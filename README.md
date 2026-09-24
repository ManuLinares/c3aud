# c3aud

## Usage

```
c3aud [options] [files / folders...]

Options:
  -h, --help        Show help manual
  -v, --verbose     Increase verbosity (-v, -vv, -vvv)
  -s, --soundfont   Path to .sf2 SoundFont file
```

## Build

```sh
# 1. Build FFmpeg dependency
./scripts/build_ffmpeg.sh <linux|windows|macos-aarch64|macos-x64>

# 2. Compile binary
c3c build <target> -O5 -g0
```

---

### Audio Architecture

```
[Audio File on Disk]
  |
  |-- .mid / .midi ---> [MidiDecoder (tsf + tml)] --------------------+
  |                                                                   | (float32 stereo @ 48kHz)
  +-- other formats --> [FfmpegDecoder (avformat/avcodec/swresample)]-|
                                                                      |
                                                                      v
                                                          [MaAudioRingBuffer]
                                                                      |
                                                                      v (Hardware Audio Thread)
                                                          [miniaudio: ma_device]
                                                            |-- Platform Output (ALSA, Pulse, Pipewire, WASAPI, CoreAudio)
                                                            +-- Oscilloscope Buffer ---> OpenGL Renderer (Main Thread)
```

### Components

- **Decoding**:
  - **MIDI (`.mid`, `.midi`)**: Parsed with `tml`, synthesized with `tsf` using an `.sf2` SoundFont.
  - **Other Formats (MP3, FLAC, AAC, OGG, Opus, WAV, M4A, WMA, etc.)**: Demuxed with `avformat`, decoded with `avcodec`, and resampled to 48kHz stereo float32 via `swresample`.
- **miniaudio**: Built with internal decoders disabled (`MA_NO_DECODING`). Retained exclusively for:
  - `ma_audio_ring_buffer`: Lock-free FIFO bridging the decoding worker to the audio callback.
  - `ma_device`: Hardware output across Linux, Windows, macOS, and WebAudio.

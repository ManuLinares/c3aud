module miniaudio::ma;

// Type Aliases & Callbacks
alias MaInt8 = ichar;
alias MaUint8 = char;
alias MaInt16 = short;
alias MaUint16 = ushort;
alias MaInt32 = int;
alias MaUint32 = uint;
alias MaInt64 = long;
alias MaUint64 = ulong;
alias MaUintptr = ulong;
alias MaBool8 = char;
alias MaBool32 = uint;
alias MaFloat = float;
alias MaDouble = double;
alias MaHandle = void*;
alias MaPtr = void*;
alias MaProc = fn void();
alias MaPthreadT = CULong;
alias MaPthreadMutexT = PthreadMutexT;
alias MaPthreadCondT = PthreadCondT;
alias MaWcharWin32 = ushort;
alias MaChannel = char;
alias MaSpinlock = uint;
alias MaThread = CULong;
alias MaMutex = MaPthreadMutexT;
alias MaLogCallbackProc = fn void(void*, MaUint32, ZString);
alias MaResamplingBackend = void;
alias MaDataSource = void;
alias MaDataSourceGetNextProc = fn MaDataSource*(MaDataSource*);
alias MaAsyncNotification = void;
alias MaJobProc = fn MaResult(MaJob*);
alias MaDeviceNotificationProc = fn void(MaDeviceNotification*);
alias MaDeviceDataProc = fn void(MaDevice*, void*, void*, MaUint32);
alias MaStopProc = fn void(MaDevice*);
alias MaEnumDevicesCallbackProc = fn MaBool32(MaContext*, MaDeviceType, MaDeviceInfo*, void*);
alias MaVfs = void;
alias MaVfsFile = void*;
alias MaReadProc = fn MaResult(void*, void*, usz, usz*);
alias MaSeekProc = fn MaResult(void*, MaInt64, MaSeekOrigin);
alias MaTellProc = fn MaResult(void*, MaInt64*);
alias MaDecoderReadProc = fn MaResult(MaDecoder*, void*, usz, usz*);
alias MaDecoderSeekProc = fn MaResult(MaDecoder*, MaInt64, MaSeekOrigin);
alias MaDecoderTellProc = fn MaResult(MaDecoder*, MaInt64*);
alias MaEncoderWriteProc = fn MaResult(MaEncoder*, void*, usz, usz*);
alias MaEncoderSeekProc = fn MaResult(MaEncoder*, MaInt64, MaSeekOrigin);
alias MaEncoderInitProc = fn MaResult(MaEncoder*);
alias MaEncoderUninitProc = fn void(MaEncoder*);
alias MaEncoderWritePcmFramesProc = fn MaResult(MaEncoder*, void*, MaUint64, MaUint64*);
alias MaNode = void;
alias MaSoundEndProc = fn void(void*, MaSound*);
alias MaSoundGroupConfig = MaSoundConfig;
alias MaSoundGroup = MaSound;
alias MaEngineProcessProc = fn void(void*, float*, MaUint64);
alias MaAtomicMemoryOrder = int;
alias MaAtomicFlag = uint;
alias MaAtomicSpinlock = uint;
alias MaThreadResult = void*;
alias MaThreadEntryProc = fn MaThreadResult(void*);
alias MaSndPcmUframesT = CULong;
alias MaSndPcmSframesT = CLong;
alias MaSndPcmStreamT = int;
alias MaSndPcmFormatT = int;
alias MaSndPcmAccessT = int;
alias MaSndPcmStateT = int;
alias MaSndPcmOpenProc = fn int(MaSndPcmT**, ZString, MaSndPcmStreamT, int);
alias MaSndPcmCloseProc = fn int(MaSndPcmT*);
alias MaSndPcmHwParamsSizeofProc = fn usz();
alias MaSndPcmHwParamsAnyProc = fn int(MaSndPcmT*, MaSndPcmHwParamsT*);
alias MaSndPcmHwParamsSetFormatProc = fn int(MaSndPcmT*, MaSndPcmHwParamsT*, MaSndPcmFormatT);
alias MaSndPcmHwParamsSetFormatFirstProc = fn int(MaSndPcmT*, MaSndPcmHwParamsT*, MaSndPcmFormatT*);
alias MaSndPcmHwParamsGetFormatMaskProc = fn void(MaSndPcmHwParamsT*, MaSndPcmFormatMaskT*);
alias MaSndPcmHwParamsSetChannelsProc = fn int(MaSndPcmT*, MaSndPcmHwParamsT*, uint);
alias MaSndPcmHwParamsSetChannelsNearProc = fn int(MaSndPcmT*, MaSndPcmHwParamsT*, uint*);
alias MaSndPcmHwParamsSetChannelsMinmaxProc = fn int(MaSndPcmT*, MaSndPcmHwParamsT*, uint*, uint*);
alias MaSndPcmHwParamsSetRateResampleProc = fn int(MaSndPcmT*, MaSndPcmHwParamsT*, uint);
alias MaSndPcmHwParamsSetRateProc = fn int(MaSndPcmT*, MaSndPcmHwParamsT*, uint, int);
alias MaSndPcmHwParamsSetRateNearProc = fn int(MaSndPcmT*, MaSndPcmHwParamsT*, uint*, int*);
alias MaSndPcmHwParamsSetRateMinmaxProc = fn int(MaSndPcmT*, MaSndPcmHwParamsT*, uint*, int*, uint*, int*);
alias MaSndPcmHwParamsSetBufferSizeNearProc = fn int(MaSndPcmT*, MaSndPcmHwParamsT*, MaSndPcmUframesT*);
alias MaSndPcmHwParamsSetPeriodsNearProc = fn int(MaSndPcmT*, MaSndPcmHwParamsT*, uint*, int*);
alias MaSndPcmHwParamsSetAccessProc = fn int(MaSndPcmT*, MaSndPcmHwParamsT*, MaSndPcmAccessT);
alias MaSndPcmHwParamsGetFormatProc = fn int(MaSndPcmHwParamsT*, MaSndPcmFormatT*);
alias MaSndPcmHwParamsGetChannelsProc = fn int(MaSndPcmHwParamsT*, uint*);
alias MaSndPcmHwParamsGetChannelsMinProc = fn int(MaSndPcmHwParamsT*, uint*);
alias MaSndPcmHwParamsGetChannelsMaxProc = fn int(MaSndPcmHwParamsT*, uint*);
alias MaSndPcmHwParamsGetRateProc = fn int(MaSndPcmHwParamsT*, uint*, int*);
alias MaSndPcmHwParamsGetRateMinProc = fn int(MaSndPcmHwParamsT*, uint*, int*);
alias MaSndPcmHwParamsGetRateMaxProc = fn int(MaSndPcmHwParamsT*, uint*, int*);
alias MaSndPcmHwParamsGetBufferSizeProc = fn int(MaSndPcmHwParamsT*, MaSndPcmUframesT*);
alias MaSndPcmHwParamsGetPeriodsProc = fn int(MaSndPcmHwParamsT*, uint*, int*);
alias MaSndPcmHwParamsGetAccessProc = fn int(MaSndPcmHwParamsT*, MaSndPcmAccessT*);
alias MaSndPcmHwParamsTestFormatProc = fn int(MaSndPcmT*, MaSndPcmHwParamsT*, MaSndPcmFormatT);
alias MaSndPcmHwParamsTestChannelsProc = fn int(MaSndPcmT*, MaSndPcmHwParamsT*, uint);
alias MaSndPcmHwParamsTestRateProc = fn int(MaSndPcmT*, MaSndPcmHwParamsT*, uint, int);
alias MaSndPcmHwParamsProc = fn int(MaSndPcmT*, MaSndPcmHwParamsT*);
alias MaSndPcmSwParamsSizeofProc = fn usz();
alias MaSndPcmSwParamsCurrentProc = fn int(MaSndPcmT*, MaSndPcmSwParamsT*);
alias MaSndPcmSwParamsGetBoundaryProc = fn int(MaSndPcmSwParamsT*, MaSndPcmUframesT*);
alias MaSndPcmSwParamsSetAvailMinProc = fn int(MaSndPcmT*, MaSndPcmSwParamsT*, MaSndPcmUframesT);
alias MaSndPcmSwParamsSetStartThresholdProc = fn int(MaSndPcmT*, MaSndPcmSwParamsT*, MaSndPcmUframesT);
alias MaSndPcmSwParamsSetStopThresholdProc = fn int(MaSndPcmT*, MaSndPcmSwParamsT*, MaSndPcmUframesT);
alias MaSndPcmSwParamsProc = fn int(MaSndPcmT*, MaSndPcmSwParamsT*);
alias MaSndPcmFormatMaskSizeofProc = fn usz();
alias MaSndPcmFormatMaskTestProc = fn int(MaSndPcmFormatMaskT*, MaSndPcmFormatT);
alias MaSndPcmGetChmapProc = fn MaSndPcmChmapT*(MaSndPcmT*);
alias MaSndPcmStateProc = fn MaSndPcmStateT(MaSndPcmT*);
alias MaSndPcmPrepareProc = fn int(MaSndPcmT*);
alias MaSndPcmStartProc = fn int(MaSndPcmT*);
alias MaSndPcmDropProc = fn int(MaSndPcmT*);
alias MaSndPcmDrainProc = fn int(MaSndPcmT*);
alias MaSndPcmResetProc = fn int(MaSndPcmT*);
alias MaSndDeviceNameHintProc = fn int(int, ZString, void***);
alias MaSndDeviceNameGetHintProc = fn char*(void*, ZString);
alias MaSndCardGetIndexProc = fn int(ZString);
alias MaSndDeviceNameFreeHintProc = fn int(void**);
alias MaSndPcmMmapBeginProc = fn int(MaSndPcmT*, MaSndPcmChannelAreaT**, MaSndPcmUframesT*, MaSndPcmUframesT*);
alias MaSndPcmMmapCommitProc = fn MaSndPcmSframesT(MaSndPcmT*, MaSndPcmUframesT, MaSndPcmUframesT);
alias MaSndPcmRecoverProc = fn int(MaSndPcmT*, int, int);
alias MaSndPcmReadiProc = fn MaSndPcmSframesT(MaSndPcmT*, void*, MaSndPcmUframesT);
alias MaSndPcmWriteiProc = fn MaSndPcmSframesT(MaSndPcmT*, void*, MaSndPcmUframesT);
alias MaSndPcmAvailProc = fn MaSndPcmSframesT(MaSndPcmT*);
alias MaSndPcmAvailUpdateProc = fn MaSndPcmSframesT(MaSndPcmT*);
alias MaSndPcmWaitProc = fn int(MaSndPcmT*, int);
alias MaSndPcmNonblockProc = fn int(MaSndPcmT*, int);
alias MaSndPcmInfoProc = fn int(MaSndPcmT*, MaSndPcmInfoT*);
alias MaSndPcmInfoSizeofProc = fn usz();
alias MaSndPcmInfoGetNameProc = fn ZString(MaSndPcmInfoT*);
alias MaSndPcmPollDescriptorsProc = fn int(MaSndPcmT*, Pollfd*, uint);
alias MaSndPcmPollDescriptorsCountProc = fn int(MaSndPcmT*);
alias MaSndPcmPollDescriptorsReventsProc = fn int(MaSndPcmT*, Pollfd*, uint, ushort*);
alias MaSndConfigUpdateFreeGlobalProc = fn int();
alias MaPaContextFlagsT = int;
alias MaPaStreamFlagsT = int;
alias MaPaSinkFlagsT = int;
alias MaPaSourceFlagsT = int;
alias MaPaContextStateT = int;
alias MaPaStreamStateT = int;
alias MaPaOperationStateT = int;
alias MaPaSinkStateT = int;
alias MaPaSourceStateT = int;
alias MaPaSeekModeT = int;
alias MaPaChannelPositionT = int;
alias MaPaChannelMapDefT = int;
alias MaPaSampleFormatT = int;
alias MaPaContextNotifyCbT = fn void(MaPaContext*, void*);
alias MaPaSinkInfoCbT = fn void(MaPaContext*, MaPaSinkInfo*, int, void*);
alias MaPaSourceInfoCbT = fn void(MaPaContext*, MaPaSourceInfo*, int, void*);
alias MaPaStreamSuccessCbT = fn void(MaPaStream*, int, void*);
alias MaPaStreamRequestCbT = fn void(MaPaStream*, usz, void*);
alias MaPaStreamNotifyCbT = fn void(MaPaStream*, void*);
alias MaPaFreeCbT = fn void(void*);
alias MaPaMainloopNewProc = fn MaPaMainloop*();
alias MaPaMainloopFreeProc = fn void(MaPaMainloop*);
alias MaPaMainloopQuitProc = fn void(MaPaMainloop*, int);
alias MaPaMainloopGetApiProc = fn MaPaMainloopApi*(MaPaMainloop*);
alias MaPaMainloopIterateProc = fn int(MaPaMainloop*, int, int*);
alias MaPaMainloopWakeupProc = fn void(MaPaMainloop*);
alias MaPaThreadedMainloopNewProc = fn MaPaThreadedMainloop*();
alias MaPaThreadedMainloopFreeProc = fn void(MaPaThreadedMainloop*);
alias MaPaThreadedMainloopStartProc = fn int(MaPaThreadedMainloop*);
alias MaPaThreadedMainloopStopProc = fn void(MaPaThreadedMainloop*);
alias MaPaThreadedMainloopLockProc = fn void(MaPaThreadedMainloop*);
alias MaPaThreadedMainloopUnlockProc = fn void(MaPaThreadedMainloop*);
alias MaPaThreadedMainloopWaitProc = fn void(MaPaThreadedMainloop*);
alias MaPaThreadedMainloopSignalProc = fn void(MaPaThreadedMainloop*, int);
alias MaPaThreadedMainloopAcceptProc = fn void(MaPaThreadedMainloop*);
alias MaPaThreadedMainloopGetRetvalProc = fn int(MaPaThreadedMainloop*);
alias MaPaThreadedMainloopGetApiProc = fn MaPaMainloopApi*(MaPaThreadedMainloop*);
alias MaPaThreadedMainloopInThreadProc = fn int(MaPaThreadedMainloop*);
alias MaPaThreadedMainloopSetNameProc = fn void(MaPaThreadedMainloop*, ZString);
alias MaPaContextNewProc = fn MaPaContext*(MaPaMainloopApi*, ZString);
alias MaPaContextUnrefProc = fn void(MaPaContext*);
alias MaPaContextConnectProc = fn int(MaPaContext*, ZString, MaPaContextFlagsT, MaPaSpawnApi*);
alias MaPaContextDisconnectProc = fn void(MaPaContext*);
alias MaPaContextSetStateCallbackProc = fn void(MaPaContext*, MaPaContextNotifyCbT, void*);
alias MaPaContextGetStateProc = fn MaPaContextStateT(MaPaContext*);
alias MaPaContextGetSinkInfoListProc = fn MaPaOperation*(MaPaContext*, MaPaSinkInfoCbT, void*);
alias MaPaContextGetSourceInfoListProc = fn MaPaOperation*(MaPaContext*, MaPaSourceInfoCbT, void*);
alias MaPaContextGetSinkInfoByNameProc = fn MaPaOperation*(MaPaContext*, ZString, MaPaSinkInfoCbT, void*);
alias MaPaContextGetSourceInfoByNameProc = fn MaPaOperation*(MaPaContext*, ZString, MaPaSourceInfoCbT, void*);
alias MaPaOperationUnrefProc = fn void(MaPaOperation*);
alias MaPaOperationGetStateProc = fn MaPaOperationStateT(MaPaOperation*);
alias MaPaChannelMapInitExtendProc = fn MaPaChannelMap*(MaPaChannelMap*, uint, MaPaChannelMapDefT);
alias MaPaChannelMapValidProc = fn int(MaPaChannelMap*);
alias MaPaChannelMapCompatibleProc = fn int(MaPaChannelMap*, MaPaSampleSpec*);
alias MaPaStreamNewProc = fn MaPaStream*(MaPaContext*, ZString, MaPaSampleSpec*, MaPaChannelMap*);
alias MaPaStreamUnrefProc = fn void(MaPaStream*);
alias MaPaStreamConnectPlaybackProc = fn int(MaPaStream*, ZString, MaPaBufferAttr*, MaPaStreamFlagsT, MaPaCvolume*, MaPaStream*);
alias MaPaStreamConnectRecordProc = fn int(MaPaStream*, ZString, MaPaBufferAttr*, MaPaStreamFlagsT);
alias MaPaStreamDisconnectProc = fn int(MaPaStream*);
alias MaPaStreamGetStateProc = fn MaPaStreamStateT(MaPaStream*);
alias MaPaStreamGetSampleSpecProc = fn MaPaSampleSpec*(MaPaStream*);
alias MaPaStreamGetChannelMapProc = fn MaPaChannelMap*(MaPaStream*);
alias MaPaStreamGetBufferAttrProc = fn MaPaBufferAttr*(MaPaStream*);
alias MaPaStreamSetBufferAttrProc = fn MaPaOperation*(MaPaStream*, MaPaBufferAttr*, MaPaStreamSuccessCbT, void*);
alias MaPaStreamGetDeviceNameProc = fn ZString(MaPaStream*);
alias MaPaStreamSetWriteCallbackProc = fn void(MaPaStream*, MaPaStreamRequestCbT, void*);
alias MaPaStreamSetReadCallbackProc = fn void(MaPaStream*, MaPaStreamRequestCbT, void*);
alias MaPaStreamSetSuspendedCallbackProc = fn void(MaPaStream*, MaPaStreamNotifyCbT, void*);
alias MaPaStreamSetMovedCallbackProc = fn void(MaPaStream*, MaPaStreamNotifyCbT, void*);
alias MaPaStreamIsSuspendedProc = fn int(MaPaStream*);
alias MaPaStreamFlushProc = fn MaPaOperation*(MaPaStream*, MaPaStreamSuccessCbT, void*);
alias MaPaStreamDrainProc = fn MaPaOperation*(MaPaStream*, MaPaStreamSuccessCbT, void*);
alias MaPaStreamIsCorkedProc = fn int(MaPaStream*);
alias MaPaStreamCorkProc = fn MaPaOperation*(MaPaStream*, int, MaPaStreamSuccessCbT, void*);
alias MaPaStreamTriggerProc = fn MaPaOperation*(MaPaStream*, MaPaStreamSuccessCbT, void*);
alias MaPaStreamBeginWriteProc = fn int(MaPaStream*, void**, usz*);
alias MaPaStreamWriteProc = fn int(MaPaStream*, void*, usz, MaPaFreeCbT, long, MaPaSeekModeT);
alias MaPaStreamPeekProc = fn int(MaPaStream*, void**, usz*);
alias MaPaStreamDropProc = fn int(MaPaStream*);
alias MaPaStreamWritableSizeProc = fn usz(MaPaStream*);
alias MaPaStreamReadableSizeProc = fn usz(MaPaStream*);
alias MaJackNframesT = uint;
alias MaJackOptionsT = int;
alias MaJackStatusT = int;
alias MaJackprocesscallback = fn int(MaJackNframesT, void*);
alias MaJackbuffersizecallback = fn int(MaJackNframesT, void*);
alias MaJackshutdowncallback = fn void(void*);
alias MaJackClientOpenProc = fn MaJackClientT*(ZString, MaJackOptionsT, MaJackStatusT*, ...);
alias MaJackClientCloseProc = fn int(MaJackClientT*);
alias MaJackClientNameSizeProc = fn int();
alias MaJackSetProcessCallbackProc = fn int(MaJackClientT*, MaJackprocesscallback, void*);
alias MaJackSetBufferSizeCallbackProc = fn int(MaJackClientT*, MaJackbuffersizecallback, void*);
alias MaJackOnShutdownProc = fn void(MaJackClientT*, MaJackshutdowncallback, void*);
alias MaJackGetSampleRateProc = fn MaJackNframesT(MaJackClientT*);
alias MaJackGetBufferSizeProc = fn MaJackNframesT(MaJackClientT*);
alias MaJackGetPortsProc = fn char**(MaJackClientT*, ZString, ZString, CULong);
alias MaJackActivateProc = fn int(MaJackClientT*);
alias MaJackDeactivateProc = fn int(MaJackClientT*);
alias MaJackConnectProc = fn int(MaJackClientT*, ZString, ZString);
alias MaJackPortRegisterProc = fn MaJackPortT*(MaJackClientT*, ZString, ZString, CULong, CULong);
alias MaJackPortNameProc = fn ZString(MaJackPortT*);
alias MaJackPortGetBufferProc = fn void*(MaJackPortT*, MaJackNframesT);
alias MaJackFreeProc = fn void(void*);
alias MaDrWavReadProc = fn usz(void*, void*, usz);
alias MaDrWavWriteProc = fn usz(void*, void*, usz);
alias MaDrWavSeekProc = fn MaBool32(void*, int, MaDrWavSeekOrigin);
alias MaDrWavTellProc = fn MaBool32(void*, MaInt64*);
alias MaDrWavChunkProc = fn MaUint64(void*, MaDrWavReadProc, MaDrWavSeekProc, void*, MaDrWavChunkHeader*, MaDrWavContainer, MaDrWavFmt*);
alias MaDrFlacCacheT = ulong;
alias MaDrFlacReadProc = fn usz(void*, void*, usz);
alias MaDrFlacSeekProc = fn MaBool32(void*, int, MaDrFlacSeekOrigin);
alias MaDrFlacTellProc = fn MaBool32(void*, MaInt64*);
alias MaDrFlacMetaProc = fn void(void*, MaDrFlacMetadata*);
alias MaDrMp3ReadProc = fn usz(void*, void*, usz);
alias MaDrMp3SeekProc = fn MaBool32(void*, int, MaDrMp3SeekOrigin);
alias MaDrMp3TellProc = fn MaBool32(void*, MaInt64*);
alias MaDrMp3MetaProc = fn void(void*, MaDrMp3Metadata*);
alias MaDrMp3F4 = float[<4>];
alias MaDrMp3dSampleT = short;
alias WcharT = WString;
alias M128_t = float;
alias PthreadT = CULong;
alias File = IoFile;
alias M128i = long;

constdef MaLogLevel : int
{
	MA_LOG_LEVEL_DEBUG = 4,
	MA_LOG_LEVEL_INFO = 3,
	MA_LOG_LEVEL_WARNING = 2,
	MA_LOG_LEVEL_ERROR = 1
}

constdef MaChannelPosition : int
{
	MA_CHANNEL_NONE = 0,
	MA_CHANNEL_MONO = 1,
	MA_CHANNEL_FRONT_LEFT = 2,
	MA_CHANNEL_FRONT_RIGHT = 3,
	MA_CHANNEL_FRONT_CENTER = 4,
	MA_CHANNEL_LFE = 5,
	MA_CHANNEL_BACK_LEFT = 6,
	MA_CHANNEL_BACK_RIGHT = 7,
	MA_CHANNEL_FRONT_LEFT_CENTER = 8,
	MA_CHANNEL_FRONT_RIGHT_CENTER = 9,
	MA_CHANNEL_BACK_CENTER = 10,
	MA_CHANNEL_SIDE_LEFT = 11,
	MA_CHANNEL_SIDE_RIGHT = 12,
	MA_CHANNEL_TOP_CENTER = 13,
	MA_CHANNEL_TOP_FRONT_LEFT = 14,
	MA_CHANNEL_TOP_FRONT_CENTER = 15,
	MA_CHANNEL_TOP_FRONT_RIGHT = 16,
	MA_CHANNEL_TOP_BACK_LEFT = 17,
	MA_CHANNEL_TOP_BACK_CENTER = 18,
	MA_CHANNEL_TOP_BACK_RIGHT = 19,
	MA_CHANNEL_AUX_0 = 20,
	MA_CHANNEL_AUX_1 = 21,
	MA_CHANNEL_AUX_2 = 22,
	MA_CHANNEL_AUX_3 = 23,
	MA_CHANNEL_AUX_4 = 24,
	MA_CHANNEL_AUX_5 = 25,
	MA_CHANNEL_AUX_6 = 26,
	MA_CHANNEL_AUX_7 = 27,
	MA_CHANNEL_AUX_8 = 28,
	MA_CHANNEL_AUX_9 = 29,
	MA_CHANNEL_AUX_10 = 30,
	MA_CHANNEL_AUX_11 = 31,
	MA_CHANNEL_AUX_12 = 32,
	MA_CHANNEL_AUX_13 = 33,
	MA_CHANNEL_AUX_14 = 34,
	MA_CHANNEL_AUX_15 = 35,
	MA_CHANNEL_AUX_16 = 36,
	MA_CHANNEL_AUX_17 = 37,
	MA_CHANNEL_AUX_18 = 38,
	MA_CHANNEL_AUX_19 = 39,
	MA_CHANNEL_AUX_20 = 40,
	MA_CHANNEL_AUX_21 = 41,
	MA_CHANNEL_AUX_22 = 42,
	MA_CHANNEL_AUX_23 = 43,
	MA_CHANNEL_AUX_24 = 44,
	MA_CHANNEL_AUX_25 = 45,
	MA_CHANNEL_AUX_26 = 46,
	MA_CHANNEL_AUX_27 = 47,
	MA_CHANNEL_AUX_28 = 48,
	MA_CHANNEL_AUX_29 = 49,
	MA_CHANNEL_AUX_30 = 50,
	MA_CHANNEL_AUX_31 = 51,
	MA_CHANNEL_POSITION_COUNT = 52,
	MA_CHANNEL_LEFT = 2,
	MA_CHANNEL_RIGHT = 3
}

constdef MaResult : int
{
	MA_SUCCESS = 0,
	MA_ERROR = -1,
	MA_INVALID_ARGS = -2,
	MA_INVALID_OPERATION = -3,
	MA_OUT_OF_MEMORY = -4,
	MA_OUT_OF_RANGE = -5,
	MA_ACCESS_DENIED = -6,
	MA_DOES_NOT_EXIST = -7,
	MA_ALREADY_EXISTS = -8,
	MA_TOO_MANY_OPEN_FILES = -9,
	MA_INVALID_FILE = -10,
	MA_TOO_BIG = -11,
	MA_PATH_TOO_LONG = -12,
	MA_NAME_TOO_LONG = -13,
	MA_NOT_DIRECTORY = -14,
	MA_IS_DIRECTORY = -15,
	MA_DIRECTORY_NOT_EMPTY = -16,
	MA_AT_END = -17,
	MA_NO_SPACE = -18,
	MA_BUSY = -19,
	MA_IO_ERROR = -20,
	MA_INTERRUPT = -21,
	MA_UNAVAILABLE = -22,
	MA_ALREADY_IN_USE = -23,
	MA_BAD_ADDRESS = -24,
	MA_BAD_SEEK = -25,
	MA_BAD_PIPE = -26,
	MA_DEADLOCK = -27,
	MA_TOO_MANY_LINKS = -28,
	MA_NOT_IMPLEMENTED = -29,
	MA_NO_MESSAGE = -30,
	MA_BAD_MESSAGE = -31,
	MA_NO_DATA_AVAILABLE = -32,
	MA_INVALID_DATA = -33,
	MA_TIMEOUT = -34,
	MA_NO_NETWORK = -35,
	MA_NOT_UNIQUE = -36,
	MA_NOT_SOCKET = -37,
	MA_NO_ADDRESS = -38,
	MA_BAD_PROTOCOL = -39,
	MA_PROTOCOL_UNAVAILABLE = -40,
	MA_PROTOCOL_NOT_SUPPORTED = -41,
	MA_PROTOCOL_FAMILY_NOT_SUPPORTED = -42,
	MA_ADDRESS_FAMILY_NOT_SUPPORTED = -43,
	MA_SOCKET_NOT_SUPPORTED = -44,
	MA_CONNECTION_RESET = -45,
	MA_ALREADY_CONNECTED = -46,
	MA_NOT_CONNECTED = -47,
	MA_CONNECTION_REFUSED = -48,
	MA_NO_HOST = -49,
	MA_IN_PROGRESS = -50,
	MA_CANCELLED = -51,
	MA_MEMORY_ALREADY_MAPPED = -52,
	MA_CRC_MISMATCH = -100,
	MA_FORMAT_NOT_SUPPORTED = -200,
	MA_DEVICE_TYPE_NOT_SUPPORTED = -201,
	MA_SHARE_MODE_NOT_SUPPORTED = -202,
	MA_NO_BACKEND = -203,
	MA_NO_DEVICE = -204,
	MA_API_NOT_FOUND = -205,
	MA_INVALID_DEVICE_CONFIG = -206,
	MA_LOOP = -207,
	MA_BACKEND_NOT_ENABLED = -208,
	MA_DEVICE_NOT_INITIALIZED = -300,
	MA_DEVICE_ALREADY_INITIALIZED = -301,
	MA_DEVICE_NOT_STARTED = -302,
	MA_DEVICE_NOT_STOPPED = -303,
	MA_FAILED_TO_INIT_BACKEND = -400,
	MA_FAILED_TO_OPEN_BACKEND_DEVICE = -401,
	MA_FAILED_TO_START_BACKEND_DEVICE = -402,
	MA_FAILED_TO_STOP_BACKEND_DEVICE = -403
}

enum MaStreamFormat
{
	MA_STREAM_FORMAT_PCM
}

enum MaStreamLayout
{
	MA_STREAM_LAYOUT_INTERLEAVED,
	MA_STREAM_LAYOUT_DEINTERLEAVED
}

enum MaDitherMode
{
	MA_DITHER_MODE_NONE,
	MA_DITHER_MODE_RECTANGLE,
	MA_DITHER_MODE_TRIANGLE
}

enum MaFormat
{
	MA_FORMAT_UNKNOWN,
	MA_FORMAT_U8,
	MA_FORMAT_S16,
	MA_FORMAT_S24,
	MA_FORMAT_S32,
	MA_FORMAT_F32,
	MA_FORMAT_COUNT
}

constdef MaStandardSampleRate : int
{
	MA_STANDARD_SAMPLE_RATE_48000 = 48000,
	MA_STANDARD_SAMPLE_RATE_44100 = 44100,
	MA_STANDARD_SAMPLE_RATE_32000 = 32000,
	MA_STANDARD_SAMPLE_RATE_24000 = 24000,
	MA_STANDARD_SAMPLE_RATE_22050 = 22050,
	MA_STANDARD_SAMPLE_RATE_88200 = 88200,
	MA_STANDARD_SAMPLE_RATE_96000 = 96000,
	MA_STANDARD_SAMPLE_RATE_176400 = 176400,
	MA_STANDARD_SAMPLE_RATE_192000 = 192000,
	MA_STANDARD_SAMPLE_RATE_16000 = 16000,
	MA_STANDARD_SAMPLE_RATE_11025 = 11025,
	MA_STANDARD_SAMPLE_RATE_8000 = 8000,
	MA_STANDARD_SAMPLE_RATE_352800 = 352800,
	MA_STANDARD_SAMPLE_RATE_384000 = 384000,
	MA_STANDARD_SAMPLE_RATE_MIN = 8000,
	MA_STANDARD_SAMPLE_RATE_MAX = 384000,
	MA_STANDARD_SAMPLE_RATE_COUNT = 14
}

constdef MaChannelMixMode : int
{
	MA_CHANNEL_MIX_MODE_RECTANGULAR = 0,
	MA_CHANNEL_MIX_MODE_SIMPLE = 1,
	MA_CHANNEL_MIX_MODE_CUSTOM_WEIGHTS = 2,
	MA_CHANNEL_MIX_MODE_DEFAULT = 0
}

constdef MaStandardChannelMap : int
{
	MA_STANDARD_CHANNEL_MAP_MICROSOFT = 0,
	MA_STANDARD_CHANNEL_MAP_ALSA = 1,
	MA_STANDARD_CHANNEL_MAP_RFC3551 = 2,
	MA_STANDARD_CHANNEL_MAP_FLAC = 3,
	MA_STANDARD_CHANNEL_MAP_VORBIS = 4,
	MA_STANDARD_CHANNEL_MAP_SOUND4 = 5,
	MA_STANDARD_CHANNEL_MAP_SNDIO = 6,
	MA_STANDARD_CHANNEL_MAP_WEBAUDIO = 3,
	MA_STANDARD_CHANNEL_MAP_DEFAULT = 0
}

enum MaPerformanceProfile
{
	MA_PERFORMANCE_PROFILE_LOW_LATENCY,
	MA_PERFORMANCE_PROFILE_CONSERVATIVE
}

constdef MaThreadPriority : int
{
	MA_THREAD_PRIORITY_IDLE = -5,
	MA_THREAD_PRIORITY_LOWEST = -4,
	MA_THREAD_PRIORITY_LOW = -3,
	MA_THREAD_PRIORITY_NORMAL = -2,
	MA_THREAD_PRIORITY_HIGH = -1,
	MA_THREAD_PRIORITY_HIGHEST = 0,
	MA_THREAD_PRIORITY_REALTIME = 1,
	MA_THREAD_PRIORITY_DEFAULT = 0
}

enum MaPanMode
{
	MA_PAN_MODE_BALANCE,
	MA_PAN_MODE_PAN
}

enum MaAttenuationModel
{
	MA_ATTENUATION_MODEL_NONE,
	MA_ATTENUATION_MODEL_INVERSE,
	MA_ATTENUATION_MODEL_LINEAR,
	MA_ATTENUATION_MODEL_EXPONENTIAL
}

enum MaPositioning
{
	MA_POSITIONING_ABSOLUTE,
	MA_POSITIONING_RELATIVE
}

enum MaHandedness
{
	MA_HANDEDNESS_RIGHT,
	MA_HANDEDNESS_LEFT
}

enum MaResampleAlgorithm
{
	MA_RESAMPLE_ALGORITHM_LINEAR,
	MA_RESAMPLE_ALGORITHM_CUSTOM
}

enum MaChannelConversionPath
{
	MA_CHANNEL_CONVERSION_PATH_UNKNOWN,
	MA_CHANNEL_CONVERSION_PATH_PASSTHROUGH,
	MA_CHANNEL_CONVERSION_PATH_MONO_OUT,
	MA_CHANNEL_CONVERSION_PATH_MONO_IN,
	MA_CHANNEL_CONVERSION_PATH_SHUFFLE,
	MA_CHANNEL_CONVERSION_PATH_WEIGHTS
}

constdef MaMonoExpansionMode : int
{
	MA_MONO_EXPANSION_MODE_DUPLICATE = 0,
	MA_MONO_EXPANSION_MODE_AVERAGE = 1,
	MA_MONO_EXPANSION_MODE_STEREO_ONLY = 2,
	MA_MONO_EXPANSION_MODE_DEFAULT = 0
}

enum MaDataConverterExecutionPath
{
	MA_DATA_CONVERTER_EXECUTION_PATH_PASSTHROUGH,
	MA_DATA_CONVERTER_EXECUTION_PATH_FORMAT_ONLY,
	MA_DATA_CONVERTER_EXECUTION_PATH_CHANNELS_ONLY,
	MA_DATA_CONVERTER_EXECUTION_PATH_RESAMPLE_ONLY,
	MA_DATA_CONVERTER_EXECUTION_PATH_RESAMPLE_FIRST,
	MA_DATA_CONVERTER_EXECUTION_PATH_CHANNELS_FIRST
}

enum MaJobType
{
	MA_JOB_TYPE_QUIT,
	MA_JOB_TYPE_CUSTOM,
	MA_JOB_TYPE_RESOURCE_MANAGER_LOAD_DATA_BUFFER_NODE,
	MA_JOB_TYPE_RESOURCE_MANAGER_FREE_DATA_BUFFER_NODE,
	MA_JOB_TYPE_RESOURCE_MANAGER_PAGE_DATA_BUFFER_NODE,
	MA_JOB_TYPE_RESOURCE_MANAGER_LOAD_DATA_BUFFER,
	MA_JOB_TYPE_RESOURCE_MANAGER_FREE_DATA_BUFFER,
	MA_JOB_TYPE_RESOURCE_MANAGER_LOAD_DATA_STREAM,
	MA_JOB_TYPE_RESOURCE_MANAGER_FREE_DATA_STREAM,
	MA_JOB_TYPE_RESOURCE_MANAGER_PAGE_DATA_STREAM,
	MA_JOB_TYPE_RESOURCE_MANAGER_SEEK_DATA_STREAM,
	MA_JOB_TYPE_DEVICE_AAUDIO_REROUTE,
	MA_JOB_TYPE_COUNT
}

constdef MaJobQueueFlags : int
{
	MA_JOB_QUEUE_FLAG_NON_BLOCKING = 1
}

enum MaDeviceState
{
	MA_DEVICE_STATE_UNINITIALIZED,
	MA_DEVICE_STATE_STOPPED,
	MA_DEVICE_STATE_STARTED,
	MA_DEVICE_STATE_STARTING,
	MA_DEVICE_STATE_STOPPING
}

enum MaBackend
{
	MA_BACKEND_WASAPI,
	MA_BACKEND_DSOUND,
	MA_BACKEND_WINMM,
	MA_BACKEND_COREAUDIO,
	MA_BACKEND_SNDIO,
	MA_BACKEND_AUDIO4,
	MA_BACKEND_OSS,
	MA_BACKEND_PULSEAUDIO,
	MA_BACKEND_ALSA,
	MA_BACKEND_JACK,
	MA_BACKEND_AAUDIO,
	MA_BACKEND_OPENSL,
	MA_BACKEND_WEBAUDIO,
	MA_BACKEND_CUSTOM,
	MA_BACKEND_NULL
}

enum MaDeviceNotificationType
{
	MA_DEVICE_NOTIFICATION_TYPE_STARTED,
	MA_DEVICE_NOTIFICATION_TYPE_STOPPED,
	MA_DEVICE_NOTIFICATION_TYPE_REROUTED,
	MA_DEVICE_NOTIFICATION_TYPE_INTERRUPTION_BEGAN,
	MA_DEVICE_NOTIFICATION_TYPE_INTERRUPTION_ENDED,
	MA_DEVICE_NOTIFICATION_TYPE_UNLOCKED
}

constdef MaDeviceType : int
{
	MA_DEVICE_TYPE_PLAYBACK = 1,
	MA_DEVICE_TYPE_CAPTURE = 2,
	MA_DEVICE_TYPE_DUPLEX = 3,
	MA_DEVICE_TYPE_LOOPBACK = 4
}

enum MaShareMode
{
	MA_SHARE_MODE_SHARED,
	MA_SHARE_MODE_EXCLUSIVE
}

enum MaIosSessionCategory
{
	MA_IOS_SESSION_CATEGORY_DEFAULT,
	MA_IOS_SESSION_CATEGORY_NONE,
	MA_IOS_SESSION_CATEGORY_AMBIENT,
	MA_IOS_SESSION_CATEGORY_SOLO_AMBIENT,
	MA_IOS_SESSION_CATEGORY_PLAYBACK,
	MA_IOS_SESSION_CATEGORY_RECORD,
	MA_IOS_SESSION_CATEGORY_PLAY_AND_RECORD,
	MA_IOS_SESSION_CATEGORY_MULTI_ROUTE
}

constdef MaIosSessionCategoryOption : int
{
	MA_IOS_SESSION_CATEGORY_OPTION_MIX_WITH_OTHERS = 1,
	MA_IOS_SESSION_CATEGORY_OPTION_DUCK_OTHERS = 2,
	MA_IOS_SESSION_CATEGORY_OPTION_ALLOW_BLUETOOTH = 4,
	MA_IOS_SESSION_CATEGORY_OPTION_DEFAULT_TO_SPEAKER = 8,
	MA_IOS_SESSION_CATEGORY_OPTION_INTERRUPT_SPOKEN_AUDIO_AND_MIX_WITH_OTHERS = 17,
	MA_IOS_SESSION_CATEGORY_OPTION_ALLOW_BLUETOOTH_A2DP = 32,
	MA_IOS_SESSION_CATEGORY_OPTION_ALLOW_AIR_PLAY = 64
}

enum MaOpenslStreamType
{
	MA_OPENSL_STREAM_TYPE_DEFAULT,
	MA_OPENSL_STREAM_TYPE_VOICE,
	MA_OPENSL_STREAM_TYPE_SYSTEM,
	MA_OPENSL_STREAM_TYPE_RING,
	MA_OPENSL_STREAM_TYPE_MEDIA,
	MA_OPENSL_STREAM_TYPE_ALARM,
	MA_OPENSL_STREAM_TYPE_NOTIFICATION
}

enum MaOpenslRecordingPreset
{
	MA_OPENSL_RECORDING_PRESET_DEFAULT,
	MA_OPENSL_RECORDING_PRESET_GENERIC,
	MA_OPENSL_RECORDING_PRESET_CAMCORDER,
	MA_OPENSL_RECORDING_PRESET_VOICE_RECOGNITION,
	MA_OPENSL_RECORDING_PRESET_VOICE_COMMUNICATION,
	MA_OPENSL_RECORDING_PRESET_VOICE_UNPROCESSED
}

enum MaWasapiUsage
{
	MA_WASAPI_USAGE_DEFAULT,
	MA_WASAPI_USAGE_GAMES,
	MA_WASAPI_USAGE_PRO_AUDIO
}

enum MaAaudioUsage
{
	MA_AAUDIO_USAGE_DEFAULT,
	MA_AAUDIO_USAGE_MEDIA,
	MA_AAUDIO_USAGE_VOICE_COMMUNICATION,
	MA_AAUDIO_USAGE_VOICE_COMMUNICATION_SIGNALLING,
	MA_AAUDIO_USAGE_ALARM,
	MA_AAUDIO_USAGE_NOTIFICATION,
	MA_AAUDIO_USAGE_NOTIFICATION_RINGTONE,
	MA_AAUDIO_USAGE_NOTIFICATION_EVENT,
	MA_AAUDIO_USAGE_ASSISTANCE_ACCESSIBILITY,
	MA_AAUDIO_USAGE_ASSISTANCE_NAVIGATION_GUIDANCE,
	MA_AAUDIO_USAGE_ASSISTANCE_SONIFICATION,
	MA_AAUDIO_USAGE_GAME,
	MA_AAUDIO_USAGE_ASSITANT,
	MA_AAUDIO_USAGE_EMERGENCY,
	MA_AAUDIO_USAGE_SAFETY,
	MA_AAUDIO_USAGE_VEHICLE_STATUS,
	MA_AAUDIO_USAGE_ANNOUNCEMENT
}

enum MaAaudioContentType
{
	MA_AAUDIO_CONTENT_TYPE_DEFAULT,
	MA_AAUDIO_CONTENT_TYPE_SPEECH,
	MA_AAUDIO_CONTENT_TYPE_MUSIC,
	MA_AAUDIO_CONTENT_TYPE_MOVIE,
	MA_AAUDIO_CONTENT_TYPE_SONIFICATION
}

enum MaAaudioInputPreset
{
	MA_AAUDIO_INPUT_PRESET_DEFAULT,
	MA_AAUDIO_INPUT_PRESET_GENERIC,
	MA_AAUDIO_INPUT_PRESET_CAMCORDER,
	MA_AAUDIO_INPUT_PRESET_VOICE_RECOGNITION,
	MA_AAUDIO_INPUT_PRESET_VOICE_COMMUNICATION,
	MA_AAUDIO_INPUT_PRESET_UNPROCESSED,
	MA_AAUDIO_INPUT_PRESET_VOICE_PERFORMANCE
}

enum MaAaudioAllowedCapturePolicy
{
	MA_AAUDIO_ALLOW_CAPTURE_DEFAULT,
	MA_AAUDIO_ALLOW_CAPTURE_BY_ALL,
	MA_AAUDIO_ALLOW_CAPTURE_BY_SYSTEM,
	MA_AAUDIO_ALLOW_CAPTURE_BY_NONE
}

constdef MaOpenModeFlags : int
{
	MA_OPEN_MODE_READ = 1,
	MA_OPEN_MODE_WRITE = 2
}

enum MaSeekOrigin
{
	MA_SEEK_ORIGIN_START,
	MA_SEEK_ORIGIN_CURRENT,
	MA_SEEK_ORIGIN_END
}

enum MaEncodingFormat
{
	MA_ENCODING_FORMAT_UNKNOWN,
	MA_ENCODING_FORMAT_WAV,
	MA_ENCODING_FORMAT_FLAC,
	MA_ENCODING_FORMAT_MP3,
	MA_ENCODING_FORMAT_VORBIS
}

enum MaWaveformType
{
	MA_WAVEFORM_TYPE_SINE,
	MA_WAVEFORM_TYPE_SQUARE,
	MA_WAVEFORM_TYPE_TRIANGLE,
	MA_WAVEFORM_TYPE_SAWTOOTH
}

enum MaNoiseType
{
	MA_NOISE_TYPE_WHITE,
	MA_NOISE_TYPE_PINK,
	MA_NOISE_TYPE_BROWNIAN
}

constdef MaResourceManagerDataSourceFlags : int
{
	MA_RESOURCE_MANAGER_DATA_SOURCE_FLAG_STREAM = 1,
	MA_RESOURCE_MANAGER_DATA_SOURCE_FLAG_DECODE = 2,
	MA_RESOURCE_MANAGER_DATA_SOURCE_FLAG_ASYNC = 4,
	MA_RESOURCE_MANAGER_DATA_SOURCE_FLAG_WAIT_INIT = 8,
	MA_RESOURCE_MANAGER_DATA_SOURCE_FLAG_UNKNOWN_LENGTH = 16,
	MA_RESOURCE_MANAGER_DATA_SOURCE_FLAG_LOOPING = 32
}

constdef MaResourceManagerFlags : int
{
	MA_RESOURCE_MANAGER_FLAG_NON_BLOCKING = 1,
	MA_RESOURCE_MANAGER_FLAG_NO_THREADING = 2
}

enum MaResourceManagerDataSupplyType
{
	MA_RESOURCE_MANAGER_DATA_SUPPLY_TYPE_UNKNOWN,
	MA_RESOURCE_MANAGER_DATA_SUPPLY_TYPE_ENCODED,
	MA_RESOURCE_MANAGER_DATA_SUPPLY_TYPE_DECODED,
	MA_RESOURCE_MANAGER_DATA_SUPPLY_TYPE_DECODED_PAGED
}

constdef MaNodeFlags : int
{
	MA_NODE_FLAG_PASSTHROUGH = 1,
	MA_NODE_FLAG_CONTINUOUS_PROCESSING = 2,
	MA_NODE_FLAG_ALLOW_NULL_INPUT = 4,
	MA_NODE_FLAG_DIFFERENT_PROCESSING_RATES = 8,
	MA_NODE_FLAG_SILENT_OUTPUT = 16
}

enum MaNodeState
{
	MA_NODE_STATE_STARTED,
	MA_NODE_STATE_STOPPED
}

constdef MaSoundFlags : int
{
	MA_SOUND_FLAG_STREAM = 1,
	MA_SOUND_FLAG_DECODE = 2,
	MA_SOUND_FLAG_ASYNC = 4,
	MA_SOUND_FLAG_WAIT_INIT = 8,
	MA_SOUND_FLAG_UNKNOWN_LENGTH = 16,
	MA_SOUND_FLAG_LOOPING = 32,
	MA_SOUND_FLAG_NO_DEFAULT_ATTACHMENT = 4096,
	MA_SOUND_FLAG_NO_PITCH = 8192,
	MA_SOUND_FLAG_NO_SPATIALIZATION = 16384
}

enum MaEngineNodeType
{
	MA_ENGINE_NODE_TYPE_SOUND,
	MA_ENGINE_NODE_TYPE_GROUP
}

enum MaDrWavSeekOrigin
{
	MA_DR_WAV_SEEK_SET,
	MA_DR_WAV_SEEK_CUR,
	MA_DR_WAV_SEEK_END
}

enum MaDrWavContainer
{
	MA_DR_WAV_CONTAINER_RIFF,
	MA_DR_WAV_CONTAINER_RIFX,
	MA_DR_WAV_CONTAINER_W64,
	MA_DR_WAV_CONTAINER_RF64,
	MA_DR_WAV_CONTAINER_AIFF
}

constdef MaDrWavMetadataType : int
{
	MA_DR_WAV_METADATA_TYPE_NONE = 0,
	MA_DR_WAV_METADATA_TYPE_UNKNOWN = 1,
	MA_DR_WAV_METADATA_TYPE_SMPL = 2,
	MA_DR_WAV_METADATA_TYPE_INST = 4,
	MA_DR_WAV_METADATA_TYPE_CUE = 8,
	MA_DR_WAV_METADATA_TYPE_ACID = 16,
	MA_DR_WAV_METADATA_TYPE_BEXT = 32,
	MA_DR_WAV_METADATA_TYPE_LIST_LABEL = 64,
	MA_DR_WAV_METADATA_TYPE_LIST_NOTE = 128,
	MA_DR_WAV_METADATA_TYPE_LIST_LABELLED_CUE_REGION = 256,
	MA_DR_WAV_METADATA_TYPE_LIST_INFO_SOFTWARE = 512,
	MA_DR_WAV_METADATA_TYPE_LIST_INFO_COPYRIGHT = 1024,
	MA_DR_WAV_METADATA_TYPE_LIST_INFO_TITLE = 2048,
	MA_DR_WAV_METADATA_TYPE_LIST_INFO_ARTIST = 4096,
	MA_DR_WAV_METADATA_TYPE_LIST_INFO_COMMENT = 8192,
	MA_DR_WAV_METADATA_TYPE_LIST_INFO_DATE = 16384,
	MA_DR_WAV_METADATA_TYPE_LIST_INFO_GENRE = 32768,
	MA_DR_WAV_METADATA_TYPE_LIST_INFO_ALBUM = 65536,
	MA_DR_WAV_METADATA_TYPE_LIST_INFO_TRACKNUMBER = 131072,
	MA_DR_WAV_METADATA_TYPE_LIST_INFO_LOCATION = 262144,
	MA_DR_WAV_METADATA_TYPE_LIST_INFO_ORGANIZATION = 524288,
	MA_DR_WAV_METADATA_TYPE_LIST_INFO_KEYWORDS = 1048576,
	MA_DR_WAV_METADATA_TYPE_LIST_INFO_MEDIUM = 2097152,
	MA_DR_WAV_METADATA_TYPE_LIST_INFO_DESCRIPTION = 4194304,
	MA_DR_WAV_METADATA_TYPE_LIST_ALL_INFO_STRINGS = 8388096,
	MA_DR_WAV_METADATA_TYPE_LIST_ALL_ADTL = 448,
	MA_DR_WAV_METADATA_TYPE_ALL = -2,
	MA_DR_WAV_METADATA_TYPE_ALL_INCLUDING_UNKNOWN = -1
}

enum MaDrWavSmplLoopType
{
	MA_DR_WAV_SMPL_LOOP_TYPE_FORWARD,
	MA_DR_WAV_SMPL_LOOP_TYPE_PINGPONG,
	MA_DR_WAV_SMPL_LOOP_TYPE_BACKWARD
}

constdef MaDrWavAcidFlag : int
{
	MA_DR_WAV_ACID_FLAG_ONE_SHOT = 1,
	MA_DR_WAV_ACID_FLAG_ROOT_NOTE_SET = 2,
	MA_DR_WAV_ACID_FLAG_STRETCH = 4,
	MA_DR_WAV_ACID_FLAG_DISK_BASED = 8,
	MA_DR_WAV_ACID_FLAG_ACIDIZER = 16
}

enum MaDrWavMetadataLocation
{
	MA_DR_WAV_METADATA_LOCATION_INVALID,
	MA_DR_WAV_METADATA_LOCATION_TOP_LEVEL,
	MA_DR_WAV_METADATA_LOCATION_INSIDE_INFO_LIST,
	MA_DR_WAV_METADATA_LOCATION_INSIDE_ADTL_LIST
}

enum MaDrFlacContainer
{
	MA_DR_FLAC_CONTAINER_NATIVE,
	MA_DR_FLAC_CONTAINER_OGG,
	MA_DR_FLAC_CONTAINER_UNKNOWN
}

enum MaDrFlacSeekOrigin
{
	MA_DR_FLAC_SEEK_SET,
	MA_DR_FLAC_SEEK_CUR,
	MA_DR_FLAC_SEEK_END
}

enum MaDrMp3SeekOrigin
{
	MA_DR_MP3_SEEK_SET,
	MA_DR_MP3_SEEK_CUR,
	MA_DR_MP3_SEEK_END
}

enum MaDrMp3MetadataType
{
	MA_DR_MP3_METADATA_TYPE_ID3V1,
	MA_DR_MP3_METADATA_TYPE_ID3V2,
	MA_DR_MP3_METADATA_TYPE_APE,
	MA_DR_MP3_METADATA_TYPE_XING,
	MA_DR_MP3_METADATA_TYPE_VBRI
}

enum MaDrWavMetadataParserStage
{
	MA_DR_WAV__METADATA_PARSER_STAGE_COUNT,
	MA_DR_WAV__METADATA_PARSER_STAGE_READ
}

enum MaDrFlacOggCrcMismatchRecovery
{
	MA_DR_FLAC_OGG_RECOVER_ON_CRC_MISMATCH,
	MA_DR_FLAC_OGG_FAIL_ON_CRC_MISMATCH
}

struct MaContext
{
	MaBackendCallbacks callbacks;
	MaBackend backend;
	MaLog* p_log;
	MaLog log;
	MaThreadPriority thread_priority;
	usz thread_stack_size;
	void* p_user_data;
	MaAllocationCallbacks allocation_callbacks;
	MaMutex device_enum_lock;
	MaMutex device_info_lock;
	uint device_info_capacity;
	uint playback_device_info_count;
	uint capture_device_info_count;
	MaDeviceInfo* p_device_infos;
	void* _field15;
	void* _field21;
}

enum MaThreadingMode
{
	MA_THREADING_MODE_MULTI_THREADED,
	MA_THREADING_MODE_SINGLE_THREADED
}

enum MaDeviceStatus
{
	MA_DEVICE_STATUS_UNINITIALIZED,
	MA_DEVICE_STATUS_STOPPED,
	MA_DEVICE_STATUS_STARTED,
	MA_DEVICE_STATUS_STARTING,
	MA_DEVICE_STATUS_STOPPING,
	MA_DEVICE_STATUS_ERRORED
}

struct MaAtomicDeviceStatus
{
	MaDeviceStatus value;
}

enum MaDeviceOpType
{
	MA_DEVICE_OP_INIT,
	MA_DEVICE_OP_UNINIT,
	MA_DEVICE_OP_START,
	MA_DEVICE_OP_STOP
}

struct MaDeviceOpCompletionEvent
{
	MaResult result;
	MaEvent event;
}

union MaDeviceOpParams
{
	struct init
	{
		void* p_device_backend_config;
		MaDeviceDescriptor* p_descriptor_playback;
		MaDeviceDescriptor* p_descriptor_capture;
	}
}

struct MaDeviceOp
{
	MaDeviceOpType type;
	MaDeviceOpParams params;
	MaDeviceOpCompletionEvent* p_completion_event;
}

struct MaDeviceOpQueue
{
	MaMutex lock;
	MaSemaphore sem;
	uint count;
	uint tail;
	MaDeviceOp[4] p_items;
}

struct MaDevicePlayback
{
	MaDeviceId* p_id;
	MaDeviceId id;
	MaShareMode share_mode;
	MaFormat format;
	uint channels;
	MaFormat internal_format;
	uint internal_channels;
	uint internal_sample_rate;
	uint internal_period_size_in_frames;
	uint internal_periods;
	MaChannelMixMode channel_mix_mode;
	uint calculate_lfe_from_spatial_channels;
	MaDataConverter converter;
	void* p_intermediary_buffer;
	uint intermediary_buffer_cap;
	uint intermediary_buffer_len;
	void* p_input_cache;
	uint input_cache_cap;
	uint input_cache_consumed;
	uint input_cache_remaining;
}

struct MaDeviceCapture
{
	MaDeviceId* p_id;
	MaDeviceId id;
	MaShareMode share_mode;
	MaFormat format;
	uint channels;
	MaFormat internal_format;
	uint internal_channels;
	uint internal_sample_rate;
	uint internal_period_size_in_frames;
	uint internal_periods;
	MaChannelMixMode channel_mix_mode;
	uint calculate_lfe_from_spatial_channels;
	MaDataConverter converter;
	void* p_intermediary_buffer;
	uint intermediary_buffer_cap;
	uint intermediary_buffer_len;
}

struct MaDevice
{
	MaContext* p_context;
	MaDeviceType type;
	MaThreadingMode threading_mode;
	MaBool32 has_audio_thread;
	uint sample_rate;
	MaAtomicDeviceStatus status;
	MaDeviceDataProc on_data;
	MaDeviceNotificationProc on_notification;
	void* p_user_data;
	void* p_backend_state;
	MaDeviceOpQueue op_queue;
	MaDeviceOpCompletionEvent op_completion_event;
	CULong audio_thread;
	MaMutex start_stop_lock;
	char is_owner_of_context;
	char no_pre_silenced_output_buffer;
	char no_clip;
	char no_disable_denormals;
	char no_fixed_sized_callback;
	MaAtomicFloat master_volume_factor;
	void* p_duplex_rb;
	struct resampling
	{
		MaResampleAlgorithm algorithm;
		MaResamplingBackendVtable* p_backend_v_table;
		void* p_backend_user_data;
		struct linear
		{
			uint lpf_order;
		}
	}
	MaDevicePlayback playback;
	MaDeviceCapture capture;
}

struct MaAllocationCallbacks
{
	void* p_user_data;
	void* on_malloc;
	void* on_realloc;
	void* on_free;
}

struct MaLcg
{
	uint state;
}

struct MaAtomicUint32
{
	uint value;
}

struct MaAtomicInt32
{
	int value;
}

struct MaAtomicUint64
{
	ulong value;
}

struct MaAtomicFloat
{
	float value;
}

struct MaAtomicBool32
{
	uint value;
}

struct MaEvent
{
	uint value;
	MaPthreadMutexT lock;
	MaPthreadCondT cond;
}

struct MaSemaphore
{
	int value;
	MaPthreadMutexT lock;
	MaPthreadCondT cond;
}

struct MaLogCallback
{
	MaLogCallbackProc on_log;
	void* p_user_data;
}

struct MaLog
{
	MaLogCallback[4] callbacks;
	uint callback_count;
	MaAllocationCallbacks allocation_callbacks;
	MaMutex lock;
}

union MaBiquadCoefficient
{
	float f32;
	int s32;
}

struct MaBiquadConfig
{
	MaFormat format;
	uint channels;
	double b0;
	double b1;
	double b2;
	double a0;
	double a1;
	double a2;
}

struct MaBiquad
{
	MaFormat format;
	uint channels;
	MaBiquadCoefficient b0;
	MaBiquadCoefficient b1;
	MaBiquadCoefficient b2;
	MaBiquadCoefficient a1;
	MaBiquadCoefficient a2;
	MaBiquadCoefficient* p_r1;
	MaBiquadCoefficient* p_r2;
	void* _p_heap;
	uint _owns_heap;
}

struct MaLpf1Config
{
	MaFormat format;
	uint channels;
	uint sample_rate;
	double cutoff_frequency;
	double q;
}

struct MaLpf2Config
{
	MaFormat format;
	uint channels;
	uint sample_rate;
	double cutoff_frequency;
	double q;
}

struct MaLpf1
{
	MaFormat format;
	uint channels;
	MaBiquadCoefficient a;
	MaBiquadCoefficient* p_r1;
	void* _p_heap;
	uint _owns_heap;
}

struct MaLpf2
{
	MaBiquad bq;
}

struct MaLpfConfig
{
	MaFormat format;
	uint channels;
	uint sample_rate;
	double cutoff_frequency;
	uint order;
}

struct MaLpf
{
	MaFormat format;
	uint channels;
	uint sample_rate;
	uint lpf1_count;
	uint lpf2_count;
	MaLpf1* p_lpf1;
	MaLpf2* p_lpf2;
	void* _p_heap;
	uint _owns_heap;
}

struct MaHpf1Config
{
	MaFormat format;
	uint channels;
	uint sample_rate;
	double cutoff_frequency;
	double q;
}

struct MaHpf2Config
{
	MaFormat format;
	uint channels;
	uint sample_rate;
	double cutoff_frequency;
	double q;
}

struct MaHpf1
{
	MaFormat format;
	uint channels;
	MaBiquadCoefficient a;
	MaBiquadCoefficient* p_r1;
	void* _p_heap;
	uint _owns_heap;
}

struct MaHpf2
{
	MaBiquad bq;
}

struct MaHpfConfig
{
	MaFormat format;
	uint channels;
	uint sample_rate;
	double cutoff_frequency;
	uint order;
}

struct MaHpf
{
	MaFormat format;
	uint channels;
	uint sample_rate;
	uint hpf1_count;
	uint hpf2_count;
	MaHpf1* p_hpf1;
	MaHpf2* p_hpf2;
	void* _p_heap;
	uint _owns_heap;
}

struct MaBpf2Config
{
	MaFormat format;
	uint channels;
	uint sample_rate;
	double cutoff_frequency;
	double q;
}

struct MaBpf2
{
	MaBiquad bq;
}

struct MaBpfConfig
{
	MaFormat format;
	uint channels;
	uint sample_rate;
	double cutoff_frequency;
	uint order;
}

struct MaBpf
{
	MaFormat format;
	uint channels;
	uint bpf2_count;
	MaBpf2* p_bpf2;
	void* _p_heap;
	uint _owns_heap;
}

struct MaNotch2Config
{
	MaFormat format;
	uint channels;
	uint sample_rate;
	double q;
	double frequency;
}

struct MaNotchConfig
{
	MaFormat format;
	uint channels;
	uint sample_rate;
	double q;
	double frequency;
}

struct MaNotch2
{
	MaBiquad bq;
}

struct MaPeak2Config
{
	MaFormat format;
	uint channels;
	uint sample_rate;
	double gain_db;
	double q;
	double frequency;
}

struct MaPeakConfig
{
	MaFormat format;
	uint channels;
	uint sample_rate;
	double gain_db;
	double q;
	double frequency;
}

struct MaPeak2
{
	MaBiquad bq;
}

struct MaLoshelf2Config
{
	MaFormat format;
	uint channels;
	uint sample_rate;
	double gain_db;
	double shelf_slope;
	double frequency;
}

struct MaLoshelfConfig
{
	MaFormat format;
	uint channels;
	uint sample_rate;
	double gain_db;
	double shelf_slope;
	double frequency;
}

struct MaLoshelf2
{
	MaBiquad bq;
}

struct MaHishelf2Config
{
	MaFormat format;
	uint channels;
	uint sample_rate;
	double gain_db;
	double shelf_slope;
	double frequency;
}

struct MaHishelfConfig
{
	MaFormat format;
	uint channels;
	uint sample_rate;
	double gain_db;
	double shelf_slope;
	double frequency;
}

struct MaHishelf2
{
	MaBiquad bq;
}

struct MaDelayConfig
{
	uint channels;
	uint sample_rate;
	uint delay_in_frames;
	uint delay_start;
	float wet;
	float dry;
	float decay;
}

struct MaDelay
{
	MaDelayConfig config;
	uint cursor;
	uint buffer_size_in_frames;
	float* p_buffer;
}

struct MaGainerConfig
{
	uint channels;
	uint smooth_time_in_frames;
}

struct MaGainer
{
	MaGainerConfig config;
	uint t;
	float master_volume;
	float* p_old_gains;
	float* p_new_gains;
	void* _p_heap;
	uint _owns_heap;
}

struct MaPannerConfig
{
	MaFormat format;
	uint channels;
	MaPanMode mode;
	float pan;
}

struct MaPanner
{
	MaFormat format;
	uint channels;
	MaPanMode mode;
	float pan;
}

struct MaFaderConfig
{
	MaFormat format;
	uint channels;
	uint sample_rate;
}

struct MaFader
{
	MaFaderConfig config;
	float volume_beg;
	float volume_end;
	ulong length_in_frames;
	long cursor_in_frames;
}

struct MaVec3f
{
	float x;
	float y;
	float z;
}

struct MaAtomicVec3f
{
	MaVec3f v;
	uint lock;
}

struct MaSpatializerListenerConfig
{
	uint channels_out;
	MaChannel* p_channel_map_out;
	MaHandedness handedness;
	float cone_inner_angle_in_radians;
	float cone_outer_angle_in_radians;
	float cone_outer_gain;
	float speed_of_sound;
	MaVec3f world_up;
}

struct MaSpatializerListener
{
	MaSpatializerListenerConfig config;
	MaAtomicVec3f position;
	MaAtomicVec3f direction;
	MaAtomicVec3f velocity;
	uint is_enabled;
	uint _owns_heap;
	void* _p_heap;
}

struct MaSpatializerConfig
{
	uint channels_in;
	uint channels_out;
	MaChannel* p_channel_map_in;
	MaAttenuationModel attenuation_model;
	MaPositioning positioning;
	MaHandedness handedness;
	float min_gain;
	float max_gain;
	float min_distance;
	float max_distance;
	float rolloff;
	float cone_inner_angle_in_radians;
	float cone_outer_angle_in_radians;
	float cone_outer_gain;
	float doppler_factor;
	float directional_attenuation_factor;
	float min_spatialization_channel_gain;
	uint gain_smooth_time_in_frames;
}

struct MaSpatializer
{
	uint channels_in;
	uint channels_out;
	MaChannel* p_channel_map_in;
	MaAttenuationModel attenuation_model;
	MaPositioning positioning;
	MaHandedness handedness;
	float min_gain;
	float max_gain;
	float min_distance;
	float max_distance;
	float rolloff;
	float cone_inner_angle_in_radians;
	float cone_outer_angle_in_radians;
	float cone_outer_gain;
	float doppler_factor;
	float directional_attenuation_factor;
	uint gain_smooth_time_in_frames;
	MaAtomicVec3f position;
	MaAtomicVec3f direction;
	MaAtomicVec3f velocity;
	float doppler_pitch;
	float min_spatialization_channel_gain;
	MaGainer gainer;
	float* p_new_channel_gains_out;
	void* _p_heap;
	uint _owns_heap;
}

struct MaLinearResamplerConfig
{
	MaFormat format;
	uint channels;
	uint sample_rate_in;
	uint sample_rate_out;
	uint lpf_order;
	double lpf_nyquist_factor;
}

struct MaLinearResampler
{
	void* _p_heap;
	uint _owns_heap;
	MaFormat format;
	uint channels;
	uint sample_rate_in;
	uint sample_rate_out;
	uint lpf_order;
	float lpf_nyquist_factor;
	uint in_advance_int;
	uint in_advance_frac;
	uint in_time_int;
	uint in_time_frac;
	uint cached_frame_count;
	void* x0;
	void* x1;
	void* lpf;
}

struct MaResamplerConfig
{
	MaFormat format;
	uint channels;
	uint sample_rate_in;
	uint sample_rate_out;
	MaResampleAlgorithm algorithm;
	MaResamplingBackendVtable* p_backend_v_table;
	void* p_backend_user_data;
	struct linear
	{
		uint lpf_order;
	}
}

struct MaResamplingBackendVtable
{
	void* on_get_heap_size;
	void* on_init;
	void* on_uninit;
	void* on_process;
	void* on_set_rate;
	void* on_get_input_latency;
	void* on_get_output_latency;
	void* on_get_required_input_frame_count;
	void* on_get_expected_output_frame_count;
	void* on_reset;
}

struct MaResampler
{
	MaResamplingBackend* p_backend;
	MaResamplingBackendVtable* p_backend_v_table;
	void* p_backend_user_data;
	MaFormat format;
	uint channels;
	uint sample_rate_in;
	uint sample_rate_out;
	MaLinearResampler state;
	void* _p_heap;
	uint _owns_heap;
}

struct MaChannelConverterConfig
{
	MaFormat format;
	uint channels_in;
	uint channels_out;
	MaChannel* p_channel_map_in;
	MaChannel* p_channel_map_out;
	MaChannelMixMode mixing_mode;
	uint calculate_lfe_from_spatial_channels;
	float** pp_weights;
}

struct MaChannelConverter
{
	void* _p_heap;
	uint _owns_heap;
	MaFormat format;
	uint channels_in;
	uint channels_out;
	MaChannelMixMode mixing_mode;
	MaChannelConversionPath conversion_path;
	MaChannel* p_channel_map_in;
	MaChannel* p_channel_map_out;
	MaUint8* p_shuffle_table;
	void* weights;
	MaChannel[2] _small_channel_map_in;
	MaChannel[2] _small_channel_map_out;
}

struct MaDataConverterConfig
{
	MaFormat format_in;
	MaFormat format_out;
	uint channels_in;
	uint channels_out;
	uint sample_rate_in;
	uint sample_rate_out;
	MaChannel* p_channel_map_in;
	MaChannel* p_channel_map_out;
	MaDitherMode dither_mode;
	MaChannelMixMode channel_mix_mode;
	uint calculate_lfe_from_spatial_channels;
	float** pp_channel_weights;
	uint allow_dynamic_sample_rate;
	MaResamplerConfig resampling;
}

struct MaDataConverter
{
	MaFormat format_in;
	MaFormat format_out;
	uint channels_in;
	uint channels_out;
	uint sample_rate_in;
	uint sample_rate_out;
	MaDitherMode dither_mode;
	MaDataConverterExecutionPath execution_path;
	MaChannelConverter channel_converter;
	MaResampler resampler;
	char has_pre_format_conversion;
	char has_post_format_conversion;
	char has_channel_converter;
	char has_resampler;
	char is_passthrough;
	char _owns_heap;
	void* _p_heap;
}

struct MaDataSourceVtable
{
	void* on_read;
	void* on_seek;
	void* on_get_data_format;
	void* on_get_cursor;
	void* on_get_length;
	void* on_set_looping;
	uint flags;
}

struct MaDataSourceConfig
{
	MaDataSourceVtable* vtable;
}

struct MaDataSourceBase
{
	MaDataSourceVtable* vtable;
	ulong range_beg_in_frames;
	ulong range_end_in_frames;
	ulong loop_beg_in_frames;
	ulong loop_end_in_frames;
	MaDataSource* p_current;
	MaDataSource* p_next;
	MaDataSourceGetNextProc on_get_next;
	uint is_looping;
}

struct MaAudioBufferRef
{
	MaDataSourceBase ds;
	MaFormat format;
	uint channels;
	uint sample_rate;
	ulong cursor;
	ulong size_in_frames;
	void* p_data;
}

struct MaAudioBufferConfig
{
	MaFormat format;
	uint channels;
	uint sample_rate;
	ulong size_in_frames;
	void* p_data;
	MaAllocationCallbacks allocation_callbacks;
}

struct MaAudioBuffer
{
	MaAudioBufferRef ref;
	MaAllocationCallbacks allocation_callbacks;
	uint owns_data;
	MaUint8[1] _p_extra_data;
}

struct MaPagedAudioBufferPage
{
	MaPagedAudioBufferPage* p_next;
	ulong size_in_frames;
	MaUint8[1] p_audio_data;
}

struct MaPagedAudioBufferData
{
	MaFormat format;
	uint channels;
	MaPagedAudioBufferPage head;
	MaPagedAudioBufferPage* p_tail;
}

struct MaPagedAudioBufferConfig
{
	MaPagedAudioBufferData* p_data;
}

struct MaPagedAudioBuffer
{
	MaDataSourceBase ds;
	MaPagedAudioBufferData* p_data;
	MaPagedAudioBufferPage* p_current;
	ulong relative_cursor;
	ulong absolute_cursor;
}


const usz CACHE_LINE_SIZE = ($feat(DARWIN) && $feat(AARCH64)) ? 128 : 64;

alias MaRb = MaRingBuffer;

struct MaRingBuffer
{
	uint head;
	char[CACHE_LINE_SIZE - 4] pad0;
	uint tail;
	char[CACHE_LINE_SIZE - 4] pad1;
	uint capacity;
	uint stride;
	uint flags;
	void* p_buffer;
}

struct MaAudioRingBufferConfig
{
	MaFormat format;
	uint channels;
	uint sample_rate;
	uint size_in_frames;
	uint flags;
	void* p_buffer;
	MaAllocationCallbacks* p_allocation_callbacks;
}

alias MaPcmRb = MaAudioRingBuffer;

struct MaAudioRingBuffer
{
	MaDataSourceBase ds;
	MaRingBuffer rb;
	MaFormat format;
	uint channels;
	uint sample_rate;
	MaBool32 is_owner_of_buffer;
	void* p_buffer;
	MaAllocationCallbacks allocation_callbacks;
}

struct MaDuplexRb
{
	MaAudioRingBuffer rb;
}

struct MaFence
{
	MaEvent e;
	uint counter;
}

struct MaAsyncNotificationCallbacks
{
	void* on_signal;
}

struct MaAsyncNotificationPoll
{
	MaAsyncNotificationCallbacks cb;
	uint signalled;
}

struct MaAsyncNotificationEvent
{
	MaAsyncNotificationCallbacks cb;
	MaEvent e;
}

struct MaSlotAllocatorConfig
{
	uint capacity;
}

struct MaSlotAllocatorGroup
{
	uint bitfield;
}

struct MaSlotAllocator
{
	MaSlotAllocatorGroup* p_groups;
	MaUint32* p_slots;
	uint count;
	uint capacity;
	uint _owns_heap;
	void* _p_heap;
}

struct MaJob
{
	void* toc;
	ulong next;
	uint order;
	void* data;
}

struct MaJobQueueConfig
{
	uint flags;
	uint capacity;
}

struct MaJobQueue
{
	uint flags;
	uint capacity;
	ulong head;
	ulong tail;
	MaSemaphore sem;
	MaSlotAllocator allocator;
	MaJob* p_jobs;
	uint lock;
	void* _p_heap;
	uint _owns_heap;
}

struct MaAtomicDeviceState
{
	MaDeviceState value;
}

struct MaDeviceJobThreadConfig
{
	uint no_thread;
	uint job_queue_capacity;
	uint job_queue_flags;
}

struct MaDeviceJobThread
{
	CULong thread;
	MaJobQueue job_queue;
	uint _has_thread;
}

struct MaDeviceNotification
{
	MaDevice* p_device;
	MaDeviceNotificationType type;
	void* data;
}

union MaTimer
{
	long counter;
	double counter_d;
}

union MaDeviceId
{
	MaWcharWin32[64] wasapi;
	MaUint8[16] dsound;
	uint winmm;
	char[256] alsa;
	char[256] pulse;
	int jack;
	char[256] coreaudio;
	char[256] sndio;
	char[256] audio4;
	char[64] oss;
	int aaudio;
	uint opensl;
	char[32] webaudio;
	void* custom;
	int nullbackend;
}

struct MaContextConfig
{
	MaLog* p_log;
	MaThreadPriority thread_priority;
	usz thread_stack_size;
	void* p_user_data;
	MaAllocationCallbacks allocation_callbacks;
	void* dsound;
	void* alsa;
	void* pulse;
	void* coreaudio;
	void* jack;
	MaBackendCallbacks custom;
}

struct MaDeviceBackendConfig
{
	void* p_vtable;
	void* p_config;
}

struct MaDeviceConfigWasapi
{
	MaWasapiUsage usage;
	char no_auto_convert_src;
	char no_default_quality_src;
	char no_auto_stream_routing;
	char no_hardware_offloading;
	uint loopback_process_id;
	char loopback_process_exclude;
}

struct MaDeviceConfigDsound { int _unused; }
struct MaDeviceConfigWinmm { int _unused; }

struct MaDeviceConfigCoreaudio
{
	uint allow_nominal_sample_rate_change;
}

struct MaDeviceConfigPipewire
{
	ZString p_thread_name;
	ZString p_stream_name;
	ZString p_media_role;
}

struct MaDeviceConfigPulseaudio
{
	ZString p_stream_name_playback;
	ZString p_stream_name_capture;
	int channel_map;
}

struct MaDeviceConfigJack
{
	uint no_auto_connect;
}

struct MaDeviceConfigAlsa
{
	uint no_mmap;
	uint no_auto_format;
	uint no_auto_channels;
	uint no_auto_resample;
	uint assume_default_channel_layout;
}

struct MaDeviceConfigSndio { int _unused; }
struct MaDeviceConfigAudio4 { int _unused; }
struct MaDeviceConfigOss { int _unused; }

enum MaAaudioPerformanceMode
{
	MA_AAUDIO_PERFORMANCE_MODE_DEFAULT,
	MA_AAUDIO_PERFORMANCE_MODE_LOW_LATENCY,
	MA_AAUDIO_PERFORMANCE_MODE_NONE,
	MA_AAUDIO_PERFORMANCE_MODE_POWER_SAVING
}

struct MaDeviceConfigAaudio
{
	MaAaudioUsage usage;
	MaAaudioContentType content_type;
	MaAaudioInputPreset input_preset;
	MaAaudioAllowedCapturePolicy allowed_capture_policy;
	MaAaudioPerformanceMode performance_mode;
	uint no_auto_start_after_reroute;
	uint allow_set_buffer_capacity;
}

struct MaDeviceConfigOpensl
{
	MaOpenslStreamType stream_type;
	MaOpenslRecordingPreset recording_preset;
}

enum MaWebaudioLatencyHint
{
	MA_WEBAUDIO_LATENCY_HINT_INTERACTIVE,
	MA_WEBAUDIO_LATENCY_HINT_PLAYBACK,
	MA_WEBAUDIO_LATENCY_HINT_BALANCED
}

struct MaDeviceConfigWebaudio
{
	MaWebaudioLatencyHint latency_hint;
}

struct MaDeviceConfigDreamcast
{
	int voice_channel;
}

struct MaDeviceConfigXaudio { int _unused; }

enum MaVitaPortType
{
	MA_VITA_PORT_TYPE_BGM,
	MA_VITA_PORT_TYPE_MAIN
}

struct MaDeviceConfigVita
{
	MaVitaPortType port_type;
}

struct MaDeviceConfigNull { int _unused; }

struct MaDeviceConfig
{
	MaDeviceType device_type;
	MaThreadingMode threading_mode;
	uint sample_rate;
	uint period_size_in_frames;
	uint period_size_in_milliseconds;
	uint periods;
	char no_pre_silenced_output_buffer;
	char no_clip;
	char no_disable_denormals;
	char no_fixed_sized_callback;
	MaDeviceDataProc data_callback;
	MaDeviceNotificationProc notification_callback;
	void* p_user_data;
	MaDeviceBackendConfig* p_backend_configs;
	usz backend_config_count;
	MaResamplerConfig resampling;
	struct playback
	{
		MaDeviceId* p_device_id;
		MaFormat format;
		uint channels;
		MaChannel* p_channel_map;
		MaChannelMixMode channel_mix_mode;
		uint calculate_lfe_from_spatial_channels;
		MaShareMode share_mode;
	}
	struct capture
	{
		MaDeviceId* p_device_id;
		MaFormat format;
		uint channels;
		MaChannel* p_channel_map;
		MaChannelMixMode channel_mix_mode;
		uint calculate_lfe_from_spatial_channels;
		MaShareMode share_mode;
	}
	MaDeviceConfigWasapi wasapi;
	MaDeviceConfigDsound dsound;
	MaDeviceConfigWinmm winmm;
	MaDeviceConfigCoreaudio coreaudio;
	MaDeviceConfigPipewire pipewire;
	MaDeviceConfigPulseaudio pulseaudio;
	MaDeviceConfigJack jack;
	MaDeviceConfigAlsa alsa;
	MaDeviceConfigSndio sndio;
	MaDeviceConfigAudio4 audio4;
	MaDeviceConfigOss oss;
	MaDeviceConfigAaudio aaudio;
	MaDeviceConfigOpensl opensl;
	MaDeviceConfigWebaudio webaudio;
	MaDeviceConfigDreamcast dreamcast;
	MaDeviceConfigXaudio xaudio;
	MaDeviceConfigVita vita;
	MaDeviceConfigNull null_backend;
}

struct MaBackendCallbacks
{
	void* on_context_init;
	void* on_context_uninit;
	void* on_context_enumerate_devices;
	void* on_context_get_device_info;
	void* on_device_init;
	void* on_device_uninit;
	void* on_device_start;
	void* on_device_stop;
	void* on_device_read;
	void* on_device_write;
	void* on_device_data_loop;
	void* on_device_data_loop_wakeup;
	void* on_device_get_info;
}

struct MaDeviceInfo
{
	MaDeviceId id;
	char[256] name;
	uint is_default;
	uint native_data_format_count;
	void*[] native_data_formats;
}

struct MaDeviceDescriptor
{
	MaDeviceId* p_device_id;
	MaShareMode share_mode;
	MaFormat format;
	uint channels;
	uint sample_rate;
	MaChannel[254] channel_map;
	uint period_size_in_frames;
	uint period_size_in_milliseconds;
	uint period_count;
}

struct MaContextCommandWasapi
{
	int code;
	MaEvent* p_event;
	void* data;
}

struct MaFileInfo
{
	ulong size_in_bytes;
}

struct MaVfsCallbacks
{
	void* on_open;
	void* on_open_w;
	void* on_close;
	void* on_read;
	void* on_write;
	void* on_seek;
	void* on_tell;
	void* on_info;
}

struct MaDefaultVfs
{
	MaVfsCallbacks cb;
	MaAllocationCallbacks allocation_callbacks;
}

struct MaDecoder
{
	MaDataSourceBase ds;
	MaDataSource* p_backend;
	MaDecodingBackendVtable* p_backend_v_table;
	void* p_backend_user_data;
	MaDecoderReadProc on_read;
	MaDecoderSeekProc on_seek;
	MaDecoderTellProc on_tell;
	void* p_user_data;
	ulong read_pointer_in_pcm_frames;
	MaFormat output_format;
	uint output_channels;
	uint output_sample_rate;
	MaDataConverter converter;
	void* p_input_cache;
	ulong input_cache_cap;
	ulong input_cache_consumed;
	ulong input_cache_remaining;
	MaAllocationCallbacks allocation_callbacks;
	char[32768] data;
}

struct MaDecodingBackendConfig
{
	MaFormat preferred_format;
	uint seek_point_count;
}

struct MaDecodingBackendVtable
{
	void* on_init;
	void* on_init_file;
	void* on_init_file_w;
	void* on_init_memory;
	void* on_uninit;
}

struct MaDecoderConfig
{
	MaFormat format;
	uint channels;
	uint sample_rate;
	MaChannel* p_channel_map;
	MaChannelMixMode channel_mix_mode;
	MaDitherMode dither_mode;
	MaResamplerConfig resampling;
	MaAllocationCallbacks allocation_callbacks;
	MaEncodingFormat encoding_format;
	uint seek_point_count;
	MaDecodingBackendVtable** pp_custom_backend_v_tables;
	uint custom_backend_count;
	void* p_custom_backend_user_data;
}

struct MaEncoder
{
	MaEncoderConfig config;
	MaEncoderWriteProc on_write;
	MaEncoderSeekProc on_seek;
	MaEncoderInitProc on_init;
	MaEncoderUninitProc on_uninit;
	MaEncoderWritePcmFramesProc on_write_pcm_frames;
	void* p_user_data;
	void* p_internal_encoder;
	void* data;
}

struct MaEncoderConfig
{
	MaEncodingFormat encoding_format;
	MaFormat format;
	uint channels;
	uint sample_rate;
	MaAllocationCallbacks allocation_callbacks;
}

struct MaWaveformConfig
{
	MaFormat format;
	uint channels;
	uint sample_rate;
	MaWaveformType type;
	double amplitude;
	double frequency;
}

struct MaWaveform
{
	MaDataSourceBase ds;
	MaWaveformConfig config;
	double advance;
	double time;
}

struct MaPulsewaveConfig
{
	MaFormat format;
	uint channels;
	uint sample_rate;
	double duty_cycle;
	double amplitude;
	double frequency;
}

struct MaPulsewave
{
	MaWaveform waveform;
	MaPulsewaveConfig config;
}

struct MaNoiseConfig
{
	MaFormat format;
	uint channels;
	MaNoiseType type;
	int seed;
	double amplitude;
	uint duplicate_channels;
}

struct MaNoise
{
	MaDataSourceBase ds;
	MaNoiseConfig config;
	MaLcg lcg;
	void* state;
	void* _p_heap;
	uint _owns_heap;
}

struct MaResourceManager
{
	MaResourceManagerConfig config;
	MaResourceManagerDataBufferNode* p_root_data_buffer_node;
	MaMutex data_buffer_bst_lock;
	MaThread[64] job_threads;
	MaJobQueue job_queue;
	MaDefaultVfs default_vfs;
	MaLog log;
}

struct MaResourceManagerDataBufferNode
{
	uint hashed_name32;
	uint ref_count;
	MaResult result;
	uint execution_counter;
	uint execution_pointer;
	uint is_data_owned_by_resource_manager;
	MaResourceManagerDataSupply data;
	MaResourceManagerDataBufferNode* p_parent;
	MaResourceManagerDataBufferNode* p_child_lo;
	MaResourceManagerDataBufferNode* p_child_hi;
}

struct MaResourceManagerDataBuffer
{
	MaDataSourceBase ds;
	MaResourceManager* p_resource_manager;
	MaResourceManagerDataBufferNode* p_node;
	uint flags;
	uint execution_counter;
	uint execution_pointer;
	ulong seek_target_in_pcm_frames;
	uint seek_to_cursor_on_next_read;
	MaResult result;
	uint is_looping;
	MaAtomicBool32 is_connector_initialized;
	void* connector;
}

struct MaResourceManagerDataStream
{
	MaDataSourceBase ds;
	MaResourceManager* p_resource_manager;
	uint flags;
	MaDecoder decoder;
	uint is_decoder_initialized;
	ulong total_length_in_pcm_frames;
	uint relative_cursor;
	ulong absolute_cursor;
	uint current_page_index;
	uint execution_counter;
	uint execution_pointer;
	uint is_looping;
	void* p_page_data;
	MaUint32[2] page_frame_count;
	MaResult result;
	uint is_decoder_at_end;
	MaBool32[2] is_page_valid;
	uint seek_counter;
}

struct MaResourceManagerDataSource
{
	void* backend;
	uint flags;
	uint execution_counter;
	uint execution_pointer;
}

struct MaResourceManagerPipelineStageNotification
{
	MaAsyncNotification* p_notification;
	MaFence* p_fence;
}

struct MaResourceManagerPipelineNotifications
{
	MaResourceManagerPipelineStageNotification init;
	MaResourceManagerPipelineStageNotification done;
}

struct MaResourceManagerDataSourceConfig
{
	ZString p_file_path;
	WcharT* p_file_path_w;
	MaResourceManagerPipelineNotifications* p_notifications;
	ulong initial_seek_point_in_pcm_frames;
	ulong range_beg_in_pcm_frames;
	ulong range_end_in_pcm_frames;
	ulong loop_point_beg_in_pcm_frames;
	ulong loop_point_end_in_pcm_frames;
	uint flags;
	uint is_looping;
}

struct MaResourceManagerDataSupply
{
	MaResourceManagerDataSupplyType type;
	void* backend;
}

struct MaResourceManagerConfig
{
	MaAllocationCallbacks allocation_callbacks;
	MaLog* p_log;
	MaFormat decoded_format;
	uint decoded_channels;
	uint decoded_sample_rate;
	uint job_thread_count;
	usz job_thread_stack_size;
	uint job_queue_capacity;
	uint flags;
	MaVfs* p_vfs;
	MaDecodingBackendVtable** pp_custom_decoding_backend_v_tables;
	uint custom_decoding_backend_count;
	void* p_custom_decoding_backend_user_data;
	MaResamplerConfig resampling;
}

struct MaStack
{
	usz offset;
	usz size_in_bytes;
	char[1] _data;
}

struct MaNodeGraph
{
	MaNodeBase base;
	MaNodeBase endpoint;
	float* p_processing_cache;
	uint processing_cache_frames_remaining;
	uint processing_size_in_frames;
	uint is_reading;
	MaStack* p_pre_mix_stack;
}

struct MaNodeVtable
{
	void* on_process;
	void* on_get_required_input_frame_count;
	char input_bus_count;
	char output_bus_count;
	uint flags;
}

struct MaNodeConfig
{
	MaNodeVtable* vtable;
	MaNodeState initial_state;
	uint input_bus_count;
	uint output_bus_count;
	MaUint32* p_input_channels;
	MaUint32* p_output_channels;
}

struct MaNodeOutputBus
{
	MaNode* p_node;
	char output_bus_index;
	char channels;
	char input_node_input_bus_index;
	uint flags;
	uint ref_count;
	uint is_attached;
	uint lock;
	float volume;
	MaNodeOutputBus* p_next;
	MaNodeOutputBus* p_prev;
	MaNode* p_input_node;
}

struct MaNodeInputBus
{
	MaNodeOutputBus head;
	uint next_counter;
	uint lock;
	char channels;
}

struct MaNodeBase
{
	MaNodeGraph* p_node_graph;
	MaNodeVtable* vtable;
	uint input_bus_count;
	uint output_bus_count;
	MaNodeInputBus* p_input_buses;
	MaNodeOutputBus* p_output_buses;
	float* p_cached_data;
	ushort cached_data_cap_in_frames_per_bus;
	ushort cached_frame_count_out;
	ushort cached_frame_count_in;
	ushort consumed_frame_count_in;
	MaNodeState state;
	MaUint64[2] state_times;
	ulong local_time;
	MaNodeInputBus[2] _input_buses;
	MaNodeOutputBus[2] _output_buses;
	void* _p_heap;
	uint _owns_heap;
}

struct MaNodeGraphConfig
{
	uint channels;
	uint processing_size_in_frames;
	usz pre_mix_stack_size_in_bytes;
}

struct MaDataSourceNodeConfig
{
	MaNodeConfig node_config;
	MaDataSource* p_data_source;
}

struct MaDataSourceNode
{
	MaNodeBase base;
	MaDataSource* p_data_source;
}

struct MaSplitterNodeConfig
{
	MaNodeConfig node_config;
	uint channels;
	uint output_bus_count;
}

struct MaSplitterNode
{
	MaNodeBase base;
}

struct MaBiquadNodeConfig
{
	MaNodeConfig node_config;
	MaBiquadConfig biquad;
}

struct MaBiquadNode
{
	MaNodeBase base_node;
	MaBiquad biquad;
}

struct MaLpfNodeConfig
{
	MaNodeConfig node_config;
	MaLpfConfig lpf;
}

struct MaLpfNode
{
	MaNodeBase base_node;
	MaLpf lpf;
}

struct MaHpfNodeConfig
{
	MaNodeConfig node_config;
	MaHpfConfig hpf;
}

struct MaHpfNode
{
	MaNodeBase base_node;
	MaHpf hpf;
}

struct MaBpfNodeConfig
{
	MaNodeConfig node_config;
	MaBpfConfig bpf;
}

struct MaBpfNode
{
	MaNodeBase base_node;
	MaBpf bpf;
}

struct MaNotchNodeConfig
{
	MaNodeConfig node_config;
	MaNotchConfig notch;
}

struct MaNotchNode
{
	MaNodeBase base_node;
	MaNotch2 notch;
}

struct MaPeakNodeConfig
{
	MaNodeConfig node_config;
	MaPeakConfig peak;
}

struct MaPeakNode
{
	MaNodeBase base_node;
	MaPeak2 peak;
}

struct MaLoshelfNodeConfig
{
	MaNodeConfig node_config;
	MaLoshelfConfig loshelf;
}

struct MaLoshelfNode
{
	MaNodeBase base_node;
	MaLoshelf2 loshelf;
}

struct MaHishelfNodeConfig
{
	MaNodeConfig node_config;
	MaHishelfConfig hishelf;
}

struct MaHishelfNode
{
	MaNodeBase base_node;
	MaHishelf2 hishelf;
}

struct MaDelayNodeConfig
{
	MaNodeConfig node_config;
	MaDelayConfig delay;
}

struct MaDelayNode
{
	MaNodeBase base_node;
	MaDelay delay;
}

struct MaEngine
{
	MaNodeGraph node_graph;
	MaResourceManager* p_resource_manager;
	MaDevice* p_device;
	MaLog* p_log;
	uint sample_rate;
	uint listener_count;
	MaSpatializerListener[4] listeners;
	MaAllocationCallbacks allocation_callbacks;
	char owns_resource_manager;
	char owns_device;
	uint inlined_sound_lock;
	MaSoundInlined* p_inlined_sound_head;
	uint inlined_sound_count;
	uint gain_smooth_time_in_frames;
	uint default_volume_smooth_time_in_pcm_frames;
	MaMonoExpansionMode mono_expansion_mode;
	MaEngineProcessProc on_process;
	void* p_process_user_data;
	MaResamplerConfig pitch_resampling_config;
}

struct MaSound
{
	MaEngineNode engine_node;
	MaDataSource* p_data_source;
	ulong seek_target;
	uint at_end;
	MaSoundEndProc end_callback;
	void* p_end_callback_user_data;
	float* p_processing_cache;
	uint processing_cache_frames_remaining;
	uint processing_cache_cap;
	char owns_data_source;
	MaResourceManagerDataSource* p_resource_manager_data_source;
}

struct MaEngineNodeConfig
{
	MaEngine* p_engine;
	MaEngineNodeType type;
	uint channels_in;
	uint channels_out;
	uint sample_rate;
	uint volume_smooth_time_in_pcm_frames;
	MaMonoExpansionMode mono_expansion_mode;
	char is_pitch_disabled;
	char is_spatialization_disabled;
	char pinned_listener_index;
	MaResamplerConfig resampling;
}

struct MaEngineNode
{
	MaNodeBase base_node;
	MaEngine* p_engine;
	uint sample_rate;
	uint volume_smooth_time_in_pcm_frames;
	MaMonoExpansionMode mono_expansion_mode;
	MaFader fader;
	MaResampler resampler;
	MaSpatializer spatializer;
	MaPanner panner;
	MaGainer volume_gainer;
	MaAtomicFloat volume;
	float pitch;
	float old_pitch;
	float old_doppler_pitch;
	uint is_pitch_disabled;
	uint is_spatialization_disabled;
	uint pinned_listener_index;
	void* fade_settings;
	char _owns_heap;
	void* _p_heap;
}

struct MaSoundConfig
{
	ZString p_file_path;
	WcharT* p_file_path_w;
	MaDataSource* p_data_source;
	MaNode* p_initial_attachment;
	uint initial_attachment_input_bus_index;
	uint channels_in;
	uint channels_out;
	MaMonoExpansionMode mono_expansion_mode;
	uint flags;
	uint volume_smooth_time_in_pcm_frames;
	ulong initial_seek_point_in_pcm_frames;
	ulong range_beg_in_pcm_frames;
	ulong range_end_in_pcm_frames;
	ulong loop_point_beg_in_pcm_frames;
	ulong loop_point_end_in_pcm_frames;
	MaSoundEndProc end_callback;
	void* p_end_callback_user_data;
	MaResamplerConfig pitch_resampling;
	MaResourceManagerPipelineNotifications init_notifications;
	MaFence* p_done_fence;
	uint is_looping;
}

struct MaSoundInlined
{
	MaSound sound;
	MaSoundInlined* p_next;
	MaSoundInlined* p_prev;
}

struct MaEngineConfig
{
	MaResourceManager* p_resource_manager;
	MaContext* p_context;
	MaDevice* p_device;
	MaDeviceId* p_playback_device_id;
	MaDeviceDataProc data_callback;
	MaDeviceNotificationProc notification_callback;
	MaLog* p_log;
	uint listener_count;
	uint channels;
	uint sample_rate;
	uint period_size_in_frames;
	uint period_size_in_milliseconds;
	uint gain_smooth_time_in_frames;
	uint gain_smooth_time_in_milliseconds;
	uint default_volume_smooth_time_in_pcm_frames;
	uint pre_mix_stack_size_in_bytes;
	MaAllocationCallbacks allocation_callbacks;
	uint no_auto_start;
	uint no_device;
	MaMonoExpansionMode mono_expansion_mode;
	MaVfs* p_resource_manager_vfs;
	MaEngineProcessProc on_process;
	void* p_process_user_data;
	MaResamplerConfig resource_manager_resampling;
	MaResamplerConfig pitch_resampling;
}

union MaAtomicIf32
{
	uint i;
	float f;
}

union MaAtomicIf64
{
	ulong i;
	double f;
}

struct MaThreadProxyData
{
	MaThreadEntryProc entry_proc;
	void* p_data;
	MaAllocationCallbacks allocation_callbacks;
}

struct MaSlotAllocatorHeapLayout
{
	usz size_in_bytes;
	usz groups_offset;
	usz slots_offset;
}

struct MaJobQueueHeapLayout
{
	usz size_in_bytes;
	usz allocator_offset;
	usz jobs_offset;
}

struct MaBackendInfo
{
	MaBackend backend;
	ZString p_name;
}

struct MaSndPcmT { void* _unused; }

struct MaSndPcmHwParamsT { void* _unused; }

struct MaSndPcmSwParamsT { void* _unused; }

struct MaSndPcmFormatMaskT { void* _unused; }

struct MaSndPcmInfoT { void* _unused; }

struct MaSndPcmChannelAreaT
{
	void* addr;
	uint first;
	uint step;
}

struct MaSndPcmChmapT
{
	uint channels;
	uint[1] pos;
}

struct MaContextGetDeviceInfoEnumCallbackDataAlsa
{
	MaDeviceType device_type;
	MaDeviceId* p_device_id;
	MaShareMode share_mode;
	MaDeviceInfo* p_device_info;
	uint found_device;
}

struct MaPaMainloop { void* _unused; }

struct MaPaThreadedMainloop { void* _unused; }

struct MaPaMainloopApi { void* _unused; }

struct MaPaContext { void* _unused; }

struct MaPaOperation { void* _unused; }

struct MaPaStream { void* _unused; }

struct MaPaSpawnApi { void* _unused; }

struct MaPaBufferAttr
{
	uint maxlength;
	uint tlength;
	uint prebuf;
	uint minreq;
	uint fragsize;
}

struct MaPaChannelMap
{
	char channels;
	MaPaChannelPositionT[32] map;
}

struct MaPaCvolume
{
	char channels;
	MaUint32[32] values;
}

struct MaPaSampleSpec
{
	int format;
	uint rate;
	char channels;
}

struct MaPaSinkInfo
{
	ZString name;
	uint index;
	ZString description;
	MaPaSampleSpec sample_spec;
	MaPaChannelMap channel_map;
	uint owner_module;
	MaPaCvolume volume;
	int mute;
	uint monitor_source;
	ZString monitor_source_name;
	ulong latency;
	ZString driver;
	int flags;
	void* proplist;
	ulong configured_latency;
	uint base_volume;
	int state;
	uint n_volume_steps;
	uint card;
	uint n_ports;
	void** ports;
	void* active_port;
	char n_formats;
	void** formats;
}

struct MaPaSourceInfo
{
	ZString name;
	uint index;
	ZString description;
	MaPaSampleSpec sample_spec;
	MaPaChannelMap channel_map;
	uint owner_module;
	MaPaCvolume volume;
	int mute;
	uint monitor_of_sink;
	ZString monitor_of_sink_name;
	ulong latency;
	ZString driver;
	int flags;
	void* proplist;
	ulong configured_latency;
	uint base_volume;
	int state;
	uint n_volume_steps;
	uint card;
	uint n_ports;
	void** ports;
	void* active_port;
	char n_formats;
	void** formats;
}

struct MaPulseDeviceEnumData
{
	uint count;
	uint capacity;
	MaDeviceInfo* p_info;
}

struct MaContextEnumerateDevicesCallbackDataPulse
{
	MaContext* p_context;
	MaEnumDevicesCallbackProc callback;
	void* p_user_data;
	uint is_terminated;
	uint default_device_index_playback;
	uint default_device_index_capture;
}

struct MaContextGetDeviceInfoCallbackDataPulse
{
	MaDeviceInfo* p_device_info;
	uint default_device_index;
	uint found_device;
}

struct MaJackClientT { void* _unused; }

struct MaJackPortT { void* _unused; }

struct MaBiquadHeapLayout
{
	usz size_in_bytes;
	usz r1_offset;
	usz r2_offset;
}

struct MaLpf1HeapLayout
{
	usz size_in_bytes;
	usz r1_offset;
}

struct MaLpfHeapLayout
{
	usz size_in_bytes;
	usz lpf1_offset;
	usz lpf2_offset;
}

struct MaHpf1HeapLayout
{
	usz size_in_bytes;
	usz r1_offset;
}

struct MaHpfHeapLayout
{
	usz size_in_bytes;
	usz hpf1_offset;
	usz hpf2_offset;
}

struct MaBpfHeapLayout
{
	usz size_in_bytes;
	usz bpf2_offset;
}

struct MaGainerHeapLayout
{
	usz size_in_bytes;
	usz old_gains_offset;
	usz new_gains_offset;
}

struct MaSpatializerListenerHeapLayout
{
	usz size_in_bytes;
	usz channel_map_out_offset;
}

struct MaSpatializerHeapLayout
{
	usz size_in_bytes;
	usz channel_map_in_offset;
	usz new_channel_gains_offset;
	usz gainer_offset;
}

struct MaLinearResamplerHeapLayout
{
	usz size_in_bytes;
	usz x0_offset;
	usz x1_offset;
	usz lpf_offset;
}

struct MaChannelConverterHeapLayout
{
	usz size_in_bytes;
	usz channel_map_in_offset;
	usz channel_map_out_offset;
	usz shuffle_table_offset;
	usz weights_offset;
}

struct MaDataConverterHeapLayout
{
	usz size_in_bytes;
	usz channel_converter_offset;
	usz resampler_offset;
}

struct MaDrWavChunkHeader
{
	void* id;
	ulong size_in_bytes;
	uint padding_size;
}

struct MaDrWavFmt
{
	ushort format_tag;
	ushort channels;
	uint sample_rate;
	uint avg_bytes_per_sec;
	ushort block_align;
	ushort bits_per_sample;
	ushort extended_size;
	ushort valid_bits_per_sample;
	uint channel_mask;
	MaUint8[16] sub_format;
}

struct MaDrWavMemoryStream
{
	MaUint8* data;
	usz data_size;
	usz current_read_pos;
}

struct MaDrWavMemoryStreamWrite
{
	void** pp_data;
	usz* p_data_size;
	usz data_size;
	usz data_capacity;
	usz current_write_pos;
}

struct MaDrWavDataFormat
{
	MaDrWavContainer container;
	uint format;
	uint channels;
	uint sample_rate;
	uint bits_per_sample;
}

struct MaDrWavSmplLoop
{
	uint cue_point_id;
	uint type;
	uint first_sample_offset;
	uint last_sample_offset;
	uint sample_fraction;
	uint play_count;
}

struct MaDrWavSmpl
{
	uint manufacturer_id;
	uint product_id;
	uint sample_period_nanoseconds;
	uint midi_unity_note;
	uint midi_pitch_fraction;
	uint smpte_format;
	uint smpte_offset;
	uint sample_loop_count;
	uint sampler_specific_data_size_in_bytes;
	MaDrWavSmplLoop* p_loops;
	MaUint8* p_sampler_specific_data;
}

struct MaDrWavInst
{
	ichar midi_unity_note;
	ichar fine_tune_cents;
	ichar gain_decibels;
	ichar low_note;
	ichar high_note;
	ichar low_velocity;
	ichar high_velocity;
}

struct MaDrWavCuePoint
{
	uint id;
	uint play_order_position;
	MaUint8[4] data_chunk_id;
	uint chunk_start;
	uint block_start;
	uint sample_offset;
}

struct MaDrWavCue
{
	uint cue_point_count;
	MaDrWavCuePoint* p_cue_points;
}

struct MaDrWavAcid
{
	uint flags;
	ushort midi_unity_note;
	ushort reserved1;
	float reserved2;
	uint num_beats;
	ushort meter_denominator;
	ushort meter_numerator;
	float tempo;
}

struct MaDrWavListLabelOrNote
{
	uint cue_point_id;
	uint string_length;
	char* p_string;
}

struct MaDrWavBext
{
	char* p_description;
	char* p_originator_name;
	char* p_originator_reference;
	char[10] p_origination_date;
	char[8] p_origination_time;
	ulong time_reference;
	ushort version;
	char* p_coding_history;
	uint coding_history_size;
	MaUint8* p_umid;
	ushort loudness_value;
	ushort loudness_range;
	ushort max_true_peak_level;
	ushort max_momentary_loudness;
	ushort max_short_term_loudness;
}

struct MaDrWavListInfoText
{
	uint string_length;
	char* p_string;
}

struct MaDrWavListLabelledCueRegion
{
	uint cue_point_id;
	uint sample_length;
	MaUint8[4] purpose_id;
	ushort country;
	ushort language;
	ushort dialect;
	ushort code_page;
	uint string_length;
	char* p_string;
}

struct MaDrWavUnknownMetadata
{
	MaUint8[4] id;
	MaDrWavMetadataLocation chunk_location;
	uint data_size_in_bytes;
	MaUint8* p_data;
}

struct MaDrWavMetadata
{
	MaDrWavMetadataType type;
	void* data;
}

struct MaDrWav
{
	MaDrWavReadProc on_read;
	MaDrWavWriteProc on_write;
	MaDrWavSeekProc on_seek;
	MaDrWavTellProc on_tell;
	void* p_user_data;
	MaAllocationCallbacks allocation_callbacks;
	MaDrWavContainer container;
	MaDrWavFmt fmt;
	uint sample_rate;
	ushort channels;
	ushort bits_per_sample;
	ushort translated_format_tag;
	ulong total_pcm_frame_count;
	ulong data_chunk_data_size;
	ulong data_chunk_data_pos;
	ulong bytes_remaining;
	ulong read_cursor_in_pcm_frames;
	ulong data_chunk_data_size_target_write;
	uint is_sequential_write;
	MaDrWavMetadata* p_metadata;
	uint metadata_count;
	MaDrWavMemoryStream memory_stream;
	MaDrWavMemoryStreamWrite memory_stream_write;
	void* msadpcm;
	void* ima;
	void* aiff;
}

struct MaDrFlacSeekpoint
{
	ulong first_pcm_frame;
	ulong flac_frame_offset;
	ushort pcm_frame_count;
}

struct MaDrFlacStreaminfo
{
	ushort min_block_size_in_pcm_frames;
	ushort max_block_size_in_pcm_frames;
	uint min_frame_size_in_pcm_frames;
	uint max_frame_size_in_pcm_frames;
	uint sample_rate;
	char channels;
	char bits_per_sample;
	ulong total_pcm_frame_count;
	MaUint8[16] md5;
}

struct MaDrFlacMetadata
{
	uint type;
	uint raw_data_size;
	ulong raw_data_offset;
	void* p_raw_data;
	void* data;
}

struct MaDrFlacMemoryStream
{
	MaUint8* data;
	usz data_size;
	usz current_read_pos;
}

struct MaDrFlacBs
{
	MaDrFlacReadProc on_read;
	MaDrFlacSeekProc on_seek;
	MaDrFlacTellProc on_tell;
	void* p_user_data;
	usz unaligned_byte_count;
	ulong unaligned_cache;
	uint next_l2_line;
	uint consumed_bits;
	MaDrFlacCacheT[512] cache_l2;
	ulong cache;
	ushort crc16;
	ulong crc16_cache;
	uint crc16_cache_ignored_bytes;
}

struct MaDrFlacSubframe
{
	char subframe_type;
	char wasted_bits_per_sample;
	char lpc_order;
	MaInt32* p_samples_s32;
}

struct MaDrFlacFrameHeader
{
	ulong pcm_frame_number;
	uint flac_frame_number;
	uint sample_rate;
	ushort block_size_in_pcm_frames;
	char channel_assignment;
	char bits_per_sample;
	char crc8;
}

struct MaDrFlacFrame
{
	MaDrFlacFrameHeader header;
	uint pcm_frames_remaining;
	MaDrFlacSubframe[8] subframes;
}

struct MaDrFlac
{
	MaDrFlacMetaProc on_meta;
	void* p_user_data_md;
	MaAllocationCallbacks allocation_callbacks;
	uint sample_rate;
	char channels;
	char bits_per_sample;
	ushort max_block_size_in_pcm_frames;
	ulong total_pcm_frame_count;
	MaDrFlacContainer container;
	uint seekpoint_count;
	MaDrFlacFrame current_flac_frame;
	ulong current_pcm_frame;
	ulong first_flac_frame_pos_in_bytes;
	MaDrFlacMemoryStream memory_stream;
	MaInt32* p_decoded_samples;
	MaDrFlacSeekpoint* p_seekpoints;
	void* _oggbs;
	uint _no_seek_table_seek;
	uint _no_binary_search_seek;
	uint _no_brute_force_seek;
	MaDrFlacBs bs;
	MaUint8[1] p_extra_data;
}

struct MaDrFlacVorbisCommentIterator
{
	uint count_remaining;
	ZString p_running_data;
}

struct MaDrFlacCuesheetTrackIterator
{
	uint count_remaining;
	ZString p_running_data;
}

struct MaDrFlacCuesheetTrackIndex
{
	ulong offset;
	char index;
	MaUint8[3] reserved;
}

struct MaDrFlacCuesheetTrack
{
	ulong offset;
	char track_number;
	char[12] isrc;
	char is_audio;
	char pre_emphasis;
	char index_count;
	MaDrFlacCuesheetTrackIndex* p_index_points;
}

struct MaDrMp3decFrameInfo
{
	int frame_bytes;
	int channels;
	int sample_rate;
	int layer;
	int bitrate_kbps;
}

struct MaDrMp3Bs
{
	MaUint8* buf;
	int pos;
	int limit;
}

struct MaDrMp3L3GrInfo
{
	MaUint8* sfbtab;
	ushort part_23_length;
	ushort big_values;
	ushort scalefac_compress;
	char global_gain;
	char block_type;
	char mixed_block_flag;
	char n_long_sfb;
	char n_short_sfb;
	MaUint8[3] table_select;
	MaUint8[3] region_count;
	MaUint8[3] subblock_gain;
	char preflag;
	char scalefac_scale;
	char count1_table;
	char scfsi;
}

struct MaDrMp3decScratch
{
	MaDrMp3Bs bs;
	MaUint8[2815] maindata;
	MaDrMp3L3GrInfo[4] gr_info;
	float[2][576] grbuf;
	float[40] scf;
	float[33][64] syn;
	MaUint8[2][39] ist_pos;
}

struct MaDrMp3dec
{
	float[2][288] mdct_overlap;
	float[960] qmf_state;
	int reserv;
	int free_format_bytes;
	MaUint8[4] header;
	MaUint8[511] reserv_buf;
	MaDrMp3decScratch scratch;
}

struct MaDrMp3SeekPoint
{
	ulong seek_pos_in_bytes;
	ulong pcm_frame_index;
	ushort mp3_frames_to_discard;
	ushort pcm_frames_to_discard;
}

struct MaDrMp3Metadata
{
	MaDrMp3MetadataType type;
	void* p_raw_data;
	usz raw_data_size;
}

struct MaDrMp3Config
{
	uint channels;
	uint sample_rate;
}

struct MaDrMp3
{
	MaDrMp3dec decoder;
	uint channels;
	uint sample_rate;
	MaDrMp3ReadProc on_read;
	MaDrMp3SeekProc on_seek;
	MaDrMp3MetaProc on_meta;
	void* p_user_data;
	void* p_user_data_meta;
	MaAllocationCallbacks allocation_callbacks;
	uint mp3_frame_channels;
	uint mp3_frame_sample_rate;
	uint pcm_frames_consumed_in_mp3_frame;
	uint pcm_frames_remaining_in_mp3_frame;
	MaUint8[9216] pcm_frames;
	ulong current_pcm_frame;
	ulong stream_cursor;
	ulong stream_length;
	ulong stream_start_offset;
	MaDrMp3SeekPoint* p_seek_points;
	uint seek_point_count;
	uint delay_in_pcm_frames;
	uint padding_in_pcm_frames;
	ulong total_pcm_frame_count;
	uint is_vbr;
	uint is_cbr;
	usz data_size;
	usz data_capacity;
	usz data_consumed;
	MaUint8* p_data;
	uint at_end;
	void* memory;
}

struct MaWav
{
	MaDataSourceBase ds;
	MaReadProc on_read;
	MaSeekProc on_seek;
	MaTellProc on_tell;
	void* p_read_seek_tell_user_data;
	MaFormat format;
	MaDrWav dr;
}

struct MaFlac
{
	MaDataSourceBase ds;
	MaReadProc on_read;
	MaSeekProc on_seek;
	MaTellProc on_tell;
	void* p_read_seek_tell_user_data;
	MaFormat format;
	MaDrFlac* dr;
}

struct MaMp3
{
	MaDataSourceBase ds;
	MaReadProc on_read;
	MaSeekProc on_seek;
	MaTellProc on_tell;
	void* p_read_seek_tell_user_data;
	MaFormat format;
	MaDrMp3 dr;
	uint seek_point_count;
	MaDrMp3SeekPoint* p_seek_points;
}

struct MaNoiseHeapLayout
{
	usz size_in_bytes;
	void* pink;
	void* brownian;
}

struct MaResourceManagerInlineNotification
{
	void* backend;
	MaResourceManager* p_resource_manager;
}

struct MaNodeHeapLayout
{
	usz size_in_bytes;
	usz input_bus_offset;
	usz output_bus_offset;
	usz cached_data_offset;
	uint input_bus_count;
	uint output_bus_count;
}

struct MaEngineNodeHeapLayout
{
	usz size_in_bytes;
	usz base_node_offset;
	usz resampler_offset;
	usz spatializer_offset;
	usz gainer_offset;
}

struct MaDrWavMetadataParser
{
	MaDrWavReadProc on_read;
	MaDrWavSeekProc on_seek;
	void* p_read_seek_user_data;
	MaDrWavMetadataParserStage stage;
	MaDrWavMetadata* p_metadata;
	uint metadata_count;
	MaUint8* p_data;
	MaUint8* p_data_cursor;
	ulong metadata_cursor;
	ulong extra_capacity;
}

struct MaDrWavBufferReader
{
	void* p_buffer;
	usz size_in_bytes;
	usz cursor;
}

struct MaDrFlacOggPageHeader
{
	MaUint8[4] capture_pattern;
	char structure_version;
	char header_type;
	ulong granule_position;
	uint serial_number;
	uint sequence_number;
	uint checksum;
	char segment_count;
	MaUint8[255] segment_table;
}

struct MaDrFlacInitInfo
{
	MaDrFlacReadProc on_read;
	MaDrFlacSeekProc on_seek;
	MaDrFlacTellProc on_tell;
	MaDrFlacMetaProc on_meta;
	MaDrFlacContainer container;
	void* p_user_data;
	void* p_user_data_md;
	uint sample_rate;
	char channels;
	char bits_per_sample;
	ulong total_pcm_frame_count;
	ushort max_block_size_in_pcm_frames;
	ulong running_file_pos;
	uint has_stream_info_block;
	uint has_metadata_blocks;
	MaDrFlacBs bs;
	MaDrFlacFrameHeader first_frame_header;
	uint ogg_serial;
	ulong ogg_first_byte_pos;
	MaDrFlacOggPageHeader ogg_bos_header;
}

struct MaDrFlacOggbs
{
	MaDrFlacReadProc on_read;
	MaDrFlacSeekProc on_seek;
	MaDrFlacTellProc on_tell;
	void* p_user_data;
	ulong current_byte_pos;
	ulong first_byte_pos;
	uint serial_number;
	MaDrFlacOggPageHeader bos_page_header;
	MaDrFlacOggPageHeader current_page_header;
	uint bytes_remaining_in_page;
	uint page_data_size;
	MaUint8[65307] page_data;
}

struct MaDrMp3L12ScaleInfo
{
	float[192] scf;
	char total_bands;
	char stereo_bands;
	MaUint8[64] bitalloc;
	MaUint8[64] scfcod;
}

struct MaDrMp3L12SubbandAlloc
{
	char tab_offset;
	char code_tab_width;
	char band_count;
}

struct MaDrMp3SeekingMp3FrameInfo
{
	ulong byte_pos;
	ulong pcm_frame_index;
}

struct Pollfd
{
	int fd;
	short events;
	short revents;
}

union PthreadMutexT
{
	char[40] data;
	ulong alignment;
}

union PthreadCondT
{
	char[48] data;
	ulong alignment;
}

struct IoFile { void* _unused; }

// Functions
extern fn void version(MaUint32* p_major, MaUint32* p_minor, MaUint32* p_revision) @cname("ma_version");
extern fn ZString version_string() @cname("ma_version_string");
extern fn MaLogCallback log_callback_init(MaLogCallbackProc on_log, void* p_user_data) @cname("ma_log_callback_init");
extern fn MaResult log_init(MaAllocationCallbacks* p_allocation_callbacks, MaLog* p_log) @cname("ma_log_init");
extern fn void log_uninit(MaLog* p_log) @cname("ma_log_uninit");
extern fn MaResult log_register_callback(MaLog* p_log, MaLogCallback callback) @cname("ma_log_register_callback");
extern fn MaResult log_unregister_callback(MaLog* p_log, MaLogCallback callback) @cname("ma_log_unregister_callback");
extern fn MaResult log_post(MaLog* p_log, uint level, ZString p_message) @cname("ma_log_post");
extern fn MaResult log_postv(MaLog* p_log, uint level, ZString p_format, CVaList* args) @cname("ma_log_postv");
extern fn MaResult log_postf(MaLog* p_log, uint level, ZString p_format, ...) @cname("ma_log_postf");
extern fn MaBiquadConfig biquad_config_init(MaFormat format, uint channels, double b0, double b1, double b2, double a0, double a1, double a2) @cname("ma_biquad_config_init");
extern fn MaResult biquad_get_heap_size(MaBiquadConfig* p_config, usz* p_heap_size_in_bytes) @cname("ma_biquad_get_heap_size");
extern fn MaResult biquad_init_preallocated(MaBiquadConfig* p_config, void* p_heap, MaBiquad* p_bq) @cname("ma_biquad_init_preallocated");
extern fn MaResult biquad_init(MaBiquadConfig* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaBiquad* p_bq) @cname("ma_biquad_init");
extern fn void biquad_uninit(MaBiquad* p_bq, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_biquad_uninit");
extern fn MaResult biquad_reinit(MaBiquadConfig* p_config, MaBiquad* p_bq) @cname("ma_biquad_reinit");
extern fn MaResult biquad_clear_cache(MaBiquad* p_bq) @cname("ma_biquad_clear_cache");
extern fn MaResult biquad_process_pcm_frames(MaBiquad* p_bq, void* p_frames_out, void* p_frames_in, ulong frame_count) @cname("ma_biquad_process_pcm_frames");
extern fn MaUint32 biquad_get_latency(MaBiquad* p_bq) @cname("ma_biquad_get_latency");
extern fn MaLpf1Config lpf1_config_init(MaFormat format, uint channels, uint sample_rate, double cutoff_frequency) @cname("ma_lpf1_config_init");
extern fn MaLpf2Config lpf2_config_init(MaFormat format, uint channels, uint sample_rate, double cutoff_frequency, double q) @cname("ma_lpf2_config_init");
extern fn MaResult lpf1_get_heap_size(MaLpf1Config* p_config, usz* p_heap_size_in_bytes) @cname("ma_lpf1_get_heap_size");
extern fn MaResult lpf1_init_preallocated(MaLpf1Config* p_config, void* p_heap, MaLpf1* p_lpf) @cname("ma_lpf1_init_preallocated");
extern fn MaResult lpf1_init(MaLpf1Config* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaLpf1* p_lpf) @cname("ma_lpf1_init");
extern fn void lpf1_uninit(MaLpf1* p_lpf, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_lpf1_uninit");
extern fn MaResult lpf1_reinit(MaLpf1Config* p_config, MaLpf1* p_lpf) @cname("ma_lpf1_reinit");
extern fn MaResult lpf1_clear_cache(MaLpf1* p_lpf) @cname("ma_lpf1_clear_cache");
extern fn MaResult lpf1_process_pcm_frames(MaLpf1* p_lpf, void* p_frames_out, void* p_frames_in, ulong frame_count) @cname("ma_lpf1_process_pcm_frames");
extern fn MaUint32 lpf1_get_latency(MaLpf1* p_lpf) @cname("ma_lpf1_get_latency");
extern fn MaResult lpf2_get_heap_size(MaLpf2Config* p_config, usz* p_heap_size_in_bytes) @cname("ma_lpf2_get_heap_size");
extern fn MaResult lpf2_init_preallocated(MaLpf2Config* p_config, void* p_heap, MaLpf2* p_hpf) @cname("ma_lpf2_init_preallocated");
extern fn MaResult lpf2_init(MaLpf2Config* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaLpf2* p_lpf) @cname("ma_lpf2_init");
extern fn void lpf2_uninit(MaLpf2* p_lpf, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_lpf2_uninit");
extern fn MaResult lpf2_reinit(MaLpf2Config* p_config, MaLpf2* p_lpf) @cname("ma_lpf2_reinit");
extern fn MaResult lpf2_clear_cache(MaLpf2* p_lpf) @cname("ma_lpf2_clear_cache");
extern fn MaResult lpf2_process_pcm_frames(MaLpf2* p_lpf, void* p_frames_out, void* p_frames_in, ulong frame_count) @cname("ma_lpf2_process_pcm_frames");
extern fn MaUint32 lpf2_get_latency(MaLpf2* p_lpf) @cname("ma_lpf2_get_latency");
extern fn MaLpfConfig lpf_config_init(MaFormat format, uint channels, uint sample_rate, double cutoff_frequency, uint order) @cname("ma_lpf_config_init");
extern fn MaResult lpf_get_heap_size(MaLpfConfig* p_config, usz* p_heap_size_in_bytes) @cname("ma_lpf_get_heap_size");
extern fn MaResult lpf_init_preallocated(MaLpfConfig* p_config, void* p_heap, MaLpf* p_lpf) @cname("ma_lpf_init_preallocated");
extern fn MaResult lpf_init(MaLpfConfig* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaLpf* p_lpf) @cname("ma_lpf_init");
extern fn void lpf_uninit(MaLpf* p_lpf, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_lpf_uninit");
extern fn MaResult lpf_reinit(MaLpfConfig* p_config, MaLpf* p_lpf) @cname("ma_lpf_reinit");
extern fn MaResult lpf_clear_cache(MaLpf* p_lpf) @cname("ma_lpf_clear_cache");
extern fn MaResult lpf_process_pcm_frames(MaLpf* p_lpf, void* p_frames_out, void* p_frames_in, ulong frame_count) @cname("ma_lpf_process_pcm_frames");
extern fn MaUint32 lpf_get_latency(MaLpf* p_lpf) @cname("ma_lpf_get_latency");
extern fn MaHpf1Config hpf1_config_init(MaFormat format, uint channels, uint sample_rate, double cutoff_frequency) @cname("ma_hpf1_config_init");
extern fn MaHpf2Config hpf2_config_init(MaFormat format, uint channels, uint sample_rate, double cutoff_frequency, double q) @cname("ma_hpf2_config_init");
extern fn MaResult hpf1_get_heap_size(MaHpf1Config* p_config, usz* p_heap_size_in_bytes) @cname("ma_hpf1_get_heap_size");
extern fn MaResult hpf1_init_preallocated(MaHpf1Config* p_config, void* p_heap, MaHpf1* p_lpf) @cname("ma_hpf1_init_preallocated");
extern fn MaResult hpf1_init(MaHpf1Config* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaHpf1* p_hpf) @cname("ma_hpf1_init");
extern fn void hpf1_uninit(MaHpf1* p_hpf, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_hpf1_uninit");
extern fn MaResult hpf1_reinit(MaHpf1Config* p_config, MaHpf1* p_hpf) @cname("ma_hpf1_reinit");
extern fn MaResult hpf1_process_pcm_frames(MaHpf1* p_hpf, void* p_frames_out, void* p_frames_in, ulong frame_count) @cname("ma_hpf1_process_pcm_frames");
extern fn MaUint32 hpf1_get_latency(MaHpf1* p_hpf) @cname("ma_hpf1_get_latency");
extern fn MaResult hpf2_get_heap_size(MaHpf2Config* p_config, usz* p_heap_size_in_bytes) @cname("ma_hpf2_get_heap_size");
extern fn MaResult hpf2_init_preallocated(MaHpf2Config* p_config, void* p_heap, MaHpf2* p_hpf) @cname("ma_hpf2_init_preallocated");
extern fn MaResult hpf2_init(MaHpf2Config* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaHpf2* p_hpf) @cname("ma_hpf2_init");
extern fn void hpf2_uninit(MaHpf2* p_hpf, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_hpf2_uninit");
extern fn MaResult hpf2_reinit(MaHpf2Config* p_config, MaHpf2* p_hpf) @cname("ma_hpf2_reinit");
extern fn MaResult hpf2_process_pcm_frames(MaHpf2* p_hpf, void* p_frames_out, void* p_frames_in, ulong frame_count) @cname("ma_hpf2_process_pcm_frames");
extern fn MaUint32 hpf2_get_latency(MaHpf2* p_hpf) @cname("ma_hpf2_get_latency");
extern fn MaHpfConfig hpf_config_init(MaFormat format, uint channels, uint sample_rate, double cutoff_frequency, uint order) @cname("ma_hpf_config_init");
extern fn MaResult hpf_get_heap_size(MaHpfConfig* p_config, usz* p_heap_size_in_bytes) @cname("ma_hpf_get_heap_size");
extern fn MaResult hpf_init_preallocated(MaHpfConfig* p_config, void* p_heap, MaHpf* p_lpf) @cname("ma_hpf_init_preallocated");
extern fn MaResult hpf_init(MaHpfConfig* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaHpf* p_hpf) @cname("ma_hpf_init");
extern fn void hpf_uninit(MaHpf* p_hpf, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_hpf_uninit");
extern fn MaResult hpf_reinit(MaHpfConfig* p_config, MaHpf* p_hpf) @cname("ma_hpf_reinit");
extern fn MaResult hpf_process_pcm_frames(MaHpf* p_hpf, void* p_frames_out, void* p_frames_in, ulong frame_count) @cname("ma_hpf_process_pcm_frames");
extern fn MaUint32 hpf_get_latency(MaHpf* p_hpf) @cname("ma_hpf_get_latency");
extern fn MaBpf2Config bpf2_config_init(MaFormat format, uint channels, uint sample_rate, double cutoff_frequency, double q) @cname("ma_bpf2_config_init");
extern fn MaResult bpf2_get_heap_size(MaBpf2Config* p_config, usz* p_heap_size_in_bytes) @cname("ma_bpf2_get_heap_size");
extern fn MaResult bpf2_init_preallocated(MaBpf2Config* p_config, void* p_heap, MaBpf2* p_bpf) @cname("ma_bpf2_init_preallocated");
extern fn MaResult bpf2_init(MaBpf2Config* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaBpf2* p_bpf) @cname("ma_bpf2_init");
extern fn void bpf2_uninit(MaBpf2* p_bpf, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_bpf2_uninit");
extern fn MaResult bpf2_reinit(MaBpf2Config* p_config, MaBpf2* p_bpf) @cname("ma_bpf2_reinit");
extern fn MaResult bpf2_process_pcm_frames(MaBpf2* p_bpf, void* p_frames_out, void* p_frames_in, ulong frame_count) @cname("ma_bpf2_process_pcm_frames");
extern fn MaUint32 bpf2_get_latency(MaBpf2* p_bpf) @cname("ma_bpf2_get_latency");
extern fn MaBpfConfig bpf_config_init(MaFormat format, uint channels, uint sample_rate, double cutoff_frequency, uint order) @cname("ma_bpf_config_init");
extern fn MaResult bpf_get_heap_size(MaBpfConfig* p_config, usz* p_heap_size_in_bytes) @cname("ma_bpf_get_heap_size");
extern fn MaResult bpf_init_preallocated(MaBpfConfig* p_config, void* p_heap, MaBpf* p_bpf) @cname("ma_bpf_init_preallocated");
extern fn MaResult bpf_init(MaBpfConfig* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaBpf* p_bpf) @cname("ma_bpf_init");
extern fn void bpf_uninit(MaBpf* p_bpf, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_bpf_uninit");
extern fn MaResult bpf_reinit(MaBpfConfig* p_config, MaBpf* p_bpf) @cname("ma_bpf_reinit");
extern fn MaResult bpf_process_pcm_frames(MaBpf* p_bpf, void* p_frames_out, void* p_frames_in, ulong frame_count) @cname("ma_bpf_process_pcm_frames");
extern fn MaUint32 bpf_get_latency(MaBpf* p_bpf) @cname("ma_bpf_get_latency");
extern fn MaNotch2Config notch2_config_init(MaFormat format, uint channels, uint sample_rate, double q, double frequency) @cname("ma_notch2_config_init");
extern fn MaResult notch2_get_heap_size(MaNotch2Config* p_config, usz* p_heap_size_in_bytes) @cname("ma_notch2_get_heap_size");
extern fn MaResult notch2_init_preallocated(MaNotch2Config* p_config, void* p_heap, MaNotch2* p_filter) @cname("ma_notch2_init_preallocated");
extern fn MaResult notch2_init(MaNotch2Config* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaNotch2* p_filter) @cname("ma_notch2_init");
extern fn void notch2_uninit(MaNotch2* p_filter, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_notch2_uninit");
extern fn MaResult notch2_reinit(MaNotch2Config* p_config, MaNotch2* p_filter) @cname("ma_notch2_reinit");
extern fn MaResult notch2_process_pcm_frames(MaNotch2* p_filter, void* p_frames_out, void* p_frames_in, ulong frame_count) @cname("ma_notch2_process_pcm_frames");
extern fn MaUint32 notch2_get_latency(MaNotch2* p_filter) @cname("ma_notch2_get_latency");
extern fn MaPeak2Config peak2_config_init(MaFormat format, uint channels, uint sample_rate, double gain_db, double q, double frequency) @cname("ma_peak2_config_init");
extern fn MaResult peak2_get_heap_size(MaPeak2Config* p_config, usz* p_heap_size_in_bytes) @cname("ma_peak2_get_heap_size");
extern fn MaResult peak2_init_preallocated(MaPeak2Config* p_config, void* p_heap, MaPeak2* p_filter) @cname("ma_peak2_init_preallocated");
extern fn MaResult peak2_init(MaPeak2Config* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaPeak2* p_filter) @cname("ma_peak2_init");
extern fn void peak2_uninit(MaPeak2* p_filter, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_peak2_uninit");
extern fn MaResult peak2_reinit(MaPeak2Config* p_config, MaPeak2* p_filter) @cname("ma_peak2_reinit");
extern fn MaResult peak2_process_pcm_frames(MaPeak2* p_filter, void* p_frames_out, void* p_frames_in, ulong frame_count) @cname("ma_peak2_process_pcm_frames");
extern fn MaUint32 peak2_get_latency(MaPeak2* p_filter) @cname("ma_peak2_get_latency");
extern fn MaLoshelf2Config loshelf2_config_init(MaFormat format, uint channels, uint sample_rate, double gain_db, double shelf_slope, double frequency) @cname("ma_loshelf2_config_init");
extern fn MaResult loshelf2_get_heap_size(MaLoshelf2Config* p_config, usz* p_heap_size_in_bytes) @cname("ma_loshelf2_get_heap_size");
extern fn MaResult loshelf2_init_preallocated(MaLoshelf2Config* p_config, void* p_heap, MaLoshelf2* p_filter) @cname("ma_loshelf2_init_preallocated");
extern fn MaResult loshelf2_init(MaLoshelf2Config* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaLoshelf2* p_filter) @cname("ma_loshelf2_init");
extern fn void loshelf2_uninit(MaLoshelf2* p_filter, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_loshelf2_uninit");
extern fn MaResult loshelf2_reinit(MaLoshelf2Config* p_config, MaLoshelf2* p_filter) @cname("ma_loshelf2_reinit");
extern fn MaResult loshelf2_process_pcm_frames(MaLoshelf2* p_filter, void* p_frames_out, void* p_frames_in, ulong frame_count) @cname("ma_loshelf2_process_pcm_frames");
extern fn MaUint32 loshelf2_get_latency(MaLoshelf2* p_filter) @cname("ma_loshelf2_get_latency");
extern fn MaHishelf2Config hishelf2_config_init(MaFormat format, uint channels, uint sample_rate, double gain_db, double shelf_slope, double frequency) @cname("ma_hishelf2_config_init");
extern fn MaResult hishelf2_get_heap_size(MaHishelf2Config* p_config, usz* p_heap_size_in_bytes) @cname("ma_hishelf2_get_heap_size");
extern fn MaResult hishelf2_init_preallocated(MaHishelf2Config* p_config, void* p_heap, MaHishelf2* p_filter) @cname("ma_hishelf2_init_preallocated");
extern fn MaResult hishelf2_init(MaHishelf2Config* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaHishelf2* p_filter) @cname("ma_hishelf2_init");
extern fn void hishelf2_uninit(MaHishelf2* p_filter, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_hishelf2_uninit");
extern fn MaResult hishelf2_reinit(MaHishelf2Config* p_config, MaHishelf2* p_filter) @cname("ma_hishelf2_reinit");
extern fn MaResult hishelf2_process_pcm_frames(MaHishelf2* p_filter, void* p_frames_out, void* p_frames_in, ulong frame_count) @cname("ma_hishelf2_process_pcm_frames");
extern fn MaUint32 hishelf2_get_latency(MaHishelf2* p_filter) @cname("ma_hishelf2_get_latency");
extern fn MaDelayConfig delay_config_init(uint channels, uint sample_rate, uint delay_in_frames, float decay) @cname("ma_delay_config_init");
extern fn MaResult delay_init(MaDelayConfig* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaDelay* p_delay) @cname("ma_delay_init");
extern fn void delay_uninit(MaDelay* p_delay, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_delay_uninit");
extern fn MaResult delay_process_pcm_frames(MaDelay* p_delay, void* p_frames_out, void* p_frames_in, uint frame_count) @cname("ma_delay_process_pcm_frames");
extern fn void delay_set_wet(MaDelay* p_delay, float value) @cname("ma_delay_set_wet");
extern fn float delay_get_wet(MaDelay* p_delay) @cname("ma_delay_get_wet");
extern fn void delay_set_dry(MaDelay* p_delay, float value) @cname("ma_delay_set_dry");
extern fn float delay_get_dry(MaDelay* p_delay) @cname("ma_delay_get_dry");
extern fn void delay_set_decay(MaDelay* p_delay, float value) @cname("ma_delay_set_decay");
extern fn float delay_get_decay(MaDelay* p_delay) @cname("ma_delay_get_decay");
extern fn MaGainerConfig gainer_config_init(uint channels, uint smooth_time_in_frames) @cname("ma_gainer_config_init");
extern fn MaResult gainer_get_heap_size(MaGainerConfig* p_config, usz* p_heap_size_in_bytes) @cname("ma_gainer_get_heap_size");
extern fn MaResult gainer_init_preallocated(MaGainerConfig* p_config, void* p_heap, MaGainer* p_gainer) @cname("ma_gainer_init_preallocated");
extern fn MaResult gainer_init(MaGainerConfig* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaGainer* p_gainer) @cname("ma_gainer_init");
extern fn void gainer_uninit(MaGainer* p_gainer, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_gainer_uninit");
extern fn MaResult gainer_process_pcm_frames(MaGainer* p_gainer, void* p_frames_out, void* p_frames_in, ulong frame_count) @cname("ma_gainer_process_pcm_frames");
extern fn MaResult gainer_set_gain(MaGainer* p_gainer, float new_gain) @cname("ma_gainer_set_gain");
extern fn MaResult gainer_set_gains(MaGainer* p_gainer, float* p_new_gains) @cname("ma_gainer_set_gains");
extern fn MaResult gainer_set_master_volume(MaGainer* p_gainer, float volume) @cname("ma_gainer_set_master_volume");
extern fn MaResult gainer_get_master_volume(MaGainer* p_gainer, float* p_volume) @cname("ma_gainer_get_master_volume");
extern fn MaPannerConfig panner_config_init(MaFormat format, uint channels) @cname("ma_panner_config_init");
extern fn MaResult panner_init(MaPannerConfig* p_config, MaPanner* p_panner) @cname("ma_panner_init");
extern fn MaResult panner_process_pcm_frames(MaPanner* p_panner, void* p_frames_out, void* p_frames_in, ulong frame_count) @cname("ma_panner_process_pcm_frames");
extern fn void panner_set_mode(MaPanner* p_panner, MaPanMode mode) @cname("ma_panner_set_mode");
extern fn MaPanMode panner_get_mode(MaPanner* p_panner) @cname("ma_panner_get_mode");
extern fn void panner_set_pan(MaPanner* p_panner, float pan) @cname("ma_panner_set_pan");
extern fn float panner_get_pan(MaPanner* p_panner) @cname("ma_panner_get_pan");
extern fn MaFaderConfig fader_config_init(MaFormat format, uint channels, uint sample_rate) @cname("ma_fader_config_init");
extern fn MaResult fader_init(MaFaderConfig* p_config, MaFader* p_fader) @cname("ma_fader_init");
extern fn MaResult fader_process_pcm_frames(MaFader* p_fader, void* p_frames_out, void* p_frames_in, ulong frame_count) @cname("ma_fader_process_pcm_frames");
extern fn void fader_get_data_format(MaFader* p_fader, MaFormat* p_format, MaUint32* p_channels, MaUint32* p_sample_rate) @cname("ma_fader_get_data_format");
extern fn void fader_set_fade(MaFader* p_fader, float volume_beg, float volume_end, ulong length_in_frames) @cname("ma_fader_set_fade");
extern fn void fader_set_fade_ex(MaFader* p_fader, float volume_beg, float volume_end, ulong length_in_frames, long start_offset_in_frames) @cname("ma_fader_set_fade_ex");
extern fn float fader_get_current_volume(MaFader* p_fader) @cname("ma_fader_get_current_volume");
extern fn MaSpatializerListenerConfig spatializer_listener_config_init(uint channels_out) @cname("ma_spatializer_listener_config_init");
extern fn MaResult spatializer_listener_get_heap_size(MaSpatializerListenerConfig* p_config, usz* p_heap_size_in_bytes) @cname("ma_spatializer_listener_get_heap_size");
extern fn MaResult spatializer_listener_init_preallocated(MaSpatializerListenerConfig* p_config, void* p_heap, MaSpatializerListener* p_listener) @cname("ma_spatializer_listener_init_preallocated");
extern fn MaResult spatializer_listener_init(MaSpatializerListenerConfig* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaSpatializerListener* p_listener) @cname("ma_spatializer_listener_init");
extern fn void spatializer_listener_uninit(MaSpatializerListener* p_listener, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_spatializer_listener_uninit");
extern fn MaChannel* spatializer_listener_get_channel_map(MaSpatializerListener* p_listener) @cname("ma_spatializer_listener_get_channel_map");
extern fn void spatializer_listener_set_cone(MaSpatializerListener* p_listener, float inner_angle_in_radians, float outer_angle_in_radians, float outer_gain) @cname("ma_spatializer_listener_set_cone");
extern fn void spatializer_listener_get_cone(MaSpatializerListener* p_listener, float* p_inner_angle_in_radians, float* p_outer_angle_in_radians, float* p_outer_gain) @cname("ma_spatializer_listener_get_cone");
extern fn void spatializer_listener_set_position(MaSpatializerListener* p_listener, float x, float y, float z) @cname("ma_spatializer_listener_set_position");
extern fn MaVec3f spatializer_listener_get_position(MaSpatializerListener* p_listener) @cname("ma_spatializer_listener_get_position");
extern fn void spatializer_listener_set_direction(MaSpatializerListener* p_listener, float x, float y, float z) @cname("ma_spatializer_listener_set_direction");
extern fn MaVec3f spatializer_listener_get_direction(MaSpatializerListener* p_listener) @cname("ma_spatializer_listener_get_direction");
extern fn void spatializer_listener_set_velocity(MaSpatializerListener* p_listener, float x, float y, float z) @cname("ma_spatializer_listener_set_velocity");
extern fn MaVec3f spatializer_listener_get_velocity(MaSpatializerListener* p_listener) @cname("ma_spatializer_listener_get_velocity");
extern fn void spatializer_listener_set_speed_of_sound(MaSpatializerListener* p_listener, float speed_of_sound) @cname("ma_spatializer_listener_set_speed_of_sound");
extern fn float spatializer_listener_get_speed_of_sound(MaSpatializerListener* p_listener) @cname("ma_spatializer_listener_get_speed_of_sound");
extern fn void spatializer_listener_set_world_up(MaSpatializerListener* p_listener, float x, float y, float z) @cname("ma_spatializer_listener_set_world_up");
extern fn MaVec3f spatializer_listener_get_world_up(MaSpatializerListener* p_listener) @cname("ma_spatializer_listener_get_world_up");
extern fn void spatializer_listener_set_enabled(MaSpatializerListener* p_listener, uint is_enabled) @cname("ma_spatializer_listener_set_enabled");
extern fn MaBool32 spatializer_listener_is_enabled(MaSpatializerListener* p_listener) @cname("ma_spatializer_listener_is_enabled");
extern fn MaSpatializerConfig spatializer_config_init(uint channels_in, uint channels_out) @cname("ma_spatializer_config_init");
extern fn MaResult spatializer_get_heap_size(MaSpatializerConfig* p_config, usz* p_heap_size_in_bytes) @cname("ma_spatializer_get_heap_size");
extern fn MaResult spatializer_init_preallocated(MaSpatializerConfig* p_config, void* p_heap, MaSpatializer* p_spatializer) @cname("ma_spatializer_init_preallocated");
extern fn MaResult spatializer_init(MaSpatializerConfig* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaSpatializer* p_spatializer) @cname("ma_spatializer_init");
extern fn void spatializer_uninit(MaSpatializer* p_spatializer, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_spatializer_uninit");
extern fn MaResult spatializer_process_pcm_frames(MaSpatializer* p_spatializer, MaSpatializerListener* p_listener, void* p_frames_out, void* p_frames_in, ulong frame_count) @cname("ma_spatializer_process_pcm_frames");
extern fn MaResult spatializer_set_master_volume(MaSpatializer* p_spatializer, float volume) @cname("ma_spatializer_set_master_volume");
extern fn MaResult spatializer_get_master_volume(MaSpatializer* p_spatializer, float* p_volume) @cname("ma_spatializer_get_master_volume");
extern fn MaUint32 spatializer_get_input_channels(MaSpatializer* p_spatializer) @cname("ma_spatializer_get_input_channels");
extern fn MaUint32 spatializer_get_output_channels(MaSpatializer* p_spatializer) @cname("ma_spatializer_get_output_channels");
extern fn void spatializer_set_attenuation_model(MaSpatializer* p_spatializer, MaAttenuationModel attenuation_model) @cname("ma_spatializer_set_attenuation_model");
extern fn MaAttenuationModel spatializer_get_attenuation_model(MaSpatializer* p_spatializer) @cname("ma_spatializer_get_attenuation_model");
extern fn void spatializer_set_positioning(MaSpatializer* p_spatializer, MaPositioning positioning) @cname("ma_spatializer_set_positioning");
extern fn MaPositioning spatializer_get_positioning(MaSpatializer* p_spatializer) @cname("ma_spatializer_get_positioning");
extern fn void spatializer_set_rolloff(MaSpatializer* p_spatializer, float rolloff) @cname("ma_spatializer_set_rolloff");
extern fn float spatializer_get_rolloff(MaSpatializer* p_spatializer) @cname("ma_spatializer_get_rolloff");
extern fn void spatializer_set_min_gain(MaSpatializer* p_spatializer, float min_gain) @cname("ma_spatializer_set_min_gain");
extern fn float spatializer_get_min_gain(MaSpatializer* p_spatializer) @cname("ma_spatializer_get_min_gain");
extern fn void spatializer_set_max_gain(MaSpatializer* p_spatializer, float max_gain) @cname("ma_spatializer_set_max_gain");
extern fn float spatializer_get_max_gain(MaSpatializer* p_spatializer) @cname("ma_spatializer_get_max_gain");
extern fn void spatializer_set_min_distance(MaSpatializer* p_spatializer, float min_distance) @cname("ma_spatializer_set_min_distance");
extern fn float spatializer_get_min_distance(MaSpatializer* p_spatializer) @cname("ma_spatializer_get_min_distance");
extern fn void spatializer_set_max_distance(MaSpatializer* p_spatializer, float max_distance) @cname("ma_spatializer_set_max_distance");
extern fn float spatializer_get_max_distance(MaSpatializer* p_spatializer) @cname("ma_spatializer_get_max_distance");
extern fn void spatializer_set_cone(MaSpatializer* p_spatializer, float inner_angle_in_radians, float outer_angle_in_radians, float outer_gain) @cname("ma_spatializer_set_cone");
extern fn void spatializer_get_cone(MaSpatializer* p_spatializer, float* p_inner_angle_in_radians, float* p_outer_angle_in_radians, float* p_outer_gain) @cname("ma_spatializer_get_cone");
extern fn void spatializer_set_doppler_factor(MaSpatializer* p_spatializer, float doppler_factor) @cname("ma_spatializer_set_doppler_factor");
extern fn float spatializer_get_doppler_factor(MaSpatializer* p_spatializer) @cname("ma_spatializer_get_doppler_factor");
extern fn void spatializer_set_directional_attenuation_factor(MaSpatializer* p_spatializer, float directional_attenuation_factor) @cname("ma_spatializer_set_directional_attenuation_factor");
extern fn float spatializer_get_directional_attenuation_factor(MaSpatializer* p_spatializer) @cname("ma_spatializer_get_directional_attenuation_factor");
extern fn void spatializer_set_position(MaSpatializer* p_spatializer, float x, float y, float z) @cname("ma_spatializer_set_position");
extern fn MaVec3f spatializer_get_position(MaSpatializer* p_spatializer) @cname("ma_spatializer_get_position");
extern fn void spatializer_set_direction(MaSpatializer* p_spatializer, float x, float y, float z) @cname("ma_spatializer_set_direction");
extern fn MaVec3f spatializer_get_direction(MaSpatializer* p_spatializer) @cname("ma_spatializer_get_direction");
extern fn void spatializer_set_velocity(MaSpatializer* p_spatializer, float x, float y, float z) @cname("ma_spatializer_set_velocity");
extern fn MaVec3f spatializer_get_velocity(MaSpatializer* p_spatializer) @cname("ma_spatializer_get_velocity");
extern fn void spatializer_get_relative_position_and_direction(MaSpatializer* p_spatializer, MaSpatializerListener* p_listener, MaVec3f* p_relative_pos, MaVec3f* p_relative_dir) @cname("ma_spatializer_get_relative_position_and_direction");
extern fn MaLinearResamplerConfig linear_resampler_config_init(MaFormat format, uint channels, uint sample_rate_in, uint sample_rate_out) @cname("ma_linear_resampler_config_init");
extern fn MaResult linear_resampler_get_heap_size(MaLinearResamplerConfig* p_config, usz* p_heap_size_in_bytes) @cname("ma_linear_resampler_get_heap_size");
extern fn MaResult linear_resampler_init_preallocated(MaLinearResamplerConfig* p_config, void* p_heap, MaLinearResampler* p_resampler) @cname("ma_linear_resampler_init_preallocated");
extern fn MaResult linear_resampler_init(MaLinearResamplerConfig* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaLinearResampler* p_resampler) @cname("ma_linear_resampler_init");
extern fn void linear_resampler_uninit(MaLinearResampler* p_resampler, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_linear_resampler_uninit");
extern fn MaResult linear_resampler_process_pcm_frames(MaLinearResampler* p_resampler, void* p_frames_in, MaUint64* p_frame_count_in, void* p_frames_out, MaUint64* p_frame_count_out) @cname("ma_linear_resampler_process_pcm_frames");
extern fn MaResult linear_resampler_set_rate(MaLinearResampler* p_resampler, uint sample_rate_in, uint sample_rate_out) @cname("ma_linear_resampler_set_rate");
extern fn MaResult linear_resampler_set_rate_ratio(MaLinearResampler* p_resampler, float ratio_in_out) @cname("ma_linear_resampler_set_rate_ratio");
extern fn MaUint64 linear_resampler_get_input_latency(MaLinearResampler* p_resampler) @cname("ma_linear_resampler_get_input_latency");
extern fn MaUint64 linear_resampler_get_output_latency(MaLinearResampler* p_resampler) @cname("ma_linear_resampler_get_output_latency");
extern fn MaResult linear_resampler_get_required_input_frame_count(MaLinearResampler* p_resampler, ulong output_frame_count, MaUint64* p_input_frame_count) @cname("ma_linear_resampler_get_required_input_frame_count");
extern fn MaResult linear_resampler_get_expected_output_frame_count(MaLinearResampler* p_resampler, ulong input_frame_count, MaUint64* p_output_frame_count) @cname("ma_linear_resampler_get_expected_output_frame_count");
extern fn MaResult linear_resampler_reset(MaLinearResampler* p_resampler) @cname("ma_linear_resampler_reset");
extern fn MaResamplerConfig resampler_config_init(MaFormat format, uint channels, uint sample_rate_in, uint sample_rate_out, MaResampleAlgorithm algorithm) @cname("ma_resampler_config_init");
extern fn MaResult resampler_get_heap_size(MaResamplerConfig* p_config, usz* p_heap_size_in_bytes) @cname("ma_resampler_get_heap_size");
extern fn MaResult resampler_init_preallocated(MaResamplerConfig* p_config, void* p_heap, MaResampler* p_resampler) @cname("ma_resampler_init_preallocated");
extern fn MaResult resampler_init(MaResamplerConfig* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaResampler* p_resampler) @cname("ma_resampler_init");
extern fn void resampler_uninit(MaResampler* p_resampler, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_resampler_uninit");
extern fn MaResult resampler_process_pcm_frames(MaResampler* p_resampler, void* p_frames_in, MaUint64* p_frame_count_in, void* p_frames_out, MaUint64* p_frame_count_out) @cname("ma_resampler_process_pcm_frames");
extern fn MaResult resampler_set_rate(MaResampler* p_resampler, uint sample_rate_in, uint sample_rate_out) @cname("ma_resampler_set_rate");
extern fn MaResult resampler_set_rate_ratio(MaResampler* p_resampler, float ratio) @cname("ma_resampler_set_rate_ratio");
extern fn MaUint64 resampler_get_input_latency(MaResampler* p_resampler) @cname("ma_resampler_get_input_latency");
extern fn MaUint64 resampler_get_output_latency(MaResampler* p_resampler) @cname("ma_resampler_get_output_latency");
extern fn MaResult resampler_get_required_input_frame_count(MaResampler* p_resampler, ulong output_frame_count, MaUint64* p_input_frame_count) @cname("ma_resampler_get_required_input_frame_count");
extern fn MaResult resampler_get_expected_output_frame_count(MaResampler* p_resampler, ulong input_frame_count, MaUint64* p_output_frame_count) @cname("ma_resampler_get_expected_output_frame_count");
extern fn MaResult resampler_reset(MaResampler* p_resampler) @cname("ma_resampler_reset");
extern fn MaChannelConverterConfig channel_converter_config_init(MaFormat format, uint channels_in, MaChannel* p_channel_map_in, uint channels_out, MaChannel* p_channel_map_out, MaChannelMixMode mixing_mode) @cname("ma_channel_converter_config_init");
extern fn MaResult channel_converter_get_heap_size(MaChannelConverterConfig* p_config, usz* p_heap_size_in_bytes) @cname("ma_channel_converter_get_heap_size");
extern fn MaResult channel_converter_init_preallocated(MaChannelConverterConfig* p_config, void* p_heap, MaChannelConverter* p_converter) @cname("ma_channel_converter_init_preallocated");
extern fn MaResult channel_converter_init(MaChannelConverterConfig* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaChannelConverter* p_converter) @cname("ma_channel_converter_init");
extern fn void channel_converter_uninit(MaChannelConverter* p_converter, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_channel_converter_uninit");
extern fn MaResult channel_converter_process_pcm_frames(MaChannelConverter* p_converter, void* p_frames_out, void* p_frames_in, ulong frame_count) @cname("ma_channel_converter_process_pcm_frames");
extern fn MaResult channel_converter_get_input_channel_map(MaChannelConverter* p_converter, MaChannel* p_channel_map, usz channel_map_cap) @cname("ma_channel_converter_get_input_channel_map");
extern fn MaResult channel_converter_get_output_channel_map(MaChannelConverter* p_converter, MaChannel* p_channel_map, usz channel_map_cap) @cname("ma_channel_converter_get_output_channel_map");
extern fn MaDataConverterConfig data_converter_config_init_default() @cname("ma_data_converter_config_init_default");
extern fn MaDataConverterConfig data_converter_config_init(MaFormat format_in, MaFormat format_out, uint channels_in, uint channels_out, uint sample_rate_in, uint sample_rate_out) @cname("ma_data_converter_config_init");
extern fn MaResult data_converter_get_heap_size(MaDataConverterConfig* p_config, usz* p_heap_size_in_bytes) @cname("ma_data_converter_get_heap_size");
extern fn MaResult data_converter_init_preallocated(MaDataConverterConfig* p_config, void* p_heap, MaDataConverter* p_converter) @cname("ma_data_converter_init_preallocated");
extern fn MaResult data_converter_init(MaDataConverterConfig* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaDataConverter* p_converter) @cname("ma_data_converter_init");
extern fn void data_converter_uninit(MaDataConverter* p_converter, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_data_converter_uninit");
extern fn MaResult data_converter_process_pcm_frames(MaDataConverter* p_converter, void* p_frames_in, MaUint64* p_frame_count_in, void* p_frames_out, MaUint64* p_frame_count_out) @cname("ma_data_converter_process_pcm_frames");
extern fn MaResult data_converter_set_rate(MaDataConverter* p_converter, uint sample_rate_in, uint sample_rate_out) @cname("ma_data_converter_set_rate");
extern fn MaResult data_converter_set_rate_ratio(MaDataConverter* p_converter, float ratio_in_out) @cname("ma_data_converter_set_rate_ratio");
extern fn MaUint64 data_converter_get_input_latency(MaDataConverter* p_converter) @cname("ma_data_converter_get_input_latency");
extern fn MaUint64 data_converter_get_output_latency(MaDataConverter* p_converter) @cname("ma_data_converter_get_output_latency");
extern fn MaResult data_converter_get_required_input_frame_count(MaDataConverter* p_converter, ulong output_frame_count, MaUint64* p_input_frame_count) @cname("ma_data_converter_get_required_input_frame_count");
extern fn MaResult data_converter_get_expected_output_frame_count(MaDataConverter* p_converter, ulong input_frame_count, MaUint64* p_output_frame_count) @cname("ma_data_converter_get_expected_output_frame_count");
extern fn MaResult data_converter_get_input_channel_map(MaDataConverter* p_converter, MaChannel* p_channel_map, usz channel_map_cap) @cname("ma_data_converter_get_input_channel_map");
extern fn MaResult data_converter_get_output_channel_map(MaDataConverter* p_converter, MaChannel* p_channel_map, usz channel_map_cap) @cname("ma_data_converter_get_output_channel_map");
extern fn MaResult data_converter_reset(MaDataConverter* p_converter) @cname("ma_data_converter_reset");
extern fn void pcm_u8_to_s16(void* p_out, void* p_in, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_u8_to_s16");
extern fn void pcm_u8_to_s24(void* p_out, void* p_in, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_u8_to_s24");
extern fn void pcm_u8_to_s32(void* p_out, void* p_in, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_u8_to_s32");
extern fn void pcm_u8_to_f32(void* p_out, void* p_in, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_u8_to_f32");
extern fn void pcm_s16_to_u8(void* p_out, void* p_in, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_s16_to_u8");
extern fn void pcm_s16_to_s24(void* p_out, void* p_in, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_s16_to_s24");
extern fn void pcm_s16_to_s32(void* p_out, void* p_in, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_s16_to_s32");
extern fn void pcm_s16_to_f32(void* p_out, void* p_in, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_s16_to_f32");
extern fn void pcm_s24_to_u8(void* p_out, void* p_in, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_s24_to_u8");
extern fn void pcm_s24_to_s16(void* p_out, void* p_in, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_s24_to_s16");
extern fn void pcm_s24_to_s32(void* p_out, void* p_in, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_s24_to_s32");
extern fn void pcm_s24_to_f32(void* p_out, void* p_in, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_s24_to_f32");
extern fn void pcm_s32_to_u8(void* p_out, void* p_in, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_s32_to_u8");
extern fn void pcm_s32_to_s16(void* p_out, void* p_in, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_s32_to_s16");
extern fn void pcm_s32_to_s24(void* p_out, void* p_in, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_s32_to_s24");
extern fn void pcm_s32_to_f32(void* p_out, void* p_in, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_s32_to_f32");
extern fn void pcm_f32_to_u8(void* p_out, void* p_in, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_f32_to_u8");
extern fn void pcm_f32_to_s16(void* p_out, void* p_in, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_f32_to_s16");
extern fn void pcm_f32_to_s24(void* p_out, void* p_in, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_f32_to_s24");
extern fn void pcm_f32_to_s32(void* p_out, void* p_in, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_f32_to_s32");
extern fn void pcm_convert(void* p_out, MaFormat format_out, void* p_in, MaFormat format_in, ulong sample_count, MaDitherMode dither_mode) @cname("ma_pcm_convert");
extern fn void convert_pcm_frames_format(void* p_out, MaFormat format_out, void* p_in, MaFormat format_in, ulong frame_count, uint channels, MaDitherMode dither_mode) @cname("ma_convert_pcm_frames_format");
extern fn void deinterleave_pcm_frames(MaFormat format, uint channels, ulong frame_count, void* p_interleaved_pcm_frames, void** pp_deinterleaved_pcm_frames) @cname("ma_deinterleave_pcm_frames");
extern fn void interleave_pcm_frames(MaFormat format, uint channels, ulong frame_count, void** pp_deinterleaved_pcm_frames, void* p_interleaved_pcm_frames) @cname("ma_interleave_pcm_frames");
extern fn MaChannel channel_map_get_channel(MaChannel* p_channel_map, uint channel_count, uint channel_index) @cname("ma_channel_map_get_channel");
extern fn void channel_map_init_blank(MaChannel* p_channel_map, uint channels) @cname("ma_channel_map_init_blank");
extern fn void channel_map_init_standard(MaStandardChannelMap standard_channel_map, MaChannel* p_channel_map, usz channel_map_cap, uint channels) @cname("ma_channel_map_init_standard");
extern fn void channel_map_copy(MaChannel* p_out, MaChannel* p_in, uint channels) @cname("ma_channel_map_copy");
extern fn void channel_map_copy_or_default(MaChannel* p_out, usz channel_map_cap_out, MaChannel* p_in, uint channels) @cname("ma_channel_map_copy_or_default");
extern fn MaBool32 channel_map_is_valid(MaChannel* p_channel_map, uint channels) @cname("ma_channel_map_is_valid");
extern fn MaBool32 channel_map_is_equal(MaChannel* p_channel_map_a, MaChannel* p_channel_map_b, uint channels) @cname("ma_channel_map_is_equal");
extern fn MaBool32 channel_map_is_blank(MaChannel* p_channel_map, uint channels) @cname("ma_channel_map_is_blank");
extern fn MaBool32 channel_map_contains_channel_position(uint channels, MaChannel* p_channel_map, char channel_position) @cname("ma_channel_map_contains_channel_position");
extern fn MaBool32 channel_map_find_channel_position(uint channels, MaChannel* p_channel_map, char channel_position, MaUint32* p_channel_index) @cname("ma_channel_map_find_channel_position");
extern fn usz channel_map_to_string(MaChannel* p_channel_map, uint channels, char* p_buffer_out, usz buffer_cap) @cname("ma_channel_map_to_string");
extern fn ZString channel_position_to_string(char channel) @cname("ma_channel_position_to_string");
extern fn MaUint64 convert_frames(void* p_out, ulong frame_count_out, MaFormat format_out, uint channels_out, uint sample_rate_out, void* p_in, ulong frame_count_in, MaFormat format_in, uint channels_in, uint sample_rate_in) @cname("ma_convert_frames");
extern fn MaUint64 convert_frames_ex(void* p_out, ulong frame_count_out, void* p_in, ulong frame_count_in, MaDataConverterConfig* p_config) @cname("ma_convert_frames_ex");
extern fn MaDataSourceConfig data_source_config_init() @cname("ma_data_source_config_init");
extern fn MaResult data_source_init(MaDataSourceConfig* p_config, MaDataSource* p_data_source) @cname("ma_data_source_init");
extern fn void data_source_uninit(MaDataSource* p_data_source) @cname("ma_data_source_uninit");
extern fn MaResult data_source_read_pcm_frames(MaDataSource* p_data_source, void* p_frames_out, ulong frame_count, MaUint64* p_frames_read) @cname("ma_data_source_read_pcm_frames");
extern fn MaResult data_source_seek_pcm_frames(MaDataSource* p_data_source, ulong frame_count, MaUint64* p_frames_seeked) @cname("ma_data_source_seek_pcm_frames");
extern fn MaResult data_source_seek_to_pcm_frame(MaDataSource* p_data_source, ulong frame_index) @cname("ma_data_source_seek_to_pcm_frame");
extern fn MaResult data_source_seek_seconds(MaDataSource* p_data_source, float second_count, float* p_seconds_seeked) @cname("ma_data_source_seek_seconds");
extern fn MaResult data_source_seek_to_second(MaDataSource* p_data_source, float seek_point_in_seconds) @cname("ma_data_source_seek_to_second");
extern fn MaResult data_source_get_data_format(MaDataSource* p_data_source, MaFormat* p_format, MaUint32* p_channels, MaUint32* p_sample_rate, MaChannel* p_channel_map, usz channel_map_cap) @cname("ma_data_source_get_data_format");
extern fn MaResult data_source_get_cursor_in_pcm_frames(MaDataSource* p_data_source, MaUint64* p_cursor) @cname("ma_data_source_get_cursor_in_pcm_frames");
extern fn MaResult data_source_get_length_in_pcm_frames(MaDataSource* p_data_source, MaUint64* p_length) @cname("ma_data_source_get_length_in_pcm_frames");
extern fn MaResult data_source_get_cursor_in_seconds(MaDataSource* p_data_source, float* p_cursor) @cname("ma_data_source_get_cursor_in_seconds");
extern fn MaResult data_source_get_length_in_seconds(MaDataSource* p_data_source, float* p_length) @cname("ma_data_source_get_length_in_seconds");
extern fn MaResult data_source_set_looping(MaDataSource* p_data_source, uint is_looping) @cname("ma_data_source_set_looping");
extern fn MaBool32 data_source_is_looping(MaDataSource* p_data_source) @cname("ma_data_source_is_looping");
extern fn MaResult data_source_set_range_in_pcm_frames(MaDataSource* p_data_source, ulong range_beg_in_frames, ulong range_end_in_frames) @cname("ma_data_source_set_range_in_pcm_frames");
extern fn void data_source_get_range_in_pcm_frames(MaDataSource* p_data_source, MaUint64* p_range_beg_in_frames, MaUint64* p_range_end_in_frames) @cname("ma_data_source_get_range_in_pcm_frames");
extern fn MaResult data_source_set_loop_point_in_pcm_frames(MaDataSource* p_data_source, ulong loop_beg_in_frames, ulong loop_end_in_frames) @cname("ma_data_source_set_loop_point_in_pcm_frames");
extern fn void data_source_get_loop_point_in_pcm_frames(MaDataSource* p_data_source, MaUint64* p_loop_beg_in_frames, MaUint64* p_loop_end_in_frames) @cname("ma_data_source_get_loop_point_in_pcm_frames");
extern fn MaResult data_source_set_current(MaDataSource* p_data_source, MaDataSource* p_current_data_source) @cname("ma_data_source_set_current");
extern fn MaDataSource* data_source_get_current(MaDataSource* p_data_source) @cname("ma_data_source_get_current");
extern fn MaResult data_source_set_next(MaDataSource* p_data_source, MaDataSource* p_next_data_source) @cname("ma_data_source_set_next");
extern fn MaDataSource* data_source_get_next(MaDataSource* p_data_source) @cname("ma_data_source_get_next");
extern fn MaResult data_source_set_next_callback(MaDataSource* p_data_source, MaDataSourceGetNextProc on_get_next) @cname("ma_data_source_set_next_callback");
extern fn MaDataSourceGetNextProc data_source_get_next_callback(MaDataSource* p_data_source) @cname("ma_data_source_get_next_callback");
extern fn MaResult audio_buffer_ref_init(MaFormat format, uint channels, void* p_data, ulong size_in_frames, MaAudioBufferRef* p_audio_buffer_ref) @cname("ma_audio_buffer_ref_init");
extern fn void audio_buffer_ref_uninit(MaAudioBufferRef* p_audio_buffer_ref) @cname("ma_audio_buffer_ref_uninit");
extern fn MaResult audio_buffer_ref_set_data(MaAudioBufferRef* p_audio_buffer_ref, void* p_data, ulong size_in_frames) @cname("ma_audio_buffer_ref_set_data");
extern fn MaUint64 audio_buffer_ref_read_pcm_frames(MaAudioBufferRef* p_audio_buffer_ref, void* p_frames_out, ulong frame_count, uint loop) @cname("ma_audio_buffer_ref_read_pcm_frames");
extern fn MaResult audio_buffer_ref_seek_to_pcm_frame(MaAudioBufferRef* p_audio_buffer_ref, ulong frame_index) @cname("ma_audio_buffer_ref_seek_to_pcm_frame");
extern fn MaResult audio_buffer_ref_map(MaAudioBufferRef* p_audio_buffer_ref, void** pp_frames_out, MaUint64* p_frame_count) @cname("ma_audio_buffer_ref_map");
extern fn MaResult audio_buffer_ref_unmap(MaAudioBufferRef* p_audio_buffer_ref, ulong frame_count) @cname("ma_audio_buffer_ref_unmap");
extern fn MaBool32 audio_buffer_ref_at_end(MaAudioBufferRef* p_audio_buffer_ref) @cname("ma_audio_buffer_ref_at_end");
extern fn MaResult audio_buffer_ref_get_cursor_in_pcm_frames(MaAudioBufferRef* p_audio_buffer_ref, MaUint64* p_cursor) @cname("ma_audio_buffer_ref_get_cursor_in_pcm_frames");
extern fn MaResult audio_buffer_ref_get_length_in_pcm_frames(MaAudioBufferRef* p_audio_buffer_ref, MaUint64* p_length) @cname("ma_audio_buffer_ref_get_length_in_pcm_frames");
extern fn MaResult audio_buffer_ref_get_available_frames(MaAudioBufferRef* p_audio_buffer_ref, MaUint64* p_available_frames) @cname("ma_audio_buffer_ref_get_available_frames");
extern fn MaAudioBufferConfig audio_buffer_config_init(MaFormat format, uint channels, ulong size_in_frames, void* p_data, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_audio_buffer_config_init");
extern fn MaResult audio_buffer_init(MaAudioBufferConfig* p_config, MaAudioBuffer* p_audio_buffer) @cname("ma_audio_buffer_init");
extern fn MaResult audio_buffer_init_copy(MaAudioBufferConfig* p_config, MaAudioBuffer* p_audio_buffer) @cname("ma_audio_buffer_init_copy");
extern fn MaResult audio_buffer_alloc_and_init(MaAudioBufferConfig* p_config, MaAudioBuffer** pp_audio_buffer) @cname("ma_audio_buffer_alloc_and_init");
extern fn void audio_buffer_uninit(MaAudioBuffer* p_audio_buffer) @cname("ma_audio_buffer_uninit");
extern fn void audio_buffer_uninit_and_free(MaAudioBuffer* p_audio_buffer) @cname("ma_audio_buffer_uninit_and_free");
extern fn MaUint64 audio_buffer_read_pcm_frames(MaAudioBuffer* p_audio_buffer, void* p_frames_out, ulong frame_count, uint loop) @cname("ma_audio_buffer_read_pcm_frames");
extern fn MaResult audio_buffer_seek_to_pcm_frame(MaAudioBuffer* p_audio_buffer, ulong frame_index) @cname("ma_audio_buffer_seek_to_pcm_frame");
extern fn MaResult audio_buffer_map(MaAudioBuffer* p_audio_buffer, void** pp_frames_out, MaUint64* p_frame_count) @cname("ma_audio_buffer_map");
extern fn MaResult audio_buffer_unmap(MaAudioBuffer* p_audio_buffer, ulong frame_count) @cname("ma_audio_buffer_unmap");
extern fn MaBool32 audio_buffer_at_end(MaAudioBuffer* p_audio_buffer) @cname("ma_audio_buffer_at_end");
extern fn MaResult audio_buffer_get_cursor_in_pcm_frames(MaAudioBuffer* p_audio_buffer, MaUint64* p_cursor) @cname("ma_audio_buffer_get_cursor_in_pcm_frames");
extern fn MaResult audio_buffer_get_length_in_pcm_frames(MaAudioBuffer* p_audio_buffer, MaUint64* p_length) @cname("ma_audio_buffer_get_length_in_pcm_frames");
extern fn MaResult audio_buffer_get_available_frames(MaAudioBuffer* p_audio_buffer, MaUint64* p_available_frames) @cname("ma_audio_buffer_get_available_frames");
extern fn MaResult paged_audio_buffer_data_init(MaFormat format, uint channels, MaPagedAudioBufferData* p_data) @cname("ma_paged_audio_buffer_data_init");
extern fn void paged_audio_buffer_data_uninit(MaPagedAudioBufferData* p_data, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_paged_audio_buffer_data_uninit");
extern fn MaPagedAudioBufferPage* paged_audio_buffer_data_get_head(MaPagedAudioBufferData* p_data) @cname("ma_paged_audio_buffer_data_get_head");
extern fn MaPagedAudioBufferPage* paged_audio_buffer_data_get_tail(MaPagedAudioBufferData* p_data) @cname("ma_paged_audio_buffer_data_get_tail");
extern fn MaResult paged_audio_buffer_data_get_length_in_pcm_frames(MaPagedAudioBufferData* p_data, MaUint64* p_length) @cname("ma_paged_audio_buffer_data_get_length_in_pcm_frames");
extern fn MaResult paged_audio_buffer_data_allocate_page(MaPagedAudioBufferData* p_data, ulong page_size_in_frames, void* p_initial_data, MaAllocationCallbacks* p_allocation_callbacks, MaPagedAudioBufferPage** pp_page) @cname("ma_paged_audio_buffer_data_allocate_page");
extern fn MaResult paged_audio_buffer_data_free_page(MaPagedAudioBufferData* p_data, MaPagedAudioBufferPage* p_page, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_paged_audio_buffer_data_free_page");
extern fn MaResult paged_audio_buffer_data_append_page(MaPagedAudioBufferData* p_data, MaPagedAudioBufferPage* p_page) @cname("ma_paged_audio_buffer_data_append_page");
extern fn MaResult paged_audio_buffer_data_allocate_and_append_page(MaPagedAudioBufferData* p_data, uint page_size_in_frames, void* p_initial_data, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_paged_audio_buffer_data_allocate_and_append_page");
extern fn MaPagedAudioBufferConfig paged_audio_buffer_config_init(MaPagedAudioBufferData* p_data) @cname("ma_paged_audio_buffer_config_init");
extern fn MaResult paged_audio_buffer_init(MaPagedAudioBufferConfig* p_config, MaPagedAudioBuffer* p_paged_audio_buffer) @cname("ma_paged_audio_buffer_init");
extern fn void paged_audio_buffer_uninit(MaPagedAudioBuffer* p_paged_audio_buffer) @cname("ma_paged_audio_buffer_uninit");
extern fn MaResult paged_audio_buffer_read_pcm_frames(MaPagedAudioBuffer* p_paged_audio_buffer, void* p_frames_out, ulong frame_count, MaUint64* p_frames_read) @cname("ma_paged_audio_buffer_read_pcm_frames");
extern fn MaResult paged_audio_buffer_seek_to_pcm_frame(MaPagedAudioBuffer* p_paged_audio_buffer, ulong frame_index) @cname("ma_paged_audio_buffer_seek_to_pcm_frame");
extern fn MaResult paged_audio_buffer_get_cursor_in_pcm_frames(MaPagedAudioBuffer* p_paged_audio_buffer, MaUint64* p_cursor) @cname("ma_paged_audio_buffer_get_cursor_in_pcm_frames");
extern fn MaResult paged_audio_buffer_get_length_in_pcm_frames(MaPagedAudioBuffer* p_paged_audio_buffer, MaUint64* p_length) @cname("ma_paged_audio_buffer_get_length_in_pcm_frames");
extern fn void ring_buffer_init(uint capacity, uint stride, uint flags, void* p_buffer, MaRingBuffer* p_ring_buffer) @cname("ma_ring_buffer_init");
extern fn uint ring_buffer_map_produce(MaRingBuffer* p_ring_buffer, uint count, void** pp_mapped_buffer) @cname("ma_ring_buffer_map_produce");
extern fn void ring_buffer_unmap_produce(MaRingBuffer* p_ring_buffer, uint count) @cname("ma_ring_buffer_unmap_produce");
extern fn uint ring_buffer_map_consume(MaRingBuffer* p_ring_buffer, uint count, void** pp_mapped_buffer) @cname("ma_ring_buffer_map_consume");
extern fn void ring_buffer_unmap_consume(MaRingBuffer* p_ring_buffer, uint count) @cname("ma_ring_buffer_unmap_consume");
extern fn uint ring_buffer_length(MaRingBuffer* p_ring_buffer) @cname("ma_ring_buffer_length");
extern fn uint ring_buffer_capacity(MaRingBuffer* p_ring_buffer) @cname("ma_ring_buffer_capacity");

extern fn MaAudioRingBufferConfig audio_ring_buffer_config_init(MaFormat format, uint channels, uint sample_rate, uint size_in_frames) @cname("ma_audio_ring_buffer_config_init");
extern fn MaResult audio_ring_buffer_init(MaAudioRingBufferConfig* p_config, MaAudioRingBuffer* p_ring_buffer) @cname("ma_audio_ring_buffer_init");
extern fn void audio_ring_buffer_uninit(MaAudioRingBuffer* p_ring_buffer) @cname("ma_audio_ring_buffer_uninit");
extern fn uint audio_ring_buffer_map_produce(MaAudioRingBuffer* p_ring_buffer, uint frame_count, void** pp_mapped_buffer) @cname("ma_audio_ring_buffer_map_produce");
extern fn void audio_ring_buffer_unmap_produce(MaAudioRingBuffer* p_ring_buffer, uint frame_count) @cname("ma_audio_ring_buffer_unmap_produce");
extern fn uint audio_ring_buffer_map_consume(MaAudioRingBuffer* p_ring_buffer, uint frame_count, void** pp_mapped_buffer) @cname("ma_audio_ring_buffer_map_consume");
extern fn void audio_ring_buffer_unmap_consume(MaAudioRingBuffer* p_ring_buffer, uint frame_count) @cname("ma_audio_ring_buffer_unmap_consume");
extern fn MaResult audio_ring_buffer_write_pcm_frames(MaAudioRingBuffer* p_ring_buffer, void* p_frames, uint frame_count, uint* p_frames_written) @cname("ma_audio_ring_buffer_write_pcm_frames");
extern fn MaResult audio_ring_buffer_read_pcm_frames(MaAudioRingBuffer* p_ring_buffer, void* p_frames, uint frame_count, uint* p_frames_read) @cname("ma_audio_ring_buffer_read_pcm_frames");
extern fn MaResult audio_ring_buffer_get_length_in_pcm_frames(MaAudioRingBuffer* p_ring_buffer, uint* p_length) @cname("ma_audio_ring_buffer_get_length_in_pcm_frames");
extern fn MaResult duplex_rb_init(MaFormat capture_format, uint capture_channels, uint sample_rate, uint capture_internal_sample_rate, uint capture_internal_period_size_in_frames, MaAllocationCallbacks* p_allocation_callbacks, MaDuplexRb* p_rb) @cname("ma_duplex_rb_init");
extern fn MaResult duplex_rb_uninit(MaDuplexRb* p_rb) @cname("ma_duplex_rb_uninit");
extern fn ZString result_description(MaResult result) @cname("ma_result_description");
extern fn void* malloc(usz sz_, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_malloc");
extern fn void* calloc(usz sz_, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_calloc");
extern fn void* realloc(void* p, usz sz_, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_realloc");
extern fn void free(void* p, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_free");
extern fn void* aligned_malloc(usz sz_, usz alignment, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_aligned_malloc");
extern fn void aligned_free(void* p, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_aligned_free");
extern fn ZString get_format_name(MaFormat format) @cname("ma_get_format_name");
extern fn void blend_f32(float* p_out, float* p_in_a, float* p_in_b, float factor, uint channels) @cname("ma_blend_f32");
extern fn MaUint32 get_bytes_per_sample(MaFormat format) @cname("ma_get_bytes_per_sample");
extern fn MaUint32 get_bytes_per_frame(MaFormat format, uint channels) @cname("ma_get_bytes_per_frame");
extern fn ZString log_level_to_string(uint log_level) @cname("ma_log_level_to_string");
extern fn MaResult spinlock_lock(MaSpinlock* p_spinlock) @cname("ma_spinlock_lock");
extern fn MaResult spinlock_lock_noyield(MaSpinlock* p_spinlock) @cname("ma_spinlock_lock_noyield");
extern fn MaResult spinlock_unlock(MaSpinlock* p_spinlock) @cname("ma_spinlock_unlock");
extern fn MaResult mutex_init(MaMutex* p_mutex) @cname("ma_mutex_init");
extern fn void mutex_uninit(MaMutex* p_mutex) @cname("ma_mutex_uninit");
extern fn void mutex_lock(MaMutex* p_mutex) @cname("ma_mutex_lock");
extern fn void mutex_unlock(MaMutex* p_mutex) @cname("ma_mutex_unlock");
extern fn MaResult event_init(MaEvent* p_event) @cname("ma_event_init");
extern fn void event_uninit(MaEvent* p_event) @cname("ma_event_uninit");
extern fn MaResult event_wait(MaEvent* p_event) @cname("ma_event_wait");
extern fn MaResult event_signal(MaEvent* p_event) @cname("ma_event_signal");
extern fn MaResult semaphore_init(int initial_value, MaSemaphore* p_semaphore) @cname("ma_semaphore_init");
extern fn void semaphore_uninit(MaSemaphore* p_semaphore) @cname("ma_semaphore_uninit");
extern fn MaResult semaphore_wait(MaSemaphore* p_semaphore) @cname("ma_semaphore_wait");
extern fn MaResult semaphore_release(MaSemaphore* p_semaphore) @cname("ma_semaphore_release");
extern fn MaResult fence_init(MaFence* p_fence) @cname("ma_fence_init");
extern fn void fence_uninit(MaFence* p_fence) @cname("ma_fence_uninit");
extern fn MaResult fence_acquire(MaFence* p_fence) @cname("ma_fence_acquire");
extern fn MaResult fence_release(MaFence* p_fence) @cname("ma_fence_release");
extern fn MaResult fence_wait(MaFence* p_fence) @cname("ma_fence_wait");
extern fn MaResult async_notification_signal(MaAsyncNotification* p_notification) @cname("ma_async_notification_signal");
extern fn MaResult async_notification_poll_init(MaAsyncNotificationPoll* p_notification_poll) @cname("ma_async_notification_poll_init");
extern fn MaBool32 async_notification_poll_is_signalled(MaAsyncNotificationPoll* p_notification_poll) @cname("ma_async_notification_poll_is_signalled");
extern fn MaResult async_notification_event_init(MaAsyncNotificationEvent* p_notification_event) @cname("ma_async_notification_event_init");
extern fn MaResult async_notification_event_uninit(MaAsyncNotificationEvent* p_notification_event) @cname("ma_async_notification_event_uninit");
extern fn MaResult async_notification_event_wait(MaAsyncNotificationEvent* p_notification_event) @cname("ma_async_notification_event_wait");
extern fn MaResult async_notification_event_signal(MaAsyncNotificationEvent* p_notification_event) @cname("ma_async_notification_event_signal");
extern fn MaSlotAllocatorConfig slot_allocator_config_init(uint capacity) @cname("ma_slot_allocator_config_init");
extern fn MaResult slot_allocator_get_heap_size(MaSlotAllocatorConfig* p_config, usz* p_heap_size_in_bytes) @cname("ma_slot_allocator_get_heap_size");
extern fn MaResult slot_allocator_init_preallocated(MaSlotAllocatorConfig* p_config, void* p_heap, MaSlotAllocator* p_allocator) @cname("ma_slot_allocator_init_preallocated");
extern fn MaResult slot_allocator_init(MaSlotAllocatorConfig* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaSlotAllocator* p_allocator) @cname("ma_slot_allocator_init");
extern fn void slot_allocator_uninit(MaSlotAllocator* p_allocator, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_slot_allocator_uninit");
extern fn MaResult slot_allocator_alloc(MaSlotAllocator* p_allocator, MaUint64* p_slot) @cname("ma_slot_allocator_alloc");
extern fn MaResult slot_allocator_free(MaSlotAllocator* p_allocator, ulong slot) @cname("ma_slot_allocator_free");
extern fn MaJob job_init(ushort code) @cname("ma_job_init");
extern fn MaResult job_process(MaJob* p_job) @cname("ma_job_process");
extern fn MaJobQueueConfig job_queue_config_init(uint flags, uint capacity) @cname("ma_job_queue_config_init");
extern fn MaResult job_queue_get_heap_size(MaJobQueueConfig* p_config, usz* p_heap_size_in_bytes) @cname("ma_job_queue_get_heap_size");
extern fn MaResult job_queue_init_preallocated(MaJobQueueConfig* p_config, void* p_heap, MaJobQueue* p_queue) @cname("ma_job_queue_init_preallocated");
extern fn MaResult job_queue_init(MaJobQueueConfig* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaJobQueue* p_queue) @cname("ma_job_queue_init");
extern fn void job_queue_uninit(MaJobQueue* p_queue, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_job_queue_uninit");
extern fn MaResult job_queue_post(MaJobQueue* p_queue, MaJob* p_job) @cname("ma_job_queue_post");
extern fn MaResult job_queue_next(MaJobQueue* p_queue, MaJob* p_job) @cname("ma_job_queue_next");
extern fn MaDeviceJobThreadConfig device_job_thread_config_init() @cname("ma_device_job_thread_config_init");
extern fn MaResult device_job_thread_init(MaDeviceJobThreadConfig* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaDeviceJobThread* p_job_thread) @cname("ma_device_job_thread_init");
extern fn void device_job_thread_uninit(MaDeviceJobThread* p_job_thread, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_device_job_thread_uninit");
extern fn MaResult device_job_thread_post(MaDeviceJobThread* p_job_thread, MaJob* p_job) @cname("ma_device_job_thread_post");
extern fn MaResult device_job_thread_next(MaDeviceJobThread* p_job_thread, MaJob* p_job) @cname("ma_device_job_thread_next");
extern fn MaBool32 device_id_equal(MaDeviceId* p_a, MaDeviceId* p_b) @cname("ma_device_id_equal");
extern fn MaContextConfig context_config_init() @cname("ma_context_config_init");
extern fn MaResult context_init(MaBackend* backends, uint backend_count, MaContextConfig* p_config, MaContext* p_context) @cname("ma_context_init");
extern fn MaResult context_uninit(MaContext* p_context) @cname("ma_context_uninit");
extern fn usz context_sizeof() @cname("ma_context_sizeof");
extern fn MaLog* context_get_log(MaContext* p_context) @cname("ma_context_get_log");
extern fn MaResult context_enumerate_devices(MaContext* p_context, MaEnumDevicesCallbackProc callback, void* p_user_data) @cname("ma_context_enumerate_devices");
extern fn MaResult context_get_devices(MaContext* p_context, MaDeviceInfo** pp_playback_device_infos, MaUint32* p_playback_device_count, MaDeviceInfo** pp_capture_device_infos, MaUint32* p_capture_device_count) @cname("ma_context_get_devices");
extern fn MaResult context_get_device_info(MaContext* p_context, MaDeviceType device_type, MaDeviceId* p_device_id, MaDeviceInfo* p_device_info) @cname("ma_context_get_device_info");
extern fn MaBool32 context_is_loopback_supported(MaContext* p_context) @cname("ma_context_is_loopback_supported");
extern fn MaDeviceConfig device_config_init(MaDeviceType device_type) @cname("ma_device_config_init");
extern fn MaResult device_init(MaContext* p_context, MaDeviceConfig* p_config, MaDevice* p_device) @cname("ma_device_init");
extern fn MaResult device_init_ex(MaBackend* backends, uint backend_count, MaContextConfig* p_context_config, MaDeviceConfig* p_config, MaDevice* p_device) @cname("ma_device_init_ex");
extern fn void device_uninit(MaDevice* p_device) @cname("ma_device_uninit");
extern fn MaContext* device_get_context(MaDevice* p_device) @cname("ma_device_get_context");
extern fn MaLog* device_get_log(MaDevice* p_device) @cname("ma_device_get_log");
extern fn MaResult device_get_info(MaDevice* p_device, MaDeviceType type, MaDeviceInfo* p_device_info) @cname("ma_device_get_info");
extern fn MaResult device_get_name(MaDevice* p_device, MaDeviceType type, char* p_name, usz name_cap, usz* p_length_not_including_null_terminator) @cname("ma_device_get_name");
extern fn MaResult device_start(MaDevice* p_device) @cname("ma_device_start");
extern fn MaResult device_stop(MaDevice* p_device) @cname("ma_device_stop");
extern fn MaBool32 device_is_started(MaDevice* p_device) @cname("ma_device_is_started");
extern fn MaDeviceState device_get_state(MaDevice* p_device) @cname("ma_device_get_state");
extern fn MaResult device_post_init(MaDevice* p_device, MaDeviceType device_type, MaDeviceDescriptor* p_playback_descriptor, MaDeviceDescriptor* p_capture_descriptor) @cname("ma_device_post_init");
extern fn MaResult device_set_master_volume(MaDevice* p_device, float volume) @cname("ma_device_set_master_volume");
extern fn MaResult device_get_master_volume(MaDevice* p_device, float* p_volume) @cname("ma_device_get_master_volume");
extern fn MaResult device_set_master_volume_db(MaDevice* p_device, float gain_db) @cname("ma_device_set_master_volume_db");
extern fn MaResult device_get_master_volume_db(MaDevice* p_device, float* p_gain_db) @cname("ma_device_get_master_volume_db");
extern fn MaResult device_handle_backend_data_callback(MaDevice* p_device, void* p_output, void* p_input, uint frame_count) @cname("ma_device_handle_backend_data_callback");
extern fn MaUint32 calculate_buffer_size_in_frames_from_descriptor(MaDeviceDescriptor* p_descriptor, uint native_sample_rate, MaPerformanceProfile performance_profile) @cname("ma_calculate_buffer_size_in_frames_from_descriptor");
extern fn ZString get_backend_name(MaBackend backend) @cname("ma_get_backend_name");
extern fn MaResult get_backend_from_name(ZString p_backend_name, MaBackend* p_backend) @cname("ma_get_backend_from_name");
extern fn MaBool32 is_backend_enabled(MaBackend backend) @cname("ma_is_backend_enabled");
extern fn MaResult get_enabled_backends(MaBackend* p_backends, usz backend_cap, usz* p_backend_count) @cname("ma_get_enabled_backends");
extern fn MaBool32 is_loopback_supported(MaBackend backend) @cname("ma_is_loopback_supported");
extern fn MaUint32 calculate_buffer_size_in_milliseconds_from_frames(uint buffer_size_in_frames, uint sample_rate) @cname("ma_calculate_buffer_size_in_milliseconds_from_frames");
extern fn MaUint32 calculate_buffer_size_in_frames_from_milliseconds(uint buffer_size_in_milliseconds, uint sample_rate) @cname("ma_calculate_buffer_size_in_frames_from_milliseconds");
extern fn void copy_pcm_frames(void* dst, void* src, ulong frame_count, MaFormat format, uint channels) @cname("ma_copy_pcm_frames");
extern fn void silence_pcm_frames(void* p, ulong frame_count, MaFormat format, uint channels) @cname("ma_silence_pcm_frames");
extern fn void* offset_pcm_frames_ptr(void* p, ulong offset_in_frames, MaFormat format, uint channels) @cname("ma_offset_pcm_frames_ptr");
extern fn void* offset_pcm_frames_const_ptr(void* p, ulong offset_in_frames, MaFormat format, uint channels) @cname("ma_offset_pcm_frames_const_ptr");
extern fn float* offset_pcm_frames_ptr_f32(float* p, ulong offset_in_frames, uint channels) @cname("ma_offset_pcm_frames_ptr_f32");
extern fn float* offset_pcm_frames_const_ptr_f32(float* p, ulong offset_in_frames, uint channels) @cname("ma_offset_pcm_frames_const_ptr_f32");
extern fn void clip_samples_u8(MaUint8* p_dst, MaInt16* p_src, ulong count) @cname("ma_clip_samples_u8");
extern fn void clip_samples_s16(MaInt16* p_dst, MaInt32* p_src, ulong count) @cname("ma_clip_samples_s16");
extern fn void clip_samples_s24(MaUint8* p_dst, MaInt64* p_src, ulong count) @cname("ma_clip_samples_s24");
extern fn void clip_samples_s32(MaInt32* p_dst, MaInt64* p_src, ulong count) @cname("ma_clip_samples_s32");
extern fn void clip_samples_f32(float* p_dst, float* p_src, ulong count) @cname("ma_clip_samples_f32");
extern fn void clip_pcm_frames(void* p_dst, void* p_src, ulong frame_count, MaFormat format, uint channels) @cname("ma_clip_pcm_frames");
extern fn void copy_and_apply_volume_factor_u8(MaUint8* p_samples_out, MaUint8* p_samples_in, ulong sample_count, float factor) @cname("ma_copy_and_apply_volume_factor_u8");
extern fn void copy_and_apply_volume_factor_s16(MaInt16* p_samples_out, MaInt16* p_samples_in, ulong sample_count, float factor) @cname("ma_copy_and_apply_volume_factor_s16");
extern fn void copy_and_apply_volume_factor_s24(void* p_samples_out, void* p_samples_in, ulong sample_count, float factor) @cname("ma_copy_and_apply_volume_factor_s24");
extern fn void copy_and_apply_volume_factor_s32(MaInt32* p_samples_out, MaInt32* p_samples_in, ulong sample_count, float factor) @cname("ma_copy_and_apply_volume_factor_s32");
extern fn void copy_and_apply_volume_factor_f32(float* p_samples_out, float* p_samples_in, ulong sample_count, float factor) @cname("ma_copy_and_apply_volume_factor_f32");
extern fn void apply_volume_factor_u8(MaUint8* p_samples, ulong sample_count, float factor) @cname("ma_apply_volume_factor_u8");
extern fn void apply_volume_factor_s16(MaInt16* p_samples, ulong sample_count, float factor) @cname("ma_apply_volume_factor_s16");
extern fn void apply_volume_factor_s24(void* p_samples, ulong sample_count, float factor) @cname("ma_apply_volume_factor_s24");
extern fn void apply_volume_factor_s32(MaInt32* p_samples, ulong sample_count, float factor) @cname("ma_apply_volume_factor_s32");
extern fn void apply_volume_factor_f32(float* p_samples, ulong sample_count, float factor) @cname("ma_apply_volume_factor_f32");
extern fn void copy_and_apply_volume_factor_pcm_frames_u8(MaUint8* p_frames_out, MaUint8* p_frames_in, ulong frame_count, uint channels, float factor) @cname("ma_copy_and_apply_volume_factor_pcm_frames_u8");
extern fn void copy_and_apply_volume_factor_pcm_frames_s16(MaInt16* p_frames_out, MaInt16* p_frames_in, ulong frame_count, uint channels, float factor) @cname("ma_copy_and_apply_volume_factor_pcm_frames_s16");
extern fn void copy_and_apply_volume_factor_pcm_frames_s24(void* p_frames_out, void* p_frames_in, ulong frame_count, uint channels, float factor) @cname("ma_copy_and_apply_volume_factor_pcm_frames_s24");
extern fn void copy_and_apply_volume_factor_pcm_frames_s32(MaInt32* p_frames_out, MaInt32* p_frames_in, ulong frame_count, uint channels, float factor) @cname("ma_copy_and_apply_volume_factor_pcm_frames_s32");
extern fn void copy_and_apply_volume_factor_pcm_frames_f32(float* p_frames_out, float* p_frames_in, ulong frame_count, uint channels, float factor) @cname("ma_copy_and_apply_volume_factor_pcm_frames_f32");
extern fn void copy_and_apply_volume_factor_pcm_frames(void* p_frames_out, void* p_frames_in, ulong frame_count, MaFormat format, uint channels, float factor) @cname("ma_copy_and_apply_volume_factor_pcm_frames");
extern fn void apply_volume_factor_pcm_frames_u8(MaUint8* p_frames, ulong frame_count, uint channels, float factor) @cname("ma_apply_volume_factor_pcm_frames_u8");
extern fn void apply_volume_factor_pcm_frames_s16(MaInt16* p_frames, ulong frame_count, uint channels, float factor) @cname("ma_apply_volume_factor_pcm_frames_s16");
extern fn void apply_volume_factor_pcm_frames_s24(void* p_frames, ulong frame_count, uint channels, float factor) @cname("ma_apply_volume_factor_pcm_frames_s24");
extern fn void apply_volume_factor_pcm_frames_s32(MaInt32* p_frames, ulong frame_count, uint channels, float factor) @cname("ma_apply_volume_factor_pcm_frames_s32");
extern fn void apply_volume_factor_pcm_frames_f32(float* p_frames, ulong frame_count, uint channels, float factor) @cname("ma_apply_volume_factor_pcm_frames_f32");
extern fn void apply_volume_factor_pcm_frames(void* p_frames, ulong frame_count, MaFormat format, uint channels, float factor) @cname("ma_apply_volume_factor_pcm_frames");
extern fn void copy_and_apply_volume_factor_per_channel_f32(float* p_frames_out, float* p_frames_in, ulong frame_count, uint channels, float* p_channel_gains) @cname("ma_copy_and_apply_volume_factor_per_channel_f32");
extern fn void copy_and_apply_volume_and_clip_samples_u8(MaUint8* p_dst, MaInt16* p_src, ulong count, float volume) @cname("ma_copy_and_apply_volume_and_clip_samples_u8");
extern fn void copy_and_apply_volume_and_clip_samples_s16(MaInt16* p_dst, MaInt32* p_src, ulong count, float volume) @cname("ma_copy_and_apply_volume_and_clip_samples_s16");
extern fn void copy_and_apply_volume_and_clip_samples_s24(MaUint8* p_dst, MaInt64* p_src, ulong count, float volume) @cname("ma_copy_and_apply_volume_and_clip_samples_s24");
extern fn void copy_and_apply_volume_and_clip_samples_s32(MaInt32* p_dst, MaInt64* p_src, ulong count, float volume) @cname("ma_copy_and_apply_volume_and_clip_samples_s32");
extern fn void copy_and_apply_volume_and_clip_samples_f32(float* p_dst, float* p_src, ulong count, float volume) @cname("ma_copy_and_apply_volume_and_clip_samples_f32");
extern fn void copy_and_apply_volume_and_clip_pcm_frames(void* p_dst, void* p_src, ulong frame_count, MaFormat format, uint channels, float volume) @cname("ma_copy_and_apply_volume_and_clip_pcm_frames");
extern fn float volume_linear_to_db(float factor) @cname("ma_volume_linear_to_db");
extern fn float volume_db_to_linear(float gain) @cname("ma_volume_db_to_linear");
extern fn MaResult mix_pcm_frames_f32(float* p_dst, float* p_src, ulong frame_count, uint channels, float volume) @cname("ma_mix_pcm_frames_f32");
extern fn MaResult vfs_open(MaVfs* p_vfs, ZString p_file_path, uint open_mode, MaVfsFile* p_file) @cname("ma_vfs_open");
extern fn MaResult vfs_open_w(MaVfs* p_vfs, WcharT* p_file_path, uint open_mode, MaVfsFile* p_file) @cname("ma_vfs_open_w");
extern fn MaResult vfs_close(MaVfs* p_vfs, void* file) @cname("ma_vfs_close");
extern fn MaResult vfs_read(MaVfs* p_vfs, void* file, void* p_dst, usz size_in_bytes, usz* p_bytes_read) @cname("ma_vfs_read");
extern fn MaResult vfs_write(MaVfs* p_vfs, void* file, void* p_src, usz size_in_bytes, usz* p_bytes_written) @cname("ma_vfs_write");
extern fn MaResult vfs_seek(MaVfs* p_vfs, void* file, long offset, MaSeekOrigin origin) @cname("ma_vfs_seek");
extern fn MaResult vfs_tell(MaVfs* p_vfs, void* file, MaInt64* p_cursor) @cname("ma_vfs_tell");
extern fn MaResult vfs_info(MaVfs* p_vfs, void* file, MaFileInfo* p_info) @cname("ma_vfs_info");
extern fn MaResult vfs_open_and_read_file(MaVfs* p_vfs, ZString p_file_path, void** pp_data, usz* p_size, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_vfs_open_and_read_file");
extern fn MaResult default_vfs_init(MaDefaultVfs* p_vfs, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_default_vfs_init");
extern fn MaDecodingBackendConfig decoding_backend_config_init(MaFormat preferred_format, uint seek_point_count) @cname("ma_decoding_backend_config_init");
extern fn MaDecoderConfig decoder_config_init(MaFormat output_format, uint output_channels, uint output_sample_rate) @cname("ma_decoder_config_init");
extern fn MaDecoderConfig decoder_config_init_default() @cname("ma_decoder_config_init_default");
extern fn MaResult decoder_init(MaDecoderReadProc on_read, MaDecoderSeekProc on_seek, void* p_user_data, MaDecoderConfig* p_config, MaDecoder* p_decoder) @cname("ma_decoder_init");
extern fn MaResult decoder_init_memory(void* p_data, usz data_size, MaDecoderConfig* p_config, MaDecoder* p_decoder) @cname("ma_decoder_init_memory");
extern fn MaResult decoder_init_vfs(MaVfs* p_vfs, ZString p_file_path, MaDecoderConfig* p_config, MaDecoder* p_decoder) @cname("ma_decoder_init_vfs");
extern fn MaResult decoder_init_vfs_w(MaVfs* p_vfs, WcharT* p_file_path, MaDecoderConfig* p_config, MaDecoder* p_decoder) @cname("ma_decoder_init_vfs_w");
extern fn MaResult decoder_init_file(ZString p_file_path, MaDecoderConfig* p_config, MaDecoder* p_decoder) @cname("ma_decoder_init_file");
extern fn MaResult decoder_init_file_w(WcharT* p_file_path, MaDecoderConfig* p_config, MaDecoder* p_decoder) @cname("ma_decoder_init_file_w");
extern fn MaResult decoder_uninit(MaDecoder* p_decoder) @cname("ma_decoder_uninit");
extern fn MaResult decoder_read_pcm_frames(MaDecoder* p_decoder, void* p_frames_out, ulong frame_count, MaUint64* p_frames_read) @cname("ma_decoder_read_pcm_frames");
extern fn MaResult decoder_seek_to_pcm_frame(MaDecoder* p_decoder, ulong frame_index) @cname("ma_decoder_seek_to_pcm_frame");
extern fn MaResult decoder_get_data_format(MaDecoder* p_decoder, MaFormat* p_format, MaUint32* p_channels, MaUint32* p_sample_rate, MaChannel* p_channel_map, usz channel_map_cap) @cname("ma_decoder_get_data_format");
extern fn MaResult decoder_get_cursor_in_pcm_frames(MaDecoder* p_decoder, MaUint64* p_cursor) @cname("ma_decoder_get_cursor_in_pcm_frames");
extern fn MaResult decoder_get_length_in_pcm_frames(MaDecoder* p_decoder, MaUint64* p_length) @cname("ma_decoder_get_length_in_pcm_frames");
extern fn MaResult decoder_get_available_frames(MaDecoder* p_decoder, MaUint64* p_available_frames) @cname("ma_decoder_get_available_frames");
extern fn MaResult decode_from_vfs(MaVfs* p_vfs, ZString p_file_path, MaDecoderConfig* p_config, MaUint64* p_frame_count_out, void** pp_pcm_frames_out) @cname("ma_decode_from_vfs");
extern fn MaResult decode_file(ZString p_file_path, MaDecoderConfig* p_config, MaUint64* p_frame_count_out, void** pp_pcm_frames_out) @cname("ma_decode_file");
extern fn MaResult decode_memory(void* p_data, usz data_size, MaDecoderConfig* p_config, MaUint64* p_frame_count_out, void** pp_pcm_frames_out) @cname("ma_decode_memory");
extern fn MaEncoderConfig encoder_config_init(MaEncodingFormat encoding_format, MaFormat format, uint channels, uint sample_rate) @cname("ma_encoder_config_init");
extern fn MaResult encoder_init(MaEncoderWriteProc on_write, MaEncoderSeekProc on_seek, void* p_user_data, MaEncoderConfig* p_config, MaEncoder* p_encoder) @cname("ma_encoder_init");
extern fn MaResult encoder_init_vfs(MaVfs* p_vfs, ZString p_file_path, MaEncoderConfig* p_config, MaEncoder* p_encoder) @cname("ma_encoder_init_vfs");
extern fn MaResult encoder_init_vfs_w(MaVfs* p_vfs, WcharT* p_file_path, MaEncoderConfig* p_config, MaEncoder* p_encoder) @cname("ma_encoder_init_vfs_w");
extern fn MaResult encoder_init_file(ZString p_file_path, MaEncoderConfig* p_config, MaEncoder* p_encoder) @cname("ma_encoder_init_file");
extern fn MaResult encoder_init_file_w(WcharT* p_file_path, MaEncoderConfig* p_config, MaEncoder* p_encoder) @cname("ma_encoder_init_file_w");
extern fn void encoder_uninit(MaEncoder* p_encoder) @cname("ma_encoder_uninit");
extern fn MaResult encoder_write_pcm_frames(MaEncoder* p_encoder, void* p_frames_in, ulong frame_count, MaUint64* p_frames_written) @cname("ma_encoder_write_pcm_frames");
extern fn MaWaveformConfig waveform_config_init(MaFormat format, uint channels, uint sample_rate, MaWaveformType type, double amplitude, double frequency) @cname("ma_waveform_config_init");
extern fn MaResult waveform_init(MaWaveformConfig* p_config, MaWaveform* p_waveform) @cname("ma_waveform_init");
extern fn void waveform_uninit(MaWaveform* p_waveform) @cname("ma_waveform_uninit");
extern fn MaResult waveform_read_pcm_frames(MaWaveform* p_waveform, void* p_frames_out, ulong frame_count, MaUint64* p_frames_read) @cname("ma_waveform_read_pcm_frames");
extern fn MaResult waveform_seek_to_pcm_frame(MaWaveform* p_waveform, ulong frame_index) @cname("ma_waveform_seek_to_pcm_frame");
extern fn MaResult waveform_set_amplitude(MaWaveform* p_waveform, double amplitude) @cname("ma_waveform_set_amplitude");
extern fn MaResult waveform_set_frequency(MaWaveform* p_waveform, double frequency) @cname("ma_waveform_set_frequency");
extern fn MaResult waveform_set_type(MaWaveform* p_waveform, MaWaveformType type) @cname("ma_waveform_set_type");
extern fn MaResult waveform_set_sample_rate(MaWaveform* p_waveform, uint sample_rate) @cname("ma_waveform_set_sample_rate");
extern fn MaPulsewaveConfig pulsewave_config_init(MaFormat format, uint channels, uint sample_rate, double duty_cycle, double amplitude, double frequency) @cname("ma_pulsewave_config_init");
extern fn MaResult pulsewave_init(MaPulsewaveConfig* p_config, MaPulsewave* p_waveform) @cname("ma_pulsewave_init");
extern fn void pulsewave_uninit(MaPulsewave* p_waveform) @cname("ma_pulsewave_uninit");
extern fn MaResult pulsewave_read_pcm_frames(MaPulsewave* p_waveform, void* p_frames_out, ulong frame_count, MaUint64* p_frames_read) @cname("ma_pulsewave_read_pcm_frames");
extern fn MaResult pulsewave_seek_to_pcm_frame(MaPulsewave* p_waveform, ulong frame_index) @cname("ma_pulsewave_seek_to_pcm_frame");
extern fn MaResult pulsewave_set_amplitude(MaPulsewave* p_waveform, double amplitude) @cname("ma_pulsewave_set_amplitude");
extern fn MaResult pulsewave_set_frequency(MaPulsewave* p_waveform, double frequency) @cname("ma_pulsewave_set_frequency");
extern fn MaResult pulsewave_set_sample_rate(MaPulsewave* p_waveform, uint sample_rate) @cname("ma_pulsewave_set_sample_rate");
extern fn MaResult pulsewave_set_duty_cycle(MaPulsewave* p_waveform, double duty_cycle) @cname("ma_pulsewave_set_duty_cycle");
extern fn MaNoiseConfig noise_config_init(MaFormat format, uint channels, MaNoiseType type, int seed, double amplitude) @cname("ma_noise_config_init");
extern fn MaResult noise_get_heap_size(MaNoiseConfig* p_config, usz* p_heap_size_in_bytes) @cname("ma_noise_get_heap_size");
extern fn MaResult noise_init_preallocated(MaNoiseConfig* p_config, void* p_heap, MaNoise* p_noise) @cname("ma_noise_init_preallocated");
extern fn MaResult noise_init(MaNoiseConfig* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaNoise* p_noise) @cname("ma_noise_init");
extern fn void noise_uninit(MaNoise* p_noise, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_noise_uninit");
extern fn MaResult noise_read_pcm_frames(MaNoise* p_noise, void* p_frames_out, ulong frame_count, MaUint64* p_frames_read) @cname("ma_noise_read_pcm_frames");
extern fn MaResult noise_set_amplitude(MaNoise* p_noise, double amplitude) @cname("ma_noise_set_amplitude");
extern fn MaResult noise_set_seed(MaNoise* p_noise, int seed) @cname("ma_noise_set_seed");
extern fn MaResult noise_set_type(MaNoise* p_noise, MaNoiseType type) @cname("ma_noise_set_type");
extern fn MaResourceManagerPipelineNotifications resource_manager_pipeline_notifications_init() @cname("ma_resource_manager_pipeline_notifications_init");
extern fn MaResourceManagerDataSourceConfig resource_manager_data_source_config_init() @cname("ma_resource_manager_data_source_config_init");
extern fn MaResourceManagerConfig resource_manager_config_init() @cname("ma_resource_manager_config_init");
extern fn MaResult resource_manager_init(MaResourceManagerConfig* p_config, MaResourceManager* p_resource_manager) @cname("ma_resource_manager_init");
extern fn void resource_manager_uninit(MaResourceManager* p_resource_manager) @cname("ma_resource_manager_uninit");
extern fn MaLog* resource_manager_get_log(MaResourceManager* p_resource_manager) @cname("ma_resource_manager_get_log");
extern fn MaResult resource_manager_register_file(MaResourceManager* p_resource_manager, ZString p_file_path, uint flags) @cname("ma_resource_manager_register_file");
extern fn MaResult resource_manager_register_file_w(MaResourceManager* p_resource_manager, WcharT* p_file_path, uint flags) @cname("ma_resource_manager_register_file_w");
extern fn MaResult resource_manager_register_decoded_data(MaResourceManager* p_resource_manager, ZString p_name, void* p_data, ulong frame_count, MaFormat format, uint channels, uint sample_rate) @cname("ma_resource_manager_register_decoded_data");
extern fn MaResult resource_manager_register_decoded_data_w(MaResourceManager* p_resource_manager, WcharT* p_name, void* p_data, ulong frame_count, MaFormat format, uint channels, uint sample_rate) @cname("ma_resource_manager_register_decoded_data_w");
extern fn MaResult resource_manager_register_encoded_data(MaResourceManager* p_resource_manager, ZString p_name, void* p_data, usz size_in_bytes) @cname("ma_resource_manager_register_encoded_data");
extern fn MaResult resource_manager_register_encoded_data_w(MaResourceManager* p_resource_manager, WcharT* p_name, void* p_data, usz size_in_bytes) @cname("ma_resource_manager_register_encoded_data_w");
extern fn MaResult resource_manager_unregister_file(MaResourceManager* p_resource_manager, ZString p_file_path) @cname("ma_resource_manager_unregister_file");
extern fn MaResult resource_manager_unregister_file_w(MaResourceManager* p_resource_manager, WcharT* p_file_path) @cname("ma_resource_manager_unregister_file_w");
extern fn MaResult resource_manager_unregister_data(MaResourceManager* p_resource_manager, ZString p_name) @cname("ma_resource_manager_unregister_data");
extern fn MaResult resource_manager_unregister_data_w(MaResourceManager* p_resource_manager, WcharT* p_name) @cname("ma_resource_manager_unregister_data_w");
extern fn MaResult resource_manager_data_buffer_init_ex(MaResourceManager* p_resource_manager, MaResourceManagerDataSourceConfig* p_config, MaResourceManagerDataBuffer* p_data_buffer) @cname("ma_resource_manager_data_buffer_init_ex");
extern fn MaResult resource_manager_data_buffer_init(MaResourceManager* p_resource_manager, ZString p_file_path, uint flags, MaResourceManagerPipelineNotifications* p_notifications, MaResourceManagerDataBuffer* p_data_buffer) @cname("ma_resource_manager_data_buffer_init");
extern fn MaResult resource_manager_data_buffer_init_w(MaResourceManager* p_resource_manager, WcharT* p_file_path, uint flags, MaResourceManagerPipelineNotifications* p_notifications, MaResourceManagerDataBuffer* p_data_buffer) @cname("ma_resource_manager_data_buffer_init_w");
extern fn MaResult resource_manager_data_buffer_init_copy(MaResourceManager* p_resource_manager, MaResourceManagerDataBuffer* p_existing_data_buffer, MaResourceManagerDataBuffer* p_data_buffer) @cname("ma_resource_manager_data_buffer_init_copy");
extern fn MaResult resource_manager_data_buffer_uninit(MaResourceManagerDataBuffer* p_data_buffer) @cname("ma_resource_manager_data_buffer_uninit");
extern fn MaResult resource_manager_data_buffer_read_pcm_frames(MaResourceManagerDataBuffer* p_data_buffer, void* p_frames_out, ulong frame_count, MaUint64* p_frames_read) @cname("ma_resource_manager_data_buffer_read_pcm_frames");
extern fn MaResult resource_manager_data_buffer_seek_to_pcm_frame(MaResourceManagerDataBuffer* p_data_buffer, ulong frame_index) @cname("ma_resource_manager_data_buffer_seek_to_pcm_frame");
extern fn MaResult resource_manager_data_buffer_get_data_format(MaResourceManagerDataBuffer* p_data_buffer, MaFormat* p_format, MaUint32* p_channels, MaUint32* p_sample_rate, MaChannel* p_channel_map, usz channel_map_cap) @cname("ma_resource_manager_data_buffer_get_data_format");
extern fn MaResult resource_manager_data_buffer_get_cursor_in_pcm_frames(MaResourceManagerDataBuffer* p_data_buffer, MaUint64* p_cursor) @cname("ma_resource_manager_data_buffer_get_cursor_in_pcm_frames");
extern fn MaResult resource_manager_data_buffer_get_length_in_pcm_frames(MaResourceManagerDataBuffer* p_data_buffer, MaUint64* p_length) @cname("ma_resource_manager_data_buffer_get_length_in_pcm_frames");
extern fn MaResult resource_manager_data_buffer_result(MaResourceManagerDataBuffer* p_data_buffer) @cname("ma_resource_manager_data_buffer_result");
extern fn MaResult resource_manager_data_buffer_set_looping(MaResourceManagerDataBuffer* p_data_buffer, uint is_looping) @cname("ma_resource_manager_data_buffer_set_looping");
extern fn MaBool32 resource_manager_data_buffer_is_looping(MaResourceManagerDataBuffer* p_data_buffer) @cname("ma_resource_manager_data_buffer_is_looping");
extern fn MaResult resource_manager_data_buffer_get_available_frames(MaResourceManagerDataBuffer* p_data_buffer, MaUint64* p_available_frames) @cname("ma_resource_manager_data_buffer_get_available_frames");
extern fn MaResult resource_manager_data_stream_init_ex(MaResourceManager* p_resource_manager, MaResourceManagerDataSourceConfig* p_config, MaResourceManagerDataStream* p_data_stream) @cname("ma_resource_manager_data_stream_init_ex");
extern fn MaResult resource_manager_data_stream_init(MaResourceManager* p_resource_manager, ZString p_file_path, uint flags, MaResourceManagerPipelineNotifications* p_notifications, MaResourceManagerDataStream* p_data_stream) @cname("ma_resource_manager_data_stream_init");
extern fn MaResult resource_manager_data_stream_init_w(MaResourceManager* p_resource_manager, WcharT* p_file_path, uint flags, MaResourceManagerPipelineNotifications* p_notifications, MaResourceManagerDataStream* p_data_stream) @cname("ma_resource_manager_data_stream_init_w");
extern fn MaResult resource_manager_data_stream_uninit(MaResourceManagerDataStream* p_data_stream) @cname("ma_resource_manager_data_stream_uninit");
extern fn MaResult resource_manager_data_stream_read_pcm_frames(MaResourceManagerDataStream* p_data_stream, void* p_frames_out, ulong frame_count, MaUint64* p_frames_read) @cname("ma_resource_manager_data_stream_read_pcm_frames");
extern fn MaResult resource_manager_data_stream_seek_to_pcm_frame(MaResourceManagerDataStream* p_data_stream, ulong frame_index) @cname("ma_resource_manager_data_stream_seek_to_pcm_frame");
extern fn MaResult resource_manager_data_stream_get_data_format(MaResourceManagerDataStream* p_data_stream, MaFormat* p_format, MaUint32* p_channels, MaUint32* p_sample_rate, MaChannel* p_channel_map, usz channel_map_cap) @cname("ma_resource_manager_data_stream_get_data_format");
extern fn MaResult resource_manager_data_stream_get_cursor_in_pcm_frames(MaResourceManagerDataStream* p_data_stream, MaUint64* p_cursor) @cname("ma_resource_manager_data_stream_get_cursor_in_pcm_frames");
extern fn MaResult resource_manager_data_stream_get_length_in_pcm_frames(MaResourceManagerDataStream* p_data_stream, MaUint64* p_length) @cname("ma_resource_manager_data_stream_get_length_in_pcm_frames");
extern fn MaResult resource_manager_data_stream_result(MaResourceManagerDataStream* p_data_stream) @cname("ma_resource_manager_data_stream_result");
extern fn MaResult resource_manager_data_stream_set_looping(MaResourceManagerDataStream* p_data_stream, uint is_looping) @cname("ma_resource_manager_data_stream_set_looping");
extern fn MaBool32 resource_manager_data_stream_is_looping(MaResourceManagerDataStream* p_data_stream) @cname("ma_resource_manager_data_stream_is_looping");
extern fn MaResult resource_manager_data_stream_get_available_frames(MaResourceManagerDataStream* p_data_stream, MaUint64* p_available_frames) @cname("ma_resource_manager_data_stream_get_available_frames");
extern fn MaResult resource_manager_data_source_init_ex(MaResourceManager* p_resource_manager, MaResourceManagerDataSourceConfig* p_config, MaResourceManagerDataSource* p_data_source) @cname("ma_resource_manager_data_source_init_ex");
extern fn MaResult resource_manager_data_source_init(MaResourceManager* p_resource_manager, ZString p_name, uint flags, MaResourceManagerPipelineNotifications* p_notifications, MaResourceManagerDataSource* p_data_source) @cname("ma_resource_manager_data_source_init");
extern fn MaResult resource_manager_data_source_init_w(MaResourceManager* p_resource_manager, WcharT* p_name, uint flags, MaResourceManagerPipelineNotifications* p_notifications, MaResourceManagerDataSource* p_data_source) @cname("ma_resource_manager_data_source_init_w");
extern fn MaResult resource_manager_data_source_init_copy(MaResourceManager* p_resource_manager, MaResourceManagerDataSource* p_existing_data_source, MaResourceManagerDataSource* p_data_source) @cname("ma_resource_manager_data_source_init_copy");
extern fn MaResult resource_manager_data_source_uninit(MaResourceManagerDataSource* p_data_source) @cname("ma_resource_manager_data_source_uninit");
extern fn MaResult resource_manager_data_source_read_pcm_frames(MaResourceManagerDataSource* p_data_source, void* p_frames_out, ulong frame_count, MaUint64* p_frames_read) @cname("ma_resource_manager_data_source_read_pcm_frames");
extern fn MaResult resource_manager_data_source_seek_to_pcm_frame(MaResourceManagerDataSource* p_data_source, ulong frame_index) @cname("ma_resource_manager_data_source_seek_to_pcm_frame");
extern fn MaResult resource_manager_data_source_get_data_format(MaResourceManagerDataSource* p_data_source, MaFormat* p_format, MaUint32* p_channels, MaUint32* p_sample_rate, MaChannel* p_channel_map, usz channel_map_cap) @cname("ma_resource_manager_data_source_get_data_format");
extern fn MaResult resource_manager_data_source_get_cursor_in_pcm_frames(MaResourceManagerDataSource* p_data_source, MaUint64* p_cursor) @cname("ma_resource_manager_data_source_get_cursor_in_pcm_frames");
extern fn MaResult resource_manager_data_source_get_length_in_pcm_frames(MaResourceManagerDataSource* p_data_source, MaUint64* p_length) @cname("ma_resource_manager_data_source_get_length_in_pcm_frames");
extern fn MaResult resource_manager_data_source_result(MaResourceManagerDataSource* p_data_source) @cname("ma_resource_manager_data_source_result");
extern fn MaResult resource_manager_data_source_set_looping(MaResourceManagerDataSource* p_data_source, uint is_looping) @cname("ma_resource_manager_data_source_set_looping");
extern fn MaBool32 resource_manager_data_source_is_looping(MaResourceManagerDataSource* p_data_source) @cname("ma_resource_manager_data_source_is_looping");
extern fn MaResult resource_manager_data_source_get_available_frames(MaResourceManagerDataSource* p_data_source, MaUint64* p_available_frames) @cname("ma_resource_manager_data_source_get_available_frames");
extern fn MaResult resource_manager_post_job(MaResourceManager* p_resource_manager, MaJob* p_job) @cname("ma_resource_manager_post_job");
extern fn MaResult resource_manager_post_job_quit(MaResourceManager* p_resource_manager) @cname("ma_resource_manager_post_job_quit");
extern fn MaResult resource_manager_next_job(MaResourceManager* p_resource_manager, MaJob* p_job) @cname("ma_resource_manager_next_job");
extern fn MaResult resource_manager_process_job(MaResourceManager* p_resource_manager, MaJob* p_job) @cname("ma_resource_manager_process_job");
extern fn MaResult resource_manager_process_next_job(MaResourceManager* p_resource_manager) @cname("ma_resource_manager_process_next_job");
extern fn MaNodeConfig node_config_init() @cname("ma_node_config_init");
extern fn MaResult node_get_heap_size(MaNodeGraph* p_node_graph, MaNodeConfig* p_config, usz* p_heap_size_in_bytes) @cname("ma_node_get_heap_size");
extern fn MaResult node_init_preallocated(MaNodeGraph* p_node_graph, MaNodeConfig* p_config, void* p_heap, MaNode* p_node) @cname("ma_node_init_preallocated");
extern fn MaResult node_init(MaNodeGraph* p_node_graph, MaNodeConfig* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaNode* p_node) @cname("ma_node_init");
extern fn void node_uninit(MaNode* p_node, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_node_uninit");
extern fn MaNodeGraph* node_get_node_graph(MaNode* p_node) @cname("ma_node_get_node_graph");
extern fn MaUint32 node_get_input_bus_count(MaNode* p_node) @cname("ma_node_get_input_bus_count");
extern fn MaUint32 node_get_output_bus_count(MaNode* p_node) @cname("ma_node_get_output_bus_count");
extern fn MaUint32 node_get_input_channels(MaNode* p_node, uint input_bus_index) @cname("ma_node_get_input_channels");
extern fn MaUint32 node_get_output_channels(MaNode* p_node, uint output_bus_index) @cname("ma_node_get_output_channels");
extern fn MaResult node_attach_output_bus(MaNode* p_node, uint output_bus_index, MaNode* p_other_node, uint other_node_input_bus_index) @cname("ma_node_attach_output_bus");
extern fn MaResult node_detach_output_bus(MaNode* p_node, uint output_bus_index) @cname("ma_node_detach_output_bus");
extern fn MaResult node_detach_all_output_buses(MaNode* p_node) @cname("ma_node_detach_all_output_buses");
extern fn MaResult node_set_output_bus_volume(MaNode* p_node, uint output_bus_index, float volume) @cname("ma_node_set_output_bus_volume");
extern fn float node_get_output_bus_volume(MaNode* p_node, uint output_bus_index) @cname("ma_node_get_output_bus_volume");
extern fn MaResult node_set_state(MaNode* p_node, MaNodeState state) @cname("ma_node_set_state");
extern fn MaNodeState node_get_state(MaNode* p_node) @cname("ma_node_get_state");
extern fn MaResult node_set_state_time(MaNode* p_node, MaNodeState state, ulong global_time) @cname("ma_node_set_state_time");
extern fn MaUint64 node_get_state_time(MaNode* p_node, MaNodeState state) @cname("ma_node_get_state_time");
extern fn MaNodeState node_get_state_by_time(MaNode* p_node, ulong global_time) @cname("ma_node_get_state_by_time");
extern fn MaNodeState node_get_state_by_time_range(MaNode* p_node, ulong global_time_beg, ulong global_time_end) @cname("ma_node_get_state_by_time_range");
extern fn MaUint64 node_get_time(MaNode* p_node) @cname("ma_node_get_time");
extern fn MaResult node_set_time(MaNode* p_node, ulong local_time) @cname("ma_node_set_time");
extern fn MaNodeGraphConfig node_graph_config_init(uint channels) @cname("ma_node_graph_config_init");
extern fn MaResult node_graph_init(MaNodeGraphConfig* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaNodeGraph* p_node_graph) @cname("ma_node_graph_init");
extern fn void node_graph_uninit(MaNodeGraph* p_node_graph, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_node_graph_uninit");
extern fn MaNode* node_graph_get_endpoint(MaNodeGraph* p_node_graph) @cname("ma_node_graph_get_endpoint");
extern fn MaResult node_graph_read_pcm_frames(MaNodeGraph* p_node_graph, void* p_frames_out, ulong frame_count, MaUint64* p_frames_read) @cname("ma_node_graph_read_pcm_frames");
extern fn MaUint32 node_graph_get_channels(MaNodeGraph* p_node_graph) @cname("ma_node_graph_get_channels");
extern fn MaUint64 node_graph_get_time(MaNodeGraph* p_node_graph) @cname("ma_node_graph_get_time");
extern fn MaResult node_graph_set_time(MaNodeGraph* p_node_graph, ulong global_time) @cname("ma_node_graph_set_time");
extern fn MaUint32 node_graph_get_processing_size_in_frames(MaNodeGraph* p_node_graph) @cname("ma_node_graph_get_processing_size_in_frames");
extern fn MaDataSourceNodeConfig data_source_node_config_init(MaDataSource* p_data_source) @cname("ma_data_source_node_config_init");
extern fn MaResult data_source_node_init(MaNodeGraph* p_node_graph, MaDataSourceNodeConfig* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaDataSourceNode* p_data_source_node) @cname("ma_data_source_node_init");
extern fn void data_source_node_uninit(MaDataSourceNode* p_data_source_node, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_data_source_node_uninit");
extern fn MaResult data_source_node_set_looping(MaDataSourceNode* p_data_source_node, uint is_looping) @cname("ma_data_source_node_set_looping");
extern fn MaBool32 data_source_node_is_looping(MaDataSourceNode* p_data_source_node) @cname("ma_data_source_node_is_looping");
extern fn MaSplitterNodeConfig splitter_node_config_init(uint channels) @cname("ma_splitter_node_config_init");
extern fn MaResult splitter_node_init(MaNodeGraph* p_node_graph, MaSplitterNodeConfig* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaSplitterNode* p_splitter_node) @cname("ma_splitter_node_init");
extern fn void splitter_node_uninit(MaSplitterNode* p_splitter_node, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_splitter_node_uninit");
extern fn MaBiquadNodeConfig biquad_node_config_init(uint channels, float b0, float b1, float b2, float a0, float a1, float a2) @cname("ma_biquad_node_config_init");
extern fn MaResult biquad_node_init(MaNodeGraph* p_node_graph, MaBiquadNodeConfig* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaBiquadNode* p_node) @cname("ma_biquad_node_init");
extern fn MaResult biquad_node_reinit(MaBiquadConfig* p_config, MaBiquadNode* p_node) @cname("ma_biquad_node_reinit");
extern fn void biquad_node_uninit(MaBiquadNode* p_node, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_biquad_node_uninit");
extern fn MaLpfNodeConfig lpf_node_config_init(uint channels, uint sample_rate, double cutoff_frequency, uint order) @cname("ma_lpf_node_config_init");
extern fn MaResult lpf_node_init(MaNodeGraph* p_node_graph, MaLpfNodeConfig* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaLpfNode* p_node) @cname("ma_lpf_node_init");
extern fn MaResult lpf_node_reinit(MaLpfConfig* p_config, MaLpfNode* p_node) @cname("ma_lpf_node_reinit");
extern fn void lpf_node_uninit(MaLpfNode* p_node, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_lpf_node_uninit");
extern fn MaHpfNodeConfig hpf_node_config_init(uint channels, uint sample_rate, double cutoff_frequency, uint order) @cname("ma_hpf_node_config_init");
extern fn MaResult hpf_node_init(MaNodeGraph* p_node_graph, MaHpfNodeConfig* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaHpfNode* p_node) @cname("ma_hpf_node_init");
extern fn MaResult hpf_node_reinit(MaHpfConfig* p_config, MaHpfNode* p_node) @cname("ma_hpf_node_reinit");
extern fn void hpf_node_uninit(MaHpfNode* p_node, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_hpf_node_uninit");
extern fn MaBpfNodeConfig bpf_node_config_init(uint channels, uint sample_rate, double cutoff_frequency, uint order) @cname("ma_bpf_node_config_init");
extern fn MaResult bpf_node_init(MaNodeGraph* p_node_graph, MaBpfNodeConfig* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaBpfNode* p_node) @cname("ma_bpf_node_init");
extern fn MaResult bpf_node_reinit(MaBpfConfig* p_config, MaBpfNode* p_node) @cname("ma_bpf_node_reinit");
extern fn void bpf_node_uninit(MaBpfNode* p_node, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_bpf_node_uninit");
extern fn MaNotchNodeConfig notch_node_config_init(uint channels, uint sample_rate, double q, double frequency) @cname("ma_notch_node_config_init");
extern fn MaResult notch_node_init(MaNodeGraph* p_node_graph, MaNotchNodeConfig* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaNotchNode* p_node) @cname("ma_notch_node_init");
extern fn MaResult notch_node_reinit(MaNotchConfig* p_config, MaNotchNode* p_node) @cname("ma_notch_node_reinit");
extern fn void notch_node_uninit(MaNotchNode* p_node, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_notch_node_uninit");
extern fn MaPeakNodeConfig peak_node_config_init(uint channels, uint sample_rate, double gain_db, double q, double frequency) @cname("ma_peak_node_config_init");
extern fn MaResult peak_node_init(MaNodeGraph* p_node_graph, MaPeakNodeConfig* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaPeakNode* p_node) @cname("ma_peak_node_init");
extern fn MaResult peak_node_reinit(MaPeakConfig* p_config, MaPeakNode* p_node) @cname("ma_peak_node_reinit");
extern fn void peak_node_uninit(MaPeakNode* p_node, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_peak_node_uninit");
extern fn MaLoshelfNodeConfig loshelf_node_config_init(uint channels, uint sample_rate, double gain_db, double q, double frequency) @cname("ma_loshelf_node_config_init");
extern fn MaResult loshelf_node_init(MaNodeGraph* p_node_graph, MaLoshelfNodeConfig* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaLoshelfNode* p_node) @cname("ma_loshelf_node_init");
extern fn MaResult loshelf_node_reinit(MaLoshelfConfig* p_config, MaLoshelfNode* p_node) @cname("ma_loshelf_node_reinit");
extern fn void loshelf_node_uninit(MaLoshelfNode* p_node, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_loshelf_node_uninit");
extern fn MaHishelfNodeConfig hishelf_node_config_init(uint channels, uint sample_rate, double gain_db, double q, double frequency) @cname("ma_hishelf_node_config_init");
extern fn MaResult hishelf_node_init(MaNodeGraph* p_node_graph, MaHishelfNodeConfig* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaHishelfNode* p_node) @cname("ma_hishelf_node_init");
extern fn MaResult hishelf_node_reinit(MaHishelfConfig* p_config, MaHishelfNode* p_node) @cname("ma_hishelf_node_reinit");
extern fn void hishelf_node_uninit(MaHishelfNode* p_node, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_hishelf_node_uninit");
extern fn MaDelayNodeConfig delay_node_config_init(uint channels, uint sample_rate, uint delay_in_frames, float decay) @cname("ma_delay_node_config_init");
extern fn MaResult delay_node_init(MaNodeGraph* p_node_graph, MaDelayNodeConfig* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaDelayNode* p_delay_node) @cname("ma_delay_node_init");
extern fn void delay_node_uninit(MaDelayNode* p_delay_node, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_delay_node_uninit");
extern fn void delay_node_set_wet(MaDelayNode* p_delay_node, float value) @cname("ma_delay_node_set_wet");
extern fn float delay_node_get_wet(MaDelayNode* p_delay_node) @cname("ma_delay_node_get_wet");
extern fn void delay_node_set_dry(MaDelayNode* p_delay_node, float value) @cname("ma_delay_node_set_dry");
extern fn float delay_node_get_dry(MaDelayNode* p_delay_node) @cname("ma_delay_node_get_dry");
extern fn void delay_node_set_decay(MaDelayNode* p_delay_node, float value) @cname("ma_delay_node_set_decay");
extern fn float delay_node_get_decay(MaDelayNode* p_delay_node) @cname("ma_delay_node_get_decay");
extern fn MaEngineNodeConfig engine_node_config_init(MaEngine* p_engine, MaEngineNodeType type, uint flags) @cname("ma_engine_node_config_init");
extern fn MaResult engine_node_get_heap_size(MaEngineNodeConfig* p_config, usz* p_heap_size_in_bytes) @cname("ma_engine_node_get_heap_size");
extern fn MaResult engine_node_init_preallocated(MaEngineNodeConfig* p_config, void* p_heap, MaEngineNode* p_engine_node) @cname("ma_engine_node_init_preallocated");
extern fn MaResult engine_node_init(MaEngineNodeConfig* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaEngineNode* p_engine_node) @cname("ma_engine_node_init");
extern fn void engine_node_uninit(MaEngineNode* p_engine_node, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_engine_node_uninit");
extern fn MaSoundConfig sound_config_init() @cname("ma_sound_config_init");
extern fn MaSoundConfig sound_config_init_2(MaEngine* p_engine) @cname("ma_sound_config_init_2");
extern fn MaSoundGroupConfig sound_group_config_init() @cname("ma_sound_group_config_init");
extern fn MaSoundGroupConfig sound_group_config_init_2(MaEngine* p_engine) @cname("ma_sound_group_config_init_2");
extern fn MaEngineConfig engine_config_init() @cname("ma_engine_config_init");
extern fn MaResult engine_init(MaEngineConfig* p_config, MaEngine* p_engine) @cname("ma_engine_init");
extern fn void engine_uninit(MaEngine* p_engine) @cname("ma_engine_uninit");
extern fn MaResult engine_read_pcm_frames(MaEngine* p_engine, void* p_frames_out, ulong frame_count, MaUint64* p_frames_read) @cname("ma_engine_read_pcm_frames");
extern fn MaNodeGraph* engine_get_node_graph(MaEngine* p_engine) @cname("ma_engine_get_node_graph");
extern fn MaResourceManager* engine_get_resource_manager(MaEngine* p_engine) @cname("ma_engine_get_resource_manager");
extern fn MaDevice* engine_get_device(MaEngine* p_engine) @cname("ma_engine_get_device");
extern fn MaLog* engine_get_log(MaEngine* p_engine) @cname("ma_engine_get_log");
extern fn MaNode* engine_get_endpoint(MaEngine* p_engine) @cname("ma_engine_get_endpoint");
extern fn MaUint64 engine_get_time_in_pcm_frames(MaEngine* p_engine) @cname("ma_engine_get_time_in_pcm_frames");
extern fn MaUint64 engine_get_time_in_milliseconds(MaEngine* p_engine) @cname("ma_engine_get_time_in_milliseconds");
extern fn MaResult engine_set_time_in_pcm_frames(MaEngine* p_engine, ulong global_time) @cname("ma_engine_set_time_in_pcm_frames");
extern fn MaResult engine_set_time_in_milliseconds(MaEngine* p_engine, ulong global_time) @cname("ma_engine_set_time_in_milliseconds");
extern fn MaUint64 engine_get_time(MaEngine* p_engine) @cname("ma_engine_get_time");
extern fn MaResult engine_set_time(MaEngine* p_engine, ulong global_time) @cname("ma_engine_set_time");
extern fn MaUint32 engine_get_channels(MaEngine* p_engine) @cname("ma_engine_get_channels");
extern fn MaUint32 engine_get_sample_rate(MaEngine* p_engine) @cname("ma_engine_get_sample_rate");
extern fn MaResult engine_start(MaEngine* p_engine) @cname("ma_engine_start");
extern fn MaResult engine_stop(MaEngine* p_engine) @cname("ma_engine_stop");
extern fn MaResult engine_set_volume(MaEngine* p_engine, float volume) @cname("ma_engine_set_volume");
extern fn float engine_get_volume(MaEngine* p_engine) @cname("ma_engine_get_volume");
extern fn MaResult engine_set_gain_db(MaEngine* p_engine, float gain_db) @cname("ma_engine_set_gain_db");
extern fn float engine_get_gain_db(MaEngine* p_engine) @cname("ma_engine_get_gain_db");
extern fn MaUint32 engine_get_listener_count(MaEngine* p_engine) @cname("ma_engine_get_listener_count");
extern fn MaUint32 engine_find_closest_listener(MaEngine* p_engine, float absolute_pos_x, float absolute_pos_y, float absolute_pos_z) @cname("ma_engine_find_closest_listener");
extern fn void engine_listener_set_position(MaEngine* p_engine, uint listener_index, float x, float y, float z) @cname("ma_engine_listener_set_position");
extern fn MaVec3f engine_listener_get_position(MaEngine* p_engine, uint listener_index) @cname("ma_engine_listener_get_position");
extern fn void engine_listener_set_direction(MaEngine* p_engine, uint listener_index, float x, float y, float z) @cname("ma_engine_listener_set_direction");
extern fn MaVec3f engine_listener_get_direction(MaEngine* p_engine, uint listener_index) @cname("ma_engine_listener_get_direction");
extern fn void engine_listener_set_velocity(MaEngine* p_engine, uint listener_index, float x, float y, float z) @cname("ma_engine_listener_set_velocity");
extern fn MaVec3f engine_listener_get_velocity(MaEngine* p_engine, uint listener_index) @cname("ma_engine_listener_get_velocity");
extern fn void engine_listener_set_cone(MaEngine* p_engine, uint listener_index, float inner_angle_in_radians, float outer_angle_in_radians, float outer_gain) @cname("ma_engine_listener_set_cone");
extern fn void engine_listener_get_cone(MaEngine* p_engine, uint listener_index, float* p_inner_angle_in_radians, float* p_outer_angle_in_radians, float* p_outer_gain) @cname("ma_engine_listener_get_cone");
extern fn void engine_listener_set_world_up(MaEngine* p_engine, uint listener_index, float x, float y, float z) @cname("ma_engine_listener_set_world_up");
extern fn MaVec3f engine_listener_get_world_up(MaEngine* p_engine, uint listener_index) @cname("ma_engine_listener_get_world_up");
extern fn void engine_listener_set_enabled(MaEngine* p_engine, uint listener_index, uint is_enabled) @cname("ma_engine_listener_set_enabled");
extern fn MaBool32 engine_listener_is_enabled(MaEngine* p_engine, uint listener_index) @cname("ma_engine_listener_is_enabled");
extern fn MaResult engine_play_sound_ex(MaEngine* p_engine, ZString p_file_path, MaNode* p_node, uint node_input_bus_index) @cname("ma_engine_play_sound_ex");
extern fn MaResult engine_play_sound(MaEngine* p_engine, ZString p_file_path, MaSoundGroup* p_group) @cname("ma_engine_play_sound");
extern fn MaResult sound_init_from_file(MaEngine* p_engine, ZString p_file_path, uint flags, MaSoundGroup* p_group, MaFence* p_done_fence, MaSound* p_sound) @cname("ma_sound_init_from_file");
extern fn MaResult sound_init_from_file_w(MaEngine* p_engine, WcharT* p_file_path, uint flags, MaSoundGroup* p_group, MaFence* p_done_fence, MaSound* p_sound) @cname("ma_sound_init_from_file_w");
extern fn MaResult sound_init_copy(MaEngine* p_engine, MaSound* p_existing_sound, uint flags, MaSoundGroup* p_group, MaSound* p_sound) @cname("ma_sound_init_copy");
extern fn MaResult sound_init_from_data_source(MaEngine* p_engine, MaDataSource* p_data_source, uint flags, MaSoundGroup* p_group, MaSound* p_sound) @cname("ma_sound_init_from_data_source");
extern fn MaResult sound_init_ex(MaEngine* p_engine, MaSoundConfig* p_config, MaSound* p_sound) @cname("ma_sound_init_ex");
extern fn void sound_uninit(MaSound* p_sound) @cname("ma_sound_uninit");
extern fn MaEngine* sound_get_engine(MaSound* p_sound) @cname("ma_sound_get_engine");
extern fn MaDataSource* sound_get_data_source(MaSound* p_sound) @cname("ma_sound_get_data_source");
extern fn MaResult sound_start(MaSound* p_sound) @cname("ma_sound_start");
extern fn MaResult sound_stop(MaSound* p_sound) @cname("ma_sound_stop");
extern fn MaResult sound_stop_with_fade_in_pcm_frames(MaSound* p_sound, ulong fade_length_in_frames) @cname("ma_sound_stop_with_fade_in_pcm_frames");
extern fn MaResult sound_stop_with_fade_in_milliseconds(MaSound* p_sound, ulong fade_length_in_frames) @cname("ma_sound_stop_with_fade_in_milliseconds");
extern fn void sound_reset_start_time(MaSound* p_sound) @cname("ma_sound_reset_start_time");
extern fn void sound_reset_stop_time(MaSound* p_sound) @cname("ma_sound_reset_stop_time");
extern fn void sound_reset_fade(MaSound* p_sound) @cname("ma_sound_reset_fade");
extern fn void sound_reset_stop_time_and_fade(MaSound* p_sound) @cname("ma_sound_reset_stop_time_and_fade");
extern fn void sound_set_volume(MaSound* p_sound, float volume) @cname("ma_sound_set_volume");
extern fn float sound_get_volume(MaSound* p_sound) @cname("ma_sound_get_volume");
extern fn void sound_set_pan(MaSound* p_sound, float pan) @cname("ma_sound_set_pan");
extern fn float sound_get_pan(MaSound* p_sound) @cname("ma_sound_get_pan");
extern fn void sound_set_pan_mode(MaSound* p_sound, MaPanMode pan_mode) @cname("ma_sound_set_pan_mode");
extern fn MaPanMode sound_get_pan_mode(MaSound* p_sound) @cname("ma_sound_get_pan_mode");
extern fn void sound_set_pitch(MaSound* p_sound, float pitch) @cname("ma_sound_set_pitch");
extern fn float sound_get_pitch(MaSound* p_sound) @cname("ma_sound_get_pitch");
extern fn void sound_set_spatialization_enabled(MaSound* p_sound, uint enabled) @cname("ma_sound_set_spatialization_enabled");
extern fn MaBool32 sound_is_spatialization_enabled(MaSound* p_sound) @cname("ma_sound_is_spatialization_enabled");
extern fn void sound_set_pinned_listener_index(MaSound* p_sound, uint listener_index) @cname("ma_sound_set_pinned_listener_index");
extern fn MaUint32 sound_get_pinned_listener_index(MaSound* p_sound) @cname("ma_sound_get_pinned_listener_index");
extern fn MaUint32 sound_get_listener_index(MaSound* p_sound) @cname("ma_sound_get_listener_index");
extern fn MaVec3f sound_get_direction_to_listener(MaSound* p_sound) @cname("ma_sound_get_direction_to_listener");
extern fn void sound_set_position(MaSound* p_sound, float x, float y, float z) @cname("ma_sound_set_position");
extern fn MaVec3f sound_get_position(MaSound* p_sound) @cname("ma_sound_get_position");
extern fn void sound_set_direction(MaSound* p_sound, float x, float y, float z) @cname("ma_sound_set_direction");
extern fn MaVec3f sound_get_direction(MaSound* p_sound) @cname("ma_sound_get_direction");
extern fn void sound_set_velocity(MaSound* p_sound, float x, float y, float z) @cname("ma_sound_set_velocity");
extern fn MaVec3f sound_get_velocity(MaSound* p_sound) @cname("ma_sound_get_velocity");
extern fn void sound_set_attenuation_model(MaSound* p_sound, MaAttenuationModel attenuation_model) @cname("ma_sound_set_attenuation_model");
extern fn MaAttenuationModel sound_get_attenuation_model(MaSound* p_sound) @cname("ma_sound_get_attenuation_model");
extern fn void sound_set_positioning(MaSound* p_sound, MaPositioning positioning) @cname("ma_sound_set_positioning");
extern fn MaPositioning sound_get_positioning(MaSound* p_sound) @cname("ma_sound_get_positioning");
extern fn void sound_set_rolloff(MaSound* p_sound, float rolloff) @cname("ma_sound_set_rolloff");
extern fn float sound_get_rolloff(MaSound* p_sound) @cname("ma_sound_get_rolloff");
extern fn void sound_set_min_gain(MaSound* p_sound, float min_gain) @cname("ma_sound_set_min_gain");
extern fn float sound_get_min_gain(MaSound* p_sound) @cname("ma_sound_get_min_gain");
extern fn void sound_set_max_gain(MaSound* p_sound, float max_gain) @cname("ma_sound_set_max_gain");
extern fn float sound_get_max_gain(MaSound* p_sound) @cname("ma_sound_get_max_gain");
extern fn void sound_set_min_distance(MaSound* p_sound, float min_distance) @cname("ma_sound_set_min_distance");
extern fn float sound_get_min_distance(MaSound* p_sound) @cname("ma_sound_get_min_distance");
extern fn void sound_set_max_distance(MaSound* p_sound, float max_distance) @cname("ma_sound_set_max_distance");
extern fn float sound_get_max_distance(MaSound* p_sound) @cname("ma_sound_get_max_distance");
extern fn void sound_set_cone(MaSound* p_sound, float inner_angle_in_radians, float outer_angle_in_radians, float outer_gain) @cname("ma_sound_set_cone");
extern fn void sound_get_cone(MaSound* p_sound, float* p_inner_angle_in_radians, float* p_outer_angle_in_radians, float* p_outer_gain) @cname("ma_sound_get_cone");
extern fn void sound_set_doppler_factor(MaSound* p_sound, float doppler_factor) @cname("ma_sound_set_doppler_factor");
extern fn float sound_get_doppler_factor(MaSound* p_sound) @cname("ma_sound_get_doppler_factor");
extern fn void sound_set_directional_attenuation_factor(MaSound* p_sound, float directional_attenuation_factor) @cname("ma_sound_set_directional_attenuation_factor");
extern fn float sound_get_directional_attenuation_factor(MaSound* p_sound) @cname("ma_sound_get_directional_attenuation_factor");
extern fn void sound_set_fade_in_pcm_frames(MaSound* p_sound, float volume_beg, float volume_end, ulong fade_length_in_frames) @cname("ma_sound_set_fade_in_pcm_frames");
extern fn void sound_set_fade_in_milliseconds(MaSound* p_sound, float volume_beg, float volume_end, ulong fade_length_in_milliseconds) @cname("ma_sound_set_fade_in_milliseconds");
extern fn void sound_set_fade_start_in_pcm_frames(MaSound* p_sound, float volume_beg, float volume_end, ulong fade_length_in_frames, ulong absolute_global_time_in_frames) @cname("ma_sound_set_fade_start_in_pcm_frames");
extern fn void sound_set_fade_start_in_milliseconds(MaSound* p_sound, float volume_beg, float volume_end, ulong fade_length_in_milliseconds, ulong absolute_global_time_in_milliseconds) @cname("ma_sound_set_fade_start_in_milliseconds");
extern fn float sound_get_current_fade_volume(MaSound* p_sound) @cname("ma_sound_get_current_fade_volume");
extern fn void sound_set_start_time_in_pcm_frames(MaSound* p_sound, ulong absolute_global_time_in_frames) @cname("ma_sound_set_start_time_in_pcm_frames");
extern fn void sound_set_start_time_in_milliseconds(MaSound* p_sound, ulong absolute_global_time_in_milliseconds) @cname("ma_sound_set_start_time_in_milliseconds");
extern fn void sound_set_stop_time_in_pcm_frames(MaSound* p_sound, ulong absolute_global_time_in_frames) @cname("ma_sound_set_stop_time_in_pcm_frames");
extern fn void sound_set_stop_time_in_milliseconds(MaSound* p_sound, ulong absolute_global_time_in_milliseconds) @cname("ma_sound_set_stop_time_in_milliseconds");
extern fn void sound_set_stop_time_with_fade_in_pcm_frames(MaSound* p_sound, ulong stop_absolute_global_time_in_frames, ulong fade_length_in_frames) @cname("ma_sound_set_stop_time_with_fade_in_pcm_frames");
extern fn void sound_set_stop_time_with_fade_in_milliseconds(MaSound* p_sound, ulong stop_absolute_global_time_in_milliseconds, ulong fade_length_in_milliseconds) @cname("ma_sound_set_stop_time_with_fade_in_milliseconds");
extern fn MaBool32 sound_is_playing(MaSound* p_sound) @cname("ma_sound_is_playing");
extern fn MaUint64 sound_get_time_in_pcm_frames(MaSound* p_sound) @cname("ma_sound_get_time_in_pcm_frames");
extern fn MaUint64 sound_get_time_in_milliseconds(MaSound* p_sound) @cname("ma_sound_get_time_in_milliseconds");
extern fn void sound_set_looping(MaSound* p_sound, uint is_looping) @cname("ma_sound_set_looping");
extern fn MaBool32 sound_is_looping(MaSound* p_sound) @cname("ma_sound_is_looping");
extern fn MaBool32 sound_at_end(MaSound* p_sound) @cname("ma_sound_at_end");
extern fn MaResult sound_seek_to_pcm_frame(MaSound* p_sound, ulong frame_index) @cname("ma_sound_seek_to_pcm_frame");
extern fn MaResult sound_seek_to_second(MaSound* p_sound, float seek_point_in_seconds) @cname("ma_sound_seek_to_second");
extern fn MaResult sound_get_data_format(MaSound* p_sound, MaFormat* p_format, MaUint32* p_channels, MaUint32* p_sample_rate, MaChannel* p_channel_map, usz channel_map_cap) @cname("ma_sound_get_data_format");
extern fn MaResult sound_get_cursor_in_pcm_frames(MaSound* p_sound, MaUint64* p_cursor) @cname("ma_sound_get_cursor_in_pcm_frames");
extern fn MaResult sound_get_length_in_pcm_frames(MaSound* p_sound, MaUint64* p_length) @cname("ma_sound_get_length_in_pcm_frames");
extern fn MaResult sound_get_cursor_in_seconds(MaSound* p_sound, float* p_cursor) @cname("ma_sound_get_cursor_in_seconds");
extern fn MaResult sound_get_length_in_seconds(MaSound* p_sound, float* p_length) @cname("ma_sound_get_length_in_seconds");
extern fn MaResult sound_set_end_callback(MaSound* p_sound, MaSoundEndProc callback, void* p_user_data) @cname("ma_sound_set_end_callback");
extern fn MaResult sound_group_init(MaEngine* p_engine, uint flags, MaSoundGroup* p_parent_group, MaSoundGroup* p_group) @cname("ma_sound_group_init");
extern fn MaResult sound_group_init_ex(MaEngine* p_engine, MaSoundGroupConfig* p_config, MaSoundGroup* p_group) @cname("ma_sound_group_init_ex");
extern fn void sound_group_uninit(MaSoundGroup* p_group) @cname("ma_sound_group_uninit");
extern fn MaEngine* sound_group_get_engine(MaSoundGroup* p_group) @cname("ma_sound_group_get_engine");
extern fn MaResult sound_group_start(MaSoundGroup* p_group) @cname("ma_sound_group_start");
extern fn MaResult sound_group_stop(MaSoundGroup* p_group) @cname("ma_sound_group_stop");
extern fn void sound_group_set_volume(MaSoundGroup* p_group, float volume) @cname("ma_sound_group_set_volume");
extern fn float sound_group_get_volume(MaSoundGroup* p_group) @cname("ma_sound_group_get_volume");
extern fn void sound_group_set_pan(MaSoundGroup* p_group, float pan) @cname("ma_sound_group_set_pan");
extern fn float sound_group_get_pan(MaSoundGroup* p_group) @cname("ma_sound_group_get_pan");
extern fn void sound_group_set_pan_mode(MaSoundGroup* p_group, MaPanMode pan_mode) @cname("ma_sound_group_set_pan_mode");
extern fn MaPanMode sound_group_get_pan_mode(MaSoundGroup* p_group) @cname("ma_sound_group_get_pan_mode");
extern fn void sound_group_set_pitch(MaSoundGroup* p_group, float pitch) @cname("ma_sound_group_set_pitch");
extern fn float sound_group_get_pitch(MaSoundGroup* p_group) @cname("ma_sound_group_get_pitch");
extern fn void sound_group_set_spatialization_enabled(MaSoundGroup* p_group, uint enabled) @cname("ma_sound_group_set_spatialization_enabled");
extern fn MaBool32 sound_group_is_spatialization_enabled(MaSoundGroup* p_group) @cname("ma_sound_group_is_spatialization_enabled");
extern fn void sound_group_set_pinned_listener_index(MaSoundGroup* p_group, uint listener_index) @cname("ma_sound_group_set_pinned_listener_index");
extern fn MaUint32 sound_group_get_pinned_listener_index(MaSoundGroup* p_group) @cname("ma_sound_group_get_pinned_listener_index");
extern fn MaUint32 sound_group_get_listener_index(MaSoundGroup* p_group) @cname("ma_sound_group_get_listener_index");
extern fn MaVec3f sound_group_get_direction_to_listener(MaSoundGroup* p_group) @cname("ma_sound_group_get_direction_to_listener");
extern fn void sound_group_set_position(MaSoundGroup* p_group, float x, float y, float z) @cname("ma_sound_group_set_position");
extern fn MaVec3f sound_group_get_position(MaSoundGroup* p_group) @cname("ma_sound_group_get_position");
extern fn void sound_group_set_direction(MaSoundGroup* p_group, float x, float y, float z) @cname("ma_sound_group_set_direction");
extern fn MaVec3f sound_group_get_direction(MaSoundGroup* p_group) @cname("ma_sound_group_get_direction");
extern fn void sound_group_set_velocity(MaSoundGroup* p_group, float x, float y, float z) @cname("ma_sound_group_set_velocity");
extern fn MaVec3f sound_group_get_velocity(MaSoundGroup* p_group) @cname("ma_sound_group_get_velocity");
extern fn void sound_group_set_attenuation_model(MaSoundGroup* p_group, MaAttenuationModel attenuation_model) @cname("ma_sound_group_set_attenuation_model");
extern fn MaAttenuationModel sound_group_get_attenuation_model(MaSoundGroup* p_group) @cname("ma_sound_group_get_attenuation_model");
extern fn void sound_group_set_positioning(MaSoundGroup* p_group, MaPositioning positioning) @cname("ma_sound_group_set_positioning");
extern fn MaPositioning sound_group_get_positioning(MaSoundGroup* p_group) @cname("ma_sound_group_get_positioning");
extern fn void sound_group_set_rolloff(MaSoundGroup* p_group, float rolloff) @cname("ma_sound_group_set_rolloff");
extern fn float sound_group_get_rolloff(MaSoundGroup* p_group) @cname("ma_sound_group_get_rolloff");
extern fn void sound_group_set_min_gain(MaSoundGroup* p_group, float min_gain) @cname("ma_sound_group_set_min_gain");
extern fn float sound_group_get_min_gain(MaSoundGroup* p_group) @cname("ma_sound_group_get_min_gain");
extern fn void sound_group_set_max_gain(MaSoundGroup* p_group, float max_gain) @cname("ma_sound_group_set_max_gain");
extern fn float sound_group_get_max_gain(MaSoundGroup* p_group) @cname("ma_sound_group_get_max_gain");
extern fn void sound_group_set_min_distance(MaSoundGroup* p_group, float min_distance) @cname("ma_sound_group_set_min_distance");
extern fn float sound_group_get_min_distance(MaSoundGroup* p_group) @cname("ma_sound_group_get_min_distance");
extern fn void sound_group_set_max_distance(MaSoundGroup* p_group, float max_distance) @cname("ma_sound_group_set_max_distance");
extern fn float sound_group_get_max_distance(MaSoundGroup* p_group) @cname("ma_sound_group_get_max_distance");
extern fn void sound_group_set_cone(MaSoundGroup* p_group, float inner_angle_in_radians, float outer_angle_in_radians, float outer_gain) @cname("ma_sound_group_set_cone");
extern fn void sound_group_get_cone(MaSoundGroup* p_group, float* p_inner_angle_in_radians, float* p_outer_angle_in_radians, float* p_outer_gain) @cname("ma_sound_group_get_cone");
extern fn void sound_group_set_doppler_factor(MaSoundGroup* p_group, float doppler_factor) @cname("ma_sound_group_set_doppler_factor");
extern fn float sound_group_get_doppler_factor(MaSoundGroup* p_group) @cname("ma_sound_group_get_doppler_factor");
extern fn void sound_group_set_directional_attenuation_factor(MaSoundGroup* p_group, float directional_attenuation_factor) @cname("ma_sound_group_set_directional_attenuation_factor");
extern fn float sound_group_get_directional_attenuation_factor(MaSoundGroup* p_group) @cname("ma_sound_group_get_directional_attenuation_factor");
extern fn void sound_group_set_fade_in_pcm_frames(MaSoundGroup* p_group, float volume_beg, float volume_end, ulong fade_length_in_frames) @cname("ma_sound_group_set_fade_in_pcm_frames");
extern fn void sound_group_set_fade_in_milliseconds(MaSoundGroup* p_group, float volume_beg, float volume_end, ulong fade_length_in_milliseconds) @cname("ma_sound_group_set_fade_in_milliseconds");
extern fn float sound_group_get_current_fade_volume(MaSoundGroup* p_group) @cname("ma_sound_group_get_current_fade_volume");
extern fn void sound_group_set_start_time_in_pcm_frames(MaSoundGroup* p_group, ulong absolute_global_time_in_frames) @cname("ma_sound_group_set_start_time_in_pcm_frames");
extern fn void sound_group_set_start_time_in_milliseconds(MaSoundGroup* p_group, ulong absolute_global_time_in_milliseconds) @cname("ma_sound_group_set_start_time_in_milliseconds");
extern fn void sound_group_set_stop_time_in_pcm_frames(MaSoundGroup* p_group, ulong absolute_global_time_in_frames) @cname("ma_sound_group_set_stop_time_in_pcm_frames");
extern fn void sound_group_set_stop_time_in_milliseconds(MaSoundGroup* p_group, ulong absolute_global_time_in_milliseconds) @cname("ma_sound_group_set_stop_time_in_milliseconds");
extern fn MaBool32 sound_group_is_playing(MaSoundGroup* p_group) @cname("ma_sound_group_is_playing");
extern fn MaUint64 sound_group_get_time_in_pcm_frames(MaSoundGroup* p_group) @cname("ma_sound_group_get_time_in_pcm_frames");
extern fn void cpuid(int* info, int fid) @cname("ma_cpuid");
extern fn MaUint64 xgetbv(int reg) @cname("ma_xgetbv");
extern fn MaBool32 has_sse2() @cname("ma_has_sse2");
extern fn MaBool32 has_avx2() @cname("ma_has_avx2");
extern fn MaBool32 has_neon() @cname("ma_has_neon");
extern fn MaBool32 is_little_endian() @cname("ma_is_little_endian");
extern fn MaBool32 is_big_endian() @cname("ma_is_big_endian");
extern fn MaUint32 swap_endian_uint32(uint n) @cname("ma_swap_endian_uint32");
extern fn void sleep__posix(uint milliseconds) @cname("ma_sleep__posix");
extern fn void sleep(uint milliseconds) @cname("ma_sleep");
extern fn void yield() @cname("ma_yield");
extern fn uint disable_denormals() @cname("ma_disable_denormals");
extern fn void restore_denormals(uint prev_state) @cname("ma_restore_denormals");
extern fn MaBool32 is_standard_sample_rate(uint sample_rate) @cname("ma_is_standard_sample_rate");
extern fn void zero_memory_default(void* p, usz sz_) @cname("ma_zero_memory_default");
extern fn double sind(double x) @cname("ma_sind");
extern fn double expd(double x) @cname("ma_expd");
extern fn double logd(double x) @cname("ma_logd");
extern fn double powd(double x, double y) @cname("ma_powd");
extern fn double sqrtd(double x) @cname("ma_sqrtd");
extern fn float rsqrtf(float x) @cname("ma_rsqrtf");
extern fn float sinf(float x) @cname("ma_sinf");
extern fn double cosd(double x) @cname("ma_cosd");
extern fn float cosf(float x) @cname("ma_cosf");
extern fn double log10d(double x) @cname("ma_log10d");
extern fn float powf(float x, float y) @cname("ma_powf");
extern fn float log10f(float x) @cname("ma_log10f");
extern fn double degrees_to_radians(double degrees) @cname("ma_degrees_to_radians");
extern fn double radians_to_degrees(double radians) @cname("ma_radians_to_degrees");
extern fn float degrees_to_radians_f(float degrees) @cname("ma_degrees_to_radians_f");
extern fn float radians_to_degrees_f(float radians) @cname("ma_radians_to_degrees_f");
extern fn int strcpy_s(char* dst, usz dst_size_in_bytes, ZString src) @cname("ma_strcpy_s");
extern fn int wcscpy_s(WcharT* dst, usz dst_cap, WcharT* src) @cname("ma_wcscpy_s");
extern fn int strncpy_s(char* dst, usz dst_size_in_bytes, ZString src, usz count) @cname("ma_strncpy_s");
extern fn int strcat_s(char* dst, usz dst_size_in_bytes, ZString src) @cname("ma_strcat_s");
extern fn int strncat_s(char* dst, usz dst_size_in_bytes, ZString src, usz count) @cname("ma_strncat_s");
extern fn int itoa_s(int value, char* dst, usz dst_size_in_bytes, int radix) @cname("ma_itoa_s");
extern fn int strcmp(ZString str1, ZString str2) @cname("ma_strcmp");
extern fn int wcscmp(WcharT* str1, WcharT* str2) @cname("ma_wcscmp");
extern fn int strappend(char* dst, usz dst_size, ZString src_a, ZString src_b) @cname("ma_strappend");
extern fn usz wcslen(WcharT* str) @cname("ma_wcslen");
extern fn char* copy_string(ZString src, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_copy_string");
extern fn WcharT* copy_string_w(WcharT* src, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_copy_string_w");
extern fn MaResult result_from_errno(int e) @cname("ma_result_from_errno");
extern fn MaResult fopen(File** pp_file, ZString p_file_path, ZString p_open_mode) @cname("ma_fopen");
extern fn MaResult wfopen(File** pp_file, WcharT* p_file_path, WcharT* p_open_mode, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_wfopen");
extern fn void copy_memory_64(void* dst, void* src, ulong size_in_bytes) @cname("ma_copy_memory_64");
extern fn void zero_memory_64(void* dst, ulong size_in_bytes) @cname("ma_zero_memory_64");
extern fn uint next_power_of_2(uint x) @cname("ma_next_power_of_2");
extern fn uint prev_power_of_2(uint x) @cname("ma_prev_power_of_2");
extern fn uint round_to_power_of_2(uint x) @cname("ma_round_to_power_of_2");
extern fn uint count_set_bits(uint x) @cname("ma_count_set_bits");
extern fn void* _malloc_default(usz sz_, void* p_user_data) @cname("ma__malloc_default");
extern fn void* _realloc_default(void* p, usz sz_, void* p_user_data) @cname("ma__realloc_default");
extern fn void _free_default(void* p, void* p_user_data) @cname("ma__free_default");
extern fn MaAllocationCallbacks allocation_callbacks_init_default() @cname("ma_allocation_callbacks_init_default");
extern fn MaResult allocation_callbacks_init_copy(MaAllocationCallbacks* p_dst, MaAllocationCallbacks* p_src) @cname("ma_allocation_callbacks_init_copy");
extern fn void log_lock(MaLog* p_log) @cname("ma_log_lock");
extern fn void log_unlock(MaLog* p_log) @cname("ma_log_unlock");
extern fn MaUint8 clip_u8(int x) @cname("ma_clip_u8");
extern fn MaInt16 clip_s16(int x) @cname("ma_clip_s16");
extern fn MaInt64 clip_s24(long x) @cname("ma_clip_s24");
extern fn MaInt32 clip_s32(long x) @cname("ma_clip_s32");
extern fn float clip_f32(float x) @cname("ma_clip_f32");
extern fn float mix_f32(float x, float y, float a) @cname("ma_mix_f32");
extern fn float mix_f32_fast(float x, float y, float a) @cname("ma_mix_f32_fast");
extern fn M128_t mix_f32_fast__sse2(float x, float y, float a) @cname("ma_mix_f32_fast__sse2");
extern fn double mix_f64(double x, double y, double a) @cname("ma_mix_f64");
extern fn double mix_f64_fast(double x, double y, double a) @cname("ma_mix_f64_fast");
extern fn float scale_to_range_f32(float x, float lo, float hi) @cname("ma_scale_to_range_f32");
extern fn MaUint32 gcf_u32(uint a, uint b) @cname("ma_gcf_u32");
extern fn MaUint32 ffs_32(uint x) @cname("ma_ffs_32");
extern fn MaInt16 float_to_fixed_16(float x) @cname("ma_float_to_fixed_16");
extern fn void lcg_seed(MaLcg* p_lcg, int seed) @cname("ma_lcg_seed");
extern fn MaInt32 lcg_rand_s32(MaLcg* p_lcg) @cname("ma_lcg_rand_s32");
extern fn MaUint32 lcg_rand_u32(MaLcg* p_lcg) @cname("ma_lcg_rand_u32");
extern fn MaInt16 lcg_rand_s16(MaLcg* p_lcg) @cname("ma_lcg_rand_s16");
extern fn double lcg_rand_f64(MaLcg* p_lcg) @cname("ma_lcg_rand_f64");
extern fn float lcg_rand_f32(MaLcg* p_lcg) @cname("ma_lcg_rand_f32");
extern fn float lcg_rand_range_f32(MaLcg* p_lcg, float lo, float hi) @cname("ma_lcg_rand_range_f32");
extern fn MaInt32 lcg_rand_range_s32(MaLcg* p_lcg, int lo, int hi) @cname("ma_lcg_rand_range_s32");
extern fn float rand_range_f32(float lo, float hi) @cname("ma_rand_range_f32");
extern fn MaInt32 rand_range_s32(int lo, int hi) @cname("ma_rand_range_s32");
extern fn float dither_f32_rectangle(float dither_min, float dither_max) @cname("ma_dither_f32_rectangle");
extern fn float dither_f32_triangle(float dither_min, float dither_max) @cname("ma_dither_f32_triangle");
extern fn float dither_f32(MaDitherMode dither_mode, float dither_min, float dither_max) @cname("ma_dither_f32");
extern fn MaInt32 dither_s32(MaDitherMode dither_mode, int dither_min, int dither_max) @cname("ma_dither_s32");
extern fn void atomic_spinlock_lock(MaAtomicSpinlock* p_spinlock) @cname("ma_atomic_spinlock_lock");
extern fn void atomic_spinlock_unlock(MaAtomicSpinlock* p_spinlock) @cname("ma_atomic_spinlock_unlock");
extern fn MaUint8 atomic_compare_and_swap_8(MaUint8* dst, char expected, char replacement) @cname("ma_atomic_compare_and_swap_8");
extern fn MaUint16 atomic_compare_and_swap_16(MaUint16* dst, ushort expected, ushort replacement) @cname("ma_atomic_compare_and_swap_16");
extern fn MaUint32 atomic_compare_and_swap_32(MaUint32* dst, uint expected, uint replacement) @cname("ma_atomic_compare_and_swap_32");
extern fn MaUint64 atomic_compare_and_swap_64(MaUint64* dst, ulong expected, ulong replacement) @cname("ma_atomic_compare_and_swap_64");
extern fn MaBool32 atomic_is_lock_free_ptr(void** ptr) @cname("ma_atomic_is_lock_free_ptr");
extern fn void* atomic_load_explicit_ptr(void** ptr, int order) @cname("ma_atomic_load_explicit_ptr");
extern fn void atomic_store_explicit_ptr(void** dst, void* src, int order) @cname("ma_atomic_store_explicit_ptr");
extern fn void* atomic_exchange_explicit_ptr(void** dst, void* src, int order) @cname("ma_atomic_exchange_explicit_ptr");
extern fn MaBool32 atomic_compare_exchange_strong_explicit_ptr(void** dst, void** expected, void* replacement, int success_order, int failure_order) @cname("ma_atomic_compare_exchange_strong_explicit_ptr");
extern fn MaBool32 atomic_compare_exchange_weak_explicit_ptr(void** dst, void** expected, void* replacement, int success_order, int failure_order) @cname("ma_atomic_compare_exchange_weak_explicit_ptr");
extern fn void* atomic_compare_and_swap_ptr(void** dst, void* expected, void* replacement) @cname("ma_atomic_compare_and_swap_ptr");
extern fn void atomic_store_explicit_f32(float* dst, float src, int order) @cname("ma_atomic_store_explicit_f32");
extern fn void atomic_store_explicit_f64(double* dst, double src, int order) @cname("ma_atomic_store_explicit_f64");
extern fn float atomic_load_explicit_f32(float* ptr, int order) @cname("ma_atomic_load_explicit_f32");
extern fn double atomic_load_explicit_f64(double* ptr, int order) @cname("ma_atomic_load_explicit_f64");
extern fn float atomic_exchange_explicit_f32(float* dst, float src, int order) @cname("ma_atomic_exchange_explicit_f32");
extern fn double atomic_exchange_explicit_f64(double* dst, double src, int order) @cname("ma_atomic_exchange_explicit_f64");
extern fn MaBool32 atomic_compare_exchange_strong_explicit_f32(float* dst, float* expected, float replacement, int success_order, int failure_order) @cname("ma_atomic_compare_exchange_strong_explicit_f32");
extern fn MaBool32 atomic_compare_exchange_strong_explicit_f64(double* dst, double* expected, double replacement, int success_order, int failure_order) @cname("ma_atomic_compare_exchange_strong_explicit_f64");
extern fn MaBool32 atomic_compare_exchange_weak_explicit_f32(float* dst, float* expected, float replacement, int success_order, int failure_order) @cname("ma_atomic_compare_exchange_weak_explicit_f32");
extern fn MaBool32 atomic_compare_exchange_weak_explicit_f64(double* dst, double* expected, double replacement, int success_order, int failure_order) @cname("ma_atomic_compare_exchange_weak_explicit_f64");
extern fn float atomic_fetch_add_explicit_f32(float* dst, float src, int order) @cname("ma_atomic_fetch_add_explicit_f32");
extern fn double atomic_fetch_add_explicit_f64(double* dst, double src, int order) @cname("ma_atomic_fetch_add_explicit_f64");
extern fn float atomic_fetch_sub_explicit_f32(float* dst, float src, int order) @cname("ma_atomic_fetch_sub_explicit_f32");
extern fn double atomic_fetch_sub_explicit_f64(double* dst, double src, int order) @cname("ma_atomic_fetch_sub_explicit_f64");
extern fn float atomic_fetch_or_explicit_f32(float* dst, float src, int order) @cname("ma_atomic_fetch_or_explicit_f32");
extern fn double atomic_fetch_or_explicit_f64(double* dst, double src, int order) @cname("ma_atomic_fetch_or_explicit_f64");
extern fn float atomic_fetch_xor_explicit_f32(float* dst, float src, int order) @cname("ma_atomic_fetch_xor_explicit_f32");
extern fn double atomic_fetch_xor_explicit_f64(double* dst, double src, int order) @cname("ma_atomic_fetch_xor_explicit_f64");
extern fn float atomic_fetch_and_explicit_f32(float* dst, float src, int order) @cname("ma_atomic_fetch_and_explicit_f32");
extern fn double atomic_fetch_and_explicit_f64(double* dst, double src, int order) @cname("ma_atomic_fetch_and_explicit_f64");
extern fn float atomic_compare_and_swap_f32(float* dst, float expected, float replacement) @cname("ma_atomic_compare_and_swap_f32");
extern fn double atomic_compare_and_swap_f64(double* dst, double expected, double replacement) @cname("ma_atomic_compare_and_swap_f64");
extern fn MaUint32 atomic_uint32_get(MaAtomicUint32* x) @cname("ma_atomic_uint32_get");
extern fn void atomic_uint32_set(MaAtomicUint32* x, uint value) @cname("ma_atomic_uint32_set");
extern fn MaUint32 atomic_uint32_exchange(MaAtomicUint32* x, uint value) @cname("ma_atomic_uint32_exchange");
extern fn MaBool32 atomic_uint32_compare_exchange(MaAtomicUint32* x, MaUint32* expected, uint desired) @cname("ma_atomic_uint32_compare_exchange");
extern fn MaUint32 atomic_uint32_fetch_add(MaAtomicUint32* x, uint y) @cname("ma_atomic_uint32_fetch_add");
extern fn MaUint32 atomic_uint32_fetch_sub(MaAtomicUint32* x, uint y) @cname("ma_atomic_uint32_fetch_sub");
extern fn MaUint32 atomic_uint32_fetch_or(MaAtomicUint32* x, uint y) @cname("ma_atomic_uint32_fetch_or");
extern fn MaUint32 atomic_uint32_fetch_xor(MaAtomicUint32* x, uint y) @cname("ma_atomic_uint32_fetch_xor");
extern fn MaUint32 atomic_uint32_fetch_and(MaAtomicUint32* x, uint y) @cname("ma_atomic_uint32_fetch_and");
extern fn MaUint32 atomic_uint32_compare_and_swap(MaAtomicUint32* x, uint expected, uint desired) @cname("ma_atomic_uint32_compare_and_swap");
extern fn MaInt32 atomic_int32_get(MaAtomicInt32* x) @cname("ma_atomic_int32_get");
extern fn void atomic_int32_set(MaAtomicInt32* x, int value) @cname("ma_atomic_int32_set");
extern fn MaInt32 atomic_int32_exchange(MaAtomicInt32* x, int value) @cname("ma_atomic_int32_exchange");
extern fn MaBool32 atomic_int32_compare_exchange(MaAtomicInt32* x, MaInt32* expected, int desired) @cname("ma_atomic_int32_compare_exchange");
extern fn MaInt32 atomic_int32_fetch_add(MaAtomicInt32* x, int y) @cname("ma_atomic_int32_fetch_add");
extern fn MaInt32 atomic_int32_fetch_sub(MaAtomicInt32* x, int y) @cname("ma_atomic_int32_fetch_sub");
extern fn MaInt32 atomic_int32_fetch_or(MaAtomicInt32* x, int y) @cname("ma_atomic_int32_fetch_or");
extern fn MaInt32 atomic_int32_fetch_xor(MaAtomicInt32* x, int y) @cname("ma_atomic_int32_fetch_xor");
extern fn MaInt32 atomic_int32_fetch_and(MaAtomicInt32* x, int y) @cname("ma_atomic_int32_fetch_and");
extern fn MaInt32 atomic_int32_compare_and_swap(MaAtomicInt32* x, int expected, int desired) @cname("ma_atomic_int32_compare_and_swap");
extern fn MaUint64 atomic_uint64_get(MaAtomicUint64* x) @cname("ma_atomic_uint64_get");
extern fn void atomic_uint64_set(MaAtomicUint64* x, ulong value) @cname("ma_atomic_uint64_set");
extern fn MaUint64 atomic_uint64_exchange(MaAtomicUint64* x, ulong value) @cname("ma_atomic_uint64_exchange");
extern fn MaBool32 atomic_uint64_compare_exchange(MaAtomicUint64* x, MaUint64* expected, ulong desired) @cname("ma_atomic_uint64_compare_exchange");
extern fn MaUint64 atomic_uint64_fetch_add(MaAtomicUint64* x, ulong y) @cname("ma_atomic_uint64_fetch_add");
extern fn MaUint64 atomic_uint64_fetch_sub(MaAtomicUint64* x, ulong y) @cname("ma_atomic_uint64_fetch_sub");
extern fn MaUint64 atomic_uint64_fetch_or(MaAtomicUint64* x, ulong y) @cname("ma_atomic_uint64_fetch_or");
extern fn MaUint64 atomic_uint64_fetch_xor(MaAtomicUint64* x, ulong y) @cname("ma_atomic_uint64_fetch_xor");
extern fn MaUint64 atomic_uint64_fetch_and(MaAtomicUint64* x, ulong y) @cname("ma_atomic_uint64_fetch_and");
extern fn MaUint64 atomic_uint64_compare_and_swap(MaAtomicUint64* x, ulong expected, ulong desired) @cname("ma_atomic_uint64_compare_and_swap");
extern fn MaFloat atomic_float_get(MaAtomicFloat* x) @cname("ma_atomic_float_get");
extern fn void atomic_float_set(MaAtomicFloat* x, float value) @cname("ma_atomic_float_set");
extern fn MaFloat atomic_float_exchange(MaAtomicFloat* x, float value) @cname("ma_atomic_float_exchange");
extern fn MaBool32 atomic_float_compare_exchange(MaAtomicFloat* x, MaFloat* expected, float desired) @cname("ma_atomic_float_compare_exchange");
extern fn MaFloat atomic_float_fetch_add(MaAtomicFloat* x, float y) @cname("ma_atomic_float_fetch_add");
extern fn MaFloat atomic_float_fetch_sub(MaAtomicFloat* x, float y) @cname("ma_atomic_float_fetch_sub");
extern fn MaFloat atomic_float_fetch_or(MaAtomicFloat* x, float y) @cname("ma_atomic_float_fetch_or");
extern fn MaFloat atomic_float_fetch_xor(MaAtomicFloat* x, float y) @cname("ma_atomic_float_fetch_xor");
extern fn MaFloat atomic_float_fetch_and(MaAtomicFloat* x, float y) @cname("ma_atomic_float_fetch_and");
extern fn MaFloat atomic_float_compare_and_swap(MaAtomicFloat* x, float expected, float desired) @cname("ma_atomic_float_compare_and_swap");
extern fn MaBool32 atomic_bool32_get(MaAtomicBool32* x) @cname("ma_atomic_bool32_get");
extern fn void atomic_bool32_set(MaAtomicBool32* x, uint value) @cname("ma_atomic_bool32_set");
extern fn MaBool32 atomic_bool32_exchange(MaAtomicBool32* x, uint value) @cname("ma_atomic_bool32_exchange");
extern fn MaBool32 atomic_bool32_compare_exchange(MaAtomicBool32* x, MaBool32* expected, uint desired) @cname("ma_atomic_bool32_compare_exchange");
extern fn MaBool32 atomic_bool32_fetch_add(MaAtomicBool32* x, uint y) @cname("ma_atomic_bool32_fetch_add");
extern fn MaBool32 atomic_bool32_fetch_sub(MaAtomicBool32* x, uint y) @cname("ma_atomic_bool32_fetch_sub");
extern fn MaBool32 atomic_bool32_fetch_or(MaAtomicBool32* x, uint y) @cname("ma_atomic_bool32_fetch_or");
extern fn MaBool32 atomic_bool32_fetch_xor(MaAtomicBool32* x, uint y) @cname("ma_atomic_bool32_fetch_xor");
extern fn MaBool32 atomic_bool32_fetch_and(MaAtomicBool32* x, uint y) @cname("ma_atomic_bool32_fetch_and");
extern fn MaBool32 atomic_bool32_compare_and_swap(MaAtomicBool32* x, uint expected, uint desired) @cname("ma_atomic_bool32_compare_and_swap");
extern fn MaDeviceState atomic_device_state_get(MaAtomicDeviceState* x) @cname("ma_atomic_device_state_get");
extern fn void atomic_device_state_set(MaAtomicDeviceState* x, MaDeviceState value) @cname("ma_atomic_device_state_set");
extern fn MaDeviceState atomic_device_state_exchange(MaAtomicDeviceState* x, MaDeviceState value) @cname("ma_atomic_device_state_exchange");
extern fn MaBool32 atomic_device_state_compare_exchange(MaAtomicDeviceState* x, MaDeviceState* expected, MaDeviceState desired) @cname("ma_atomic_device_state_compare_exchange");
extern fn MaDeviceState atomic_device_state_fetch_add(MaAtomicDeviceState* x, MaDeviceState y) @cname("ma_atomic_device_state_fetch_add");
extern fn MaDeviceState atomic_device_state_fetch_sub(MaAtomicDeviceState* x, MaDeviceState y) @cname("ma_atomic_device_state_fetch_sub");
extern fn MaDeviceState atomic_device_state_fetch_or(MaAtomicDeviceState* x, MaDeviceState y) @cname("ma_atomic_device_state_fetch_or");
extern fn MaDeviceState atomic_device_state_fetch_xor(MaAtomicDeviceState* x, MaDeviceState y) @cname("ma_atomic_device_state_fetch_xor");
extern fn MaDeviceState atomic_device_state_fetch_and(MaAtomicDeviceState* x, MaDeviceState y) @cname("ma_atomic_device_state_fetch_and");
extern fn MaDeviceState atomic_device_state_compare_and_swap(MaAtomicDeviceState* x, MaDeviceState expected, MaDeviceState desired) @cname("ma_atomic_device_state_compare_and_swap");
extern fn MaUint64 calculate_frame_count_after_resampling(uint sample_rate_out, uint sample_rate_in, ulong frame_count_in) @cname("ma_calculate_frame_count_after_resampling");
extern fn MaResult spinlock_lock_ex(MaSpinlock* p_spinlock, uint yield) @cname("ma_spinlock_lock_ex");
extern fn MaResult thread_create__posix(MaThread* p_thread, MaThreadPriority priority, usz stack_size, MaThreadEntryProc entry_proc, void* p_data) @cname("ma_thread_create__posix");
extern fn void thread_wait__posix(MaThread* p_thread) @cname("ma_thread_wait__posix");
extern fn MaResult mutex_init__posix(MaMutex* p_mutex) @cname("ma_mutex_init__posix");
extern fn void mutex_uninit__posix(MaMutex* p_mutex) @cname("ma_mutex_uninit__posix");
extern fn void mutex_lock__posix(MaMutex* p_mutex) @cname("ma_mutex_lock__posix");
extern fn void mutex_unlock__posix(MaMutex* p_mutex) @cname("ma_mutex_unlock__posix");
extern fn MaResult event_init__posix(MaEvent* p_event) @cname("ma_event_init__posix");
extern fn void event_uninit__posix(MaEvent* p_event) @cname("ma_event_uninit__posix");
extern fn MaResult event_wait__posix(MaEvent* p_event) @cname("ma_event_wait__posix");
extern fn MaResult event_signal__posix(MaEvent* p_event) @cname("ma_event_signal__posix");
extern fn MaResult semaphore_init__posix(int initial_value, MaSemaphore* p_semaphore) @cname("ma_semaphore_init__posix");
extern fn void semaphore_uninit__posix(MaSemaphore* p_semaphore) @cname("ma_semaphore_uninit__posix");
extern fn MaResult semaphore_wait__posix(MaSemaphore* p_semaphore) @cname("ma_semaphore_wait__posix");
extern fn MaResult semaphore_release__posix(MaSemaphore* p_semaphore) @cname("ma_semaphore_release__posix");
extern fn MaThreadResult thread_entry_proxy(void* p_data) @cname("ma_thread_entry_proxy");
extern fn MaResult thread_create(MaThread* p_thread, MaThreadPriority priority, usz stack_size, MaThreadEntryProc entry_proc, void* p_data, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_thread_create");
extern fn void thread_wait(MaThread* p_thread) @cname("ma_thread_wait");
extern fn void async_notification_poll__on_signal(MaAsyncNotification* p_notification) @cname("ma_async_notification_poll__on_signal");
extern fn void async_notification_event__on_signal(MaAsyncNotification* p_notification) @cname("ma_async_notification_event__on_signal");
extern fn MaUint32 slot_allocator_calculate_group_capacity(uint slot_capacity) @cname("ma_slot_allocator_calculate_group_capacity");
extern fn MaUint32 slot_allocator_group_capacity(MaSlotAllocator* p_allocator) @cname("ma_slot_allocator_group_capacity");
extern fn MaResult slot_allocator_get_heap_layout(MaSlotAllocatorConfig* p_config, MaSlotAllocatorHeapLayout* p_heap_layout) @cname("ma_slot_allocator_get_heap_layout");
extern fn MaUint32 job_extract_refcount(ulong toc) @cname("ma_job_extract_refcount");
extern fn MaUint16 job_extract_slot(ulong toc) @cname("ma_job_extract_slot");
extern fn MaUint64 job_toc_to_allocation(ulong toc) @cname("ma_job_toc_to_allocation");
extern fn MaUint64 job_set_refcount(ulong toc, uint refcount) @cname("ma_job_set_refcount");
extern fn MaResult job_process__noop(MaJob* p_job) @cname("ma_job_process__noop");
extern fn MaResult job_process__quit(MaJob* p_job) @cname("ma_job_process__quit");
extern fn MaResult job_process__custom(MaJob* p_job) @cname("ma_job_process__custom");
extern fn MaResult job_process__resource_manager__load_data_buffer_node(MaJob* p_job) @cname("ma_job_process__resource_manager__load_data_buffer_node");
extern fn MaResult job_process__resource_manager__free_data_buffer_node(MaJob* p_job) @cname("ma_job_process__resource_manager__free_data_buffer_node");
extern fn MaResult job_process__resource_manager__page_data_buffer_node(MaJob* p_job) @cname("ma_job_process__resource_manager__page_data_buffer_node");
extern fn MaResult job_process__resource_manager__load_data_buffer(MaJob* p_job) @cname("ma_job_process__resource_manager__load_data_buffer");
extern fn MaResult job_process__resource_manager__free_data_buffer(MaJob* p_job) @cname("ma_job_process__resource_manager__free_data_buffer");
extern fn MaResult job_process__resource_manager__load_data_stream(MaJob* p_job) @cname("ma_job_process__resource_manager__load_data_stream");
extern fn MaResult job_process__resource_manager__free_data_stream(MaJob* p_job) @cname("ma_job_process__resource_manager__free_data_stream");
extern fn MaResult job_process__resource_manager__page_data_stream(MaJob* p_job) @cname("ma_job_process__resource_manager__page_data_stream");
extern fn MaResult job_process__resource_manager__seek_data_stream(MaJob* p_job) @cname("ma_job_process__resource_manager__seek_data_stream");
extern fn MaResult job_process__device__aaudio_reroute(MaJob* p_job) @cname("ma_job_process__device__aaudio_reroute");
extern fn MaResult job_queue_get_heap_layout(MaJobQueueConfig* p_config, MaJobQueueHeapLayout* p_heap_layout) @cname("ma_job_queue_get_heap_layout");
extern fn MaBool32 job_queue_cas(MaUint64* dst, ulong expected, ulong desired) @cname("ma_job_queue_cas");
extern fn MaHandle dlopen(MaLog* p_log, ZString filename) @cname("ma_dlopen");
extern fn void dlclose(MaLog* p_log, void* handle) @cname("ma_dlclose");
extern fn MaProc dlsym(MaLog* p_log, void* handle, ZString symbol) @cname("ma_dlsym");
extern fn void device_info_add_native_data_format(MaDeviceInfo* p_device_info, MaFormat format, uint channels, uint sample_rate, uint flags) @cname("ma_device_info_add_native_data_format");
extern fn void timer_init(MaTimer* p_timer) @cname("ma_timer_init");
extern fn double timer_get_time_in_seconds(MaTimer* p_timer) @cname("ma_timer_get_time_in_seconds");
extern fn uint device_disable_denormals(MaDevice* p_device) @cname("ma_device_disable_denormals");
extern fn void device_restore_denormals(MaDevice* p_device, uint prev_state) @cname("ma_device_restore_denormals");
extern fn MaDeviceNotification device_notification_init(MaDevice* p_device, MaDeviceNotificationType type) @cname("ma_device_notification_init");
extern fn void device__on_notification(MaDeviceNotification notification) @cname("ma_device__on_notification");
extern fn void device__on_notification_started(MaDevice* p_device) @cname("ma_device__on_notification_started");
extern fn void device__on_notification_stopped(MaDevice* p_device) @cname("ma_device__on_notification_stopped");
extern fn void device__on_notification_rerouted(MaDevice* p_device) @cname("ma_device__on_notification_rerouted");
extern fn void device__on_data_inner(MaDevice* p_device, void* p_frames_out, void* p_frames_in, uint frame_count) @cname("ma_device__on_data_inner");
extern fn void device__on_data(MaDevice* p_device, void* p_frames_out, void* p_frames_in, uint frame_count) @cname("ma_device__on_data");
extern fn void device__handle_data_callback(MaDevice* p_device, void* p_frames_out, void* p_frames_in, uint frame_count) @cname("ma_device__handle_data_callback");
extern fn void device__read_frames_from_client(MaDevice* p_device, uint frame_count, void* p_frames_out) @cname("ma_device__read_frames_from_client");
extern fn void device__send_frames_to_client(MaDevice* p_device, uint frame_count_in_device_format, void* p_frames_in_device_format) @cname("ma_device__send_frames_to_client");
extern fn MaResult device__handle_duplex_callback_capture(MaDevice* p_device, uint frame_count_in_device_format, void* p_frames_in_device_format, MaPcmRb* p_rb) @cname("ma_device__handle_duplex_callback_capture");
extern fn MaResult device__handle_duplex_callback_playback(MaDevice* p_device, uint frame_count, void* p_frames_in_internal_format, MaPcmRb* p_rb) @cname("ma_device__handle_duplex_callback_playback");
extern fn void device__set_state(MaDevice* p_device, MaDeviceState new_state) @cname("ma_device__set_state");
extern fn MaUint32 get_format_priority_index(MaFormat format) @cname("ma_get_format_priority_index");
extern fn MaResult device__post_init_setup(MaDevice* p_device, MaDeviceType device_type) @cname("ma_device__post_init_setup");
extern fn MaBool32 device_descriptor_is_valid(MaDeviceDescriptor* p_device_descriptor) @cname("ma_device_descriptor_is_valid");
extern fn MaResult device_audio_thread__default_read_write(MaDevice* p_device) @cname("ma_device_audio_thread__default_read_write");
extern fn MaThreadResult device_thread__null(void* p_data) @cname("ma_device_thread__null");
extern fn MaResult device_do_operation__null(MaDevice* p_device, uint operation) @cname("ma_device_do_operation__null");
extern fn MaUint64 device_get_total_run_time_in_frames__null(MaDevice* p_device) @cname("ma_device_get_total_run_time_in_frames__null");
extern fn MaResult context_enumerate_devices__null(MaContext* p_context, MaEnumDevicesCallbackProc callback, void* p_user_data) @cname("ma_context_enumerate_devices__null");
extern fn MaResult context_get_device_info__null(MaContext* p_context, MaDeviceType device_type, MaDeviceId* p_device_id, MaDeviceInfo* p_device_info) @cname("ma_context_get_device_info__null");
extern fn MaResult device_uninit__null(MaDevice* p_device) @cname("ma_device_uninit__null");
extern fn MaResult device_init__null(MaDevice* p_device, MaDeviceConfig* p_config, MaDeviceDescriptor* p_descriptor_playback, MaDeviceDescriptor* p_descriptor_capture) @cname("ma_device_init__null");
extern fn MaResult device_start__null(MaDevice* p_device) @cname("ma_device_start__null");
extern fn MaResult device_stop__null(MaDevice* p_device) @cname("ma_device_stop__null");
extern fn MaBool32 device_is_started__null(MaDevice* p_device) @cname("ma_device_is_started__null");
extern fn MaResult device_write__null(MaDevice* p_device, void* p_pcm_frames, uint frame_count, MaUint32* p_frames_written) @cname("ma_device_write__null");
extern fn MaResult device_read__null(MaDevice* p_device, void* p_pcm_frames, uint frame_count, MaUint32* p_frames_read) @cname("ma_device_read__null");
extern fn MaResult context_uninit__null(MaContext* p_context) @cname("ma_context_uninit__null");
extern fn MaResult context_init__null(MaContext* p_context, MaContextConfig* p_config, MaBackendCallbacks* p_callbacks) @cname("ma_context_init__null");
extern fn MaSndPcmFormatT convert_ma_format_to_alsa_format(MaFormat format) @cname("ma_convert_ma_format_to_alsa_format");
extern fn MaFormat format_from_alsa(int format_alsa) @cname("ma_format_from_alsa");
extern fn MaChannel convert_alsa_channel_position_to_ma_channel(uint alsa_channel_pos) @cname("ma_convert_alsa_channel_position_to_ma_channel");
extern fn MaBool32 is_common_device_name__alsa(ZString name) @cname("ma_is_common_device_name__alsa");
extern fn MaBool32 is_playback_device_blacklisted__alsa(ZString name) @cname("ma_is_playback_device_blacklisted__alsa");
extern fn MaBool32 is_capture_device_blacklisted__alsa(ZString name) @cname("ma_is_capture_device_blacklisted__alsa");
extern fn MaBool32 is_device_blacklisted__alsa(MaDeviceType device_type, ZString name) @cname("ma_is_device_blacklisted__alsa");
extern fn ZString find_char(ZString str, char c, int* index) @cname("ma_find_char");
extern fn MaBool32 is_device_name_in_hw_format__alsa(ZString hwid) @cname("ma_is_device_name_in_hw_format__alsa");
extern fn int convert_device_name_to_hw_format__alsa(MaContext* p_context, char* dst, usz dst_size, ZString src) @cname("ma_convert_device_name_to_hw_format__alsa");
extern fn MaBool32 does_id_exist_in_list__alsa(MaDeviceId* p_unique_i_ds, uint count, ZString p_hwid) @cname("ma_does_id_exist_in_list__alsa");
extern fn MaResult context_open_pcm__alsa(MaContext* p_context, MaShareMode share_mode, MaDeviceType device_type, MaDeviceId* p_device_id, int open_mode, MaSndPcmT** pp_pcm) @cname("ma_context_open_pcm__alsa");
extern fn MaResult context_enumerate_devices__alsa(MaContext* p_context, MaEnumDevicesCallbackProc callback, void* p_user_data) @cname("ma_context_enumerate_devices__alsa");
extern fn MaBool32 context_get_device_info_enum_callback__alsa(MaContext* p_context, MaDeviceType device_type, MaDeviceInfo* p_device_info, void* p_user_data) @cname("ma_context_get_device_info_enum_callback__alsa");
extern fn void context_test_rate_and_add_native_data_format__alsa(MaContext* p_context, MaSndPcmT* p_pcm, MaSndPcmHwParamsT* p_hw_params, MaFormat format, uint channels, uint sample_rate, uint flags, MaDeviceInfo* p_device_info) @cname("ma_context_test_rate_and_add_native_data_format__alsa");
extern fn void context_iterate_rates_and_add_native_data_format__alsa(MaContext* p_context, MaSndPcmT* p_pcm, MaSndPcmHwParamsT* p_hw_params, MaFormat format, uint channels, uint flags, MaDeviceInfo* p_device_info) @cname("ma_context_iterate_rates_and_add_native_data_format__alsa");
extern fn MaResult context_get_device_info__alsa(MaContext* p_context, MaDeviceType device_type, MaDeviceId* p_device_id, MaDeviceInfo* p_device_info) @cname("ma_context_get_device_info__alsa");
extern fn MaResult device_uninit__alsa(MaDevice* p_device) @cname("ma_device_uninit__alsa");
extern fn MaResult device_init_by_type__alsa(MaDevice* p_device, MaDeviceConfig* p_config, MaDeviceDescriptor* p_descriptor, MaDeviceType device_type) @cname("ma_device_init_by_type__alsa");
extern fn MaResult device_init__alsa(MaDevice* p_device, MaDeviceConfig* p_config, MaDeviceDescriptor* p_descriptor_playback, MaDeviceDescriptor* p_descriptor_capture) @cname("ma_device_init__alsa");
extern fn MaResult device_start__alsa(MaDevice* p_device) @cname("ma_device_start__alsa");
extern fn MaResult device_stop__alsa(MaDevice* p_device) @cname("ma_device_stop__alsa");
extern fn MaResult device_wait__alsa(MaDevice* p_device, MaSndPcmT* p_pcm, Pollfd* p_poll_descriptors, int poll_descriptor_count, short required_event) @cname("ma_device_wait__alsa");
extern fn MaResult device_wait_read__alsa(MaDevice* p_device) @cname("ma_device_wait_read__alsa");
extern fn MaResult device_wait_write__alsa(MaDevice* p_device) @cname("ma_device_wait_write__alsa");
extern fn MaResult device_read__alsa(MaDevice* p_device, void* p_frames_out, uint frame_count, MaUint32* p_frames_read) @cname("ma_device_read__alsa");
extern fn MaResult device_write__alsa(MaDevice* p_device, void* p_frames, uint frame_count, MaUint32* p_frames_written) @cname("ma_device_write__alsa");
extern fn MaResult device_data_loop_wakeup__alsa(MaDevice* p_device) @cname("ma_device_data_loop_wakeup__alsa");
extern fn MaResult context_uninit__alsa(MaContext* p_context) @cname("ma_context_uninit__alsa");
extern fn MaResult context_init__alsa(MaContext* p_context, MaContextConfig* p_config, MaBackendCallbacks* p_callbacks) @cname("ma_context_init__alsa");
extern fn MaResult result_from_pulse(int result) @cname("ma_result_from_pulse");
extern fn MaFormat format_from_pulse(int format) @cname("ma_format_from_pulse");
extern fn MaChannel channel_position_from_pulse(int position) @cname("ma_channel_position_from_pulse");
extern fn MaResult wait_for_operation__pulse(MaContext* p_context, void* p_main_loop, MaPaOperation* p_op) @cname("ma_wait_for_operation__pulse");
extern fn MaResult wait_for_operation_and_unref__pulse(MaContext* p_context, void* p_main_loop, MaPaOperation* p_op) @cname("ma_wait_for_operation_and_unref__pulse");
extern fn MaResult wait_for_pa_context_to_connect__pulse(MaContext* p_context, void* p_main_loop, void* p_pulse_context) @cname("ma_wait_for_pa_context_to_connect__pulse");
extern fn MaResult wait_for_pa_stream_to_connect__pulse(MaContext* p_context, void* p_main_loop, void* p_stream) @cname("ma_wait_for_pa_stream_to_connect__pulse");
extern fn MaResult init_pa_mainloop_and_pa_context__pulse(MaContext* p_context, ZString p_application_name, ZString p_server_name, uint try_auto_spawn, MaPtr* pp_main_loop, MaPtr* pp_pulse_context) @cname("ma_init_pa_mainloop_and_pa_context__pulse");
extern fn void device_sink_info_callback(MaPaContext* p_pulse_context, MaPaSinkInfo* p_info, int end_of_list, void* p_user_data) @cname("ma_device_sink_info_callback");
extern fn void device_source_info_callback(MaPaContext* p_pulse_context, MaPaSourceInfo* p_info, int end_of_list, void* p_user_data) @cname("ma_device_source_info_callback");
extern fn MaResult context_get_sink_info__pulse(MaContext* p_context, ZString p_device_name, MaPaSinkInfo* p_sink_info) @cname("ma_context_get_sink_info__pulse");
extern fn MaResult context_get_source_info__pulse(MaContext* p_context, ZString p_device_name, MaPaSourceInfo* p_source_info) @cname("ma_context_get_source_info__pulse");
extern fn MaResult context_get_default_device_index__pulse(MaContext* p_context, MaDeviceType device_type, MaUint32* p_index) @cname("ma_context_get_default_device_index__pulse");
extern fn void context_enumerate_devices_sink_callback__pulse(MaPaContext* p_pulse_context, MaPaSinkInfo* p_sink_info, int end_of_list, void* p_user_data) @cname("ma_context_enumerate_devices_sink_callback__pulse");
extern fn void context_enumerate_devices_source_callback__pulse(MaPaContext* p_pulse_context, MaPaSourceInfo* p_source_info, int end_of_list, void* p_user_data) @cname("ma_context_enumerate_devices_source_callback__pulse");
extern fn MaResult context_enumerate_devices__pulse(MaContext* p_context, MaEnumDevicesCallbackProc callback, void* p_user_data) @cname("ma_context_enumerate_devices__pulse");
extern fn void context_get_device_info_sink_callback__pulse(MaPaContext* p_pulse_context, MaPaSinkInfo* p_info, int end_of_list, void* p_user_data) @cname("ma_context_get_device_info_sink_callback__pulse");
extern fn void context_get_device_info_source_callback__pulse(MaPaContext* p_pulse_context, MaPaSourceInfo* p_info, int end_of_list, void* p_user_data) @cname("ma_context_get_device_info_source_callback__pulse");
extern fn MaResult context_get_device_info__pulse(MaContext* p_context, MaDeviceType device_type, MaDeviceId* p_device_id, MaDeviceInfo* p_device_info) @cname("ma_context_get_device_info__pulse");
extern fn MaResult device_uninit__pulse(MaDevice* p_device) @cname("ma_device_uninit__pulse");
extern fn MaPaBufferAttr device__pa_buffer_attr_new(uint period_size_in_frames, uint periods, MaPaSampleSpec* ss) @cname("ma_device__pa_buffer_attr_new");
extern fn MaPaStream* device__pa_stream_new__pulse(MaDevice* p_device, ZString p_stream_name, MaPaSampleSpec* ss, MaPaChannelMap* cmap) @cname("ma_device__pa_stream_new__pulse");
extern fn void device_on_read__pulse(MaPaStream* p_stream, usz byte_count, void* p_user_data) @cname("ma_device_on_read__pulse");
extern fn MaResult device_write_to_stream__pulse(MaDevice* p_device, MaPaStream* p_stream, MaUint64* p_frames_processed) @cname("ma_device_write_to_stream__pulse");
extern fn void device_on_write__pulse(MaPaStream* p_stream, usz byte_count, void* p_user_data) @cname("ma_device_on_write__pulse");
extern fn void device_on_suspended__pulse(MaPaStream* p_stream, void* p_user_data) @cname("ma_device_on_suspended__pulse");
extern fn void device_on_rerouted__pulse(MaPaStream* p_stream, void* p_user_data) @cname("ma_device_on_rerouted__pulse");
extern fn MaUint32 calculate_period_size_in_frames_from_descriptor__pulse(MaDeviceDescriptor* p_descriptor, uint native_sample_rate, MaPerformanceProfile performance_profile) @cname("ma_calculate_period_size_in_frames_from_descriptor__pulse");
extern fn MaResult device_init__pulse(MaDevice* p_device, MaDeviceConfig* p_config, MaDeviceDescriptor* p_descriptor_playback, MaDeviceDescriptor* p_descriptor_capture) @cname("ma_device_init__pulse");
extern fn void pulse_operation_complete_callback(MaPaStream* p_stream, int success, void* p_user_data) @cname("ma_pulse_operation_complete_callback");
extern fn MaResult device__cork_stream__pulse(MaDevice* p_device, MaDeviceType device_type, int cork) @cname("ma_device__cork_stream__pulse");
extern fn MaResult device_start__pulse(MaDevice* p_device) @cname("ma_device_start__pulse");
extern fn MaResult device_stop__pulse(MaDevice* p_device) @cname("ma_device_stop__pulse");
extern fn MaResult device_data_loop__pulse(MaDevice* p_device) @cname("ma_device_data_loop__pulse");
extern fn MaResult device_data_loop_wakeup__pulse(MaDevice* p_device) @cname("ma_device_data_loop_wakeup__pulse");
extern fn MaResult context_uninit__pulse(MaContext* p_context) @cname("ma_context_uninit__pulse");
extern fn MaResult context_init__pulse(MaContext* p_context, MaContextConfig* p_config, MaBackendCallbacks* p_callbacks) @cname("ma_context_init__pulse");
extern fn MaResult context_open_client__jack(MaContext* p_context, MaJackClientT** pp_client) @cname("ma_context_open_client__jack");
extern fn MaResult context_enumerate_devices__jack(MaContext* p_context, MaEnumDevicesCallbackProc callback, void* p_user_data) @cname("ma_context_enumerate_devices__jack");
extern fn MaResult context_get_device_info__jack(MaContext* p_context, MaDeviceType device_type, MaDeviceId* p_device_id, MaDeviceInfo* p_device_info) @cname("ma_context_get_device_info__jack");
extern fn MaResult device_uninit__jack(MaDevice* p_device) @cname("ma_device_uninit__jack");
extern fn void device__jack_shutdown_callback(void* p_user_data) @cname("ma_device__jack_shutdown_callback");
extern fn int device__jack_buffer_size_callback(uint frame_count, void* p_user_data) @cname("ma_device__jack_buffer_size_callback");
extern fn int device__jack_process_callback(uint frame_count, void* p_user_data) @cname("ma_device__jack_process_callback");
extern fn MaResult device_init__jack(MaDevice* p_device, MaDeviceConfig* p_config, MaDeviceDescriptor* p_descriptor_playback, MaDeviceDescriptor* p_descriptor_capture) @cname("ma_device_init__jack");
extern fn MaResult device_start__jack(MaDevice* p_device) @cname("ma_device_start__jack");
extern fn MaResult device_stop__jack(MaDevice* p_device) @cname("ma_device_stop__jack");
extern fn MaResult context_uninit__jack(MaContext* p_context) @cname("ma_context_uninit__jack");
extern fn MaResult context_init__jack(MaContext* p_context, MaContextConfig* p_config, MaBackendCallbacks* p_callbacks) @cname("ma_context_init__jack");
extern fn MaBool32 _is_channel_map_valid(MaChannel* p_channel_map, uint channels) @cname("ma__is_channel_map_valid");
extern fn MaBool32 context_is_backend_asynchronous(MaContext* p_context) @cname("ma_context_is_backend_asynchronous");
extern fn MaThreadResult worker_thread(void* p_data) @cname("ma_worker_thread");
extern fn MaBool32 device__is_initialized(MaDevice* p_device) @cname("ma_device__is_initialized");
extern fn MaResult context_uninit_backend_apis__nix(MaContext* p_context) @cname("ma_context_uninit_backend_apis__nix");
extern fn MaResult context_init_backend_apis__nix(MaContext* p_context) @cname("ma_context_init_backend_apis__nix");
extern fn MaResult context_init_backend_apis(MaContext* p_context) @cname("ma_context_init_backend_apis");
extern fn MaResult context_uninit_backend_apis(MaContext* p_context) @cname("ma_context_uninit_backend_apis");
extern fn MaThreadResult device_job_thread_entry(void* p_user_data) @cname("ma_device_job_thread_entry");
extern fn MaBool32 context_get_devices__enum_callback(MaContext* p_context, MaDeviceType device_type, MaDeviceInfo* p_info, void* p_user_data) @cname("ma_context_get_devices__enum_callback");
extern fn MaInt16 apply_volume_unclipped_u8(short x, short volume) @cname("ma_apply_volume_unclipped_u8");
extern fn MaInt32 apply_volume_unclipped_s16(int x, short volume) @cname("ma_apply_volume_unclipped_s16");
extern fn MaInt64 apply_volume_unclipped_s24(long x, short volume) @cname("ma_apply_volume_unclipped_s24");
extern fn MaInt64 apply_volume_unclipped_s32(long x, short volume) @cname("ma_apply_volume_unclipped_s32");
extern fn float apply_volume_unclipped_f32(float x, float volume) @cname("ma_apply_volume_unclipped_f32");
extern fn MaInt16 pcm_sample_f32_to_s16(float x) @cname("ma_pcm_sample_f32_to_s16");
extern fn MaInt16 pcm_sample_u8_to_s16_no_scale(char x) @cname("ma_pcm_sample_u8_to_s16_no_scale");
extern fn MaInt64 pcm_sample_s24_to_s32_no_scale(MaUint8* x) @cname("ma_pcm_sample_s24_to_s32_no_scale");
extern fn void pcm_sample_s32_to_s24_no_scale(long x, MaUint8* s24) @cname("ma_pcm_sample_s32_to_s24_no_scale");
extern fn void pcm_u8_to_u8(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_u8_to_u8");
extern fn void pcm_u8_to_s16__reference(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_u8_to_s16__reference");
extern fn void pcm_u8_to_s16__optimized(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_u8_to_s16__optimized");
extern fn void pcm_u8_to_s16__sse2(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_u8_to_s16__sse2");
extern fn void pcm_u8_to_s24__reference(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_u8_to_s24__reference");
extern fn void pcm_u8_to_s24__optimized(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_u8_to_s24__optimized");
extern fn void pcm_u8_to_s24__sse2(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_u8_to_s24__sse2");
extern fn void pcm_u8_to_s32__reference(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_u8_to_s32__reference");
extern fn void pcm_u8_to_s32__optimized(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_u8_to_s32__optimized");
extern fn void pcm_u8_to_s32__sse2(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_u8_to_s32__sse2");
extern fn void pcm_u8_to_f32__reference(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_u8_to_f32__reference");
extern fn void pcm_u8_to_f32__optimized(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_u8_to_f32__optimized");
extern fn void pcm_u8_to_f32__sse2(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_u8_to_f32__sse2");
extern fn void pcm_interleave_u8__optimized(void* dst, void** src, ulong frame_count, uint channels) @cname("ma_pcm_interleave_u8__optimized");
extern fn void pcm_interleave_u8(void* dst, void** src, ulong frame_count, uint channels) @cname("ma_pcm_interleave_u8");
extern fn void pcm_deinterleave_u8__reference(void** dst, void* src, ulong frame_count, uint channels) @cname("ma_pcm_deinterleave_u8__reference");
extern fn void pcm_deinterleave_u8__optimized(void** dst, void* src, ulong frame_count, uint channels) @cname("ma_pcm_deinterleave_u8__optimized");
extern fn void pcm_deinterleave_u8(void** dst, void* src, ulong frame_count, uint channels) @cname("ma_pcm_deinterleave_u8");
extern fn void pcm_s16_to_u8__reference(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_s16_to_u8__reference");
extern fn void pcm_s16_to_u8__optimized(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_s16_to_u8__optimized");
extern fn void pcm_s16_to_u8__sse2(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_s16_to_u8__sse2");
extern fn void pcm_s16_to_s16(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_s16_to_s16");
extern fn void pcm_s16_to_s24__reference(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_s16_to_s24__reference");
extern fn void pcm_s16_to_s24__optimized(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_s16_to_s24__optimized");
extern fn void pcm_s16_to_s24__sse2(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_s16_to_s24__sse2");
extern fn void pcm_s16_to_s32__reference(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_s16_to_s32__reference");
extern fn void pcm_s16_to_s32__optimized(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_s16_to_s32__optimized");
extern fn void pcm_s16_to_s32__sse2(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_s16_to_s32__sse2");
extern fn void pcm_s16_to_f32__reference(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_s16_to_f32__reference");
extern fn void pcm_s16_to_f32__optimized(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_s16_to_f32__optimized");
extern fn void pcm_s16_to_f32__sse2(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_s16_to_f32__sse2");
extern fn void pcm_interleave_s16__reference(void* dst, void** src, ulong frame_count, uint channels) @cname("ma_pcm_interleave_s16__reference");
extern fn void pcm_interleave_s16__optimized(void* dst, void** src, ulong frame_count, uint channels) @cname("ma_pcm_interleave_s16__optimized");
extern fn void pcm_interleave_s16(void* dst, void** src, ulong frame_count, uint channels) @cname("ma_pcm_interleave_s16");
extern fn void pcm_deinterleave_s16__reference(void** dst, void* src, ulong frame_count, uint channels) @cname("ma_pcm_deinterleave_s16__reference");
extern fn void pcm_deinterleave_s16__optimized(void** dst, void* src, ulong frame_count, uint channels) @cname("ma_pcm_deinterleave_s16__optimized");
extern fn void pcm_deinterleave_s16(void** dst, void* src, ulong frame_count, uint channels) @cname("ma_pcm_deinterleave_s16");
extern fn void pcm_s24_to_u8__reference(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_s24_to_u8__reference");
extern fn void pcm_s24_to_u8__optimized(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_s24_to_u8__optimized");
extern fn void pcm_s24_to_u8__sse2(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_s24_to_u8__sse2");
extern fn void pcm_s24_to_s16__reference(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_s24_to_s16__reference");
extern fn void pcm_s24_to_s16__optimized(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_s24_to_s16__optimized");
extern fn void pcm_s24_to_s16__sse2(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_s24_to_s16__sse2");
extern fn void pcm_s24_to_s24(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_s24_to_s24");
extern fn void pcm_s24_to_s32__reference(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_s24_to_s32__reference");
extern fn void pcm_s24_to_s32__optimized(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_s24_to_s32__optimized");
extern fn void pcm_s24_to_s32__sse2(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_s24_to_s32__sse2");
extern fn void pcm_s24_to_f32__reference(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_s24_to_f32__reference");
extern fn void pcm_s24_to_f32__optimized(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_s24_to_f32__optimized");
extern fn void pcm_s24_to_f32__sse2(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_s24_to_f32__sse2");
extern fn void pcm_interleave_s24__reference(void* dst, void** src, ulong frame_count, uint channels) @cname("ma_pcm_interleave_s24__reference");
extern fn void pcm_interleave_s24__optimized(void* dst, void** src, ulong frame_count, uint channels) @cname("ma_pcm_interleave_s24__optimized");
extern fn void pcm_interleave_s24(void* dst, void** src, ulong frame_count, uint channels) @cname("ma_pcm_interleave_s24");
extern fn void pcm_deinterleave_s24__reference(void** dst, void* src, ulong frame_count, uint channels) @cname("ma_pcm_deinterleave_s24__reference");
extern fn void pcm_deinterleave_s24__optimized(void** dst, void* src, ulong frame_count, uint channels) @cname("ma_pcm_deinterleave_s24__optimized");
extern fn void pcm_deinterleave_s24(void** dst, void* src, ulong frame_count, uint channels) @cname("ma_pcm_deinterleave_s24");
extern fn void pcm_s32_to_u8__reference(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_s32_to_u8__reference");
extern fn void pcm_s32_to_u8__optimized(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_s32_to_u8__optimized");
extern fn void pcm_s32_to_u8__sse2(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_s32_to_u8__sse2");
extern fn void pcm_s32_to_s16__reference(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_s32_to_s16__reference");
extern fn void pcm_s32_to_s16__optimized(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_s32_to_s16__optimized");
extern fn void pcm_s32_to_s16__sse2(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_s32_to_s16__sse2");
extern fn void pcm_s32_to_s24__reference(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_s32_to_s24__reference");
extern fn void pcm_s32_to_s24__optimized(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_s32_to_s24__optimized");
extern fn void pcm_s32_to_s24__sse2(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_s32_to_s24__sse2");
extern fn void pcm_s32_to_s32(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_s32_to_s32");
extern fn void pcm_s32_to_f32__reference(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_s32_to_f32__reference");
extern fn void pcm_s32_to_f32__optimized(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_s32_to_f32__optimized");
extern fn void pcm_s32_to_f32__sse2(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_s32_to_f32__sse2");
extern fn void pcm_interleave_s32__reference(void* dst, void** src, ulong frame_count, uint channels) @cname("ma_pcm_interleave_s32__reference");
extern fn void pcm_interleave_s32__optimized(void* dst, void** src, ulong frame_count, uint channels) @cname("ma_pcm_interleave_s32__optimized");
extern fn void pcm_interleave_s32(void* dst, void** src, ulong frame_count, uint channels) @cname("ma_pcm_interleave_s32");
extern fn void pcm_deinterleave_s32__reference(void** dst, void* src, ulong frame_count, uint channels) @cname("ma_pcm_deinterleave_s32__reference");
extern fn void pcm_deinterleave_s32__optimized(void** dst, void* src, ulong frame_count, uint channels) @cname("ma_pcm_deinterleave_s32__optimized");
extern fn void pcm_deinterleave_s32(void** dst, void* src, ulong frame_count, uint channels) @cname("ma_pcm_deinterleave_s32");
extern fn void pcm_f32_to_u8__reference(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_f32_to_u8__reference");
extern fn void pcm_f32_to_u8__optimized(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_f32_to_u8__optimized");
extern fn void pcm_f32_to_u8__sse2(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_f32_to_u8__sse2");
extern fn void pcm_f32_to_s16__optimized(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_f32_to_s16__optimized");
extern fn void pcm_f32_to_s16__sse2(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_f32_to_s16__sse2");
extern fn void pcm_f32_to_s24__reference(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_f32_to_s24__reference");
extern fn void pcm_f32_to_s24__optimized(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_f32_to_s24__optimized");
extern fn void pcm_f32_to_s24__sse2(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_f32_to_s24__sse2");
extern fn void pcm_f32_to_s32__reference(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_f32_to_s32__reference");
extern fn void pcm_f32_to_s32__optimized(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_f32_to_s32__optimized");
extern fn void pcm_f32_to_s32__sse2(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_f32_to_s32__sse2");
extern fn void pcm_f32_to_f32(void* dst, void* src, ulong count, MaDitherMode dither_mode) @cname("ma_pcm_f32_to_f32");
extern fn void pcm_interleave_f32__reference(void* dst, void** src, ulong frame_count, uint channels) @cname("ma_pcm_interleave_f32__reference");
extern fn void pcm_interleave_f32__optimized(void* dst, void** src, ulong frame_count, uint channels) @cname("ma_pcm_interleave_f32__optimized");
extern fn void pcm_interleave_f32(void* dst, void** src, ulong frame_count, uint channels) @cname("ma_pcm_interleave_f32");
extern fn void pcm_deinterleave_f32__reference(void** dst, void* src, ulong frame_count, uint channels) @cname("ma_pcm_deinterleave_f32__reference");
extern fn void pcm_deinterleave_f32__optimized(void** dst, void* src, ulong frame_count, uint channels) @cname("ma_pcm_deinterleave_f32__optimized");
extern fn void pcm_deinterleave_f32(void** dst, void* src, ulong frame_count, uint channels) @cname("ma_pcm_deinterleave_f32");
extern fn MaInt32 biquad_float_to_fp(double x) @cname("ma_biquad_float_to_fp");
extern fn MaResult biquad_get_heap_layout(MaBiquadConfig* p_config, MaBiquadHeapLayout* p_heap_layout) @cname("ma_biquad_get_heap_layout");
extern fn void biquad_process_pcm_frame_f32__direct_form_2_transposed(MaBiquad* p_bq, float* p_y, float* p_x) @cname("ma_biquad_process_pcm_frame_f32__direct_form_2_transposed");
extern fn void biquad_process_pcm_frame_f32(MaBiquad* p_bq, float* p_y, float* p_x) @cname("ma_biquad_process_pcm_frame_f32");
extern fn void biquad_process_pcm_frame_s16__direct_form_2_transposed(MaBiquad* p_bq, MaInt16* p_y, MaInt16* p_x) @cname("ma_biquad_process_pcm_frame_s16__direct_form_2_transposed");
extern fn void biquad_process_pcm_frame_s16(MaBiquad* p_bq, MaInt16* p_y, MaInt16* p_x) @cname("ma_biquad_process_pcm_frame_s16");
extern fn MaResult lpf1_get_heap_layout(MaLpf1Config* p_config, MaLpf1HeapLayout* p_heap_layout) @cname("ma_lpf1_get_heap_layout");
extern fn void lpf1_process_pcm_frame_f32(MaLpf1* p_lpf, float* p_y, float* p_x) @cname("ma_lpf1_process_pcm_frame_f32");
extern fn void lpf1_process_pcm_frame_s16(MaLpf1* p_lpf, MaInt16* p_y, MaInt16* p_x) @cname("ma_lpf1_process_pcm_frame_s16");
extern fn MaBiquadConfig lpf2__get_biquad_config(MaLpf2Config* p_config) @cname("ma_lpf2__get_biquad_config");
extern fn void lpf2_process_pcm_frame_s16(MaLpf2* p_lpf, MaInt16* p_frame_out, MaInt16* p_frame_in) @cname("ma_lpf2_process_pcm_frame_s16");
extern fn void lpf2_process_pcm_frame_f32(MaLpf2* p_lpf, float* p_frame_out, float* p_frame_in) @cname("ma_lpf2_process_pcm_frame_f32");
extern fn void lpf_calculate_sub_lpf_counts(uint order, MaUint32* p_lpf1_count, MaUint32* p_lpf2_count) @cname("ma_lpf_calculate_sub_lpf_counts");
extern fn MaResult lpf_get_heap_layout(MaLpfConfig* p_config, MaLpfHeapLayout* p_heap_layout) @cname("ma_lpf_get_heap_layout");
extern fn MaResult lpf_reinit__internal(MaLpfConfig* p_config, void* p_heap, MaLpf* p_lpf, uint is_new) @cname("ma_lpf_reinit__internal");
extern fn void lpf_process_pcm_frame_f32(MaLpf* p_lpf, float* p_y, void* p_x) @cname("ma_lpf_process_pcm_frame_f32");
extern fn void lpf_process_pcm_frame_s16(MaLpf* p_lpf, MaInt16* p_y, MaInt16* p_x) @cname("ma_lpf_process_pcm_frame_s16");
extern fn MaResult hpf1_get_heap_layout(MaHpf1Config* p_config, MaHpf1HeapLayout* p_heap_layout) @cname("ma_hpf1_get_heap_layout");
extern fn void hpf1_process_pcm_frame_f32(MaHpf1* p_hpf, float* p_y, float* p_x) @cname("ma_hpf1_process_pcm_frame_f32");
extern fn void hpf1_process_pcm_frame_s16(MaHpf1* p_hpf, MaInt16* p_y, MaInt16* p_x) @cname("ma_hpf1_process_pcm_frame_s16");
extern fn MaBiquadConfig hpf2__get_biquad_config(MaHpf2Config* p_config) @cname("ma_hpf2__get_biquad_config");
extern fn void hpf2_process_pcm_frame_s16(MaHpf2* p_hpf, MaInt16* p_frame_out, MaInt16* p_frame_in) @cname("ma_hpf2_process_pcm_frame_s16");
extern fn void hpf2_process_pcm_frame_f32(MaHpf2* p_hpf, float* p_frame_out, float* p_frame_in) @cname("ma_hpf2_process_pcm_frame_f32");
extern fn void hpf_calculate_sub_hpf_counts(uint order, MaUint32* p_hpf1_count, MaUint32* p_hpf2_count) @cname("ma_hpf_calculate_sub_hpf_counts");
extern fn MaResult hpf_get_heap_layout(MaHpfConfig* p_config, MaHpfHeapLayout* p_heap_layout) @cname("ma_hpf_get_heap_layout");
extern fn MaResult hpf_reinit__internal(MaHpfConfig* p_config, void* p_heap, MaHpf* p_hpf, uint is_new) @cname("ma_hpf_reinit__internal");
extern fn MaBiquadConfig bpf2__get_biquad_config(MaBpf2Config* p_config) @cname("ma_bpf2__get_biquad_config");
extern fn void bpf2_process_pcm_frame_s16(MaBpf2* p_bpf, MaInt16* p_frame_out, MaInt16* p_frame_in) @cname("ma_bpf2_process_pcm_frame_s16");
extern fn void bpf2_process_pcm_frame_f32(MaBpf2* p_bpf, float* p_frame_out, float* p_frame_in) @cname("ma_bpf2_process_pcm_frame_f32");
extern fn MaResult bpf_get_heap_layout(MaBpfConfig* p_config, MaBpfHeapLayout* p_heap_layout) @cname("ma_bpf_get_heap_layout");
extern fn MaResult bpf_reinit__internal(MaBpfConfig* p_config, void* p_heap, MaBpf* p_bpf, uint is_new) @cname("ma_bpf_reinit__internal");
extern fn MaBiquadConfig notch2__get_biquad_config(MaNotch2Config* p_config) @cname("ma_notch2__get_biquad_config");
extern fn void notch2_process_pcm_frame_s16(MaNotch2* p_filter, MaInt16* p_frame_out, MaInt16* p_frame_in) @cname("ma_notch2_process_pcm_frame_s16");
extern fn void notch2_process_pcm_frame_f32(MaNotch2* p_filter, float* p_frame_out, float* p_frame_in) @cname("ma_notch2_process_pcm_frame_f32");
extern fn MaBiquadConfig peak2__get_biquad_config(MaPeak2Config* p_config) @cname("ma_peak2__get_biquad_config");
extern fn void peak2_process_pcm_frame_s16(MaPeak2* p_filter, MaInt16* p_frame_out, MaInt16* p_frame_in) @cname("ma_peak2_process_pcm_frame_s16");
extern fn void peak2_process_pcm_frame_f32(MaPeak2* p_filter, float* p_frame_out, float* p_frame_in) @cname("ma_peak2_process_pcm_frame_f32");
extern fn MaBiquadConfig loshelf2__get_biquad_config(MaLoshelf2Config* p_config) @cname("ma_loshelf2__get_biquad_config");
extern fn void loshelf2_process_pcm_frame_s16(MaLoshelf2* p_filter, MaInt16* p_frame_out, MaInt16* p_frame_in) @cname("ma_loshelf2_process_pcm_frame_s16");
extern fn void loshelf2_process_pcm_frame_f32(MaLoshelf2* p_filter, float* p_frame_out, float* p_frame_in) @cname("ma_loshelf2_process_pcm_frame_f32");
extern fn MaBiquadConfig hishelf2__get_biquad_config(MaHishelf2Config* p_config) @cname("ma_hishelf2__get_biquad_config");
extern fn void hishelf2_process_pcm_frame_s16(MaHishelf2* p_filter, MaInt16* p_frame_out, MaInt16* p_frame_in) @cname("ma_hishelf2_process_pcm_frame_s16");
extern fn void hishelf2_process_pcm_frame_f32(MaHishelf2* p_filter, float* p_frame_out, float* p_frame_in) @cname("ma_hishelf2_process_pcm_frame_f32");
extern fn MaResult gainer_get_heap_layout(MaGainerConfig* p_config, MaGainerHeapLayout* p_heap_layout) @cname("ma_gainer_get_heap_layout");
extern fn float gainer_calculate_current_gain(MaGainer* p_gainer, uint channel) @cname("ma_gainer_calculate_current_gain");
extern fn MaResult gainer_process_pcm_frames_internal(MaGainer* p_gainer, void* p_frames_out @noalias, void* p_frames_in @noalias, ulong frame_count) @cname("ma_gainer_process_pcm_frames_internal");
extern fn void gainer_set_gain_by_index(MaGainer* p_gainer, float new_gain, uint i_channel) @cname("ma_gainer_set_gain_by_index");
extern fn void gainer_reset_smoothing_time(MaGainer* p_gainer) @cname("ma_gainer_reset_smoothing_time");
extern fn void stereo_balance_pcm_frames_f32(float* p_frames_out, float* p_frames_in, ulong frame_count, float pan) @cname("ma_stereo_balance_pcm_frames_f32");
extern fn void stereo_balance_pcm_frames(void* p_frames_out, void* p_frames_in, ulong frame_count, MaFormat format, float pan) @cname("ma_stereo_balance_pcm_frames");
extern fn void stereo_pan_pcm_frames_f32(float* p_frames_out, float* p_frames_in, ulong frame_count, float pan) @cname("ma_stereo_pan_pcm_frames_f32");
extern fn void stereo_pan_pcm_frames(void* p_frames_out, void* p_frames_in, ulong frame_count, MaFormat format, float pan) @cname("ma_stereo_pan_pcm_frames");
extern fn MaVec3f vec3f_init_3f(float x, float y, float z) @cname("ma_vec3f_init_3f");
extern fn MaVec3f vec3f_sub(MaVec3f a, MaVec3f b) @cname("ma_vec3f_sub");
extern fn MaVec3f vec3f_neg(MaVec3f a) @cname("ma_vec3f_neg");
extern fn float vec3f_dot(MaVec3f a, MaVec3f b) @cname("ma_vec3f_dot");
extern fn float vec3f_len2(MaVec3f v) @cname("ma_vec3f_len2");
extern fn float vec3f_len(MaVec3f v) @cname("ma_vec3f_len");
extern fn float vec3f_dist(MaVec3f a, MaVec3f b) @cname("ma_vec3f_dist");
extern fn MaVec3f vec3f_normalize(MaVec3f v) @cname("ma_vec3f_normalize");
extern fn MaVec3f vec3f_cross(MaVec3f a, MaVec3f b) @cname("ma_vec3f_cross");
extern fn void atomic_vec3f_init(MaAtomicVec3f* v, MaVec3f value) @cname("ma_atomic_vec3f_init");
extern fn void atomic_vec3f_set(MaAtomicVec3f* v, MaVec3f value) @cname("ma_atomic_vec3f_set");
extern fn MaVec3f atomic_vec3f_get(MaAtomicVec3f* v) @cname("ma_atomic_vec3f_get");
extern fn void channel_map_apply_f32(float* p_frames_out, MaChannel* p_channel_map_out, uint channels_out, float* p_frames_in, MaChannel* p_channel_map_in, uint channels_in, ulong frame_count, MaChannelMixMode mode, MaMonoExpansionMode mono_expansion_mode) @cname("ma_channel_map_apply_f32");
extern fn MaBool32 is_spatial_channel_position(char channel_position) @cname("ma_is_spatial_channel_position");
extern fn MaVec3f get_channel_direction(char channel) @cname("ma_get_channel_direction");
extern fn float attenuation_inverse(float distance, float min_distance, float max_distance, float rolloff) @cname("ma_attenuation_inverse");
extern fn float attenuation_linear(float distance, float min_distance, float max_distance, float rolloff) @cname("ma_attenuation_linear");
extern fn float attenuation_exponential(float distance, float min_distance, float max_distance, float rolloff) @cname("ma_attenuation_exponential");
extern fn float doppler_pitch(MaVec3f relative_position, MaVec3f source_velocity, MaVec3f listen_velocity, float speed_of_sound, float doppler_factor) @cname("ma_doppler_pitch");
extern fn void get_default_channel_map_for_spatializer(MaChannel* p_channel_map, usz channel_map_cap, uint channel_count) @cname("ma_get_default_channel_map_for_spatializer");
extern fn MaResult spatializer_listener_get_heap_layout(MaSpatializerListenerConfig* p_config, MaSpatializerListenerHeapLayout* p_heap_layout) @cname("ma_spatializer_listener_get_heap_layout");
extern fn MaGainerConfig spatializer_gainer_config_init(MaSpatializerConfig* p_config) @cname("ma_spatializer_gainer_config_init");
extern fn MaResult spatializer_validate_config(MaSpatializerConfig* p_config) @cname("ma_spatializer_validate_config");
extern fn MaResult spatializer_get_heap_layout(MaSpatializerConfig* p_config, MaSpatializerHeapLayout* p_heap_layout) @cname("ma_spatializer_get_heap_layout");
extern fn float calculate_angular_gain(MaVec3f dir_a, MaVec3f dir_b, float cone_inner_angle_in_radians, float cone_outer_angle_in_radians, float cone_outer_gain) @cname("ma_calculate_angular_gain");
extern fn void linear_resampler_adjust_timer_for_new_rate(MaLinearResampler* p_resampler, uint old_sample_rate_out, uint new_sample_rate_out) @cname("ma_linear_resampler_adjust_timer_for_new_rate");
extern fn MaResult linear_resampler_set_rate_internal(MaLinearResampler* p_resampler, void* p_heap, MaLinearResamplerHeapLayout* p_heap_layout, uint sample_rate_in, uint sample_rate_out, uint is_resampler_already_initialized) @cname("ma_linear_resampler_set_rate_internal");
extern fn MaResult linear_resampler_get_heap_layout(MaLinearResamplerConfig* p_config, MaLinearResamplerHeapLayout* p_heap_layout) @cname("ma_linear_resampler_get_heap_layout");
extern fn MaInt16 linear_resampler_mix_s16(short x, short y, int a, int shift) @cname("ma_linear_resampler_mix_s16");
extern fn void linear_resampler_interpolate_frame_s16(MaLinearResampler* p_resampler, MaInt16* p_frame_out @noalias) @cname("ma_linear_resampler_interpolate_frame_s16");
extern fn void linear_resampler_interpolate_frame_f32(MaLinearResampler* p_resampler, float* p_frame_out @noalias) @cname("ma_linear_resampler_interpolate_frame_f32");
extern fn MaResult linear_resampler_process_pcm_frames_s16_downsample(MaLinearResampler* p_resampler, void* p_frames_in, MaUint64* p_frame_count_in, void* p_frames_out, MaUint64* p_frame_count_out) @cname("ma_linear_resampler_process_pcm_frames_s16_downsample");
extern fn MaResult linear_resampler_process_pcm_frames_s16_upsample(MaLinearResampler* p_resampler, void* p_frames_in, MaUint64* p_frame_count_in, void* p_frames_out, MaUint64* p_frame_count_out) @cname("ma_linear_resampler_process_pcm_frames_s16_upsample");
extern fn MaResult linear_resampler_process_pcm_frames_s16(MaLinearResampler* p_resampler, void* p_frames_in, MaUint64* p_frame_count_in, void* p_frames_out, MaUint64* p_frame_count_out) @cname("ma_linear_resampler_process_pcm_frames_s16");
extern fn MaResult linear_resampler_process_pcm_frames_f32_downsample(MaLinearResampler* p_resampler, void* p_frames_in, MaUint64* p_frame_count_in, void* p_frames_out, MaUint64* p_frame_count_out) @cname("ma_linear_resampler_process_pcm_frames_f32_downsample");
extern fn MaResult linear_resampler_process_pcm_frames_f32_upsample(MaLinearResampler* p_resampler, void* p_frames_in, MaUint64* p_frame_count_in, void* p_frames_out, MaUint64* p_frame_count_out) @cname("ma_linear_resampler_process_pcm_frames_f32_upsample");
extern fn MaResult linear_resampler_process_pcm_frames_f32(MaLinearResampler* p_resampler, void* p_frames_in, MaUint64* p_frame_count_in, void* p_frames_out, MaUint64* p_frame_count_out) @cname("ma_linear_resampler_process_pcm_frames_f32");
extern fn MaLinearResamplerConfig resampling_backend_get_config__linear(MaResamplerConfig* p_config) @cname("ma_resampling_backend_get_config__linear");
extern fn MaResult resampling_backend_get_heap_size__linear(void* p_user_data, MaResamplerConfig* p_config, usz* p_heap_size_in_bytes) @cname("ma_resampling_backend_get_heap_size__linear");
extern fn MaResult resampling_backend_init__linear(void* p_user_data, MaResamplerConfig* p_config, void* p_heap, MaResamplingBackend** pp_backend) @cname("ma_resampling_backend_init__linear");
extern fn void resampling_backend_uninit__linear(void* p_user_data, MaResamplingBackend* p_backend, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_resampling_backend_uninit__linear");
extern fn MaResult resampling_backend_process__linear(void* p_user_data, MaResamplingBackend* p_backend, void* p_frames_in, MaUint64* p_frame_count_in, void* p_frames_out, MaUint64* p_frame_count_out) @cname("ma_resampling_backend_process__linear");
extern fn MaResult resampling_backend_set_rate__linear(void* p_user_data, MaResamplingBackend* p_backend, uint sample_rate_in, uint sample_rate_out) @cname("ma_resampling_backend_set_rate__linear");
extern fn MaUint64 resampling_backend_get_input_latency__linear(void* p_user_data, MaResamplingBackend* p_backend) @cname("ma_resampling_backend_get_input_latency__linear");
extern fn MaUint64 resampling_backend_get_output_latency__linear(void* p_user_data, MaResamplingBackend* p_backend) @cname("ma_resampling_backend_get_output_latency__linear");
extern fn MaResult resampling_backend_get_required_input_frame_count__linear(void* p_user_data, MaResamplingBackend* p_backend, ulong output_frame_count, MaUint64* p_input_frame_count) @cname("ma_resampling_backend_get_required_input_frame_count__linear");
extern fn MaResult resampling_backend_get_expected_output_frame_count__linear(void* p_user_data, MaResamplingBackend* p_backend, ulong input_frame_count, MaUint64* p_output_frame_count) @cname("ma_resampling_backend_get_expected_output_frame_count__linear");
extern fn MaResult resampling_backend_reset__linear(void* p_user_data, MaResamplingBackend* p_backend) @cname("ma_resampling_backend_reset__linear");
extern fn MaResult resampler_get_vtable(MaResamplerConfig* p_config, MaResampler* p_resampler, MaResamplingBackendVtable** pp_v_table, void** pp_user_data) @cname("ma_resampler_get_vtable");
extern fn float calculate_channel_position_rectangular_weight(char channel_position_a, char channel_position_b) @cname("ma_calculate_channel_position_rectangular_weight");
extern fn MaInt32 channel_converter_float_to_fixed(float x) @cname("ma_channel_converter_float_to_fixed");
extern fn MaUint32 channel_map_get_spatial_channel_count(MaChannel* p_channel_map, uint channels) @cname("ma_channel_map_get_spatial_channel_count");
extern fn MaBool32 channel_map_is_passthrough(MaChannel* p_channel_map_in, uint channels_in, MaChannel* p_channel_map_out, uint channels_out) @cname("ma_channel_map_is_passthrough");
extern fn MaChannelConversionPath channel_map_get_conversion_path(MaChannel* p_channel_map_in, uint channels_in, MaChannel* p_channel_map_out, uint channels_out, MaChannelMixMode mode) @cname("ma_channel_map_get_conversion_path");
extern fn MaResult channel_map_build_shuffle_table(MaChannel* p_channel_map_in, uint channel_count_in, MaChannel* p_channel_map_out, uint channel_count_out, MaUint8* p_shuffle_table) @cname("ma_channel_map_build_shuffle_table");
extern fn void channel_map_apply_shuffle_table_u8(MaUint8* p_frames_out, uint channels_out, MaUint8* p_frames_in, uint channels_in, ulong frame_count, MaUint8* p_shuffle_table) @cname("ma_channel_map_apply_shuffle_table_u8");
extern fn void channel_map_apply_shuffle_table_s16(MaInt16* p_frames_out, uint channels_out, MaInt16* p_frames_in, uint channels_in, ulong frame_count, MaUint8* p_shuffle_table) @cname("ma_channel_map_apply_shuffle_table_s16");
extern fn void channel_map_apply_shuffle_table_s24(MaUint8* p_frames_out, uint channels_out, MaUint8* p_frames_in, uint channels_in, ulong frame_count, MaUint8* p_shuffle_table) @cname("ma_channel_map_apply_shuffle_table_s24");
extern fn void channel_map_apply_shuffle_table_s32(MaInt32* p_frames_out, uint channels_out, MaInt32* p_frames_in, uint channels_in, ulong frame_count, MaUint8* p_shuffle_table) @cname("ma_channel_map_apply_shuffle_table_s32");
extern fn void channel_map_apply_shuffle_table_f32(float* p_frames_out, uint channels_out, float* p_frames_in, uint channels_in, ulong frame_count, MaUint8* p_shuffle_table) @cname("ma_channel_map_apply_shuffle_table_f32");
extern fn MaResult channel_map_apply_shuffle_table(void* p_frames_out, uint channels_out, void* p_frames_in, uint channels_in, ulong frame_count, MaUint8* p_shuffle_table, MaFormat format) @cname("ma_channel_map_apply_shuffle_table");
extern fn MaResult channel_map_apply_mono_out_f32(float* p_frames_out, float* p_frames_in, MaChannel* p_channel_map_in, uint channels_in, ulong frame_count) @cname("ma_channel_map_apply_mono_out_f32");
extern fn MaResult channel_map_apply_mono_in_f32(float* p_frames_out @noalias, MaChannel* p_channel_map_out, uint channels_out, float* p_frames_in @noalias, ulong frame_count, MaMonoExpansionMode mono_expansion_mode) @cname("ma_channel_map_apply_mono_in_f32");
extern fn MaChannelConversionPath channel_converter_config_get_conversion_path(MaChannelConverterConfig* p_config) @cname("ma_channel_converter_config_get_conversion_path");
extern fn MaResult channel_converter_get_heap_layout(MaChannelConverterConfig* p_config, MaChannelConverterHeapLayout* p_heap_layout) @cname("ma_channel_converter_get_heap_layout");
extern fn MaResult channel_converter_process_pcm_frames__passthrough(MaChannelConverter* p_converter, void* p_frames_out, void* p_frames_in, ulong frame_count) @cname("ma_channel_converter_process_pcm_frames__passthrough");
extern fn MaResult channel_converter_process_pcm_frames__shuffle(MaChannelConverter* p_converter, void* p_frames_out, void* p_frames_in, ulong frame_count) @cname("ma_channel_converter_process_pcm_frames__shuffle");
extern fn MaResult channel_converter_process_pcm_frames__mono_in(MaChannelConverter* p_converter, void* p_frames_out, void* p_frames_in, ulong frame_count) @cname("ma_channel_converter_process_pcm_frames__mono_in");
extern fn MaResult channel_converter_process_pcm_frames__mono_out(MaChannelConverter* p_converter, void* p_frames_out, void* p_frames_in, ulong frame_count) @cname("ma_channel_converter_process_pcm_frames__mono_out");
extern fn MaResult channel_converter_process_pcm_frames__weights(MaChannelConverter* p_converter, void* p_frames_out, void* p_frames_in, ulong frame_count) @cname("ma_channel_converter_process_pcm_frames__weights");
extern fn MaBool32 data_converter_config_is_resampler_required(MaDataConverterConfig* p_config) @cname("ma_data_converter_config_is_resampler_required");
extern fn MaFormat data_converter_config_get_mid_format(MaDataConverterConfig* p_config) @cname("ma_data_converter_config_get_mid_format");
extern fn MaChannelConverterConfig channel_converter_config_init_from_data_converter_config(MaDataConverterConfig* p_config) @cname("ma_channel_converter_config_init_from_data_converter_config");
extern fn MaResamplerConfig resampler_config_init_from_data_converter_config(MaDataConverterConfig* p_config) @cname("ma_resampler_config_init_from_data_converter_config");
extern fn MaResult data_converter_get_heap_layout(MaDataConverterConfig* p_config, MaDataConverterHeapLayout* p_heap_layout) @cname("ma_data_converter_get_heap_layout");
extern fn MaResult data_converter_process_pcm_frames__passthrough(MaDataConverter* p_converter, void* p_frames_in, MaUint64* p_frame_count_in, void* p_frames_out, MaUint64* p_frame_count_out) @cname("ma_data_converter_process_pcm_frames__passthrough");
extern fn MaResult data_converter_process_pcm_frames__format_only(MaDataConverter* p_converter, void* p_frames_in, MaUint64* p_frame_count_in, void* p_frames_out, MaUint64* p_frame_count_out) @cname("ma_data_converter_process_pcm_frames__format_only");
extern fn MaResult data_converter_process_pcm_frames__resample_with_format_conversion(MaDataConverter* p_converter, void* p_frames_in, MaUint64* p_frame_count_in, void* p_frames_out, MaUint64* p_frame_count_out) @cname("ma_data_converter_process_pcm_frames__resample_with_format_conversion");
extern fn MaResult data_converter_process_pcm_frames__resample_only(MaDataConverter* p_converter, void* p_frames_in, MaUint64* p_frame_count_in, void* p_frames_out, MaUint64* p_frame_count_out) @cname("ma_data_converter_process_pcm_frames__resample_only");
extern fn MaResult data_converter_process_pcm_frames__channels_only(MaDataConverter* p_converter, void* p_frames_in, MaUint64* p_frame_count_in, void* p_frames_out, MaUint64* p_frame_count_out) @cname("ma_data_converter_process_pcm_frames__channels_only");
extern fn MaResult data_converter_process_pcm_frames__resample_first(MaDataConverter* p_converter, void* p_frames_in, MaUint64* p_frame_count_in, void* p_frames_out, MaUint64* p_frame_count_out) @cname("ma_data_converter_process_pcm_frames__resample_first");
extern fn MaResult data_converter_process_pcm_frames__channels_first(MaDataConverter* p_converter, void* p_frames_in, MaUint64* p_frame_count_in, void* p_frames_out, MaUint64* p_frame_count_out) @cname("ma_data_converter_process_pcm_frames__channels_first");
extern fn MaChannel channel_map_init_standard_channel(MaStandardChannelMap standard_channel_map, uint channel_count, uint channel_index) @cname("ma_channel_map_init_standard_channel");
extern fn MaChannel channel_map_init_standard_channel_microsoft(uint channel_count, uint channel_index) @cname("ma_channel_map_init_standard_channel_microsoft");
extern fn MaChannel channel_map_init_standard_channel_alsa(uint channel_count, uint channel_index) @cname("ma_channel_map_init_standard_channel_alsa");
extern fn MaChannel channel_map_init_standard_channel_rfc3551(uint channel_count, uint channel_index) @cname("ma_channel_map_init_standard_channel_rfc3551");
extern fn MaChannel channel_map_init_standard_channel_flac(uint channel_count, uint channel_index) @cname("ma_channel_map_init_standard_channel_flac");
extern fn MaChannel channel_map_init_standard_channel_vorbis(uint channel_count, uint channel_index) @cname("ma_channel_map_init_standard_channel_vorbis");
extern fn MaChannel channel_map_init_standard_channel_sound4(uint channel_count, uint channel_index) @cname("ma_channel_map_init_standard_channel_sound4");
extern fn MaChannel channel_map_init_standard_channel_sndio(uint channel_count, uint channel_index) @cname("ma_channel_map_init_standard_channel_sndio");
extern fn MaUint32 rb__extract_offset_in_bytes(uint encoded_offset) @cname("ma_rb__extract_offset_in_bytes");
extern fn MaUint32 rb__extract_offset_loop_flag(uint encoded_offset) @cname("ma_rb__extract_offset_loop_flag");
extern fn void* rb__get_read_ptr(MaRb* p_rb) @cname("ma_rb__get_read_ptr");
extern fn void* rb__get_write_ptr(MaRb* p_rb) @cname("ma_rb__get_write_ptr");
extern fn MaUint32 rb__construct_offset(uint offset_in_bytes, uint offset_loop_flag) @cname("ma_rb__construct_offset");
extern fn void rb__deconstruct_offset(uint encoded_offset, MaUint32* p_offset_in_bytes, MaUint32* p_offset_loop_flag) @cname("ma_rb__deconstruct_offset");
extern fn MaResult pcm_rb_data_source__on_read(MaDataSource* p_data_source, void* p_frames_out, ulong frame_count, MaUint64* p_frames_read) @cname("ma_pcm_rb_data_source__on_read");
extern fn MaResult pcm_rb_data_source__on_get_data_format(MaDataSource* p_data_source, MaFormat* p_format, MaUint32* p_channels, MaUint32* p_sample_rate, MaChannel* p_channel_map, usz channel_map_cap) @cname("ma_pcm_rb_data_source__on_get_data_format");
extern fn MaUint32 pcm_rb_get_bpf(MaPcmRb* p_rb) @cname("ma_pcm_rb_get_bpf");
extern fn MaResult data_source_resolve_current(MaDataSource* p_data_source, MaDataSource** pp_current_data_source) @cname("ma_data_source_resolve_current");
extern fn MaResult data_source_read_pcm_frames_from_backend(MaDataSource* p_data_source, void* p_frames_out, ulong frame_count, MaUint64* p_frames_read) @cname("ma_data_source_read_pcm_frames_from_backend");
extern fn MaResult data_source_read_pcm_frames_within_range(MaDataSource* p_data_source, void* p_frames_out, ulong frame_count, MaUint64* p_frames_read) @cname("ma_data_source_read_pcm_frames_within_range");
extern fn MaResult audio_buffer_ref__data_source_on_read(MaDataSource* p_data_source, void* p_frames_out, ulong frame_count, MaUint64* p_frames_read) @cname("ma_audio_buffer_ref__data_source_on_read");
extern fn MaResult audio_buffer_ref__data_source_on_seek(MaDataSource* p_data_source, ulong frame_index) @cname("ma_audio_buffer_ref__data_source_on_seek");
extern fn MaResult audio_buffer_ref__data_source_on_get_data_format(MaDataSource* p_data_source, MaFormat* p_format, MaUint32* p_channels, MaUint32* p_sample_rate, MaChannel* p_channel_map, usz channel_map_cap) @cname("ma_audio_buffer_ref__data_source_on_get_data_format");
extern fn MaResult audio_buffer_ref__data_source_on_get_cursor(MaDataSource* p_data_source, MaUint64* p_cursor) @cname("ma_audio_buffer_ref__data_source_on_get_cursor");
extern fn MaResult audio_buffer_ref__data_source_on_get_length(MaDataSource* p_data_source, MaUint64* p_length) @cname("ma_audio_buffer_ref__data_source_on_get_length");
extern fn MaResult audio_buffer_init_ex(MaAudioBufferConfig* p_config, uint do_copy, MaAudioBuffer* p_audio_buffer) @cname("ma_audio_buffer_init_ex");
extern fn void audio_buffer_uninit_ex(MaAudioBuffer* p_audio_buffer, uint do_free) @cname("ma_audio_buffer_uninit_ex");
extern fn MaResult paged_audio_buffer__data_source_on_read(MaDataSource* p_data_source, void* p_frames_out, ulong frame_count, MaUint64* p_frames_read) @cname("ma_paged_audio_buffer__data_source_on_read");
extern fn MaResult paged_audio_buffer__data_source_on_seek(MaDataSource* p_data_source, ulong frame_index) @cname("ma_paged_audio_buffer__data_source_on_seek");
extern fn MaResult paged_audio_buffer__data_source_on_get_data_format(MaDataSource* p_data_source, MaFormat* p_format, MaUint32* p_channels, MaUint32* p_sample_rate, MaChannel* p_channel_map, usz channel_map_cap) @cname("ma_paged_audio_buffer__data_source_on_get_data_format");
extern fn MaResult paged_audio_buffer__data_source_on_get_cursor(MaDataSource* p_data_source, MaUint64* p_cursor) @cname("ma_paged_audio_buffer__data_source_on_get_cursor");
extern fn MaResult paged_audio_buffer__data_source_on_get_length(MaDataSource* p_data_source, MaUint64* p_length) @cname("ma_paged_audio_buffer__data_source_on_get_length");
extern fn MaResult default_vfs_open__stdio(MaVfs* p_vfs, ZString p_file_path, uint open_mode, MaVfsFile* p_file) @cname("ma_default_vfs_open__stdio");
extern fn MaResult default_vfs_open_w__stdio(MaVfs* p_vfs, WcharT* p_file_path, uint open_mode, MaVfsFile* p_file) @cname("ma_default_vfs_open_w__stdio");
extern fn MaResult default_vfs_close__stdio(MaVfs* p_vfs, void* file) @cname("ma_default_vfs_close__stdio");
extern fn MaResult default_vfs_read__stdio(MaVfs* p_vfs, void* file, void* p_dst, usz size_in_bytes, usz* p_bytes_read) @cname("ma_default_vfs_read__stdio");
extern fn MaResult default_vfs_write__stdio(MaVfs* p_vfs, void* file, void* p_src, usz size_in_bytes, usz* p_bytes_written) @cname("ma_default_vfs_write__stdio");
extern fn MaResult default_vfs_seek__stdio(MaVfs* p_vfs, void* file, long offset, MaSeekOrigin origin) @cname("ma_default_vfs_seek__stdio");
extern fn MaResult default_vfs_tell__stdio(MaVfs* p_vfs, void* file, MaInt64* p_cursor) @cname("ma_default_vfs_tell__stdio");
extern fn MaResult default_vfs_info__stdio(MaVfs* p_vfs, void* file, MaFileInfo* p_info) @cname("ma_default_vfs_info__stdio");
extern fn MaResult default_vfs_open(MaVfs* p_vfs, ZString p_file_path, uint open_mode, MaVfsFile* p_file) @cname("ma_default_vfs_open");
extern fn MaResult default_vfs_open_w(MaVfs* p_vfs, WcharT* p_file_path, uint open_mode, MaVfsFile* p_file) @cname("ma_default_vfs_open_w");
extern fn MaResult default_vfs_close(MaVfs* p_vfs, void* file) @cname("ma_default_vfs_close");
extern fn MaResult default_vfs_read(MaVfs* p_vfs, void* file, void* p_dst, usz size_in_bytes, usz* p_bytes_read) @cname("ma_default_vfs_read");
extern fn MaResult default_vfs_write(MaVfs* p_vfs, void* file, void* p_src, usz size_in_bytes, usz* p_bytes_written) @cname("ma_default_vfs_write");
extern fn MaResult default_vfs_seek(MaVfs* p_vfs, void* file, long offset, MaSeekOrigin origin) @cname("ma_default_vfs_seek");
extern fn MaResult default_vfs_tell(MaVfs* p_vfs, void* file, MaInt64* p_cursor) @cname("ma_default_vfs_tell");
extern fn MaResult default_vfs_info(MaVfs* p_vfs, void* file, MaFileInfo* p_info) @cname("ma_default_vfs_info");
extern fn MaResult vfs_or_default_open(MaVfs* p_vfs, ZString p_file_path, uint open_mode, MaVfsFile* p_file) @cname("ma_vfs_or_default_open");
extern fn MaResult vfs_or_default_open_w(MaVfs* p_vfs, WcharT* p_file_path, uint open_mode, MaVfsFile* p_file) @cname("ma_vfs_or_default_open_w");
extern fn MaResult vfs_or_default_close(MaVfs* p_vfs, void* file) @cname("ma_vfs_or_default_close");
extern fn MaResult vfs_or_default_read(MaVfs* p_vfs, void* file, void* p_dst, usz size_in_bytes, usz* p_bytes_read) @cname("ma_vfs_or_default_read");
extern fn MaResult vfs_or_default_write(MaVfs* p_vfs, void* file, void* p_src, usz size_in_bytes, usz* p_bytes_written) @cname("ma_vfs_or_default_write");
extern fn MaResult vfs_or_default_seek(MaVfs* p_vfs, void* file, long offset, MaSeekOrigin origin) @cname("ma_vfs_or_default_seek");
extern fn MaResult vfs_or_default_tell(MaVfs* p_vfs, void* file, MaInt64* p_cursor) @cname("ma_vfs_or_default_tell");
extern fn MaResult vfs_or_default_info(MaVfs* p_vfs, void* file, MaFileInfo* p_info) @cname("ma_vfs_or_default_info");
extern fn MaResult vfs_open_and_read_file_ex(MaVfs* p_vfs, ZString p_file_path, WcharT* p_file_path_w, void** pp_data, usz* p_size, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_vfs_open_and_read_file_ex");
extern fn MaResult vfs_open_and_read_file_w(MaVfs* p_vfs, WcharT* p_file_path, void** pp_data, usz* p_size, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_vfs_open_and_read_file_w");
extern fn void dr_wav_version(MaUint32* p_major, MaUint32* p_minor, MaUint32* p_revision) @cname("ma_dr_wav_version");
extern fn ZString dr_wav_version_string() @cname("ma_dr_wav_version_string");
extern fn MaUint16 dr_wav_fmt_get_format(MaDrWavFmt* p_fmt) @cname("ma_dr_wav_fmt_get_format");
extern fn MaBool32 dr_wav_init(MaDrWav* p_wav, MaDrWavReadProc on_read, MaDrWavSeekProc on_seek, MaDrWavTellProc on_tell, void* p_user_data, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_wav_init");
extern fn MaBool32 dr_wav_init_ex(MaDrWav* p_wav, MaDrWavReadProc on_read, MaDrWavSeekProc on_seek, MaDrWavTellProc on_tell, MaDrWavChunkProc on_chunk, void* p_read_seek_tell_user_data, void* p_chunk_user_data, uint flags, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_wav_init_ex");
extern fn MaBool32 dr_wav_init_with_metadata(MaDrWav* p_wav, MaDrWavReadProc on_read, MaDrWavSeekProc on_seek, MaDrWavTellProc on_tell, void* p_user_data, uint flags, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_wav_init_with_metadata");
extern fn MaBool32 dr_wav_init_write(MaDrWav* p_wav, MaDrWavDataFormat* p_format, MaDrWavWriteProc on_write, MaDrWavSeekProc on_seek, void* p_user_data, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_wav_init_write");
extern fn MaBool32 dr_wav_init_write_sequential(MaDrWav* p_wav, MaDrWavDataFormat* p_format, ulong total_sample_count, MaDrWavWriteProc on_write, void* p_user_data, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_wav_init_write_sequential");
extern fn MaBool32 dr_wav_init_write_sequential_pcm_frames(MaDrWav* p_wav, MaDrWavDataFormat* p_format, ulong total_pcm_frame_count, MaDrWavWriteProc on_write, void* p_user_data, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_wav_init_write_sequential_pcm_frames");
extern fn MaBool32 dr_wav_init_write_with_metadata(MaDrWav* p_wav, MaDrWavDataFormat* p_format, MaDrWavWriteProc on_write, MaDrWavSeekProc on_seek, void* p_user_data, MaAllocationCallbacks* p_allocation_callbacks, MaDrWavMetadata* p_metadata, uint metadata_count) @cname("ma_dr_wav_init_write_with_metadata");
extern fn MaUint64 dr_wav_target_write_size_bytes(MaDrWavDataFormat* p_format, ulong total_frame_count, MaDrWavMetadata* p_metadata, uint metadata_count) @cname("ma_dr_wav_target_write_size_bytes");
extern fn MaDrWavMetadata* dr_wav_take_ownership_of_metadata(MaDrWav* p_wav) @cname("ma_dr_wav_take_ownership_of_metadata");
extern fn MaResult dr_wav_uninit(MaDrWav* p_wav) @cname("ma_dr_wav_uninit");
extern fn usz dr_wav_read_raw(MaDrWav* p_wav, usz bytes_to_read, void* p_buffer_out) @cname("ma_dr_wav_read_raw");
extern fn MaUint64 dr_wav_read_pcm_frames(MaDrWav* p_wav, ulong frames_to_read, void* p_buffer_out) @cname("ma_dr_wav_read_pcm_frames");
extern fn MaUint64 dr_wav_read_pcm_frames_le(MaDrWav* p_wav, ulong frames_to_read, void* p_buffer_out) @cname("ma_dr_wav_read_pcm_frames_le");
extern fn MaUint64 dr_wav_read_pcm_frames_be(MaDrWav* p_wav, ulong frames_to_read, void* p_buffer_out) @cname("ma_dr_wav_read_pcm_frames_be");
extern fn MaBool32 dr_wav_seek_to_pcm_frame(MaDrWav* p_wav, ulong target_frame_index) @cname("ma_dr_wav_seek_to_pcm_frame");
extern fn MaResult dr_wav_get_cursor_in_pcm_frames(MaDrWav* p_wav, MaUint64* p_cursor) @cname("ma_dr_wav_get_cursor_in_pcm_frames");
extern fn MaResult dr_wav_get_length_in_pcm_frames(MaDrWav* p_wav, MaUint64* p_length) @cname("ma_dr_wav_get_length_in_pcm_frames");
extern fn usz dr_wav_write_raw(MaDrWav* p_wav, usz bytes_to_write, void* p_data) @cname("ma_dr_wav_write_raw");
extern fn MaUint64 dr_wav_write_pcm_frames(MaDrWav* p_wav, ulong frames_to_write, void* p_data) @cname("ma_dr_wav_write_pcm_frames");
extern fn MaUint64 dr_wav_write_pcm_frames_le(MaDrWav* p_wav, ulong frames_to_write, void* p_data) @cname("ma_dr_wav_write_pcm_frames_le");
extern fn MaUint64 dr_wav_write_pcm_frames_be(MaDrWav* p_wav, ulong frames_to_write, void* p_data) @cname("ma_dr_wav_write_pcm_frames_be");
extern fn MaUint64 dr_wav_read_pcm_frames_s16(MaDrWav* p_wav, ulong frames_to_read, MaInt16* p_buffer_out) @cname("ma_dr_wav_read_pcm_frames_s16");
extern fn MaUint64 dr_wav_read_pcm_frames_s16le(MaDrWav* p_wav, ulong frames_to_read, MaInt16* p_buffer_out) @cname("ma_dr_wav_read_pcm_frames_s16le");
extern fn MaUint64 dr_wav_read_pcm_frames_s16be(MaDrWav* p_wav, ulong frames_to_read, MaInt16* p_buffer_out) @cname("ma_dr_wav_read_pcm_frames_s16be");
extern fn void dr_wav_u8_to_s16(MaInt16* p_out, MaUint8* p_in, usz sample_count) @cname("ma_dr_wav_u8_to_s16");
extern fn void dr_wav_s24_to_s16(MaInt16* p_out, MaUint8* p_in, usz sample_count) @cname("ma_dr_wav_s24_to_s16");
extern fn void dr_wav_s32_to_s16(MaInt16* p_out, MaInt32* p_in, usz sample_count) @cname("ma_dr_wav_s32_to_s16");
extern fn void dr_wav_f32_to_s16(MaInt16* p_out, float* p_in, usz sample_count) @cname("ma_dr_wav_f32_to_s16");
extern fn void dr_wav_f64_to_s16(MaInt16* p_out, double* p_in, usz sample_count) @cname("ma_dr_wav_f64_to_s16");
extern fn void dr_wav_alaw_to_s16(MaInt16* p_out, MaUint8* p_in, usz sample_count) @cname("ma_dr_wav_alaw_to_s16");
extern fn void dr_wav_mulaw_to_s16(MaInt16* p_out, MaUint8* p_in, usz sample_count) @cname("ma_dr_wav_mulaw_to_s16");
extern fn MaUint64 dr_wav_read_pcm_frames_f32(MaDrWav* p_wav, ulong frames_to_read, float* p_buffer_out) @cname("ma_dr_wav_read_pcm_frames_f32");
extern fn MaUint64 dr_wav_read_pcm_frames_f32le(MaDrWav* p_wav, ulong frames_to_read, float* p_buffer_out) @cname("ma_dr_wav_read_pcm_frames_f32le");
extern fn MaUint64 dr_wav_read_pcm_frames_f32be(MaDrWav* p_wav, ulong frames_to_read, float* p_buffer_out) @cname("ma_dr_wav_read_pcm_frames_f32be");
extern fn void dr_wav_u8_to_f32(float* p_out, MaUint8* p_in, usz sample_count) @cname("ma_dr_wav_u8_to_f32");
extern fn void dr_wav_s16_to_f32(float* p_out, MaInt16* p_in, usz sample_count) @cname("ma_dr_wav_s16_to_f32");
extern fn void dr_wav_s24_to_f32(float* p_out, MaUint8* p_in, usz sample_count) @cname("ma_dr_wav_s24_to_f32");
extern fn void dr_wav_s32_to_f32(float* p_out, MaInt32* p_in, usz sample_count) @cname("ma_dr_wav_s32_to_f32");
extern fn void dr_wav_f64_to_f32(float* p_out, double* p_in, usz sample_count) @cname("ma_dr_wav_f64_to_f32");
extern fn void dr_wav_alaw_to_f32(float* p_out, MaUint8* p_in, usz sample_count) @cname("ma_dr_wav_alaw_to_f32");
extern fn void dr_wav_mulaw_to_f32(float* p_out, MaUint8* p_in, usz sample_count) @cname("ma_dr_wav_mulaw_to_f32");
extern fn MaUint64 dr_wav_read_pcm_frames_s32(MaDrWav* p_wav, ulong frames_to_read, MaInt32* p_buffer_out) @cname("ma_dr_wav_read_pcm_frames_s32");
extern fn MaUint64 dr_wav_read_pcm_frames_s32le(MaDrWav* p_wav, ulong frames_to_read, MaInt32* p_buffer_out) @cname("ma_dr_wav_read_pcm_frames_s32le");
extern fn MaUint64 dr_wav_read_pcm_frames_s32be(MaDrWav* p_wav, ulong frames_to_read, MaInt32* p_buffer_out) @cname("ma_dr_wav_read_pcm_frames_s32be");
extern fn void dr_wav_u8_to_s32(MaInt32* p_out, MaUint8* p_in, usz sample_count) @cname("ma_dr_wav_u8_to_s32");
extern fn void dr_wav_s16_to_s32(MaInt32* p_out, MaInt16* p_in, usz sample_count) @cname("ma_dr_wav_s16_to_s32");
extern fn void dr_wav_s24_to_s32(MaInt32* p_out, MaUint8* p_in, usz sample_count) @cname("ma_dr_wav_s24_to_s32");
extern fn void dr_wav_f32_to_s32(MaInt32* p_out, float* p_in, usz sample_count) @cname("ma_dr_wav_f32_to_s32");
extern fn void dr_wav_f64_to_s32(MaInt32* p_out, double* p_in, usz sample_count) @cname("ma_dr_wav_f64_to_s32");
extern fn void dr_wav_alaw_to_s32(MaInt32* p_out, MaUint8* p_in, usz sample_count) @cname("ma_dr_wav_alaw_to_s32");
extern fn void dr_wav_mulaw_to_s32(MaInt32* p_out, MaUint8* p_in, usz sample_count) @cname("ma_dr_wav_mulaw_to_s32");
extern fn MaBool32 dr_wav_init_file(MaDrWav* p_wav, ZString filename, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_wav_init_file");
extern fn MaBool32 dr_wav_init_file_ex(MaDrWav* p_wav, ZString filename, MaDrWavChunkProc on_chunk, void* p_chunk_user_data, uint flags, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_wav_init_file_ex");
extern fn MaBool32 dr_wav_init_file_w(MaDrWav* p_wav, WcharT* filename, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_wav_init_file_w");
extern fn MaBool32 dr_wav_init_file_ex_w(MaDrWav* p_wav, WcharT* filename, MaDrWavChunkProc on_chunk, void* p_chunk_user_data, uint flags, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_wav_init_file_ex_w");
extern fn MaBool32 dr_wav_init_file_with_metadata(MaDrWav* p_wav, ZString filename, uint flags, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_wav_init_file_with_metadata");
extern fn MaBool32 dr_wav_init_file_with_metadata_w(MaDrWav* p_wav, WcharT* filename, uint flags, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_wav_init_file_with_metadata_w");
extern fn MaBool32 dr_wav_init_file_write(MaDrWav* p_wav, ZString filename, MaDrWavDataFormat* p_format, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_wav_init_file_write");
extern fn MaBool32 dr_wav_init_file_write_sequential(MaDrWav* p_wav, ZString filename, MaDrWavDataFormat* p_format, ulong total_sample_count, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_wav_init_file_write_sequential");
extern fn MaBool32 dr_wav_init_file_write_sequential_pcm_frames(MaDrWav* p_wav, ZString filename, MaDrWavDataFormat* p_format, ulong total_pcm_frame_count, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_wav_init_file_write_sequential_pcm_frames");
extern fn MaBool32 dr_wav_init_file_write_w(MaDrWav* p_wav, WcharT* filename, MaDrWavDataFormat* p_format, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_wav_init_file_write_w");
extern fn MaBool32 dr_wav_init_file_write_sequential_w(MaDrWav* p_wav, WcharT* filename, MaDrWavDataFormat* p_format, ulong total_sample_count, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_wav_init_file_write_sequential_w");
extern fn MaBool32 dr_wav_init_file_write_sequential_pcm_frames_w(MaDrWav* p_wav, WcharT* filename, MaDrWavDataFormat* p_format, ulong total_pcm_frame_count, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_wav_init_file_write_sequential_pcm_frames_w");
extern fn MaBool32 dr_wav_init_memory(MaDrWav* p_wav, void* data, usz data_size, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_wav_init_memory");
extern fn MaBool32 dr_wav_init_memory_ex(MaDrWav* p_wav, void* data, usz data_size, MaDrWavChunkProc on_chunk, void* p_chunk_user_data, uint flags, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_wav_init_memory_ex");
extern fn MaBool32 dr_wav_init_memory_with_metadata(MaDrWav* p_wav, void* data, usz data_size, uint flags, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_wav_init_memory_with_metadata");
extern fn MaBool32 dr_wav_init_memory_write(MaDrWav* p_wav, void** pp_data, usz* p_data_size, MaDrWavDataFormat* p_format, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_wav_init_memory_write");
extern fn MaBool32 dr_wav_init_memory_write_sequential(MaDrWav* p_wav, void** pp_data, usz* p_data_size, MaDrWavDataFormat* p_format, ulong total_sample_count, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_wav_init_memory_write_sequential");
extern fn MaBool32 dr_wav_init_memory_write_sequential_pcm_frames(MaDrWav* p_wav, void** pp_data, usz* p_data_size, MaDrWavDataFormat* p_format, ulong total_pcm_frame_count, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_wav_init_memory_write_sequential_pcm_frames");
extern fn MaInt16* dr_wav_open_and_read_pcm_frames_s16(MaDrWavReadProc on_read, MaDrWavSeekProc on_seek, MaDrWavTellProc on_tell, void* p_user_data, uint* channels_out, uint* sample_rate_out, MaUint64* total_frame_count_out, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_wav_open_and_read_pcm_frames_s16");
extern fn float* dr_wav_open_and_read_pcm_frames_f32(MaDrWavReadProc on_read, MaDrWavSeekProc on_seek, MaDrWavTellProc on_tell, void* p_user_data, uint* channels_out, uint* sample_rate_out, MaUint64* total_frame_count_out, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_wav_open_and_read_pcm_frames_f32");
extern fn MaInt32* dr_wav_open_and_read_pcm_frames_s32(MaDrWavReadProc on_read, MaDrWavSeekProc on_seek, MaDrWavTellProc on_tell, void* p_user_data, uint* channels_out, uint* sample_rate_out, MaUint64* total_frame_count_out, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_wav_open_and_read_pcm_frames_s32");
extern fn MaInt16* dr_wav_open_file_and_read_pcm_frames_s16(ZString filename, uint* channels_out, uint* sample_rate_out, MaUint64* total_frame_count_out, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_wav_open_file_and_read_pcm_frames_s16");
extern fn float* dr_wav_open_file_and_read_pcm_frames_f32(ZString filename, uint* channels_out, uint* sample_rate_out, MaUint64* total_frame_count_out, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_wav_open_file_and_read_pcm_frames_f32");
extern fn MaInt32* dr_wav_open_file_and_read_pcm_frames_s32(ZString filename, uint* channels_out, uint* sample_rate_out, MaUint64* total_frame_count_out, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_wav_open_file_and_read_pcm_frames_s32");
extern fn MaInt16* dr_wav_open_file_and_read_pcm_frames_s16_w(WcharT* filename, uint* channels_out, uint* sample_rate_out, MaUint64* total_frame_count_out, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_wav_open_file_and_read_pcm_frames_s16_w");
extern fn float* dr_wav_open_file_and_read_pcm_frames_f32_w(WcharT* filename, uint* channels_out, uint* sample_rate_out, MaUint64* total_frame_count_out, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_wav_open_file_and_read_pcm_frames_f32_w");
extern fn MaInt32* dr_wav_open_file_and_read_pcm_frames_s32_w(WcharT* filename, uint* channels_out, uint* sample_rate_out, MaUint64* total_frame_count_out, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_wav_open_file_and_read_pcm_frames_s32_w");
extern fn MaInt16* dr_wav_open_memory_and_read_pcm_frames_s16(void* data, usz data_size, uint* channels_out, uint* sample_rate_out, MaUint64* total_frame_count_out, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_wav_open_memory_and_read_pcm_frames_s16");
extern fn float* dr_wav_open_memory_and_read_pcm_frames_f32(void* data, usz data_size, uint* channels_out, uint* sample_rate_out, MaUint64* total_frame_count_out, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_wav_open_memory_and_read_pcm_frames_f32");
extern fn MaInt32* dr_wav_open_memory_and_read_pcm_frames_s32(void* data, usz data_size, uint* channels_out, uint* sample_rate_out, MaUint64* total_frame_count_out, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_wav_open_memory_and_read_pcm_frames_s32");
extern fn void dr_wav_free(void* p, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_wav_free");
extern fn MaUint16 dr_wav_bytes_to_u16(MaUint8* data) @cname("ma_dr_wav_bytes_to_u16");
extern fn MaInt16 dr_wav_bytes_to_s16(MaUint8* data) @cname("ma_dr_wav_bytes_to_s16");
extern fn MaUint32 dr_wav_bytes_to_u32(MaUint8* data) @cname("ma_dr_wav_bytes_to_u32");
extern fn MaInt32 dr_wav_bytes_to_s32(MaUint8* data) @cname("ma_dr_wav_bytes_to_s32");
extern fn MaUint64 dr_wav_bytes_to_u64(MaUint8* data) @cname("ma_dr_wav_bytes_to_u64");
extern fn MaInt64 dr_wav_bytes_to_s64(MaUint8* data) @cname("ma_dr_wav_bytes_to_s64");
extern fn float dr_wav_bytes_to_f32(MaUint8* data) @cname("ma_dr_wav_bytes_to_f32");
extern fn MaBool32 dr_wav_guid_equal(MaUint8* a, MaUint8* b) @cname("ma_dr_wav_guid_equal");
extern fn MaBool32 dr_wav_fourcc_equal(MaUint8* a, ZString b) @cname("ma_dr_wav_fourcc_equal");
extern fn void dr_flac_version(MaUint32* p_major, MaUint32* p_minor, MaUint32* p_revision) @cname("ma_dr_flac_version");
extern fn ZString dr_flac_version_string() @cname("ma_dr_flac_version_string");
extern fn MaDrFlac* dr_flac_open(MaDrFlacReadProc on_read, MaDrFlacSeekProc on_seek, MaDrFlacTellProc on_tell, void* p_user_data, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_flac_open");
extern fn MaDrFlac* dr_flac_open_relaxed(MaDrFlacReadProc on_read, MaDrFlacSeekProc on_seek, MaDrFlacTellProc on_tell, MaDrFlacContainer container, void* p_user_data, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_flac_open_relaxed");
extern fn MaDrFlac* dr_flac_open_with_metadata(MaDrFlacReadProc on_read, MaDrFlacSeekProc on_seek, MaDrFlacTellProc on_tell, MaDrFlacMetaProc on_meta, void* p_user_data, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_flac_open_with_metadata");
extern fn MaDrFlac* dr_flac_open_with_metadata_relaxed(MaDrFlacReadProc on_read, MaDrFlacSeekProc on_seek, MaDrFlacTellProc on_tell, MaDrFlacMetaProc on_meta, MaDrFlacContainer container, void* p_user_data, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_flac_open_with_metadata_relaxed");
extern fn void dr_flac_close(MaDrFlac* p_flac) @cname("ma_dr_flac_close");
extern fn MaUint64 dr_flac_read_pcm_frames_s32(MaDrFlac* p_flac, ulong frames_to_read, MaInt32* p_buffer_out) @cname("ma_dr_flac_read_pcm_frames_s32");
extern fn MaUint64 dr_flac_read_pcm_frames_s16(MaDrFlac* p_flac, ulong frames_to_read, MaInt16* p_buffer_out) @cname("ma_dr_flac_read_pcm_frames_s16");
extern fn MaUint64 dr_flac_read_pcm_frames_f32(MaDrFlac* p_flac, ulong frames_to_read, float* p_buffer_out) @cname("ma_dr_flac_read_pcm_frames_f32");
extern fn MaBool32 dr_flac_seek_to_pcm_frame(MaDrFlac* p_flac, ulong pcm_frame_index) @cname("ma_dr_flac_seek_to_pcm_frame");
extern fn MaDrFlac* dr_flac_open_file(ZString p_file_name, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_flac_open_file");
extern fn MaDrFlac* dr_flac_open_file_w(WcharT* p_file_name, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_flac_open_file_w");
extern fn MaDrFlac* dr_flac_open_file_with_metadata(ZString p_file_name, MaDrFlacMetaProc on_meta, void* p_user_data, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_flac_open_file_with_metadata");
extern fn MaDrFlac* dr_flac_open_file_with_metadata_w(WcharT* p_file_name, MaDrFlacMetaProc on_meta, void* p_user_data, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_flac_open_file_with_metadata_w");
extern fn MaDrFlac* dr_flac_open_memory(void* p_data, usz data_size, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_flac_open_memory");
extern fn MaDrFlac* dr_flac_open_memory_with_metadata(void* p_data, usz data_size, MaDrFlacMetaProc on_meta, void* p_user_data, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_flac_open_memory_with_metadata");
extern fn MaInt32* dr_flac_open_and_read_pcm_frames_s32(MaDrFlacReadProc on_read, MaDrFlacSeekProc on_seek, MaDrFlacTellProc on_tell, void* p_user_data, uint* channels, uint* sample_rate, MaUint64* total_pcm_frame_count, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_flac_open_and_read_pcm_frames_s32");
extern fn MaInt16* dr_flac_open_and_read_pcm_frames_s16(MaDrFlacReadProc on_read, MaDrFlacSeekProc on_seek, MaDrFlacTellProc on_tell, void* p_user_data, uint* channels, uint* sample_rate, MaUint64* total_pcm_frame_count, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_flac_open_and_read_pcm_frames_s16");
extern fn float* dr_flac_open_and_read_pcm_frames_f32(MaDrFlacReadProc on_read, MaDrFlacSeekProc on_seek, MaDrFlacTellProc on_tell, void* p_user_data, uint* channels, uint* sample_rate, MaUint64* total_pcm_frame_count, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_flac_open_and_read_pcm_frames_f32");
extern fn MaInt32* dr_flac_open_file_and_read_pcm_frames_s32(ZString filename, uint* channels, uint* sample_rate, MaUint64* total_pcm_frame_count, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_flac_open_file_and_read_pcm_frames_s32");
extern fn MaInt16* dr_flac_open_file_and_read_pcm_frames_s16(ZString filename, uint* channels, uint* sample_rate, MaUint64* total_pcm_frame_count, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_flac_open_file_and_read_pcm_frames_s16");
extern fn float* dr_flac_open_file_and_read_pcm_frames_f32(ZString filename, uint* channels, uint* sample_rate, MaUint64* total_pcm_frame_count, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_flac_open_file_and_read_pcm_frames_f32");
extern fn MaInt32* dr_flac_open_memory_and_read_pcm_frames_s32(void* data, usz data_size, uint* channels, uint* sample_rate, MaUint64* total_pcm_frame_count, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_flac_open_memory_and_read_pcm_frames_s32");
extern fn MaInt16* dr_flac_open_memory_and_read_pcm_frames_s16(void* data, usz data_size, uint* channels, uint* sample_rate, MaUint64* total_pcm_frame_count, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_flac_open_memory_and_read_pcm_frames_s16");
extern fn float* dr_flac_open_memory_and_read_pcm_frames_f32(void* data, usz data_size, uint* channels, uint* sample_rate, MaUint64* total_pcm_frame_count, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_flac_open_memory_and_read_pcm_frames_f32");
extern fn void dr_flac_free(void* p, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_flac_free");
extern fn void dr_flac_init_vorbis_comment_iterator(MaDrFlacVorbisCommentIterator* p_iter, uint comment_count, void* p_comments) @cname("ma_dr_flac_init_vorbis_comment_iterator");
extern fn ZString dr_flac_next_vorbis_comment(MaDrFlacVorbisCommentIterator* p_iter, MaUint32* p_comment_length_out) @cname("ma_dr_flac_next_vorbis_comment");
extern fn void dr_flac_init_cuesheet_track_iterator(MaDrFlacCuesheetTrackIterator* p_iter, uint track_count, void* p_track_data) @cname("ma_dr_flac_init_cuesheet_track_iterator");
extern fn MaBool32 dr_flac_next_cuesheet_track(MaDrFlacCuesheetTrackIterator* p_iter, MaDrFlacCuesheetTrack* p_cuesheet_track) @cname("ma_dr_flac_next_cuesheet_track");
extern fn void dr_mp3_version(MaUint32* p_major, MaUint32* p_minor, MaUint32* p_revision) @cname("ma_dr_mp3_version");
extern fn ZString dr_mp3_version_string() @cname("ma_dr_mp3_version_string");
extern fn void dr_mp3dec_init(MaDrMp3dec* dec) @cname("ma_dr_mp3dec_init");
extern fn int dr_mp3dec_decode_frame(MaDrMp3dec* dec, MaUint8* mp3, int mp3_bytes, void* pcm, MaDrMp3decFrameInfo* info) @cname("ma_dr_mp3dec_decode_frame");
extern fn void dr_mp3dec_f32_to_s16(float* in, MaInt16* out, usz num_samples) @cname("ma_dr_mp3dec_f32_to_s16");
extern fn MaBool32 dr_mp3_init(MaDrMp3* p_mp3, MaDrMp3ReadProc on_read, MaDrMp3SeekProc on_seek, MaDrMp3TellProc on_tell, MaDrMp3MetaProc on_meta, void* p_user_data, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_mp3_init");
extern fn MaBool32 dr_mp3_init_memory_with_metadata(MaDrMp3* p_mp3, void* p_data, usz data_size, MaDrMp3MetaProc on_meta, void* p_user_data_meta, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_mp3_init_memory_with_metadata");
extern fn MaBool32 dr_mp3_init_memory(MaDrMp3* p_mp3, void* p_data, usz data_size, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_mp3_init_memory");
extern fn MaBool32 dr_mp3_init_file_with_metadata(MaDrMp3* p_mp3, ZString p_file_path, MaDrMp3MetaProc on_meta, void* p_user_data_meta, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_mp3_init_file_with_metadata");
extern fn MaBool32 dr_mp3_init_file_with_metadata_w(MaDrMp3* p_mp3, WcharT* p_file_path, MaDrMp3MetaProc on_meta, void* p_user_data_meta, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_mp3_init_file_with_metadata_w");
extern fn MaBool32 dr_mp3_init_file(MaDrMp3* p_mp3, ZString p_file_path, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_mp3_init_file");
extern fn MaBool32 dr_mp3_init_file_w(MaDrMp3* p_mp3, WcharT* p_file_path, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_mp3_init_file_w");
extern fn void dr_mp3_uninit(MaDrMp3* p_mp3) @cname("ma_dr_mp3_uninit");
extern fn MaUint64 dr_mp3_read_pcm_frames_f32(MaDrMp3* p_mp3, ulong frames_to_read, float* p_buffer_out) @cname("ma_dr_mp3_read_pcm_frames_f32");
extern fn MaUint64 dr_mp3_read_pcm_frames_s16(MaDrMp3* p_mp3, ulong frames_to_read, MaInt16* p_buffer_out) @cname("ma_dr_mp3_read_pcm_frames_s16");
extern fn MaBool32 dr_mp3_seek_to_pcm_frame(MaDrMp3* p_mp3, ulong frame_index) @cname("ma_dr_mp3_seek_to_pcm_frame");
extern fn MaUint64 dr_mp3_get_pcm_frame_count(MaDrMp3* p_mp3) @cname("ma_dr_mp3_get_pcm_frame_count");
extern fn MaUint64 dr_mp3_get_mp3_frame_count(MaDrMp3* p_mp3) @cname("ma_dr_mp3_get_mp3_frame_count");
extern fn MaBool32 dr_mp3_get_mp3_and_pcm_frame_count(MaDrMp3* p_mp3, MaUint64* p_mp3_frame_count, MaUint64* p_pcm_frame_count) @cname("ma_dr_mp3_get_mp3_and_pcm_frame_count");
extern fn MaBool32 dr_mp3_calculate_seek_points(MaDrMp3* p_mp3, MaUint32* p_seek_point_count, MaDrMp3SeekPoint* p_seek_points) @cname("ma_dr_mp3_calculate_seek_points");
extern fn MaBool32 dr_mp3_bind_seek_table(MaDrMp3* p_mp3, uint seek_point_count, MaDrMp3SeekPoint* p_seek_points) @cname("ma_dr_mp3_bind_seek_table");
extern fn float* dr_mp3_open_and_read_pcm_frames_f32(MaDrMp3ReadProc on_read, MaDrMp3SeekProc on_seek, MaDrMp3TellProc on_tell, void* p_user_data, MaDrMp3Config* p_config, MaUint64* p_total_frame_count, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_mp3_open_and_read_pcm_frames_f32");
extern fn MaInt16* dr_mp3_open_and_read_pcm_frames_s16(MaDrMp3ReadProc on_read, MaDrMp3SeekProc on_seek, MaDrMp3TellProc on_tell, void* p_user_data, MaDrMp3Config* p_config, MaUint64* p_total_frame_count, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_mp3_open_and_read_pcm_frames_s16");
extern fn float* dr_mp3_open_memory_and_read_pcm_frames_f32(void* p_data, usz data_size, MaDrMp3Config* p_config, MaUint64* p_total_frame_count, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_mp3_open_memory_and_read_pcm_frames_f32");
extern fn MaInt16* dr_mp3_open_memory_and_read_pcm_frames_s16(void* p_data, usz data_size, MaDrMp3Config* p_config, MaUint64* p_total_frame_count, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_mp3_open_memory_and_read_pcm_frames_s16");
extern fn float* dr_mp3_open_file_and_read_pcm_frames_f32(ZString file_path, MaDrMp3Config* p_config, MaUint64* p_total_frame_count, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_mp3_open_file_and_read_pcm_frames_f32");
extern fn MaInt16* dr_mp3_open_file_and_read_pcm_frames_s16(ZString file_path, MaDrMp3Config* p_config, MaUint64* p_total_frame_count, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_mp3_open_file_and_read_pcm_frames_s16");
extern fn void* dr_mp3_malloc(usz sz_, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_mp3_malloc");
extern fn void dr_mp3_free(void* p, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_mp3_free");
extern fn MaResult decoder_read_bytes(MaDecoder* p_decoder, void* p_buffer_out, usz bytes_to_read, usz* p_bytes_read) @cname("ma_decoder_read_bytes");
extern fn MaResult decoder_seek_bytes(MaDecoder* p_decoder, long byte_offset, MaSeekOrigin origin) @cname("ma_decoder_seek_bytes");
extern fn MaResult decoder_tell_bytes(MaDecoder* p_decoder, MaInt64* p_cursor) @cname("ma_decoder_tell_bytes");
extern fn MaDecoderConfig decoder_config_init_copy(MaDecoderConfig* p_config) @cname("ma_decoder_config_init_copy");
extern fn MaResult decoder__init_data_converter(MaDecoder* p_decoder, MaDecoderConfig* p_config) @cname("ma_decoder__init_data_converter");
extern fn MaResult decoder_internal_on_read__custom(void* p_user_data, void* p_buffer_out, usz bytes_to_read, usz* p_bytes_read) @cname("ma_decoder_internal_on_read__custom");
extern fn MaResult decoder_internal_on_seek__custom(void* p_user_data, long offset, MaSeekOrigin origin) @cname("ma_decoder_internal_on_seek__custom");
extern fn MaResult decoder_internal_on_tell__custom(void* p_user_data, MaInt64* p_cursor) @cname("ma_decoder_internal_on_tell__custom");
extern fn MaResult decoder_init_from_vtable__internal(MaDecodingBackendVtable* p_v_table, void* p_v_table_user_data, MaDecoderConfig* p_config, MaDecoder* p_decoder) @cname("ma_decoder_init_from_vtable__internal");
extern fn MaResult decoder_init_from_file__internal(MaDecodingBackendVtable* p_v_table, void* p_v_table_user_data, ZString p_file_path, MaDecoderConfig* p_config, MaDecoder* p_decoder) @cname("ma_decoder_init_from_file__internal");
extern fn MaResult decoder_init_from_file_w__internal(MaDecodingBackendVtable* p_v_table, void* p_v_table_user_data, WcharT* p_file_path, MaDecoderConfig* p_config, MaDecoder* p_decoder) @cname("ma_decoder_init_from_file_w__internal");
extern fn MaResult decoder_init_from_memory__internal(MaDecodingBackendVtable* p_v_table, void* p_v_table_user_data, void* p_data, usz data_size, MaDecoderConfig* p_config, MaDecoder* p_decoder) @cname("ma_decoder_init_from_memory__internal");
extern fn MaResult decoder_init_custom__internal(MaDecoderConfig* p_config, MaDecoder* p_decoder) @cname("ma_decoder_init_custom__internal");
extern fn MaResult decoder_init_custom_from_file__internal(ZString p_file_path, MaDecoderConfig* p_config, MaDecoder* p_decoder) @cname("ma_decoder_init_custom_from_file__internal");
extern fn MaResult decoder_init_custom_from_file_w__internal(WcharT* p_file_path, MaDecoderConfig* p_config, MaDecoder* p_decoder) @cname("ma_decoder_init_custom_from_file_w__internal");
extern fn MaResult decoder_init_custom_from_memory__internal(void* p_data, usz data_size, MaDecoderConfig* p_config, MaDecoder* p_decoder) @cname("ma_decoder_init_custom_from_memory__internal");
extern fn MaResult wav_init(MaReadProc on_read, MaSeekProc on_seek, MaTellProc on_tell, void* p_read_seek_tell_user_data, MaDecodingBackendConfig* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaWav* p_wav) @cname("ma_wav_init");
extern fn MaResult wav_init_file(ZString p_file_path, MaDecodingBackendConfig* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaWav* p_wav) @cname("ma_wav_init_file");
extern fn MaResult wav_init_file_w(WcharT* p_file_path, MaDecodingBackendConfig* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaWav* p_wav) @cname("ma_wav_init_file_w");
extern fn MaResult wav_init_memory(void* p_data, usz data_size, MaDecodingBackendConfig* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaWav* p_wav) @cname("ma_wav_init_memory");
extern fn void wav_uninit(MaWav* p_wav, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_wav_uninit");
extern fn MaResult wav_read_pcm_frames(MaWav* p_wav, void* p_frames_out, ulong frame_count, MaUint64* p_frames_read) @cname("ma_wav_read_pcm_frames");
extern fn MaResult wav_seek_to_pcm_frame(MaWav* p_wav, ulong frame_index) @cname("ma_wav_seek_to_pcm_frame");
extern fn MaResult wav_get_data_format(MaWav* p_wav, MaFormat* p_format, MaUint32* p_channels, MaUint32* p_sample_rate, MaChannel* p_channel_map, usz channel_map_cap) @cname("ma_wav_get_data_format");
extern fn MaResult wav_get_cursor_in_pcm_frames(MaWav* p_wav, MaUint64* p_cursor) @cname("ma_wav_get_cursor_in_pcm_frames");
extern fn MaResult wav_get_length_in_pcm_frames(MaWav* p_wav, MaUint64* p_length) @cname("ma_wav_get_length_in_pcm_frames");
extern fn MaResult wav_ds_read(MaDataSource* p_data_source, void* p_frames_out, ulong frame_count, MaUint64* p_frames_read) @cname("ma_wav_ds_read");
extern fn MaResult wav_ds_seek(MaDataSource* p_data_source, ulong frame_index) @cname("ma_wav_ds_seek");
extern fn MaResult wav_ds_get_data_format(MaDataSource* p_data_source, MaFormat* p_format, MaUint32* p_channels, MaUint32* p_sample_rate, MaChannel* p_channel_map, usz channel_map_cap) @cname("ma_wav_ds_get_data_format");
extern fn MaResult wav_ds_get_cursor(MaDataSource* p_data_source, MaUint64* p_cursor) @cname("ma_wav_ds_get_cursor");
extern fn MaResult wav_ds_get_length(MaDataSource* p_data_source, MaUint64* p_length) @cname("ma_wav_ds_get_length");
extern fn usz wav_dr_callback__read(void* p_user_data, void* p_buffer_out, usz bytes_to_read) @cname("ma_wav_dr_callback__read");
extern fn MaBool32 wav_dr_callback__seek(void* p_user_data, int offset, MaDrWavSeekOrigin origin) @cname("ma_wav_dr_callback__seek");
extern fn MaBool32 wav_dr_callback__tell(void* p_user_data, MaInt64* p_cursor) @cname("ma_wav_dr_callback__tell");
extern fn MaResult wav_init_internal(MaDecodingBackendConfig* p_config, MaWav* p_wav) @cname("ma_wav_init_internal");
extern fn MaResult wav_post_init(MaWav* p_wav) @cname("ma_wav_post_init");
extern fn MaResult decoding_backend_init__wav(void* p_user_data, MaReadProc on_read, MaSeekProc on_seek, MaTellProc on_tell, void* p_read_seek_tell_user_data, MaDecodingBackendConfig* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaDataSource** pp_backend) @cname("ma_decoding_backend_init__wav");
extern fn MaResult decoding_backend_init_file__wav(void* p_user_data, ZString p_file_path, MaDecodingBackendConfig* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaDataSource** pp_backend) @cname("ma_decoding_backend_init_file__wav");
extern fn MaResult decoding_backend_init_file_w__wav(void* p_user_data, WcharT* p_file_path, MaDecodingBackendConfig* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaDataSource** pp_backend) @cname("ma_decoding_backend_init_file_w__wav");
extern fn MaResult decoding_backend_init_memory__wav(void* p_user_data, void* p_data, usz data_size, MaDecodingBackendConfig* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaDataSource** pp_backend) @cname("ma_decoding_backend_init_memory__wav");
extern fn void decoding_backend_uninit__wav(void* p_user_data, MaDataSource* p_backend, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_decoding_backend_uninit__wav");
extern fn MaResult decoder_init_wav__internal(MaDecoderConfig* p_config, MaDecoder* p_decoder) @cname("ma_decoder_init_wav__internal");
extern fn MaResult decoder_init_wav_from_file__internal(ZString p_file_path, MaDecoderConfig* p_config, MaDecoder* p_decoder) @cname("ma_decoder_init_wav_from_file__internal");
extern fn MaResult decoder_init_wav_from_file_w__internal(WcharT* p_file_path, MaDecoderConfig* p_config, MaDecoder* p_decoder) @cname("ma_decoder_init_wav_from_file_w__internal");
extern fn MaResult decoder_init_wav_from_memory__internal(void* p_data, usz data_size, MaDecoderConfig* p_config, MaDecoder* p_decoder) @cname("ma_decoder_init_wav_from_memory__internal");
extern fn MaResult flac_init(MaReadProc on_read, MaSeekProc on_seek, MaTellProc on_tell, void* p_read_seek_tell_user_data, MaDecodingBackendConfig* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaFlac* p_flac) @cname("ma_flac_init");
extern fn MaResult flac_init_file(ZString p_file_path, MaDecodingBackendConfig* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaFlac* p_flac) @cname("ma_flac_init_file");
extern fn MaResult flac_init_file_w(WcharT* p_file_path, MaDecodingBackendConfig* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaFlac* p_flac) @cname("ma_flac_init_file_w");
extern fn MaResult flac_init_memory(void* p_data, usz data_size, MaDecodingBackendConfig* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaFlac* p_flac) @cname("ma_flac_init_memory");
extern fn void flac_uninit(MaFlac* p_flac, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_flac_uninit");
extern fn MaResult flac_read_pcm_frames(MaFlac* p_flac, void* p_frames_out, ulong frame_count, MaUint64* p_frames_read) @cname("ma_flac_read_pcm_frames");
extern fn MaResult flac_seek_to_pcm_frame(MaFlac* p_flac, ulong frame_index) @cname("ma_flac_seek_to_pcm_frame");
extern fn MaResult flac_get_data_format(MaFlac* p_flac, MaFormat* p_format, MaUint32* p_channels, MaUint32* p_sample_rate, MaChannel* p_channel_map, usz channel_map_cap) @cname("ma_flac_get_data_format");
extern fn MaResult flac_get_cursor_in_pcm_frames(MaFlac* p_flac, MaUint64* p_cursor) @cname("ma_flac_get_cursor_in_pcm_frames");
extern fn MaResult flac_get_length_in_pcm_frames(MaFlac* p_flac, MaUint64* p_length) @cname("ma_flac_get_length_in_pcm_frames");
extern fn MaResult flac_ds_read(MaDataSource* p_data_source, void* p_frames_out, ulong frame_count, MaUint64* p_frames_read) @cname("ma_flac_ds_read");
extern fn MaResult flac_ds_seek(MaDataSource* p_data_source, ulong frame_index) @cname("ma_flac_ds_seek");
extern fn MaResult flac_ds_get_data_format(MaDataSource* p_data_source, MaFormat* p_format, MaUint32* p_channels, MaUint32* p_sample_rate, MaChannel* p_channel_map, usz channel_map_cap) @cname("ma_flac_ds_get_data_format");
extern fn MaResult flac_ds_get_cursor(MaDataSource* p_data_source, MaUint64* p_cursor) @cname("ma_flac_ds_get_cursor");
extern fn MaResult flac_ds_get_length(MaDataSource* p_data_source, MaUint64* p_length) @cname("ma_flac_ds_get_length");
extern fn usz flac_dr_callback__read(void* p_user_data, void* p_buffer_out, usz bytes_to_read) @cname("ma_flac_dr_callback__read");
extern fn MaBool32 flac_dr_callback__seek(void* p_user_data, int offset, MaDrFlacSeekOrigin origin) @cname("ma_flac_dr_callback__seek");
extern fn MaBool32 flac_dr_callback__tell(void* p_user_data, MaInt64* p_cursor) @cname("ma_flac_dr_callback__tell");
extern fn MaResult flac_init_internal(MaDecodingBackendConfig* p_config, MaFlac* p_flac) @cname("ma_flac_init_internal");
extern fn MaResult decoding_backend_init__flac(void* p_user_data, MaReadProc on_read, MaSeekProc on_seek, MaTellProc on_tell, void* p_read_seek_tell_user_data, MaDecodingBackendConfig* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaDataSource** pp_backend) @cname("ma_decoding_backend_init__flac");
extern fn MaResult decoding_backend_init_file__flac(void* p_user_data, ZString p_file_path, MaDecodingBackendConfig* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaDataSource** pp_backend) @cname("ma_decoding_backend_init_file__flac");
extern fn MaResult decoding_backend_init_file_w__flac(void* p_user_data, WcharT* p_file_path, MaDecodingBackendConfig* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaDataSource** pp_backend) @cname("ma_decoding_backend_init_file_w__flac");
extern fn MaResult decoding_backend_init_memory__flac(void* p_user_data, void* p_data, usz data_size, MaDecodingBackendConfig* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaDataSource** pp_backend) @cname("ma_decoding_backend_init_memory__flac");
extern fn void decoding_backend_uninit__flac(void* p_user_data, MaDataSource* p_backend, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_decoding_backend_uninit__flac");
extern fn MaResult decoder_init_flac__internal(MaDecoderConfig* p_config, MaDecoder* p_decoder) @cname("ma_decoder_init_flac__internal");
extern fn MaResult decoder_init_flac_from_file__internal(ZString p_file_path, MaDecoderConfig* p_config, MaDecoder* p_decoder) @cname("ma_decoder_init_flac_from_file__internal");
extern fn MaResult decoder_init_flac_from_file_w__internal(WcharT* p_file_path, MaDecoderConfig* p_config, MaDecoder* p_decoder) @cname("ma_decoder_init_flac_from_file_w__internal");
extern fn MaResult decoder_init_flac_from_memory__internal(void* p_data, usz data_size, MaDecoderConfig* p_config, MaDecoder* p_decoder) @cname("ma_decoder_init_flac_from_memory__internal");
extern fn MaResult mp3_init(MaReadProc on_read, MaSeekProc on_seek, MaTellProc on_tell, void* p_read_seek_tell_user_data, MaDecodingBackendConfig* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaMp3* p_mp3) @cname("ma_mp3_init");
extern fn MaResult mp3_init_file(ZString p_file_path, MaDecodingBackendConfig* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaMp3* p_mp3) @cname("ma_mp3_init_file");
extern fn MaResult mp3_init_file_w(WcharT* p_file_path, MaDecodingBackendConfig* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaMp3* p_mp3) @cname("ma_mp3_init_file_w");
extern fn MaResult mp3_init_memory(void* p_data, usz data_size, MaDecodingBackendConfig* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaMp3* p_mp3) @cname("ma_mp3_init_memory");
extern fn void mp3_uninit(MaMp3* p_mp3, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_mp3_uninit");
extern fn MaResult mp3_read_pcm_frames(MaMp3* p_mp3, void* p_frames_out, ulong frame_count, MaUint64* p_frames_read) @cname("ma_mp3_read_pcm_frames");
extern fn MaResult mp3_seek_to_pcm_frame(MaMp3* p_mp3, ulong frame_index) @cname("ma_mp3_seek_to_pcm_frame");
extern fn MaResult mp3_get_data_format(MaMp3* p_mp3, MaFormat* p_format, MaUint32* p_channels, MaUint32* p_sample_rate, MaChannel* p_channel_map, usz channel_map_cap) @cname("ma_mp3_get_data_format");
extern fn MaResult mp3_get_cursor_in_pcm_frames(MaMp3* p_mp3, MaUint64* p_cursor) @cname("ma_mp3_get_cursor_in_pcm_frames");
extern fn MaResult mp3_get_length_in_pcm_frames(MaMp3* p_mp3, MaUint64* p_length) @cname("ma_mp3_get_length_in_pcm_frames");
extern fn MaResult mp3_ds_read(MaDataSource* p_data_source, void* p_frames_out, ulong frame_count, MaUint64* p_frames_read) @cname("ma_mp3_ds_read");
extern fn MaResult mp3_ds_seek(MaDataSource* p_data_source, ulong frame_index) @cname("ma_mp3_ds_seek");
extern fn MaResult mp3_ds_get_data_format(MaDataSource* p_data_source, MaFormat* p_format, MaUint32* p_channels, MaUint32* p_sample_rate, MaChannel* p_channel_map, usz channel_map_cap) @cname("ma_mp3_ds_get_data_format");
extern fn MaResult mp3_ds_get_cursor(MaDataSource* p_data_source, MaUint64* p_cursor) @cname("ma_mp3_ds_get_cursor");
extern fn MaResult mp3_ds_get_length(MaDataSource* p_data_source, MaUint64* p_length) @cname("ma_mp3_ds_get_length");
extern fn usz mp3_dr_callback__read(void* p_user_data, void* p_buffer_out, usz bytes_to_read) @cname("ma_mp3_dr_callback__read");
extern fn MaBool32 mp3_dr_callback__seek(void* p_user_data, int offset, MaDrMp3SeekOrigin origin) @cname("ma_mp3_dr_callback__seek");
extern fn MaBool32 mp3_dr_callback__tell(void* p_user_data, MaInt64* p_cursor) @cname("ma_mp3_dr_callback__tell");
extern fn MaResult mp3_init_internal(MaDecodingBackendConfig* p_config, MaMp3* p_mp3) @cname("ma_mp3_init_internal");
extern fn MaResult mp3_generate_seek_table(MaMp3* p_mp3, MaDecodingBackendConfig* p_config, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_mp3_generate_seek_table");
extern fn MaResult mp3_post_init(MaMp3* p_mp3, MaDecodingBackendConfig* p_config, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_mp3_post_init");
extern fn MaResult decoding_backend_init__mp3(void* p_user_data, MaReadProc on_read, MaSeekProc on_seek, MaTellProc on_tell, void* p_read_seek_tell_user_data, MaDecodingBackendConfig* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaDataSource** pp_backend) @cname("ma_decoding_backend_init__mp3");
extern fn MaResult decoding_backend_init_file__mp3(void* p_user_data, ZString p_file_path, MaDecodingBackendConfig* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaDataSource** pp_backend) @cname("ma_decoding_backend_init_file__mp3");
extern fn MaResult decoding_backend_init_file_w__mp3(void* p_user_data, WcharT* p_file_path, MaDecodingBackendConfig* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaDataSource** pp_backend) @cname("ma_decoding_backend_init_file_w__mp3");
extern fn MaResult decoding_backend_init_memory__mp3(void* p_user_data, void* p_data, usz data_size, MaDecodingBackendConfig* p_config, MaAllocationCallbacks* p_allocation_callbacks, MaDataSource** pp_backend) @cname("ma_decoding_backend_init_memory__mp3");
extern fn void decoding_backend_uninit__mp3(void* p_user_data, MaDataSource* p_backend, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_decoding_backend_uninit__mp3");
extern fn MaResult decoder_init_mp3__internal(MaDecoderConfig* p_config, MaDecoder* p_decoder) @cname("ma_decoder_init_mp3__internal");
extern fn MaResult decoder_init_mp3_from_file__internal(ZString p_file_path, MaDecoderConfig* p_config, MaDecoder* p_decoder) @cname("ma_decoder_init_mp3_from_file__internal");
extern fn MaResult decoder_init_mp3_from_file_w__internal(WcharT* p_file_path, MaDecoderConfig* p_config, MaDecoder* p_decoder) @cname("ma_decoder_init_mp3_from_file_w__internal");
extern fn MaResult decoder_init_mp3_from_memory__internal(void* p_data, usz data_size, MaDecoderConfig* p_config, MaDecoder* p_decoder) @cname("ma_decoder_init_mp3_from_memory__internal");
extern fn MaResult decoder__init_allocation_callbacks(MaDecoderConfig* p_config, MaDecoder* p_decoder) @cname("ma_decoder__init_allocation_callbacks");
extern fn MaResult decoder__data_source_on_read(MaDataSource* p_data_source, void* p_frames_out, ulong frame_count, MaUint64* p_frames_read) @cname("ma_decoder__data_source_on_read");
extern fn MaResult decoder__data_source_on_seek(MaDataSource* p_data_source, ulong frame_index) @cname("ma_decoder__data_source_on_seek");
extern fn MaResult decoder__data_source_on_get_data_format(MaDataSource* p_data_source, MaFormat* p_format, MaUint32* p_channels, MaUint32* p_sample_rate, MaChannel* p_channel_map, usz channel_map_cap) @cname("ma_decoder__data_source_on_get_data_format");
extern fn MaResult decoder__data_source_on_get_cursor(MaDataSource* p_data_source, MaUint64* p_cursor) @cname("ma_decoder__data_source_on_get_cursor");
extern fn MaResult decoder__data_source_on_get_length(MaDataSource* p_data_source, MaUint64* p_length) @cname("ma_decoder__data_source_on_get_length");
extern fn MaResult decoder__preinit(MaDecoderReadProc on_read, MaDecoderSeekProc on_seek, MaDecoderTellProc on_tell, void* p_user_data, MaDecoderConfig* p_config, MaDecoder* p_decoder) @cname("ma_decoder__preinit");
extern fn MaResult decoder__postinit(MaDecoderConfig* p_config, MaDecoder* p_decoder) @cname("ma_decoder__postinit");
extern fn MaResult decoder_init__internal(MaDecoderReadProc on_read, MaDecoderSeekProc on_seek, void* p_user_data, MaDecoderConfig* p_config, MaDecoder* p_decoder) @cname("ma_decoder_init__internal");
extern fn MaResult decoder__on_read_memory(MaDecoder* p_decoder, void* p_buffer_out, usz bytes_to_read, usz* p_bytes_read) @cname("ma_decoder__on_read_memory");
extern fn MaResult decoder__on_seek_memory(MaDecoder* p_decoder, long byte_offset, MaSeekOrigin origin) @cname("ma_decoder__on_seek_memory");
extern fn MaResult decoder__on_tell_memory(MaDecoder* p_decoder, MaInt64* p_cursor) @cname("ma_decoder__on_tell_memory");
extern fn MaResult decoder__preinit_memory_wrapper(void* p_data, usz data_size, MaDecoderConfig* p_config, MaDecoder* p_decoder) @cname("ma_decoder__preinit_memory_wrapper");
extern fn ZString path_file_name(ZString path) @cname("ma_path_file_name");
extern fn WcharT* path_file_name_w(WcharT* path) @cname("ma_path_file_name_w");
extern fn ZString path_extension(ZString path) @cname("ma_path_extension");
extern fn WcharT* path_extension_w(WcharT* path) @cname("ma_path_extension_w");
extern fn MaBool32 path_extension_equal(ZString path, ZString extension) @cname("ma_path_extension_equal");
extern fn MaBool32 path_extension_equal_w(WcharT* path, WcharT* extension) @cname("ma_path_extension_equal_w");
extern fn MaResult decoder__on_read_vfs(MaDecoder* p_decoder, void* p_buffer_out, usz bytes_to_read, usz* p_bytes_read) @cname("ma_decoder__on_read_vfs");
extern fn MaResult decoder__on_seek_vfs(MaDecoder* p_decoder, long offset, MaSeekOrigin origin) @cname("ma_decoder__on_seek_vfs");
extern fn MaResult decoder__on_tell_vfs(MaDecoder* p_decoder, MaInt64* p_cursor) @cname("ma_decoder__on_tell_vfs");
extern fn MaResult decoder__preinit_vfs(MaVfs* p_vfs, ZString p_file_path, MaDecoderConfig* p_config, MaDecoder* p_decoder) @cname("ma_decoder__preinit_vfs");
extern fn MaResult decoder__preinit_vfs_w(MaVfs* p_vfs, WcharT* p_file_path, MaDecoderConfig* p_config, MaDecoder* p_decoder) @cname("ma_decoder__preinit_vfs_w");
extern fn MaResult decoder__preinit_file(ZString p_file_path, MaDecoderConfig* p_config, MaDecoder* p_decoder) @cname("ma_decoder__preinit_file");
extern fn MaResult decoder__preinit_file_w(WcharT* p_file_path, MaDecoderConfig* p_config, MaDecoder* p_decoder) @cname("ma_decoder__preinit_file_w");
extern fn MaResult decoder__full_decode_and_uninit(MaDecoder* p_decoder, MaDecoderConfig* p_config_out, MaUint64* p_frame_count_out, void** pp_pcm_frames_out) @cname("ma_decoder__full_decode_and_uninit");
extern fn usz encoder__internal_on_write_wav(void* p_user_data, void* p_data, usz bytes_to_write) @cname("ma_encoder__internal_on_write_wav");
extern fn MaBool32 encoder__internal_on_seek_wav(void* p_user_data, int offset, MaDrWavSeekOrigin origin) @cname("ma_encoder__internal_on_seek_wav");
extern fn MaResult encoder__on_init_wav(MaEncoder* p_encoder) @cname("ma_encoder__on_init_wav");
extern fn void encoder__on_uninit_wav(MaEncoder* p_encoder) @cname("ma_encoder__on_uninit_wav");
extern fn MaResult encoder__on_write_pcm_frames_wav(MaEncoder* p_encoder, void* p_frames_in, ulong frame_count, MaUint64* p_frames_written) @cname("ma_encoder__on_write_pcm_frames_wav");
extern fn MaResult encoder_preinit(MaEncoderConfig* p_config, MaEncoder* p_encoder) @cname("ma_encoder_preinit");
extern fn MaResult encoder_init__internal(MaEncoderWriteProc on_write, MaEncoderSeekProc on_seek, void* p_user_data, MaEncoder* p_encoder) @cname("ma_encoder_init__internal");
extern fn MaResult encoder__on_write_vfs(MaEncoder* p_encoder, void* p_buffer_in, usz bytes_to_write, usz* p_bytes_written) @cname("ma_encoder__on_write_vfs");
extern fn MaResult encoder__on_seek_vfs(MaEncoder* p_encoder, long offset, MaSeekOrigin origin) @cname("ma_encoder__on_seek_vfs");
extern fn MaResult waveform__data_source_on_read(MaDataSource* p_data_source, void* p_frames_out, ulong frame_count, MaUint64* p_frames_read) @cname("ma_waveform__data_source_on_read");
extern fn MaResult waveform__data_source_on_seek(MaDataSource* p_data_source, ulong frame_index) @cname("ma_waveform__data_source_on_seek");
extern fn MaResult waveform__data_source_on_get_data_format(MaDataSource* p_data_source, MaFormat* p_format, MaUint32* p_channels, MaUint32* p_sample_rate, MaChannel* p_channel_map, usz channel_map_cap) @cname("ma_waveform__data_source_on_get_data_format");
extern fn MaResult waveform__data_source_on_get_cursor(MaDataSource* p_data_source, MaUint64* p_cursor) @cname("ma_waveform__data_source_on_get_cursor");
extern fn double waveform__calculate_advance(uint sample_rate, double frequency) @cname("ma_waveform__calculate_advance");
extern fn void waveform__update_advance(MaWaveform* p_waveform) @cname("ma_waveform__update_advance");
extern fn float waveform_sine_f32(double time, double amplitude) @cname("ma_waveform_sine_f32");
extern fn MaInt16 waveform_sine_s16(double time, double amplitude) @cname("ma_waveform_sine_s16");
extern fn float waveform_square_f32(double time, double duty_cycle, double amplitude) @cname("ma_waveform_square_f32");
extern fn MaInt16 waveform_square_s16(double time, double duty_cycle, double amplitude) @cname("ma_waveform_square_s16");
extern fn float waveform_triangle_f32(double time, double amplitude) @cname("ma_waveform_triangle_f32");
extern fn MaInt16 waveform_triangle_s16(double time, double amplitude) @cname("ma_waveform_triangle_s16");
extern fn float waveform_sawtooth_f32(double time, double amplitude) @cname("ma_waveform_sawtooth_f32");
extern fn MaInt16 waveform_sawtooth_s16(double time, double amplitude) @cname("ma_waveform_sawtooth_s16");
extern fn void waveform_read_pcm_frames__sine(MaWaveform* p_waveform, void* p_frames_out, ulong frame_count) @cname("ma_waveform_read_pcm_frames__sine");
extern fn void waveform_read_pcm_frames__square(MaWaveform* p_waveform, double duty_cycle, void* p_frames_out, ulong frame_count) @cname("ma_waveform_read_pcm_frames__square");
extern fn void waveform_read_pcm_frames__triangle(MaWaveform* p_waveform, void* p_frames_out, ulong frame_count) @cname("ma_waveform_read_pcm_frames__triangle");
extern fn void waveform_read_pcm_frames__sawtooth(MaWaveform* p_waveform, void* p_frames_out, ulong frame_count) @cname("ma_waveform_read_pcm_frames__sawtooth");
extern fn MaResult noise__data_source_on_read(MaDataSource* p_data_source, void* p_frames_out, ulong frame_count, MaUint64* p_frames_read) @cname("ma_noise__data_source_on_read");
extern fn MaResult noise__data_source_on_seek(MaDataSource* p_data_source, ulong frame_index) @cname("ma_noise__data_source_on_seek");
extern fn MaResult noise__data_source_on_get_data_format(MaDataSource* p_data_source, MaFormat* p_format, MaUint32* p_channels, MaUint32* p_sample_rate, MaChannel* p_channel_map, usz channel_map_cap) @cname("ma_noise__data_source_on_get_data_format");
extern fn MaResult noise_get_heap_layout(MaNoiseConfig* p_config, MaNoiseHeapLayout* p_heap_layout) @cname("ma_noise_get_heap_layout");
extern fn float noise_f32_white(MaNoise* p_noise) @cname("ma_noise_f32_white");
extern fn MaInt16 noise_s16_white(MaNoise* p_noise) @cname("ma_noise_s16_white");
extern fn MaUint64 noise_read_pcm_frames__white(MaNoise* p_noise, void* p_frames_out, ulong frame_count) @cname("ma_noise_read_pcm_frames__white");
extern fn uint tzcnt32(uint x) @cname("ma_tzcnt32");
extern fn float noise_f32_pink(MaNoise* p_noise, uint i_channel) @cname("ma_noise_f32_pink");
extern fn MaInt16 noise_s16_pink(MaNoise* p_noise, uint i_channel) @cname("ma_noise_s16_pink");
extern fn MaUint64 noise_read_pcm_frames__pink(MaNoise* p_noise, void* p_frames_out, ulong frame_count) @cname("ma_noise_read_pcm_frames__pink");
extern fn float noise_f32_brownian(MaNoise* p_noise, uint i_channel) @cname("ma_noise_f32_brownian");
extern fn MaInt16 noise_s16_brownian(MaNoise* p_noise, uint i_channel) @cname("ma_noise_s16_brownian");
extern fn MaUint64 noise_read_pcm_frames__brownian(MaNoise* p_noise, void* p_frames_out, ulong frame_count) @cname("ma_noise_read_pcm_frames__brownian");
extern fn void resource_manager_pipeline_notifications_signal_all_notifications(MaResourceManagerPipelineNotifications* p_pipeline_notifications) @cname("ma_resource_manager_pipeline_notifications_signal_all_notifications");
extern fn void resource_manager_pipeline_notifications_acquire_all_fences(MaResourceManagerPipelineNotifications* p_pipeline_notifications) @cname("ma_resource_manager_pipeline_notifications_acquire_all_fences");
extern fn void resource_manager_pipeline_notifications_release_all_fences(MaResourceManagerPipelineNotifications* p_pipeline_notifications) @cname("ma_resource_manager_pipeline_notifications_release_all_fences");
extern fn MaUint32 rotl32(uint x, ichar r) @cname("ma_rotl32");
extern fn MaUint32 hash_getblock(MaUint32* blocks, int i) @cname("ma_hash_getblock");
extern fn MaUint32 hash_fmix32(uint h) @cname("ma_hash_fmix32");
extern fn MaUint32 hash_32(void* key, int len, uint seed) @cname("ma_hash_32");
extern fn MaUint32 hash_string_32(ZString str) @cname("ma_hash_string_32");
extern fn MaUint32 hash_string_w_32(WcharT* str) @cname("ma_hash_string_w_32");
extern fn MaResult resource_manager_data_buffer_node_search(MaResourceManager* p_resource_manager, uint hashed_name32, MaResourceManagerDataBufferNode** pp_data_buffer_node) @cname("ma_resource_manager_data_buffer_node_search");
extern fn MaResult resource_manager_data_buffer_node_insert_point(MaResourceManager* p_resource_manager, uint hashed_name32, MaResourceManagerDataBufferNode** pp_insert_point) @cname("ma_resource_manager_data_buffer_node_insert_point");
extern fn MaResult resource_manager_data_buffer_node_insert_at(MaResourceManager* p_resource_manager, MaResourceManagerDataBufferNode* p_data_buffer_node, MaResourceManagerDataBufferNode* p_insert_point) @cname("ma_resource_manager_data_buffer_node_insert_at");
extern fn MaResourceManagerDataBufferNode* resource_manager_data_buffer_node_find_min(MaResourceManagerDataBufferNode* p_data_buffer_node) @cname("ma_resource_manager_data_buffer_node_find_min");
extern fn MaResourceManagerDataBufferNode* resource_manager_data_buffer_node_find_max(MaResourceManagerDataBufferNode* p_data_buffer_node) @cname("ma_resource_manager_data_buffer_node_find_max");
extern fn MaResourceManagerDataBufferNode* resource_manager_data_buffer_node_find_inorder_successor(MaResourceManagerDataBufferNode* p_data_buffer_node) @cname("ma_resource_manager_data_buffer_node_find_inorder_successor");
extern fn MaResult resource_manager_data_buffer_node_remove(MaResourceManager* p_resource_manager, MaResourceManagerDataBufferNode* p_data_buffer_node) @cname("ma_resource_manager_data_buffer_node_remove");
extern fn MaResourceManagerDataSupplyType resource_manager_data_buffer_node_get_data_supply_type(MaResourceManagerDataBufferNode* p_data_buffer_node) @cname("ma_resource_manager_data_buffer_node_get_data_supply_type");
extern fn void resource_manager_data_buffer_node_set_data_supply_type(MaResourceManagerDataBufferNode* p_data_buffer_node, MaResourceManagerDataSupplyType supply_type) @cname("ma_resource_manager_data_buffer_node_set_data_supply_type");
extern fn MaResult resource_manager_data_buffer_node_increment_ref(MaResourceManager* p_resource_manager, MaResourceManagerDataBufferNode* p_data_buffer_node, MaUint32* p_new_ref_count) @cname("ma_resource_manager_data_buffer_node_increment_ref");
extern fn MaResult resource_manager_data_buffer_node_decrement_ref(MaResourceManager* p_resource_manager, MaResourceManagerDataBufferNode* p_data_buffer_node, MaUint32* p_new_ref_count) @cname("ma_resource_manager_data_buffer_node_decrement_ref");
extern fn void resource_manager_data_buffer_node_free(MaResourceManager* p_resource_manager, MaResourceManagerDataBufferNode* p_data_buffer_node) @cname("ma_resource_manager_data_buffer_node_free");
extern fn MaResult resource_manager_data_buffer_node_result(MaResourceManagerDataBufferNode* p_data_buffer_node) @cname("ma_resource_manager_data_buffer_node_result");
extern fn MaBool32 resource_manager_is_threading_enabled(MaResourceManager* p_resource_manager) @cname("ma_resource_manager_is_threading_enabled");
extern fn MaResult resource_manager_inline_notification_init(MaResourceManager* p_resource_manager, MaResourceManagerInlineNotification* p_notification) @cname("ma_resource_manager_inline_notification_init");
extern fn void resource_manager_inline_notification_uninit(MaResourceManagerInlineNotification* p_notification) @cname("ma_resource_manager_inline_notification_uninit");
extern fn void resource_manager_inline_notification_wait(MaResourceManagerInlineNotification* p_notification) @cname("ma_resource_manager_inline_notification_wait");
extern fn void resource_manager_inline_notification_wait_and_uninit(MaResourceManagerInlineNotification* p_notification) @cname("ma_resource_manager_inline_notification_wait_and_uninit");
extern fn void resource_manager_data_buffer_bst_lock(MaResourceManager* p_resource_manager) @cname("ma_resource_manager_data_buffer_bst_lock");
extern fn void resource_manager_data_buffer_bst_unlock(MaResourceManager* p_resource_manager) @cname("ma_resource_manager_data_buffer_bst_unlock");
extern fn MaThreadResult resource_manager_job_thread(void* p_user_data) @cname("ma_resource_manager_job_thread");
extern fn void resource_manager_delete_all_data_buffer_nodes(MaResourceManager* p_resource_manager) @cname("ma_resource_manager_delete_all_data_buffer_nodes");
extern fn MaDecoderConfig resource_manager__init_decoder_config(MaResourceManager* p_resource_manager) @cname("ma_resource_manager__init_decoder_config");
extern fn MaResult resource_manager__init_decoder(MaResourceManager* p_resource_manager, ZString p_file_path, WcharT* p_file_path_w, MaDecoder* p_decoder) @cname("ma_resource_manager__init_decoder");
extern fn MaBool32 resource_manager_data_buffer_has_connector(MaResourceManagerDataBuffer* p_data_buffer) @cname("ma_resource_manager_data_buffer_has_connector");
extern fn MaDataSource* resource_manager_data_buffer_get_connector(MaResourceManagerDataBuffer* p_data_buffer) @cname("ma_resource_manager_data_buffer_get_connector");
extern fn MaResult resource_manager_data_buffer_init_connector(MaResourceManagerDataBuffer* p_data_buffer, MaResourceManagerDataSourceConfig* p_config, MaAsyncNotification* p_init_notification, MaFence* p_init_fence) @cname("ma_resource_manager_data_buffer_init_connector");
extern fn MaResult resource_manager_data_buffer_uninit_connector(MaResourceManager* p_resource_manager, MaResourceManagerDataBuffer* p_data_buffer) @cname("ma_resource_manager_data_buffer_uninit_connector");
extern fn MaUint32 resource_manager_data_buffer_node_next_execution_order(MaResourceManagerDataBufferNode* p_data_buffer_node) @cname("ma_resource_manager_data_buffer_node_next_execution_order");
extern fn MaResult resource_manager_data_buffer_node_init_supply_encoded(MaResourceManager* p_resource_manager, MaResourceManagerDataBufferNode* p_data_buffer_node, ZString p_file_path, WcharT* p_file_path_w) @cname("ma_resource_manager_data_buffer_node_init_supply_encoded");
extern fn MaResult resource_manager_data_buffer_node_init_supply_decoded(MaResourceManager* p_resource_manager, MaResourceManagerDataBufferNode* p_data_buffer_node, ZString p_file_path, WcharT* p_file_path_w, uint flags, MaDecoder** pp_decoder) @cname("ma_resource_manager_data_buffer_node_init_supply_decoded");
extern fn MaResult resource_manager_data_buffer_node_decode_next_page(MaResourceManager* p_resource_manager, MaResourceManagerDataBufferNode* p_data_buffer_node, MaDecoder* p_decoder) @cname("ma_resource_manager_data_buffer_node_decode_next_page");
extern fn MaResult resource_manager_data_buffer_node_acquire_critical_section(MaResourceManager* p_resource_manager, ZString p_file_path, WcharT* p_file_path_w, uint hashed_name32, uint flags, MaResourceManagerDataSupply* p_existing_data, MaFence* p_init_fence, MaFence* p_done_fence, MaResourceManagerInlineNotification* p_init_notification, MaResourceManagerDataBufferNode** pp_data_buffer_node) @cname("ma_resource_manager_data_buffer_node_acquire_critical_section");
extern fn MaResult resource_manager_data_buffer_node_acquire(MaResourceManager* p_resource_manager, ZString p_file_path, WcharT* p_file_path_w, uint hashed_name32, uint flags, MaResourceManagerDataSupply* p_existing_data, MaFence* p_init_fence, MaFence* p_done_fence, MaResourceManagerDataBufferNode** pp_data_buffer_node) @cname("ma_resource_manager_data_buffer_node_acquire");
extern fn MaResult resource_manager_data_buffer_node_unacquire(MaResourceManager* p_resource_manager, MaResourceManagerDataBufferNode* p_data_buffer_node, ZString p_name, WcharT* p_name_w) @cname("ma_resource_manager_data_buffer_node_unacquire");
extern fn MaUint32 resource_manager_data_buffer_next_execution_order(MaResourceManagerDataBuffer* p_data_buffer) @cname("ma_resource_manager_data_buffer_next_execution_order");
extern fn MaResult resource_manager_data_buffer_cb__read_pcm_frames(MaDataSource* p_data_source, void* p_frames_out, ulong frame_count, MaUint64* p_frames_read) @cname("ma_resource_manager_data_buffer_cb__read_pcm_frames");
extern fn MaResult resource_manager_data_buffer_cb__seek_to_pcm_frame(MaDataSource* p_data_source, ulong frame_index) @cname("ma_resource_manager_data_buffer_cb__seek_to_pcm_frame");
extern fn MaResult resource_manager_data_buffer_cb__get_data_format(MaDataSource* p_data_source, MaFormat* p_format, MaUint32* p_channels, MaUint32* p_sample_rate, MaChannel* p_channel_map, usz channel_map_cap) @cname("ma_resource_manager_data_buffer_cb__get_data_format");
extern fn MaResult resource_manager_data_buffer_cb__get_cursor_in_pcm_frames(MaDataSource* p_data_source, MaUint64* p_cursor) @cname("ma_resource_manager_data_buffer_cb__get_cursor_in_pcm_frames");
extern fn MaResult resource_manager_data_buffer_cb__get_length_in_pcm_frames(MaDataSource* p_data_source, MaUint64* p_length) @cname("ma_resource_manager_data_buffer_cb__get_length_in_pcm_frames");
extern fn MaResult resource_manager_data_buffer_cb__set_looping(MaDataSource* p_data_source, uint is_looping) @cname("ma_resource_manager_data_buffer_cb__set_looping");
extern fn MaResult resource_manager_data_buffer_init_ex_internal(MaResourceManager* p_resource_manager, MaResourceManagerDataSourceConfig* p_config, uint hashed_name32, MaResourceManagerDataBuffer* p_data_buffer) @cname("ma_resource_manager_data_buffer_init_ex_internal");
extern fn MaResult resource_manager_data_buffer_uninit_internal(MaResourceManagerDataBuffer* p_data_buffer) @cname("ma_resource_manager_data_buffer_uninit_internal");
extern fn MaResult resource_manager_register_data(MaResourceManager* p_resource_manager, ZString p_name, WcharT* p_name_w, MaResourceManagerDataSupply* p_existing_data) @cname("ma_resource_manager_register_data");
extern fn MaResult resource_manager_register_decoded_data_internal(MaResourceManager* p_resource_manager, ZString p_name, WcharT* p_name_w, void* p_data, ulong frame_count, MaFormat format, uint channels, uint sample_rate) @cname("ma_resource_manager_register_decoded_data_internal");
extern fn MaResult resource_manager_register_encoded_data_internal(MaResourceManager* p_resource_manager, ZString p_name, WcharT* p_name_w, void* p_data, usz size_in_bytes) @cname("ma_resource_manager_register_encoded_data_internal");
extern fn MaUint32 resource_manager_data_stream_next_execution_order(MaResourceManagerDataStream* p_data_stream) @cname("ma_resource_manager_data_stream_next_execution_order");
extern fn MaBool32 resource_manager_data_stream_is_decoder_at_end(MaResourceManagerDataStream* p_data_stream) @cname("ma_resource_manager_data_stream_is_decoder_at_end");
extern fn MaUint32 resource_manager_data_stream_seek_counter(MaResourceManagerDataStream* p_data_stream) @cname("ma_resource_manager_data_stream_seek_counter");
extern fn MaResult resource_manager_data_stream_cb__read_pcm_frames(MaDataSource* p_data_source, void* p_frames_out, ulong frame_count, MaUint64* p_frames_read) @cname("ma_resource_manager_data_stream_cb__read_pcm_frames");
extern fn MaResult resource_manager_data_stream_cb__seek_to_pcm_frame(MaDataSource* p_data_source, ulong frame_index) @cname("ma_resource_manager_data_stream_cb__seek_to_pcm_frame");
extern fn MaResult resource_manager_data_stream_cb__get_data_format(MaDataSource* p_data_source, MaFormat* p_format, MaUint32* p_channels, MaUint32* p_sample_rate, MaChannel* p_channel_map, usz channel_map_cap) @cname("ma_resource_manager_data_stream_cb__get_data_format");
extern fn MaResult resource_manager_data_stream_cb__get_cursor_in_pcm_frames(MaDataSource* p_data_source, MaUint64* p_cursor) @cname("ma_resource_manager_data_stream_cb__get_cursor_in_pcm_frames");
extern fn MaResult resource_manager_data_stream_cb__get_length_in_pcm_frames(MaDataSource* p_data_source, MaUint64* p_length) @cname("ma_resource_manager_data_stream_cb__get_length_in_pcm_frames");
extern fn MaResult resource_manager_data_stream_cb__set_looping(MaDataSource* p_data_source, uint is_looping) @cname("ma_resource_manager_data_stream_cb__set_looping");
extern fn void resource_manager_data_stream_set_absolute_cursor(MaResourceManagerDataStream* p_data_stream, ulong absolute_cursor) @cname("ma_resource_manager_data_stream_set_absolute_cursor");
extern fn MaUint32 resource_manager_data_stream_get_page_size_in_frames(MaResourceManagerDataStream* p_data_stream) @cname("ma_resource_manager_data_stream_get_page_size_in_frames");
extern fn void* resource_manager_data_stream_get_page_data_pointer(MaResourceManagerDataStream* p_data_stream, uint page_index, uint relative_cursor) @cname("ma_resource_manager_data_stream_get_page_data_pointer");
extern fn void resource_manager_data_stream_fill_page(MaResourceManagerDataStream* p_data_stream, uint page_index) @cname("ma_resource_manager_data_stream_fill_page");
extern fn void resource_manager_data_stream_fill_pages(MaResourceManagerDataStream* p_data_stream) @cname("ma_resource_manager_data_stream_fill_pages");
extern fn MaResult resource_manager_data_stream_map(MaResourceManagerDataStream* p_data_stream, void** pp_frames_out, MaUint64* p_frame_count) @cname("ma_resource_manager_data_stream_map");
extern fn MaResult resource_manager_data_stream_unmap(MaResourceManagerDataStream* p_data_stream, ulong frame_count) @cname("ma_resource_manager_data_stream_unmap");
extern fn MaResult resource_manager_data_source_preinit(MaResourceManager* p_resource_manager, MaResourceManagerDataSourceConfig* p_config, MaResourceManagerDataSource* p_data_source) @cname("ma_resource_manager_data_source_preinit");
extern fn MaResult resource_manager_data_source_map(MaResourceManagerDataSource* p_data_source, void** pp_frames_out, MaUint64* p_frame_count) @cname("ma_resource_manager_data_source_map");
extern fn MaResult resource_manager_data_source_unmap(MaResourceManagerDataSource* p_data_source, ulong frame_count) @cname("ma_resource_manager_data_source_unmap");
extern fn MaStack* stack_init(usz size_in_bytes, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_stack_init");
extern fn void stack_uninit(MaStack* p_stack, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_stack_uninit");
extern fn void* stack_alloc(MaStack* p_stack, usz sz_) @cname("ma_stack_alloc");
extern fn void stack_free(MaStack* p_stack, void* p) @cname("ma_stack_free");
extern fn MaResult node_read_pcm_frames(MaNode* p_node, uint output_bus_index, float* p_frames_out, uint frame_count, MaUint32* p_frames_read, ulong global_time) @cname("ma_node_read_pcm_frames");
extern fn void debug_fill_pcm_frames_with_sine_wave(float* p_frames_out, uint frame_count, MaFormat format, uint channels, uint sample_rate) @cname("ma_debug_fill_pcm_frames_with_sine_wave");
extern fn void node_graph_set_is_reading(MaNodeGraph* p_node_graph, uint is_reading) @cname("ma_node_graph_set_is_reading");
extern fn void node_graph_node_process_pcm_frames(MaNode* p_node, float** pp_frames_in, MaUint32* p_frame_count_in, float** pp_frames_out, MaUint32* p_frame_count_out) @cname("ma_node_graph_node_process_pcm_frames");
extern fn void node_graph_endpoint_process_pcm_frames(MaNode* p_node, float** pp_frames_in, MaUint32* p_frame_count_in, float** pp_frames_out, MaUint32* p_frame_count_out) @cname("ma_node_graph_endpoint_process_pcm_frames");
extern fn MaResult node_output_bus_init(MaNode* p_node, uint output_bus_index, uint channels, MaNodeOutputBus* p_output_bus) @cname("ma_node_output_bus_init");
extern fn void node_output_bus_lock(MaNodeOutputBus* p_output_bus) @cname("ma_node_output_bus_lock");
extern fn void node_output_bus_unlock(MaNodeOutputBus* p_output_bus) @cname("ma_node_output_bus_unlock");
extern fn MaUint32 node_output_bus_get_channels(MaNodeOutputBus* p_output_bus) @cname("ma_node_output_bus_get_channels");
extern fn void node_output_bus_set_has_read(MaNodeOutputBus* p_output_bus, uint has_read) @cname("ma_node_output_bus_set_has_read");
extern fn MaBool32 node_output_bus_has_read(MaNodeOutputBus* p_output_bus) @cname("ma_node_output_bus_has_read");
extern fn void node_output_bus_set_is_attached(MaNodeOutputBus* p_output_bus, uint is_attached) @cname("ma_node_output_bus_set_is_attached");
extern fn MaBool32 node_output_bus_is_attached(MaNodeOutputBus* p_output_bus) @cname("ma_node_output_bus_is_attached");
extern fn MaResult node_output_bus_set_volume(MaNodeOutputBus* p_output_bus, float volume) @cname("ma_node_output_bus_set_volume");
extern fn float node_output_bus_get_volume(MaNodeOutputBus* p_output_bus) @cname("ma_node_output_bus_get_volume");
extern fn MaResult node_input_bus_init(uint channels, MaNodeInputBus* p_input_bus) @cname("ma_node_input_bus_init");
extern fn void node_input_bus_lock(MaNodeInputBus* p_input_bus) @cname("ma_node_input_bus_lock");
extern fn void node_input_bus_unlock(MaNodeInputBus* p_input_bus) @cname("ma_node_input_bus_unlock");
extern fn void node_input_bus_next_begin(MaNodeInputBus* p_input_bus) @cname("ma_node_input_bus_next_begin");
extern fn void node_input_bus_next_end(MaNodeInputBus* p_input_bus) @cname("ma_node_input_bus_next_end");
extern fn MaUint32 node_input_bus_get_next_counter(MaNodeInputBus* p_input_bus) @cname("ma_node_input_bus_get_next_counter");
extern fn MaUint32 node_input_bus_get_channels(MaNodeInputBus* p_input_bus) @cname("ma_node_input_bus_get_channels");
extern fn void node_input_bus_detach__no_output_bus_lock(MaNodeInputBus* p_input_bus, MaNodeOutputBus* p_output_bus) @cname("ma_node_input_bus_detach__no_output_bus_lock");
extern fn void node_input_bus_attach(MaNodeInputBus* p_input_bus, MaNodeOutputBus* p_output_bus, MaNode* p_new_input_node, uint input_node_input_bus_index) @cname("ma_node_input_bus_attach");
extern fn MaNodeOutputBus* node_input_bus_next(MaNodeInputBus* p_input_bus, MaNodeOutputBus* p_output_bus) @cname("ma_node_input_bus_next");
extern fn MaNodeOutputBus* node_input_bus_first(MaNodeInputBus* p_input_bus) @cname("ma_node_input_bus_first");
extern fn MaResult node_input_bus_read_pcm_frames(MaNode* p_input_node, MaNodeInputBus* p_input_bus, float* p_frames_out, uint frame_count, MaUint32* p_frames_read, ulong global_time) @cname("ma_node_input_bus_read_pcm_frames");
extern fn MaUint16 node_config_get_cache_size_in_frames(MaNodeConfig* p_config, MaNodeGraph* p_node_graph) @cname("ma_node_config_get_cache_size_in_frames");
extern fn MaResult node_detach_full(MaNode* p_node) @cname("ma_node_detach_full");
extern fn float* node_get_cached_input_ptr(MaNode* p_node, uint input_bus_index) @cname("ma_node_get_cached_input_ptr");
extern fn float* node_get_cached_output_ptr(MaNode* p_node, uint output_bus_index) @cname("ma_node_get_cached_output_ptr");
extern fn MaResult node_translate_bus_counts(MaNodeConfig* p_config, MaUint32* p_input_bus_count, MaUint32* p_output_bus_count) @cname("ma_node_translate_bus_counts");
extern fn MaResult node_get_heap_layout(MaNodeGraph* p_node_graph, MaNodeConfig* p_config, MaNodeHeapLayout* p_heap_layout) @cname("ma_node_get_heap_layout");
extern fn void node_process_pcm_frames_internal(MaNode* p_node, float** pp_frames_in, MaUint32* p_frame_count_in, float** pp_frames_out, MaUint32* p_frame_count_out) @cname("ma_node_process_pcm_frames_internal");
extern fn void data_source_node_process_pcm_frames(MaNode* p_node, float** pp_frames_in, MaUint32* p_frame_count_in, float** pp_frames_out, MaUint32* p_frame_count_out) @cname("ma_data_source_node_process_pcm_frames");
extern fn void splitter_node_process_pcm_frames(MaNode* p_node, float** pp_frames_in, MaUint32* p_frame_count_in, float** pp_frames_out, MaUint32* p_frame_count_out) @cname("ma_splitter_node_process_pcm_frames");
extern fn void biquad_node_process_pcm_frames(MaNode* p_node, float** pp_frames_in, MaUint32* p_frame_count_in, float** pp_frames_out, MaUint32* p_frame_count_out) @cname("ma_biquad_node_process_pcm_frames");
extern fn void lpf_node_process_pcm_frames(MaNode* p_node, float** pp_frames_in, MaUint32* p_frame_count_in, float** pp_frames_out, MaUint32* p_frame_count_out) @cname("ma_lpf_node_process_pcm_frames");
extern fn void hpf_node_process_pcm_frames(MaNode* p_node, float** pp_frames_in, MaUint32* p_frame_count_in, float** pp_frames_out, MaUint32* p_frame_count_out) @cname("ma_hpf_node_process_pcm_frames");
extern fn void bpf_node_process_pcm_frames(MaNode* p_node, float** pp_frames_in, MaUint32* p_frame_count_in, float** pp_frames_out, MaUint32* p_frame_count_out) @cname("ma_bpf_node_process_pcm_frames");
extern fn void notch_node_process_pcm_frames(MaNode* p_node, float** pp_frames_in, MaUint32* p_frame_count_in, float** pp_frames_out, MaUint32* p_frame_count_out) @cname("ma_notch_node_process_pcm_frames");
extern fn void peak_node_process_pcm_frames(MaNode* p_node, float** pp_frames_in, MaUint32* p_frame_count_in, float** pp_frames_out, MaUint32* p_frame_count_out) @cname("ma_peak_node_process_pcm_frames");
extern fn void loshelf_node_process_pcm_frames(MaNode* p_node, float** pp_frames_in, MaUint32* p_frame_count_in, float** pp_frames_out, MaUint32* p_frame_count_out) @cname("ma_loshelf_node_process_pcm_frames");
extern fn void hishelf_node_process_pcm_frames(MaNode* p_node, float** pp_frames_in, MaUint32* p_frame_count_in, float** pp_frames_out, MaUint32* p_frame_count_out) @cname("ma_hishelf_node_process_pcm_frames");
extern fn void delay_node_process_pcm_frames(MaNode* p_node, float** pp_frames_in, MaUint32* p_frame_count_in, float** pp_frames_out, MaUint32* p_frame_count_out) @cname("ma_delay_node_process_pcm_frames");
extern fn void sound_set_at_end(MaSound* p_sound, uint at_end) @cname("ma_sound_set_at_end");
extern fn MaBool32 sound_get_at_end(MaSound* p_sound) @cname("ma_sound_get_at_end");
extern fn void engine_node_update_pitch_if_required(MaEngineNode* p_engine_node) @cname("ma_engine_node_update_pitch_if_required");
extern fn MaBool32 engine_node_is_pitching_enabled(MaEngineNode* p_engine_node) @cname("ma_engine_node_is_pitching_enabled");
extern fn MaBool32 engine_node_is_spatialization_enabled(MaEngineNode* p_engine_node) @cname("ma_engine_node_is_spatialization_enabled");
extern fn MaResult engine_node_set_volume(MaEngineNode* p_engine_node, float volume) @cname("ma_engine_node_set_volume");
extern fn MaResult engine_node_get_volume(MaEngineNode* p_engine_node, float* p_volume) @cname("ma_engine_node_get_volume");
extern fn void engine_node_process_pcm_frames__general(MaEngineNode* p_engine_node, float** pp_frames_in, MaUint32* p_frame_count_in, float** pp_frames_out, MaUint32* p_frame_count_out) @cname("ma_engine_node_process_pcm_frames__general");
extern fn void engine_node_process_pcm_frames__sound(MaNode* p_node, float** pp_frames_in, MaUint32* p_frame_count_in, float** pp_frames_out, MaUint32* p_frame_count_out) @cname("ma_engine_node_process_pcm_frames__sound");
extern fn void engine_node_process_pcm_frames__group(MaNode* p_node, float** pp_frames_in, MaUint32* p_frame_count_in, float** pp_frames_out, MaUint32* p_frame_count_out) @cname("ma_engine_node_process_pcm_frames__group");
extern fn MaNodeConfig engine_node_base_node_config_init(MaEngineNodeConfig* p_config) @cname("ma_engine_node_base_node_config_init");
extern fn MaSpatializerConfig engine_node_spatializer_config_init(MaNodeConfig* p_base_node_config) @cname("ma_engine_node_spatializer_config_init");
extern fn MaResult engine_node_get_heap_layout(MaEngineNodeConfig* p_config, MaEngineNodeHeapLayout* p_heap_layout) @cname("ma_engine_node_get_heap_layout");
extern fn void engine_data_callback_internal(MaDevice* p_device, void* p_frames_out, void* p_frames_in, uint frame_count) @cname("ma_engine_data_callback_internal");
extern fn MaUint32 device__get_processing_size_in_frames(MaDevice* p_device) @cname("ma_device__get_processing_size_in_frames");
extern fn MaResult sound_preinit(MaEngine* p_engine, MaSound* p_sound) @cname("ma_sound_preinit");
extern fn MaResult sound_init_from_data_source_internal(MaEngine* p_engine, MaSoundConfig* p_config, MaSound* p_sound) @cname("ma_sound_init_from_data_source_internal");
extern fn MaResult sound_init_from_file_internal(MaEngine* p_engine, MaSoundConfig* p_config, MaSound* p_sound) @cname("ma_sound_init_from_file_internal");
extern fn int dr_wav__is_little_endian() @cname("ma_dr_wav__is_little_endian");
extern fn void dr_wav_bytes_to_guid(MaUint8* data, MaUint8* guid) @cname("ma_dr_wav_bytes_to_guid");
extern fn MaUint16 dr_wav__bswap16(ushort n) @cname("ma_dr_wav__bswap16");
extern fn MaUint32 dr_wav__bswap32(uint n) @cname("ma_dr_wav__bswap32");
extern fn MaUint64 dr_wav__bswap64(ulong n) @cname("ma_dr_wav__bswap64");
extern fn MaInt16 dr_wav__bswap_s16(short n) @cname("ma_dr_wav__bswap_s16");
extern fn void dr_wav__bswap_samples_s16(MaInt16* p_samples, ulong sample_count) @cname("ma_dr_wav__bswap_samples_s16");
extern fn void dr_wav__bswap_s24(MaUint8* p) @cname("ma_dr_wav__bswap_s24");
extern fn void dr_wav__bswap_samples_s24(MaUint8* p_samples, ulong sample_count) @cname("ma_dr_wav__bswap_samples_s24");
extern fn MaInt32 dr_wav__bswap_s32(int n) @cname("ma_dr_wav__bswap_s32");
extern fn void dr_wav__bswap_samples_s32(MaInt32* p_samples, ulong sample_count) @cname("ma_dr_wav__bswap_samples_s32");
extern fn MaInt64 dr_wav__bswap_s64(long n) @cname("ma_dr_wav__bswap_s64");
extern fn void dr_wav__bswap_samples_s64(MaInt64* p_samples, ulong sample_count) @cname("ma_dr_wav__bswap_samples_s64");
extern fn float dr_wav__bswap_f32(float n) @cname("ma_dr_wav__bswap_f32");
extern fn void dr_wav__bswap_samples_f32(float* p_samples, ulong sample_count) @cname("ma_dr_wav__bswap_samples_f32");
extern fn void dr_wav__bswap_samples(void* p_samples, ulong sample_count, uint bytes_per_sample) @cname("ma_dr_wav__bswap_samples");
extern fn MaBool32 dr_wav_is_container_be(MaDrWavContainer container) @cname("ma_dr_wav_is_container_be");
extern fn MaUint16 dr_wav_bytes_to_u16_le(MaUint8* data) @cname("ma_dr_wav_bytes_to_u16_le");
extern fn MaUint16 dr_wav_bytes_to_u16_be(MaUint8* data) @cname("ma_dr_wav_bytes_to_u16_be");
extern fn MaUint16 dr_wav_bytes_to_u16_ex(MaUint8* data, MaDrWavContainer container) @cname("ma_dr_wav_bytes_to_u16_ex");
extern fn MaUint32 dr_wav_bytes_to_u32_le(MaUint8* data) @cname("ma_dr_wav_bytes_to_u32_le");
extern fn MaUint32 dr_wav_bytes_to_u32_be(MaUint8* data) @cname("ma_dr_wav_bytes_to_u32_be");
extern fn MaUint32 dr_wav_bytes_to_u32_ex(MaUint8* data, MaDrWavContainer container) @cname("ma_dr_wav_bytes_to_u32_ex");
extern fn MaInt64 dr_wav_aiff_extented_to_s64(MaUint8* data) @cname("ma_dr_wav_aiff_extented_to_s64");
extern fn void* dr_wav__malloc_default(usz sz_, void* p_user_data) @cname("ma_dr_wav__malloc_default");
extern fn void* dr_wav__realloc_default(void* p, usz sz_, void* p_user_data) @cname("ma_dr_wav__realloc_default");
extern fn void dr_wav__free_default(void* p, void* p_user_data) @cname("ma_dr_wav__free_default");
extern fn void* dr_wav__malloc_from_callbacks(usz sz_, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_wav__malloc_from_callbacks");
extern fn void* dr_wav__realloc_from_callbacks(void* p, usz sz_new, usz sz_old, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_wav__realloc_from_callbacks");
extern fn void dr_wav__free_from_callbacks(void* p, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_wav__free_from_callbacks");
extern fn MaAllocationCallbacks dr_wav_copy_allocation_callbacks_or_defaults(MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_wav_copy_allocation_callbacks_or_defaults");
extern fn MaBool32 dr_wav__is_compressed_format_tag(ushort format_tag) @cname("ma_dr_wav__is_compressed_format_tag");
extern fn uint dr_wav__chunk_padding_size_riff(ulong chunk_size) @cname("ma_dr_wav__chunk_padding_size_riff");
extern fn uint dr_wav__chunk_padding_size_w64(ulong chunk_size) @cname("ma_dr_wav__chunk_padding_size_w64");
extern fn MaUint64 dr_wav_read_pcm_frames_s16__msadpcm(MaDrWav* p_wav, ulong samples_to_read, MaInt16* p_buffer_out) @cname("ma_dr_wav_read_pcm_frames_s16__msadpcm");
extern fn MaUint64 dr_wav_read_pcm_frames_s16__ima(MaDrWav* p_wav, ulong samples_to_read, MaInt16* p_buffer_out) @cname("ma_dr_wav_read_pcm_frames_s16__ima");
extern fn MaBool32 dr_wav_init_write__internal(MaDrWav* p_wav, MaDrWavDataFormat* p_format, ulong total_sample_count) @cname("ma_dr_wav_init_write__internal");
extern fn MaResult dr_wav__read_chunk_header(MaDrWavReadProc on_read, void* p_user_data, MaDrWavContainer container, MaUint64* p_running_bytes_read_out, MaDrWavChunkHeader* p_header_out) @cname("ma_dr_wav__read_chunk_header");
extern fn MaBool32 dr_wav__seek_forward(MaDrWavSeekProc on_seek, ulong offset, void* p_user_data) @cname("ma_dr_wav__seek_forward");
extern fn MaBool32 dr_wav__seek_from_start(MaDrWavSeekProc on_seek, ulong offset, void* p_user_data) @cname("ma_dr_wav__seek_from_start");
extern fn usz dr_wav__on_read(MaDrWavReadProc on_read, void* p_user_data, void* p_buffer_out, usz bytes_to_read, MaUint64* p_cursor) @cname("ma_dr_wav__on_read");
extern fn usz dr_wav__metadata_memory_capacity(MaDrWavMetadataParser* p_parser) @cname("ma_dr_wav__metadata_memory_capacity");
extern fn MaUint8* dr_wav__metadata_get_memory(MaDrWavMetadataParser* p_parser, usz size, usz align) @cname("ma_dr_wav__metadata_get_memory");
extern fn void dr_wav__metadata_request_extra_memory_for_stage_2(MaDrWavMetadataParser* p_parser, usz bytes, usz align) @cname("ma_dr_wav__metadata_request_extra_memory_for_stage_2");
extern fn MaResult dr_wav__metadata_alloc(MaDrWavMetadataParser* p_parser, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_wav__metadata_alloc");
extern fn usz dr_wav__metadata_parser_read(MaDrWavMetadataParser* p_parser, void* p_buffer_out, usz bytes_to_read, MaUint64* p_cursor) @cname("ma_dr_wav__metadata_parser_read");
extern fn MaUint64 dr_wav__read_smpl_to_metadata_obj(MaDrWavMetadataParser* p_parser, MaDrWavChunkHeader* p_chunk_header, MaDrWavMetadata* p_metadata) @cname("ma_dr_wav__read_smpl_to_metadata_obj");
extern fn MaUint64 dr_wav__read_cue_to_metadata_obj(MaDrWavMetadataParser* p_parser, MaDrWavChunkHeader* p_chunk_header, MaDrWavMetadata* p_metadata) @cname("ma_dr_wav__read_cue_to_metadata_obj");
extern fn MaUint64 dr_wav__read_inst_to_metadata_obj(MaDrWavMetadataParser* p_parser, MaDrWavMetadata* p_metadata) @cname("ma_dr_wav__read_inst_to_metadata_obj");
extern fn MaUint64 dr_wav__read_acid_to_metadata_obj(MaDrWavMetadataParser* p_parser, MaDrWavMetadata* p_metadata) @cname("ma_dr_wav__read_acid_to_metadata_obj");
extern fn usz dr_wav__strlen(ZString str) @cname("ma_dr_wav__strlen");
extern fn usz dr_wav__strlen_clamped(ZString str, usz max_to_read) @cname("ma_dr_wav__strlen_clamped");
extern fn char* dr_wav__metadata_copy_string(MaDrWavMetadataParser* p_parser, ZString str, usz max_to_read) @cname("ma_dr_wav__metadata_copy_string");
extern fn MaResult dr_wav_buffer_reader_init(void* p_buffer, usz size_in_bytes, MaDrWavBufferReader* p_reader) @cname("ma_dr_wav_buffer_reader_init");
extern fn void* dr_wav_buffer_reader_ptr(MaDrWavBufferReader* p_reader) @cname("ma_dr_wav_buffer_reader_ptr");
extern fn MaResult dr_wav_buffer_reader_seek(MaDrWavBufferReader* p_reader, usz bytes_to_seek) @cname("ma_dr_wav_buffer_reader_seek");
extern fn MaResult dr_wav_buffer_reader_read(MaDrWavBufferReader* p_reader, void* p_dst, usz bytes_to_read, usz* p_bytes_read) @cname("ma_dr_wav_buffer_reader_read");
extern fn MaResult dr_wav_buffer_reader_read_u16(MaDrWavBufferReader* p_reader, MaUint16* p_dst) @cname("ma_dr_wav_buffer_reader_read_u16");
extern fn MaResult dr_wav_buffer_reader_read_u32(MaDrWavBufferReader* p_reader, MaUint32* p_dst) @cname("ma_dr_wav_buffer_reader_read_u32");
extern fn MaUint64 dr_wav__read_bext_to_metadata_obj(MaDrWavMetadataParser* p_parser, MaDrWavMetadata* p_metadata, ulong chunk_size) @cname("ma_dr_wav__read_bext_to_metadata_obj");
extern fn MaUint64 dr_wav__read_list_label_or_note_to_metadata_obj(MaDrWavMetadataParser* p_parser, MaDrWavMetadata* p_metadata, ulong chunk_size, MaDrWavMetadataType type) @cname("ma_dr_wav__read_list_label_or_note_to_metadata_obj");
extern fn MaUint64 dr_wav__read_list_labelled_cue_region_to_metadata_obj(MaDrWavMetadataParser* p_parser, MaDrWavMetadata* p_metadata, ulong chunk_size) @cname("ma_dr_wav__read_list_labelled_cue_region_to_metadata_obj");
extern fn MaUint64 dr_wav__metadata_process_info_text_chunk(MaDrWavMetadataParser* p_parser, ulong chunk_size, MaDrWavMetadataType type) @cname("ma_dr_wav__metadata_process_info_text_chunk");
extern fn MaUint64 dr_wav__metadata_process_unknown_chunk(MaDrWavMetadataParser* p_parser, MaUint8* p_chunk_id, ulong chunk_size, MaDrWavMetadataLocation location) @cname("ma_dr_wav__metadata_process_unknown_chunk");
extern fn MaBool32 dr_wav__chunk_matches(MaDrWavMetadataType allowed_metadata_types, MaUint8* p_chunk_id, MaDrWavMetadataType type, ZString p_id) @cname("ma_dr_wav__chunk_matches");
extern fn MaUint64 dr_wav__metadata_process_chunk(MaDrWavMetadataParser* p_parser, MaDrWavChunkHeader* p_chunk_header, MaDrWavMetadataType allowed_metadata_types) @cname("ma_dr_wav__metadata_process_chunk");
extern fn MaUint32 dr_wav_get_bytes_per_pcm_frame(MaDrWav* p_wav) @cname("ma_dr_wav_get_bytes_per_pcm_frame");
extern fn MaBool32 dr_wav_preinit(MaDrWav* p_wav, MaDrWavReadProc on_read, MaDrWavSeekProc on_seek, MaDrWavTellProc on_tell, void* p_read_seek_tell_user_data, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_wav_preinit");
extern fn MaBool32 dr_wav_init__internal(MaDrWav* p_wav, MaDrWavChunkProc on_chunk, void* p_chunk_user_data, uint flags) @cname("ma_dr_wav_init__internal");
extern fn usz dr_wav__write(MaDrWav* p_wav, void* p_data, usz data_size) @cname("ma_dr_wav__write");
extern fn usz dr_wav__write_byte(MaDrWav* p_wav, char byte) @cname("ma_dr_wav__write_byte");
extern fn usz dr_wav__write_u16ne_to_le(MaDrWav* p_wav, ushort value) @cname("ma_dr_wav__write_u16ne_to_le");
extern fn usz dr_wav__write_u32ne_to_le(MaDrWav* p_wav, uint value) @cname("ma_dr_wav__write_u32ne_to_le");
extern fn usz dr_wav__write_u64ne_to_le(MaDrWav* p_wav, ulong value) @cname("ma_dr_wav__write_u64ne_to_le");
extern fn usz dr_wav__write_f32ne_to_le(MaDrWav* p_wav, float value) @cname("ma_dr_wav__write_f32ne_to_le");
extern fn usz dr_wav__write_or_count(MaDrWav* p_wav, void* p_data, usz data_size) @cname("ma_dr_wav__write_or_count");
extern fn usz dr_wav__write_or_count_byte(MaDrWav* p_wav, char byte) @cname("ma_dr_wav__write_or_count_byte");
extern fn usz dr_wav__write_or_count_u16ne_to_le(MaDrWav* p_wav, ushort value) @cname("ma_dr_wav__write_or_count_u16ne_to_le");
extern fn usz dr_wav__write_or_count_u32ne_to_le(MaDrWav* p_wav, uint value) @cname("ma_dr_wav__write_or_count_u32ne_to_le");
extern fn usz dr_wav__write_or_count_f32ne_to_le(MaDrWav* p_wav, float value) @cname("ma_dr_wav__write_or_count_f32ne_to_le");
extern fn usz dr_wav__write_or_count_string_to_fixed_size_buf(MaDrWav* p_wav, char* str, usz buf_fixed_size) @cname("ma_dr_wav__write_or_count_string_to_fixed_size_buf");
extern fn usz dr_wav__write_or_count_metadata(MaDrWav* p_wav, MaDrWavMetadata* p_metadatas, uint metadata_count) @cname("ma_dr_wav__write_or_count_metadata");
extern fn MaUint32 dr_wav__riff_chunk_size_riff(ulong data_chunk_size, MaDrWavMetadata* p_metadata, uint metadata_count) @cname("ma_dr_wav__riff_chunk_size_riff");
extern fn MaUint32 dr_wav__data_chunk_size_riff(ulong data_chunk_size) @cname("ma_dr_wav__data_chunk_size_riff");
extern fn MaUint64 dr_wav__riff_chunk_size_w64(ulong data_chunk_size) @cname("ma_dr_wav__riff_chunk_size_w64");
extern fn MaUint64 dr_wav__data_chunk_size_w64(ulong data_chunk_size) @cname("ma_dr_wav__data_chunk_size_w64");
extern fn MaUint64 dr_wav__riff_chunk_size_rf64(ulong data_chunk_size, MaDrWavMetadata* metadata, uint num_metadata) @cname("ma_dr_wav__riff_chunk_size_rf64");
extern fn MaUint64 dr_wav__data_chunk_size_rf64(ulong data_chunk_size) @cname("ma_dr_wav__data_chunk_size_rf64");
extern fn MaBool32 dr_wav_preinit_write(MaDrWav* p_wav, MaDrWavDataFormat* p_format, uint is_sequential, MaDrWavWriteProc on_write, MaDrWavSeekProc on_seek, void* p_user_data, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_wav_preinit_write");
extern fn usz dr_wav__on_read_stdio(void* p_user_data, void* p_buffer_out, usz bytes_to_read) @cname("ma_dr_wav__on_read_stdio");
extern fn usz dr_wav__on_write_stdio(void* p_user_data, void* p_data, usz bytes_to_write) @cname("ma_dr_wav__on_write_stdio");
extern fn MaBool32 dr_wav__on_seek_stdio(void* p_user_data, int offset, MaDrWavSeekOrigin origin) @cname("ma_dr_wav__on_seek_stdio");
extern fn MaBool32 dr_wav__on_tell_stdio(void* p_user_data, MaInt64* p_cursor) @cname("ma_dr_wav__on_tell_stdio");
extern fn MaBool32 dr_wav_init_file__internal_file(MaDrWav* p_wav, File* p_file, MaDrWavChunkProc on_chunk, void* p_chunk_user_data, uint flags, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_wav_init_file__internal_FILE");
extern fn MaBool32 dr_wav_init_file_write__internal_file(MaDrWav* p_wav, File* p_file, MaDrWavDataFormat* p_format, ulong total_sample_count, uint is_sequential, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_wav_init_file_write__internal_FILE");
extern fn MaBool32 dr_wav_init_file_write__internal(MaDrWav* p_wav, ZString filename, MaDrWavDataFormat* p_format, ulong total_sample_count, uint is_sequential, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_wav_init_file_write__internal");
extern fn MaBool32 dr_wav_init_file_write_w__internal(MaDrWav* p_wav, WcharT* filename, MaDrWavDataFormat* p_format, ulong total_sample_count, uint is_sequential, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_wav_init_file_write_w__internal");
extern fn usz dr_wav__on_read_memory(void* p_user_data, void* p_buffer_out, usz bytes_to_read) @cname("ma_dr_wav__on_read_memory");
extern fn MaBool32 dr_wav__on_seek_memory(void* p_user_data, int offset, MaDrWavSeekOrigin origin) @cname("ma_dr_wav__on_seek_memory");
extern fn usz dr_wav__on_write_memory(void* p_user_data, void* p_data_in, usz bytes_to_write) @cname("ma_dr_wav__on_write_memory");
extern fn MaBool32 dr_wav__on_seek_memory_write(void* p_user_data, int offset, MaDrWavSeekOrigin origin) @cname("ma_dr_wav__on_seek_memory_write");
extern fn MaBool32 dr_wav__on_tell_memory(void* p_user_data, MaInt64* p_cursor) @cname("ma_dr_wav__on_tell_memory");
extern fn MaBool32 dr_wav_init_memory_write__internal(MaDrWav* p_wav, void** pp_data, usz* p_data_size, MaDrWavDataFormat* p_format, ulong total_sample_count, uint is_sequential, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_wav_init_memory_write__internal");
extern fn MaBool32 dr_wav_seek_to_first_pcm_frame(MaDrWav* p_wav) @cname("ma_dr_wav_seek_to_first_pcm_frame");
extern fn MaInt16 dr_wav__alaw_to_s16(char sample_in) @cname("ma_dr_wav__alaw_to_s16");
extern fn MaInt16 dr_wav__mulaw_to_s16(char sample_in) @cname("ma_dr_wav__mulaw_to_s16");
extern fn void dr_wav__pcm_to_s16(MaInt16* p_out, MaUint8* p_in, usz total_sample_count, uint bytes_per_sample) @cname("ma_dr_wav__pcm_to_s16");
extern fn void dr_wav__ieee_to_s16(MaInt16* p_out, MaUint8* p_in, usz total_sample_count, uint bytes_per_sample) @cname("ma_dr_wav__ieee_to_s16");
extern fn MaUint64 dr_wav_read_pcm_frames_s16__pcm(MaDrWav* p_wav, ulong frames_to_read, MaInt16* p_buffer_out) @cname("ma_dr_wav_read_pcm_frames_s16__pcm");
extern fn MaUint64 dr_wav_read_pcm_frames_s16__ieee(MaDrWav* p_wav, ulong frames_to_read, MaInt16* p_buffer_out) @cname("ma_dr_wav_read_pcm_frames_s16__ieee");
extern fn MaUint64 dr_wav_read_pcm_frames_s16__alaw(MaDrWav* p_wav, ulong frames_to_read, MaInt16* p_buffer_out) @cname("ma_dr_wav_read_pcm_frames_s16__alaw");
extern fn MaUint64 dr_wav_read_pcm_frames_s16__mulaw(MaDrWav* p_wav, ulong frames_to_read, MaInt16* p_buffer_out) @cname("ma_dr_wav_read_pcm_frames_s16__mulaw");
extern fn void dr_wav__pcm_to_f32(float* p_out, MaUint8* p_in, usz sample_count, uint bytes_per_sample) @cname("ma_dr_wav__pcm_to_f32");
extern fn void dr_wav__ieee_to_f32(float* p_out, MaUint8* p_in, usz sample_count, uint bytes_per_sample) @cname("ma_dr_wav__ieee_to_f32");
extern fn MaUint64 dr_wav_read_pcm_frames_f32__pcm(MaDrWav* p_wav, ulong frames_to_read, float* p_buffer_out) @cname("ma_dr_wav_read_pcm_frames_f32__pcm");
extern fn MaUint64 dr_wav_read_pcm_frames_f32__msadpcm_ima(MaDrWav* p_wav, ulong frames_to_read, float* p_buffer_out) @cname("ma_dr_wav_read_pcm_frames_f32__msadpcm_ima");
extern fn MaUint64 dr_wav_read_pcm_frames_f32__ieee(MaDrWav* p_wav, ulong frames_to_read, float* p_buffer_out) @cname("ma_dr_wav_read_pcm_frames_f32__ieee");
extern fn MaUint64 dr_wav_read_pcm_frames_f32__alaw(MaDrWav* p_wav, ulong frames_to_read, float* p_buffer_out) @cname("ma_dr_wav_read_pcm_frames_f32__alaw");
extern fn MaUint64 dr_wav_read_pcm_frames_f32__mulaw(MaDrWav* p_wav, ulong frames_to_read, float* p_buffer_out) @cname("ma_dr_wav_read_pcm_frames_f32__mulaw");
extern fn void dr_wav__pcm_to_s32(MaInt32* p_out, MaUint8* p_in, usz total_sample_count, uint bytes_per_sample) @cname("ma_dr_wav__pcm_to_s32");
extern fn void dr_wav__ieee_to_s32(MaInt32* p_out, MaUint8* p_in, usz total_sample_count, uint bytes_per_sample) @cname("ma_dr_wav__ieee_to_s32");
extern fn MaUint64 dr_wav_read_pcm_frames_s32__pcm(MaDrWav* p_wav, ulong frames_to_read, MaInt32* p_buffer_out) @cname("ma_dr_wav_read_pcm_frames_s32__pcm");
extern fn MaUint64 dr_wav_read_pcm_frames_s32__msadpcm_ima(MaDrWav* p_wav, ulong frames_to_read, MaInt32* p_buffer_out) @cname("ma_dr_wav_read_pcm_frames_s32__msadpcm_ima");
extern fn MaUint64 dr_wav_read_pcm_frames_s32__ieee(MaDrWav* p_wav, ulong frames_to_read, MaInt32* p_buffer_out) @cname("ma_dr_wav_read_pcm_frames_s32__ieee");
extern fn MaUint64 dr_wav_read_pcm_frames_s32__alaw(MaDrWav* p_wav, ulong frames_to_read, MaInt32* p_buffer_out) @cname("ma_dr_wav_read_pcm_frames_s32__alaw");
extern fn MaUint64 dr_wav_read_pcm_frames_s32__mulaw(MaDrWav* p_wav, ulong frames_to_read, MaInt32* p_buffer_out) @cname("ma_dr_wav_read_pcm_frames_s32__mulaw");
extern fn MaInt16* dr_wav__read_pcm_frames_and_close_s16(MaDrWav* p_wav, uint* channels, uint* sample_rate, MaUint64* total_frame_count) @cname("ma_dr_wav__read_pcm_frames_and_close_s16");
extern fn float* dr_wav__read_pcm_frames_and_close_f32(MaDrWav* p_wav, uint* channels, uint* sample_rate, MaUint64* total_frame_count) @cname("ma_dr_wav__read_pcm_frames_and_close_f32");
extern fn MaInt32* dr_wav__read_pcm_frames_and_close_s32(MaDrWav* p_wav, uint* channels, uint* sample_rate, MaUint64* total_frame_count) @cname("ma_dr_wav__read_pcm_frames_and_close_s32");
extern fn void dr_flac__cpuid(int* info, int fid) @cname("ma_dr_flac__cpuid");
extern fn MaBool32 dr_flac_has_sse2() @cname("ma_dr_flac_has_sse2");
extern fn MaBool32 dr_flac_has_sse41() @cname("ma_dr_flac_has_sse41");
extern fn void dr_flac__init_cpu_caps() @cname("ma_dr_flac__init_cpu_caps");
extern fn MaBool32 dr_flac__is_little_endian() @cname("ma_dr_flac__is_little_endian");
extern fn MaUint16 dr_flac__swap_endian_uint16(ushort n) @cname("ma_dr_flac__swap_endian_uint16");
extern fn MaUint32 dr_flac__swap_endian_uint32(uint n) @cname("ma_dr_flac__swap_endian_uint32");
extern fn MaUint64 dr_flac__swap_endian_uint64(ulong n) @cname("ma_dr_flac__swap_endian_uint64");
extern fn MaUint16 dr_flac__be2host_16(ushort n) @cname("ma_dr_flac__be2host_16");
extern fn MaUint32 dr_flac__be2host_32(uint n) @cname("ma_dr_flac__be2host_32");
extern fn MaUint32 dr_flac__be2host_32_ptr_unaligned(void* p_data) @cname("ma_dr_flac__be2host_32_ptr_unaligned");
extern fn MaUint64 dr_flac__be2host_64(ulong n) @cname("ma_dr_flac__be2host_64");
extern fn MaUint32 dr_flac__le2host_32(uint n) @cname("ma_dr_flac__le2host_32");
extern fn MaUint32 dr_flac__le2host_32_ptr_unaligned(void* p_data) @cname("ma_dr_flac__le2host_32_ptr_unaligned");
extern fn MaUint32 dr_flac__unsynchsafe_32(uint n) @cname("ma_dr_flac__unsynchsafe_32");
extern fn MaUint8 dr_flac_crc8_byte(char crc, char data) @cname("ma_dr_flac_crc8_byte");
extern fn MaUint8 dr_flac_crc8(char crc, uint data, uint count) @cname("ma_dr_flac_crc8");
extern fn MaUint16 dr_flac_crc16_byte(ushort crc, char data) @cname("ma_dr_flac_crc16_byte");
extern fn MaUint16 dr_flac_crc16_cache(ushort crc, ulong data) @cname("ma_dr_flac_crc16_cache");
extern fn MaUint16 dr_flac_crc16_bytes(ushort crc, ulong data, uint byte_count) @cname("ma_dr_flac_crc16_bytes");
extern fn void dr_flac__reset_crc16(MaDrFlacBs* bs) @cname("ma_dr_flac__reset_crc16");
extern fn void dr_flac__update_crc16(MaDrFlacBs* bs) @cname("ma_dr_flac__update_crc16");
extern fn MaUint16 dr_flac__flush_crc16(MaDrFlacBs* bs) @cname("ma_dr_flac__flush_crc16");
extern fn MaBool32 dr_flac__reload_l1_cache_from_l2(MaDrFlacBs* bs) @cname("ma_dr_flac__reload_l1_cache_from_l2");
extern fn MaBool32 dr_flac__reload_cache(MaDrFlacBs* bs) @cname("ma_dr_flac__reload_cache");
extern fn void dr_flac__reset_cache(MaDrFlacBs* bs) @cname("ma_dr_flac__reset_cache");
extern fn MaBool32 dr_flac__read_uint32(MaDrFlacBs* bs, uint bit_count, MaUint32* p_result_out) @cname("ma_dr_flac__read_uint32");
extern fn MaBool32 dr_flac__read_int32(MaDrFlacBs* bs, uint bit_count, MaInt32* p_result) @cname("ma_dr_flac__read_int32");
extern fn MaBool32 dr_flac__read_uint64(MaDrFlacBs* bs, uint bit_count, MaUint64* p_result_out) @cname("ma_dr_flac__read_uint64");
extern fn MaBool32 dr_flac__read_uint16(MaDrFlacBs* bs, uint bit_count, MaUint16* p_result) @cname("ma_dr_flac__read_uint16");
extern fn MaBool32 dr_flac__read_uint8(MaDrFlacBs* bs, uint bit_count, MaUint8* p_result) @cname("ma_dr_flac__read_uint8");
extern fn MaBool32 dr_flac__read_int8(MaDrFlacBs* bs, uint bit_count, MaInt8* p_result) @cname("ma_dr_flac__read_int8");
extern fn MaBool32 dr_flac__seek_bits(MaDrFlacBs* bs, usz bits_to_seek) @cname("ma_dr_flac__seek_bits");
extern fn MaBool32 dr_flac__find_and_seek_to_next_sync_code(MaDrFlacBs* bs) @cname("ma_dr_flac__find_and_seek_to_next_sync_code");
extern fn MaUint32 dr_flac__clz_software(ulong x) @cname("ma_dr_flac__clz_software");
extern fn MaBool32 dr_flac__is_lzcnt_supported() @cname("ma_dr_flac__is_lzcnt_supported");
extern fn MaUint32 dr_flac__clz_lzcnt(ulong x) @cname("ma_dr_flac__clz_lzcnt");
extern fn MaUint32 dr_flac__clz(ulong x) @cname("ma_dr_flac__clz");
extern fn MaBool32 dr_flac__seek_past_next_set_bit(MaDrFlacBs* bs, uint* p_offset_out) @cname("ma_dr_flac__seek_past_next_set_bit");
extern fn MaBool32 dr_flac__seek_to_byte(MaDrFlacBs* bs, ulong offset_from_start) @cname("ma_dr_flac__seek_to_byte");
extern fn MaResult dr_flac__read_utf8_coded_number(MaDrFlacBs* bs, MaUint64* p_number_out, MaUint8* p_crc_out) @cname("ma_dr_flac__read_utf8_coded_number");
extern fn MaUint32 dr_flac__ilog2_u32(uint x) @cname("ma_dr_flac__ilog2_u32");
extern fn MaBool32 dr_flac__use_64_bit_prediction(uint bits_per_sample, uint order, uint precision) @cname("ma_dr_flac__use_64_bit_prediction");
extern fn MaInt32 dr_flac__calculate_prediction_32(uint order, int shift, MaInt32* coefficients, MaInt32* p_decoded_samples) @cname("ma_dr_flac__calculate_prediction_32");
extern fn MaInt32 dr_flac__calculate_prediction_64(uint order, int shift, MaInt32* coefficients, MaInt32* p_decoded_samples) @cname("ma_dr_flac__calculate_prediction_64");
extern fn MaBool32 dr_flac__read_rice_parts_x1(MaDrFlacBs* bs, char rice_param, MaUint32* p_zero_counter_out, MaUint32* p_rice_param_part_out) @cname("ma_dr_flac__read_rice_parts_x1");
extern fn MaBool32 dr_flac__seek_rice_parts(MaDrFlacBs* bs, char rice_param) @cname("ma_dr_flac__seek_rice_parts");
extern fn MaBool32 dr_flac__decode_samples_with_residual__rice__scalar_zeroorder(MaDrFlacBs* bs, uint bits_per_sample, uint count, char rice_param, uint order, int shift, MaInt32* coefficients, MaInt32* p_samples_out) @cname("ma_dr_flac__decode_samples_with_residual__rice__scalar_zeroorder");
extern fn MaBool32 dr_flac__decode_samples_with_residual__rice__scalar(MaDrFlacBs* bs, uint bits_per_sample, uint count, char rice_param, uint lpc_order, int lpc_shift, uint lpc_precision, MaInt32* coefficients, MaInt32* p_samples_out) @cname("ma_dr_flac__decode_samples_with_residual__rice__scalar");
extern fn M128i dr_flac__mm_packs_interleaved_epi32(long a, long b) @cname("ma_dr_flac__mm_packs_interleaved_epi32");
extern fn MaBool32 dr_flac__decode_samples_with_residual__rice(MaDrFlacBs* bs, uint bits_per_sample, uint count, char rice_param, uint lpc_order, int lpc_shift, uint lpc_precision, MaInt32* coefficients, MaInt32* p_samples_out) @cname("ma_dr_flac__decode_samples_with_residual__rice");
extern fn MaBool32 dr_flac__read_and_seek_residual__rice(MaDrFlacBs* bs, uint count, char rice_param) @cname("ma_dr_flac__read_and_seek_residual__rice");
extern fn MaBool32 dr_flac__decode_samples_with_residual__unencoded(MaDrFlacBs* bs, uint bits_per_sample, uint count, char unencoded_bits_per_sample, uint lpc_order, int lpc_shift, uint lpc_precision, MaInt32* coefficients, MaInt32* p_samples_out) @cname("ma_dr_flac__decode_samples_with_residual__unencoded");
extern fn MaBool32 dr_flac__decode_samples_with_residual(MaDrFlacBs* bs, uint bits_per_sample, uint block_size, uint lpc_order, int lpc_shift, uint lpc_precision, MaInt32* coefficients, MaInt32* p_decoded_samples) @cname("ma_dr_flac__decode_samples_with_residual");
extern fn MaBool32 dr_flac__read_and_seek_residual(MaDrFlacBs* bs, uint block_size, uint order) @cname("ma_dr_flac__read_and_seek_residual");
extern fn MaBool32 dr_flac__decode_samples__constant(MaDrFlacBs* bs, uint block_size, uint subframe_bits_per_sample, MaInt32* p_decoded_samples) @cname("ma_dr_flac__decode_samples__constant");
extern fn MaBool32 dr_flac__decode_samples__verbatim(MaDrFlacBs* bs, uint block_size, uint subframe_bits_per_sample, MaInt32* p_decoded_samples) @cname("ma_dr_flac__decode_samples__verbatim");
extern fn MaBool32 dr_flac__decode_samples__fixed(MaDrFlacBs* bs, uint block_size, uint subframe_bits_per_sample, char lpc_order, MaInt32* p_decoded_samples) @cname("ma_dr_flac__decode_samples__fixed");
extern fn MaBool32 dr_flac__decode_samples__lpc(MaDrFlacBs* bs, uint block_size, uint bits_per_sample, char lpc_order, MaInt32* p_decoded_samples) @cname("ma_dr_flac__decode_samples__lpc");
extern fn MaBool32 dr_flac__read_next_flac_frame_header(MaDrFlacBs* bs, char streaminfo_bits_per_sample, MaDrFlacFrameHeader* header) @cname("ma_dr_flac__read_next_flac_frame_header");
extern fn MaBool32 dr_flac__read_subframe_header(MaDrFlacBs* bs, MaDrFlacSubframe* p_subframe) @cname("ma_dr_flac__read_subframe_header");
extern fn MaBool32 dr_flac__decode_subframe(MaDrFlacBs* bs, MaDrFlacFrame* frame, int subframe_index, MaInt32* p_decoded_samples_out) @cname("ma_dr_flac__decode_subframe");
extern fn MaBool32 dr_flac__seek_subframe(MaDrFlacBs* bs, MaDrFlacFrame* frame, int subframe_index) @cname("ma_dr_flac__seek_subframe");
extern fn MaUint8 dr_flac__get_channel_count_from_channel_assignment(ichar channel_assignment) @cname("ma_dr_flac__get_channel_count_from_channel_assignment");
extern fn MaResult dr_flac__decode_flac_frame(MaDrFlac* p_flac) @cname("ma_dr_flac__decode_flac_frame");
extern fn MaResult dr_flac__seek_flac_frame(MaDrFlac* p_flac) @cname("ma_dr_flac__seek_flac_frame");
extern fn MaBool32 dr_flac__read_and_decode_next_flac_frame(MaDrFlac* p_flac) @cname("ma_dr_flac__read_and_decode_next_flac_frame");
extern fn void dr_flac__get_pcm_frame_range_of_current_flac_frame(MaDrFlac* p_flac, MaUint64* p_first_pcm_frame, MaUint64* p_last_pcm_frame) @cname("ma_dr_flac__get_pcm_frame_range_of_current_flac_frame");
extern fn MaBool32 dr_flac__seek_to_first_frame(MaDrFlac* p_flac) @cname("ma_dr_flac__seek_to_first_frame");
extern fn MaResult dr_flac__seek_to_next_flac_frame(MaDrFlac* p_flac) @cname("ma_dr_flac__seek_to_next_flac_frame");
extern fn MaUint64 dr_flac__seek_forward_by_pcm_frames(MaDrFlac* p_flac, ulong pcm_frames_to_seek) @cname("ma_dr_flac__seek_forward_by_pcm_frames");
extern fn MaBool32 dr_flac__seek_to_pcm_frame__brute_force(MaDrFlac* p_flac, ulong pcm_frame_index) @cname("ma_dr_flac__seek_to_pcm_frame__brute_force");
extern fn MaBool32 dr_flac__seek_to_approximate_flac_frame_to_byte(MaDrFlac* p_flac, ulong target_byte, ulong range_lo, ulong range_hi, MaUint64* p_last_successful_seek_offset) @cname("ma_dr_flac__seek_to_approximate_flac_frame_to_byte");
extern fn MaBool32 dr_flac__decode_flac_frame_and_seek_forward_by_pcm_frames(MaDrFlac* p_flac, ulong offset) @cname("ma_dr_flac__decode_flac_frame_and_seek_forward_by_pcm_frames");
extern fn MaBool32 dr_flac__seek_to_pcm_frame__binary_search_internal(MaDrFlac* p_flac, ulong pcm_frame_index, ulong byte_range_lo, ulong byte_range_hi) @cname("ma_dr_flac__seek_to_pcm_frame__binary_search_internal");
extern fn MaBool32 dr_flac__seek_to_pcm_frame__binary_search(MaDrFlac* p_flac, ulong pcm_frame_index) @cname("ma_dr_flac__seek_to_pcm_frame__binary_search");
extern fn MaBool32 dr_flac__seek_to_pcm_frame__seek_table(MaDrFlac* p_flac, ulong pcm_frame_index) @cname("ma_dr_flac__seek_to_pcm_frame__seek_table");
extern fn void dr_flac__decode_block_header(uint block_header, MaUint8* is_last_block, MaUint8* block_type, MaUint32* block_size) @cname("ma_dr_flac__decode_block_header");
extern fn MaBool32 dr_flac__read_and_decode_block_header(MaDrFlacReadProc on_read, void* p_user_data, MaUint8* is_last_block, MaUint8* block_type, MaUint32* block_size) @cname("ma_dr_flac__read_and_decode_block_header");
extern fn MaBool32 dr_flac__read_streaminfo(MaDrFlacReadProc on_read, void* p_user_data, MaDrFlacStreaminfo* p_stream_info) @cname("ma_dr_flac__read_streaminfo");
extern fn void* dr_flac__malloc_default(usz sz_, void* p_user_data) @cname("ma_dr_flac__malloc_default");
extern fn void* dr_flac__realloc_default(void* p, usz sz_, void* p_user_data) @cname("ma_dr_flac__realloc_default");
extern fn void dr_flac__free_default(void* p, void* p_user_data) @cname("ma_dr_flac__free_default");
extern fn void* dr_flac__malloc_from_callbacks(usz sz_, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_flac__malloc_from_callbacks");
extern fn void* dr_flac__realloc_from_callbacks(void* p, usz sz_new, usz sz_old, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_flac__realloc_from_callbacks");
extern fn void dr_flac__free_from_callbacks(void* p, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_flac__free_from_callbacks");
extern fn MaBool32 dr_flac__read_and_decode_metadata(MaDrFlacReadProc on_read, MaDrFlacSeekProc on_seek, MaDrFlacTellProc on_tell, MaDrFlacMetaProc on_meta, void* p_user_data, void* p_user_data_md, MaUint64* p_first_frame_pos, MaUint64* p_seektable_pos, MaUint32* p_seekpoint_count, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_flac__read_and_decode_metadata");
extern fn MaBool32 dr_flac__init_private__native(MaDrFlacInitInfo* p_init, MaDrFlacReadProc on_read, MaDrFlacSeekProc on_seek, MaDrFlacMetaProc on_meta, void* p_user_data, void* p_user_data_md, uint relaxed) @cname("ma_dr_flac__init_private__native");
extern fn MaUint32 dr_flac_crc32_byte(uint crc32, char data) @cname("ma_dr_flac_crc32_byte");
extern fn MaUint32 dr_flac_crc32_buffer(uint crc32, MaUint8* p_data, uint data_size) @cname("ma_dr_flac_crc32_buffer");
extern fn MaBool32 dr_flac_ogg__is_capture_pattern(MaUint8* pattern) @cname("ma_dr_flac_ogg__is_capture_pattern");
extern fn MaUint32 dr_flac_ogg__get_page_header_size(MaDrFlacOggPageHeader* p_header) @cname("ma_dr_flac_ogg__get_page_header_size");
extern fn MaUint32 dr_flac_ogg__get_page_body_size(MaDrFlacOggPageHeader* p_header) @cname("ma_dr_flac_ogg__get_page_body_size");
extern fn MaResult dr_flac_ogg__read_page_header_after_capture_pattern(MaDrFlacReadProc on_read, void* p_user_data, MaDrFlacOggPageHeader* p_header, MaUint32* p_bytes_read, MaUint32* p_crc32) @cname("ma_dr_flac_ogg__read_page_header_after_capture_pattern");
extern fn MaResult dr_flac_ogg__read_page_header(MaDrFlacReadProc on_read, void* p_user_data, MaDrFlacOggPageHeader* p_header, MaUint32* p_bytes_read, MaUint32* p_crc32) @cname("ma_dr_flac_ogg__read_page_header");
extern fn usz dr_flac_oggbs__read_physical(MaDrFlacOggbs* oggbs, void* buffer_out, usz bytes_to_read) @cname("ma_dr_flac_oggbs__read_physical");
extern fn MaBool32 dr_flac_oggbs__seek_physical(MaDrFlacOggbs* oggbs, ulong offset, MaDrFlacSeekOrigin origin) @cname("ma_dr_flac_oggbs__seek_physical");
extern fn MaBool32 dr_flac_oggbs__goto_next_page(MaDrFlacOggbs* oggbs, MaDrFlacOggCrcMismatchRecovery recovery_method) @cname("ma_dr_flac_oggbs__goto_next_page");
extern fn usz dr_flac__on_read_ogg(void* p_user_data, void* buffer_out, usz bytes_to_read) @cname("ma_dr_flac__on_read_ogg");
extern fn MaBool32 dr_flac__on_seek_ogg(void* p_user_data, int offset, MaDrFlacSeekOrigin origin) @cname("ma_dr_flac__on_seek_ogg");
extern fn MaBool32 dr_flac__on_tell_ogg(void* p_user_data, MaInt64* p_cursor) @cname("ma_dr_flac__on_tell_ogg");
extern fn MaBool32 dr_flac_ogg__seek_to_pcm_frame(MaDrFlac* p_flac, ulong pcm_frame_index) @cname("ma_dr_flac_ogg__seek_to_pcm_frame");
extern fn MaBool32 dr_flac__init_private__ogg(MaDrFlacInitInfo* p_init, MaDrFlacReadProc on_read, MaDrFlacSeekProc on_seek, MaDrFlacMetaProc on_meta, void* p_user_data, void* p_user_data_md, uint relaxed) @cname("ma_dr_flac__init_private__ogg");
extern fn MaBool32 dr_flac__init_private(MaDrFlacInitInfo* p_init, MaDrFlacReadProc on_read, MaDrFlacSeekProc on_seek, MaDrFlacTellProc on_tell, MaDrFlacMetaProc on_meta, MaDrFlacContainer container, void* p_user_data, void* p_user_data_md) @cname("ma_dr_flac__init_private");
extern fn void dr_flac__init_from_info(MaDrFlac* p_flac, MaDrFlacInitInfo* p_init) @cname("ma_dr_flac__init_from_info");
extern fn MaDrFlac* dr_flac_open_with_metadata_private(MaDrFlacReadProc on_read, MaDrFlacSeekProc on_seek, MaDrFlacTellProc on_tell, MaDrFlacMetaProc on_meta, MaDrFlacContainer container, void* p_user_data, void* p_user_data_md, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_flac_open_with_metadata_private");
extern fn usz dr_flac__on_read_stdio(void* p_user_data, void* buffer_out, usz bytes_to_read) @cname("ma_dr_flac__on_read_stdio");
extern fn MaBool32 dr_flac__on_seek_stdio(void* p_user_data, int offset, MaDrFlacSeekOrigin origin) @cname("ma_dr_flac__on_seek_stdio");
extern fn MaBool32 dr_flac__on_tell_stdio(void* p_user_data, MaInt64* p_cursor) @cname("ma_dr_flac__on_tell_stdio");
extern fn usz dr_flac__on_read_memory(void* p_user_data, void* buffer_out, usz bytes_to_read) @cname("ma_dr_flac__on_read_memory");
extern fn MaBool32 dr_flac__on_seek_memory(void* p_user_data, int offset, MaDrFlacSeekOrigin origin) @cname("ma_dr_flac__on_seek_memory");
extern fn MaBool32 dr_flac__on_tell_memory(void* p_user_data, MaInt64* p_cursor) @cname("ma_dr_flac__on_tell_memory");
extern fn void dr_flac_read_pcm_frames_s32__decode_left_side__scalar(MaDrFlac* p_flac, ulong frame_count, uint unused_bits_per_sample, MaInt32* p_input_samples0, MaInt32* p_input_samples1, MaInt32* p_output_samples) @cname("ma_dr_flac_read_pcm_frames_s32__decode_left_side__scalar");
extern fn void dr_flac_read_pcm_frames_s32__decode_left_side__sse2(MaDrFlac* p_flac, ulong frame_count, uint unused_bits_per_sample, MaInt32* p_input_samples0, MaInt32* p_input_samples1, MaInt32* p_output_samples) @cname("ma_dr_flac_read_pcm_frames_s32__decode_left_side__sse2");
extern fn void dr_flac_read_pcm_frames_s32__decode_left_side(MaDrFlac* p_flac, ulong frame_count, uint unused_bits_per_sample, MaInt32* p_input_samples0, MaInt32* p_input_samples1, MaInt32* p_output_samples) @cname("ma_dr_flac_read_pcm_frames_s32__decode_left_side");
extern fn void dr_flac_read_pcm_frames_s32__decode_right_side__scalar(MaDrFlac* p_flac, ulong frame_count, uint unused_bits_per_sample, MaInt32* p_input_samples0, MaInt32* p_input_samples1, MaInt32* p_output_samples) @cname("ma_dr_flac_read_pcm_frames_s32__decode_right_side__scalar");
extern fn void dr_flac_read_pcm_frames_s32__decode_right_side__sse2(MaDrFlac* p_flac, ulong frame_count, uint unused_bits_per_sample, MaInt32* p_input_samples0, MaInt32* p_input_samples1, MaInt32* p_output_samples) @cname("ma_dr_flac_read_pcm_frames_s32__decode_right_side__sse2");
extern fn void dr_flac_read_pcm_frames_s32__decode_right_side(MaDrFlac* p_flac, ulong frame_count, uint unused_bits_per_sample, MaInt32* p_input_samples0, MaInt32* p_input_samples1, MaInt32* p_output_samples) @cname("ma_dr_flac_read_pcm_frames_s32__decode_right_side");
extern fn void dr_flac_read_pcm_frames_s32__decode_mid_side__scalar(MaDrFlac* p_flac, ulong frame_count, uint unused_bits_per_sample, MaInt32* p_input_samples0, MaInt32* p_input_samples1, MaInt32* p_output_samples) @cname("ma_dr_flac_read_pcm_frames_s32__decode_mid_side__scalar");
extern fn void dr_flac_read_pcm_frames_s32__decode_mid_side__sse2(MaDrFlac* p_flac, ulong frame_count, uint unused_bits_per_sample, MaInt32* p_input_samples0, MaInt32* p_input_samples1, MaInt32* p_output_samples) @cname("ma_dr_flac_read_pcm_frames_s32__decode_mid_side__sse2");
extern fn void dr_flac_read_pcm_frames_s32__decode_mid_side(MaDrFlac* p_flac, ulong frame_count, uint unused_bits_per_sample, MaInt32* p_input_samples0, MaInt32* p_input_samples1, MaInt32* p_output_samples) @cname("ma_dr_flac_read_pcm_frames_s32__decode_mid_side");
extern fn void dr_flac_read_pcm_frames_s32__decode_independent_stereo__scalar(MaDrFlac* p_flac, ulong frame_count, uint unused_bits_per_sample, MaInt32* p_input_samples0, MaInt32* p_input_samples1, MaInt32* p_output_samples) @cname("ma_dr_flac_read_pcm_frames_s32__decode_independent_stereo__scalar");
extern fn void dr_flac_read_pcm_frames_s32__decode_independent_stereo__sse2(MaDrFlac* p_flac, ulong frame_count, uint unused_bits_per_sample, MaInt32* p_input_samples0, MaInt32* p_input_samples1, MaInt32* p_output_samples) @cname("ma_dr_flac_read_pcm_frames_s32__decode_independent_stereo__sse2");
extern fn void dr_flac_read_pcm_frames_s32__decode_independent_stereo(MaDrFlac* p_flac, ulong frame_count, uint unused_bits_per_sample, MaInt32* p_input_samples0, MaInt32* p_input_samples1, MaInt32* p_output_samples) @cname("ma_dr_flac_read_pcm_frames_s32__decode_independent_stereo");
extern fn void dr_flac_read_pcm_frames_s16__decode_left_side__scalar(MaDrFlac* p_flac, ulong frame_count, uint unused_bits_per_sample, MaInt32* p_input_samples0, MaInt32* p_input_samples1, MaInt16* p_output_samples) @cname("ma_dr_flac_read_pcm_frames_s16__decode_left_side__scalar");
extern fn void dr_flac_read_pcm_frames_s16__decode_left_side__sse2(MaDrFlac* p_flac, ulong frame_count, uint unused_bits_per_sample, MaInt32* p_input_samples0, MaInt32* p_input_samples1, MaInt16* p_output_samples) @cname("ma_dr_flac_read_pcm_frames_s16__decode_left_side__sse2");
extern fn void dr_flac_read_pcm_frames_s16__decode_left_side(MaDrFlac* p_flac, ulong frame_count, uint unused_bits_per_sample, MaInt32* p_input_samples0, MaInt32* p_input_samples1, MaInt16* p_output_samples) @cname("ma_dr_flac_read_pcm_frames_s16__decode_left_side");
extern fn void dr_flac_read_pcm_frames_s16__decode_right_side__scalar(MaDrFlac* p_flac, ulong frame_count, uint unused_bits_per_sample, MaInt32* p_input_samples0, MaInt32* p_input_samples1, MaInt16* p_output_samples) @cname("ma_dr_flac_read_pcm_frames_s16__decode_right_side__scalar");
extern fn void dr_flac_read_pcm_frames_s16__decode_right_side__sse2(MaDrFlac* p_flac, ulong frame_count, uint unused_bits_per_sample, MaInt32* p_input_samples0, MaInt32* p_input_samples1, MaInt16* p_output_samples) @cname("ma_dr_flac_read_pcm_frames_s16__decode_right_side__sse2");
extern fn void dr_flac_read_pcm_frames_s16__decode_right_side(MaDrFlac* p_flac, ulong frame_count, uint unused_bits_per_sample, MaInt32* p_input_samples0, MaInt32* p_input_samples1, MaInt16* p_output_samples) @cname("ma_dr_flac_read_pcm_frames_s16__decode_right_side");
extern fn void dr_flac_read_pcm_frames_s16__decode_mid_side__scalar(MaDrFlac* p_flac, ulong frame_count, uint unused_bits_per_sample, MaInt32* p_input_samples0, MaInt32* p_input_samples1, MaInt16* p_output_samples) @cname("ma_dr_flac_read_pcm_frames_s16__decode_mid_side__scalar");
extern fn void dr_flac_read_pcm_frames_s16__decode_mid_side__sse2(MaDrFlac* p_flac, ulong frame_count, uint unused_bits_per_sample, MaInt32* p_input_samples0, MaInt32* p_input_samples1, MaInt16* p_output_samples) @cname("ma_dr_flac_read_pcm_frames_s16__decode_mid_side__sse2");
extern fn void dr_flac_read_pcm_frames_s16__decode_mid_side(MaDrFlac* p_flac, ulong frame_count, uint unused_bits_per_sample, MaInt32* p_input_samples0, MaInt32* p_input_samples1, MaInt16* p_output_samples) @cname("ma_dr_flac_read_pcm_frames_s16__decode_mid_side");
extern fn void dr_flac_read_pcm_frames_s16__decode_independent_stereo__scalar(MaDrFlac* p_flac, ulong frame_count, uint unused_bits_per_sample, MaInt32* p_input_samples0, MaInt32* p_input_samples1, MaInt16* p_output_samples) @cname("ma_dr_flac_read_pcm_frames_s16__decode_independent_stereo__scalar");
extern fn void dr_flac_read_pcm_frames_s16__decode_independent_stereo__sse2(MaDrFlac* p_flac, ulong frame_count, uint unused_bits_per_sample, MaInt32* p_input_samples0, MaInt32* p_input_samples1, MaInt16* p_output_samples) @cname("ma_dr_flac_read_pcm_frames_s16__decode_independent_stereo__sse2");
extern fn void dr_flac_read_pcm_frames_s16__decode_independent_stereo(MaDrFlac* p_flac, ulong frame_count, uint unused_bits_per_sample, MaInt32* p_input_samples0, MaInt32* p_input_samples1, MaInt16* p_output_samples) @cname("ma_dr_flac_read_pcm_frames_s16__decode_independent_stereo");
extern fn void dr_flac_read_pcm_frames_f32__decode_left_side__scalar(MaDrFlac* p_flac, ulong frame_count, uint unused_bits_per_sample, MaInt32* p_input_samples0, MaInt32* p_input_samples1, float* p_output_samples) @cname("ma_dr_flac_read_pcm_frames_f32__decode_left_side__scalar");
extern fn void dr_flac_read_pcm_frames_f32__decode_left_side__sse2(MaDrFlac* p_flac, ulong frame_count, uint unused_bits_per_sample, MaInt32* p_input_samples0, MaInt32* p_input_samples1, float* p_output_samples) @cname("ma_dr_flac_read_pcm_frames_f32__decode_left_side__sse2");
extern fn void dr_flac_read_pcm_frames_f32__decode_left_side(MaDrFlac* p_flac, ulong frame_count, uint unused_bits_per_sample, MaInt32* p_input_samples0, MaInt32* p_input_samples1, float* p_output_samples) @cname("ma_dr_flac_read_pcm_frames_f32__decode_left_side");
extern fn void dr_flac_read_pcm_frames_f32__decode_right_side__scalar(MaDrFlac* p_flac, ulong frame_count, uint unused_bits_per_sample, MaInt32* p_input_samples0, MaInt32* p_input_samples1, float* p_output_samples) @cname("ma_dr_flac_read_pcm_frames_f32__decode_right_side__scalar");
extern fn void dr_flac_read_pcm_frames_f32__decode_right_side__sse2(MaDrFlac* p_flac, ulong frame_count, uint unused_bits_per_sample, MaInt32* p_input_samples0, MaInt32* p_input_samples1, float* p_output_samples) @cname("ma_dr_flac_read_pcm_frames_f32__decode_right_side__sse2");
extern fn void dr_flac_read_pcm_frames_f32__decode_right_side(MaDrFlac* p_flac, ulong frame_count, uint unused_bits_per_sample, MaInt32* p_input_samples0, MaInt32* p_input_samples1, float* p_output_samples) @cname("ma_dr_flac_read_pcm_frames_f32__decode_right_side");
extern fn void dr_flac_read_pcm_frames_f32__decode_mid_side__scalar(MaDrFlac* p_flac, ulong frame_count, uint unused_bits_per_sample, MaInt32* p_input_samples0, MaInt32* p_input_samples1, float* p_output_samples) @cname("ma_dr_flac_read_pcm_frames_f32__decode_mid_side__scalar");
extern fn void dr_flac_read_pcm_frames_f32__decode_mid_side__sse2(MaDrFlac* p_flac, ulong frame_count, uint unused_bits_per_sample, MaInt32* p_input_samples0, MaInt32* p_input_samples1, float* p_output_samples) @cname("ma_dr_flac_read_pcm_frames_f32__decode_mid_side__sse2");
extern fn void dr_flac_read_pcm_frames_f32__decode_mid_side(MaDrFlac* p_flac, ulong frame_count, uint unused_bits_per_sample, MaInt32* p_input_samples0, MaInt32* p_input_samples1, float* p_output_samples) @cname("ma_dr_flac_read_pcm_frames_f32__decode_mid_side");
extern fn void dr_flac_read_pcm_frames_f32__decode_independent_stereo__scalar(MaDrFlac* p_flac, ulong frame_count, uint unused_bits_per_sample, MaInt32* p_input_samples0, MaInt32* p_input_samples1, float* p_output_samples) @cname("ma_dr_flac_read_pcm_frames_f32__decode_independent_stereo__scalar");
extern fn void dr_flac_read_pcm_frames_f32__decode_independent_stereo__sse2(MaDrFlac* p_flac, ulong frame_count, uint unused_bits_per_sample, MaInt32* p_input_samples0, MaInt32* p_input_samples1, float* p_output_samples) @cname("ma_dr_flac_read_pcm_frames_f32__decode_independent_stereo__sse2");
extern fn void dr_flac_read_pcm_frames_f32__decode_independent_stereo(MaDrFlac* p_flac, ulong frame_count, uint unused_bits_per_sample, MaInt32* p_input_samples0, MaInt32* p_input_samples1, float* p_output_samples) @cname("ma_dr_flac_read_pcm_frames_f32__decode_independent_stereo");
extern fn MaInt32* dr_flac__full_read_and_close_s32(MaDrFlac* p_flac, uint* channels_out, uint* sample_rate_out, MaUint64* total_pcm_frame_count_out) @cname("ma_dr_flac__full_read_and_close_s32");
extern fn MaInt16* dr_flac__full_read_and_close_s16(MaDrFlac* p_flac, uint* channels_out, uint* sample_rate_out, MaUint64* total_pcm_frame_count_out) @cname("ma_dr_flac__full_read_and_close_s16");
extern fn float* dr_flac__full_read_and_close_f32(MaDrFlac* p_flac, uint* channels_out, uint* sample_rate_out, MaUint64* total_pcm_frame_count_out) @cname("ma_dr_flac__full_read_and_close_f32");
extern fn void dr_mp3_cpuid(int* cpu_info, int info_type) @cname("ma_dr_mp3_cpuid");
extern fn int dr_mp3_have_simd() @cname("ma_dr_mp3_have_simd");
extern fn void dr_mp3_bs_init(MaDrMp3Bs* bs, MaUint8* data, int bytes) @cname("ma_dr_mp3_bs_init");
extern fn MaUint32 dr_mp3_bs_get_bits(MaDrMp3Bs* bs, int n) @cname("ma_dr_mp3_bs_get_bits");
extern fn int dr_mp3_hdr_valid(MaUint8* h) @cname("ma_dr_mp3_hdr_valid");
extern fn int dr_mp3_hdr_compare(MaUint8* h1, MaUint8* h2) @cname("ma_dr_mp3_hdr_compare");
extern fn uint dr_mp3_hdr_bitrate_kbps(MaUint8* h) @cname("ma_dr_mp3_hdr_bitrate_kbps");
extern fn uint dr_mp3_hdr_sample_rate_hz(MaUint8* h) @cname("ma_dr_mp3_hdr_sample_rate_hz");
extern fn uint dr_mp3_hdr_frame_samples(MaUint8* h) @cname("ma_dr_mp3_hdr_frame_samples");
extern fn int dr_mp3_hdr_frame_bytes(MaUint8* h, int free_format_size) @cname("ma_dr_mp3_hdr_frame_bytes");
extern fn int dr_mp3_hdr_padding(MaUint8* h) @cname("ma_dr_mp3_hdr_padding");
extern fn MaDrMp3L12SubbandAlloc* dr_mp3_l12_subband_alloc_table(MaUint8* hdr, MaDrMp3L12ScaleInfo* sci) @cname("ma_dr_mp3_L12_subband_alloc_table");
extern fn void dr_mp3_l12_read_scalefactors(MaDrMp3Bs* bs, MaUint8* pba, MaUint8* scfcod, int bands, float* scf) @cname("ma_dr_mp3_L12_read_scalefactors");
extern fn void dr_mp3_l12_read_scale_info(MaUint8* hdr, MaDrMp3Bs* bs, MaDrMp3L12ScaleInfo* sci) @cname("ma_dr_mp3_L12_read_scale_info");
extern fn int dr_mp3_l12_dequantize_granule(float* grbuf, MaDrMp3Bs* bs, MaDrMp3L12ScaleInfo* sci, int group_size) @cname("ma_dr_mp3_L12_dequantize_granule");
extern fn void dr_mp3_l12_apply_scf_384(MaDrMp3L12ScaleInfo* sci, float* scf, float* dst) @cname("ma_dr_mp3_L12_apply_scf_384");
extern fn int dr_mp3_l3_read_side_info(MaDrMp3Bs* bs, MaDrMp3L3GrInfo* gr, MaUint8* hdr) @cname("ma_dr_mp3_L3_read_side_info");
extern fn void dr_mp3_l3_read_scalefactors(MaUint8* scf, MaUint8* ist_pos, MaUint8* scf_size, MaUint8* scf_count, MaDrMp3Bs* bitbuf, int scfsi) @cname("ma_dr_mp3_L3_read_scalefactors");
extern fn float dr_mp3_l3_ldexp_q2(float y, int exp_q2) @cname("ma_dr_mp3_L3_ldexp_q2");
extern fn void dr_mp3_l3_decode_scalefactors(MaUint8* hdr, MaUint8* ist_pos, MaDrMp3Bs* bs, MaDrMp3L3GrInfo* gr, float* scf, int ch) @cname("ma_dr_mp3_L3_decode_scalefactors");
extern fn float dr_mp3_l3_pow_43(int x) @cname("ma_dr_mp3_L3_pow_43");
extern fn void dr_mp3_l3_huffman(float* dst, MaDrMp3Bs* bs, MaDrMp3L3GrInfo* gr_info, float* scf, int layer3gr_limit) @cname("ma_dr_mp3_L3_huffman");
extern fn void dr_mp3_l3_midside_stereo(float* left, int n) @cname("ma_dr_mp3_L3_midside_stereo");
extern fn void dr_mp3_l3_intensity_stereo_band(float* left, int n, float kl, float kr) @cname("ma_dr_mp3_L3_intensity_stereo_band");
extern fn void dr_mp3_l3_stereo_top_band(float* right, MaUint8* sfb, int nbands, int* max_band) @cname("ma_dr_mp3_L3_stereo_top_band");
extern fn void dr_mp3_l3_stereo_process(float* left, MaUint8* ist_pos, MaUint8* sfb, MaUint8* hdr, int* max_band, int mpeg2_sh) @cname("ma_dr_mp3_L3_stereo_process");
extern fn void dr_mp3_l3_intensity_stereo(float* left, MaUint8* ist_pos, MaDrMp3L3GrInfo* gr, MaUint8* hdr) @cname("ma_dr_mp3_L3_intensity_stereo");
extern fn void dr_mp3_l3_reorder(float* grbuf, float* scratch, MaUint8* sfb) @cname("ma_dr_mp3_L3_reorder");
extern fn void dr_mp3_l3_antialias(float* grbuf, int nbands) @cname("ma_dr_mp3_L3_antialias");
extern fn void dr_mp3_l3_dct3_9(float* y) @cname("ma_dr_mp3_L3_dct3_9");
extern fn void dr_mp3_l3_imdct36(float* grbuf, float* overlap, float* window, int nbands) @cname("ma_dr_mp3_L3_imdct36");
extern fn void dr_mp3_l3_idct3(float x0, float x1, float x2, float* dst) @cname("ma_dr_mp3_L3_idct3");
extern fn void dr_mp3_l3_imdct12(float* x, float* dst, float* overlap) @cname("ma_dr_mp3_L3_imdct12");
extern fn void dr_mp3_l3_imdct_short(float* grbuf, float* overlap, int nbands) @cname("ma_dr_mp3_L3_imdct_short");
extern fn void dr_mp3_l3_change_sign(float* grbuf) @cname("ma_dr_mp3_L3_change_sign");
extern fn void dr_mp3_l3_imdct_gr(float* grbuf, float* overlap, uint block_type, uint n_long_bands) @cname("ma_dr_mp3_L3_imdct_gr");
extern fn void dr_mp3_l3_save_reservoir(MaDrMp3dec* h, MaDrMp3decScratch* s) @cname("ma_dr_mp3_L3_save_reservoir");
extern fn int dr_mp3_l3_restore_reservoir(MaDrMp3dec* h, MaDrMp3Bs* bs, MaDrMp3decScratch* s, int main_data_begin) @cname("ma_dr_mp3_L3_restore_reservoir");
extern fn void dr_mp3_l3_decode(MaDrMp3dec* h, MaDrMp3decScratch* s, MaDrMp3L3GrInfo* gr_info, int nch) @cname("ma_dr_mp3_L3_decode");
extern fn void dr_mp3d_dct_ii(float* grbuf, int n) @cname("ma_dr_mp3d_DCT_II");
extern fn MaInt16 dr_mp3d_scale_pcm(float sample) @cname("ma_dr_mp3d_scale_pcm");
extern fn void dr_mp3d_synth_pair(MaDrMp3dSampleT* pcm, int nch, float* z) @cname("ma_dr_mp3d_synth_pair");
extern fn void dr_mp3d_synth(float* xl, MaDrMp3dSampleT* dstl, int nch, float* lins) @cname("ma_dr_mp3d_synth");
extern fn void dr_mp3d_synth_granule(float* qmf_state, float* grbuf, int nbands, int nch, MaDrMp3dSampleT* pcm, float* lins) @cname("ma_dr_mp3d_synth_granule");
extern fn int dr_mp3d_match_frame(MaUint8* hdr, int mp3_bytes, int frame_bytes) @cname("ma_dr_mp3d_match_frame");
extern fn int dr_mp3d_find_frame(MaUint8* mp3, int mp3_bytes, int* free_format_bytes, int* ptr_frame_bytes) @cname("ma_dr_mp3d_find_frame");
extern fn float dr_mp3_mix_f32(float x, float y, float a) @cname("ma_dr_mp3_mix_f32");
extern fn float dr_mp3_mix_f32_fast(float x, float y, float a) @cname("ma_dr_mp3_mix_f32_fast");
extern fn MaUint32 dr_mp3_gcf_u32(uint a, uint b) @cname("ma_dr_mp3_gcf_u32");
extern fn void* dr_mp3__malloc_default(usz sz_, void* p_user_data) @cname("ma_dr_mp3__malloc_default");
extern fn void* dr_mp3__realloc_default(void* p, usz sz_, void* p_user_data) @cname("ma_dr_mp3__realloc_default");
extern fn void dr_mp3__free_default(void* p, void* p_user_data) @cname("ma_dr_mp3__free_default");
extern fn void* dr_mp3__malloc_from_callbacks(usz sz_, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_mp3__malloc_from_callbacks");
extern fn void* dr_mp3__realloc_from_callbacks(void* p, usz sz_new, usz sz_old, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_mp3__realloc_from_callbacks");
extern fn void dr_mp3__free_from_callbacks(void* p, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_mp3__free_from_callbacks");
extern fn MaAllocationCallbacks dr_mp3_copy_allocation_callbacks_or_defaults(MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_mp3_copy_allocation_callbacks_or_defaults");
extern fn usz dr_mp3__on_read(MaDrMp3* p_mp3, void* p_buffer_out, usz bytes_to_read) @cname("ma_dr_mp3__on_read");
extern fn usz dr_mp3__on_read_clamped(MaDrMp3* p_mp3, void* p_buffer_out, usz bytes_to_read) @cname("ma_dr_mp3__on_read_clamped");
extern fn MaBool32 dr_mp3__on_seek(MaDrMp3* p_mp3, int offset, MaDrMp3SeekOrigin origin) @cname("ma_dr_mp3__on_seek");
extern fn MaBool32 dr_mp3__on_seek_64(MaDrMp3* p_mp3, ulong offset, MaDrMp3SeekOrigin origin) @cname("ma_dr_mp3__on_seek_64");
extern fn void dr_mp3__on_meta(MaDrMp3* p_mp3, MaDrMp3MetadataType type, void* p_raw_data, usz raw_data_size) @cname("ma_dr_mp3__on_meta");
extern fn MaUint32 dr_mp3_decode_next_frame_ex__callbacks(MaDrMp3* p_mp3, MaDrMp3dSampleT* p_pcm_frames, MaDrMp3decFrameInfo* p_mp3_frame_info, MaUint8** pp_mp3_frame_data) @cname("ma_dr_mp3_decode_next_frame_ex__callbacks");
extern fn MaUint32 dr_mp3_decode_next_frame_ex__memory(MaDrMp3* p_mp3, MaDrMp3dSampleT* p_pcm_frames, MaDrMp3decFrameInfo* p_mp3_frame_info, MaUint8** pp_mp3_frame_data) @cname("ma_dr_mp3_decode_next_frame_ex__memory");
extern fn MaUint32 dr_mp3_decode_next_frame_ex(MaDrMp3* p_mp3, MaDrMp3dSampleT* p_pcm_frames, MaDrMp3decFrameInfo* p_mp3_frame_info, MaUint8** pp_mp3_frame_data) @cname("ma_dr_mp3_decode_next_frame_ex");
extern fn MaUint32 dr_mp3_decode_next_frame(MaDrMp3* p_mp3) @cname("ma_dr_mp3_decode_next_frame");
extern fn MaBool32 dr_mp3_init_internal(MaDrMp3* p_mp3, MaDrMp3ReadProc on_read, MaDrMp3SeekProc on_seek, MaDrMp3TellProc on_tell, MaDrMp3MetaProc on_meta, void* p_user_data, void* p_user_data_meta, MaAllocationCallbacks* p_allocation_callbacks) @cname("ma_dr_mp3_init_internal");
extern fn usz dr_mp3__on_read_memory(void* p_user_data, void* p_buffer_out, usz bytes_to_read) @cname("ma_dr_mp3__on_read_memory");
extern fn MaBool32 dr_mp3__on_seek_memory(void* p_user_data, int byte_offset, MaDrMp3SeekOrigin origin) @cname("ma_dr_mp3__on_seek_memory");
extern fn MaBool32 dr_mp3__on_tell_memory(void* p_user_data, MaInt64* p_cursor) @cname("ma_dr_mp3__on_tell_memory");
extern fn usz dr_mp3__on_read_stdio(void* p_user_data, void* p_buffer_out, usz bytes_to_read) @cname("ma_dr_mp3__on_read_stdio");
extern fn MaBool32 dr_mp3__on_seek_stdio(void* p_user_data, int offset, MaDrMp3SeekOrigin origin) @cname("ma_dr_mp3__on_seek_stdio");
extern fn MaBool32 dr_mp3__on_tell_stdio(void* p_user_data, MaInt64* p_cursor) @cname("ma_dr_mp3__on_tell_stdio");
extern fn void dr_mp3_s16_to_f32(float* dst, MaInt16* src, ulong sample_count) @cname("ma_dr_mp3_s16_to_f32");
extern fn MaUint64 dr_mp3_read_pcm_frames_raw(MaDrMp3* p_mp3, ulong frames_to_read, void* p_buffer_out) @cname("ma_dr_mp3_read_pcm_frames_raw");
extern fn void dr_mp3_reset(MaDrMp3* p_mp3) @cname("ma_dr_mp3_reset");
extern fn MaBool32 dr_mp3_seek_to_start_of_stream(MaDrMp3* p_mp3) @cname("ma_dr_mp3_seek_to_start_of_stream");
extern fn MaBool32 dr_mp3_seek_forward_by_pcm_frames__brute_force(MaDrMp3* p_mp3, ulong frame_offset) @cname("ma_dr_mp3_seek_forward_by_pcm_frames__brute_force");
extern fn MaBool32 dr_mp3_seek_to_pcm_frame__brute_force(MaDrMp3* p_mp3, ulong frame_index) @cname("ma_dr_mp3_seek_to_pcm_frame__brute_force");
extern fn MaBool32 dr_mp3_find_closest_seek_point(MaDrMp3* p_mp3, ulong frame_index, MaUint32* p_seek_point_index) @cname("ma_dr_mp3_find_closest_seek_point");
extern fn MaBool32 dr_mp3_seek_to_pcm_frame__seek_table(MaDrMp3* p_mp3, ulong frame_index) @cname("ma_dr_mp3_seek_to_pcm_frame__seek_table");
extern fn void dr_mp3__accumulate_running_pcm_frame_count(MaDrMp3* p_mp3, uint pcm_frame_count_in, MaUint64* p_running_pcm_frame_count, float* p_running_pcm_frame_count_fractional_part) @cname("ma_dr_mp3__accumulate_running_pcm_frame_count");
extern fn float* dr_mp3__full_read_and_close_f32(MaDrMp3* p_mp3, MaDrMp3Config* p_config, MaUint64* p_total_frame_count) @cname("ma_dr_mp3__full_read_and_close_f32");
extern fn MaInt16* dr_mp3__full_read_and_close_s16(MaDrMp3* p_mp3, MaDrMp3Config* p_config, MaUint64* p_total_frame_count) @cname("ma_dr_mp3__full_read_and_close_s16");

// Global Variables
extern MaUint32[14] g_ma_standard_sample_rate_priorities @cname("g_maStandardSampleRatePriorities");
extern MaFormat[5] g_ma_format_priorities @cname("g_maFormatPriorities");
extern MaLcg g_ma_lcg @cname("g_maLCG");
extern uint atomic_global_lock @cname("ma_atomic_global_lock");
extern MaJobProc[12] g_job_v_table @cname("g_jobVTable");
extern MaBackendInfo[15] g_backend_info @cname("gBackendInfo");
extern ZString[4] g_ma_common_device_names_alsa @cname("g_maCommonDeviceNamesALSA");
extern ZString[1] g_ma_blacklisted_playback_device_names_alsa @cname("g_maBlacklistedPlaybackDeviceNamesALSA");
extern ZString[1] g_ma_blacklisted_capture_device_names_alsa @cname("g_maBlacklistedCaptureDeviceNamesALSA");
extern MaVec3f[52] g_ma_channel_directions @cname("g_maChannelDirections");
extern MaResamplingBackendVtable g_ma_linear_resampler_vtable @cname("g_ma_linear_resampler_vtable");
extern float[52][6] g_ma_channel_plane_ratios @cname("g_maChannelPlaneRatios");
extern MaDataSourceVtable g_rb_data_source_v_table @cname("ma_gRBDataSourceVTable");
extern MaDataSourceVtable g_ma_audio_buffer_ref_data_source_vtable @cname("g_ma_audio_buffer_ref_data_source_vtable");
extern MaDataSourceVtable g_ma_paged_audio_buffer_data_source_vtable @cname("g_ma_paged_audio_buffer_data_source_vtable");
extern MaDataSourceVtable g_ma_wav_ds_vtable @cname("g_ma_wav_ds_vtable");
extern MaDecodingBackendVtable g_ma_decoding_backend_vtable_wav @cname("g_ma_decoding_backend_vtable_wav");
extern MaDataSourceVtable g_ma_flac_ds_vtable @cname("g_ma_flac_ds_vtable");
extern MaDecodingBackendVtable g_ma_decoding_backend_vtable_flac @cname("g_ma_decoding_backend_vtable_flac");
extern MaDataSourceVtable g_ma_mp3_ds_vtable @cname("g_ma_mp3_ds_vtable");
extern MaDecodingBackendVtable g_ma_decoding_backend_vtable_mp3 @cname("g_ma_decoding_backend_vtable_mp3");
extern MaDataSourceVtable g_ma_decoder_data_source_vtable @cname("g_ma_decoder_data_source_vtable");
extern MaDataSourceVtable g_ma_waveform_data_source_vtable @cname("g_ma_waveform_data_source_vtable");
extern MaDataSourceVtable g_ma_noise_data_source_vtable @cname("g_ma_noise_data_source_vtable");
extern MaDataSourceVtable g_ma_resource_manager_data_buffer_vtable @cname("g_ma_resource_manager_data_buffer_vtable");
extern MaDataSourceVtable g_ma_resource_manager_data_stream_vtable @cname("g_ma_resource_manager_data_stream_vtable");
extern MaNodeVtable g_node_graph_node_vtable @cname("g_node_graph_node_vtable");
extern MaNodeVtable g_node_graph_endpoint_vtable @cname("g_node_graph_endpoint_vtable");
extern MaNodeVtable g_ma_data_source_node_vtable @cname("g_ma_data_source_node_vtable");
extern MaNodeVtable g_ma_splitter_node_vtable @cname("g_ma_splitter_node_vtable");
extern MaNodeVtable g_ma_biquad_node_vtable @cname("g_ma_biquad_node_vtable");
extern MaNodeVtable g_ma_lpf_node_vtable @cname("g_ma_lpf_node_vtable");
extern MaNodeVtable g_ma_hpf_node_vtable @cname("g_ma_hpf_node_vtable");
extern MaNodeVtable g_ma_bpf_node_vtable @cname("g_ma_bpf_node_vtable");
extern MaNodeVtable g_ma_notch_node_vtable @cname("g_ma_notch_node_vtable");
extern MaNodeVtable g_ma_peak_node_vtable @cname("g_ma_peak_node_vtable");
extern MaNodeVtable g_ma_loshelf_node_vtable @cname("g_ma_loshelf_node_vtable");
extern MaNodeVtable g_ma_hishelf_node_vtable @cname("g_ma_hishelf_node_vtable");
extern MaNodeVtable g_ma_delay_node_vtable @cname("g_ma_delay_node_vtable");
extern MaNodeVtable g_ma_engine_node_vtable__sound @cname("g_ma_engine_node_vtable__sound");
extern MaNodeVtable g_ma_engine_node_vtable__group @cname("g_ma_engine_node_vtable__group");
extern MaUint8[16] dr_wav_guid_w64_riff @cname("ma_dr_wavGUID_W64_RIFF");
extern MaUint8[16] dr_wav_guid_w64_wave @cname("ma_dr_wavGUID_W64_WAVE");
extern MaUint8[16] dr_wav_guid_w64_fmt @cname("ma_dr_wavGUID_W64_FMT");
extern MaUint8[16] dr_wav_guid_w64_fact @cname("ma_dr_wavGUID_W64_FACT");
extern MaUint8[16] dr_wav_guid_w64_data @cname("ma_dr_wavGUID_W64_DATA");
extern ushort[256] dr_wav_g_alaw_table @cname("ma_dr_wav_gAlawTable");
extern ushort[256] dr_wav_g_mulaw_table @cname("ma_dr_wav_gMulawTable");
extern uint dr_flac__g_is_lzcnt_supported @cname("ma_dr_flac__gIsLZCNTSupported");
extern uint dr_flac__g_is_sse2_supported @cname("ma_dr_flac__gIsSSE2Supported");
extern uint dr_flac__g_is_sse41_supported @cname("ma_dr_flac__gIsSSE41Supported");
extern MaUint8[256] dr_flac__crc8_table @cname("ma_dr_flac__crc8_table");
extern MaUint16[256] dr_flac__crc16_table @cname("ma_dr_flac__crc16_table");
extern MaUint32[256] dr_flac__crc32_table @cname("ma_dr_flac__crc32_table");
extern float[145] dr_mp3_g_pow43 @cname("ma_dr_mp3_g_pow43");


<*
## High-Level API: `@parse`

The `@parse` macro parses a command-line argument slice. It automatically extracts option names, processes qualifiers, maps values to variables, and handles sequential arrays, enums, callbacks, and environment fallbacks.

Options can be specified using either:
* **Triplets**: `short_name, long_name, &assignee`
* **Quartets**: `short_name, long_name, description, &assignee`

You can freely mix triplets and quartets within the same `@parse` invocation.

### Basic Example

```c3
import std::io;
import std::os::argparse;

fn int main(String[] args)
{
	bool help = false;
	int port = 8080;
	String host = "127.0.0.1";

	sz? result = argparse::@parse(args,
		"h*", "help*", "Show help manual",         &help,
		"p",  "port",                              &port,
		"s",  "server", "The server host address", &host
	);

	if (catch err = result)
	{
		if (err == argparse::HELP_REQUESTED) return 0;

		io::eprintfn("Command-line error: %s", err);
		return 1;
	}

	io::printfn("Starting server on %s:%d", host, port);
	return 0;
}
```

### Supported Syntax Conventions

The parser is designed to adhere to standard POSIX and GNU command-line parsing conventions:

* **Long Option Separators**: Values can be passed to long options using either spaces or an equals sign (e.g., `--port 8080` or `--port=8080`).
* **Short Option Stacking**: Multiple short flags can be stacked together (e.g., `-vh` instead of `-v -h`).
* **Compact Short Option Values**: A short option requiring an argument can accept its value directly attached to the flag (e.g., `-p8080` instead of `-p 8080`).
* **Negative Numbers**: Hyphenated numeric values (such as `-10` or `-3.14`) are automatically detected and treated as literal values rather than illegal options.

---

## Option Qualifiers

Qualifiers can be appended to option names (either short or long) to modify their behavior at compile time.

### 1. Help Qualifier (`*`)
Any flag designated with `*` acts as a help trigger. When matched, the macro automatically formats and prints a left-aligned options block using the descriptions provided in the quartets, then returns `argparse::HELP_REQUESTED`.
```c3
"h*", "help*", "Show this help screen", &help
```

### 2. Optional Suffix (`?`)
By default, non-boolean options *must* be followed by a value (for example, `--port` expects a trailing number, and omitting it throws a `MISSING_ARGUMENT` error). 

Appending `?` to any option name makes its value optional:

1. **For non-booleans (Strings, Integers, etc.)**: If the flag is specified without a value, the parser skips it without throwing an error, allowing the variable to retain its default initialized value. If a value *is* provided, it is parsed and assigned normally.
2. **For booleans**: By default, booleans don't accept arguments. Appending `?` allows them to optionally parse explicit values (such as `--verbose=false` or `--verbose=true`), while falling back to `true` if passed as a bare flag.

This is highly useful for flags that enable a feature with a sensible default but can optionally accept a custom override.

```c3
String log_file = "default.log";
bool help = false;

sz? result = argparse::@parse(args,
	"h*", "help*", "Show help manual",                                   &help,
	"l?", "log?", "Enable logging, optionally specifying a custom file", &log_file
);

// Running:  ./app --log
// Result:   log_file remains "default.log"

// Running:  ./app --log custom.log
// Result:   log_file becomes "custom.log"
```

### 3. Incremental Counters (`+`)
Appending `+` to an option name increments the target numeric variable every time the flag is specified.

The parser supports both standard stacked short flags (e.g., `-vvv`) as well as repeated occurrences of flags.
```c3
"v+", "verbose+", "Increase verbosity", &verbosity
// Passing "-vvv -v" results in verbosity = 4
// Passing "-vv --verbose -vvv -v" results in verbosity = 7
```

---

## Advanced Features

### 1. Environment Variable Fallbacks
Long options can be mapped to environment variable fallbacks using `=env:VAR_NAME`. If the flag is omitted from the command-line invocation, the parser queries the specified environment variable before finishing.

```c3
int port = 8080;

argparse::@parse(args,
	"p", "port=env:PORT", "Port number (defaults to $PORT)", &port
);
```

### 2. Custom Validation Callbacks
You can pass a callback function of type `fn void? (String)` as an option assignee.

The callback is invoked with the parsed option value. Returning a fault from this function aborts option parsing and propagates the fault out of `@parse`.

```c3
fn void? validate_port(String value)
{
	int? port = value.to_int();
	if (catch err = port) return argparse::INVALID_VALUE~;
	if (port < 1024) return argparse::INVALID_VALUE~;
	return;
}

// ...
argparse::@parse(args,
	"p", "port", "Custom validated port", &validate_port
);
```

### 3. Sequential Array Collection
Passing a pointer to a fixed-size array collects sequential occurrences of that option flag into the array.

To prevent parsing ambiguity with subsequent positional arguments, each item must be preceded by its own option flag. Space-separated multi-value syntax (e.g. `-f file1 file2`) is intentionally unsupported to ensure positional arguments are not eaten by mistake.

If the array capacity is exceeded, the parser returns `argparse::OUT_OF_BOUNDS`.

```c3
String[3] input_files = {};

argparse::@parse(args,
	"f", "file", "Target files to process", &input_files
);
// Passing "-f file1.txt -f file2.txt" populates input_files[0] and input_files[1]
```

### 4. Automatic Enum Mapping
If you pass a pointer to an `enum`, the parser case-insensitively maps CLI string values to the enum member names, falling back to matching integer ordinal indices.

```c3
enum LogLevel { DEBUG, INFO, WARNING, ERROR }
LogLevel level = LogLevel.INFO;

argparse::@parse(args,
	"l", "level", "Select logging level", &level
);
// Values like "debug", "DEBUG", "2" are mapped automatically.
```

### 5. Strict Option Parsing Mode
If the first parameter after `args` is a compile-time `bool` set to `true`, the parser is configured in strict POSIX mode. Option-seeking terminates immediately upon encountering the first raw positional argument. Any subsequent flags are treated as positional arguments.

```c3
bool verbose = false;
String[3] positionals = {};

argparse::@parse(args, true,
	"v", "verbose", "Verbose mode", &verbose,
	&positionals
);
```

### 6. Positional Arguments Capture
If a final trailing argument (not part of a triplet or quartet) is provided to `@parse`, it acts as a positional target array. Unhandled positional arguments are stored there in order.

```c3
String[10] positional_args = {};

argparse::@parse(args,
	"v", "verbose", "Verbose mode", &verbose,
	&positional_args // Stores up to 10 positional arguments
);
```

### 7. End-of-Options Marker (`--`)
The standard double-hyphen marker `--` disables option-parsing for any subsequent arguments. All arguments following `--` are treated strictly as positional arguments, even if they begin with a hyphen.

### 8. Subcommand Routing
If `@parse` is called without specifying a final positional target array, option parsing terminates immediately upon reaching the first raw positional argument. The macro then returns the index of that unhandled argument. 

This enables robust multi-command routing by letting you slice the arguments array at the returned index and pass the slice to subcommand-specific parsers.

```c3
bool verbose, help;

sz? parse_res = argparse::@parse(args,
	"h*", "help*", "Show help manual", &help,
	"v", "verbose", "Verbose mode",    &verbose
);

if (catch err = parse_res)
{
	// If help was requested, append the subcommand "help" before exiting
	if (err == argparse::HELP_REQUESTED)
	{
		io::printfn("\nCommands:");
		io::printfn("  build       Optimize and compile the project");
		io::printfn("  run         Execute the project binary");
		return 0;
	}
	return 1;
}

if (parse_res < args.len)
{
	switch (args[parse_res])
	{
		case "build": return handle_build(args[parse_res..]);
		case "run":   return handle_run(args[parse_res..]);
		default:      io::eprintfn("Unknown command: %s", args[parse_res]); return 1;
	}
}
```

---

## Low-Level API: `ArgParser`

For manual or non-standard argument processing, you can bypass the compile-time macro and use the zero-allocation `ArgParser` struct directly.

```c3
import std;

fn void main(String[] args)
{
	ArgParser parser;
	parser.init(args);

	bool verbose = false;
	bool is_option;

	while (try token = parser.next(&is_option))
	{
		if (is_option)
		{
			switch (token)
			{
				case "h": case "help":
					io::printfn("Usage: %s [-v | --verbose] [files...]", args[0]);
					return;
				case "v": case "verbose":
					verbose = true;
				default:
					io::eprintfn("Error: Unknown option '--%s'.", token);
					if (parser.has_value()) (void)parser.consume_value();
					return;
			}
		}
		else
		{
			io::printfn("Processing positional: %s", token);
		}
	}

	io::printfn("Running with verbose = %b", verbose);
}
```
*>
module std::os::argparse;

import std::io, std::os::env;

faultdef
	MISSING_ARGUMENT,
	ILLEGAL_OPTION,
	HELP_REQUESTED,
	OUT_OF_BOUNDS,
	INVALID_VALUE,
	INVALID_ENUM_VALUE,
	END_OF_ARGS;

int option_col_width     = 15;
int short_only_col_width = 20;

const String ENV_FALLBACK_PREFIX = "=env:";

String last_opt;

struct ArgParser
{
	String[] args;
	sz index;
	String short_remain;
	String pending_value;
	bool has_pending_value;
	bool strict_mode;
	bool stop_options;
}

fn void ArgParser.init(ArgParser* self, String[] args, bool strict_mode = false)
{
	*self = {
		.args = args,
		.index = 1,
		.strict_mode = strict_mode
	};
}

fn String? ArgParser.next(ArgParser* self, bool* is_option)
{
	*is_option = false;

	if (self.short_remain.len > 0)
	{
		String opt = self.short_remain[:1];
		self.short_remain = self.short_remain[1..];
		*is_option = true;
		return opt;
	}

	if (self.index >= self.args.len) return END_OF_ARGS~;

	String arg = self.args[self.index];

	if (arg == "--")
	{
		self.index++;
		self.stop_options = true;
		if (self.index >= self.args.len) return END_OF_ARGS~;
		arg = self.args[self.index];
	}

	if (self.stop_options)
	{
		self.index++;
		return arg;
	}

	if (arg.starts_with("--"))
	{
		self.index++;
		*is_option = true;
		String opt_part = arg[2..];
		if (try eq_idx = opt_part.index_of_char('='))
		{
			self.pending_value = opt_part[eq_idx + 1..];
			self.has_pending_value = true;
			return opt_part[:eq_idx];
		}
		return opt_part;
	}

	// Avoid treating negative numbers as options
	if (arg.starts_with("-") && arg.len > 1 && (arg[1] < '0' || arg[1] > '9'))
	{
		self.index++;
		*is_option = true;
		self.short_remain = arg[2..];
		return arg[1:1];
	}

	if (self.strict_mode) self.stop_options = true;
	self.index++;
	return arg;
}

fn bool ArgParser.has_value(ArgParser* self)
{
	if (self.has_pending_value) return true;
	if (self.short_remain.len > 0) return true;
	if (self.index >= self.args.len) return false;

	String next_arg = self.args[self.index];
	if (next_arg.starts_with("-"))
	{
		// If it's a single "-" or a negative number (like "-10"), it is a valid value
		if (next_arg.len == 1 || (next_arg[1] >= '0' && next_arg[1] <= '9'))
		{
			return true;
		}
		return false;
	}
	return true;
}

fn String? ArgParser.consume_value(ArgParser* self)
{
	switch
	{
		case self.has_pending_value:
			self.has_pending_value = false;
			return self.pending_value;

		case self.short_remain.len > 0:
			defer self.short_remain = "";
			return self.short_remain;

		case self.index >= self.args.len:
			return MISSING_ARGUMENT~;
	}

	defer self.index++;
	return self.args[self.index];
}

<* Parses a string to a primitive type. *>
macro void? @parse_value(String val_str, $Type, #assignee) @local
{
	$switch ($Type):
		$case int:
		$case short:
			#assignee = ($Type)(val_str.to_int() ?? INVALID_VALUE~!);
		$case uint:
		$case ushort:
			#assignee = ($Type)(val_str.to_uint() ?? INVALID_VALUE~!);
		$case long:
			#assignee = val_str.to_long() ?? INVALID_VALUE~!;
		$case ulong:
			#assignee = val_str.to_ulong() ?? INVALID_VALUE~!;
		$case float:
			#assignee = val_str.to_float() ?? INVALID_VALUE~!;
		$case double:
			#assignee = val_str.to_double() ?? INVALID_VALUE~!;
		$case String:
			#assignee = val_str;
		$case bool:
			#assignee = (val_str == "true" || val_str == "1");
		$default:
			$error "Type `" +++ $Type::name +++ "` is unsupported by the standard option parser.";
	$endswitch
}

const int QUALIFIER_LEN @private = 1;

struct UnpackedOption @private
{
	String short_raw;
	String long_raw;
	String desc;
	int assignee_offset;
	int stride;
}

<* Checks if a flag string is a long option name rather than a short flag. *>
macro bool @is_long_option_name($name) @private
{
	return !($name.len <= QUALIFIER_LEN ||| ($name.len == QUALIFIER_LEN + 1 &&& @in($name[1], '*', '+', '?')));
}

<* Checks if an index in $vaarg is a pointer or callback assignee. *>
macro bool @is_assignee(int $idx, ...) @private
{
	return $idx < $vaarg.len &&& (@kindof($vaarg[$idx]) == POINTER ||| @kindof($vaarg[$idx]) == FUNC);
}

<* Safely retrieves an argument string from $vaarg or empty string if out of bounds. *>
macro String @get_arg(int $idx, ...) @private
{
	return $idx < $vaarg.len ??? $vaarg[$idx] : "";
}

<* Unpacks 2, 3, or 4-element option tuples from $vaarg starting at index $start_idx. *>
macro UnpackedOption @unpack_option(int $start_idx, ...) @private
{
	String $short_raw = @get_arg($start_idx, ...$vaarg);
	String $long_raw;
	String $desc;
	int $assignee_offset;
	int $stride;

	$switch:
		$case @is_assignee($start_idx + 1, ...$vaarg):
			$assignee_offset = 1;
			$stride = 2;
			$if @is_long_option_name($short_raw):
				$long_raw = $short_raw;
				$short_raw = "";
			$else
				$long_raw = "";
			$endif

		$case @is_assignee($start_idx + 2, ...$vaarg):
			$assignee_offset = 2;
			$stride = 3;
			$if @is_long_option_name($short_raw):
				$desc = @get_arg($start_idx + 1, ...$vaarg);
				$long_raw = $short_raw;
				$short_raw = "";
			$else
				$long_raw = @get_arg($start_idx + 1, ...$vaarg);
			$endif

		$default:
			$assignee_offset = 3;
			$stride = 4;
			$long_raw = @get_arg($start_idx + 1, ...$vaarg);
			$desc = @get_arg($start_idx + 2, ...$vaarg);
	$endswitch

	return {
		.short_raw = $short_raw,
		.long_raw = $long_raw,
		.desc = $desc,
		.assignee_offset = $assignee_offset,
		.stride = $stride
	};
}

struct OptionMeta @private
{
	bool is_help;
	bool is_inc;
	bool is_opt;
	String short_clean;
	String long_opt_name;
	String env_var_name;
	bool has_env_fallback;
}

<* Extracts and cleans option metadata from raw flags at compile-time. *>
macro OptionMeta @clean_option_meta($short_raw, $long_raw) @private
{
	bool $is_help = ($short_raw.len > 0 &&& $short_raw[^1] == '*') ||| ($long_raw.len > 0 &&& $long_raw[^1] == '*');
	bool $is_inc  = ($short_raw.len > 0 &&& $short_raw[^1] == '+') ||| ($long_raw.len > 0 &&& $long_raw[^1] == '+');
	bool $is_opt  = ($short_raw.len > 0 &&& $short_raw[^1] == '?') ||| ($long_raw.len > 0 &&& $long_raw[^1] == '?');
	bool $has_qualifier = $is_help ||| $is_inc ||| $is_opt;

	String $short_clean = $has_qualifier ??? ($short_raw.len > 0 ??? $short_raw[:$short_raw.len - QUALIFIER_LEN] : "") : $short_raw;
	String $long_clean  = $has_qualifier ??? ($long_raw.len > 0 ??? $long_raw[:$long_raw.len - QUALIFIER_LEN] : "") : $long_raw;

	String $long_opt_name = $long_clean;
	String $env_var_name;
	bool $has_env_fallback;

	$if $long_clean.len > ENV_FALLBACK_PREFIX.len:
		$for int $e_idx = 0; $e_idx < $long_clean.len - (ENV_FALLBACK_PREFIX.len - 1); ++$e_idx:
			$if $long_clean[$e_idx : ENV_FALLBACK_PREFIX.len] == ENV_FALLBACK_PREFIX:
				$has_env_fallback = true;
				$long_opt_name = $long_clean[:$e_idx];
				$env_var_name = $long_clean[$e_idx + ENV_FALLBACK_PREFIX.len..];
			$endif
		$endfor
	$endif

	return {
		.is_help = $is_help,
		.is_inc = $is_inc,
		.is_opt = $is_opt,
		.short_clean = $short_clean,
		.long_opt_name = $long_opt_name,
		.env_var_name = $env_var_name,
		.has_env_fallback = $has_env_fallback
	};
}

<* Validates an option's qualifier against its assignee type at compile-time. *>
macro void @validate_option($short_raw, $long_raw, $assignee_kind) @private
{
	bool $is_inc = ($short_raw.len > 0 &&& $short_raw[^1] == '+') ||| ($long_raw.len > 0 &&& $long_raw[^1] == '+');
	$if $is_inc &&& $assignee_kind == BOOL:
		$error "Option '" +++ ($long_raw.len > 0 ??? $long_raw : $short_raw) +++ "' uses incremental '+' qualifier, but assignee is `bool*`. Use an integer type (e.g. `int`) instead.";
	$endif
}

<* Parses and maps a string value to an Enum type safely. *>
macro void? @parse_enum(String val, $TargetType, #assignee) @private
{
	bool enum_matched;
	$for int $e = 0; $e < $TargetType::len; ++$e:
		if (!enum_matched && val.compare_to_ignore_case($TargetType::names[$e]) == 0)
		{
			#assignee = $TargetType::values[$e];
			enum_matched = true;
		}
	$endfor

	if (!enum_matched)
	{
		int? ordinal = val.to_int();
		if (try ord = ordinal)
		{
			if (ord >= 0 && ord < $TargetType::len)
			{
				#assignee = $TargetType::from_ordinal(ord);
				enum_matched = true;
			}
		}
	}

	if (!enum_matched) return INVALID_ENUM_VALUE~;
	return;
}

<*
 @param #args : "The command-line argument slice (typically String[] args from main)."
 @return "On success, the index of the first argument that was not handled (not consumed as a flag or flag value). On failure, returns a parsing fault or HELP_REQUESTED."
 @require $defined(String[] a = #args) : "Expected '#args' to be compatible with String[]"
*>
macro sz? @parse(#args, ...)
{
	bool $strict_mode;
	int $vaarg_start;
	$if @kindof($vaarg[0]) == BOOL:
		$strict_mode = $vaarg[0];
		$vaarg_start = 1;
	$endif

	int $total_options;
	bool $has_positional_target;
	int $positional_idx = -1;
	int $i = $vaarg_start;

	$for ; $i < $vaarg.len; :
		$if $i == $vaarg.len - 1 &&& (@kindof($vaarg[$i]) == POINTER ||| @kindof($vaarg[$i]) == FUNC):
			$positional_idx = $i;
			$has_positional_target = true;
			$i++;
		$else
			UnpackedOption $unpacked = @unpack_option($i, ...$vaarg);
			int $assignee_idx = $i + $unpacked.assignee_offset;
			$if $assignee_idx >= $vaarg.len:
				$error "Invalid arguments to `@parse`: missing assignee pointer for option '" +++ $vaarg[$i] +++ "'.";
			$else
				$if @kindof($vaarg[$assignee_idx]) == POINTER:
					@validate_option($unpacked.short_raw, $unpacked.long_raw, @kindof(*$vaarg[$assignee_idx]));
				$else
					$if @kindof($vaarg[$assignee_idx]) != FUNC:
						$error "Invalid arguments to `@parse`: expected assignee pointer or callback for option '" +++ $vaarg[$i] +++ "', but got '" +++ $Typeof($vaarg[$assignee_idx])::name +++ "'.";
					$endif
				$endif
			$endif
			$total_options++;
			$i += $unpacked.stride;
		$endif
	$endfor

	int $options_end = $has_positional_target ? $vaarg.len - 1 : $vaarg.len;

	ArgParser parser;
	parser.init(#args, $strict_mode);

	sz[$total_options > 0 ??? $total_options : 1] array_indexes = {};
	bool[$total_options > 0 ??? $total_options : 1] option_parsed = {};
	sz positional_index = 0;
	bool print_def = false;

	bool is_opt;
	while (try opt = parser.next(&is_opt))
	{
		if (is_opt)
		{
			last_opt = opt;
			bool option_matched = false;

			int $opt_idx;
			int $j = $vaarg_start;
			$for ; $j < $options_end; :
				int $curr_j = $j;
				UnpackedOption $unpacked = @unpack_option($curr_j, ...$vaarg);
				String $short_raw = $unpacked.short_raw;
				String $long_raw = $unpacked.long_raw;
				String $desc = $unpacked.desc;
				int $assignee_offset = $unpacked.assignee_offset;
				$j += $unpacked.stride;

				OptionMeta $meta = @clean_option_meta($short_raw, $long_raw);

				if (($meta.short_clean.len > 0 && opt == $meta.short_clean) || ($meta.long_opt_name.len > 0 && opt == $meta.long_opt_name))
				{
					option_matched = true;
					option_parsed[$opt_idx] = true;

					$switch:
						$case $meta.is_help:
							// Print help menu
							io::printfn("Usage: %s [options]", #args[0]);
							io::printfn("Options:");
							int $h_idx = $vaarg_start;
							$for ; $h_idx < $options_end; :
								int $curr_h = $h_idx;
								UnpackedOption $h_unpacked = @unpack_option($curr_h, ...$vaarg);
								String $h_short = $h_unpacked.short_raw;
								String $h_long = $h_unpacked.long_raw;
								String $h_desc = $h_unpacked.desc;
								int $h_assignee_offset = $h_unpacked.assignee_offset;
								$h_idx += $h_unpacked.stride;

								OptionMeta $h_meta = @clean_option_meta($h_short, $h_long);

								// Print aligned option strings
								switch
								{
									case $h_meta.short_clean.len > 0 && $h_meta.long_opt_name.len > 0:
										io::printf("  -%s, --%-*s ", $h_meta.short_clean, option_col_width, $h_meta.long_opt_name);
									case $h_meta.short_clean.len > 0:
										io::printf("  -%-*s ", short_only_col_width, $h_meta.short_clean);
									case $h_meta.long_opt_name.len > 0:
										io::printf("      --%-*s ", option_col_width, $h_meta.long_opt_name);
								}

								$switch:
									$case @kindof($vaarg[$curr_h + $h_assignee_offset]) == FUNC:
										io::printfn("%s", $h_desc);
									$default:
										var $HType = $Typeof(*$vaarg[$curr_h + $h_assignee_offset]);
										print_def = true;

										$switch ($HType::kind):
											$case BOOL:
												print_def = *$vaarg[$curr_h + $h_assignee_offset];
											$case ARRAY:
												print_def = false;
												foreach (elem : *$vaarg[$curr_h + $h_assignee_offset])
												{
													var $ElemType = $Typeof(elem);
													$if $ElemType == String:
														if (elem.len > 0) print_def = true;
													$else
														if (elem != 0) print_def = true;
													$endif
												}
											$default:
												$if $HType == String:
													print_def = (*$vaarg[$curr_h + $h_assignee_offset]).len > 0;
												$endif
										$endswitch

										if (print_def)
										{
											$if $HType == String:
												io::printfn("%s (default: \"%s\")", $h_desc, *$vaarg[$curr_h + $h_assignee_offset]);
											$else
												io::printfn("%s (default: %s)", $h_desc, *$vaarg[$curr_h + $h_assignee_offset]);
											$endif
										}
										else
										{
											io::printfn("%s", $h_desc);
										}
								$endswitch
							$endfor
							return HELP_REQUESTED~;

						$case $meta.is_inc:
							(*$vaarg[$curr_j + $assignee_offset])++;

						$case @kindof($vaarg[$curr_j + $assignee_offset]) == FUNC:
							($vaarg[$curr_j + $assignee_offset])(parser.consume_value()!)!;

						$default:
							var $TargetType = $Typeof(*$vaarg[$curr_j + $assignee_offset]);

							$switch ($TargetType::kind):
								$case ARRAY:
									sz idx = array_indexes[$opt_idx]++;
									if (idx >= (*$vaarg[$curr_j + $assignee_offset]).len) return OUT_OF_BOUNDS~;
									var $ElementType = $Typeof((*$vaarg[$curr_j + $assignee_offset])[0]);
									@parse_value(parser.consume_value(), $ElementType, (*$vaarg[$curr_j + $assignee_offset])[idx])!;

								$case ENUM:
									@parse_enum(parser.consume_value(), $TargetType, *$vaarg[$curr_j + $assignee_offset])!;

								$case BOOL:
									bool flag_val = true;
									$if $meta.is_opt:
										if (parser.has_value())
										{
											String val = parser.consume_value()!;
											flag_val = (val == "true" || val == "1");
										}
									$endif
									*$vaarg[$curr_j + $assignee_offset] = flag_val;

								$default:
									$if $meta.is_opt:
										if (parser.has_value()) @parse_value(parser.consume_value(), $TargetType, *$vaarg[$curr_j + $assignee_offset])!;
									$else
										@parse_value(parser.consume_value(), $TargetType, *$vaarg[$curr_j + $assignee_offset])!;
									$endif
							$endswitch
					$endswitch
				}

				$opt_idx++;
			$endfor

			if (!option_matched) return ILLEGAL_OPTION~;
		}
		else
		{
			$if $has_positional_target:
				var pos_target = $vaarg[$positional_idx];
				if (positional_index < (*pos_target).len)
				{
					(*pos_target)[positional_index++] = opt;
				}
				else
				{
					return OUT_OF_BOUNDS~;
				}
			$else
				return parser.index - 1;
			$endif
		}
	}

	// Apply environment fallbacks for any unparsed options
	int $fallback_idx;
	int $k = $vaarg_start;
	$for ; $k < $options_end; :
		int $curr_k = $k;
		UnpackedOption $k_unpacked = @unpack_option($curr_k, ...$vaarg);
		String $short_raw = $k_unpacked.short_raw;
		String $long_raw = $k_unpacked.long_raw;
		int $assignee_offset = $k_unpacked.assignee_offset;
		$k += $k_unpacked.stride;

		OptionMeta $k_meta = @clean_option_meta($short_raw, $long_raw);

		$if $k_meta.has_env_fallback:
			if (!option_parsed[$fallback_idx])
			{
				String? env_val = env::tget_var($k_meta.env_var_name);
				if (try val = env_val)
				{
					$switch:
						$case @kindof($vaarg[$curr_k + $assignee_offset]) == FUNC:
							($vaarg[$curr_k + $assignee_offset])(val)!;
						$default:
							var $TargetType = $Typeof(*$vaarg[$curr_k + $assignee_offset]);
							$switch ($TargetType::kind):
								$case ARRAY:
									sz idx = array_indexes[$fallback_idx]++;
									if (idx < (*$vaarg[$curr_k + $assignee_offset]).len)
									{
										var $ElementType = $Typeof((*$vaarg[$curr_k + $assignee_offset])[0]);
										@parse_value(val, $ElementType, (*$vaarg[$curr_k + $assignee_offset])[idx])!;
									}
								$case BOOL:
									*$vaarg[$curr_k + $assignee_offset] = (val == "true" || val == "1");
								$case ENUM:
									@parse_enum(val, $TargetType, *$vaarg[$curr_k + $assignee_offset])!;
								$default:
									@parse_value(val, $TargetType, *$vaarg[$curr_k + $assignee_offset])!;
							$endswitch
					$endswitch
				}
			}
		$endif

		$fallback_idx++;
	$endfor

	return parser.index;
}
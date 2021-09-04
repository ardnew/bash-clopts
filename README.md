# bash-clopts
#### Simple GNU Bash 4.x function to parse command-line options

## Usage

Calling function `clopts` with the arguments you want to parse will potentially perform two operations:

1. For each single-letter option `-X` found in the given arguments, an environment variable named `opt_X` is exported, and its value is set to the given non-option argument immediately following it (if any). If there is no following argument, or it is also a single-letter option, then its value is set to `1`. Option parsing stops at first occurrence of `--`. 
2. All arguments that are not single-letter options, or arguments to these options, are printed verbatim to stdout.

You can test if an option was found in the given arguments with the something like the following, which correctly handles the case where an empty string was given as argument to the option: 

```bash
if [[ ! -z ${opt_X++} ]]; then
  # flag -X was given, possibly with or without an argument (which may be empty)
  echo "opt_X found = ${opt_X}"
fi
```

### Examples

```bash
$ clopts -x foo -y -z ""
$ declare -p opt_x opt_y opt_z opt_a
declare -- opt_x="foo"
declare -- opt_y="1"
declare -- opt_z=""
bash: declare: opt_a: not found
```

```bash
$ clopts -x foo bar -y -- -z baz
bar -z baz
$ declare -p opt_x opt_y opt_z opt_a
declare -- opt_x="foo"
declare -- opt_y="1"
bash: declare: opt_z: not found
bash: declare: opt_a: not found
```

## Installation

Just place the function `clopts` defined in [`clopts.bash`](clopts.bash) in some file sourced by your shell (e.g., `~/.bashrc`, `~/bash_functions`, etc.), or source the file manually in your script:

```bash
. /path/to/clopts.bash
```

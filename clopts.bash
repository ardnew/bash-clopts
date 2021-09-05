#!/bin/bash

# clopts parses the given arguments for single-letter command-line options,
# and exports environment variables with names of the form "opt_X" for each
# option found, with each value equal to its corresponding argument. A value
# of 1 is used for flags without arguments. 
# All remaining non-option arguments are output to stdout.
clopts() {

	local -a arg

	while [[ ${#} -gt 0 ]]; do
		case "${1}" in

			-[a-zA-Z0-9])
				# Create a nameref to a variable whose name matches current token, but
				# prepended with "opt_".
				local -n opt="opt_${1#-}"
				shift
				# Check if this was the last token or the next token appears to be yet
				# another option. In both cases, the option accepts no argument.
				#   - This was the last token if no tokens remain, or if the next token
				#     is exactly equal to the string '--'.
				if [[ ${#} -eq 0 ]] || [[ "${1}" =~ ^-[a-zA-Z0-9\-]$ ]]; then
					# Set the option flag (which accept no arguments) value to 1.
					opt=1
				else
					# Otherwise, the flag accepts an argument, set the current option's
					# value to the next token.
					opt=${1}
					shift
				fi
				;;

			--)
				# Stop processing if we find end-of-arguments token '--'.
				shift # Consume the token.
				break
				;;

			*)
				# Append all non-option tokens to the array of arguments.
				arg+=( "${1}" )
				shift
				;;

		esac
	done

	# Append any remaining tokens to the array of arguments.
	while [[ ${#} -gt 0 ]]; do
		arg+=( "${1}" )
		shift
	done

	# Output the unprocessed args. The parsed flags are set in the caller's env,
	# so if they want a flag, test if it exists and use it: 
	#   [[ -n ${opt_X+?} ]] && echo "flag -X exists (possibly empty): [${opt_X}]"
	[[ ${#arg[@]} -gt 0 ]] && 
		printf -- '%s\n' "${arg[@]}"
		
	return 0
}

#! /usr/bin/awk -f
#
# Execuded with TRAVIS using command
# find . -path "*.dm" | grep .dm | awk '{sCall = "./tools/indentation.awk \""$0"\"";system(sCall)}'
#
#
# Finds incorrect indentation of absolute path definitions in DM code
# For example, the following fails on the indicated line:
#
#/datum/path/foo
#	x = "foo"
# /datum/path/bar // FAIL
#	x = "bar"
#
# Updated to also find aditional commas in lists and fixed reporting commented lines as errors
##These will pass
#/datum/path/var/list(
#	/type/path1, //comment
#	/type/path2, /*comment */
#	/type/path3
#	)
#/datum/path/var/list(
#	/type/path1,
#	/type/path1)
#
##These fail due to the extra , on the last entry
#/datum/path/var/list(
# /type/path,
#	/type/path2,
#	)
#/datum/path/var/list(
# /type/path,
#	/type/path2,)
#
{
	# update the line counter
	if (curFile != FILENAME) {
		curLine = 1
		curFile = FILENAME
	} else {
		curLine++
	}

	if ( comma != 1 ) { # No comma/'list('/etc at the end of the previous line
		if ( $0 ~ /^[\t ]+\/[^\/*]/ ) { # Current line's first non-whitespace character is a slash, followed by something that is not another slash or an asterisk
			print "Extra whitespace in path definition:", FILENAME, "line:"curLine
			print "("$0")"
			fail = 1
		}
	} else {
		# Is this the end of a list
		if ( $0 ~ /^[\t ]*\)[\t ]*(\/\/|\r?$)/ ) {
			print "Unexpected comma at end of list:", FILENAME, "line:"curLine
			print "("PREVIOUSLINE")"
			fail = 1
		}
	}

	if ( $0 ~ /,[\t ]*\/\/|,[\t ]*\\?\r?$/ || # comma at EOL
	    ( $0 ~ /,[\t ]*?\/\*/ && $0 ~ /\*\/\r?$/ ) || # comma at EOL that's followed by an enclosed comment
	    $0 ~ /list[\t ]*\([\t ]*\\?\r?$/ || # start of a list()
	    $0 ~ /pick[\t ]*\([\t ]*\\?\r?$/ ) { # start of a pick()
		comma = 1
	} else {
		comma = 0
	}
	PREVIOUSLINE = $0 #Used for end of list error report
}

END {
	if ( fail ) {
		exit 1
	}
}

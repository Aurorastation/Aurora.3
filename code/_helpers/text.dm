#define SMALL_FONTS(FONTSIZE, MSG) "<span style=\"font-family: 'Small Fonts'; -dm-text-outline: 1 black; font-size: [FONTSIZE]px;\">[MSG]</span>"

/// Macro from Lummox used to get height from a MeasureText proc
#define WXH_TO_HEIGHT(x) text2num(copytext(x, findtextEx(x, "x") + 1))

#define SPAN_RED(x) "<span style='color:[COLOR_RED]'>[x]</span>"
#define SPAN_YELLOW(x) "<span style='color:[COLOR_YELLOW]'>[x]</span>"
#define SPAN_GREEN(x) "<span style='color:[COLOR_GREEN]'>[x]</span>"

/*
 * Holds procs designed to help with filtering text
 * Contains groups:
 *			SQL sanitization
 *			Text sanitization
 *			Text searches
 *			Text modification
 *			Misc
 */


/*
 * SQL sanitization
 */

// Run all strings to be used in an SQL query through this proc first to properly escape out injection attempts.
/proc/sanitizeSQL(var/t as text)
	var/sqltext = dbcon.Quote(t);
	return copytext_char(sqltext, 2, length(sqltext));//Quote() adds quotes around input, we already do that

/*
 * Text sanitization
 */

//Used for preprocessing entered text
/proc/sanitize(var/input, var/max_length = MAX_MESSAGE_LEN, var/encode = 1, var/trim = 1, var/extra = 1)
	if(!input)
		return

	if(max_length)
		input = copytext_char(input, 1, max_length)

	if(extra)
		input = replace_characters(input, list("\n"=" ","\t"=" "))

	if(encode)
		// The below \ escapes have a space inserted to attempt to enable Travis auto-checking of span class usage. Please do not remove the space.
		//In addition to processing html, html_encode removes byond formatting codes like "\ red", "\ i" and other.
		//It is important to avoid double-encode text, it can "break" quotes and some other characters.
		//Also, keep in mind that escaped characters don't work in the interface (window titles, lower left corner of the main window, etc.)
		input = html_encode(input)
	else
		//If not need encode text, simply remove < and >
		//note: we can also remove here byond formatting codes: 0xFF + next byte
		input = replace_characters(input, list("<"=" ", ">"=" "))

	if(trim)
		//Maybe, we need trim text twice? Here and before copytext?
		input = trim(input)

	return input

//Run sanitize(), but remove <, >, " first to prevent displaying them as &gt; &lt; &34; in some places, after html_encode().
//Best used for sanitize object names, window titles.
//If you have a problem with sanitize() in chat, when quotes and >, < are displayed as html entites -
//this is a problem of double-encode(when & becomes &amp;), use sanitize() with encode=0, but not the sanitizeSafe()!
/proc/sanitizeSafe(var/input, var/max_length = MAX_MESSAGE_LEN, var/encode = 1, var/trim = 1, var/extra = 1)
	return sanitize(replace_characters(input, list(">"=" ","<"=" ", "\""="'")), max_length, encode, trim, extra)

/proc/sanitize_simple(t,list/repl_chars = list("\n"="#","\t"="#"))
	for(var/char in repl_chars)
		var/index = findtext(t, char)
		while(index)
			t = copytext(t, 1, index) + repl_chars[char] + copytext(t, index + length(char))
			index = findtext(t, char, index + length(char))
	return t

/proc/sanitize_filename(t)
	return sanitize_simple(t, list("\n"="", "\t"="", "/"="", "\\"="", "?"="", "%"="", "*"="", ":"="", "|"="", "\""="", "<"="", ">"=""))

#define NO_CHARS_DETECTED 0
#define SPACES_DETECTED 1
#define SYMBOLS_DETECTED 2
#define NUMBERS_DETECTED 3
#define LETTERS_DETECTED 4
#define SYMBOLS_DETECTED_NEW_WORD 5 // symbols that we will interpret as the start of a new word

/**
  * Filters out undesirable characters from names.
  *
  * * allow_numbers - allows numbers and common special characters - used for silicon/other weird things names
  */

/proc/sanitizeName(input, max_length = MAX_NAME_LEN, allow_numbers = TRUE)
	if(!input)
		return //Rejects the input if it is null

	var/number_of_alphanumeric = 0
	var/last_char_group = NO_CHARS_DETECTED
	var/output = ""
	var/t_len = length_char(input)
	var/charcount = 0
	var/char = ""

	// This is a sanity short circuit, if the users name is three times the maximum allowable length of name
	// We bail out on trying to process the name at all, as it could be a bug or malicious input and we dont
	// Want to iterate all of it.
	if(t_len > 3 * MAX_NAME_LEN)
		return
	for(var/i = 1, i <= t_len, i += length_char(char))
		char = input[i]
		switch(text2ascii_char(char))

			// A  .. Z
			if(65 to 90)   //Uppercase Letters
				number_of_alphanumeric++
				last_char_group = LETTERS_DETECTED

			// a  .. z
			if(97 to 122)   //Lowercase Letters
				if(last_char_group == NO_CHARS_DETECTED || last_char_group == SPACES_DETECTED || last_char_group == SYMBOLS_DETECTED_NEW_WORD) //start of a word
					char = uppertext(char)
				number_of_alphanumeric++
				last_char_group = LETTERS_DETECTED

			// 0  .. 9
			if(48 to 57)   //Numbers
				if(last_char_group == NO_CHARS_DETECTED || !allow_numbers) //suppress at start of string
					continue
				number_of_alphanumeric++
				last_char_group = NUMBERS_DETECTED

			// '  -
			if(39,45)   //Common name punctuation
				if(last_char_group == NO_CHARS_DETECTED)
					continue
				last_char_group = SYMBOLS_DETECTED

			// ~   |   @  :  #  $  %  &  *  + .
			if(126,124,64,58,35,36,37,38,42,43,46)			//Other symbols that we'll allow (mainly for AI)
				if(last_char_group == NO_CHARS_DETECTED || !allow_numbers) //suppress at start of string
					continue
				last_char_group = SYMBOLS_DETECTED_NEW_WORD

			//Space
			if(32)
				if(last_char_group == NO_CHARS_DETECTED || last_char_group == SPACES_DETECTED) //suppress double-spaces and spaces at start of string
					continue
				last_char_group = SPACES_DETECTED

			if(127 to INFINITY)
				return

			else
				continue
		output += char
		charcount++
		if(charcount >= max_length)
			break

	if(number_of_alphanumeric < 2)
		return //protects against tiny names like "A" and also names like "' ' ' ' ' ' ' '"

	if(last_char_group == SPACES_DETECTED)
		output = copytext_char(output, 1, -1) //removes the last character (in this case a space)

	for(var/bad_name in list("space","floor","wall","r-wall","monkey","unknown","inactive ai","plating"))	//prevents these common metagamey names
		if(cmptext(output,bad_name))
			return	//(not case sensitive)

	return output

/proc/sanitize_readd_odd_symbols(var/input)
	input = replacetext(input, "&#39;", "\'")
	input = replacetext(input, "&#34;", "\"")
	return input

#undef NO_CHARS_DETECTED
#undef SPACES_DETECTED
#undef SYMBOLS_DETECTED
#undef NUMBERS_DETECTED
#undef LETTERS_DETECTED
#undef SYMBOLS_DETECTED_NEW_WORD

//Returns null if there is any bad text in the string
/proc/reject_bad_text(text, max_length=512)
	if(length_char(text) > max_length)	return			//message too long
	var/non_whitespace = 0
	for(var/i=1, i<=length_char(text), i++)
		switch(text2ascii_char(text,i))
			if(62,60,92,47)	return			//rejects the text if it contains these bad characters: <, >, \ or /
			if(127 to 255)	return			//rejects weird letters like �
			if(0 to 31)		return			//more weird stuff
			if(32)			continue		//whitespace
			else			non_whitespace = 1
	if(non_whitespace)		return text		//only accepts the text if it has some non-spaces


//Old variant. Haven't dared to replace in some places.
/proc/sanitize_old(var/t,var/list/repl_chars = list("\n"="#","\t"="#"))
	return html_encode(replace_characters(t,repl_chars))

// Truncates text to limit if necessary.
/proc/dd_limittext(message, length)
	var/size = length(message)
	if (size <= length)
		return message
	else
		return copytext(message, 1, length + 1)

/*
 * Text searches
 */

//Checks the beginning of a string for a specified sub-string
//Returns the position of the substring or 0 if it was not found
/proc/dd_hasprefix(text, prefix)
	var/start = 1
	var/end = length(prefix) + 1
	return findtext_char(text, prefix, start, end)

//Checks the beginning of a string for a specified sub-string. This proc is case sensitive
//Returns the position of the substring or 0 if it was not found
/proc/dd_hasprefix_case(text, prefix)
	var/start = 1
	var/end = length(prefix) + 1
	return findtextEx_char(text, prefix, start, end)

//Checks the end of a string for a specified substring.
//Returns the position of the substring or 0 if it was not found
/proc/dd_hassuffix(text, suffix)
	var/start = length(text) - length(suffix)
	if(start)
		return findtext_char(text, suffix, start, null)
	return

//Checks the end of a string for a specified substring. This proc is case sensitive
//Returns the position of the substring or 0 if it was not found
/proc/dd_hassuffix_case(text, suffix)
	var/start = length(text) - length(suffix)
	if(start)
		return findtextEx_char(text, suffix, start, null)


//Parses a string into a list
/proc/dd_text2List(text, separator)
	var/textlength      = length_char(text)
	var/separatorlength = length_char(separator)
	var/list/textList   = new /list()
	var/searchPosition  = 1
	var/findPosition    = 1
	var/buggyText
	while (1)															// Loop forever.
		findPosition = findtextEx_char(text, separator, searchPosition, 0)
		buggyText = copytext_char(text, searchPosition, findPosition)		// Everything from searchPosition to findPosition goes into a list element.
		textList += "[buggyText]"										// Working around weird problem where "text" != "text" after this copytext().

		searchPosition = findPosition + separatorlength					// Skip over separator.
		if (findPosition == 0)											// Didn't find anything at end of string so stop here.
			return textList
		else
			if (searchPosition > textlength)							// Found separator at very end of string.
				textList += ""											// So add empty element


/*
 * Text modification
 */

/proc/replace_characters(t,list/repl_chars)
	for(var/char in repl_chars)
		t = replacetext_char(t, char, repl_chars[char])
	return t

//Adds 'u' number of zeros ahead of the text 't'
/proc/add_zero(t, u)
	while (length(t) < u)
		t = "0[t]"
	return t

//Adds 'u' number of spaces ahead of the text 't'
/proc/add_lspace(t, u)
	while(length(t) < u)
		t = " [t]"
	return t

//Adds 'u' number of spaces behind the text 't'
/proc/add_tspace(t, u)
	while(length(t) < u)
		t = "[t] "
	return t

//Returns a string with reserved characters and spaces before the first letter removed
/proc/trim_left(text)
	for (var/i = 1 to length_char(text))
		if (text2ascii_char(text, i) > 32)
			return copytext_char(text, i)
	return ""

//Returns a string with reserved characters and spaces after the last letter removed
/proc/trim_right(text)
	for (var/i = length_char(text), i > 0, i--)
		if (text2ascii_char(text, i) > 32)
			return copytext_char(text, 1, i + 1)
	return ""

//Returns a string with reserved characters and spaces before the first word and after the last word removed.
/proc/trim(text)
	return trim_left(trim_right(text))

//Returns a string with the first element of the string capitalized, ignoring html-tags
/proc/capitalize(t as text)
	var/i = 1
	while(copytext_char(t, i, i + 1) == "<")
		i = findtext_char(t, ">", i + 1)
		if(i)
			i++
		else
			i = 2
			break
	return copytext_char(t, 1, i) + uppertext(copytext_char(t, i, i + 1)) + copytext_char(t, i + 1)

//This proc strips html properly, remove < > and all text between
//for complete text sanitizing should be used sanitize()
/proc/strip_html_properly(input)
	if(!input)
		return
	var/opentag = 1 //These store the position of < and > respectively.
	var/closetag = 1
	while(1)
		opentag = findtext(input, "<")
		closetag = findtext(input, ">")
		if(closetag && opentag)
			if(closetag < opentag)
				input = copytext(input, (closetag + 1))
			else
				input = copytext(input, 1, opentag) + copytext(input, (closetag + 1))
		else if(closetag || opentag)
			if(opentag)
				input = copytext(input, 1, opentag)
			else
				input = copytext(input, (closetag + 1))
		else
			break

	return input

//This proc fills in all spaces with the "replace" var (* by default) with whatever
//is in the other string at the same spot (assuming it is not a replace char).
//This is used for fingerprints
/proc/stringmerge(text,compare,replace = "*")
	var/newtext = text
	if(length(text) != length(compare))
		return 0
	for(var/i = 1, i < length(text), i++)
		var/a = copytext(text,i,i+1)
		var/b = copytext(compare,i,i+1)
		//if it isn't both the same letter, or if they are both the replacement character
		//(no way to know what it was supposed to be)
		if(a != b)
			if(a == replace) //if A is the replacement char
				newtext = copytext(newtext,1,i) + b + copytext(newtext, i+1)
			else if(b == replace) //if B is the replacement char
				newtext = copytext(newtext,1,i) + a + copytext(newtext, i+1)
			else //The lists disagree, Uh-oh!
				return 0
	return newtext

//This proc returns the number of chars of the string that is the character
//This is used for detective work to determine fingerprint completion.
/proc/stringpercent(text,character = "*")
	if(!text || !character)
		return 0
	var/count = 0
	for(var/i = 1, i <= length(text), i++)
		var/a = copytext(text,i,i+1)
		if(a == character)
			count++
	return count

/proc/reverse_text(text = "")
	var/new_text = ""
	for(var/i = length(text); i > 0; i--)
		new_text += copytext(text, i, i+1)
	return new_text

//Used in preferences' SetFlavorText and human's set_flavor verb
//Previews a string of len or less length
/proc/TextPreview(string, len=40)
	if(length(string) <= len)
		if(!length(string))
			return "\[...\]"
		else
			return string
	else
		return "[copytext_preserve_html(string, 1, 37)]..."

//alternative copytext() for encoded text, doesn't break html entities (&#34; and other)
/proc/copytext_preserve_html(text, first, last)
	return html_encode(copytext(html_decode(text), first, last))

//For generating neat chat tag-images
//The icon var could be local in the proc, but it's a waste of resources
//	to always create it and then throw it out.
/proc/create_text_tag(var/tagname, var/client/C = null)
	if(C && (C.prefs.toggles & CHAT_NOICONS))
		return tagname

	var/list/tagname_to_class = list(
		"OOC" = "ooc",
		"LOOC" = "looc",
		"ALOOC" = "adminlooc",
		"DEV" = "dev",
		"ADMIN" = "admin",
		"MOD" = "mod",
		"DEAD" = "dead",
		"PM ->" = "pmin",
		"PM <-" = "pmout",
		"PM <->" = "pmother",
		"HELP" = "help",
		"A-OOC" = "aooc"
	)

	return "<span class=\"tag [tagname_to_class[tagname]]_tag\">[tagname]</span>"

// For processing simple markup, similar to what Skype and Discord use.
// Enabled from a config setting.
/proc/process_chat_markup(var/message, var/list/ignore_tags = list())
	if (!config.allow_chat_markup)
		return message

	if (!message)
		return ""

	// ---Begin URL caching.
	var/list/urls = list()
	var/i = 1
	while (url_find_lazy.Find_char(message))
		urls["\ref[urls]-[i]"] = url_find_lazy.match
		i++

	for (var/ref in urls)
		message = replacetextEx_char(message, urls[ref], ref)
	// ---End URL caching

	var/regex/tag_markup
	for (var/tag in (markup_tags - ignore_tags))
		tag_markup = markup_regex[tag]
		message = tag_markup.Replace_char(message, "$2[markup_tags[tag][1]]$3[markup_tags[tag][2]]$5")

	// ---Unload URL cache
	for (var/ref in urls)
		message = replacetextEx_char(message, ref, urls[ref])

	return message

//Converts New Lines to html <br>
/proc/nl2br(var/text)
	return replacetextEx_char(text,"\n","<br>")

/proc/contains_az09(input)
	for(var/i=1, i<=length(input), i++)
		var/ascii_char = text2ascii(input,i)
		switch(ascii_char)
			// A  .. Z
			if(65 to 90)			//Uppercase Letters
				return 1
			// a  .. z
			if(97 to 122)			//Lowercase Letters
				return 1

			// 0  .. 9
			if(48 to 57)			//Numbers
				return 1
	return 0

/proc/generateRandomString(length)
	. = list()
	for(var/a in 1 to length)
		var/letter = rand(33,126)
		. += ascii2text(letter)
	. = jointext(.,null)

#define starts_with(string, substring) (copytext(string,1,1+length(substring)) == substring)

#define gender2text(gender) capitalize(gender)

/**
 * Strip out the special beyond characters for \proper and \improper
 * from text that will be sent to the browser.
 */
#define strip_improper(input_text) replacetext(replacetext(input_text, "\proper", ""), "\improper", "")


/proc/pencode2html(t, limited = 0)
	t = replacetext(t, "\[b\]", "<B>")
	t = replacetext(t, "\[/b\]", "</B>")
	t = replacetext(t, "\[i\]", "<I>")
	t = replacetext(t, "\[/i\]", "</I>")
	t = replacetext(t, "\[u\]", "<U>")
	t = replacetext(t, "\[/u\]", "</U>")
	t = replacetext(t, "\[large\]", "<font size=\"4\">")
	t = replacetext(t, "\[/large\]", "</font>")
	t = replacetext(t, "\[small\]", "<font size = \"1\">")
	t = replacetext(t, "\[/small\]", "</font>")
	t = replacetext(t, "\[station\]", current_map.station_name)

	var/regex/redacted_text = new(@"(\[redacted\])(.*?)(\[\/redacted\])", "g")
	while (redacted_text.Find(t))
		var/new_content = ""
		for(var/i = 1 to length(redacted_text.group[2]))
			new_content += "|"
		t = replacetext(t, redacted_text.match, "<span class='redacted'>[new_content]</span>")

	// A break for signature customization code to use this proc as well.
	if (limited)
		return t

	t = replacetext(t, "\n", "<BR>")
	t = replacetext(t, "\[center\]", "<center>")
	t = replacetext(t, "\[/center\]", "</center>")
	t = replacetext(t, "\[br\]", "<BR>")
	t = replacetext(t, "\[field\]", "<span class=\"paper_field\"></span>")
	t = replacetext(t, "\[h1\]", "<H1>")
	t = replacetext(t, "\[/h1\]", "</H1>")
	t = replacetext(t, "\[h2\]", "<H2>")
	t = replacetext(t, "\[/h2\]", "</H2>")
	t = replacetext(t, "\[h3\]", "<H3>")
	t = replacetext(t, "\[/h3\]", "</H3>")
	t = replacetext(t, "\[*\]", "<li>")
	t = replacetext(t, "\[hr\]", "<HR>")
	t = replacetext(t, "\[list\]", "<ul>")
	t = replacetext(t, "\[/list\]", "</ul>")
	t = replacetext(t, "\[table\]", "<table border=1 cellspacing=0 cellpadding=3 style='border: 1px solid black;'>")
	t = replacetext(t, "\[/table\]", "</td></tr></table>")
	t = replacetext(t, "\[grid\]", "<table>")
	t = replacetext(t, "\[/grid\]", "</td></tr></table>")
	t = replacetext(t, "\[row\]", "</td><tr>")
	t = replacetext(t, "\[cell\]", "<td>")
	t = replacetext(t, "\[logo_scc\]", "<img src = scclogo.png>")
	t = replacetext(t, "\[logo_nt\]", "<img src = ntlogo.png>")
	t = replacetext(t, "\[logo_nt_small\]", "<img src = ntlogo_small.png>")
	t = replacetext(t, "\[logo_zh\]", "<img src = zhlogo.png>")
	t = replacetext(t, "\[logo_idris\]", "<img src = idrislogo.png>")
	t = replacetext(t, "\[logo_eridani\]", "<img src = eridanilogo.png>")
	t = replacetext(t, "\[logo_zavod\]", "<img src = zavodlogo.png>")
	t = replacetext(t, "\[logo_hp\]", "<img src = hplogo.png>")
	t = replacetext(t, "\[flag_be\]", "<img src = beflag.png>")
	t = replacetext(t, "\[flag_elyra\]", "<img src = elyraflag.png>")
	t = replacetext(t, "\[flag_sol\]", "<img src = solflag.png>")
	t = replacetext(t, "\[flag_coc\]", "<img src = cocflag.png>")
	t = replacetext(t, "\[flag_dom\]", "<img src = domflag.png>")
	t = replacetext(t, "\[flag_jargon\]", "<img src = jargonflag.png>")
	t = replacetext(t, "\[flag_pra\]", "<img src = praflag.png>")
	t = replacetext(t, "\[flag_dpra\]", "<img src = dpraflag.png>")
	t = replacetext(t, "\[flag_nka\]", "<img src = nkaflag.png>")
	t = replacetext(t, "\[flag_izweski\]", "<img src = izweskiflag.png>")
	t = replacetext(t, "\[logo_golden\]", "<img src = goldenlogo.png>")
	t = replacetext(t, "\[barcode\]", "<img src = barcode[rand(0, 3)].png>")
	t = replacetext(t, "\[time\]", "[worldtime2text()]")
	t = replacetext(t, "\[date\]", "[worlddate2text()]")
	t = replacetext(t, "\[editorbr\]", "<BR>")
	t = replacetext(t, @"[image id=([\w]*?\.[\w]*?)]", "<img style=\"display:block;width:90%;\" src = [config.docs_image_host]$1></img>")
	return t

/proc/html2pencode(t, var/include_images = FALSE)
	t = replacetext(t, "<B>", "\[b\]")
	t = replacetext(t, "</B>", "\[/b\]")
	t = replacetext(t, "<I>", "\[i\]")
	t = replacetext(t, "</I>", "\[/i\]")
	t = replacetext(t, "<U>", "\[u\]")
	t = replacetext(t, "</U>", "\[/u\]")
	t = replacetext(t, "<font size=\"4\">", "\[large\]")
	t = replacetext(t, "</font>", "\[/large\]")
	t = replacetext(t, "<font size = \"1\">", "\[small\]")
	t = replacetext(t, "</font>", "\[/small\]")
	t = replacetext(t, current_map.station_name, "\[station\]")
	t = replacetext(t, "<BR>", "\n")
	t = replacetext(t, "<center>", "\[center\]")
	t = replacetext(t, "</center>", "\[/center\]")
	t = replacetext(t, "<BR>", "\[br\]")
	t = replacetext(t, "<span class=\"paper_field\"></span>", "\[field\]")
	t = replacetext(t, "<H1>", "\[h1\]")
	t = replacetext(t, "</H1>", "\[/h1\]")
	t = replacetext(t, "<H2>", "\[h2\]")
	t = replacetext(t, "</H2>", "\[/h2\]")
	t = replacetext(t, "<H3>", "\[h3\]")
	t = replacetext(t, "</H3>", "\[/h3\]")
	t = replacetext(t, "<li>", "\[*\]")
	t = replacetext(t, "<HR>", "\[hr\]")
	t = replacetext(t, "<ul>", "\[list\]")
	t = replacetext(t, "</ul>", "\[/list\]")
	t = replacetext(t, "<table border=1 cellspacing=0 cellpadding=3 style='border: 1px solid black;'>", "\[table\]")
	t = replacetext(t, "</td></tr></table>", "\[/table\]")
	t = replacetext(t, "<table>", "\[grid\]")
	t = replacetext(t, "</td></tr></table>", "\[/grid\]")
	t = replacetext(t, "</td><tr>", "\[row\]")
	t = replacetext(t, "<td>", "\[cell\]")

	if(include_images)
		t = replacetext(t, "<img src = scclogo.png>", "\[logo_scc\]")
		t = replacetext(t, "<img src = ntlogo.png>", "\[logo_nt\]")
		t = replacetext(t, "<img src = ntlogo_small.png>", "\[logo_nt_small\]")
		t = replacetext(t, "<img src = zhlogo.png>", "\[logo_zh\]")
		t = replacetext(t, "<img src = idrislogo.png>", "\[logo_idris\]")
		t = replacetext(t, "<img src = eridanilogo.png>", "\[logo_eridani\]")
		t = replacetext(t, "<img src = zavodlogo.png>", "\[logo_zavod\]")
		t = replacetext(t, "<img src = hplogo.png>", "\[logo_hp\]")
		t = replacetext(t, "<img src = beflag.png>", "\[flag_be\]")
		t = replacetext(t, "<img src = elyraflag.png>", "\[flag_elyra\]")
		t = replacetext(t, "<img src = solflag.png>", "\[flag_sol\]")
		t = replacetext(t, "<img src = cocflag.png>", "\[flag_coc\]")
		t = replacetext(t, "<img src = domflag.png>", "\[flag_dom\]")
		t = replacetext(t, "<img src = jargonflag.png>", "\[flag_jargon\]")
		t = replacetext(t, "<img src = praflag.png>", "\[flag_pra\]")
		t = replacetext(t, "<img src = dpraflag.png>", "\[flag_dpra\]")
		t = replacetext(t, "<img src = nkaflag.png>", "\[flag_nka\]")
		t = replacetext(t, "<img src = izweskiflag.png>", "\[flag_izweski\]")
		t = replacetext(t, "<img src = goldenlogo.png>", "\[logo_golden\]")

	return t

//Used for applying byonds text macros to strings that are loaded at runtime
/proc/apply_text_macros(string)
	var/next_backslash = findtext(string, "\\")
	if(!next_backslash)
		return string

	var/leng = length(string)

	var/next_space = findtext_char(string, " ", next_backslash + 1)
	if(!next_space)
		next_space = leng - next_backslash

	if(!next_space)	//trailing bs
		return string

	var/base = next_backslash == 1 ? "" : copytext(string, 1, next_backslash)
	var/macro = lowertext(copytext(string, next_backslash + 1, next_space))
	var/rest = next_backslash > leng ? "" : copytext(string, next_space + 1)

	//See http://www.byond.com/docs/ref/info.html#/DM/text/macros
	switch(macro)
		//prefixes/agnostic
		if("the")
			rest = text("\the []", rest)
		if("a")
			rest = text("\a []", rest)
		if("an")
			rest = text("\an []", rest)
		if("proper")
			rest = text("\proper []", rest)
		if("improper")
			rest = text("\improper []", rest)
		if("roman")
			rest = text("\roman []", rest)
		//postfixes
		if("th")
			base = text("[]\th", rest)
		if("s")
			base = text("[]\s", rest)
		if("he")
			base = text("[]\he", rest)
		if("she")
			base = text("[]\she", rest)
		if("his")
			base = text("[]\his", rest)
		if("himself")
			base = text("[]\himself", rest)
		if("herself")
			base = text("[]\herself", rest)
		if("hers")
			base = text("[]\hers", rest)

	. = base
	if(rest)
		. += .(rest)

/proc/replacemany(text, list/replacements)
	if (!LAZYLEN(replacements))
		return text

	. = text

	for (var/replacement in replacements)
		. = replacetext_char(., replacement, replacements[replacement])

// Finds the first letter of each word in the provided string and capitalize them
/proc/capitalize_first_letters(var/string)
	var/list/text = splittext_char(string, " ")
	var/list/finalized_text = list()
	for(var/word in text)
		finalized_text += capitalize(word)
	return jointext(finalized_text, " ")

// makes text uppercase, makes sure it has a correct line-end symbol (ie fullstop)
/proc/formalize_text(var/string)
	string = capitalize(string)
	var/ending = copytext(string, length(string), (length(string) + 1))
	if(ending && !correct_punctuation[ending])
		string += "."
	return string

/proc/num2loadingbar(percent as num, numSquares = 20, reverse = FALSE)
	var/loadstring = ""
	var/limit = reverse ? numSquares - percent*numSquares : percent*numSquares
	for (var/i in 1 to numSquares)
		loadstring += i <= limit ? "█" : "░"
	return "\[[loadstring]\]"

// Adds -s or -es to the very last word of given string
/proc/pluralize_word(text, check_plural = FALSE)
	var/l = length(text)
	if (l)
		switch(text[l])
			if("z", "x")
				return "[text]es"
			if("s")
				if (check_plural && l > 2)
					return text
				return "[text]es"
			if("h") // -sh, -ch
				if (l > 1)
					var/second = text[l-1]
					if(second == "s" || second == "c")
						return "[text]es"
		return "[text]s"
	return ""

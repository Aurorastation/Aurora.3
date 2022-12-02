/*
 * Holds procs designed to change one type of value, into another.
 * Contains:
 *			text2list & list2text
 *			file2list
 *			angle2dir
 *			angle2text
 *			worldtime2text
 */

// Splits the text of a file at seperator and returns them in a list.
/proc/file2list(filename, seperator="\n")
	return splittext(file2text(filename) || "", seperator)

//Splits the text of a file at seperator and returns them in a list.
/world/proc/file2list(filename, seperator="\n")
	return splittext(file2text(filename), seperator)

// Slower then list2text (replaced with jointext), but correctly processes associative lists.
proc/tg_list2text(list/list, glue=",")
	if (!istype(list) || !list.len)
		return
	var/output
	for(var/i=1 to list.len)
		output += (i!=1? glue : null)+(!isnull(list["[list[i]]"])?"[list["[list[i]]"]]":"[list[i]]")
	return output

// Converts a string into a list by splitting the string at each delimiter found. (discarding the seperator)
/proc/text2list(text, delimiter="\n")
	var/delim_len = length(delimiter)
	if (delim_len < 1)
		return list(text)

	. = list()
	var/last_found = 1
	var/found

	do
		found       = findtext(text, delimiter, last_found, 0)
		.          += copytext(text, last_found, found)
		last_found  = found + delim_len
	while (found)

// Case sensitive version of /proc/text2list().
/proc/text2listEx(text, delimiter="\n")
	var/delim_len = length(delimiter)
	if (delim_len < 1)
		return list(text)

	. = list()
	var/last_found = 1
	var/found

	do
		found       = findtextEx(text, delimiter, last_found, 0)
		.          += copytext(text, last_found, found)
		last_found  = found + delim_len
	while (found)

/proc/text2numlist(text, delimiter="\n")
	var/list/num_list = list()
	for(var/x in text2list(text, delimiter))
		num_list += text2num(x)
	return num_list

// Turns a direction into text
/proc/num2dir(direction)
	switch (direction)
		if (1.0) return NORTH
		if (2.0) return SOUTH
		if (4.0) return EAST
		if (8.0) return WEST
		else
			world.log <<  "UNKNOWN DIRECTION: [direction]"

// Turns a direction into text
/proc/dir2text(direction)
	switch (direction)
		if (1.0)  return "north"
		if (2.0)  return "south"
		if (4.0)  return "east"
		if (8.0)  return "west"
		if (5.0)  return "northeast"
		if (6.0)  return "southeast"
		if (9.0)  return "northwest"
		if (10.0) return "southwest"

// Turns text into proper directions
/proc/text2dir(direction)
	switch (uppertext(direction))
		if ("NORTH")     return 1
		if ("SOUTH")     return 2
		if ("EAST")      return 4
		if ("WEST")      return 8
		if ("NORTHEAST") return 5
		if ("NORTHWEST") return 9
		if ("SOUTHEAST") return 6
		if ("SOUTHWEST") return 10

// Converts an angle (degrees) into an ss13 direction
/proc/angle2dir(var/degree)
	degree = (degree + 22.5) % 360 // 22.5 = 45 / 2
	if (degree < 45)  return NORTH
	if (degree < 90)  return NORTHEAST
	if (degree < 135) return EAST
	if (degree < 180) return SOUTHEAST
	if (degree < 225) return SOUTH
	if (degree < 270) return SOUTHWEST
	if (degree < 315) return WEST
	return NORTH|WEST

// Returns the north-zero clockwise angle in degrees, given a direction
/proc/dir2angle(var/D)
	switch (D)
		if (NORTH)     return 0
		if (SOUTH)     return 180
		if (EAST)      return 90
		if (WEST)      return 270
		if (NORTHEAST) return 45
		if (SOUTHEAST) return 135
		if (NORTHWEST) return 315
		if (SOUTHWEST) return 225

// Returns the angle in english
/proc/angle2text(var/degree)
	return dir2text(angle2dir(degree))

// Converts a blend_mode constant to one acceptable to icon.Blend()
/proc/blendMode2iconMode(blend_mode)
	switch (blend_mode)
		if (BLEND_MULTIPLY) return ICON_MULTIPLY
		if (BLEND_ADD)      return ICON_ADD
		if (BLEND_SUBTRACT) return ICON_SUBTRACT
		else                return ICON_OVERLAY

// Converts a rights bitfield into a string
/proc/rights2text(rights,seperator="")
	if (rights & R_BUILDMODE)   . += "[seperator]+BUILDMODE"
	if (rights & R_ADMIN)       . += "[seperator]+ADMIN"
	if (rights & R_BAN)         . += "[seperator]+BAN"
	if (rights & R_FUN)         . += "[seperator]+FUN"
	if (rights & R_SERVER)      . += "[seperator]+SERVER"
	if (rights & R_DEBUG)       . += "[seperator]+DEBUG"
	if (rights & R_POSSESS)     . += "[seperator]+POSSESS"
	if (rights & R_PERMISSIONS) . += "[seperator]+PERMISSIONS"
	if (rights & R_STEALTH)     . += "[seperator]+STEALTH"
	if (rights & R_REJUVINATE)  . += "[seperator]+REJUVINATE"
	if (rights & R_VAREDIT)     . += "[seperator]+VAREDIT"
	if (rights & R_SOUNDS)      . += "[seperator]+SOUND"
	if (rights & R_SPAWN)       . += "[seperator]+SPAWN"
	if (rights & R_MOD)         . += "[seperator]+MODERATOR"
	if (rights & R_DEV)			. += "[seperator]+DEVELOPER"
	if (rights & R_CCIAA)		. += "[seperator]+CCIAA"
	return .

// heat2color functions. Adapted from: http://www.tannerhelland.com/4435/convert-temperature-rgb-algorithm-code/
// light_adjustment makes the given colour a bit brighter so that set_light can use it to make the room a bit brighter - geeves
/proc/heat2color(temp, var/for_light = FALSE)
	return rgb(heat2color_r(temp, for_light), heat2color_g(temp, for_light), heat2color_b(temp, for_light))

/proc/heat2color_r(temp, var/for_light = FALSE)
	temp /= 100
	if(temp <= 66)
		return 255
	else
		var/light_adjustment = for_light ? 15 : 0
		return max(0, min(255, 329.698727446 * (temp - 60) ** -0.1332047592 + light_adjustment))

/proc/heat2color_g(temp, var/for_light = FALSE)
	temp /= 100
	var/light_adjustment = for_light ? 15 : 0
	if(temp <= 66)
		return max(0, min(255, 99.4708025861 * log(temp) - 161.1195681661 + light_adjustment))
	else
		return max(0, min(255, 288.1221695283 * ((temp - 60) ** -0.0755148492 + light_adjustment)))

/proc/heat2color_b(temp, var/for_light = FALSE)
	temp /= 100
	if(temp >= 66)
		return 255
	else
		if(temp <= 16)
			return 0
		else
			var/light_adjustment = for_light ? 15 : 0
			return max(0, min(255, 138.5177312231 * log(temp - 10) - 305.0447927307 + light_adjustment))

// Very ugly, BYOND doesn't support unix time and rounding errors make it really hard to convert it to BYOND time.
// returns "YYYY-MM-DD" by default
/proc/unix2date(timestamp, seperator = "-")
	if(timestamp < 0)
		return 0 //Do not accept negative values

	var/const/dayInSeconds = 86400 //60secs*60mins*24hours
	var/const/daysInYear = 365 //Non Leap Year
	var/const/daysInLYear = daysInYear + 1//Leap year
	var/days = round(timestamp / dayInSeconds) //Days passed since UNIX Epoc
	var/year = 1970 //Unix Epoc begins 1970-01-01
	var/tmpDays = days + 1 //If passed (timestamp < dayInSeconds), it will return 0, so add 1
	var/monthsInDays = list() //Months will be in here ***Taken from the PHP source code***
	var/month = 1 //This will be the returned MONTH NUMBER.
	var/day //This will be the returned day number.

	while(tmpDays > daysInYear) //Start adding years to 1970
		year++
		if(isLeap(year))
			tmpDays -= daysInLYear
		else
			tmpDays -= daysInYear

	if(isLeap(year)) //The year is a leap year
		monthsInDays = list(-1,30,59,90,120,151,181,212,243,273,304,334)
	else
		monthsInDays = list(0,31,59,90,120,151,181,212,243,273,304,334)

	var/mDays = 0;
	var/monthIndex = 0;

	for(var/m in monthsInDays)
		monthIndex++
		if(tmpDays > m)
			mDays = m
			month = monthIndex

	day = tmpDays - mDays //Setup the date

	return "[year][seperator][((month < 10) ? "0[month]" : month)][seperator][((day < 10) ? "0[day]" : day)]"

/proc/isLeap(y)
	return ((y) % 4 == 0 && ((y) % 100 != 0 || (y) % 400 == 0))

/proc/strtohex(str)
	if(!istext(str)||!str)
		return
	var/r
	var/c
	for(var/i = 1 to length(str))
		c= text2ascii(str,i)
		r+= num2hex(c, 0)
	return r

// Decodes hex to raw byte string.
// If safe=TRUE, returns null on incorrect input strings instead of CRASHing
/proc/hextostr(str)
	if(!istext(str)||!str)
		return
	var/r
	var/c
	for(var/i = 1 to length(str)/2)
		c = hex2num(copytext(str,i*2-1,i*2+1))
		if(isnull(c))
			return null
		r += ascii2text(c)
	return r

/proc/hex2cssrgba(var/hex, var/alpha)
	var/textr = copytext(hex, 2, 4)
	var/textg = copytext(hex, 4, 6)
	var/textb = copytext(hex, 6, 8)
	var/r = hex2num(textr)
	var/g = hex2num(textg)
	var/b = hex2num(textb)
	return "rgba([r], [g], [b], [alpha])"

/proc/type2parent(child)
	var/string_type = "[child]"
	var/last_slash = findlasttext(string_type, "/")
	if(last_slash == 1)
		switch(child)
			if(/datum)
				return null
			if(/obj || /mob)
				return /atom/movable
			if(/area || /turf)
				return /atom
			else
				return /datum
	return text2path(copytext(string_type, 1, last_slash))

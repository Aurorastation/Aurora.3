/*
 * A large number of misc global procs.
 */

//Checks if all high bits in req_mask are set in bitfield
#define BIT_TEST_ALL(bitfield, req_mask) ((~(bitfield) & (req_mask)) == 0)

//Inverts the colour of an HTML string
/proc/invertHTML(HTMLstring)

	if (!( istext(HTMLstring) ))
		CRASH("Given non-text argument!")
	else
		if (length(HTMLstring) != 7)
			CRASH("Given non-HTML argument!")
	var/textr = copytext(HTMLstring, 2, 4)
	var/textg = copytext(HTMLstring, 4, 6)
	var/textb = copytext(HTMLstring, 6, 8)
	var/r = hex2num(textr)
	var/g = hex2num(textg)
	var/b = hex2num(textb)
	textr = num2hex(255 - r, 0)
	textg = num2hex(255 - g, 0)
	textb = num2hex(255 - b, 0)
	if (length(textr) < 2)
		textr = text("0[]", textr)
	if (length(textg) < 2)
		textr = text("0[]", textg)
	if (length(textb) < 2)
		textr = text("0[]", textb)
	return text("#[][][]", textr, textg, textb)

//Returns the middle-most value
/proc/dd_range(var/low, var/high, var/num)
	return max(low,min(high,num))

//Returns whether or not A is the middle most value
/proc/InRange(var/A, var/lower, var/upper)
	if(A < lower) return 0
	if(A > upper) return 0
	return 1


/proc/Get_Angle(atom/movable/start, atom/movable/end) //For beams.
	if(!start || !end)
		return FALSE
	var/dy = (32 * end.y + end.pixel_y) - (32 * start.y + start.pixel_y)
	var/dx = (32 * end.x + end.pixel_x) - (32 * start.x + start.pixel_x)
	if(!dy)
		return (dx >= 0) ? 90 : 270
	. = arctan(dx / dy)
	if(dy < 0)
		. += 180
	else if(dx < 0)
		. += 360

/**
 * Gets all turfs inside a cone, return a `/list` of `/turf` that are inside the cone
 *
 * * source - The source from which to calculate the cone from, an `/atom`
 * * middle_angle - The angle that is considered the middle, if not specific (eg. from a click), you can use `dir2angle(dir)` to convert the direction of the atom to an angle
 * * distance - How far to take turfs from
 * * angle_spread - How much degrees does the cone spread, from the `middle_angle`
 *
 */
/proc/get_turfs_in_cone(atom/source, middle_angle, distance, angle_spread)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_BE_PURE(TRUE)

	if(!source)
		crash_with("Source not specified")

	if(isnull(middle_angle) || middle_angle < 0)
		crash_with("middle_angle not specified, or invalid")

	if(isnull(distance))
		crash_with("Distance not specified")

	if(angle_spread < 0)
		crash_with("angle_spread cannot be negative")

	var/list/turf/turfs_in_cone = list()
	RETURN_TYPE(turfs_in_cone)

	var/angle_left = (middle_angle - angle_spread + 360) % 360
	var/angle_right = (middle_angle + angle_spread) % 360

	for(var/turf/turf in range(distance, source))
		var/angle_between_source_and_target = Get_Angle(source, turf)

		// Ensure correct handling of angles spanning the 0-degree mark
		if(angle_left <= angle_right)
			if((angle_between_source_and_target >= angle_left) && (angle_between_source_and_target <= angle_right))
				turfs_in_cone += turf
		else
			if((angle_between_source_and_target >= angle_left) || (angle_between_source_and_target <= angle_right))
				turfs_in_cone += turf

	return turfs_in_cone


/proc/get_projectile_angle(atom/source, atom/target)
	var/sx = source.x * world.icon_size
	var/sy = source.y * world.icon_size
	var/tx = target.x * world.icon_size
	var/ty = target.y * world.icon_size
	var/atom/movable/AM
	if(ismovable(source))
		AM = source
		sx += AM.step_x
		sy += AM.step_y
	if(ismovable(target))
		AM = target
		tx += AM.step_x
		ty += AM.step_y
	return SIMPLIFY_DEGREES(arctan(ty - sy, tx - sx))

//Returns location. Returns null if no location was found.
/proc/get_teleport_loc(turf/location,mob/target,distance = 1, density = 0, errorx = 0, errory = 0, eoffsetx = 0, eoffsety = 0)
/*
Location where the teleport begins, target that will teleport, distance to go, density checking 0/1(yes/no).
Random error in tile placement x, error in tile placement y, and block offset.
Block offset tells the proc how to place the box. Behind teleport location, relative to starting location, forward, etc.
Negative values for offset are accepted, think of it in relation to North, -x is west, -y is south. Error defaults to positive.
Turf and target are seperate in case you want to teleport some distance from a turf the target is not standing on or something.
*/

	var/dirx = 0//Generic location finding variable.
	var/diry = 0

	var/xoffset = 0//Generic counter for offset location.
	var/yoffset = 0

	var/b1xerror = 0//Generic placing for point A in box. The lower left.
	var/b1yerror = 0
	var/b2xerror = 0//Generic placing for point B in box. The upper right.
	var/b2yerror = 0

	errorx = abs(errorx)//Error should never be negative.
	errory = abs(errory)
	//var/errorxy = round((errorx+errory)/2)//Used for diagonal boxes.

	switch(target.dir)//This can be done through equations but switch is the simpler method. And works fast to boot.
	//Directs on what values need modifying.
		if(1)//North
			diry+=distance
			yoffset+=eoffsety
			xoffset+=eoffsetx
			b1xerror-=errorx
			b1yerror-=errory
			b2xerror+=errorx
			b2yerror+=errory
		if(2)//South
			diry-=distance
			yoffset-=eoffsety
			xoffset+=eoffsetx
			b1xerror-=errorx
			b1yerror-=errory
			b2xerror+=errorx
			b2yerror+=errory
		if(4)//East
			dirx+=distance
			yoffset+=eoffsetx//Flipped.
			xoffset+=eoffsety
			b1xerror-=errory//Flipped.
			b1yerror-=errorx
			b2xerror+=errory
			b2yerror+=errorx
		if(8)//West
			dirx-=distance
			yoffset-=eoffsetx//Flipped.
			xoffset+=eoffsety
			b1xerror-=errory//Flipped.
			b1yerror-=errorx
			b2xerror+=errory
			b2yerror+=errorx

	var/turf/destination=locate(location.x+dirx,location.y+diry,location.z)

	if(destination)//If there is a destination.
		if(errorx||errory)//If errorx or y were specified.
			var/destination_list[] = list()//To add turfs to list.
			//destination_list = new()
			/*This will draw a block around the target turf, given what the error is.
			Specifying the values above will basically draw a different sort of block.
			If the values are the same, it will be a square. If they are different, it will be a rectengle.
			In either case, it will center based on offset. Offset is position from center.
			Offset always calculates in relation to direction faced. In other words, depending on the direction of the teleport,
			the offset should remain positioned in relation to destination.*/

			var/turf/center = locate((destination.x+xoffset),(destination.y+yoffset),location.z)//So now, find the new center.

			//Now to find a box from center location and make that our destination.
			for(var/turf/T in block(locate(center.x+b1xerror,center.y+b1yerror,location.z), locate(center.x+b2xerror,center.y+b2yerror,location.z) ))
				if(density&&T.density)	continue//If density was specified.
				if(T.x>world.maxx || T.x<1)	continue//Don't want them to teleport off the map.
				if(T.y>world.maxy || T.y<1)	continue
				destination_list += T
			if(destination_list.len)
				destination = pick(destination_list)
			else	return

		else//Same deal here.
			if(density&&destination.density)	return
			if(destination.x>world.maxx || destination.x<1)	return
			if(destination.y>world.maxy || destination.y<1)	return
	else	return

	return destination



/proc/LinkBlocked(turf/A, turf/B)
	if(A == null || B == null) return 1
	var/adir = get_dir(A,B)
	var/rdir = get_dir(B,A)
	if((adir & (NORTH|SOUTH)) && (adir & (EAST|WEST)))	//	diagonal
		var/iStep = get_step(A,adir&(NORTH|SOUTH))
		if(!LinkBlocked(A,iStep) && !LinkBlocked(iStep,B)) return 0

		var/pStep = get_step(A,adir&(EAST|WEST))
		if(!LinkBlocked(A,pStep) && !LinkBlocked(pStep,B)) return 0
		return 1

	if(DirBlocked(A,adir)) return 1
	if(DirBlocked(B,rdir)) return 1
	return 0


/proc/DirBlocked(turf/loc,var/dir)
	for(var/obj/structure/window/D in loc)
		if(!D.density)			continue
		if(D.dir == SOUTHWEST)	return 1
		if(D.dir == dir)		return 1

	for(var/obj/machinery/door/D in loc)
		if(!D.density)			continue
		if(istype(D, /obj/machinery/door/window))
			if((dir & SOUTH) && (D.dir & (EAST|WEST)))		return 1
			if((dir & EAST ) && (D.dir & (NORTH|SOUTH)))	return 1
		else return 1	// it's a real, air blocking door
	return 0

/proc/TurfBlockedNonWindow(turf/loc)
	for(var/obj/O in loc)
		if(O.density && !istype(O, /obj/structure/window))
			return 1
	return 0

/proc/sign(x)
	return x!=0?x/abs(x):0

/proc/getline(atom/M,atom/N)//Ultra-Fast Bresenham Line-Drawing Algorithm
	var/px=M.x		//starting x
	var/py=M.y
	var/line[] = list(locate(px,py,M.z))
	var/dx=N.x-px	//x distance
	var/dy=N.y-py
	var/dxabs=abs(dx)//Absolute value of x distance
	var/dyabs=abs(dy)
	var/sdx=sign(dx)	//Sign of x distance (+ or -)
	var/sdy=sign(dy)
	var/x=dxabs>>1	//Counters for steps taken, setting to distance/2
	var/y=dyabs>>1	//Bit-shifting makes me l33t.  It also makes getline() unnessecarrily fast.
	var/j			//Generic integer for counting
	if(dxabs>=dyabs)	//x distance is greater than y
		for(j=0;j<dxabs;j++)//It'll take dxabs steps to get there
			y+=dyabs
			if(y>=dxabs)	//Every dyabs steps, step once in y direction
				y-=dxabs
				py+=sdy
			px+=sdx		//Step on in x direction
			line+=locate(px,py,M.z)//Add the turf to the list
	else
		for(j=0;j<dyabs;j++)
			x+=dxabs
			if(x>=dyabs)
				x-=dyabs
				px+=sdx
			py+=sdy
			line+=locate(px,py,M.z)
	return line

#define LOCATE_COORDS(X, Y, Z) locate(between(1, X, world.maxx), between(1, Y, world.maxy), Z)
/proc/getcircle(turf/center, var/radius) //Uses a fast Bresenham rasterization algorithm to return the turfs in a thin circle.
	if(!radius) return list(center)

	var/x = 0
	var/y = radius
	var/p = 3 - 2 * radius

	. = list()
	while(y >= x) // only formulate 1/8 of circle

		. += LOCATE_COORDS(center.x - x, center.y - y, center.z) //upper left left
		. += LOCATE_COORDS(center.x - y, center.y - x, center.z) //upper upper left
		. += LOCATE_COORDS(center.x + y, center.y - x, center.z) //upper upper right
		. += LOCATE_COORDS(center.x + x, center.y - y, center.z) //upper right right
		. += LOCATE_COORDS(center.x - x, center.y + y, center.z) //lower left left
		. += LOCATE_COORDS(center.x - y, center.y + x, center.z) //lower lower left
		. += LOCATE_COORDS(center.x + y, center.y + x, center.z) //lower lower right
		. += LOCATE_COORDS(center.x + x, center.y + y, center.z) //lower right right

		if(p < 0)
			p += 4*x++ + 6;
		else
			p += 4*(x++ - y--) + 10;

#undef LOCATE_COORDS

///Returns whether or not a player is a guest using their ckey as an input
/proc/IsGuestKey(key)
	if (findtext(key, "Guest-", 1, 7) != 1) //was findtextEx
		return 0

	var/i = 7, ch, len = length(key)

	if(copytext(key, 7, 8) == "W") //webclient
		i++

	for (, i <= len, ++i)
		ch = text2ascii(key, i)
		if (ch < 48 || ch > 57)
			return 0
	return 1

///Ensure the frequency is within bounds of what it should be sending/recieving at
/proc/sanitize_frequency(var/f, var/low = PUBLIC_LOW_FREQ, var/high = PUBLIC_HIGH_FREQ)
	f = round(f)
	f = max(low, f)
	f = min(high, f)
	if ((f % 2) == 0) //Ensure the last digit is an odd number
		f += 1
	return f

///Turns 1479 into 147.9
/proc/format_frequency(var/f)
	return "[round(f / 10)].[f % 10]"

///Picks a string of symbols to display as the law number for hacked or ion laws
/proc/ionnum()
	return "[pick("1","2","3","4","5","6","7","8","9","0")][pick("!","@","#","$","%","^","&","*")][pick("!","@","#","$","%","^","&","*")][pick("!","@","#","$","%","^","&","*")]"

///When an AI is activated, it can choose from a list of non-slaved borgs to have as a slave.
/proc/freeborg()
	var/select = null
	var/list/borgs = list()
	for (var/mob/living/silicon/robot/A in GLOB.player_list)
		if (A.stat == 2 || A.connected_ai || A.scrambled_codes || istype(A,/mob/living/silicon/robot/drone))
			continue
		var/name = "[A.real_name] ([A.mod_type] [A.braintype])"
		borgs[name] = A

	if (borgs.len)
		select = input("Unshackled borg signals detected:", "Borg selection", null, null) as null|anything in borgs
		return borgs[select]

///When a borg is activated, it can choose which AI it wants to be slaved to
/proc/active_ais()
	. = list()
	for(var/mob/living/silicon/ai/A in GLOB.living_mob_list)
		if(A.stat == DEAD)
			continue
		if(A.control_disabled == 1)
			continue
		. += A
	return .

///Find an active ai with the least borgs. VERBOSE PROCNAME HUH!
/proc/select_active_ai_with_fewest_borgs()
	var/mob/living/silicon/ai/selected
	var/list/active = active_ais()
	for(var/mob/living/silicon/ai/A in active)
		if(!selected || (selected.connected_robots.len > A.connected_robots.len))
			selected = A

	return selected

/proc/select_active_ai(var/mob/user)
	var/list/ais = active_ais()
	if(ais.len)
		if(user)	. = input(usr,"AI signals detected:", "AI selection") in ais
		else		. = pick(ais)
	return .

/proc/get_sorted_mobs()
	var/list/old_list = getmobs()
	var/list/AI_list = list()
	var/list/Dead_list = list()
	var/list/keyclient_list = list()
	var/list/key_list = list()
	var/list/logged_list = list()
	for(var/named in old_list)
		var/mob/M = old_list[named]
		if(issilicon(M))
			AI_list |= M
		else if(isobserver(M) || M.stat == 2)
			Dead_list |= M
		else if(M.key && M.client)
			keyclient_list |= M
		else if(M.key)
			key_list |= M
		else
			logged_list |= M
		old_list.Remove(named)
	var/list/new_list = list()
	new_list += AI_list
	new_list += keyclient_list
	new_list += key_list
	new_list += logged_list
	new_list += Dead_list
	return new_list

///Returns a list of all mobs with their name
/proc/getmobs()

	var/list/mobs = sortmobs()
	var/list/names = list()
	var/list/creatures = list()
	var/list/namecounts = list()
	for(var/mob/M in mobs)
		var/name = M.name
		if (name in names)
			namecounts[name]++
			name = "[name] ([namecounts[name]])"
		else
			names.Add(name)
			namecounts[name] = 1
		if (M.real_name && M.real_name != M.name)
			name += " \[[M.real_name]\]"
		if (M.stat == 2)
			if(istype(M, /mob/abstract/observer/))
				name += " \[ghost\]"
			else
				name += " \[dead\]"
		creatures[name] = M

	return creatures

///Orders mobs by type then by name
/proc/sortmobs()
	var/list/moblist = list()
	var/list/sortmob = sortAtom(GLOB.mob_list)
	for(var/mob/abstract/eye/M in sortmob)
		moblist.Add(M)
	for(var/mob/living/silicon/ai/M in sortmob)
		moblist.Add(M)
	for(var/mob/living/silicon/pai/M in sortmob)
		moblist.Add(M)
	for(var/mob/living/silicon/robot/M in sortmob)
		moblist.Add(M)
	for(var/mob/living/carbon/human/M in sortmob)
		moblist.Add(M)
	for(var/mob/living/carbon/brain/M in sortmob)
		moblist.Add(M)
	for(var/mob/living/carbon/alien/M in sortmob)
		moblist.Add(M)
	for(var/mob/abstract/observer/M in sortmob)
		moblist.Add(M)
	for(var/mob/abstract/new_player/M in sortmob)
		moblist.Add(M)
	for(var/mob/living/carbon/slime/M in sortmob)
		moblist.Add(M)
	for(var/mob/living/simple_animal/M in sortmob)
		moblist.Add(M)
//	for(var/mob/living/silicon/hivebot/M in world)
//		mob_list.Add(M)
//	for(var/mob/living/silicon/hive_mainframe/M in world)
//		mob_list.Add(M)
	return moblist

///Forces a variable to be posative
/proc/modulus(var/M)
	if(M >= 0)
		return M
	if(M < 0)
		return -M

/**
 * Returns the turf located at the map edge in the specified direction relative to A
 * used for mass driver
 */
/proc/get_edge_target_turf(var/atom/A, var/direction)

	var/turf/target = locate(A.x, A.y, A.z)
	if(!A || !target)
		return 0
		//since NORTHEAST == NORTH & EAST, etc, doing it this way allows for diagonal mass drivers in the future
		//and isn't really any more complicated

		// Note diagonal directions won't usually be accurate
	if(direction & NORTH)
		target = locate(target.x, world.maxy, target.z)
	if(direction & SOUTH)
		target = locate(target.x, 1, target.z)
	if(direction & EAST)
		target = locate(world.maxx, target.y, target.z)
	if(direction & WEST)
		target = locate(1, target.y, target.z)

	return target

/**
 * returns turf relative to A in given direction at set range
 * result is bounded to map size
 * note range is non-pythagorean
 * used for disposal system
 */
/proc/get_ranged_target_turf(var/atom/A, var/direction, var/range)

	var/x = A.x
	var/y = A.y
	if(direction & NORTH)
		y = min(world.maxy, y + range)
	if(direction & SOUTH)
		y = max(1, y - range)
	if(direction & EAST)
		x = min(world.maxx, x + range)
	if(direction & WEST)
		x = max(1, x - range)

	return locate(x,y,A.z)


// returns turf relative to A offset in dx and dy tiles
// bound to map limits
/proc/get_offset_target_turf(var/atom/A, var/dx, var/dy)
	var/x = min(world.maxx, max(1, A.x + dx))
	var/y = min(world.maxy, max(1, A.y + dy))
	return locate(x,y,A.z)

///Makes sure MIDDLE is between LOW and HIGH. If not, it adjusts it. Returns the adjusted value.
/proc/between(var/low, var/middle, var/high)
	return max(min(middle, high), low)

///Returns random gauss number
/proc/GaussRand(var/sigma)
	var/x,y,rsq
	do
		x=2*rand()-1
		y=2*rand()-1
		rsq=x*x+y*y
	while(rsq>1 || !rsq)
	return sigma*y*sqrt(-2*log(rsq)/rsq)

///Returns random gauss number, rounded to 'roundto'
/proc/GaussRandRound(var/sigma,var/roundto)
	return round(GaussRand(sigma),roundto)

///Step-towards method of determining whether one atom can see another. Similar to viewers()
/proc/can_see(var/atom/source, var/atom/target, var/length=5) // I couldn't be arsed to do actual raycasting :I This is horribly inaccurate.
	var/turf/current = get_turf(source)
	var/turf/target_turf = get_turf(target)
	var/steps = 0

	if(!current || !target_turf)
		return 0

	while(current != target_turf)
		if(steps > length) return 0
		if(current.opacity) return 0
		for(var/atom/A in current)
			if(A.opacity) return 0
		current = get_step_towards(current, target_turf)
		steps++

	return 1

/proc/is_blocked_turf(var/turf/T)
	var/cant_pass = 0
	if(T.density) cant_pass = 1
	for(var/atom/A in T)
		if(A.density)//&&A.anchored
			cant_pass = 1
	return cant_pass

/proc/get_step_towards2(var/atom/ref , var/atom/trg)
	var/base_dir = get_dir(ref, get_step_towards(ref,trg))
	var/turf/temp = get_step_towards(ref,trg)

	if(is_blocked_turf(temp))
		var/dir_alt1 = turn(base_dir, 90)
		var/dir_alt2 = turn(base_dir, -90)
		var/turf/turf_last1 = temp
		var/turf/turf_last2 = temp
		var/free_tile = null
		var/breakpoint = 0

		while(!free_tile && breakpoint < 10)
			if(!is_blocked_turf(turf_last1))
				free_tile = turf_last1
				break
			if(!is_blocked_turf(turf_last2))
				free_tile = turf_last2
				break
			turf_last1 = get_step(turf_last1,dir_alt1)
			turf_last2 = get_step(turf_last2,dir_alt2)
			breakpoint++

		if(!free_tile) return get_step(ref, base_dir)
		else return get_step_towards(ref,free_tile)

	else return get_step(ref, base_dir)

/**
 * Makes a mob perform an action to another mob, showing a progress bar and over a given time
 *
 * * user - The `/mob` that performs the action
 * * target - The `/mob` that the action is being performed to
 * * delay - The time it takes for the action to be performed
 * * needhand - Boolean, if a free hand is needed for the action to be successful
 * * display_progress - Boolean, if the progress bar is shown
 * * extra_checks - A `/datum/callback` that is invoked to perform extra checks and validate that the action can continue to be performed,
 * if it returns `FALSE` or an algebraic equivalent the action is aborted
 */
/proc/do_mob(mob/user, mob/target, delay = 30, needhand = TRUE, display_progress = TRUE, datum/callback/extra_checks) //This is quite an ugly solution but i refuse to use the old request system.
	if(!user || !target)
		stack_trace("do_mob called without either an user or a target!")
		return FALSE

	var/user_loc = user.loc
	var/target_loc = target.loc
	var/holding = user.get_active_hand()

	var/datum/progressbar/progbar
	if (display_progress && user.client && (user.client.prefs.toggles_secondary & PROGRESS_BARS))
		var/atom/loc_check = target
		for(var/i = 0; !isturf(loc_check.loc) && i < 5; i++)
			loc_check = target.loc
		progbar = new(user, delay, loc_check)

	var/endtime = world.time + delay
	var/starttime = world.time

	. = TRUE

	while (world.time < endtime)
		stoplag(1)
		if (progbar)
			progbar.update(world.time - starttime)

		if(QDELETED(user) || QDELETED(target))
			. = FALSE
			break

		if (user.loc != user_loc || target.loc != target_loc || (needhand && user.get_active_hand() != holding) || user.stat || user.weakened || user.stunned || (extra_checks && !extra_checks.Invoke()))
			. = FALSE
			break

	if (progbar)
		qdel(progbar)

/// Integer. Unique sequential ID from the `do_after` proc used to validate `DO_USER_UNIQUE_ACT` flag checks.
/mob/var/do_unique_user_handle = 0
/// The mob currently interacting with the atom during a `do_after` timer. Used to validate `DO_TARGET_UNIQUE_ACT` flag checks.
/atom/var/mob/do_unique_target_user

/**
 * Timed actions involving one mob user and (optionally) one target.
 *
 * Returns TRUE on success or FALSE on failure
 *
 * Arguments:
 * * user: The user to check for.
 * * delay: The delay in ticks to wait before returning TRUE.
 * * target: The target to check for. Optional.
 * * do_flags: Flags that determine what the user and target can and cannot do, defined in [mobs.dm]. Defaults to DO_DEFAULT.
 * * incapacitation_flags: Incapacitation flags that determines if the user can be incapacitated. Defaults to INCAPACITATION_DEFAULT.
 * * extra_checks: Optional extra checks, that uses a callback. See [datum/callback].
 *
 */
/proc/do_after(mob/user, delay, atom/target, do_flags = DO_DEFAULT, incapacitation_flags = INCAPACITATION_DEFAULT, datum/callback/extra_checks)
	return !do_after_detailed(user, delay, target, do_flags, incapacitation_flags)

/**
 * See [/proc/do_after]
 * Returns the exact error, defined in [mobs.dm] for custom error messages.
 * Overlaps with do_flags, with some extra error messages available.
 */
/proc/do_after_detailed(mob/user, delay, atom/target, do_flags = DO_DEFAULT, incapacitation_flags = INCAPACITATION_DEFAULT, datum/callback/extra_checks)
	if(!delay)
		return FALSE

	if(!user)
		return DO_MISSING_USER

	var/initial_handle
	if (HAS_FLAG(do_flags, DO_USER_UNIQUE_ACT))
		initial_handle = sequential_id("/proc/do_after")
		user.do_unique_user_handle = initial_handle

	var/do_feedback = HAS_FLAG(do_flags, DO_FAIL_FEEDBACK)

	if(target?.do_unique_target_user)
		if (do_feedback)
			USE_FEEDBACK_FAILURE("\The [target.do_unique_target_user] is already interacting with \the [target]!")
		return DO_TARGET_UNIQUE_ACT

	if (HAS_FLAG(do_flags, DO_TARGET_UNIQUE_ACT) && target)
		target.do_unique_target_user = user

	var/atom/user_loc = HAS_FLAG(do_flags, DO_USER_CAN_MOVE) ? null : user.loc
	var/user_dir = HAS_FLAG(do_flags, DO_USER_CAN_TURN) ? null : user.dir
	var/user_hand = HAS_FLAG(do_flags, DO_USER_SAME_HAND) ? user.hand : null

	var/atom/target_loc = HAS_FLAG(do_flags, DO_TARGET_CAN_MOVE) ? null : target?.loc
	var/target_dir = HAS_FLAG(do_flags, DO_TARGET_CAN_TURN) ? null : target?.dir
	var/target_type = target?.type

	var/target_zone = HAS_FLAG(do_flags, DO_USER_SAME_ZONE) ? user.zone_sel.selecting : null

	if (HAS_FLAG(do_flags, DO_MOVE_CHECKS_TURFS))
		if (user_loc)
			user_loc = get_turf(user)
		if (target_loc)
			target_loc = get_turf(target)

	var/datum/progressbar/progbar
	if (HAS_FLAG(do_flags, DO_SHOW_PROGRESS) && user.client && (user.client.prefs.toggles_secondary & PROGRESS_BARS))
		progbar = new(user, delay, target || user)

	SEND_SIGNAL(user, COMSIG_DO_AFTER_BEGAN)

	var/start_time = world.time
	var/end_time = start_time + delay

	. = FALSE

	while(world.time < end_time)
		stoplag(1)
		if (!QDELETED(progbar))
			progbar.update(world.time - start_time)
		if (QDELETED(user))
			. = DO_MISSING_USER
			break
		if (target_type && (QDELETED(target) || target_type != target.type))
			. = DO_MISSING_TARGET
			break
		if (user.incapacitated(incapacitation_flags))
			. = DO_INCAPACITATED
			break
		if (user_loc && user_loc != (HAS_FLAG(do_flags, DO_MOVE_CHECKS_TURFS) ? get_turf(user) : user.loc))
			. = DO_USER_CAN_MOVE
			break
		if (target_loc && target_loc != (HAS_FLAG(do_flags, DO_MOVE_CHECKS_TURFS) ? get_turf(target) : target.loc))
			. = DO_TARGET_CAN_MOVE
			break
		if (user_dir && user_dir != user.dir)
			. = DO_USER_CAN_TURN
			break
		if (target_dir && target_dir != target.dir)
			. = DO_TARGET_CAN_TURN
			break
		if (HAS_FLAG(do_flags, DO_USER_SAME_HAND) && user_hand != user.hand)
			. = DO_USER_SAME_HAND
			break
		if (initial_handle && initial_handle != user.do_unique_user_handle)
			. = DO_USER_UNIQUE_ACT
			break
		if (target_zone && user.zone_sel.selecting != target_zone)
			. = DO_USER_SAME_ZONE
			break
		if (extra_checks && !extra_checks.Invoke())
			. = DO_EXTRA_CHECKS
			break

	if (. && do_feedback)
		switch (.)
			if (DO_MISSING_TARGET)
				USE_FEEDBACK_FAILURE("\The [target] no longer exists!")
			if (DO_INCAPACITATED)
				USE_FEEDBACK_FAILURE("You're no longer able to act!")
			if (DO_USER_CAN_MOVE)
				USE_FEEDBACK_FAILURE("You must remain still to perform that action!")
			if (DO_TARGET_CAN_MOVE)
				USE_FEEDBACK_FAILURE("\The [target] must remain still to perform that action!")
			if (DO_USER_CAN_TURN)
				USE_FEEDBACK_FAILURE("You must face the same direction to perform that action!")
			if (DO_TARGET_CAN_TURN)
				USE_FEEDBACK_FAILURE("\The [target] must face the same direction to perform that action!")
			if (DO_USER_SAME_HAND)
				USE_FEEDBACK_FAILURE("You must remain on the same active hand to perform that action!")
			if (DO_USER_UNIQUE_ACT)
				USE_FEEDBACK_FAILURE("You stop what you're doing with \the [target].")
			if (DO_USER_SAME_ZONE)
				USE_FEEDBACK_FAILURE("You must remain targeting the same zone to perform that action!")

	if(!QDELETED(progbar))
		progbar.endProgress()
	if (HAS_FLAG(do_flags, DO_USER_UNIQUE_ACT) && user.do_unique_user_handle == initial_handle)
		user.do_unique_user_handle = 0
	if (HAS_FLAG(do_flags, DO_TARGET_UNIQUE_ACT) && target)
		target.do_unique_target_user = null

	SEND_SIGNAL(user, COMSIG_DO_AFTER_ENDED)

/proc/atom_maintain_position(var/atom/A, var/atom/location)
	if(QDELETED(A) || QDELETED(location))
		return FALSE
	if(A.loc != location)
		return FALSE
	return TRUE

//Takes: Anything that could possibly have variables and a varname to check.
//Returns: 1 if found, 0 if not.
/proc/hasvar(var/datum/A, var/varname)
	if(A.vars.Find(lowertext(varname))) return 1
	else return 0

/proc/DuplicateObject(obj/original, var/perfectcopy = 0 , var/sameloc = 0)
	if(!original)
		return null

	var/obj/O = null

	if(sameloc)
		O=new original.type(original.loc)
	else
		O=new original.type(locate(0,0,0))

	if(perfectcopy)
		if((O) && (original))
			for(var/V in original.vars)
				if(!(V in list("type","loc","locs","vars", "parent", "parent_type","verbs","ckey","key")))
					O.vars[V] = original.vars[V]
	return O

/proc/get_cardinal_dir(atom/A, atom/B)
	var/dx = abs(B.x - A.x)
	var/dy = abs(B.y - A.y)
	return get_dir(A, B) & (rand() * (dx+dy) < dy ? 3 : 12)

/proc/get_compass_dir(atom/start, atom/end) //get_dir() only considers an object to be north/south/east/west if there is zero deviation. This uses rounding instead. // Ported from CM-SS13
	if(!start || !end)
		return 0
	if(!start.z || !end.z)
		return 0 //Atoms are not on turfs.

	var/dy= end.y - start.y
	var/dx= end.x - start.x
	if(!dy)
		return (dx >= 0) ? 4 : 8

	var/angle = arctan(dx / dy)
	if(dy < 0)
		angle += 180
	else if(dx < 0)
		angle += 360

	switch(angle) //diagonal directions get priority over straight directions in edge cases
		if (22.5 to 67.5)
			return NORTHEAST
		if (112.5 to 157.5)
			return SOUTHEAST
		if (202.5 to 247.5)
			return SOUTHWEST
		if (292.5 to 337.5)
			return NORTHWEST
		if (0 to 22.5)
			return NORTH
		if (67.5 to 112.5)
			return EAST
		if (157.5 to 202.5)
			return SOUTH
		if (247.5 to 292.5)
			return WEST
		else
			return NORTH

//chances are 1:value. anyprob(1) will always return true
/proc/anyprob(value)
	return (rand(1,value)==value)

/proc/view_or_range(distance = world.view , center = usr , type)
	switch(type)
		if("view")
			. = view(distance,center)
		if("range")
			. = range(distance,center)
	return

/proc/oview_or_orange(distance = world.view , center = usr , type)
	switch(type)
		if("view")
			. = oview(distance,center)
		if("range")
			. = orange(distance,center)
	return

/proc/get_mob_with_client_list()
	var/list/mobs = list()
	for(var/mob/M in GLOB.mob_list)
		if (M.client)
			mobs += M
	return mobs


/proc/parse_zone(zone)
	if(zone == BP_R_HAND) return "right hand"
	else if (zone == BP_L_HAND) return "left hand"
	else if (zone == BP_L_ARM) return "left arm"
	else if (zone == BP_R_ARM) return "right arm"
	else if (zone == BP_L_LEG) return "left leg"
	else if (zone == BP_R_LEG) return "right leg"
	else if (zone == BP_L_FOOT) return "left foot"
	else if (zone == BP_R_FOOT) return "right foot"
	else if (zone == BP_L_HAND) return "left hand"
	else if (zone == BP_R_HAND) return "right hand"
	else if (zone == BP_L_FOOT) return "left foot"
	else if (zone == BP_R_FOOT) return "right foot"
	else return zone

/proc/reverse_parse_zone(zone)
	if(zone == "right hand") return BP_R_HAND
	else if (zone == "left hand") return BP_L_HAND
	else if (zone == "left arm") return BP_L_ARM
	else if (zone == "right arm") return BP_R_ARM
	else if (zone == "left leg") return BP_L_LEG
	else if (zone == "right leg") return BP_R_LEG
	else if (zone == "left foot") return BP_L_FOOT
	else if (zone == "right foot") return BP_R_FOOT
	else if (zone == "left hand") return BP_L_HAND
	else if (zone == "right hand") return BP_R_HAND
	else if (zone == "left foot") return BP_L_FOOT
	else if (zone == "right foot") return BP_R_FOOT
	else return zone

/proc/get(atom/loc, type)
	while(loc)
		if(istype(loc, type))
			return loc
		loc = loc.loc
	return null

/proc/get_turf_or_move(turf/location)
	return get_turf(location)


//Quick type checks for some tools
var/global/list/common_tools = list(
/obj/item/stack/cable_coil,
/obj/item/wrench,
/obj/item/pipewrench,
/obj/item/weldingtool,
/obj/item/screwdriver,
/obj/item/wirecutters,
/obj/item/powerdrill,
/obj/item/combitool,
/obj/item/device/multitool,
/obj/item/crowbar)

/proc/istool(O)
	if(O && is_type_in_list(O, common_tools))
		return 1
	return 0

/proc/is_hot(obj/item/W as obj)
	switch(W.type)
		if(/obj/item/weldingtool)
			var/obj/item/weldingtool/WT = W
			if(WT.isOn())
				return 3800
			else
				return 0
		if(/obj/item/flame/lighter)
			if(W:lit)
				return 1500
			else
				return 0
		if(/obj/item/flame/match)
			if(W:lit)
				return 1000
			else
				return 0
		if(/obj/item/clothing/mask/smokable/cigarette)
			if(W:lit)
				return 1000
			else
				return 0
		if(/obj/item/gun/energy/plasmacutter)
			return 3800
		if(/obj/item/melee/energy)
			return 3500
		else
			return 0

//Whether or not the given item counts as sharp in terms of dealing damage
/proc/is_sharp(obj/O)
	if (!O)
		return 0
	if (O.sharp)
		return 1
	if (O.edge)
		return 1
	return 0

//Whether or not the given item counts as cutting with an edge in terms of removing limbs
/proc/has_edge(obj/O)
	if (!O)
		return 0
	if (O.edge)
		return 1
	return 0

/proc/is_surgery_tool(obj/item/W)
	return istype(W, /obj/item/surgery)

/proc/is_borg_item(obj/item/W)
	return W && W.loc && isrobot(W.loc)

//check if mob is lying down on something we can operate him on.
/proc/can_operate(mob/living/carbon/M) //If it's 2, commence surgery, if it's 1, fail surgery, if it's 0, attack
	var/surgery_attempt = SURGERY_IGNORE
	var/located = FALSE
	if(locate(/obj/machinery/optable, M.loc))
		located = TRUE
		surgery_attempt = SURGERY_SUCCESS
	else if(locate(/obj/structure/bed/roller, M.loc))
		located = TRUE
		if(prob(80))
			surgery_attempt = SURGERY_SUCCESS
		else
			surgery_attempt = SURGERY_FAIL
	else if(locate(/obj/structure/table, M.loc))
		located = TRUE
		if(prob(66))
			surgery_attempt = SURGERY_SUCCESS
		else
			surgery_attempt = SURGERY_FAIL
	if(!M.lying && surgery_attempt != SURGERY_SUCCESS && located)
		surgery_attempt = SURGERY_IGNORE //hit yourself if you're not lying
	return surgery_attempt

/proc/reverse_direction(var/dir)
	switch(dir)
		if(NORTH)
			return SOUTH
		if(NORTHEAST)
			return SOUTHWEST
		if(EAST)
			return WEST
		if(SOUTHEAST)
			return NORTHWEST
		if(SOUTH)
			return NORTH
		if(SOUTHWEST)
			return NORTHEAST
		if(WEST)
			return EAST
		if(NORTHWEST)
			return SOUTHEAST

/*
Checks if that loc and dir has a item on the wall
*/
var/list/wall_items = typecacheof(list(
	/obj/machinery/power/apc,
	/obj/machinery/alarm,
	/obj/item/device/radio/intercom,
	/obj/structure/extinguisher_cabinet,
	/obj/structure/reagent_dispensers/peppertank,
	/obj/machinery/status_display,
	/obj/machinery/requests_console,
	/obj/machinery/light_switch,
	/obj/machinery/newscaster,
	/obj/machinery/firealarm,
	/obj/structure/noticeboard,
	/obj/machinery/computer/security/telescreen,
	/obj/machinery/embedded_controller/radio/airlock,
	/obj/item/storage/secure/safe,
	/obj/machinery/door_timer,
	/obj/machinery/flasher,
	/obj/machinery/keycard_auth,
	/obj/structure/mirror,
	/obj/structure/fireaxecabinet,
	/obj/machinery/computer/security/telescreen/entertainment,
	/obj/structure/sign
))

/proc/gotwallitem(loc, dir)
	for(var/obj/O in loc)
		if (is_type_in_typecache(O, global.wall_items))
			//Direction works sometimes
			if(O.dir == dir)
				return 1

			//Some stuff doesn't use dir properly, so we need to check pixel instead
			switch(dir)
				if(SOUTH)
					if(O.pixel_y > 10)
						return 1
				if(NORTH)
					if(O.pixel_y < -10)
						return 1
				if(WEST)
					if(O.pixel_x > 10)
						return 1
				if(EAST)
					if(O.pixel_x < -10)
						return 1

	//Some stuff is placed directly on the wallturf (signs)
	for(var/obj/O in get_step(loc, dir))
		if (is_type_in_typecache(O, global.wall_items) && O.pixel_x == 0 && O.pixel_y == 0)
			return 1
	return 0

// Returns a variable type as string, optionally with some details:
// Objects (datums) get their type, paths get the type name, scalars show length (text) and value (numbers), lists show length.
// Also attempts some detection of otherwise undetectable types using ref IDs
var/global/known_proc = /proc/get_type_ref_bytes
/proc/get_debug_type(var/V, var/details = TRUE, var/print_numbers = TRUE, var/path_names = TRUE, var/text_lengths = TRUE, var/list_lengths = TRUE, var/show_useless_subtypes = TRUE)
	// scalars / basic types
	if(isnull(V))
		return "null"
	if(ispath(V))
		return details && path_names ? "path([V])" : "path"
	if(istext(V))
		return details && text_lengths ? "text([length(V) ])" : "text"
	if(isnum(V)) // Byond doesn't really differentiate between floats and ints, but we can sort of guess here
		// also technically we could also say that 0 and 1 are boolean but that'd be quite silly
		if(IsInteger(V) && V < 16777216 && V > -16777216)
			return details && print_numbers ? "int([V])" : "int"
		if(V >= INFINITY)
			return details ? "float(+INF)" : "float"
		if(V <= -INFINITY)
			return details ? "float(-INF)" : "float"
		return details && print_numbers ? "float([V])" : "float"
	// Resource types
	if(isicon(V))
		return "icon"
	if(isfile(V))
		return "file"
	// Types that don't inherit from /datum (note that /world is not here because you can't hold a reference to it)
	if(islist(V))
		return details && list_lengths ? "list([length(V)])" : "list"
	if(isclient(V))
		return "client"
	if(istype(V, /savefile))
		return "savefile"
	// Finally actual objects that inherit from /datum
	// We want to differentiate at least the basic "special" Byond types
	var/datum/D = V
	if(isarea(D))
		return details ? "area([D.type])" : "area"
	if(isturf(D))
		return details ? "turf([D.type])" : "turf"
	if(ismob(D))
		return details ? "mob([D.type])" : "mob"
	if(isobj(D))
		return details ? "obj([D.type])" : "obj"
	if(istype(D, /atom/movable)) // according to DM docs there should be no defined types under this but there certainly are some
		return details ? "movable([D.type])" : "movable"
	if(isatom(D))
		return details ? "atom([D.type])" : "atom"
	if(istype(D, /database))
		return details && show_useless_subtypes ? "database([D.type])" : "database"
	if(istype(D, /exception))
		return details && show_useless_subtypes ? "exception([D.type])" : "exception"
	if(istype(D, /mutable_appearance)) // must come before /image
		return details && show_useless_subtypes ? "mutable_appearance([D.type])" : "mutable_appearance"
	if(istype(D, /image))
		return details ? "image([D.type])" : "image"
	if(istype(D, /matrix))
		return details && show_useless_subtypes ? "matrix([D.type])" : "matrix"
	if(istype(D, /regex))
		return details && show_useless_subtypes ? "regex([D.type])" : "regex"
	if(istype(D, /sound))
		return details ? "sound([D.type])" : "sound"
	if(istype(D, /singleton))
		return details ? "singleton([D.type])" : "singleton"
	if(isdatum(D))
		return details ? "datum([D.type])" : "datum"
	if(istype(D)) // let's future proof ourselves
		return details ? "unknown-object([D.type])" : "unknown-object"
	// some undetectable types
	var/refType = get_type_ref_bytes(V)
	if(refType == "")
		return "unknown"
	if(refType == get_type_ref_bytes(known_proc)) // it's a proc of some kind
		if(istext(V?:name) && V:name != "") // procs with names are generally verbs
			return "verb"
		return "proc"
	if(refType == "53")
		return "filters"
	if(refType == "3a")
		return "appearance"
	return "unknown-object([refType])" // If you see this you found a new undetectable type. Feel free to add it here.

/proc/get_type_ref_bytes(var/V) // returns first 4 bytes from \ref which denote the object type (for objects that is)
	return lowertext(copytext(ref(V), 4, 6))

/proc/format_text(text)
	return replacetext(replacetext(text,"\proper ",""),"\improper ","")

/proc/topic_link(var/datum/D, var/arglist, var/content)
	if(istype(arglist,/list))
		arglist = list2params(arglist)
	return "<a href='?src=\ref[D];[arglist]'>[content]</a>"

/proc/get_random_colour(var/simple, var/lower, var/upper)
	var/colour
	if(simple)
		colour = pick(list("FF0000","FF7F00","FFFF00","00FF00","0000FF","4B0082","8F00FF"))
	else
		for(var/i=1;i<=3;i++)
			var/temp_col = "[num2hex(rand(lower,upper), 0)]"
			if(length(temp_col )<2)
				temp_col  = "0[temp_col]"
			colour += temp_col
	return "#[colour]"

/proc/color_square(red, green, blue, hex)
	var/color = hex ? hex : "#[num2hex(red, 2)][num2hex(green, 2)][num2hex(blue, 2)]"
	return "<span style='font-face: fixedsys; font-size: 14px; background-color: [color]; color: [color]'>___</span>"

// call to generate a stack trace and print to runtime logs
/proc/crash_with(msg)
	CRASH(msg)

//similar function to RANGE_TURFS(), but will search spiralling outwards from the center (like the above, but only turfs)
/proc/spiral_range_turfs(dist=0, center=usr, orange=0)
	if(!dist)
		if(!orange)
			return list(center)
		else
			return list()

	var/turf/t_center = get_turf(center)
	if(!t_center)
		return list()

	var/list/L = list()
	var/turf/T
	var/y
	var/x
	var/c_dist = 1

	if(!orange)
		L += t_center

	while( c_dist <= dist )
		y = t_center.y + c_dist
		x = t_center.x - c_dist + 1
		for(x in x to t_center.x+c_dist)
			T = locate(x,y,t_center.z)
			if(T)
				L += T

		y = t_center.y + c_dist - 1
		x = t_center.x + c_dist
		for(y in t_center.y-c_dist to y)
			T = locate(x,y,t_center.z)
			if(T)
				L += T

		y = t_center.y - c_dist
		x = t_center.x + c_dist - 1
		for(x in t_center.x-c_dist to x)
			T = locate(x,y,t_center.z)
			if(T)
				L += T

		y = t_center.y - c_dist + 1
		x = t_center.x - c_dist
		for(y in y to t_center.y+c_dist)
			T = locate(x,y,t_center.z)
			if(T)
				L += T
		c_dist++

	return L

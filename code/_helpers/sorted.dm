 */
/*
/*
/*
))
*/
*/
	)
	)


































































































































































































	. = 0
	. = 0
			. = 0
			. = 0
			. = 0
			. = 0
			. = 0
	. = 1
	. = 1
		.+=180
		.+=360
		. += A
		a = a.loc
		act_target = user
			AI_list |= M
 * A large number of misc global procs.
		//and isn't really any more complicated
	.=arctan(dx/dy)
		arglist = list2params(arglist)
			A.SetName(newname)
//as sleeps aren't cheap and sleeping only to wake up and sleep again is wasteful
/atom/proc/add_verb(the_verb, datum/callback/callback)
/atom/proc/find_up_hierarchy(var/atom/target)
/atom/proc/GetAllContents(searchDepth = 5)
/atom/proc/get_light_and_color(var/atom/origin)
/atom/proc/use_check(mob/user, use_flags = 0, show_messages = FALSE)
			b1xerror-=errorx
			b1xerror-=errorx
			b1xerror-=errory//Flipped.
			b1xerror-=errory//Flipped.
			b1yerror-=errorx
			b1yerror-=errorx
			b1yerror-=errory
			b1yerror-=errory
			b2xerror+=errorx
			b2xerror+=errorx
			b2xerror+=errory
			b2xerror+=errory
			b2yerror+=errorx
			b2yerror+=errorx
			b2yerror+=errory
			b2yerror+=errory
Block offset tells the proc how to place the box. Behind teleport location, relative to starting location, forward, etc.
		borgs[name] = A
// bound to map limits
					break
				break
				break
				break
			break
			break
			break
			break
			break
			breakpoint++
			break	//That's a suitable name!
//Calling this proc without an oldname will only update the mob and skip updating the pda, id and records ~Carn
// call to generate a stack trace and print to runtime logs
			cant_pass = 1
		c_dist++
		. += Ceiling(i*DELTA_CALC)
//chances are 1:value. anyprob(1) will always return true
//check if mob is lying down on something we can operate him on.
//Checks if all high bits in req_mask are set in bitfield
Checks if that loc and dir has a item on the wall
// Checks if user can use this object. Set use_flags to customize what checks are done.
		ch = text2ascii(key, i)
		color = origin.color
		colour = pick(list("FF0000","FF7F00","FFFF00","00FF00","0000FF","4B0082","8F00FF"))
			colour += temp_col
				continue
			continue
			continue
			continue
			CRASH("Given non-HTML argument!")
		CRASH("Given non-text argument!")
	CRASH(msg)
		creatures[name] = M
		current = get_step_towards(current, target_turf)
			Dead_list |= M
#define BIT_TEST_ALL(bitfield, req_mask) ((~(bitfield) & (req_mask)) == 0)
#define DELTA_CALC max(((max(world.tick_usage, world.cpu) / 100) * max(Master.sleep_delta-1,1)), 1)
#define HAS_FLAG(flag) (flag & use_flags)
#define LOCATE_COORDS(X, Y, Z) locate(between(1, X, world.maxx), between(1, Y, world.maxy), Z)
#define NOT_FLAG(flag) (!(flag & use_flags))
			//destination_list = new()
				destination_list += T
				destination = pick(destination_list)
			//Direction works sometimes
	//Directs on what values need modifying.
			dirx-=distance
			dirx+=distance
			diry-=distance
			diry+=distance
		dna.real_name = real_name
  do
	do
	dx=(32*end.x+end.pixel_x)-(32*start.x+start.pixel_x)
	dy=(32*end.y+end.pixel_y)-(32*start.y+start.pixel_y)
			else
			else
			else
			else
			else
		else
		else
		else
		else
		else
		else
	else
	else
	else
	else
	else
	else if(dx<0)
		else if(isobserver(M) || M.stat == 2)
	else if (istype(A.loc, /obj/item/rig_module))
		else if(M.key)
		else if(M.key && M.client)
			else if( search_pda && istype(A,/obj/item/device/pda) )
	else if (zone == "l_arm") return "left arm"
	else if (zone == "l_foot") return "left foot"
	else if (zone == "l_foot") return "left foot"
	else if (zone == "l_hand") return "left hand"
	else if (zone == "l_hand") return "left hand"
	else if (zone == "l_leg") return "left leg"
	else if (zone == "r_arm") return "right arm"
	else if (zone == "r_foot") return "right foot"
	else if (zone == "r_foot") return "right foot"
	else if (zone == "r_hand") return "right hand"
	else if (zone == "r_leg") return "right leg"
		else		. = pick(ais)
			else	return
	else	return
	else return 0
		else return 1	// it's a real, air blocking door
	else return get_step(ref, base_dir)
		else return get_step_towards(ref,free_tile)
	else return zone
		else//Same deal here.
//Ensure the frequency is within bounds of what it should be sending/recieving at
	errorx = abs(errorx)//Error should never be negative.
	errory = abs(errory)
		f += 1
//Find an active ai with the least borgs. VERBOSE PROCNAME HUH!
// Flags are in `code/__defines/misc.dm`
	f = max(low, f)
	f = min(high, f)
//Forces a variable to be posative
	for (, i <= len, ++i)
		for(j=0;j<dxabs;j++)//It'll take dxabs steps to get there
		for(j=0;j<dyabs;j++)
		for(var/A in searching)
		for(var/atom/A in current)
	for(var/atom/A in T)
	for(var/atom/part in contents)
			for(var/datum/data/record/R in L)
		for(var/i=1;i<=3;i++)
	for(var/i=1,i<=3,i++)	//we get 3 attempts to pick a suitable name.
		for(var/list/L in list(data_core.general,data_core.medical,data_core.security,data_core.locked))
	for(var/mob/dead/observer/M in sortmob)
	for(var/mob/eye/M in sortmob)
	for(var/mob/living/carbon/alien/M in sortmob)
	for(var/mob/living/carbon/brain/M in sortmob)
	for(var/mob/living/carbon/human/M in sortmob)
	for(var/mob/living/carbon/slime/M in sortmob)
		for(var/mob/living/M in player_list)
	for(var/mob/living/silicon/ai/A in active)
	for(var/mob/living/silicon/ai/A in living_mob_list)
	for(var/mob/living/silicon/ai/M in sortmob)
//	for(var/mob/living/silicon/hivebot/M in world)
//	for(var/mob/living/silicon/hive_mainframe/M in world)
	for(var/mob/living/silicon/pai/M in sortmob)
	for (var/mob/living/silicon/robot/A in player_list)
	for(var/mob/living/silicon/robot/M in sortmob)
	for(var/mob/living/simple_animal/M in sortmob)
	for(var/mob/M in mob_list)
	for(var/mob/M in mobs)
	for(var/mob/new_player/M in sortmob)
	for(var/named in old_list)
	for(var/obj/machinery/door/D in loc)
	for(var/obj/O in get_step(loc, dir))
	for(var/obj/O in loc)
	for(var/obj/O in loc)
	for(var/obj/structure/window/D in loc)
			for(var/turf/T in block(locate(center.x+b1xerror,center.y+b1yerror,location.z), locate(center.x+b2xerror,center.y+b2yerror,location.z) ))
			for(var/V in original.vars)
		for(x in t_center.x-c_dist to x)
		for(x in x to t_center.x+c_dist)
		for(y in t_center.y-c_dist to y)
		for(y in y to t_center.y+c_dist)
				free_tile = turf_last1
				free_tile = turf_last2
	f = round(f)
	fully_replace_character_name(oldname,newname)
//Generalised helper proc for letting mobs rename themselves. Used to be clname() and ainame()
// Helper for adding verbs with timers.
		i++
		i *= 2
					ID.name = "[newname]'s ID Card ([ID.assignment])"
					ID.registered_name = newname
		if(1)//North
		if(2)//South
		if(4)//East
		if(8)//West
		if(A.control_disabled == 1)
	if (!act_target)
		if(A.density)//&&A.anchored
	if((adir & (NORTH|SOUTH)) && (adir & (EAST|WEST)))	//	diagonal
	if(ais.len)
	if(A < lower) return 0
	if(A == null || B == null) return 1
			if(A.opacity) return 0
		if (A.stat == 2 || A.connected_ai || A.scrambledcodes || istype(A,/mob/living/silicon/robot/drone))
		if(A.stat == DEAD)
	if(!A || !target)
		if (a == target)//we found it!
	if(A > upper) return 0
	if(A.vars.Find(lowertext(varname))) return 1
	if (borgs.len)
	if (callback && !callback.Invoke())
		if (ch < 48 || ch > 57)
	if(cmptext("ai",role))
	if(copytext(key, 7, 8) == "W") //webclient
		if(current.opacity) return 0
	if(!current || !target_turf)
		if(!D.density)			continue
		if(!D.density)			continue
		if(D.dir == dir)		return 1
		if(D.dir == SOUTHWEST)	return 1
			if(density&&destination.density)	return
				if(density&&T.density)	continue//If density was specified.
	if(destination)//If there is a destination.
			if(destination_list.len)
			if(destination.x>world.maxx || destination.x<1)	return
			if(destination.y>world.maxy || destination.y<1)	return
	if(DirBlocked(A,adir)) return 1
	if(DirBlocked(B,rdir)) return 1
			if((dir & EAST ) && (D.dir & (NORTH|SOUTH)))	return 1
	if(direction & EAST)
	if(direction & EAST)
	if(direction & NORTH)
	if(direction & NORTH)
	if(direction & SOUTH)
	if(direction & SOUTH)
	if(direction & WEST)
	if(direction & WEST)
			if((dir & SOUTH) && (D.dir & (EAST|WEST)))		return 1
	if (display_progress && user.client && (user.client.prefs.parallax_togs & PROGRESS_BARS))
	if (display_progress && user.client && (user.client.prefs.parallax_togs & PROGRESS_BARS))
	if(!dist)
	if(dna)
	if(dxabs>=dyabs)	//x distance is greater than y
	if(!dy)
	if(dy<0)
				if(EAST)
		if(EAST)
		if(errorx||errory)//If errorx or y were specified.
		if (extra_checks && !extra_checks.Invoke())
	if ((f % 2) == 0) //Ensure the last digit is an odd number
	if (findtext(key, "Guest-", 1, 7) != 1) //was findtextEx
		if(!free_tile) return get_step(ref, base_dir)
	if (HAS_FLAG(USE_DISALLOW_SILICONS) && issilicon(user))
	if (HAS_FLAG(USE_FORCE_SRC_IN_USER) && !(src in user))
				if(ID.registered_name == oldname)
	if (!initial_delay)
		if(isAI(src))
	if(is_blocked_turf(temp))
			if(!is_blocked_turf(turf_last1))
			if(!is_blocked_turf(turf_last2))
		if (isnull(a))
		if(issilicon(M))
	if (!( istext(HTMLstring) ))
		if (istype(a, /area))
	if (istype(A.loc, /mob/living/silicon))
	if(istype(arglist,/list))
		if(istype(D, /obj/machinery/door/window))
		if (is_type_in_typecache(O, global.wall_items))
		if (is_type_in_typecache(O, global.wall_items) && O.pixel_x == 0 && O.pixel_y == 0)
		if(istype(loc, type))
			if(istype(M, /mob/dead/observer/))
		if (length(HTMLstring) != 7)
			if(length(temp_col )<2)
	if (length(textb) < 2)
	if (length(textg) < 2)
	if (length(textr) < 2)
		if(!LinkBlocked(A,iStep) && !LinkBlocked(iStep,B)) return 0
		if(!LinkBlocked(A,pStep) && !LinkBlocked(pStep,B)) return 0
	if(M < 0)
	if(M >= 0)
	if (!Master || Master.initializing || !Master.round_started)
		if (M.client)
	if(mind)
		if (M.real_name && M.real_name != M.name)
			if(M == src)
		if (M.stat == 2)
		if (name in names)
		if(needhand && !(user.get_active_hand() == holding))	//Sometimes you don't want the user to have to keep their active hand
		if(newname)
			if(!newname || M.real_name == newname)
	if(!newname)	return 0
	if(!newname)	//we'll stick with the oldname then
				if(NORTH)
		if(NORTH)
		if(NORTHEAST)
		if(NORTHWEST)
	if (NOT_FLAG(USE_ALLOW_DEAD) && user.stat == DEAD)
	if (NOT_FLAG(USE_ALLOW_INCAPACITATED) && (user.incapacitated()))
	if (NOT_FLAG(USE_ALLOW_NON_ADJACENT) && !Adjacent(user))
	if (NOT_FLAG(USE_ALLOW_NON_ADV_TOOL_USR) && !user.IsAdvancedToolUser())
	if (NOT_FLAG(USE_ALLOW_NONLIVING) && !isliving(user))
		if(/obj/item/clothing/mask/smokable/cigarette)
		if(/obj/item/weapon/flame/lighter)
		if(/obj/item/weapon/flame/match)
		if(/obj/item/weapon/gun/energy/plasmacutter)
		if(/obj/item/weapon/melee/energy)
		if(/obj/item/weapon/weldingtool)
		if(O.density && !istype(O, /obj/structure/window))
			if(O.dir == dir)
	if (O.edge) return 1
	if (O.edge) return 1
	if(O && is_type_in_list(O, common_tools))
	if(oldname)
		if((O) && (original))
					if(O.pixel_x < -10)
					if(O.pixel_x > 10)
					if(O.pixel_y < -10)
					if(O.pixel_y > 10)
		if(!orange)
	if(!orange)
	if (!O) return 0
	if (!O) return 0
	if(origin)
	if(!original)
	if (O.sharp) return 1
		if(p < 0)
		if(part.contents.len && searchDepth)
				if(PDA.owner == oldname)
	if(perfectcopy)
		if (progbar)
		if (progbar)
	if (progbar)
	if (progbar)
		if(QDELETED(user) || QDELETED(target))
	if(!radius) return list(center)
		if("range")
		if("range")
				if(R.fields["name"] == oldname)
	if(sameloc)
					if(!search_id)	break
			if( search_id && istype(A,/obj/item/weapon/card/id) )
					if(!search_pda)	break
		if(!selected || (selected.connected_robots.len > A.connected_robots.len))
		if (show_messages)
		if (show_messages)
		if (show_messages)
		if (show_messages)
		if (show_messages)
		if (show_messages)
	if(simple)
				if(SOUTH)
		if(SOUTH)
		if(SOUTHEAST)
		if(SOUTHWEST)
	if(!start || !end) return 0
		if(steps > length) return 0
			if(T)
			if(T)
			if(T)
			if(T)
	if(!t_center)
	if(T.density) cant_pass = 1
			If the values are the same, it will be a square. If they are different, it will be a rectengle.
				if(T.x>world.maxx || T.x<1)	continue//Don't want them to teleport off the map.
				if(T.y>world.maxy || T.y<1)	continue
		if(user)	. = input(usr,"AI signals detected:", "AI selection") in ais
	if(!user || isnull(user))
		if (user.loc != user_loc || target.loc != target_loc || (needhand && user.get_active_hand() != holding) || user.stat || user.weakened || user.stunned || (extra_checks && !extra_checks.Invoke()))
	if(!user || !target)
		if (!user || user.stat || user.weakened || user.stunned || !(user_loc_to_check == Location))
		if(use_user_turf)
	if(use_user_turf)	//When this is true, do_after() will check whether the user's turf has changed, rather than the user's loc.
		if("view")
		if("view")
				if(!(V in list("type","loc","locs","vars", "parent", "parent_type","verbs","ckey","key")))
	// If we're initializing, our tick limit might be over 100 (testing config), but stoplag() penalizes procs that go over.
				if(WEST)
		if(WEST)
			if(W:lit)
			if(W:lit)
			if(W:lit)
		if((world.time-time_passed)>3000)
	if(!W) return 0
	if(W.sharp) return 1
			if(WT.isOn())
			if(x>=dyabs)
			if(y>=dxabs)	//Every dyabs steps, step once in y direction
	if(zone == "r_hand") return "right hand"
//Increases delay as the server gets more overloaded,
			In either case, it will center based on offset. Offset is position from center.
		initial_delay = world.tick_lag
//Inverts the colour of an HTML string
		isscrewdriver(W)                   || \
		istype(W, /obj/item/clothing/mask/smokable/cigarette) 		      || \
	istype(W, /obj/item/weapon/bonegel)			||	\
	istype(W, /obj/item/weapon/bonesetter)
	istype(W, /obj/item/weapon/cautery)			||	\
		istype(W, /obj/item/weapon/flame/lighter/zippo)			  || \
		istype(W, /obj/item/weapon/flame/match)            		  || \
	istype(W, /obj/item/weapon/hemostat)		||	\
		istype(W, /obj/item/weapon/pen)                           || \
	istype(W, /obj/item/weapon/retractor)		||	\
	istype(W, /obj/item/weapon/scalpel)			||	\
		istype(W, /obj/item/weapon/shovel) \
		iswelder(W)					  || \
	//It will stop when it reaches an area, as areas have no loc
			keyclient_list |= M
			key_list |= M
//Last modified by Carn
			line+=locate(px,py,M.z)
			line+=locate(px,py,M.z)//Add the turf to the list
	. = list()
	. = list()
		. += LOCATE_COORDS(center.x - x, center.y + y, center.z) //lower left left
		. += LOCATE_COORDS(center.x + x, center.y + y, center.z) //lower right right
		. += LOCATE_COORDS(center.x - x, center.y - y, center.z) //upper left left
		. += LOCATE_COORDS(center.x + x, center.y - y, center.z) //upper right right
		. += LOCATE_COORDS(center.x - y, center.y + x, center.z) //lower lower left
		. += LOCATE_COORDS(center.x + y, center.y + x, center.z) //lower lower right
		. += LOCATE_COORDS(center.x - y, center.y - x, center.z) //upper upper left
		. += LOCATE_COORDS(center.x + y, center.y - x, center.z) //upper upper right
	locate(/obj/machinery/optable, M.loc) || \
	(locate(/obj/structure/bed/roller, M.loc) && prob(75)) || \
	(locate(/obj/structure/table/, M.loc) && prob(66)))
		Location = get_turf(user)
		Location = user.loc
Location where the teleport begins, target that will teleport, distance to go, density checking 0/1(yes/no).
		loc = loc.loc
			logged_list |= M
				L += T
				L += T
				L += T
				L += T
		L += t_center
//Makes sure MIDDLE is between LOW and HIGH. If not, it adjusts it. Returns the adjusted value.
		mind.name = newname
//		mob_list.Add(M)
//		mob_list.Add(M)
		moblist.Add(M)
		moblist.Add(M)
		moblist.Add(M)
		moblist.Add(M)
		moblist.Add(M)
		moblist.Add(M)
		moblist.Add(M)
		moblist.Add(M)
		moblist.Add(M)
		moblist.Add(M)
		moblist.Add(M)
/mob/proc/fully_replace_character_name(var/oldname,var/newname)
/mob/proc/rename_self(var/role, var/allow_numbers=0)
			mobs += M
			namecounts[name]++
			namecounts[name] = 1
				name += " \[dead\]"
				name += " \[ghost\]"
			name += " \[[M.real_name]\]"
			name = "[name] ([namecounts[name]])"
	name = newname
			names.Add(name)
Negative values for offset are accepted, think of it in relation to North, -x is west, -y is south. Error defaults to positive.
	new_list += AI_list
	new_list += Dead_list
	new_list += keyclient_list
	new_list += key_list
	new_list += logged_list
		newname = input(src,"You are \a [role]. Would you like to change your name to something else?", "Name change",oldname) as text
				newname = null
		newname = sanitizeName(newname, ,allow_numbers)	//returns null if the name doesn't meet some basic requirements. Tidies up a few other things like bad-characters.
		// No message for ghosts.
		// Note diagonal directions won't usually be accurate
// note range is non-pythagorean
			//Now to find a box from center location and make that our destination.
/obj/item/device/multitool,
	/obj/item/device/radio/intercom,
/obj/item/stack/cable_coil,
/obj/item/weapon/crowbar)
/obj/item/weapon/screwdriver,
	/obj/item/weapon/storage/secure/safe,
/obj/item/weapon/weldingtool,
/obj/item/weapon/wirecutters,
/obj/item/weapon/wrench,
	/obj/machinery/alarm,
	/obj/machinery/computer/security/telescreen,
	/obj/machinery/computer/security/telescreen/entertainment,
	/obj/machinery/door_timer,
	/obj/machinery/embedded_controller/radio/airlock,
	/obj/machinery/firealarm,
	/obj/machinery/flasher,
	/obj/machinery/keycard_auth,
	/obj/machinery/light_switch,
	/obj/machinery/newscaster,
	/obj/machinery/power/apc,
	/obj/machinery/requests_console,
	/obj/machinery/station_map,
	/obj/machinery/status_display,
	/obj/structure/extinguisher_cabinet,
	/obj/structure/fireaxecabinet,
	/obj/structure/mirror,
	/obj/structure/noticeboard,
	/obj/structure/reagent_dispensers/peppertank,
	/obj/structure/sign
			Offset always calculates in relation to direction faced. In other words, depending on the direction of the teleport,
		old_list.Remove(named)
			oldname = null//don't bother with the records update crap
		O=new original.type(locate(0,0,0))
		O=new original.type(original.loc)
			. = orange(distance,center)
//Orders mobs by type then by name
					O.vars[V] = original.vars[V]
			. = oview(distance,center)
			p += 4*x++ + 6;
			p += 4*(x++ - y--) + 10;
					PDA.name = "PDA-[newname] ([PDA.ownjob])"
					PDA.owner = newname
//Picks a string of symbols to display as the law number for hacked or ion laws
//Prevents robots dropping their modules.
/proc/active_ais()
proc/anyprob(value)
proc/arctan(x)
/proc/between(var/low, var/middle, var/high)
/proc/can_operate(mob/living/carbon/M)
/proc/can_puncture(obj/item/W as obj)		// For the record, WHAT THE HELL IS THIS METHOD OF DOING IT?
/proc/can_see(var/atom/source, var/atom/target, var/length=5) // I couldn't be arsed to do actual raycasting :I This is horribly inaccurate.
/proc/crash_with(msg)
/proc/dd_range(var/low, var/high, var/num)
/proc/DirBlocked(turf/loc,var/dir)
/proc/do_after(mob/user as mob, delay as num, needhand = TRUE, atom/movable/act_target = null, use_user_turf = FALSE, display_progress = TRUE, datum/callback/extra_checks)
/proc/do_mob(mob/user, mob/target, delay = 30, needhand = TRUE, display_progress = TRUE, datum/callback/extra_checks) //This is quite an ugly solution but i refuse to use the old request system.
/proc/dropsafety(var/atom/movable/A)
proc/DuplicateObject(obj/original, var/perfectcopy = 0 , var/sameloc = 0)
/proc/format_frequency(var/f)
/proc/format_text(text)
/proc/freeborg()
proc/GaussRandRound(var/sigma,var/roundto)
proc/GaussRand(var/sigma)
/proc/Get_Angle(atom/movable/start,atom/movable/end)//For beams.
/proc/get(atom/loc, type)
proc/get_cardinal_dir(atom/A, atom/B)
/proc/getcircle(turf/center, var/radius) //Uses a fast Bresenham rasterization algorithm to return the turfs in a thin circle.
/proc/get_edge_target_turf(var/atom/A, var/direction)
/proc/getline(atom/M,atom/N)//Ultra-Fast Bresenham Line-Drawing Algorithm
/proc/getmobs()
proc/get_mob_with_client_list()
/proc/get_offset_target_turf(var/atom/A, var/dx, var/dy)
/proc/get_random_colour(var/simple, var/lower, var/upper)
/proc/get_ranged_target_turf(var/atom/A, var/direction, var/range)
/proc/get_sorted_mobs()
/proc/get_step_towards2(var/atom/ref , var/atom/trg)
/proc/get_teleport_loc(turf/location,mob/target,distance = 1, density = 0, errorx = 0, errory = 0, eoffsetx = 0, eoffsety = 0)
/proc/get_turf_or_move(turf/location)
/proc/gotwallitem(loc, dir)
/proc/has_edge(obj/O as obj)
/proc/hasvar(var/datum/A, var/varname)
/proc/InRange(var/A, var/lower, var/upper)
/proc/invertHTML(HTMLstring)
/proc/ionnum()
/proc/is_blocked_turf(var/turf/T)
/proc/is_borg_item(obj/item/W as obj)
/proc/IsGuestKey(key)
proc/is_hot(obj/item/W as obj)
/proc/is_sharp(obj/O as obj)
/proc/is_surgery_tool(obj/item/W as obj)
/proc/istool(O)
/proc/LinkBlocked(turf/A, turf/B)
/proc/modulus(var/M)
proc/oview_or_orange(distance = world.view , center = usr , type)
/proc/parse_zone(zone)
/proc/reverse_direction(var/dir)
/proc/sanitize_frequency(var/f, var/low = PUBLIC_LOW_FREQ, var/high = PUBLIC_HIGH_FREQ)
/proc/select_active_ai(var/mob/user)
/proc/select_active_ai_with_fewest_borgs()
/proc/sign(x)
/proc/sortmobs()
/proc/spiral_range_turfs(dist=0, center=usr, orange=0)
/proc/stoplag(initial_delay)
/proc/topic_link(var/datum/D, var/arglist, var/content)
/proc/TurfBlockedNonWindow(turf/loc)
proc/view_or_range(distance = world.view , center = usr , type)
		progbar = new(user, delay, act_target)
		progbar = new(user, delay, target)
			progbar.update(world.time - starttime)
			progbar.update(world.time - starttime)
				px+=sdx
			px+=sdx		//Step on in x direction
				py+=sdy
			py+=sdy
		qdel(progbar)
		qdel(progbar)
//Quick type checks for some tools
Random error in tile placement x, error in tile placement y, and block offset.
			. = range(distance,center)
	real_name = newname
// result is bounded to map size
			return
		return
		return
		return
	return .
	return .
	return ( \
	return (	\
	return
	return
	return
				return 0
				return 0
				return 0
				return 0
			return 0
			return 0
			return 0
		return 0
		return 0
		return 0
		return 0
		return 0
		return 0
		return 0
	return 0
	return 0
	return 0
	return 0
	return 0
	return 0
	return 0
	return 0
			return 0//Can't recurse any higher than this.
	return 0//If we get here, we must be buried many layers deep in nested containers. Shouldn't happen
						return 1
						return 1
						return 1
						return 1
				return 1
			return 1
			return 1
			return 1
		return 1
		return 1
		return 1
	return 1
	return 1
	return 1
	return 1
	return 1
				return 1000
				return 1000
				return 1500
			return 3500
				return 3800
			return 3800
	return "<a href='?src=\ref[D];[arglist]'>[content]</a>"
		return borgs[select]
	return cant_pass
	return "#[colour]"
	return creatures
	return destination
		return (dx>=0)?90:270
			return EAST
	return f
	return get_dir(A, B) & (rand() * (dx+dy) < dy ? 3 : 12)
	return get_turf(location)
	return L
	return line
			return list()
		return list()
			return list(center)
			return loc
	return locate(x,y,A.z)
	return locate(x,y,A.z)
		return -M
		return M
	return max(low,min(high,num))
	return max(min(middle, high), low)
	return (M.lying && \
	return moblist
	return mobs
	return new_list
			return NORTH
			return NORTHEAST
			return NORTHWEST
		return null
	return null
	return O
	return "[pick("1","2","3","4","5","6","7","8","9","0")][pick("!","@","#","$","%","^","&","*")][pick("!","@","#","$","%","^","&","*")][pick("!","@","#","$","%","^","&","*")]"
	return (rand(1,value)==value)
	return replacetext(replacetext(text,"\proper ",""),"\improper ","")
	return "[round(f / 10)].[f % 10]"
	return round(GaussRand(sigma),roundto)
// Returns 0 if they can use it, a value representing why they can't if not.
//Returns: 1 if found, 0 if not.
//Returns 1 if the given item is capable of popping things like balloons, inflatable barriers, or cutting police tape.
//Returns a list of all mobs with their name
	return selected
  return sigma*y*sqrt(-2*log(rsq)/rsq)
//Returns location. Returns null if no location was found.
			return SOUTH
			return SOUTHEAST
			return SOUTHWEST
//returns random gauss number
//returns random gauss number, rounded to 'roundto'
//Returns the middle-most value
// returns the turf located at the map edge in the specified direction relative to A
// returns turf relative to A in given direction at set range
// returns turf relative to A offset in dx and dy tiles
//Returns whether or not A is the middle most value
//Returns whether or not a player is a guest using their ckey as an input
	return target
	return text("#[][][]", textr, textg, textb)
			return	//took too long
	return toReturn
		return USE_FAIL_DEAD
		return USE_FAIL_INCAPACITATED
		return USE_FAIL_IS_SILICON
		return USE_FAIL_NON_ADJACENT
		return USE_FAIL_NON_ADV_TOOL_USR
		return USE_FAIL_NONLIVING
		return USE_FAIL_NOT_IN_USER
			return WEST
	return W && W.loc && isrobot(W.loc)
	return x!=0?x/abs(x):0
	return y
					R.fields["name"] = newname
    rsq=x*x+y*y
					search_id = 0
					search_pda = 0
			selected = A
		select = input("Unshackled borg signals detected:", "Borg selection", null, null) as null|anything in borgs
			// Set eyeobj name
		set_light(origin.light_range, origin.light_power, origin.light_color)
	set waitfor = FALSE
//similar function to RANGE_TURFS(), but will search spiralling outwards from the center (like the above, but only turfs)
		//since NORTHEAST == NORTH & EAST, etc, doing it this way allows for diagonal mass drivers in the future
		sleep(i*world.tick_lag*DELTA_CALC)
		sleep(world.tick_lag)
			//Some stuff doesn't use dir properly, so we need to check pixel instead
	//Some stuff is placed directly on the wallturf (signs)
			Specifying the values above will basically draw a different sort of block.
		src << "Sorry, that [role]-name wasn't appropriate, please try another. It's possibly too long/short, has bad characters or is already taken."
		steps++
//Step-towards method of determining whether one atom can see another. Similar to viewers()
		stoplag(1)
		stoplag(1)
			switch(dir)
	switch(dir)
	switch(target.dir)//This can be done through equations but switch is the simpler method. And works fast to boot.
	switch(type)
	switch(type)
	switch(W.type)
//Takes: Anything that could possibly have variables and a varname to check.
		target = locate(1, target.y, target.z)
		target = locate(target.x, 1, target.z)
		target = locate(target.x, world.maxy, target.z)
		target = locate(world.maxx, target.y, target.z)
				temp_col  = "0[temp_col]"
	textb = num2hex(255 - b)
	textg = num2hex(255 - g)
	textr = num2hex(255 - r)
		textr = text("0[]", textb)
		textr = text("0[]", textg)
		textr = text("0[]", textr)
			the offset should remain positioned in relation to destination.*/
//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31
	//This function will recurse up the hierarchy containing src, in search of the target
			/*This will draw a block around the target turf, given what the error is.
//This will update a mob's name, real_name, mind.name, data_core records, pda and id
			T = locate(x,y,t_center.z)
			T = locate(x,y,t_center.z)
			T = locate(x,y,t_center.z)
			T = locate(x,y,t_center.z)
		toReturn += part
			toReturn += part.GetAllContents(searchDepth - 1)
Turf and target are seperate in case you want to teleport some distance from a turf the target is not standing on or something.
			turf_last1 = get_step(turf_last1,dir_alt1)
			turf_last2 = get_step(turf_last2,dir_alt2)
//Turns 1479 into 147.9
#undef DELTA_CALC
#undef HAS_FLAG
#undef LOCATE_COORDS
#undef NOT_FLAG
	// 	Unfortunately, this penalty slows down init a *lot*. So, we disable it during boot and lobby, when relatively few things should be calling this.
		//update our pda and id if we have them on our person
		//update the datacore records! This is goig to be a bit costly.
// used for disposal system
// used for mass driver
			user_loc_to_check = get_turf(user)
			user_loc_to_check = user.loc
			user << "<span class='notice'>How do you expect to do that when you're dead?</span>"
			user << "<span class='notice'>How do you propose doing that without hands?</span>"
			user << "<span class='notice'>You cannot do that in your current state.</span>"
			user << "<span class='notice'>You don't know how to operate [src].</span>"
			user << "<span class='notice'>You need to be holding [src] to do that.</span>"
			user << "<span class='notice'>You're too far away from [src] to do that.</span>"
	var/adir = get_dir(A,B)
	var/atom/a = src
	var/b1xerror = 0//Generic placing for point A in box. The lower left.
	var/b1yerror = 0
	var/b2xerror = 0//Generic placing for point B in box. The upper right.
	var/b2yerror = 0
	var/base_dir = get_dir(ref, get_step_towards(ref,trg))
	var/b = hex2num(textb)
		var/breakpoint = 0
	var/cant_pass = 0
	var/c_dist = 1
	var/colour
	var/datum/progressbar/progbar
	var/datum/progressbar/progbar
			var/destination_list[] = list()//To add turfs to list.
		var/dir_alt1 = turn(base_dir, 90)
		var/dir_alt2 = turn(base_dir, -90)
	var/dirx = 0//Generic location finding variable.
	var/diry = 0
	var/dx
	var/dxabs=abs(dx)//Absolute value of x distance
	var/dx = abs(B.x - A.x)
	var/dx=N.x-px	//x distance
	var/dy
	var/dyabs=abs(dy)
	var/dy = abs(B.y - A.y)
	var/dy=N.y-py
	var/endtime = world.time + delay
	var/endtime = world.time + delay
	//var/errorxy = round((errorx+errory)/2)//Used for diagonal boxes.
		var/free_tile = null
	var/g = hex2num(textg)
var/global/list/common_tools = list(
	var/holding = user.get_active_hand()
	var/holding = user.get_active_hand()
	var/i = 7, ch, len = length(key)
	var/i = DS2TICKS(initial_delay)
		var/iStep = get_step(A,adir&(NORTH|SOUTH))
	var/j			//Generic integer for counting
	var/line[] = list(locate(px,py,M.z))
	var/list/active = active_ais()
	var/list/AI_list = list()
	var/list/ais = active_ais()
	var/list/borgs = list()
	var/list/creatures = list()
	var/list/Dead_list = list()
	var/list/keyclient_list = list()
	var/list/key_list = list()
	var/list/L = list()
	var/list/logged_list = list()
	var/list/moblist = list()
	var/list/mobs = list()
	var/list/mobs = sortmobs()
	var/list/namecounts = list()
	var/list/names = list()
	var/list/new_list = list()
	var/list/old_list = getmobs()
		var/list/searching = GetAllContents(searchDepth = 3)
	var/list/sortmob = sortAtom(mob_list)
	var/list/toReturn = list()
var/list/wall_items = typecacheof(list(
	var/Location
			var/mob/living/silicon/ai/A = src
	var/mob/living/silicon/ai/selected
		var/mob/M = old_list[named]
		var/name = "[A.real_name] ([A.modtype] [A.braintype])"
		var/name = M.name
	var/newname
				var/obj/item/device/pda/PDA = A
				var/obj/item/weapon/card/id/ID = A
			var/obj/item/weapon/weldingtool/WT = W
	var/obj/O = null
	var/oldname = real_name
	var/p = 3 - 2 * radius
		var/pStep = get_step(A,adir&(EAST|WEST))
	var/px=M.x		//starting x
	var/py=M.y
	var/rdir = get_dir(B,A)
	var/r = hex2num(textr)
	var/sdx=sign(dx)	//Sign of x distance (+ or -)
	var/sdy=sign(dy)
		var/search_id = 1
		var/search_pda = 1
	var/select = null
	var/starttime = world.time
	var/starttime = world.time
	var/steps = 0
	var/target_loc = target.loc
			var/temp_col = "[num2hex(rand(lower,upper))]"
	var/textb = copytext(HTMLstring, 6, 8)
	var/textg = copytext(HTMLstring, 4, 6)
	var/textr = copytext(HTMLstring, 2, 4)
	var/time_passed = world.time
			var/turf/center = locate((destination.x+xoffset),(destination.y+yoffset),location.z)//So now, find the new center.
	var/turf/current = get_turf(source)
	var/turf/destination=locate(location.x+dirx,location.y+diry,location.z)
	var/turf/T
	var/turf/target = locate(A.x, A.y, A.z)
	var/turf/target_turf = get_turf(target)
	var/turf/t_center = get_turf(center)
	var/turf/temp = get_step_towards(ref,trg)
		var/turf/turf_last1 = temp
		var/turf/turf_last2 = temp
		var/user_loc_to_check
	var/user_loc = user.loc
	var/x
	var/x = 0
	var/x = 0//As a safety, we'll crawl up a maximum of ten layers
	var/x = A.x
	var/x=dxabs>>1	//Counters for steps taken, setting to distance/2
	var/x = min(world.maxx, max(1, A.x + dx))
	var/xoffset = 0//Generic counter for offset location.
  var/x,y,rsq
	var/y
	var/y=arcsin(x/sqrt(1+x*x))
	var/y = A.y
	var/y=dyabs>>1	//Bit-shifting makes me l33t.  It also makes getline() unnessecarrily fast.
	var/y = min(world.maxy, max(1, A.y + dy))
	var/yoffset = 0
	var/y = radius
	verbs += the_verb
			. = view(distance,center)
//When a borg is activated, it can choose which AI it wants to be slaved to
//When an AI is activated, it can choose from a list of non-slaved borgs to have as a slave.
//Whether or not the given item counts as cutting with an edge in terms of removing limbs
//Whether or not the given item counts as sharp in terms of dealing damage
	while( c_dist <= dist )
	while(current != target_turf)
		while(!free_tile && breakpoint < 10)
	while(loc)
  while(rsq>1 || !rsq)
	while (world.tick_usage > min(TICK_LIMIT_TO_RUN, CURRENT_TICKLIMIT))
	while (world.time < endtime)
	while (world.time < endtime)
	while (x < 10)
	while(y >= x) // only formulate 1/8 of circle
//Will return the contents of an atom recursivly to a depth of 'searchDepth'
			//world << "<b>[newname] is the AI!</b>"
			//world << sound('sound/AI/newAI.ogg')
		W.sharp													  || \
		x++
    x=2*rand()-1
			x+=dxabs
				x-=dyabs
		x = max(1, x - range)
		x = min(world.maxx, x + range)
			xoffset+=eoffsetx
			xoffset+=eoffsetx
			xoffset+=eoffsety
			xoffset+=eoffsety
		x = t_center.x - c_dist
		x = t_center.x + c_dist
		x = t_center.x - c_dist + 1
		x = t_center.x + c_dist - 1
    y=2*rand()-1
				y-=dxabs
			y+=dyabs
		y = max(1, y - range)
		y = min(world.maxy, y + range)
			yoffset-=eoffsetx//Flipped.
			yoffset+=eoffsetx//Flipped.
			yoffset-=eoffsety
			yoffset+=eoffsety
		y = t_center.y - c_dist
		y = t_center.y + c_dist
		y = t_center.y - c_dist + 1
		y = t_center.y + c_dist - 1

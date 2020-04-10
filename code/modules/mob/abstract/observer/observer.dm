/mob/abstract/observer
	name = "ghost"
	desc = "It's a g-g-g-g-ghooooost!" //jinkies!
	icon = 'icons/mob/mob.dmi'
	icon_state = "ghost"
	layer = 4
	stat = DEAD
	density = 0
	canmove = 0
	blinded = 0
	anchored = 1	//  don't get pushed around
	invisibility = INVISIBILITY_OBSERVER
	simulated = FALSE
	var/can_reenter_corpse
	var/datum/hud/living/carbon/hud = null // hud
	var/bootime = 0
	var/started_as_observer //This variable is set to 1 when you enter the game as an observer.
							//If you died in the game and are a ghsot - this will remain as null.
							//Note that this is not a reliable way to determine if admins started as observers, since they change mobs a lot.
	var/has_enabled_antagHUD = 0
	var/medHUD = 0
	var/antagHUD = 0
	universal_speak = 1
	var/atom/movable/following = null
	var/admin_ghosted = 0
	var/anonsay = 0
	var/image/ghostimage = null //this mobs ghost image, for deleting and stuff
	var/ghostvision = 1 //is the ghost able to see things humans can't?
	var/seedarkness = 1

	var/is_manifest = 0
	var/ghost_cooldown = 0

	var/obj/item/device/multitool/ghost_multitool
	incorporeal_move = 1

	mob_thinks = FALSE

/mob/abstract/observer/New(mob/body)
	if (istype(body, /mob/abstract/observer))
		return//A ghost can't become a ghost.

	sight |= SEE_TURFS | SEE_MOBS | SEE_OBJS | SEE_SELF
	see_invisible = SEE_INVISIBLE_OBSERVER
	see_in_dark = 100
	verbs += /mob/abstract/observer/proc/dead_tele

	stat = DEAD

	ghostimage = image(src.icon,src,src.icon_state)
	SSmob.ghost_darkness_images |= ghostimage
	updateallghostimages()

	var/turf/T
	if (ismob(body))
		T = get_turf(body)				//Where is the body located?
		attack_log = body.attack_log	//preserve our attack logs by copying them to our ghost

		var/originaldesc = desc
		var/o_transform = transform
		appearance = body
		desc = originaldesc
		transform = o_transform

		alpha = 127
		invisibility = initial(invisibility)

		gender = body.gender
		if(body.mind && body.mind.name)
			name = body.mind.name
		else
			if(body.real_name)
				name = body.real_name
			else
				if(gender == MALE)
					name = capitalize(pick(first_names_male)) + " " + capitalize(pick(last_names))
				else
					name = capitalize(pick(first_names_female)) + " " + capitalize(pick(last_names))

		mind = body.mind	//we don't transfer the mind but we keep a reference to it.

	if(!T)	T = pick(latejoin)			//Safety in case we cannot find the body's position
	forceMove(T)

	if(!name)							//To prevent nameless ghosts
		name = capitalize(pick(first_names_male)) + " " + capitalize(pick(last_names))
	real_name = name

	ghost_multitool = new(src)
	..()

/mob/abstract/observer/Destroy()
	stop_following()
	qdel(ghost_multitool)
	ghost_multitool = null

	if (ghostimage)
		SSmob.ghost_darkness_images -= ghostimage
		qdel(ghostimage)
		ghostimage = null
		updateallghostimages()
	return ..()

/mob/abstract/observer/Topic(href, href_list)
	if (href_list["track"])
		if(istype(href_list["track"],/mob))
			var/mob/target = locate(href_list["track"]) in mob_list
			if(target)
				ManualFollow(target)
		else
			var/atom/target = locate(href_list["track"])
			if(istype(target))
				ManualFollow(target)

/mob/abstract/observer/proc/initialise_postkey(set_timers = TRUE)
	//This function should be run after a ghost has been created and had a ckey assigned
	if (!set_timers)
		return

	//Death times are initialised if they were unset
	//get/set death_time functions are in mob_helpers.dm
	if (!get_death_time(ANIMAL))
		set_death_time(ANIMAL, world.time - RESPAWN_ANIMAL) //allow instant mouse spawning
	if (!get_death_time(MINISYNTH))
		set_death_time(MINISYNTH, world.time - RESPAWN_MINISYNTH) //allow instant drone spawning
	if (!get_death_time(CREW))
		set_death_time(CREW, world.time)

/mob/abstract/observer/attackby(obj/item/W, mob/user)
	if(istype(W,/obj/item/book/tome))
		var/mob/abstract/observer/M = src
		M.manifest(user)

/mob/abstract/observer/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	return 1
/*
Transfer_mind is there to check if mob is being deleted/not going to have a body.
Works together with spawning an observer, noted above.
*/

/mob/abstract/observer/Life()
	..()
	if(!loc) return
	if(!client) return 0

	handle_hud_glasses()

	if(antagHUD)
		var/list/target_list = list()
		for(var/mob/living/target in oview(src, 14))
			if(target.mind && target.mind.special_role)
				target_list += target
		if(target_list.len)
			assess_targets(target_list, src)
	if(medHUD)
		process_medHUD(src)

	teleport_if_needed()

/mob/abstract/observer/proc/on_restricted_level(var/check)
	if(!check)
		check = z
	//Check if they are a staff member
	if(check_rights(R_MOD|R_ADMIN|R_DEV, show_msg=FALSE, user=src))
		return FALSE
	
	//Check if the z level is in the restricted list
	if (!(check in current_map.restricted_levels))
		return FALSE
	
	return TRUE

/mob/abstract/observer/proc/teleport_to_spawn(var/message)
	if(!message)
		message = "You can not freely observe on this z-level."

	//Teleport them back to the ghost spawn
	var/obj/O = locate("landmark*Observer-Start")
	if(istype(O))
		to_chat(src, "<span class='notice'>[message]</span>")
		forceMove(O.loc)

//Teleports the observer away from z-levels they shouldnt be on, if needed.
/mob/abstract/observer/proc/teleport_if_needed()
	if(!on_restricted_level())
		return

	if(following)
		if(!iscarbon(following)) //If they are following something other than a carbon mob, teleport them
			stop_following()
			teleport_to_spawn("You can not follow \the [following] on this level.")
		else
			return
	//If they are moving around freely, teleport them
	teleport_to_spawn()
	//And update their sight settings
	updateghostsight()


/mob/abstract/observer/proc/process_medHUD(var/mob/M)
	var/client/C = M.client
	for(var/mob/living/carbon/human/patient in oview(M, 14))
		C.images += patient.hud_list[HEALTH_HUD]
		C.images += patient.hud_list[STATUS_HUD_OOC]

/mob/abstract/observer/proc/assess_targets(list/target_list, mob/abstract/observer/U)
	var/client/C = U.client
	for(var/mob/living/carbon/human/target in target_list)
		C.images += target.hud_list[SPECIALROLE_HUD]
	for(var/mob/living/silicon/target in target_list)
		C.images += target.hud_list[SPECIALROLE_HUD]
	return 1

/mob/proc/ghostize(var/can_reenter_corpse = TRUE, var/should_set_timer = TRUE)
	if(ckey)
		var/mob/abstract/observer/ghost = new(src)	//Transfer safety to observer spawning proc.
		ghost.can_reenter_corpse = can_reenter_corpse
		ghost.timeofdeath = src.stat == DEAD ? src.timeofdeath : world.time

		ghost.ckey = ckey
		ghost.client = client
		ghost.initialise_postkey(should_set_timer)
		if(ghost.client)
			if(!ghost.client.holder && !config.antag_hud_allowed)		// For new ghosts we remove the verb from even showing up if it's not allowed.
				ghost.verbs -= /mob/abstract/observer/verb/toggle_antagHUD	// Poor guys, don't know what they are missing!
		return ghost

/*
This is the proc mobs get to turn into a ghost. Forked from ghostize due to compatibility issues.
*/
/mob/living/verb/ghost()
	set category = "OOC"
	set name = "Ghost"
	set desc = "Relinquish your life and enter the land of the dead."

	if(stat == DEAD)
		announce_ghost_joinleave(ghostize(1, 0))
	else
		var/response
		if(check_rights((R_MOD|R_ADMIN), 0))
			response = alert(src, "You have the ability to Admin-Ghost. The regular Ghost verb will announce your presence to dead chat. Both variants will allow you to return to your body using 'aghost'.\n\nWhat do you wish to do?", "Are you sure you want to ghost?", "Ghost", "Admin Ghost", "Stay in body")
			if(response == "Admin Ghost")
				if(!src.client)
					return
				src.client.admin_ghost()
		else
			response = alert(src, "Are you -sure- you want to ghost?\n(You are alive. If you ghost, you won't be able to play this round for another [config.respawn_delay] minutes! You can't change your mind so choose wisely!)", "Are you sure you want to ghost?", "Ghost", "Stay in body")
		if(response != "Ghost")
			return
		resting = 1
		var/turf/location = get_turf(src)
		message_admins("[key_name_admin(usr)] has ghosted. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[location.x];Y=[location.y];Z=[location.z]'>JMP</a>)")
		log_game("[key_name_admin(usr)] has ghosted.",ckey=key_name(usr))
		var/mob/abstract/observer/ghost = ghostize(0)	//0 parameter is so we can never re-enter our body, "Charlie, you can never come baaaack~" :3
		ghost.timeofdeath = world.time // Because the living mob won't have a time of death and we want the respawn timer to work properly.
		announce_ghost_joinleave(ghost)

/mob/abstract/observer/can_use_hands()
	return FALSE

/mob/abstract/observer/is_active()
	return FALSE

/mob/abstract/observer/Stat()
	..()
	if(statpanel("Status"))
		if(emergency_shuttle)
			var/eta_status = emergency_shuttle.get_status_panel_eta()
			if(eta_status)
				stat(null, eta_status)

/mob/abstract/observer/verb/reenter_corpse()
	set category = "Ghost"
	set name = "Re-enter Corpse"
	if(!client)	return
	if(!(mind && mind.current && can_reenter_corpse))
		to_chat(src, "<span class='warning'>You have no body.</span>")
		return
	if(mind.current.key && copytext(mind.current.key,1,2)!="@")	//makes sure we don't accidentally kick any clients
		to_chat(usr, "<span class='warning'>Another consciousness is in your body... it is resisting you.</span>")
		return
	if(mind.current.ajourn && mind.current.stat != DEAD) //check if the corpse is astral-journeying (it's client ghosted using a cultist rune).
		var/found_rune
		for(var/obj/effect/rune/ethereal/R in get_turf(mind.current)) //whilst corpse is alive, we can only reenter the body if it's on the rune
			found_rune = TRUE
			break
		if(!found_rune)
			to_chat(usr, span("cult", "The astral cord that ties your body and your spirit has been severed. You are likely to wander the realm beyond until your body is finally dead and thus reunited with you."))
			return
	stop_following()
	mind.current.ajourn=0
	mind.current.key = key
	mind.current.teleop = null
	if(!admin_ghosted)
		announce_ghost_joinleave(mind, 0, "They now occupy their body again.")
	return 1

/mob/abstract/observer/verb/toggle_medHUD()
	set category = "Ghost"
	set name = "Toggle MedicHUD"
	set desc = "Toggles Medical HUD allowing you to see how everyone is doing"
	if(!client)
		return
	if(medHUD)
		medHUD = 0
		to_chat(src, "<span class='notice'><B>Medical HUD Disabled</B></span>")
	else
		medHUD = 1
		to_chat(src, "<span class='notice'><B>Medical HUD Enabled</B></span>")

/mob/abstract/observer/verb/toggle_antagHUD()
	set category = "Ghost"
	set name = "Toggle AntagHUD"
	set desc = "Toggles AntagHUD allowing you to see who is the antagonist"

	if(!client)
		return
	var/aux_staff = check_rights(R_MOD|R_ADMIN, 0)
	if(!config.antag_hud_allowed && (!client.holder || aux_staff))
		to_chat(src, "<span class='warning'>Admins have disabled this for this round.</span>")
		return
	var/mob/abstract/observer/M = src
	if(jobban_isbanned(M, "AntagHUD"))
		to_chat(src, "<span class='danger'>You have been banned from using this feature</span>")
		return
	if(config.antag_hud_restricted && !M.has_enabled_antagHUD && (!client.holder || aux_staff))
		var/response = alert(src, "If you turn this on, you will not be able to take any part in the round.","Are you sure you want to turn this feature on?","Yes","No")
		if(response == "No") return
		M.can_reenter_corpse = 0
	if(!M.has_enabled_antagHUD && (!client.holder || aux_staff))
		M.has_enabled_antagHUD = 1
	if(M.antagHUD)
		M.antagHUD = 0
		to_chat(src, "<span class='notice'><B>AntagHUD Disabled</B></span>")
	else
		M.antagHUD = 1
		to_chat(src, "<span class='notice'><B>AntagHUD Enabled</B></span>")

/mob/abstract/observer/proc/dead_tele(A in ghostteleportlocs)
	set category = "Ghost"
	set name = "Teleport"
	set desc= "Teleport to a location"
	if(!istype(usr, /mob/abstract/observer))
		to_chat(usr, "Not when you're not dead!")
		return
	usr.verbs -= /mob/abstract/observer/proc/dead_tele
	ADD_VERB_IN(usr, 30, /mob/abstract/observer/proc/dead_tele)
	var/area/thearea = ghostteleportlocs[A]
	if(!thearea)	return

	var/list/L = list()
	var/holyblock = 0

	if(usr.invisibility <= SEE_INVISIBLE_LIVING || (usr.mind in cult.current_antagonists))
		for(var/turf/T in get_area_turfs(thearea))
			if(!T.holy)
				L+=T
			else
				holyblock = 1
	else
		for(var/turf/T in get_area_turfs(thearea))
			L+=T

	if(!L || !L.len)
		if(holyblock)
			to_chat(usr, "<span class='warning'>This area has been entirely made into sacred grounds, you cannot enter it while you are in this plane of existence!</span>")
			return
		else
			to_chat(usr, "No area available.")
			return

	var/turf/P = pick(L)
	if(on_restricted_level(P.z))
		to_chat(usr, "You can not teleport to this area")
		return

	stop_following()
	usr.forceMove(pick(L))

/mob/abstract/observer/verb/follow(input in getmobs())
	set category = "Ghost"
	set name = "Follow" // "Haunt"
	set desc = "Follow and haunt a mob."

	var/target = getmobs()[input]
	if(!target) return
	ManualFollow(target)

// This is the ghost's follow verb with an argument
/mob/abstract/observer/proc/ManualFollow(var/atom/movable/target)
	if(!target || target == following || target == src)
		return

	stop_following()
	following = target
	moved_event.register(following, src, /atom/movable/proc/move_to_destination)
	destroyed_event.register(following, src, /mob/abstract/observer/proc/stop_following)

	to_chat(src, "<span class='notice'>Now following \the [following]</span>")
	move_to_destination(following, following.loc, following.loc)
	updateghostsight()

/mob/abstract/observer/proc/stop_following()
	if(following)
		to_chat(src, "<span class='notice'>No longer following \the [following]</span>")
		moved_event.unregister(following, src)
		destroyed_event.unregister(following, src)
		following = null
	

/mob/abstract/observer/move_to_destination(var/atom/movable/am, var/old_loc, var/new_loc)
	var/turf/T = get_turf(new_loc)
	if(check_holy(T))
		stop_following()
		teleport_if_needed()
		to_chat(usr, "<span class='warning'>You cannot follow something standing on holy grounds!</span>")
		return
	..()

/mob/proc/check_holy(var/turf/T)
	return 0

/mob/abstract/observer/check_holy(var/turf/T)
	if(check_rights(R_ADMIN|R_FUN, 0, src))
		return 0

	return (T && T.holy) && (invisibility <= SEE_INVISIBLE_LIVING || (mind in cult.current_antagonists))

/mob/abstract/observer/verb/jumptomob(input in getmobs()) //Moves the ghost instead of just changing the ghosts's eye -Nodrak
	set category = "Ghost"
	set name = "Jump to Mob"
	set desc = "Teleport to a mob"

	if(istype(usr, /mob/abstract/observer)) //Make sure they're an observer!
		var/target = getmobs()[input]
		if(!target) return
		var/turf/T = get_turf(target) //Turf of the destination mob

		if(T && isturf(T))	//Make sure the turf exists, then move the source to that destination.
			stop_following()
			forceMove(T)
		else
			to_chat(src, "This mob is not located in the game world.")
		
		teleport_if_needed()

/mob/abstract/observer/memory()
	set hidden = 1
	to_chat(src, "<span class='warning'>You are dead! You have no mind to store memory!</span>")

/mob/abstract/observer/add_memory()
	set hidden = 1
	to_chat(src, "<span class='warning'>You are dead! You have no mind to store memory!</span>")

/mob/abstract/observer/Post_Incorpmove()
	stop_following()
	teleport_if_needed()

/mob/abstract/observer/verb/analyze_air()
	set name = "Analyze Air"
	set category = "Ghost"

	if(!istype(usr, /mob/abstract/observer)) return

	// Shamelessly copied from the Gas Analyzers
	if (!( istype(usr.loc, /turf) ))
		return

	var/datum/gas_mixture/environment = usr.loc.return_air()

	var/pressure = environment.return_pressure()
	var/total_moles = environment.total_moles

	to_chat(src, "<span class='notice'><B>Results:</B></span>")
	if(abs(pressure - ONE_ATMOSPHERE) < 10)
		to_chat(src, "<span class='notice'>Pressure: [round(pressure,0.1)] kPa</span>")
	else
		to_chat(src, "<span class='warning'>Pressure: [round(pressure,0.1)] kPa</span>")
	if(total_moles)
		for(var/g in environment.gas)
			to_chat(src, "<span class='notice'>[gas_data.name[g]]: [round((environment.gas[g] / total_moles) * 100)]% ([round(environment.gas[g], 0.01)] moles)</span>")
		to_chat(src, "<span class='notice'>Temperature: [round(environment.temperature-T0C,0.1)]&deg;C ([round(environment.temperature,0.1)]K)</span>")
		to_chat(src, "<span class='notice'>Heat Capacity: [round(environment.heat_capacity(),0.1)]</span>")

/proc/find_mouse_spawnpoint(var/ZLevel)
	//This function will attempt to find a good spawnpoint for rats, and prevent them from spawning in closed vent systems with no escape
	//It does this by bruteforce: Picks a random vent, tests if it has enough connections, if not, repeat
	//Continues either until a valid one is found (in which case we return it), or until we hit a limit on attempts..
	//If we hit the limit without finding a valid one, then the best one we found is selected

	var/list/found_vents = list()
	for(var/obj/machinery/atmospherics/unary/vent_pump/v in SSmachinery.processing_machines)
		if(!v.welded && v.z == ZLevel)
			found_vents.Add(v)

	if (found_vents.len == 0)
		return null//Every vent on the map is welded? Sucks to be a mouse

	var/attempts = 0
	var/max_attempts = min(20, found_vents.len)
	var/target_connections = 30//Any vent with at least this many connections is good enough

	var/obj/machinery/atmospherics/unary/vent_pump/bestvent = null
	var/best_connections = 0
	while (attempts < max_attempts)
		attempts++
		var/obj/machinery/atmospherics/unary/vent_pump/testvent = pick(found_vents)

		if (!testvent.network)//this prevents runtime errors
			continue

		var/turf/T = get_turf(testvent)



		//We test the environment of the tile, to see if its habitable for a mouse
		//-----------------------------------
		var/atmos_suitable = 1

		var/maxtemp = 390
		var/mintemp = 210
		var/min_oxy = 5
		var/max_phoron = 1
		var/max_co2 = 5
		var/min_pressure = 80

		var/datum/gas_mixture/Environment = T.return_air()
		if(Environment)

			if(Environment.temperature > maxtemp)
				atmos_suitable = 0
			else if (Environment.temperature < mintemp)
				atmos_suitable = 0
			else if(Environment.gas["oxygen"] < min_oxy)
				atmos_suitable = 0
			else if(Environment.gas["phoron"] > max_phoron)
				atmos_suitable = 0
			else if(Environment.gas["carbon_dioxide"] > max_co2)
				atmos_suitable = 0
			else if(Environment.return_pressure() < min_pressure)
				atmos_suitable = 0
		else
			atmos_suitable = 0

		if (!atmos_suitable)
			continue
		//----------------------




		//Now we test the vent connections, and ensure the vent we spawn at is connected enough to give the mouse free movement
		var/list/connections = list()
		for(var/obj/machinery/atmospherics/unary/vent_pump/temp_vent in testvent.network.normal_members)
			if(temp_vent.welded)
				continue
			if(temp_vent == testvent)//Our testvent shouldn't count itself as a connection
				continue

			connections += temp_vent

		if(connections.len > best_connections)
			best_connections = connections.len
			bestvent = testvent

		if (connections.len >= target_connections)
			return testvent
			//If we've found one that's good enough, then we stop looking


	//IF we get here, then we hit the limit without finding a valid one.
	//This would probably only be likely to happen if the station is full of holes and pipes are broken everywhere
	if (bestvent == null)
		//If bestvent is null, then every vent we checked was either welded or unsafe to spawn at. The user will be given a message reflecting this.
		return null
	else
		return bestvent

/mob/abstract/observer/verb/view_manfiest()
	set name = "Show Crew Manifest"
	set category = "Ghost"

	var/dat
	dat += "<h4>Crew Manifest</h4>"
	dat += SSrecords.get_manifest(OOC = 1)

	src << browse(dat, "window=manifest;size=370x420;can_close=1")

//This is called when a ghost is drag clicked to something.
/mob/abstract/observer/MouseDrop(atom/over)
	if(!usr || !over) return
	if(isobserver(usr) && usr.client && isliving(over))
		var/mob/living/M = over
		// If they an admin, see if control can be resolved.
		if(usr.client.holder && usr.client.holder.cmd_ghost_drag(src,M))
			return
		// Otherwise, see if we can possess the target.
		if(usr == src && try_possession(M))
			return
	if(istype(over, /obj/machinery/drone_fabricator))
		var/obj/machinery/drone_fabricator/fab = over
		if(fab.create_drone(src))
			return

	return ..()

/mob/abstract/observer/proc/try_possession(var/mob/living/M)
	if(!config.ghosts_can_possess_animals)
		to_chat(usr, "<span class='warning'>Ghosts are not permitted to possess animals.</span>")
		return 0
	if(!M.can_be_possessed_by(src))
		return 0
	return M.do_possession(src)

//Used for drawing on walls with blood puddles as a spooky ghost.
/mob/abstract/observer/verb/bloody_doodle()
	set category = "Ghost"
	set name = "Write in blood"
	set desc = "If the round is sufficiently spooky, write a short message in blood on the floor or a wall. Remember, no IC in OOC or OOC in IC."

	if(!(config.cult_ghostwriter))
		to_chat(src, "<span class='warning'>That verb is not currently permitted.</span>")
		return

	if (!src.stat)
		return

	if (usr != src)
		return 0 //something is terribly wrong

	if(!round_is_spooky())
		to_chat(src, "<span class='warning'>The veil is not thin enough for you to do that.</span>")
		return

	var/list/choices = list()
	for(var/obj/effect/decal/cleanable/blood/B in view(1,src))
		if(B.amount > 0)
			choices += B

	if(!choices.len)
		to_chat(src, "<span class = 'warning'>There is no blood to use nearby.</span>")
		return

	var/obj/effect/decal/cleanable/blood/choice = input(src,"What blood would you like to use?") in null|choices

	var/direction = input(src,"Which way?","Tile selection") as anything in list("Here","North","South","East","West")
	var/turf/simulated/T = src.loc
	if (direction != "Here")
		T = get_step(T,text2dir(direction))

	if (!istype(T))
		to_chat(src, "<span class='warning'>You cannot doodle there.</span>")
		return

	if(!choice || choice.amount == 0 || !(src.Adjacent(choice)))
		return

	var/doodle_color = (choice.basecolor) ? choice.basecolor : "#A10808"

	var/num_doodles = 0
	for (var/obj/effect/decal/cleanable/blood/writing/W in T)
		num_doodles++
	if (num_doodles > 4)
		to_chat(src, "<span class='warning'>There is no space to write on!</span>")
		return

	var/max_length = 50

	var/message = sanitize(input("Write a message. It cannot be longer than [max_length] characters.","Blood writing", ""))

	if (message)

		if (length(message) > max_length)
			message += "-"
			to_chat(src, "<span class='warning'>You ran out of blood to write with!</span>")

		var/obj/effect/decal/cleanable/blood/writing/W = new(T)
		W.basecolor = doodle_color
		W.update_icon()
		W.message = message
		W.add_hiddenprint(src)
		W.visible_message("<span class='warning'>Invisible fingers crudely paint something in blood on [T]...</span>")

/mob/abstract/observer/pointed(atom/A as mob|obj|turf in view())
	if(!..())
		return 0
	usr.visible_message("<span class='deadsay'><b>[src]</b> points to [A]</span>")
	return 1

/mob/abstract/observer/proc/manifest(mob/user)
	is_manifest = 0
	if(!is_manifest)
		is_manifest = 1
		verbs += /mob/abstract/observer/proc/toggle_visibility_verb
		verbs += /mob/abstract/observer/proc/ghost_whisper
		verbs += /mob/abstract/observer/proc/move_item

	if(src.invisibility != 0)
		user.visible_message( \
			"<span class='warning'>\The [user] drags ghost, [src], to our plane of reality!</span>", \
			"<span class='warning'>You drag [src] to our plane of reality!</span>" \
		)
		toggle_visibility(1)
	else
		user.visible_message ( \
			"<span class='warning'>\The [user] just tried to smash \his book into that ghost!  It's not very effective.</span>", \
			"<span class='warning'>You get the feeling that the ghost can't become any more visible.</span>" \
		)


/mob/abstract/observer/proc/toggle_icon(var/icon)
	if(!client)
		return

	var/iconRemoved = 0
	for(var/image/I in client.images)
		if(I.icon_state == icon)
			iconRemoved = 1
			client.images -= I
			qdel(I)

	if(!iconRemoved)
		var/image/J = image('icons/mob/mob.dmi', loc = src, icon_state = icon)
		client.images += J

/mob/abstract/observer/proc/toggle_visibility_verb()
	set category = "Ghost"
	set name = "Toggle Visibility"
	set desc = "Allows you to turn (in)visible (almost) at will."

	toggle_visibility()

/mob/abstract/observer/proc/toggle_visibility(var/forced = 0)
	var/toggled_invisible
	if(!forced && invisibility && world.time < toggled_invisible + 600)
		to_chat(src, "You must gather strength before you can turn visible again...")
		return

	if(invisibility == 0)
		toggled_invisible = world.time
		visible_message("<span class='emote'>It fades from sight...</span>", "<span class='info'>You are now invisible.</span>")
	else
		to_chat(src, "<span class='info'>You are now visible!</span>")

	invisibility = invisibility == INVISIBILITY_OBSERVER ? 0 : INVISIBILITY_OBSERVER
	// Give the ghost a cult icon which should be visible only to itself
	toggle_icon("cult")

/mob/abstract/observer/proc/ghost_whisper()
	set category = "Ghost"
	set name = "Spectral Whisper"

	if(is_manifest)  //Only able to whisper if it's hit with a tome.
		var/list/options = list()
		for(var/mob/living/Ms in view(src))
			options += Ms
		var/mob/living/M = input(src, "Select who to whisper to:", "Whisper to?", null) as null|mob in options
		if(!M)
			return 0
		var/msg = sanitize(input(src, "Message:", "Spectral Whisper") as text|null)
		if(msg)
			log_say("SpectralWhisper: [key_name(usr)]->[M.key] : [msg]")
			to_chat(M, "<span class='warning'> You hear a strange, unidentifiable voice in your head... <font color='purple'>[msg]</font></span>")
			to_chat(src, "<span class='warning'> You said: '[msg]' to [M].</span>")
		else
			return
		return 1
	else
		to_chat(src, "<span class='danger'>You have not been pulled past the veil!</span>")

/mob/abstract/observer/proc/move_item()
	set category = "Ghost"
	set name = "Move item"
	set desc = "Move a small item to where you are."

	if(ghost_cooldown > world.time)
		return

	if(!is_manifest)
		return

	var/turf/T = get_turf(src)

	var/list/obj/item/choices = list()
	for(var/obj/item/I in range(1))
		if(I.w_class <= 2)
			choices += I

	if(!choices.len)
		to_chat(src, "<span class='warning'>There are no suitable items nearby.</span>")
		return

	var/obj/item/choice = input(src, "What item would you like to pull?") as null|anything in choices
	if(!choice || !(choice in range(1)) || choice.w_class > 2)
		return

	if(!is_manifest)
		return

	if(step_to(choice, T))
		choice.visible_message("<span class='warning'>\The [choice] suddenly moves!</span>")

	ghost_cooldown = world.time + 500

/mob/abstract/observer/verb/toggle_anonsay()
	set category = "Ghost"
	set name = "Toggle Anonymous Chat"
	set desc = "Toggles showing your key in dead chat."

	src.anonsay = !src.anonsay
	if(anonsay)
		to_chat(src, "<span class='info'>Your key won't be shown when you speak in dead chat.</span>")
	else
		to_chat(src, "<span class='info'>Your key will be publicly visible again.</span>")

/mob/abstract/observer/canface()
	return 1

/mob/proc/can_admin_interact()
    return 0

/mob/abstract/observer/can_admin_interact()
	return check_rights(R_ADMIN, 0, src)

/mob/abstract/observer/verb/toggle_ghostsee()
	set name = "Toggle Ghost Vision"
	set desc = "Toggles your ability to see things only ghosts can see, like other ghosts"
	set category = "Ghost"
	ghostvision = !(ghostvision)
	updateghostsight()
	to_chat(usr, "You [(ghostvision?"now":"no longer")] have ghost vision.")

/mob/abstract/observer/verb/toggle_darkness()
	set name = "Toggle Darkness"
	set category = "Ghost"
	seedarkness = !(seedarkness)
	updateghostsight()

/mob/abstract/observer/proc/updateghostsight()
	//if they are on a restricted level, then set the ghost vision for them.
	if(on_restricted_level())
		//On the restricted level they have the same sight as the mob
		sight &= ~(SEE_TURFS | SEE_MOBS | SEE_OBJS)
		see_in_dark = 2
		see_invisible = SEE_INVISIBLE_OBSERVER
	else
		//Outside of the restrcited level, they have enhanced vision
		sight |= (SEE_TURFS | SEE_MOBS | SEE_OBJS)
		see_in_dark = 100
		see_invisible = SEE_INVISIBLE_LEVEL_TWO

		if (!seedarkness)
			see_invisible = SEE_INVISIBLE_NOLIGHTING
		else
			see_invisible = SEE_INVISIBLE_OBSERVER
			if (!ghostvision)
				see_invisible = SEE_INVISIBLE_LIVING

	updateghostimages()

/proc/updateallghostimages()
	for (var/mob/abstract/observer/O in player_list)
		O.updateghostimages()

/mob/abstract/observer/proc/updateghostimages()
	if (!client)
		return
	if (seedarkness || !ghostvision)
		client.images -= SSmob.ghost_darkness_images
		client.images |= SSmob.ghost_sightless_images
	else
		//add images for the 60inv things ghosts can normally see when darkness is enabled so they can see them now
		client.images -= SSmob.ghost_sightless_images
		client.images |= SSmob.ghost_darkness_images
		if (ghostimage)
			client.images -= ghostimage //remove ourself

mob/abstract/observer/MayRespawn(var/feedback = 0, var/respawn_type = null)
	if(!client)
		return 0
	if(config.antag_hud_restricted && has_enabled_antagHUD == 1)
		if(feedback)
			to_chat(src, "<span class='warning'>antagHUD restrictions prevent you from respawning.</span>")
		return 0

	if (respawn_type)
		var/timedifference = world.time- get_death_time(respawn_type)
		var/respawn_time = 0
		if (respawn_type == CREW)
			respawn_time = config.respawn_delay *600
		else if (respawn_type == ANIMAL)
			respawn_time = RESPAWN_ANIMAL
		else if (respawn_type == MINISYNTH)
			respawn_time = RESPAWN_MINISYNTH

		if (respawn_time && timedifference >= respawn_time)
			return 1
		else if (feedback)
			var/timedifference_text = time2text(respawn_time - timedifference,"mm:ss")
			to_chat(src, "<span class='warning'>You must have been dead for [respawn_time/600] minute\s to respawn. You have [timedifference_text] left.</span>")
		return 0

	return 1

/atom/proc/extra_ghost_link()
	return

/mob/extra_ghost_link(var/atom/ghost)
	if(client && eyeobj)
		return "|<a href='byond://?src=\ref[ghost];track=\ref[eyeobj]'>\[E\]</a>"

/mob/abstract/observer/extra_ghost_link(var/atom/ghost)
	if(mind && mind.current)
		return "|<a href='byond://?src=\ref[ghost];track=\ref[mind.current]'>\[B\]</a>"

/proc/ghost_follow_link(var/atom/target, var/atom/ghost)
	if((!target) || (!ghost)) return
	. = "<a href='byond://?src=\ref[ghost];track=\ref[target]'>\[F\]</a>"
	. += target.extra_ghost_link(ghost)


//Opens the Ghost Spawner Menu
/mob/abstract/observer/verb/ghost_spawner()
	set category = "Ghost"
	set name = "Ghost Spawner"
	
	if(!ROUND_IS_STARTED)
		to_chat(usr, "<span class='danger'>The round hasn't started yet!</span>")
		return

	SSghostroles.vui_interact(src)

/mob/abstract/observer/verb/submitpai()
	set category = "Ghost"
	set name = "Submit pAI personality"
	set desc = "Submits you pAI personality to the pAI candidate pool."

	if(jobban_isbanned(src, "pAI"))
		to_chat(src, "You are job banned from the pAI position.")
		return
	SSpai.recruitWindow(src)

/mob/abstract/observer/verb/revokepai()
	set category = "Ghost"
	set name = "Revoke pAI personality"
	set desc = "Removes you from the pAI candidite pool."

	if(SSpai.revokeCandidancy(src))
		to_chat(src, "You have been removed from the pAI candidate pool.")

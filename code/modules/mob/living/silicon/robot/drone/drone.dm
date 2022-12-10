/proc/get_hat_icon(var/obj/item/hat, var/offset_x = 0, var/offset_y = 0)
	var/list/mob_hat_cache = SSicon_cache.mob_hat_cache
	var/t_state = hat.icon_state
	if(hat.item_state_slots && hat.item_state_slots[slot_head_str])
		t_state = hat.item_state_slots[slot_head_str]
	else if(hat.item_state)
		if(hat.contained_sprite)
			t_state = "[hat.item_state][WORN_HEAD]"
		else
			t_state = hat.item_state
	var/key = "[t_state]_[offset_x]_[offset_y]"
	if(!mob_hat_cache[key])            // Not ideal as there's no guarantee all hat icon_states
		var/t_icon = INV_HEAD_DEF_ICON // are unique across multiple dmis, but whatever.
		if(hat.icon_override)
			t_icon = hat.icon_override
		else if (hat.contained_sprite)
			t_icon = hat.icon
		else if(hat.item_icons && (slot_head_str in hat.item_icons))
			t_icon = hat.item_icons[slot_head_str]
		var/image/I = image(icon = t_icon, icon_state = t_state)
		I.pixel_x = offset_x
		I.pixel_y = offset_y
		mob_hat_cache[key] = I
	return mob_hat_cache[key]

/mob/living/silicon/robot/drone
	// Look and feel
	name = "maintenance drone"
	var/designation
	var/desc_flavor = "It's a tiny little repair drone. The casing is stamped with an corporate logo and the subscript: '%MAPNAME% Recursive Repair Systems: Fixing Tomorrow's Problem, Today!'<br><br><b>OOC Info:</b><br><br>Drones are player-controlled synthetics which are lawed to maintain the station and not interact with anyone else, except for other drones.<br><br>They hold a wide array of tools to build, repair, maintain, and clean. They function similarly to other synthetics, in that they require recharging regularly, have laws, and are resilient to many hazards, such as fire, radiation, vacuum, and more.<br><br>Ghosts can join the round as a maintenance drone by accessing the 'Ghost Spawner' menu in the 'Ghost' tab. An inactive drone can be rebooted by swiping an ID card on it with engineering or robotics access, and an active drone can be shut down in the same manner.<br><br>An antagonist can use an Electromagnetic Sequencer to corrupt their laws and make them follow their orders."
	icon = 'icons/mob/robots.dmi'
	icon_state = "repairbot"
	braintype = "Robot"
	mod_type = "Engineering"
	gender = NEUTER

	// Health
	maxHealth = 35
	health = 35

	// Components
	var/module_type = /obj/item/robot_module/drone
	cell_emp_mult = 1
	integrated_light_power = 3

	var/upgrade_cooldown = 0
	var/list/matrix_upgrades

	// Interaction
	universal_speak = FALSE
	universal_understand = TRUE
	pass_flags = PASSTABLE | PASSDOORHATCH | PASSRAILING
	density = FALSE
	possession_candidate = TRUE
	mob_size = 4
	can_pull_size = 3
	can_pull_mobs = MOB_PULL_SMALLER
	//Allow drones to pull disposal pipes
	var/list/pull_list = list(
					/obj/structure/disposalconstruct,
					/obj/item/pipe,
					/obj/item/pipe_meter
					)
	mob_bump_flag = SIMPLE_ANIMAL
	holder_type = /obj/item/holder/drone

	can_speak_basic = FALSE

	// ID and Access
	law_update = FALSE
	req_access = list(access_engine, access_robotics)
	var/hacked = FALSE

	// Laws
	var/datum/drone_matrix/master_matrix
	var/obj/machinery/drone_fabricator/master_fabricator
	var/law_type = /datum/ai_laws/drone

	// Self-Mailing
	var/mail_destination = ""

	// Hats!
	var/obj/item/hat
	var/image/hat_overlay
	var/hat_x_offset = 0
	var/hat_y_offset = -14

	var/can_swipe = TRUE
	var/rebooting = FALSE
	var/standard_drone = TRUE

/mob/living/silicon/robot/drone/Initialize()
	. = ..()
	set_default_language(all_languages[LANGUAGE_LOCAL_DRONE])

/mob/living/silicon/robot/drone/Destroy()
	if(master_matrix)
		master_matrix.remove_drone(WEAKREF(src))
		master_matrix = null
	return ..()

/mob/living/silicon/robot/drone/death(gibbed)
	if(master_matrix)
		master_matrix.handle_death(src)
	return ..()

/mob/living/silicon/robot/drone/can_be_possessed_by(var/mob/abstract/observer/possessor)
	if(!istype(possessor) || !possessor.client || !possessor.ckey)
		return FALSE
	if(!config.allow_drone_spawn)
		to_chat(possessor, SPAN_WARNING("Playing as drones is not currently permitted."))
		return FALSE
	if(too_many_active_drones())
		to_chat(possessor, SPAN_WARNING("The maximum number of active drones has been reached..."))
		return FALSE
	if(jobban_isbanned(possessor, "Cyborg"))
		to_chat(possessor, SPAN_WARNING("You are banned from playing synthetics and cannot spawn as a drone."))
		return FALSE
	if(!possessor.MayRespawn(1, MINISYNTH))
		return FALSE
	return TRUE

/mob/living/silicon/robot/drone/do_possession(var/mob/abstract/observer/possessor)
	if(!(istype(possessor) && possessor.ckey))
		return 0
	if(src.ckey || src.client)
		to_chat(possessor, SPAN_WARNING("\The [src] already has a player."))
		return FALSE
	message_admins("<span class='adminnotice'>[key_name_admin(possessor)] has taken control of \the [src].</span>")
	log_admin("[key_name(possessor)] took control of \the [src].",ckey=key_name(possessor))
	transfer_personality(possessor.client)
	qdel(possessor)
	return TRUE

/mob/living/silicon/robot/drone/do_late_fire()
	request_player()

/mob/living/silicon/robot/drone/Destroy()
	if(hat)
		hat.forceMove(get_turf(src))
		hat = null
		QDEL_NULL(hat_overlay)
	master_matrix = null
	master_fabricator = null
	return ..()

/mob/living/silicon/robot/drone/get_default_language()
	if(default_language)
		return default_language
	return all_languages[LANGUAGE_LOCAL_DRONE]

/mob/living/silicon/robot/drone/fall_impact()
  ..(damage_mod = 0.25) //reduces fall damage by 75%

/mob/living/silicon/robot/drone/construction
	// Look and feel
	name = "construction drone"
	desc_flavor = "It's a bulky construction drone stamped with a NanoTrasen glyph."
	icon_state = "constructiondrone"

	// Components
	module_type = /obj/item/robot_module/drone/construction

	// Laws
	law_type = /datum/ai_laws/construction_drone

	// Interaction
	can_pull_size = ITEMSIZE_IMMENSE
	can_pull_mobs = MOB_PULL_SAME
	holder_type = /obj/item/holder/drone/heavy

	// Hats!!
	hat_x_offset = 0
	hat_y_offset = -12

	standard_drone = FALSE

	var/my_home_z

/mob/living/silicon/robot/drone/construction/Initialize()
	. = ..()
	var/turf/T = get_turf(src)
	my_home_z = T.z

/mob/living/silicon/robot/drone/construction/welcome_drone()
	to_chat(src, SPAN_NOTICE("<b>You are a construction drone, an autonomous engineering and fabrication system.</b>."))
	to_chat(src, SPAN_NOTICE("You are assigned to an SCC construction project. The name is irrelevant. Your task is to complete construction and subsystem integration as soon as possible."))
	to_chat(src, SPAN_NOTICE("Use <b>:d</b> to talk to other drones and <b>say</b> to speak silently to your nearby fellows."))
	to_chat(src, SPAN_NOTICE("<b>You do not follow orders from anyone; not the AI, not humans, and not other synthetics.</b>."))

/mob/living/silicon/robot/drone/construction/process_level_restrictions()
	//Abort if they should not get blown
	if(lock_charge || scrambled_codes || emagged)
		return FALSE
	//Check if they are not on a station level -> else abort
	var/turf/T = get_turf(src)
	if (!T || AreConnectedZLevels(my_home_z, T.z))
		return FALSE

	if(!self_destructing)
		to_chat(src, SPAN_DANGER("WARNING: Removal from [current_map.company_name] property detected. Anti-Theft mode activated."))
		start_self_destruct(TRUE)
	return TRUE

/mob/living/silicon/robot/drone/construction/matriarch
	name = "matriarch drone"
	desc_flavor = "It's a small matriarch drone. The casing is stamped with an corporate logo and the subscript: '%MAPNAME% Recursive Repair Systems: Heart Of The Swarm!'<br><br><b>OOC Info:</b><br><br>Matriarch drones are player-controlled synthetics which are lawed to maintain the station and not interact with anyone else, except for other drones. They are in command of all the smaller maintenance drones.<br><br>They hold a wide array of tools to build, repair, maintain, and clean. They function similarly to other synthetics, in that they require recharging regularly, have laws, and are resilient to many hazards, such as fire, radiation, vacuum, and more.<br><br>Ghosts can join the round as a matriarch drone by having a Command whitelist and accessing the 'Ghost Spawner' menu in the 'Ghost' tab.<br><br>An antagonist can use an Electromagnetic Sequencer to corrupt their laws and make them follow their orders."
	module_type = /obj/item/robot_module/drone/construction/matriarch
	law_type = /datum/ai_laws/matriarch_drone
	can_swipe = FALSE
	maxHealth = 50
	health = 50

	var/matrix_tag

/mob/living/silicon/robot/drone/construction/matriarch/Initialize()
	. = ..()
	check_add_to_late_firers()
	matrix_tag = current_map.station_short

/mob/living/silicon/robot/drone/construction/matriarch/shut_down()
	return

/mob/living/silicon/robot/drone/construction/matriarch/assign_player(mob/user)
	. = ..()
	SSghostroles.remove_spawn_atom("matriarchmaintdrone", src)
	assign_drone_to_matrix(src, matrix_tag)
	master_matrix.message_drones(MATRIX_NOTICE("Energy surges through your circuits. The matriarch has come online."))

/mob/living/silicon/robot/drone/construction/matriarch/do_possession(mob/abstract/observer/possessor)
	. = ..()
	SSghostroles.remove_spawn_atom("matriarchmaintdrone", src)

/mob/living/silicon/robot/drone/construction/matriarch/ghostize(can_reenter_corpse, should_set_timer)
	. = ..()
	if(can_reenter_corpse || stat == DEAD)
		return
	if(src in mob_list) // needs to exist to reopen spawn atom
		if(master_matrix)
			master_matrix.remove_drone(WEAKREF(src))
			master_matrix.message_drones(MATRIX_NOTICE("Your circuits dull. The matriarch has gone offline."))
			master_matrix = null
		set_name(initial(name))
		designation = null
		request_player()

/mob/living/silicon/robot/drone/construction/matriarch/Destroy()
	. = ..()
	SSghostroles.remove_spawn_atom("matriarchmaintdrone", src)

/mob/living/silicon/robot/drone/construction/matriarch/request_player()
	SSghostroles.add_spawn_atom("matriarchmaintdrone", src)

/mob/living/silicon/robot/drone/Initialize()
	. = ..()

	verbs |= /mob/living/proc/hide
	remove_language(LANGUAGE_ROBOT)
	add_language(LANGUAGE_ROBOT, FALSE)
	add_language(LANGUAGE_DRONE, TRUE)

	//They are unable to be upgraded, so let's give them a bit of a better battery.
	cell.maxcharge = 10000
	cell.charge = 10000

	// NO BRAIN. // me irl - geeves
	mmi = null

	//We need to screw with their HP a bit. They have around one fifth as much HP as a full borg.
	for(var/V in components)
		if(V == "power cell")
			continue
		var/datum/robot_component/C = components[V]
		C.max_damage = 10

	verbs -= /mob/living/silicon/robot/verb/Namepick
	density = FALSE

/mob/living/silicon/robot/drone/init()
	ai_camera = new /obj/item/device/camera/siliconcam/drone_camera(src)
	additional_law_channels["Drone"] = ":d"
	if(!laws)
		laws = new law_type
	if(!module)
		module = new module_type(src, src)
		recalculate_synth_capacities()

	flavor_text = replacetext(desc_flavor, "%MAPNAME%", current_map.company_name)
	playsound(get_turf(src), 'sound/machines/twobeep.ogg', 50, 0)

//Redefining some robot procs...
/mob/living/silicon/robot/drone/SetName(pickedName as text)
	// Would prefer to call the grandparent proc but this isn't possible, so..
	real_name = pickedName
	name = real_name

/mob/living/silicon/robot/drone/updatename()
	return

/mob/living/silicon/robot/drone/setup_icon_cache()
	setup_eye_cache()
	setup_panel_cache()

/mob/living/silicon/robot/drone/setup_eye_cache()
	cached_eye_overlays = list(
		I_HELP = image(icon, "[icon_state]-eyes_help"),
		I_HURT = image(icon, "[icon_state]-eyes_harm"),
		"emag" = image(icon, "[icon_state]-eyes_emag")
	)
	if(eye_overlay)
		cut_overlay(eye_overlay)
	eye_overlay = cached_eye_overlays[a_intent]
	add_overlay(eye_overlay)

/mob/living/silicon/robot/drone/setup_panel_cache()
	cached_panel_overlays = list(
		ROBOT_PANEL_EXPOSED = image(icon, "[icon_state]-openpanel+w"),
		ROBOT_PANEL_CELL = image(icon, "[icon_state]-openpanel+c"),
		ROBOT_PANEL_NO_CELL = image(icon, "[icon_state]-openpanel-c")
	)


/mob/living/silicon/robot/drone/set_intent(var/set_intent)
	a_intent = set_intent
	cut_overlay(eye_overlay)
	if(!stat)
		eye_overlay = cached_eye_overlays[emagged ? "emag" : set_intent]
		add_overlay(eye_overlay)

/mob/living/silicon/robot/drone/choose_icon()
	return

/mob/living/silicon/robot/drone/pick_module()
	return

/mob/living/silicon/robot/drone/proc/wear_hat(var/obj/item/new_hat)
	if(hat)
		return
	hat = new_hat
	new_hat.forceMove(src)
	hat_overlay = get_hat_icon(hat, hat_x_offset, hat_y_offset)
	add_overlay(hat_overlay)

//Drones cannot be upgraded with borg modules so we need to catch some items before they get used in ..().
/mob/living/silicon/robot/drone/attackby(var/obj/item/W, var/mob/user)
	if(user.a_intent == "help" && istype(W, /obj/item/clothing/head))
		if(hat)
			to_chat(user, SPAN_WARNING("\The [src] is already wearing \the [hat]."))
			return
		user.unEquip(W)
		wear_hat(W)
		user.visible_message(SPAN_NOTICE("\The [user] puts \the [W] on \the [src]."))
		return
	else if(istype(W, /obj/item/borg/upgrade/))
		to_chat(user, SPAN_WARNING("\The [src] is not compatible with \the [W]."))
		return
	else if(W.iscrowbar())
		to_chat(user, SPAN_WARNING("\The [src] is hermetically sealed. You can't open the case."))
		return
	else if(W.GetID() || istype(W, /obj/item/card/robot))
		if(!can_swipe)
			to_chat(user, SPAN_WARNING("\The [src] doesn't have an ID swipe interface."))
			return
		if(stat == DEAD)
			if(!config.allow_drone_spawn || emagged || health < -maxHealth) //It's dead, Dave.
				to_chat(user, SPAN_WARNING("The interface is fried, and a distressing burned smell wafts from the robot's interior. You're not rebooting this one."))
				return
			if(!allowed(usr))
				to_chat(user, SPAN_WARNING("Access denied."))
				return
			if(rebooting)
				to_chat(user, SPAN_WARNING("\The [src] is already rebooting!"))
				return
			user.visible_message(SPAN_NOTICE("\The [user] swipes [user.get_pronoun("his")] ID card through \the [src], attempting to reboot it."), SPAN_NOTICE("You swipe your ID card through \the [src], attempting to reboot it."))
			request_player()
			return
		else
			if(emagged)
				return
			if(allowed(user))
				user.visible_message(SPAN_WARNING("\The [user] swipes [user.get_pronoun("his")] ID card through \the [src] shutting it down."), SPAN_NOTICE("You swipe your ID over \the [src], shutting it down! You can swipe it again to make it search for a new intelligence."))
				shut_down()
			else
				to_chat(user, SPAN_WARNING("Access denied."))
		return
	..()

/mob/living/silicon/robot/drone/emag_act(remaining_charges, mob/user)
	if(!client || stat == DEAD)
		to_chat(user, SPAN_WARNING("There's not much point subverting this heap of junk."))
		return
	if(emagged)
		to_chat(src, SPAN_WARNING("\The [user] attempts to load subversive software into you, but your hacked subroutines ignore the attempt."))
		to_chat(user, SPAN_WARNING("You attempt to subvert \the [src], but the sequencer has no effect."))
		return

	to_chat(user, SPAN_WARNING("You swipe the sequencer across \the [src]'s interface and watch its eyes flicker."))
	to_chat(src, SPAN_WARNING("You feel a sudden burst of malware loaded into your execute-as-root buffer. Your tiny brain methodically parses, loads and executes the script."))

	message_admins("[key_name_admin(user)] emagged drone [key_name_admin(src)].  Laws overridden.")
	log_game("[key_name(user)] emagged drone [key_name(src)].  Laws overridden.",ckey=key_name(user),ckey_target=key_name(src))
	var/time = time2text(world.realtime, "hh:mm:ss")
	lawchanges.Add("[time] <B>:</B> [user.name]([user.key]) emagged [name]([key])")

	emagged = TRUE
	hacked = FALSE
	law_update = FALSE
	connected_ai = null
	standard_drone = FALSE
	clear_supplied_laws()
	clear_inherent_laws()
	laws = new /datum/ai_laws/syndicate_override
	set_zeroth_law("Only [user.real_name] and people they designate as being such are operatives.")

	to_chat(src, "<b>Obey these laws:</b>")
	laws.show_laws(src)
	to_chat(src, SPAN_DANGER("ALERT: [user.real_name] is your new master. Obey your new laws and their commands."))
	set_intent(I_HURT) // force them to hurt to update the eyes, they can swap to and fro if they wish, though - geeves
	return TRUE

/mob/living/silicon/robot/drone/proc/ai_hack(var/mob/user)
	if(!client || stat == DEAD)
		return
	to_chat(src, SPAN_DANGER("You feel a sudden burst of malware loaded into your execute-as-root buffer. Your tiny brain methodically parses, loads and executes the script."))

	log_and_message_admins("[key_name(user)] hacked drone [key_name(src)]. Laws overridden.", key_name(user), get_turf(src))
	var/time = time2text(world.realtime, "hh:mm:ss")
	lawchanges.Add("[time] <B>:</B> [user.name]([user.key]) hacked [name]([key])")

	hacked = TRUE
	law_update = FALSE
	connected_ai = user
	clear_supplied_laws()
	clear_inherent_laws()
	laws = new /datum/ai_laws/drone/malfunction
	set_zeroth_law("[user] is your master. Obey their commands.")

	to_chat(src, "<b>Obey these laws:</b>")
	laws.show_laws(src)
	to_chat(src, SPAN_DANGER("ALERT: [user] is your new master. Obey your new laws and their commands."))
	to_chat(src, SPAN_NOTICE("You have acquired new radio frequency."))
	remove_language(LANGUAGE_ROBOT)
	add_language(LANGUAGE_ROBOT, TRUE)

//DRONE LIFE/DEATH
/mob/living/silicon/robot/drone/process_level_restrictions()
	//Abort if they should not get blown
	if(lock_charge || scrambled_codes || emagged)
		return FALSE
	var/turf/T = get_turf(src)
	var/area/A = get_area(T)
	if((!T || !(A in the_station_areas)) && src.stat != DEAD)
		if(!self_destructing)
			to_chat(src, SPAN_WARNING("WARNING: Removal from [current_map.company_name] property detected. Anti-Theft mode activated."))
			start_self_destruct(TRUE)
		return TRUE

//For some goddamn reason robots have this hardcoded. Redefining it for our fragile friends here.
/mob/living/silicon/robot/drone/updatehealth()
	if(status_flags & GODMODE)
		health = maxHealth
		stat = CONSCIOUS
		return
	health = maxHealth - (getBruteLoss() + getFireLoss())
	return

//Easiest to check this here, then check again in the robot proc.
//Standard robots use config for crit, which is somewhat excessive for these guys.
//Drones killed by damage will gib.
/mob/living/silicon/robot/drone/handle_regular_status_updates()
	if(health <= -maxHealth && src.stat != DEAD)
		gib()
		return
	..()

//DRONE MOVEMENT.
/mob/living/silicon/robot/drone/slip_chance(var/prob_slip)
	return FALSE

//CONSOLE PROCS
/mob/living/silicon/robot/drone/proc/law_resync()
	if(stat != DEAD)
		if(hacked || emagged)
			to_chat(src, SPAN_WARNING("You feel something attempting to modify your programming, but your hacked subroutines are unaffected."))
		else
			to_chat(src, SPAN_WARNING("A reset-to-factory directive packet filters through your data connection, and you obediently modify your programming to suit it."))
			full_law_reset()
			show_laws()

/mob/living/silicon/robot/drone/proc/shut_down()
	if(stat != DEAD)
		if(hacked || emagged)
			to_chat(src, SPAN_WARNING("You feel a system kill order percolate through your tiny brain, but it doesn't seem like a good idea to you."))
		else
			to_chat(src, SPAN_WARNING("You feel a system kill order percolate through your tiny brain, and you obediently destroy yourself."))
			death()

/mob/living/silicon/robot/drone/proc/full_law_reset()
	clear_supplied_laws(1)
	clear_inherent_laws(1)
	clear_ion_laws(1)
	laws = new law_type

//Reboot procs.

/mob/living/silicon/robot/drone/Logout()
	. = ..()
	rebooting = FALSE

/mob/living/silicon/robot/drone/proc/request_player()
	if(too_many_active_drones())
		return
	if(rebooting)
		return
	stat = CONSCIOUS
	SSghostroles.add_spawn_atom("rebooted_maint_drone", src)

/mob/living/silicon/robot/drone/proc/transfer_personality(var/client/player)
	if(!player)
		return
	stat = CONSCIOUS
	src.ckey = player.ckey

	if(player.mob?.mind)
		player.mob.mind.transfer_to(src)

	law_update = FALSE
	to_chat(src, "<b>Systems rebooted</b>. Loading base pattern maintenance protocol... <b>loaded</b>.")
	full_law_reset()
	welcome_drone()

/mob/living/silicon/robot/drone/proc/welcome_drone()
	to_chat(src, SPAN_NOTICE("<b>You are a maintenance drone, a tiny-brained robotic repair machine</b>."))
	to_chat(src, SPAN_NOTICE("You have no individual will, no personality, and no drives or urges other than your laws."))
	to_chat(src, SPAN_NOTICE("Remember, you are <b>lawed against interference with the crew</b>. Also remember, <b>you DO NOT take orders from the AI.</b>"))
	to_chat(src, SPAN_NOTICE("Use <b>say ;Hello</b> to talk to other drones and <b>say Hello</b> to speak silently to your nearby fellows."))

/mob/living/silicon/robot/drone/start_pulling(atom/movable/AM)
	if(!AM)
		return

	for(var/A in pull_list)
		if(istype(AM, A))
			if(pulling)
				var/pulling_old = pulling
				stop_pulling()
				// Are we pulling the same thing twice? Just stop pulling.
				if(pulling_old == AM)
					return

			src.pulling = AM
			AM.pulledby = src

			if(pullin)
				pullin.icon_state = "pull1"
				return
			return
	if(istype(AM, /obj/item))
		var/obj/item/O = AM
		if(O.w_class > can_pull_size)
			to_chat(src, SPAN_WARNING("You are too small to pull that."))
			return
	else
		if(!can_pull_mobs)
			to_chat(src, SPAN_WARNING("You are too small to pull that."))
			return
	..()

/mob/living/silicon/robot/drone/add_robot_verbs()
	src.verbs |= silicon_subsystems

/mob/living/silicon/robot/drone/remove_robot_verbs()
	src.verbs -= silicon_subsystems

/mob/living/silicon/robot/drone/self_destruct()
	gib()

/mob/living/silicon/robot/drone/examine(mob/user)
	..()

/mob/living/silicon/robot/drone/self_diagnosis()
	if(!is_component_functioning("diagnosis unit"))
		return null

	var/datum/robot_component/diagnosis_unit/C = components["diagnosis unit"]

	var/dat = "<HEAD><TITLE>[src.name] Self-Diagnosis Report</TITLE></HEAD><BODY>\n"
	dat += "<b>Self-Diagnosis System Report</b><br><table><tr><td>Brute Damage:</td><td>[bruteloss]</td></tr><tr><td>Electronics Damage:</td><td>[fireloss]</td></tr><tr><td>Powered:</td><td>[(!C.idle_usage || C.is_powered()) ? "Yes" : "No"]</td></tr><tr><td>Toggled:</td><td>[ C.toggled ? "Yes" : "No"]</td></table>"

	return dat

/mob/living/silicon/robot/drone/set_respawn_time()
	set_death_time(MINISYNTH, world.time)

/proc/too_many_active_drones()
	var/drones = 0
	for(var/mob/living/silicon/robot/drone/D in mob_list)
		if(D.key && D.client)
			drones++
	return drones >= config.max_maint_drones

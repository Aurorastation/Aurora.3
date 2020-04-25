/proc/get_hat_icon(var/obj/item/hat, var/offset_x = 0, var/offset_y = 0)
	var/list/mob_hat_cache = SSicon_cache.mob_hat_cache
	var/t_state = hat.icon_state
	if(hat.item_state_slots && hat.item_state_slots[slot_head_str])
		t_state = hat.item_state_slots[slot_head_str]
	else if(hat.item_state)
		t_state = hat.item_state
	var/key = "[t_state]_[offset_x]_[offset_y]"
	if(!mob_hat_cache[key])            // Not ideal as there's no guarantee all hat icon_states
		var/t_icon = INV_HEAD_DEF_ICON // are unique across multiple dmis, but whatever.
		if(hat.icon_override)
			t_icon = hat.icon_override
		else if(hat.item_icons && (slot_head_str in hat.item_icons))
			t_icon = hat.item_icons[slot_head_str]
		var/image/I = image(icon = t_icon, icon_state = t_state)
		I.pixel_x = offset_x
		I.pixel_y = offset_y
		mob_hat_cache[key] = I
	return mob_hat_cache[key]

/mob/living/silicon/robot/drone
	// Look and feel
	name = "drone"
	real_name = "drone"
	icon = 'icons/mob/robots.dmi'
	icon_state = "repairbot"
	braintype = "Robot"
	gender = NEUTER

	// Health
	maxHealth = 35
	health = 35

	// Components
	var/module_type = /obj/item/robot_module/drone
	cell_emp_mult = 1
	integrated_light_power = 3
	local_transmit = TRUE

	// Interaction
	universal_speak = FALSE
	universal_understand = TRUE
	pass_flags = PASSTABLE | PASSDOORHATCH
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

	// ID and Access
	law_update = FALSE
	req_access = list(access_engine, access_robotics)
	var/hacked = FALSE

	// Laws
	var/obj/machinery/drone_fabricator/master_fabricator
	var/law_type = /datum/ai_laws/drone

	// Self-Mailing
	var/mail_destination = ""

	// Hats!
	var/obj/item/hat
	var/hat_x_offset = 0
	var/hat_y_offset = -13

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

/mob/living/silicon/robot/drone/Destroy()
	if(hat)
		hat.forceMove(get_turf(src))
		hat = null
	return ..()

/mob/living/silicon/robot/drone/construction
	// Look and feel
	icon_state = "constructiondrone"

	// Components
	module_type = /obj/item/robot_module/drone/construction

	// Laws
	law_type = /datum/ai_laws/construction_drone

	// Interaction
	can_pull_size = 5
	can_pull_mobs = MOB_PULL_SAME
	holder_type = /obj/item/holder/drone/heavy

	// Hats!!
	hat_x_offset = 1
	hat_y_offset = -12

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
	updateicon()
	density = FALSE

/mob/living/silicon/robot/drone/init()
	ai_camera = new /obj/item/device/camera/siliconcam/drone_camera(src)
	additional_law_channels["Drone"] = ":d"
	if(!laws)
		laws = new law_type
	if(!module)
		module = new module_type(src)

	flavor_text = "It's a tiny little repair drone. The casing is stamped with an corporate logo and the subscript: '[current_map.company_name] Recursive Repair Systems: Fixing Tomorrow's Problem, Today!'"
	playsound(get_turf(src), 'sound/machines/twobeep.ogg', 50, 0)

//Redefining some robot procs...
/mob/living/silicon/robot/drone/SetName(pickedName as text)
	// Would prefer to call the grandparent proc but this isn't possible, so..
	real_name = pickedName
	name = real_name

/mob/living/silicon/robot/drone/updatename()
	real_name = "maintenance drone ([rand(100,999)])"
	name = real_name

/mob/living/silicon/robot/drone/updateicon()
	cut_overlays()
	if(stat == CONSCIOUS)
		if(!emagged)
			add_overlay("eyes-[icon_state]")
		else
			add_overlay("eyes-[icon_state]-emag")
	if(hat) // Let the drones wear hats.
		add_overlay(get_hat_icon(hat, hat_x_offset, hat_y_offset))

/mob/living/silicon/robot/drone/choose_icon()
	return

/mob/living/silicon/robot/drone/pick_module()
	return

/mob/living/silicon/robot/drone/proc/wear_hat(var/obj/item/new_hat)
	if(hat)
		return
	hat = new_hat
	new_hat.forceMove(src)
	updateicon()

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
	else if(istype(W, /obj/item/card/id)||istype(W, /obj/item/device/pda))
		if(stat == DEAD)
			if(!config.allow_drone_spawn || emagged || health < -maxHealth) //It's dead, Dave.
				to_chat(user, SPAN_WARNING("The interface is fried, and a distressing burned smell wafts from the robot's interior. You're not rebooting this one."))
				return
			if(!allowed(usr))
				to_chat(user, SPAN_WARNING("Access denied."))
				return
			user.visible_message(SPAN_NOTICE("\The [user] swipes \his ID card through \the [src], attempting to reboot it."), SPAN_NOTICE("You swipe your ID card through \the [src], attempting to reboot it."))
			request_player()
			return
		else
			user.visible_message(SPAN_WARNING("\The [user] swipes \his ID card through \the [src], attempting to shut it down."), SPAN_WARNING("You swipe your ID card through \the [src], attempting to shut it down."))
			if(emagged)
				return
			if(allowed(user))
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
	clear_supplied_laws()
	clear_inherent_laws()
	laws = new /datum/ai_laws/syndicate_override
	set_zeroth_law("Only [user.real_name] and people they designate as being such are operatives.")

	to_chat(src, "<b>Obey these laws:</b>")
	laws.show_laws(src)
	to_chat(src, SPAN_DANGER("ALERT: [user.real_name] is your new master. Obey your new laws and \his commands."))
	updateicon()
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
	to_chat(src, span("notice", "You have acquired new radio frequency."))
	remove_language(LANGUAGE_ROBOT)
	add_language(LANGUAGE_ROBOT, TRUE)

//DRONE LIFE/DEATH
/mob/living/silicon/robot/drone/process_level_restrictions()
	var/turf/T = get_turf(src)
	var/area/A = get_area(T)
	if((!T || !(A in the_station_areas)) && src.stat != DEAD)
		to_chat(src, SPAN_WARNING("WARNING: Removal from NanoTrasen property detected. Anti-Theft mode activated."))
		gib()
		return
	return

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

/mob/living/silicon/robot/drone/proc/request_player()
	if(too_many_active_drones())
		return
	var/datum/ghosttrap/G = get_ghost_trap("maintenance drone")
	G.request_player(src, "Someone is attempting to reboot a maintenance drone.", 30 SECONDS)

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

/mob/living/silicon/robot/drone/examine(mob/user)
	..()
	var/msg
	if(emagged)
		msg += "Their eye glows red."
	else
		msg += "Their eye glows green."
	to_chat(user, msg)

/mob/living/silicon/robot/drone/construction/welcome_drone()
	to_chat(src, SPAN_NOTICE("<b>You are a construction drone, an autonomous engineering and fabrication system.</b>."))
	to_chat(src, SPAN_NOTICE("You are assigned to a NanoTrasen construction project. The name is irrelevant. Your task is to complete construction and subsystem integration as soon as possible."))
	to_chat(src, SPAN_NOTICE("Use <b>:d</b> to talk to other drones and <b>say</b> to speak silently to your nearby fellows."))
	to_chat(src, SPAN_NOTICE("<b>You do not follow orders from anyone; not the AI, not humans, and not other synthetics.</b>."))

/mob/living/silicon/robot/drone/construction/init()
	..()
	flavor_text = "It's a bulky construction drone stamped with a NanoTrasen glyph."

/mob/living/silicon/robot/drone/construction/updatename()
	real_name = "construction drone ([rand(100,999)])"
	name = real_name

/mob/living/silicon/robot/drone/construction/process_level_restrictions()
	//Abort if they should not get blown
	if(lock_charge || scrambled_codes || emagged)
		return
	//Check if they are not on station level -> abort
	var/turf/T = get_turf(src)
	if(!T || isNotStationLevel(T.z))
		return
	to_chat(src, SPAN_WARNING("WARNING: Lost contact with controller. Anti-Theft mode activated."))
	gib()

/proc/too_many_active_drones()
	var/drones = 0
	for(var/mob/living/silicon/robot/drone/D in mob_list)
		if(D.key && D.client)
			drones++
	return drones >= config.max_maint_drones
/mob/living/silicon/robot/drone/mining
	name = "NT-MD-000"
	desc_flavor = "It's a small mining drone. The casing is stamped with an corporate logo and the subscript: '%MAPNAME% Automated Pickaxe!'<br><br><b>OOC Info:</b><br><br>Mining drones are player-controlled synthetics which are lawed to serve the crew and excavate for ore.<br><br>They hold a wide array of tools to explore mining sites and extract ore. They function similarly to other synthetics, in that they require recharging regularly, have laws, and are resilient to many hazards, such as fire, radiation, vacuum, and more.<br><br>Ghosts can join the round as a mining drone by accessing the 'Ghost Spawner' menu in the 'Ghost' tab. An inactive drone can be rebooted by swiping an ID card on it with mining or robotics access, and an active drone can be shut down in the same manner.<br><br>An antagonist can use an Electromagnetic Sequencer to corrupt their laws and make them follow their orders."
	icon_state = "miningdrone"
	mod_type = "Mining"
	law_type = /datum/ai_laws/mining_drone
	module_type = /obj/item/robot_module/mining_drone
	holder_type = /obj/item/holder/drone/mining
	maxHealth = 45
	health = 45
	pass_flags = PASSTABLE|PASSRAILING
	req_access = list(access_mining, access_robotics)
	id_card_type = /obj/item/card/id/minedrone
	speed = -1
	hat_x_offset = 1
	hat_y_offset = -12
	standard_drone = FALSE
	var/list/allowed_areas = list(/area/exoplanet, /area/shuttle/mining, /area/shuttle/intrepid) //Needed for the bot to go mining
	var/seeking_player = FALSE
	var/health_upgrade
	var/ranged_upgrade
	var/drill_upgrade

/mob/living/silicon/robot/drone/mining/Initialize()
	. = ..()

	verbs |= /mob/living/proc/hide

	//They are unable to be upgraded, so let's give them a bit of a better battery.
	cell.maxcharge = 10000
	cell.charge = 10000

	mmi = /obj/item/organ/internal/mmi_holder/circuit

	// Allows mining drones to pull ore boxes, might be useful for supporting miners
	pull_list |= /obj/structure/ore_box

	//We need to screw with their HP a bit. They have around one fifth as much HP as a full borg.
	for(var/V in components)
		if(V != "power cell")
			var/datum/robot_component/C = components[V]
			C.max_damage = 15

	verbs -= /mob/living/silicon/robot/verb/Namepick
	verbs -= /mob/living/silicon/robot/drone/verb/set_mail_tag
	update_icon()
	density = FALSE

/mob/living/silicon/robot/drone/mining/examine(mob/user)
	. = ..()
	if(health_upgrade)
		to_chat(user, SPAN_NOTICE("\The [src] appears to have a reinforced chassis."))
	if(ranged_upgrade || drill_upgrade)
		var/output_text = "\The [src]'s lights indicates it has"
		if(ranged_upgrade && drill_upgrade)
			output_text += " fully upgraded mining equipment."
		else if(ranged_upgrade)
			output_text += " a stationbound class KA mounted to it."
		else if(drill_upgrade)
			output_text += " a jackhammer drill mounted to it."
		to_chat(user, SPAN_NOTICE(output_text))

/mob/living/silicon/robot/drone/mining/request_player()
	if(too_many_active_drones())
		return
	seeking_player = TRUE
	SSghostroles.add_spawn_atom("mining_drone", src)

/mob/living/silicon/robot/drone/mining/assign_player(var/mob/user)
	if(src.ckey)
		SSghostroles.remove_spawn_atom("mining_drone", src)
		return
	src.ckey = user.ckey
	seeking_player = FALSE
	welcome_drone()

	return src

/mob/living/silicon/robot/drone/mining/welcome_drone()
	to_chat(src, SPAN_DANGER("<b>You are a mining drone, a tiny-brained robotic industrial machine.</b>"))
	to_chat(src, SPAN_DANGER("You have little individual will, some personality, and no drives or urges other than your laws and the art of mining."))
	to_chat(src, SPAN_DANGER("Remember, <b>you DO NOT take orders from the AI.</b>"))

/mob/living/silicon/robot/drone/mining/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/borg/upgrade))
		to_chat(user, SPAN_WARNING("\The [src] is not compatible with \the [W]."))
		return

	if(istype(W, /obj/item/device/mine_bot_upgrade))
		var/obj/item/device/mine_bot_upgrade/MBU = W
		MBU.upgrade_bot(src, user)
		return

	else if (W.GetID())
		if(!allowed(user))
			to_chat(user, SPAN_WARNING("Access denied."))
			return
		if(ckey || client)
			user.visible_message(SPAN_WARNING("\The [user] swipes [user.get_pronoun("his")] ID card through \the [src] shutting it down."), SPAN_NOTICE("You swipe your ID over \the [src], shutting it down! You can swipe it again to make it search for a new intelligence."))
			shut_down()
			return
		if(seeking_player)
			to_chat(user, SPAN_WARNING("\The [src] is already in the reboot process."))
			return
		if(!config.allow_drone_spawn || emagged || health < -maxHealth) //It's dead, Dave.
			to_chat(user, SPAN_WARNING("The interface is fried, and a distressing burned smell wafts from the robot's interior. You're not rebooting this one."))
			return

		user.visible_message(SPAN_WARNING("\The [user] swipes [user.get_pronoun("his")] ID card through \the [src], attempting to reboot it."), SPAN_WARNING("You swipe your ID card through \the [src], attempting to reboot it."))
		request_player()
		return
	..()

/mob/living/silicon/robot/drone/mining/process_level_restrictions()
	//Abort if they should not get blown
	if(lock_charge || scrambled_codes || emagged)
		return FALSE
	//Check if they are not on a station level -> else abort
	var/turf/T = get_turf(src)
	if (!T || isStationLevel(T.z))
		return FALSE
	if(is_type_in_list(get_area(T), allowed_areas))
		return FALSE
	if(!self_destructing)
		to_chat(src, SPAN_DANGER("WARNING: Removal from [current_map.company_name] property detected. Anti-Theft mode activated."))
		start_self_destruct(TRUE)
	return TRUE

/mob/living/silicon/robot/drone/mining/update_robot_light()
	if(lights_on)
		set_light(5, 1, LIGHT_COLOR_FIRE, angle = LIGHT_OMNI)
	else
		set_light(0)

/**********************Minebot Upgrades**********************/

/obj/item/device/mine_bot_upgrade
	name = "minebot drill upgrade"
	desc = "A minebot upgrade."
	icon_state = "mainboard"
	icon = 'icons/obj/module.dmi'

/obj/item/device/mine_bot_upgrade/proc/upgrade_bot(var/mob/living/silicon/robot/drone/mining/M, mob/user)
	if(M.drill_upgrade)
		to_chat(user, SPAN_WARNING("[src] already has a drill upgrade installed!"))
		return
	M.mod_type = initial(M.mod_type)
	M.uneq_all()
	QDEL_NULL(M.module)
	if(M.ranged_upgrade)
		M.module = new /obj/item/robot_module/mining_drone/drillandka(M, M)
	else
		M.module = new /obj/item/robot_module/mining_drone/drill(M, M)
	M.drill_upgrade = TRUE
	M.module.rebuild()
	M.recalculate_synth_capacities()
	to_chat(user, SPAN_NOTICE("You successfully install \the [src] into \the [M]."))
	qdel(src)

/obj/item/device/mine_bot_upgrade/health
	name = "minebot chassis upgrade"

/obj/item/device/mine_bot_upgrade/health/upgrade_bot(var/mob/living/silicon/robot/drone/mining/M, mob/user)
	if(M.health_upgrade)
		to_chat(user, SPAN_WARNING("[src] already has a reinforced chassis!"))
		return
	M.maxHealth = 100
	M.health += 55
	for(var/V in M.components)
		if(V != "power cell")
			var/datum/robot_component/C = M.components[V]
			C.max_damage = 30
	M.health_upgrade = TRUE
	to_chat(user, SPAN_NOTICE("You successfully install \the [src] into \the [M]."))
	qdel(src)

/obj/item/device/mine_bot_upgrade/ka
	name = "minebot kinetic accelerator upgrade"

/obj/item/device/mine_bot_upgrade/ka/upgrade_bot(var/mob/living/silicon/robot/drone/mining/M, mob/user)
	if(M.ranged_upgrade)
		to_chat(user, "[src] already has a KA upgrade installed!")
		return
	M.mod_type = initial(M.mod_type)
	M.uneq_all()
	QDEL_NULL(M.module)
	if(M.drill_upgrade)
		M.module = new /obj/item/robot_module/mining_drone/drillandka(M, M)
	else
		M.module = new /obj/item/robot_module/mining_drone/ka(M, M)
	M.ranged_upgrade = TRUE
	M.module.rebuild()
	M.recalculate_synth_capacities()
	to_chat(user, SPAN_NOTICE("You successfully install \the [src] into \the [M]."))
	qdel(src)

/mob/living/silicon/robot/drone/mining/roundstart/Initialize()
	. = ..()
	check_add_to_late_firers()
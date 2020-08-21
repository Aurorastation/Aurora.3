/mob/living/silicon/robot/drone/mining
	icon_state = "miningdrone"
	mod_type = "Mining"
	law_type = /datum/ai_laws/mining_drone
	module_type = /obj/item/robot_module/mining_drone/basic
	holder_type = /obj/item/holder/drone/mining
	maxHealth = 45
	health = 45
	pass_flags = PASSTABLE
	req_access = list(access_mining, access_robotics)
	id_card_type = /obj/item/card/id/minedrone
	speed = -1
	var/seeking_player = FALSE
	var/health_upgrade
	var/ranged_upgrade
	var/melee_upgrade
	var/drill_upgrade

/mob/living/silicon/robot/drone/mining/Initialize()
	. = ..()

	verbs |= /mob/living/proc/hide
	remove_language(LANGUAGE_ROBOT)
	remove_language(LANGUAGE_DRONE)
	add_language(LANGUAGE_TCB, TRUE)
	add_language(LANGUAGE_EAL, TRUE)

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

/mob/living/silicon/robot/drone/mining/updatename()
	real_name = "NT-I-[rand(100,999)]"
	name = real_name

/mob/living/silicon/robot/drone/mining/init()
	ai_camera = new /obj/item/device/camera/siliconcam/drone_camera(src)
	if(!laws)
		laws = new law_type
	if(!module)
		module = new module_type(src, src)

	flavor_text = "It's a tiny little mining drone. The casing is stamped with an corporate logo and the subscript: '[current_map.company_name] Automated Pickaxe!'"
	playsound(src.loc, 'sound/machines/twobeep.ogg', 50, 0)

/mob/living/silicon/robot/drone/mining/request_player()
	if(too_many_active_drones())
		return
	seeking_player = TRUE
	SSghostroles.add_spawn_atom("mining_drone", src)
	var/area/A = get_area(src)
	if(A)
		say_dead_direct("Someone is attempting to reboot a mining drone in [A.name]! Spawn in as it by using the ghost spawner menu in the ghost tab.")

/mob/living/silicon/robot/drone/mining/proc/spawn_into_mining_drone(var/mob/user)
	if(src.ckey)
		return
	src.ckey = user.ckey
	SSghostroles.remove_spawn_atom("mining_drone", src)
	seeking_player = FALSE
	welcome_drone()

/mob/living/silicon/robot/drone/mining/welcome_drone()
	to_chat(src, SPAN_DANGER("<b>You are a mining drone, a tiny-brained robotic industrial machine.</b>"))
	to_chat(src, SPAN_DANGER("You have little individual will, some personality, and no drives or urges other than your laws and the art of mining."))
	to_chat(src, SPAN_DANGER("Remember, <b>you DO NOT take orders from the AI.</b>"))

/mob/living/silicon/robot/drone/mining/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/borg/upgrade))
		to_chat(user, SPAN_WARNING("\The [src] is not compatible with \the [W]."))
		return

	else if (istype(W, /obj/item/card/id) || istype(W, /obj/item/device/pda))
		if(!allowed(user))
			to_chat(user, SPAN_WARNING("Access denied."))
			return
		if(seeking_player)
			to_chat(user, SPAN_WARNING("\The [src] is already in the reboot process."))
			return
		if(!config.allow_drone_spawn || emagged || health < -maxHealth) //It's dead, Dave.
			to_chat(user, SPAN_WARNING("The interface is fried, and a distressing burned smell wafts from the robot's interior. You're not rebooting this one."))
			return

		user.visible_message(SPAN_WARNING("\The [user] swipes \his ID card through \the [src], attempting to reboot it."), SPAN_WARNING("You swipe your ID card through \the [src], attempting to reboot it."))
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
	if(!self_destructing)
		to_chat(src, SPAN_DANGER("WARNING: Removal from [current_map.company_name] property detected. Anti-Theft mode activated."))
		start_self_destruct(TRUE)
	return TRUE

/**********************Minebot Upgrades**********************/

/obj/item/device/mine_bot_upgrade
	name = "minebot drill upgrade"
	desc = "A minebot upgrade."
	icon_state = "mainboard"
	icon = 'icons/obj/module.dmi'

/obj/item/device/mine_bot_upgrade/afterattack(var/mob/living/silicon/robot/drone/mining/M, mob/user, proximity)
	if(!istype(M) || !proximity)
		return
	if(upgrade_bot(M, user))
		to_chat(user, SPAN_NOTICE("You successfully install \the [src] into \the [M]."))

/obj/item/device/mine_bot_upgrade/proc/upgrade_bot(var/mob/living/silicon/robot/drone/mining/M, mob/user)
	if(M.melee_upgrade)
		to_chat(user, SPAN_WARNING("[src] already has a drill upgrade installed!"))
		return
	M.mod_type = initial(M.mod_type)
	M.uneq_all()
	qdel(M.module)
	M.module = null
	if(M.ranged_upgrade)
		new /obj/item/robot_module/mining_drone/drillandka(M)
	else
		new /obj/item/robot_module/mining_drone/drill(M)
	M.melee_upgrade = TRUE
	M.module.rebuild()
	M.recalculate_synth_capacities()
	qdel(src)
	return TRUE

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
	qdel(src)
	return TRUE

/obj/item/device/mine_bot_upgrade/ka
	name = "minebot kinetic accelerator upgrade"

/obj/item/device/mine_bot_upgrade/ka/upgrade_bot(var/mob/living/silicon/robot/drone/mining/M, mob/user)
	if(M.ranged_upgrade)
		to_chat(user, "[src] already has a KA upgrade installed!")
		return
	M.mod_type = initial(M.mod_type)
	M.uneq_all()
	qdel(M.module)
	M.module = null
	if(M.melee_upgrade)
		new /obj/item/robot_module/mining_drone/drillandka(M)
	else
		new /obj/item/robot_module/mining_drone/ka(M)
	M.ranged_upgrade = TRUE
	M.module.rebuild()
	M.recalculate_synth_capacities()
	qdel(src)
	return TRUE
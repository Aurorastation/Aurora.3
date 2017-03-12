/mob/living/silicon/robot/drone/mining
	icon_state = "miningdrone"
	law_type = /datum/ai_laws/mining_drone
	module_type = /obj/item/weapon/robot_module/mining_drone
	holder_type = /obj/item/weapon/holder/drone/mining
	maxHealth = 45
	health = 45
	pass_flags = PASSTABLE
	req_access = list(access_mining, access_robotics)
	idcard_type = /obj/item/weapon/card/id/synthetic/minedrone
	speed = -1
	var/health_upgrade
	var/ranged_upgrade
	var/melee_upgrade
	var/drill_upgrade

/mob/living/silicon/robot/drone/mining/New()

	..()

	verbs += /mob/living/proc/hide
	remove_language("Robot Talk")
	add_language("Drone Talk", 1)

	//They are unable to be upgraded, so let's give them a bit of a better battery.
	cell.maxcharge = 10000
	cell.charge = 10000

	// NO BRAIN.
	mmi = null

	//We need to screw with their HP a bit. They have around one fifth as much HP as a full borg.
	for(var/V in components) if(V != "power cell")
		var/datum/robot_component/C = components[V]
		C.max_damage = 15

	verbs -= /mob/living/silicon/robot/verb/Namepick
	updateicon()
	density = 0

/mob/living/silicon/robot/drone/mining/init()
	aiCamera = new/obj/item/device/camera/siliconcam/drone_camera(src)
	additional_law_channels["Drone"] = ":d"
	if(!laws) laws = new law_type
	if(!module) module = new module_type(src)

	flavor_text = "It's a tiny little mining drone. The casing is stamped with an corporate logo and the subscript: '[company_name] Automated Pickaxe!'"
	playsound(src.loc, 'sound/machines/twobeep.ogg', 50, 0)

/mob/living/silicon/robot/drone/mining/welcome_drone()
	src << "<b>You are a mining drone, a tiny-brained robotic industrial machine</b>."
	src << "You have little individual will, some personality, and no drives or urges other than your laws and the art of mining."
	src << "Remember, <b>you DO NOT take orders from the AI.</b>"
	src << "Use <b>say ;Hello</b> to talk to other drones and <b>say Hello</b> to speak silently to your nearby fellows."

/mob/living/silicon/robot/drone/mining/attackby(var/obj/item/weapon/W, var/mob/user)

	if(istype(W, /obj/item/borg/upgrade/))
		user << "<span class='danger'>\The [src] is not compatible with \the [W].</span>"
		return

	else if (istype(W, /obj/item/weapon/card/id)||istype(W, /obj/item/device/pda))

		if(stat == 2)

			var/choice = input("Look at your icon - is this what you want?") in list("Reboot","Recycle")
			if(choice=="Reboot")

				if(!config.allow_drone_spawn || emagged || health < -maxHealth) //It's dead, Dave.
					user << "<span class='danger'>The interface is fried, and a distressing burned smell wafts from the robot's interior. You're not rebooting this one.</span>"
					return

				if(!allowed(usr))
					user << "<span class='danger'>Access denied.</span>"
					return

				user.visible_message("<span class='danger'>\The [user] swipes \his ID card through \the [src], attempting to reboot it.</span>", "<span class='danger'>>You swipe your ID card through \the [src], attempting to reboot it.</span>")
				request_player()
				return

			else
				var/obj/item/weapon/card/id/ID = W
				if(!allowed(usr))
					user << "<span class='danger'>Access denied.</span>"
					return

				user.visible_message("<span class='danger'>\The [user] swipes \his ID card through \the [src], recycling it into points.</span>", "<span class='danger'>>You swipe your ID card through \the [src], recycling it into points.</span>")
				ID.mining_points += 800
				if(health_upgrade)
					ID.mining_points += 600
					health_upgrade = 0
				if(ranged_upgrade)
					ID.mining_points += 600
					ranged_upgrade = 0
				if(melee_upgrade)
					ID.mining_points += 400
					melee_upgrade = 0
				if(drill_upgrade)
					ID.mining_points += 2000
					drill_upgrade = 0
				qdel()
				return

		else
			user.visible_message("<span class='danger'>\The [user] swipes \his ID card through \the [src], attempting to shut it down.</span>", "<span class='danger'>You swipe your ID card through \the [src], attempting to shut it down.</span>")

			if(emagged)
				return

			if(allowed(usr))
				shut_down()
			else
				user << "<span class='danger'>Access denied.</span>"

		return

	..()

/**********************Minebot Upgrades**********************/

/obj/item/device/mine_bot_ugprade
	name = "minebot drill upgrade"
	desc = "A minebot upgrade."
	icon_state = "door_electronics"
	icon = 'icons/obj/module.dmi'

/obj/item/device/mine_bot_ugprade/afterattack(var/mob/living/silicon/robot/drone/mining/M, mob/user, proximity)
	if(!istype(M) || !proximity)
		return
	upgrade_bot(M, user)

/obj/item/device/mine_bot_ugprade/proc/upgrade_bot(var/mob/living/silicon/robot/drone/mining/M, mob/user)
	if(M.melee_upgrade)
		user << "[src] already has a drill upgrade installed!"
		return
	for(var/obj/item/weapon/pickaxe/D in M.module.modules)
		qdel(D)
	M.module.modules += new /obj/item/weapon/pickaxe/borgdrill(src)
	M.module.rebuild()
	M.melee_upgrade = 1
	qdel(src)

/obj/item/device/mine_bot_ugprade/health
	name = "minebot chassis upgrade"

/obj/item/device/mine_bot_ugprade/health/upgrade_bot(var/mob/living/silicon/robot/drone/mining/M, mob/user)
	if(M.health_upgrade)
		user << "[src] already has a reinforced chassis!"
		return
	M.maxHealth = 100
	M.health += 55
	for(var/V in M.components) if(V != "power cell")
		var/datum/robot_component/C = M.components[V]
		C.max_damage = 30
	M.health_upgrade = 1
	qdel(src)

/obj/item/device/mine_bot_ugprade/plasma
	name = "minebot plasma cutter upgrade"

/obj/item/device/mine_bot_ugprade/plasma/upgrade_bot(var/mob/living/silicon/robot/drone/mining/M, mob/user)
	if(M.ranged_upgrade)
		user << "[src] already has a plasma cutter upgrade installed!"
		return
	M.module.modules += new /obj/item/weapon/gun/energy/plasmacutter/mounted(src)
	M.module.rebuild()
	M.ranged_upgrade = 1
	qdel(src)

/obj/item/device/mine_bot_ugprade/thermal
	name = "minebot thermal drill upgrade"

/obj/item/device/mine_bot_ugprade/thermal/upgrade_bot(var/mob/living/silicon/robot/drone/mining/M, mob/user)
	if(M.drill_upgrade)
		user << "[src] already has a thermal drill!"
		return
	if(M.emagged == 1)
		return 0

	M.emagged = 1
	M.fakeemagged = 1
	M.drill_upgrade = 1
	qdel(src)
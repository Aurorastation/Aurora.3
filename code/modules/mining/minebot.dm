/mob/living/silicon/robot/drone/mining
	icon_state = "miningdrone"
	law_type = /datum/ai_laws/mining_drone
	module_type = /obj/item/robot_module/mining_drone/basic
	holder_type = /obj/item/holder/drone/mining
	maxHealth = 45
	health = 45
	pass_flags = PASSTABLE
	req_access = list(access_mining, access_robotics)
	idcard_type = /obj/item/card/id/minedrone
	speed = -1
	var/health_upgrade
	var/ranged_upgrade
	var/melee_upgrade
	var/drill_upgrade

/mob/living/silicon/robot/drone/mining/Initialize()
	. = ..()

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
	verbs -= /mob/living/silicon/robot/drone/verb/set_mail_tag
	updateicon()
	density = 0

/mob/living/silicon/robot/drone/mining/updatename()
	real_name = "NT-I-[rand(100,999)]"
	name = real_name

/mob/living/silicon/robot/drone/mining/init()
	aiCamera = new/obj/item/device/camera/siliconcam/drone_camera(src)
	additional_law_channels["Drone"] = ":d"
	if(!laws) laws = new law_type
	if(!module) module = new module_type(src)
	if(!jetpack)
		jetpack = new /obj/item/tank/jetpack/carbondioxide/synthetic(src)

	flavor_text = "It's a tiny little mining drone. The casing is stamped with an corporate logo and the subscript: '[current_map.company_name] Automated Pickaxe!'"
	playsound(src.loc, 'sound/machines/twobeep.ogg', 50, 0)

/mob/living/silicon/robot/drone/mining/request_player()
	if(too_many_active_drones())
		return
	var/datum/ghosttrap/G = get_ghost_trap("mining drone")
	G.request_player(src, "Someone is attempting to reboot a mining drone.", 30 SECONDS)

/mob/living/silicon/robot/drone/mining/welcome_drone()
	to_chat(src, "<b>You are a mining drone, a tiny-brained robotic industrial machine</b>.")
	to_chat(src, "You have little individual will, some personality, and no drives or urges other than your laws and the art of mining.")
	to_chat(src, "Remember, <b>you DO NOT take orders from the AI.</b>")
	to_chat(src, "Use <b>say ;Hello</b> to talk to other drones and <b>say Hello</b> to speak silently to your nearby fellows.")

/mob/living/silicon/robot/drone/mining/attackby(var/obj/item/W, var/mob/user)

	if(istype(W, /obj/item/borg/upgrade/))
		to_chat(user, "<span class='danger'>\The [src] is not compatible with \the [W].</span>")
		return

	else if (istype(W, /obj/item/card/id)||istype(W, /obj/item/device/pda))

		var/choice = input("Select your choice.") in list("Reboot","Recycle")
		if(choice=="Reboot")

			if(!config.allow_drone_spawn || emagged || health < -maxHealth) //It's dead, Dave.
				to_chat(user, "<span class='danger'>The interface is fried, and a distressing burned smell wafts from the robot's interior. You're not rebooting this one.</span>")
				return

			if(!allowed(usr))
				to_chat(user, "<span class='danger'>Access denied.</span>")
				return

			user.visible_message("<span class='danger'>\The [user] swipes \his ID card through \the [src], attempting to reboot it.</span>", "<span class='danger'>>You swipe your ID card through \the [src], attempting to reboot it.</span>")
			request_player()
			return

		else
			var/obj/item/card/id/ID = W
			if(!allowed(usr))
				to_chat(user, "<span class='danger'>Access denied.</span>")
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
			qdel(src)
			return
	..()

/mob/living/silicon/robot/drone/mining/verb/print_report()
	set name = "Print Message"
	set desc = "Print out a status report of your own choosing."
	set category = "Robot Commands"

	var/input = sanitize(input(usr, "Please enter a message to print out. NOTE: BBCode does not work.", "Print readout", "") as message|null)
	if (!input)
		to_chat(usr, "<span class='warning'>Cancelled.</span>")
		return

	var/customname = input(usr, "Pick a title for the report", "Title") as text|null
	if (!customname)
		to_chat(usr, "<span class='warning'>Cancelled.</span>")
		return

	var/status_report
	switch(src.health)
		if((maxHealth - (maxHealth/3)) to maxHealth)
			status_report = "All systems nominal."
		if((maxHealth/3) to maxHealth/2)
			status_report = "Systems compromised."
		if(0 to (maxHealth/3))
			status_report = "Systems failing."
		else
			status_report = "System status unknown."

	// Create the reply message
	to_chat(usr, "<span class='warning'>You begin printing the message.</span>")
	if(do_after(src,20))
		var/obj/item/paper/P = new /obj/item/paper(src.loc)
		P.name = "mining report - [customname]"
		P.info = {"<center><img src = ntlogo.png></center>
	<center><b><i>NanoTrasen Mining Drone Report</b></i><br>
	<font size = \"1\">FOR YOUR EYES ONLY</font><hr><br>
	<font size = \"1\"><font face='Courier New'>[input]</font></font><hr>
	<font size = \"1\">[status_report]</font><br>
	<center><img src = barcode[rand(0, 3)].png></center></center>"}
		P.update_icon()
		visible_message("\icon[src] <span class = 'notice'>The [usr] pings, \"[P.name] ready for review\", and happily disgorges a small printout.</span>", range = 2)
		playsound(src.loc, 'sound/machines/ping.ogg', 50, 0)

/mob/living/silicon/robot/drone/mining/process_level_restrictions()
	//Abort if they should not get blown
	if (lockcharge || scrambledcodes || emagged)
		return
	//Check if they are not on a station level -> abort
	var/turf/T = get_turf(src)
	if (!T || isStationLevel(T.z))
		return
	to_chat(src,"WARNING: Removal from NanoTrasen property detected. Anti-Theft mode activated.")
	gib()

/**********************Minebot Upgrades**********************/

/obj/item/device/mine_bot_ugprade
	name = "minebot drill upgrade"
	desc = "A minebot upgrade."
	icon_state = "mainboard"
	icon = 'icons/obj/module.dmi'

/obj/item/device/mine_bot_ugprade/afterattack(var/mob/living/silicon/robot/drone/mining/M, mob/user, proximity)
	if(!istype(M) || !proximity)
		return
	upgrade_bot(M, user)

/obj/item/device/mine_bot_ugprade/proc/upgrade_bot(var/mob/living/silicon/robot/drone/mining/M, mob/user)
	if(M.melee_upgrade)
		to_chat(user, "[src] already has a drill upgrade installed!")
		return
	M.modtype = initial(M.modtype)
	M.uneq_all()
	qdel(M.module)
	M.module = null
	if(M.ranged_upgrade)
		new /obj/item/robot_module/mining_drone/drillandka(M)
	else
		new /obj/item/robot_module/mining_drone/drill(M)
	M.module.rebuild()
	M.recalculate_synth_capacities()
	if(!M.jetpack)
		M.jetpack = new /obj/item/tank/jetpack/carbondioxide/synthetic(src)
	qdel(src)

/obj/item/device/mine_bot_ugprade/health
	name = "minebot chassis upgrade"

/obj/item/device/mine_bot_ugprade/health/upgrade_bot(var/mob/living/silicon/robot/drone/mining/M, mob/user)
	if(M.health_upgrade)
		to_chat(user, "[src] already has a reinforced chassis!")
		return
	M.maxHealth = 100
	M.health += 55
	for(var/V in M.components) if(V != "power cell")
		var/datum/robot_component/C = M.components[V]
		C.max_damage = 30
	M.health_upgrade = 1
	qdel(src)

/obj/item/device/mine_bot_ugprade/ka
	name = "minebot kinetic accelerator upgrade"

/obj/item/device/mine_bot_ugprade/ka/upgrade_bot(var/mob/living/silicon/robot/drone/mining/M, mob/user)
	if(M.ranged_upgrade)
		to_chat(user, "[src] already has a KA upgrade installed!")
		return
	M.modtype = initial(M.modtype)
	M.uneq_all()
	qdel(M.module)
	M.module = null
	if(M.melee_upgrade)
		new /obj/item/robot_module/mining_drone/drillandka(M)
	else
		new /obj/item/robot_module/mining_drone/ka(M)
	M.ranged_upgrade = 1
	M.module.rebuild()
	M.recalculate_synth_capacities()
	if(!M.jetpack)
		M.jetpack = new /obj/item/tank/jetpack/carbondioxide/synthetic(src)
	qdel(src)

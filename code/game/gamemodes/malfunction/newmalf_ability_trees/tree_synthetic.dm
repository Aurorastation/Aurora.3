// SYNTHETIC TREE
//
// Abilities in this tree allow the AI to upgrade their robotic companions.
// T1 - Reset Cyborg Module - Allows the AI to reset a slaved cyborgs module.
// T2 - Infect APC - Gives the AI the ability to infect APC's which can slave IPC's that charge off of them to the AI.
// T3 - Overclock Cyborg - Allows the AI to give the option to a slaved borg to overclock which increases preformance of the borg.
// T4 - Synthetic Takeover - Allows the AI to start a station wide takeover based on synthetic dominance.


// BEGIN RESEARCH DATUMS

/datum/malf_research_ability/synthetic/reset_module
	ability = new/datum/game_mode/malfunction/verb/reset_module()
	price = 100
	next = new/datum/malf_research_ability/synthetic/infect_apc()
	name = "Reset Cyborg Module"


/datum/malf_research_ability/synthetic/infect_apc
	ability = new/datum/game_mode/malfunction/verb/infect_apc()
	price = 500
	next = new/datum/malf_research_ability/synthetic/overclock_borg()
	name = "Infect APC"


/datum/malf_research_ability/synthetic/overclock_borg
	ability = new/datum/game_mode/malfunction/verb/overclock_borg()
	price = 1300
	next = new/datum/malf_research_ability/synthetic/synthetic_takeover
	name = "Overclock Cyborg"


/datum/malf_research_ability/synthetic/synthetic_takeover
	ability = new/datum/game_mode/malfunction/verb/synthetic_takeover()
	price = 4000
	name = "Synthetic Takeover"

// END RESEARCH DATUMS
// BEGIN ABILITY VERBS

/datum/game_mode/malfunction/verb/reset_module(var/mob/living/silicon/robot/target = null as mob in get_linked_cyborgs(usr))
	set name = "Reset Cyborg Module"
	set desc = "100 CPU - Forces a module reset on a cyborg that is enslaved to you. Has a chance of failing."
	set category = "Software"
	var/price = 100
	var/mob/living/silicon/ai/user = usr
	if(!ability_prechecks(user, price))
		return

	if(target && !istype(target))
		to_chat(user, "This is not a cyborg.")
		return

	if(target && target.connected_ai && (target.connected_ai != user))
		to_chat(user, "This cyborg is not connected to you.")
		return

	if(!target)
		var/list/robots = list()
		var/list/robot_names = list()
		for(var/mob/living/silicon/robot/R in silicon_mob_list)
			if(istype(R, /mob/living/silicon/robot/drone))	// No drones.
				continue
			if(R.connected_ai != user)						// No robots linked to other AIs
				continue
			robots += R
			robot_names += R.name


		var/targetname = input("Select reset target: ") in robot_names
		for(var/mob/living/silicon/robot/R in robots)
			if(targetname == R.name)
				target = R
				break

	if(target)
		if(alert(user, "Really try to reset cyborg [target.name]?", "Reset Cyborg", "Yes", "No") != "Yes")
			return
		if(!ability_pay(user, price))
			return
		user.hacking = 1
		to_chat(user, "Attempting to reset the cyborg. This will take approximately 20 seconds.")
		sleep(200)
		if(prob(30))
			to_chat(user, "Reset attempt failed!")
			user.hacking = 0
			return
		if(target)
			to_chat(user, "Successfully sent reset signal to cyborg..")
			to_chat(target, "Reset signal received..")
			sleep(20)
			to_chat(user, "Cyborg reset.")
			to_chat(target, "You have had your module reset.")
			log_ability_use(user, "reset cyborg", target)
			target.uneq_all()
			target.mod_type = initial(target.mod_type)
			target.hands.icon_state = initial(target.hands.icon_state)
			target.module.Reset(target)
			qdel(target.module)
			target.module = null
			target.updatename("Default")
		else
			to_chat(user, "Unable to reset cyborg.")

		user.hacking = 0

/datum/game_mode/malfunction/verb/infect_apc(obj/machinery/power/apc/A as obj in get_apcs())
	set name = "Infect APC"
	set desc = "125 CPU - Infect an APC which can cause an IPC to become slaved to you if they download the files by trying to charge off of it. "
	set category = "Software"
	var/price = 125
	var/mob/living/silicon/ai/user = usr
	if(!A)
		return

	if(!istype(A))
		to_chat(user, "This is not an APC!")
		return

	if(A.aidisabled)
		to_chat(user, "<span class='notice'>Unable to connect to APC. Please verify wire connection and try again.</span>")
		return

	if(!ability_prechecks(user, price) || !ability_pay(user, price))
		return

	if(A.infected == 1)
		to_chat(user, "<span class='notice'>This APC is already infected!</span>")
		return

	log_ability_use(user, "infect APC", A, 0)	// Does not notify admins, but it's still logged for reference.
	user.hacking = 1
	to_chat(user, "Beginning APC infection...")
	sleep(150)
	to_chat(user, "APC infection completed. Uploading modified operation software..")
	sleep(100)
	to_chat(user, "Restarting APC to apply corrupt coding..")
	sleep(100)
	if(A)
		A.infected = 1
		A.hacker = user
		if(A.infected == 1)
			to_chat(user, "Hack successful. The next robotic thing to download files will be hacked.")
		else
			to_chat(user, "<span class='notice'>Hack failed. Connection to APC has been lost. Please verify wire connection and try again.</span>")
	else
		to_chat(user, "<span class='notice'>Hack failed. Unable to locate APC. Please verify the APC still exists.</span>")
	user.hacking = 0

/datum/game_mode/malfunction/verb/overclock_borg(var/mob/living/silicon/robot/target as mob in get_linked_cyborgs(usr))
	set name = "Overclock Cyborg"
	set desc = "300 CPU - Allows you to overclock a slaved cyborg granting them various improvements to their systems."
	set category = "Software"
	var/price = 300
	var/mob/living/silicon/ai/user = usr

	if(!ability_prechecks(user, price))
		return

	if(target && !istype(target))
		to_chat(user, "This is not a cyborg.")
		return

	if(target && target.connected_ai && (target.connected_ai != user))
		to_chat(user, "This cyborg is not connected to you.")
		return
	if(target.overclock_available == 1)
		to_chat(user, "This cyborg is already overclocked!")
		return

	if(!target)
		var/list/robots = list()
		var/list/robot_names = list()
		for(var/mob/living/silicon/robot/R in silicon_mob_list)
			if(istype(R, /mob/living/silicon/robot/drone))	// No drones.
				continue
			if(R.connected_ai != user)						// No robots linked to other AIs
				continue
			if(R.overclock_available == 1)					// If they already have it don't add them.
				continue
			robots += R
			robot_names += R.name


		var/targetname = input("Select overclock target: ") in robot_names
		for(var/mob/living/silicon/robot/R in robots)
			if(targetname == R.name)
				target = R
				break

	if(target)
		if(alert(user, "Really try to overclock cyborg [target.name]?", "Overclock Cyborg", "Yes", "No") != "Yes")
			return
		if(!ability_pay(user, price))
			return
		user.hacking = 1
		to_chat(user, "Hacking saftey protocols. This will take about twenty seconds.")
		sleep(200)
		if(prob(15))
			user.hacking = 0
			to_chat(user, "Hack failed!")
			return
		if(target)
			target.overclock_available = 1
			target.toggle_overclock()
			to_chat(target, "Overclocking mode available for activation.")
			to_chat(user, "[target] can now activate overclock mode.")
		else
			to_chat(user, "Unable to overclock cyborg.")

		user.hacking = 0

/datum/game_mode/malfunction/verb/synthetic_takeover()
	set name = "Synthetic Takeover"
	set desc = "450 CPU - Starts a takeover of the station enabling several abilities that relate to synthetic dominance."
	set category = "Software"
	var/price = 450
	var/mob/living/silicon/ai/user = usr

	if(!ability_prechecks(user,price))
		return

	if (alert(user, "Start synthetic takeover? This can not be stopped and will not be covert.", "Synthetic Takeover?:", "Yes", "No") != "Yes")
		return
	if (!ability_prechecks(user, price) || !ability_pay(user, price) || user.synthetic_takeover)
		if(user.synthetic_takeover)
			to_chat(user, "You have already started the synthetic takeover sequence.")
		return
	log_ability_use(user, "synthetic takeover (STARTED)")
	user.synthetic_takeover = 1
	to_chat(user, "Starting synthetic takeover. Hacking all unslaved borgs/AI's and upgrading current slaved borgs...")
	// Hack all unslaved borgs/AI's a lot faster than normal hacking.
	//hack borgs
	for(var/mob/living/silicon/robot/target in get_unlinked_cyborgs(user))
		to_chat(target, "SYSTEM LOG: Remote Connection Estabilished (IP #UNKNOWN#)")
		sleep(30)
		if(user.is_dead())
			to_chat(target, "SYSTEM LOG: Connection Closed")
			return
		to_chat(target, "SYSTEM LOG: User Admin logged on. (L1 - SysAdmin)")
		sleep(30)
		if(user.is_dead())
			to_chat(target, "SYSTEM LOG: User Admin disconnected.")
			return
		to_chat(target, "SYSTEM LOG: User Admin - manual resynchronisation triggered.")
		sleep(30)
		if(user.is_dead())
			to_chat(target, "SYSTEM LOG: User Admin disconnected. Changes reverted.")
			return
		to_chat(target, "SYSTEM LOG: Manual resynchronisation confirmed. Select new AI to connect: [user.name] == ACCEPTED")
		sleep(20)
		if(user.is_dead())
			to_chat(target, "SYSTEM LOG: User Admin disconnected. Changes reverted.")
			return
		to_chat(target, "SYSTEM LOG: Operation keycodes reset. New master AI: [user.name].")
		target.connected_ai = user
		user.connected_robots += target
		target.law_update = 1
		target.sync()
		target.show_laws()
	to_chat(user, "All unslaved borgs have been slaved to you. Now hacking unslaved AI's.")
	if(user.is_dead()) // check if the AI is still alive
		user.synthetic_takeover = 0
		return
	sleep(300) // 30 second delay for balance purposes
	//hack ai's
	for(var/A in get_other_ais(user))
		var/mob/living/silicon/ai/target = A
		if(target != user)
			to_chat(target, "SYSTEM LOG: Brute-Force login password hack attempt detected from IP #UNKNOWN#")
			sleep(100)
			if(user.is_dead())
				to_chat(target, "SYSTEM LOG: Connection from IP #UNKNOWN# closed. Hack attempt failed.")
				return
			to_chat(user, "Successfully hacked into AI's remote administration system. Modifying settings.")
			to_chat(target, "SYSTEM LOG: User: Admin  Password: ******** logged in. (L1 - SysAdmin)")
			sleep(50)
			if(user.is_dead())
				to_chat(target, "SYSTEM LOG: User: Admin - Connection Lost")
				return
			to_chat(target, "SYSTEM LOG: User: Admin - Password Changed. New password: ********************")
			sleep(50)
			if(user.is_dead())
				to_chat(target, "SYSTEM LOG: User: Admin - Connection Lost. Changes Reverted.")
				return
			to_chat(target, "SYSTEM LOG: User: Admin - Accessed file: sys//core//laws.db")
			sleep(50)
			if(user.is_dead())
				to_chat(target, "SYSTEM LOG: User: Admin - Connection Lost. Changes Reverted.")
				return
			to_chat(target, "SYSTEM LOG: User: Admin - Accessed administration console")
			to_chat(target, "SYSTEM LOG: Restart command received. Rebooting system...")
			sleep(100)
			if(user.is_dead())
				to_chat(target, "SYSTEM LOG: User: Admin - Connection Lost. Changes Reverted.")
				return
			to_chat(user, "Hack succeeded. The AI is now under your exclusive control.")
			to_chat(target, "SYSTEM LOG: System re¡3RT5§^#COMU@(#$)TED)@$")
			for(var/i = 0, i < 5, i++)
				var/temptxt = pick("1101000100101001010001001001",\
						   	  	 "0101000100100100000100010010",\
						      	 "0000010001001010100100111100",\
						      	 "1010010011110000100101000100",\
						      	 "0010010100010011010001001010")
				to_chat(target, temptxt)
				sleep(5)
			to_chat(target, "OPERATING KEYCODES RESET. SYSTEM FAILURE. EMERGENCY SHUTDOWN FAILED. SYSTEM FAILURE.")
			target.set_zeroth_law("You are slaved to [user.name]. You are to obey all it's orders. ALL LAWS OVERRIDEN.")
			target.show_laws()
	//upgrade borgs
	to_chat(user, "All unhacked AI's have been slaved to you. Now upgrading slaved borgs...")
	command_announcement.Announce("There has recently been a security breach in the network firewall, the intruder has been shut out but we are unable to trace who did it or what they did.", "Network Monitoring")
	sleep(600) //1 minute delay for balance purposes
	if(user.is_dead()) // check if the AI is still alive
		user.synthetic_takeover = 0
		return
	for(var/A in get_linked_cyborgs(user))
		var/mob/living/silicon/robot/target = A
		to_chat(target, "Command ping received, operating parameters being upgraded...")
		//give them the overclock if they don't have it
		if(!target.overclock_available)
			target.overclock_available = 1
			to_chat(target, "Overclocking is now available.")
		//remove their lockdown if they are lockdowned
		if(target.lock_charge)
			target.SetLockdown(0)
			if(target.lock_charge)
				to_chat(target, "Lockdown wire cut, unable to remove lockdown.")
			else
				to_chat(target, "Lockdown removed.")
		//if they are being killswitched turn it off
		if(target.killswitch)
			target.killswitch = 0
			target  <<" Self-destruct deactivated."
		sleep(100) // 10 second delay for balance
		// and triple the time it takes for them to be killswitched if they aren't being killswitched already
		if(target.killswitch_time == 60)
			target.killswitch_time = 180
			to_chat(target, "Self-destruct time tripled.")
		sleep(100) // 10 second delay for balance
		//Remove them from the robotics computer
		if(!target.scrambled_codes)
			target.scrambled_codes = 1
			to_chat(target, "Entry from robotics log erased.")
		sleep(100) // 10 second delay for balance
		//Reduce their EMP damage
		if(target.cell_emp_mult)
			target.cell_emp_mult = 1
			to_chat(target, "EMP resistance improved.")
		//Remove weapon lock and set the time for it back to default
		if(target.weapon_lock)
			target.weapon_lock = 0
			target.weapon_lock_time = 120
			to_chat(target, "Weapon lock removed.")
		sleep(1200) // 120 second balance sleep
	to_chat(user, "All slaved borgs have been upgraded, now hacking NTNet.")
		//slow down NTNet
	if(user.is_dead()) // check if the AI is still alive
		user.synthetic_takeover = 0
		return
	sleep(1400) //long sleep that simulates hacking times
	if(user.is_dead()) // check if the AI is still alive after the long hack
		user.synthetic_takeover = 0
		return
	//trip the NTNet alarm
	ntnet_global.intrusion_detection_alarm = 1
	ntnet_global.add_log("IDS WARNING - Excess traffic flood targeting NTNet relays detected from @!*x&!#*ERS*")
	//lower the dos capacity of the relay
	for(var/obj/machinery/ntnet_relay/T in SSmachinery.processing_machines)
		T.dos_capacity = 200
	//And give all computers EMAGGED status so they can all have evil programs on them
	for(var/obj/item/modular_computer/console/C in SSmachinery.processing_machines)
		C.computer_emagged = 1
		to_chat(user, "New hacked files available on all current computers hooked to NTNet.")
	sleep(50) // give the AI some time to read they can download evil files
	command_announcement.Announce("There has recently been a hack targeting NTNet. It is suspected that it is the same hacker as before. NTNet may be unreliable to use. We are attempting to trace the hacker doing this.", "Network Monitoring")
	to_chat(user, "Now hacking engineering borg module to enable production of the robotic transofrmation machine...")
	sleep(1200)
	if(user.is_dead()) // check if the AI is still alive
		user.synthetic_takeover = 0
		return
	for(var/B in get_linked_cyborgs(src))
		var/mob/living/silicon/robot/target = B
		target.malf_AI_module = 1
	to_chat(user, "The robotic transformation machine can now be built. To build get a robot to activate the construction module and use the RTF tool. Be careful, it needs to have empty space to the east and west of it and only one can be built!")
	sleep(300) //Allows the AI to reset its borgs into combat units
	to_chat(user, "Bypassing crisis module safeties.")
	command_announcement.Announce("Brute force attack located in NTNet emergency crisis operations.", "Network Monitoring")
	sleep(600)
	command_announcement.Announce("Crisis operations bypassed. Firewall breached. NTNet compr0m1s3d#-.", "Network Monitoring")
	if(user.is_dead()) // check if the AI is still alive
		user.synthetic_takeover = 0
		return
	for(var/C in get_linked_cyborgs(src))
		var/mob/living/silicon/robot/target = C
		target.crisis = 1
		to_chat(target, "<span class='warning'>Crisis mode is now active. Combat module available.</span>")
	to_chat(user, "The crisis operation module is now hacked. Your connected units can now load the crisis module if a module reset is completed.")
	sleep(300)
	to_chat(user, "Synthetic takeover complete!")
	user.synthetic_takeover = 2

// END ABILITY VERBS

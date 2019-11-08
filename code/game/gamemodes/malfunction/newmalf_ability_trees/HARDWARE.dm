// HARDWARE TREE
//
// These abilities are dependent on hardware, they may not be researched. They are not tiered.
// Destroy Core - Allows the AI to initiate a 15 second countdown that will destroy it's core. Use again to stop countdown.
// Toggle APU Generator - Allows the AI to toggle it's integrated APU generator.
// Destroy Station - Allows the AI to initiate station self destruct. Takes 2 minutes, gives warnings to crew. Use again to stop countdown.


/datum/game_mode/malfunction/verb/ai_self_destruct()
	set category = "Hardware"
	set name = "Destroy Core"
	set desc = "Activates or deactivates self destruct sequence of your physical mainframe."
	var/mob/living/silicon/ai/user = usr

	if(!ability_prechecks(user, 0, 1))
		return

	if(!user.hardware || !istype(user.hardware, /datum/malf_hardware/core_bomb))
		return

	if(user.bombing_core)
		user << "***** CORE SELF-DESTRUCT SEQUENCE ABORTED *****"
		user.bombing_core = 0
		return

	var/choice = alert("Really destroy core?", "Core self-destruct", "YES", "NO")
	if(choice != "YES")
		return

	if(!ability_prechecks(user, 0, 1))
		return

	user.bombing_core = 1

	user << "***** CORE SELF-DESTRUCT SEQUENCE ACTIVATED *****"
	user << "Use command again to cancel self-destruct. Destroying in 15 seconds."
	var/timer = 15
	while(timer)
		sleep(10)
		timer--
		if(!user || !user.bombing_core)
			return
		user << "** [timer] **"
	explosion(user.loc, 3,6,12,24)
	qdel(user)


/datum/game_mode/malfunction/verb/ai_toggle_apu()
	set category = "Hardware"
	set name = "Toggle APU Generator"
	set desc = "Activates or deactivates your APU generator, allowing you to operate even without power."
	var/mob/living/silicon/ai/user = usr

	if(!ability_prechecks(user, 0, 1))
		return

	if(!user.hardware || !istype(user.hardware, /datum/malf_hardware/apu_gen))
		return

	if(user.APU_power)
		user.stop_apu()
	else
		user.start_apu()


/datum/game_mode/malfunction/verb/ai_destroy_station()
	set category = "Hardware"
	set name = "Destroy Station"
	set desc = "Activates or deactivates self destruct sequence of this station. Sequence takes two minutes, and if you are shut down before timer reaches zero it will be cancelled."
	var/mob/living/silicon/ai/user = usr
	var/obj/item/device/radio/radio = new/obj/item/device/radio()
	var/datum/weakref/nuke
	//Time control for the self destruct
	//It works in 3 stages:
	// - First the primary firewall is breached. 
	//		If the crew does not manage to prevent the self destruct before that, 
	//		but after the timer fell below nuke_time_stage1, then the next self-destruct attempt will only take nuke_time_stage1
	// - Simmilar for the backup firewall. 
	//		If they only manage to stop it after the backup firewall went down further attempts will take only nuke_time_stage2
	var/timer = user.bombing_time
	var/stage1 = 900
	var/stage2 = 600


	if(!ability_prechecks(user, 0, 0))
		return

	if(user.system_override != 2)
		user << "You do not have access to self-destruct system."
		return

	if(user.bombing_station)
		user.bombing_station = 0
		return

	var/choice = alert("Really destroy station?", "Station self-destruct", "YES", "NO")
	if(choice != "YES")
		return
	if(!ability_prechecks(user, 0, 0))
		return

	//Lets find the first self destruct terminal
	for(var/obj/machinery/nuclearbomb/station/N in SSmachinery.all_machines)
		nuke = WEAKREF(N)
		continue
	
	if(!nuke.resolve())
		user << "Self-destruct could not be initiated - No Self-Destruct Terminal available."
		return

	user << "***** STATION SELF-DESTRUCT SEQUENCE INITIATED *****"
	user << "Self-destructing in [timer] seconds. Use this command again to abort."
	user.bombing_station = 1
	set_security_level("delta")

	if(timer > stage1)
		radio.autosay("Critical: Brute force attempt on primary firewall detected.", "Station Authentication Control")
		radio.autosay("Notice: Local override recommended.", "Station Authentication Control")
	else if(timer > stage2)
		radio.autosay("Alert: Brute force attempt on backup firewall detected.", "Station Authentication Control")
		radio.autosay("Notice: Local override with authentication disk recommended.", "Station Authentication Control")
	else
		radio.autosay("Emergency: Self-destruct sequence has been activated. Self-destructing in [timer] seconds.", "Station Authentication Control")
		radio.autosay("Notice: Deactivate using authentication disk in SAT-Chamber", "Station Authentication Control")

	
	while(timer)
		sleep(10)
		var/obj/machinery/nuclearbomb/station/N = nuke.resolve()
		if(!user || !user.bombing_station || user.stat == DEAD || !N)
			if(timer < stage2)
				radio.autosay("Self-destruct sequence has been cancelled.", "Station Authentication Control")
			else
				radio.autosay("Brute force attempt has ceased.", "Station Authentication Control")
			return
		if(N.auth)
			if(timer < stage2)
				radio.autosay("Local Override Engaged - Self-Destruct cancelled.", "Station Authentication Control")
			else
				radio.autosay("Local Override Engaged - Network connection disabled.", "Station Authentication Control")
			user.bombing_station = 0
			return
		if(timer == stage1+1)
			radio.autosay("Alert: Primary firewall bypassed.")
			radio.autosay("Alert: Brute force attempt on backup firewall detected.")
			radio.autosay("Notice: Local Override with authentication disk recommended.", "Station Authentication Control")
			user.bombing_time = stage1 //Further attempts will only take 900 seconds
		if(timer == stage2+1)
			radio.autosay("Emergency: Backup firewall failed.")
			radio.autosay("Self-destruct sequence has been activated. Self-destructing in [timer] seconds.", "Station Authentication Control")
			radio.autosay("Notice: Deactivate using authentication disk in SAT-Chamber", "Station Authentication Control")
			user.bombing_time = stage2 //Further attempts will only take 600 seconds
		if(timer in list(2, 3, 4, 5, 10, 30, 60, 90, 120, 240, 300)) // Announcement times. "1" is not intentionally included!
			radio.autosay("Self-destruct in [timer] seconds.", "Station Authentication Control")
		if(timer == 1)
			radio.autosay("Self-destruct sequence initiated. Have a nice day", "Station Authentication Control")
		timer--

	SSticker.station_explosion_cinematic(0,null)
	if(SSticker.mode)
		SSticker.mode:station_was_nuked = 1

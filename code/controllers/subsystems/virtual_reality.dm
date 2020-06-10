/var/global/datum/controller/subsystem/virtualreality/SSvirtualreality

/datum/controller/subsystem/virtualreality
	name = "Virtual Reality"
	init_order = SS_INIT_MISC_FIRST
	flags = SS_NO_FIRE

	// MECHA
	var/list/mechnetworks = list("remotemechs", "aimechs", "prisonmechs") // A list of all the networks a mech can possibly connect to
	var/list/list/mechs = list() // A list of lists, containing the mechs and their networks

	// IPC BODIES
	var/list/robotnetworks = list("remoterobots", "bunkerrobots", "prisonrobots")
	var/list/list/robots = list()

/datum/controller/subsystem/virtualreality/New()
	NEW_SS_GLOBAL(SSvirtualreality)

/datum/controller/subsystem/virtualreality/Initialize()
	for(var/network in mechnetworks)
		mechs[network] = list()
	for(var/network in robotnetworks)
		robots[network] = list()
	..()


/datum/controller/subsystem/virtualreality/proc/add_mech(var/mob/living/heavy_vehicle/mech, var/network)
	if(mech && network)
		mechs[network] += mech

/datum/controller/subsystem/virtualreality/proc/remove_mech(var/mob/living/heavy_vehicle/mech, var/network)
	if(mech && network)
		mechs[network].Remove(mech)

/datum/controller/subsystem/virtualreality/proc/add_robot(var/mob/living/robot, var/network)
	if(robot && network)
		robots[network] += robot

/datum/controller/subsystem/virtualreality/proc/remove_robot(var/mob/living/robot, var/network)
	if(robot && network)
		robots[network].Remove(robot)


/mob
	var/mob/living/vr_mob = null // In which mob is our mind
	var/mob/living/old_mob = null // Which mob is our old mob

// Return to our original body
/mob/proc/body_return()
	set name = "Return to Body"
	set category = "IC"

	if(old_mob)
		ckey_transfer(old_mob)
		languages = list(all_languages[LANGUAGE_TCB])
		to_chat(old_mob, SPAN_NOTICE("System exited safely, we hope you enjoyed your stay."))
		old_mob = null
	else
		to_chat(src, SPAN_DANGER("Interface error, you cannot exit the system at this time."))
		to_chat(src, SPAN_WARNING("Ahelp to get back into your body, a bug has occurred."))

/mob/living/silicon/body_return()
	set name = "Return to Body"
	set category = "IC"

	if(old_mob)
		ckey_transfer(old_mob)
		speech_synthesizer_langs = list(all_languages[LANGUAGE_TCB])
		to_chat(old_mob, SPAN_NOTICE("System exited safely, we hope you enjoyed your stay."))
		old_mob = null
	else
		to_chat(src, SPAN_DANGER("Interface error, you cannot exit the system at this time."))
		to_chat(src, SPAN_WARNING("Ahelp to get back into your body, a bug has occurred."))

/mob/living/proc/vr_mob_exit_languages()
	languages = list(all_languages[LANGUAGE_TCB])

/mob/living/silicon/vr_mob_exit_languages()
	..()
	speech_synthesizer_langs = list(all_languages[LANGUAGE_TCB])

// Handles saving of the original mob and assigning the new mob
/datum/controller/subsystem/virtualreality/proc/mind_transfer(var/mob/living/M, var/mob/living/target)
	var/new_ckey = M.ckey
	target.old_mob = M
	M.vr_mob = target
	target.ckey = new_ckey
	M.ckey = "@[new_ckey]"
	target.verbs += /mob/proc/body_return

	target.get_vr_name(M)
	M.swap_languages(target)

	if(target.client)
		target.client.screen |= global_hud.vr_control

	to_chat(target, SPAN_NOTICE("Connection established, system suite active and calibrated."))
	to_chat(target, SPAN_WARNING("To exit this mode, use the \"Return to Body\" verb in the IC tab."))

/mob/living/proc/swap_languages(var/mob/target)
	target.languages = languages
	if(issilicon(target))
		var/mob/living/silicon/T = target
		T.speech_synthesizer_langs = languages

/mob/living/silicon/swap_languages(mob/target)
	target.languages = speech_synthesizer_langs
	if(issilicon(target))
		var/mob/living/silicon/T = target
		T.speech_synthesizer_langs = speech_synthesizer_langs

/mob/proc/get_vr_name(var/mob/user)
	return

/mob/living/simple_animal/spiderbot/get_vr_name(mob/user)
	real_name = "Remote-Bot ([user.real_name])"
	name = real_name

/mob/proc/ckey_transfer(var/mob/target, var/null_vr_mob = TRUE)
	target.ckey = src.ckey
	src.ckey = null
	if(null_vr_mob)
		target.vr_mob = null

/datum/controller/subsystem/virtualreality/proc/mech_selection(var/user, var/network)
	var/list/mech = list()
	mech["Return"] = null

	for(var/mob/living/heavy_vehicle/R in mechs[network])
		var/turf/T = get_turf(R)
		if(!T)
			continue
		if(isNotStationLevel(T.z))
			continue
		if(!R.remote)
			continue
		if(!R.pilots.len)
			continue
		var/mob/living/mech_pilot = R.pilots[1]
		if(mech_pilot.client || mech_pilot.ckey)
			continue
		if(mech_pilot.stat == DEAD)
			continue
		mech[R.name] = R

	if(mech.len == 1)
		to_chat(user, SPAN_WARNING("No active remote mechs are available."))
		return

	var/desc = input("Please select a remote control compatible mech to take over.", "Remote Mech Selection") in mech|null
	if(!desc)
		return

	var/mob/living/heavy_vehicle/chosen_mech = mech[desc]
	var/mob/living/remote_pilot = chosen_mech.pilots[1] // the first pilot
	mind_transfer(user, remote_pilot)

	return

/datum/controller/subsystem/virtualreality/proc/robot_selection(var/user, var/network)
	var/list/robot = list()
	robot["Return"] = null

	for(var/mob/living/R in robots[network])
		var/turf/T = get_turf(R)
		if(!T)
			continue
		if(isNotStationLevel(T.z))
			continue
		if(R.client || R.ckey)
			continue
		if(R.stat == DEAD)
			continue
		robot[R.name] = R

	if(robot.len == 1)
		to_chat(user, SPAN_WARNING("No active remote robots are available."))
		return

	var/desc = input("Please select a remote control robot to take over.", "Remote Robot Selection") in robot|null
	if(!desc)
		return

	mind_transfer(user, robot[desc])

	return
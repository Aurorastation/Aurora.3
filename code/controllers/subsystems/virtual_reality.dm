/var/global/datum/controller/subsystem/virtualreality/SSvirtualreality

/datum/controller/subsystem/virtualreality
	name = "Virtual Reality"
	init_order = SS_INIT_MISC_FIRST
	flags = SS_NO_FIRE

	// MECHA
	var/list/mechnetworks = list("remotemechs", "prisonmechs") // A list of all the networks a mech can possibly connect to
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


/mob/living/
	var/mob/living/vr_mob = null // In which mob is our mind
	var/mob/living/old_mob = null // Which mob is our old mob

// Return to our original body
/mob/living/proc/body_return()
	set name = "Return to Body"
	set category = "IC"

	if(!vr_mob && !old_mob)
		return

	if(vr_mob)
		ckey = vr_mob.ckey
		vr_mob.ckey = null
		vr_mob.old_mob = null
		vr_mob.languages = list(LANGUAGE_TCB)
		vr_mob = null
		to_chat(src, span("notice", "System exited safely, we hope you enjoyed your stay."))
	if(old_mob)
		old_mob.ckey = ckey
		ckey = null
		old_mob.vr_mob = null
		languages = list(LANGUAGE_TCB)
		to_chat(old_mob, span("notice", "System exited safely, we hope you enjoyed your stay."))
		old_mob = null
	else
		to_chat(src, span("danger", "Interface error, you cannot exit the system at this time."))
		to_chat(src, span("warning", "Ahelp to get back into your body, a bug has occurred."))

// Handles saving of the original mob and assigning the new mob
/datum/controller/subsystem/virtualreality/proc/mind_transfer(var/mob/living/M, var/mob/living/target)
	var/new_ckey = M.ckey
	target.old_mob = M
	M.vr_mob = target
	target.ckey = new_ckey
	M.ckey = "@[new_ckey]"
	target.verbs += /mob/living/proc/body_return

	target.languages = M.languages

	to_chat(target, span("notice", "Connection established, system suite active and calibrated."))
	to_chat(target, span("warning", "To exit this mode, use the \"Return to Body\" verb in the IC tab."))


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
		mech[mech_pilot.name] = mech_pilot

	if(mech.len == 1)
		to_chat(user, span("warning", "No active remote mechs are available."))
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
		to_chat(user, span("warning", "No active remote robots are available."))
		return

	var/desc = input("Please select a remote control robot to take over.", "Remote Robot Selection") in robot|null
	if(!desc)
		return

	mind_transfer(user, robot[desc])

	return
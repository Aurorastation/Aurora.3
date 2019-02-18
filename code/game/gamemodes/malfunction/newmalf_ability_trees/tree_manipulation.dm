// MANIPULATION TREE
//
// Abilities in this tree allow the AI to physically manipulate systems around the station.
// T1 - Hack Holopad - Allows the AI to hack a holopad. Hacked holopads only activate the listening feature when turned on.
// T2 - Hack Camera - Allows the AI to hack a camera. Deactivated areas may be reactivated, and functional cameras can be upgraded.
// T3 - Emergency Forcefield - Allows the AI to project 1 tile forcefield that blocks movement and air flow. Forcefield�dissipates over time. It is also very susceptible to energetic weaponry.
// T4 - Machine Overload - Detonates machine of choice in a minor explosion. Two of these are usually enough to kill or K/O someone.


// BEGIN RESEARCH DATUMS

/datum/malf_research_ability/manipulation/hack_holopad
	ability = new/datum/game_mode/malfunction/verb/hack_holopad()
	price = 50
	next = new/datum/malf_research_ability/manipulation/hack_camera()
	name = "Hack Holopad"


/datum/malf_research_ability/manipulation/hack_camera
	ability = new/datum/game_mode/malfunction/verb/hack_camera()
	price = 1200
	next = new/datum/malf_research_ability/manipulation/emergency_forcefield()
	name = "Hack Camera"


/datum/malf_research_ability/manipulation/emergency_forcefield
	ability = new/datum/game_mode/malfunction/verb/emergency_forcefield()
	price = 1750
	next = new/datum/malf_research_ability/manipulation/machine_overload()
	name = "Emergency Forcefield"


/datum/malf_research_ability/manipulation/machine_overload
	ability = new/datum/game_mode/malfunction/verb/machine_overload()
	price = 5000
	name = "Machine Overload"

// END RESEARCH DATUMS
// BEGIN ABILITY VERBS

/datum/game_mode/malfunction/verb/hack_holopad(var/obj/machinery/hologram/holopad/HP = null as obj in get_unhacked_holopads())
	set name = "Hack Holopad"
	set desc = "50 CPU - Hacks a holopad shorting out its projector. Using a hacked holopad only turns on the audio feature."
	set category = "Software"
	var/price = 50
	var/mob/living/silicon/ai/user = usr
	if(!ability_prechecks(user, price) || !ability_pay(user,price))
		return
	if(HP.hacked)
		to_chat(user, "This holopad is already hacked!")
		return

	to_chat(user, "Hacking holopad...")
	user.hacking = 1
	sleep(100)
	HP.hacked = 1
	log_ability_use(user, "hack_holopad")
	to_chat(user, "Holopad hacked.")
	user.hacking = 0

/datum/game_mode/malfunction/verb/hack_camera(var/obj/machinery/camera/target = null as obj in cameranet.cameras)
	set name = "Hack Camera"
	set desc = "100 CPU - Hacks existing camera, allowing you to add upgrade of your choice to it. Alternatively it lets you reactivate broken camera."
	set category = "Software"
	var/price = 100
	var/mob/living/silicon/ai/user = usr

	if(target && !istype(target))
		to_chat(user, "This is not a camera.")
		return

	if(!ability_prechecks(user, price))
		return

	if(!target)
		return
	var/action = input("Select required action: ") in list("Reset", "Add X-Ray", "Add Motion Sensor", "Add EMP Shielding")
	if(target)
		switch(action)
			if("Reset")
				if(target.wires)
					if(!ability_pay(user, price))
						return
					target.reset_wires()
					to_chat(user, "Camera reactivated.")
					log_ability_use(user, "hack camera (reset)", target)
					return
			if("Add X-Ray")
				if(target.isXRay())
					to_chat(user, "Camera already has X-Ray function.")
					return
				else if(ability_pay(user, price))
					target.upgradeXRay()
					target.reset_wires()
					to_chat(user, "X-Ray camera module enabled.")
					log_ability_use(user, "hack camera (add X-Ray)", target)
					return
			if("Add Motion Sensor")
				if(target.isMotion())
					to_chat(user, "Camera already has Motion Sensor function.")
					return
				else if(ability_pay(user, price))
					target.upgradeMotion()
					target.reset_wires()
					to_chat(user, "Motion Sensor camera module enabled.")
					log_ability_use(user, "hack camera (add motion)", target)
					return
			if("Add EMP Shielding")
				if(target.isEmpProof())
					to_chat(user, "Camera already has EMP Shielding function.")
					return
				else if(ability_pay(user, price))
					target.upgradeEmpProof()
					target.reset_wires()
					to_chat(user, "EMP Shielding camera module enabled.")
					log_ability_use(user, "hack camera (add EMP shielding)", target)
					return
	else
		to_chat(user, "Please pick a suitable camera.")


/datum/game_mode/malfunction/verb/emergency_forcefield(var/turf/T as turf in turfs)
	set name = "Emergency Forcefield"
	set desc = "275 CPU - Uses station's emergency shielding system to create temporary barrier which lasts for few minutes, but won't resist gunfire."
	set category = "Software"
	var/price = 275
	var/mob/living/silicon/ai/user = usr
	if(!T || !istype(T))
		return
	if(!ability_prechecks(user, price) || !ability_pay(user, price))
		return

	to_chat(user, "Emergency forcefield projection completed.")
	new/obj/machinery/shield/malfai(T)
	user.hacking = 1
	log_ability_use(user, "emergency forcefield", T)
	sleep(20)
	user.hacking = 0


/datum/game_mode/malfunction/verb/machine_overload(obj/machinery/M in SSmachinery.processing_machines)
	set name = "Machine Overload"
	set desc = "400 CPU - Causes cyclic short-circuit in machine, resulting in weak explosion after some time."
	set category = "Software"
	var/price = 400
	var/mob/living/silicon/ai/user = usr

	if(!ability_prechecks(user, price))
		return

	var/obj/machinery/power/N = M

	var/explosion_intensity = 2

	// Verify if we can overload the target, if yes, calculate explosion strength. Some things have higher explosion strength than others, depending on charge(APCs, SMESs)
	if(N && istype(N)) // /obj/machinery/power first, these create bigger explosions due to direct powernet connection
		if(!istype(N, /obj/machinery/power/apc) && !istype(N, /obj/machinery/power/smes/buildable) && (!N.powernet || !N.powernet.avail)) // Directly connected machine which is not an APC or SMES. Either it has no powernet connection or it's powernet does not have enough power to overload
			to_chat(user, "<span class='notice'>ERROR: Low network voltage. Unable to overload. Increase network power level and try again.</span>")
			return
		else if (istype(N, /obj/machinery/power/apc)) // APC. Explosion is increased by available cell power.
			var/obj/machinery/power/apc/A = N
			if(A.cell && A.cell.charge)
				explosion_intensity = explosion_intensity + round((A.cell.charge / CELLRATE) / 100000)
			else
				to_chat(user, "<span class='notice'>ERROR: APC Malfunction - Cell depleted or removed. Unable to overload.</span>")
				return
		else if (istype(N, /obj/machinery/power/smes/buildable)) // SMES. These explode in a very very very big boom. Similar to magnetic containment failure when messing with coils.
			var/obj/machinery/power/smes/buildable/S = N
			if(S.charge && S.RCon)
				explosion_intensity = 4 + round((S.charge / CELLRATE) / 100000)
			else
				// Different error texts
				if(!S.charge)
					to_chat(user, "<span class='notice'>ERROR: SMES Depleted. Unable to overload. Please charge SMES unit and try again.</span>")
				else
					to_chat(user, "<span class='notice'>ERROR: SMES RCon error - Unable to reach destination. Please verify wire connection.</span>")
				return
	else if(M && istype(M)) // Not power machinery, so it's a regular machine instead. These have weak explosions.
		if(!M.use_power) // Not using power at all
			to_chat(user, "<span class='notice'>ERROR: No power grid connection. Unable to overload.</span>")
			return
		if(M.inoperable()) // Not functional
			to_chat(user, "<span class='notice'>ERROR: Unknown error. Machine is probably damaged or power supply is nonfunctional.</span>")
			return
	else // Not a machine at all (what the hell is this doing in Machines list anyway??)
		to_chat(user, "<span class='notice'>ERROR: Unable to overload - target is not a machine.</span>")
		return

	explosion_intensity = min(explosion_intensity, 12) // 3, 6, 12 explosion cap

	if(!ability_pay(user,price))
		return

	// M.use_power(1 MEGAWATTS)

	// Trigger a powernet alarm. Careful engineers will probably notice something is going on.
	var/area/temp_area = get_area(M)
	if(temp_area)
		var/obj/machinery/power/apc/temp_apc = temp_area.get_apc()
		if(temp_apc && temp_apc.terminal && temp_apc.terminal.powernet)
			temp_apc.terminal.powernet.trigger_warning(50) // Long alarm
		if(temp_apc)
			temp_apc.emp_act(3) // Such power surges are not good for APC electronics/cell in general.
			if(prob(explosion_intensity))
				temp_apc.set_broken()


	log_ability_use(user, "machine overload", M)
	M.visible_message("<span class='notice'>BZZZZZZZT</span>")
	sleep(50)
	explosion(get_turf(M), round(explosion_intensity/4),round(explosion_intensity/2),round(explosion_intensity),round(explosion_intensity * 2))
	if(M)
		qdel(M)

// END ABILITY VERBS

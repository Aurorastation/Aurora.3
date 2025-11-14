/obj/item/mecha_equipment/sleeper
	name = "\improper exosuit sleeper"
	desc = "An exosuit-mounted sleeper designed to maintain patients stabilized on their way to medical facilities."
	icon_state = "mech_sleeper"
	restricted_hardpoints = list(HARDPOINT_BACK)
	restricted_software = list(MECH_SOFTWARE_MEDICAL)
	equipment_delay = 30 //don't spam it on people pls
	active_power_use = 0 //Usage doesn't really require power. We don't want people stuck inside
	origin_tech = list(TECH_DATA = 2, TECH_BIO = 3)
	passive_power_use = 25
	var/obj/machinery/sleeper/mounted/sleeper = null
	module_hints = list(
		"<b>Left Click(Living Target):</b> Load the target into the mech's onboard Medical Sleeper unit.",
		"<b>Alt Click(Icon):</b> Activate the sleeper unit's control interface.",
		"Mounted sleepers are capable of performing any task that a stationary sleeper can do.",
		"This includes putting a patient into stasis, injecting medicines, and performing kidney dialysis.",
	)

/obj/item/mecha_equipment/sleeper/Initialize()
	. = ..()
	sleeper = new /obj/machinery/sleeper/mounted(src)
	sleeper.forceMove(src)

/obj/item/mecha_equipment/sleeper/Destroy()
	sleeper.go_out() //If for any reason you weren't outside already.
	QDEL_NULL(sleeper)
	. = ..()

/obj/item/mecha_equipment/sleeper/uninstalled()
	. = ..()
	sleeper.go_out()

/obj/item/mecha_equipment/sleeper/attack_self(var/mob/user)
	. = ..()
	if(.)
		sleeper.ui_interact(user)

/obj/item/mecha_equipment/sleeper/attack(mob/living/target_mob, mob/living/user, target_zone)
	return

/obj/item/mecha_equipment/sleeper/attackby(obj/item/attacking_item, mob/user)
	return sleeper.attackby(attacking_item, user)

/obj/item/mecha_equipment/sleeper/afterattack(var/atom/target, var/mob/living/user, var/inrange, var/params)
	. = ..()
	if(!.)
		return

	//Check it's a person and typecast if so
	if(!ishuman(target))
		return
	var/mob/living/carbon/human/person_to_load = target

	//Check that the person is not buckled
	if(person_to_load.buckled_to)
		to_chat(SPAN_WARNING("You must unbuckle [person_to_load] before loading!"))
		return

	//Check that the sleeper isn't already occupied
	if(sleeper.occupant)
		to_chat(user, SPAN_WARNING("The sleeper is already occupied!"))
		return

	//All good, load the person
	visible_message(SPAN_NOTICE("\The [src] begins loading \the [target] into \the [src]."))
	sleeper.go_in(person_to_load, user)

/obj/item/mecha_equipment/sleeper/get_hardpoint_maptext()
	if(sleeper && sleeper.occupant)
		return "[sleeper.occupant]"

/obj/item/mecha_equipment/sleeper/CtrlClick(mob/user)
	if(owner)
		sleeper.go_out()
	else
		..()

/obj/machinery/sleeper/mounted
	name = "\improper mounted sleeper"
	density = 0
	anchored = 0
	idle_power_usage = 0
	active_power_usage = 0 //It'd be hard to handle, so for now all power is consumed by mech sleeper object
	interact_offline = TRUE
	display_loading_message = FALSE

/obj/machinery/sleeper/mounted/ui_host()
	var/obj/item/mecha_equipment/sleeper/S = loc
	if(istype(S))
		return S.owner
	return null

/obj/machinery/sleeper/mounted/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/reagent_containers/glass))
		if(!user.unEquip(attacking_item, src))
			return TRUE

		if(beaker)
			beaker.forceMove(get_turf(src))
			user.visible_message(SPAN_NOTICE("\The [user] removes \the [beaker] from \the [src]."),
									SPAN_NOTICE("You remove \the [beaker] from \the [src]."))

		beaker = attacking_item
		user.visible_message(SPAN_NOTICE("\The [user] adds \a [attacking_item] to \the [src]."),
								SPAN_NOTICE("You add \a [attacking_item] to \the [src]."))

		return TRUE

/obj/item/mecha_equipment/crisis_drone
	name = "crisis dronebay"
	desc = "A small shoulder-mounted dronebay containing a rapid response drone capable of moderately stabilizing a patient near the exosuit."
	icon_state = "med_droid"
	origin_tech = list(TECH_PHORON = 2, TECH_MAGNET = 3, TECH_BIO = 3, TECH_DATA = 3)
	active_power_use = 0
	passive_power_use = 3000
	restricted_hardpoints = list(HARDPOINT_LEFT_SHOULDER)
	restricted_software = list(MECH_SOFTWARE_MEDICAL)
	equipment_delay = 3

	var/beam_state = "medbeam"

	var/enabled = FALSE

	var/max_distance = 3

	var/damcap = 30
	var/heal_dead = FALSE	// Does this device heal the dead?

	var/brute_heal = 2	// Amount of bruteloss healed.
	var/burn_heal = 2	// Amount of fireloss healed.
	var/tox_heal = 2		// Amount of toxloss healed.
	var/oxy_heal = 4		// Amount of oxyloss healed.
	var/rad_heal = 0		// Amount of radiation healed.
	var/clone_heal = 0	// Amount of cloneloss healed.
	var/hal_heal = 0.8	// Amount of halloss healed.
	var/bone_heal = 0	// Percent chance it will heal a broken bone. this does not mean 'make it not instantly re-break'.

	var/mob/living/carbon/Target = null
	var/datum/beam/MyBeam = null

	module_hints = list(
		"<b>Alt Click(Drone Icon):</b> Activates the drone. When active, it will bob up and down rapidly as a visual indication.",
		"When active, a crisis drone will constantly attempt to heal injured people within <b>3</b> tiles.",
		"The drone is capable of healing most damage types, it will even alleviate a patient's pain. It cannot heal patients with less than 30 total damage.",
		"It <b>cannot</b> heal the dead. It also <b>cannot</b> mend broken bones.",
	)

/obj/item/mecha_equipment/crisis_drone/alien
	name = "anomalous dronebay"
	desc = "A small shoulder-mounted dronebay containing a drone made seemingly from mercury."
	icon_state = "alien_drone"
	origin_tech = list(TECH_PHORON = 9, TECH_MAGNET = 9, TECH_BIO = 9, TECH_DATA = 9)
	restricted_hardpoints = list(HARDPOINT_LEFT_SHOULDER, HARDPOINT_RIGHT_SHOULDER)

/obj/item/mecha_equipment/crisis_drone/alien/Initialize()
	. = ..()
	max_distance = rand(1, 5)
	passive_power_use *= rand(0.8, 1.2)
	damcap *= rand(0.8, 1.2)
	heal_dead = prob(50)

	// 5% chance to be a "Harming drone" instead of a healing drone. All healing is inverted to damage. Have fun with that.
	var/harming_drone = 1
	if(prob(5))
		harming_drone = -1

	brute_heal = rand(1, 5) * harming_drone
	burn_heal = rand(1, 5) * harming_drone
	tox_heal = rand(1, 5) * harming_drone
	oxy_heal = rand(1, 5) * harming_drone
	rad_heal = rand(1, 5) * harming_drone
	clone_heal = rand(1, 5) * harming_drone
	hal_heal = rand(1, 5) * harming_drone
	bone_heal = rand(0, 499) / 5

/obj/item/mecha_equipment/crisis_drone/Destroy()
	Target = null
	MyBeam = null
	STOP_PROCESSING(SSprocessing, src)
	. = ..()

/obj/item/mecha_equipment/crisis_drone/uninstalled()
	. = ..()
	shut_down()
	STOP_PROCESSING(SSprocessing, src)

/obj/item/mecha_equipment/crisis_drone/process()	// Will continually try to find the nearest person above the threshold that is a valid target, and try to heal them.
	if(!(owner.get_cell()?.check_charge(active_power_use * CELLRATE)))
		shut_down()

	var/mob/living/carbon/Targ = Target
	var/TargDamage = 0

	if(!valid_target(Target))
		Target = null
		passive_power_use = 3000

	if(Target)
		TargDamage = (Targ.getOxyLoss() + Targ.getFireLoss() + Targ.getBruteLoss() + Targ.getToxLoss())

	for(var/mob/living/carbon/Potential in view(max_distance, owner))
		if(!valid_target(Potential))
			continue

		var/tallydamage = 0
		if(oxy_heal)
			tallydamage += Potential.getOxyLoss()
		if(burn_heal)
			tallydamage += Potential.getFireLoss()
		if(brute_heal)
			tallydamage += Potential.getBruteLoss()
		if(tox_heal)
			tallydamage += Potential.getToxLoss()
		if(hal_heal)
			tallydamage += Potential.getHalLoss()
		if(clone_heal)
			tallydamage += Potential.getCloneLoss()

		if(tallydamage > TargDamage)
			Target = Potential

	if(MyBeam && !valid_target(MyBeam.target))
		QDEL_NULL(MyBeam)

	if(Target)
		if(MyBeam && MyBeam.target != Target)
			QDEL_NULL(MyBeam)

		if(valid_target(Target))
			if(!MyBeam)
				MyBeam = owner.Beam(Target,icon='icons/effects/beam.dmi',icon_state=beam_state,time=3 SECONDS,maxdistance=max_distance,beam_type = /obj/effect/ebeam,beam_sleep_time=2)
			heal_target(Target)


/obj/item/mecha_equipment/crisis_drone/proc/valid_target(var/mob/living/carbon/L)
	. = TRUE

	if(!L || !istype(L))
		return FALSE

	if(get_dist(L, owner) > max_distance)
		return FALSE

	if(!(L in view(max_distance, owner)))
		return FALSE

	if(!unique_patient_checks(L))
		return FALSE

	if(L.stat == DEAD && !heal_dead)
		return FALSE

	var/tallydamage = 0
	if(oxy_heal)
		tallydamage += L.getOxyLoss()
	if(burn_heal)
		tallydamage += L.getFireLoss()
	if(brute_heal)
		tallydamage += L.getBruteLoss()
	if(tox_heal)
		tallydamage += L.getToxLoss()
	if(hal_heal)
		tallydamage += L.getHalLoss()
	if(clone_heal)
		tallydamage += L.getCloneLoss()

	if(tallydamage < damcap)
		return FALSE

/obj/item/mecha_equipment/crisis_drone/proc/shut_down()
	if(enabled)
		owner.visible_message(SPAN_NOTICE("\The [owner]'s [src] buzzes as its drone returns to port."))
		toggle_drone()
	if(!isnull(Target))
		Target = null
	if(MyBeam)
		QDEL_NULL(MyBeam)

/obj/item/mecha_equipment/crisis_drone/proc/unique_patient_checks(var/mob/living/carbon/L)	// Anything special for subtypes. Does it only work on Robots? Fleshies? A species?
	. = TRUE

/obj/item/mecha_equipment/crisis_drone/proc/heal_target(var/mob/living/carbon/L)	// We've done all our special checks, just get to fixing damage.
	passive_power_use = 50000
	if(istype(L))
		L.adjustBruteLoss(brute_heal * -1)
		L.adjustFireLoss(burn_heal * -1)
		L.adjustToxLoss(tox_heal * -1)
		L.adjustOxyLoss(oxy_heal * -1)
		L.adjustCloneLoss(clone_heal * -1)
		L.adjustHalLoss(hal_heal * -1)
		L.add_chemical_effect(CE_PAINKILLER, 50) //Pain is bad :(

		if(ishuman(L) && bone_heal)
			var/mob/living/carbon/human/H = L

			if(H.bad_external_organs.len)
				for(var/obj/item/organ/external/E in H.bad_external_organs)
					if(prob(bone_heal))
						E.status &= ~ORGAN_BROKEN

/obj/item/mecha_equipment/crisis_drone/proc/toggle_drone(var/mob/user)
	enabled = !enabled
	if(enabled)
		to_chat(user, SPAN_NOTICE("Medical drone activated."))
		icon_state = "med_droid_a"
		START_PROCESSING(SSprocessing, src)
	else
		to_chat(user, SPAN_NOTICE("Medical drone deactivated."))
		icon_state = "med_droid"
		STOP_PROCESSING(SSprocessing, src)
	update_icon()
	owner.update_icon()

/obj/item/mecha_equipment/crisis_drone/attack_self(var/mob/user)
	. = ..()
	if(.)
		toggle_drone(user)

/obj/item/mecha_equipment/mounted_system/medanalyzer
	name = "mounted health analyzer"
	icon_state = "mecha_healthyanalyzer"
	holding_type = /obj/item/device/healthanalyzer/mech
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_MEDICAL)
	module_hints = list(
		"<b>Left Click(Target):</b> Instantly perform a basic medical scan of the target.",
		"<b>Ctrl Click(Target):</b> After remaining still for 7 seconds, print a full body scan of the target.",
	)

/// Special health analyzer used by the exosuit health analyzer.
/obj/item/device/healthanalyzer/mech
	name = "mounted health analyzer"
	var/obj/machinery/body_scanconsole/connected = null
	/// Toggle whether to do full or basic scan
	var/fullScan = FALSE

/obj/item/device/healthanalyzer/mech/get_hardpoint_maptext()
	return "[(fullScan ? "Full" : "Basic")]"

/obj/item/device/healthanalyzer/mech/Initialize()
	. = ..()
	if(!connected)
		var/obj/machinery/body_scanconsole/S = new (src)
		S.forceMove(src)
		S.update_use_power(POWER_USE_OFF)
		connected = S

/obj/item/device/healthanalyzer/mech/Destroy()
	if(connected)
		QDEL_NULL(connected)
	. = ..()

/obj/item/mecha_equipment/mounted_system/medanalyzer/CtrlClick(mob/user)
	var/obj/item/device/healthanalyzer/mech/HA = holding
	if(istype(HA))
		HA.fullScan = !HA.fullScan
		to_chat(user, SPAN_NOTICE("You switch to \the [src]'s [HA.fullScan ? "full body" : "basic"] scan mode."))
		if(HA.fullScan)
			icon_state = "mecha_healthyanalyzer_alt"
		else
			icon_state = "mecha_healthyanalyzer"
		update_icon()
		owner.update_icon()

/obj/item/device/healthanalyzer/mech/attack(mob/living/target_mob, mob/living/user, target_zone)
	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	user.do_attack_animation(src)
	var/mob/living/heavy_vehicle/user_vehicle = user
	if(!istype(user_vehicle))
		to_chat(user, SPAN_NOTICE("Only Exosuits can handle this equipment!"))
		return FALSE
	if(!fullScan)
		for(var/mob/pilot in user_vehicle.pilots)
			health_scan_mob(target_mob, pilot, TRUE, TRUE, sound_scan = TRUE)
	else
		user_vehicle.visible_message("<b>[user_vehicle]</b> starts scanning \the [target_mob] with \the [src].",
								SPAN_NOTICE("You start scanning \the [target_mob] with \the [src]."))
		for(var/mob/pilot in user_vehicle.pilots)
			if(!do_after(pilot, 7 SECONDS, target_mob, (DO_DEFAULT & ~DO_USER_CAN_TURN) | DO_USER_UNIQUE_ACT | DO_FAIL_FEEDBACK)) // Pilots must not move while scanning
				return FALSE
		print_scan(target_mob, user_vehicle)

/obj/item/device/healthanalyzer/mech/proc/print_scan(var/mob/M, var/mob/living/heavy_vehicle/user_vehicle)
	var/obj/item/paper/medscan/R = new /obj/item/paper/medscan(user_vehicle.loc, connected.format_occupant_data(get_medical_data(M)), "Scan ([M.name])", M)
	for(var/mob/pilot in user_vehicle.pilots)
		R.show_content(pilot)
	user_vehicle.visible_message(SPAN_NOTICE("\The [src] spits out a piece of paper."))
	playsound(user_vehicle.loc, /singleton/sound_category/print_sound, 50, 1)
	R.forceMove(user_vehicle.loc)

/obj/item/device/healthanalyzer/mech/proc/get_medical_data(var/mob/living/carbon/human/H)
	if (!ishuman(H))
		return

	var/displayed_stat = H.stat
	var/blood_oxygenation = H.get_blood_oxygenation()
	if(H.status_flags & FAKEDEATH)
		displayed_stat = DEAD
		blood_oxygenation = min(blood_oxygenation, BLOOD_VOLUME_SURVIVE)
	switch(displayed_stat)
		if(CONSCIOUS)
			displayed_stat = "Conscious"
		if(UNCONSCIOUS)
			displayed_stat = "Unconscious"
		if(DEAD)
			displayed_stat = "DEAD"

	var/pulse_result
	if(H.should_have_organ(BP_HEART))
		var/obj/item/organ/internal/heart/heart = H.internal_organs_by_name[BP_HEART]
		if(!heart)
			pulse_result = 0
		else if(BP_IS_ROBOTIC(heart))
			pulse_result = -2
		else if(H.status_flags & FAKEDEATH)
			pulse_result = 0
		else
			pulse_result = H.get_pulse(GETPULSE_TOOL)
	else
		pulse_result = -1

	if(pulse_result == ">250")
		pulse_result = -3

	var/datum/reagents/R = H.bloodstr

	connected.has_internal_injuries = FALSE
	connected.has_external_injuries = FALSE
	var/list/bodyparts = connected.get_external_wound_data(H)
	var/list/organs = connected.get_internal_wound_data(H)

	var/list/occupant_data = list(
		"stationtime" = worldtime2text(),
		"stat" = displayed_stat,
		"name" = H.name,
		"species" = H.get_species(),

		"brain_activity" = H.get_brain_status(),
		"pulse" = text2num(pulse_result),
		"blood_volume" = H.get_blood_volume(),
		"blood_oxygenation" = H.get_blood_oxygenation(),
		"blood_pressure" = H.get_blood_pressure(),
		"blood_type" = H.dna.b_type,

		"bruteloss" = get_severity(H.getBruteLoss(), TRUE),
		"fireloss" = get_severity(H.getFireLoss(), TRUE),
		"oxyloss" = get_severity(H.getOxyLoss(), TRUE),
		"toxloss" = get_severity(H.getToxLoss(), TRUE),
		"cloneloss" = get_severity(H.getCloneLoss(), TRUE),

		"rads" = H.total_radiation,
		"paralysis" = H.paralysis,
		"bodytemp" = H.bodytemperature,
		"borer_present" = H.has_brain_worms(),
		"inaprovaline_amount" = REAGENT_VOLUME(R, /singleton/reagent/inaprovaline),
		"dexalin_amount" = REAGENT_VOLUME(R, /singleton/reagent/dexalin),
		"soporific_amount" = REAGENT_VOLUME(R, /singleton/reagent/soporific),
		"bicaridine_amount" = REAGENT_VOLUME(R, /singleton/reagent/bicaridine),
		"dermaline_amount" = REAGENT_VOLUME(R, /singleton/reagent/dermaline),
		"thetamycin_amount" = REAGENT_VOLUME(R, /singleton/reagent/thetamycin),
		"other_amount" = R.total_volume - (REAGENT_VOLUME(R, /singleton/reagent/inaprovaline) + REAGENT_VOLUME(R, /singleton/reagent/soporific) + REAGENT_VOLUME(R, /singleton/reagent/bicaridine) + REAGENT_VOLUME(R, /singleton/reagent/dexalin) + REAGENT_VOLUME(R, /singleton/reagent/dermaline) + REAGENT_VOLUME(R, /singleton/reagent/thetamycin)),
		"bodyparts" = bodyparts,
		"organs" = organs,
		"has_internal_injuries" = connected.has_internal_injuries,
		"has_external_injuries" = connected.has_external_injuries,
		"missing_limbs" = connected.get_missing_limbs(H),
		"missing_organs" = connected.get_missing_organs(H)
		)
	return occupant_data

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

/obj/item/mecha_equipment/sleeper/attack()
	return

/obj/item/mecha_equipment/sleeper/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/reagent_containers/glass))
		sleeper.attackby(I, user)
	else return ..()

/obj/item/mecha_equipment/sleeper/afterattack(var/atom/target, var/mob/living/user, var/inrange, var/params)
	. = ..()
	if(.)
		if(ishuman(target) && !sleeper.occupant)
			visible_message("<span class='notice'>\The [src] begins loading \the [target] into \the [src].</span>")
			sleeper.go_in(target, user)
		else
			to_chat(user, "<span class='warning'>You cannot load that in!</span>")

/obj/item/mecha_equipment/sleeper/get_hardpoint_maptext()
	if(sleeper && sleeper.occupant)
		return "[sleeper.occupant]"

/obj/machinery/sleeper/mounted
	name = "\improper mounted sleeper"
	density = 0
	anchored = 0
	idle_power_usage = 0
	active_power_usage = 0 //It'd be hard to handle, so for now all power is consumed by mech sleeper object
	interact_offline = TRUE
	display_loading_message = FALSE

/obj/machinery/sleeper/mounted/ui_interact(var/mob/user, var/ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = mech_state)
	. = ..()

/obj/machinery/sleeper/mounted/ui_host()
	var/obj/item/mecha_equipment/sleeper/S = loc
	if(istype(S))
		return S.owner
	return null

/obj/machinery/sleeper/mounted/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/reagent_containers/glass))
		if(!user.unEquip(I, src))
			return

		if(beaker)
			beaker.forceMove(get_turf(src))
			user.visible_message("<span class='notice'>\The [user] removes \the [beaker] from \the [src].</span>", "<span class='notice'>You remove \the [beaker] from \the [src].</span>")
		beaker = I
		user.visible_message("<span class='notice'>\The [user] adds \a [I] to \the [src].</span>", "<span class='notice'>You add \a [I] to \the [src].</span>")

/obj/machinery/sleeper/mounted/go_out()

	if(!occupant)
		return

	occupant.forceMove(get_turf(src))
	occupant = null

	return

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

/obj/item/mecha_equipment/crisis_drone/Initialize()
	..()

/obj/item/mecha_equipment/crisis_drone/Destroy()
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
		owner.visible_message("<span class='notice'>\The [owner]'s [src] buzzes as its drone returns to port.</span>")
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

		if(ishuman(L) && bone_heal)
			var/mob/living/carbon/human/H = L

			if(H.bad_external_organs.len)
				for(var/obj/item/organ/external/E in H.bad_external_organs)
					if(prob(bone_heal))
						E.status &= ~ORGAN_BROKEN

/obj/item/mecha_equipment/crisis_drone/proc/toggle_drone()
	for(var/mob/pilot in owner.pilots)
		if(owner)
			enabled = !enabled
			update_icon()
			if(enabled)
				to_chat(pilot,"<span class='notice'>Medical drone activated.</span>")
				icon_state = "med_droid_a"
				START_PROCESSING(SSprocessing, src)
			else
				to_chat(pilot,"<span class='notice'>Medical drone deactivated.</span>")
				icon_state = "med_droid"
				STOP_PROCESSING(SSprocessing, src)
			owner.update_icon()

/obj/item/mecha_equipment/crisis_drone/attack_self(var/mob/user)
	toggle_drone()


/obj/item/mecha_equipment/mounted_system/medanalyzer
	name = "mounted health analyzer"
	icon_state = "mecha_healthyanalyzer"
	holding_type = /obj/item/device/healthanalyzer/mech
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_MEDICAL)

/obj/item/device/healthanalyzer/mech/attack(mob/living/M, var/mob/living/heavy_vehicle/user)
	for(var/mob/pilot in user.pilots)
		health_scan_mob(M, pilot, FALSE)
		return

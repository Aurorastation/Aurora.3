/obj/machinery/optable
	name = "operating table"
	desc = "Used for advanced medical procedures."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "table2-idle"
	pass_flags_self = PASSTABLE
	density = TRUE
	anchored = TRUE
	use_power = POWER_USE_IDLE
	idle_power_usage = 1
	active_power_usage = 5
	component_types = list(
			/obj/item/circuitboard/optable,
			/obj/item/stock_parts/scanning_module = 1
		)

	///The base icon state that will be modified
	var/modify_state = "table2"

	///The person occupying the table, a weakref to a `/mob/living/carbon/human`
	var/datum/weakref/occupant = null

	///If the table is currently suppressing, aka active
	var/suppressing = FALSE

	///The connected surgery computer
	var/obj/machinery/computer/operating/computer = null

/obj/machinery/optable/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Click your target with Grab intent, then click on the table with an empty hand, to place them on it."

/obj/machinery/optable/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "The neural suppressors are switched [suppressing ? "on" : "off"]."

/obj/machinery/optable/Initialize()
	..()

	LAZYADD(can_buckle, /mob/living)
	buckle_delay = 30

	RegisterSignal(loc, COMSIG_ATOM_ENTERED, PROC_REF(mark_patient))
	RegisterSignal(loc, COMSIG_ATOM_EXITED, PROC_REF(unmark_patient))

	return INITIALIZE_HINT_LATELOAD

/obj/machinery/optable/LateInitialize()
	. = ..()

	//Search for an operating computer and ask it to hook us up
	for(var/obj/machinery/computer/operating/candidate_computer in orange(src, 1))
		if(candidate_computer.hook_table(src))
			break

/obj/machinery/optable/Destroy()
	STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
	UnregisterSignal(loc, COMSIG_ATOM_ENTERED)
	UnregisterSignal(loc, COMSIG_ATOM_EXITED)

	//If we have a computer, ask it to unhook us, clear the reference anyways just to be sure
	if(computer)
		computer.unhook_table(src)
	computer = null

	//If there's an occupant, ensure to release the view before dropping the weakref
	var/occupant_resolved = occupant?.resolve()
	if(occupant_resolved)
		release_view(occupant_resolved)
	occupant = null

	. = ..()

/// Any mob that enters our tile will awaken our processing as it's a potential patient
/obj/machinery/optable/proc/mark_patient(datum/source, mob/living/carbon/potential_patient)
	SIGNAL_HANDLER
	if(!istype(potential_patient))
		return
	START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
	refresh_icon_state()

/// Unmark the potential patient
/obj/machinery/optable/proc/unmark_patient(datum/source, mob/living/carbon/potential_patient)
	SIGNAL_HANDLER
	if(!istype(potential_patient))
		return

	//Stop processing only if it's not the occupant, or the occupant doesn't exist
	var/occupant_resolved = occupant?.resolve()
	if(isnull(occupant_resolved) || potential_patient == occupant_resolved)
		STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)

		//If it was the occupant, clear the var and give him back the view, and turn off the suppressor
		if(potential_patient == occupant_resolved)
			suppressing = FALSE
			occupant = null //Null the weakref
			release_view(potential_patient)

		//Reprocess the icon state at the end
		refresh_icon_state()

/obj/machinery/optable/process(seconds_per_tick)
	//We just call the check_occupant for all the processing
	check_occupant(seconds_per_tick)

/**
 * Acquires the view of the patient so that it's locked on the table, instead of eg. remote viewing a camera
 */
/obj/machinery/optable/proc/acquire_view(mob/living/carbon/patient)
	//No point if there's no client
	if(!patient.client)
		return

	//Perspective according to the eye
	patient.client.perspective = EYE_PERSPECTIVE
	patient.client.eye = src

/**
 * Releases the view of the patient back to the mob
 */
/obj/machinery/optable/proc/release_view(mob/living/carbon/patient)
	//No point if there's no client
	if(!patient.client)
		return

	patient.reset_view(null)

/obj/machinery/optable/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if(prob(50))
				qdel(src)
				return
		if(3.0)
			if(prob(25))
				density = FALSE
	return

/obj/machinery/optable/attack_hand(mob/user)
	if((user.mutations & HULK))
		visible_message(SPAN_DANGER("\The [user] destroys \the [src]!"))
		density = FALSE
		qdel(src)
		return

	var/mob/living/carbon/human/occupant_resolved = occupant?.resolve()
	if(!occupant_resolved)
		to_chat(user, SPAN_WARNING("There is nobody on \the [src]. It would be pointless to turn the suppressor on."))
		return TRUE

	if((user.a_intent != I_HELP) && buckled)
		user_unbuckle(user)
		return
	if(user != occupant_resolved && !use_check_and_message(user)) // Skip checks if you're doing it to yourself or turning it off, this is an anti-griefing mechanic more than anything.
		user.visible_message(SPAN_WARNING("\The [user] begins switching [suppressing ? "off" : "on"] \the [src]'s neural suppressor."))
		if(!do_after(user, 3 SECONDS, src, DO_UNIQUE))
			return
		if(!occupant_resolved)
			to_chat(user, SPAN_WARNING("There is nobody on \the [src]. It would be pointless to turn the suppressor on."))

		suppressing = !suppressing
		user.visible_message(SPAN_NOTICE("\The [user] switches [suppressing ? "on" : "off"] \the [src]'s neural suppressor."), intent_message = BUTTON_FLICK)
		playsound(loc, /singleton/sound_category/switch_sound, 50, 1)

/**
 * Refreshes the icon state based on the table status
 */
/obj/machinery/optable/proc/refresh_icon_state()
	SHOULD_NOT_SLEEP(TRUE)

	var/mob/living/carbon/human/human_occupant = occupant?.resolve()

	if(istype(human_occupant) && human_occupant.lying && !(human_occupant.isSynthetic()))
		//If there's a bad condition, set the critical table icon
		if(human_occupant.stat == DEAD || human_occupant.is_asystole() || (human_occupant.status_flags & FAKEDEATH) || !human_occupant.pulse())
			icon_state = "[modify_state]-critical"
		//Otherwise, as far as we can tell, the patient is alive; set the active table icon
		else
			icon_state = "[modify_state]-active"

	//Noone on the table or a synthetic, idle status
	else
		icon_state = "[modify_state]-idle"


/obj/machinery/optable/proc/check_occupant(seconds_per_tick)
	SHOULD_NOT_SLEEP(TRUE)

	refresh_icon_state()
	var/mob/living/carbon/human/occupant_resolved = occupant?.resolve()

	//If the occupant is not set
	if(!occupant_resolved)
		//Reset suppression
		suppressing = FALSE

		//Try to find a patient, if you have one, set it as occupant
		//does not mean it's suppressed, just that it's occupying the table
		var/mob/living/carbon/human/new_occupant = locate() in loc
		if(istype(new_occupant))
			if(new_occupant.lying)
				//Set the occupant weakref and get his view
				occupant = WEAKREF(new_occupant)
				acquire_view(new_occupant)

	//We have a patient, and it's not synthetic
	else if(!occupant_resolved.isSynthetic())
		//If the table is on and suppressing
		if(suppressing)
			if(stat & NOPOWER)
				return FALSE

			src.use_power_oneoff(2 KILO WATTS)

			//Set it to unwillful sleep
			occupant_resolved.Sleeping(3.5*seconds_per_tick)
			occupant_resolved.willfully_sleeping = FALSE

			//Blur the vision
			occupant_resolved.eye_blurry = max((3.5*seconds_per_tick), occupant_resolved.eye_blurry)

		return TRUE

	return FALSE

/**
 * To handle the 30 snowflake ways to get a mob on the table
 *
 * * patient - The (will be) occupant
 * * giver - The person that is occupant the `patient` on the table
 *
 * Returns `TRUE` if the patient was taken, `FALSE` otherwise
 */
/obj/machinery/optable/proc/take_occupant(mob/living/carbon/patient, mob/living/carbon/giver)
	SHOULD_NOT_SLEEP(TRUE)

	//No point if there's no patient
	if(!istype(patient))
		return FALSE

	//Someone is already on the table
	var/mob/living/carbon/human/occupant_resolved = occupant?.resolve()
	if(occupant_resolved)
		return FALSE

	if(patient == giver) //Putting yourself on the table
		giver.visible_message("\The [giver] climbs on \the [src].", "You climb on \the [src].")
	else //Putting someone else on the table, or noone
		visible_message(SPAN_NOTICE("\The [patient] has been laid on \the [src] by \the [giver]."))

	//Add the fingerprints and fibers of both the giver and the patient
	add_fingerprint(giver)
	add_fibers(giver)
	add_fingerprint(patient)
	add_fibers(patient)

	move_patient_to_table(patient, giver)

	return TRUE

/**
 * Actually moves a patient to the table.
 */
/obj/machinery/optable/proc/move_patient_to_table(mob/living/carbon/patient, mob/living/carbon/giver)
	patient.resting = TRUE
	patient.forceMove(loc)

/obj/machinery/optable/mouse_drop_receive(atom/dropped, mob/user, params)
	//If the user is a ghost, stop.
	if(isghost(user))
		return

	if(istype(dropped, /obj/item))
		user.drop_from_inventory(dropped, get_turf(src))

	var/mob/living/carbon/patient = dropped
	//No point if it's not a possible patient
	if(!istype(patient))
		return

	//If the user is not able, stop
	if(user.stat || user.restrained())
		return

	//It's already occupied, spessbro
	var/mob/living/carbon/human/occupant_resolved = occupant?.resolve()
	if(occupant_resolved)
		to_chat(usr, SPAN_NOTICE(SPAN_BOLD("\The [src] is already occupied!")))
		return

	if((get_turf(patient) != get_turf(src)))
		var/bucklestatus = patient.bucklecheck(user)
		if(!bucklestatus)
			return

		if(patient == user)
			user.visible_message(SPAN_NOTICE("\The [user] starts climbing onto \the [src]."), SPAN_NOTICE("You start climbing onto \the [src]."), range = 3)
		else
			user.visible_message(SPAN_NOTICE("\The [user] starts putting \the [patient] onto \the [src]."), SPAN_NOTICE("You start putting \the [patient] onto \the [src]."), range = 3)

		//Move the patient on the table after a short delay and buckle him
		if(do_mob(user, patient, 1 SECOND, needhand = FALSE))
			//If he's already buckled to something, unbuckle him first
			if(bucklestatus == 2)
				var/obj/structure/LB = patient.buckled_to
				LB.user_unbuckle(user)
			take_occupant(patient, user)
	else
		return ..()

/obj/machinery/optable/attackby(obj/item/attacking_item, mob/user, params)
	if(istype(attacking_item, /obj/item/grab))
		var/obj/item/grab/G = attacking_item

		var/mob/living/carbon/human/occupant_resolved = occupant?.resolve()
		if(occupant_resolved)
			to_chat(usr, SPAN_NOTICE(SPAN_BOLD("\The [src] is already occupied!")))
			return TRUE

		var/mob/living/L = G.affecting
		var/bucklestatus = L.bucklecheck(user)
		if(!bucklestatus)
			return TRUE

		if(L == user)
			user.visible_message(SPAN_NOTICE("\The [user] starts climbing onto \the [src]."), SPAN_NOTICE("You start climbing onto \the [src]."), range = 3)
		else
			user.visible_message(SPAN_NOTICE("\The [user] starts putting \the [L] onto \the [src]."), SPAN_NOTICE("You start putting \the [L] onto \the [src]."), range = 3)
		if(do_mob(user, L, 10, needhand = FALSE))
			take_occupant(G.affecting,usr)
			qdel(attacking_item)
		return TRUE
	if(default_deconstruction_screwdriver(user, attacking_item))
		return TRUE
	if(default_deconstruction_crowbar(user, attacking_item))
		return TRUE
	if(default_part_replacement(user, attacking_item))
		return TRUE

/obj/machinery/optable/robotics
	name = "machinery chair"
	desc = "Some sort of hybrid between an operating table and a chair, typically used by machinists and roboticists to strap synthetics to while they work on them. \
			It comes with an access cable for easy access to a synthetic's diagnostics unit."
	icon_state = "machinist_or_table"

	/// The access cable linked to this table.
	var/obj/item/access_cable/access_cable

/obj/machinery/optable/robotics/mechanics_hints(mob/user, distance, is_adjacent)
	. = ..()
	. += list("Use the <b>Retrieve Cable</b> verb on this chair in order to take the access cable from it.")
	. += list("You can then click an IPC with that cable to slot it into them. After that, click on the chair with <b>grab</b> intent.")

/obj/machinery/optable/robotics/refresh_icon_state()
	return

/obj/machinery/optable/robotics/move_patient_to_table(mob/living/carbon/patient, mob/living/carbon/giver)
	buckle(patient, giver)

/obj/machinery/optable/robotics/Initialize()
	. = ..()
	access_cable = new(src, src)

/obj/machinery/optable/robotics/attack_hand(mob/user)
	if(access_cable?.target && user.a_intent == I_GRAB)
		if(istype(access_cable.target, /obj/item/organ/internal/machine/access_port))
			var/obj/item/organ/internal/machine/access_port/port = access_cable.target
			port.cable_interact(access_cable, user)
	else
		. = ..()

/obj/machinery/optable/robotics/attackby(obj/item/attacking_item, mob/user, params)
	if(istype(attacking_item, /obj/item/access_cable))
		var/obj/item/access_cable/retrieved_cable = attacking_item
		if(retrieved_cable == access_cable)
			visible_message(SPAN_NOTICE("[user] slots \the [access_cable] back into \the [src]."))
			user.drop_from_inventory(access_cable)
			access_cable.forceMove(src)
			retrieved_cable.clear_cable_full()
			return TRUE
	else
		return ..()

/obj/machinery/optable/robotics/verb/take_cable()
	set name = "Retrieve Cable"
	set category = "Object"
	set src in view(1)

	if(!ishuman(usr))
		return

	var/mob/living/carbon/human/user = usr

	if(use_check_and_message(user))
		return

	if(!access_cable)
		to_chat(user, SPAN_WARNING("This table does not have an access cable anymore!"))
		return

	if(user.get_active_hand())
		to_chat(user, SPAN_WARNING("You need a free hand to retrieve \the [access_cable]!"))
		return

	if(access_cable.loc != src)
		to_chat(user, SPAN_WARNING("The access cable is already elsewhere!"))
		return

	user.visible_message(SPAN_NOTICE("[user] retrieves \the [access_cable] from \the [src]."), SPAN_NOTICE("You retrieve \the [access_cable] from \the [src]."))
	access_cable.create_cable(src, user)
	user.put_in_active_hand(access_cable)

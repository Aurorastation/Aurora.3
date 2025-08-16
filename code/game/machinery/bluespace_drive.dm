/datum/looping_sound/bluespace_drive
	mid_sounds = list('sound/ambience/highsec/highsec2.ogg' = 1)
	mid_length = 13 SECONDS
	volume = 70
	vary = TRUE

/obj/machinery/bluespacedrive
	name = "C-Goliath Drive"
	desc = "Developed by NanoTrasen, the C-Goliath Drive is a complex piece of machinery designed to fold space using the physics of the Bluespace Dimension and powered by Phoron. \
			As one of the greatest pieces of technology invented in the Orion Spur, the bluespace drive changed history twice. \
			Once after its discovery, and again during the phoron shortage."
	icon = 'icons/obj/machinery/bluespace-drive.dmi'
	icon_state = "drive_base"
	init_flags = EMPTY_BITFIELD
	dir = NORTH

	pixel_x = -81
	pixel_y = -96

	anchored = TRUE
	density = TRUE
	// opacity = TRUE

	///The atmospherics interface used to give gasses to the drive
	var/obj/machinery/atmospherics/portables_connector/atmos_interface

	///The interface used to give fuel (phoron) to the drive
	var/obj/machinery/atmospherics/portables_connector/fuel_interface

	///The internal gas that the drive uses, fed by the `atmos_interface`
	var/datum/gas_mixture/internal_gas = new()

	///The fuel gas that the drive uses, fed by the `fuel_interface`
	var/datum/gas_mixture/fuel_gas = new()

	/**
	 * How much each mole of a given gas contributes to the power
	 *
	 * This is then multiplied by the logarithm of the gas temperature, so atmos techs have a reason to burn gasses
	 *
	 * Keys are gas IDs, see `GAS_*` in `code\__DEFINES\atmos.dm`
	 *
	 * Values are power, numbers
	 */
	var/static/list/gas_mole_to_power_factor = list(
		GAS_PHORON = 1,

		/* Common gasses */
		GAS_HYDROGEN = 0.7,
		GAS_OXYGEN = 0.9,
		GAS_NITROGEN = 0.3,
		GAS_CO2 = 0.24,
		GAS_N2O = 0.5,

		/* Uncommon gasses, if you work out to get them, you deserve better power */
		GAS_SULFUR = 1.2,
		GAS_CHLORINE = 1,
		GAS_HELIUM = 1.6,
		GAS_DEUTERIUM = 1.67,
		GAS_TRITIUM = 1.68,
		GAS_BORON = 1.69
	)

	/**
	 * How many phoron moles we need to jump, anything more is useless
	 *
	 * Encourages atmos techs to be precise with their calculations
	 */
	var/static/minimum_phoron_moles_per_jump = 1000 //About half of a full canister

	///The power given to the drive, due to gasses
	var/power_from_gas

	///The rotation we'll be using to jump
	var/rotation = 0

	///The angle we'll be using to jump
	var/angle = 60

	///If the drive is energized
	var/energized = FALSE

	///The looping sound that plays when the drive is energized
	var/datum/looping_sound/bluespace_drive/energized_looping_sound

	///The timer id for the initiate jump sequence
	var/initiate_jump_timer_id

	///The singularity that this drive made
	var/obj/singularity/bluespace_drive/our_singularity

	///Our bluespace jump event
	var/datum/event/bluespace_jump/bluespace_jump_event


/obj/machinery/bluespacedrive/Initialize()
	..()

	//Thanks to byond bug 2925542
	bound_y = -64
	bound_height = 128
	bound_x = -32
	bound_width = 96

	atmos_interface = locate(/obj/machinery/atmospherics/portables_connector) in get_turf(src)
	if(atmos_interface)
		RegisterSignal(atmos_interface, COMSIG_QDELETING, PROC_REF(handle_atmos_interface_qdeleting))

	fuel_interface = locate(/obj/machinery/atmospherics/portables_connector) in get_step(src, WEST)
	if(fuel_interface)
		RegisterSignal(fuel_interface, COMSIG_QDELETING, PROC_REF(handle_fuel_interface_qdeleting))

	return INITIALIZE_HINT_LATELOAD

/obj/machinery/bluespacedrive/LateInitialize()
	if(SSatlas.current_map.use_overmap && !linked)
		var/my_sector = GLOB.map_sectors["[z]"]
		if(istype(my_sector, /obj/effect/overmap/visitable/ship))
			attempt_hook_up(my_sector)

	if(!linked)
		//Stacktrace only outside unit tests
		#if !defined(UNIT_TEST)
		stack_trace("Bluespace drives must be linked to a ship!")
		qdel(src)
		#endif

		return



/obj/machinery/bluespacedrive/Destroy()
	QDEL_NULL(internal_gas)
	QDEL_NULL(fuel_gas)

	atmos_interface = null
	fuel_interface = null

	. = ..()

/obj/machinery/bluespacedrive/update_icon()
	ClearOverlays()

	. = ..()

	//We're energized (on)
	if(energized)
		AddOverlays("drive_glow")

	//We're jumping
	if(initiate_jump_timer_id)
		AddOverlays("drive_orb")

/obj/machinery/bluespacedrive/process(seconds_per_tick)

	//If we have an atmos interface, and it's connected to a pipe, pump gas from it to our internal gas tank
	if(atmos_interface?.node)
		var/power_used = pump_gas(atmos_interface, atmos_interface.node.return_air(), internal_gas)
		use_power_oneoff(power_used)

	//If we have a fuel interface, and it's connected to a pipe, pump gas from it to our internal gas tank
	//passive flow only, to encourage the use of higher pressures
	if(fuel_interface?.node)
		var/datum/gas_mixture/node_gas_mixture = fuel_interface.node.return_air()
		scrub_gas(src, list(GAS_PHORON), node_gas_mixture, fuel_gas)

	consume_internal_gasses()

	if(power_from_gas && fuel_gas.total_moles)
		if(!our_singularity)
			our_singularity = new(get_turf(src), 100, FALSE, FALSE, src)
			RegisterSignal(our_singularity, COMSIG_QDELETING, PROC_REF(handle_singularity_deletion))

	else
		if(our_singularity)
			QDEL_NULL(our_singularity)

/obj/machinery/bluespacedrive/CanPass(atom/movable/mover, turf/target, height, air_group)
	if(istype(mover, /obj/singularity/bluespace_drive))
		return TRUE

	. = ..()

/**
 * Compute the power from the gasses that we received, and discard them
 * any non recognised gasses goes to (blue)space, aka is thrown away
 */
/obj/machinery/bluespacedrive/proc/consume_internal_gasses()
	SHOULD_NOT_SLEEP(TRUE)

	for(var/gas_type in internal_gas.gas)
		power_from_gas += internal_gas.get_gas(gas_type) * (gas_mole_to_power_factor[gas_type] * log(max(internal_gas.temperature, 1.1)))

	//Reset the internal gasses, we have "consumed" them
	internal_gas = new()

/**
 * Moves the ship to the target location, depending on the drive charge and configuration
 */
/obj/machinery/bluespacedrive/proc/move_ship()
	SHOULD_NOT_SLEEP(TRUE)

	var/turf/target_turf = get_jump_destination()

	if(!target_turf)
		return

	linked.forceMove(target_turf)

/**
 * Returns the destination of the jump, based on the current drive configuration
 *
 * Returns FALSE if the jump cannot be performed or would end up in the same turf, the new `/turf` otherwise
 */
/obj/machinery/bluespacedrive/proc/get_jump_destination()
	SHOULD_BE_PURE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	//No fuel, no jump
	if(!fuel_gas.total_moles || !power_from_gas)
		return FALSE

	var/turf/ship_turf = get_turf(linked)

	var/datum/projectile_data/proj_data = projectile_trajectory(linked.x, linked.y, rotation, angle, (power_from_gas / (10 KILO)))

	var/turf/target_turf = locate(proj_data.dest_x, proj_data.dest_y, linked.z)

	//If the destination isn't where the ship can go, remain in place
	if(!istype(target_turf, /turf/unsimulated/map) || istype(ship_turf, /turf/unsimulated/map/edge) || (target_turf == ship_turf))
		return FALSE
	else
		return target_turf

///Handles the qdel of the atmos_interface
/obj/machinery/bluespacedrive/proc/handle_atmos_interface_qdeleting()
	SIGNAL_HANDLER

	atmos_interface = null

///Handles the qdel of the atmos_interface
/obj/machinery/bluespacedrive/proc/handle_fuel_interface_qdeleting()
	SIGNAL_HANDLER

	fuel_interface = null

///Handles the qdel of the atmos_interface
/obj/machinery/bluespacedrive/proc/handle_singularity_deletion()
	SIGNAL_HANDLER

	our_singularity = null

///Toggles the energized state of the drive
/obj/machinery/bluespacedrive/proc/toggle_energized()
	SHOULD_NOT_SLEEP(TRUE)

	energized = !energized

	if(energized)
		START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
		energized_looping_sound = new(src, TRUE)
		light_range = 5
		light_color = "#0e3b69"

	else
		STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
		QDEL_NULL(energized_looping_sound)
		light_range = 0
		light_color = null

		//Turning the drive off while still holding a charge
		if(internal_gas.total_moles || fuel_gas.total_moles)
			purge_charge()

		//If we're jumping, abort the jump
		if(initiate_jump_timer_id)
			abort_bluespace_jump()

	update_icon()
	update_light()

/**
 * Purges the drive charge
 *
 * forced - If TRUE, the purge isn't the natural effect of consuming the gasses
 */
/obj/machinery/bluespacedrive/proc/purge_charge(forced)
	SHOULD_NOT_SLEEP(TRUE)

	if(forced)
		playsound(src, 'sound/effects/supermatter.ogg', 100, TRUE)

		for(var/mob/living/carbon/human/H in get_hearers_in_LOS(world.view, src))
			H.flash_act(FLASH_PROTECTION_MAJOR)
			H.noise_act(EAR_PROTECTION_MAJOR, 0, 1)

	//Dump the power
	power_from_gas = 0

	//No point computing the removal of all the content since we're purging, just make a new gas mixture
	fuel_gas = new()
	internal_gas = new() //Technically this is reset on every processing and shouldn't be necessary, neverthless...

	if(our_singularity)
		QDEL_NULL(our_singularity)

	update_icon()

///Sets the rotation of the drive jump
/obj/machinery/bluespacedrive/proc/set_rotation(rotation)
	SHOULD_NOT_SLEEP(TRUE)

	if(!isnum(rotation) || rotation < 0 || rotation > 359)
		stack_trace("Invalid rotation!")
		return

	src.rotation = rotation


/*############################
	JUMP SEQUENCE PROCS
############################*/

/**
 * Initiates the jump sequence
 *
 * Returns FALSE if the jump cannot be performed, TRUE otherwise
 */
/obj/machinery/bluespacedrive/proc/initiate_jump()
	SHOULD_NOT_SLEEP(TRUE)

	//Already jumping
	if(initiate_jump_timer_id)
		return FALSE

	//We don't have enough power to jump
	if(fuel_gas.total_moles < minimum_phoron_moles_per_jump)
		return FALSE

	if(!get_jump_destination())
		return FALSE

	activate_bluespace_jump_event()

	command_announcement.Announce("Attention all hands, Tigard-Alasdair field generation warp arrays are being energized, assume bluespace jump action stations; \
									bluespace transition procedures are now in effect. Severe risk of death or serious injury to all personnel outside of the vessel. \
									30 seconds to space warping.",
									"C-Goliath Bluespace Drive Jump Sequence Initiated")//, 'sound/effects/ship_weapons/leviathan_safetyoff.ogg')

	for(var/mob/living/affected_mob in GLOB.player_list)
		//Skip all mobs that are not in a connected z level to the drive
		if(!AreConnectedZLevels(affected_mob.z, z))
			continue

		apply_bluespace_effect(affected_mob)
		affected_mob.playsound_local(affected_mob, 'sound/magic/Ethereal_Enter.ogg', 60)

	initiate_jump_timer_id = addtimer(CALLBACK(src, PROC_REF(enter_bluespace)), 30 SECONDS, TIMER_UNIQUE|TIMER_STOPPABLE)

	update_icon()

	return TRUE


/obj/machinery/bluespacedrive/proc/enter_bluespace()
	SHOULD_NOT_SLEEP(TRUE)

	for(var/mob/living/affected_mob in GLOB.player_list)
		//Skip all mobs that are not in a connected z level to the drive
		if(!AreConnectedZLevels(affected_mob.z, z))
			continue

		//Sorry spessbro, your story ends here if you're still outside when the ship jumps
		if(istype(get_area(affected_mob), /area/space))
			to_chat(affected_mob, SPAN_DANGER("Space completely warps around you, turning your body into something that a mind can barely comprehend..."))
			qdel(affected_mob)

	//Discharge to all the coils (flavored as warper receivers)
	var/coils_discharged_to = 0
	for(var/obj/machinery/power/tesla_coil/coil in orange(4, src))
		if(!coil.anchored)
			continue

		src.Beam(coil, icon_state="lightning[rand(1,12)]", icon = 'icons/effects/effects.dmi', time= 2 SECONDS)
		coils_discharged_to++

	//If it's less than the expected amount of coils, it failed, purge the charge and do not move the ship,
	//otherwise it succeeded, move the ship
	if(coils_discharged_to < 4)
		//Play the sound if at least one coil got the discharge
		if(coils_discharged_to)
			playsound(src, 'sound/magic/lightningbolt.ogg', 40, TRUE)

		visible_message(SPAN_DANGER("\The [src] fails to warp completely, not finding all the warper receivers!"))
		purge_charge(forced = TRUE)

	else
		move_ship()

	exit_bluespace()


/**
 * Exits the bluespace, also called if the jump is aborted
 */
/obj/machinery/bluespacedrive/proc/exit_bluespace()
	SHOULD_NOT_SLEEP(TRUE)

	for(var/mob/living/affected_mob in GLOB.player_list)
		//Skip all mobs that are not in a connected z level to the drive
		if(!AreConnectedZLevels(affected_mob.z, z))
			continue

		remove_bluespace_effect(affected_mob)
		affected_mob.playsound_local(affected_mob, 'sound/magic/Ethereal_Exit.ogg', 60)

	deactivate_bluespace_jump_event()

	initiate_jump_timer_id = null
	purge_charge(forced = FALSE)
	update_icon()


/**
 * Aborts the jump sequence
 */
/obj/machinery/bluespacedrive/proc/abort_bluespace_jump()
	SHOULD_NOT_SLEEP(TRUE)

	//The timer means we're jumping, if not set, we're not jumping so we can't abort
	if(!initiate_jump_timer_id)
		return

	//Purge the charge if there's any, in case of an aborted jump
	if(internal_gas.total_moles || fuel_gas.total_moles)
		purge_charge()

	deltimer(initiate_jump_timer_id)
	exit_bluespace()
	visible_message(SPAN_DANGER("\The [src] bluespace warp bubble constriction field falthers, discharging!"))


/obj/machinery/bluespacedrive/proc/apply_bluespace_effect(mob/living/M)
	if(M.client)
		to_chat(M,SPAN_NOTICE("You feel oddly light, and somewhat disoriented as everything around you shimmers and warps ever so slightly."))
		M.overlay_fullscreen("bluespace", /atom/movable/screen/fullscreen/bluespace_overlay)
	M.confused = 20

/obj/machinery/bluespacedrive/proc/remove_bluespace_effect(mob/living/M)
	if(M.client)
		to_chat(M,SPAN_NOTICE("You feel rooted in the material world again."))
		M.clear_fullscreen("bluespace")

///Activates the bluespace jump event, mainly to give the skybox image
/obj/machinery/bluespacedrive/proc/activate_bluespace_jump_event()
	SHOULD_NOT_SLEEP(TRUE)

	if(istype(bluespace_jump_event))
		stack_trace("Bluespace jump event already active, but somehow is being triggered again!")

	bluespace_jump_event = new()

///Deactivates the bluespace jump event, mainly to return the skybox image to normal
/obj/machinery/bluespacedrive/proc/deactivate_bluespace_jump_event()
	SHOULD_NOT_SLEEP(TRUE)

	if(QDELETED(bluespace_jump_event))
		return

	bluespace_jump_event.end()
	bluespace_jump_event.kill()
	QDEL_NULL(bluespace_jump_event)


/*######################
	CONTROL CONSOLE
######################*/

/**
 * # Bluespace Drive Control Console
 * The console that controls the bluespace drive
 */
/obj/machinery/computer/bluespacedrive
	name = "\improper Bluespace Drive Control Console"
	desc = "Used to control the bluespace drive."
	icon_keyboard = "lightblue_key"
	icon_keyboard_emis = "lightblue_key_mask"
	light_color = LIGHT_COLOR_BLUE

	/// The bluespace drive (`/obj/machinery/bluespacedrive`) that this console controls
	var/obj/machinery/bluespacedrive/linked_bluespace_drive

/obj/machinery/computer/bluespacedrive/Initialize()
	..()

	return INITIALIZE_HINT_LATELOAD

/obj/machinery/computer/bluespacedrive/LateInitialize()

	linked_bluespace_drive = locate() in get_area(src)

	if(!linked_bluespace_drive)

		//Stacktrace only outside unit tests
		#if !defined(UNIT_TEST)
		stack_trace("Bluespace drive not found!")
		qdel(src)
		#endif

		return

	RegisterSignal(linked_bluespace_drive, COMSIG_QDELETING, PROC_REF(handle_drive_deletion))

/obj/machinery/computer/bluespacedrive/Destroy()
	linked_bluespace_drive = null

	. = ..()


/obj/machinery/computer/bluespacedrive/ui_data(mob/user)
	var/list/data = list()

	data["energized"] = linked_bluespace_drive.energized
	data["charge"] = (linked_bluespace_drive.internal_gas.total_moles || linked_bluespace_drive.fuel_gas.total_moles) ? TRUE : FALSE
	data["rotation"] = linked_bluespace_drive.rotation
	data["jumping"] = linked_bluespace_drive.initiate_jump_timer_id ? TRUE : FALSE
	data["jump_power"] = linked_bluespace_drive.power_from_gas / (10 KILO)
	data["fuel_gas"] = linked_bluespace_drive.fuel_gas.total_moles

	return data


/obj/machinery/computer/bluespacedrive/ui_act(action, params)
	. = ..()
	if(.)
		return

	switch(action)

		if("toggle_energized")
			linked_bluespace_drive.toggle_energized()

		if("purge_charge")
			linked_bluespace_drive.purge_charge(forced = TRUE)

		if("set_rotation")
			linked_bluespace_drive.set_rotation(params["rotation"])

		if("jump")
			var/success = linked_bluespace_drive.initiate_jump()
			if(!success)
				visible_message(SPAN_NOTICE("\The [src] buzzes, flashing \"Unable to acquire bluespace path: Destination unreachable, same as current position \
											or jump already in progress\"!"))


/obj/machinery/computer/bluespacedrive/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BluespaceDrive", ui_x=500, ui_y=380)
		ui.open()


/obj/machinery/computer/bluespacedrive/attack_hand(mob/user)
		ui_interact(user)

/// Signal handler for when the linked bluespace drive is deleted
/obj/machinery/computer/bluespacedrive/proc/handle_drive_deletion()
	SIGNAL_HANDLER

	linked_bluespace_drive = null


/*######################
	BSD SINGULARITY
######################*/

/obj/singularity/bluespace_drive
	name = "bluespace drive singularity"
	energy = 100

	///The bluespace drive that made us
	var/obj/machinery/bluespacedrive/drive_that_made_us

	///How far can the singularity move from the drive, before it starts destroying things
	var/max_safe_distance_from_drive = 4

	///The beam that tethers the singularity to the drive
	var/datum/beam/beam_to_drive

/obj/singularity/bluespace_drive/Initialize(mapload, energy, qdel_in, alert_admins, obj/machinery/bluespacedrive/drive_that_made_us)
	. = ..()

	src.drive_that_made_us = drive_that_made_us
	RegisterSignal(drive_that_made_us, COMSIG_QDELETING, PROC_REF(handle_drive_deletion))

	beam_to_drive = src.Beam(loc, icon_state="n_beam", icon = 'icons/effects/beam.dmi', time=-1, maxdistance=max_safe_distance_from_drive)
	RegisterSignal(beam_to_drive, COMSIG_QDELETING, PROC_REF(handle_beam_deletion))

/obj/singularity/bluespace_drive/Destroy()
	drive_that_made_us = null
	QDEL_NULL(beam_to_drive)

	. = ..()

/obj/singularity/bluespace_drive/check_energy()

	if(is_safe())

		if(drive_that_made_us.initiate_jump_timer_id)
			energy = 400

		else
			energy = 100

	. = ..()

/obj/singularity/bluespace_drive/process()
	//Since it doesn't move while it's small otherwise
	if(is_safe())
		move()

	. = ..()

/obj/singularity/bluespace_drive/eat()
	if(!is_safe())
		. = ..()

/obj/singularity/bluespace_drive/consume(atom/A)
	if(!is_safe())
		. = ..()

/obj/singularity/bluespace_drive/event()
	if(!is_safe())
		. = ..()

/**
 * Returns whether or not the singularity is safe
 */
/obj/singularity/bluespace_drive/proc/is_safe()
	if(!drive_that_made_us || !beam_to_drive)
		return FALSE

	// if(get_dist(src, drive_that_made_us) > max_safe_distance_from_drive)
	// 	return FALSE

	return TRUE

/obj/singularity/bluespace_drive/proc/handle_drive_deletion()
	SIGNAL_HANDLER

	drive_that_made_us = null
	QDEL_IN(src, 10 SECONDS)

/obj/singularity/bluespace_drive/proc/handle_beam_deletion()
	SIGNAL_HANDLER

	beam_to_drive = null


/*####################
	BSD JUMP EVENT
####################*/

/**
 * Bluespace Jump event, never triggers autonomously, only the BSD Drive can trigger it
 *
 * Mainly exist for the skybox shenanigans
 */
/datum/event/bluespace_jump
	event_meta = new /datum/event_meta/bluespace_jump()
	has_skybox_image = TRUE
	no_fake = TRUE
	endWhen = INFINITY //Event stopped manually

/datum/event/bluespace_jump/get_skybox_image()
	var/image/res = overlay_image('icons/skybox/ionbox.dmi', "ions", color_matrix_rotate_hue(rand(-3,3)*5), RESET_COLOR|KEEP_TOGETHER)
	res.blend_mode = BLEND_INSET_OVERLAY
	res.add_filter("displace", 1, list("icon" = icon('icons/skybox/ionbox.dmi', "ions")))
	res.alpha = 0
	animate(res, alpha = 255, time = (5 SECONDS), easing = (CIRCULAR_EASING|EASE_OUT))
	return res


/**
 * Bluespace Jump event metadata
 */
/datum/event_meta/bluespace_jump
	enabled = FALSE
	weight = 0

/*##########################
	FLUFF INGAME MANUAL
##########################*/

/obj/item/paper/fluff/bluespacedrive_manual
	set_unsafe_on_init = TRUE

/obj/item/paper/fluff/bluespacedrive_manual/New(loc, ...)
	name = "[/obj/machinery/bluespacedrive::name] Field Handbook"
	desc = "A manual illustrating the basic operation of the [/obj/machinery/bluespacedrive::name], useful for those who missed the last 300 years of history."

	info = {"
	<h2>
		<b>[/obj/machinery/bluespacedrive::name] Field Handbook - Quick Reference</b><BR>
	</h2>

	<font size = "1">
		<i>"How to use the [/obj/machinery/bluespacedrive::name] for bluespace jumping."</i>
	</font>

	<BR>
	<BR>
	<BR>

	<font size = "2">
		<h3>The [/obj/machinery/bluespacedrive::name] comes equipped with:</h3><BR>
		<ul style="list-style:circle">
			<li>Two separate gas feeding circuits: A Phoron line on the west and a moderator gas mix line on the north.</li>
			<li>Two independent power circuits: The primary circuit, which feeds the outer shield ring, the room APC and the drive itself, and the secondary circuit, which feeds the inner shield ring.</li>
			<li>A same-room control console.</li>
		</ul>

		<BR>
		<BR>
		<BR>

		<h3>Operational Instructions:</h3><BR>
		<ol>
			<li>Energize and charge the two SMES circuits to an acceptable level.</li>
			<li>Wrench down the coils and the outer shield ring generators, wrench down and weld down the inner shield ring generators and the emitters.</li>
			<li>Prepare [/obj/machinery/bluespacedrive::minimum_phoron_moles_per_jump] moles of Phoron to be pulled into the drive, on the Phoron line.</li>
			<li>Prepare the moderator gas mixture to be fed into the drive, on the moderator gas mix line.</li>
			<li>Once sure the calculations for the gasses are correct and the drive can feed, activate the emitters.</li>
			<li>Wait for the charge bar indicators on the inner shield generators to reach 100%.</li>
			<li>Operate the inner shield generators to turn them on. <span style="color:red;">Move away from them as soon as activated, the shield can and will repel you too!</span></li>
			<li>Unlock with your ID card and activate the outer shield generators, if non-specialized personnel is present, lock them back after activation.</li>
			<li>Operate the control console, energize the drive and observe the gasses being fed into it.</li>
			<li>Set the rotation of the jump on the knob, in absolute galactic degrees.</li>
			<li><b><span style="color:red;">Announce the jump and ensure no personnel is outside the ship!</span></b></li>
			<li>Activate the jump, the drive will take approximately 30 seconds to energize the field, then it will jump automatically.</li>
			<li>De-energize the drive in the control console.</li>
			<li>Disable the secondary circuit SMES output to disable the emitters, and wait for the inner shield generators to discharge and the shield to extinguish.</li>
			<li>Disable the outer shield generators.</li>
		</ol>

		<BR>
		<BR>
		<BR>

		<h3>Emergency Procedure:</h3><BR>
		Should the drive need to be shut down for an emergency, or to abort the jump, it's possible to de-energize it from the control console.<BR>
		Likewise, it's possible to dump unwanted gas mixtures contained in it via the appropriate dump button located in the control console.<BR>
		Dumping gasses will cause the gasses to be lost, it's recommended to only do that in extreme circumstances, and pump out the Phoron from the Phoron line before.<BR>

		Please note, the dissipation of the stored energy would cause a bluespace flash across the ship, which can cause temporary hearing and vision disturbances, when the drive is de-energized
		while operational or the gasses are dumped. If time allows, the crew should be informed about it.<BR>

		<BR>
		<BR>

		<h4><i>Dr. Marivek's notes:</i></h3><BR>
		The [/obj/machinery/bluespacedrive::name] will create the bluespace-field-driver singularity only when energized and fed with any valid gas in the moderator circuit and the Phoron line.<BR>
		Any quantity above [/obj/machinery/bluespacedrive::minimum_phoron_moles_per_jump] moles of Phoron is wasted, precise calculation is therefore encourage for efficiency.<BR>
		Various gasses can be used for the moderation mix, any gas that is not valid will simply be absorbed without contributing to the bluespace effect.<BR>
		Temperature of the moderation gas mixture is also influential, in my observations, ontop of the specific gas and the amount. Higher temperatures seems to increase the effect per mole.<BR>
		The field-driver singularity is not self-sustaining, and can be destroyed by depowering the [/obj/machinery/bluespacedrive::name].<BR>
		Should the field-driver singularity become loose from the quantum entanglement tunnel, unless fed, it won't destroy more than its size and won't move.<BR>
		It has been noted that, at times, it has been observed to escape the first shield ring. It is extremely important to ensure both shield rings are engaged for maximum safety.

	</font>
	"}

	. = ..()

#define SETUP_OK 1			// All good
#define SETUP_WARNING 2		// Something that shouldn't happen happened, but it's not critical so we will continue
#define SETUP_ERROR 3		// Something bad happened, and it's important so we won't continue setup.
#define SETUP_DELAYED 4		// Wait for other things first.

#define EMITTERSHOTS *14.4
#define ENERGY_CARBONDIOXIDE 10 EMITTERSHOTS
#define ENERGY_HYDROGEN 17 EMITTERSHOTS
#define ENERGY_NITROGEN 8 EMITTERSHOTS
#define ENERGY_NITROUSOXIDE 7 EMITTERSHOTS
#define ENERGY_OXYGEN 7 EMITTERSHOTS
#define ENERGY_PHORON 21 EMITTERSHOTS // Phoron can take more but this is enough to max out both SMESs anyway

#define OPT_CARBONDIOXIDE "Carbon Dioxide (CO2)"
#define OPT_HYDROGEN "Hydrogen (H2)"
#define OPT_NITROGEN "Nitrogen (N2)"
#define OPT_NITROUSOXIDE "Nitrous Oxide (N2O) \[DANGEROUS]"
#define OPT_OXYGEN "Oxygen (O2) \[DANGEROUS]"
#define OPT_PHORON "Phoron"
#define OPT_ABORT "Abort"

/*
	How to use (map) the Supermatter Auto-Setup feature:
	1. Have (map) a SM engine like normal.
	2. On top of every coolant injector (connector) ports add a `coolant_canister` marker.
	3. For every pump that needs to be maxed / turned on add a `pump_max` marker.
	4. For every connector port that needs an empty canister add a `empty_canister` marker.
	5. For every filter that needs to be set up for the coolant add a `filter` marker.
	   Note that the filters must be set up to filter the coolant back into the core loop by default.
	   Otherwise the auto setup will mess up and you'll end up without the correct coolant gas!
	6. For every freezer that needs to be on, add a `freezer` marker.
	7. For every SMES that needs to be online and maxed, add a `smes` marker.
	8. On top of the SM core map a `core` marker.
	9. Make sure to test that it actually works and doesn't blow up.
*/

/datum/admins/proc/setup_supermatter()
	set category = "Debug"
	set name = "Setup Supermatter"
	set desc = "Allows you to start the Supermatter engine."

	if(!check_rights(R_DEBUG|R_DEV))
		return

	var/list/opts = list(
		OPT_CARBONDIOXIDE,
		OPT_HYDROGEN,
		OPT_NITROGEN,
		OPT_NITROUSOXIDE,
		OPT_OXYGEN,
		OPT_PHORON,
		OPT_ABORT
	)
	var/response = input(usr, "Are you sure? This will start up the engine with selected gas as coolant.", "Engine setup") as null|anything in opts
	if(!response || response == OPT_ABORT)
		return

	var/errors = 0
	var/warnings = 0
	var/success = 0

	log_and_message_admins("## SUPERMATTER SETUP - Setup initiated by [usr] using coolant type [response].")

	// CONFIGURATION PHASE
	// Coolant canisters, set types according to response.
	for(var/obj/effect/landmark/engine_setup/coolant_canister/C in landmarks_list)
		switch(response)
			if(OPT_CARBONDIOXIDE)
				C.canister_type = /obj/machinery/portable_atmospherics/canister/carbon_dioxide
				continue
			if(OPT_HYDROGEN)
				C.canister_type = /obj/machinery/portable_atmospherics/canister/phoron
				continue
			if(OPT_NITROGEN)
				C.canister_type = /obj/machinery/portable_atmospherics/canister/nitrogen
				continue
			if(OPT_NITROUSOXIDE)
				C.canister_type = /obj/machinery/portable_atmospherics/canister/sleeping_agent
				continue
			if(OPT_OXYGEN)
				C.canister_type = /obj/machinery/portable_atmospherics/canister/oxygen
				continue
			if(OPT_PHORON)
				C.canister_type = /obj/machinery/portable_atmospherics/canister/hydrogen
				continue
			else
				to_chat(usr, SPAN_DANGER("Did not find canister type for '[response]'! Aborting."))
				return

	var/core_count = 0
	for(var/obj/effect/landmark/engine_setup/core/C in landmarks_list)
		core_count++
		switch(response)
			if(OPT_CARBONDIOXIDE)
				C.energy_setting = ENERGY_CARBONDIOXIDE
				continue
			if(OPT_HYDROGEN)
				C.energy_setting = ENERGY_HYDROGEN
				continue
			if(OPT_NITROGEN)
				C.energy_setting = ENERGY_NITROGEN
				continue
			if(OPT_NITROUSOXIDE)
				C.energy_setting = ENERGY_NITROUSOXIDE
				continue
			if(OPT_OXYGEN)
				C.energy_setting = ENERGY_OXYGEN
				continue
			if(OPT_PHORON)
				C.energy_setting = ENERGY_PHORON
				continue
			else
				to_chat(usr, SPAN_DANGER("Did not find energy setting for '[response]'! Aborting."))
				return

	if(core_count < 1)
		log_and_message_admins("## SUPERMATTER SETUP ERROR: Found no Supermatter core markers! Make sure all SM setup markers are mapped in properly. Aborting.")
		return

	for(var/obj/effect/landmark/engine_setup/filter/F in landmarks_list)
		switch(response)
			if(OPT_CARBONDIOXIDE)
				F.coolant = ATM_CO2
				continue
			if(OPT_HYDROGEN)
				F.coolant = ATM_H2
				continue
			if(OPT_NITROGEN)
				F.coolant = ATM_N2
				continue
			if(OPT_NITROUSOXIDE)
				F.coolant = ATM_N2O
				continue
			if(OPT_OXYGEN)
				F.coolant = ATM_O2
				continue
			if(OPT_PHORON)
				F.coolant = ATM_P
				continue
			else
				to_chat(usr, SPAN_DANGER("Did not find coolant setting for '[response]'! Aborting."))
				return

	var/list/delayed_objects = list()
	// SETUP PHASE
	for(var/obj/effect/landmark/engine_setup/S in landmarks_list)
		var/result = S.activate(0)
		switch(result)
			if(SETUP_OK)
				success++
				continue
			if(SETUP_WARNING)
				warnings++
				continue
			if(SETUP_ERROR)
				errors++
				log_and_message_admins("## SUPERMATTER SETUP - Error encountered! Aborting.")
				break
			if(SETUP_DELAYED)
				delayed_objects.Add(S)
				continue

	if(!errors)
		for(var/obj/effect/landmark/engine_setup/S in delayed_objects)
			var/result = S.activate(1)
			switch(result)
				if(SETUP_OK)
					success++
					continue
				if(SETUP_WARNING)
					warnings++
					continue
				if(SETUP_ERROR)
					errors++
					log_and_message_admins("## SUPERMATTER SETUP - Error encountered! Aborting.")
					break

	log_and_message_admins("## SUPERMATTER SETUP - Setup completed with [errors] errors, [warnings] warnings and [success] successful steps.")

	return


/obj/effect/landmark/engine_setup
	name = "Engine Setup Marker"
	desc = DESC_PARENT
	invisibility = 101
	anchored = 1
	density = 0
	icon = 'icons/mob/screen/generic.dmi'
	icon_state = "x4"

/obj/effect/landmark/engine_setup/proc/activate(var/last = 0)
	return SETUP_OK


// Tries to locate a pump, enables it, and sets it to MAX. Triggers warning if unable to locate a pump.
/obj/effect/landmark/engine_setup/pump_max
	name = "Pump Setup Marker"

/obj/effect/landmark/engine_setup/pump_max/activate()
	..()
	var/obj/machinery/atmospherics/binary/pump/P = locate() in get_turf(src)
	if(!P)
		log_and_message_admins("## WARNING: Unable to locate pump at [x] [y] [z]!")
		return SETUP_WARNING
	P.target_pressure = P.max_pressure_setting
	P.update_use_power(POWER_USE_IDLE)
	P.update_icon()
	return SETUP_OK


// Spawns an empty canister on this turf, if it has a connector port. Triggers warning if unable to find a connector port
/obj/effect/landmark/engine_setup/empty_canister
	name = "Empty Canister Marker"

/obj/effect/landmark/engine_setup/empty_canister/activate()
	..()
	var/obj/machinery/atmospherics/portables_connector/P = locate() in get_turf(src)
	if(!P)
		log_and_message_admins("## WARNING: Unable to locate connector port at [x] [y] [z]!")
		return SETUP_WARNING
	new/obj/machinery/portable_atmospherics/canister(get_turf(src)) // Canisters automatically connect to connectors in New()
	return SETUP_OK


// Spawns a coolant canister on this turf, if it has a connector port.
// Triggers error when unable to locate connector port or when coolant canister type is unset.
/obj/effect/landmark/engine_setup/coolant_canister
	name = "Coolant Canister Marker"
	var/canister_type = null

/obj/effect/landmark/engine_setup/coolant_canister/activate()
	..()
	var/obj/machinery/atmospherics/portables_connector/P = locate() in get_turf(src)
	if(!P)
		log_and_message_admins("## ERROR: Unable to locate coolant connector port at [x] [y] [z]!")
		return SETUP_ERROR
	if(!canister_type)
		log_and_message_admins("## ERROR: Canister type unset at [x] [y] [z]!")
		return SETUP_ERROR
	new canister_type(get_turf(src))
	return SETUP_OK


// Energises the supermatter. Errors when unable to locate supermatter.
/obj/effect/landmark/engine_setup/core
	name = "Supermatter Core Marker"
	var/energy_setting = 0

/obj/effect/landmark/engine_setup/core/activate(var/last = 0)
	if(!last)
		return SETUP_DELAYED
	..()
	var/obj/machinery/power/supermatter/SM = locate() in get_turf(src)
	if(!SM)
		log_and_message_admins("## ERROR: Unable to locate supermatter core at [x] [y] [z]!")
		return SETUP_ERROR
	if(!energy_setting)
		log_and_message_admins("## ERROR: Energy setting unset at [x] [y] [z]!")
		return SETUP_ERROR
	SM.power = energy_setting
	return SETUP_OK


// Tries to enable the SMES on max input/output settings. With load balancing it should be fine as long as engine outputs at least ~500kW
/obj/effect/landmark/engine_setup/smes
	name = "SMES Marker"

/obj/effect/landmark/engine_setup/smes/activate()
	..()
	var/obj/machinery/power/smes/S = locate() in get_turf(src)
	if(!S)
		log_and_message_admins("## WARNING: Unable to locate SMES unit at [x] [y] [z]!")
		return SETUP_WARNING
	S.input_attempt = 1
	S.output_attempt = 1
	S.input_level = S.input_level_max
	S.output_level = S.output_level_max
	S.update_icon()
	return SETUP_OK


// Sets up filters. This assumes the filtered gas is the coolant - that it goes back into the core loop by default.
/obj/effect/landmark/engine_setup/filter
	name = "Omni Filter Marker"
	var/coolant = null

/obj/effect/landmark/engine_setup/filter/activate()
	..()
	var/obj/machinery/atmospherics/omni/filter/F = locate() in get_turf(src)
	if(!F)
		log_and_message_admins("## WARNING: Unable to locate omni filter at [x] [y] [z]!")
		return SETUP_WARNING
	if(isnull(coolant))
		log_and_message_admins("## WARNING: No coolant type set for marker at [x] [y] [z]!")
		return SETUP_WARNING

	// set every filtering port to the target coolant
	for(var/datum/omni_port/P in F.ports)
		switch(P.mode)
			if(ATM_NONE, ATM_INPUT , ATM_OUTPUT)
				continue
			else
				P.mode = coolant
	F.rebuild_filtering_list()

	F.update_use_power(POWER_USE_IDLE)
	F.update_icon()
	return SETUP_OK


// Sets up freezers.
/obj/effect/landmark/engine_setup/freezer
	name = "Freezer Marker"

/obj/effect/landmark/engine_setup/freezer/activate()
	..()
	var/obj/machinery/atmospherics/unary/freezer/F = locate() in get_turf(src)
	if(!F)
		log_and_message_admins("## WARNING: Unable to locate freezer at [x] [y] [z]!")
		return SETUP_WARNING

	F.update_use_power(POWER_USE_IDLE)
	F.update_icon()
	return SETUP_OK


#undef SETUP_OK
#undef SETUP_WARNING
#undef SETUP_ERROR
#undef SETUP_DELAYED

#undef ENERGY_CARBONDIOXIDE
#undef ENERGY_HYDROGEN
#undef ENERGY_NITROGEN
#undef ENERGY_NITROUSOXIDE
#undef ENERGY_OXYGEN
#undef ENERGY_PHORON
#undef EMITTERSHOTS

#undef OPT_CARBONDIOXIDE
#undef OPT_HYDROGEN
#undef OPT_NITROGEN
#undef OPT_NITROUSOXIDE
#undef OPT_OXYGEN
#undef OPT_PHORON
#undef OPT_ABORT

/datum/gear/computer
	display_name = "laptop computer"
	path = /obj/item/modular_computer/laptop/preset/loadout
	sort_category = "Modular Computers"
	cost = 2

ABSTRACT_TYPE(/datum/gear/computer/handheld)

/datum/gear/computer/handheld/tablet
	display_name = "tablet"
	path = /obj/item/modular_computer/handheld/preset

/datum/gear/computer/handheld/tablet/New()
	..()
	var/list/tablets = list()
	tablets["generic tablet"] = /obj/item/modular_computer/handheld/preset/generic
	tablets["janitor tablet"] = /obj/item/modular_computer/handheld/preset/civilian/janitor
	tablets["operations tablet"] = /obj/item/modular_computer/handheld/preset/supply
	tablets["engineering tablet"] = /obj/item/modular_computer/handheld/preset/engineering
	tablets["atmos tablet"] = /obj/item/modular_computer/handheld/preset/engineering/atmos
	tablets["medical tablet"] =/obj/item/modular_computer/handheld/preset/medical
	tablets["security tablet"] = /obj/item/modular_computer/handheld/preset/security
	tablets["investigation tablet"] = /obj/item/modular_computer/handheld/preset/security/detective
	tablets["research tablet"] = /obj/item/modular_computer/handheld/preset/research
	tablets["machinist tablet"] = /obj/item/modular_computer/handheld/preset/supply/machinist
	gear_tweaks += new /datum/gear_tweak/path(tablets)

ABSTRACT_TYPE(/datum/gear/computer/handheld/wristbound)

/datum/gear/computer/handheld/wristbound/selection
	display_name = "wristbound computer selection"
	path = /obj/item/modular_computer/handheld/wristbound/preset

/datum/gear/computer/handheld/wristbound/selection/New()
	..()
	var/list/wristbounds = list()
	wristbounds["cheap generic wristbound"] = /obj/item/modular_computer/handheld/wristbound/preset/cheap/generic
	wristbounds["expensive generic wristbound"] = /obj/item/modular_computer/handheld/wristbound/preset/advanced/generic
	wristbounds["operations wristbound"] = /obj/item/modular_computer/handheld/wristbound/preset/advanced/cargo
	wristbounds["engineering wristbound"] = /obj/item/modular_computer/handheld/wristbound/preset/advanced/engineering
	wristbounds["medical wristbound"] = /obj/item/modular_computer/handheld/wristbound/preset/advanced/medical
	wristbounds["security wristbound"] = /obj/item/modular_computer/handheld/wristbound/preset/advanced/security
	wristbounds["investigation wristbound"] = /obj/item/modular_computer/handheld/wristbound/preset/advanced/security/investigations
	wristbounds["research wristbound"] = /obj/item/modular_computer/handheld/wristbound/preset/advanced/research
	gear_tweaks += new /datum/gear_tweak/path(wristbounds)

/datum/gear/computer/handheld/wristbound/ce
	display_name = "wristbound computer (Chief Engineer)"
	path = /obj/item/modular_computer/handheld/wristbound/preset/advanced/command/ce
	allowed_roles = list("Chief Engineer")

/datum/gear/computer/handheld/wristbound/rd
	display_name = "wristbound computer (Research Director)"
	path = /obj/item/modular_computer/handheld/wristbound/preset/advanced/command/rd
	allowed_roles = list("Research Director")

/datum/gear/computer/handheld/wristbound/cmo
	display_name = "wristbound computer (Chief Medical Officer)"
	path = /obj/item/modular_computer/handheld/wristbound/preset/advanced/command/cmo
	allowed_roles = list("Chief Medical Officer")

/datum/gear/computer/handheld/wristbound/xo
	display_name = "wristbound computer (Executive Officer)"
	path = /obj/item/modular_computer/handheld/wristbound/preset/advanced/command/xo
	allowed_roles = list("Executive Officer")

/datum/gear/computer/handheld/wristbound/hos
	display_name = "wristbound computer (Head of Security)"
	path = /obj/item/modular_computer/handheld/wristbound/preset/advanced/command/hos
	allowed_roles = list("Head of Security")

/datum/gear/computer/handheld/wristbound/captain
	display_name = "wristbound computer (Captain)"
	path = /obj/item/modular_computer/handheld/wristbound/preset/advanced/command/captain
	allowed_roles = list("Captain")

/datum/gear/computer/handheld/communicator
	display_name = "communicator"
	path = /obj/item/modular_computer/handheld/communicator
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION
	cost = 2

/datum/gear/computer/handheld/communicator/New()
	. = ..()
	gear_tweaks += new /datum/gear_tweak/communicator_address

// After spawning the communicator, register it to the player to avoid them needing to swipe their ID to activate it.
/datum/gear/computer/handheld/communicator/spawn_item(location, metadata, mob/living/carbon/human/H)
	var/obj/item/modular_computer/handheld/communicator/comm = ..()
	addtimer(CALLBACK(comm, TYPE_PROC_REF(/obj/item/modular_computer/handheld/communicator, register_to_mob), H), 3 SECONDS)
	return comm

/datum/gear/computer/handheld/communicator/video
	display_name = "video communicator"
	path = /obj/item/modular_computer/handheld/communicator/video
	cost = 4

/datum/gear/computer/handheld/communicator/holographic
	display_name = "holographic communicator"
	path = /obj/item/modular_computer/handheld/communicator/holographic
	cost = 6

// Communicator NTNet address customisation
/datum/gear_tweak/communicator_address/get_contents(metadata)
	return "Address: [metadata ? "{[metadata]}" : "Not set"]"

/datum/gear_tweak/communicator_address/get_metadata(user, metadata, title, gear_path)
	return tgui_input_communicator_address(user, "Communicator Number", metadata)

/datum/gear_tweak/communicator_address/tweak_item(obj/item/modular_computer/handheld/communicator/comm, metadata, mob/living/carbon/human/H)
	if(!metadata)
		return
	metadata = lowertext(metadata)
	if(!validate_ntnet_address(metadata))
		to_chat(H, SPAN_DANGER("Error applying custom communicator number: Invalid number."))
		return
	// A saved address can collide with a communicator that joined the round
	// before this loadout spawned. Keep the preference unchanged, but assign a
	// fresh address to this device for the current round.
	var/datum/computer_file/program/communicator/existing_app = GLOB.active_communicator_apps[metadata]
	var/datum/computer_file/program/communicator/comm_app = comm.get_communicator_program()
	if(existing_app && existing_app != comm_app)
		var/original_address = metadata
		var/randomized_address
		for(var/attempt in 1 to 10)
			var/candidate = generate_ntnet_address("round-communicator-[REF(comm)]-[world.time]-[attempt]-[rand(1, 1000000000)]")
			if(!GLOB.active_communicator_apps[candidate])
				randomized_address = candidate
				break
		if(!randomized_address)
			to_chat(H, SPAN_DANGER("Could not assign a free communicator number for this round."))
			return
		metadata = randomized_address
		to_chat(H, SPAN_WARNING("Your saved communicator number [original_address] was already taken. It has been randomized to [metadata] for this round only; your loadout preference was not changed."))

	var/obj/item/computer_hardware/network_card/network_card = comm.network_card
	if(!network_card)
		return

	comm_app?.remove_from_active(network_card.identification_addr)
	network_card.identification_addr = metadata
	comm_app?.add_to_active(metadata)

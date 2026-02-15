GLOBAL_LIST_EMPTY(active_communicators)

/obj/item/modular_computer/handheld/communicator
	name = "communicator"
	desc = "A T-14.2 communicator, popular across the galaxy for it's simplicity to use." // todo: "galaxy"?
	icon = 'icons/obj/devices/communicator.dmi'
	icon_state = "communicator"
	icon_state_unpowered = "communicator-off"
	// todo: icon state variants
	pickup_sound = 'sound/items/pickup/device.ogg'
	drop_sound = 'sound/items/drop/device.ogg'
	hardware_flag = PROGRAM_COMMUNICATOR

/obj/item/modular_computer/handheld/communicator/Initialize()
	. = ..()
	usr = null // temp fix for admin spawning a communicator causing a runtime

	if(network_card?.identification_addr)
		add_to_active(network_card)
		RegisterSignal(network_card, COMSIG_QDELETING, PROC_REF(remove_from_active))

	set_autorun("ntnrc_comm")

	/*
	Calling `enable_computer()` directly in `Initialize()` generates a dreamchecker error because
	`/datum/computer_file/program/chat_client/run_program()` has an `alert()` call,
	potentially causing the whole `Initialize()` thread to freeze.

	That will never actually get called from here, but dreamchecker doesn't know that so
	this works for now to avoid it. (The chat client program will probably get merged into this anyway.)
	*/
	INVOKE_ASYNC(src, PROC_REF(enable_computer), null, TRUE)

	// Just in case the communicator spawned on someone (for example as a loadout item).
	// This waits a couple of seconds for everything to settle then tries to register itself to the holding mob, if there is one.
	addtimer(CALLBACK(src, PROC_REF(register_to_holder)), 2 SECONDS)
	// todo: check that this actually works?

/obj/item/modular_computer/handheld/communicator/Destroy()
	remove_from_active(network_card)
	return ..()

/obj/item/modular_computer/handheld/communicator/proc/add_to_active(obj/item/computer_hardware/network_card/net_card)
	if(net_card?.identification_addr)
		GLOB.active_communicators[net_card.identification_addr] = src

/obj/item/modular_computer/handheld/communicator/proc/remove_from_active(obj/item/computer_hardware/network_card/net_card)
	SIGNAL_HANDLER
	if(net_card?.identification_addr)
		GLOB.active_communicators -= net_card.identification_addr

/obj/item/modular_computer/handheld/communicator/try_install_component(mob/living/user, obj/item/computer_hardware/H, found)
	var/obj/item/computer_hardware/network_card/prev_network_card = network_card
	. = ..()
	if(network_card != prev_network_card)
		add_to_active(network_card)

/obj/item/modular_computer/handheld/communicator/uninstall_component(mob/living/user, obj/item/computer_hardware/H, found, critical, put_in_hands)
	var/obj/item/computer_hardware/network_card/prev_network_card = network_card
	. = ..()
	if(network_card != prev_network_card)
		remove_from_active(prev_network_card)

// Todo: add some way to reset/change registered ID card.
/obj/item/modular_computer/handheld/communicator/attackby(obj/item/attacking_item, mob/user)
	if(!istype(attacking_item, /obj/item/card/id))
		return ..()
	if(registered_id)
		to_chat(user, "something something already registered todo")
		return TRUE

	register_account(null, attacking_item)
	return TRUE

/obj/item/modular_computer/handheld/communicator/proc/register_to_holder()
	var/mob/holder = get_holding_mob()
	if(holder)
		register_account(null, holder.GetIdCard(), TRUE)

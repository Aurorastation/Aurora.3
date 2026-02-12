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
	set_autorun("ntnrc_comm")

	/*
	Calling `enable_computer()` directly in `Initialize()` generates a dreamchecker error because
	`/datum/computer_file/program/chat_client/run_program()` has an `alert()` call,
	potentially causing the whole `Initialize()` thread to freeze.

	That will never actually get called from here, but dreamchecker doesn't know that so
	this works for now to avoid it. (The chat client program will probably get merged into this anyway.)
	*/
	INVOKE_ASYNC(src, PROC_REF(enable_computer), null, TRUE)

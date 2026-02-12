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

	// temp fix to admin spawning a communicator causing a runtime
	usr = null

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
	addtimer(CALLBACK(src, PROC_REF(register_to_holder), null, TRUE), 2 SECONDS)

// this works for now but TODO: some way to re-register to someone else, plus unregistering
/obj/item/modular_computer/handheld/communicator/attack_self(mob/user)
	if(!registered_id)
		register_to_holder(user)
		return
	return ..()

/obj/item/modular_computer/handheld/communicator/proc/register_to_holder(mob/holder = null, silent = FALSE)
	holder ||= get_holding_mob()
	if(holder)
		register_account(null, holder.GetIdCard(), silent)

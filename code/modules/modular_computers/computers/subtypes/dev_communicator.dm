/obj/item/modular_computer/handheld/communicator
	name = "communicator"
	desc = "A T-14.2 communicator, popular across the galaxy for it's simplicity to use." // todo: "galaxy"?
	icon = 'icons/obj/modular_computers/communicator.dmi'
	icon_state = "communicator"
	icon_state_unpowered = "communicator"
	// todo: icon state variants
	pickup_sound = 'sound/items/pickup/device.ogg'
	drop_sound = 'sound/items/drop/device.ogg'
	hardware_flag = PROGRAM_COMMUNICATOR

	var/unread_notification = FALSE

	/// How many tiles away can the communicator pick up speech while on a voice call.
	var/mic_range = 3

/obj/item/modular_computer/handheld/communicator/Initialize()
	. = ..()
	usr = null // temp fix for admin spawning a communicator causing a runtime

	set_autorun("ntnrc_comm")

	/*
	Calling `enable_computer()` directly in `Initialize()` generates a dreamchecker error because
	`/datum/computer_file/program/chat_client/run_program()` has an `alert()` call,
	potentially causing the whole `Initialize()` thread to freeze.

	That will never actually get called from here, but dreamchecker doesn't know that so
	this works for now to avoid it. (The chat client program will probably get merged into this anyway.)
	*/
	INVOKE_ASYNC(src, PROC_REF(enable_computer), null, TRUE)

/obj/item/modular_computer/handheld/communicator/register_account(datum/computer_file/program/PRG, obj/item/card/id/id, quiet)
	. = ..()
	if(. && name == initial(name)) // Only rename if there isn't already a custom name set.
		name = "[id.registered_name]'s [initial(name)]"

/obj/item/modular_computer/handheld/communicator/unregister_account(quiet)
	. = ..()
	name = initial(name)

// Todo: add some way to reset/change registered ID card.
/obj/item/modular_computer/handheld/communicator/attackby(obj/item/attacking_item, mob/user)
	if(!istype(attacking_item, /obj/item/card/id))
		return ..()
	if(registered_id)
		to_chat(user, "something something already registered todo")
		return TRUE

	register_account(null, attacking_item)
	return TRUE

/obj/item/modular_computer/handheld/communicator/get_notification(message, message_range, source)
	. = ..()
	unread_notification = TRUE
	update_icon()

/obj/item/modular_computer/handheld/communicator/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	unread_notification = FALSE
	update_icon()

// Called by `/datum/gear/computer/handheld/communicator/spawn_item()`.
/obj/item/modular_computer/handheld/communicator/proc/register_to_mob(mob/M)
	register_account(null, M.GetIdCard(), TRUE)

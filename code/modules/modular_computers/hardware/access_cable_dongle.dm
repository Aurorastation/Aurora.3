/obj/item/computer_hardware/access_cable_dongle
	name = "access cable dongle"
	desc = "A dongle from which a positronic-compatible cable can be extended."
	critical = FALSE
	icon_state = "aislot"
	hardware_size = 3

	/// The access cable currently inserted into this slot.
	var/obj/item/access_cable/access_cable

/obj/item/computer_hardware/access_cable_dongle/Initialize()
	. = ..()
	access_cable = new(src, src, src)

/obj/item/computer_hardware/access_cable_dongle/Destroy()
	if(access_cable)
		access_cable.retract()
	QDEL_NULL(access_cable)
	return ..()

/obj/item/computer_hardware/access_cable_dongle/verb/take_cable()
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

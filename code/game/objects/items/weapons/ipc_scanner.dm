/obj/item/ipc_tag_scanner
	name = "IPC tag scanner"
	desc = "A hand-held IPC tag scanner, that, when used to analyze the info of an IPC, will output its tag status and information."
	icon = 'icons/obj/ipc_utilities.dmi'
	icon_state = "ipc_tag_scanner"
	item_state = "ipc_tag_scanner"
	contained_sprite = TRUE
	flags = CONDUCT
	slot_flags = SLOT_BELT
	throwforce = 3
	w_class = ITEMSIZE_SMALL

	// Wiring
	var/datum/wires/tag_scanner/wires
	var/wires_exposed = FALSE
	var/powered = TRUE
	var/hacked = FALSE

	throw_speed = 5
	throw_range = 10
	origin_tech = list(TECH_MAGNET = 2, TECH_BIO = 1, TECH_ENGINEERING = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 500, MATERIAL_GLASS = 200)

/obj/item/ipc_tag_scanner/Initialize(mapload, ...)
	. = ..()
	wires = new /datum/wires/tag_scanner(src)

/obj/item/ipc_tag_scanner/Destroy()
	QDEL_NULL(wires)
	return ..()

/obj/item/ipc_tag_scanner/attack(mob/living/M, mob/living/user)
	add_fingerprint(user)
	if(!powered)
		to_chat(user, SPAN_WARNING("\The [src] reads, \"Scanning failure, please submit scanner for repairs.\""))
		return
	user.visible_message(SPAN_NOTICE("\The [user] starts analyzing \the [M] with \the [src]..."), SPAN_NOTICE("You start analyzing \the [M] with \the [src]..."))
	if(do_after(user, 50, TRUE, src))
		if(!isipc(M))
			to_chat(user, SPAN_WARNING("You analyze \the [M], but find that they're not an IPC at all!"))
			return
		var/mob/living/carbon/human/IPC = M
		var/obj/item/organ/internal/ipc_tag/tag = IPC.internal_organs_by_name[BP_IPCTAG]
		if(isnull(tag) || !tag)
			to_chat(user, SPAN_WARNING("Error: Serial Identification Missing."))
			return
		to_chat(user, SPAN_NOTICE("[capitalize_first_letters(tag.name)]:"))
		to_chat(user, SPAN_NOTICE("<b>Serial Number:</b> [tag.serial_number]"))
		to_chat(user, SPAN_NOTICE("<b>Ownership Status:</b> [tag.ownership_info]"))
		to_chat(user, SPAN_NOTICE("<b>Citizenship Info:</b> [tag.citizenship_info]"))

/obj/item/ipc_tag_scanner/attackby(obj/item/W, mob/user)
	if(W.isscrewdriver())
		wires_exposed = !wires_exposed
		user.visible_message(SPAN_WARNING("\The [user] [wires_exposed ? "exposes the wiring" : "closes the panel"] on \the [src]."), SPAN_WARNING("You [wires_exposed ? "expose the wiring" : "close the panel"] on \the [src]."), 3)
	else if(W.iswirecutter() || W.ismultitool())
		if(wires_exposed)
			wires.Interact(user)
		else
			to_chat(user, SPAN_WARNING("\The [src]'s wires aren't exposed."))
	else
		..()
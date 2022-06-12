/obj/item/overloader
	name = "overloader"
	desc = "An IPC overloader. This one appears to be blank, with no installed software."
	icon = 'icons/obj/overloader.dmi'
	icon_state = "overloader"
	item_state = "overloader"
	var/runtime = 30

/obj/item/overloader/attack(mob/living/carbon/human/M, mob/user, def_zone)
	if(!istype(M))
		return
	
	var/obj/item/organ/internal/dataport/D = M.internal_organs_by_name[BP_DATAPORT]

	if (D && M.isSynthetic())
		if (length(D.contents))
			to_chat(user, SPAN_WARNING("[M]'s dataport already has something in it!"))
			return

		user.visible_message(SPAN_WARNING("[user] slots \the [src.name] into [M]'s dataport."))
		user.drop_from_inventory(src, D)

/obj/item/overloader/do_overloader_effects(mob/living/carbon/human/M)
	runtime--
	return

/obj/item/overloader/seizure
	name = "seizure overloader"
	desc = "An IPC overloader. This one appears to cause seizures, since it's a placeholder overloader for testing purposes."

/obj/item/overloader/do_overloader_effects(mob/living/carbon/human/M)
	. = ..()

	while (runtime > 1)
	M.seizure()
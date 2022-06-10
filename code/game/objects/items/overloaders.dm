/obj/item/overloader
	name = "overloader"
	desc = "An IPC overloader. This one appears to be blank, with no installed software."
	icon = 'icons/obj/overloader.dmi'
	icon_state = "overloader"
	item_state = "overloader"
	var/expended = FALSE
	var/runtime = 30

/obj/item/overloader/do_overloader_effects(mob/living/carbon/human/M)

	if (!isSynthetic(M))
		return
	
/obj/item/overloader/shutdown
	name = "shutdown overloader"
	desc = "An IPC overloader. This one looks very dangerous."

/obj/item/overloader/shutdown/do_overloader_effects(mob/living/carbon/human/M)
	. = ..()

	
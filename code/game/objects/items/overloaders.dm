/obj/item/overloader
	name = "overloader"
	desc = "An IPC overloader. This one appears to be blank, with no installed software."
	icon = 'icons/obj/overloader.dmi'
	icon_state = "overloader"
	item_state = "overloader"

/obj/item/overloader/attack(mob/living/carbon/human/M, mob/user, def_zone)
	if(!istype(M))
		return
	
	var/obj/item/organ/internal/dataport/dataport

	if (M.internal_organs_by_name[dataport] && M.isSynthetic())
		usr.drop_from_inventory(src, M.internal_organs_by_name[dataport])
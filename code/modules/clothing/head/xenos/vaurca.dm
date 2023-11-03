/obj/item/clothing/head/vaurca_breeder
	name = "zo'ra representative shroud"
	desc = "Large shroud used by Zo'ra representatives."
	icon = 'icons/mob/species/breeder/inventory.dmi'
	item_state = "hive_rep_shroud"
	icon_state = "hive_rep_shroud"
	contained_sprite = FALSE
	species_restricted = list(BODYTYPE_VAURCA_BREEDER)
	sprite_sheets = list(BODYTYPE_VAURCA_BREEDER = 'icons/mob/species/breeder/head.dmi')
	var/raised = FALSE

/obj/item/clothing/head/vaurca_breeder/verb/raise_shroud()
	set name = "Raise Shroud"
	set desc = "Raise your shroud."
	set category = "Object"
	set src in usr

	if(use_check_and_message(usr) || !ishuman(usr))
		return FALSE

	var/mob/living/carbon/human/user = usr

	raised = !raised
	to_chat(user, SPAN_NOTICE("You [raised ? "raise" : "lower"] your shroud."))
	icon_state = "[initial(icon_state)][raised ? "_raised" : ""]"

	user.update_icon()
	user.update_inv_head()

/obj/item/clothing/head/vaurca_breeder/klax
	name = "k'lax represenatitve shroud"
	desc = "Large shroud used by K'lax representatives."
	item_state = "hive_rep_shroud_klax"
	icon_state = "hive_rep_shroud_klax"

/obj/item/clothing/head/vaurca_breeder/cthur
	name = "c'thur representative shroud"
	desc = "Large shroud used by C'thur representatives."
	item_state = "hive_rep_shroud_cthur"
	icon_state = "hive_rep_shroud_cthur"

/obj/item/clothing/head/vaurca_breeder/nralakk
	name = "nralakk representative shroud"
	desc = "Large shroud used by C'thur Nralakk representatives."
	item_state = "hive_rep_shroud_nralakk"
	icon_state = "hive_rep_shroud_nralakk"

/obj/item/clothing/head/vaurca_breeder/biesel
	name = "biesel representative shroud"
	desc = "Large shroud used by Zo'ra Republic of Biesel representatives."
	item_state = "hive_rep_shroud_biesel"
	icon_state = "hive_rep_shroud_biesel"

/obj/item/clothing/head/vaurca_breeder/hegemony
	name = "hegemony representative shroud"
	desc = "Large shroud used by K'lax Izweski Hegemony representatives."
	item_state = "hive_rep_shroud_hegemony"
	icon_state = "hive_rep_shroud_hegemony"

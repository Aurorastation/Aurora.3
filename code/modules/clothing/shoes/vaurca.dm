/obj/item/clothing/shoes/vaurca
	name = "vaurca shoes"
	desc = "A standard pattern of Vaurcaesian footwear, these shoes are tight, yet comfortable enough to allow space for claws. These are equipped with heels, both for higher vantage, and to allow sleeping while standing."
	icon = 'icons/obj/vaurca_items.dmi'
	icon_state = "vaurca_shoes"
	item_state = "vaurca_shoes"
	armor = list(
			melee = ARMOR_MELEE_MINOR
			)
	body_parts_covered = FEET
	species_restricted = list(BODYTYPE_VAURCA)
	contained_sprite = TRUE

/obj/item/clothing/shoes/vaurca/breeder
	name = "zo'ra representative shoes"
	desc = "Large shoes used by Zo'ra representatives."
	icon = 'icons/mob/species/breeder/inventory.dmi'
	item_state = "typec_shoes"
	icon_state = "typec_shoes"
	contained_sprite = FALSE
	species_restricted = list(BODYTYPE_VAURCA_BREEDER)
	sprite_sheets = list(BODYTYPE_VAURCA_BREEDER = 'icons/mob/species/breeder/shoes.dmi')
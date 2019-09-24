/obj/item/clothing/shoes/vaurca
	name = "vaurca shoes"
	desc = "A standard pattern of Vaurcaesian footwear, these shoes are tight, yet comfortable enough to allow space for claws. These are equipped with heels, both for higher vantage, and to allow sleeping while standing."
	icon = 'icons/obj/vaurca_items.dmi'
	icon_state = "vaurca_shoes"
	item_state = "vaurca_shoes"
	armor = list(melee = 10, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
	body_parts_covered = FEET
	species_restricted = list("Vaurca")
	contained_sprite = TRUE

/obj/item/clothing/shoes/vaurca/breeder
	name = "zo'ra representative shoes"
	desc = "Large shoes used by Zo'ra representatives."
	icon = 'icons/mob/species/breeder/inventory.dmi'
	item_state = "typec_shoes"
	icon_state = "typec_shoes"
	contained_sprite = FALSE
	species_restricted = list("Vaurca Breeder")
	sprite_sheets = list("Vaurca Breeder" = 'icons/mob/species/breeder/shoes.dmi')
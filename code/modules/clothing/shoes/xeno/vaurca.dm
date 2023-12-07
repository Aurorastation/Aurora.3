/obj/item/clothing/shoes/vaurca
	name = "vaurca shoes"
	desc = "A standard pattern of Vaurcaesian footwear, these shoes are tight, yet comfortable enough to allow space for claws. These are equipped with heels, both for higher vantage, and to allow sleeping while standing."
	icon = 'icons/obj/vaurca_items.dmi'
	icon_state = "vaurca_shoes"
	item_state = "vaurca_shoes"
	worn_overlay = "over"
	build_from_parts = TRUE

	armor = list(
		melee = ARMOR_MELEE_MINOR
		)

	sprite_sheets = list(
		BODYTYPE_VAURCA_BULWARK = 'icons/mob/species/bulwark/shoes.dmi' //depreceated, only used for bulwarks due to their size
	)


	body_parts_covered = FEET
	species_restricted = list(BODYTYPE_VAURCA, BODYTYPE_VAURCA_BULWARK)
	contained_sprite = TRUE

/obj/item/clothing/shoes/vaurca/breeder
	name = "zo'ra representative shoes"
	desc = "Large shoes used by Zo'ra representatives."
	icon = 'icons/mob/species/breeder/inventory.dmi'
	item_state = "hive_rep_shoes"
	icon_state = "hive_rep_shoes"
	contained_sprite = FALSE
	species_restricted = list(BODYTYPE_VAURCA_BREEDER)
	sprite_sheets = list(BODYTYPE_VAURCA_BREEDER = 'icons/mob/species/breeder/shoes.dmi')
	worn_overlay = null
	build_from_parts = FALSE

/obj/item/clothing/shoes/vaurca/breeder/klax
	name = "k'lax representative shoes"
	desc = "Large shoes used by K'lax representatives."
	item_state = "hive_rep_shoes_klax"
	icon_state = "hive_rep_shoes_klax"

/obj/item/clothing/shoes/vaurca/breeder/cthur
	name = "c'thur representative shoes"
	desc = "Large shoes used by C'thur representatives."
	item_state = "hive_rep_shoes_cthur"
	icon_state = "hive_rep_shoes_cthur"

/obj/item/clothing/shoes/vaurca/breeder/nralakk
	name = "nralakk representative shoes"
	desc = "Large shoes used by Nralakk representatives."
	item_state = "hive_rep_shoes_nralakk"
	icon_state = "hive_rep_shoes_nralakk"

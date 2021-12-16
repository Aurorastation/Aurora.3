/obj/item/clothing/suit/vaurca
	name = "hive cloak"
	desc = "A fashionable robe tailored for nonhuman proportions, this one is red and golden."
	icon = 'icons/obj/vaurca_items.dmi'
	icon_state = "robegold"
	item_state = "robegold"
	contained_sprite = TRUE
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS

/obj/item/clothing/suit/vaurca/silver
	desc = "A fashionable robe tailored for nonhuman proportions, this one is red and silver."
	icon_state = "robesilver"
	item_state = "robesilver"

/obj/item/clothing/suit/vaurca/brown
	desc = "A fashionable robe tailored for nonhuman proportions, this one is brown and silver."
	icon_state = "robebrown"
	item_state = "robebrown"

/obj/item/clothing/suit/vaurca/blue
	desc = "A fashionable robe tailored for nonhuman proportions, this one is blue and golden."
	icon_state = "robeblue"
	item_state = "robeblue"

/obj/item/clothing/suit/vaurca/shaper
	name = "shaper robes"
	desc = "Commonly worn by Preimmients, these robes are meant to catch pheromones, obfuscating hive affiliation."
	icon_state = "shaper_robes"
	item_state = "shaper_robes"
	sprite_sheets = list(
		BODYTYPE_VAURCA_BULWARK = 'icons/mob/species/bulwark/suit.dmi'
	)
	species_restricted = list(BODYTYPE_VAURCA, BODYTYPE_VAURCA_BULWARK)

/obj/item/clothing/suit/vaurca/breeder
	name = "zo'ra representative clothes"
	desc = "A large piece of clothing used by Zo'ra representatives."
	icon = 'icons/mob/species/breeder/inventory.dmi'
	item_state = "representative_clothes"
	icon_state = "representative_clothes"
	contained_sprite = FALSE
	species_restricted = list(BODYTYPE_VAURCA_BREEDER)
	sprite_sheets = list(BODYTYPE_VAURCA_BREEDER = 'icons/mob/species/breeder/suit.dmi')

/obj/item/clothing/suit/vaurca/breeder_klax
	name = "k'lax representative clothes"
	desc = "A large piece of clothing used by K'lax representatives."
	icon = 'icons/mob/species/breeder/inventory.dmi'
	item_state = "representative_clothes_klax"
	icon_state = "representative_clothes_klax"
	contained_sprite = FALSE
	species_restricted = list(BODYTYPE_VAURCA_BREEDER)
	sprite_sheets = list(BODYTYPE_VAURCA_BREEDER = 'icons/mob/species/breeder/suit.dmi')

/obj/item/clothing/suit/vaurca/breeder_cthur
	name = "c'thur representative clothes"
	desc = "A large piece of clothing used by C'thur representatives."
	icon = 'icons/mob/species/breeder/inventory.dmi'
	item_state = "representative_clothes_cthur"
	icon_state = "representative_clothes_cthur"
	contained_sprite = FALSE
	species_restricted = list(BODYTYPE_VAURCA_BREEDER)
	sprite_sheets = list(BODYTYPE_VAURCA_BREEDER = 'icons/mob/species/breeder/suit.dmi')
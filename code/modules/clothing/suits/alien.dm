//Unathi clothing.

/obj/item/clothing/suit/unathi/robe
	name = "roughspun robes"
	desc = "A traditional Unathi garment."
	icon = 'icons/obj/unathi_items.dmi'
	icon_state = "roughspun_robe"
	item_state = "roughspun_robe"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS
	contained_sprite = TRUE

/obj/item/clothing/suit/unathi/robe/beige
	color = "#DBC684"

/obj/item/clothing/suit/unathi/robe/kilt
	name = "wasteland kilt"
	desc = "A long tunic made of old material that acts as a kilt for the poorest of Unathi, who aren't afraid to let the sand and sun strike their scales."
	icon_state = "wasteland_kilt"
	item_state = "wasteland_kilt"

/obj/item/clothing/suit/unathi/robe/robe_coat //I was at a loss for names under-the-hood.
	name = "tzirzi robes"
	desc = "A casual garment native to Moghes typically worn by Unathi."
	icon = 'icons/obj/unathi_items.dmi'
	icon_state = "robe_coat"
	item_state = "robe_coat"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS
	contained_sprite = 1

//Vaurca clothing

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
	species_restricted = list(BODYTYPE_VAURCA)

/obj/item/clothing/suit/vaurca/mantle
	name = "vaurcan mantle"
	desc = "This mantle is commonly worn in dusty underground areas, its wide upper covering acting as a kind of dust umbrella."
	icon_state = "vacmantle"
	item_state = "vacmantle"
	body_parts_covered = UPPER_TORSO

/obj/item/clothing/suit/vaurca/breeder
	name = "zo'ra representative clothes"
	desc = "A large piece of clothing used by Zo'ra representatives."
	icon = 'icons/mob/species/breeder/inventory.dmi'
	item_state = "representative_clothes"
	icon_state = "representative_clothes"
	contained_sprite = FALSE
	species_restricted = list(BODYTYPE_VAURCA_BREEDER)
	sprite_sheets = list(BODYTYPE_VAURCA_BREEDER = 'icons/mob/species/breeder/suit.dmi')
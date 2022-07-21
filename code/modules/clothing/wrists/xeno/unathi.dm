/obj/item/clothing/wrists/unathi
	name = "unathi wristwear"
	desc = "The default wrists."
	icon = 'icons/obj/unathi_items.dmi'
	contained_sprite = TRUE

/obj/item/clothing/wrists/unathi/jeweled
	name = "jeweled bracers"
	desc = "A pair of flashy bracers for a stylish Sinta, whether a noble or a noble's envoy."
	icon_state = "bracers"
	item_state = "bracers"
	gender = PLURAL
	build_from_parts = TRUE
	worn_overlay = "trim"

/obj/item/clothing/wrists/unathi/maxtlatl
	name = "Th'akhist wristguards"
	desc = "A traditional garment worn by Th'akh shamans. Popular adornments include dried and pressed grass and \
	feathers, as well as precious metals and colorful stones in the cuff itself."
	desc_fluff = "Wristguards as a part of the maxtatl did not become prevalent until much later in Th'akh \
	tradition. As time passed and garb was passed down from shaman to shaman, attire became cluttered with \
	adornments. Bracers were designed as a method of adding more charms to remember previous shamans that \
	predate the latest to pass away."
	icon_state = "maxtlatl-wrists"
	item_state = "maxtlatl-wrists"
	species_restricted = list(BODYTYPE_UNATHI)
	contained_sprite = TRUE
	gender = PLURAL

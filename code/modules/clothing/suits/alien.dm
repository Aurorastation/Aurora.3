//Unathi clothing.

/obj/item/clothing/suit/unathi/robe
	name = "roughspun robes"
	desc = "A traditional Unathi garment."
	icon_state = "robe-unathi"
	item_state = "robe-unathi"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS

/obj/item/clothing/suit/unathi/robe/robe_coat //I was at a loss for names under-the-hood.
	name = "tzirzi robes"
	desc = "A casual Moghes-native garment typically worn by Unathi while planet-side."
	icon = 'icons/obj/unathi_items.dmi'
	icon_state = "robe_coat"
	item_state = "robe_coat"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS
	contained_sprite = 1

/obj/item/clothing/suit/unathi/mantle
	name = "hide mantle"
	desc = "A rather grisly selection of cured hides and skin, sewn together to form a ragged mantle."
	icon_state = "mantle-unathi"
	item_state = "mantle-unathi"
	body_parts_covered = UPPER_TORSO

//Taj clothing.

/obj/item/clothing/suit/tajaran/furs
	name = "heavy furs"
	desc = "A traditional Zhan-Khazan garment."
	icon_state = "zhan_furs"
	item_state = "zhan_furs"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS

/obj/item/clothing/head/tajaran/scarf
	name = "headscarf"
	desc = "A scarf of coarse fabric. Seems to have ear-holes."
	icon_state = "zhan_scarf"
	body_parts_covered = HEAD|FACE

/obj/item/clothing/suit/storage/tajaran
	name = "tajaran naval coat"
	desc = "A thick wool coat from Adhomai."
	icon_state = "naval_coat"
	item_state = "naval_coat"

/obj/item/clothing/suit/storage/toggle/labcoat/tajaran
	name = "people's republic medical coat"
	desc = "A sterile insulated coat made of leather stitched over fur."
	icon_state = "taj_jacket"
	item_state = "taj_jacket"
	icon_open = "taj_jacket_open"
	icon_closed = "taj_jacket"

/obj/item/clothing/suit/storage/tajaran/cloak
	name = "commoner cloak"
	desc = "A tajaran cloak made with the middle class in mind, fancy but nothing special."
	icon = 'icons/obj/tajara_items.dmi'
	icon_state = "taj_commoncloak"
	item_state = "taj_commoncloak"
	contained_sprite = TRUE
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS

/obj/item/clothing/suit/storage/tajaran/cloak/fancy
	name = "royal cloak"
	desc = "A cloak fashioned from the best materials, meant for tajara of high standing."
	icon_state = "taj_fancycloak"
	item_state = "taj_fancycloak"

/obj/item/clothing/suit/storage/hooded/tajaran
	name = "gruff cloak"
	desc = "A cloak designated for the lowest classes."
	icon = 'icons/obj/tajara_items.dmi'
	icon_state = "taj_cloak"
	item_state = "taj_cloak"
	contained_sprite = TRUE
	flags_inv = HIDETAIL
	hoodtype = /obj/item/clothing/head/winterhood

/obj/item/clothing/head/tajaran/circlet
	name = "golden dress circlet"
	desc = "A golden circlet with a pearl in the middle of it."
	icon = 'icons/obj/tajara_items.dmi'
	icon_state = "taj_circlet"
	item_state = "taj_circlet"
	contained_sprite = TRUE
	body_parts_covered = 0

/obj/item/clothing/head/tajaran/circlet/silver
	name = "silver dress circlet"
	desc = "A silver circlet with a pearl in the middle of it."
	icon_state = "taj_circlet_s"
	item_state = "taj_circlet_s"

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
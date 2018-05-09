/*
 * Contains:
 *		Lasertag
 *		Costume
 *		Misc
 */

/*
 * Lasertag
 */
/obj/item/clothing/suit/bluetag
	name = "blue laser tag armour"
	desc = "Blue Pride, Station Wide."
	icon_state = "bluetag"
	item_state = "bluetag"
	blood_overlay_type = "armor"
	body_parts_covered = UPPER_TORSO
	allowed = list (/obj/item/weapon/gun/energy/lasertag/blue)
	siemens_coefficient = 3.0

/obj/item/clothing/suit/redtag
	name = "red laser tag armour"
	desc = "Reputed to go faster."
	icon_state = "redtag"
	item_state = "redtag"
	blood_overlay_type = "armor"
	body_parts_covered = UPPER_TORSO
	allowed = list (/obj/item/weapon/gun/energy/lasertag/red)
	siemens_coefficient = 3.0

/*
 * Costume
 */
/obj/item/clothing/suit/pirate
	name = "pirate coat"
	desc = "Yarr."
	icon_state = "pirate"
	item_state = "pirate"
	body_parts_covered = UPPER_TORSO|ARMS


/obj/item/clothing/suit/hgpirate
	name = "pirate captain coat"
	desc = "Yarr."
	icon_state = "hgpirate"
	item_state = "hgpirate"
	flags_inv = HIDEJUMPSUIT
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS


/obj/item/clothing/suit/cyborg_suit
	name = "cyborg suit"
	desc = "Suit for a cyborg costume."
	icon_state = "death"
	item_state = "death"
	flags = CONDUCT
	fire_resist = T0C+5200
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT


/obj/item/clothing/suit/greatcoat
	name = "great coat"
	desc = "A heavy great coat"
	icon_state = "nazi"
	item_state = "nazi"


/obj/item/clothing/suit/johnny_coat
	name = "johnny~~ coat"
	desc = "Johnny~~"
	icon_state = "johnny"
	item_state = "johnny"


/obj/item/clothing/suit/justice
	name = "justice suit"
	desc = "This pretty much looks ridiculous."
	icon_state = "justice"
	item_state = "justice"
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|HANDS|LEGS|FEET

/obj/item/clothing/suit/judgerobe
	name = "judge's robe"
	desc = "This robe commands authority."
	icon_state = "judge"
	item_state = "judge"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	allowed = list(/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/spacecash)
	flags_inv = HIDEJUMPSUIT

/obj/item/clothing/suit/wcoat
	name = "waistcoat"
	desc = "For some classy, murderous fun."
	icon_state = "vest"
	item_state = "wcoat"
	blood_overlay_type = "armor"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/suit/syndicatefake
	name = "red space suit replica"
	icon_state = "syndicate"
	item_state = "space_suit_syndicate"
	desc = "A plastic replica of the syndicate space suit, you'll look just like a real murderous syndicate agent in this! This is a toy, it is not made for use in space!"
	w_class = 3
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/emergency_oxygen,/obj/item/toy)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|HANDS|LEGS|FEET

/obj/item/clothing/suit/hastur
	name = "hastur's robes"
	desc = "Robes not meant to be worn by man"
	icon_state = "hastur"
	item_state = "hastur"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT


/obj/item/clothing/suit/imperium_monk
	name = "imperium monk"
	desc = "Have YOU killed a xenos today?"
	icon_state = "imperium_monk"
	item_state = "imperium_monk"
	body_parts_covered = HEAD|UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS
	flags_inv = HIDESHOES|HIDEJUMPSUIT


/obj/item/clothing/suit/chickensuit
	name = "chicken suit"
	desc = "A suit made long ago by the ancient empire KFC."
	icon_state = "chickensuit"
	item_state = "chickensuit"
	body_parts_covered = UPPER_TORSO|ARMS|LOWER_TORSO|LEGS|FEET
	flags_inv = HIDESHOES|HIDEJUMPSUIT
	siemens_coefficient = 2.0


/obj/item/clothing/suit/monkeysuit
	name = "monkey suit"
	desc = "A suit that looks like a primate"
	icon_state = "monkeysuit"
	item_state = "monkeysuit"
	body_parts_covered = UPPER_TORSO|ARMS|LOWER_TORSO|LEGS|FEET|HANDS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	siemens_coefficient = 2.0


/obj/item/clothing/suit/holidaypriest
	name = "holiday priest"
	desc = "This is a nice holiday my son."
	icon_state = "holidaypriest"
	item_state = "holidaypriest"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	flags_inv = HIDEJUMPSUIT


/obj/item/clothing/suit/cardborg
	name = "cardborg suit"
	desc = "An ordinary cardboard box with holes cut in the sides."
	icon_state = "cardborg"
	item_state = "cardborg"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	flags_inv = HIDEJUMPSUIT

/*
 * Misc
 */

/obj/item/clothing/suit/straight_jacket
	name = "straitjacket"
	desc = "A suit that completely restrains the wearer."
	icon_state = "straight_jacket"
	item_state = "straight_jacket"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|HANDS
	flags_inv = HIDEGLOVES|HIDEJUMPSUIT

/obj/item/clothing/suit/straight_jacket/equipped(var/mob/user, var/slot)
	if (slot == slot_wear_suit)
		if(ishuman(loc))
			var/mob/living/carbon/human/H = loc
			H.drop_r_hand()
			H.drop_l_hand()
			H.drop_from_inventory(H.handcuffed)
	..()

/obj/item/clothing/suit/ianshirt
	name = "worn shirt"
	desc = "A worn out, curiously comfortable t-shirt with a picture of Ian. You wouldn't go so far as to say it feels like being hugged when you wear it but it's pretty close. Good for sleeping in."
	icon_state = "ianshirt"
	item_state = "ianshirt"
	body_parts_covered = UPPER_TORSO|ARMS

//coats

/obj/item/clothing/suit/leathercoat
	name = "leather coat"
	desc = "A long, thick black leather coat."
	icon_state = "leathercoat_alt"
	item_state = "leathercoat_alt"
	body_parts_covered = UPPER_TORSO|ARMS
	min_cold_protection_temperature = T0C - 20
	siemens_coefficient = 0.7

/obj/item/clothing/suit/browncoat
	name = "brown leather coat"
	desc = "A long, brown leather coat."
	icon_state = "browncoat"
	item_state = "browncoat"

/obj/item/clothing/suit/neocoat
	name = "black coat"
	desc = "A flowing, black coat."
	icon_state = "neocoat"
	item_state = "neocoat"

/obj/item/clothing/suit/xenos
	name = "xenos suit"
	desc = "A suit made out of chitinous alien hide."
	icon_state = "xenos"
	item_state = "xenos_helm"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	siemens_coefficient = 2.0

/obj/item/clothing/suit/poncho
	name = "poncho"
	desc = "A simple, comfortable poncho."
	icon_state = "classicponcho"
	item_state = "classicponcho"

/obj/item/clothing/suit/poncho/green
	name = "green poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is green."
	icon_state = "greenponcho"
	item_state = "greenponcho"

/obj/item/clothing/suit/poncho/red
	name = "red poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is red."
	icon_state = "redponcho"
	item_state = "redponcho"

/obj/item/clothing/suit/poncho/purple
	name = "purple poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is purple."
	icon_state = "purpleponcho"
	item_state = "purpleponcho"

/obj/item/clothing/suit/poncho/blue
	name = "blue poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is blue."
	icon_state = "blueponcho"
	item_state = "blueponcho"

/obj/item/clothing/suit/storage/toggle/bomber
	name = "bomber jacket"
	desc = "A thick, well-worn WW2 leather bomber jacket."
	icon_state = "bomber"
	item_state = "bomber"
	icon_open = "bomber_open"
	icon_closed = "bomber"
	body_parts_covered = UPPER_TORSO|ARMS
	cold_protection = UPPER_TORSO|ARMS
	min_cold_protection_temperature = T0C - 20
	siemens_coefficient = 0.7

/obj/item/clothing/suit/storage/leather_jacket
	name = "leather jacket"
	desc = "A black leather coat."
	icon_state = "leather_jacket"
	item_state = "leather_jacket"
	body_parts_covered = UPPER_TORSO|ARMS

/obj/item/clothing/suit/storage/leather_jacket/nanotrasen
	desc = "A black leather coat. A corporate logo is proudly displayed on the back."
	icon_state = "leather_jacket_nt"

/obj/item/clothing/suit/storage/toggle/leather_vest
	name = "leather vest"
	desc = "A black leather vest."
	icon_state = "leather_jacket_sleeveless"
	item_state = "leather_jacket_sleeveless"
	icon_open = "leather_jacket_sleeveless_open"
	icon_closed = "leather_jacket_sleeveless"
	body_parts_covered = UPPER_TORSO

//This one has buttons for some reason
/obj/item/clothing/suit/storage/toggle/brown_jacket
	name = "leather jacket"
	desc = "A brown leather coat."
	icon_state = "brown_jacket"
	item_state = "brown_jacket"
	icon_open = "brown_jacket_open"
	icon_closed = "brown_jacket"
	body_parts_covered = UPPER_TORSO|ARMS

/obj/item/clothing/suit/storage/toggle/brown_jacket/sleeveless
	name = "brown vest"
	desc = "A brown leather vest."
	icon_state = "brown_jacket_sleeveless"
	item_state = "brown_jacket_sleeveless"
	icon_open = "brown_jacket_sleeveless_open"
	icon_closed = "brown_jacket_sleeveless"
	body_parts_covered = UPPER_TORSO

/obj/item/clothing/suit/storage/toggle/brown_jacket/nanotrasen
	desc = "A brown leather coat. A corporate logo is proudly displayed on the back."
	icon_state = "brown_jacket_nt"
	icon_open = "brown_jacket_nt_open"
	icon_closed = "brown_jacket_nt"

/obj/item/clothing/suit/storage/toggle/hoodie
	name = "grey hoodie"
	desc = "A warm, grey sweatshirt."
	icon_state = "grey_hoodie"
	item_state = "grey_hoodie"
	icon_open = "grey_hoodie_open"
	icon_closed = "grey_hoodie"
	min_cold_protection_temperature = T0C - 20
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS

/obj/item/clothing/suit/storage/toggle/hoodie/black
	name = "black hoodie"
	desc = "A warm, black sweatshirt."
	icon_state = "black_hoodie"
	item_state = "black_hoodie"
	icon_open = "black_hoodie_open"
	icon_closed = "black_hoodie"

/obj/item/clothing/suit/storage/toggle/tracksuit
	name = "track jacket"
	desc = "An athletic black and white track jacket."
	icon = 'icons/obj/tracksuit.dmi'
	icon_state = "trackjacket"
	item_state = "trackjacket"
	icon_open = "trackjacket_open"
	icon_closed = "trackjacket"
	contained_sprite = 1

/obj/item/clothing/suit/storage/toggle/flannel
	name = "green flannel shirt"
	desc = "A flannel shirt, for all your space hipster needs."
	icon_state = "flannel_green"
	item_state = "flannel_green"
	icon_open = "flannel_green_open"
	icon_closed = "flannel_green"
	body_parts_covered = UPPER_TORSO|ARMS

/obj/item/clothing/suit/storage/toggle/flannel/red
	name = "red flannel shirt"
	icon_state = "flannel_red"
	item_state = "flannel_red"
	icon_open = "flannel_red_open"
	icon_closed = "flannel_red"

/obj/item/clothing/suit/storage/toggle/flannel/blue
	name = "blue flannel shirt"
	icon_state = "flannel_blue"
	item_state = "flannel_blue"
	icon_open = "flannel_blue_open"
	icon_closed = "flannel_blue"

/obj/item/clothing/suit/storage/toggle/flannel/gray
	name = "grey flannel shirt"
	icon_state = "flannel_gray"
	item_state = "flannel_gray"
	icon_open = "flannel_gray_open"
	icon_closed = "flannel_gray"

/obj/item/clothing/suit/storage/toggle/flannel/purple
	name = "purple flannel shirt"
	icon_state = "flannel_purple"
	item_state = "flannel_purple"
	icon_open = "flannel_purple_open"
	icon_closed = "flannel_purple"

/obj/item/clothing/suit/storage/toggle/flannel/yellow
	name = "yellow flannel shirt"
	icon_state = "flannel_yellow"
	item_state = "flannel_yellow"
	icon_open = "flannel_yellow_open"
	icon_closed = "flannel_yellow"

/obj/item/clothing/suit/storage/toggle/trench
	name = "brown trenchcoat"
	desc = "A rugged canvas trenchcoat."
	icon_state = "trench"
	item_state = "trench"
	icon_open = "trench_open"
	icon_closed = "trench"
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|ARMS

/obj/item/clothing/suit/storage/toggle/trench/grey
	name = "grey trenchcoat"
	icon_state = "trench2"
	item_state = "trench2"
	icon_open = "trench2_open"
	icon_closed = "trench2"
	blood_overlay_type = "coat"
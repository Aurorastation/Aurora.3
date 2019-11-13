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
	allowed = list (/obj/item/gun/energy/lasertag/blue)
	siemens_coefficient = 1.0

/obj/item/clothing/suit/redtag
	name = "red laser tag armour"
	desc = "Reputed to go faster."
	icon_state = "redtag"
	item_state = "redtag"
	blood_overlay_type = "armor"
	body_parts_covered = UPPER_TORSO
	allowed = list (/obj/item/gun/energy/lasertag/red)
	siemens_coefficient = 1.0

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
	allowed = list(/obj/item/storage/fancy/cigarettes,/obj/item/spacecash)
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
	allowed = list(/obj/item/device/flashlight,/obj/item/tank/emergency_oxygen,/obj/item/toy)
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
	siemens_coefficient = 1.5


/obj/item/clothing/suit/monkeysuit
	name = "monkey suit"
	desc = "A suit that looks like a primate"
	icon_state = "monkeysuit"
	item_state = "monkeysuit"
	body_parts_covered = UPPER_TORSO|ARMS|LOWER_TORSO|LEGS|FEET|HANDS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	siemens_coefficient = 1.5


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
	siemens_coefficient = 0.75

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
	siemens_coefficient = 1.5

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
	siemens_coefficient = 0.75

/obj/item/clothing/suit/storage/toggle/leather_jacket
	name = "leather jacket"
	desc = "A black leather coat."
	icon_state = "leather_jacket"
	item_state = "leather_jacket"
	icon_open = "leather_jacket_open"
	icon_closed = "leather_jacket"
	body_parts_covered = UPPER_TORSO|ARMS

/obj/item/clothing/suit/storage/toggle/leather_jacket/nanotrasen
	desc = "A black leather coat. A corporate logo is proudly displayed on the back."
	icon_state = "leather_jacket_nt"
	icon_open = "leather_jacket_nt_open"
	icon_closed = "leather_jacket_nt"

/obj/item/clothing/suit/storage/toggle/leather_vest
	name = "leather vest"
	desc = "A black leather vest."
	icon_state = "leather_jacket_sleeveless"
	item_state = "leather_jacket_sleeveless"
	icon_open = "leather_jacket_sleeveless_open"
	icon_closed = "leather_jacket_sleeveless"
	body_parts_covered = UPPER_TORSO

/obj/item/clothing/suit/storage/toggle/leather_jacket/biker
	name = "biker jacket"
	desc = "A thick, black leather jacket with silver zippers and buttons, crafted to evoke the image of rebellious space-biker gangs."
	icon_state = "biker"
	item_state = "biker"
	icon_open = "biker_open"
	icon_closed = "biker"

/obj/item/clothing/suit/storage/toggle/leather_jacket/designer
	name = "designer leather jacket"
	desc = "A sophisticated, stylish leather jacket. It doesn't look cheap."
	icon_state = "designer_jacket"
	item_state = "designer_jacket"
	icon_open = "designer_jacket_open"
	icon_closed = "designer_jacket"

/obj/item/clothing/suit/storage/toggle/leather_jacket/designer/black
	icon_state = "blackdesigner_jacket"
	item_state = "blackdesigner_jacket"
	icon_open = "blackdesigner_jacket_open"
	icon_closed = "blackdesigner_jacket"

/obj/item/clothing/suit/storage/toggle/leather_jacket/designer/red
	icon_state = "reddesigner_jacket"
	item_state = "reddesigner_jacket"
	icon_open = "reddesigner_jacket_open"
	icon_closed = "reddesigner_jacket"

/obj/item/clothing/suit/storage/toggle/leather_jacket/flight
	name = "flight jacket"
	desc = "A modern pilot's jacket made from a silky, shiny nanonylon material. Not to be confused with the vintage stylings of a bomber jacket."
	icon_state = "flight"
	item_state = "flight"
	icon_open = "flight_open"
	icon_closed = "flight"

/obj/item/clothing/suit/storage/toggle/leather_jacket/flight/green
	icon_state = "gflight"
	item_state = "gflight"
	icon_open = "gflight_open"
	icon_closed = "gflight"

/obj/item/clothing/suit/storage/toggle/leather_jacket/flight/white
	icon_state = "wflight"
	item_state = "wflight"
	icon_open = "wflight_open"
	icon_closed = "wflight"

/obj/item/clothing/suit/storage/toggle/leather_jacket/military
	name = "military jacket"
	desc = "A military-styled jacket made from thick, distressed canvas. Popular among Martian punks. Patches not included."
	icon_state = "mgreen"
	item_state = "mgreen"
	icon_open = "mgreen_open"
	icon_closed = "mgreen"
	allowed = list (/obj/item/pen, /obj/item/paper, /obj/item/device/flashlight, /obj/item/tank/emergency_oxygen, /obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask)

/obj/item/clothing/suit/storage/toggle/leather_jacket/military/tan
	icon_state = "mtan"
	item_state = "mtan"
	icon_open = "mtan_open"
	icon_closed = "mtan"

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

/obj/item/clothing/suit/storage/toggle/trench/alt
	name = "brown trenchcoat"
	desc = "A sleek canvas trenchcoat"
	icon_state = "trenchcoat_brown"
	item_state = "trenchcoat_brown"
	icon_open = "trenchcoat_brown_open"
	icon_closed = "trenchcoat_brown"

/obj/item/clothing/suit/storage/toggle/trench/grey_alt
	name = "grey trenchcoat"
	desc = "A sleek canvas trenchcoat"
	icon_state = "trenchcoat_grey"
	item_state = "trenchcoat_grey"
	icon_open = "trenchcoat_grey_open"
	icon_closed = "trenchcoat_grey"

/obj/item/clothing/suit/storage/dominia
	name = "dominia cape"
	desc = "This is a cape in the style of Dominia nobility. It's the latest fashion across Dominian space."
	icon_state = "dominian_cape"
	item_state = "dominian_cape"

/obj/item/clothing/suit/storage/toggle/dominia
	name = "dominia great coat"
	desc = "This is a great coat in the style of Dominia nobility. It's the latest fashion across Dominian space."
	icon_state = "dominian_noble"
	item_state = "dominian_noble"
	icon_open = "dominian_noble_open"
	icon_closed = "dominian_noble"

/obj/item/clothing/suit/storage/toggle/dominia/alt
	icon_state = "dominian_noble2"
	item_state = "dominian_noble2"
	icon_open = "dominian_noble2_open"
	icon_closed = "dominian_noble2"

/obj/item/clothing/suit/storage/toggle/dominia/black
	icon_state = "dominian_noble4"
	item_state = "dominian_noble4"
	icon_open = "dominian_noble4_open"
	icon_closed = "dominian_noble4"

/obj/item/clothing/suit/storage/toggle/dominia/black/alt
	icon_state = "dominian_noble5"
	item_state = "dominian_noble5"
	icon_open = "dominian_noble5_open"
	icon_closed = "dominian_noble5"

/obj/item/clothing/suit/storage/toggle/greengov
	name = "green formal jacket"
	desc = "A sleek proper formal jacket with gold buttons."
	icon_state = "suitjacket_green_open"
	item_state = "suitjacket_green"
	icon_open = "suitjacket_green_open"
	icon_closed = "suitjacket_green"
	body_parts_covered = UPPER_TORSO|ARMS

/obj/item/clothing/suit/storage/toggle/track
	name = "track jacket"
	desc = "a track jacket, for the athletic."
	icon = 'icons/obj/tracksuit.dmi'
	icon_state = "trackjacket"
	item_state = "trackjacket"
	icon_open = "trackjacket_open"
	icon_closed = "trackjacket"
	allowed = list (/obj/item/pen, /obj/item/paper, /obj/item/device/flashlight, /obj/item/tank/emergency_oxygen, /obj/item/storage/fancy/cigarettes, /obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask)
	contained_sprite = 1

/obj/item/clothing/suit/storage/toggle/track/blue
	name = "blue track jacket"
	icon = 'icons/obj/tracksuit.dmi'
	icon_state = "trackjacketblue"
	item_state = "trackjacketblue"
	icon_open = "trackjacketblue_open"
	icon_closed = "trackjacketblue"
	contained_sprite = 1

/obj/item/clothing/suit/storage/toggle/track/green
	name = "green track jacket"
	icon = 'icons/obj/tracksuit.dmi'
	icon_state = "trackjacketgreen"
	item_state = "trackjacketgreen"
	icon_open = "trackjacketgreen_open"
	icon_closed = "trackjacketgreen"
	contained_sprite = 1

/obj/item/clothing/suit/storage/toggle/track/red
	name = "red track jacket"
	icon = 'icons/obj/tracksuit.dmi'
	icon_state = "trackjacketred"
	item_state = "trackjacketred"
	icon_open = "trackjacketred_open"
	icon_closed = "trackjacketred"
	contained_sprite = 1

/obj/item/clothing/suit/storage/toggle/track/white
	name = "white track jacket"
	icon = 'icons/obj/tracksuit.dmi'
	icon_state = "trackjacketwhite"
	item_state = "trackjacketwhite"
	icon_open = "trackjacketwhite_open"
	icon_closed = "trackjacketwhite"
	contained_sprite = 1

/obj/item/clothing/suit/varsity
	name = "black varsity jacket"
	desc = "A favorite of jocks everywhere from Sol to the Frontier."
	icon_state = "varsity"
	item_state = "varsity"
	allowed = list (/obj/item/pen, /obj/item/paper, /obj/item/device/flashlight, /obj/item/tank/emergency_oxygen, /obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask)

/obj/item/clothing/suit/varsity/red
	name = "red varsity jacket"
	icon_state = "varsity_red"
	item_state = "varsity_red"

/obj/item/clothing/suit/varsity/purple
	name = "purple varsity jacket"
	icon_state = "varsity_purple"
	item_state = "varsity_purple"

/obj/item/clothing/suit/varsity/green
	name = "green varsity jacket"
	icon_state = "varsity_green"
	item_state = "varsity_green"

/obj/item/clothing/suit/varsity/blue
	name = "blue varsity jacket"
	icon_state = "varsity_blue"
	item_state = "varsity_blue"

/obj/item/clothing/suit/varsity/brown
	name = "brown varsity jacket"
	icon_state = "varsity_brown"
	item_state = "varsity_brown"

/obj/item/clothing/suit/storage/legion
	name = "tcfl jacket"
	desc = "A pale blue canvas jacket embossed with the insignia of the Tau Ceti Foreign Legion."
	icon_state = "tcfljacket"
	item_state = "tcfljacket"

/obj/item/clothing/suit/jacket/puffer
	name = "puffer jacket"
	desc = "A thick jacket with a rubbery, water-resistant shell. Oddly enough, you don't feel any heat."
	icon_state = "pufferjacket"
	item_state = "pufferjacket"

/obj/item/clothing/suit/jacket/puffer/vest
	name = "puffer vest"
	desc = "A thick vest with a rubbery, water-resistant shell."
	icon_state = "puffervest"
	item_state = "puffervest"

/obj/item/clothing/suit/storage/toggle/peacoat
	name = "peacoat"
	desc = "A well-tailored, stylish peacoat."
	icon_state = "peacoat"
	item_state = "peacoat"
	icon_open = "peacoat_open"
	icon_closed = "peacoat"

/*
 * Department Jackets
 */
/obj/item/clothing/suit/storage/toggle/engi_dep_jacket
	name = "engineering department jacket"
	desc = "A cozy jacket in engineering's colors. Show your department pride!"
	icon_state = "engi_dep_jacket"
	item_state = "engi_dep_jacket"
	icon_open = "engi_dep_jacket_open"
	icon_closed = "engi_dep_jacket"

/obj/item/clothing/suit/storage/toggle/supply_dep_jacket
	name = "supply department jacket"
	desc = "A cozy jacket in supply's colors. Show your department pride!"
	icon_state = "supply_dep_jacket"
	item_state = "supply_dep_jacket"
	icon_open = "supply_dep_jacket_open"
	icon_closed = "supply_dep_jacket"

/obj/item/clothing/suit/storage/toggle/sci_dep_jacket
	name = "science department jacket"
	desc = "A cozy jacket in science's colors. Show your department pride!"
	icon_state = "sci_dep_jacket"
	item_state = "sci_dep_jacket"
	icon_open = "sci_dep_jacket_open"
	icon_closed = "sci_dep_jacket"

/obj/item/clothing/suit/storage/toggle/med_dep_jacket
	name = "medical department jacket"
	desc = "A cozy jacket in medical's colors. Show your department pride!"
	icon_state = "med_dep_jacket"
	item_state = "med_dep_jacket"
	icon_open = "med_dep_jacket_open"
	icon_closed = "med_dep_jacket"

/obj/item/clothing/suit/storage/toggle/sec_dep_jacket
	name = "security department jacket"
	desc = "A cozy jacket in security's colors. Show your department pride!"
	icon_state = "sec_dep_jacket"
	item_state = "sec_dep_jacket"
	icon_open = "sec_dep_jacket_open"
	icon_closed = "sec_dep_jacket"

/obj/item/clothing/suit/cardigan
	name = "cardigan"
	desc = "A cozy, warm knit cardigan. Only slightly worse than a blanket."
	icon_state = "cardigan"
	item_state = "cardigan"

/obj/item/clothing/suit/fake_cultrobes
	name = "occultist robes"
	desc = "A ragged, dusty set of robes. Sets off that moody, mysterious aura."
	icon_state = "cultrobes"
	item_state = "cultrobes"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	flags_inv = HIDEJUMPSUIT

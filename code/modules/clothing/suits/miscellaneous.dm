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

/obj/item/clothing/suit/trinary_robes
    name = "trinary perfection robe"
    desc = "Robes worn by those who serve The Trinary Perfection."
    icon_state = "trinary_robes"
    item_state = "trinary_robes"

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

/obj/item/clothing/suit/storage/leathercoat
	name = "leather coat"
	desc = "A long, thick black leather coat."
	icon_state = "leathercoat_alt"
	item_state = "leathercoat_alt"
	body_parts_covered = UPPER_TORSO|ARMS
	min_cold_protection_temperature = T0C - 20
	siemens_coefficient = 0.75

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

/obj/item/clothing/suit/storage/bomber/alt
	name = "bomber jacket"
	desc = "A thick, well-worn WW2 leather bomber jacket."
	icon_state = "bomberjacket_new"
	item_state_slots = list(slot_r_hand_str = "brown_jacket", slot_l_hand_str = "brown_jacket")
	body_parts_covered = UPPER_TORSO|ARMS
	cold_protection = UPPER_TORSO|ARMS
	min_cold_protection_temperature = T0C - 20
	siemens_coefficient = 0.7

/obj/item/clothing/suit/storage/toggle/bomber/pilot
	name = "pilot jacket"
	desc = "A thick, blue bomber jacket."
	icon_state = "pilot_bomber"
	item_state_slots = list(slot_r_hand_str = "brown_jacket", slot_l_hand_str = "brown_jacket")

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

/obj/item/clothing/suit/storage/toggle/leather_jacket/flight/legion
	name = "tcfl flight jacket"
	desc = "A Tau Ceti Foreign Legion pilot's jacket. This is the more common, less durable variety, which typically finds itself percolating amongst all ranks of the TCFL."
	icon_state = "lflight"
	item_state = "lflight"
	icon_open = "lflight_open"
	icon_closed = "lflight"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)
	siemens_coefficient = 0.75

/obj/item/clothing/suit/storage/toggle/leather_jacket/flight/legion/alt
	desc = "A Tau Ceti Foreign Legion pilot's jacket made from a silky, shiny nanonylon material and lined with tough, protective synthfabrics."
	armor = list(melee = 40, bullet = 10, laser = 20, energy = 10, bomb = 30, bio = 0, rad = 0)
	siemens_coefficient = 0.35

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

/obj/item/clothing/suit/storage/toggle/leather_jacket/military/old
	name = "old military jacket"
	desc = "A canvas jacket styled after classical earth military garb. Feels sturdy, yet comfortable."
	icon_state = "mold"
	item_state = "mold"

/obj/item/clothing/suit/storage/toggle/leather_jacket/military/old/alt
	icon_state = "mold_alt"
	item_state = "mold_alt"

/obj/item/clothing/suit/storage/toggle/leather_jacket/military/old/green
	icon_state = "militaryjacket_green"
	item_state = "militaryjacket_green"

/obj/item/clothing/suit/storage/toggle/leather_jacket/military/old/tan
	icon_state = "militaryjacket_tan"
	item_state = "militaryjacket_tan"

/obj/item/clothing/suit/storage/toggle/leather_jacket/military/old/white
	icon_state = "militaryjacket_white"
	item_state = "militaryjacket_white"

/obj/item/clothing/suit/storage/toggle/leather_jacket/military/old/navy
	icon_state = "militaryjacket_navy"
	item_state = "militaryjacket_navy"

/obj/item/clothing/suit/storage/toggle/leather_jacket/military/old/grey
	icon_state = "militaryjacket_grey"
	item_state = "militaryjacket_grey"

/obj/item/clothing/suit/storage/toggle/leather_jacket/military/old/black
	icon_state = "militaryjacket_black"
	item_state = "militaryjacket_black"

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

//Flannels

/obj/item/clothing/suit/storage/flannel
	name = "Flannel shirt"
	desc = "A comfy, black flannel shirt.  Unleash your inner hipster."
	icon_state = "flannel"
	item_state_slots = list(slot_r_hand_str = "black_labcoat", slot_l_hand_str = "black_labcoat")
	allowed = list (/obj/item/pen, /obj/item/paper, /obj/item/device/flashlight,/obj/item/tank/emergency_oxygen, /obj/item/storage/fancy/cigarettes, /obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask)
	var/rolled = 0
	var/tucked = 0
	var/buttoned = 0

/obj/item/clothing/suit/storage/flannel/verb/roll_sleeves()
	set name = "Roll Sleeves"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living))
		return
	if(usr.stat)
		return

	if(rolled == 0)
		rolled = 1
		body_parts_covered &= ~(ARMS)
		to_chat(usr, "<span class='notice'>You roll up the sleeves of your [src].</span>")
	else
		rolled = 0
		body_parts_covered = initial(body_parts_covered)
		to_chat(usr, "<span class='notice'>You roll down the sleeves of your [src].</span>")
	update_icon()

/obj/item/clothing/suit/storage/flannel/verb/tuck()
	set name = "Toggle Shirt Tucking"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)||usr.stat)
		return

	if(tucked == 0)
		tucked = 1
		to_chat(usr, "<span class='notice'>You tuck in your your [src].</span>")
	else
		tucked = 0
		to_chat(usr, "<span class='notice'>You untuck your [src].</span>")
	update_icon()

/obj/item/clothing/suit/storage/flannel/verb/button()
	set name = "Toggle Shirt Buttons"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)||usr.stat)
		return

	if(buttoned == 0)
		buttoned = 1
		to_chat(usr, "<span class='notice'>You button your [src].</span>")
	else
		buttoned = 0
		to_chat(usr, "<span class='notice'>You unbutton your [src].</span>")
	update_icon()

/obj/item/clothing/suit/storage/flannel/update_icon()
	icon_state = initial(icon_state)
	if(rolled)
		icon_state += "r"
	if(tucked)
		icon_state += "t"
	if(buttoned)
		icon_state += "b"
	update_clothing_icon()

/obj/item/clothing/suit/storage/flannel/red
	desc = "A comfy, red flannel shirt.  Unleash your inner hipster."
	icon_state = "flannel_red"
	item_state_slots = list(slot_r_hand_str = "red_labcoat", slot_l_hand_str = "red_labcoat")

/obj/item/clothing/suit/storage/flannel/aqua
	desc = "A comfy, aqua flannel shirt.  Unleash your inner hipster."
	icon_state = "flannel_aqua"
	item_state_slots = list(slot_r_hand_str = "blue_labcoat", slot_l_hand_str = "blue_labcoat")

/obj/item/clothing/suit/storage/flannel/brown
	desc = "A comfy, brown flannel shirt.  Unleash your inner hipster."
	icon_state = "flannel_brown"
	item_state_slots = list(slot_r_hand_str = "johnny", slot_l_hand_str = "johnny")

/obj/item/clothing/suit/storage/flannel/yellow
	desc = "A comfy, yellow flannel shirt. Unlesh your inner hipster."
	icon_state = "flannel_yellow"
	item_state = "flannel_yellow"

/obj/item/clothing/suit/storage/flannel/purple
	desc = "A comfy, purple flannel shirt. Unleash your inner hipster."
	icon_state = "flannel_purple"
	item_state = "flannel_purple"

/obj/item/clothing/suit/storage/flannel/grey
	desc = "A comfy, grey flannel shirt. Unleash your inner hipster."
	icon_state = "flannel_grey"
	item_state = "flannel_grey"

/obj/item/clothing/suit/storage/flannel/blue
	desc = "A comfy, blue flannel shirt. Unlesh your inner hipster."
	icon_state = "flannel_blue"
	item_state = "flannel_blue"

/obj/item/clothing/suit/storage/flannel/green
	desc = "A comfy, green flannel shirt. Unlesh your inner hipster."
	icon_state = "flannel_green"
	item_state = "flannel_green"

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

/obj/item/clothing/suit/storage/toggle/track/black
	name = "black track jacket"
	icon_state = "trackjacketblack"
	item_state = "trackjacketblack"
	icon_open = "trackjacketblack_open"
	icon_closed = "trackjacketblack"

/obj/item/clothing/suit/storage/toggle/varsity
	name = "black varsity jacket"
	desc = "A favorite of jocks everywhere from Sol to the Coalition."
	icon_state = "varsity"
	item_state = "varsity"
	icon_open = "varsity_open"
	icon_closed = "varsity"
	allowed = list (/obj/item/pen, /obj/item/paper, /obj/item/device/flashlight, /obj/item/tank/emergency_oxygen, /obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask)

/obj/item/clothing/suit/storage/toggle/varsity/red
	name = "red varsity jacket"
	icon_state = "varsity_red"
	item_state = "varsity_red"
	icon_open = "varsity_red_open"
	icon_closed = "varsity_red"

/obj/item/clothing/suit/storage/toggle/varsity/purple
	name = "purple varsity jacket"
	icon_state = "varsity_purple"
	item_state = "varsity_purple"
	icon_open = "varsity_purple_open"
	icon_closed = "varsity_purple"

/obj/item/clothing/suit/storage/toggle/varsity/green
	name = "green varsity jacket"
	icon_state = "varsity_green"
	item_state = "varsity_green"
	icon_open = "varsity_green_open"
	icon_closed = "varsity_green"

/obj/item/clothing/suit/storage/toggle/varsity/blue
	name = "blue varsity jacket"
	icon_state = "varsity_blue"
	item_state = "varsity_blue"
	icon_open = "varsity_blue_open"
	icon_closed = "varsity_blue"

/obj/item/clothing/suit/storage/toggle/varsity/brown
	name = "brown varsity jacket"
	icon_state = "varsity_brown"
	item_state = "varsity_brown"
	icon_open = "varsity_brown_open"
	icon_closed = "varsity_brown"

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
	desc = "A cozy jacket in engineering's colors, featuring spacious pockets you won't even use."
	icon_state = "engi_dep_jacket"
	item_state = "engi_dep_jacket"
	icon_open = "engi_dep_jacket_open"
	icon_closed = "engi_dep_jacket"

/obj/item/clothing/suit/storage/toggle/supply_dep_jacket
	name = "supply department jacket"
	desc = "A cozy jacket in supply's colors, perfect for folding up and forgetting bounty lists."
	icon_state = "supply_dep_jacket"
	item_state = "supply_dep_jacket"
	icon_open = "supply_dep_jacket_open"
	icon_closed = "supply_dep_jacket"

/obj/item/clothing/suit/storage/toggle/sci_dep_jacket
	name = "science department jacket"
	desc = "A cozy jacket in science's colors, offering the latest in a complete lack of protection against chemical spills."
	icon_state = "sci_dep_jacket"
	item_state = "sci_dep_jacket"
	icon_open = "sci_dep_jacket_open"
	icon_closed = "sci_dep_jacket"

/obj/item/clothing/suit/storage/toggle/med_dep_jacket
	name = "medical department jacket"
	desc = "A cozy jacket in medical's colors, guaranteed not to leak the latest gossip."
	icon_state = "med_dep_jacket"
	item_state = "med_dep_jacket"
	icon_open = "med_dep_jacket_open"
	icon_closed = "med_dep_jacket"

/obj/item/clothing/suit/storage/toggle/sec_dep_jacket
	name = "security department jacket"
	desc = "A cozy jacket in security's colors, luckily able to be easily cleaned of blood stains"
	icon_state = "sec_dep_jacket"
	item_state = "sec_dep_jacket"
	icon_open = "sec_dep_jacket_open"
	icon_closed = "sec_dep_jacket"

/obj/item/clothing/suit/storage/toggle/serv_dep_jacket
	name = "service department jacket"
	desc = "A cozy jacket in service's colors, reminding many employees that even service has colors."
	icon_state = "serv_dep_jacket"
	item_state = "serv_dep_jacket"
	icon_open = "serv_dep_jacket_open"
	icon_closed = "serv_dep_jacket"

/obj/item/clothing/suit/storage/fib
	name = "\improper FIB agent jacket"
	desc = "A jacket used by Federal Investigations Bureau agents while on the field."
	icon_state = "fib_jacket"
	item_state = "fib_jacket"

/obj/item/clothing/suit/storage/duster
	name = "cowboy duster"
	desc = "A duster commonly seen on cowboys from Earth's late 1800's."
	icon_state = "duster"
	blood_overlay_type = "coat"
	allowed = list(/obj/item/tank/emergency_oxygen, /obj/item/device/flashlight,/obj/item/gun/energy,/obj/item/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/handcuffs,/obj/item/storage/fancy/cigarettes,/obj/item/flame/lighter)

// Cardigans.

/obj/item/clothing/suit/storage/toggle/cardigan
	name = "cardigan"
	desc = "A cozy, warm knit cardigan."
	desc_fluff = "Only slightly worse than a blanket."
	icon_state = "cardigan"
	item_state = "cardigan"
	icon_open = "cardigan_open"
	icon_closed = "cardigan"

/obj/item/clothing/suit/storage/toggle/cardigan/sweater
	name = "sweater cardigan"
	desc = "A cozy, warm knit sweater cardigan."
	desc_fluff = "Half as warm as a sweater, and half as fashionable as a cardigan. Not like it matters for coffee-house dwelling beatniks like yourself."
	icon_state = "cardigansweater"
	item_state = "cardigansweater"
	icon_open = "cardigansweater_open"
	icon_closed = "cardigansweater"

/obj/item/clothing/suit/storage/toggle/cardigan/argyle
	name = "argyle cardigan"
	desc = "A cozy, warm knit argyle cardigan."
	desc_fluff = "You'll never get dumped if you never get in a relationship in the first place. With this, you'll never have to worry again."
	icon_state = "cardiganargyle"
	item_state = "cardiganargyle"
	icon_open = "cardiganargyle_open"
	icon_closed = "cardiganargyle"

/obj/item/clothing/suit/storage/toggle/cardigan/croptop
	name = "crop top cardigan"
	desc = "A cozy cardigan in a classic style."
	icon_state = "cardigan_crop"
	item_state = "cardigan_crop"
	icon_open = "cardigan_crop_open"
	icon_closed = "cardigan_crop"

/obj/item/clothing/suit/fake_cultrobes
	name = "occultist robes"
	desc = "A ragged, dusty set of robes. Sets off that moody, mysterious aura."
	icon_state = "cultrobes"
	item_state = "cultrobes"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	flags_inv = HIDEJUMPSUIT

/obj/item/clothing/suit/caution
	name = "wet floor sign"
	desc = "Caution! Wet Floor!"
	desc_fluff = "Used by the janitor to passive-aggressively point at when you eventually slip on one of their mopped floors."
	desc_info = "Alt-click, or click in-hand to toggle the caution lights. It looks like you can wear it in your suit slot."
	icon = 'icons/obj/janitor.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_janitor.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_janitor.dmi',
		)
	icon_state = "caution"
	drop_sound = 'sound/items/drop/shoes.ogg'
	pickup_sound = 'sound/items/pickup/shoes.ogg'
	force = 1
	throwforce = 3
	throw_speed = 2
	throw_range = 5
	w_class = 2
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	attack_verb = list("warned", "cautioned", "smashed")
	armor = list("melee" = 5, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 0, "acid" = 0)

/obj/item/clothing/suit/caution/attack_self()
	toggle()

/obj/item/clothing/suit/caution/AltClick()
	toggle()

/obj/item/clothing/suit/caution/proc/toggle()
	if(!usr || usr.stat || usr.lying || usr.restrained() || !Adjacent(usr))	return
	else if(src.icon_state == "caution")
		src.icon_state = "caution_blinking"
		src.item_state = "caution_blinking"
		usr.show_message("You turn the wet floor sign on.")
		playsound(src.loc, 'sound/items/flashlight.ogg', 75, 1)
	else
		src.icon_state = "caution"
		src.item_state = "caution"
		usr.show_message("You turn the wet floor sign off.")
	update_clothing_icon()

//Denim jackets
/obj/item/clothing/suit/storage/toggle/denim_jacket
	name = "denim jacket"
	desc = "A denim coat."
	icon_state = "denim_jacket"
	item_state = "denim_jacket"
	icon_open = "denim_jacket_open"
	icon_closed = "denim_jacket"
	item_state_slots = list(slot_r_hand_str = "denim_jacket", slot_l_hand_str = "denim_jacket")
	allowed = list (/obj/item/pen, /obj/item/paper, /obj/item/device/flashlight,/obj/item/tank/emergency_oxygen, /obj/item/storage/fancy/cigarettes, /obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask)
	body_parts_covered = UPPER_TORSO|ARMS

/obj/item/clothing/suit/storage/toggle/denim_jacket/sleeveless
	name = "denim vest"
	desc = "A denim vest."
	icon_state = "denim_jacket_sleeveless"
	item_state = "denim_jacket_sleeveless"
	icon_open = "denim_jacket_sleeveless_open"
	icon_closed = "denim_jacket_sleeveless"
	body_parts_covered = UPPER_TORSO
	item_state_slots = list(slot_r_hand_str = "denim_jacket", slot_l_hand_str = "denim_jacket")

/obj/item/clothing/suit/storage/toggle/denim_jacket/nanotrasen
	desc = "A denim coat. A corporate logo is proudly displayed on the back."
	icon_state = "denim_jacket_nt"
	item_state = "denim_jacket_nt"
	icon_open = "denim_jacket_nt_open"
	icon_closed = "denim_jacket_nt"
	item_state_slots = list(slot_r_hand_str = "denim_jacket", slot_l_hand_str = "denim_jacket")

/obj/item/clothing/suit/storage/toggle/denim_jacket/nanotrasen/sleeveless
	name = "denim vest"
	desc = "A denim vest. A corporate logo is proudly displayed on the back."
	icon_state = "denim_jacket_nt_sleeveless"
	item_state = "denim_jacket_nt_sleeveless"
	icon_open = "denim_jacket_nt_sleeveless_open"
	icon_closed = "denim_jacket_nt_sleeveless"
	body_parts_covered = UPPER_TORSO
	item_state_slots = list(slot_r_hand_str = "denim_jacket", slot_l_hand_str = "denim_jacket")

/obj/item/clothing/suit/storage/toggle/greatcoat
	name = "great coat"
	desc = "A heavy great coat."
	icon_state = "gentlecoat"
	item_state = "gentlecoat"
	icon_open = "gentlecoat_open"
	icon_closed = "gentlecoat"
	item_state_slots = list(slot_r_hand_str = "greatcoat", slot_l_hand_str = "greatcoat")

/obj/item/clothing/suit/storage/toggle/hoodie
	name = "hoodie"
	desc = "A warm sweatshirt."
	icon_state = "hoodie_alt"
	item_state = "hoodie_alt"
	icon_open = "hoodie_alt_open"
	icon_closed = "hoodie_alt"
	item_state_slots = list(slot_r_hand_str = "suit_grey", slot_l_hand_str = "suit_grey")
	min_cold_protection_temperature = T0C - 20
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS

/obj/item/clothing/suit/storage/toggle/hoodie/hpei
	name = "\improper HPEI hoodie"
	desc = "A warm, black sweatshirt. It bears the letters HPEI on the back, the letters for Hongsun Park Engineering Institute."
	icon_state = "hpei_hoodie"
	item_state = "hpei_hoodie"
	icon_open = "hpei_hoodie_open"
	icon_closed = "hpei_hoodie"
	item_state_slots = list(slot_r_hand_str = "suit_black", slot_l_hand_str = "suit_black")

/obj/item/clothing/suit/storage/toggle/hoodie/mu
	name = "\improper MU hoodie"
	desc = "A warm, grey sweatshirt.  It bears the letters MU on the front: Mars University."
	icon_state = "mu_hoodie"
	item_state = "mu_hoodie"
	icon_open = "mu_hoodie_open"
	icon_closed = "mu_hoodie"
	item_state_slots = list(slot_r_hand_str = "suit_grey", slot_l_hand_str = "suit_grey")

/obj/item/clothing/suit/storage/toggle/hoodie/nt
	name = "\improper NT hoodie"
	desc = "A warm, blue sweatshirt.  It proudly bears the silver NanoTrasen insignia lettering on the back.  The edges are trimmed with silver."
	icon_state = "nt_hoodie"
	item_state = "nt_hoodie"
	icon_open = "nt_hoodie_open"
	icon_closed = "nt_hoodie"
	item_state_slots = list(slot_r_hand_str = "suit_blue", slot_l_hand_str = "suit_blue")

/obj/item/clothing/suit/storage/toggle/hoodie/smw
	name = "\improper Space Mountain Wind hoodie"
	desc = "A warm, black sweatshirt.  It has the logo for the popular softdrink Space Mountain Wind on both the front and the back."
	icon_state = "smw_hoodie"
	item_state = "smw_hoodie"
	icon_open = "smw_hoodie_open"
	icon_closed = "smw_hoodie"
	item_state_slots = list(slot_r_hand_str = "suit_black", slot_l_hand_str = "suit_black")

/obj/item/clothing/suit/storage/toggle/hoodie/lums
	name = "\improper LUMS hoodie"
	desc = "A warm, grey sweatshirt. It bears the letters LUMS on the back: the letters of the Lunar University of Medical Science."
	icon_state = "lums_hoodie"
	item_state = "lums_hoodie"
	icon_open = "lums_hoodie_open"
	icon_closed = "lums_hoodie"
	item_state_slots = list(slot_r_hand_str = "suit_grey", slot_l_hand_str = "suit_grey")

/obj/item/clothing/suit/storage/snowsuit
	name = "snowsuit"
	desc = "A suit made to keep you nice and toasty on cold winter days. Or at least alive."
	icon_state = "snowsuit"
	item_state_slots = list(slot_r_hand_str = "labcoat", slot_l_hand_str = "labcoat")
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)
	allowed = list (/obj/item/pen, /obj/item/paper, /obj/item/device/flashlight,/obj/item/tank/emergency_oxygen, /obj/item/storage/fancy/cigarettes, /obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask)

/obj/item/clothing/suit/storage/snowsuit/command
	name = "command snowsuit"
	icon_state = "snowsuit_command"

/obj/item/clothing/suit/storage/snowsuit/security
	name = "security snowsuit"
	icon_state = "snowsuit_security"

/obj/item/clothing/suit/storage/snowsuit/medical
	name = "medical snowsuit"
	icon_state = "snowsuit_medical"

/obj/item/clothing/suit/storage/snowsuit/engineering
	name = "engineering snowsuit"
	icon_state = "snowsuit_engineering"

/obj/item/clothing/suit/storage/snowsuit/cargo
	name = "cargo snowsuit"
	icon_state = "snowsuit_cargo"

/obj/item/clothing/suit/storage/snowsuit/science
	name = "science snowsuit"
	icon_state = "snowsuit_science"

/*
 * Contains:
 * * Costume
 * * Misc
 */

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
	obj_flags = OBJ_FLAG_CONDUCTABLE
	fire_resist = T0C+5200
	flags_inv = HIDEWRISTS|HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT

/obj/item/clothing/suit/justice
	name = "justice suit"
	desc = "This pretty much looks ridiculous."
	icon_state = "justice"
	item_state = "justice"
	flags_inv = HIDEWRISTS|HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|HANDS|LEGS|FEET

/obj/item/clothing/suit/judgerobe
	name = "judge's robe"
	desc = "This robe commands authority."
	icon_state = "judge"
	item_state = "judge"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	allowed = list(/obj/item/storage/box/fancy/cigarettes,/obj/item/spacecash)
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
	desc = "A crimson red plastic replica of a space suit. This is a toy, it is not made for use in space!"
	w_class = WEIGHT_CLASS_NORMAL
	allowed = list(/obj/item/flashlight,/obj/item/tank/emergency_oxygen,/obj/item/toy)
	flags_inv = HIDEWRISTS|HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|HANDS|LEGS|FEET

/obj/item/clothing/suit/chickensuit
	name = "chicken suit"
	desc = "A cheap rubber chicken costume."
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
	flags_inv = HIDEWRISTS|HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
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
	flags_inv = HIDEWRISTS|HIDEGLOVES|HIDEJUMPSUIT

/obj/item/clothing/suit/straight_jacket/equipped(var/mob/user, var/slot)
	if (slot == slot_wear_suit_str)
		if(ishuman(loc))
			var/mob/living/carbon/human/H = loc
			H.drop_held_items()
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

/obj/item/clothing/suit/golden_tailcoat
	name = "golden tailcoat"
	desc = "A brilliant looking golden tailcoat of sorts."
	icon = 'icons/obj/item/clothing/suit/goldendeep_tailcoat.dmi'
	icon_state = "tailcoat"
	item_state = "tailcoat"
	body_parts_covered = UPPER_TORSO|ARMS

/obj/item/clothing/suit/storage/toggle/bomber
	name = "bomber jacket"
	desc = "A thick, well-worn WW2 leather bomber jacket."
	icon_state = "bomber"
	item_state = "bomber"
	body_parts_covered = UPPER_TORSO|ARMS
	cold_protection = UPPER_TORSO|ARMS
	min_cold_protection_temperature = T0C - 20
	siemens_coefficient = 0.75

/obj/item/clothing/suit/storage/toggle/leather_jacket
	name = "leather jacket"
	desc = "A black leather coat."
	icon_state = "leather_jacket"
	item_state = "leather_jacket"
	body_parts_covered = UPPER_TORSO|ARMS

/obj/item/clothing/suit/storage/toggle/leather_jacket/nanotrasen
	desc = "A black leather coat. A corporate logo is proudly displayed on the back."
	icon_state = "leather_jacket_nt"

/obj/item/clothing/suit/storage/toggle/leather_vest
	name = "leather vest"
	desc = "A black leather vest."
	icon_state = "leather_jacket_sleeveless"
	item_state = "leather_jacket_sleeveless"
	body_parts_covered = UPPER_TORSO

/obj/item/clothing/suit/storage/toggle/leather_jacket/biker
	name = "biker jacket"
	desc = "A thick, black leather jacket with silver zippers and buttons, crafted to evoke the image of rebellious space-biker gangs."
	icon_state = "biker"
	item_state = "biker"

/obj/item/clothing/suit/storage/toggle/leather_jacket/midriff
	name = "cropped leather jacket"
	icon = 'icons/obj/item/clothing/suit/storage/toggle/cropped_leather_jacket.dmi'
	desc = "A thick leather jacket that doesn't actually cover the waist. Rebel against what's expected of your jacket!"
	icon_state = "mid"
	item_state = "mid"
	contained_sprite = TRUE

/obj/item/clothing/suit/storage/toggle/leather_jacket/designer
	name = "designer leather jacket"
	desc = "A sophisticated, stylish leather jacket. It doesn't look cheap."
	icon_state = "designer_jacket"
	item_state = "designer_jacket"

/obj/item/clothing/suit/storage/toggle/leather_jacket/designer/black
	icon_state = "blackdesigner_jacket"
	item_state = "blackdesigner_jacket"

/obj/item/clothing/suit/storage/toggle/leather_jacket/designer/red
	icon_state = "reddesigner_jacket"
	item_state = "reddesigner_jacket"

/obj/item/clothing/suit/storage/toggle/leather_jacket/flight
	name = "flight jacket"
	desc = "A modern pilot's jacket made from a silky, shiny nanonylon material. Not to be confused with the vintage stylings of a bomber jacket."
	icon_state = "flight"
	item_state = "flight"

/obj/item/clothing/suit/storage/toggle/leather_jacket/flight/green
	icon_state = "gflight"
	item_state = "gflight"

/obj/item/clothing/suit/storage/toggle/leather_jacket/flight/white
	icon_state = "wflight"
	item_state = "wflight"

/obj/item/clothing/suit/storage/toggle/leather_jacket/flight/tcaf
	name = "TCAF flight jacket"
	desc = "A cheap pilot's jacket made from a silky, shiny nanonylon material and lined with tough, protective synthfabrics. It is ubiquitous throughout the Tau Ceti Armed Forces."
	icon_state = "lflight"
	item_state = "lflight"
	armor = list(
		MELEE = ARMOR_MELEE_RESISTANT,
		BULLET = ARMOR_BALLISTIC_MINOR,
		LASER = ARMOR_LASER_SMALL,
		ENERGY = ARMOR_ENERGY_MINOR,
		BOMB = ARMOR_BOMB_PADDED
	)
	siemens_coefficient = 0.75

/obj/item/clothing/suit/storage/toggle/leather_jacket/military
	name = "military jacket"
	desc = "A military-styled jacket made from thick, distressed canvas. Popular among Martian punks. Patches not included."
	icon_state = "mgreen"
	item_state = "mgreen"
	allowed = list (/obj/item/pen, /obj/item/paper, /obj/item/flashlight, /obj/item/tank/emergency_oxygen, /obj/item/storage/box/fancy/matches, /obj/item/reagent_containers/food/drinks/flask)

/obj/item/clothing/suit/storage/toggle/leather_jacket/military/tan
	icon_state = "mtan"
	item_state = "mtan"

/obj/item/clothing/suit/storage/toggle/leather_jacket/military/old
	name = "old military jacket"
	desc = "A canvas jacket styled after classical earth military garb. Feels sturdy, yet comfortable."
	icon_state = "mold"
	item_state = "mold"

/obj/item/clothing/suit/storage/toggle/leather_jacket/military/old/alt
	icon_state = "mold_alt"
	item_state = "mold_alt"

/obj/item/clothing/suit/storage/toggle/leather_jacket/reade_racing
	name = "reade extreme racing jacket"
	desc = "A synthleather racing jacket. \
	The jacket has various patches and insignia of unsavoury, underground racing groups and sponsors based on and around Reade stitched or printed onto it. \
	It can be tightly strapped and zipped up tight to offer some void protection to the torso, and a thick layer of fire resistant material lines the inside of the \
	jacket — still not the safest to get into an accident in."
	icon = 'icons/obj/item/clothing/suit/storage/toggle/human/biesel/reade_racing_jacket.dmi'
	icon_state = "racing"
	item_state = "racing"
	has_accents = TRUE
	build_from_parts = TRUE
	contained_sprite = TRUE

	// This is a *space* extreme racing jacket so, it will have some moderate protection from some space environmental hazards, but nothing that replaces the need to source proper voidsuits.
	// Legs/head/hands are not protected so, you will still be quickly disabled by void barotrauma if not wearing other PPE.
	gas_transfer_coefficient = 0.85
	siemens_coefficient = 0.85
	heat_protection = UPPER_TORSO|LOWER_TORSO|ARMS
	max_heat_protection_temperature = T0C + 40
	fire_resist = T0C + 40
	max_pressure_protection = 101.3

	/// Determines if and what decal is applied to the back of the jacket.
	var/decal

	/// Boolean. Has the jacket been fastened tight for some moderate void/heat protection?
	var/voidproofed = FALSE

/obj/item/clothing/suit/storage/toggle/leather_jacket/reade_racing/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "This jacket can be fastened to provide temporary protection in near-void conditions and moderately heated environments."
	. += "It is not a suitable replacement for a proper space suit as it does not offer total void protection, may come loose on its own, and does not cover the entire body."

/obj/item/clothing/suit/storage/toggle/leather_jacket/reade_racing/get_mob_overlay(var/mob/living/carbon/human/human, var/mob_icon, var/mob_state, var/slot)
	var/image/I = ..()
	if(equip_slot == slot_wear_suit)
		if(decal)
			var/image/decal_overlay = overlay_image(icon, decal, flags = RESET_COLOR)
			I.AddOverlays(decal_overlay)
	return I

/obj/item/clothing/suit/storage/toggle/leather_jacket/reade_racing/verb/voidproof_toggle_verb()
	set name = "Fasten/Unfasten Racing Jacket Straps"
	set category = "Object"
	set src in usr

	if(use_check_and_message(usr))
		return
	if(!ismob(src.loc))
		to_chat(usr, SPAN_WARNING("You need to be wearing the jacket to fasten it tight"))
		return
	if(opened)
		to_chat(usr, SPAN_WARNING("The jacket must be zipped up first!"))
		return

	if(!do_after(usr, 2 SECONDS))
		return

	if(voidproofed)
		usr.visible_message(SPAN_NOTICE("[usr] unfastens the straps of their racing jacket."),
							SPAN_NOTICE("You unfasten the straps of your racing jacket. Much comfier and more mobile!"))
		playsound(usr, 'sound/items/zip.ogg', 50, 1)
		loosen_straps(usr)
	else
		usr.visible_message(SPAN_NOTICE("[usr] fastens the straps of their racing jacket tight."),
							SPAN_NOTICE("You fasten the straps of your racing jacket tight, providing some moderate void/heat protection. This is going to slow you down a bit..."))
		playsound(usr, 'sound/items/zip.ogg', 50, 1)
		fasten_straps(usr)

/obj/item/clothing/suit/storage/toggle/leather_jacket/reade_racing/proc/fasten_straps(mob/user)
		// Buffed pressure/gas transfer/heat protection
		min_pressure_protection = 5 // Protects against all but a hard void (and even then, your hands/feet/head aren't protected)
		gas_transfer_coefficient = 0.20
		max_heat_protection_temperature = T0C + 200
		fire_resist = T0C + 200
		max_pressure_protection = SPACE_SUIT_MAX_PRESSURE*0.8
		slowdown = 0.2 // cause its more umcomfortable, i guess? slightly better than a softsuit
		voidproofed = TRUE

		// After a while, the straps automatically loosen.
		addtimer(CALLBACK(src, PROC_REF(straps_come_loose), user), rand(60, 120) SECONDS)

/obj/item/clothing/suit/storage/toggle/leather_jacket/reade_racing/proc/loosen_straps(mob/user)
	min_pressure_protection = initial(min_pressure_protection)
	gas_transfer_coefficient = initial(gas_transfer_coefficient)
	max_heat_protection_temperature = initial(max_heat_protection_temperature)
	fire_resist = initial(fire_resist)
	max_pressure_protection = initial(max_pressure_protection)
	slowdown = initial(slowdown)
	voidproofed = FALSE

/obj/item/clothing/suit/storage/toggle/leather_jacket/reade_racing/proc/straps_come_loose(var/mob/user)
	if(voidproofed)
		to_chat(user, SPAN_WARNING("You feel a strap of the racing jacket come loose!"))
		min_pressure_protection = initial(min_pressure_protection)
		gas_transfer_coefficient = initial(gas_transfer_coefficient)
		max_heat_protection_temperature = initial(max_heat_protection_temperature)
		voidproofed = FALSE

/obj/item/clothing/suit/storage/toggle/leather_jacket/reade_racing/checker
	decal = "decal_checker"
	desc = "A synthetic leather racing jacket with a thin layer of protective padding. The jacket has various patches and insignia of unsavoury, underground racing groups and sponsors based on and around Reade stitched or printed onto it. It has a checkered pattern printed on the back."

/obj/item/clothing/suit/storage/toggle/leather_jacket/reade_racing/eagle
	decal = "decal_eagle"
	desc = "A synthetic leather racing jacket with a thin layer of protective padding. The jacket has various patches and insignia of unsavoury, underground racing groups and sponsors based on and around Reade stitched or printed onto it. It has an eagle printed on the back."

/obj/item/clothing/suit/storage/toggle/leather_jacket/reade_racing/eagle2
	decal = "decal_eagle2"
	desc = "A synthetic leather racing jacket with a thin layer of protective padding. The jacket has various patches and insignia of unsavoury, underground racing groups and sponsors based on and around Reade stitched or printed onto it. It has an eagle printed on the back."

/obj/item/clothing/suit/storage/toggle/leather_jacket/reade_racing/skull
	decal = "decal_skull"
	desc = "A synthetic leather racing jacket with a thin layer of protective padding. The jacket has various patches and insignia of unsavoury, underground racing groups and sponsors based on and around Reade stitched or printed onto it. It has a skull printed on the back."

/obj/item/clothing/suit/storage/toggle/leather_jacket/reade_racing/flames
	decal = "decal_flames"
	desc = "A synthetic leather racing jacket with a thin layer of protective padding. The jacket has various patches and insignia of unsavoury, underground racing groups and sponsors based on and around Reade stitched or printed onto it. It has a flame decal printed on the back."

/obj/item/clothing/suit/storage/toggle/leather_jacket/reade_racing/knife
	decal = "decal_knife"
	desc = "A synthetic leather racing jacket with a thin layer of protective padding. The jacket has various patches and insignia of unsavoury, underground racing groups and sponsors based on and around Reade stitched or printed onto it. It has a bloodied knife printed on the back, much like the notorious The Killer displayed."

/obj/item/clothing/suit/storage/toggle/leather_jacket/reade_racing/crown
	decal = "decal_crown"
	desc = "A synthetic leather racing jacket with a thin layer of protective padding. The jacket has various patches and insignia of unsavoury, underground racing groups and sponsors based on and around Reade stitched or printed onto it. It has a crown printed on the back, much like the legendary The Monarch displayed."

/obj/item/clothing/suit/storage/toggle/leather_jacket/reade_racing/zombie
	decal = "decal_zombie"
	desc = "A synthetic leather racing jacket with a thin layer of protective padding. The jacket has various patches and insignia of unsavoury, underground racing groups and sponsors based on and around Reade stitched or printed onto it. It has a zombie head decal printed on the back, much like the infamous The Zombie displayed."

/obj/item/clothing/suit/storage/toggle/leather_jacket/reade_racing/cat
	decal = "decal_cat"
	desc = "A synthetic leather racing jacket with a thin layer of protective padding. The jacket has various patches and insignia of unsavoury, underground racing groups and sponsors based on and around Reade stitched or printed onto it. It has a cat head printed on the back."

/obj/item/clothing/suit/storage/toggle/leather_jacket/reade_racing/random/Initialize()
	. = ..()
	decal = pick("decal_checker", "decal_eagle", "decal_eagle2", "decal_skull", "decal_flames", "decal_knife", "decal_crown", "decal_zombie", "decal_cat")
	color = get_random_colour(lower = 150)
	accent_color = get_random_colour(1)

//This one has buttons for some reason
/obj/item/clothing/suit/storage/toggle/brown_jacket
	name = "leather jacket"
	desc = "A brown leather coat."
	icon_state = "brown_jacket"
	item_state = "brown_jacket"
	body_parts_covered = UPPER_TORSO|ARMS

/obj/item/clothing/suit/storage/toggle/brown_jacket/sleeveless
	name = "brown vest"
	desc = "A brown leather vest."
	icon_state = "brown_jacket_sleeveless"
	item_state = "brown_jacket_sleeveless"
	body_parts_covered = UPPER_TORSO

/obj/item/clothing/suit/storage/toggle/brown_jacket/sleeveless/colorable
	name = "vest"
	desc = "A vest made of synthetic fiber."
	icon_state = "colored_vest"
	item_state = "colored_vest"

/obj/item/clothing/suit/storage/toggle/brown_jacket/nanotrasen
	desc = "A brown leather coat. A corporate logo is proudly displayed on the back."
	icon_state = "brown_jacket_nt"

/obj/item/clothing/suit/storage/toggle/brown_jacket/scc
	name = "Stellar Corporate Conglomerate jacket"
	desc = "A comfortable blue jacket. Tailored upon its back is a large Stellar Corporate Conglomerate logo."
	desc_extended = "The Stellar Corporate Conglomerate, also known as Chainlink, is a joint alliance between the NanoTrasen Corporation, Hephaestus Industries, Idris Incorporated, Zeng-Hu Pharmaceuticals and Zavodskoi Interstellar to exercise an undisputed economic dominance over the Orion Spur."
	icon = 'icons/obj/item/clothing/suit/storage/toggle/corp_dep_jackets.dmi'
	icon_state = "scc_jacket"
	item_state = "scc_jacket"
	contained_sprite = TRUE

/obj/item/clothing/suit/storage/toggle/brown_jacket/scc/sancol
	name = "bridge crew jacket"
	desc = "A more formal jacket for bridge staff. Designed in a typical Colettish style."
	desc_extended= "While not a true Colettish uniform the aiguillette and cuff tabs of this one are obviously based on the real thing. \
	An actual Civil Guard uniform, commonly known as a rayadillo, is generally of a darker blue and features the wearer’s ranks on the collar."
	icon = 'icons/obj/item/clothing/suit/storage/toggle/corp_dep_jackets.dmi'
	icon_state = "bridge_crew_jacket_sancol"
	item_state = "bridge_crew_jacket_sancol"

/obj/item/clothing/suit/storage/toggle/flannel
	name = "green flannel shirt"
	desc = "A flannel shirt, for all your space hipster needs."
	icon_state = "flannel_green"
	item_state = "flannel_green"
	body_parts_covered = UPPER_TORSO|ARMS

/obj/item/clothing/suit/storage/toggle/flannel/red
	name = "red flannel shirt"
	icon_state = "flannel_red"
	item_state = "flannel_red"

/obj/item/clothing/suit/storage/toggle/flannel/blue
	name = "blue flannel shirt"
	icon_state = "flannel_blue"
	item_state = "flannel_blue"

/obj/item/clothing/suit/storage/toggle/flannel/gray
	name = "grey flannel shirt"
	icon_state = "flannel_gray"
	item_state = "flannel_gray"

/obj/item/clothing/suit/storage/toggle/flannel/purple
	name = "purple flannel shirt"
	icon_state = "flannel_purple"
	item_state = "flannel_purple"

/obj/item/clothing/suit/storage/toggle/flannel/yellow
	name = "yellow flannel shirt"
	icon_state = "flannel_yellow"
	item_state = "flannel_yellow"

/obj/item/clothing/suit/storage/toggle/trench
	name = "brown trenchcoat"
	desc = "A rugged canvas trenchcoat."
	icon = 'icons/obj/item/clothing/suit/storage/toggle/trenchcoat.dmi'
	icon_state = "trench"
	item_state = "trench"
	contained_sprite = TRUE
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|ARMS
	protects_against_weather = TRUE

/obj/item/clothing/suit/storage/toggle/trench/grey
	name = "grey trenchcoat"
	icon_state = "trench2"
	item_state = "trench2"
	blood_overlay_type = "coat"

/obj/item/clothing/suit/storage/toggle/trench/alt
	name = "brown trenchcoat"
	desc = "A sleek canvas trenchcoat."
	icon_state = "trenchcoat_brown"
	item_state = "trenchcoat_brown"

/obj/item/clothing/suit/storage/toggle/trench/grey_alt
	name = "grey trenchcoat"
	desc = "A sleek canvas trenchcoat."
	icon_state = "trenchcoat_grey"
	item_state = "trenchcoat_grey"

/obj/item/clothing/suit/storage/toggle/trench/green
	name = "green trenchcoat"
	desc = "A sleek canvas trenchcoat."
	icon_state = "trenchcoat_green"
	item_state = "trenchcoat_green"

/obj/item/clothing/suit/storage/toggle/trench/colorable
	name = "trenchcoat"
	desc = "A sleek canvas trenchcoat."
	icon_state = "trench_colorable"
	item_state = "trench_colorable"

/obj/item/clothing/suit/storage/toggle/trench/colorable/random/Initialize()
	. = ..()
	color = get_random_colour(lower = 150)

/obj/item/clothing/suit/storage/toggle/trench/colorable/alt
	icon_state = "trench_colorable2"
	item_state = "trench_colorable2"
	has_accents = TRUE

/obj/item/clothing/suit/storage/toggle/track
	name = "track jacket"
	desc = "a track jacket, for the athletic."
	icon = 'icons/obj/tracksuit.dmi'
	icon_state = "trackjacket"
	item_state = "trackjacket"
	allowed = list (/obj/item/pen, /obj/item/paper, /obj/item/flashlight, /obj/item/tank/emergency_oxygen, /obj/item/storage/box/fancy/cigarettes, /obj/item/storage/box/fancy/matches, /obj/item/reagent_containers/food/drinks/flask)
	contained_sprite = TRUE

/obj/item/clothing/suit/storage/toggle/track/blue
	name = "blue track jacket"
	icon = 'icons/obj/tracksuit.dmi'
	icon_state = "trackjacketblue"
	item_state = "trackjacketblue"

/obj/item/clothing/suit/storage/toggle/track/green
	name = "green track jacket"
	icon = 'icons/obj/tracksuit.dmi'
	icon_state = "trackjacketgreen"
	item_state = "trackjacketgreen"

/obj/item/clothing/suit/storage/toggle/track/red
	name = "red track jacket"
	icon = 'icons/obj/tracksuit.dmi'
	icon_state = "trackjacketred"
	item_state = "trackjacketred"

/obj/item/clothing/suit/storage/toggle/track/white
	name = "white track jacket"
	icon = 'icons/obj/tracksuit.dmi'
	icon_state = "trackjacketwhite"
	item_state = "trackjacketwhite"

/obj/item/clothing/suit/storage/toggle/varsity
	name = "black varsity jacket"
	desc = "A favorite of jocks everywhere from Sol to the Coalition."
	icon_state = "varsity"
	item_state = "varsity"
	allowed = list (/obj/item/pen, /obj/item/paper, /obj/item/flashlight, /obj/item/tank/emergency_oxygen, /obj/item/storage/box/fancy/matches, /obj/item/reagent_containers/food/drinks/flask)

/obj/item/clothing/suit/storage/toggle/varsity/red
	name = "red varsity jacket"
	icon_state = "varsity_red"
	item_state = "varsity_red"

/obj/item/clothing/suit/storage/toggle/varsity/purple
	name = "purple varsity jacket"
	icon_state = "varsity_purple"
	item_state = "varsity_purple"

/obj/item/clothing/suit/storage/toggle/varsity/green
	name = "green varsity jacket"
	icon_state = "varsity_green"
	item_state = "varsity_green"

/obj/item/clothing/suit/storage/toggle/varsity/blue
	name = "blue varsity jacket"
	icon_state = "varsity_blue"
	item_state = "varsity_blue"

/obj/item/clothing/suit/storage/toggle/varsity/brown
	name = "brown varsity jacket"
	icon_state = "varsity_brown"
	item_state = "varsity_brown"

/obj/item/clothing/suit/storage/tcaf/legion
	name = "TCAF foreign legions jacket"
	desc = "A pale blue canvas jacket embossed with the insignia of one of the TCAF service branch's Foreign Legions corp."
	icon_state = "tcfljacket"
	item_state = "tcfljacket"

/obj/item/clothing/suit/storage/tcaf
	name = "TCAF jacket"
	desc = "A pale blue canvas jacket embossed with the insignia of the Tau Ceti Armed Forces."
	icon_state = "tcaf_jacket"
	item_state = "tcaf_jacket"

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

/obj/item/clothing/suit/storage/toggle/asymmetriccoat
	name = "asymmetric coat"
	desc = "A solid sleeveless coat that only covers the upper body and the back of the legs."
	icon_state = "asymmetriccoat"
	item_state = "asymmetriccoat"
	body_parts_covered = UPPER_TORSO

/obj/item/clothing/suit/storage/toggle/highloft
	name = "high loft jacket"
	desc = "A high loft insulated jacket intended for long hours in cold station conditions."
	icon = 'icons/obj/item/clothing/suit/storage/toggle/highloft.dmi'
	icon_state = "highloft"
	item_state = "highloft"
	worn_overlay = "over"
	contained_sprite = TRUE
	build_from_parts = TRUE
	body_parts_covered = UPPER_TORSO|ARMS
	cold_protection = UPPER_TORSO|ARMS
	min_cold_protection_temperature = T0C - 20
	siemens_coefficient = 0.75

/*
 * Department Jackets
 */
/obj/item/clothing/suit/storage/toggle/engi_dep_jacket
	name = "engineering department jacket"
	desc = "A cozy jacket in engineering's colors, featuring spacious pockets you won't even use."
	icon_state = "engi_dep_jacket"
	item_state = "engi_dep_jacket"
	icon = 'icons/obj/item/clothing/suit/storage/toggle/corp_dep_jackets.dmi'
	contained_sprite = TRUE

/obj/item/clothing/suit/storage/toggle/supply_dep_jacket
	name = "operations department jacket"
	desc = "A cozy jacket in operations' colors, perfect for folding up and forgetting bounty lists."
	icon_state = "supply_dep_jacket"
	item_state = "supply_dep_jacket"
	icon = 'icons/obj/item/clothing/suit/storage/toggle/corp_dep_jackets.dmi'
	contained_sprite = TRUE

/obj/item/clothing/suit/storage/toggle/sci_dep_jacket
	name = "science department jacket"
	desc = "A cozy jacket in science's colors, offering the latest in a complete lack of protection against chemical spills."
	icon_state = "sci_dep_jacket"
	item_state = "sci_dep_jacket"
	icon = 'icons/obj/item/clothing/suit/storage/toggle/corp_dep_jackets.dmi'
	contained_sprite = TRUE

/obj/item/clothing/suit/storage/toggle/med_dep_jacket
	name = "medical department jacket"
	desc = "A cozy jacket in medical's colors, guaranteed not to leak the latest gossip."
	icon_state = "med_dep_jacket"
	item_state = "med_dep_jacket"
	icon = 'icons/obj/item/clothing/suit/storage/toggle/corp_dep_jackets.dmi'
	contained_sprite = TRUE

/obj/item/clothing/suit/storage/toggle/sec_dep_jacket
	name = "security department jacket"
	desc = "A cozy jacket in security's colors, luckily able to be easily cleaned of blood stains"
	icon_state = "sec_dep_jacket"
	item_state = "sec_dep_jacket"
	icon = 'icons/obj/item/clothing/suit/storage/toggle/corp_dep_jackets.dmi'
	contained_sprite = TRUE

/obj/item/clothing/suit/storage/toggle/serv_dep_jacket
	name = "service department jacket"
	desc = "A cozy jacket in service's colors, reminding many employees that even service has colors."
	icon_state = "serv_dep_jacket"
	item_state = "serv_dep_jacket"
	icon = 'icons/obj/item/clothing/suit/storage/toggle/corp_dep_jackets.dmi'
	contained_sprite = TRUE

/obj/item/clothing/suit/storage/toggle/bssb
	name = "\improper BSSB agent jacket"
	desc = "A jacket used by Biesel Security Services Bureau agents while on the field."
	icon_state = "bssb_jacket"
	item_state = "bssb_jacket"
	icon = 'icons/obj/item/clothing/suit/storage/toggle/bssb_jacket.dmi'
	contained_sprite = TRUE

/obj/item/clothing/suit/storage/toggle/bssb/armor
	name = "\improper BSSB agent armored jacket"
	desc = "A jacket used by Biesel Security Services Bureau agents while on the field. This one has armored lining."
	icon_state = "bssb_jacket_armored"
	item_state = "bssb_jacket_armored"
	armor = list(
		MELEE = ARMOR_MELEE_KNIVES,
		BULLET = ARMOR_BALLISTIC_SMALL,
		LASER = ARMOR_LASER_SMALL,
		ENERGY = ARMOR_ENERGY_MINOR,
		BOMB = ARMOR_BOMB_PADDED
	)

// Cardigans.

/obj/item/clothing/suit/storage/toggle/cardigan
	name = "cardigan"
	desc = "A cozy, warm knit cardigan."
	desc_extended = "Only slightly worse than a blanket."
	icon_state = "cardigan"
	item_state = "cardigan"

/obj/item/clothing/suit/storage/toggle/cardigan/sweater
	name = "sweater cardigan"
	desc = "A cozy, warm knit sweater cardigan."
	desc_extended = "Half as warm as a sweater, and half as fashionable as a cardigan. Not like it matters for coffee-house dwelling beatniks like yourself."
	icon_state = "cardigansweater"
	item_state = "cardigansweater"

/obj/item/clothing/suit/storage/toggle/cardigan/argyle
	name = "argyle cardigan"
	desc = "A cozy, warm knit argyle cardigan."
	desc_extended = "You'll never get dumped if you never get in a relationship in the first place. With this, you'll never have to worry again."
	icon_state = "cardiganargyle"
	item_state = "cardiganargyle"

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
	desc_extended = "Used by the janitor to passive-aggressively point at when you eventually slip on one of their mopped floors."
	icon = 'icons/obj/janitor.dmi'
	item_icons = list(
		BP_L_HAND = 'icons/mob/items/lefthand_janitor.dmi',
		BP_R_HAND = 'icons/mob/items/righthand_janitor.dmi',
		)
	icon_state = "caution"
	drop_sound = 'sound/items/drop/shoes.ogg'
	pickup_sound = 'sound/items/pickup/shoes.ogg'
	force = 1
	throwforce = 3
	throw_speed = 2
	throw_range = 5
	w_class = WEIGHT_CLASS_SMALL
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	attack_verb = list("warned", "cautioned", "smashed")
	armor = list(melee = 5, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/suit/caution/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "ALT-click, or click in-hand to toggle the caution lights."
	. += "It looks like you could wear it in your suit slot if you really wanted to."

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

/obj/item/clothing/suit/caution/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/wetfloor_holder))
		var/obj/item/wetfloor_holder/WFH = attacking_item
		if(!WFH.held)
			to_chat(user, SPAN_NOTICE("You collect \the [src]."))
			forceMove(WFH)
			WFH.held = src
		return TRUE

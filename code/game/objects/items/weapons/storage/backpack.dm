
/*
 * Backpack
 */

/obj/item/storage/backpack
	name = "backpack"
	desc = "You wear this on your back and put items into it."
	desc_antag = "As a Cultist, this item can be reforged to become a cult backpack. Any stored items will be transferred."
	icon = 'icons/obj/storage/backpack.dmi'
	icon_state = "backpack"
	item_state = "backpack"
	contained_sprite = TRUE
	sprite_sheets = list(
		BODYTYPE_VAURCA_BULWARK = 'icons/mob/species/bulwark/back.dmi'
	)
	w_class = ITEMSIZE_LARGE
	slot_flags = SLOT_BACK
	max_w_class = ITEMSIZE_NORMAL
	max_storage_space = 28
	var/species_restricted = list("exclude",BODYTYPE_VAURCA_BREEDER,BODYTYPE_VAURCA_WARFORM)
	drop_sound = 'sound/items/drop/backpack.ogg'
	pickup_sound = 'sound/items/pickup/backpack.ogg'
	allow_quick_empty = TRUE
	empty_delay = 0.5 SECOND
	var/straps = FALSE // Only really used for the verb.

/obj/item/storage/backpack/Initialize()
	. = ..()
	if(straps == TRUE)
		alpha_mask = "normal"
		verbs += /obj/item/storage/backpack/proc/adjust_backpack_straps

/obj/item/storage/backpack/proc/adjust_backpack_straps()
	set name = "Adjust Bag Straps"
	set desc = "Adjust your bag straps."
	set category = "Object"
	set src in usr
	if(use_check_and_message(usr))
		return 0
	switch(input(usr, "Choose your bag strap style.", "[src]") as null|anything in GLOB.backbagstrap)
		if("Hidden")
			alpha_mask = "hidden"
		if("Thin")
			alpha_mask = "thin"
		if("Normal")
			alpha_mask = "normal"
		if("Thick")
			alpha_mask = null
	to_chat(usr, SPAN_NOTICE("You adjust your bag strap to be [alpha_mask ? "[alpha_mask]" : "thick"]."))
	var/mob/living/carbon/human/H = src.loc
	H.update_icon()
	H.update_inv_back()

/obj/item/storage/backpack/mob_can_equip(M as mob, slot, disable_warning = FALSE)

	//if we can't equip the item anyway, don't bother with species_restricted (cuts down on spam)
	if (!..())
		return 0

	if(species_restricted && ishuman(M) && !(slot in list(slot_l_hand, slot_r_hand)))
		var/exclusive = null
		var/wearable = null
		var/mob/living/carbon/human/H = M

		if("exclude" in species_restricted)
			exclusive = 1

		if(H.species)
			if(exclusive)
				if(!(H.species.get_bodytype() in species_restricted))
					wearable = 1
			else
				if(H.species.get_bodytype() in species_restricted)
					wearable = 1

			if(!wearable && !(slot in list(slot_l_store, slot_r_store, slot_s_store)))
				to_chat(H, "<span class='danger'>Your species cannot wear [src].</span>")
				return 0
	return 1

/*
 * Backpack Types
 */

/obj/item/storage/backpack/holding
	name = "portable bluespace pocket"
	desc = "A backpack that opens into a localized pocket of bluespace. Extremely dangerous, and officially these devices do not exist. Officially."
	origin_tech = list(TECH_BLUESPACE = 4)
	icon_state = "holdingpack"
	item_state = "holdingpack"
	max_w_class = ITEMSIZE_LARGE
	max_storage_space = 56
	storage_cost = 29
	empty_delay = 0.8 SECOND

/obj/item/storage/backpack/holding/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/storage/backpack/holding))
		to_chat(user, "<span class='warning'>The Bluespace interfaces of the two devices conflict and malfunction.</span>")
		qdel(attacking_item)
		return
	..()

	//Please don't clutter the parent storage item with stupid hacks.
/obj/item/storage/backpack/holding/can_be_inserted(obj/item/W as obj, stop_messages = 0)
	if(istype(W, /obj/item/storage/backpack/holding))
		return 1
	return ..()

/obj/item/storage/backpack/santabag
	name = "\improper Santa's gift bag"
	desc = "Space Santa uses this to deliver toys to all the nice children in space in Christmas! Wow, it's pretty big!"
	icon_state = "giftbag0"
	item_state = "giftbag"
	w_class = ITEMSIZE_LARGE
	max_storage_space = 200 // can store a ton of shit!
	empty_delay = 1 SECOND

/obj/item/storage/backpack/cultpack
	name = "trophy rack"
	desc = "It's useful for both carrying extra gear and proudly declaring your insanity."
	desc_antag = null // It's already been forged once.
	icon_state = "cultpack"
	item_state = "cultpack"

/obj/item/storage/backpack/medic
	name = "medical backpack"
	desc = "It's a backpack especially designed for use in a sterile environment."
	icon_state = "medicalpack"
	item_state = "medicalpack"

/obj/item/storage/backpack/security
	name = "security backpack"
	desc = "It's a very robust backpack."
	icon_state = "securitypack"
	item_state = "securitypack"

/obj/item/storage/backpack/captain
	name = "captain's backpack"
	desc = "It's a special backpack made exclusively for officers."
	icon_state = "captainpack"
	item_state = "captainpack"
	empty_delay = 0.8 SECOND

/obj/item/storage/backpack/industrial
	name = "industrial backpack"
	desc = "It's a tough backpack for the daily grind of station life."
	icon_state = "engiepack"
	item_state = "engiepack"
	empty_delay = 0.8 SECOND

/obj/item/storage/backpack/toxins
	name = "laboratory backpack"
	desc = "It's a light backpack modeled for use in laboratories and other scientific institutions."
	icon_state = "toxpack"
	item_state = "toxpack"

/obj/item/storage/backpack/hydroponics
	name = "herbalist's backpack"
	desc = "It's a green backpack with many pockets to store plants and tools in."
	icon_state = "hydpack"
	item_state = "hydpack"

/obj/item/storage/backpack/pharmacy
	name = "pharmacy backpack"
	desc = "It's an orange backpack which was designed to hold beakers, pill bottles and bottles."
	icon_state = "chempack"
	item_state = "chempack"

/obj/item/storage/backpack/psychiatrist
	name = "psychiatrist backpack"
	desc = "It's a blue backpack, designed to calm and soothe the crew of whatever mess of a workplace you reside in."
	icon_state = "psychpack"
	item_state = "psychpack"

/obj/item/storage/backpack/emt
	name = "EMT's backpack"
	desc = "It's a black and white backpack for the savior of clumsy miners."
	icon_state = "emtpack"
	item_state = "emtpack"

/obj/item/storage/backpack/syndie
	name = "tactical rucksack"
	desc = "The latest in carbon fiber and red satin combat rucksack technology. Comfortable and tough!"
	icon_state = "syndiepack"
	item_state = "syndiepack"
	empty_delay = 0.8 SECOND

/obj/item/storage/backpack/cmo
	name = "CMO's backpack"
	desc = "It's a backpack especially designed for use in a sterile environment. Did someone store organs in this?"
	icon_state = "cmopack"
	item_state = "cmopack"
	empty_delay = 0.8 SECOND

/obj/item/storage/backpack/hos
	name = "HOS' backpack"
	desc = "It's a very robust backpack. Ergonomically designed for maximum suplex efficiency!"
	icon_state = "hospack"
	item_state = "hospack"
	empty_delay = 0.8 SECOND

/obj/item/storage/backpack/ce
	name = "CE's backpack"
	desc = "It's a tough backpack for the daily grind of station life. Perfect for surviving a welder-bomb at point-blank range."
	icon_state = "cepack"
	item_state = "cepack"
	empty_delay = 0.8 SECOND

/obj/item/storage/backpack/rd
	name = "RD's backpack"
	desc = "It's a light backpack modeled for use in laboratories and other scientific institutions. Mainly used to store homemade firearms."
	icon_state = "rdpack"
	item_state = "rdpack"
	empty_delay = 0.8 SECOND

/obj/item/storage/backpack/om
	name = "OM's backpack"
	desc = "A perfect backpack for the paper-pushing bureaucrat; to store requisition forms that annoy the hell out of everyone."
	icon_state = "ompack"
	item_state = "ompack"
	empty_delay = 0.8 SECOND

/obj/item/storage/backpack/zavod
	name = "zavodskoi backpack"
	icon_state = "zavodpack"
	item_state = "zavodpack"

/obj/item/storage/backpack/nt
	name = "nanotrasen backpack"
	icon_state = "ntpack"
	item_state = "ntpack"

/obj/item/storage/backpack/zeng
	name = "zeng-hu backpack"
	icon_state = "zengpack"
	item_state = "zengpack"

/obj/item/storage/backpack/heph
	name = "hephaestus backpack"
	icon_state = "hephpack"
	item_state = "hephpack"

/obj/item/storage/backpack/idris
	name = "idris backpack"
	icon_state = "idrispack"
	item_state = "idrispack"

/obj/item/storage/backpack/orion
	name = "orion backpack"
	icon_state = "orionpack"
	item_state = "orionpack"

/obj/item/storage/backpack/pmcg
	name = "PMCG backpack"
	icon_state = "pmcgpack"
	item_state = "pmcgpack"

/obj/item/storage/backpack/legion
	name = "military rucksack"
	desc = "A sturdy backpack with the emblems and markings of the Tau Ceti Foreign Legion."
	icon_state = "legion_bag"
	item_state = "legion_bag"
	empty_delay = 0.8 SECOND

/obj/item/storage/backpack/tcaf
	name = "\improper TCAF carapace backpack"
	desc = "A hard shelled backpack with the flag of the Republic of Biesel front and center. Made for the Tau Ceti Armed Forces."
	icon_state = "tcaf_carapace_backpack"
	item_state = "tcaf_carapace_backpack"
	empty_delay = 0.8 SECOND

/obj/item/storage/backpack/service
	name = "idris service backpack"
	desc = "The Idris Service Standard, known for it's professionalism. It also baffingly includes this monstrous, self-stabilizing back-mounted utensil and service item holder."
	icon_state = "idris_backpack"
	item_state = "idris_backpack"
	storage_slots = 6
	max_w_class = ITEMSIZE_LARGE
	can_hold = list(
		/obj/item/tray,
		/obj/item/material/kitchen/utensil/fork,
		/obj/item/material/kitchen/utensil/knife,
		/obj/item/material/kitchen/utensil/spoon,
		/obj/item/material/knife,
		/obj/item/material/hatchet/butch,
		/obj/item/reagent_containers/food/drinks/drinkingglass,
		/obj/item/storage/toolbox/lunchbox
		)

//ERT backpacks.
/obj/item/storage/backpack/ert
	name = "emergency response team backpack"
	desc = "A spacious backpack with lots of pockets, used by members of the Emergency Response Team."
	icon_state = "ert_commander"
	item_state = "ert_commander"
	empty_delay = 0.8 SECOND

//Commander
/obj/item/storage/backpack/ert/commander
	name = "emergency response team commander backpack"
	desc = "A spacious backpack with lots of pockets, worn by the commander of an Emergency Response Team."

//Security
/obj/item/storage/backpack/ert/security
	name = "emergency response team security backpack"
	desc = "A spacious backpack with lots of pockets, worn by security members of an Emergency Response Team."
	icon_state = "ert_security"
	item_state = "ert_security"

//Engineering
/obj/item/storage/backpack/ert/engineer
	name = "emergency response team engineer backpack"
	desc = "A spacious backpack with lots of pockets, worn by engineering members of an Emergency Response Team."
	icon_state = "ert_engineering"
	item_state = "ert_engineering"

//Medical
/obj/item/storage/backpack/ert/medical
	name = "emergency response team medical backpack"
	desc = "A spacious backpack with lots of pockets, worn by medical members of an Emergency Response Team."
	icon_state = "ert_medical"
	item_state = "ert_medical"

/*
 * Satchel Types
 */

/obj/item/storage/backpack/satchel
	name = "satchel"
	desc = "A trendy looking satchel."
	icon = 'icons/obj/storage/satchel.dmi'
	icon_state = "satchel"
	item_state = "satchel"
	straps = TRUE

/obj/item/storage/backpack/satchel/leather/withwallet/New()
	..()
	new /obj/item/storage/wallet/random( src )

/obj/item/storage/backpack/satchel/hegemony
	name = "hegemony satchel"
	desc = "A rugged satchel with many pouches, seen commonly within the Hegemony Levies."
	icon = 'icons/obj/unathi_items.dmi'
	icon_state = "hegemony_satchel"
	item_state = "hegemony_satchel"
	max_storage_space = 32
	allow_quick_empty = FALSE // Pouches 'n shit.

/obj/item/storage/backpack/satchel/eng
	name = "industrial satchel"
	desc = "A tough satchel with extra pockets."
	icon_state = "satchel-eng"
	item_state = "satchel-eng"
	empty_delay = 0.8 SECOND

/obj/item/storage/backpack/satchel/med
	name = "medical satchel"
	desc = "A sterile satchel used in medical departments."
	icon_state = "satchel-med"
	item_state = "satchel-med"

/obj/item/storage/backpack/satchel/pharm
	name = "pharmacist satchel"
	desc = "A sterile satchel with pharmacist colours."
	icon_state = "satchel-chem"
	item_state = "satchel-chem"

/obj/item/storage/backpack/satchel/psych
	name = "psychiatrist satchel"
	desc = "A sterile satchel with psychiatrist colours."
	icon_state = "satchel-psych"
	item_state = "satchel-psych"

/obj/item/storage/backpack/satchel/emt
	name = "EMT's satchel"
	desc = "A sterile satchel with EMT colours."
	icon_state = "satchel-emt"
	item_state = "satchel-emt"

/obj/item/storage/backpack/satchel/tox
	name = "scientist satchel"
	desc = "Useful for holding research materials."
	icon_state = "satchel-tox"
	item_state = "satchel-tox"

/obj/item/storage/backpack/satchel/sec
	name = "security satchel"
	desc = "A robust satchel for security related needs."
	icon_state = "satchel-sec"
	item_state = "satchel-sec"

/obj/item/storage/backpack/satchel/hyd
	name = "hydroponics satchel"
	desc = "A green satchel for plant related work."
	icon_state = "satchel-hyd"
	item_state = "satchel-hyd"

/obj/item/storage/backpack/satchel/cap
	name = "captain's satchel"
	desc = "An exclusive satchel for officers."
	icon_state = "satchel-cap"
	item_state = "satchel-cap"
	empty_delay = 0.8 SECOND

/obj/item/storage/backpack/satchel/syndie
	name = "tactical satchel"
	desc = "A stylish satchel in the same hip and trendy color scheme as many pieces of combat equipment."
	icon_state = "satchel-syndie"
	item_state = "satchel-syndie"
	empty_delay = 0.8 SECOND

/obj/item/storage/backpack/satchel/cmo
	name = "CMO's satchel"
	desc = "An exclusive sterile satchel for only the most experienced of medical practicioners. Smells of chloral hydrate and singed cat fur."
	icon_state = "satchel-cmo"
	item_state = "satchel-cmo"
	empty_delay = 0.8 SECOND

/obj/item/storage/backpack/satchel/hos
	name = "HOS' satchel"
	desc = "A robust satchel, passed down through generations of officers sparring in the holodeck."
	icon_state = "satchel-hos"
	item_state = "satchel-hos"
	empty_delay = 0.8 SECOND

/obj/item/storage/backpack/satchel/ce
	name = "CE's satchel"
	desc = "A tough satchel with extra pockets. Awarded to those who have prevented utter annihilation through supermatter delamination or singularity collapse."
	icon_state = "satchel-ce"
	item_state = "satchel-ce"
	empty_delay = 0.8 SECOND

/obj/item/storage/backpack/satchel/rd
	name = "RD's satchel"
	desc = "Useful for holding research materials. Survived countless explosions of the Research department - can't say the same for the previous owners."
	icon_state = "satchel-rd"
	item_state = "satchel-rd"
	empty_delay = 0.8 SECOND

/obj/item/storage/backpack/satchel/om
	name = "OM's satchel"
	desc = "A satchel for holding trinkets and baubles found in the maintenance tunnels."
	icon_state = "satchel-om"
	item_state = "satchel-om"
	empty_delay = 0.8 SECOND

/obj/item/storage/backpack/satchel/zavod
	name = "zavodskoi satchel"
	icon_state = "satchel-zavod"
	item_state = "satchel-zavod"

/obj/item/storage/backpack/satchel/nt
	name = "nanotrasen satchel"
	icon_state = "satchel-nt"
	item_state = "satchel-nt"

/obj/item/storage/backpack/satchel/zeng
	name = "zeng-hu satchel"
	icon_state = "satchel-zeng"
	item_state = "satchel-zeng"

/obj/item/storage/backpack/satchel/heph
	name = "hephaestus satchel"
	icon_state = "satchel-heph"
	item_state = "satchel-heph"

/obj/item/storage/backpack/satchel/idris
	name = "idris satchel"
	icon_state = "satchel-idris"
	item_state = "satchel-idris"

/obj/item/storage/backpack/satchel/orion
	name = "orion satchel"
	icon_state = "satchel-orion"
	item_state = "satchel-orion"

/obj/item/storage/backpack/satchel/pmcg
	name = "PMCG backpack"
	icon_state = "satchel-pmcg"
	item_state = "satchel-pmcg"

/*
 * Colored satchels
 */

/obj/item/storage/backpack/satchel/leather
	name = "leather satchel"
	desc = "It's a very fancy satchel made with fine leather."
	icon_state = "satchel_leather"
	item_state = "satchel_leather"

/obj/item/storage/backpack/satchel/leather/recolorable
	icon_state = "satchel_leather_recolorable"
	item_state = "satchel_leather_recolorable"
	build_from_parts = TRUE
	worn_overlay = "overlay"

/obj/item/storage/backpack/satchel/leather/recolorable/Initialize()
	update_icon()
	. = ..()

/*
 * Colored pocketbooks
 */

/obj/item/storage/backpack/satchel/pocketbook
	name = "leather pocketbook"
	desc = "A neat little folding clasp pocketbook with a shoulder sling."
	icon_state = "pocketbook_leather"
	item_state = "pocketbook_leather"
	w_class = ITEMSIZE_HUGE // to avoid recursive backpacks
	slot_flags = SLOT_BACK
	max_w_class = ITEMSIZE_NORMAL
	max_storage_space = 20
	build_from_parts = TRUE
	worn_overlay = "overlay"

/obj/item/storage/backpack/satchel/pocketbook/Initialize()
	update_icon()
	. = ..()

/obj/item/storage/backpack/satchel/pocketbook/recolorable
	icon_state = "pocketbook"
	item_state = "pocketbook"

/obj/item/storage/backpack/satchel/pocketbook/purse
	name = "purse"
	desc = "A small, fashionable bag typically worn over the shoulder."
	icon_state = "purse"
	item_state = "purse"
	max_storage_space = 16
	straps = FALSE

// Duffel Bags

/obj/item/storage/backpack/duffel
	name = "duffel bag"
	desc = "A spacious duffel bag."
	icon = 'icons/obj/storage/duffelbag.dmi'
	icon_state = "duffel"
	item_state = "duffel"
	slowdown = 1
	max_storage_space = 38
	straps = TRUE

/obj/item/storage/backpack/duffel/cap
	name = "captain's duffel bag"
	desc = "A rare and special duffel bag for only the most air-headed of SCC personnel."
	icon_state = "duffel-captain"
	item_state = "duffel-captain"
	empty_delay = 0.8 SECOND

/obj/item/storage/backpack/duffel/hyd
	name = "botanist's duffel bag"
	desc = "A specially designed duffel bag for containing plant matter, regardless of how questionable it may be."
	icon_state = "duffel-hydroponics"
	item_state = "duffel-hydroponics"

/obj/item/storage/backpack/duffel/med
	name = "medical duffel bag"
	desc = "A sterilized duffel bag for the young, upcoming lesbayan."
	icon_state = "duffel-medical"
	item_state = "duffel-medical"

/obj/item/storage/backpack/duffel/eng
	name = "industrial duffel bag"
	desc = "A rough and tumble duffel bag for the hard working wrench-monkey of tomorrow."
	icon_state = "duffel-engineering"
	item_state = "duffel-engineering"
	empty_delay = 0.8 SECOND

/obj/item/storage/backpack/duffel/tox
	name = "scientist's duffel bag"
	desc = "Handy when it comes to storing volatile materials of the anomalous persuasion."
	icon_state = "duffel-tox"
	item_state = "duffel-tox"

/obj/item/storage/backpack/duffel/sec
	name = "security duffel bag"
	desc = "A grey and blue duffel bag for the boys in colour, with room for all the batons and flashbangs you could ever need."
	icon_state = "duffel-security"
	item_state = "duffel-security"

/obj/item/storage/backpack/duffel/pharm
	name = "pharmacy duffel bag"
	desc = "Spice up the love life a little."
	icon_state = "duffel-chemistry"
	item_state = "duffel-chemistry"

/obj/item/storage/backpack/duffel/psych
	name = "psychiatrist duffel bag"
	desc = "Perfect for storing a manner of weighted blankets and marketable plushies."
	icon_state = "duffel-psych"
	item_state = "duffel-psych"

/obj/item/storage/backpack/duffel/emt
	name = "EMT's duffel bag"
	desc = "Too bad you can't just stuff a person in here - that'll make your job too easy."
	icon_state = "duffel-emt"
	item_state = "duffel-emt"

/obj/item/storage/backpack/duffel/syndie
	name = "tactical duffel bag"
	desc = "A snazzy black and red duffel bag, perfect for smuggling C4 and Parapens. It seems to be made of a lighter material."
	icon_state = "duffel-syndie"
	item_state = "duffel-syndie"
	slowdown = 0
	empty_delay = 0.8 SECOND

/obj/item/storage/backpack/duffel/cmo
	name = "CMO's duffel"
	desc = "A sterilized duffel bag with enough space to lug around enough medical supplies to treat a small humanitarian effort."
	icon_state = "duffel-cmo"
	item_state = "duffel-cmo"
	empty_delay = 0.8 SECOND

/obj/item/storage/backpack/duffel/hos
	name = "HOS' duffel"
	desc = "A grey and blue duffel bag for the boys in colour. Time to teach the cadets how to charge their batons."
	icon_state = "duffel-hos"
	item_state = "duffel-hos"
	empty_delay = 0.8 SECOND

/obj/item/storage/backpack/duffel/ce
	name = "CE's duffel"
	desc = "A rough and tumble duffel bag with enough space to jerry-rig and barricade a break room into a saferoom."
	icon_state = "duffel-ce"
	item_state = "duffel-ce"
	empty_delay = 0.8 SECOND

/obj/item/storage/backpack/duffel/rd
	name = "RD's duffel"
	desc = "Useful for handling large anamolous materials, provided you follow standard insertion procedure."
	icon_state = "duffel-rd"
	item_state = "duffel-rd"
	empty_delay = 0.8 SECOND

/obj/item/storage/backpack/duffel/om
	name = "OM's duffel"
	desc = "Enough space to hold wealth beyond measure."
	icon_state = "duffel-om"
	item_state = "duffel-om"
	empty_delay = 0.8 SECOND

/obj/item/storage/backpack/duffel/zavod
	name = "zavodskoi duffel"
	icon_state = "duffel-zavod"
	item_state = "duffel-zavod"

/obj/item/storage/backpack/duffel/nt
	name = "nanotrasen duffel"
	icon_state = "duffel-nt"
	item_state = "duffel-nt"

/obj/item/storage/backpack/duffel/zeng
	name = "zeng-hu duffel"
	icon_state = "duffel-zeng"
	item_state = "duffel-zeng"

/obj/item/storage/backpack/duffel/heph
	name = "hephaestus duffel"
	icon_state = "duffel-heph"
	item_state = "duffel-heph"

/obj/item/storage/backpack/duffel/idris
	name = "idris duffel"
	icon_state = "duffel-idris"
	item_state = "duffel-idris"

/obj/item/storage/backpack/duffel/orion
	name = "orion duffel"
	icon_state = "duffel-orion"
	item_state = "duffel-orion"

/obj/item/storage/backpack/duffel/pmcg
	name = "PMCG duffel"
	icon_state = "duffel-pmcg"
	item_state = "duffel-pmcg"

/*
 * Messenger Bags
 */

/obj/item/storage/backpack/messenger
	name = "messenger bag"
	desc = "A sturdy backpack worn over one shoulder."
	icon = 'icons/obj/storage/courierbag.dmi'
	icon_state = "courierbag"
	item_state = "courierbag"
	straps = TRUE

/obj/item/storage/backpack/messenger/pharm
	name = "pharmacy messenger bag"
	desc = "A sterile backpack worn over one shoulder. This one is in pharmacy colors."
	icon_state = "courierbagchem"
	item_state = "courierbagchem"

/obj/item/storage/backpack/messenger/psych
	name = "psychiatrist messenger bag"
	desc = "A sterile backpack worn over one shoulder. This one is in psychiatrist colors."
	icon_state = "courierbagpsych"
	item_state = "courierbagpsych"

/obj/item/storage/backpack/messenger/emt
	name = "EMT's messenger bag"
	desc = "A sterile backpack worn over one shoulder. This one is in EMT colors."
	icon_state = "courierbagemt"
	item_state = "courierbagemt"

/obj/item/storage/backpack/messenger/med
	name = "medical messenger bag"
	desc = "A sterile backpack worn over one shoulder used in medical departments."
	icon_state = "courierbagmed"
	item_state = "courierbagmed"

/obj/item/storage/backpack/messenger/tox
	name = "research messenger bag"
	desc = "A backpack worn over one shoulder. Useful for holding science materials."
	icon_state = "courierbagtox"
	item_state = "courierbagtox"

/obj/item/storage/backpack/messenger/com
	name = "captain's messenger bag"
	desc = "A special backpack worn over one shoulder. This one is made specifically for command officers."
	icon_state = "courierbagcom"
	item_state = "courierbagcom"
	empty_delay = 0.8 SECOND

/obj/item/storage/backpack/messenger/engi
	name = "engineering messenger bag"
	desc = "A strong backpack worn over one shoulder. This one is designed for industrial work."
	icon_state = "courierbagengi"
	item_state = "courierbagengi"
	empty_delay = 0.8 SECOND

/obj/item/storage/backpack/messenger/hyd
	name = "hydroponics messenger bag"
	desc = "A backpack worn over one shoulder.  This one is designed for plant-related work."
	icon_state = "courierbaghyd"
	item_state = "courierbaghyd"

/obj/item/storage/backpack/messenger/sec
	name = "security messenger bag"
	desc = "A tactical backpack worn over one shoulder. This one is in security colors."
	icon_state = "courierbagsec"
	item_state = "courierbagsec"

/obj/item/storage/backpack/messenger/syndie
	name = "tactical messenger bag"
	desc = "A sturdy backpack worn over one shoulder. This one is in red and black menacing colors."
	icon_state = "courierbagsyndie"
	item_state = "courierbagsyndie"

/obj/item/storage/backpack/messenger/cmo
	name = "CMO's messenger bag"
	desc = "A sterile backpack worn over one shoulder. Useful for running after patients who haven't completely recovered."
	icon_state = "courierbagcmo"
	item_state = "courierbagcmo"
	empty_delay = 0.8 SECOND

/obj/item/storage/backpack/messenger/hos
	name = "HOS' messenger bag"
	desc = "A tactical backpack worn over one shoulder. The bag of choice for the people with murder as a dayjob."
	icon_state = "courierbaghos"
	item_state = "courierbaghos"
	empty_delay = 0.8 SECOND

/obj/item/storage/backpack/messenger/ce
	name = "CE's messenger bag"
	desc = "A strong backpack worn over one shoulder. Designed to withstand the pressures of a supermatter chamber and/or the stress of incompetent apprentices."
	icon_state = "courierbagce"
	item_state = "courierbagce"
	empty_delay = 0.8 SECOND

/obj/item/storage/backpack/messenger/rd
	name = "RD's messenger bag"
	desc = "A backpack worn over one shoulder. Also a good place to hide firing pins."
	icon_state = "courierbagrd"
	item_state = "courierbagrd"
	empty_delay = 0.8 SECOND

/obj/item/storage/backpack/messenger/om
	name = "OM's messenger bag"
	desc = "A sturdy backpack worn over one shoulder. Keep your Kinetic Accelerator close, and your approval stamp closer."
	icon_state = "courierbagom"
	item_state = "courierbagom"
	empty_delay = 0.8 SECOND

/obj/item/storage/backpack/messenger/zavod
	name = "zavodskoi messenger bag"
	icon_state = "courierbagzavod"
	item_state = "courierbagzavod"

/obj/item/storage/backpack/messenger/nt
	name = "nanotrasen messenger bag"
	icon_state = "courierbagnt"
	item_state = "courierbagnt"

/obj/item/storage/backpack/messenger/zeng
	name = "zeng-hu messenger bag"
	icon_state = "courierbagzeng"
	item_state = "courierbagzeng"

/obj/item/storage/backpack/messenger/heph
	name = "hephaestus messenger bag"
	icon_state = "courierbagheph"
	item_state = "courierbagheph"

/obj/item/storage/backpack/messenger/idris
	name = "idris messenger bag"
	icon_state = "courierbagidris"
	item_state = "courierbagidris"

/obj/item/storage/backpack/messenger/orion
	name = "orion messenger bag"
	icon_state = "courierbagorion"
	item_state = "courierbagorion"

/obj/item/storage/backpack/messenger/pmcg
	name = "PMCG messenger bag"
	icon_state = "courierbagpmcg"
	item_state = "courierbagpmcg"

/*
 * Rucksacks
 */

/obj/item/storage/backpack/rucksack
	name = "black rucksack"
	desc = "A sturdy, military-grade backpack with low-profile straps. Designed to work well with armor."
	icon = 'icons/obj/storage/rucksack.dmi'
	icon_state = "rucksack_black"
	item_state = "rucksack_black"

/obj/item/storage/backpack/rucksack/recolorable
	name = "rucksack"
	icon_state = "rucksack"
	item_state = "rucksack"
	build_from_parts = TRUE
	worn_overlay = "overlay"

/obj/item/storage/backpack/rucksack/recolorable/Initialize()
	update_icon()
	. = ..()

/obj/item/storage/backpack/rucksack/blue
	name = "blue rucksack"
	icon_state = "rucksack_blue"
	item_state = "rucksack_blue"

/obj/item/storage/backpack/rucksack/green
	name = "green rucksack"
	icon_state = "rucksack_green"
	item_state = "rucksack_green"

/obj/item/storage/backpack/rucksack/navy
	name = "navy rucksack"
	icon_state = "rucksack_navy"
	item_state = "rucksack_navy"

/obj/item/storage/backpack/rucksack/tan
	name = "tan rucksack"
	icon_state = "rucksack_tan"
	item_state = "rucksack_tan"

// Vaurca stuff.

/obj/item/storage/backpack/typec
	icon = 'icons/mob/species/breeder/inventory.dmi'
	name = "breeder zo'ra wings"
	desc = "The wings of a CB Caste Vaurca. They are far too small at this stage to permit sustained periods of flight in most situations."
	icon_state = "wings"
	item_state = "wings"
	contained_sprite = FALSE
	w_class = ITEMSIZE_HUGE
	slot_flags = SLOT_BACK
	max_storage_space = 12
	canremove = FALSE
	species_restricted = list(BODYTYPE_VAURCA_BREEDER)
	sprite_sheets = list(BODYTYPE_VAURCA_BREEDER = 'icons/mob/species/breeder/back.dmi')
	var/wings_extended = FALSE

/obj/item/storage/backpack/typec/verb/toggle_wings()
	set name = "Spread Wings"
	set desc = "Spread your wings."
	set category = "Object"
	set src in usr

	if(use_check_and_message(usr) || !ishuman(usr))
		return FALSE

	var/mob/living/carbon/human/user = usr

	wings_extended = !wings_extended
	playsound(src.loc, 'sound/items/storage/wings.ogg', 50)
	user.visible_message("<b>[user]</b> [wings_extended ? "extend" : "collapse"]s their wings.", SPAN_NOTICE("You [wings_extended ? "extend" : "collapse"] your wings."))
	icon_state = "[initial(icon_state)][wings_extended ? "_open" : ""]"
	item_state = "icon_state"

	user.update_icon()
	user.update_inv_back()

/obj/item/storage/backpack/typec/klax
	icon = 'icons/mob/species/breeder/inventory.dmi'
	name = "breeder k'lax wings"
	desc = "The wings of a CB Caste Vaurca. They are far too small at this stage to permit sustained periods of flight in most situations."
	icon_state = "wings_klax"
	item_state = "wings_klax"

/obj/item/storage/backpack/typec/cthur
	icon = 'icons/mob/species/breeder/inventory.dmi'
	name = "breeder c'thur wings"
	desc = "The wings of a CB Caste Vaurca. They are far too small at this stage to permit sustained periods of flight in most situations."
	icon_state = "wings_cthur"
	item_state = "wings_cthur"


//**Vaurca cloaks**//

/obj/item/storage/backpack/cloak
	name = "tunnel cloak"
	desc = "A Vaurca cloak with storage pockets."
	icon = 'icons/obj/vaurca_items.dmi'
	icon_state = "cape"
	item_state = "cape"
	contained_sprite = FALSE
	sprite_sheets = list(BODYTYPE_VAURCA = 'icons/mob/species/vaurca/back.dmi', BODYTYPE_VAURCA_BULWARK = 'icons/mob/species/bulwark/back.dmi')
	var/hooded = FALSE
	var/cape_backing_state = "cape_backing"

/obj/item/storage/backpack/cloak/verb/toggle_cloak_hood()
	set name = "Toggle Cloak Hood"
	set desc = "Toggle your cloak hood."
	set category = "Object"
	set src in usr
	if(use_check_and_message(usr))
		return 0
	hooded = !hooded
	to_chat(usr, "You [hooded ? "raise" : "lower"] \the [src] hood.")
	icon_state = "[initial(icon_state)][hooded ? "_up" : ""]"
	item_state = "icon_state"
	var/mob/living/carbon/human/H = src.loc
	H.update_icon()
	H.update_inv_back()

/obj/item/storage/backpack/cloak/get_mob_overlay(var/mob/living/carbon/human/human, var/mob_icon, var/mob_state, var/slot)
	var/image/I = ..()
	var/image/cape_backing = image(mob_icon, null, "[icon_state]_backing", MOB_SHADOW_LAYER)
	I.add_overlay(cape_backing)
	return I

/obj/item/storage/backpack/cloak/sedantis
	name = "Sedantis tunnel cloak"
	desc = "A Vaurca cloak with storage pockets. This one has the Sedantis flag design."
	icon_state = "sedcape"
	item_state = "sedcape"

/obj/item/storage/backpack/cloak/medical
	name = "medical tunnel cloak"
	desc = "A Vaurca cloak with storage pockets. This one has the medical department design."
	icon_state = "medcape"
	item_state = "medcape"

/obj/item/storage/backpack/cloak/engi
	name = "engineering tunnel cloak"
	desc = "A Vaurca cloak with storage pockets. This one has the engineering department design."
	icon_state = "engicape"
	item_state = "engicape"

/obj/item/storage/backpack/cloak/atmos
	name = "atmospherics tunnel cloak"
	desc = "A Vaurca cloak with storage pockets. This one has the atmospherics design."
	icon_state = "atmoscape"
	item_state = "atmoscape"

/obj/item/storage/backpack/cloak/cargo
	name = "operations tunnel cloak"
	desc = "A Vaurca cloak with storage pockets. This one has the operations department design."
	icon_state = "cargocape"
	item_state = "cargocape"

/obj/item/storage/backpack/cloak/sci
	name = "science tunnel cloak"
	desc = "A Vaurca cloak with storage pockets. This one has the science department design."
	icon_state = "scicape"
	item_state = "scicape"

/obj/item/storage/backpack/cloak/sec
	name = "security tunnel cloak"
	desc = "A Vaurca cloak with storage pockets. This one has the security department design."
	icon_state = "seccape"
	item_state = "seccape"

/obj/item/storage/backpack/cloak/zora
	name = "\improper Zo'ra tunnel cloak"
	desc = "A Vaurca cloak with storage pockets. This one has the Zo'ra Hive flag design."
	icon_state = "zoracape"
	item_state = "zoracape"

/obj/item/storage/backpack/cloak/klax
	name = "\improper K'lax tunnel cloak"
	desc = "A Vaurca cloak with storage pockets. This one has the K'lax Hive flag design."
	icon_state = "klaxcape"
	item_state = "klaxcape"

/obj/item/storage/backpack/cloak/cthur
	name = "\improper C'thur tunnel cloak"
	desc = "A Vaurca cloak with storage pockets. This one has the C'thur Hive flag design."
	icon_state = "cthurcape"
	item_state = "cthurcape"

/obj/item/storage/backpack/kala
	name = "skrell backpack"
	desc = "A lightly padded, waterproof backpack worn by Skrell."
	icon = 'icons/clothing/kit/skrell_armor.dmi'
	icon_state = "kala_backpack"
	item_state = "kala_backpack"
	contained_sprite = TRUE

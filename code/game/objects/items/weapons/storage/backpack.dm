
/*
 * Backpack
 */

/obj/item/weapon/storage/backpack
	name = "backpack"
	desc = "You wear this on your back and put items into it."
	item_icons = list(//ITEM_ICONS ARE DEPRECATED. USE CONTAINED SPRITES IN FUTURE
		slot_l_hand_str = 'icons/mob/items/lefthand_backpacks.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_backpacks.dmi'
		)
	icon_state = "backpack"
	item_state = null
	//most backpacks use the default backpack state for inhand overlays
	item_state_slots = list(
		slot_l_hand_str = "backpack",
		slot_r_hand_str = "backpack"
		)
	sprite_sheets = list(
		"Resomi" = 'icons/mob/species/resomi/back.dmi'
		)
	w_class = 4
	slot_flags = SLOT_BACK
	max_w_class = 3
	max_storage_space = 28
	var/species_restricted = list("exclude","Vaurca Breeder","Vaurca Warform")

/obj/item/weapon/storage/backpack/mob_can_equip(M as mob, slot)

	//if we can't equip the item anyway, don't bother with species_restricted (cuts down on spam)
	if (!..())
		return 0

	if(species_restricted && istype(M,/mob/living/carbon/human))
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
				H << "<span class='danger'>Your species cannot wear [src].</span>"
				return 0
	return 1

/obj/item/weapon/storage/backpack/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (src.use_sound)
		playsound(src.loc, src.use_sound, 50, 1, -5)
	..()

/obj/item/weapon/storage/backpack/equipped(var/mob/user, var/slot)
	if (slot == slot_back && src.use_sound)
		playsound(src.loc, src.use_sound, 50, 1, -5)
	..(user, slot)

/*
/obj/item/weapon/storage/backpack/dropped(mob/user as mob)
	if (loc == user && src.use_sound)
		playsound(src.loc, src.use_sound, 50, 1, -5)
	..(user)
*/

/*
 * Backpack Types
 */

/obj/item/weapon/storage/backpack/holding
	name = "bag of holding"
	desc = "A backpack that opens into a localized pocket of Blue Space."
	origin_tech = list(TECH_BLUESPACE = 4)
	icon_state = "holdingpack"
	max_w_class = 4
	max_storage_space = 56
	storage_cost = 29
	item_state_slots = list(
		slot_l_hand_str = "holdingpack",
		slot_r_hand_str = "holdingpack"
		)

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(istype(W, /obj/item/weapon/storage/backpack/holding))
			user << "<span class='warning'>The Bluespace interfaces of the two devices conflict and malfunction.</span>"
			qdel(W)
			return
		..()

	//Please don't clutter the parent storage item with stupid hacks.
	can_be_inserted(obj/item/W as obj, stop_messages = 0)
		if(istype(W, /obj/item/weapon/storage/backpack/holding))
			return 1
		return ..()

/obj/item/weapon/storage/backpack/santabag
	name = "\improper Santa's gift bag"
	desc = "Space Santa uses this to deliver toys to all the nice children in space in Christmas! Wow, it's pretty big!"
	icon_state = "giftbag0"
	item_state = "giftbag"
	w_class = 4.0
	max_w_class = 3
	max_storage_space = 400 // can store a ton of shit!
	item_state_slots = null

/obj/item/weapon/storage/backpack/cultpack
	name = "trophy rack"
	desc = "It's useful for both carrying extra gear and proudly declaring your insanity."
	icon_state = "cultpack"

/obj/item/weapon/storage/backpack/clown
	name = "Giggles von Honkerton"
	desc = "It's a backpack made by Honk! Co."
	icon_state = "clownpack"
	item_state_slots = null

/obj/item/weapon/storage/backpack/medic
	name = "medical backpack"
	desc = "It's a backpack especially designed for use in a sterile environment."
	icon_state = "medicalpack"
	item_state_slots = null

/obj/item/weapon/storage/backpack/security
	name = "security backpack"
	desc = "It's a very robust backpack."
	icon_state = "securitypack"
	item_state_slots = null

/obj/item/weapon/storage/backpack/captain
	name = "captain's backpack"
	desc = "It's a special backpack made exclusively for officers."
	icon_state = "captainpack"
	item_state_slots = null

/obj/item/weapon/storage/backpack/industrial
	name = "industrial backpack"
	desc = "It's a tough backpack for the daily grind of station life."
	icon_state = "engiepack"
	item_state_slots = null

/obj/item/weapon/storage/backpack/toxins
	name = "laboratory backpack"
	desc = "It's a light backpack modeled for use in laboratories and other scientific institutions."
	icon_state = "toxpack"

/obj/item/weapon/storage/backpack/hydroponics
	name = "herbalist's backpack"
	desc = "It's a green backpack with many pockets to store plants and tools in."
	icon_state = "hydpack"

/obj/item/weapon/storage/backpack/genetics
	name = "geneticist backpack"
	desc = "It's a backpack fitted with slots for diskettes and other workplace tools."
	icon_state = "genpack"

/obj/item/weapon/storage/backpack/virology
	name = "sterile backpack"
	desc = "It's a sterile backpack able to withstand different pathogens from entering its fabric."
	icon_state = "viropack"

/obj/item/weapon/storage/backpack/chemistry
	name = "chemistry backpack"
	desc = "It's an orange backpack which was designed to hold beakers, pill bottles and bottles."
	icon_state = "chempack"

/obj/item/weapon/storage/backpack/cloak
	name = "tunnel cloak"
	desc = "It's a Vaurca cloak, with paltry storage options."
	icon_state = "cape"
	max_storage_space = 12
	sprite_sheets = list("Vaurca" = 'icons/mob/species/vaurca/back.dmi')

/obj/item/weapon/storage/backpack/syndie
	name = "syndicate rucksack"
	desc = "The latest in carbon fiber and red satin combat rucksack technology. Comfortable and tough!"
	icon_state = "syndiepack"

/obj/item/weapon/storage/backpack/wizard
	name = "wizard federation sack"
	desc = "Perfect for keeping your shining crystal balls inside of."
	icon_state = "wizardpack"

/*
 * Satchel Types
 */

/obj/item/weapon/storage/backpack/satchel
	name = "leather satchel"
	desc = "It's a very fancy satchel made with fine leather."
	icon_state = "satchel"
	item_state_slots = list(
		slot_l_hand_str = "satchel",
		slot_r_hand_str = "satchel"
		)

/obj/item/weapon/storage/backpack/satchel/withwallet
	New()
		..()
		new /obj/item/weapon/storage/wallet/random( src )

/obj/item/weapon/storage/backpack/satchel_norm
	name = "satchel"
	desc = "A trendy looking satchel."
	icon_state = "satchel-norm"

/obj/item/weapon/storage/backpack/satchel_eng
	name = "industrial satchel"
	desc = "A tough satchel with extra pockets."
	icon_state = "satchel-eng"
	item_state_slots = list(
		slot_l_hand_str = "engiepack",
		slot_r_hand_str = "engiepack"
		)

/obj/item/weapon/storage/backpack/satchel_med
	name = "medical satchel"
	desc = "A sterile satchel used in medical departments."
	icon_state = "satchel-med"
	item_state_slots = list(
		slot_l_hand_str = "medicalpack",
		slot_r_hand_str = "medicalpack"
		)

/obj/item/weapon/storage/backpack/satchel_vir
	name = "virologist satchel"
	desc = "A sterile satchel with virologist colours."
	icon_state = "satchel-vir"

/obj/item/weapon/storage/backpack/satchel_chem
	name = "chemist satchel"
	desc = "A sterile satchel with chemist colours."
	icon_state = "satchel-chem"

/obj/item/weapon/storage/backpack/satchel_gen
	name = "geneticist satchel"
	desc = "A sterile satchel with geneticist colours."
	icon_state = "satchel-gen"

/obj/item/weapon/storage/backpack/satchel_tox
	name = "scientist satchel"
	desc = "Useful for holding research materials."
	icon_state = "satchel-tox"

/obj/item/weapon/storage/backpack/satchel_sec
	name = "security satchel"
	desc = "A robust satchel for security related needs."
	icon_state = "satchel-sec"
	item_state_slots = list(
		slot_l_hand_str = "securitypack",
		slot_r_hand_str = "securitypack"
		)

/obj/item/weapon/storage/backpack/satchel_hyd
	name = "hydroponics satchel"
	desc = "A green satchel for plant related work."
	icon_state = "satchel_hyd"

/obj/item/weapon/storage/backpack/satchel_cap
	name = "captain's satchel"
	desc = "An exclusive satchel for officers."
	icon_state = "satchel-cap"
	item_state_slots = list(
		slot_l_hand_str = "satchel-cap",
		slot_r_hand_str = "satchel-cap"
		)

/obj/item/weapon/storage/backpack/satchel_syndie
	name = "syndicate satchel"
	desc = "A satchel in the new age style of a multi-corperate terrorist organisation."
	icon_state = "satchel-syndie"

/obj/item/weapon/storage/backpack/satchel_wizard
	name = "wizard federation satchel"
	desc = "This stylish satchel will put a spell on anyone with some fashion sense to spare."
	icon_state = "satchel-wizard"

//ERT backpacks.
/obj/item/weapon/storage/backpack/ert
	name = "emergency response team backpack"
	desc = "A spacious backpack with lots of pockets, used by members of the Emergency Response Team."
	icon_state = "ert_commander"
	item_state_slots = list(
		slot_l_hand_str = "securitypack",
		slot_r_hand_str = "securitypack"
		)

//Commander
/obj/item/weapon/storage/backpack/ert/commander
	name = "emergency response team commander backpack"
	desc = "A spacious backpack with lots of pockets, worn by the commander of an Emergency Response Team."

//Security
/obj/item/weapon/storage/backpack/ert/security
	name = "emergency response team security backpack"
	desc = "A spacious backpack with lots of pockets, worn by security members of an Emergency Response Team."
	icon_state = "ert_security"

//Engineering
/obj/item/weapon/storage/backpack/ert/engineer
	name = "emergency response team engineer backpack"
	desc = "A spacious backpack with lots of pockets, worn by engineering members of an Emergency Response Team."
	icon_state = "ert_engineering"

//Medical
/obj/item/weapon/storage/backpack/ert/medical
	name = "emergency response team medical backpack"
	desc = "A spacious backpack with lots of pockets, worn by medical members of an Emergency Response Team."
	icon_state = "ert_medical"

// Duffel Bags

/obj/item/weapon/storage/backpack/duffel
	name = "duffel bag"
	desc = "A spacious duffel bag."
	icon_state = "duffel-norm"
	item_state_slots = list(
		slot_l_hand_str = "duffle",
		slot_r_hand_str = "duffle"
	)
	slowdown = 1
	max_storage_space = 38

/obj/item/weapon/storage/backpack/duffel/cap
	name = "captain's duffel bag"
	desc = "A rare and special duffel bag for only the most air-headed of Nanotrasen personnel."
	icon_state = "duffel-captain"
	item_state_slots = list(
		slot_l_hand_str = "duffle_captain",
		slot_r_hand_str = "duffle_captain"
	)

/obj/item/weapon/storage/backpack/duffel/hyd
	name = "botanist's duffel bag"
	desc = "A specially designed duffel bag for containing plant matter, regardless of how questionable it may be."
	icon_state = "duffel-hydroponics"

/obj/item/weapon/storage/backpack/duffel/vir
	name = "virology duffel bag"
	desc = "A sterilized duffel bag suited to those about to unleash pathogenic havoc upon the world."
	icon_state = "duffel-virology"
	item_state_slots = list(
		slot_l_hand_str = "duffle_med",
		slot_r_hand_str = "duffle_med"
	)

/obj/item/weapon/storage/backpack/duffel/med
	name = "medical duffel bag"
	desc = "A sterilized duffel bag for the young, upcoming lesbayan."
	icon_state = "duffel-medical"
	item_state_slots = list(
		slot_l_hand_str = "duffle_med",
		slot_r_hand_str = "duffle_med"
	)

/obj/item/weapon/storage/backpack/duffel/eng
	name = "industrial duffel bag"
	desc = "A rough and tumble duffel bag for the hard working wrench-monkey of tomorrow."
	icon_state = "duffel-engineering"
	item_state_slots = list(
		slot_l_hand_str = "duffle_eng",
		slot_r_hand_str = "duffle_eng"
	)

/obj/item/weapon/storage/backpack/duffel/tox
	name = "scientist's duffel bag"
	desc = "Handy when it comes to storing volatile materials of the anomalous persuasion."
	icon_state = "duffel-toxins"

/obj/item/weapon/storage/backpack/duffel/sec
	name = "security duffel bag"
	desc = "A grey and blue duffel bag for the boys in colour, with room for all the batons and flashbangs you could ever need."
	icon_state = "duffel-security"

/obj/item/weapon/storage/backpack/duffel/gen
	name = "genetics duffel bag"
	desc = "It sure won't hold your genes together, but it'll keep the denim ones safe."
	icon_state = "duffel-genetics"

/obj/item/weapon/storage/backpack/duffel/chem
	name = "chemistry duffel bag"
	desc = "Spice up the love life a little."
	icon_state = "duffel-chemistry"
	item_state_slots = list(
		slot_l_hand_str = "duffle_med",
		slot_r_hand_str = "duffle_med"
	)

/obj/item/weapon/storage/backpack/duffel/syndie
	name = "syndicate duffel bag"
	desc = "A snazzy black and red duffel bag, perfect for smuggling C4 and Parapens. It seems to be made of a lighter material."
	icon_state = "duffel-syndie"
	item_state_slots = list(
		slot_l_hand_str = "duffle_syndie",
		slot_r_hand_str = "duffle_syndie"
	)
	slowdown = 0

/obj/item/weapon/storage/backpack/duffel/wizard
	name = "wizardly duffel bag"
	desc = "A fancy blue wizard bag, duffel edition."
	icon_state = "duffel-wizard"
	slowdown = 0

/*
 * Messenger Bags
 */

/obj/item/weapon/storage/backpack/messenger
	name = "messenger bag"
	desc = "A sturdy backpack worn over one shoulder."
	icon_state = "courierbag"

/obj/item/weapon/storage/backpack/messenger/chem
	name = "chemistry messenger bag"
	desc = "A serile backpack worn over one shoulder.  This one is in chemsitry colors."
	icon_state = "courierbagchem"

/obj/item/weapon/storage/backpack/messenger/med
	name = "medical messenger bag"
	desc = "A sterile backpack worn over one shoulder used in medical departments."
	icon_state = "courierbagmed"

/obj/item/weapon/storage/backpack/messenger/viro
	name = "virology messenger bag"
	desc = "A sterile backpack worn over one shoulder.  This one is in virology colors."
	icon_state = "courierbagviro"

/obj/item/weapon/storage/backpack/messenger/tox
	name = "research messenger bag"
	desc = "A backpack worn over one shoulder.  Useful for holding science materials."
	icon_state = "courierbagtox"

/obj/item/weapon/storage/backpack/messenger/gen
	name = "geneticist messenger bag"
	desc = "A backpack worn over one shoulder.  Useful for holding DNA injectors and data disks."
	icon_state = "courierbaggenetics"

/obj/item/weapon/storage/backpack/messenger/com
	name = "captain's messenger bag"
	desc = "A special backpack worn over one shoulder.  This one is made specifically for command officers."
	icon_state = "courierbagcom"

/obj/item/weapon/storage/backpack/messenger/engi
	name = "engineering messenger bag"
	desc = "A strong backpack worn over one shoulder. This one is designed for industrial work."
	icon_state = "courierbagengi"

/obj/item/weapon/storage/backpack/messenger/hyd
	name = "hydroponics messenger bag"
	desc = "A backpack worn over one shoulder.  This one is designed for plant-related work."
	icon_state = "courierbaghyd"

/obj/item/weapon/storage/backpack/messenger/sec
	name = "security messenger bag"
	desc = "A tactical backpack worn over one shoulder. This one is in security colors."
	icon_state = "courierbagsec"

/obj/item/weapon/storage/backpack/messenger/syndie
	name = "syndicate messenger bag"
	desc = "A sturdy backpack worn over one shoulder. This one is in red and black menacing colors."
	icon_state = "courierbagsyndie"

/obj/item/weapon/storage/backpack/messenger/wizard
	name = "wizardly messenger bag"
	desc = "A wizardly backpack worn over one shoulder. This one is in blue and purple colors."
	icon_state = "courierbagwizard"

/obj/item/weapon/storage/backpack/legion
	name = "military rucksack"
	desc = "A sturdy backpack with the emblems and markings of the Tau Ceti Foreign Legion."
	icon_state = "legion_bag"
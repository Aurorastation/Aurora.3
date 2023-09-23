// Chemical, Biological, Radiological ~~and Nuclear~~ Weapons
/datum/uplink_item/item/bioweapons
	category = /datum/uplink_category/bioweapons

/datum/uplink_item/item/bioweapons/random_toxin
	name = "Random Toxins Kit"
	desc = "A kit that contains 3 vials containing random toxins. Comes with a syringe!"
	telecrystal_cost = 1
	path = /obj/item/storage/box/syndie_kit/toxin

/datum/uplink_item/item/bioweapons/nerveworms_kit
	name = "Parasitic Worms Kit - Nerve Fluke"
	desc = "Contains the eggs of a Nerve Fluke. Non-lethal but incapacitating."
	telecrystal_cost = 3
	path = /obj/item/storage/box/syndie_kit/nerveworms

/datum/uplink_item/item/bioweapons/heartworms_kit
	name = "Parasitic Worms Kit - Heart Fluke"
	desc = "Contains the eggs of a Heart Fluke. Lethal if left untreated."
	telecrystal_cost = 5
	path = /obj/item/storage/box/syndie_kit/heartworms

/datum/uplink_item/item/bioweapons/greimorian_eggs
	name = "Greimorian Eggs"
	desc = "A cluster of greimorian eggs. (They will be planted at your feet on-purchase and CANNOT be moved, so make sure you're where you want them to be)"
	telecrystal_cost = 4
	path = /obj/effect/spider/eggcluster

/datum/uplink_item/item/bioweapons/radsuit
	name = "Radiation Suit"
	desc = "A kit containing a radiation suit. Complete with a geiger counter and one anti-radiation tablet."
	telecrystal_cost = 1
	bluecrystal_cost = 1
	path = /obj/item/storage/box/syndie_kit/radsuit

/datum/uplink_item/item/bioweapons/dirtybomb
	name = "Dirty Bomb"
	desc = "A small explosive laced with radium. The explosion is small, but the radioactive will affect a large area for a while (10 minutes approx)."
	telecrystal_cost = 4
	path = /obj/item/plastique/dirty

/datum/uplink_item/item/bioweapons/syringe_gun
	name = "Syringe Gun Kit"
	desc = "A kit containing a syringe gun and 3 disassembled darts. Fill a syringe, add it to a dart, then load into the rifle."
	telecrystal_cost = 3
	bluecrystal_cost = 3
	path = /obj/item/storage/box/syndie_kit/syringe_gun

/datum/uplink_item/item/bioweapons/chlorine_tank
	name = "Chlorine Gas Tank"
	desc = "A Chlorine gas tank, a poisonous gas firstly mass produced on Earth for warfare uses, thanks to the research of Haber. At a premium, you can now wage \
	your personal chemical warfare. Make sure the wind blows in the right direction, and wear the appropriate PPEs."
	telecrystal_cost = 5
	path = /obj/machinery/portable_atmospherics/canister/chlorine

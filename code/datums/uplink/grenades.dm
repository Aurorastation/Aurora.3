/***********
* Grenades *
************/
/datum/uplink_item/item/grenades
	category = /datum/uplink_category/grenades

/datum/uplink_item/item/grenades/manhack
	name = "Viscerator Delivery Grenade"
	telecrystal_cost = 2
	path = /obj/item/grenade/spawnergrenade/manhacks
	desc = "A grenade that deploys three viscerator combat drones. Deadly in numbers, will not attack you or your allies."

/datum/uplink_item/item/grenades/lubed_manhack
	name = "Lubed Viscerator Delivery Grenade"
	telecrystal_cost = 3
	path = /obj/item/grenade/spawnergrenade/manhacks/lubed
	desc = "A grenade that deploys three lubed viscerator combat drones. Deadly in numbers, will not attack you or your allies. Works best when killed."

/datum/uplink_item/item/grenades/smoke
	name = "5xSmoke Grenades"
	telecrystal_cost = 1
	bluecrystal_cost = 1
	path = /obj/item/storage/box/smokes
	desc = "A box of five grenades that deploy smoke in the thrown area. Targets hidden in smoke are much harder to hit with ranged weaponry."

/datum/uplink_item/item/grenades/emp
	name = "5xEMP Grenades"
	telecrystal_cost = 2
	path = /obj/item/storage/box/emps
	desc = "A box of five grenades that cause a risky EMP explosion, capable of toggling headsets off, permanently destroying IPC units and draining a stationbound completely."

/datum/uplink_item/item/grenades/frag
	name = "5xFrag Grenades"
	telecrystal_cost = 6
	path = /obj/item/storage/box/frags

/datum/uplink_item/item/grenades/cardox
	name = "5xCardox Grenades"
	telecrystal_cost = 2
	path = /obj/item/storage/box/cardox
	desc = "A box of five grenades that deploy cardox smoke in the thrown area. This smoke is incredibly toxic, especially to vaurca. It can also clear K'ois outbreaks with ease."

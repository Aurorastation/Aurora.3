/***************
* Telecrystals *
***************/
/datum/uplink_item/item/telecrystal
	category = /datum/uplink_category/crystals
	desc = "Acquire the uplink telecrystals in pure form."

/datum/uplink_item/item/telecrystal/get_goods(var/obj/item/device/uplink/U, var/loc)
	return new /obj/item/stack/telecrystal(loc, telecrystal_cost(U.telecrystals))

/datum/uplink_item/item/telecrystal/one
	name = "Telecrystal - 01"
	telecrystal_cost = 1

/datum/uplink_item/item/telecrystal/five
	name = "Telecrystals - 05"
	telecrystal_cost = 5

/datum/uplink_item/item/telecrystal/ten
	name = "Telecrystals - 10"
	telecrystal_cost = 10

/datum/uplink_item/item/telecrystal/twentyfive
	name = "Telecrystals - 25"
	telecrystal_cost = 25

/datum/uplink_item/item/telecrystal/all
	name = "Telecrystals - Empty Uplink"
	telecrystal_cost = 1

/datum/uplink_item/item/telecrystal/all/telecrystal_cost(var/telecrystals)
	return max(1, telecrystals)

/datum/uplink_item/item/bluecrystal
	category = /datum/uplink_category/crystals
	desc = "Acquire the uplink bluecrystals in pure form."

/datum/uplink_item/item/bluecrystal/get_goods(var/obj/item/device/uplink/U, var/loc)
	return new /obj/item/stack/telecrystal/blue(loc, bluecrystal_cost(U.bluecrystals))

/datum/uplink_item/item/bluecrystal/one
	name = "Bluecrystals - 01"
	bluecrystal_cost = 1

/datum/uplink_item/item/bluecrystal/five
	name = "Bluecrystals - 05"
	bluecrystal_cost = 5

/datum/uplink_item/item/bluecrystal/ten
	name = "Bluecrystals - 10"
	bluecrystal_cost = 10

/datum/uplink_item/item/bluecrystal/twentyfive
	name = "Bluecrystals - 25"
	bluecrystal_cost = 25

/datum/uplink_item/item/bluecrystal/all
	name = "Bluecrystals - Empty Uplink"
	bluecrystal_cost = 1

/datum/uplink_item/item/bluecrystal/all/bluecrystal_cost(var/bluecrystals)
	return max(1, bluecrystals)


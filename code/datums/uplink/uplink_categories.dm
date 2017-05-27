/datum/uplink_category
	var/name = ""
	var/list/datum/uplink_item/items
	var/list/datum/antagonist/antag_roles = list() // added this so category wide restrictions can be placed to make it eaiser to set restrictions


/datum/uplink_category/New()
	..()
	items = list()

/datum/uplink_category/proc/can_view(obj/item/device/uplink/U)
	for(var/datum/uplink_item/item in items)
		if(item.can_view(U))
			return 1

	if(!U || !antag_roles.len)
		return 1

	if(!U.uplink_owner)
		return 0

	for(var/antag_role in antag_roles)
		var/datum/antagonist/antag = all_antag_types[antag_role]
		if(antag.is_antagonist(U.uplink_owner))
			return 1
	return 0

/datum/uplink_category/ammunition
	name = "Ammunition"
	antag_roles = list(MODE_MERCENARY, MODE_TRAITOR)


/datum/uplink_category/grenades
	name = "Grenades and Thrown Objects"
	antag_roles = list(MODE_MERCENARY, MODE_TRAITOR)

/datum/uplink_category/visible_weapons
	name = "Highly Visible and Dangerous Weapons"
	antag_roles = list(MODE_MERCENARY, MODE_TRAITOR)

/datum/uplink_category/stealthy_weapons
	name = "Stealthy and Inconspicuous Weapons"
	antag_roles = list(MODE_MERCENARY, MODE_TRAITOR)

/datum/uplink_category/stealth_items
	name = "Stealth and Camouflage Items"
	antag_roles = list(MODE_MERCENARY, MODE_TRAITOR)

/datum/uplink_category/tools
	name = "Devices and Tools"
	antag_roles = list(MODE_MERCENARY, MODE_TRAITOR)

/datum/uplink_category/implants
	name = "Implants"
	antag_roles = list(MODE_MERCENARY, MODE_TRAITOR)

/datum/uplink_category/medical
	name = "Medical"
	antag_roles = list(MODE_MERCENARY, MODE_TRAITOR)

/datum/uplink_category/hardsuit_modules
	name = "Hardsuit Modules"
	antag_roles = list(MODE_MERCENARY, MODE_TRAITOR)

/datum/uplink_category/services
	name = "Services"
	antag_roles = list(MODE_MERCENARY, MODE_TRAITOR)

/datum/uplink_category/badassery
	name = "Badassery"
	antag_roles = list(MODE_MERCENARY, MODE_TRAITOR)

/datum/uplink_category/telecrystals
	name = "Telecrystals"

/datum/uplink_category/ninja_modules
	name = "Special Modules"
	antag_roles = list(MODE_NINJA)


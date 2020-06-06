// Weapon exports. Stun batons, disablers, etc.

/datum/export/weapon
	include_subtypes = FALSE

/datum/export/weapon/baton
	cost = 100
	unit_name = "stun baton"
	export_types = list(/obj/item/melee/baton/)
	exclude_types = list(/obj/item/melee/baton/cattleprod)
	include_subtypes = TRUE

/datum/export/weapon/knife
	cost = 100
	unit_name = "tactical knife"
	export_types = list(/obj/item/material/knife/tacknife )

/datum/export/weapon/laser
	cost = 200
	unit_name = "laser gun"
	export_types = list(/obj/item/gun/energy/rifle/laser)

/datum/export/weapon/energy_gun
	cost = 300
	unit_name = "energy gun"
	export_types = list(/obj/item/gun/energy/gun)

/datum/export/weapon/flashbang
	cost = 5
	unit_name = "flashbang grenade"
	export_types = list(/obj/item/grenade/flashbang)

/datum/export/weapon/teargas
	cost = 5
	unit_name = "tear gas grenade"
	export_types = list(/obj/item/grenade/chem_grenade/teargas)


/datum/export/weapon/flash
	cost = 5
	unit_name = "handheld flash"
	export_types = list(/obj/item/device/flash)
	include_subtypes = TRUE

/datum/export/weapon/handcuffs
	cost = 3
	unit_name = "pair"
	message = "of handcuffs"
	export_types = list(/obj/item/handcuffs)
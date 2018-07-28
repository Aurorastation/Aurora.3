/obj/item/device/flash/full
	cell_type = /obj/item/weapon/cell
	bulb_type = /obj/item/weapon/flash_bulb/

/obj/item/device/flash/weak/
	bulb_type = /obj/item/weapon/flash_bulb/weak

/obj/item/device/flash/weak/full
	cell_type = /obj/item/weapon/cell/crap

/obj/item/device/flash/immortal //For rigsuits
	cell_type = /obj/item/weapon/cell/secborg
	bulb_type = /obj/item/weapon/flash_bulb/immortal
	no_tamper = TRUE
	use_external_power = TRUE

/obj/item/device/flash/cyborg
	bulb_type = /obj/item/weapon/flash_bulb/cyborg
	cell_type = /obj/item/weapon/cell/secborg
	no_tamper = TRUE
	use_external_power = TRUE

/obj/item/weapon/flash_bulb/weak //Get these from the autolathe.
	name = "weak flash bulb"
	desc = "A small bulb built to be fit inside a flash. This one is cheaply made."
	icon_state = "bulb_weak"
	strength = 0.75
	build_name = "budget flash"
	heat_damage_to_add = 1
	max_heat_damage = 2
	cooldown_delay = 30 SECONDS

	matter = list("glass" = 500)

/obj/item/weapon/flash_bulb/cyborg
	name = "cyborg flash bulb"
	desc = "A small bulb built to be fit inside a flash. This one is meant for cyborgs, as it can easily be repaired by nanites."
	icon_state = "bulb_strong"
	build_name = "cyborg flash"

/obj/item/weapon/flash_bulb/immortal //These never break.
	name = "immortal flash bulb"
	desc = "What cruel god created these?"
	icon_state = "bulb_immortal"
	strength = 1
	build_name = "immortal"
	heat_damage_to_add = 0
	max_heat_damage = 100
	cooldown_delay = 0
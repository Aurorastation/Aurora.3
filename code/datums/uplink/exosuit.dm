/datum/uplink_item/item/exosuit
	category = /datum/uplink_category/exosuit

/datum/uplink_item/item/exosuit/combat/New()
	name = "Combat Exosuit Dropper"
	desc = "A device that can be used to drop in a combat exosuit. Can only be used outside [SSatlas.current_map.station_name] areas, unless emagged, which is hazardous."
	telecrystal_cost = 25
	path = /obj/item/device/orbital_dropper/mecha/combat

/datum/uplink_item/item/exosuit/heavy/New()
	name = "Heavy Exosuit Dropper"
	desc = "A device that can be used to drop in a heavy exosuit. Can only be used outside [SSatlas.current_map.station_name] areas, unless emagged, which is hazardous."
	telecrystal_cost = 20
	path = /obj/item/device/orbital_dropper/mecha/heavy

/datum/uplink_item/item/exosuit/light/New()
	name = "Light Exosuit Dropper"
	desc = "A device that can be used to drop in a light exosuit. Can only be used outside [SSatlas.current_map.station_name] areas, unless emagged, which is hazardous."
	telecrystal_cost = 15
	path = /obj/item/device/orbital_dropper/mecha

/datum/uplink_item/item/exosuit/powerloader/New()
	name = "Powerloader Exosuit Dropper"
	desc = "A device that can be used to drop in a powerloader exosuit. Can only be used outside [SSatlas.current_map.station_name] areas, unless emagged, which is hazardous."
	telecrystal_cost = 10
	path = /obj/item/device/orbital_dropper/mecha/powerloader

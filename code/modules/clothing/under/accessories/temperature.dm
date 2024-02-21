/obj/item/clothing/accessory/temperature
	name = "temperature pack"
	desc = "A nice little pack that heats/cools you when worn under your clothes!"
	icon = 'icons/obj/item/clothing/accessory/temperature.dmi'
	icon_state = "pack"
	contained_sprite = TRUE

/obj/item/clothing/accessory/temperature/warm
	name = "heat pack"
	desc = "A nice little pack that heats you when worn under your clothes!"
	icon_state = "heat_pack"
	body_temperature_change = 5

/obj/item/clothing/accessory/temperature/volcano
	name = "volcano pack"
	desc = "A dangerous little pack that can warm even the coldest heart!"
	icon_state = "volcano_pack"
	body_temperature_change = 10

/obj/item/clothing/accessory/temperature/cold
	name = "cold pack"
	desc = "A nice little pack that cools you when worn under your clothes!"
	icon_state = "cold_pack"
	body_temperature_change = -5

/obj/item/clothing/accessory/temperature/blizzard
	name = "blizzard pack"
	desc = "A dangerous little pack that can suck the warmth out of any hearth!"
	icon_state = "blizzard_pack"
	body_temperature_change = -10

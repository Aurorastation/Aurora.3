/datum/technomancer/equipment/boots_of_speed
	name = "Boots of Speed"
	desc = "What appears to be an ordinary pair of boots, is actually a bit more useful than that.  These will help against slipping \
	on flat surfaces, and will make you run a bit faster than if you had normal shoes or boots on."
	cost = 50
	obj_path = /obj/item/clothing/shoes/boots/speed

/obj/item/clothing/shoes/boots/speed
	name = "boots of speed"
	desc = "The latest in sure footing technology."
	icon_state = "swat"
	item_flags = NOSLIP
	siemens_coefficient = 0.6
	slowdown = -1

	cold_protection = FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = FEET
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE
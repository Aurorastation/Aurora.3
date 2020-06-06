/obj/item/clothing/head/hardhat
	name = "hard hat"
	desc = "A piece of headgear used in dangerous working conditions to protect the head. Comes with a built-in flashlight."
	icon_state = "hardhat_yellow"
	action_button_name = "Toggle Headlamp"
	brightness_on = 4 //luminosity when on
	light_overlay = "hardhat_light"
	armor = list(melee = 30, bullet = 5, laser = 20,energy = 10, bomb = 20, bio = 10, rad = 20)
	flags_inv = 0
	siemens_coefficient = 0.9
	light_wedge = LIGHT_WIDE
	drop_sound = 'sound/items/drop/helm.ogg'
	pickup_sound = 'sound/items/pickup/helm.ogg'

/obj/item/clothing/head/hardhat/orange
	icon_state = "hardhat_orange"

/obj/item/clothing/head/hardhat/red
	name = "firefighter helmet"
	icon_state = "hardhat_red"
	heat_protection = HEAD
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/head/hardhat/white
	desc = "A piece of headgear used in dangerous working conditions to protect the head. Comes with a built-in flashlight. This one looks heat-resistant."
	icon_state = "hardhat_white"
	heat_protection = HEAD
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/head/hardhat/dblue
	icon_state = "hardhat_dblue"
	item_state = "hardhat_dblue"

/obj/item/clothing/head/hardhat/red/atmos
	name = "atmospheric firefighter helmet"
	desc = "An atmospheric firefighter's helmet, able to keep the user protected from heat and fire."
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE + 15000
	icon_state = "atmos_fire"
	item_state = "atmos_fire"

/obj/item/clothing/head/hardhat/emt
	name = "medical helmet"
	desc = "A polymer helmet worn by EMTs and Paramedics throughout human space to protect their heads. This one comes with an attached flashlight and has green crosses on the sides."
	icon_state = "helmet_paramed"
	item_state = "helmet_paramed"
	light_overlay = "EMS_light"
	armor = list(melee = 30, bullet = 15, laser = 20,energy = 10, bomb = 20, bio = 10, rad = 20)

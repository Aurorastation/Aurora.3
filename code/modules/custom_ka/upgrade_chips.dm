/obj/item/custom_ka_upgrade/upgrade_chips
	name = "kinetic accelerator upgrade chip"
	icon = 'icons/obj/kinetic_accelerators.dmi'
	damage_increase = 0
	firedelay_increase = 0
	range_increase = 0
	recoil_increase = 0
	cost_increase = 0
	cell_increase = 0
	capacity_increase = 0
	mod_limit_increase = 0

	origin_tech = list(TECH_POWER = 4,TECH_MAGNET = 4, TECH_DATA = 4)

/obj/item/custom_ka_upgrade/upgrade_chips/damage
	name = "upgrade chip - damage increase"
	desc = "Increases damage and recoil."
	icon_state = "upgrade_chip"
	damage_increase = 10
	recoil_increase = 3

/obj/item/custom_ka_upgrade/upgrade_chips/firerate
	name = "upgrade chip - firedelay increase"
	desc = "Increases the rate of fire, reduces damage."
	icon_state = "upgrade_chip"
	damage_increase = -5
	firedelay_increase = -0.5 SECONDS

/obj/item/custom_ka_upgrade/upgrade_chips/effeciency
	name = "upgrade chip - effeciency increase"
	desc = "Reduces the cost of shots by 1, reduces damage."
	icon_state = "upgrade_chip"
	damage_increase = -5
	cost_increase = -1

/obj/item/custom_ka_upgrade/upgrade_chips/recoil
	name = "upgrade chip - recoil reduction"
	desc = "Reduces recoil, increases accuracy, reduces rate of fire"
	icon_state = "upgrade_chip"
	recoil_increase = -5
	firedelay_increase = 0.25 SECONDS

/obj/item/custom_ka_upgrade/upgrade_chips/focusing
	name = "upgrade chip - focusing"
	desc = "Significantly increases damage and accuracy, however reduces the range."
	icon_state = "upgrade_chip"
	damage_increase = 10
	recoil_increase = -4
	range_increase = -3

/obj/item/custom_ka_upgrade/upgrade_chips/capacity
	name = "upgrade chip - capacity increase"
	desc = "Increases the maximum capacity of the assembly at the cost of more power drain."
	icon_state = "upgrade_chip"
	cost_increase = 5
	capacity_increase = 5
	mod_limit_increase = 1

/obj/item/custom_ka_upgrade/upgrade_chips/illegal
	name = "illegal custom KA upgrade chip"
	desc = "Overrides safety settings for a custom kinetic accelerator. What's the worst that could happen?"
	icon_state = "upgrade_chip_illegal"
	damage_increase = 10
	firedelay_increase = -0.5 SECONDS
	recoil_increase = 4
	cost_increase = 1
	range_increase = 4
	capacity_increase = 100
	mod_limit_increase = 5
	origin_tech = list(TECH_POWER = 6,TECH_MAGNET = 6, TECH_DATA = 6, TECH_ILLEGAL = 4)
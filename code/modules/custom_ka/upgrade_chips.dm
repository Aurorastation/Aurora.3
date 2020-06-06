/obj/item/custom_ka_upgrade/upgrade_chips/damage
	name = "upgrade chip - damage increase"
	desc = "Increases damage and recoil, reduces accuracy."
	icon_state = "upgrade_chip"
	damage_increase = 15
	recoil_increase = 3
	firedelay_increase = 1.5 SECONDS
	cost_increase = 3

/obj/item/custom_ka_upgrade/upgrade_chips/firerate
	name = "upgrade chip - firedelay increase"
	desc = "Increases the rate of fire, reduces damage."
	icon_state = "upgrade_chip"
	damage_increase = -5
	firedelay_increase = -0.5 SECONDS

/obj/item/custom_ka_upgrade/upgrade_chips/effeciency
	name = "upgrade chip - efficiency increase"
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
	desc = "Increases damage and accuracy, however reduces the range and explosion size, if any."
	icon_state = "upgrade_chip"
	damage_increase = 10
	recoil_increase = -4
	range_increase = -2
	aoe_increase = -100

/obj/item/custom_ka_upgrade/upgrade_chips/capacity
	name = "upgrade chip - capacity increase"
	desc = "Increases the maximum capacity of the assembly at the cost of more power drain per shot."
	icon_state = "upgrade_chip"
	cost_increase = 3
	capacity_increase = 5
	mod_limit_increase = 1

/obj/item/custom_ka_upgrade/upgrade_chips/explosive
	name = "upgrade chip - aoe explosion MKI"
	desc = "Kinetic blasts explode in an increased AoE radius at significantly increased power drain per shot."
	icon_state = "upgrade_chip"
	cost_increase = 5
	aoe_increase = 2

/obj/item/custom_ka_upgrade/upgrade_chips/illegal
	name = "illegal custom KA upgrade chip"
	desc = "Overrides safety settings for a custom kinetic accelerator. What's the worst that could happen?"
	icon_state = "upgrade_chip_illegal"
	firedelay_increase = -0.5 SECONDS
	recoil_increase = 4
	cost_increase = 1
	range_increase = 4
	capacity_increase = 100
	mod_limit_increase = 5
	origin_tech = list(TECH_POWER = 6,TECH_MAGNET = 6, TECH_DATA = 6, TECH_ILLEGAL = 4)
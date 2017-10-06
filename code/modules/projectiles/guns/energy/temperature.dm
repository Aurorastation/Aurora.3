/obj/item/weapon/gun/energy/temperature
	name = "temperature gun"
	icon_state = "freezegun"
	fire_sound = 'sound/weapons/pulse3.ogg'
	desc = "A gun that can add or remove heat from entities it hits.  In other words, it can fire 'cold', and 'hot' beams."
	charge_cost = 240
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 4, TECH_POWER = 3, TECH_MAGNET = 2)
	slot_flags = SLOT_BELT|SLOT_BACK

	projectile_type = /obj/item/projectile/temp

	firemodes = list(
		list(mode_name="endothermic beam", projectile_type = /obj/item/projectile/temp, charge_cost = 240),
		list(mode_name="exothermic beam", projectile_type = /obj/item/projectile/temp/hot, charge_cost = 240),
)
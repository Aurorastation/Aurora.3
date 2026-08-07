/obj/item/gun/energy/gauss/
	name = "forged gauss rifle"
	desc = "test"
	desc_extended = "test"
	icon = 'icons/obj/guns/faction/voidtamer/voidtamer_rifle/voidtamer_rifle.dmi'
	icon_state = "voidtamer_rifle"
	item_state = "voidtamer_rifle"

	has_item_ratio = FALSE
	fire_sound = 'sound/weapons/pulse.ogg'
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 3, TECH_MAGNET = 2, TECH_ILLEGAL = 2)
	charge_cost = 100
	max_shots = 15
	fire_delay = 6
	burst_delay = 4
	can_turret = FALSE
	drop_sound = 'sound/items/drop/rifle.ogg'
	pickup_sound = 'sound/items/pickup/rifle.ogg'
	is_wieldable = TRUE
	fire_delay_wielded = 5
	accuracy_wielded = 2
	slot_flags = SLOT_BACK

	secondary_projectile_type = /obj/projectile/energy/blaster/gauss_projectile/
	projectile_type = /obj/projectile/beam/gauss/

	can_switch_modes = TRUE
	firemodes = list(
		list(mode_name="beam", projectile_type=/obj/projectile/beam/gauss/),
		list(mode_name="projectile", projectile_type=/obj/projectile/energy/blaster/gauss_projectile/)
		)

/obj/item/gun/energy/gauss/carbine
	name = "forged gauss carbine"
	desc = "test"
	desc_extended = "test"
	icon = 'icons/obj/guns/faction/voidtamer/voidtamer_carbine/voidtamer_carbine.dmi'
	icon_state = "voidtamer_smg"
	item_state = "voidtamer_smg"
	slot_flags = SLOT_BELT

	max_shots = 20
	fire_delay = 4
	is_wieldable = FALSE

	secondary_projectile_type = /obj/projectile/energy/blaster/gauss_projectile/weak/
	projectile_type = /obj/projectile/beam/gauss/weak

	firemodes = list(
		list(mode_name="beam", projectile_type=/obj/projectile/beam/gauss/weak),
		list(mode_name="projectile", projectile_type=/obj/projectile/energy/blaster/gauss_projectile/weak/)
		)
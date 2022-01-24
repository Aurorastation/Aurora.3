/obj/item/gun/energy/freeze
	name = "freeze ray gun"
	desc = "A portable freezing ray gun designated to quickly lower temperatures."
	icon = 'icons/obj/guns/freezeray.dmi'
	icon_state = "icer"
	item_state = "icer"
	has_item_ratio = FALSE
	fire_sound = 'sound/weapons/pulse3.ogg'

	max_shots = 5

	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 4, TECH_POWER = 4)
	slot_flags = SLOT_BELT

	projectile_type = /obj/item/projectile/beam/freezer

	firemodes = list(
		list(mode_name="freeze", projectile_type= /obj/item/projectile/beam/freezer, fire_sound='sound/weapons/pulse3.ogg'),
		list(mode_name="ice bolt", projectile_type= /obj/item/projectile/ice, fire_sound='sound/weapons/crossbow.ogg')
		)
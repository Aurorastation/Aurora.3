	name = "pulse carbine"
	icon_state = "pulse_carbine"
	item_state = "pulse_carbine"
	slot_flags = SLOT_BELT
	force = 5
	projectile_type = /obj/item/projectile/beam
	sel_mode = 2
	max_shots = 10
	can_turret = 1
	secondary_projectile_type = /obj/item/projectile/beam/pulse
	can_switch_modes = 0
	turret_sprite_set = "pulse"
	turret_is_lethal = 1

	firemodes = list(
		)

	name = "mounted pulse carbine"
	charge_cost = 400
	self_recharge = 1
	use_external_power = 1
	recharge_time = 10
	can_turret = 0

	name = "pulse pistol"
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	icon_state = "pulse_pistol"
	item_state = "pulse_pistol"
	max_shots = 5

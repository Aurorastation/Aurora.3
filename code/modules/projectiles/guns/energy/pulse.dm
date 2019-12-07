/obj/item/gun/energy/pulse
	name = "pulse carbine"
	desc = "A weapon that uses advanced pulse-based beam generation technology to emit powerful laser blasts. Because of its complexity and cost, it is rarely seen in use except by specialists."
	icon_state = "pulse_carbine"
	item_state = "pulse_carbine"
	slot_flags = SLOT_BELT
	force = 5
	fire_sound='sound/weapons/Laser.ogg'
	projectile_type = /obj/item/projectile/beam
	sel_mode = 2
	accuracy = 1
	max_shots = 10
	can_turret = 1
	secondary_projectile_type = /obj/item/projectile/beam/pulse
	secondary_fire_sound = 'sound/weapons/pulse.ogg'
	can_switch_modes = 0
	turret_sprite_set = "pulse"
	turret_is_lethal = 1

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun, fire_sound='sound/weapons/Taser.ogg', fire_delay=null, charge_cost=null),
		list(mode_name="lethal", projectile_type=/obj/item/projectile/beam, fire_sound='sound/weapons/Laser.ogg', fire_delay=null, charge_cost=null),
		list(mode_name="DESTROY", projectile_type=/obj/item/projectile/beam/pulse, fire_sound='sound/weapons/pulse.ogg', fire_delay=25)
		)

/obj/item/gun/energy/pulse/mounted
	name = "mounted pulse carbine"
	charge_cost = 400
	self_recharge = 1
	use_external_power = 1
	recharge_time = 10
	can_turret = 0

/obj/item/gun/energy/pulse/pistol
	name = "pulse pistol"
	desc = "A weapon that uses advanced pulse-based beam generation technology to emit powerful laser blasts. This one is a really compact model."
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	icon_state = "pulse_pistol"
	item_state = "pulse_pistol"
	max_shots = 5

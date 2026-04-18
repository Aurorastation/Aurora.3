/obj/item/gun/energy/rifle/pulse
	name = "\improper PL-10 pulse rifle"
	desc = "A top-of-the-line, heavy-duty, multifaceted energy rifle with three firing modes. The gold standard for NanoTrasen's heavier security specialists."
	icon = 'icons/obj/guns/faction/nanotrasen_corporation/pulse.dmi'
	icon_state = "pulse"
	item_state = "pulse"
	fire_sound = 'sound/weapons/laser1.ogg'
	projectile_type = /obj/projectile/beam
	sel_mode = 2
	origin_tech = list(TECH_COMBAT = 7, TECH_MATERIAL = 6, TECH_MAGNET = 4)
	secondary_projectile_type = /obj/projectile/beam/pulse
	secondary_fire_sound = 'sound/weapons/pulse.ogg'
	can_switch_modes = FALSE
	turret_sprite_set = "pulse"
	turret_is_lethal = TRUE

	modifystate = null

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/projectile/beam/stun, fire_sound='sound/weapons/Taser.ogg'),
		list(mode_name="lethal", projectile_type=/obj/projectile/beam, fire_sound='sound/weapons/laser1.ogg'),
		list(mode_name="DESTROY", projectile_type=/obj/projectile/beam/pulse, fire_sound='sound/weapons/pulse.ogg')
		)

/obj/item/gun/energy/rifle/pulse/destroyer
	name = "\improper PL-10D pulse destroyer"
	desc = "A heavy-duty, pulse-based energy weapon. Because of its complexity and cost, it is rarely seen in use except by specialists."
	fire_sound = 'sound/weapons/pulse.ogg'
	projectile_type = /obj/projectile/beam/pulse
	burst_delay = 5
	burst = 3
	max_shots = 30
	secondary_projectile_type = null
	secondary_fire_sound = null

/obj/item/gun/energy/rifle/pulse/destroyer/toggle_firing_mode(mob/living/user)
	to_chat(user, SPAN_WARNING("[src.name] has three settings, and they are all DESTROY."))

/obj/item/gun/energy/pulse
	name = "\improper PL-4 pulse carbine"
	desc = "A next-generation pulse weapon for NanoTrasen's security forces. High production costs and logistical issues have limited its deployment to specialist Loss Prevention and Emergency Response units."
	icon = 'icons/obj/guns/faction/nanotrasen_corporation/pulse_carbine.dmi'
	icon_state = "pulse_carbine"
	item_state = "pulse_carbine"
	slot_flags = SLOT_BELT
	force = 11
	fire_sound='sound/weapons/laser1.ogg'
	projectile_type = /obj/projectile/beam
	sel_mode = 2
	accuracy = 1
	max_shots = 10
	can_turret = TRUE
	secondary_projectile_type = /obj/projectile/beam/pulse
	secondary_fire_sound = 'sound/weapons/pulse.ogg'
	can_switch_modes = FALSE
	turret_sprite_set = "pulse"
	turret_is_lethal = TRUE

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/projectile/beam/stun, fire_sound='sound/weapons/Taser.ogg'),
		list(mode_name="lethal", projectile_type=/obj/projectile/beam, fire_sound='sound/weapons/laser1.ogg'),
		list(mode_name="DESTROY", projectile_type=/obj/projectile/beam/pulse, fire_sound='sound/weapons/pulse.ogg', fire_delay=25)
		)

/obj/item/gun/energy/pulse/mounted
	name = "mounted pulse carbine"
	charge_cost = 400
	self_recharge = TRUE
	use_external_power = TRUE
	recharge_time = 10
	can_turret = FALSE

/obj/item/gun/energy/pulse/pistol
	name = "\improper PL-7 pulse pistol"
	desc = "A weapon that uses advanced pulse-based beam generation technology to emit powerful laser blasts. This one is a really compact model."
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	icon = 'icons/obj/guns/faction/nanotrasen_corporation/pulse_pistol.dmi'
	icon_state = "pulse_pistol"
	item_state = "pulse_pistol"
	offhand_accuracy = 1
	max_shots = 5

/obj/item/weapon/gun/energy/rifle
	name = "energy rifle"
	desc = "An energy-based rifle with two settings: stun and kill."
	icon_state = "eriflestun100"
	item_state = "elaser" //placeholder for now
	fire_sound = 'sound/weapons/Taser.ogg'
	slot_flags = SLOT_BACK
	w_class = 4
	force = 10
	max_shots = 20
	fire_delay = 6
	accuracy = -2
	can_turret = 1
	secondary_projectile_type = /obj/item/projectile/beam
	secondary_fire_sound = 'sound/weapons/Laser.ogg'
	can_switch_modes = 1
	turret_sprite_set = "carbine"
	turret_is_lethal = 0

	fire_delay_wielded = 1
	accuracy_wielded = 0
	sel_mode = 1

	projectile_type = /obj/item/projectile/beam/stun
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2, TECH_MAGNET = 3)
	modifystate = "eriflestun"

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun, modifystate="eriflestun", fire_sound='sound/weapons/Taser.ogg'),
		list(mode_name="lethal", projectile_type=/obj/item/projectile/beam, modifystate="eriflekill", fire_sound='sound/weapons/Laser.ogg')
		)

    //action button for wielding
	action_button_name = "Wield rifle"

/obj/item/weapon/gun/energy/rifle/can_wield()
	return 1

/obj/item/weapon/gun/energy/rifle/ui_action_click()
	if(src in usr)
		toggle_wield(usr)

/obj/item/weapon/gun/energy/rifle/verb/wield_rifle()
	set name = "Wield rifle"
	set category = "Object"
	set src in usr

	toggle_wield(usr)

/obj/item/weapon/gun/energy/rifle/laser
	name = "laser rifle"
	desc = "A common laser weapon, designed to kill with concentrated energy blasts."
	icon_state = "laser"
	item_state = "laser"
	fire_sound = 'sound/weapons/Laser.ogg'
	max_shots = 15
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 2)
	projectile_type = /obj/item/projectile/beam
	secondary_projectile_type = null
	secondary_fire_sound = null
	can_switch_modes = 0
	turret_sprite_set = "laser"
	turret_is_lethal = 1

	firemodes = list()
	modifystate = null

/obj/item/weapon/gun/energy/rifle/laser/heavy
	name = "laser cannon"
	desc = "With the laser cannon, the lasing medium is enclosed in a tube lined with uranium-235 and subjected to high neutron flux in a nuclear reactor core. This incredible technology may help YOU achieve high excitation rates with small laser volumes!"
	icon_state = "lasercannon"
	item_state = "lasercannon"
	fire_sound = 'sound/weapons/lasercannonfire.ogg'
	origin_tech = "combat=4;materials=3;powerstorage=3"
	projectile_type = /obj/item/projectile/beam/heavylaser
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3, TECH_POWER = 3)
	charge_cost = 400
	max_shots = 5
	fire_delay = 40
	accuracy = -2
	secondary_projectile_type = null
	secondary_fire_sound = null
	can_switch_modes = 0
	turret_sprite_set = "cannon"
	turret_is_lethal = 1

	fire_delay_wielded = 20

/obj/item/weapon/gun/energy/rifle/laser/xray
	name = "xray laser rifle"
	desc = "A high-power laser rifle capable of expelling concentrated xray blasts."
	icon_state = "xrifle"
	item_state = "xray"
	fire_sound = 'sound/weapons/laser3.ogg'
	projectile_type = /obj/item/projectile/beam/xray
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 3, TECH_MAGNET = 2, TECH_ILLEGAL = 2)
	max_shots = 40
	secondary_projectile_type = null
	secondary_fire_sound = null
	can_switch_modes = 0
	turret_sprite_set = "xray"
	turret_is_lethal = 1
	
/obj/item/weapon/gun/energy/rifle/pulse
	name = "pulse rifle"
	desc = "A weapon that uses advanced pulse-based beam generation technology to emit powerful laser blasts. Because of its complexity and cost, it is rarely seen in use except by specialists."
	icon_state = "pulse"
	item_state = "pulse"
	fire_sound = 'sound/weapons/Laser.ogg'
	projectile_type = /obj/item/projectile/beam
	sel_mode = 2
	origin_tech = list(TECH_COMBAT = 7, TECH_MATERIAL = 6, TECH_MAGNET = 4)
	secondary_projectile_type = /obj/item/projectile/beam/pulse
	secondary_fire_sound = 'sound/weapons/pulse.ogg'
	can_switch_modes = 0
	turret_sprite_set = "pulse"
	turret_is_lethal = 1
	
	modifystate = null

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun, fire_sound='sound/weapons/Taser.ogg'),
		list(mode_name="lethal", projectile_type=/obj/item/projectile/beam, fire_sound='sound/weapons/Laser.ogg'),
		list(mode_name="DESTROY", projectile_type=/obj/item/projectile/beam/pulse, fire_sound='sound/weapons/pulse.ogg')
		)

/obj/item/weapon/gun/energy/rifle/pulse/destroyer
	name = "pulse destroyer"
	desc = "A heavy-duty, pulse-based energy weapon. Because of its complexity and cost, it is rarely seen in use except by specialists."
	fire_sound='sound/weapons/pulse.ogg'
	projectile_type=/obj/item/projectile/beam/pulse
	burst_delay = 5
	burst = 3
	max_shots = 30
	secondary_projectile_type = null
	secondary_fire_sound = null

/obj/item/weapon/gun/energy/rifle/pulse/destroyer/attack_self(mob/living/user as mob)
	user << "<span class='warning'>[src.name] has three settings, and they are all DESTROY.</span>"

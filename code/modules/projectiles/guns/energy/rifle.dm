/obj/item/weapon/gun/energy/rifle
    name = "energy rifle"
    desc = "An energy-based rifle with two settings: stun and kill."
    icon_state = "eriflestun100"
    item_state = null
    fire_sound = 'sound/weapons/Taser.ogg'
    slot_flags = SLOT_BACK
    w_class = 4
    force = 10
    max_shots = 10
    fire_delay = 6
    accuracy = -2

    fire_delay_wielded = 1
    accuracy_wielded = 0

    projectile_type = /obj/item/projectile/beam/stun
    origin_tech = "combat=3;magnets=2"
    modifystate = "eriflestun"

    firemodes = list(
        list(name="stun", projectile_type=/obj/item/projectile/beam/stun, modifystate="eriflestun", fire_sound='sound/weapons/Taser.ogg'),
        list(name="lethal", projectile_type=/obj/item/projectile/beam, modifystate="eriflekill", fire_sound='sound/weapons/Laser.ogg'),
        )

    //action button for wielding
    icon_action_button = "action_blank"
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
    icon_state = "laser rifle"
    item_state = "laser rifle"
    fire_sound = 'sound/weapons/Laser.ogg'
    projectile_type = /obj/item/projectile/beam

    firemodes = list()
    modifystate = null

/obj/item/weapon/gun/energy/rifle/laser/heavy
    name = "heavy laser rifle"
    desc = "With the laser cannon, the lasing medium is enclosed in a tube lined with uranium-235 and subjected to high neutron flux in a nuclear reactor core. This incredible technology may help YOU achieve high excitation rates with small laser volumes!"
    icon_state = "lasercannon"
    item_state = null
    fire_sound = 'sound/weapons/lasercannonfire.ogg'
    origin_tech = "combat=4;materials=3;powerstorage=3"
    projectile_type = /obj/item/projectile/beam/heavylaser
    charge_cost = 400
    max_shots = 5
    fire_delay = 40
    accuracy = -2

    fire_delay_wielded = 20

/obj/item/weapon/gun/energy/rifle/pulse
    name = "pulse rifle"
    desc = "A weapon that uses advanced pulse-based beam generation technology to emit powerful laser blasts. Because of its complexity and cost, it is rarely seen in use except by specialists."
    icon_state = "pulse"
    fire_sound = 'sound/weapons/Laser.ogg'
    projectile_type = /obj/item/projectile/beam
    sel_mode = 2

    modifystate = null

    firemodes = list(
		list(name="stun", projectile_type=/obj/item/projectile/beam/stun, fire_sound='sound/weapons/Taser.ogg'),
		list(name="lethal", projectile_type=/obj/item/projectile/beam, fire_sound='sound/weapons/Laser.ogg'),
		list(name="DESTROY", projectile_type=/obj/item/projectile/beam/pulse, fire_sound='sound/weapons/pulse.ogg', fire_delay=25, charge_cost=400),
		)

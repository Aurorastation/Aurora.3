/obj/item/gun/energy/rifle
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
	accuracy = -1
	can_turret = 1
	secondary_projectile_type = /obj/item/projectile/beam
	secondary_fire_sound = 'sound/weapons/Laser.ogg'
	can_switch_modes = 1
	turret_sprite_set = "carbine"
	turret_is_lethal = 0

	fire_delay_wielded = 1
	accuracy_wielded = 2
	sel_mode = 1

	projectile_type = /obj/item/projectile/beam/stun
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2, TECH_MAGNET = 3)
	modifystate = "eriflestun"

	is_wieldable = TRUE

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun, modifystate="eriflestun", fire_sound='sound/weapons/Taser.ogg'),
		list(mode_name="lethal", projectile_type=/obj/item/projectile/beam, modifystate="eriflekill", fire_sound='sound/weapons/Laser.ogg')
		)


/obj/item/gun/energy/rifle/laser
	name = "laser rifle"
	desc = "A common laser weapon, designed to kill with concentrated energy blasts."
	icon_state = "laserrifle"
	item_state = "laserrifle"
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

/obj/item/gun/energy/rifle/laser/update_icon()
	..()
	if(wielded)
		item_state = "[initial(icon_state)]-wielded"
	else
		item_state = initial(item_state)
	update_held_icon()

/obj/item/gun/energy/rifle/laser/heavy
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

	accuracy_wielded = 2
	fire_delay_wielded = 20

/obj/item/gun/energy/rifle/laser/xray
	name = "xray laser rifle"
	desc = "A high-power laser rifle capable of expelling concentrated xray blasts."
	icon_state = "xrifle"
	item_state = "xrifle"
	fire_sound = 'sound/weapons/laser3.ogg'
	projectile_type = /obj/item/projectile/beam/xray
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 3, TECH_MAGNET = 2, TECH_ILLEGAL = 2)
	max_shots = 40
	secondary_projectile_type = null
	secondary_fire_sound = null
	can_switch_modes = 0
	turret_sprite_set = "xray"
	turret_is_lethal = 1

/obj/item/gun/energy/rifle/pulse
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

/obj/item/gun/energy/rifle/pulse/destroyer
	name = "pulse destroyer"
	desc = "A heavy-duty, pulse-based energy weapon. Because of its complexity and cost, it is rarely seen in use except by specialists."
	fire_sound='sound/weapons/pulse.ogg'
	projectile_type=/obj/item/projectile/beam/pulse
	burst_delay = 5
	burst = 3
	max_shots = 30
	secondary_projectile_type = null
	secondary_fire_sound = null

/obj/item/gun/energy/rifle/pulse/destroyer/attack_self(mob/living/user as mob)
	to_chat(user, "<span class='warning'>[src.name] has three settings, and they are all DESTROY.</span>")

/obj/item/gun/energy/rifle/laser/tachyon
	name = "tachyon rifle"
	desc = "A Vaurcan rifle that fires a beam of concentrated faster than light particles, capable of passing through most forms of matter."
	contained_sprite = 1
	icon = 'icons/obj/vaurca_items.dmi'
	icon_state = "tachyonrifle"
	item_state = "tachyonrifle"
	fire_sound = 'sound/weapons/laser3.ogg'
	projectile_type = /obj/item/projectile/beam/tachyon
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 3, TECH_MAGNET = 2, TECH_ILLEGAL = 2)
	secondary_projectile_type = null
	secondary_fire_sound = null
	can_switch_modes = 0
	can_turret = 0
	zoomdevicename = "rifle scope"
	var/obj/screen/overlay = null

/obj/item/gun/energy/rifle/laser/tachyon/verb/scope()
	set category = "Object"
	set name = "Use Rifle Scope"
	set popup_menu = 1

	if(wielded)
		toggle_scope(2.0, usr)
	else
		to_chat(usr, "<span class='warning'>You can't look through the scope without stabilizing the rifle!</span>")

/obj/item/gun/energy/rifle
	name = "energy rifle"
	desc = "A NanoTrasen designed energy-based rifle with two settings: Stun and Kill."
	desc_extended = "The NT ER-2 is an energy rifle developed and produced by NanoTrasen. Widely produced and sold across the galaxy. Designed to both stun and kill with concentrated energy blasts of varying strengths based on the fire mode, focused through a crystal lens. Considered to be a dual-purpose rifle with prolonged combat capability."
	icon = 'icons/obj/guns/erifle.dmi'
	icon_state = "eriflestun"
	item_state = "eriflestun"
	fire_sound = 'sound/weapons/Taser.ogg'
	slot_flags = SLOT_BACK
	w_class = ITEMSIZE_LARGE
	force = 15
	max_shots = 20
	fire_delay = 6
	burst_delay = 3
	accuracy = -1
	can_turret = 1
	secondary_projectile_type = /obj/item/projectile/beam
	secondary_fire_sound = 'sound/weapons/laser1.ogg'
	can_switch_modes = 1
	turret_sprite_set = "carbine"
	turret_is_lethal = 0
	has_item_ratio = FALSE

	fire_delay_wielded = 5
	accuracy_wielded = 2
	sel_mode = 1

	projectile_type = /obj/item/projectile/beam/stun
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2, TECH_MAGNET = 3)
	modifystate = "eriflestun"

	is_wieldable = TRUE

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun, modifystate="eriflestun", fire_sound='sound/weapons/Taser.ogg'),
		list(mode_name="lethal", projectile_type=/obj/item/projectile/beam, modifystate="eriflekill", fire_sound='sound/weapons/laser1.ogg')
		)

/obj/item/gun/energy/rifle/laser
	name = "laser rifle"
	desc = "A NanoTrasen designed laser weapon, designed to kill with concentrated energy blasts."
	desc_extended = "The NT LR-6 is a laser rifle developed and produced by NanoTrasen. Designed to kill with concentrated energy blasts focused through a crystal lens. It is considered to be the template of other standard laser weaponry."
	icon = 'icons/obj/guns/laserrifle.dmi'
	icon_state = "laserrifle"
	item_state = "laserrifle"
	has_item_ratio = FALSE // the back and suit slots have ratio sprites but the in-hands dont
	fire_sound = 'sound/weapons/laser1.ogg'
	max_shots = 15
	fire_delay = 6
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 2)
	projectile_type = /obj/item/projectile/beam/midlaser
	secondary_projectile_type = null
	secondary_fire_sound = null
	can_switch_modes = 0
	turret_sprite_set = "laser"
	turret_is_lethal = 1

	firemodes = list()
	modifystate = null

/obj/item/gun/energy/rifle/laser/practice
	name = "practice laser rifle"
	desc = "A modified version of the NT LR-6. It fires less concentrated laser beams that are visible, but ultimately harmless, designed for target practice."
	projectile_type = /obj/item/projectile/beam/practice

/obj/item/gun/energy/rifle/laser/noctiluca
	name = "combat laser rifle"
	desc = "The Noctiluca XM/24 is a brand new model of laser rifle, developed entirely by Kumar Arms, a Zavodskoi Interstellar subsidiary. Easy to handle for users with minimal training, reliable and with a reasonable form factor, it is poised to become the new standard for laser weaponry."
	desc_extended = "The Noctiluca XM/24 was unveiled at the tail end of 2463 in the SCC Future Firearms contest and was released by Zavodskoi in June 2464 after achieving a stunning victory over the other competitors. Zavodskoi installations are prioritized for acquisition of this new rifle, with along the SCCV Horizon. The Noctiluca's specialty lies in its revolutionary dual-function laser diffuser, which is able to modulate the laser into either a standard beam or an armor-piercing super-concentrated beam."
	desc_info = "This is an energy weapon.  To fire the weapon, ensure your intent is *not* set to 'help', have your gun mode set to 'fire', \
	then click where you want to fire.  Most energy weapons can fire through windows harmlessly.  To recharge this weapon, use a weapon recharger. \
	The Noctiluca comes with a standard firing mode that is slightly worse in damage than the normal laser rifle, but has more armor penetration. Additionally, \
	it has a secondary armor-piercing mode, which does less damage but has extremely high armor piercing."
	icon = 'icons/obj/guns/crew_laser.dmi'
	icon_state = "trilaser"
	item_state = "trilaser"
	max_shots = 12
	fire_delay = 5
	burst_delay = 5
	origin_tech = list(TECH_COMBAT = 8, TECH_MAGNET = 4)
	projectile_type = /obj/item/projectile/beam/noctiluca
	secondary_projectile_type = /obj/item/projectile/beam/noctiluca/armor_piercing
	secondary_fire_sound = 'sound/weapons/laserstrong.ogg'
	can_switch_modes = TRUE
	firemodes = list(
		list(mode_name = "fire normal diffusion lasers", projectile_type = /obj/item/projectile/beam/noctiluca, fire_sound = 'sound/weapons/laser1.ogg'),
		list(mode_name = "fire specialized armor piercing lasers", projectile_type = /obj/item/projectile/beam/noctiluca/armor_piercing, fire_sound = 'sound/weapons/laserstrong.ogg')
	)

/obj/item/gun/energy/rifle/laser/heavy
	name = "laser cannon"
	desc = "A nanotrasen designed laser cannon capable of acting as a powerful support weapon."
	desc_extended = "The NT LC-4 is a laser cannon developed and produced by NanoTrasen. Produced and sold to organizations both in need of a highly powerful support weapon and can afford its high unit cost. In spite of the low capacity, it is a highly capable tool, cutting down fortifications and armored targets with ease."
	icon = 'icons/obj/guns/lasercannon.dmi'
	icon_state = "lasercannon100"
	item_state = "lasercannon100"
	has_item_ratio = TRUE
	fire_sound = 'sound/weapons/lasercannonfire.ogg'
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

	modifystate = "lasercannon"

	accuracy_wielded = 2
	fire_delay_wielded = 20

/obj/item/gun/energy/rifle/laser/xray
	name = "xray laser rifle"
	desc = "A NanoTrasen designed high-power laser rifle capable of expelling concentrated xray blasts."
	desc_extended = "The NT XR-1 is a laser firearm developed and produced by NanoTrasen. A recent innovation, used for specialist operations, it is presently being produced and sold in limited capacity over the galaxy. Designed for precision strikes, releasing concentrated xray blasts that are capable of hitting targets behind cover, all the while having a large ammo capacity."
	icon = 'icons/obj/guns/xrifle.dmi'
	icon_state = "xrifle"
	item_state = "xrifle"
	fire_sound = 'sound/weapons/laser3.ogg'
	projectile_type = /obj/item/projectile/beam/xray
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 3, TECH_MAGNET = 2, TECH_ILLEGAL = 2)
	max_shots = 40
	fire_delay = 6
	burst_delay = 6
	secondary_projectile_type = null
	secondary_fire_sound = null
	can_switch_modes = 0
	turret_sprite_set = "xray"
	turret_is_lethal = 1

/obj/item/gun/energy/rifle/pulse
	name = "pulse rifle"
	desc = "A weapon that uses advanced pulse-based beam generation technology to emit powerful laser blasts. Because of its complexity and cost, it is rarely seen in use except by specialists."
	icon = 'icons/obj/guns/pulse.dmi'
	icon_state = "pulse"
	item_state = "pulse"
	fire_sound = 'sound/weapons/laser1.ogg'
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
		list(mode_name="lethal", projectile_type=/obj/item/projectile/beam, fire_sound='sound/weapons/laser1.ogg'),
		list(mode_name="DESTROY", projectile_type=/obj/item/projectile/beam/pulse, fire_sound='sound/weapons/pulse.ogg')
		)

/obj/item/gun/energy/rifle/pulse/destroyer
	name = "pulse destroyer"
	desc = "A heavy-duty, pulse-based energy weapon. Because of its complexity and cost, it is rarely seen in use except by specialists."
	fire_sound = 'sound/weapons/pulse.ogg'
	projectile_type = /obj/item/projectile/beam/pulse
	burst_delay = 5
	burst = 3
	max_shots = 30
	secondary_projectile_type = null
	secondary_fire_sound = null

/obj/item/gun/energy/rifle/pulse/destroyer/toggle_firing_mode(mob/living/user)
	to_chat(user, "<span class='warning'>[src.name] has three settings, and they are all DESTROY.</span>")

/obj/item/gun/energy/rifle/laser/tachyon
	name = "tachyon rifle"
	desc = "A Vaurcan rifle that fires a beam of concentrated faster than light particles, capable of passing through most forms of matter."
	icon = 'icons/obj/vaurca_items.dmi'
	icon_state = "tachyonrifle"
	item_state = "tachyonrifle"
	has_item_ratio = FALSE
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
	set name = "Use Scope"
	set src in usr

	if(wielded)
		toggle_scope(2.0, usr)
	else
		to_chat(usr, "<span class='warning'>You can't look through the scope without stabilizing the rifle!</span>")

/obj/item/gun/energy/rifle/ionrifle
	name = "ion rifle"
	desc = "The NT Mk70 EW Halicon is a man portable anti-armor weapon designed to disable mechanical threats, produced by NanoTrasen."
	icon = 'icons/obj/guns/ionrifle.dmi'
	icon_state = "ionrifle"
	item_state = "ionrifle"
	has_item_ratio = FALSE
	modifystate = null
	projectile_type = /obj/item/projectile/ion/stun
	fire_sound = 'sound/weapons/laser1.ogg'
	origin_tech = list(TECH_COMBAT = 2, TECH_MAGNET = 4)
	w_class = ITEMSIZE_LARGE
	accuracy = 1
	force = 15
	obj_flags = OBJ_FLAG_CONDUCTABLE
	slot_flags = SLOT_BACK
	charge_cost = 300
	max_shots = 4
	can_turret = 1
	turret_sprite_set = "ion"
	firemodes = list()

/obj/item/gun/energy/rifle/ionrifle/emp_act(severity)
	. = ..()

/obj/item/gun/energy/rifle/ionrifle/mounted
	name = "mounted ion rifle"
	self_recharge = 1
	use_external_power = 1
	recharge_time = 10
	can_turret = 0

/obj/item/gun/energy/rifle/laser/qukala
	name = "geop cannon"
	desc = "An advanced weapon of Skrell design, this Geop Cannon uses a tiny warp accelerator to super heat particles."
	icon = 'icons/obj/item/gun/energy/rifle/qukala_heavy.dmi'
	icon_state = "qukala_heavy"
	item_state = "qukala_heavy"
	max_shots = 10
	self_recharge = TRUE
	projectile_type = /obj/item/projectile/beam/midlaser/skrell/heavy

/obj/item/gun/energy/rifle/hegemony
	name = "hegemony energy rifle"
	desc = "An upgraded variant of the standard laser rifle. It does not have a stun setting."
	desc_extended = "The Zkrehk-Guild Heavy Beamgun, an energy-based rifle designed and manufactured on Moghes. A special crystal used in its design allows it to penetrate armor with pinpoint accuracy."
	icon = 'icons/obj/guns/hegemony_rifle.dmi'
	icon_state = "hegemonyrifle"
	item_state = "hegemonyrifle"
	has_item_ratio = FALSE
	fire_sound = 'sound/weapons/laser1.ogg'
	slot_flags = SLOT_BELT|SLOT_BACK
	max_shots = 15
	can_switch_modes = FALSE
	can_turret = TRUE
	turret_is_lethal = TRUE
	projectile_type = /obj/item/projectile/beam/midlaser/hegemony
	origin_tech = list(TECH_COMBAT = 6, TECH_MAGNET = 4)
	is_wieldable = TRUE
	modifystate = "hegemonyrifle"

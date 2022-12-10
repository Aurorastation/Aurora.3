/obj/item/gun/energy/blaster
	name = "blaster pistol"
	desc = "A tiny energy pistol converted to fire off energy bolts rather than lasers beams."
	icon = 'icons/obj/guns/blaster_pistol.dmi'
	icon_state = "blaster_pistol"
	item_state = "blaster_pistol"
	has_item_ratio = FALSE
	fire_sound = 'sound/weapons/laser1.ogg'
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	w_class = ITEMSIZE_SMALL
	force = 5
	origin_tech = list(TECH_COMBAT = 2, TECH_MAGNET = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	offhand_accuracy = 1
	projectile_type = /obj/item/projectile/energy/blaster
	max_shots = 6

	burst_delay = 2
	sel_mode = 1

	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=0,    move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="2-round bursts", burst=2, fire_delay=null, move_delay=2,    burst_accuracy=list(1,0,0),       dispersion=list(0, 10, 15))
		)

/obj/item/gun/energy/blaster/mounted/mech
	name = "rapidfire blaster"
	desc = "An aged but reliable rapidfire blaster tuned to expel projectiles at high fire rates."
	fire_sound = 'sound/weapons/laserstrong.ogg'
	projectile_type = /obj/item/projectile/energy/blaster/heavy
	burst = 5
	burst_delay = 3
	max_shots = 30
	charge_cost = 100
	use_external_power = TRUE
	self_recharge = TRUE
	recharge_time = 1.5
	dispersion = list(3,6,9,12)
	firemodes = list()

/obj/item/gun/energy/blaster/pilot_special
	name = "pilot's sidearm"
	desc = "A robust, low in maintenance blaster pistol. Customized for peak performance and perfect for self-defense purposes."
	max_shots = 8
	accuracy = 2 // Likely to get nothing else, so they gotta know how to make it count.
	offhand_accuracy = 2

/obj/item/gun/energy/blaster/revolver
	name = "blaster revolver"
	desc = "A robust eight-shot blaster."
	icon = 'icons/obj/guns/blaster_revolver.dmi'
	icon_state = "blaster_revolver"
	item_state = "blaster_revolver"
	fire_sound = 'sound/weapons/laserstrong.ogg'
	projectile_type = /obj/item/projectile/energy/blaster
	max_shots = 8
	w_class = ITEMSIZE_SMALL

/obj/item/gun/energy/blaster/revolver/unique_action(mob/living/user)
	user.visible_message(SPAN_WARNING("\The [user] spins the cylinder of \the [src]!"), SPAN_WARNING("You spin the cylinder of \the [src]!"), SPAN_NOTICE("You hear something metallic spin and click."))
	playsound(src.loc, 'sound/weapons/revolver_spin.ogg', 100, 1)

/obj/item/gun/energy/blaster/carbine
	name = "blaster carbine"
	desc = "A short-barreled blaster carbine meant for easy handling and comfort when in combat."
	icon = 'icons/obj/guns/blaster_carbine.dmi'
	icon_state = "blaster_carbine"
	item_state = "blaster_carbine"
	max_shots = 12
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 2)
	offhand_accuracy = 0
	projectile_type = /obj/item/projectile/energy/blaster
	slot_flags = SLOT_BELT
	w_class = ITEMSIZE_NORMAL

/obj/item/gun/energy/blaster/rifle
	name = "bolt slinger"
	desc = "A blaster rifle which seems to work by accelerating particles and flinging them out in destructive bolts."
	icon = 'icons/obj/guns/blaster_rifle.dmi'
	icon_state = "blaster_rifle"
	item_state = "blaster_rifle"
	max_shots = 20
	origin_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 3)
	offhand_accuracy = 0
	projectile_type = /obj/item/projectile/energy/blaster/heavy

	force = 10
	slot_flags = SLOT_BACK
	w_class = ITEMSIZE_LARGE
	can_bayonet = TRUE
	knife_x_offset = 23
	knife_y_offset = 13
	fire_delay = 25
	w_class = ITEMSIZE_LARGE
	accuracy = -3
	scoped_accuracy = 4

	fire_delay_wielded = 10
	accuracy_wielded = 1

	is_wieldable = TRUE

/obj/item/gun/energy/blaster/rifle/verb/scope()
	set category = "Object"
	set name = "Use Scope"
	set popup_menu = 1

	if(wielded)
		toggle_scope(2.0, usr)
	else
		to_chat(usr, "<span class='warning'>You can't look through the scope without stabilizing the rifle!</span>")

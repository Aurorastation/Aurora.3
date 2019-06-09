/obj/item/weapon/gun/energy/blaster
	name = "blaster pistol"
	desc = "A tiny energy pistol converted to fire off energy bolts rather than lasers beams."
	icon_state = "blaster_pistol"
	item_state = "blaster_pistol"
	fire_sound = 'sound/weapons/Laser.ogg'
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	w_class = 3
	force = 5
	origin_tech = list(TECH_COMBAT = 2, TECH_MAGNET = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	projectile_type = /obj/item/projectile/energy/blaster
	max_shots = 6

	burst_delay = 2
	sel_mode = 1

	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=0,    move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="2-round bursts", burst=2, fire_delay=null, move_delay=2,    burst_accuracy=list(1,0,0),       dispersion=list(0, 10, 15))
		)

/obj/item/weapon/gun/energy/blaster/detective
	name = "detective blaster"
	desc = "A robust eight-shot blaster, capable of taking down any aggressive suspects."
	icon_state = "detective"
	item_state = "detective"
	fire_sound = 'sound/weapons/laserstrong.ogg'
	projectile_type = /obj/item/projectile/energy/blaster/tame
	max_shots = 8

/obj/item/weapon/gun/energy/blaster/detective/verb/spin_cylinder()
	set name = "Spin cylinder"
	set desc = "Fun when you're bored out of your skull."
	set category = "Object"

	usr.visible_message("<span class='warning'>\The [usr] spins the cylinder of \the [src]!</span>", "<span class='warning'>You spin the cylinder of \the [src]!</span>", "<span class='notice'>You hear something metallic spin and click.</span>")
	playsound(src.loc, 'sound/weapons/revolver_spin.ogg', 100, 1)

/obj/item/weapon/gun/energy/blaster/detective/verb/rename_gun()
	set name = "Name Gun"
	set category = "Object"
	set desc = "Click to rename your gun. If you're the detective."

	var/mob/M = usr
	if(!M.mind)	return 0
	if(!M.mind.assigned_role == "Detective")
		to_chat(M, "<span class='notice'>You don't feel cool enough to name this gun, chump.</span>")
		return 0

	var/input = sanitizeSafe(input("What do you want to name the gun?", ,""), MAX_NAME_LEN)

	if(src && input && !M.stat && in_range(M,src))
		name = input
		to_chat(M, "You name the gun [input]. Say hello to your new friend.")
		return 1

/obj/item/weapon/gun/energy/blaster/carbine
	name = "blaster carbine"
	desc = "A short-barreled blaster carbine meant for easy handling and comfort when in combat."
	icon_state = "blaster_carbine"
	item_state = "blaster_carbine"
	max_shots = 12
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 2)
	projectile_type = /obj/item/projectile/energy/blaster
	slot_flags = SLOT_BELT

/obj/item/weapon/gun/energy/blaster/rifle
	name = "bolt slinger"
	desc = "A blaster rifle which seems to work by accelerating particles and flinging them out in destructive bolts."
	icon_state = "blaster_rifle"
	item_state = "blaster_rifle"
	max_shots = 20
	origin_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 3)
	projectile_type = /obj/item/projectile/energy/blaster/heavy

	slot_flags = SLOT_BACK
	w_class = 4

	fire_delay = 25
	w_class = 4
	accuracy = -3
	scoped_accuracy = 4

	fire_delay_wielded = 10
	accuracy_wielded = 0

	action_button_name = "Wield rifle"

/obj/item/weapon/gun/energy/blaster/rifle/update_icon()
	..()
	if(wielded)
		item_state = "blaster_rifle-wielded"
	else
		item_state = initial(item_state)
	update_held_icon()

/obj/item/weapon/gun/energy/blaster/rifle/can_wield()
	return 1

/obj/item/weapon/gun/energy/blaster/rifle/ui_action_click()
	if(src in usr)
		toggle_wield(usr)

/obj/item/weapon/gun/energy/blaster/rifle/verb/scope()
	set category = "Object"
	set name = "Use Scope"
	set popup_menu = 1

	if(wielded)
		toggle_scope(2.0, usr)
	else
		to_chat(usr, "<span class='warning'>You can't look through the scope without stabilizing the rifle!</span>")

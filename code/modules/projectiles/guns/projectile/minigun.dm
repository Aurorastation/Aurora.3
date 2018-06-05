/obj/item/minigunpack
	name = "backpack power source"
	desc = "The massive external power source for the gatling gun."
	icon = 'icons/obj/minigun.dmi'
	icon_state = "holstered"
	item_state = "holstered"
	contained_sprite = 1
	w_class = 4
	slot_flags = SLOT_BACK

	var/obj/item/weapon/gun/projectile/automatic/rifle/minigun/gun
	var/armed = FALSE
	var/obj/item/ammo_magazine/ammo_magazine
	var/magazine_type =  /obj/item/ammo_magazine/minigun

/obj/item/minigunpack/update_icon()
	..()
	if(armed)
		icon_state = "notholstered"
		item_state = "notholstered"
	else
		icon_state = "holstered"
		item_state = "holstered"

/obj/item/minigunpack/Initialize()
	. = ..()
	gun = make_gun()
	gun.source = src
	ammo_magazine = new magazine_type(src)
	gun.magazine_type = ammo_magazine
	gun.ammo_magazine = ammo_magazine
	gun.loc = src

/obj/item/minigunpack/proc/make_gun()
	return new /obj/item/weapon/gun/projectile/automatic/rifle/minigun()

/obj/item/minigunpack/ui_action_click()
	toggle_gun()

/obj/item/minigunpack/verb/toggle_gun()
	set name = "Toggle Gun"
	set category = "Object"
	var/mob/living/carbon/human/user
	if(istype(usr,/mob/living/carbon/human))
		user = usr
	else
		return
	if(!user)
		return
	if (user.back!= src)
		to_chat(user, "<span class='warning'>\The [src] must be worn to deploy \the [gun]!</span>")
		return
	if(use_check(user))
		return
	armed = !armed
	if(gun)
		if(!gun)
			gun = make_gun()
			gun.source = src
			gun.magazine_type = ammo_magazine
			gun.ammo_magazine = ammo_magazine
			gun.loc = src

		if(!user.put_in_hands(gun))
			armed = FALSE
			to_chat(user, "<span class='warning'>You need a free hand to hold \the [gun]!</span>")
			return
		gun.loc = user
		update_icon()
		user.update_inv_back()
	else
		remove_gun()
	return

/obj/item/minigunpack/equipped(mob/user, slot)
	..()
	if(slot != slot_back)
		remove_gun()

/obj/item/minigunpack/proc/remove_gun()
	if(!gun)
		gun = make_gun()
		gun.source = src
		gun.magazine_type = ammo_magazine
		gun.ammo_magazine = ammo_magazine
		gun.loc = src
	if(ismob(gun.loc))
		var/mob/M = gun.loc
		M.drop_from_inventory(gun)
		gun.loc = src
		update_icon()
	return

/obj/item/minigunpack/Destroy()
	qdel(gun)
	gun = null
	return ..()

/obj/item/minigunpack/attackby(obj/item/W, mob/user, params)
	if(W == gun)
		remove_gun()
		return 1
	else
		return ..()

/obj/item/weapon/gun/projectile/automatic/rifle/minigun
	name = "gatling machine gun"
	desc = "A six-barrel rotary machine gun with an incredible rate of fire. Requires a bulky backpack power source to use."
	slot_flags = 0
	icon = 'icons/obj/minigun.dmi'
	icon_state = "minigun"
	item_state = "minigun"
	contained_sprite = 1
	caliber = "a762"
	magazine_type = null
	fire_sound = 'sound/weapons/gunshot_saw.ogg'

	firemodes = list(
		list(mode_name="short bursts",	burst=6, move_delay=8, burst_accuracy = list(0,-1,-1,-2,-2),          dispersion = list(3, 6, 9)),
		list(mode_name="long bursts",	burst=12, move_delay=9, burst_accuracy = list(0,-1,-1,-2,-2,-2,-3,-3), dispersion = list(8))
		)


	var/obj/item/minigunpack/source

/obj/item/weapon/gun/projectile/automatic/rifle/minigun/special_check(var/mob/user)
	if(!wielded)
		user << "<span class='danger'>You cannot fire this weapon with just one hand!</span>"
		return 0

	return ..()

/obj/item/weapon/gun/projectile/automatic/rifle/minigun/load_ammo(var/obj/item/A, mob/user)
	return

/obj/item/weapon/gun/projectile/automatic/rifle/minigun/unload_ammo(mob/user, var/allow_dump=1)
	return

/obj/item/weapon/gun/projectile/automatic/rifle/minigun/dropped(mob/user)
	..()
	if(source)
		to_chat(user, "<span class='notice'>\The [src] snaps back onto the backpack.</span>")
		source.armed = FALSE
		forceMove(source)

/obj/item/weapon/gun/projectile/automatic/rifle/minigun/Move()
	..()
	if(source)
		if(loc != source.loc)
			forceMove(source.loc)


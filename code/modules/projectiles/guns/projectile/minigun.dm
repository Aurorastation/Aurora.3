/obj/item/minigunpack
	name = "backpack power source"
	desc = "The massive external power source for the gatling gun."
	icon = 'icons/obj/minigun.dmi'
	icon_state = "holstered"
	item_state = "holstered"
	contained_sprite = 1
	w_class = 4
	slot_flags = SLOT_BACK
	origin_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 6, TECH_MAGNET = 4, TECH_ILLEGAL = 7)
	action_button_name = "Deploy the Gatling Machine Gun"

	var/obj/item/gun/projectile/automatic/rifle/minigun/gun
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
	gun.forceMove(src)

/obj/item/minigunpack/proc/make_gun()
	return new /obj/item/gun/projectile/automatic/rifle/minigun()

/obj/item/minigunpack/ui_action_click()
	if(src in usr)
		toggle_gun()

/obj/item/minigunpack/verb/toggle_gun()
	set name = "Deploy the gatling machine gun"
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

	if(use_check_and_message(user))
		return

	if(!gun)
		to_chat(user, "<span class='warning'>There is no weapon attached the \the [src]!</span>")

	if(armed)
		to_chat(user, "<span class='warning'>\The [src] has been already deployed!</span>")

	else
		if(!user.put_in_hands(gun))
			to_chat(user, "<span class='warning'>You need a free hand to hold \the [gun]!</span>")
			return

		armed = TRUE
		update_icon()
		user.update_inv_back()

/obj/item/minigunpack/equipped(mob/user, slot)
	..()
	if(slot != slot_back)
		remove_gun()
		user.update_inv_back()

/obj/item/minigunpack/proc/remove_gun()
	if(!gun)
		return
	if(ismob(gun.loc))
		var/mob/M = gun.loc
		if(M.drop_from_inventory(gun, src))
			update_icon()
	else
		gun.forceMove(src)
		update_icon()

	armed = FALSE

	return

/obj/item/minigunpack/Destroy()
	if(gun)
		qdel(gun)
		gun = null
	if(ammo_magazine)
		qdel(ammo_magazine)
		ammo_magazine = null
	return ..()

/obj/item/minigunpack/attackby(obj/item/W, mob/user, params)
	if(W == gun)
		remove_gun()
		return 1
	else
		return ..()

/obj/item/gun/projectile/automatic/rifle/minigun
	name = "gatling machine gun"
	desc = "A six-barrel rotary machine gun with an incredible rate of fire. Requires a bulky backpack power source to use."
	slot_flags = 0
	icon = 'icons/obj/minigun.dmi'
	icon_state = "minigun"
	item_state = "minigun"
	contained_sprite = 1
	caliber = "a762"
	magazine_type = null
	max_shells = 1000
	fire_sound = 'sound/weapons/gunshot/gunshot_saw.ogg'
	needspin = FALSE
	origin_tech = null

	firemodes = list(
		list(mode_name="short bursts",	burst=6, move_delay=8, burst_accuracy = list(0,-1,-1,-2,-2),          dispersion = list(3, 6, 9)),
		list(mode_name="long bursts",	burst=12, move_delay=9, burst_accuracy = list(0,-1,-1,-2,-2,-2,-3,-3), dispersion = list(8))
		)


	var/obj/item/minigunpack/source

/obj/item/gun/projectile/automatic/rifle/minigun/special_check(var/mob/user)
	if(!wielded)
		to_chat(user, "<span class='danger'>You cannot fire this weapon with just one hand!</span>")
		return 0

	if (user.back!= source)
		to_chat(user, "<span class='warning'>\The [source] must be worn to fire \the [src]!</span>")
		return 0

	return ..()

/obj/item/gun/projectile/automatic/rifle/minigun/load_ammo(var/obj/item/A, mob/user)
	return

/obj/item/gun/projectile/automatic/rifle/minigun/unload_ammo(mob/user, var/allow_dump=1)
	return

/obj/item/gun/projectile/automatic/rifle/minigun/dropped(mob/user)
	..()
	if(source)
		to_chat(user, "<span class='notice'>\The [src] snaps back onto \the [source].</span>")
		INVOKE_ASYNC(source, /obj/item/minigunpack/.proc/remove_gun)
		source.update_icon()
		user.update_inv_back()

/obj/item/gun/projectile/automatic/rifle/minigun/Move()
	..()
	if(loc != source.loc)
		INVOKE_ASYNC(source, /obj/item/minigunpack/.proc/remove_gun)
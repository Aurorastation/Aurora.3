/obj/item/weapon/gun/projectile/boltaction
	name = "\improper bolt action rifle"
	desc = "A cheap ballistic rifle often found in the hands of crooks and frontiersmen. Uses 7.62mm rounds."
	icon_state = "moistnugget"
	item_state = "moistnugget"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	fire_sound = 'sound/weapons/rifleshot.ogg'
	slot_flags = SLOT_BACK
	load_method = SINGLE_CASING|SPEEDLOADER
	handle_casings = HOLD_CASINGS
	caliber = "a762"
	ammo_type = /obj/item/ammo_casing/a762
	max_shells = 5
	w_class = 4.0
	force = 10
	var/recentpump = 0

	action_button_name = "Wield rifle"

/obj/item/weapon/gun/projectile/boltaction/can_wield()
	return 1

/obj/item/weapon/gun/projectile/boltaction/ui_action_click()
	if(src in usr)
		toggle_wield(usr)

/obj/item/weapon/gun/projectile/boltaction/verb/wield_shotgun()
	set name = "Wield rifle"
	set category = "Object"
	set src in usr

	toggle_wield(usr)

/obj/item/weapon/gun/projectile/boltaction/consume_next_projectile()
	if(chambered)
		return chambered.BB
	return null

/obj/item/weapon/gun/projectile/boltaction/attack_self(mob/living/user as mob)
	if(world.time >= recentpump + 10)
		pump(user)
		recentpump = world.time

/obj/item/weapon/gun/projectile/boltaction/proc/pump(mob/M as mob)
	if(!wielded)
		M << "<span class='warning'>You cannot work the rifle's bolt without gripping it with both hands!</span>"
		return

	playsound(M, 'sound/weapons/riflebolt.ogg', 60, 1)

	if(chambered)//We have a shell in the chamber
		chambered.loc = get_turf(src)//Eject casing
		chambered = null

	if(loaded.len)
		var/obj/item/ammo_casing/AC = loaded[1] //load next casing.
		loaded -= AC //Remove casing from loaded list.
		chambered = AC

	update_icon()


/obj/item/weapon/gun/projectile/boltaction/attackby(var/obj/item/A as obj, mob/user as mob)
	if(istype(A, /obj/item/weapon/circular_saw) || istype(A, /obj/item/weapon/melee/energy) || istype(A, /obj/item/weapon/gun/energy/plasmacutter) && w_class != 3)
		user << "<span class='notice'>You begin to shorten the barrel and stock of \the [src].</span>"
		if(loaded.len)
			afterattack(user, user)
			playsound(user, fire_sound, 50, 1)
			user.visible_message("<span class='danger'>[src] goes off!</span>", "<span class='danger'>The rifle goes off in your face!</span>")
			return
		if(do_after(user, 30))
			icon_state = "obrez"
			w_class = 3
			recoil = 2
			accuracy = -2
			item_state = "obrez"
			slot_flags &= ~SLOT_BACK
			slot_flags |= (SLOT_BELT|SLOT_HOLSTER)
			name = "\improper obrez"
			desc = "A shortened bolt action rifle, not really acurate. Uses 7.62mm rounds."
			user << "<span class='warning'>You shorten the barrel and stock of the rifle!</span>"
	else
		..()

/obj/item/weapon/gun/projectile/boltaction/obrez
	name = "obrez"
	desc = "A shortened bolt action rifle, not really accurate. Uses 7.62mm rounds."
	icon_state = "obrez"
	item_state = "obrez"
	w_class = 3
	recoil = 2
	accuracy = -2
	slot_flags = SLOT_BELT|SLOT_HOLSTER

/obj/item/weapon/gun/projectile/contender
	name = "pocket rifle"
	desc = "A perfect, pristine replica of an ancient one-shot hand-cannon. This one has been modified to work almost like a bolt-action. Uses 5.56mm rounds."
	icon_state = "pockrifle"
	item_state = "obrez"
	caliber = "a556"
	handle_casings = HOLD_CASINGS
	max_shells = 1
	ammo_type = /obj/item/ammo_casing/a556
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	load_method = SINGLE_CASING
	fire_sound = 'sound/weapons/rifleshot.ogg'
	var/retracted_bolt = 0
	var/icon_retracted = "pockrifle-empty"

/obj/item/weapon/gun/projectile/contender/special_check(mob/user)
	if(retracted_bolt)
		user << "<span class='warning'>You can't fire \the [src] while the bolt is open!</span>"
		return 0
	return ..()

/obj/item/weapon/gun/projectile/contender/attack_self(mob/user as mob)
	if(chambered)
		chambered.loc = get_turf(src)
		chambered = null
		var/obj/item/ammo_casing/C = loaded[1]
		loaded -= C

	if(!retracted_bolt)
		to_chat(user, "<span class='notice'>You cycle back the bolt on \the [src], ejecting the casing and allowing you to reload.</span>")
		playsound(user, 'sound/weapons/riflebolt.ogg', 60, 1)
		icon_state = icon_retracted
		retracted_bolt = 1
		return 1

	else if(retracted_bolt && loaded.len)
		to_chat(user, "<span class='notice'>You cycle the loaded round into the chamber, allowing you to fire.</span>")

	else
		to_chat(user, "<span class='notice'>You cycle the bolt back into position, leaving the gun empty.</span>")

	icon_state = initial(icon_state)
	retracted_bolt = 0

/obj/item/weapon/gun/projectile/contender/load_ammo(var/obj/item/A, mob/user)
	if(!retracted_bolt)
		to_chat(user, "<span class='notice'>You can't load \the [src] without cycling the bolt.</span>")
		return
	..()
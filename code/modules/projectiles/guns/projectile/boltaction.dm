/obj/item/weapon/gun/projectile/boltaction
	name = "\improper bolt action rifle"
	desc = "A cheap ballistic rifle often found in the hands of crooks and frontiersmen. Uses 7.62mm rounds."
	icon_state = "moistnugget"
	item_state = "moistnugget"
	origin_tech = "combat=2;materials=2"
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
	if(istype(A, /obj/item/weapon/circular_saw) || istype(A, /obj/item/weapon/melee/energy) || istype(A, /obj/item/weapon/pickaxe/plasmacutter) && w_class != 3)
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
			item_state = "gun"
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
	item_state = "gun"
	w_class = 3
	recoil = 2
	accuracy = -2
	slot_flags = SLOT_BELT|SLOT_HOLSTER

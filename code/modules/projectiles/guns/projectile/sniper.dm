/obj/item/gun/projectile/heavysniper
	name = "anti-materiel rifle"
	desc = "A portable anti-armour rifle fitted with a scope, the PTR-7 is capable of punching through windows and non-reinforced walls with ease. Fires armor piercing 14.5mm shells."
	icon_state = "heavysniper"
	item_state = "heavysniper"
	w_class = 4
	force = 10
	slot_flags = SLOT_BACK
	origin_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 2, TECH_ILLEGAL = 8)
	caliber = "14.5mm"
	recoil = 4 //extra kickback
	handle_casings = HOLD_CASINGS
	load_method = SINGLE_CASING
	max_shells = 1
	ammo_type = /obj/item/ammo_casing/a145
	//+2 accuracy over the LWAP because only one shot
	accuracy = -3
	scoped_accuracy = 4
	var/bolt_open = 0

	is_wieldable = TRUE

	fire_sound = 'sound/weapons/gunshot/gunshot_dmr.ogg'

	recoil_wielded = 2
	accuracy_wielded = -1

/obj/item/gun/projectile/heavysniper/update_icon()
	if(bolt_open)
		icon_state = "heavysniper-open"
	else
		icon_state = "heavysniper"
	if(wielded)
		item_state = "heavysniper-wielded"
	else
		item_state = "heavysniper"
	update_held_icon()

/obj/item/gun/projectile/heavysniper/attack_self(mob/user as mob)
	playsound(src.loc, 'sound/weapons/flipblade.ogg', 50, 1)
	bolt_open = !bolt_open
	if(bolt_open)
		if(chambered)
			to_chat(user, "<span class='notice'>You work the bolt open, ejecting [chambered]!</span>")
			chambered.forceMove(get_turf(src))
			loaded -= chambered
			chambered = null
		else
			to_chat(user, "<span class='notice'>You work the bolt open.</span>")
	else
		to_chat(user, "<span class='notice'>You work the bolt closed.</span>")
		bolt_open = 0
	add_fingerprint(user)
	update_icon()

/obj/item/gun/projectile/heavysniper/special_check(mob/user)
	if(bolt_open)
		to_chat(user, "<span class='warning'>You can't fire [src] while the bolt is open!</span>")
		return 0
	if(!wielded)
		to_chat(user, "<span class='warning'>You can't fire without stabilizing the rifle!</span>")
		return 0
	return ..()

/obj/item/gun/projectile/heavysniper/load_ammo(var/obj/item/A, mob/user)
	if(!bolt_open)
		return
	..()

/obj/item/gun/projectile/heavysniper/unload_ammo(mob/user, var/allow_dump=1)
	if(!bolt_open)
		return
	..()

/obj/item/gun/projectile/heavysniper/verb/scope()
	set category = "Object"
	set name = "Use Scope"
	set popup_menu = 1

	if(wielded)
		toggle_scope(2.0, usr)
	else
		to_chat(usr, "<span class='warning'>You can't look through the scope without stabilizing the rifle!</span>")

/obj/item/gun/projectile/heavysniper/tranq
	name = "tranquilizer rifle"
	desc = "A nonlethal modification to the PTR-7 anti-materiel rifle meant for sedation and capture of the most dangerous of game. Fires .50 cal PPS shells that deploy a torpor inducing drug payload."
	icon_state = "tranqsniper"
	item_state = "heavysniper"
	w_class = 4
	force = 10
	slot_flags = SLOT_BACK
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 2)
	caliber = "PPS"
	recoil = 1
	silenced = 1
	fire_sound = 'sound/weapons/gunshot/gunshot_light.ogg'
	max_shells = 4
	ammo_type = null
	accuracy = -3
	scoped_accuracy = 4
	bolt_open = 0
	muzzle_flash = 1

	recoil_wielded = 1
	accuracy_wielded = 2

/obj/item/gun/projectile/heavysniper/tranq/update_icon()
	if(bolt_open)
		icon_state = "tranqsniper-open"
	else
		icon_state = "tranqsniper"
	if(wielded)
		item_state = "heavysniper-wielded"
	else
		item_state = "heavysniper"
	update_held_icon()

/obj/item/gun/projectile/dragunov
	name = "antique sniper rifle"
	desc = "An old Dragunov semi-automatic marksman rifle. Smells of vodka and Communism. Uses 7.62mm rounds."
	icon_state = "dragunov"
	item_state = "dragunov"
	w_class = 4
	force = 10
	slot_flags = SLOT_BACK
	origin_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 3, TECH_MAGNET = 2, TECH_ILLEGAL = 5)
	caliber = "a762"
	recoil = 2
	fire_sound = 'sound/weapons/gunshot/gunshot_svd.ogg'
	load_method = MAGAZINE
	max_shells = 10
	magazine_type = /obj/item/ammo_magazine/d762
	allowed_magazines = list(/obj/item/ammo_magazine/d762)
	accuracy = -4
	scoped_accuracy = 3

	is_wieldable = TRUE

	recoil_wielded = 1
	accuracy_wielded = 1

/obj/item/gun/projectile/dragunov/update_icon()

	if(ammo_magazine)
		icon_state = "dragunov"
	else
		icon_state = "dragunov-empty"

	if(wielded)
		item_state = "dragunov-wielded"
	else
		item_state = "dragunov"

	update_held_icon()

/obj/item/gun/projectile/dragunov/special_check(mob/user)
	if(!wielded)
		to_chat(user, "<span class='warning'>You can't fire without stabilizing the rifle!</span>")
		return 0
	return ..()

/obj/item/gun/projectile/dragunov/verb/scope()
	set category = "Object"
	set name = "Use Scope"
	set popup_menu = 1

	if(wielded)
		toggle_scope(2.0, usr)
	else
		to_chat(usr, "<span class='warning'>You can't look through the scope without stabilizing the rifle!</span>")

/obj/item/gun/projectile/automatic/rifle/w556
	name = "scout rifle"
	desc = "A lightweight Neyland 556mi 'Ranger' used within the Sol Navy and Nanotrasen Emergency Response Teams. Equipped with a scope and designed for medium to long range combat, with moderate stopping power. Chambered in 5.56 rounds."
	icon_state = "w556rifle"
	item_state = "heavysniper"
	w_class = 4
	force = 10
	slot_flags = SLOT_BACK
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 3)
	caliber = "a556"
	recoil = 4
	load_method = MAGAZINE
	fire_sound = 'sound/weapons/gunshot/gunshot_dmr.ogg'
	max_shells = 10
	ammo_type = /obj/item/ammo_casing/a556/ap
	magazine_type = /obj/item/ammo_magazine/a556/ap
	allowed_magazines = list(/obj/item/ammo_magazine/a556, /obj/item/ammo_magazine/a556/ap)
	accuracy = -4
	scoped_accuracy = 3
	recoil_wielded = 2
	accuracy_wielded = 1
	multi_aim = 0 //Definitely a fuck no. Being able to target one person at this range is plenty.

	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=0,    move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="2-round bursts", burst=2, fire_delay=null, move_delay=4,    burst_accuracy=list(0,-1,-1), dispersion=list(0, 8))
		)

/obj/item/gun/projectile/automatic/rifle/w556/verb/scope()
	set category = "Object"
	set name = "Use Scope"
	set popup_menu = 1

	if(wielded)
		toggle_scope(2.0, usr)
	else
		to_chat(usr, "<span class='warning'>You can't look through the scope without stabilizing the rifle!</span>")

/obj/item/gun/projectile/automatic/rifle/w556/update_icon()
	if(wielded)
		item_state = "heavysniper-wielded"
	else
		item_state = "heavysniper"
	update_held_icon()
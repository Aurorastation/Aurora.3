/obj/item/weapon/gun/projectile/heavysniper
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
	scoped_accuracy = 2
	var/bolt_open = 0

	fire_sound = 'sound/weapons/Gunshot_DMR.ogg'

	recoil_wielded = 2
	accuracy_wielded = -1

	//action button for wielding
	action_button_name = "Wield rifle"

/obj/item/weapon/gun/projectile/heavysniper/can_wield()
	return 1

/obj/item/weapon/gun/projectile/heavysniper/ui_action_click()
	if(src in usr)
		toggle_wield(usr)

/obj/item/weapon/gun/projectile/heavysniper/verb/wield_rifle()
	set name = "Wield rifle"
	set category = "Object"
	set src in usr

	toggle_wield(usr)
	usr.update_icon()

/obj/item/weapon/gun/projectile/heavysniper/update_icon()
	if(bolt_open)
		icon_state = "heavysniper-open"
	else
		icon_state = "heavysniper"
	if(wielded)
		item_state = "heavysniper-wielded"
	else
		item_state = "heavysniper"
	update_held_icon()

/obj/item/weapon/gun/projectile/heavysniper/attack_self(mob/user as mob)
	playsound(src.loc, 'sound/weapons/flipblade.ogg', 50, 1)
	bolt_open = !bolt_open
	if(bolt_open)
		if(chambered)
			user << "<span class='notice'>You work the bolt open, ejecting [chambered]!</span>"
			chambered.loc = get_turf(src)
			loaded -= chambered
			chambered = null
		else
			user << "<span class='notice'>You work the bolt open.</span>"
	else
		user << "<span class='notice'>You work the bolt closed.</span>"
		bolt_open = 0
	add_fingerprint(user)
	update_icon()

/obj/item/weapon/gun/projectile/heavysniper/special_check(mob/user)
	if(bolt_open)
		user << "<span class='warning'>You can't fire [src] while the bolt is open!</span>"
		return 0
	if(!wielded)
		user << "<span class='warning'>You can't fire without stabilizing the rifle!</span>"
		return 0
	return ..()

/obj/item/weapon/gun/projectile/heavysniper/load_ammo(var/obj/item/A, mob/user)
	if(!bolt_open)
		return
	..()

/obj/item/weapon/gun/projectile/heavysniper/unload_ammo(mob/user, var/allow_dump=1)
	if(!bolt_open)
		return
	..()

/obj/item/weapon/gun/projectile/heavysniper/verb/scope()
	set category = "Object"
	set name = "Use Scope"
	set popup_menu = 1

	if(wielded)
		toggle_scope(2.0, usr)
	else
		usr << "<span class='warning'>You can't look through the scope without stabilizing the rifle!</span>"

/obj/item/weapon/gun/projectile/heavysniper/tranq
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
	fire_sound = 'sound/weapons/Gunshot_light.ogg'
	handle_casings = HOLD_CASINGS
	load_method = SINGLE_CASING
	magazine_type = null
	allowed_magazines = list(/obj/item/ammo_magazine/tranq)
	max_shells = 4
	ammo_type = null
	accuracy = -3
	scoped_accuracy = 3
	bolt_open = 0
	muzzle_flash = 1

	recoil_wielded = 1
	accuracy_wielded = 2

/obj/item/weapon/gun/projectile/heavysniper/tranq/update_icon()
	if(bolt_open)
		icon_state = "tranqsniper-open"
	else
		icon_state = "tranqsniper"
	if(wielded)
		item_state = "heavysniper-wielded"
	else
		item_state = "heavysniper"
	update_held_icon()
/obj/item/weapon/gun/projectile/dragunov
	name = "antique sniper rifle"
	desc = "An old Dragunov semi-automatic marksman rifle. Smells of vodka and Communism. Uses 7.62mm rounds."
	icon = 'icons/obj/dragunov.dmi'
	icon_state = "dragunov"
	item_state = "dragunov"
	contained_sprite = 1
	w_class = 4
	force = 10
	slot_flags = SLOT_BACK
	origin_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 3, TECH_MAGNET = 2, TECH_ILLEGAL = 5)
	caliber = "a762"
	recoil = 2
	fire_sound = 'sound/weapons/svd_shot.ogg'
	load_method = MAGAZINE
	max_shells = 10
	magazine_type = /obj/item/ammo_magazine/d762
	allowed_magazines = list(/obj/item/ammo_magazine/d762)
	accuracy = -4
	scoped_accuracy = 2

	recoil_wielded = 1
	accuracy_wielded = 0

	//action button for wielding
	action_button_name = "Wield rifle"

/obj/item/weapon/gun/projectile/dragunov/update_icon()

	if(ammo_magazine)
		icon_state = "dragunov"
	else
		icon_state = "dragunov-empty"

/obj/item/weapon/gun/projectile/dragunov/can_wield()
	return 1

/obj/item/weapon/gun/projectile/dragunov/ui_action_click()
	if(src in usr)
		toggle_wield(usr)

/obj/item/weapon/gun/projectile/dragunov/verb/wield_rifle()
	set name = "Wield rifle"
	set category = "Object"
	set src in usr

	toggle_wield(usr)

/obj/item/weapon/gun/projectile/dragunov/special_check(mob/user)
	if(!wielded)
		user << "<span class='warning'>You can't fire without stabilizing the rifle!</span>"
		return 0
	return ..()

/obj/item/weapon/gun/projectile/dragunov/verb/scope()
	set category = "Object"
	set name = "Use Scope"
	set popup_menu = 1

	if(wielded)
		toggle_scope(2.0, usr)
	else
		usr << "<span class='warning'>You can't look through the scope without stabilizing the rifle!</span>"

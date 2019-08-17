/obj/item/weapon/gun/projectile/cannon
	name = "hand cannon"
	desc = "An amalgamation of ancient and modern tajaran technology. This old naval cannon was turned into a portable firearm."
	icon_state = "cannon"
	item_state = "cannon"
	caliber = "cannon"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3)
	load_method = SINGLE_CASING
	handle_casings = DELETE_CASINGS
	slot_flags = SLOT_BACK
	max_shells = 1
	ammo_type = /obj/item/ammo_casing/cannon
	fire_delay = 25
	fire_sound = 'sound/effects/Explosion1.ogg'
	recoil = 4

	action_button_name = "Wield hand cannon"

	is_wieldable = TRUE

/obj/item/weapon/gun/projectile/cannon/update_icon()
	if(wielded)
		item_state = "cannon-wielded"
	else
		item_state = "cannon"
	update_held_icon()


/obj/item/weapon/gun/projectile/cannon/special_check(mob/user)
	if(!wielded)
		to_chat(user, "<span class='warning'>You can't fire without stabilizing \the [src]!</span>")
		return 0
	return ..()
/obj/item/gun/projectile/cannon
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

	is_wieldable = TRUE

	description_fluff = "The adhomian hand cannon was created due the shortage of weapons that happened in the New Kingdom of Adhomai during the second civil war. Old naval culverins \
	found in museums and forgotten warehouses were adapted into portable weapons, combining modern and ancient tajaran technology. This weapon is usually found in the hands of the \
	sailors and marines of the Royal Navy."

/obj/item/gun/projectile/cannon/update_icon()
	if(wielded)
		item_state = "cannon-wielded"
	else
		item_state = "cannon"
	update_held_icon()


/obj/item/gun/projectile/cannon/special_check(mob/user)
	if(!wielded)
		to_chat(user, "<span class='warning'>You can't fire without stabilizing \the [src]!</span>")
		return 0
	return ..()
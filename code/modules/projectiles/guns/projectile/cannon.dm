/obj/item/gun/projectile/cannon
	name = "hand cannon"
	desc = "An amalgamation of ancient and modern tajaran technology. This old naval cannon was turned into a portable firearm."
	icon = 'icons/obj/guns/cannon.dmi'
	icon_state = "cannon"
	item_state = "cannon"
	caliber = "cannon"
	w_class = ITEMSIZE_LARGE
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

/obj/item/gun/projectile/nuke
	name = "nuclear launcher"
	desc = "A launcher weapon designated to fire miniaturized nuclear warheads."
	icon = 'icons/obj/guns/blockbuster.dmi' // hoh
	icon_state = "blockbuster"
	item_state = "blockbuster"
	caliber = "nuke"
	w_class = ITEMSIZE_LARGE
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 4)
	load_method = MAGAZINE
	handle_casings = DELETE_CASINGS
	slot_flags = SLOT_BACK
	magazine_type = /obj/item/ammo_magazine/nuke
	allowed_magazines = list(/obj/item/ammo_magazine/nuke)
	fire_delay = 40
	fire_sound = 'sound/weapons/empty.ogg'
	recoil = 4

	auto_eject = TRUE

	is_wieldable = TRUE

	description_fluff = "The People's Republic of Adhomai is the only Adhomian faction able to master the nuclear fission. Atomic weapons were used before in the tajaran civil war, \
	causing the annihilation of the military base of Quizosa. The nuclear launcher was created by republican scientists as way to deploy this destructive force while on the field."

/obj/item/gun/projectile/nuke/update_icon()
	if(ammo_magazine)
		icon_state = "blockbuster-[(ammo_magazine.stored_ammo.len)]"
	else
		icon_state = "blockbuster-0"

	if(wielded)
		item_state = "blockbuster-wielded"
	else
		item_state = "blockbuster"

	update_held_icon()

/obj/item/gun/projectile/nuke/special_check(mob/user)
	if(!wielded)
		to_chat(user, "<span class='warning'>You can't fire without stabilizing \the [src]!</span>")
		return 0
	return ..()
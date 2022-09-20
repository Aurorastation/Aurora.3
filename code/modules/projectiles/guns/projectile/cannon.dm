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
	fire_sound = 'sound/weapons/gunshot/cannon.ogg'
	recoil = 4

	is_wieldable = TRUE

	desc_lore = "The adhomian hand cannon was created due the shortage of weapons that happened in the New Kingdom of Adhomai during the second civil war. Old naval culverins \
	found in museums and forgotten warehouses were adapted into portable weapons, combining modern and ancient tajaran technology. This weapon is usually found in the hands of the \
	sailors and marines of the Royal Navy."

/obj/item/gun/projectile/cannon/special_check(mob/user)
	if(!wielded)
		to_chat(user, SPAN_WARNING("You can't fire without stabilizing \the [src]!"))
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
	fire_sound = 'sound/weapons/mortar.ogg'
	recoil = 4

	auto_eject = TRUE

	is_wieldable = TRUE

	desc_lore = "The People's Republic of Adhomai is the first Adhomian faction able to master the nuclear fission. Atomic weapons were used before in the tajaran civil war, \
	causing the annihilation of the military base of Quizosa. The nuclear launcher was created by republican scientists as way to deploy this destructive force while on the field."

/obj/item/gun/projectile/nuke/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "blockbuster-[(ammo_magazine.stored_ammo.len)]"
	else
		icon_state = "blockbuster-0"

/obj/item/gun/projectile/nuke/special_check(mob/user)
	if(!wielded)
		to_chat(user, SPAN_WARNING("You can't fire without stabilizing \the [src]!"))
		return 0
	return ..()

/obj/item/gun/projectile/recoilless_rifle
	name = "adhomian recoilless rifle"
	desc = "An inexpensive, one use anti-tank weapon used extensively by the Tajaran armed forces."
	icon = 'icons/obj/guns/recoilless_rifle.dmi'
	icon_state = "recoilless_rifle"
	item_state = "recoilless_rifle"
	caliber = "recoilless_rifle"
	w_class = ITEMSIZE_LARGE
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3)
	slot_flags = null
	fire_sound = 'sound/weapons/recoilless_rifle.ogg'
	recoil = 0
	ammo_type = /obj/item/ammo_casing/recoilless_rifle

	is_wieldable = TRUE

	load_method = SINGLE_CASING
	handle_casings = DELETE_CASINGS

	max_shells = 1

/obj/item/gun/projectile/recoilless_rifle/update_icon()
	..()
	if(loaded.len)
		icon_state = "recoilless_rifle"
		item_state = "recoilless_rifle"
	else
		icon_state = "recoilless_rifle-empty"
		item_state = "recoilless_rifle-empty"


/obj/item/gun/projectile/recoilless_rifle/special_check(mob/user)
	if(!wielded)
		to_chat(user, SPAN_WARNING("You can't fire without stabilizing \the [src]!"))
		return 0
	return ..()

/obj/item/gun/projectile/recoilless_rifle/load_ammo(var/obj/item/A, mob/user)
	return FALSE

/obj/item/gun/projectile/recoilless_rifle/unload_ammo(mob/user, var/allow_dump = 1, var/drop_mag = FALSE)
	return FALSE

/obj/item/gun/projectile/peac
	name = "point entry anti-materiel cannon"
	desc = "An SCC-designed, man-portable cannon meant to neutralize mechanized threats. The disgustingly large accelerator capacitors make room for only one shot, so make it count."
	icon = 'icons/obj/guns/peac.dmi'
	icon_state = "peac"
	item_state = "peac"
	caliber = "peac"
	w_class = ITEMSIZE_LARGE
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 5)
	load_method = SINGLE_CASING
	fire_sound = 'sound/weapons/gunshot/cannon.ogg'
	slot_flags = null
	ammo_type = /obj/item/ammo_casing/peac
	accuracy_wielded = 4

	fire_delay = 20

	recoil = 0

	auto_eject = TRUE

	is_wieldable = TRUE

	max_shells = 1

/obj/item/gun/projectile/peac/update_icon()
	..()
	if(loaded.len)
		icon_state = "peac"
		item_state = "peac"
	else
		icon_state = "peac-empty"
		item_state = "peac-empty"

/obj/item/gun/projectile/peac/special_check(mob/user)
	if(!wielded)
		to_chat(user, SPAN_WARNING("You can't fire without stabilizing \the [src]!"))
		return 0
	return ..()

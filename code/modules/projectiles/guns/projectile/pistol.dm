/obj/item/weapon/gun/projectile/colt
	name = "vintage .45 pistol"
	desc = "A cheap Martian knock-off of a Colt M1911. Uses .45 rounds."
	magazine_type = /obj/item/ammo_magazine/c45m
	allowed_magazines = list(/obj/item/ammo_magazine/c45m)
	icon_state = "colt"
	caliber = ".45"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	fire_sound = 'sound/weapons/Gunshot_light.ogg'
	load_method = MAGAZINE

/obj/item/weapon/gun/projectile/colt/update_icon()
	..()
	if(ammo_magazine && ammo_magazine.stored_ammo.len)
		icon_state = "colt"
	else
		icon_state = "colt-e"

/obj/item/weapon/gun/projectile/colt/detective
	magazine_type = /obj/item/ammo_magazine/c45m/rubber

/obj/item/weapon/gun/projectile/colt/detective/verb/rename_gun()
	set name = "Name Gun"
	set category = "Object"
	set desc = "Rename your gun. If you're the detective."

	var/mob/M = usr
	if(!M.mind)	return 0
	if(!M.mind.assigned_role == "Detective")
		M << "<span class='notice'>You don't feel cool enough to name this gun, chump.</span>"
		return 0

	var/input = sanitizeSafe(input("What do you want to name the gun?", ,""), MAX_NAME_LEN)

	if(src && input && !M.stat && in_range(M,src))
		name = input
		M << "You name the gun [input]. Say hello to your new friend."
		return 1

/obj/item/weapon/gun/projectile/sec
	name = ".45 pistol"
	desc = "A NanoTrasen designed sidearm, found pretty much everywhere humans are. Uses .45 rounds."
	icon_state = "secguncomp"
	magazine_type = /obj/item/ammo_magazine/c45m/rubber
	allowed_magazines = list(/obj/item/ammo_magazine/c45m)
	caliber = ".45"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	fire_sound = 'sound/weapons/gunshot_pistol.ogg'
	load_method = MAGAZINE

/obj/item/weapon/gun/projectile/sec/update_icon()
	..()
	if(ammo_magazine && ammo_magazine.stored_ammo.len)
		icon_state = "secguncomp"
	else
		icon_state = "secguncomp-e"

/obj/item/weapon/gun/projectile/sec/lethal
	magazine_type = /obj/item/ammo_magazine/c45m

/obj/item/weapon/gun/projectile/sec/flash
	name = ".45 signal pistol"
	magazine_type = /obj/item/ammo_magazine/c45m/flash

/obj/item/weapon/gun/projectile/sec/wood
	desc = "A Nanotrasen designed sidearm, this one has a sweet wooden grip. Uses .45 rounds."
	name = "custom .45 Pistol"
	icon_state = "secgundark"

/obj/item/weapon/gun/projectile/sec/wood/update_icon()
	..()
	if(ammo_magazine && ammo_magazine.stored_ammo.len)
		icon_state = "secgundark"
	else
		icon_state = "secgundark-e"

/obj/item/weapon/gun/projectile/automatic/x9
	name = "automatic .45 pistol"
	desc = "The x9 tactical pistol is a lightweight fast firing handgun. Uses .45 rounds."
	icon_state = "x9tactical"
	w_class = 3
	load_method = MAGAZINE
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	max_shells = 16
	caliber = ".45"
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2)
	ammo_type = /obj/item/ammo_casing/c45
	magazine_type = /obj/item/ammo_magazine/c45x
	allowed_magazines = list(/obj/item/ammo_magazine/c45x)
	multi_aim = 1
	auto_eject = 1
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'

/obj/item/weapon/gun/projectile/tanto
	desc = "A Necropolis Industries Tanto .40, designed to compete with the NT Mk58. Uses 10mm rounds."
	name = "10mm pistol"
	icon_state = "c05r"
	magazine_type = /obj/item/ammo_magazine/t40
	allowed_magazines = list(/obj/item/ammo_magazine/t40)
	caliber = "10mm"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	fire_sound = 'sound/weapons/Gunshot_light.ogg'
	load_method = MAGAZINE
	sel_mode = 1

	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=0,    move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=4,    burst_accuracy=list(0,-1,-1),       dispersion=list(0, 10))
		)


/obj/item/weapon/gun/projectile/tanto/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "c05r"
	else
		icon_state = "c05r-e"

/obj/item/weapon/gun/projectile/silenced
	name = "silenced pistol"
	desc = "A small, quiet,  easily concealable gun. Uses .45 rounds."
	icon_state = "silenced_pistol"
	w_class = 3
	caliber = ".45"
	silenced = 1
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_ILLEGAL = 8)
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/c45m
	allowed_magazines = list(/obj/item/ammo_magazine/c45m)

/obj/item/weapon/gun/projectile/deagle
	name = ".50 magnum pistol"
	desc = "A robust handgun that uses .50 AE ammo."
	icon_state = "deagle"
	force = 14.0
	caliber = ".50"
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/a50
	allowed_magazines = list(/obj/item/ammo_magazine/a50)
	auto_eject = 1
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'

/obj/item/weapon/gun/projectile/deagle/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "[initial(icon_state)]"
	else
		icon_state = "[initial(icon_state)]-e"

/obj/item/weapon/gun/projectile/deagle/gold
	desc = "A gold plated gun folded over a million times by superior martian gunsmiths. Uses .50 AE ammo."
	icon_state = "deagleg"
	item_state = "deagleg"

/obj/item/weapon/gun/projectile/deagle/camo
	desc = "A Deagle brand Deagle for operators operating operationally. Uses .50 AE ammo."
	icon_state = "deaglecamo"

/obj/item/weapon/gun/projectile/gyropistol
	name = "gyrojet pistol"
	desc = "A bulky pistol designed to fire self propelled rounds"
	icon_state = "gyropistol"
	max_shells = 8
	caliber = "75"
	fire_sound = 'sound/effects/Explosion1.ogg'
	origin_tech = list(TECH_COMBAT = 3)
	ammo_type = "/obj/item/ammo_casing/a75"
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/a75
	allowed_magazines = list(/obj/item/ammo_magazine/a75)
	auto_eject = 1
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'

/obj/item/weapon/gun/projectile/gyropistol/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "gyropistolloaded"
	else
		icon_state = "gyropistol"

/obj/item/weapon/gun/projectile/pistol
	name = "9mm pistol"
	desc = "500 years since its creation and the Stechkin automatic pistol is still a common sight throughout the Frontier."
	icon_state = "pistol"
	item_state = null
	w_class = 2
	caliber = "9mm"
	silenced = 0
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_ILLEGAL = 2)
	fire_sound = 'sound/weapons/gunshot_pistol.ogg'
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/mc9mm
	allowed_magazines = list(/obj/item/ammo_magazine/mc9mm)

/obj/item/weapon/gun/projectile/pistol/flash
	name = "9mm signal pistol"
	magazine_type = /obj/item/ammo_magazine/mc9mm/flash

/obj/item/weapon/gun/projectile/pistol/attack_hand(mob/user as mob)
	if(user.get_inactive_hand() == src)
		if(silenced)
			if(user.l_hand != src && user.r_hand != src)
				..()
				return
			user << "<span class='notice'>You unscrew [silenced] from [src].</span>"
			user.put_in_hands(silenced)
			silenced = 0
			w_class = 2
			update_icon()
			return
	..()

/obj/item/weapon/gun/projectile/pistol/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/weapon/silencer))
		if(user.l_hand != src && user.r_hand != src)	//if we're not in his hands
			user << "<span class='notice'>You'll need [src] in your hands to do that.</span>"
			return
		user.drop_from_inventory(I,src)
		user << "<span class='notice'>You screw [I] onto [src].</span>"
		silenced = I	//dodgy?
		w_class = 3
		update_icon()
		return
	..()

/obj/item/weapon/gun/projectile/pistol/update_icon()
	..()
	if(silenced)
		icon_state = "pistol-silencer"
	else
		icon_state = "pistol"

/obj/item/weapon/gun/projectile/pistol/update_icon()
	..()
	if(silenced)
		icon_state = "pistol-silencer"
	else
		icon_state = "pistol"
	if(!(ammo_magazine && ammo_magazine.stored_ammo.len))
		icon_state = "[icon_state]-e"

/obj/item/weapon/silencer
	name = "silencer"
	desc = "A silencer"
	icon = 'icons/obj/gun.dmi'
	icon_state = "silencer"
	w_class = 2

/obj/item/weapon/gun/projectile/pirate
	name = "zip gun"
	desc = "Little more than a barrel, handle, and firing mechanism, cheap makeshift firearms like this one are not uncommon in frontier systems."
	icon_state = "zipgun"
	item_state = "sawnshotgun"
	handle_casings = CYCLE_CASINGS //player has to take the old casing out manually before reloading
	load_method = SINGLE_CASING
	max_shells = 1 //literally just a barrel

	var/global/list/ammo_types = list(
		/obj/item/ammo_casing/a357              = ".357",
		/obj/item/ammo_casing/shotgun           = "12 gauge",
		/obj/item/ammo_casing/shotgun           = "12 gauge",
		/obj/item/ammo_casing/shotgun/pellet    = "12 gauge",
		/obj/item/ammo_casing/shotgun/pellet    = "12 gauge",
		/obj/item/ammo_casing/shotgun/beanbag   = "12 gauge",
		/obj/item/ammo_casing/shotgun/emp	= "12 gauge",
		/obj/item/ammo_casing/a762              = "7.62mm",
		/obj/item/ammo_casing/a556              = "5.56mm"
		)

/obj/item/weapon/gun/projectile/pirate/Initialize()
	ammo_type = pick(ammo_types)
	desc += " Uses [ammo_types[ammo_type]] rounds."

	var/obj/item/ammo_casing/ammo = ammo_type
	caliber = initial(ammo.caliber)
	. = ..()

/obj/item/weapon/gun/projectile/leyon
	name = "10mm pistol"
	desc = "The Leyon LCC Everyman is a small pistol that holds five shots and is loaded with a stripper clip, popular for self-defense on Mars. Uses 10mm rounds."
	icon_state = "leyon"
	caliber = "10mm"
	w_class = 2
	ammo_type = /obj/item/ammo_casing/t40
	max_shells = 5
	origin_tech = list(TECH_COMBAT = 1, TECH_MATERIAL = 1)
	fire_sound = 'sound/weapons/Gunshot_light.ogg'
	load_method = SINGLE_CASING|SPEEDLOADER

/obj/item/weapon/gun/projectile/leyon/update_icon()
	..()
	if(loaded.len)
		icon_state = "leyon"
	else
		icon_state = "leyon-e"
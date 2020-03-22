/obj/item/gun/projectile/colt
	name = "vintage .45 pistol"
	desc = "A cheap Martian knock-off of a Colt M1911. Uses .45 rounds."
	magazine_type = /obj/item/ammo_magazine/c45m
	allowed_magazines = list(/obj/item/ammo_magazine/c45m)
	icon = 'icons/obj/guns/colt.dmi'
	icon_state = "colt"
	item_state = "colt"
	caliber = ".45"
	accuracy = 1
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	fire_sound = 'sound/weapons/gunshot/gunshot_light.ogg'
	load_method = MAGAZINE

/obj/item/gun/projectile/colt/update_icon()
	..()
	if(ammo_magazine && ammo_magazine.stored_ammo.len)
		icon_state = "colt"
	else
		icon_state = "colt-e"

/obj/item/gun/projectile/colt/detective
	magazine_type = /obj/item/ammo_magazine/c45m/rubber

/obj/item/gun/projectile/colt/detective/verb/rename_gun()
	set name = "Name Gun"
	set category = "Object"
	set desc = "Rename your gun. If you're the detective."

	var/mob/M = usr
	if(!M.mind)	return 0
	if(!M.mind.assigned_role == "Detective")
		to_chat(M, "<span class='notice'>You don't feel cool enough to name this gun, chump.</span>")
		return 0

	var/input = sanitizeSafe(input("What do you want to name the gun?", ,""), MAX_NAME_LEN)

	if(src && input && !M.stat && in_range(M,src))
		name = input
		to_chat(M, "You name the gun [input]. Say hello to your new friend.")
		return 1

/obj/item/gun/projectile/sec
	name = ".45 pistol"
	desc = "A NanoTrasen designed sidearm, found among law enforcement and security forces. Uses .45 rounds."
	description_fluff = "The NT Mk58 is a ballistic sidearm developed and produced by Nanotrasen. Bulky and heavy, the Mk58 is nonetheless used by security forces and law enforcement for its ease of use, low maintenance requirement, longevity, reliability - and most of all, extremely inexpensive price tag. A trademark of Nanotrasen security forces. It uses .45 rounds."
	icon = 'icons/obj/guns/secgun.dmi'
	icon_state = "secgun"
	item_state = "secgun"
	magazine_type = /obj/item/ammo_magazine/c45m/rubber
	allowed_magazines = list(/obj/item/ammo_magazine/c45m)
	caliber = ".45"
	accuracy = 1
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	fire_sound = 'sound/weapons/gunshot/gunshot_pistol.ogg'
	load_method = MAGAZINE

/obj/item/gun/projectile/sec/update_icon()
	..()
	if(ammo_magazine?.stored_ammo.len)
		icon_state = "secgun"
	else
		icon_state = "secgun-e"

/obj/item/gun/projectile/sec/lethal
	magazine_type = /obj/item/ammo_magazine/c45m

/obj/item/gun/projectile/sec/flash
	name = ".45 signal pistol"
	magazine_type = /obj/item/ammo_magazine/c45m/flash

/obj/item/gun/projectile/sec/wood
	desc = "A NanoTrasen designed sidearm, found among law enforcement and security forces. It has a wooden grip. Uses .45 rounds."
	description_fluff = "The NT Mk58 is a ballistic sidearm developed and produced by Nanotrasen. Bulky and heavy, the Mk58 is nonetheless used by security forces and law enforcement for its ease of use, low maintenance requirement, longevity, reliability - and most of all, extremely inexpensive price tag. A trademark of Nanotrasen security forces. This one has a faux wooden grip. It uses .45 rounds."
	name = "custom .45 Pistol"
	icon = 'icons/obj/guns/secgun_wood.dmi'
	icon_state = "secgunwood"
	item_state = "secgunwood"

/obj/item/gun/projectile/sec/wood/update_icon()
	..()
	if(ammo_magazine?.stored_ammo.len)
		icon_state = "secgunwood"
	else
		icon_state = "secgunwood-e"

/obj/item/gun/projectile/sec/detective
	desc = "A compact NanoTrasen designed sidearm, popular with law enforcement personnel for concealed carry purposes. It has a faux wooden grip. Uses .45 rounds."
	description_fluff = "The NT Mk21 Blackjack is a ballistic sidearm developed and produced by Nanotrasen. Unlike the related Mk58, the Blackjack is a rather high quality piece - typically issued to higher ranking law enforcement personnel, the Mk21 is compact and chambered in .45 caliber. With all the bells and whistles of a modern, quality police pistol, the Blackjack's main drawback is the notoriously nippy recoil - .45 in such a small package does not play well with the average shooter."
	name = "compact .45 pistol"
	icon = 'icons/obj/guns/detgun.dmi'
	icon_state = "detgun"
	item_state = "detgun"
	w_class = ITEMSIZE_SMALL
	magazine_type = /obj/item/ammo_magazine/c45m

/obj/item/gun/projectile/sec/detective/update_icon()
	..()
	if(ammo_magazine?.stored_ammo.len)
		icon_state = "detgun"
	else
		icon_state = "detgunempty"

/obj/item/gun/projectile/automatic/x9
	name = "automatic .45 pistol"
	desc = "The x9 tactical pistol is a lightweight fast firing handgun. Uses .45 rounds."
	icon = 'icons/obj/guns/x9.dmi'
	icon_state = "x9tactical"
	item_state = "x9"
	w_class = 3
	accuracy = 1
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

/obj/item/gun/projectile/tanto
	desc = "A Necropolis Industries Tanto .40, designed to compete with the NT Mk58. Uses 10mm rounds."
	name = "10mm auto-pistol"
	icon = 'icons/obj/guns/c05r.dmi'
	icon_state = "c05r"
	item_state = "c05r"
	magazine_type = /obj/item/ammo_magazine/mc10mm
	allowed_magazines = list(/obj/item/ammo_magazine/mc10mm)
	caliber = "10mm"
	accuracy = 1
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	fire_sound = 'sound/weapons/gunshot/gunshot_pistol.ogg'
	load_method = MAGAZINE
	sel_mode = 1

	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=0,    move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=null,    burst_accuracy=list(1,0,0),       dispersion=list(0, 10))
		)


/obj/item/gun/projectile/tanto/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "c05r"
	else
		icon_state = "c05r-e"

/obj/item/gun/projectile/silenced
	name = "silenced pistol"
	desc = "A small, quiet, easily concealable gun. Uses .45 rounds."
	icon = 'icons/obj/guns/silenced_pistol.dmi'
	icon_state = "silenced_pistol"
	item_state = "silenced_pistol"
	fire_sound = 'sound/weapons/gunshot/gunshot_suppressed.ogg'
	w_class = 3
	accuracy = 1
	caliber = ".45"
	silenced = 1
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_ILLEGAL = 8)
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/c45m
	allowed_magazines = list(/obj/item/ammo_magazine/c45m)

	description_fluff = "Created as a disposable and concealable weapon, the Mrrazhakulii suppressed pistol is a firearm with a silencer integrated as part of its barrel. Carried by \
	guerrilla forces and spies, those guns are used in assassination and subterfuge operations. Due to using cheap and available materials, such as recycled iron and tires, countless of \
	those pistols were distributed among cells and ALA soldiers."

/obj/item/gun/projectile/silenced/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "[initial(icon_state)]"
	else
		icon_state = "[initial(icon_state)]-e"

/obj/item/gun/projectile/deagle
	name = ".50 magnum pistol"
	desc = "A robust handgun that uses .50 AE ammo."
	icon = 'icons/obj/guns/deagle.dmi'
	icon_state = "deagle"
	item_state = "deagle"
	force = 10
	accuracy = 1
	caliber = ".50"
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/a50
	allowed_magazines = list(/obj/item/ammo_magazine/a50)
	auto_eject = 1
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'

/obj/item/gun/projectile/deagle/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "[initial(icon_state)]"
	else
		icon_state = "[initial(icon_state)]-e"

/obj/item/gun/projectile/deagle/adhomai
	name = "adhomian heavy pistol"
	desc = "A bulk handgun used by republican commissars and high-ranking members of the Hadiist Party."
	icon = 'icons/obj/guns/adhomian_heavy_pistol.dmi'
	icon_state = "adhomian_heavy_pistol"
	item_state = "adhomian_heavy_pistol"
	description_fluff = "Given to Republican Commissars and high ranking Party members, the Nal'tor Model Pistol is notable for its large caliber. Unlike the Adar'Mazy pistol, only a \
	single factory in Nal'tor is allowed to fabricate it, with its design being kept as a state secret. Because of its rarity and status, the Adhomai Heavy Pistol was a sought after \
	war trophy by royalist and rebels forces."

/obj/item/gun/projectile/gyropistol
	name = "gyrojet pistol"
	desc = "A bulky pistol designed to fire self propelled rounds"
	icon = 'icons/obj/guns/gyropistol.dmi'
	icon_state = "gyropistol"
	item_state = "gyropistol"
	max_shells = 8
	accuracy = 1
	caliber = "75"
	fire_sound = 'sound/effects/Explosion1.ogg'
	origin_tech = list(TECH_COMBAT = 3)
	ammo_type = "/obj/item/ammo_casing/a75"
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/a75
	allowed_magazines = list(/obj/item/ammo_magazine/a75)
	auto_eject = 1
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'

/obj/item/gun/projectile/gyropistol/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "gyropistolloaded"
	else
		icon_state = "gyropistol"

/obj/item/gun/projectile/pistol
	name = "9mm pistol"
	desc = "A compact 9mm handgun, extremely popular all throughout human space."
	description_fluff = "The Necropolis Industries Moonlight 9mm can be found in the hands of just about anyone imaginable - special operatives, common criminals, police officers, the average Joe - on account of the time-tested design, low price point, reliability, and ease of concealment. Having a threaded barrel helps, too, and it isn't uncommon to see the Moonlight as a prop in spy films, suppressed."
	icon = 'icons/obj/guns/pistol.dmi'
	icon_state = "pistol"
	item_state = "pistol"
	w_class = 2
	accuracy = 1
	caliber = "9mm"
	silenced = 0
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_ILLEGAL = 2)
	fire_sound = 'sound/weapons/gunshot/gunshot_pistol.ogg'
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/mc9mm
	allowed_magazines = list(/obj/item/ammo_magazine/mc9mm)
	var/can_silence = TRUE

/obj/item/gun/projectile/pistol/flash
	name = "9mm signal pistol"
	magazine_type = /obj/item/ammo_magazine/mc9mm/flash

/obj/item/gun/projectile/pistol/attack_hand(mob/user as mob)
	if(user.get_inactive_hand() == src)
		if(silenced && can_silence)
			if(user.l_hand != src && user.r_hand != src)
				..()
				return
			to_chat(user, "<span class='notice'>You unscrew [silenced] from [src].</span>")
			user.put_in_hands(silenced)
			silenced = 0
			w_class = 2
			update_icon()
			return
	..()

/obj/item/gun/projectile/pistol/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/silencer) && can_silence)
		if(user.l_hand != src && user.r_hand != src)	//if we're not in his hands
			to_chat(user, "<span class='notice'>You'll need [src] in your hands to do that.</span>")
			return
		user.drop_from_inventory(I,src)
		to_chat(user, "<span class='notice'>You screw [I] onto [src].</span>")
		silenced = I	//dodgy?
		w_class = 3
		update_icon()
		return
	..()

/obj/item/gun/projectile/pistol/update_icon()
	..()
	if(silenced)
		icon_state = "pistol-silencer"
	else
		icon_state = "pistol"

/obj/item/gun/projectile/pistol/update_icon()
	..()
	if(silenced)
		icon_state = "pistol-silencer"
	else
		icon_state = "pistol"
	if(!(ammo_magazine && ammo_magazine.stored_ammo.len))
		icon_state = "[icon_state]-e"

/obj/item/silencer
	name = "silencer"
	desc = "A silencer"
	icon = 'icons/obj/guns/pistol.dmi'
	icon_state = "silencer"
	w_class = 2

/obj/item/gun/projectile/pirate
	name = "zip gun"
	desc = "Little more than a barrel, handle, and firing mechanism, cheap makeshift firearms like this one are not uncommon in frontier systems."
	icon = 'icons/obj/guns/zipgun.dmi'
	icon_state = "zipgun"
	item_state = "zipgun"
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
		/obj/item/ammo_casing/shotgun/emp	    = "12 gauge",
		/obj/item/ammo_casing/a762              = "7.62mm",
		/obj/item/ammo_casing/a556              = "5.56mm"
		)

/obj/item/gun/projectile/pirate/Initialize()
	ammo_type = pick(ammo_types)
	desc += " Uses [ammo_types[ammo_type]] rounds."

	var/obj/item/ammo_casing/ammo = ammo_type
	caliber = initial(ammo.caliber)
	. = ..()

/obj/item/gun/projectile/leyon
	name = "10mm pistol"
	desc = "The Leyon LCC Everyman is a small pistol that holds five shots and is loaded with a stripper clip, popular for self-defense on Mars. Uses 10mm rounds."
	icon = 'icons/obj/guns/leyon.dmi'
	icon_state = "leyon"
	item_state = "leyon"
	caliber = "10mm"
	w_class = 2
	ammo_type = /obj/item/ammo_casing/c10mm
	magazine_type = /obj/item/ammo_magazine/mc10mm/leyon
	max_shells = 5
	origin_tech = list(TECH_COMBAT = 1, TECH_MATERIAL = 1)
	fire_sound = 'sound/weapons/gunshot/gunshot_pistol.ogg'
	load_method = SINGLE_CASING|SPEEDLOADER

/obj/item/gun/projectile/leyon/load_ammo(var/obj/item/A, mob/user)
	user.visible_message("[user] begins reloading \the [src].", "You begin reloading \the [src].")
	if(!do_after(user, 20, act_target = src))
		return
	return ..()

/obj/item/gun/projectile/leyon/update_icon()
	..()
	if(loaded.len)
		icon_state = "leyon"
	else
		icon_state = "leyon-e"

/obj/item/gun/projectile/pistol/sol
	name = "service pistol"
	desc = "A very old service pistol. Branded at the grip with the old emblem of the Sol Alliance, hand-made by Necropolis."
	icon = 'icons/obj/guns/m8.dmi'
	icon_state = "m8"
	item_state = "m8"
	can_silence = FALSE

/obj/item/gun/projectile/pistol/sol/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "m8"
	else
		icon_state = "m8-empty"

/obj/item/gun/projectile/pistol/adhomai
	name = "adhomian service pistol"
	desc = "The Adar'Mazy pistol is an adhomian firearm commonly issued to People's Republic officers, government officials and low-ranking Party members."
	icon = 'icons/obj/guns/adhomian_pistol.dmi'
	icon_state = "adhomian_pistol"
	item_state = "adhomian_pistol"
	can_silence = FALSE
	description_fluff = "A mass produced pistol issued to People's Republic officers, government officials and low-ranking Party members. Known for their simple, cheap and reliable \
	design, this weapon is produced by nearly all weapon factories in the Republic. The Adar'Mazy is also found in the hands of Adhomai Liberation Army soldiers and commanders."

/obj/item/gun/projectile/pistol/adhomai/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "adhomian_pistol"
	else
		icon_state = "adhomian_pistol-e"

/obj/item/gun/projectile/automatic
	name = "prototype SMG"
	desc = "A protoype lightweight, fast firing gun. Uses 9mm rounds."
	icon_state = "saber"	//ugly
	w_class = 3
	load_method = SPEEDLOADER //yup. until someone sprites a magazine for it.
	max_shells = 22
	caliber = "9mm"
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2)
	slot_flags = SLOT_BELT
	ammo_type = /obj/item/ammo_casing/c9mm
	accuracy = 1
	multi_aim = 1
	burst_delay = 2
	sel_mode = 1

	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=0,    move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=2,    burst_accuracy=list(1,0,0),       dispersion=list(0, 10, 15)),
		list(mode_name="short bursts",   burst=5, fire_delay=null, move_delay=3,    burst_accuracy=list(1,0,,-1,-1), dispersion=list(5, 10, 15, 20))
		)

//Submachine guns and personal defence weapons, go.

/obj/item/gun/projectile/automatic/mini_uzi
	name = ".45 machine pistol"
	desc = "A lightweight, fast firing gun. For when you want someone dead. Uses .45 rounds."
	icon_state = "mini-uzi"
	item_state = "mini-uzi"
	w_class = 3
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/c45uzi
	allowed_magazines = list(/obj/item/ammo_magazine/c45uzi)
	max_shells = 16
	caliber = ".45"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2, TECH_ILLEGAL = 8)
	ammo_type = /obj/item/ammo_casing/c45

/obj/item/gun/projectile/automatic/mini_uzi/update_icon()
	..()
	icon_state = (ammo_magazine)? "mini-uzi" : "mini-uzi-e"

/obj/item/gun/projectile/automatic/c20r
	name = "submachine gun"
	desc = "The C-20r is a lightweight and rapid firing SMG, for when you REALLY need someone dead. Uses 10mm rounds. Has a 'Scarborough Arms - Per falcis, per pravitas' buttstamp."
	icon_state = "c20r"
	item_state = "c20r"
	w_class = 3
	force = 10
	caliber = "10mm"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2, TECH_ILLEGAL = 8)
	slot_flags = SLOT_BELT|SLOT_BACK
	fire_sound = 'sound/weapons/gunshot/gunshot_pistol.ogg'
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/a10mm
	allowed_magazines = list(/obj/item/ammo_magazine/a10mm)
	auto_eject = 1
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'

/obj/item/gun/projectile/automatic/c20r/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "c20r-[round(ammo_magazine.stored_ammo.len,4)]"
	else
		icon_state = "c20r"
	return

/obj/item/gun/projectile/automatic/wt550
	name = "machine pistol"
	desc = "The NI 550 Saber is a cheap self-defense weapon, mass-produced by Necropolis Industries for paramilitary and private use. Uses 9mm rounds."
	icon_state = "wt550"
	item_state = "wt550"
	w_class = 3
	caliber = "9mm"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)
	slot_flags = SLOT_BELT
	ammo_type = "/obj/item/ammo_casing/c9mmr"
	fire_sound = 'sound/weapons/gunshot/gunshot_pistol.ogg'
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/mc9mmt/rubber
	allowed_magazines = list(/obj/item/ammo_magazine/mc9mmt)

/obj/item/gun/projectile/automatic/wt550/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "wt550-[round(ammo_magazine.stored_ammo.len,4)]"
	else
		icon_state = "wt550"
	return

//Ballistic rifles, go.

/obj/item/gun/projectile/automatic/rifle
	name = "automatic rifle"
	desc = "A weapon firing an intermediate caliber round, or larger."
	icon_state = "arifle"
	item_state = null
	w_class = 4
	force = 10
	caliber = "a762"
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 1, TECH_ILLEGAL = 4)
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	fire_sound = 'sound/weapons/gunshot/gunshot_rifle.ogg'
	magazine_type = /obj/item/ammo_magazine/c762
	allowed_magazines = list(/obj/item/ammo_magazine/c762)

	is_wieldable = TRUE

	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=10,    move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=2,    burst_accuracy=list(1,0,0),       dispersion=list(0, 5, 10)),
		list(mode_name="short bursts",   burst=5, fire_delay=null, move_delay=3,    burst_accuracy=list(1,0,0,-1,-1), dispersion=list(5, 5, 15))
		)

	//slower to regain aim, more inaccurate if not wielding
	fire_delay = 10
	accuracy = -1

	//wielding information
	fire_delay_wielded = 6
	accuracy_wielded = 2


/obj/item/gun/projectile/automatic/rifle/sts35
	name = "assault rifle"
	desc = "A durable, rugged looking automatic weapon of a make popular on the frontier worlds. Uses 7.62mm rounds. It is unmarked."
	can_bayonet = TRUE
	knife_x_offset = 23
	knife_y_offset = 13

/obj/item/gun/projectile/automatic/rifle/sts35/update_icon()
	..()
	icon_state = (ammo_magazine)? "arifle" : "arifle-empty"
	if(wielded)
		item_state = (ammo_magazine)? "arifle-wielded" : "arifle-wielded-empty"
	else
		item_state = (ammo_magazine)? "arifle" : "arifle-empty"
	update_held_icon()

/obj/item/gun/projectile/automatic/rifle/sol
	name = "battle rifle"
	desc = "A powerful battle rifle, the M469 is a highly accurate skirmishing firearm of Necropolis make which is chambered in 7.62."
	icon_state = "battlerifle"
	item_state = "battlerifle"
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 3, TECH_ILLEGAL = 2)
	magazine_type = /obj/item/ammo_magazine/c762/sol
	allowed_magazines = list(/obj/item/ammo_magazine/c762/sol)
	auto_eject = 1
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'

/obj/item/gun/projectile/automatic/rifle/sol/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "battlerifle"
	else
		icon_state = "battlerifle-empty"
	if(wielded)
		item_state = "battlerifle-wielded"
	else
		item_state = "battlerifle"
	update_held_icon()
	return

/datum/firemode/z8
	var/use_launcher = 0

/obj/item/gun/projectile/automatic/rifle/z8
	name = "bullpup assault carbine"
	desc = "The Z8 Bulldog bullpup carbine, made by the now defunct Zendai Foundries. Uses armor piercing 5.56mm rounds. Makes you feel like a space marine when you hold it."
	icon_state = "carbine"
	item_state = "z8carbine"
	w_class = 4
	force = 10
	caliber = "a556"
	origin_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 3)
	ammo_type = "/obj/item/ammo_casing/a556"
	fire_sound = 'sound/weapons/gunshot/gunshot_rifle.ogg'
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/a556
	allowed_magazines = list(/obj/item/ammo_magazine/a556)
	auto_eject = 1
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'

	can_bayonet = TRUE
	knife_x_offset = 23
	knife_y_offset = 13

	burst_delay = 4
	firemodes = list(
		list(mode_name="semiauto",       burst=1,    fire_delay=10,    move_delay=null, use_launcher=null, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3,    fire_delay=null, move_delay=3,    use_launcher=null, burst_accuracy=list(2,1,1), dispersion=list(0, 7.5)),
		list(mode_name="fire grenades",  burst=null, fire_delay=null, move_delay=null, use_launcher=1,    burst_accuracy=null, dispersion=null)
		)

	var/use_launcher = 0
	var/obj/item/gun/launcher/grenade/underslung/launcher

/obj/item/gun/projectile/automatic/rifle/z8/Initialize()
	. = ..()
	launcher = new(src)

/obj/item/gun/projectile/automatic/rifle/z8/attackby(obj/item/I, mob/user)
	if((istype(I, /obj/item/grenade)))
		launcher.load(I, user)
	else
		..()

/obj/item/gun/projectile/automatic/rifle/z8/attack_hand(mob/user)
	if(user.get_inactive_hand() == src && use_launcher)
		launcher.unload(user)
	else
		..()

/obj/item/gun/projectile/automatic/rifle/z8/Fire(atom/target, mob/living/user, params, pointblank=0, reflex=0)
	if(use_launcher)
		launcher.Fire(target, user, params, pointblank, reflex)
		if(!launcher.chambered)
			switch_firemodes() //switch back automatically
	else
		..()

/obj/item/gun/projectile/automatic/rifle/z8/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "carbine-[round(ammo_magazine.stored_ammo.len,2)]"
	else
		icon_state = "carbine"
	if(wielded)
		item_state = "z8carbine-wielded"
	else
		item_state = "z8carbine"
	update_held_icon()
	return

/obj/item/gun/projectile/automatic/rifle/z8/examine(mob/user)
	..()
	if(launcher.chambered)
		to_chat(user, "\The [launcher] has \a [launcher.chambered] loaded.")
	else
		to_chat(user, "\The [launcher] is empty.")

/obj/item/gun/projectile/automatic/rifle/l6_saw
	name = "light machine gun"
	desc = "A rather traditionally made L6 SAW with a pleasantly lacquered wooden pistol grip. Has 'Aussec Armoury- 2431' engraved on the receiver"
	icon_state = "l6closed100"
	item_state = "l6closedmag"
	w_class = 4
	force = 10
	slot_flags = 0
	max_shells = 50
	caliber = "a762"
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 1, TECH_ILLEGAL = 2)
	slot_flags = SLOT_BACK
	ammo_type = "/obj/item/ammo_casing/a762"
	allowed_magazines = list(/obj/item/ammo_magazine/a762)
	fire_sound = 'sound/weapons/gunshot/gunshot_saw.ogg'
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/a762

	firemodes = list(
		list(mode_name="short bursts",	burst=5, move_delay=4, burst_accuracy = list(1,0,0,-1,-1),          dispersion = list(3, 6, 9)),
		list(mode_name="long bursts",	burst=8, move_delay=5, burst_accuracy = list(1,0,0,-1,-1,-1,-2,-2), dispersion = list(8))
		)

	var/cover_open = 0

/obj/item/gun/projectile/automatic/rifle/l6_saw/special_check(mob/user)
	if(cover_open)
		to_chat(user, "<span class='warning'>[src]'s cover is open! Close it before firing!</span>")
		return 0
	return ..()

/obj/item/gun/projectile/automatic/rifle/l6_saw/proc/toggle_cover(mob/user)
	cover_open = !cover_open
	to_chat(user, "<span class='notice'>You [cover_open ? "open" : "close"] [src]'s cover.</span>")
	if(cover_open)
		playsound(user, 'sound/weapons/sawopen.ogg', 60, 1)
	else
		playsound(user, 'sound/weapons/sawclose.ogg', 60, 1)
	update_icon()

/obj/item/gun/projectile/automatic/rifle/l6_saw/attack_self(mob/user as mob)
	if(cover_open)
		toggle_cover(user) //close the cover
	else
		return ..() //once closed, behave like normal

/obj/item/gun/projectile/automatic/rifle/l6_saw/attack_hand(mob/user as mob)
	if(!cover_open && user.get_inactive_hand() == src)
		toggle_cover(user) //open the cover
	else
		return ..() //once open, behave like normal

/obj/item/gun/projectile/automatic/rifle/l6_saw/update_icon()
	icon_state = "l6[cover_open ? "open" : "closed"][ammo_magazine ? round(ammo_magazine.stored_ammo.len*2, 25) : "-empty"]"
	if(wielded)
		item_state = "l6closedmag-wielded"
	else
		item_state = initial(item_state)

/obj/item/gun/projectile/automatic/rifle/l6_saw/load_ammo(var/obj/item/A, mob/user)
	if(!cover_open)
		to_chat(user, "<span class='warning'>You need to open the cover to load [src].</span>")
		return
	..()

/obj/item/gun/projectile/automatic/rifle/l6_saw/unload_ammo(mob/user, var/allow_dump=1)
	if(!cover_open)
		to_chat(user, "<span class='warning'>You need to open the cover to unload [src].</span>")
		return
	..()

/obj/item/gun/projectile/automatic/tommygun
	name = "vintage submachine gun"
	desc = "A classic submachine gun. Uses .45 rounds."
	icon_state = "tommygun"
	item_state = "tommygun"
	w_class = 3
	max_shells = 50
	caliber = ".45"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2, TECH_ILLEGAL = 5)
	slot_flags = SLOT_BELT
	ammo_type = /obj/item/ammo_casing/c45
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/tommymag
	allowed_magazines = list(/obj/item/ammo_magazine/tommymag, /obj/item/ammo_magazine/tommydrum)
	fire_sound = 'sound/weapons/tommygun_shoot.ogg'

/obj/item/gun/projectile/automatic/tommygun/update_icon()
	..()
	icon_state = (ammo_magazine)? "tommygun" : "tommygun-empty"

/obj/item/gun/projectile/automatic/railgun
	name = "railgun"
	desc = "An advanced rifle that magnetically propels hyperdense rods at breakneck speeds to devastating effect."
	icon_state = "railgun"
	item_state = "railgun"
	w_class = 4
	force = 10
	caliber = "trod"
	origin_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 7)
	slot_flags = SLOT_BELT|SLOT_BACK
	fire_sound = 'sound/effects/Explosion2.ogg'
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/trodpack
	allowed_magazines = list(/obj/item/ammo_magazine/trodpack)
	auto_eject = 1
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'

	firemodes = list(
		list(mode_name="single coil",	burst=1,    fire_delay=0,    move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="dual coil",	burst=2, move_delay=5, accuracy = list(-2,-3), dispersion = list(20))
		)


/obj/item/gun/projectile/automatic/terminator
	name = "flechette rifle"
	desc = "A fearsome Necropolis Industries designed rifle with unattached bayonet that fires lethal flechette rounds."
	icon = 'icons/obj/terminator.dmi'
	icon_state = "flechetterifle"
	item_state = "flechetterifle"
	contained_sprite = 1
	w_class = 5
	force = 30
	caliber = "flechette"
	slot_flags = SLOT_BELT|SLOT_BACK
	fire_sound = 'sound/weapons/gunshot/gunshot_dmr.ogg'
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/flechette
	allowed_magazines = list(/obj/item/ammo_magazine/flechette,/obj/item/ammo_magazine/flechette/explosive)
	auto_eject = 1
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'

	is_wieldable = TRUE

	firemodes = list(
		list(mode_name="semiauto",       burst=1, move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, move_delay=2,    burst_accuracy=list(2,1,1),       dispersion=list(0, 10, 15)),
		list(mode_name="short bursts",   burst=5, move_delay=3,    burst_accuracy=list(2,1,1,0,0), dispersion=list(5, 10, 15))
		)


	fire_delay = 20
	accuracy = -1

	//wielding information
	fire_delay_wielded = 5
	accuracy_wielded = 2
	scoped_accuracy = 2

/obj/item/gun/projectile/automatic/terminator/verb/scope()
	set category = "Object"
	set name = "Use Scope"
	set popup_menu = 1

	if(wielded)
		toggle_scope(2.0, usr)
	else
		to_chat(usr, "<span class='warning'>You can't look through the scope without stabilizing the rifle!</span>")

/obj/item/gun/projectile/automatic/rifle/shotgun
	name = "assault shotgun"
	desc = "A experimental, semi-automatic combat shotgun, designed for boarding operations and law enforcement agencies."
	icon_state = "assaultshotgun"
	item_state = "assaultshotgun"
	w_class = 4
	load_method = MAGAZINE
	max_shells = 8
	caliber = "shotgun"
	magazine_type = /obj/item/ammo_magazine/assault_shotgun
	allowed_magazines = list(/obj/item/ammo_magazine/assault_shotgun)
	origin_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 4, TECH_ILLEGAL = 5)
	slot_flags = SLOT_BACK
	auto_eject = 1
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'
	recoil = 3
	fire_sound = 'sound/weapons/gunshot/gunshot_shotgun.ogg'

	accuracy = -2
	fire_delay = 10
	recoil_wielded = 0

	fire_delay_wielded = 6
	accuracy_wielded = 0

	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay= 10,    move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=3,    burst_accuracy=list(0,-1,-1),       dispersion=list(0, 10, 15))
		)

/obj/item/gun/projectile/automatic/rifle/shotgun/update_icon()
	..()
	icon_state = (ammo_magazine)? "assaultshotgun" : "assaultshotgun-empty"

/obj/item/weapon/gun/projectile/automatic //Hopefully someone will find a way to make these fire in bursts or something. --Superxpdude
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
	multi_aim = 1
	burst_delay = 2
	sel_mode = 1

	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=0,    move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=4,    burst_accuracy=list(0,-1,-1),       dispersion=list(0.0, 0.6, 1.0)),
		list(mode_name="short bursts",   burst=5, fire_delay=null, move_delay=4,    burst_accuracy=list(0,-1,-1,-2,-2), dispersion=list(0.6, 1.0, 1.0, 1.0, 1.2))
		)

//Submachine guns and personal defence weapons, go.

/obj/item/weapon/gun/projectile/automatic/mini_uzi
	name = "\improper Uzi"
	desc = "The UZI is a lightweight, fast firing gun. For when you want someone dead. Uses .45 rounds."
	icon_state = "mini-uzi"
	w_class = 3
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/c45uzi
	allowed_magazines = list(/obj/item/ammo_magazine/c45uzi)
	max_shells = 16
	caliber = ".45"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2, TECH_ILLEGAL = 8)
	ammo_type = /obj/item/ammo_casing/c45

/obj/item/weapon/gun/projectile/automatic/c20r
	name = "submachine gun"
	desc = "The C-20r is a lightweight and rapid firing SMG, for when you REALLY need someone dead. Uses 10mm rounds. Has a 'Scarborough Arms - Per falcis, per pravitas' buttstamp."
	icon_state = "c20r"
	item_state = "c20r"
	w_class = 3
	force = 10
	caliber = "10mm"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2, TECH_ILLEGAL = 8)
	slot_flags = SLOT_BELT|SLOT_BACK
	fire_sound = 'sound/weapons/Gunshot_light.ogg'
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/a10mm
	allowed_magazines = list(/obj/item/ammo_magazine/a10mm)
	auto_eject = 1
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'

/obj/item/weapon/gun/projectile/automatic/c20r/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "c20r-[round(ammo_magazine.stored_ammo.len,4)]"
	else
		icon_state = "c20r"
	return

/obj/item/weapon/gun/projectile/automatic/wt550
	name = "machine pistol"
	desc = "The W-T 550 Saber is a cheap self-defense weapon, mass-produced by Ward-Takahashi for paramilitary and private use. Uses 9mm rounds."
	icon_state = "wt550"
	item_state = "wt550"
	w_class = 3
	caliber = "9mm"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)
	slot_flags = SLOT_BELT
	ammo_type = "/obj/item/ammo_casing/c9mmr"
	fire_sound = 'sound/weapons/Gunshot_light.ogg'
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/mc9mmt/rubber
	allowed_magazines = list(/obj/item/ammo_magazine/mc9mmt)

/obj/item/weapon/gun/projectile/automatic/wt550/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "wt550-[round(ammo_magazine.stored_ammo.len,4)]"
	else
		icon_state = "wt550"
	return

//Ballistic rifles, go.

/obj/item/weapon/gun/projectile/automatic/rifle
	name = "automatic rifle"
	desc = "A weapon firing an intermediate caliber round, or larger."
	icon_state = "arifle"
	item_state = null
	w_class = 4
	force = 10
	caliber = "a762"
	origin_tech = "combat=6;materials=1;syndicate=4"
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/c762
	allowed_magazines = list(/obj/item/ammo_magazine/c762)

	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=10,    move_delay=null, burst_accuracy=-2, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=4,    burst_accuracy=list(0,-1,-1),       dispersion=list(0.0, 0.6, 1.0)),
		list(mode_name="short bursts",   burst=5, fire_delay=null, move_delay=4,    burst_accuracy=list(0,-1,-1,-2,-2), dispersion=list(0.6, 1.0, 1.0, 1.0, 1.2))
		)

	//slower to regain aim, more inaccurate if not wielding
	fire_delay = 10
	accuracy = -2

	//wielding information
	fire_delay_wielded = 6
	accuracy_wielded = 0

	//action button for wielding
	action_button_name = "Wield rifle"

/obj/item/weapon/gun/projectile/automatic/rifle/can_wield()
	return 1

/obj/item/weapon/gun/projectile/automatic/rifle/ui_action_click()
	if(src in usr)
		toggle_wield(usr)

/obj/item/weapon/gun/projectile/automatic/rifle/verb/wield_rifle()
	set name = "Wield rifle"
	set category = "Object"
	set src in usr

	toggle_wield(usr)

/obj/item/weapon/gun/projectile/automatic/rifle/sts35
	name = "\improper STS-35 automatic rifle"
	desc = "A durable, rugged looking automatic weapon of a make popular on the frontier worlds. Uses 7.62mm rounds. It is unmarked."

/obj/item/weapon/gun/projectile/automatic/rifle/sts35/update_icon()
	..()
	icon_state = (ammo_magazine)? "arifle" : "arifle-empty"
	update_held_icon()

/datum/firemode/z8
	var/use_launcher = 0

/obj/item/weapon/gun/projectile/automatic/rifle/z8
	name = "\improper Z8 Bulldog"
	desc = "An older model bullpup carbine, made by the now defunct Zendai Foundries. Uses armor piercing 5.56mm rounds. Makes you feel like a space marine when you hold it."
	icon_state = "carbine"
	item_state = "z8carbine"
	w_class = 4
	force = 10
	caliber = "a556"
	origin_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 3)
	ammo_type = "/obj/item/ammo_casing/a556"
	fire_sound = 'sound/weapons/Gunshot.ogg'
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/a556
	allowed_magazines = list(/obj/item/ammo_magazine/a556)
	auto_eject = 1
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'

	burst_delay = 4
	firemodes = list(
		list(mode_name="semiauto",       burst=1,    fire_delay=10,    move_delay=null, use_launcher=null, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3,    fire_delay=null, move_delay=6,    use_launcher=null, burst_accuracy=list(0,-1,-1), dispersion=list(0.0, 0.6, 0.6)),
		list(mode_name="fire grenades",  burst=null, fire_delay=null, move_delay=null, use_launcher=1,    burst_accuracy=null, dispersion=null)
		)

	var/use_launcher = 0
	var/obj/item/weapon/gun/launcher/grenade/underslung/launcher

/obj/item/weapon/gun/projectile/automatic/rifle/z8/New()
	..()
	launcher = new(src)

/obj/item/weapon/gun/projectile/automatic/rifle/z8/attackby(obj/item/I, mob/user)
	if((istype(I, /obj/item/weapon/grenade)))
		launcher.load(I, user)
	else
		..()

/obj/item/weapon/gun/projectile/automatic/rifle/z8/attack_hand(mob/user)
	if(user.get_inactive_hand() == src && use_launcher)
		launcher.unload(user)
	else
		..()

/obj/item/weapon/gun/projectile/automatic/rifle/z8/Fire(atom/target, mob/living/user, params, pointblank=0, reflex=0)
	if(use_launcher)
		launcher.Fire(target, user, params, pointblank, reflex)
		if(!launcher.chambered)
			switch_firemodes() //switch back automatically
	else
		..()

/obj/item/weapon/gun/projectile/automatic/rifle/z8/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "carbine-[round(ammo_magazine.stored_ammo.len,2)]"
	else
		icon_state = "carbine"
	return

/obj/item/weapon/gun/projectile/automatic/rifle/z8/examine(mob/user)
	..()
	if(launcher.chambered)
		user << "\The [launcher] has \a [launcher.chambered] loaded."
	else
		user << "\The [launcher] is empty."

/obj/item/weapon/gun/projectile/automatic/rifle/l6_saw
	name = "\improper L6 SAW"
	desc = "A rather traditionally made light machine gun with a pleasantly lacquered wooden pistol grip. Has 'Aussec Armoury- 2531' engraved on the reciever"
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
	fire_sound = 'sound/weapons/Gunshot_light.ogg'
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/a762

	firemodes = list(
		list(mode_name="short bursts",	burst=5, move_delay=6, burst_accuracy = list(0,-1,-1,-2,-2),          dispersion = list(0.6, 1.0, 1.0, 1.0, 1.2)),
		list(mode_name="long bursts",	burst=8, move_delay=8, burst_accuracy = list(0,-1,-1,-2,-2,-2,-3,-3), dispersion = list(1.0, 1.0, 1.0, 1.0, 1.2))
		)

	var/cover_open = 0

/obj/item/weapon/gun/projectile/automatic/rifle/l6_saw/special_check(mob/user)
	if(cover_open)
		user << "<span class='warning'>[src]'s cover is open! Close it before firing!</span>"
		return 0
	return ..()

/obj/item/weapon/gun/projectile/automatic/rifle/l6_saw/proc/toggle_cover(mob/user)
	cover_open = !cover_open
	user << "<span class='notice'>You [cover_open ? "open" : "close"] [src]'s cover.</span>"
	update_icon()

/obj/item/weapon/gun/projectile/automatic/rifle/l6_saw/attack_self(mob/user as mob)
	if(cover_open)
		toggle_cover(user) //close the cover
	else
		return ..() //once closed, behave like normal

/obj/item/weapon/gun/projectile/automatic/rifle/l6_saw/attack_hand(mob/user as mob)
	if(!cover_open && user.get_inactive_hand() == src)
		toggle_cover(user) //open the cover
	else
		return ..() //once open, behave like normal

/obj/item/weapon/gun/projectile/automatic/rifle/l6_saw/update_icon()
	icon_state = "l6[cover_open ? "open" : "closed"][ammo_magazine ? round(ammo_magazine.stored_ammo.len, 25) : "-empty"]"

/obj/item/weapon/gun/projectile/automatic/rifle/l6_saw/load_ammo(var/obj/item/A, mob/user)
	if(!cover_open)
		user << "<span class='warning'>You need to open the cover to load [src].</span>"
		return
	..()

/obj/item/weapon/gun/projectile/automatic/rifle/l6_saw/unload_ammo(mob/user, var/allow_dump=1)
	if(!cover_open)
		user << "<span class='warning'>You need to open the cover to unload [src].</span>"
		return
	..()

/obj/item/weapon/gun/projectile/automatic/tommygun
	name = "\improper Tommygun"
	desc = "A classic among criminals. Uses .45 rounds."
	icon_state = "tommygun"
	w_class = 3
	max_shells = 50
	caliber = ".45"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2, TECH_ILLEGAL = 5)
	slot_flags = SLOT_BELT
	ammo_type = /obj/item/ammo_casing/c45
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/tommymag
	allowed_magazines = list(/obj/item/ammo_magazine/tommymag, /obj/item/ammo_magazine/tommydrum)

/obj/item/weapon/gun/projectile/automatic/tommygun/update_icon()
	..()
	icon_state = (ammo_magazine)? "tommygun" : "tommygun-empty"

/obj/item/weapon/gun/projectile/automatic/railgun
	name = "railgun"
	desc = "An advanced rifle that magnetically propels hyperdense rods at breakneck speeds to devastating effect."
	icon_state = "railgun"
	item_state = "arifle"
	w_class = 4
	force = 10
	caliber = "trod"
	origin_tech = "combat=8;materials=7"
	slot_flags = SLOT_BELT|SLOT_BACK
	fire_sound = 'sound/effects/Explosion2.ogg'
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/trodpack
	allowed_magazines = list(/obj/item/ammo_magazine/trodpack)
	auto_eject = 1
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'

	firemodes = list(
		list(mode_name="single coil",	burst=1,    fire_delay=0,    move_delay=null, use_launcher=null, burst_accuracy=null, dispersion=null),
		list(mode_name="dual coil",	burst=2, move_delay=8, accuracy = list(-2,-3), dispersion = list(2.0, 3.0))
		)


/obj/item/weapon/gun/projectile/automatic/terminator
	name = "flechette rifle"
	desc = "A fearsome Necropolis Industries designed rifle with attached bayonet that fires lethal flechette rounds."
	icon = 'icons/obj/terminator.dmi'
	icon_state = "flechetterifle"
	item_state = "flechetterifle"
	contained_sprite = 1
	w_class = 5
	force = 30
	caliber = "flechette"
	slot_flags = SLOT_BELT|SLOT_BACK
	fire_sound = 'sound/weapons/Gunshot_DMR.ogg'
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/flechette
	allowed_magazines = list(/obj/item/ammo_magazine/flechette,/obj/item/ammo_magazine/flechette/explosive)
	auto_eject = 1
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'

	firemodes = list(
		list(mode_name="semiauto",       burst=1, move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, move_delay=4,    burst_accuracy=list(0,-1,-1),       dispersion=list(0.0, 0.6, 1.0)),
		list(mode_name="short bursts",   burst=5, move_delay=4,    burst_accuracy=list(0,-1,-1,-2,-2), dispersion=list(0.6, 1.0, 1.0, 1.0, 1.2))
		)


	fire_delay = 20
	accuracy = -4

	//wielding information
	fire_delay_wielded = 5
	accuracy_wielded = 0
	scoped_accuracy = 2

	action_button_name = "Wield rifle"

/obj/item/weapon/gun/projectile/automatic/terminator/verb/scope()
	set category = "Object"
	set name = "Use Scope"
	set popup_menu = 1

	if(wielded)
		toggle_scope(2.0)
	else
		usr << "<span class='warning'>You can't look through the scope without stabilizing the rifle!</span>"

/obj/item/weapon/gun/projectile/automatic/terminator/can_wield()
	return 1

/obj/item/weapon/gun/projectile/automatic/terminator/ui_action_click()
	if(src in usr)
		toggle_wield(usr)

/obj/item/weapon/gun/projectile/automatic/terminator/verb/wield_rifle()
	set name = "Wield rifle"
	set category = "Object"
	set src in usr

/obj/item/weapon/gun/projectile/automatic/rifle/shotgun
	name = "assault shotgun"
	desc = "A experimental, semi-automatic combat shotgun, designed for boarding operations and law enforcement agencies."
	icon = 'icons/obj/dragunov.dmi' //lazy but works fine
	icon_state = "cshotgun"
	item_state = "cshotgun"
	contained_sprite = 1
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
	
	accuracy = -2
	fire_delay = 10
	recoil_wielded = 0
	
	fire_delay_wielded = 6
	accuracy_wielded = 0

	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay= 10,    move_delay=null, burst_accuracy=-2, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=4,    burst_accuracy=list(0,-1,-1),       dispersion=list(0.0, 0.6, 1.0))
		)

/obj/item/weapon/gun/projectile/automatic/rifle/shotgun/update_icon()
	..()
	icon_state = (ammo_magazine)? "cshotgun" : "cshotgun-empty"


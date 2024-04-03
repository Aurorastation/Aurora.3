/obj/item/gun/projectile/automatic
	name = "prototype SMG"
	desc = "A prototype version of a lightweight, fast-firing gun."
	icon = 'icons/obj/guns/saber.dmi'
	icon_state = "saber"	//ugly //yup
	item_state = "saber"
	w_class = ITEMSIZE_NORMAL
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
	fire_delay = ROF_SMG
	can_suppress = TRUE
	suppressor_x_offset = 8

	firemodes = list(
		list(mode_name="semiauto",       can_autofire=0, burst=1, fire_delay=ROF_SMG),
		list(mode_name="3-round bursts", can_autofire=0, burst=3, burst_accuracy=list(1,0,0), dispersion=list(0, 10, 15)),
		list(mode_name="short bursts",   can_autofire=0, burst=5, burst_accuracy=list(1,0,,-1,-1), dispersion=list(5, 10, 15, 20)),
		list(mode_name="full auto",		can_autofire=1, burst=1, fire_delay=5, fire_delay_wielded=2, one_hand_fa_penalty=12, burst_accuracy = list(0,-1,-1,-2,-2,-2,-3,-3), dispersion = list(5, 10, 15, 20, 25))
		)

//Submachine guns and personal defence weapons, go.

/obj/item/gun/projectile/automatic/mini_uzi
	name = ".45 machine pistol"
	desc = "A lightweight, fast-firing gun. For when you want someone dead."
	icon = 'icons/obj/guns/mini-uzi.dmi'
	icon_state = "mini-uzi"
	item_state = "mini-uzi"
	w_class = ITEMSIZE_NORMAL
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/c45uzi
	allowed_magazines = list(/obj/item/ammo_magazine/c45uzi)
	max_shells = 16
	caliber = ".45"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2, TECH_ILLEGAL = 8)
	ammo_type = /obj/item/ammo_casing/c45
	suppressed = FALSE
	can_suppress = TRUE
	suppressor_x_offset = 10

/obj/item/gun/projectile/automatic/mini_uzi/update_icon()
	..()
	icon_state = (ammo_magazine)? "mini-uzi" : "mini-uzi-e"

/obj/item/gun/projectile/automatic/c20r
	name = "submachine gun"
	desc = "A conventional bullpup submachine gun with an extendable stock."
	desc_extended = "The Colettish Armaments Model 25 SMG is a typical product of the San Colette Interstellar Armaments Company (CAISC). Rejected by the Solarian military due to competition with the Zavodskoi M470-L, the CA-M25 was repurposed \
	into the Colettish Armaments Model 25 Export (CA-25E) and has found reasonable success in mercenary groups across the Orion Spur. Recently many have found their ways into the hands of violent non-state actors in the Corporate Reconstruction Zone, where \
	they contribute to the further destabilization of the region. Curiously, these models typically have a filed-off serial number or no serial number at all."
	icon = 'icons/obj/guns/c20r.dmi'
	icon_state = "c20r"
	item_state = "c20r"
	w_class = ITEMSIZE_NORMAL
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
	suppressed = FALSE
	can_suppress = TRUE
	suppressor_x_offset = 11

/obj/item/gun/projectile/automatic/c20r/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "c20r-[round(ammo_magazine.stored_ammo.len,4)]"
	else
		icon_state = "c20r"
	return

/obj/item/gun/projectile/automatic/c20r/sol
	name = "solarian submachine gun"
	desc = "Designed by Zavodskoi as a scaled-down version of their M469, the M470-L is a personal defense weapon intended for use by second-line personnel from all branches of the Solarian military, such as support troops and Navy crewmen."
	icon = 'icons/obj/guns/sol_smg.dmi'
	icon_state = "vityaz"
	item_state = "vityaz"
	suppressor_x_offset = 10

/obj/item/gun/projectile/automatic/c20r/sol/update_icon()
	..()
	icon_state = (ammo_magazine)? "vityaz" : "vityaz-empty"

/obj/item/gun/projectile/automatic/xanusmg
	name = "\improper Xanan submachine gun"
	desc = "A sleek metal-framed submachine gun, produced by d.N.A Defense for the All-Xanu Armed Forces."
	desc_extended = "The dNAC-4.6 II submachine gun is a custom-made submachine gun for the All-Xanu Armed Forces, designed to use the same 4.6mm rounds as the dNAC-4.6 pistol. It mainly sees use as a personal defensive weapon for pilots and drivers, but has also been used aboard the spacefleet's vessels for close quarters combat."
	magazine_type = /obj/item/ammo_magazine/c46m/extended
	allowed_magazines = list(/obj/item/ammo_magazine/c46m/extended)
	icon = 'icons/obj/guns/xanu_smg.dmi'
	icon_state = "xanu_smg"
	item_state = "xanu_smg"
	caliber = "4.6mm"
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2)
	fire_sound = 'sound/weapons/gunshot/gunshot_light.ogg'
	load_method = MAGAZINE
	suppressed = FALSE
	can_suppress = TRUE
	suppressor_x_offset = 10
	suppressor_y_offset = 1

/obj/item/gun/projectile/automatic/xanusmg/update_icon()
	..()
	icon_state = (ammo_magazine)? "xanu_smg" : "xanu_smg-e"


/obj/item/gun/projectile/automatic/wt550
	name = "machine pistol"
	desc = "The NI 550 Saber is a cheap self-defense weapon, mass-produced by Zavodskoi Interstellar for paramilitary and private use."
	icon = 'icons/obj/guns/wt550.dmi'
	icon_state = "wt550"
	item_state = "wt550"
	w_class = ITEMSIZE_NORMAL
	caliber = "9mm"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)
	slot_flags = SLOT_BELT
	ammo_type = "/obj/item/ammo_casing/c9mmr"
	fire_sound = 'sound/weapons/gunshot/gunshot_pistol.ogg'
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/mc9mmt/rubber
	allowed_magazines = list(/obj/item/ammo_magazine/mc9mmt)
	can_suppress = TRUE
	suppressor_x_offset = 10
	suppressor_y_offset = -1

/obj/item/gun/projectile/automatic/wt550/lethal
	magazine_type = /obj/item/ammo_magazine/mc9mmt

/obj/item/gun/projectile/automatic/wt550/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "wt550-[round(ammo_magazine.stored_ammo.len,4)]"
	else
		icon_state = "wt550"
	return

/obj/item/gun/projectile/automatic/konyang_pirate
	name = "pirate smg"
	desc = "A hacked together SMG, made out of salvage metal and a lot of creativity."
	desc_extended = "Konyang's pirates have to go by somehow. They usually salvage and collect old metal and weapon's parts, pile them up in their hideout and get really creative. It's not advisable to use one, except you're desperate. Or a pirate."
	icon = 'icons/obj/guns/pirate_smg.dmi'
	icon_state = "pirate_smg"
	item_state = "pirate_smg"
	w_class = ITEMSIZE_NORMAL
	caliber = "10mm"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	slot_flags = SLOT_BELT|SLOT_HOLSTER|SLOT_OCLOTHING
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/smg10mm
	allowed_magazines = list(/obj/item/ammo_magazine/smg10mm)

	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=ROF_RIFLE),
		list(mode_name="short bursts",   burst=5, burst_accuracy=list(1,0,0,-1,-1), dispersion=list(5, 5, 15)),
		list(mode_name="full auto",		can_autofire=1, burst=1, fire_delay=5, fire_delay_wielded=2, one_hand_fa_penalty=12, burst_accuracy = list(0,-1,-1,-2,-2,-2,-3,-3), dispersion = list(5, 10, 15, 20, 25)),
		)

/obj/item/gun/projectile/automatic/konyang_pirate/update_icon()
	..()
	icon_state = (ammo_magazine)? "pirate_smg" : "pirate_smg-empty"

//Ballistic rifles, go.

/obj/item/gun/projectile/automatic/rifle
	name = "automatic rifle"
	desc = "A weapon firing an intermediate caliber round, or larger."
	icon = 'icons/obj/guns/arifle.dmi'
	icon_state = "arifle"
	item_state = "arifle"
	w_class = ITEMSIZE_LARGE
	force = 10
	caliber = "a762"
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 1, TECH_ILLEGAL = 4)
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	fire_sound = 'sound/weapons/gunshot/gunshot_rifle.ogg'
	empty_sound = /singleton/sound_category/out_of_ammo_rifle
	magazine_type = /obj/item/ammo_magazine/c762
	allowed_magazines = list(/obj/item/ammo_magazine/c762)
	fire_delay = ROF_RIFLE

	is_wieldable = TRUE
	can_suppress = FALSE

	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=ROF_RIFLE),
		list(mode_name="3-round bursts", burst=3, burst_accuracy=list(1,0,0),       dispersion=list(0, 5, 10)),
		list(mode_name="short bursts",   burst=5, burst_accuracy=list(1,0,0,-1,-1), dispersion=list(5, 5, 15)),
		list(mode_name="full auto",		can_autofire=1, burst=1, fire_delay=5, fire_delay_wielded=2, one_hand_fa_penalty=12, burst_accuracy = list(0,-1,-1,-2,-2,-2,-3,-3), dispersion = list(5, 10, 15, 20, 25)),
		)

	//slower to regain aim, more inaccurate if not wielding
	fire_delay = 10
	accuracy = -1

	//wielding information
	fire_delay_wielded = 6
	accuracy_wielded = 2

/obj/item/gun/projectile/automatic/rifle/sts35
	name = "assault rifle"
	desc = "A durable, rugged-looking automatic weapon of a make popular on the frontier worlds. It is unmarked."
	desc_extended = "The STS35 is a durable, reliable and cheap to buy fully automatic assault rifle with many licensed manufacturers across \
	the galaxy. It comes in different versions and calibres, this one uses 7.62 rounds. The manufacturer markings have been filed off."
	can_bayonet = TRUE
	knife_x_offset = 23
	knife_y_offset = 13

/obj/item/gun/projectile/automatic/rifle/sts35/update_icon()
	..()
	icon_state = (ammo_magazine)? "arifle" : "arifle-empty"

/obj/item/gun/projectile/automatic/rifle/shorty
	name = "short-barreled assault rifle"
	desc = "A durable, rugged-looking automatic weapon that has been heavily modified. \
	Key changes include significant shortening of the barrel and the addition of an improvised vertical foregrip, \
	condensing heavy firepower into a relatively small and maneuverable package intended for close-in \
	fighting aboard ships and space stations. Affectionately referred to as the \"Shorty\" in some circles."
	desc_extended = "The STS35 is a durable, reliable, and cheap fully-automatic assault rifle with many licensed manufacturers across \
	the galaxy. It comes in many different versions and calibres; this one uses 7.62mm rounds. This example has been heavily modified and is illegal in some jurisdictions. \
	Much of the barrel has been lopped off to decrease overall length, while a pistol grip from another STS35 has been clamped on below what remains of the handguard \
	to improve handling. The fire control group has been altered as well, sacrificing the burst-fire function in favor of a smoother trigger pull. Born from \
	extensive experience fighting in claustrophobic environments aboard ships and stations, weapons like these are common among Coalition Rangers conducting high-risk boarding operations \
	along the Frontier, who rely on its ability to rapidly gain fire superiority in the event of an ambush. While no formal name exists for it, \
	and no two examples are quite alike, weapons of this type are commonly just referred to as the \"Shorty\"."
	icon = 'icons/obj/guns/shorty.dmi'
	icon_state = "shorty"
	item_state = "shorty"
	can_bayonet = TRUE
	knife_x_offset = 23
	knife_y_offset = 13
	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=ROF_HEAVY),
		list(mode_name="full auto",		can_autofire=1, burst=1, fire_delay=5, fire_delay_wielded=2, one_hand_fa_penalty=22, burst_accuracy = list(0,-1,-1,-1,-2,-2,-2,-3), dispersion = list(5, 5, 10, 15, 20)),
		)

	accuracy = 2

/obj/item/gun/projectile/automatic/rifle/shorty/update_icon()
	..()
	icon_state = (ammo_magazine)? "shorty" : "shorty-empty"

/obj/item/gun/projectile/automatic/rifle/carbine
	name = "ballistic carbine"
	desc = "A durable, rugged-looking semi-automatic weapon of a make popular on the frontier worlds. Doesn't accept large-capacity magazines. It is unmarked."
	desc_extended = "The ST24 is often considered the little brother of its larger and fully automatic counterpart, the STS35. It is a \
	reliable and cheap to buy carbine with many licensed manufacturers across the galaxy. It comes in different versions and calibres, \
	some even boasting select fire functionality. This one uses 5.56 rounds and is semi-automatic. The manufacturer markings have been filed off."
	icon = 'icons/obj/guns/bcarbine.dmi'
	icon_state = "bcarbine"
	item_state = "bcarbine"
	caliber = "a556"
	can_bayonet = TRUE
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 1, TECH_ILLEGAL = 3)
	magazine_type = /obj/item/ammo_magazine/a556/carbine
	allowed_magazines = list(/obj/item/ammo_magazine/a556/carbine)
	knife_x_offset = 23
	knife_y_offset = 13

	firemodes = list(mode_name="semiauto", burst=1, fire_delay=ROF_HEAVY, fire_delay_wielded=ROF_INTERMEDIATE)

/obj/item/gun/projectile/automatic/rifle/carbine/update_icon()
	..()
	icon_state = (ammo_magazine)? "bcarbine" : "bcarbine-empty"

/obj/item/gun/projectile/automatic/rifle/carbine/civcarbine
	name = "bullpup carbine"
	desc = "A variant of the ZI Bulldog assault carbine, the ZI Terrier is a slimmer and lighter version, only capable of accepting smaller magazines. \
	It also lacks the integrated grenade launcher and burst fire of the Bulldog."
	desc_extended = "It makes you feel like a corporate goon when you hold it."
	icon = 'icons/obj/guns/crew_rifle.dmi'
	magazine_type = /obj/item/ammo_magazine/a556/carbine/polymer
	allowed_magazines = list(/obj/item/ammo_magazine/a556/carbine, /obj/item/ammo_magazine/a556/carbine/polymer)
	icon_state = "civcarbine"
	item_state = "civcarbine"
	can_bayonet = FALSE

/obj/item/gun/projectile/automatic/rifle/carbine/civcarbine/update_icon()
	..()
	icon_state = (ammo_magazine)? "civcarbine" : "civcarbine-empty"

/obj/item/gun/projectile/automatic/rifle/sol
	name = "solarian assault rifle"
	desc = "A reliable assault rifle manufactured by Zavodskoi Interstellar, the M469 is the standard service rifle of the Solarian Armed Forces, most commonly associated with its ground forces. \
	Though the design is old, it continues to see widespread use in the Alliance and its breakaway states and likely will for years to come."
	icon = 'icons/obj/guns/sol_rifle.dmi'
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

/datum/firemode/z8
	var/use_launcher = 0

/obj/item/gun/projectile/automatic/rifle/dominia
	name = "dominian rifle"
	desc = "The standard-issue rifle of the Empire of Dominia's Imperial Army. Loads from 30 round 5.56 magazines."
	desc_extended = "The Moroz Pattern Rifle, Year of 2424 has been the standard-issue rifle of the Imperial Army for decades thanks to its durable construction and ease \
	of use. The Imperial Army has repeatedly modernized and updated the MPR-24 over the past 40 years, and the rifle is now in its fifth modernization: \
	one that they hope will keep it competitive well into the 2470s."
	icon = 'icons/obj/guns/dominia_rifle.dmi'
	icon_state = "acr"
	item_state = "acr"
	caliber = "a556"
	ammo_type = /obj/item/ammo_casing/a556
	magazine_type = /obj/item/ammo_magazine/a556
	allowed_magazines = list(/obj/item/ammo_magazine/a556)

/obj/item/gun/projectile/automatic/rifle/dominia/update_icon()
	..()
	icon_state = (ammo_magazine)? "acr" : "acr-empty"
	item_state = icon_state

/obj/item/gun/projectile/automatic/rifle/z8
	name = "bullpup assault carbine"
	desc = "The ZI Bulldog bullpup assault carbine, Zavodskoi Industries' answer to any problem that can be solved by an assault rifle."
	desc_extended = "It makes you feel like a corporate commando when you hold it."
	icon = 'icons/obj/guns/carbine.dmi'
	icon_state = "carbine"
	item_state = "carbine"
	w_class = ITEMSIZE_LARGE
	force = 10
	caliber = "a556"
	origin_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 3)
	ammo_type = "/obj/item/ammo_casing/a556"
	fire_sound = 'sound/weapons/gunshot/gunshot_rifle.ogg'
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/a556
	allowed_magazines = list(/obj/item/ammo_magazine/a556, /obj/item/ammo_magazine/a556/carbine)
	auto_eject = 1
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'

	can_bayonet = TRUE
	knife_x_offset = 23
	knife_y_offset = 13

	burst_delay = 4
	firemodes = list(
		list(mode_name="semiauto", burst=1, fire_delay=ROF_INTERMEDIATE),
		list(mode_name="3-round bursts", burst=3, burst_accuracy=list(2,1,1), dispersion=list(0, 7.5)),
		list(mode_name="fire grenades", use_launcher=1)
		)

	var/use_launcher = 0
	var/obj/item/gun/launcher/grenade/underslung/launcher

/obj/item/gun/projectile/automatic/rifle/z8/Initialize()
	. = ..()
	launcher = new(src)

/obj/item/gun/projectile/automatic/rifle/z8/Destroy()
	QDEL_NULL(launcher)

	. = ..()

/obj/item/gun/projectile/automatic/rifle/z8/attackby(obj/item/attacking_item, mob/user)
	if((istype(attacking_item, /obj/item/grenade)))
		launcher.load(attacking_item, user)
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
		icon_state = "carbine"
	else
		icon_state = "carbine-empty"

/obj/item/gun/projectile/automatic/rifle/z8/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(launcher.chambered)
		. += "\The [launcher] has \a [launcher.chambered] loaded."
	else
		. += "\The [launcher] is empty."

/obj/item/gun/projectile/automatic/rifle/jingya
	name = "burst rifle"
	desc = "The Jingya A-1 is the first of a new line of NanoTrasen rifles, developed in cooperation with Zavodskoi Interstellar's Kumar Arms subsidiary. Primarily made of high strength polymers, the rifle is designed to be cheap to mass produce while remaining reliable."
	desc_extended = "The Jingya A-1 won a hard-fought victory in the ballistic side of the SCC Future Firearms contest hosted in 2463, which was also its first unveiling: this rifle is made to function where laser weaponry may be either too risky or not functional for the engagement at hand. It is slated to be deployed for trial usage by a select few special TCFL regiments in Mictlan."
	icon = 'icons/obj/guns/burst_rifle.dmi'
	icon_state = "arx"
	item_state = "arx"
	w_class = ITEMSIZE_LARGE
	force = 10
	caliber = "a556"
	origin_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 3)
	ammo_type = /obj/item/ammo_casing/a556
	fire_sound = 'sound/weapons/gunshot/gunshot_rifle.ogg'
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/a556/carbine/polymer
	allowed_magazines = list(/obj/item/ammo_magazine/a556/carbine, /obj/item/ammo_magazine/a556/carbine/polymer)

	burst_delay = 4
	firemodes = list(
		list(mode_name="semiauto", burst=1, fire_delay=ROF_RIFLE),
		list(mode_name="2-round bursts", burst=2, burst_accuracy=list(1, 1))
	)

/obj/item/gun/projectile/automatic/rifle/jingya/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "arx"
	else
		icon_state = "arx-empty"

/obj/item/gun/projectile/automatic/rifle/l6_saw
	name = "light machine gun"
	desc = "A squad machine gun with a clunky, outdated loading mechanism. Loads from 7.62mm ammunition boxes. Gentlemen, lock and load."
	desc_extended = "Created by the San Colette Interstellar Armaments Company (CAISC) explicitly for export, the Colettish Armaments Model 75 Export machine gun is a cheap yet outdated method of providing large amounts of firepower to a squad. \
	The CA-75E is not used by San Colette’s Civil Guard and is typically sold to mercenary groups or other Solarian systems. Since the Solarian Collapse more and more CA-75Es have found themselves in the hands of pirates and rebels in the Corporate Reconstruction Zone, and captured models curiously often have no serial number."
	icon = 'icons/obj/guns/l6.dmi'
	icon_state = "l6closed100"
	item_state = "l6closedmag"
	w_class = ITEMSIZE_LARGE
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
		list(mode_name="short bursts",	burst=5, burst_accuracy = list(1,0,0,-1,-1), dispersion = list(3, 6, 9)),
		list(mode_name="long bursts",	burst=8, burst_accuracy = list(1,0,0,-1,-1,-1,-2,-2), dispersion = list(8)),
		list(mode_name="full auto", can_autofire=1, burst=1, fire_delay=5, fire_delay_wielded=2, one_hand_fa_penalty=12, burst_accuracy = list(0,-1,-1,-2,-2,-2,-3,-3), dispersion = list(5, 10, 15, 20, 25))
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

/obj/item/gun/projectile/automatic/rifle/l6_saw/unique_action(mob/user)
	toggle_cover(user)

/obj/item/gun/projectile/automatic/rifle/l6_saw/toggle_firing_mode(mob/user)
	if(cover_open)
		to_chat(user, SPAN_WARNING("The cover must be closed!"))
		return
	..()

/obj/item/gun/projectile/automatic/rifle/l6_saw/attack_hand(mob/user as mob)
	if(!cover_open && user.get_inactive_hand() == src)
		toggle_cover(user) //open the cover
	else
		return ..() //once open, behave like normal

/obj/item/gun/projectile/automatic/rifle/l6_saw/update_icon()
	icon_state = "l6[cover_open ? "open" : "closed"][ammo_magazine ? round(ammo_magazine.stored_ammo.len*2, 25) : "-empty"]"
	..()

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

/obj/item/gun/projectile/automatic/rifle/adhomian
	name = "adhomian automatic rifle"
	desc = "The Tsarrayut'yan rifle is a select-fire automatic rifle producted by the People's Republic of Adhomai."
	icon = 'icons/obj/guns/tsarrayut.dmi'
	icon_state = "tsarrayut"
	item_state = "tsarrayut"
	contained_sprite = TRUE

	desc_extended = "Unlike the other Adhomian factions, the Hadiist military has fully adopted automatic weapons. Their service rifle is the Tsarrayut'yan rifle, a select-fire, \
	automatic rifle. Laser weapons are usually used by high-ranking soldiers or special operatives. Regardless of advances in the small arms field, artillery is the Republican army’s \
	main weapon and pride."

	load_method = SINGLE_CASING|SPEEDLOADER

	ammo_type = /obj/item/ammo_casing/a762
	allowed_magazines = null
	magazine_type = null
	max_shells = 25

	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	fire_sound = 'sound/weapons/gunshot/gunshot_rifle.ogg'

	is_wieldable = TRUE

	can_bayonet = TRUE
	knife_x_offset = 23
	knife_y_offset = 14

/obj/item/gun/projectile/automatic/rifle/dpra
	name = "adhomian assault rifle"
	desc = "The Mrrazhak Model-1 is the newest Al'mariist automatic rifle. The Mrrazhak is notorious for its simple and reliable design; it can be fabricated and assembled without the \
	need of a specialized industry or a highly trained workforce."
	icon = 'icons/obj/guns/mrrazhak.dmi'
	icon_state = "mrrazhak"
	item_state = "mrrazhak"

	can_bayonet = TRUE
	knife_x_offset = 22
	knife_y_offset = 13

	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	fire_sound = 'sound/weapons/gunshot/gunshot_rifle.ogg'

	is_wieldable = TRUE

	can_bayonet = TRUE


	magazine_type = /obj/item/ammo_magazine/c762/dpra
	allowed_magazines = list(/obj/item/ammo_magazine/c762/dpra)

/obj/item/gun/projectile/automatic/rifle/dpra/update_icon()
	if(ammo_magazine)
		icon_state = "mrrazhak"
		item_state = "mrrazhak"
	else
		icon_state = "mrrazhak_nomag"
		item_state = "mrrazhak_nomag"
	..()

/obj/item/gun/projectile/automatic/rifle/dpra/gold
	name = "gold plated adhomian assault rifle"
	desc = "The Mrrazhak Model-1 is the newest Al'mariist automatic rifle. The Mrrazhak is notorious for its simple and reliable design; it can be fabricated and assembled without the \
	need of a specialized industry or a highly trained workforce. This one is golden plated."
	icon = 'icons/obj/guns/golden_mrrazhak.dmi'

/obj/item/gun/projectile/automatic/tommygun
	name = "submachine gun"
	desc = "An Adhomian-made submachine gun."
	icon = 'icons/obj/guns/tommygun.dmi'
	icon_state = "tommygun"
	item_state = "tommygun"
	w_class = ITEMSIZE_NORMAL
	max_shells = 50
	caliber = ".45"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2, TECH_ILLEGAL = 5)
	slot_flags = SLOT_BELT
	ammo_type = /obj/item/ammo_casing/c45
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/submachinemag
	allowed_magazines = list(/obj/item/ammo_magazine/submachinemag, /obj/item/ammo_magazine/submachinedrum)
	fire_sound = 'sound/weapons/gunshot/gunshot_tommygun.ogg'

	can_suppress = TRUE
	suppressor_x_offset = 10
	suppressor_y_offset = -1

/obj/item/gun/projectile/automatic/tommygun/update_icon()
	..()
	icon_state = (ammo_magazine)? "tommygun" : "tommygun-empty"

/obj/item/gun/projectile/automatic/tommygun/dom
	name = "dominian submachine gun"
	desc = "A submachine gun featuring a novel top loading configuration, used by the Empire of Dominia's armed forces."
	desc_extended = "The Moroz Pattern Machine Carbine, Model of 2430 is a lightweight, handy weapon intended for use by vehicle crews, airborne troops, and other units that do not require a full-length rifle. \
	Simplistic in design and function, the MPMC-30 is highly reliable in nearly all environments, lending itself well to use by colonial forces. In particular, the Imperial Fisanduhian Gendarmerie are known to make heavy use of the weapon."
	icon = 'icons/obj/guns/dominia_smg.dmi'
	icon_state = "owen"
	item_state = "owen"
	max_shells = 20
	allowed_magazines = list(/obj/item/ammo_magazine/submachinemag)

/obj/item/gun/projectile/automatic/tommygun/dom/update_icon()
	..()
	icon_state = (ammo_magazine)? "owen" : "owen-empty"

/obj/item/gun/projectile/automatic/tommygun/assassin
	name = "integrally suppressed machine pistol"
	desc = "An Eridanian “rat hunting” gun manufactured by the Amon Pest Control Company. Commonly used by corporate assassins, uncommonly used by pest control workers. Chambered in 6mm."
	desc_extended = "The APCC RatAway SMG is manufactured by a shell company of Ringspire for use in corporate assassination duties. Extremely quiet and firing caseless ammunition, it is an ideal weapon for putting down those who dare to threaten megacorporate interests."
	icon = 'icons/obj/guns/assassin_smg.dmi'
	icon_state = "assassin_smg"
	item_state = "assassin_smg"
	magazine_type = /obj/item/ammo_magazine/submachinemag/assassin
	allowed_magazines = list(/obj/item/ammo_magazine/submachinemag/assassin)
	caliber = "6mm"
	suppressed = TRUE
	can_unsuppress = FALSE
	suppressor_x_offset = null
	suppressor_y_offset = null
	handle_casings = DELETE_CASINGS
	max_shells = 30
	allowed_magazines = list(/obj/item/ammo_magazine/submachinemag/assassin)

/obj/item/gun/projectile/automatic/tommygun/assassin/update_icon()
	..()
	icon_state = (ammo_magazine) ? "assassin_smg" : "assassin_smg-empty"

/obj/item/gun/projectile/automatic/tommygun/konyang
	name = "konyang police submachine gun"
	desc = "A compact submachine gun made specifically for the Konyang National Police. Takes .45 ammo."
	desc_extended = "Produced by one of Einstein Engines' local subsidiaries on Konyang, the K45 \"Pogpung\" submachine gun is Taepung Arms' entry into the submachine gun market. \
	The National Police purchased a large number of K45s for their patrol units due to reports that service revolvers were inadequate at stopping rampant IPCs. The K45-P variant \
	specially designed for the police forces is chambered in the organization's preferred .45 caliber and is limited to 3-round bursts due to the relatively limited firearms training of \
	National Police officers."
	icon = 'icons/obj/guns/konyang_weapons.dmi'
	icon_state = "k45carbine"
	item_state = "k45carbine"
	w_class = ITEMSIZE_NORMAL
	max_shells = 30
	load_method = MAGAZINE
	ammo_type = /obj/item/ammo_casing/c45
	allowed_magazines = list(/obj/item/ammo_magazine/c45m, /obj/item/ammo_magazine/submachinemag)

	firemodes = list(
		list(mode_name="semiauto",       can_autofire=0, burst=1, fire_delay=ROF_SMG),
		list(mode_name="3-round bursts", can_autofire=0, burst=3, burst_accuracy=list(1,0,0), dispersion=list(0, 10, 15))
	)

/obj/item/gun/projectile/automatic/tommygun/konyang/update_icon()
	..()
	icon_state = (ammo_magazine)? "k45carbine" : "k45carbine-e"

/obj/item/gun/projectile/automatic/rifle/dnac
	name = "dNAC-6.5 assault rifle"
	desc = "A durable, sleek-looking bullpup rifle manufactured by d.N.A Defense & Aerospace for the All-Xanu Armed Forces. This model has been adopted by a majority of the Coalition's military forces as well due to its simplicity and reliability."
	icon = 'icons/obj/guns/xanu_rifle.dmi'
	icon_state = "xanu_rifle"
	item_state = "xanu_rifle"
	magazine_type = /obj/item/ammo_magazine/a65
	allowed_magazines = list(/obj/item/ammo_magazine/a65)
	caliber = "a65"

	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=ROF_RIFLE),
		list(mode_name="3-round bursts", burst=3, burst_accuracy=list(1,0,0),       dispersion=list(0, 5, 10)),
		list(mode_name="full auto",		can_autofire=1, burst=1, fire_delay=5, fire_delay_wielded=2, one_hand_fa_penalty=12, burst_accuracy = list(0,-1,-1,-2,-2,-2,-3,-3), dispersion = list(5, 10, 15, 20, 25)),
		)

/obj/item/gun/projectile/automatic/rifle/dnac/update_icon()
	..()
	icon_state = (ammo_magazine)? "xanu_rifle" : "xanu_rifle-empty"

/obj/item/gun/projectile/automatic/railgun
	name = "railgun"
	desc = "An advanced rifle that magnetically propels hyperdense rods at breakneck speeds to devastating effect."
	icon = 'icons/obj/guns/railgun.dmi'
	icon_state = "railgun"
	item_state = "railgun"
	w_class = ITEMSIZE_LARGE
	force = 10
	caliber = "trod"
	origin_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 7)
	slot_flags = SLOT_BELT|SLOT_BACK
	fire_sound = 'sound/weapons/railgun.ogg'
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/trodpack
	allowed_magazines = list(/obj/item/ammo_magazine/trodpack)
	auto_eject = 1
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'

	can_suppress = FALSE

	firemodes = list(
		list(mode_name="single coil", burst = 1),
		list(mode_name="dual coil", burst = 2, move_delay = 1, accuracy = list(-2,-3), dispersion = list(20))
		)


/obj/item/gun/projectile/automatic/terminator
	name = "flechette rifle"
	desc = "A fearsome Zavodskoi Interstellar designed rifle with unattached bayonet that fires lethal flechette rounds."
	icon = 'icons/obj/guns/flechette.dmi'
	icon_state = "flechetterifle"
	item_state = "flechetterifle"
	w_class = ITEMSIZE_HUGE
	force = 30
	caliber = "flechette"
	slot_flags = SLOT_BELT|SLOT_BACK
	fire_sound = 'sound/weapons/gunshot/gunshot_dmr.ogg'
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/flechette
	allowed_magazines = list(/obj/item/ammo_magazine/flechette,/obj/item/ammo_magazine/flechette/explosive)
	auto_eject = 1
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'

	can_suppress = FALSE

	is_wieldable = TRUE

	firemodes = list(
		list(mode_name="semiauto", burst=1),
		list(mode_name="3-round bursts", burst=3, burst_accuracy=list(2,1,1), dispersion=list(0, 10, 15)),
		list(mode_name="short bursts", burst=5, burst_accuracy=list(2,1,1,0,0), dispersion=list(5, 10, 15))
		)


	fire_delay = ROF_UNWIELDY
	accuracy = -1

	//wielding information
	fire_delay_wielded = ROF_SUPERHEAVY
	accuracy_wielded = 2
	scoped_accuracy = 2

/obj/item/gun/projectile/automatic/terminator/verb/scope()
	set category = "Object"
	set name = "Use Scope"
	set src in usr

	if(wielded)
		toggle_scope(2.0, usr)
	else
		to_chat(usr, "<span class='warning'>You can't look through the scope without stabilizing the rifle!</span>")

/obj/item/gun/projectile/automatic/rifle/konyang/k556
	name = "konyang assault rifle"
	desc = "The K556 is the standard assault rifle of the Konyang Armed Forces. Sturdy and reliable."
	desc_extended = "The K556 assault rifle is a new design in use by elements of the Konyang Armed Forces, designed in-house by the military in partnership with Einstein Engines'local subsidiaries. It has yet to see widespread service as the government is reluctant to spend money on new small arms when they already possess large stockpiles from the colonial period. This has not stopped the Aerospace Forces from making the transition to the new weapon however, as its compact design, light weight, and accuracy make it ideal for use aboard a spacecraft."
	icon = 'icons/obj/guns/konyang_weapons.dmi'
	icon_state = "k556rifle"
	item_state = "k556rifle"
	slot_flags = SLOT_BACK|SLOT_OCLOTHING
	w_class = ITEMSIZE_NORMAL
	ammo_type = "/obj/item/ammo_casing/a556"
	handle_casings = EJECT_CASINGS
	caliber = "a556"
	magazine_type = /obj/item/ammo_magazine/a556/k556
	allowed_magazines = list(/obj/item/ammo_magazine/a556/k556)
	is_wieldable = TRUE

/obj/item/gun/projectile/automatic/rifle/konyang/k556/update_icon()
	..()
	icon_state = (ammo_magazine)? "k556rifle" : "k556rifle-e"

/obj/item/gun/projectile/automatic/rifle/konyang/konyang47
	name = "konyang assault carbine"
	desc = "The Dering-K1 is the carbine version of the K556. Intended to be used by vehicle crews, second line infantry, support crew and staff or when you have limited space to work with."
	desc_extended = "The Dering K1 battle rifle is a standard Solarian M469 given a service extension package by Zavodskoi Interstellar. Many of the rifles bear Konyanger proof marks right next to old Solarian ones, indicating their heritage. Its more robust design is tailored for naval and swamp warfare, while still maintaining the firepower needed for frontline combat operations."
	icon = 'icons/obj/guns/konyang_weapons.dmi'
	icon_state = "k47"
	item_state = "k47"
	slot_flags = SLOT_BACK|SLOT_OCLOTHING
	w_class = ITEMSIZE_LARGE
	ammo_type = "/obj/item/ammo_casing/a556"
	handle_casings = EJECT_CASINGS
	caliber = "a556"
	magazine_type = /obj/item/ammo_magazine/a556/carbine/konyang47
	allowed_magazines = list(/obj/item/ammo_magazine/a556/carbine/konyang47)
	is_wieldable = TRUE

/obj/item/gun/projectile/automatic/rifle/konyang/konyang47/update_icon()
	..()
	icon_state = (ammo_magazine)? "k47" : "k47-e"

/obj/item/gun/projectile/automatic/rifle/konyang/pirate_rifle
	name = "re-bored rifle"
	desc = "A wooden rifle, repaired and re-bored to actually work again. Fires eight rounds of .308 in semi-auto."
	icon = 'icons/obj/guns/konyang_weapons.dmi'
	icon_state = "poacher"
	item_state = "poacher"
	slot_flags = SLOT_BACK|SLOT_OCLOTHING
	load_method = SINGLE_CASING
	w_class = ITEMSIZE_LARGE
	ammo_type = /obj/item/ammo_casing/vintage
	handle_casings = EJECT_CASINGS
	caliber = "30-06 govt"
	is_wieldable = TRUE
	max_shells = 8

/obj/item/gun/projectile/automatic/rifle/dominia_carbine
	name = "dominian carbine"
	desc = "A carbine variant of the MPR-24/5 with a shorter barrel and folding stock. Loads from 20 round 7.62 magazines."
	desc_extended = "The carbine variant of the MPR-24/5 is commonly seen in the hands of vehicle crews, airborne troops, and other units that do not require a \
	full-length rifle. Paramilitary units, such as the Imperial Fisanduhian Gendarmerie, are armed with these rather than full-length rifles."
	icon = 'icons/obj/guns/dominia_carbine.dmi'
	icon_state = "dom_carbine"
	item_state = "dom_carbine"
	slot_flags = SLOT_BACK|SLOT_OCLOTHING
	w_class = ITEMSIZE_LARGE
	ammo_type = "/obj/item/ammo_casing/a762"
	handle_casings = EJECT_CASINGS
	caliber = "a762"
	magazine_type = /obj/item/ammo_magazine/c762/dominia
	allowed_magazines = list(/obj/item/ammo_magazine/c762/dominia)
	is_wieldable = TRUE

/obj/item/gun/projectile/automatic/rifle/dominia_carbine/update_icon()
	..()
	icon_state = (ammo_magazine)? "dom_carbine" : "dom_carbine-empty"

/obj/item/gun/projectile/automatic/rifle/dominia_lmg
	name = "dominian light machine gun"
	desc = "A machine gun based on the MPR-24/5 platform."
	desc_extended = "Originally developed as a platoon-level weapon but later converted to squad-level use, the MPR-24/5 PMG (Platoon Machine Gun) is \
	the most commonly-issued machine gun in the Imperial Army. The PMG is reliable and capable yet fairly heavy, and most non-geneboosted soldiers \
	issued it receive a special load-bearing harness to make using it easier."
	icon = 'icons/obj/guns/dominia_lmg.dmi'
	icon_state = "dom_lmg"
	item_state = "dom_lmg"
	caliber = "a556"
	magazine_type = /obj/item/ammo_magazine/a556/dlmg
	allowed_magazines = list(/obj/item/ammo_magazine/a556/dlmg)
	firemodes = list(
		list(mode_name="short bursts",	burst=5, burst_accuracy = list(1,0,0,-1,-1), dispersion = list(3, 6, 9)),
		list(mode_name="long bursts",	burst=8, burst_accuracy = list(1,0,0,-1,-1,-1,-2,-2), dispersion = list(8)),
		list(mode_name="full auto", can_autofire=1, burst=1, fire_delay=5, fire_delay_wielded=2, one_hand_fa_penalty=12, burst_accuracy = list(0,-1,-1,-2,-2,-2,-3,-3), dispersion = list(5, 10, 15, 20, 25))
	)

/obj/item/gun/projectile/automatic/rifle/dominia_lmg/update_icon()
	..()
	icon_state = (ammo_magazine)? "dom_lmg" : "dom_lmg-empty"
	item_state = icon_state

/obj/item/gun/projectile/automatic/rifle/shotgun
	name = "assault shotgun"
	desc = "A experimental, semi-automatic combat shotgun, designed for boarding operations and law enforcement agencies."
	icon = 'icons/obj/guns/assaultshotgun.dmi'
	icon_state = "assaultshotgun"
	item_state = "assaultshotgun"
	w_class = ITEMSIZE_LARGE
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
	recoil_wielded = 0

	accuracy_wielded = 0

	firemodes = list(
		list(mode_name="semiauto", burst=1, fire_delay=ROF_SUPERHEAVY, fire_delay_wielded=ROF_HEAVY),
		list(mode_name="3-round bursts", burst=3, burst_accuracy=list(0,-1,-1), dispersion=list(0, 10, 15))
		)

/obj/item/gun/projectile/automatic/rifle/shotgun/update_icon()
	..()
	icon_state = (ammo_magazine)? "assaultshotgun" : "assaultshotgun-empty"

/obj/item/gun/projectile/automatic/rifle/shotgun/xanan
	name = "dNAC-12 combat shotgun"
	desc = "A magazine-fed semi-automatic combat shotgun, designed by d.N.A Defense on Xanu Prime."
	desc_extended = "The dNAC-12 combat shotgun was designed for the All-Xanu Grand Army and the All-Xanu National Militia for its law enforcement duties and military police. Due to its reliability, ease of use, and flexibility however, it has been adopted by the Air Corps and Spacefleet as well for defensive purposes."
	icon = 'icons/obj/guns/xanu_shotgun.dmi'
	icon_state = "xanu_shotgun"
	item_state = "xanu_shotgun"
	magazine_type = /obj/item/ammo_magazine/xanan_shotgun/shells
	allowed_magazines = list(/obj/item/ammo_magazine/xanan_shotgun)

/obj/item/gun/projectile/automatic/rifle/shotgun/xanan/update_icon()
	..()
	icon_state = (ammo_magazine)? "xanu_shotgun" : "xanu_shotgun-empty"

	firemodes = list(
		list(mode_name="semiauto", burst=1, fire_delay=ROF_SUPERHEAVY, fire_delay_wielded=ROF_HEAVY),
		list(mode_name="2-round bursts", burst=2, burst_accuracy=list(0,-1), dispersion=list(0, 10))
		)

/obj/item/gun/projectile/automatic/rifle/shotgun/konyang
	name = "magazine-fed shotgun"
	desc = "A compact semi-automatic shotgun, fed by a magazine. Unsuspectic, but powerful and not to be underestimated. Takes standard 12g shotgun ammo."
	desc_extended = "The RCG-1, locally produced on Konyang, also nicknamed \"The Showstopper\" for its wide variety of applications. It uses a compact design with a newly developed type of double spring mechanism in the magazine \
	to eradicate all kinds of feeding malfunctions, as well as groundbreaking caseless shotgun ammunition. Favoured by the Commandos of Konyang's Special Forces."
	icon = 'icons/obj/guns/mag_shotgun.dmi'
	icon_state = "mshotgun"
	item_state = "mshotgun"
	slot_flags = SLOT_BACK|SLOT_OCLOTHING
	w_class = ITEMSIZE_LARGE
	ammo_type = /obj/item/ammo_casing/shotgun
	handle_casings = DELETE_CASINGS
	max_shells = 9
	auto_eject = 0
	caliber = "shotgun"
	magazine_type = /obj/item/ammo_magazine/konyang_shotgun
	allowed_magazines = list(/obj/item/ammo_magazine/konyang_shotgun)
	is_wieldable = TRUE

	firemodes = list(
		list(mode_name="semiauto", burst=1, fire_delay=ROF_SUPERHEAVY, fire_delay_wielded=ROF_HEAVY)
		)

/obj/item/gun/projectile/automatic/rifle/shotgun/konyang/update_icon()
	..()
	icon_state = (ammo_magazine)? "mshotgun" : "mshotgun-empty"

/obj/item/gun/projectile/automatic/rifle/hook_mg
	name = "unathi hook machine gun"
	desc = "A ballistic machine gun of Unathi manufacture, often used by the forces of the Traditionalist Coalition during the Contact War."
	desc_extended = "The Hook Machinegun is a heavy automatic machinegun of Moghesian manufacture. Though the name of the creators of this weapon was lost to the destruction of the nuclear exchange, the Hook was known to be found in the hands of some of the better-equipped forces of the Traditionalist Coalition during the Contact War. \
	This machine gun is carried on one's shoulder and thus can be used with a single hand. Though it can fire heavy cartridges, it is quite lacking in accuracy."
	icon = 'icons/obj/guns/unathi_ballistics.dmi'
	icon_state = "hookmg"
	item_state = "hookmg"
	caliber = "5.8mm"
	magazine_type = /obj/item/ammo_magazine/hookmg
	allowed_magazines = list(/obj/item/ammo_magazine/hookmg)
	firemodes = list(
		list(mode_name="short bursts",	burst=5, burst_accuracy = list(1,0,0,-1,-1), dispersion = list(3, 6, 9)),
		list(mode_name="long bursts",	burst=8, burst_accuracy = list(1,0,0,-1,-1,-1,-2,-2), dispersion = list(8)),
		list(mode_name="full auto", can_autofire=1, burst=1, fire_delay=5, fire_delay_wielded=2, one_hand_fa_penalty=12, burst_accuracy = list(0,-1,-1,-2,-2,-2,-3,-3), dispersion = list(5, 10, 15, 20, 25))
	)
	slot_flags = null
	w_class = ITEMSIZE_LARGE
	accuracy = -2
	accuracy_wielded = 0

/obj/item/gun/projectile/automatic/rifle/hook_mg/update_icon()
	..()
	icon_state = (ammo_magazine)? "hookmg" : "hookmg-empty"

/obj/item/gun/projectile/automatic/tempestsmg
	name = "tempest submachine gun"
	desc = "The tempest sub-machine gun is a Hegemonic design dating back to the 2350s, though still produced in ample numbers to this day. While rather large and heavy for a weapon of its class, its simplicity and reliability have made it a popular weapon among Unathi for over a century, and the aging weapon was even used as the basis for future designs."
	magazine_type = /obj/item/ammo_magazine/tempestsmg
	allowed_magazines = list(/obj/item/ammo_magazine/tempestsmg)
	icon = 'icons/obj/guns/unathi_ballistics.dmi'
	icon_state = "tempestsmg"
	item_state = "tempestsmg"
	caliber = "11.6mm"
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2)
	fire_sound = 'sound/weapons/gunshot/gunshot_light.ogg'
	load_method = MAGAZINE
	slot_flags = SLOT_BELT|SLOT_BACK|SLOT_S_STORE
	suppressed = FALSE
	is_wieldable = TRUE
	accuracy_wielded = 2
	can_suppress = TRUE
	suppressor_x_offset = 10
	suppressor_y_offset = 1

/obj/item/gun/projectile/automatic/tempestsmg/update_icon()
	..()
	icon_state = (ammo_magazine)? "tempestsmg" : "tempestsmg-empty"

/obj/item/gun/projectile/automatic
	name = "prototype SMG"
	desc = "A protoype lightweight, fast firing gun. Uses 9mm rounds."
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

	firemodes = list(
		list(mode_name="semiauto",       can_autofire=0, burst=1),
		list(mode_name="3-round bursts", can_autofire=0, burst=3, burst_accuracy=list(1,0,0), dispersion=list(0, 10, 15)),
		list(mode_name="short bursts",   can_autofire=0, burst=5, burst_accuracy=list(1,0,,-1,-1), dispersion=list(5, 10, 15, 20)),
		list(mode_name="full auto",		can_autofire=1, burst=1, fire_delay=1, fire_delay_wielded=1, one_hand_fa_penalty=12, burst_accuracy = list(0,-1,-1,-2,-2,-2,-3,-3), dispersion = list(5, 10, 15, 20, 25))
		)

//Submachine guns and personal defence weapons, go.

/obj/item/gun/projectile/automatic/mini_uzi
	name = ".45 machine pistol"
	desc = "A lightweight, fast firing gun. For when you want someone dead. Uses .45 rounds."
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

/obj/item/gun/projectile/automatic/mini_uzi/update_icon()
	..()
	icon_state = (ammo_magazine)? "mini-uzi" : "mini-uzi-e"

/obj/item/gun/projectile/automatic/c20r
	name = "submachine gun"
	desc = "A conventional bullpup submachine gun with an extendable stock. Loads from 9mm magazines."
	desc_fluff = "The Colettish Armaments Model 25 SMG is a typical product of the San Colette Interstellar Armaments Company (CAISC). Rejected by the Solarian military due to competition with the Zavodskoi M470-L, the CA-M25 was repurposed \
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

/obj/item/gun/projectile/automatic/c20r/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "c20r-[round(ammo_magazine.stored_ammo.len,4)]"
	else
		icon_state = "c20r"
	return

/obj/item/gun/projectile/automatic/c20r/sol
	name = "solarian submachine gun"
	desc = "Designed by Zavodskoi as a scaled-down version of their M469, the M470-L is a personal defense weapon intended for use by second-line personnel from all branches of the Solarian military, such as support troops and Navy crewmen. Chambered in 10mm."
	icon = 'icons/obj/guns/sol_smg.dmi'
	icon_state = "vityaz"
	item_state = "vityaz"

/obj/item/gun/projectile/automatic/c20r/sol/update_icon()
	..()
	icon_state = (ammo_magazine)? "vityaz" : "vityaz-empty"

/obj/item/gun/projectile/automatic/wt550
	name = "machine pistol"
	desc = "The NI 550 Saber is a cheap self-defense weapon, mass-produced by Zavodskoi Interstellar for paramilitary and private use. Uses 9mm rounds."
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

/obj/item/gun/projectile/automatic/wt550/lethal
	magazine_type = /obj/item/ammo_magazine/mc9mmt

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
	empty_sound = /decl/sound_category/out_of_ammo_rifle
	magazine_type = /obj/item/ammo_magazine/c762
	allowed_magazines = list(/obj/item/ammo_magazine/c762)

	is_wieldable = TRUE

	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=10),
		list(mode_name="3-round bursts", burst=3, burst_accuracy=list(1,0,0),       dispersion=list(0, 5, 10)),
		list(mode_name="short bursts",   burst=5, burst_accuracy=list(1,0,0,-1,-1), dispersion=list(5, 5, 15)),
		list(mode_name="full auto",		can_autofire=1, burst=1, fire_delay=1, fire_delay_wielded=1, one_hand_fa_penalty=12, burst_accuracy = list(0,-1,-1,-2,-2,-2,-3,-3), dispersion = list(5, 10, 15, 20, 25)),
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
	desc_fluff = "The STS35 is a durable, reliable and cheap to buy fully automatic assault rifle with many licensed manufacturers across \
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
	fighting aboard ships and space stations. Affectionately referred to as the \"Shorty\" in some circles. Uses 7.62mm rounds."
	desc_fluff = "The STS35 is a durable, reliable, and cheap fully-automatic assault rifle with many licensed manufacturers across \
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
		list(mode_name="semiauto",       burst=1, fire_delay=8),
		list(mode_name="full auto",		can_autofire=1, burst=1, fire_delay=1, fire_delay_wielded=1, one_hand_fa_penalty=22, burst_accuracy = list(0,-1,-1,-1,-2,-2,-2,-3), dispersion = list(5, 5, 10, 15, 20)),
		)

	fire_delay = 8
	accuracy = 2

/obj/item/gun/projectile/automatic/rifle/shorty/update_icon()
	..()
	icon_state = (ammo_magazine)? "shorty" : "shorty-empty"

/obj/item/gun/projectile/automatic/rifle/carbine
	name = "ballistic carbine"
	desc = "A durable, rugged looking semi-automatic weapon of a make popular on the frontier worlds. Uses 5.56mm rounds and does not accept large \
	capacity magazines. It is unmarked."
	desc_fluff = "The ST24 is often considered the little brother of its larger and fully automatic counterpart, the STS35. It is a \
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

	firemodes = list(mode_name="semiauto", burst=1, fire_delay=12, fire_delay_wielded=12)

/obj/item/gun/projectile/automatic/rifle/carbine/update_icon()
	..()
	icon_state = (ammo_magazine)? "bcarbine" : "bcarbine-empty"

/obj/item/gun/projectile/automatic/rifle/carbine/civcarbine
	name = "bullpup carbine"
	desc = "A variant of the ZI Bulldog assault carbine, the ZI Terrier is a slimmer and lighter version, chambered in the same 5.56 caliber but only capable of accepting smaller magazines. It lacks the integral grenade launcher and the burst fire of the Bulldog."
	desc_fluff = "It makes you feel like a corporate goon when you hold it."
	icon = 'icons/obj/guns/civcarbine.dmi'
	icon_state = "civcarbine"
	item_state = "civcarbine"
	can_bayonet = FALSE

/obj/item/gun/projectile/automatic/rifle/carbine/civcarbine/update_icon()
	..()
	icon_state = (ammo_magazine)? "civcarbine" : "civcarbine-empty"

/obj/item/gun/projectile/automatic/rifle/sol
	name = "solarian assault rifle"
	desc = "A reliable assault rifle manufactured by Zavodskoi Interstellar, the M469 is the standard service rifle of the Solarian Armed Forces, most commonly associated with its ground forces. \
	Though the design is old, it continues to see widespread use in the Alliance and its breakaway states and likely will for years to come. Chambered in 7.62mm."
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

/obj/item/gun/projectile/automatic/rifle/z8
	name = "bullpup assault carbine"
	desc = "The ZI Bulldog bullpup assault carbine, Zavodskoi Industries' answer to any problem that can be solved by an assault rifle. Uses 5.56mm rounds."
	desc_fluff = "It makes you feel like a corporate commando when you hold it."
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
		list(mode_name="semiauto", burst=1, fire_delay=10),
		list(mode_name="3-round bursts", burst=3, burst_accuracy=list(2,1,1), dispersion=list(0, 7.5)),
		list(mode_name="fire grenades", use_launcher=1)
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
		icon_state = "carbine"
	else
		icon_state = "carbine-empty"

/obj/item/gun/projectile/automatic/rifle/z8/examine(mob/user)
	..()
	if(launcher.chambered)
		to_chat(user, "\The [launcher] has \a [launcher.chambered] loaded.")
	else
		to_chat(user, "\The [launcher] is empty.")

/obj/item/gun/projectile/automatic/rifle/jingya
	name = "burst rifle"
	desc = "The Jingya A-1 is the first of a new line of NanoTrasen rifles, developed in cooperation with Zavodskoi Interstellar's Kumar Arms subsidiary. They are made to be sleek, easy to use by users with minimal training and cheap to mass produce while still being reliable."
	desc_fluff = "The Jingya A-1 won a hard-fought victory in the ballistic side of the SCC Future Firearms contest hosted in 2463, which was also its first unveiling: this rifle is made to function where laser weaponry may be either too risky or not functional for the engagement at hand. It is slated to be deployed for trial usage by a select few special TCFL regiments in Mictlan."
	icon = 'icons/obj/guns/crew_rifle.dmi'
	icon_state = "arifle"
	item_state = "arifle"
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
		list(mode_name="semiauto", burst=1, fire_delay=12),
		list(mode_name="2-round bursts", burst=2, burst_accuracy=list(1, 1))
	)

/obj/item/gun/projectile/automatic/rifle/jingya/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "arifle"
	else
		icon_state = "arifle-empty"

/obj/item/gun/projectile/automatic/rifle/l6_saw
	name = "light machine gun"
	desc = "A squad machine gun with a clunky, outdated loading mechanism. Loads from 7.62mm ammunition boxes. Gentlemen, lock and load."
	desc_fluff = "Created by the San Colette Interstellar Armaments Company (CAISC) explicitly for export, the Colettish Armaments Model 75 Export machine gun is a cheap yet outdated method of providing large amounts of firepower to a squad. \
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
		list(mode_name="full auto", can_autofire=1, burst=1, fire_delay=1, fire_delay_wielded=1, one_hand_fa_penalty=12, burst_accuracy = list(0,-1,-1,-2,-2,-2,-3,-3), dispersion = list(5, 10, 15, 20, 25))
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
	desc = "The Tsarrayut'yan rifle is a select-fire, crew-served automatic rifle producted by the People's Republic of Adhomai."
	icon = 'icons/obj/guns/tsarrayut.dmi'
	icon_state = "tsarrayut"
	item_state = "tsarrayut"
	contained_sprite = TRUE

	desc_fluff = "People's Republic military hardware is the most advanced among the Tajaran nations. Laser weapons, alongside simple ballistic guns, are used by high ranking soldiers or \
	special operatives. The majority of military is still equipped with simple bolt action rifles, that are being slowly replaced by the Tsarrayut'yan rifle; a select-fire, crew-served \
	automatic rifle. Regardless of advances in the small arms field, artillery is the Republican army's main weapon and pride."

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

/obj/item/gun/projectile/automatic/tommygun
	name = "submachine gun"
	desc = "An adhomian made submachine gun. Uses .45 rounds."
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

/obj/item/gun/projectile/automatic/tommygun/update_icon()
	..()
	icon_state = (ammo_magazine)? "tommygun" : "tommygun-empty"

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

	is_wieldable = TRUE

	firemodes = list(
		list(mode_name="semiauto", burst=1),
		list(mode_name="3-round bursts", burst=3, burst_accuracy=list(2,1,1), dispersion=list(0, 10, 15)),
		list(mode_name="short bursts", burst=5, burst_accuracy=list(2,1,1,0,0), dispersion=list(5, 10, 15))
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
	fire_delay = 10
	recoil_wielded = 0

	fire_delay_wielded = 6
	accuracy_wielded = 0

	firemodes = list(
		list(mode_name="semiauto", burst=1, fire_delay= 10, fire_delay_wielded=10),
		list(mode_name="3-round bursts", burst=3, burst_accuracy=list(0,-1,-1), dispersion=list(0, 10, 15))
		)

/obj/item/gun/projectile/automatic/rifle/shotgun/update_icon()
	..()
	icon_state = (ammo_magazine)? "assaultshotgun" : "assaultshotgun-empty"

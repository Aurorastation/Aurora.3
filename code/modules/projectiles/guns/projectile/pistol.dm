/obj/item/gun/projectile/colt
	name = ".45 combat pistol"
	desc = "A robust metal-framed semi-automatic pistol produced in the system of San Colette."
	desc_extended = "The Pattern 5 Pistol is the standard-issue sidearm for the Civil Guard, San Colette’s local military force. Loosely based on the standard 9mm pistol of the Solarian Army, the P5 fires a larger .45 round intended for use against heavier targets. \
	The P5 is produced by the San Colette Interstellar Armaments Company (CAISC) and is often found abroad due to its rugged construction."
	magazine_type = /obj/item/ammo_magazine/c45m
	allowed_magazines = list(/obj/item/ammo_magazine/c45m)
	icon = 'icons/obj/guns/colt.dmi'
	icon_state = "colt"
	item_state = "colt"
	caliber = ".45"
	accuracy = 1
	offhand_accuracy = 1
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	fire_sound = 'sound/weapons/gunshot/gunshot_light.ogg'
	load_method = MAGAZINE
	fire_delay = ROF_PISTOL

/obj/item/gun/projectile/colt/update_icon()
	..()
	if(ammo_magazine?.stored_ammo.len)
		icon_state = "colt"
	else
		icon_state = "colt-e"

/obj/item/gun/projectile/colt/detective
	magazine_type = /obj/item/ammo_magazine/c45m/rubber

/obj/item/gun/projectile/colt/detective/verb/rename_gun()
	set name = "Name Gun"
	set category = "Object"
	set desc = "Rename your gun. If you're the detective."
	set src in usr

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

/obj/item/gun/projectile/colt/super
	name = "ornamental .45 combat pistol"
	desc = "A robust metal-framed semi-automatic pistol produced in the system of San Colette. This example sports a short slide, wood-paneled grips, and few signs of use, likely belonging to someone of higher stature."
	desc_extended = "The Pattern 5 Pistol is the standard-issue sidearm for the Civil Guard, San Colette’s local military force. Loosely based on the standard 9mm pistol of the Solarian Army, the P5 fires a larger .45 round intended for use against heavier targets. \
	The P5 is produced by the San Colette Interstellar Armaments Company (CAISC) and is often found abroad due to its rugged construction."
	magazine_type = /obj/item/ammo_magazine/c45m/stendo
	icon = 'icons/obj/guns/coltsuper.dmi'
	icon_state = "coltsuper"
	item_state = "coltsuper"

/obj/item/gun/projectile/colt/super/update_icon()
	..()
	if(ammo_magazine?.stored_ammo.len)
		icon_state = "coltsuper"
	else
		icon_state = "coltsuper-e"

/obj/item/gun/projectile/automatic/lebman
	name = "automatic .45 combat pistol"
	desc = "A robust metal-framed semi-automatic pistol produced in the system of San Colette. This example has been modified to allow fully-automatic fire, and sports a prominent vertical grip and muzzle compensator to aid in control."
	desc_extended = "The Pattern 5 Pistol is the standard-issue sidearm for the Civil Guard, San Colette’s local military force. Loosely based on the standard 9mm pistol of the Solarian Army, the P5 fires a larger .45 round intended for use against heavier targets. \
	The P5 is produced by the San Colette Interstellar Armaments Company (CAISC) and is often found abroad due to its rugged construction."
	magazine_type = /obj/item/ammo_magazine/c45m/lebman
	icon = 'icons/obj/guns/coltauto.dmi'
	icon_state = "coltauto"
	item_state = "coltauto"
	w_class = ITEMSIZE_NORMAL
	accuracy = 1
	offhand_accuracy = 1
	load_method = MAGAZINE
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	max_shells = 18
	caliber = ".45"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	ammo_type = /obj/item/ammo_casing/c45
	allowed_magazines = list(/obj/item/ammo_magazine/c45m)

/obj/item/gun/projectile/automatic/lebman/update_icon()
	..()
	if(ammo_magazine?.stored_ammo.len)
		icon_state = "coltauto"
	else
		icon_state = "coltauto-e"

/obj/item/gun/projectile/sec
	name = "\improper .45 pistol"
	desc = "A NanoTrasen designed sidearm, found among law enforcement and security forces."
	desc_extended = "The NT Mk58 is a ballistic sidearm developed and produced by NanoTrasen. Bulky and heavy, the Mk58 is nonetheless used by security forces and law enforcement for its ease of use, low maintenance requirement, longevity, reliability - and most of all, extremely inexpensive price tag. A trademark of NanoTrasen security forces. It uses .45 rounds."
	icon = 'icons/obj/guns/secgun.dmi'
	icon_state = "secgun"
	item_state = "secgun"
	magazine_type = /obj/item/ammo_magazine/c45m/rubber
	allowed_magazines = list(/obj/item/ammo_magazine/c45m)
	caliber = ".45"
	accuracy = 1
	offhand_accuracy = 1
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	fire_sound = 'sound/weapons/gunshot/gunshot_pistol.ogg'
	load_method = MAGAZINE
	fire_delay = ROF_PISTOL

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
	name = "custom .45 pistol"
	desc = "A NanoTrasen designed sidearm, found among law enforcement and security forces. It has a wooden grip."
	desc_extended = "The NT Mk58 is a ballistic sidearm developed and produced by NanoTrasen. Bulky and heavy, the Mk58 is nonetheless used by security forces and law enforcement for its ease of use, low maintenance requirement, longevity, reliability - and most of all, extremely inexpensive price tag. A trademark of NanoTrasen security forces. This one has a faux wooden grip. It uses .45 rounds."
	icon = 'icons/obj/guns/secgun_wood.dmi'
	icon_state = "secgunwood"
	item_state = "secgunwood"

/obj/item/gun/projectile/sec/wood/update_icon()
	..()
	if(ammo_magazine?.stored_ammo.len)
		icon_state = "secgunwood"
	else
		icon_state = "secgunwood-e"

/obj/item/gun/projectile/automatic/x9
	name = "automatic .45 pistol"
	desc = "A NanoTrasen-designed sidearm, modified for fully-automatic fire. Issued to select security and law enforcement groups."
	desc_extended = "The NT Mk58 is a ballistic sidearm developed and produced by NanoTrasen. Bulky and heavy, the Mk58 is nonetheless used by security \
	forces and law enforcement for its ease of use, low maintenance requirement, longevity, reliability - and most of all, extremely inexpensive price tag. \
	A trademark of NanoTrasen security forces. This one has been modified for fully-automatic fire from the factory and sports a collapsible shoulder stock for better control. It uses .45 rounds."
	icon = 'icons/obj/guns/x9.dmi'
	icon_state = "secgunauto"
	item_state = "secgunauto"
	w_class = ITEMSIZE_NORMAL
	accuracy = 1
	offhand_accuracy = 1
	load_method = MAGAZINE
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	max_shells = 16
	caliber = ".45"
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2)
	ammo_type = /obj/item/ammo_casing/c45
	magazine_type = /obj/item/ammo_magazine/c45m/auto
	allowed_magazines = list(/obj/item/ammo_magazine/c45m)
	multi_aim = 1
	auto_eject = 1
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'

/obj/item/gun/projectile/automatic/x9/update_icon()
	..()
	if(ammo_magazine?.stored_ammo.len)
		icon_state = "secgunauto"
	else
		icon_state = "secgunauto-e"

/obj/item/gun/projectile/tanto
	desc = "An automatic variant of the NanoTrasen Mk1 Everyman handgun that has been built to accept detachable magazines, negating one of the original \
	weapon's biggest shortcomings. It is marketed towards lower-echelon security companies as a machine pistol named the Tanto, and features a burst-fire selector \
	and sturdier barrel with heatshield to better take advantage of the higher capacity."
	name = "10mm auto-pistol"
	icon = 'icons/obj/guns/c05r.dmi'
	icon_state = "c05r"
	item_state = "c05r"
	magazine_type = /obj/item/ammo_magazine/mc10mm
	allowed_magazines = list(/obj/item/ammo_magazine/mc10mm)
	caliber = "10mm"
	accuracy = 1
	offhand_accuracy = 1
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	fire_sound = 'sound/weapons/gunshot/gunshot_pistol.ogg'
	load_method = MAGAZINE
	sel_mode = 1

	firemodes = list(
		list(mode_name="semiauto", burst=1, fire_delay=ROF_PISTOL, fire_delay_wielded=ROF_SMG),
		list(mode_name="3-round bursts", burst=3, burst_accuracy=list(1,0,0), dispersion=list(0, 10))
		)


/obj/item/gun/projectile/tanto/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "c05r"
	else
		icon_state = "c05r-e"

/obj/item/gun/projectile/silenced
	name = "suppressed pistol"
	desc = "A small, quiet, easily concealable gun."
	desc_extended = "Created as a disposable and concealable weapon, the Mrrazhakulii suppressed pistol is a firearm with a suppressor integrated as part of its barrel. \
		Carried by guerrilla forces and spies, those guns are used in assassination and subterfuge operations. Due to using cheap and available materials, such as \
		recycled iron and tires, countless of those pistols were distributed among cells and ALA soldiers."
	icon = 'icons/obj/guns/silenced_pistol.dmi'
	icon_state = "silenced_pistol"
	item_state = "silenced_pistol"
	fire_sound = 'sound/weapons/gunshot/gunshot_suppressed.ogg'
	w_class = ITEMSIZE_NORMAL
	accuracy = 1
	offhand_accuracy = 1
	caliber = ".45"
	suppressed = TRUE
	can_unsuppress = FALSE
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_ILLEGAL = 8)
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/c45m
	allowed_magazines = list(/obj/item/ammo_magazine/c45m)
	fire_delay = ROF_PISTOL

/obj/item/gun/projectile/silenced/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "[initial(icon_state)]"
	else
		icon_state = "[initial(icon_state)]-e"

/obj/item/gun/projectile/deagle
	name = ".50 magnum pistol"
	desc = "A very robust handgun."
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
	fire_delay = ROF_RIFLE

/obj/item/gun/projectile/deagle/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "[initial(icon_state)]"
	else
		icon_state = "[initial(icon_state)]-e"

/obj/item/gun/projectile/deagle/adhomai
	name = "adhomian heavy pistol"
	desc = "A bulky handgun used by republican commissars and high-ranking members of the Hadiist Party."
	icon = 'icons/obj/guns/adhomian_heavy_pistol.dmi'
	icon_state = "adhomian_heavy_pistol"
	item_state = "adhomian_heavy_pistol"
	desc_extended = "Given to Republican Commissars and high ranking Party members, the Nal'tor Model Pistol is notable for its large caliber. Unlike the Adar'Mazy pistol, only a \
	single factory in Nal'tor is allowed to fabricate it, with its design being kept as a state secret. Because of its rarity and status, the Adhomai Heavy Pistol was a sought after \
	war trophy by royalist and rebels forces."

/obj/item/gun/projectile/gyropistol
	name = "gyrojet pistol"
	desc = "A massive experimental pistol, designed to fire self-propelled rounds."
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
	fire_delay = ROF_UNWIELDY

/obj/item/gun/projectile/gyropistol/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "gyropistolloaded"
	else
		icon_state = "gyropistol"

/obj/item/gun/projectile/pistol
	name = "9mm pistol"
	desc = "An extremely popular compact handgun, used throughout human space."
	desc_extended = "The Zavodskoi Interstellar Moonlight 9mm can be found in the hands of just about anyone imaginable - special operatives, common criminals, police officers, the average Joe - on account of the time-tested design, low price point, reliability, and ease of concealment. Having a threaded barrel helps, too, and it isn't uncommon to see the Moonlight as a prop in spy films, suppressed."
	icon = 'icons/obj/guns/pistol.dmi'
	icon_state = "pistol"
	item_state = "pistol"
	w_class = ITEMSIZE_SMALL
	accuracy = 1
	offhand_accuracy = 2
	caliber = "9mm"
	suppressed = FALSE
	can_suppress = TRUE
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_ILLEGAL = 2)
	fire_sound = 'sound/weapons/gunshot/gunshot_pistol.ogg'
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/mc9mm
	allowed_magazines = list(/obj/item/ammo_magazine/mc9mm)
	fire_delay = ROF_PISTOL
	suppressor_x_offset = 5

/obj/item/gun/projectile/pistol/flash
	name = "9mm signal pistol"
	magazine_type = /obj/item/ammo_magazine/mc9mm/flash

/obj/item/gun/projectile/pistol/detective
	desc = "A compact NanoTrasen designed sidearm, popular with law enforcement personnel for concealed carry purposes. It has a faux wooden grip."
	desc_extended = "The NT Mk21 Blackjack is a ballistic sidearm developed and produced by NanoTrasen. Unlike the related Mk58, the Blackjack is a rather high quality piece - typically issued to higher ranking law enforcement personnel, the Mk21 is compact and chambered in 9mm caliber. With all the bells and whistles of a modern, quality police pistol, the Blackjack's main drawback is the notoriously nippy recoil - 9mm in such a small package can be unpleasant for the average shooter."
	name = "compact 9mm pistol"
	magazine_type = /obj/item/ammo_magazine/mc9mm
	icon = 'icons/obj/guns/detgun.dmi'
	icon_state = "detgun"
	item_state = "detgun"
	can_suppress = FALSE

/obj/item/gun/projectile/pistol/detective/update_icon()
	..()
	if(ammo_magazine?.stored_ammo.len)
		icon_state = "detgun"
	else
		icon_state = "detgunempty"

/obj/item/gun/projectile/pistol/detective/verb/rename_gun()
	set name = "Name Gun"
	set category = "Object"
	set desc = "Rename your gun."
	set src in usr

	var/input = sanitizeSafe(input("What do you want to name the gun?", ,""), MAX_NAME_LEN)

	if(use_check_and_message(usr))
		return
	name = input
	to_chat(usr, "You name the gun [input]. Say hello to your new friend.")

/obj/item/gun/projectile/pistol/update_icon()
	..()
	if(!(ammo_magazine && ammo_magazine.stored_ammo.len))
		icon_state = "[icon_state]-e"
	else
		icon_state = "pistol"

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
	var/obj/item/ammo_casing/ammo = ammo_type
	caliber = initial(ammo.caliber)
	. = ..()

/obj/item/gun/projectile/leyon
	name = "10mm pistol"
	desc = "NanoTrasen's first marketed firearm design, the Mk1, better known as the Everyman, was an instant hit - though it is a crude, \
	stripper clip-fed design with a very small capacity, the Everyman is absurdly inexpensive and famously reliable, and is now one of the most \
	common weapons found in the Orion Spur."
	icon = 'icons/obj/guns/leyon.dmi'
	icon_state = "leyon"
	item_state = "leyon"
	caliber = "10mm"
	w_class = ITEMSIZE_SMALL
	ammo_type = /obj/item/ammo_casing/c10mm
	magazine_type = /obj/item/ammo_magazine/mc10mm/leyon
	max_shells = 5
	origin_tech = list(TECH_COMBAT = 1, TECH_MATERIAL = 1)
	fire_sound = 'sound/weapons/gunshot/gunshot_pistol.ogg'
	load_method = SINGLE_CASING|SPEEDLOADER
	fire_delay = ROF_PISTOL

/obj/item/gun/projectile/leyon/update_icon()
	..()
	if(loaded.len)
		icon_state = "leyon"
	else
		icon_state = "leyon-e"

/obj/item/gun/projectile/pistol/sol
	name = "solarian service pistol"
	desc = "Manufactured by Zavodskoi Interstellar and based off of a full-sized variant of their 9mm design, the compact M8 is the standard service pistol of the Solarian Armed Forces."
	icon = 'icons/obj/guns/sol_pistol.dmi'
	icon_state = "m8"
	item_state = "m8"
	can_suppress = TRUE
	suppressor_x_offset = 9
	suppressor_y_offset = 3

/obj/item/gun/projectile/pistol/sol/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "m8"
	else
		icon_state = "m8-empty"

/obj/item/gun/projectile/pistol/adhomai
	name = "adhomian service pistol"
	desc = "The Adar'Mazy pistol is an Adhomian firearm commonly issued to People's Republic officers, government officials and low-ranking Party members."
	icon = 'icons/obj/guns/adhomian_pistol.dmi'
	icon_state = "adhomian_pistol"
	item_state = "adhomian_pistol"
	can_suppress = FALSE
	desc_extended = "A mass produced pistol issued to People's Republic officers, government officials and low-ranking Party members. Known for their simple, cheap and reliable \
	design, this weapon is produced by nearly all weapon factories in the Republic. The Adar'Mazy is also found in the hands of Adhomai Liberation Army soldiers and commanders."

/obj/item/gun/projectile/pistol/adhomai/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "adhomian_pistol"
	else
		icon_state = "adhomian_pistol-e"

/obj/item/gun/projectile/pistol/super_heavy
	name = "super-heavy pistol"
	desc = "A big, bulky, and extremely powerful pistol, intended to pierce even your strongest enemy. You should wield this thing with two hands, if you want your wrists to stay intact."
	desc_extended = "The Kumar Arms 2557 is a newly designed type of \"super-heavy\" pistol. \
	It features a light-weight polymer pistol grip, a bulky plasteel frame and an extra long barrel. \
	It is chambered in the newly developed .599 Kumar Super rifle cartridge. Despite designed for rifle use, the newly developed propellants allows this cartridge for use in the Kumar Arms 2557, upping the stopping power significantly. \
	Kumar Arms guarantees your enemy's armor penetrated or your money back. It features a revolving bolt system with an electromagnetic striker, allowing for hammerless actuation. It has a revolutinary blowback system to ensure accuracy at the cost of fire rate."
	icon = 'icons/obj/item/gun/projectile/pistol/k_arms.dmi'
	icon_state = "k2557-loaded"
	item_state = "k2557-loaded"
	contained_sprite = TRUE
	can_suppress = FALSE
	w_class = ITEMSIZE_NORMAL
	load_method = MAGAZINE
	handle_casings = EJECT_CASINGS
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	is_wieldable = TRUE
	fire_sound = 'sound/weapons/gunshot/k2557-shot.ogg'
	caliber = ".599 Kumar Super"
	ammo_type = /obj/item/ammo_casing/kumar_super
	magazine_type = /obj/item/ammo_magazine/super_heavy
	allowed_magazines = list(/obj/item/ammo_magazine/super_heavy)
	fire_delay = ROF_UNWIELDY
	fire_delay_wielded = ROF_SUPERHEAVY
	max_shells = 5
	force = 3
	recoil = 5
	recoil_wielded = 1
	accuracy = -3
	accuracy_wielded = 1

/obj/item/gun/projectile/pistol/super_heavy/Initialize()
	. = ..()
	desc_info = "This is an extremely powerful ballistic weapon, using .599 Kumar Super ammunition. If you aren't an Unathi or a G2 IPC, firing without wielding (clicking in-hand) could lead to serious injury or death; Unathi and G2s may fire it unwielded \
	with an aim penalty. To fire the weapon, toggle the safety with ctrl-click (or enable HARM intent), then click where you want to fire.  To reload, click the gun with an empty hand to remove the magazine, and then insert a new one."

/obj/item/gun/projectile/pistol/super_heavy/update_icon()
	..()
	if(istype(ammo_magazine))
		if(ammo_magazine.stored_ammo.len)
			icon_state = "k2557-loaded"
		else
			icon_state = "k2557-empty"
	else
		icon_state = "k2557"

/obj/item/gun/projectile/pistol/super_heavy/handle_post_fire(mob/user)
	..()
	if(wielded)
		return
	else
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(H.mob_size <10)
				H.visible_message(SPAN_WARNING("\The [src] flies out of \the [H]'s' hand!"), SPAN_WARNING("\The [src] flies out of your hand!"))
				H.drop_item(src)
				src.throw_at(get_edge_target_turf(src, GLOB.reverse_dir[H.dir]), 4, 4)

				var/obj/item/organ/external/LH = H.get_organ(BP_L_HAND)
				var/obj/item/organ/external/RH = H.get_organ(BP_R_HAND)
				var/active_hand = H.hand

				if(active_hand)
					LH.take_damage(30)
				else
					RH.take_damage(30)

/obj/item/gun/projectile/xanupistol
	name = "\improper Xanan service pistol"
	desc = "A sleek metal-framed semi-automatic pistol, produced by d.N.A Defense for the All-Xanu Armed Forces."
	desc_extended = "The dNAC-4.6 pistol is the standard issue sidearm for the All-Xanu Armed Forces. Designed to use 4.6x30mm rounds with less weight but better armor penetration than the 9mm pistols it replaced, the dNAC-4.6 has seen great success in Xanu Prime and beyond, as it has been adopted as a standard sidearm for police forces, military units, and other entities across the Coalition of Colonies and beyond."
	magazine_type = /obj/item/ammo_magazine/c46m
	allowed_magazines = list(/obj/item/ammo_magazine/c46m, /obj/item/ammo_magazine/c46m/extended)
	icon = 'icons/obj/guns/xanu_pistol.dmi'
	icon_state = "xanu_pistol"
	item_state = "xanu_pistol"
	caliber = "4.6mm"
	accuracy = 1
	offhand_accuracy = 1
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	fire_sound = 'sound/weapons/gunshot/gunshot_light.ogg'
	load_method = MAGAZINE
	fire_delay = ROF_PISTOL
	suppressed = FALSE
	can_suppress = TRUE
	suppressor_x_offset = 9
	suppressor_y_offset = 2

/obj/item/gun/projectile/xanupistol/update_icon()
	..()
	if(ammo_magazine)
		if(ammo_magazine.stored_ammo.len)
			icon_state = "xanu_pistol"
		else
			icon_state = "xanu_pistol-em"
	else
		icon_state = "xanu_pistol-e"

/obj/item/gun/projectile/pistol/dominia
	name = "dominian service pistol"
	desc = "The Imperial Army's standard-issue handgun. Cheap, reliable, and easy to use."
	desc_extended = "The Moroz Pattern Pistol, Year of 2450 (MPP-50) is a reliable handgun chambered in 7.62 \
	Imperial Short which features an unusual magazine. Zavodskoi Interstellar is a major producer of these handguns."
	magazine_type = /obj/item/ammo_magazine/c45m/dominia
	allowed_magazines = list(/obj/item/ammo_magazine/c45m/dominia)
	icon = 'icons/obj/guns/dominia_pistol.dmi'
	icon_state = "dom_pistol"
	item_state = "dom_pistol"
	caliber = ".45"
	fire_sound = 'sound/weapons/gunshot/gunshot_pistol.ogg'
	load_method = MAGAZINE
	fire_delay = ROF_PISTOL

/obj/item/gun/projectile/pistol/dominia/update_icon()
	..()
	if(ammo_magazine?.stored_ammo.len)
		icon_state = "dom_pistol"
	else
		icon_state = "dom_pistol-e"

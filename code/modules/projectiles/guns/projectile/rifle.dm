/obj/item/gun/projectile/shotgun/pump/rifle
	name = "\improper Harrzhak pattern bolt action rifle"
	desc = "A cheap ballistic rifle, often found in the hands of Tajaran conscripts."
	icon = 'icons/obj/guns/faction/pra/bolt.dmi'
	icon_state = "moistnugget"
	item_state = "moistnugget"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	fire_sound = 'sound/weapons/gunshot/gunshot_rifle.ogg'
	caliber = "6.8mm"
	ammo_type = /obj/item/ammo_casing/a68
	magazine_type = /obj/item/ammo_magazine/boltaction/adhomai
	max_shells = 5

	rack_sound = 'sound/weapons/riflebolt.ogg'
	rack_verb = "pull back the bolt on"
	cycle_anim = FALSE

	can_bayonet = TRUE
	knife_x_offset = 23
	knife_y_offset = 13
	can_sawoff = TRUE
	sawnoff_workmsg = "shorten the barrel and stock"

/obj/item/gun/projectile/shotgun/pump/rifle/magazine_fed
	name = "strange rifle"
	desc = DESC_PARENT
	can_sawoff = FALSE
	load_method = MAGAZINE

/obj/item/gun/projectile/shotgun/pump/rifle/magazine_fed/handle_pump_loading()
	if(ammo_magazine && length(ammo_magazine.stored_ammo))
		var/obj/item/ammo_casing/AC = ammo_magazine.stored_ammo[1] //load next casing.
		if(AC)
			AC.forceMove(src)
			ammo_magazine.stored_ammo -= AC
			chambered = AC

/obj/item/gun/projectile/shotgun/pump/rifle/blank
	desc = "A replica of a traditional Adhomian bolt action rifle. It has the seal of the Grand Romanovich Casino on its stock."
	ammo_type = /obj/item/ammo_casing/a68/blank

/obj/item/gun/projectile/shotgun/pump/rifle/scope
	name = "scoped Harrzhak pattern bolt action rifle"
	desc = "A cheap ballistic rifle, often found in the hands of Tajaran conscripts. This one has a telescopic sight attached to it."
	icon = 'icons/obj/guns/faction/pra/bolt_scope.dmi'

/obj/item/gun/projectile/shotgun/pump/rifle/scope/verb/scope()
	set category = "Object.Held"
	set name = "Use Scope"
	set src in usr

	if(wielded)
		toggle_scope(2.0, usr)
	else
		to_chat(usr, SPAN_WARNING ("You can't look through the scope without stabilizing the rifle!"))

/obj/item/gun/projectile/shotgun/pump/rifle/saw_off(mob/user, obj/item/tool)
	icon = 'icons/obj/guns/obrez.dmi'
	icon_state = "obrez"
	item_state = "obrez"
	w_class = WEIGHT_CLASS_NORMAL
	recoil = 2
	accuracy = -2
	slot_flags &= ~SLOT_BACK
	slot_flags |= (SLOT_BELT|SLOT_HOLSTER)
	can_bayonet = FALSE
	if(bayonet)
		qdel(bayonet)
		bayonet = null
		update_icon()
	name = "sawn-off bolt action rifle"
	desc = "A shortened bolt action rifle, not really acurate."
	to_chat(user, SPAN_WARNING("You shorten the barrel and stock of the rifle!"))

/obj/item/gun/projectile/shotgun/pump/rifle/obrez
	name = "sawn-off bolt action rifle"
	desc = "A shortened bolt action rifle, not really accurate."
	icon = 'icons/obj/guns/obrez.dmi'
	icon_state = "obrez"
	item_state = "obrez"
	w_class = WEIGHT_CLASS_NORMAL
	recoil = 2
	accuracy = -2
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	can_bayonet = FALSE

/obj/item/gun/projectile/shotgun/pump/rifle/magazine_fed/pipegun
	name = "pipegun"
	desc = "An excellent weapon for flushing out tunnel rats and enemy assistants, but its rifling leaves much to be desired."
	icon = 'icons/obj/guns/pipegun.dmi'
	icon_state = "pipegun"
	item_state = "pipegun"
	caliber = "a556"
	ammo_type = null
	magazine_type = null
	allowed_magazines = list(/obj/item/ammo_magazine/a556/makeshift)
	load_method = MAGAZINE
	max_shells = 7
	can_sawoff = FALSE

	needspin = FALSE
	has_safety = FALSE

	slot_flags = SLOT_BACK|SLOT_S_STORE // can be stored in suit slot due to built in sling

	jam_chance = -10

/obj/item/gun/projectile/shotgun/pump/rifle/magazine_fed/pipegun/condition_hints(mob/user, distance, is_adjacent, infix, suffix)
	. = list()
	. += ..()
	switch(jam_chance)
		if(10 to 20)
			. += SPAN_NOTICE("\The [src] is starting to accumulate fouling. Might want to grab a rag.")
		if(20 to 40)
			. += SPAN_WARNING("\The [src] looks reasonably fouled up. Maybe you should clean it with a rag.")
		if(40 to 80)
			. += SPAN_WARNING("\The [src] is starting to look quite gunked up. You should clean it with a rag.")
		if(80 to INFINITY)
			. += SPAN_DANGER("\The [src] is completely fouled. You're going to be extremely lucky to get a shot off. Clean it with a rag.")

/obj/item/gun/projectile/shotgun/pump/rifle/magazine_fed/pipegun/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/reagent_containers/glass/rag))
		if(!jam_chance || jam_chance == initial(jam_chance))
			to_chat(user, SPAN_WARNING("There's no fouling present on \the [src]."))
			return
		user.visible_message("<b>[user]</b> starts cleaning \the [src] with \the [attacking_item].", SPAN_NOTICE("You start cleaning \the [src] with \the [attacking_item]."))
		if(do_after(user, jam_chance * 5))
			to_chat(user, SPAN_WARNING("You completely clean \the [src]."))
			jam_chance = initial(jam_chance)
		return
	return ..()

/obj/item/gun/projectile/shotgun/pump/rifle/magazine_fed/pipegun/handle_post_fire(mob/user)
	. = ..()
	jam_chance = min(jam_chance + 5, 100)

/obj/item/gun/projectile/shotgun/pump/rifle/dominia
	name = "\improper MPMR-08/2 sniper rifle"
	desc = "A precision rifle used by snipers and sharpshooters of the Imperial Army. One of the few modern military-grade weapons to use a bolt for its action."
	desc_extended = "The MPMR-08/2 is a precisely machined and meticulously designed rifle which prioritizes accuracy and precision over rate of fire. \
	Outside of the Imperial Army, it is commonly seen in the hands of competition shooters."
	icon = 'icons/obj/guns/faction/dominian_empire/dominia_bolt_action.dmi'
	icon_state = "dom_bolt_action"
	item_state = "dom_bolt_action"
	caliber = "a762"
	ammo_type = /obj/item/ammo_casing/a762
	magazine_type = /obj/item/ammo_magazine/boltaction
	load_method = SPEEDLOADER

/obj/item/gun/projectile/shotgun/pump/rifle/dominia/verb/scope()
	set category = "Object.Held"
	set name = "Use Scope"
	set src in usr

	if(wielded)
		toggle_scope(2.0, usr)
	else
		to_chat(usr, SPAN_WARNING("You can't look through the scope without stabilizing the rifle!"))

/obj/item/gun/projectile/contender
	name = "\improper H-H Gram pocket rifle"
	desc = "A perfect, pristine replica of an ancient one-shot hand-cannon. This one has been modified to work almost like a bolt-action."
	icon = 'icons/obj/guns/faction/frontier/pockrifle.dmi'
	icon_state = "pockrifle"
	item_state = "pockrifle"
	caliber = "a556"
	handle_casings = HOLD_CASINGS
	max_shells = 1
	ammo_type = /obj/item/ammo_casing/a556
	magazine_type = /obj/item/ammo_magazine/a556
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	load_method = SINGLE_CASING
	fire_sound = 'sound/weapons/gunshot/gunshot3.ogg'
	var/retracted_bolt = 0
	var/icon_retracted = "pockrifle-empty"

/obj/item/gun/projectile/contender/special_check(mob/user)
	if(retracted_bolt)
		to_chat(user, SPAN_WARNING("You can't fire \the [src] while the bolt is open!"))
		return 0
	return ..()

/obj/item/gun/projectile/contender/unique_action(mob/user as mob)
	if(chambered)
		chambered.forceMove(get_turf(src))
		chambered = null
		var/obj/item/ammo_casing/C = loaded[1]
		loaded -= C

	if(!retracted_bolt)
		to_chat(user, SPAN_NOTICE("You cycle back the bolt on \the [src], ejecting the casing and allowing you to reload."))
		playsound(user, 'sound/weapons/riflebolt.ogg', 60, 1)
		icon_state = icon_retracted
		item_state = icon_retracted
		retracted_bolt = 1
		user.update_inv_l_hand()
		user.update_inv_r_hand()
		return 1

	else if(retracted_bolt && loaded.len)
		to_chat(user, SPAN_NOTICE("You cycle the loaded round into the chamber, allowing you to fire."))

	else
		to_chat(user, SPAN_NOTICE("You cycle the bolt back into position, leaving the gun empty."))

	icon_state = initial(icon_state)
	item_state = initial(item_state)

	user.update_inv_l_hand()
	user.update_inv_r_hand()

	retracted_bolt = 0

/obj/item/gun/projectile/contender/load_ammo(var/obj/item/A, mob/user)
	if(!retracted_bolt)
		to_chat(user, SPAN_NOTICE("You can't load \the [src] without cycling the bolt."))
		return
	..()

/obj/item/gun/projectile/contender/unload_ammo(mob/user, allow_dump = TRUE, drop_mag = FALSE)
	if(!retracted_bolt)
		to_chat(user, SPAN_NOTICE("You can't unload \the [src] without cycling the bolt."))
		return
	..()

/obj/item/gun/projectile/shotgun/pump/rifle/vintage
	name = "\improper M1903 Springfield rifle"
	desc = "An extremely old-looking rifle. Words you can't read are stamped on the gun. Doesn't look like it'll take any modern rounds."
	icon = 'icons/obj/guns/faction/antique/springfield.dmi'
	icon_state = "springfield"
	item_state = "springfield"
	origin_tech = list(TECH_COMBAT = 1, TECH_MATERIAL = 3)
	fire_sound = 'sound/weapons/gunshot/gunshot_rifle.ogg'
	slot_flags = SLOT_BACK
	load_method = SINGLE_CASING|SPEEDLOADER
	handle_casings = HOLD_CASINGS
	caliber = "30-06 govt"
	ammo_type = /obj/item/ammo_casing/vintage
	magazine_type = /obj/item/ammo_magazine/boltaction/vintage
	can_bayonet = TRUE
	var/open_bolt = 0
	var/obj/item/ammo_magazine/boltaction/vintage/has_clip

/obj/item/gun/projectile/shotgun/pump/rifle/vintage/unique_action(mob/living/user as mob)
	if(wielded)
		pump(user)
	if(open_bolt && has_clip)
		if(has_clip.stored_ammo.len > 0)
			load_ammo(has_clip, user)
			src.ClearOverlays()
			if(!has_clip.stored_ammo.len)
				AddOverlays("springfield-clip-empty")
			else if(has_clip.stored_ammo.len <= 3)
				AddOverlays("springfield-clip-half")
			else
				AddOverlays("springfield-clip-full")
		else
			to_chat(user, SPAN_WARNING("There is no ammo in \the [has_clip.name]!"))
	else if(!open_bolt)
		to_chat(user, SPAN_WARNING("The bolt on \the [src.name] is closed! You'll have to grip it with both hands to rack it."))
	else
		to_chat(user, SPAN_WARNING("There is no clip in \the [src.name]!"))

/obj/item/gun/projectile/shotgun/pump/rifle/vintage/pump(mob/M as mob)
	if(!open_bolt)
		open_bolt = 1
		icon_state = "springfield-openbolt"
		playsound(M, rack_sound, 60, 1)
		update_icon()
		return
	open_bolt = 0
	icon_state = "springfield"
	playsound(M, rack_sound, 60, 1)
	if(has_clip)
		has_clip.forceMove(get_turf(src))
		has_clip = null
		ClearOverlays()

	if(chambered)//We have a shell in the chamber
		chambered.forceMove(get_turf(src))//Eject casing
		chambered = null

	if(loaded.len)
		var/obj/item/ammo_casing/AC = loaded[1] //load next casing.
		loaded -= AC //Remove casing from loaded list.
		chambered = AC

	update_icon()

/obj/item/gun/projectile/shotgun/pump/rifle/vintage/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/ammo_magazine/boltaction/vintage))
		if(!open_bolt)
			to_chat(user, SPAN_NOTICE("You need to open the bolt of \the [src] first."))
			return
		if(!has_clip)
			user.drop_from_inventory(attacking_item, src)
			has_clip = attacking_item
			to_chat(user, SPAN_NOTICE("You load the clip into \the [src]."))
			if(!has_clip.stored_ammo.len)
				AddOverlays("springfield-clip-empty")
			else if(has_clip.stored_ammo.len <= 3)
				AddOverlays("springfield-clip-half")
			else
				AddOverlays("springfield-clip-full")
		else
			to_chat(user, SPAN_NOTICE("There's already a clip in \the [src]."))

	else
		..()

/obj/item/gun/projectile/shotgun/pump/rifle/vintage/load_ammo(var/obj/item/A, mob/user)
	if(!open_bolt)
		to_chat(user, SPAN_WARNING("The bolt is closed on \the [src]!"))
		return
	..()

/obj/item/gun/projectile/shotgun/pump/rifle/vintage/Fire(atom/target, mob/living/user, clickparams, pointblank=0, reflex=0)
	if(open_bolt)
		to_chat(user, SPAN_WARNING("The bolt is open on \the [src]!"))
		return
	..()

/obj/item/gun/projectile/gauss
	name = "\improper NGS-01 gauss thumper"
	desc = "An outdated model of gauss weapon which sees sparing use in modern times."
	desc_extended = "Designed by NanoTrasen in 2398, the NGS-01 was an offshoot of the venerable HeS-05 gauss rifle. After purchasing \
	the defunct Henricus company’s designs, work began on an upgrade. Trading in the depleted uranium rounds for tungsten that was more \
	common in the Solarian core worlds, the power equipment was also made more compact thanks to the usage of phoron components pioneered by NT. \
	This allowed for a magazine-based ammo loading system, no longer requiring the simple break-action that isolated the ammo from the hot temperatures. \
	The result was the “Thumper” model of gauss gun. Its popularity quickly established NanoTrasen as a new player in the firearms \
	industry. While at this point obsolete compared to newer models, its cheapness led it to be established as the official weapon of the \
	then-recently established Tau Ceti Foreign Legion in 2459, providing it a new lease of life despite its obvious shortcomings due to its age."
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = SLOT_BACK
	magazine_type = /obj/item/ammo_magazine/gauss
	allowed_magazines = list(/obj/item/ammo_magazine/gauss)
	icon = 'icons/obj/guns/faction/nanotrasen_corporation/gauss_thumper.dmi'
	icon_state = "gauss_thumper"
	item_state = "gauss_thumper"
	caliber = "gauss"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	fire_sound = SFX_SHOOT_GAUSS
	load_method = MAGAZINE
	handle_casings = DELETE_CASINGS

	force = 15
	can_bayonet = TRUE
	knife_x_offset = 23
	knife_y_offset = 13

	fire_delay = ROF_UNWIELDY
	accuracy = -1

	fire_delay_wielded = ROF_HEAVY
	accuracy_wielded = 2

	is_wieldable = TRUE

/obj/item/gun/projectile/gauss/update_icon()
	..()
	icon_state = (ammo_magazine)? "gauss_thumper" : "gauss_thumper-e"

/obj/item/gun/energy/gauss/mounted/mech
	name = "heavy gauss cannon"
	desc = "An outdated and power hungry gauss cannon, modified to deliver high explosive rounds at high velocities."
	desc_extended = null
	icon = 'icons/obj/guns/faction/nanotrasen_corporation/gauss_thumper.dmi' //TODO: Needs a proper sprite
	icon_state = "gauss_thumper"
	fire_sound = SFX_SHOOT_GAUSS
	fire_delay = ROF_UNWIELDY
	charge_meter = 0
	max_shots = 3
	charge_cost = 500
	projectile_type = /obj/projectile/bullet/gauss/highex
	self_recharge = TRUE
	use_external_power = TRUE
	recharge_time = 12
	needspin = FALSE

/obj/item/gun/projectile/gauss/old
	name = "\improper Henricus HeS-05 gauss rifle"
	desc = "A simple break-action gun utilizing gauss technology. It is still reliable and cheap despite being an out of date model."
	desc_extended = "The Henricus company was de Namur Defense Systems’s chief rival throughout the 23rd and 24th centuries. While de Namur primarily \
	focused on projectile weapons and armor, the Henricus company was known for its innovative at the time gauss weaponry. While popular throughout the \
	Coalition, competition by megacorporations allowed in by the Solarian Reproachment chipped at their market share as the weapons became \
	considered dated, and upgrades were slow to come. The Henricus company eventually shuttered its doors in 2391, its last production facilities \
	being sold to de Namur."
	icon = 'icons/obj/guns/faction/frontier/gauss_carbine.dmi'
	icon_state = "gauss_carbine"
	item_state = "gauss_carbine"
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = SLOT_BACK
	ammo_type = /obj/item/ammo_casing/gauss/old
	load_method = SINGLE_CASING
	handle_casings = HOLD_CASINGS
	max_shells = 1

	fire_delay_wielded = ROF_INTERMEDIATE
	accuracy_wielded = 1

/obj/item/gun/projectile/gauss/old/update_icon()
	..()
	if(loaded.len)
		icon_state = "gauss_carbine"
	else
		icon_state = "gauss_carbine-e"

/obj/item/gun/projectile/gauss/old/special_check(mob/user)
	if(!wielded)
		to_chat(user, SPAN_WARNING("You can't fire without stabilizing \the [src]!"))
		return 0
	return ..()

/obj/item/gun/projectile/shotgun/pump/lever_action
	name = "\improper Harrier-Elrond Zalen lever action rifle"
	desc = "A lever action rifle from the frontier with a side-loading port, the Zalen is popular with frontiersmen for hunting and self-defense purposes."
	desc_extended = "The Harrier-Elrond company is not well-known outside of the human frontier, and the outskirts of the Coalition. Mostly providing cheap \
	firearms for those not readily served by the mega-corporations, a single factory is able to provide for an entire standard years’ demand. \
	Despite this, the nearly century of business the company have been in have allowed for numerous copies to be found throughout the human frontier, \
	and in many cases even beyond."
	icon = 'icons/obj/guns/faction/frontier/leveraction.dmi'
	icon_state = "leveraction"
	item_state = "leveraction"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	fire_sound = 'sound/weapons/gunshot/gunshot_rifle.ogg'
	caliber = "45-70 govt"
	ammo_type = /obj/item/ammo_casing/govt
	max_shells = 4
	load_method = SINGLE_CASING
	handle_casings = HOLD_CASINGS

	cycle_anim = TRUE

	rack_sound = 'sound/weapons/reloads/lever_action_cock1.ogg'
	rack_verb = "work the lever on"
	can_bayonet = FALSE
	can_sawoff = FALSE

/obj/item/gun/projectile/shotgun/pump/rifle/magazine_fed/crackrifle
	name = "\improper Azarak-96 crack rifle"
	desc = "A heavy bolt-action rifle of Moghesian manufacture."
	desc_extended = "Manufactured by the Azarak Kingdom in 2350, the Azarak-96 'Crack Rifle' is a bolt-action rifle of Moghesian manufacture, easily recognizable by its long bayonet and large magazine wrapped around its trigger guard.\
	This heavy but powerful weapon is mostly known for its use by the common warrior of the Traditionalist Coalition during the Contact War.\
	Many of these rifles survived the ravages of the Contact War, a testament to their reliability."
	icon = 'icons/obj/guns/faction/izweski_hegemony/unathi_ballistics.dmi'
	icon_state = "crackrifle"
	item_state = "crackrifle"
	caliber = "5.8mm"
	magazine_type = /obj/item/ammo_magazine/crackrifle
	allowed_magazines = list(/obj/item/ammo_magazine/crackrifle)
	load_method = MAGAZINE

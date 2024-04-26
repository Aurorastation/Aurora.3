/obj/item/gun/projectile/shotgun/pump/rifle
	name = "bolt action rifle"
	desc = "A cheap ballistic rifle, often found in the hands of Tajaran conscripts."
	icon = 'icons/obj/guns/moistnugget.dmi'
	icon_state = "moistnugget"
	item_state = "moistnugget"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	fire_sound = 'sound/weapons/gunshot/gunshot_rifle.ogg'
	caliber = "a762"
	ammo_type = /obj/item/ammo_casing/a762
	magazine_type = /obj/item/ammo_magazine/boltaction
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
	ammo_type = /obj/item/ammo_casing/a762/blank

/obj/item/gun/projectile/shotgun/pump/rifle/scope
	name = "sniper bolt action rifle"
	desc = "A cheap ballistic rifle, often found in the hands of Tajaran conscripts. This one has a telescopic sight attached to it."
	icon = 'icons/obj/guns/bolt_scope.dmi'

/obj/item/gun/projectile/shotgun/pump/rifle/scope/verb/scope()
	set category = "Object"
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
	w_class = ITEMSIZE_NORMAL
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
	to_chat(user, "<span class='warning'>You shorten the barrel and stock of the rifle!</span>")

/obj/item/gun/projectile/shotgun/pump/rifle/obrez
	name = "sawn-off bolt action rifle"
	desc = "A shortened bolt action rifle, not really accurate."
	icon = 'icons/obj/guns/obrez.dmi'
	icon_state = "obrez"
	item_state = "obrez"
	w_class = ITEMSIZE_NORMAL
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

/obj/item/gun/projectile/shotgun/pump/rifle/magazine_fed/pipegun/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
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
	name = "dominian sniper rifle"
	desc = "A precision rifle used by snipers and sharpshooters of the Imperial Army. One of the few modern military-grade weapons to use a bolt for its action."
	desc_extended = "The MPMR-08/2 is a precisely machined and meticulously designed rifle which prioritizes accuracy and precision over rate of fire. \
	Outside of the Imperial Army, it is commonly seen in the hands of competition shooters."
	icon = 'icons/obj/guns/dominia_bolt_action.dmi'
	icon_state = "dom_bolt_action"
	item_state = "dom_bolt_action"
	caliber = "a762"
	ammo_type = /obj/item/ammo_casing/a762
	magazine_type = /obj/item/ammo_magazine/boltaction
	load_method = SPEEDLOADER

/obj/item/gun/projectile/shotgun/pump/rifle/dominia/verb/scope()
	set category = "Object"
	set name = "Use Scope"
	set src in usr

	if(wielded)
		toggle_scope(2.0, usr)
	else
		to_chat(usr, "<span class='warning'>You can't look through the scope without stabilizing the rifle!</span>")

/obj/item/gun/projectile/contender
	name = "pocket rifle"
	desc = "A perfect, pristine replica of an ancient one-shot hand-cannon. This one has been modified to work almost like a bolt-action."
	icon = 'icons/obj/guns/pockrifle.dmi'
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
		to_chat(user, "<span class='warning'>You can't fire \the [src] while the bolt is open!</span>")
		return 0
	return ..()

/obj/item/gun/projectile/contender/unique_action(mob/user as mob)
	if(chambered)
		chambered.forceMove(get_turf(src))
		chambered = null
		var/obj/item/ammo_casing/C = loaded[1]
		loaded -= C

	if(!retracted_bolt)
		to_chat(user, "<span class='notice'>You cycle back the bolt on \the [src], ejecting the casing and allowing you to reload.</span>")
		playsound(user, 'sound/weapons/riflebolt.ogg', 60, 1)
		icon_state = icon_retracted
		item_state = icon_retracted
		retracted_bolt = 1
		user.update_inv_l_hand()
		user.update_inv_r_hand()
		return 1

	else if(retracted_bolt && loaded.len)
		to_chat(user, "<span class='notice'>You cycle the loaded round into the chamber, allowing you to fire.</span>")

	else
		to_chat(user, "<span class='notice'>You cycle the bolt back into position, leaving the gun empty.</span>")

	icon_state = initial(icon_state)
	item_state = initial(item_state)

	user.update_inv_l_hand()
	user.update_inv_r_hand()

	retracted_bolt = 0

/obj/item/gun/projectile/contender/load_ammo(var/obj/item/A, mob/user)
	if(!retracted_bolt)
		to_chat(user, "<span class='notice'>You can't load \the [src] without cycling the bolt.</span>")
		return
	..()

/obj/item/gun/projectile/contender/unload_ammo(mob/user, var/allow_dump=1)
	if(!retracted_bolt)
		to_chat(user, "<span class='notice'>You can't unload \the [src] without cycling the bolt.</span>")
		return
	..()

/obj/item/gun/projectile/shotgun/pump/rifle/vintage
	name = "vintage bolt action rifle"
	desc = "An extremely old-looking rifle. Words you can't read are stamped on the gun. Doesn't look like it'll take any modern rounds."
	icon = 'icons/obj/guns/springfield.dmi'
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
		return
	else
		if(open_bolt && has_clip)
			if(has_clip.stored_ammo.len > 0)
				load_ammo(has_clip, user)
				src.cut_overlays()
				if(!has_clip.stored_ammo.len)
					add_overlay("springfield-clip-empty")
				else if(has_clip.stored_ammo.len <= 3)
					add_overlay("springfield-clip-half")
				else
					add_overlay("springfield-clip-full")
			else
				to_chat(user, "<span class='warning'>There is no ammo in \the [has_clip.name]!</span>")
		else if(!open_bolt)
			to_chat(user, "<span class='warning'>The bolt on \the [src.name] is closed!</span>")
		else
			to_chat(user, "<span class='warning'>There is no clip in \the [src.name]!</span>")

/obj/item/gun/projectile/shotgun/pump/rifle/vintage/pump(mob/M as mob)
	if(!wielded)
		to_chat(M, "<span class='warning'>You cannot work \the [src]'s bolt without gripping it with both hands!</span>")
		return
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
		cut_overlays()


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
			to_chat(user, "<span class='notice'>You need to open the bolt of \the [src] first.</span>")
			return
		if(!has_clip)
			user.drop_from_inventory(attacking_item, src)
			has_clip = attacking_item
			to_chat(user, "<span class='notice'>You load the clip into \the [src].</span>")
			if(!has_clip.stored_ammo.len)
				add_overlay("springfield-clip-empty")
			else if(has_clip.stored_ammo.len <= 3)
				add_overlay("springfield-clip-half")
			else
				add_overlay("springfield-clip-full")
		else
			to_chat(user, "<span class='notice'>There's already a clip in \the [src].</span>")

	else
		..()

/obj/item/gun/projectile/shotgun/pump/rifle/vintage/load_ammo(var/obj/item/A, mob/user)
	if(!open_bolt)
		to_chat(user, "<span class='warning'>The bolt is closed on \the [src]!</span>")
		return
	..()

/obj/item/gun/projectile/shotgun/pump/rifle/vintage/Fire(atom/target, mob/living/user, clickparams, pointblank=0, reflex=0)
	if(open_bolt)
		to_chat(user, "<span class='warning'>The bolt is open on \the [src]!</span>")
		return
	..()

/obj/item/gun/projectile/gauss
	name = "gauss thumper"
	desc = "An outdated gauss weapon which sees sparing use in modern times."
	w_class = ITEMSIZE_NORMAL
	slot_flags = 0
	magazine_type = /obj/item/ammo_magazine/gauss
	allowed_magazines = list(/obj/item/ammo_magazine/gauss)
	icon = 'icons/obj/guns/gauss_thumper.dmi'
	icon_state = "gauss_thumper"
	item_state = "gauss_thumper"
	caliber = "gauss"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	fire_sound = /singleton/sound_category/gauss_fire_sound
	load_method = MAGAZINE
	handle_casings = DELETE_CASINGS

	force = 15
	slot_flags = SLOT_BACK
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
	icon = 'icons/obj/guns/gauss_thumper.dmi'
	icon_state = "gauss_thumper"
	fire_sound = /singleton/sound_category/gauss_fire_sound
	fire_delay = ROF_UNWIELDY
	charge_meter = 0
	max_shots = 3
	charge_cost = 500
	projectile_type = /obj/item/projectile/bullet/gauss/highex
	self_recharge = 1
	use_external_power = 1
	recharge_time = 12
	needspin = FALSE

/obj/item/gun/projectile/gauss/carbine
	name = "gauss carbine"
	desc = "A simple gun utilizing the gauss technology. It is still reliable and cheap despite being outdated."
	icon = 'icons/obj/guns/gauss_carbine.dmi'
	icon_state = "gauss_carbine"
	item_state = "gauss_carbine"
	w_class = ITEMSIZE_LARGE
	slot_flags = SLOT_BACK
	ammo_type = /obj/item/ammo_casing/gauss/carbine
	load_method = SINGLE_CASING
	handle_casings = HOLD_CASINGS
	max_shells = 1

	fire_delay_wielded = ROF_INTERMEDIATE
	accuracy_wielded = 1

/obj/item/gun/projectile/gauss/carbine/update_icon()
	..()
	if(loaded.len)
		icon_state = "gauss_carbine"
	else
		icon_state = "gauss_carbine-e"

/obj/item/gun/projectile/gauss/carbine/special_check(mob/user)
	if(!wielded)
		to_chat(user, SPAN_WARNING("You can't fire without stabilizing \the [src]!"))
		return 0
	return ..()

/obj/item/gun/projectile/shotgun/pump/lever_action
	name = "lever action rifle"
	desc = "A lever action rifle with a side-loading port, these are still popular with frontiersmen for hunting and self-defense purposes."
	icon = 'icons/obj/guns/leveraction.dmi'
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
	name = "crack rifle"
	desc = "A heavy bolt-action rifle of Moghesian manufacture."
	desc_extended = "Manufactured by the Azarak Kingdom in 2350, the Azarak-96 'Crack Rifle' is a bolt-action rifle of Moghesian manufacture, easily recognizable by its long bayonet and large magazine wrapped around its trigger guard.\
	This heavy but powerful weapon is mostly known for its use by the common warrior of the Traditionalist Coalition during the Contact War.\
	Many of these rifles survived the ravages of the Contact War, a testament to their reliability."
	icon = 'icons/obj/guns/unathi_ballistics.dmi'
	icon_state = "crackrifle"
	item_state = "crackrifle"
	caliber = "5.8mm"
	magazine_type = /obj/item/ammo_magazine/crackrifle
	allowed_magazines = list(/obj/item/ammo_magazine/crackrifle)
	load_method = MAGAZINE

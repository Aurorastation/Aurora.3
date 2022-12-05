/obj/item/gun/projectile/shotgun/pump/rifle
	name = "bolt action rifle"
	desc = "A cheap ballistic rifle often found in the hands of Tajaran conscripts. Uses 7.62mm rounds."
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

	can_bayonet = TRUE
	knife_x_offset = 23
	knife_y_offset = 13
	can_sawoff = TRUE
	sawnoff_workmsg = "shorten the barrel and stock"

/obj/item/gun/projectile/shotgun/pump/rifle/blank
	desc = "A replica of a traditional adhomian bolt action rifle. It has the seal of the Grand Romanovich Casino on its stock. Uses 7.62mm rounds."
	ammo_type = /obj/item/ammo_casing/a762/blank

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
	desc = "A shortened bolt action rifle, not really acurate. Uses 7.62mm rounds."
	to_chat(user, "<span class='warning'>You shorten the barrel and stock of the rifle!</span>")

/obj/item/gun/projectile/shotgun/pump/rifle/obrez
	name = "sawn-off bolt action rifle"
	desc = "A shortened bolt action rifle, not really accurate. Uses 7.62mm rounds."
	icon = 'icons/obj/guns/obrez.dmi'
	icon_state = "obrez"
	item_state = "obrez"
	w_class = ITEMSIZE_NORMAL
	recoil = 2
	accuracy = -2
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	can_bayonet = FALSE

/obj/item/gun/projectile/shotgun/pump/rifle/pipegun
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

/obj/item/gun/projectile/shotgun/pump/rifle/pipegun/handle_pump_loading()
	if(ammo_magazine && length(ammo_magazine.stored_ammo))
		var/obj/item/ammo_casing/AC = ammo_magazine.stored_ammo[1] //load next casing.
		if(AC)
			AC.forceMove(src)
			ammo_magazine.stored_ammo -= AC
			chambered = AC

/obj/item/gun/projectile/shotgun/pump/rifle/pipegun/examine(mob/user)
	. = ..()
	switch(jam_chance)
		if(10 to 20)
			to_chat(user, SPAN_NOTICE("\The [src] is starting to accumulate fouling. Might want to grab a rag."))
		if(20 to 40)
			to_chat(user, SPAN_WARNING("\The [src] looks reasonably fouled up. Maybe you should clean it with a rag."))
		if(40 to 80)
			to_chat(user, SPAN_WARNING("\The [src] is starting to look quite gunked up. You should clean it with a rag."))
		if(80 to INFINITY)
			to_chat(user, SPAN_DANGER("\The [src] is completely fouled. You're going to be extremely lucky to get a shot off. Clean it with a rag."))

/obj/item/gun/projectile/shotgun/pump/rifle/pipegun/attackby(obj/item/A, mob/user)
	if(istype(A, /obj/item/reagent_containers/glass/rag))
		if(!jam_chance || jam_chance == initial(jam_chance))
			to_chat(user, SPAN_WARNING("There's no fouling present on \the [src]."))
			return
		user.visible_message("<b>[user]</b> starts cleaning \the [src] with \the [A].", SPAN_NOTICE("You start cleaning \the [src] with \the [A]."))
		if(do_after(user, jam_chance * 5))
			to_chat(user, SPAN_WARNING("You completely clean \the [src]."))
			jam_chance = initial(jam_chance)
		return
	return ..()

/obj/item/gun/projectile/shotgun/pump/rifle/pipegun/handle_post_fire(mob/user)
	. = ..()
	jam_chance = min(jam_chance + 5, 100)

/obj/item/gun/projectile/contender
	name = "pocket rifle"
	desc = "A perfect, pristine replica of an ancient one-shot hand-cannon. This one has been modified to work almost like a bolt-action. Uses 5.56mm rounds."
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
	caliber = "vintage"
	ammo_type = /obj/item/ammo_casing/vintage
	magazine_type = /obj/item/ammo_magazine/boltaction/vintage
	can_bayonet = TRUE
	var/open_bolt = 0
	var/obj/item/ammo_magazine/boltaction/vintage/has_clip

/obj/item/gun/projectile/shotgun/pump/rifle/vintage/unique_action(mob/living/user as mob)
	if(wielded)
		if(world.time >= recentpump + 10)
			pump(user)
			recentpump = world.time
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

/obj/item/gun/projectile/shotgun/pump/rifle/vintage/attackby(var/obj/item/A as obj, mob/user as mob)
	if(istype(A, /obj/item/ammo_magazine/boltaction/vintage))
		if(!open_bolt)
			to_chat(user, "<span class='notice'>You need to open the bolt of \the [src] first.</span>")
			return
		if(!has_clip)
			user.drop_from_inventory(A,src)
			has_clip = A
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
	fire_sound = /decl/sound_category/gauss_fire_sound
	load_method = MAGAZINE
	handle_casings = DELETE_CASINGS

	force = 10
	slot_flags = SLOT_BACK
	can_bayonet = TRUE
	knife_x_offset = 23
	knife_y_offset = 13

	fire_delay = 25
	accuracy = -1

	fire_delay_wielded = 10
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
	fire_sound = /decl/sound_category/gauss_fire_sound
	fire_delay = 30
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

	fire_delay_wielded = 20
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
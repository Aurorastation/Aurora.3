/obj/item/gun/projectile/shotgun/pump/rifle
	name = "bolt action rifle"
	desc = "A cheap ballistic rifle often found in the hands of crooks and frontiersmen. Uses 7.62mm rounds."
	icon = 'icons/obj/guns/moistnugget.dmi'
	icon_state = "moistnugget"
	item_state = "moistnugget"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	fire_sound = 'sound/weapons/gunshot/gunshot_rifle.ogg'
	caliber = "a762"
	ammo_type = /obj/item/ammo_casing/a762
	magazine_type = /obj/item/ammo_magazine/boltaction
	max_shells = 5

	pump_fail_msg = "<span class='warning'>You cannot work the rifle's bolt without gripping it with both hands!</span>"
	pump_snd = 'sound/weapons/riflebolt.ogg'
	has_wield_state = TRUE

	can_bayonet = TRUE
	knife_x_offset = 23
	knife_y_offset = 13
	can_sawoff = TRUE
	sawnoff_workmsg = "shorten the barrel and stock"

/obj/item/gun/projectile/shotgun/pump/rifle/saw_off(mob/user, obj/item/tool)
	icon = 'icons/obj/guns/obrez.dmi'
	icon_state = "obrez"
	item_state = "obrez"
	w_class = 3
	recoil = 2
	accuracy = -2
	slot_flags &= ~SLOT_BACK
	slot_flags |= (SLOT_BELT|SLOT_HOLSTER)
	can_bayonet = FALSE
	has_wield_state = FALSE
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
	w_class = 3
	recoil = 2
	accuracy = -2
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	can_bayonet = FALSE
	has_wield_state = FALSE

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

/obj/item/gun/projectile/contender/attack_self(mob/user as mob)
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

/obj/item/gun/projectile/shotgun/pump/rifle/vintage/attack_self(mob/living/user as mob)
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
		playsound(M, 'sound/weapons/riflebolt.ogg', 60, 1)
		update_icon()
		return
	open_bolt = 0
	icon_state = "springfield"
	playsound(M, 'sound/weapons/riflebolt.ogg', 60, 1)
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
	w_class = 3
	slot_flags = 0
	magazine_type = /obj/item/ammo_magazine/gauss
	allowed_magazines = list(/obj/item/ammo_magazine/gauss)
	icon = 'icons/obj/guns/gauss_thumper.dmi'
	icon_state = "gauss_thumper"
	item_state = "gauss_thumper"
	caliber = "gauss"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	fire_sound = 'sound/weapons/railgun.ogg'
	load_method = MAGAZINE
	handle_casings = DELETE_CASINGS

	fire_delay = 25
	accuracy = -1

	fire_delay_wielded = 10
	accuracy_wielded = 2

	is_wieldable = TRUE

/obj/item/gun/projectile/gauss/update_icon()
	..()
	icon_state = (ammo_magazine)? "gauss_thumper" : "gauss_thumper-e"

	if(wielded)
		item_state = "gauss_thumper-wielded"
	else
		item_state = "gauss_thumper"

	update_held_icon()
	return

/obj/item/gun/energy/gauss/mounted/mech
	name = "heavy gauss cannon"
	desc = "An outdated and power hungry gauss cannon, modified to deliver high explosive rounds at high velocities."
	icon = 'icons/obj/guns/gauss_thumper.dmi'
	icon_state = "gauss_thumper"
	fire_sound = 'sound/weapons/railgun.ogg'
	fire_delay = 30
	charge_meter = 0
	max_shots = 3
	charge_cost = 500
	projectile_type = /obj/item/projectile/bullet/gauss/highex
	self_recharge = 1
	use_external_power = 1
	recharge_time = 12
	needspin = FALSE
/obj/item/weapon/gun/projectile/shotgun/pump/rifle
	name = "bolt action rifle"
	desc = "A cheap ballistic rifle often found in the hands of crooks and frontiersmen. Uses 7.62mm rounds."
	icon_state = "moistnugget"
	item_state = "moistnugget"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	fire_sound = 'sound/weapons/rifleshot.ogg'
	caliber = "a762"
	ammo_type = /obj/item/ammo_casing/a762
	max_shells = 5

	pump_fail_msg = "<span class='warning'>You cannot work the rifle's bolt without gripping it with both hands!</span>"
	pump_snd = 'sound/weapons/riflebolt.ogg'
	has_wield_state = FALSE

	can_bayonet = TRUE
	knife_x_offset = 23
	knife_y_offset = 13
	can_sawoff = TRUE
	sawnoff_workmsg = "shorten the barrel and stock"

	action_button_name = "Wield rifle"

/obj/item/weapon/gun/projectile/shotgun/pump/rifle/saw_off(mob/user, obj/item/tool)
	icon_state = "obrez"
	w_class = 3
	recoil = 2
	accuracy = -2
	item_state = "obrez"
	slot_flags &= ~SLOT_BACK
	slot_flags |= (SLOT_BELT|SLOT_HOLSTER)
	can_bayonet = FALSE
	if(bayonet)
		qdel(bayonet)
		bayonet = null
		update_icon()
	name = "obrez"
	desc = "A shortened bolt action rifle, not really acurate. Uses 7.62mm rounds."
	to_chat(user, "<span class='warning'>You shorten the barrel and stock of the rifle!</span>")

/obj/item/weapon/gun/projectile/shotgun/pump/rifle/obrez
	name = "obrez"
	desc = "A shortened bolt action rifle, not really accurate. Uses 7.62mm rounds."
	icon_state = "obrez"
	item_state = "obrez"
	w_class = 3
	recoil = 2
	accuracy = -2
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	can_bayonet = FALSE

/obj/item/weapon/gun/projectile/contender
	name = "pocket rifle"
	desc = "A perfect, pristine replica of an ancient one-shot hand-cannon. This one has been modified to work almost like a bolt-action. Uses 5.56mm rounds."
	icon_state = "pockrifle"
	item_state = "obrez"
	caliber = "a556"
	handle_casings = HOLD_CASINGS
	max_shells = 1
	ammo_type = /obj/item/ammo_casing/a556
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	load_method = SINGLE_CASING
	fire_sound = 'sound/weapons/gunshot3.ogg'
	var/retracted_bolt = 0
	var/icon_retracted = "pockrifle-empty"

/obj/item/weapon/gun/projectile/contender/special_check(mob/user)
	if(retracted_bolt)
		user << "<span class='warning'>You can't fire \the [src] while the bolt is open!</span>"
		return 0
	return ..()

/obj/item/weapon/gun/projectile/contender/attack_self(mob/user as mob)
	if(chambered)
		chambered.forceMove(get_turf(src))
		chambered = null
		var/obj/item/ammo_casing/C = loaded[1]
		loaded -= C

	if(!retracted_bolt)
		to_chat(user, "<span class='notice'>You cycle back the bolt on \the [src], ejecting the casing and allowing you to reload.</span>")
		playsound(user, 'sound/weapons/riflebolt.ogg', 60, 1)
		icon_state = icon_retracted
		retracted_bolt = 1
		return 1

	else if(retracted_bolt && loaded.len)
		to_chat(user, "<span class='notice'>You cycle the loaded round into the chamber, allowing you to fire.</span>")

	else
		to_chat(user, "<span class='notice'>You cycle the bolt back into position, leaving the gun empty.</span>")

	icon_state = initial(icon_state)
	retracted_bolt = 0

/obj/item/weapon/gun/projectile/contender/load_ammo(var/obj/item/A, mob/user)
	if(!retracted_bolt)
		to_chat(user, "<span class='notice'>You can't load \the [src] without cycling the bolt.</span>")
		return
	..()

/obj/item/weapon/gun/projectile/contender/unload_ammo(mob/user, var/allow_dump=1)
	if(!retracted_bolt)
		to_chat(user, "<span class='notice'>You can't unload \the [src] without cycling the bolt.</span>")
		return
	..()

/obj/item/weapon/gun/projectile/shotgun/pump/rifle/vintage
	name = "\improper vintage bolt action rifle"
	desc = "An extremely old-looking rifle. Words you can't read are stamped on the gun. Doesn't look like it'll take any modern rounds."
	icon_state = "springfield"
	icon_state = "springfield"
	origin_tech = list(TECH_COMBAT = 1, TECH_MATERIAL = 3)
	fire_sound = 'sound/weapons/rifleshot.ogg'
	slot_flags = SLOT_BACK
	load_method = SINGLE_CASING|SPEEDLOADER
	handle_casings = HOLD_CASINGS
	caliber = "vintage"
	ammo_type = /obj/item/ammo_casing/vintage
	can_bayonet = TRUE
	var/open_bolt = 0
	var/obj/item/ammo_magazine/boltaction/vintage/has_clip

/obj/item/weapon/gun/projectile/shotgun/pump/rifle/vintage/attack_self(mob/living/user as mob)
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
				user << "<span class='warning'>There is no ammo in \the [has_clip.name]!</span>"
		else if(!open_bolt)
			user << "<span class='warning'>The bolt on \the [src.name] is closed!</span>"
		else
			user << "<span class='warning'>There is no clip in \the [src.name]!</span>"

/obj/item/weapon/gun/projectile/shotgun/pump/rifle/vintage/pump(mob/M as mob)
	if(!wielded)
		M << "<span class='warning'>You cannot work \the [src]'s bolt without gripping it with both hands!</span>"
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

/obj/item/weapon/gun/projectile/shotgun/pump/rifle/vintage/attackby(var/obj/item/A as obj, mob/user as mob)
	if(istype(A, /obj/item/ammo_magazine/boltaction/vintage))
		if(!open_bolt)
			user << "<span class='notice'>You need to open the bolt of \the [src] first.</span>"
			return
		if(!has_clip)
			user.drop_from_inventory(A,src)
			has_clip = A
			user << "<span class='notice'>You load the clip into \the [src].</span>"
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

/obj/item/weapon/gun/projectile/shotgun/pump/rifle/vintage/load_ammo(var/obj/item/A, mob/user)
	if(!open_bolt)
		user << "<span class='warning'>The bolt is closed on \the [src]!</span>"
		return
	..()

/obj/item/weapon/gun/projectile/shotgun/pump/rifle/vintage/Fire(atom/target, mob/living/user, clickparams, pointblank=0, reflex=0)
	if(open_bolt)
		user << "<span class='warning'>The bolt is open on \the [src]!</span>"
		return
	..()

/obj/item/weapon/gun/projectile/gauss
	name = "gauss thumper"
	desc = "An outdated gauss weapon which sees sparing use in modern times. It's covered in the colors of the Tau Ceti Foreign Legion."
	w_class = 3
	slot_flags = 0
	magazine_type = /obj/item/ammo_magazine/gauss
	allowed_magazines = list(/obj/item/ammo_magazine/gauss)
	icon_state = "gauss_thumper"
	caliber = "gauss"
	accuracy = 1
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	fire_sound = 'sound/weapons/railgun.ogg'
	load_method = MAGAZINE
	handle_casings = DELETE_CASINGS

	fire_delay = 25
	accuracy = -1

	fire_delay_wielded = 10
	accuracy_wielded = 2

	action_button_name = "Wield rifle"

/obj/item/weapon/gun/projectile/gauss/update_icon()
	..()
	icon_state = (ammo_magazine)? "gauss_thumper" : "gauss_thumper-e"

	if(wielded)
		item_state = "gauss_thumper-wielded"
	else
		item_state = "gauss_thumper"

	update_held_icon()
	return

/obj/item/weapon/gun/projectile/gauss/can_wield()
	return 1

/obj/item/weapon/gun/projectile/gauss/ui_action_click()
	if(src in usr)
		toggle_wield(usr)

/obj/item/weapon/gun/projectile/gauss/verb/wield_rifle()
	set name = "Wield rifle"
	set category = "Object"
	set src in usr

	toggle_wield(usr)
	usr.update_icon()

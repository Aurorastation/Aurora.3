/obj/item/gun/projectile/heavysniper
	name = "anti-materiel rifle"
	desc = "The PTR-7 is man-portable anti-armor rifle fitted with a high-powered scope, capable of penetrating through most windows, airlocks, and non-reinforced walls with ease. Fires armor piercing 14.5mm shells."
	desc_info = "A single-shot, bolt-action anachronism in an age of energy weapons, the PTR-7 was originally developed to combat exosuits, either by disabling critical systems \
	or killing the pilot. Firing a high-velocity 14.5mm cartridge designed to defeat heavy armor, the PTR-7 boasts penetrative power unmatched by most in its class, though recent advancements \
	in composites have rendered the weapon less effective at its intended purpose. Nonetheless, it still sees use among some groups as a general-purpose anti-materiel rifle."
	icon = 'icons/obj/guns/heavysniper.dmi'
	icon_state = "heavysniper"
	item_state = "heavysniper"
	w_class = ITEMSIZE_LARGE
	force = 10
	slot_flags = SLOT_BACK
	origin_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 2, TECH_ILLEGAL = 8)
	caliber = "14.5mm"
	recoil = 4 //extra kickback
	handle_casings = HOLD_CASINGS
	load_method = SINGLE_CASING
	max_shells = 1
	ammo_type = /obj/item/ammo_casing/a145
	//+2 accuracy over the LWAP because only one shot
	accuracy = -3
	offhand_accuracy = -1
	scoped_accuracy = 4
	var/bolt_open = 0
	var/has_scope = TRUE

	is_wieldable = TRUE

	fire_sound = 'sound/weapons/gunshot/gunshot_dmr.ogg'

	recoil_wielded = 2
	accuracy_wielded = -1

/obj/item/gun/projectile/heavysniper/get_ammo()
	var/ammo_count = 0
	for(var/thing in loaded)
		var/obj/item/ammo_casing/AC = thing
		if(AC.BB) // my favourite band - geeves
			ammo_count++
	return ammo_count

/obj/item/gun/projectile/heavysniper/update_icon()
	..()
	if(bolt_open)
		icon_state = "heavysniper-open"
	else
		icon_state = "heavysniper"

/obj/item/gun/projectile/heavysniper/unique_action(mob/user as mob)
	bolt_open = !bolt_open
	if(bolt_open)
		playsound(src.loc, 'sound/weapons/blade_open.ogg', 50, 1)
		if(chambered)
			to_chat(user, "<span class='notice'>You work the bolt open, ejecting [chambered]!</span>")
			chambered.forceMove(get_turf(src))
			loaded -= chambered
			chambered = null
		else
			to_chat(user, "<span class='notice'>You work the bolt open.</span>")
	else
		to_chat(user, "<span class='notice'>You work the bolt closed.</span>")
		playsound(src.loc, 'sound/weapons/blade_close.ogg', 50, 1)
		bolt_open = 0
	add_fingerprint(user)
	update_icon()

/obj/item/gun/projectile/heavysniper/special_check(mob/user)
	if(bolt_open)
		to_chat(user, "<span class='warning'>You can't fire [src] while the bolt is open!</span>")
		return 0
	if(!wielded)
		to_chat(user, "<span class='warning'>You can't fire without stabilizing the rifle!</span>")
		return 0
	return ..()

/obj/item/gun/projectile/heavysniper/load_ammo(var/obj/item/A, mob/user)
	if(!bolt_open)
		return
	..()

/obj/item/gun/projectile/heavysniper/unload_ammo(mob/user, var/allow_dump=1)
	if(!bolt_open)
		return
	..()

/obj/item/gun/projectile/heavysniper/verb/scope()
	set category = "Object"
	set name = "Use Scope"
	set popup_menu = 1

	if(!has_scope)
		to_chat(usr, SPAN_WARNING("\The [src] doesn't have a scope!"))
		return

	if(wielded)
		toggle_scope(2.0, usr)
	else
		to_chat(usr, "<span class='warning'>You can't look through the scope without stabilizing the rifle!</span>")

/obj/item/gun/projectile/heavysniper/unathi
	name = "hegemony slugger"
	desc = "An incredibly large firearm, produced by an Ouerean Guild. Uses custom slugger rounds."
	icon = 'icons/obj/guns/unathi_slugger.dmi'
	icon_state = "slugger"
	item_state = "slugger"
	origin_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 2, TECH_ILLEGAL = 4)
	w_class = ITEMSIZE_HUGE
	fire_sound = 'sound/effects/Explosion1.ogg'
	caliber = "slugger"
	ammo_type = /obj/item/ammo_casing/slugger
	magazine_type = null
	has_scope = FALSE

/obj/item/gun/projectile/heavysniper/unathi/update_icon()
	..()
	if(bolt_open && length(loaded))
		icon_state = "slugger-open-loaded"
	else if(bolt_open && !length(loaded))
		icon_state = "slugger-open"
	else
		icon_state = "slugger"

/obj/item/gun/projectile/heavysniper/unathi/handle_post_fire(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/has_online_rig = H.wearing_rig && !H.wearing_rig.offline
		if(H.mob_size < 10 && !has_online_rig) // smaller than an unathi
			H.visible_message(SPAN_WARNING("\The [src] goes flying out of \the [H]'s hand!"), SPAN_WARNING("\The [src] flies out of your hand!"))
			H.drop_item(src)
			src.throw_at(get_edge_target_turf(src, reverse_dir[H.dir]), 3, 3)

			var/obj/item/organ/external/LH = H.get_organ(BP_L_HAND)
			var/obj/item/organ/external/RH = H.get_organ(BP_R_HAND)
			var/active_hand = H.hand

			if(active_hand)
				LH.take_damage(30)
			else
				RH.take_damage(30)

/obj/item/gun/projectile/heavysniper/tranq
	name = "tranquilizer rifle"
	desc = "A nonlethal modification to the PTR-7 anti-materiel rifle meant for sedation and capture of the most dangerous of game. Fires .50 cal PPS shells that deploy a torpor inducing drug payload."
	icon = 'icons/obj/guns/tranqsniper.dmi'
	icon_state = "tranqsniper"
	item_state = "tranqsniper"
	w_class = ITEMSIZE_LARGE
	force = 10
	slot_flags = SLOT_BACK
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 2)
	caliber = "PPS"
	recoil = 1
	silenced = 1
	fire_sound = 'sound/weapons/gunshot/gunshot_light.ogg'
	max_shells = 4
	ammo_type = null
	accuracy = -3
	scoped_accuracy = 4
	bolt_open = 0
	muzzle_flash = 1

	recoil_wielded = 1
	accuracy_wielded = 2

/obj/item/gun/projectile/heavysniper/tranq/update_icon()
	..()
	if(bolt_open)
		icon_state = "tranqsniper-open"
	else
		icon_state = "tranqsniper"

/obj/item/gun/projectile/dragunov
	name = "marksman rifle"
	desc = "A semi-automatic marksman rifle. Uses 7.62mm rounds."
	icon = 'icons/obj/guns/dragunov.dmi'
	icon_state = "dragunov"
	item_state = "dragunov"

	desc_fluff = "The Ho'taki Marksman Rifle was created by the Shastar Technical University, created through the reverse engineering of captured Tsarrayut'yan rifle. \
	The rifle is commonly issued to the feared Das'nrra Marksmen."

	w_class = ITEMSIZE_LARGE
	force = 10
	slot_flags = SLOT_BACK
	origin_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 3, TECH_MAGNET = 2, TECH_ILLEGAL = 5)
	caliber = "a762"
	recoil = 2
	fire_sound = 'sound/weapons/gunshot/gunshot_svd.ogg'
	load_method = MAGAZINE
	max_shells = 10

	magazine_type = /obj/item/ammo_magazine/d762
	allowed_magazines = list(/obj/item/ammo_magazine/d762)

	accuracy = -4
	scoped_accuracy = 3

	is_wieldable = TRUE

	recoil_wielded = 1
	accuracy_wielded = 1

/obj/item/gun/projectile/dragunov/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "dragunov"
	else
		icon_state = "dragunov-empty"

/obj/item/gun/projectile/dragunov/special_check(mob/user)
	if(!wielded)
		to_chat(user, "<span class='warning'>You can't fire without stabilizing the rifle!</span>")
		return 0
	return ..()

/obj/item/gun/projectile/dragunov/verb/scope()
	set category = "Object"
	set name = "Use Scope"
	set popup_menu = 1

	if(wielded)
		toggle_scope(2.0, usr)
	else
		to_chat(usr, "<span class='warning'>You can't look through the scope without stabilizing the rifle!</span>")

/obj/item/gun/projectile/automatic/rifle/w556
	name = "scout rifle"
	desc = "The ZI Pointer, the designated marksman rifle variant of Zavodskoi's ZI Bulldog carbine. \
	Features a longer, heavier barrel and low-power fixed-magnification optic in lieu of the grenade launcher. \
	A vertical grip has been attached under the forend to help offset the change in balance and improve handling. Uses 5.56mm rounds."
	icon = 'icons/obj/guns/w556.dmi'
	icon_state = "w556rifle"
	item_state = "w556rifle"
	w_class = ITEMSIZE_LARGE
	force = 10
	slot_flags = SLOT_BACK
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 3)
	caliber = "a556"
	recoil = 4
	load_method = MAGAZINE
	fire_sound = 'sound/weapons/gunshot/gunshot_dmr.ogg'
	max_shells = 10
	ammo_type = /obj/item/ammo_casing/a556/ap
	magazine_type = /obj/item/ammo_magazine/a556/ap
	allowed_magazines = list(/obj/item/ammo_magazine/a556, /obj/item/ammo_magazine/a556/ap)
	accuracy = -4
	scoped_accuracy = 3
	recoil_wielded = 2
	accuracy_wielded = 1
	multi_aim = 0 //Definitely a fuck no. Being able to target one person at this range is plenty.
	auto_eject = 1
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'

	firemodes = list(
		list(mode_name="semiauto", burst=1, fire_delay=0, fire_delay_wielded=0),
		list(mode_name="2-round bursts", burst=2, burst_accuracy=list(0,-1,-1), dispersion=list(0, 8))
		)

/obj/item/gun/projectile/automatic/rifle/w556/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "w556rifle"
	else
		icon_state = "w556rifle-empty"

/obj/item/gun/projectile/automatic/rifle/w556/verb/scope()
	set category = "Object"
	set name = "Use Scope"
	set popup_menu = 1

	if(wielded)
		toggle_scope(2.0, usr)
	else
		to_chat(usr, "<span class='warning'>You can't look through the scope without stabilizing the rifle!</span>")

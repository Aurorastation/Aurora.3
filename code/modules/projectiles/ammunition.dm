/obj/item/ammo_casing
	name = "bullet casing"
	desc = "A bullet casing."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "s-casing"
	randpixel = 10
	obj_flags = OBJ_FLAG_CONDUCTABLE
	slot_flags = SLOT_BELT | SLOT_EARS
	throwforce = 1
	layer = BELOW_TABLE_LAYER
	w_class = WEIGHT_CLASS_TINY

	var/leaves_residue = 1
	var/caliber = ""					//Which kind of guns it can be loaded into
	var/max_stack = 5					// how many of us can fit in a pile
	var/projectile_type					//The bullet type to create when New() is called
	var/obj/projectile/BB = null	//The loaded bullet - make it so that the projectiles are created only when needed?
	var/spent_icon = "s-casing-spent"

	drop_sound = /singleton/sound_category/casing_drop_sound
	pickup_sound = 'sound/items/pickup/ring.ogg'
	var/reload_sound = 'sound/weapons/reload_bullet.ogg' //sound that plays when inserted into gun.

/obj/item/ammo_casing/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if (!BB)
		. += "This one is spent."

/obj/item/ammo_casing/Initialize()
	. = ..()
	if(ispath(projectile_type))
		BB = new projectile_type(src)
	else
		expend() // allows spawning spent casings by nulling projectile_type
	randpixel_xy()
	transform = turn(transform,rand(0,360))

/obj/item/ammo_casing/Destroy()
	QDEL_NULL(BB)
	. = ..()

//removes the projectile from the ammo casing
/obj/item/ammo_casing/proc/expend()
	. = BB
	BB = null
	set_dir(pick(GLOB.alldirs)) //spin spent casings
	update_icon()

/obj/item/ammo_casing/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.isscrewdriver())
		if(!BB)
			to_chat(user, SPAN_NOTICE("There is no bullet in the casing to inscribe anything into."))
			return

		var/tmp_label = ""
		var/label_text = sanitizeSafe( tgui_input_text(user, "Inscribe some text into \the [initial(BB.name)]", "Inscription", tmp_label, MAX_NAME_LEN), MAX_NAME_LEN )
		if(length(label_text) > 20)
			to_chat(user, SPAN_WARNING("The inscription can be at most 20 characters long."))
		else if(!label_text)
			to_chat(user, SPAN_NOTICE("You scratch the inscription off of [initial(BB)]."))
			BB.name = initial(BB.name)
		else
			to_chat(user, SPAN_NOTICE("You inscribe \"[label_text]\" into \the [initial(BB.name)]."))
			BB.name = "[initial(BB.name)] (\"[label_text]\")"
	else if(istype(attacking_item, /obj/item/ammo_casing))
		if(attacking_item.type != src.type)
			to_chat(user, SPAN_WARNING("Ammo of different types cannot stack!"))
			return
		if(max_stack == 1)
			to_chat(user, SPAN_WARNING("\The [src] cannot be stacked!"))
			return
		if(!src.BB)
			to_chat(user, SPAN_WARNING("That round is spent!"))
			return
		var/obj/item/ammo_casing/B = attacking_item
		if(!B.BB)
			to_chat(user, SPAN_WARNING("Your round is spent!"))
			return
		var/obj/item/ammo_pile/pile = new /obj/item/ammo_pile(get_turf(user), list(src, attacking_item))
		user.put_in_hands(pile)
	..()

/obj/item/ammo_casing/update_icon()
	if(spent_icon && !BB)
		icon_state = spent_icon

//Gun loading types
#define SINGLE_CASING 	1	//The gun only accepts ammo_casings. ammo_magazines should never have this as their mag_type.
#define SPEEDLOADER 	2	//Transfers casings from the mag to the gun when used.
#define MAGAZINE 		4	//The magazine item itself goes inside the gun

//An item that holds casings and can be used to put them inside guns
/obj/item/ammo_magazine
	name = "magazine"
	desc = "A magazine for some kind of gun."
	icon_state = "357"
	icon = 'icons/obj/ammo.dmi'
	obj_flags = OBJ_FLAG_CONDUCTABLE
	slot_flags = SLOT_BELT
	item_state = "box"
	matter = list(DEFAULT_WALL_MATERIAL = 500)
	throwforce = 5
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 4
	throw_range = 10

	var/list/stored_ammo = list()
	var/mag_type = SPEEDLOADER //ammo_magazines can only be used with compatible guns. This is not a bitflag, the load_method var on guns is.
	var/caliber = "357"
	var/max_ammo = 7

	/// Ammo type that is initially loaded
	var/ammo_type = /obj/item/ammo_casing
	var/initial_ammo = null

	var/multiple_sprites = FALSE
	//because BYOND doesn't support numbers as keys in associative lists
	var/list/icon_keys = list()		//keys
	var/list/ammo_states = list()	//values

	/// sound item plays when it is inserted into a gun.
	var/insert_sound = /singleton/sound_category/metal_slide_reload
	/// sound item plays when it is ejected from a gun.
	var/eject_sound = 'sound/weapons/magazine_eject.ogg'

/obj/item/ammo_magazine/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "There [(stored_ammo.len == 1)? "is" : "are"] <b>[stored_ammo.len] round\s</b> left!"

/obj/item/ammo_magazine/Initialize()
	. = ..()
	if(multiple_sprites)
		initialize_magazine_icondata(src)

	if(isnull(initial_ammo))
		initial_ammo = max_ammo

	if(initial_ammo)
		for(var/i in 1 to initial_ammo)
			stored_ammo += new ammo_type(src)
	update_icon()

/obj/item/ammo_magazine/Destroy()
	QDEL_LIST(stored_ammo)
	. = ..()

/obj/item/ammo_magazine/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/ammo_casing))
		var/obj/item/ammo_casing/C = attacking_item
		if(C.caliber != caliber)
			to_chat(user, SPAN_WARNING("[C] does not fit into [src]."))
			return
		if(stored_ammo.len >= max_ammo)
			to_chat(user, SPAN_WARNING("[src] is full!"))
			return
		user.remove_from_mob(C)
		C.forceMove(src)
		stored_ammo.Insert(1, C) //add to the head of the list
		update_icon()
	else if(istype(attacking_item, /obj/item/gun) && ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.check_weapon_affinity(attacking_item)) // if we have gun-kata, we can reload by attacking a magazine
			attacking_item.attackby(src, user)

/obj/item/ammo_magazine/attack_self(mob/user)
	if(!stored_ammo.len)
		to_chat(user, SPAN_NOTICE("[src] is already empty!"))
		return
	to_chat(user, SPAN_NOTICE("You empty [src]."))
	for(var/obj/item/ammo_casing/C in stored_ammo)
		C.forceMove(user.loc)
		playsound(C, /singleton/sound_category/casing_drop_sound, 50, FALSE)
		C.set_dir(pick(GLOB.alldirs))
	stored_ammo.Cut()
	update_icon()

/obj/item/ammo_magazine/update_icon()
	if(multiple_sprites)
		//find the lowest key greater than or equal to stored_ammo.len
		var/new_state = null
		for(var/idx in 1 to icon_keys.len)
			var/ammo_count = icon_keys[idx]
			if (ammo_count >= stored_ammo.len)
				new_state = ammo_states[idx]
				break
		icon_state = (new_state)? new_state : initial(icon_state)
	if(!length(stored_ammo))
		recyclable = TRUE
	else
		recyclable = FALSE

//magazine icon state caching (caching lists are in SSicon_cache)

/proc/initialize_magazine_icondata(var/obj/item/ammo_magazine/M)
	var/list/magazine_icondata_keys = SSicon_cache.magazine_icondata_keys
	var/list/magazine_icondata_states = SSicon_cache.magazine_icondata_states

	var/typestr = "[M.type]"
	if(!(typestr in magazine_icondata_keys) || !(typestr in magazine_icondata_states))
		magazine_icondata_cache_add(M)

	M.icon_keys = magazine_icondata_keys[typestr]
	M.ammo_states = magazine_icondata_states[typestr]

/proc/magazine_icondata_cache_add(var/obj/item/ammo_magazine/M)
	var/list/magazine_icondata_keys = SSicon_cache.magazine_icondata_keys
	var/list/magazine_icondata_states = SSicon_cache.magazine_icondata_states

	var/list/icon_keys = list()
	var/list/ammo_states = list()
	var/list/states = icon_states(M.icon)
	for(var/i = 0, i <= M.max_ammo, i++)
		var/ammo_state = "[M.icon_state]-[i]"
		if(ammo_state in states)
			icon_keys += i
			ammo_states += ammo_state

	magazine_icondata_keys["[M.type]"] = icon_keys
	magazine_icondata_states["[M.type]"] = ammo_states

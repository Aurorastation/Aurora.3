/obj/item/gun/launcher/grenade
	name = "grenade launcher"
	desc = "A bulky pump-action grenade launcher. Holds up to 6 grenades in a revolving magazine."
	icon = 'icons/obj/contained_items/weapons/grenade_launcher.dmi'
	icon_state = "grenadelauncher"
	item_state = "grenadelauncher"
	contained_sprite = TRUE
	w_class = ITEMSIZE_LARGE
	slot_flags = SLOT_BACK
	force = 10

	fire_sound = 'sound/weapons/grenadelaunch.ogg'
	fire_sound_text = "a metallic thunk"
	recoil = 0
	throw_distance = 7
	release_force = 5

	var/obj/item/grenade/chambered
	var/list/grenades = new/list()
	var/max_grenades = 1
	var/blacklisted_grenades = list()
	matter = list(DEFAULT_WALL_MATERIAL = 2000)

/obj/item/gun/launcher/grenade/attackby(obj/item/I, mob/user)
	if((istype(I, /obj/item/grenade)))
		load(I, user)
	else
		..()

/obj/item/gun/launcher/grenade/attack_hand(mob/user)
	if(user.get_inactive_hand() == src)
		unload(user)
	else
		..()

/obj/item/gun/launcher/grenade/consume_next_projectile()
	if(chambered)
		chambered.det_time = 10
		chambered.activate(null)
	return chambered

/obj/item/gun/launcher/grenade/handle_post_fire(mob/user)
	message_admins("[key_name_admin(user)] fired a grenade ([chambered.name]) from a grenade launcher ([src.name]).")
	log_game("[key_name_admin(user)] used a grenade ([chambered.name]).",ckey=key_name(user))
	chambered = null
	update_maptext()

/obj/item/gun/launcher/grenade/get_ammo()
	return grenades.len + (chambered? 1 : 0)

/obj/item/gun/launcher/grenade/proc/can_load_grenade_type(obj/item/grenade/G, mob/user)
	if(is_type_in_list(G, blacklisted_grenades))
		to_chat(user, SPAN_WARNING("\The [G] doesn't seem to fit in \the [src]!"))
		return FALSE
	return TRUE

///////////////////// Different Grenade Launcher Types /////////////////////
/obj/item/gun/launcher/grenade/revolving
	name = "grenade launcher"
	desc = "A bulky pump-action grenade launcher. Holds up to 6 grenades in a revolving magazine."
	icon = 'icons/obj/contained_items/weapons/grenade_launcher.dmi'
	icon_state = "grenadelauncher"
	item_state = "grenadelauncher"
	contained_sprite = TRUE
	w_class = ITEMSIZE_LARGE
	slot_flags = SLOT_BACK
	force = 10
	max_grenades = 5
	needspin = FALSE

	fire_sound = 'sound/weapons/grenadelaunch.ogg'
	fire_sound_text = "a metallic thunk"
	recoil = 0
	throw_distance = 7
	release_force = 5
	blacklisted_grenades = list(
		/obj/item/grenade/flashbang/clusterbang,
		/obj/item/grenade/frag
		)

/obj/item/gun/launcher/grenade/examine(mob/user)
	. = ..()
	if(Adjacent(user))
		to_chat(user, SPAN_NOTICE("It has [get_ammo()] grenade\s remaining."))
		if(chambered)
			to_chat(user, SPAN_NOTICE("\A [chambered] is chambered."))

/obj/item/gun/launcher/grenade/proc/load(obj/item/grenade/G, mob/user)
	if(!can_load_grenade_type(G, user))
		return
	if(grenades.len >= max_grenades)
		to_chat(user, SPAN_WARNING("[src] is full."))
		return
	user.remove_from_mob(G)
	G.forceMove(src)
	grenades.Insert(1, G) //add to the head of the list, so that it is loaded on the next pump
	user.visible_message("[user] inserts \a [G] into [src].", SPAN_NOTICE("You insert \a [G] into [src]."))
	update_maptext()

/obj/item/gun/launcher/grenade/proc/unload(mob/user)
	if(grenades.len)
		var/obj/item/grenade/G = grenades[grenades.len]
		grenades.len--
		user.put_in_hands(G)
		user.visible_message("[user] removes \a [G] from [src].", SPAN_NOTICE("You remove \a [G] from [src]."))
	else
		to_chat(user, SPAN_WARNING("[src] is empty."))
	update_maptext()

/obj/item/gun/launcher/grenade/unique_action(mob/user)
	pump(user)

//revolves the magazine, allowing players to choose between multiple grenade types
/obj/item/gun/launcher/grenade/proc/pump(mob/M as mob)
	playsound(M, 'sound/weapons/reloads/shotgun_pump.ogg', 60, 1)

	var/obj/item/grenade/next
	if(grenades.len)
		next = grenades[1] //get this first, so that the chambered grenade can still be removed if the grenades list is empty
	if(chambered)
		grenades += chambered //rotate the revolving magazine
		chambered = null
	if(next)
		grenades -= next //Remove grenade from loaded list.
		chambered = next
		to_chat(M, SPAN_WARNING("You pump [src], loading \a [next] into the chamber."))
	else
		to_chat(M, SPAN_WARNING("You pump [src], but the magazine is empty."))
	update_icon()

/obj/item/gun/launcher/grenade/examine(mob/user)
	. = ..()
	if(Adjacent(user))
		to_chat(user, SPAN_NOTICE("It has [get_ammo()] grenade\s remaining."))
		if(chambered)
			to_chat(user, SPAN_NOTICE("\A [chambered] is chambered."))

/obj/item/gun/launcher/grenade/unique_action(mob/user)
	pump(user)

/obj/item/gun/launcher/grenade/attackby(obj/item/I, mob/user)
	if((istype(I, /obj/item/grenade)))
		load(I, user)
	else
		..()

/obj/item/gun/launcher/grenade/attack_hand(mob/user)
	if(user.get_inactive_hand() == src)
		unload(user)
	else
		..()

/obj/item/gun/launcher/grenade/consume_next_projectile()
	if(chambered)
		chambered.det_time = 10
		chambered.activate(null)
	return chambered

/obj/item/gun/launcher/grenade/handle_post_fire(mob/user)
	message_admins("[key_name_admin(user)] fired a grenade ([chambered.name]) from a grenade launcher ([src.name]).")
	log_game("[key_name_admin(user)] used a grenade ([chambered.name]).",ckey=key_name(user))
	chambered = null
	update_maptext()

/obj/item/gun/launcher/grenade/get_ammo()
	return grenades.len + (chambered? 1 : 0)

//Underslung grenade launcher to be used with the Z8
/obj/item/gun/launcher/grenade/underslung
	name = "underslung grenade launcher"
	desc = "Not much more than a tube and a firing mechanism, this grenade launcher is designed to be fitted to a rifle."
	w_class = ITEMSIZE_NORMAL
	force = 5
	max_grenades = 0

//load and unload directly into chambered
/obj/item/gun/launcher/grenade/underslung/load(obj/item/grenade/G, mob/user)
	if(chambered)
		to_chat(user, SPAN_WARNING("[src] is already loaded."))
		return
	user.remove_from_mob(G)
	G.forceMove(src)
	chambered = G
	user.visible_message("[user] load \a [G] into [src].", SPAN_NOTICE("You load \a [G] into [src]."))

/obj/item/gun/launcher/grenade/underslung/unload(mob/user)
	if(chambered)
		user.put_in_hands(chambered)
		user.visible_message("[user] removes \a [chambered] from [src].", SPAN_NOTICE("You remove \a [chambered] from [src]."))
		chambered = null
	else
		to_chat(user, SPAN_WARNING("[src] is empty."))

/obj/item/gun/launcher/grenade/break_action

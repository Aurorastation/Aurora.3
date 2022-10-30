/obj/item/gun/launcher/grenade
	name = "grenade launcher"
	desc = "The parent weapon of the ones that shoots grenades over a distance."
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

	var/ammo_type = null
	var/list/loaded = list()
	var/obj/item/grenade/chambered
	var/list/grenades = new/list()
	var/max_grenades = 1 // A single shot grenade launcher
	var/blacklisted_grenades = list()
	var/load_method
	matter = list(DEFAULT_WALL_MATERIAL = 2000)

/obj/item/gun/launcher/grenade/attackby(obj/item/I, mob/user) // Loading one grenade at a time
	if((istype(I, /obj/item/grenade)))
		load(I, user)
	else
		..()

/obj/item/gun/launcher/grenade/attack_hand(mob/user) // Removing one grenade at a time
	if(user.get_inactive_hand() == src)
		unload(user)
	else
		..()

/obj/item/gun/launcher/grenade/handle_post_fire(mob/user)
	message_admins("[key_name_admin(user)] fired a grenade ([chambered.name]) from a grenade launcher ([src.name]).") // Chat + admin output after firing
	log_game("[key_name_admin(user)] used a grenade ([chambered.name]).",ckey=key_name(user))
	chambered = null
	update_maptext()

/obj/item/gun/launcher/grenade/get_ammo() // Is there a grenade in the chamber?
	return grenades.len + (chambered? 1 : 0)

/obj/item/gun/launcher/grenade/proc/can_load_grenade_type(obj/item/grenade/G, mob/user) // This happens when you try to load a blacklisted grenade
	if(is_type_in_list(G, blacklisted_grenades))
		to_chat(user, SPAN_WARNING("\The [G] doesn't seem to fit in \the [src]!"))
		return FALSE
	return TRUE

///////////////////// Different Grenade Launcher Types /////////////////////
/obj/item/gun/launcher/grenade/revolving
	name = "riot grenade launcher"
	desc = "A bulky pump-action grenade launcher, made to pacify crowds. Holds up to 6 grenades in a revolving magazine."
	icon = 'icons/obj/contained_items/weapons/grenade_launcher.dmi'
	icon_state = "grenadelauncher"
	item_state = "grenadelauncher"
	contained_sprite = TRUE
	max_grenades = 5
	needspin = FALSE

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

/obj/item/gun/launcher/grenade/revolving/consume_next_projectile()
	if(chambered)
		chambered.det_time = 10
		chambered.activate(null)
	return chambered


/obj/item/gun/launcher/grenade/proc/unload(mob/user)
	if(grenades.len)
		var/obj/item/grenade/G = grenades[grenades.len]
		grenades.len--
		user.put_in_hands(G)
		user.visible_message("[user] removes \a [G] from [src].", SPAN_NOTICE("You remove \a [G] from [src]."))
	else
		to_chat(user, SPAN_WARNING("[src] is empty."))
	update_maptext()

/obj/item/gun/launcher/grenade/revolving/unique_action(mob/user)
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
	name = "break-action grenade launcher"
	desc = "A cheap, reliable weapon made out of wood and stamped metal. One barrel to shoot 40mm grenades."
	desc_fluff = "Made by Zavodskoi for decades now, the SSGL-40, short for \"Single Shot Grenade Launcher Caliber 40 Millimeters\", is a Frontier remake from Zavodskoi Interstellar, originally pioneered off of an early 20th century design for war. It's brutally simple and a little unoriginal, but deadly just the same."
	contained_sprite = TRUE
	load_method = SINGLE_CASING

	var/cover_open = 0

/obj/item/gun/launcher/grenade/break_action/proc/toggle_cover(mob/user)
	cover_open = !cover_open
	to_chat(user, SPAN_NOTICE("You [cover_open ? "open" : "close"] [src]'s breechface."))
	if(cover_open)
		playsound(user, 'sound/weapons/grenade_launcher/launcher_open.ogg', 60, 1)
	else
		playsound(user, 'sound/weapons/grenade_launcher/launcher_close.ogg', 60, 1)
	update_icon()

/obj/item/gun/launcher/grenade/break_action/special_check(mob/user)
	if(cover_open)
		to_chat(user, SPAN_WARNING("[src]'s breechface is open! Close it before firing!</span>"))
		return 0
	return ..()

/obj/item/gun/launcher/grenade/break_action/update_icon()
	icon_state = "l6[cover_open ? "open" : "closed"]]"
	..()

//Attempts to load A into src, depending on the type of thing being loaded and the load_method
//Maybe this should be broken up into separate procs for each load method?
/obj/item/gun/projectile/proc/load_ammo(var/obj/item/A, mob/user)
	if(istype(A, /obj/item/ammo_magazine))
		var/obj/item/ammo_magazine/AM = A
		if(!(load_method & AM.mag_type) || caliber != AM.caliber || (allowed_magazines && !is_type_in_list(A, allowed_magazines)))
			to_chat(user,"<span class='warning'>[AM] won't load into [src]!</span>")
			return
		switch(AM.mag_type)
			if(MAGAZINE)
				if(ammo_magazine)
					to_chat(user,"<span class='warning'>[src] already has something loaded.</span>") //already a magazine here
					return
				user.remove_from_mob(AM)
				AM.forceMove(src)
				ammo_magazine = AM
				user.visible_message("[user] inserts [AM] into [src].", "<span class='notice'>You insert [AM] into [src].</span>")
				playsound(src.loc, AM.insert_sound, 50, FALSE)
			if(SPEEDLOADER)
				if(loaded.len >= max_shells)
					to_chat(user,"<span class='warning'>[src] is full!</span>")
					return
				var/count = 0
				for(var/obj/item/ammo_casing/C in AM.stored_ammo)
					if(loaded.len >= max_shells)
						break
					if(C.caliber == caliber)
						C.forceMove(src)
						loaded += C
						AM.stored_ammo -= C //should probably go inside an ammo_magazine proc, but I guess less proc calls this way...
						count++
				if(count)
					user.visible_message("[user] reloads [src].", "<span class='notice'>You load [count] round\s into [src] using \the [AM].</span>")
					playsound(src.loc, AM.insert_sound, 50, FALSE)
		AM.update_icon()
	else if(istype(A, /obj/item/ammo_casing))
		var/obj/item/ammo_casing/C = A
		if(!(load_method & SINGLE_CASING))
			to_chat(user,"<span class='warning'>[src] can not be loaded with single casings.</span>")
			return //incompatible
		if(caliber != C.caliber)
			to_chat(user,"<span class='warning'>\The [C] does not fit.</span>")
			return //incompatible
		if(loaded.len >= max_shells)
			to_chat(user,"<span class='warning'>[src] is full.</span>")
			return

		user.remove_from_mob(C)
		C.forceMove(src)
		loaded.Insert(1, C) //add to the head of the list
		user.visible_message("[user] inserts \a [C] into [src].", "<span class='notice'>You insert \a [C] into [src].</span>")
		playsound(src.loc, C.reload_sound, 50, FALSE)
	update_maptext()
	update_icon()

//attempts to unload src. If allow_dump is set to 0, the speedloader unloading method will be disabled
/obj/item/gun/projectile/proc/unload_ammo(mob/user, var/allow_dump = 1, var/drop_mag = FALSE)
	if(ammo_magazine)
		if(drop_mag)
			ammo_magazine.forceMove(user.loc)
		else
			user.put_in_hands(ammo_magazine)
		user.visible_message("[user] removes [ammo_magazine] from [src].", "<span class='notice'>You remove [ammo_magazine] from [src].</span>")
		playsound(src.loc, ammo_magazine.eject_sound, 50, FALSE)
		ammo_magazine.update_icon()
		ammo_magazine = null
	else if(loaded.len)
		//presumably, if it can be speed-loaded, it can be speed-unloaded.
		if(allow_dump && (load_method & SPEEDLOADER))
			var/count = 0
			var/turf/T = get_turf(user)
			if(T)
				for(var/obj/item/ammo_casing/C in loaded)
					C.forceMove(T)
					playsound(C, /decl/sound_category/casing_drop_sound, 50, FALSE)
					count++
				loaded.Cut()
			if(count)
				user.visible_message("[user] unloads [src].", "<span class='notice'>You unload [count] round\s from [src].</span>")
		else if(load_method & SINGLE_CASING)
			var/obj/item/ammo_casing/C = loaded[loaded.len]
			loaded.len--
			user.put_in_hands(C)
			user.visible_message("[user] removes \a [C] from [src].", "<span class='notice'>You remove \a [C] from [src].</span>")
	else
		to_chat(user, "<span class='warning'>[src] is empty.</span>")
	update_maptext()
	update_icon()

/obj/item/gun/projectile/attackby(obj/item/A, mob/user)
	. = ..()
	load_ammo(A, user)

/obj/item/gun/projectile/toggle_firing_mode(mob/user)
	if(jam_num)
		playsound(src.loc, 'sound/weapons/click.ogg', 50, TRUE)
		jam_num--
		if(!jam_num)
			visible_message(SPAN_DANGER("\The [user] unjams \the [src]!"))
			balloon_alert(user, SPAN_GREEN("CLEAR"))
			playsound(src.loc, 'sound/weapons/unjam.ogg', 100, TRUE)
			unjam_cooldown = world.time
		else
			balloon_alert(user, SPAN_YELLOW("CLICK"))
	else if(unjam_cooldown + 2 SECONDS > world.time)
		return
	else if(firemodes.len > 1)
		..()
	else
		unload_ammo(user)

/obj/item/gun/projectile/attack_hand(mob/user)
	if(user.get_inactive_hand() == src)
		unload_ammo(user, allow_dump=0)
	else
		return ..()

/obj/item/gun/launcher/grenade/break_action/load_ammo(var/obj/item/A, mob/user)
	if(!cover_open)
		to_chat(user, SPAN_WARNING("You need to open the breechface to load [src].</span>"))
		return
	..()

/obj/item/gun/launcher/grenade/break_action/unload_ammo(mob/user)
	if(!cover_open)
		to_chat(user, SPAN_WARNING("You need to open the breechface to unload [src].</span>"))
		return
	..()

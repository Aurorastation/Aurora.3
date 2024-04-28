/obj/item/gun/projectile
	name = "gun"
	desc = "A gun that fires bullets."
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	w_class = ITEMSIZE_NORMAL
	matter = list(DEFAULT_WALL_MATERIAL = 1000)
	recoil = 1

	var/caliber = "357"		//determines which casings will fit
	var/handle_casings = EJECT_CASINGS	//determines how spent casings should be handled
	var/load_method = SINGLE_CASING|SPEEDLOADER //1 = Single shells, 2 = box or quick loader, 3 = magazine
	var/obj/item/ammo_casing/chambered = null

	//For SINGLE_CASING or SPEEDLOADER guns
	var/max_shells = 0			//the number of casings that will fit inside
	var/ammo_type = null		//the type of ammo that the gun comes preloaded with
	var/list/loaded = list()	//stored ammo

	//For MAGAZINE guns
	var/magazine_type = null	//the type of magazine that the gun comes preloaded with
	var/obj/item/ammo_magazine/ammo_magazine = null //stored magazine
	var/list/allowed_magazines		//determines list of which magazines will fit in the gun
	var/auto_eject = 0			//if the magazine should automatically eject itself when empty.
	var/auto_eject_sound = null

	var/jam_num = 0             //Whether this gun is jammed and how many self-uses until it's unjammed
	var/unjam_cooldown = 0      //Gives the unjammer some time after spamming unjam to not eject their mag
	var/jam_chance = 0          //Chance it jams on fire

	///Pixel offset for the suppressor overlay on the x axis.
	var/suppressor_x_offset
	///Pixel offset for the suppressor overlay on the y axis.
	var/suppressor_y_offset

	//TODO generalize ammo icon states for guns
	//var/magazine_states = 0
	//var/list/icon_keys = list()		//keys
	//var/list/ammo_states = list()	//values

/obj/item/gun/projectile/Initialize()
	. = ..()
	desc_info = "This is a ballistic weapon. It fires [caliber] ammunition. To fire the weapon, toggle the safety with ctrl-click (or enable HARM intent), \
	then click where you want to fire.  To reload, click the gun with an empty hand to remove any spent casings or magazines, and then insert new ones."
	if(ispath(ammo_type) && (load_method & (SINGLE_CASING|SPEEDLOADER)))
		for(var/i in 1 to max_shells)
			loaded += new ammo_type(src)
	if(ispath(magazine_type) && (load_method & MAGAZINE))
		ammo_magazine = new magazine_type(src)
	update_icon()

/obj/item/gun/projectile/Destroy()
	chambered = null
	QDEL_NULL(ammo_magazine)
	QDEL_LIST(loaded)
	. = ..()

/obj/item/gun/projectile/update_icon()
	..()
	if(suppressed)
		var/mutable_appearance/MA = mutable_appearance('icons/obj/guns/suppressor.dmi', "suppressor")
		if(suppressor_x_offset)
			MA.pixel_x = suppressor_x_offset
		if(suppressor_y_offset)
			MA.pixel_y = suppressor_y_offset
		underlays += MA

/obj/item/gun/projectile/consume_next_projectile()
	if(jam_num)
		return FALSE
	//get the next casing
	if(loaded.len)
		chambered = loaded[1] //load next casing.
		if(handle_casings != HOLD_CASINGS)
			loaded -= chambered
	else if(ammo_magazine && ammo_magazine.stored_ammo.len)
		chambered = ammo_magazine.stored_ammo[1]
		if(handle_casings != HOLD_CASINGS)
			ammo_magazine.stored_ammo -= chambered

	if(chambered)
		return chambered.BB
	return null

/obj/item/gun/projectile/handle_post_fire(mob/user)
	..()
	if(chambered)
		chambered.expend()
		process_chambered()
	if(ammo_magazine && !length(ammo_magazine.stored_ammo) && ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.check_weapon_affinity(src))
			unload_ammo(user, TRUE, TRUE)
	update_maptext()

/obj/item/gun/projectile/handle_click_empty()
	..()
	process_chambered()

/obj/item/gun/projectile/special_check(var/mob/user)
	if(!..())
		return FALSE
	if(!jam_num && jam_chance && get_ammo())
		if(prob(jam_chance))
			playsound(src.loc, 'sound/items/trayhit2.ogg', 50, TRUE)
			to_chat(user, "<span class='danger'>\The [src] jams!</span>")
			balloon_alert(user, SPAN_RED("JAM"))
			jam_num = rand(2, 5) // gotta attackself two to five times to unjam
			return FALSE
	return TRUE

/obj/item/gun/projectile/proc/process_chambered()
	if (!chambered) return

	// Aurora forensics port, gunpowder residue.
	if(chambered.leaves_residue)
		var/mob/living/carbon/human/H = loc
		if(istype(H))
			if(!istype(H.gloves, /obj/item/clothing))
				LAZYDISTINCTADD(H.gunshot_residue, chambered.caliber)
			else
				var/obj/item/clothing/G = H.gloves
				LAZYDISTINCTADD(G.gunshot_residue, chambered.caliber)

	switch(handle_casings)
		if(DELETE_CASINGS)
			qdel(chambered)
		if(EJECT_CASINGS) //eject casing onto ground.
			chambered.forceMove(get_turf(src))
			chambered.throw_at(get_ranged_target_turf(get_turf(src),turn(loc.dir,270),1), rand(0,1), 5)
			playsound(chambered, /singleton/sound_category/casing_drop_sound, 50, FALSE)
		if(CYCLE_CASINGS) //cycle the casing back to the end.
			if(ammo_magazine)
				ammo_magazine.stored_ammo += chambered
			else
				loaded += chambered

	if(handle_casings != HOLD_CASINGS)
		chambered = null


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
					to_chat(user,"<span class='warning'>[src] already has a magazine loaded.</span>") //already a magazine here
					return
				user.remove_from_mob(AM)
				AM.forceMove(src)
				ammo_magazine = AM
				user.visible_message("[user] inserts [AM] into [src].", "<span class='notice'>You insert [AM] into [src].</span>")
				playsound(src.loc, AM.insert_sound, 50, extrarange = SHORT_RANGE_SOUND_EXTRARANGE)
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
					playsound(src.loc, AM.insert_sound, 50, extrarange = SHORT_RANGE_SOUND_EXTRARANGE)
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
		playsound(src.loc, C.reload_sound, 50, extrarange = SILENCED_SOUND_EXTRARANGE) //Casings, aka single bullets, are extremely quiet
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
		playsound(src.loc, ammo_magazine.eject_sound, 50, extrarange = SHORT_RANGE_SOUND_EXTRARANGE, falloff_exponent = (SOUND_FALLOFF_EXPONENT+2))
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
					playsound(C, /singleton/sound_category/casing_drop_sound, 50, extrarange = SILENCED_SOUND_EXTRARANGE, falloff_exponent = (SOUND_FALLOFF_EXPONENT+2))
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

/obj/item/gun/projectile/attackby(obj/item/attacking_item, mob/user)
	. = ..()
	if(.)
		return
	load_ammo(attacking_item, user)
	if(istype(attacking_item, /obj/item/suppressor))
		var/obj/item/suppressor/S = attacking_item
		if(!can_suppress)
			balloon_alert(user, "\the [S.name] doesn't fit")
			return

		if(suppressed)
			balloon_alert(user, "already has a suppressor")
			return

		if(user.l_hand != S && user.r_hand != S)
			balloon_alert(user, "not in hand")
			return

		user.drop_from_inventory(suppressor, src)
		balloon_alert(user, "[S.name] attached")
		install_suppressor(S)
		return

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

/obj/item/gun/projectile/afterattack(atom/A, mob/living/user)
	..()
	if(auto_eject && ammo_magazine && ammo_magazine.stored_ammo && !ammo_magazine.stored_ammo.len)
		ammo_magazine.forceMove(get_turf(src.loc))
		user.visible_message(
			"[ammo_magazine] falls out and clatters on the floor!",
			"<span class='notice'>[ammo_magazine] falls out and clatters on the floor!</span>"
			)
		playsound(user, ammo_magazine.eject_sound, 40, FALSE)
		ammo_magazine.update_icon()
		ammo_magazine = null
		update_icon() //make sure to do this after unsetting ammo_magazine

/obj/item/gun/projectile/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(distance > 1)
		return
	if(jam_num)
		. += "<span class='warning'>It looks jammed.</span>"
	if(ammo_magazine)
		. += "It has \a [ammo_magazine] loaded."
	if(suppressed)
		. += "It has a suppressor attached."
	. += "Has [get_ammo()] round\s remaining."
	return

/obj/item/gun/projectile/get_ammo()
	var/bullets = 0
	if(loaded)
		bullets += loaded.len
	if(ammo_magazine && ammo_magazine.stored_ammo)
		bullets += ammo_magazine.stored_ammo.len
	if(chambered)
		bullets += 1
	return bullets

/obj/item/gun/projectile/get_print_info()
	. = ""
	if(load_method & (SINGLE_CASING|SPEEDLOADER))
		. += "Load Type: Single Casing or Speedloader<br>"
		. += "Max Shots: [max_shells]<br>"
		if(length(loaded))
			var/obj/item/ammo_casing/casing = loaded[1]
			var/obj/item/projectile/P = new casing.projectile_type
			. += "<br><b>Projectile</b><br>"
			. += P.get_print_info()
		else
			. += "No ammunition loaded.<br>"
	else
		. += "Load Type: Magazine<br>"
		if(ammo_magazine)
			var/obj/item/ammo_casing/casing = new ammo_magazine.ammo_type
			var/obj/item/projectile/P = new casing.projectile_type
			. += "<br><b>Projectile</b><br>"
			. += P.get_print_info()
		else
			. += "No magazine inserted.<br>"
	. += ..(FALSE)

///Installs a new suppressor, assumes that the suppressor is already in the contents of src
/obj/item/gun/projectile/proc/install_suppressor(obj/item/suppressor/S)
	suppressed = TRUE
	w_class += S.w_class //Add our weight class to the item's weight class
	suppressor = S
	update_icon()

/obj/item/gun/projectile/clear_suppressor()
	if(!can_unsuppress)
		return
	if(istype(suppressor))
		w_class -= suppressor.w_class
	return ..()

/obj/item/gun/projectile/AltClick(mob/user)
	if(use_check_and_message(user))
		return
	if(suppressed && can_unsuppress)
		balloon_alert(user, "[suppressor.name] removed")
		user.put_in_hands(suppressor)
		clear_suppressor()
	return ..()

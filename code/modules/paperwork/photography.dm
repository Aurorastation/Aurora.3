/*	Photography!
 * Contains:
 * * Camera
 * * Camera Film
 * * Photos
 * * Photo Albums
 */

/*******
* film *
*******/
/obj/item/camera_film
	name = "film cartridge"
	icon = 'icons/obj/bureaucracy.dmi'
	desc = "A camera film cartridge. Insert it into a camera to reload it."
	icon_state = "film"
	item_state = "electropack"
	w_class = WEIGHT_CLASS_TINY

/obj/item/camera_film/taj_film
	name = "film canister"
	icon = 'icons/obj/tajara_items.dmi'
	desc = "A rolle of 35mm film intended for cameras of Tajaran make."
	icon_state = "taj_film"

/********
* photo *
********/
GLOBAL_VAR_INIT(photo_count, 1)

/obj/item/photo
	name = "photo"
	desc = "An archaic means of visual preservation, kept alive as kitschy memorabilia by paparazzi, conspiracy theorists and teenage girls."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "photo"
	item_state = "paper"
	w_class = WEIGHT_CLASS_TINY
	/// Who and/or what's in the picture.
	var/picture_desc
	/// The photo's id
	var/id
	/// Big photo image
	var/icon/img
	/// Scribble on the back.
	var/scribble
	/// The small size of the photo used for the icon
	var/icon/tiny
	/// The size of the photo
	var/photo_size = 3
	/// The time the photo was taken
	var/time_taken
	/// The place the photo was taken
	var/location_taken
	/// Who took the photo
	var/taken_by
	/// The photo's name/caption
	var/caption

	drop_sound = 'sound/items/drop/paper.ogg'
	pickup_sound = 'sound/items/pickup/paper.ogg'

/obj/item/photo/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(distance <= 1 || in_slide_projector(user))
		show(user)
		. += SPAN_NOTICE("[picture_desc]")
	else
		. += SPAN_NOTICE("You are too far away to discern its contents.")

/obj/item/photo/New()
	. = ..()
	id = GLOB.photo_count++

/obj/item/photo/attack_self(mob/user as mob)
	examinate(user, src)

/obj/item/photo/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.tool_behaviour == TOOL_PEN)
		var/txt = sanitize( tgui_input_text(user, "What would you like to write on the back?", "Photo Writing", max_length = 128), 128 )
		if((loc == user || Adjacent(user)) && user.stat == 0)
			scribble = txt
	..()

/obj/item/photo/proc/show(mob/user as mob)
	send_rsc(user, img, "tmp_photo_[id].png")
	var/image_size = 64 * photo_size
	var/window_width = image_size
	var/window_height = scribble ? max(400, image_size + 100) : image_size
	if(user.client?.prefs.ui_scale && user.client.window_scaling)
		window_width *= user.client.window_scaling
		window_height *= user.client.window_scaling
	var/dat = "<html><head><title>[name]</title></head>" \
		+ "<body style='overflow:hidden;margin:0;text-align:center'>" \
		+ "<img src='tmp_photo_[id].png' width='[image_size]' style='-ms-interpolation-mode:nearest-neighbor' />" \
		+ "[scribble ? "<br>Written on the back:<br><i>[scribble]</i>" : ""]" \
		+ "</body></html>"
	show_browser(user, HTML_SKELETON(dat), "window=book;size=[window_width]x[window_height]")
	onclose(user, "[name]")
	return

/obj/item/photo/verb/rename()
	set name = "Rename Photo"
	set category = "Object"
	set src in usr

	if(use_check_and_message(usr, USE_ALLOW_NON_ADJACENT))
		return

	var/n_name = sanitizeSafe(input(usr, "What would you like to label the photo?", "Photo Labelling", null)  as text, MAX_NAME_LEN)

	if(use_check_and_message(usr, USE_ALLOW_NON_ADJACENT))
		return

	var/atom/surface_atom = recursive_loc_turf_check(src, 3, usr)
	if(surface_atom == usr || surface_atom.Adjacent(usr))
		if(n_name)
			name = "[initial(name)] ([n_name])"
			caption = n_name
		else
			name = initial(name)
			caption = null
		add_fingerprint(usr)


/**************
* photo album *
**************/
/obj/item/storage/photo_album
	name = "photo album"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "album"
	item_state = "briefcase"
	can_hold = list(/obj/item/photo)

/obj/item/storage/photo_album/mouse_drop_dragged(atom/over, mob/user, src_location, over_location, params)

	if((istype(user, /mob/living/carbon/human)))
		var/mob/M = user
		if(!( istype(over, /atom/movable/screen) ))
			return ..()
		playsound(loc, SFX_RUSTLE, 50, 1, -5)
		if((!( M.restrained() ) && !( M.stat ) && M.back == src))
			switch(over.name)
				if("right hand")
					M.u_equip(src)
					M.equip_to_slot_if_possible(src, slot_r_hand)
				if("left hand")
					M.u_equip(src)
					M.equip_to_slot_if_possible(src, slot_l_hand)
			add_fingerprint(user)
			return
		if(over == user && in_range(src, user) || user.contents.Find(src))
			if(user.s_active)
				user.s_active.close(user)
			show_to(user)
			return
	return

/*********
* camera *
*********/
/obj/item/camera
	name = "camera"
	icon = 'icons/obj/bureaucracy.dmi'
	desc = "A polaroid camera."
	icon_state = "camera"
	item_state = "electropack"
	w_class = WEIGHT_CLASS_SMALL
	obj_flags = OBJ_FLAG_CONDUCTABLE
	slot_flags = SLOT_BELT
	matter = list(MATERIAL_STEEL = 2000)
	var/black_white = FALSE
	var/pictures_max = 10
	var/pictures_left = 10
	var/on = FALSE
	var/icon_on = "camera"
	var/icon_off = "camera_off"
	var/size = 3

/obj/item/camera/Initialize()
	. = ..()
	update_icon()

/obj/item/camera/update_icon()
	icon_state = on ? icon_on : icon_off

/obj/item/camera/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(is_adjacent)
		. += SPAN_NOTICE("It has <b>[pictures_left] photos</b> left.")

/obj/item/camera/verb/change_size()
	set name = "Set Photo Focus"
	set category = "Object"
	set src in usr

	var/nsize = input("Photo Size","Pick a size of resulting photo.") as null|anything in list(1,3,5,7)
	if(nsize)
		size = nsize
		to_chat(usr, SPAN_NOTICE("Camera will now take [size]x[size] photos."))

/obj/item/camera/attack(mob/living/target_mob, mob/living/user, target_zone)
	return

/obj/item/camera/attack_self(mob/user as mob)
	on = !on
	update_icon()
	to_chat(user, "You switch the camera [on ? "on" : "off"].")
	return

/obj/item/camera/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/camera_film))
		if(pictures_left)
			to_chat(user, SPAN_NOTICE("[src] still has some film in it!"))
			return TRUE
		to_chat(user, SPAN_NOTICE("You insert [attacking_item] into [src]."))
		user.drop_from_inventory(attacking_item, get_turf(src))
		qdel(attacking_item)
		pictures_left = pictures_max
		return TRUE
	return ..()

/obj/item/camera/AltClick(var/mob/user)
	change_size()

/obj/item/camera/proc/get_mobs(turf/the_turf as turf)
	var/mob_detail
	for(var/mob/living/carbon/A in the_turf)
		if(A.invisibility) continue
		var/holding = null
		if(A.l_hand || A.r_hand)
			if(A.l_hand) holding = "They are holding \a [A.l_hand]"
			if(A.r_hand)
				if(holding)
					holding += " and \a [A.r_hand]"
				else
					holding = "They are holding \a [A.r_hand]"

		if(!mob_detail)
			mob_detail = "You can see [A] in the photo[A.health < 75 ? " - [A] looks hurt":""].[holding ? " [holding]":"."]. "
		else
			mob_detail += "You can also see [A] in the photo[A.health < 75 ? " - [A] looks hurt":""].[holding ? " [holding]":"."]."
	return mob_detail

/obj/item/camera/afterattack(atom/target as mob|obj|turf|area, mob/user as mob, flag)
	// Placement/storage interactions may already have moved us out of a hand.
	if(loc != user || (user.get_active_hand() != src && user.get_inactive_hand() != src))
		return
	if(!on || !pictures_left || ismob(target.loc)) return
	captureimage(target, user, flag)

	do_photo_sound()

	pictures_left--
	to_chat(user, SPAN_NOTICE("[pictures_left] photos left."))
	icon_state = icon_off
	on = 0
	spawn(64)
		icon_state = icon_on
		on = 1

/obj/item/camera/proc/do_photo_sound()
	playsound(loc, SFX_PRINT, 75, 1, -3)

/obj/item/camera/detective
	name = "detectives camera"
	desc = "A one use - polaroid camera."
	pictures_left = 30

/obj/item/camera/detective/press
	name = "journalists camera"

// Detective cameras have build in data recording, so no need for a skill check
/obj/item/camera/detective/record_data(mob/living/user, obj/item/photo/pic)
	pic.time_taken = worldtime2text()
	pic.location_taken = get_area_display_name(get_area(user))
	pic.taken_by = user.name

//Proc for capturing check
/mob/living/proc/can_capture_turf(turf/T)
	return TRUE	// DVIEW will do sanity checks, we've got no special checks.

/obj/item/camera/proc/captureimage(atom/target, mob/living/user, flag)
	var/obj/item/photo/p = createpicture(get_turf(target), user, flag)
	printpicture(user, p)

/obj/item/camera/proc/createpicture(atom/target, mob/living/user, flag)
	var/mobs = ""
	var/list/turfs = list()
	var/x_c = target.x - (size-1)/2
	var/y_c = target.y - (size-1)/2
	var/z_c = target.z

	var/turf/topleft = locate(x_c, y_c, z_c)
	if (!topleft)
		return null

	var/turf/viewpoint = get_turf(src)
	if(istype(user, /mob/living/silicon/ai) && user.eyeobj)
		viewpoint = get_turf(user.eyeobj)
	if(!viewpoint || viewpoint.z != z_c)
		return null

	var/photo_radius = (size - 1) / 2
	// get_dist returns -1 for the same turf, which would trim the outer ring
	// from photos centered on the photographer.
	var/view_range = max(0, get_dist(viewpoint, target)) + photo_radius
	FOR_DVIEW(var/turf/T, view_range, viewpoint, INVISIBILITY_LIGHTING)
		if(T.x < x_c || T.x >= x_c + size || T.y < y_c || T.y >= y_c + size)
			continue
		if (user.can_capture_turf(T))
			mobs += get_mobs(T)
			turfs += T

	END_FOR_DVIEW

	var/icon/photoimage = generate_image_from_turfs(topleft, turfs, size, CAPTURE_MODE_REGULAR, user)

	var/icon/small_img = icon(photoimage)
	var/icon/tiny_img = icon(photoimage)
	var/icon/ic = icon('icons/obj/bureaucracy.dmi',"photo")
	var/icon/pc = icon('icons/obj/bureaucracy.dmi', "photo")
	small_img.Scale(8, 8)
	tiny_img.Scale(4, 4)
	ic.Blend(small_img,ICON_OVERLAY, 10, 13)
	pc.Blend(tiny_img,ICON_OVERLAY, 12, 19)

	var/obj/item/photo/p = new()
	p.name = "photo"
	p.icon = ic
	p.tiny = pc
	p.img = photoimage
	if(black_white)
		p.img.MapColors(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(0,0,0))
		p.tiny.MapColors(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(0,0,0))
	p.picture_desc = mobs
	p.pixel_x = rand(-10, 10)
	p.pixel_y = rand(-10, 10)
	p.photo_size = size
	record_data(user, p)

	return p

/// Data recorded on photos.
/obj/item/camera/proc/record_data(mob/living/user, obj/item/photo/pic)
	var/forensic = GET_SKILL_LEVEL(user, FORENSICS_SKILL_COMPONENT)
	forensic = forensic ? forensic : SKILL_LEVEL_TRAINED

	// Trained people would know to add this data
	if(forensic >= SKILL_LEVEL_FAMILIAR)
		pic.time_taken = worldtime2text()
		pic.location_taken = get_area_display_name(get_area(user))
		pic.taken_by = user.name

/obj/item/camera/proc/printpicture(mob/user, obj/item/photo/p)
	p.forceMove(user.loc)
	if(!user.get_inactive_hand())
		user.put_in_inactive_hand(p)

/obj/item/photo/proc/copy(var/copy_id = 0)
	var/obj/item/photo/p = new/obj/item/photo()

	p.name = name
	p.icon = icon(icon, icon_state)
	p.tiny = icon(tiny)
	p.img = icon(img)
	p.picture_desc = picture_desc
	p.pixel_x = pixel_x
	p.pixel_y = pixel_y
	p.photo_size = photo_size
	p.scribble = scribble
	p.time_taken = time_taken
	p.location_taken = location_taken
	p.taken_by = taken_by
	p.caption = caption

	if(copy_id)
		p.id = id

	return p

/obj/item/camera/adhomai
	name = "adhomian camera"
	icon = 'icons/obj/tajara_items.dmi'
	desc = "A slightly antiquated camera with a large flash bulb. Still popular with Tajara all over Adhomai."
	icon_state = "taj_camera_on"
	item_state = "taj_camera"
	slot_flags = SLOT_MASK
	black_white = TRUE
	icon_on = "taj_camera_on"
	icon_off = "taj_camera_off"

/obj/item/camera/adhomai/do_photo_sound()
	flick("taj_camera_flash", src)
	playsound(loc, 'sound/items/camerabulb.ogg', 75, 1, -3)

/obj/item/camera/digital
	name = "digital camera"
	desc = "A digital camera with internal photo storage and a built-in printer. Film cartridges refill the printer."
	icon_state = "camera_digital"
	icon_on = "camera_digital"
	icon_off = "camera_digital_off"
	on = FALSE
	/// Stored originals are kept inside the camera; printing produces a copy.
	var/list/obj/item/photo/stored_photos = list()
	var/storage_capacity = 20
	var/next_capture = 0
	var/next_print = 0

/obj/item/camera/digital/Destroy()
	QDEL_LIST(stored_photos)
	return ..()

/obj/item/camera/digital/mechanics_hints(mob/user, distance, is_adjacent)
	. = ..()
	. += "Use in hand to open the photo gallery. Click a subject to take a photo, or Alt-click to change the focus."
	. += "Photos stay in memory until deleted. Printing uses film, but keeps the stored original. Insert a film cartridge when the printer is empty."

/obj/item/camera/digital/feedback_hints(mob/user, distance, is_adjacent)
	. = ..()
	if(is_adjacent)
		. += SPAN_NOTICE("Its memory holds <b>[length(stored_photos)] of [storage_capacity] photos</b>. Film is only used when printing.")

/obj/item/camera/digital/attack_self(mob/user)
	ui_interact(user)

/obj/item/camera/digital/afterattack(atom/target, mob/user, proximity_flag)
	if(loc != user || (user.get_active_hand() != src && user.get_inactive_hand() != src))
		return
	if(!on || world.time < next_capture || ismob(target.loc) || !isliving(user))
		return
	if(length(stored_photos) >= storage_capacity)
		to_chat(user, SPAN_WARNING("\The [src]'s memory is full. Delete a photo to make room."))
		return
	next_capture = world.time + 2 SECONDS
	if(!captureimage(target, user, proximity_flag))
		next_capture = 0
		return
	do_photo_sound()
	to_chat(user, SPAN_NOTICE("Photo saved. [storage_capacity - length(stored_photos)] photo slots remaining."))
	SStgui.update_uis(src)

/obj/item/camera/digital/captureimage(atom/target, mob/living/user, flag)
	if(length(stored_photos) >= storage_capacity)
		return FALSE
	var/turf/target_turf = get_turf(target)
	if(!target_turf)
		return FALSE
	var/obj/item/photo/photo = createpicture(target_turf, user, flag)
	if(!photo)
		return FALSE
	photo.name = "Photo [photo.id]"
	photo.forceMove(src)
	stored_photos += photo
	return TRUE

/obj/item/camera/digital/record_data(mob/living/user, obj/item/photo/photo)
	photo.time_taken = worldtime2text()
	photo.location_taken = get_area_display_name(get_area(user))
	photo.taken_by = user.name

/obj/item/camera/digital/do_photo_sound()
	playsound(loc, 'sound/items/polaroid1.ogg', 50, TRUE, -3)

/obj/item/camera/digital/ui_state(mob/user)
	return GLOB.hands_state

/obj/item/camera/digital/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "DigitalCamera", name, 760, 600)
		ui.open()

/obj/item/camera/digital/ui_data(mob/user)
	var/list/data = list()
	data["capacity"] = storage_capacity
	data["prints_left"] = pictures_left
	data["on"] = on
	data["focus"] = size
	data["printing"] = world.time < next_print
	var/list/photos = list()
	for(var/obj/item/photo/photo in stored_photos)
		// Use the same client-side photo resources as the case dossier.
		var/filename = "tmp_photo_[photo.id].png"
		send_rsc(user, photo.img, filename)
		photos += list(list(
			"id" = photo.id,
			"name" = photo.name,
			"image" = filename,
			"description" = photo.picture_desc,
			"taken_at" = photo.time_taken,
			"location" = photo.location_taken,
			"taken_by" = photo.taken_by,
			"size" = photo.photo_size
		))
	data["photos"] = photos
	return data

/obj/item/camera/digital/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	switch(action)
		if("toggle_power")
			on = !on
			update_icon()
			return TRUE
		if("set_focus")
			var/focus = text2num(params["size"])
			if(focus in list(1, 3, 5, 7))
				size = focus
			return TRUE
		if("delete", "print")
			var/photo_id = text2num(params["id"])
			var/obj/item/photo/selected_photo
			for(var/obj/item/photo/photo in stored_photos)
				if(photo.id == photo_id)
					selected_photo = photo
					break
			if(!selected_photo)
				return
			if(action == "delete")
				stored_photos -= selected_photo
				qdel(selected_photo)
				return TRUE
			if(!pictures_left || world.time < next_print)
				return
			var/obj/item/photo/printed_photo = selected_photo.copy()
			printpicture(usr, printed_photo)
			pictures_left--
			next_print = world.time + 2 SECONDS
			playsound(loc, SFX_PRINT, 50, TRUE, -3)
			return TRUE

/obj/item/camera/digital/investigator
	name = "investigator's digital camera"
	desc = "A rugged digital camera for documenting evidence, with internal photo storage and a built-in printer. Film cartridges refill the printer."
	icon_state = "camera_investigator"
	icon_on = "camera_investigator"
	icon_off = "camera_investigator_off"
	pictures_left = 30
	storage_capacity = 30

/*	Photography!
 *	Contains:
 *		Camera
 *		Camera Film
 *		Photos
 *		Photo Albums
 */

/*******
* film *
*******/
/obj/item/device/camera_film
	name = "film cartridge"
	icon = 'icons/obj/bureaucracy.dmi'
	desc = "A camera film cartridge. Insert it into a camera to reload it."
	icon_state = "film"
	item_state = "electropack"
	w_class = ITEMSIZE_TINY


/********
* photo *
********/
var/global/photo_count = 0

/obj/item/photo
	name = "photo"
	desc = "An archaic means of visual preservation, kept alive as kitschy memorabilia by paparazzi, conspiracy theorists and teenage girls."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "photo"
	item_state = "paper"
	w_class = ITEMSIZE_TINY
	var/picture_desc // Who and/or what's in the picture.
	var/id
	var/icon/img	//Big photo image
	var/scribble	//Scribble on the back.
	var/icon/tiny
	var/photo_size = 3

	drop_sound = 'sound/items/drop/paper.ogg'
	pickup_sound = 'sound/items/pickup/paper.ogg'

/obj/item/photo/New()
	id = photo_count++

/obj/item/photo/attack_self(mob/user as mob)
	user.examinate(src)

/obj/item/photo/attackby(obj/item/P as obj, mob/user as mob)
	if(P.ispen())
		var/txt = sanitize(input(user, "What would you like to write on the back?", "Photo Writing", null)  as text, 128)
		if(loc == user && user.stat == 0)
			scribble = txt
	..()

/obj/item/photo/examine(mob/user)
	. = ..()
	if(in_range(user, src) || isobserver(user) || in_slide_projector(user))
		show(user)
		to_chat(user, "<span class='notice'>[picture_desc]</span>")
	else
		to_chat(user, "<span class='notice'>You are too far away to discern its contents.</span>")


/obj/item/photo/proc/show(mob/user as mob)
	send_rsc(user, img, "tmp_photo_[id].png")
	user << browse("<html><head><title>[name]</title></head>" + "<body style='overflow:hidden;margin:0;text-align:center'>" + "<img src='tmp_photo_[id].png' width='[64*photo_size]' style='-ms-interpolation-mode:nearest-neighbor' />" + "[scribble ? "<br>Written on the back:<br><i>[scribble]</i>" : ""]" + "</body></html>", "window=book;size=[64*photo_size]x[scribble ? 400 : 64*photo_size]")
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
		else
			name = initial(name)
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

/obj/item/storage/photo_album/MouseDrop(obj/over_object as obj)

	if((istype(usr, /mob/living/carbon/human)))
		var/mob/M = usr
		if(!( istype(over_object, /obj/screen) ))
			return ..()
		playsound(loc, /decl/sound_category/rustle_sound, 50, 1, -5)
		if((!( M.restrained() ) && !( M.stat ) && M.back == src))
			switch(over_object.name)
				if("right hand")
					M.u_equip(src)
					M.equip_to_slot_if_possible(src, slot_r_hand)
				if("left hand")
					M.u_equip(src)
					M.equip_to_slot_if_possible(src, slot_l_hand)
			add_fingerprint(usr)
			return
		if(over_object == usr && in_range(src, usr) || usr.contents.Find(src))
			if(usr.s_active)
				usr.s_active.close(usr)
			show_to(usr)
			return
	return

/*********
* camera *
*********/
/obj/item/device/camera
	name = "camera"
	icon = 'icons/obj/bureaucracy.dmi'
	desc = "A polaroid camera."
	icon_state = "camera"
	item_state = "electropack"
	w_class = ITEMSIZE_SMALL
	flags = CONDUCT
	slot_flags = SLOT_BELT
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	var/pictures_max = 10
	var/pictures_left = 10
	var/on = 1
	var/icon_on = "camera"
	var/icon_off = "camera_off"
	var/size = 3

/obj/item/device/camera/examine(mob/user, distance)
	..()
	if(Adjacent(user))
		to_chat(user, SPAN_NOTICE("It has <b>[pictures_left]</b> photos left."))

/obj/item/device/camera/verb/change_size()
	set name = "Set Photo Focus"
	set category = "Object"
	var/nsize = input("Photo Size","Pick a size of resulting photo.") as null|anything in list(1,3,5,7)
	if(nsize)
		size = nsize
		to_chat(usr, "<span class='notice'>Camera will now take [size]x[size] photos.</span>")

/obj/item/device/camera/attack(mob/living/carbon/human/M as mob, mob/user as mob)
	return

/obj/item/device/camera/attack_self(mob/user as mob)
	on = !on
	if(on)
		src.icon_state = icon_on
	else
		src.icon_state = icon_off
	to_chat(user, "You switch the camera [on ? "on" : "off"].")
	return

/obj/item/device/camera/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/device/camera_film))
		if(pictures_left)
			to_chat(user, "<span class='notice'>[src] still has some film in it!</span>")
			return
		to_chat(user, "<span class='notice'>You insert [I] into [src].</span>")
		user.drop_from_inventory(I,get_turf(src))
		qdel(I)
		pictures_left = pictures_max
		return
	..()

/obj/item/device/camera/AltClick(var/mob/user)
	change_size()

/obj/item/device/camera/proc/get_mobs(turf/the_turf as turf)
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
			mob_detail = "You can see [A] in the photo[A:health < 75 ? " - [A] looks hurt":""].[holding ? " [holding]":"."]. "
		else
			mob_detail += "You can also see [A] in the photo[A:health < 75 ? " - [A] looks hurt":""].[holding ? " [holding]":"."]."
	return mob_detail

/obj/item/device/camera/afterattack(atom/target as mob|obj|turf|area, mob/user as mob, flag)
	if(!on || !pictures_left || ismob(target.loc)) return
	captureimage(target, user, flag)

	playsound(loc, pick('sound/items/polaroid1.ogg', 'sound/items/polaroid2.ogg'), 75, 1, -3)

	pictures_left--
	to_chat(user, "<span class='notice'>[pictures_left] photos left.</span>")
	icon_state = icon_off
	on = 0
	spawn(64)
		icon_state = icon_on
		on = 1

/obj/item/device/camera/detective
	name = "detectives camera"
	desc = "A one use - polaroid camera."
	pictures_left = 30

//Proc for capturing check
/mob/living/proc/can_capture_turf(turf/T)
	return TRUE	// DVIEW will do sanity checks, we've got no special checks.

/obj/item/device/camera/proc/captureimage(atom/target, mob/living/user, flag)
	var/obj/item/photo/p = createpicture(get_turf(target), user, flag)
	printpicture(user, p)

/obj/item/device/camera/proc/createpicture(atom/target, mob/living/user, flag)
	var/mobs = ""
	var/list/turfs = list()

	FOR_DVIEW(var/turf/T, size, target, INVISIBILITY_LIGHTING)
		if (user.can_capture_turf(T))
			mobs += get_mobs(T)
			turfs += T

	END_FOR_DVIEW

	var/x_c = target.x - (size-1)/2
	var/y_c = target.y - (size-1)/2
	var/z_c	= target.z

	var/turf/topleft = locate(x_c, y_c, z_c)
	if (!topleft)
		return null

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
	p.picture_desc = mobs
	p.pixel_x = rand(-10, 10)
	p.pixel_y = rand(-10, 10)
	p.photo_size = size

	return p

/obj/item/device/camera/proc/printpicture(mob/user, obj/item/photo/p)
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

	if(copy_id)
		p.id = id

	return p

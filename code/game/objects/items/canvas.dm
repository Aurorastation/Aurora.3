/**
 * Interface for using DrawBox() to draw 1 pixel on a coordinate.
 * Returns the same icon specifed in the argument, but with the pixel drawn.
 */
/proc/DrawPixel(icon/I, color, drawX, drawY)
	if(!I)
		return FALSE

	var/Iwidth = I.Width()
	var/Iheight = I.Height()

	if(drawX > Iwidth || drawX <= 0)
		return FALSE
	if(drawY > Iheight || drawY <= 0)
		return FALSE

	I.DrawBox(color, drawX, drawY)
	return I

/**
 * Interface for easy drawing of one pixel on an atom.
 */
/atom/proc/DrawPixelOn(color, drawX, drawY)
	var/icon/I = new(icon)
	var/icon/J = DrawPixel(I, color, drawX, drawY)
	if(J) // Only set the icon if it succeeded, the icon without the pixel is 1000x better than a black square.
		icon = J
		return J
	return FALSE

/obj/item/canvas
	name = "11px by 11px canvas"
	desc = "Draw out your soul on this canvas! Only crayons can draw on it."
	icon = 'icons/obj/canvas.dmi'
	icon_state = "11x11"

/obj/item/canvas/nineteen_nineteen
	name = "19px by 19px canvas"
	icon_state = "19x19"

/obj/item/canvas/twentythree_nineteen
	name = "23px by 19px canvas"
	icon_state = "23x19"

/obj/item/canvas/twentythree_twentythree
	name = "23px by 23px canvas"
	icon_state = "23x23"

/**
 * One pixel increments.
 */
/obj/item/canvas/attackby(obj/item/I, mob/user, params)
	if(I.iswrench())
		to_chat(user, SPAN_NOTICE("You begin to [anchored ? "loosen" : "tighten"] \the [src]..."))
		if(I.use_tool(src, user, 40, volume = 50))
			user.visible_message("<b>[user]</b> [anchored ? "loosens" : "tightens"] \the [src].", SPAN_NOTICE("You [anchored ? "loosen" : "tighten"] \the [src]."), SPAN_NOTICE("You hear a ratchet."))
			anchored = !anchored
		return TRUE

	// Click info.
	var/list/click_params = params2list(params)
	var/pixX = text2num(click_params["icon-x"])
	var/pixY = text2num(click_params["icon-y"])

	// Should always be true, otherwise you didn't click the object, but let's check because SS13~
	if(!click_params || !click_params["icon-x"] || !click_params["icon-y"])
		return TRUE

	// Cleaning one pixel with a soap or rag.
	if(istype(I, /obj/item/soap) || istype(I, /obj/item/reagent_containers/glass/rag))
		// Pixel info created only when needed.
		var/icon/masterpiece = icon(icon,icon_state)
		var/thePix = masterpiece.GetPixel(pixX,pixY)
		var/icon/Ico = clean_canvas()
		if(!Ico)
			qdel(masterpiece)
			return TRUE

		var/theOriginalPix = Ico.GetPixel(pixX,pixY)
		if(thePix != theOriginalPix) // Clour changed.
			DrawPixelOn(theOriginalPix,pixX,pixY)
		qdel(masterpiece)
		return TRUE

	// Drawing one pixel with a crayon.
	else if(istype(I, /obj/item/pen/crayon))
		var/obj/item/pen/crayon/C = I
		DrawPixelOn(C.shadeColour, pixX, pixY)
		return TRUE
	else
		return ..()

/**
 * Clean the whole canvas.
 */
/obj/item/canvas/attack_self(mob/user)
	if(!user)
		return
	var/icon/blank = clean_canvas()
	if(blank)
		// It's basically a giant etch-a-sketch.
		icon = blank
		user.visible_message("<b>[user]</b> cleans the canvas.", SPAN_NOTICE("You clean the canvas."))

/obj/item/canvas/afterattack(turf/A, mob/user, flag, params)
	if(!istype(A))
		return

	if(!iswall(A))
		return

	var/turf/target_turf = A
	var/turf/source_turf = get_turf(user)

	var/dir_offset = 0
	if(target_turf != source_turf)
		dir_offset = get_dir(source_turf, target_turf)
		if(!(dir_offset in global.cardinal))
			to_chat(user, SPAN_WARNING("You cannot reach that from here."))
			return

	if(user.unEquip(src, source_turf))
		if(params)
			var/list/mouse_control = params2list(params)
			if(mouse_control["icon-x"])
				pixel_x = text2num(mouse_control["icon-x"]) - 16
				if(dir_offset & EAST)
					pixel_x += 32
				else if(dir_offset & WEST)
					pixel_x -= 32
			if(mouse_control["icon-y"])
				pixel_y = text2num(mouse_control["icon-y"]) - 16
				if(dir_offset & NORTH)
					pixel_y += 32
				else if(dir_offset & SOUTH)
					pixel_y -= 32

/obj/item/canvas/proc/clean_canvas()
	var/icon/I = icon(initial(icon), initial(icon_state))
	. = I

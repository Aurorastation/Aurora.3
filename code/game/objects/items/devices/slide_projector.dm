/obj/item/storage/slide_projector
	name = "slide projector"
	desc = "A handy device capable of showing an enlarged projection of whatever you can fit inside."
	desc_info = "You can use this in hand to open the interface, click-dragging it to you also works. Click anywhere with it in your hand to project at that location. Click dragging it to that location also works."
	icon = 'icons/obj/projector.dmi'
	icon_state = "projector0"
	max_w_class = WEIGHT_CLASS_SMALL
	max_storage_space = 10
	use_sound = 'sound/items/storage/toolbox.ogg'
	var/static/list/projection_types = list(
		/obj/item/photo = /obj/effect/projection/photo,
		/obj/item/paper = /obj/effect/projection/paper,
		/obj/item = /obj/effect/projection
	)
	var/obj/item/current_slide
	var/obj/effect/projection/projection

/obj/item/storage/slide_projector/Destroy()
	QDEL_NULL(current_slide)
	QDEL_NULL(projection)
	return ..()

/obj/item/storage/slide_projector/update_icon()
	icon_state = "projector[!!projection]"

/obj/item/storage/slide_projector/remove_from_storage(obj/item/W)
	. = ..()
	if(. && W == current_slide)
		set_slide(length(contents) ? contents[1] : null)

/obj/item/storage/slide_projector/handle_item_insertion(var/obj/item/W)
	. = ..()
	if(. && !current_slide)
		set_slide(W)

/obj/item/storage/slide_projector/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(istype(target, /obj/structure/table) && proximity_flag)
		return
	if(!current_slide)
		to_chat(user, SPAN_WARNING("\The [src] does not have a slide loaded."))
		return
	project_at(get_turf(target))

/obj/item/storage/slide_projector/mouse_drop_dragged(atom/over, mob/user, src_location, over_location, params)
	if(use_check_and_message(user))
		return

	if(over == user)
		interact(user)
		return

	var/turf/T = get_turf(over)
	if(istype(T))
		afterattack(over, user)

/obj/item/storage/slide_projector/proc/set_slide(obj/item/new_slide)
	current_slide = new_slide
	playsound(loc, 'sound/machines/slide_change.ogg', 50)
	if(projection)
		project_at(get_turf(projection))

/obj/item/storage/slide_projector/proc/check_projections()
	if(!projection)
		return
	if(!(projection in view(7,get_turf(src))))
		stop_projecting()

/obj/item/storage/slide_projector/proc/stop_projecting()
	if(projection)
		QDEL_NULL(projection)
	UnregisterSignal(src, COMSIG_MOVABLE_MOVED)
	set_light(0)
	update_icon()

/obj/item/storage/slide_projector/proc/project_at(turf/target)
	stop_projecting()
	if(!current_slide)
		return
	var/projection_type
	for(var/T in projection_types)
		if(istype(current_slide, T))
			projection_type = projection_types[T]
			break
	projection = new projection_type(target)
	projection.set_source(current_slide)
	RegisterSignal(src, COMSIG_MOVABLE_MOVED, PROC_REF(check_projections))
	set_light(1.4, 0.1, COLOR_WHITE) //Bit of light
	update_icon()

/obj/item/storage/slide_projector/attack_self(mob/user)
	interact(user)

/obj/item/storage/slide_projector/interact(mob/user)
	var/data = list()
	if(projection)
		data += "<a href='byond://?src=[REF(src)];stop_projector=1'>Disable Projector</a>"
	else
		data += "Projector Inactive"

	var/table = list("<table><tr><th>#</th><th>SLIDE</th><th>SHOW</th></tr>")
	var/i = 1
	for(var/obj/item/I in contents)
		table += "<tr><td>#[i]</td>"
		if(I == current_slide)
			table += "<td><b>[I.name]</b></td><td>SHOWING</td>"
		else
			table += "<td>[I.name]</td><td><a href='byond://?src=[REF(src)];set_active=[i]'>SHOW</a></td>"
		table += "</tr>"
		i++
	table += "</table>"
	data += jointext(table,null)

	var/datum/browser/popup = new(user, "slides[REF(src)]", "Slide Projector")
	popup.set_content(jointext(data, "<br>"))
	popup.open()

/obj/item/storage/slide_projector/Topic(href, href_list)
	. = ..()
	if(.)
		return

	if(href_list["stop_projector"])
		if(!projection)
			return TRUE
		stop_projecting()
		. = FALSE

	if(href_list["set_active"])
		var/index = text2num(href_list["set_active"])
		if(index < 1 || index > contents.len)
			return TRUE
		set_slide(contents[index])
		. = FALSE

	interact(usr)

/obj/effect/projection
	name = "projected slide"
	icon = 'icons/effects/effects.dmi'
	icon_state = "white"
	anchored = TRUE
	simulated = FALSE
	plane = EFFECTS_ABOVE_LIGHTING_PLANE
	alpha = 100
	var/datum/weakref/source

/obj/effect/projection/Initialize()
	. = ..()
	set_light(1.4, 0.1, COLOR_WHITE) //Makes turning off the lights not invalidate projection

/obj/effect/projection/update_icon()
	filters = filter(type="drop_shadow", color = COLOR_WHITE, size = 4, offset = 1,x = 0, y = 0)
	project_icon()

/obj/effect/projection/proc/project_icon()
	var/obj/item/I = source.resolve()
	if(!istype(I))
		qdel(src)
		return
	ClearOverlays()
	var/mutable_appearance/MA = new(I)
	MA.plane = EFFECTS_ABOVE_LIGHTING_PLANE
	MA.appearance_flags = RESET_ALPHA
	MA.alpha = 170
	MA.pixel_x = 0
	MA.pixel_y = 0
	overlays |= MA

/obj/effect/projection/proc/set_source(obj/item/I)
	source = WEAKREF(I)
	desc = "It's currently showing \the [I]."
	update_icon()

/obj/effect/projection/examine(mob/user, distance, is_adjacent, infix, suffix, show_extended)
	. = ..()
	var/obj/item/slide = source.resolve()
	if(!istype(slide))
		qdel(src)
		return
	return slide.examine(user, max(distance, 1), FALSE, show_extended = show_extended)

/obj/effect/projection/photo
	alpha = 170

/obj/effect/projection/photo/project_icon()
	var/obj/item/photo/slide = source.resolve()
	if(!istype(slide))
		qdel(src)
		return
	icon = slide.img
	transform = matrix()
	transform *= 1 / slide.photo_size
	pixel_x = -32 * round(slide.photo_size/2)
	pixel_y = -32 * round(slide.photo_size/2)

/obj/effect/projection/paper
	alpha = 140
	blend_mode = BLEND_ADD

/obj/effect/projection/paper/project_icon()
	var/obj/item/paper/P = source.resolve()
	if(!istype(P))
		qdel(src)
		return
	ClearOverlays()
	if(P.info)
		icon_state = "text[rand(1,3)]"

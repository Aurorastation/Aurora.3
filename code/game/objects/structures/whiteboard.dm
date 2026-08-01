/// List of data passed over to tgui, obtained from whiteboard singletons. List contains lists of: "display_name", "icon", "icon_name", "singleton_path"
GLOBAL_LIST_EMPTY(whiteboard_overlay_cache)

// ---- large whiteboard, 64x32
/obj/structure/whiteboard
	name = "whiteboard"
	desc = "A whiteboard in classic design. Often associated with its sibling glassboard, perfect material to draw incomprehensible equations."
	icon = 'icons/obj/whiteboard.dmi'
	icon_state = "whiteboard"
	layer = OBJ_LAYER
	/// Singleton path to whiteboard overlays.
	var/overlay_choices_singleton = /singleton/whiteboard
	/// Written things on the whiteboard.
	var/written_contents
	/// Is someone currently drawing things on the whiteboard?
	var/busy = FALSE
	/// Used to prevent pixel-shift mechanic spam.
	var/currently_pixel_shifting = FALSE
	/// For mapping purposes. Define this as one of the overlay icon_state's name (e.g. overlay_1).
	var/preset_overlay

/obj/structure/whiteboard/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "You can write or edit things on [src] with a <b>pen</b>."
	. += "You can <b>ALT Click</b> to pixel-shift [src] to the wall. Only works for north direction when wheel brakes are locked!"
	. += "You can engage/release wheel brakes with the help of a <b>wrench</b>."

/obj/structure/whiteboard/examine(mob/user, distance, is_adjacent, infix, suffix, show_extended)
	. = ..()
	if(written_contents)
		to_chat(user, EXAMINE_BLOCK("It reads: \"[written_contents]\"."))

/obj/structure/whiteboard/Initialize()
	. = ..()
	if(!length(GLOB.whiteboard_overlay_cache))
		var/list/singleton_instances = GET_SINGLETON_SUBTYPE_MAP(overlay_choices_singleton)
		for(var/i in singleton_instances)
			var/singleton/whiteboard/S = GET_SINGLETON(i)
			var/overlay_image = image(icon = icon, icon_state = S.icon_state)

			GLOB.whiteboard_overlay_cache.Add(list(list(
			"display_name" = S.name,
			"icon" = icon2base64(getFlatIcon(overlay_image)), // expensive but we only do it once
			"icon_name" = S.icon_state,
			"singleton_path" = "[S.type]"
		)))

	if(preset_overlay)
		AddOverlays(preset_overlay)

/obj/structure/whiteboard/Move()
	. = ..()
	if(has_gravity())
		playsound(src, 'sound/effects/roll.ogg', 50, 1)

/obj/structure/whiteboard/AltClick(mob/user)
	if(!anchored)
		to_chat(user, SPAN_WARNING("You need the wheels locked first in order to secure [src] to a wall!"))
		return

	if(currently_pixel_shifting)
		return

	currently_pixel_shifting = TRUE
	if(!do_after(user, 0.5 SECOND))
		currently_pixel_shifting = FALSE
		return
	currently_pixel_shifting = FALSE
	animate(src, pixel_y = pixel_y == 0 ? 12 : 0, time = 0.2 SECOND)
	balloon_alert(user, "shifted")

/obj/structure/whiteboard/attackby(obj/item/attacking_item, mob/user)
	if(busy)
		to_chat(user, SPAN_WARNING("Someone is already drawing things on this board!"))
		return

	var/obj/item/pen/P = attacking_item
	if(istype(P))
		to_chat(user, SPAN_NOTICE("You start contemplating what to draw."))
		handle_drawing(user)

	else if(attacking_item.tool_behaviour == TOOL_WRENCH)
		animate(src, pixel_y = 0, time = 0.2 SECOND) // if we were pixel-shifted, return to our original state
		anchored = !anchored
		attacking_item.play_tool_sound(get_turf(src), 75)
		balloon_alert(user, "[anchored ? "secure" : "unsecure"]")
		user.visible_message("[user] [anchored ? "locks" : "unlocks"] [src]'s wheels.", \
					"You [anchored ? "locked" : "unlocked"] [src]'s wheels.", \
					"You hear a click.")

	else
		to_chat(user, SPAN_WARNING("This is the wrong tool to manifest your inland empire, maybe a pen would be more fitting?"))

/obj/structure/whiteboard/proc/handle_drawing(mob/user)
	busy = TRUE
	// Text input
	var/new_written_contents = tgui_input_text(user, "Write your text here", "Whiteboard Contents", default = written_contents, multiline = TRUE)
	if(new_written_contents == written_contents) // if untouched, cancel it
		to_chat(user, SPAN_WARNING("You withdraw your pen in thought, [src] remains untouched."))
		busy = FALSE
		return

	if(!new_written_contents) //if empty, erase the board
		to_chat(user, SPAN_NOTICE("You erase the contents on [src]."))
		ClearOverlays()
		desc = initial(desc)
		written_contents = null
		busy = FALSE
		return

	written_contents = new_written_contents
	ui_interact(user)

/obj/structure/whiteboard/proc/finalize_drawing(mob/user, choice)
	playsound(get_turf(src), SFX_WHITEBOARD_SCRIBBLE, 60, FALSE)
	if(do_after(user, 2 SECONDS))
		update_icon(choice)
	else
		ClearOverlays()
		written_contents = null

/obj/structure/whiteboard/update_icon(choice)
	ClearOverlays()
	AddOverlays(choice)

// ---- UI code

/obj/structure/whiteboard/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "OverlayChoice", capitalize_first_letters(name))
		ui.open()

/obj/structure/whiteboard/ui_static_data(mob/user)
	var/list/data = list()
	data["contents"] = GLOB.whiteboard_overlay_cache
	return data

/obj/structure/whiteboard/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/user = ui.user
	add_fingerprint(user)
	switch(action)
		if("select_overlay")
			var/choice = params["choice"]
			INVOKE_ASYNC(src, PROC_REF(finalize_drawing), user, choice)
			busy = FALSE

			SStgui.close_uis(src)

	. = TRUE

/obj/structure/whiteboard/ui_close(mob/user, datum/tgui/ui)
	. = ..()

	if(busy) // if the ui was closed while we were still busy, it means no overlay were chosen
		busy = FALSE
		written_contents = null
		ClearOverlays()
		to_chat(user, SPAN_WARNING("You withdraw your pen in thought, [src] remains untouched."))

// ---- Portable whiteboard, 32x32
/obj/item/portable_whiteboard
	name = "portable whiteboard"
	desc = "A compact whiteboard folded into a portable frame, ready to be deployed on any unexpected seminar!"
	icon = 'icons/obj/whiteboard_portable.dmi'
	icon_state = "whiteboard_case"
	item_state = "whiteboard_case"
	contained_sprite = TRUE
	force = 18
	throw_speed = 1
	throw_range = 4
	w_class = WEIGHT_CLASS_BULKY
	attack_verb = list("attacked", "bashed", "battered", "bludgeoned", "whacked")
	drop_sound = 'sound/items/drop/toolbox.ogg'
	pickup_sound = 'sound/items/pickup/toolbox.ogg'
	/// Used to keep track of folding process to prevent spams.
	var/currently_unfolding = FALSE

/obj/item/portable_whiteboard/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "You can <b>ALT Click</b> to deploy [src]. It must be on the floor first!"

/obj/item/portable_whiteboard/AltClick(mob/user)
	if(loc == user)
		to_chat(user, SPAN_WARNING("[src] needs to be standing on the floor in order to be unfolded!"))
		return

	if(currently_unfolding)
		return

	currently_unfolding = TRUE
	if(!do_after(user, 3 SECONDS))
		currently_unfolding = FALSE
		return

	new /obj/structure/whiteboard/portable(get_turf(src))
	playsound(get_turf(src), 'sound/items/storage/briefcase.ogg', 50)
	qdel(src)

/obj/structure/whiteboard/portable
	name = "portable whiteboard"
	desc = "A compact whiteboard folded into a portable frame, ready to be deployed on any unexpected seminar!"
	icon = 'icons/obj/whiteboard_portable.dmi'
	anchored = FALSE
	/// Used to keep track of folding process to prevent spams.
	var/currently_folding = FALSE

/obj/structure/whiteboard/portable/AltClick(mob/user)
	if(currently_folding)
		return

	currently_folding = TRUE
	if(!do_after(user, 3 SECONDS))
		currently_folding = FALSE
		return

	new /obj/item/portable_whiteboard(get_turf(src))
	playsound(get_turf(src), 'sound/items/storage/briefcase.ogg', 50)
	qdel(src)

/obj/structure/whiteboard/portable/update_icon(choice)
	ClearOverlays()
	var/image/overlay_image = image(icon = 'icons/obj/whiteboard.dmi', icon_state = choice)
	overlay_image.transform *= 0.5
	overlay_image.pixel_x = -16
	overlay_image.pixel_y = 2
	AddOverlays(overlay_image)

// ---- Whiteboard overlay singletons

/singleton/whiteboard
	var/name = "placeholder"
	var/icon_state = ""

/singleton/whiteboard/bar_chart
	name = "Bar chart"
	icon_state = "overlay_1"

/singleton/whiteboard/pie_chart
	name = "Pie chart"
	icon_state = "overlay_2"

/singleton/whiteboard/spacetime_diagram
	name = "Spacetime diagram"
	icon_state = "overlay_3"

/singleton/whiteboard/geometric_chart
	name = "Geometric chart"
	icon_state = "overlay_4"

/singleton/whiteboard/scribbles
	name = "Scribbles"
	icon_state = "overlay_5"

/singleton/whiteboard/gun_diagram
	name = "Gun diagram"
	icon_state = "overlay_6"

/singleton/whiteboard/circle_chart
	name = "Circle chart"
	icon_state = "overlay_7"

/singleton/whiteboard/display_chart
	name = "Display chart"
	icon_state = "overlay_8"

/singleton/whiteboard/todays_menu
	name = "Today's menu"
	icon_state = "overlay_9"

/singleton/whiteboard/calculations
	name = "Calculations"
	icon_state = "overlay_10"

/singleton/whiteboard/erased_board
	name = "Erased board"
	icon_state = "overlay_11"

/singleton/whiteboard/wavelenghth
	name = "Wavelength"
	icon_state = "overlay_12"

/singleton/whiteboard/grafitti
	name = "Grafitti"
	icon_state = "overlay_13"

/singleton/whiteboard/archeological
	name = "Archeological"
	icon_state = "overlay_14"

/singleton/whiteboard/horizon
	name = "SCCV Horizon"
	icon_state = "overlay_15"

/singleton/whiteboard/thrust
	name = "Thrust diagram"
	icon_state = "overlay_16"

/singleton/whiteboard/navchart
	name = "Navigation chart"
	icon_state = "overlay_17"

/singleton/whiteboard/tasks
	name = "Task list"
	icon_state = "overlay_18"

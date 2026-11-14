
#define AIRLOCK_REGION_PAINT    "Paint"
#define AIRLOCK_REGION_STRIPE   "Stripe"
#define AIRLOCK_REGION_WINDOW   "Window"

/obj/item/paint_sprayer
	name = "paint gun"
	desc = "A Hephaestus-made paint gun that uses microbes to replenish its paint storage. Very high-tech and fancy too!"
	icon = 'icons/obj/item/paint_sprayer.dmi'
	icon_state = "paint_sprayer"
	item_state = "paint_sprayer"
	contained_sprite = TRUE
	var/decal =        "remove all decals"
	var/paint_dir =    "precise"
	var/paint_colour = COLOR_WHITE

	var/list/decals = list(
		// quarter
		"quarter-turf" =          list("path" = /obj/effect/floor_decal/corner, "precise" = 1, "coloured" = 1),
		"wide quarter-turf" =     list("path" = /obj/effect/floor_decal/corner_wide, "precise" = 1, "coloured" = 1),
		"full quarter-turf" =     list("path" = /obj/effect/floor_decal/corner_full, "precise" = 1, "coloured" = 1),
		// hazard
		"hazard stripes" =        list("path" = /obj/effect/floor_decal/industrial/warning),
		"corner, hazard" =        list("path" = /obj/effect/floor_decal/industrial/warning/corner),
		// hatch
		"hatched marking" =       list("path" = /obj/effect/floor_decal/industrial/hatch, "coloured" = 1),
		"hatched marking small" = list("path" = /obj/effect/floor_decal/industrial/hatch_small, "coloured" = 1),
		"hatched marking tiny" =  list("path" = /obj/effect/floor_decal/industrial/hatch_tiny, "coloured" = 1),
		// outline
		"dotted outline" =        list("path" = /obj/effect/floor_decal/industrial/outline, "coloured" = 1),
		"arrow" =             list("path" = /obj/effect/floor_decal/industrial/arrow, "precise" = 1, "coloured" = 1),
		"loading sign" =      list("path" = /obj/effect/floor_decal/industrial/loading),
		// signs
		"1" =                 list("path" = /obj/effect/floor_decal/sign),
		"2" =                 list("path" = /obj/effect/floor_decal/sign/two),
		"A" =                 list("path" = /obj/effect/floor_decal/sign/a),
		"B" =                 list("path" = /obj/effect/floor_decal/sign/b),
		"C" =                 list("path" = /obj/effect/floor_decal/sign/c),
		"D" =                 list("path" = /obj/effect/floor_decal/sign/d),
		"Ex" =                list("path" = /obj/effect/floor_decal/sign/ex),
		"M" =                 list("path" = /obj/effect/floor_decal/sign/m),
		"CMO" =               list("path" = /obj/effect/floor_decal/sign/cmo),
		"V" =                 list("path" = /obj/effect/floor_decal/sign/v),
		"Psy" =               list("path" = /obj/effect/floor_decal/sign/p),
		// remove all
		"remove all decals" = list("path" = /obj/effect/floor_decal/reset)
		)

	var/list/paint_dirs = list(
		"north" =       NORTH,
		"northwest" =   NORTHWEST,
		"west" =        WEST,
		"southwest" =   SOUTHWEST,
		"south" =       SOUTH,
		"southeast" =   SOUTHEAST,
		"east" =        EAST,
		"northeast" =   NORTHEAST,
		"precise" = 0
		)

	var/list/preset_colors = list(
		"beasty brown" =   COLOR_BEASTY_BROWN,
		"blue" =           COLOR_BLUE_GRAY,
		"civvie green" =   COLOR_CIVIE_GREEN,
		"command blue" =   COLOR_COMMAND_BLUE,
		"cyan" =           COLOR_CYAN,
		"green" =          COLOR_GREEN,
		"bottle green" =   COLOR_PALE_BTL_GREEN,
		"dark red" =       COLOR_DARK_RED,
		"orange" =         COLOR_ORANGE,
		"pale orange" =    COLOR_PALE_ORANGE,
		"red" =            COLOR_RED,
		"sky blue" =       COLOR_DEEP_SKY_BLUE,
		"titanium" =       COLOR_TITANIUM,
		"aluminium"=       COLOR_ALUMINIUM,
		"violet" =         COLOR_VIOLET,
		"white" =          COLOR_WHITE,
		"yellow" =         COLOR_AMBER,
		"hull blue" =      COLOR_HULL,
		"bulkhead black" = COLOR_WALL_GUNMETAL
		)

	var/list/locker_paint_schemes = list(
		"Fire Control" = "fire",
		"Emergency O2" = "emergency",
		"Medical" = "med",
		"Ops (Mining)" = "miner",
		"Ops (Hangar Tech)" = "hangar_tech",
		"Ops (Machinist)" = "machinist",
		"Hazmat" = "hazmat",
		"Hazmat (Custodial)" = "hazmat_custodial",
		"Engi (Tool)" = "eng_tool",
		"Engi (Rad)" = "eng_rad",
		"Engi (Elec)" = "eng_elec",
		"Engi (Weld)" = "eng_weld",
		"Engi (L2)" = "eng_l2",
		"Atmos" = "atmos",
		"Security" = "sec",
		"Hydroponics" = "hydro"
	)

	var/list/crate_paint_schemes = list(
		"Fire Control" = "fire",
		"Emergency O2" = "o2_crate",
		"Medical" = "medical_crate",
		"Science" = "science_crate",
		"Engi (Tool)" = "eng_tool",
		"Engi (Rad)" = "eng_rad",
		"Engi (Elec)" = "eng_elec",
		"Engi (Weld)" = "eng_weld",
		"Engi (L2)" = "eng_l2",
		"Security" = "security_crate",
		"Contraband Stripes" = "secgear_crate",
		"Hydroponics" = "hydro_crate"
	)

	/// Pipe painting modes
	var/list/modes
	var/mode


/// Initialize available pipe color modes.
/obj/item/paint_sprayer/New()
	..()
	modes = new()
	for(var/C in GLOB.pipe_colors)
		modes += "[C]"
	mode = pick(modes)

/obj/item/paint_sprayer/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Use a paint sprayer on yourself to configure it."
	. += "Paint sprayers can be used on the following targets: floors, walls, windows, window frames, windoors, blast shutters, security cameras, tables, chairs, beds, computers, vending machines, smartfridges, grilles, lattices, catwalks and grates, airlocks, exosuit frames and components, beds, atmos pipes, and (plain grey) lockers/crates."
	. += "CTRL-click a turf or airlock with the paint sprayer to copy the color(s) used on it."
	. += "SHIFT-click a turf with the paint sprayer to clear all decals from it, or to strip the paint from a wall."

/obj/item/paint_sprayer/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "It is configured to produce the '[SPAN_NOTICE(decal)]' decal with a direction of '[SPAN_NOTICE(paint_dir)]' using [SPAN_NOTICE(paint_colour)] paint."

/obj/item/paint_sprayer/update_icon()
	ClearOverlays()
	AddOverlays(overlay_image(icon, "paint_sprayer_color", paint_colour))

/obj/item/paint_sprayer/afterattack(var/atom/A, var/mob/user, proximity, params)
	if(!proximity)
		return

	var/mob/living/heavy_vehicle/ES = A
	if(istype(ES))
		to_chat(user, SPAN_WARNING("You can't paint an active exosuit. Dismantle it first."))
		return

	var/obj/structure/heavy_vehicle_frame/EF = A
	if(istype(EF))
		playsound(get_turf(src), 'sound/effects/spray3.ogg', 30, 1, -6)
		EF.set_colour(paint_colour)
		return

	var/obj/item/mech_component/MC = A
	if(istype(MC))
		playsound(get_turf(src), 'sound/effects/spray3.ogg', 30, 1, -6)
		MC.set_colour(paint_colour)
		return

	var/obj/structure/bed/B = A
	if(istype(B))
		playsound(get_turf(src), 'sound/effects/spray3.ogg', 30, 1, -6)
		if(B.padding_material)
			B.set_colour(paint_colour)
		else
			B.color = paint_colour // No padding to paint, so paint the frame itself.
		B.update_icon()
		return

	else if (istype(A, /obj/structure/machinery/door/airlock))
		return paint_airlock(A, user)

	else if (istype(A, /turf/simulated/floor))
		return paint_floor(A, user, params)

	else if (istype(A, /obj/structure/closet/crate))
		return paint_crate(A, user, params)

	else if (istype(A, /obj/structure/closet))
		return paint_locker(A, user, params)

	else if(istype(A,/obj/structure/machinery/atmospherics/pipe))
		var/obj/structure/machinery/atmospherics/pipe/P = A
		P.change_color(GLOB.pipe_colors[mode])
		playsound(get_turf(src), 'sound/effects/spray3.ogg', 30, 1, -6)

	else if(istype(A, /obj/item/pipe) && pipe_color_check(GLOB.pipe_colors[mode]))
		var/obj/item/pipe/P = A
		P.color = GLOB.pipe_colors[mode]
		playsound(get_turf(src), 'sound/effects/spray3.ogg', 30, 1, -6)

/// Walls can be painted from diagonal tiles too, otherwise walls boxed in by other walls (e.g. the centre of a + shape) can't be reached.
/obj/item/paint_sprayer/proc/can_reach_wall(mob/user, turf/simulated/wall/W)
	return isturf(user.loc) && user.z == W.z && get_dist(user, W) <= 1

/obj/item/paint_sprayer/proc/paint_wall(turf/simulated/wall/W, mob/user)
	if(!can_reach_wall(user, W) || user.incapacitated())
		return FALSE
	if(!W.material)
		to_chat(user, SPAN_WARNING("\The [src] cannot paint this wall."))
		return FALSE
	playsound(get_turf(src), 'sound/effects/spray3.ogg', 30, 1, -6)
	W.color = paint_colour
	W.update_icon()
	add_fingerprint(user)
	to_chat(user, SPAN_NOTICE("You paint \the [W] with \the [src]."))
	return TRUE

/// Paints a window or window frame by recolouring it.
/obj/item/paint_sprayer/proc/paint_colourable(obj/O, mob/user)
	if(!user.Adjacent(O) || user.incapacitated())
		return FALSE
	playsound(get_turf(src), 'sound/effects/spray3.ogg', 30, 1, -6)
	O.color = paint_colour
	O.update_icon()
	add_fingerprint(user)
	to_chat(user, SPAN_NOTICE("You paint \the [O] with \the [src]."))
	return TRUE

/obj/item/paint_sprayer/proc/paint_floor(turf/simulated/floor/F, mob/user, params)
	if(!F.flooring?.can_paint)
		to_chat(user, SPAN_WARNING("\The [src] cannot paint this type of flooring."))
		return

	if(!F.flooring || F.broken || F.burnt)
		to_chat(user, SPAN_WARNING("\The [src] cannot paint damaged or missing tiles."))
		return

	var/list/decal_data = decals[decal]
	var/config_error
	if(!islist(decal_data))
		config_error = 1
	var/painting_decal
	if(!config_error)
		painting_decal = decal_data["path"]
		if(!ispath(painting_decal))
			config_error = 1

	if(config_error)
		to_chat(user, SPAN_WARNING("\The [src] flashes an error light. You might need to reconfigure it."))
		return

	if(F.decals && F.decals.len > 5 && painting_decal != /obj/effect/floor_decal/reset)
		to_chat(user, SPAN_WARNING("\The [F] has been painted too much; you need to clear it off."))
		return

	var/painting_dir = 0
	if(paint_dir == "precise")
		if(!decal_data["precise"])
			painting_dir = user.dir
		else
			var/list/mouse_control = mouse_safe_xy(params)
			var/mouse_x = mouse_control["icon-x"]
			var/mouse_y = mouse_control["icon-y"]
			if(isnum(mouse_x) && isnum(mouse_y))
				if(mouse_x <= 16)
					if(mouse_y <= 16)
						painting_dir = WEST
					else
						painting_dir = NORTH
				else
					if(mouse_y <= 16)
						painting_dir = SOUTH
					else
						painting_dir = EAST
			else
				painting_dir = user.dir
	else if(paint_dirs[paint_dir])
		painting_dir = paint_dirs[paint_dir]

	var/painting_colour
	if(decal_data["coloured"] && paint_colour)
		painting_colour = paint_colour

	playsound(get_turf(src), 'sound/effects/spray3.ogg', 30, 1, -6)
	new painting_decal(F, painting_dir, painting_colour)

/obj/item/paint_sprayer/attack_self(var/mob/user)
	var/choice = tgui_input_list(user, "Do you wish to change: decal type, paint direction, paint colour (for turfs), or pipe colour mode?", "Paint Sprayer", list("Decal","Direction","Colour","Pipe Colour"), 30 SECONDS)
	if(choice == "Decal")
		choose_decal()
	else if(choice == "Direction")
		choose_direction()
	else if(choice == "Colour")
		choose_colour()
	else if(choice == "Pipe Colour")
		choose_pipe_colour()

/obj/item/paint_sprayer/proc/change_colour(new_colour, mob/user)
	if (new_colour)
		paint_colour = new_colour
		if (user)
			add_fingerprint(user)
			to_chat(user, SPAN_NOTICE("You set \the [src] to paint with <span style='color:[paint_colour]'>a new colour</span>."))
		update_icon()
		playsound(src, 'sound/weapons/blade_open.ogg', 30, 1)
		return TRUE
	return FALSE

/turf/simulated/floor/Click(location, control, params)
	if(ishuman(usr) || isrobot(usr))
		var/mob/living/L = usr
		var/list/modifiers = params2list(params)
		var/obj/item/paint_sprayer/paint_sprayer = L.get_active_hand()
		if(istype(paint_sprayer))
			if(!istype(L.buckled_to))
				L.face_atom(src)

			if(modifiers["ctrl"] && paint_sprayer.pick_color(src, L))
				return

			if(modifiers["shift"] && paint_sprayer.remove_paint(src, L))
				return

	. = ..()

/turf/simulated/wall/Click(location, control, params)
	if(ishuman(usr) || isrobot(usr))
		var/mob/living/L = usr
		var/list/modifiers = params2list(params)
		var/obj/item/paint_sprayer/paint_sprayer = L.get_active_hand()
		if(istype(paint_sprayer) && !modifiers["shift"] && !modifiers["ctrl"] && !modifiers["alt"] && get_dist(L, src) == 1 && !L.Adjacent(src))
			// Diagonal wall: normal clicking can't reach it, so paint it directly.
			if(!istype(L.buckled_to))
				L.face_atom(src)
			L.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			paint_sprayer.paint_wall(src, L)
			return
		if(istype(paint_sprayer) && modifiers["shift"])
			if(!istype(L.buckled_to))
				L.face_atom(src)
			if(paint_sprayer.remove_paint(src, L))
				return

	. = ..()

/obj/structure/table/Click(location, control, params)
	if(paint_sprayer_shift_click(src, usr, params))
		return
	. = ..()

/obj/structure/bed/Click(location, control, params)
	if(paint_sprayer_shift_click(src, usr, params))
		return
	. = ..()

/obj/structure/machinery/vending/Click(location, control, params)
	if(paint_sprayer_shift_click(src, usr, params))
		return
	. = ..()

/obj/structure/machinery/smartfridge/Click(location, control, params)
	if(paint_sprayer_shift_click(src, usr, params))
		return
	. = ..()

/obj/structure/grille/Click(location, control, params)
	if(paint_sprayer_shift_click(src, usr, params))
		return
	. = ..()

/obj/structure/lattice/Click(location, control, params)
	if(paint_sprayer_shift_click(src, usr, params))
		return
	. = ..()

/obj/structure/machinery/door/blast/Click(location, control, params)
	if(paint_sprayer_shift_click(src, usr, params))
		return
	. = ..()

/obj/structure/machinery/camera/Click(location, control, params)
	if(paint_sprayer_shift_click(src, usr, params))
		return
	. = ..()

/obj/structure/machinery/door/window/Click(location, control, params)
	if(paint_sprayer_shift_click(src, usr, params))
		return
	. = ..()

/obj/item/modular_computer/Click(location, control, params)
	if(paint_sprayer_shift_click(src, usr, params))
		return
	. = ..()

/obj/structure/machinery/computer/Click(location, control, params)
	if(paint_sprayer_shift_click(src, usr, params))
		return
	. = ..()

/obj/structure/window/Click(location, control, params)
	if(paint_sprayer_shift_click(src, usr, params))
		return
	. = ..()

/obj/structure/window_frame/Click(location, control, params)
	if(paint_sprayer_shift_click(src, usr, params))
		return
	. = ..()

/// Handles shift-clicking an atom with a paint sprayer in hand to strip its paint. Returns TRUE if handled.
/proc/paint_sprayer_shift_click(atom/target, mob/user, params)
	if(!ishuman(user) && !isrobot(user))
		return FALSE
	var/mob/living/L = user
	var/list/modifiers = params2list(params)
	var/obj/item/paint_sprayer/paint_sprayer = L.get_active_hand()
	if(!istype(paint_sprayer) || !modifiers["shift"])
		return FALSE
	if(!istype(L.buckled_to))
		L.face_atom(target)
	return paint_sprayer.remove_paint(target, L)

/obj/item/paint_sprayer/proc/pick_color(atom/A, mob/user)
	if (!user.Adjacent(A) || user.incapacitated())
		return FALSE
	var/new_color
	if (istype(A, /turf/simulated/floor))
		new_color = pick_color_from_floor(A, user)
	else if (istype(A, /obj/structure/machinery/door/airlock))
		new_color = pick_color_from_airlock(A, user)
	if (!change_colour(new_color, user))
		to_chat(user, SPAN_WARNING("\The [A] does not have a colour that you could pick from."))
	return TRUE // There was an attempt to pick a color.

/obj/item/paint_sprayer/proc/pick_color_from_floor(turf/simulated/floor/F, mob/user)
	if (!F.decals || !F.decals.len)
		return FALSE
	var/list/available_colors = list()
	for (var/img in F.decals)
		/// This snowflake code is necessary because for some reason images added to the decals list at roundstart become appearances.
		var/image/I = image(img)
		available_colors |= isnull(I.color) ? COLOR_WHITE : I.color
	var/picked_color = available_colors[1]
	if (available_colors.len > 1)
		picked_color = tgui_input_list(user, "Which color do you wish to pick from?", "Paint Sprayer", available_colors)
		if (user.incapacitated() || !user.Adjacent(F))
			return FALSE
	return picked_color

/obj/item/paint_sprayer/proc/pick_color_from_airlock(obj/structure/machinery/door/airlock/D, mob/user)
	if (!D.paintable)
		return FALSE
	switch (select_airlock_region(D, user, "Where do you wish to pick the color from?"))
		if (AIRLOCK_REGION_PAINT)
			return D.door_color
		if (AIRLOCK_REGION_STRIPE)
			return D.stripe_color
		if (AIRLOCK_REGION_WINDOW)
			return D.window_color
		else
			return FALSE

/obj/item/paint_sprayer/proc/paint_airlock(obj/structure/machinery/door/airlock/D, mob/user)
	if (!D.paintable)
		to_chat(user, SPAN_WARNING("You can't paint this airlock type."))
		return FALSE

	switch (select_airlock_region(D, user, "What do you wish to paint?"))
		if (AIRLOCK_REGION_PAINT)
			D.paint_airlock(paint_colour)
		if (AIRLOCK_REGION_STRIPE)
			D.stripe_airlock(paint_colour)
		if (AIRLOCK_REGION_WINDOW)
			D.paint_window(paint_colour)
		else
			return FALSE
	return TRUE

/obj/item/paint_sprayer/proc/select_airlock_region(obj/structure/machinery/door/airlock/D, mob/user, input_text)
	var/choice
	var/list/choices = list()
	if (D.paintable & AIRLOCK_PAINTABLE_MAIN)
		choices |= AIRLOCK_REGION_PAINT
	if (D.paintable & AIRLOCK_PAINTABLE_STRIPE)
		choices |= AIRLOCK_REGION_STRIPE
	if (D.paintable & AIRLOCK_PAINTABLE_WINDOW)
		choices |= AIRLOCK_REGION_WINDOW
	choice = tgui_input_list(user, input_text, "Paint Sprayer", sortList(choices))
	if (!user.use_check_and_message() || !D || !user.Adjacent(D))
		return FALSE
	return choice

/obj/item/paint_sprayer/proc/remove_paint(atom/A, mob/user)
	if(istype(A, /turf/simulated/wall))
		if(!can_reach_wall(user, A) || user.incapacitated())
			return FALSE
	else if(!user.Adjacent(A) || user.incapacitated())
		return FALSE
	if (istype(A, /turf/simulated/floor))
		var/turf/simulated/floor/F = A
		if (F.decals && F.decals.len > 0)
			F.decals.len--
			F.update_icon()
			. = TRUE
	else if (istype(A, /obj/structure/table))
		var/obj/structure/table/T = A
		T.color = "#ffffff"
		T.update_icon()
		. = TRUE
	else if (istype(A, /obj/structure/bed))
		var/obj/structure/bed/B = A
		B.color = initial(B.color)
		B.painted_colour = null
		B.update_icon()
		. = TRUE
	else if (istype(A, /obj/structure/window) || istype(A, /obj/structure/window_frame) || istype(A, /obj/structure/machinery/computer) || istype(A, /obj/item/modular_computer) || istype(A, /obj/structure/machinery/vending) || istype(A, /obj/structure/machinery/smartfridge) || istype(A, /obj/structure/grille) || istype(A, /obj/structure/lattice) || istype(A, /obj/structure/machinery/door/window) || istype(A, /obj/structure/machinery/door/blast) || istype(A, /obj/structure/machinery/camera))
		var/obj/O = A
		O.color = initial(O.color)
		O.update_icon()
		. = TRUE
	else if (istype(A, /turf/simulated/wall))
		var/turf/simulated/wall/W = A
		if (W.material)
			W.reset_color()
			W.update_icon()
			. = TRUE
	else if (istype(A, /obj/structure/machinery/door/airlock))
		var/obj/structure/machinery/door/airlock/D = A
		if (D.paintable)
			D.paint_airlock(null)
			D.stripe_airlock(null)
			D.paint_window(null)
			. = TRUE
	if (.)
		add_fingerprint(user)
		playsound(get_turf(src), 'sound/effects/spray3.ogg', 30, 1, -6)
	return .

/obj/item/paint_sprayer/verb/choose_colour()
	set name = "Choose Colour"
	set desc = "Choose a paintgun colour."
	set category = "Object.Held"
	set src in usr

	if(usr.incapacitated())
		return
	var/new_colour = input(usr, "Choose a colour.", "Paint Sprayer", paint_colour) as color|null
	change_colour(new_colour, usr)

/obj/item/paint_sprayer/verb/choose_preset_colour()
	set name = "Choose Preset Colour"
	set desc = "Choose a paintgun colour."
	set category = "Object.Held"
	set src in usr

	if(usr.incapacitated())
		return
	var/new_colour = input(usr, "Choose a colour.", "paintgun", paint_colour) as null|anything in preset_colors
	if(new_colour && new_colour != paint_colour)
		paint_colour = preset_colors[new_colour]
		update_icon()
		to_chat(usr, SPAN_NOTICE("You set \the [src] to paint with <font color='[paint_colour]'>a new colour</font>."))

/obj/item/paint_sprayer/verb/choose_decal()
	set name = "Choose Decal"
	set desc = "Choose a paintgun decal."
	set category = "Object.Held"
	set src in usr

	if(usr.incapacitated())
		return

	var/new_decal = tgui_input_list(usr, "Select a decal.", "Paint Sprayer", decals)
	if(new_decal && !isnull(decals[new_decal]))
		decal = new_decal
		to_chat(usr, SPAN_NOTICE("You set \the [src] decal to '[decal]'."))

/obj/item/paint_sprayer/verb/choose_direction()
	set name = "Choose Direction"
	set desc = "Choose a paintgun direction."
	set category = "Object.Held"
	set src in usr

	if(usr.incapacitated())
		return

	var/new_dir = tgui_input_list(usr, "Select a direction.", "Paint Sprayer", paint_dirs)
	if(new_dir && !isnull(paint_dirs[new_dir]))
		paint_dir = new_dir
		to_chat(usr, SPAN_NOTICE("You set \the [src] direction to '[paint_dir]'."))

/obj/item/paint_sprayer/verb/choose_pipe_colour(var/mob/user)
	mode = tgui_input_list(user, "Choose a colour.", "Pipe Painter", modes, mode)

/obj/item/paint_sprayer/proc/paint_locker(obj/structure/closet/target_closet, mob/user, input_text)
	if(!target_closet.can_label)
		to_chat(user, SPAN_NOTICE("This container has already been painted."))
		return FALSE
	var/paint_job = tgui_input_list(usr, "Choose locker paint scheme.", "Paint Sprayer", locker_paint_schemes)
	if(paint_job)
		var/new_icon_state = locker_paint_schemes[paint_job]
		target_closet.paint_container(new_icon_state)
		playsound(get_turf(src), 'sound/effects/spray3.ogg', 30, 1, -6)
	return TRUE

/obj/item/paint_sprayer/proc/paint_crate(obj/structure/closet/crate/target_crate, mob/user, input_text)
	if(!target_crate.can_label)
		to_chat(user, SPAN_NOTICE("This container has already been painted."))
		return FALSE
	var/paint_job = tgui_input_list(usr, "Choose crate paint scheme.", "Paint Sprayer", crate_paint_schemes)
	if(paint_job)
		var/new_icon_state = crate_paint_schemes[paint_job]
		target_crate.paint_container(new_icon_state)
		playsound(get_turf(src), 'sound/effects/spray3.ogg', 30, 1, -6)
	. = TRUE

#undef AIRLOCK_REGION_PAINT
#undef AIRLOCK_REGION_STRIPE


// Pipe painter still exists but only as offsite flavor.
/obj/item/pipe_painter
	name = "pipe painter"
	icon = 'icons/obj/item/paint_sprayer.dmi'
	icon_state = "pipe_painter"
	item_state = "pipe_painter"
	var/list/modes
	var/mode

/obj/item/pipe_painter/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	. +=  "It is in [mode] mode."

/obj/item/pipe_painter/New()
	..()
	modes = new()
	for(var/C in GLOB.pipe_colors)
		modes += "[C]"
	mode = pick(modes)

/obj/item/pipe_painter/afterattack(var/atom/A, var/mob/user, proximity)
	if(!proximity)
		return
	if(!in_range(user, A))
		return
	else if(is_type_in_list(A, list(/obj/structure/machinery/atmospherics/pipe/tank, /obj/structure/machinery/atmospherics/pipe/simple/heat_exchanging)))
		return
	else if(istype(A,/obj/structure/machinery/atmospherics/pipe))
		var/obj/structure/machinery/atmospherics/pipe/P = A
		P.change_color(GLOB.pipe_colors[mode])
	else if(istype(A, /obj/item/pipe) && pipe_color_check(GLOB.pipe_colors[mode]))
		var/obj/item/pipe/P = A
		P.color = GLOB.pipe_colors[mode]

/obj/item/pipe_painter/attack_self(var/mob/user)
	mode = tgui_input_list(user, "Which colour do you want to use?", "Pipe Painter", modes, mode)

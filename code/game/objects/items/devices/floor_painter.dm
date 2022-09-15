/obj/item/device/floor_painter
	name = "paint gun"
	desc = "A Hephaestus-made paint gun that uses microbes to replenish its paint storage. Very high-tech and fancy too!"
	desc_info = "Use control-click on a coloured decal on a turf to copy its colour. You can also use shift-click on a turf with the paint gun in hand to clear all decals on it."
	icon = 'icons/obj/item/device/floor_painter.dmi'
	icon_state = "floor_painter"
	item_state = "floor_painter"
	contained_sprite = TRUE
	var/decal =        "remove all decals"
	var/paint_dir =    "precise"
	var/paint_colour = COLOR_WHITE

	var/list/decals = list(
		"quarter-turf" =      list("path" = /obj/effect/floor_decal/corner, "precise" = 1, "coloured" = 1),
		"full quarter-turf" = list("path" = /obj/effect/floor_decal/corner_full, "precise" = 1, "coloured" = 1),
		"light corner" = list("path" = /obj/effect/floor_decal/corner/light, "precise" = 1, "coloured" = 1),
		"full light corner" = list("path" = /obj/effect/floor_decal/corner/light/full, "precise" = 1, "coloured" = 1),
		"light, wide corner" = list("path" = /obj/effect/floor_decal/corner_wide/light, "precise" = 1, "coloured" = 1),
		"full, light, wide corner" = list("path" = /obj/effect/floor_decal/corner_wide/light/full, "precise" = 1, "coloured" = 1),
		"hazard stripes" =    list("path" = /obj/effect/floor_decal/industrial/warning),
		"corner, hazard" =    list("path" = /obj/effect/floor_decal/industrial/warning/corner),
		"hatched marking" =   list("path" = /obj/effect/floor_decal/industrial/hatch, "coloured" = 1),
		"dotted outline" =    list("path" = /obj/effect/floor_decal/industrial/outline, "coloured" = 1),
		"loading sign" =      list("path" = /obj/effect/floor_decal/industrial/loading),
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

/obj/item/device/floor_painter/afterattack(var/atom/A, var/mob/user, proximity, params)

	if(!proximity)
		return

	var/mob/living/heavy_vehicle/ES = A
	if(istype(ES))
		to_chat(user, "<span class='warning'>You can't paint an active exosuit. Dismantle it first.</span>")
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
		B.set_colour(paint_colour)
		B.update_icon()
		return

	var/turf/simulated/floor/F = A
	if(!istype(F))
		to_chat(user, "<span class='warning'>\The [src] can only be used on station flooring.</span>")
		return

	if(!F.flooring || !F.flooring.can_paint || F.broken || F.burnt)
		to_chat(user, "<span class='warning'>\The [src] cannot paint broken or missing tiles.</span>")
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
		to_chat(user, "<span class='warning'>\The [src] flashes an error light. You might need to reconfigure it.</span>")
		return

	if(F.decals && F.decals.len > 5 && painting_decal != /obj/effect/floor_decal/reset)
		to_chat(user, "<span class='warning'>\The [F] has been painted too much; you need to clear it off.</span>")
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

/obj/item/device/floor_painter/attack_self(var/mob/user)
	var/choice = input("Do you wish to change the decal type, paint direction, or paint colour?") as null|anything in list("Decal","Direction", "Colour")
	if(choice == "Decal")
		choose_decal()
	else if(choice == "Direction")
		choose_direction()
	else if(choice == "Colour")
		choose_colour()

/obj/item/device/floor_painter/proc/change_colour(new_colour, mob/user)
	if (new_colour)
		paint_colour = new_colour
		if (user)
			add_fingerprint(user)
			to_chat(user, SPAN_NOTICE("You set \the [src] to paint with <span style='color:[paint_colour]'>a new color</span>."))
		update_icon()
		playsound(src, 'sound/weapons/blade_open.ogg', 30, 1)
		return TRUE
	return FALSE

/turf/simulated/floor/Click(location, control, params)
	if(ishuman(usr))
		var/mob/living/carbon/human/H = usr
		var/list/modifiers = params2list(params)
		var/obj/item/device/floor_painter/paint_sprayer = H.get_active_hand()
		if(istype(paint_sprayer))
			if(!istype(H.buckled_to))
				H.face_atom(src)
			if(modifiers["ctrl"] && paint_sprayer.pick_color(src, H))
				return
			if(modifiers["shift"] && paint_sprayer.remove_paint(src, H))
				return
	. = ..()

/obj/item/device/floor_painter/proc/pick_color(atom/A, mob/user)
	if (!user.Adjacent(A) || user.incapacitated())
		return FALSE
	var/new_color
	if (istype(A, /turf/simulated/floor))
		new_color = pick_color_from_floor(A, user)
	if (!change_colour(new_color, user))
		to_chat(user, SPAN_WARNING("\The [A] does not have a colour that you could pick from."))
	return TRUE // There was an attempt to pick a color.

/obj/item/device/floor_painter/proc/pick_color_from_floor(turf/simulated/floor/F, mob/user)
	if (!F.decals || !F.decals.len)
		return FALSE
	var/list/available_colors = list()
	for (var/image/I in F.decals)
		available_colors |= isnull(I.color) ? COLOR_WHITE : I.color
	var/picked_color = available_colors[1]
	if (available_colors.len > 1)
		picked_color = input(user, "Which color do you wish to pick from?") as null|anything in available_colors
		if (user.incapacitated() || !user.Adjacent(F))
			return FALSE
	return picked_color

/obj/item/device/floor_painter/proc/remove_paint(atom/A, mob/user)
	if(!user.Adjacent(A) || user.incapacitated())
		return FALSE
	if (istype(A, /turf/simulated/floor))
		var/turf/simulated/floor/F = A
		if (F.decals && F.decals.len > 0)
			F.decals.len--
			F.update_icon()
			. = TRUE
	if (.)
		add_fingerprint(user)
		playsound(get_turf(src), 'sound/effects/spray3.ogg', 30, 1, -6)
	return .

/obj/item/device/floor_painter/examine(mob/user)
	. = ..(user)
	to_chat(user, "It is configured to produce the '[decal]' decal with a direction of '[paint_dir]' using [paint_colour] paint.")

/obj/item/device/floor_painter/verb/choose_colour()
	set name = "Choose Colour"
	set desc = "Choose a paintgun colour."
	set category = "Object"
	set src in usr

	if(usr.incapacitated())
		return
	var/new_colour = input(usr, "Choose a colour.", "paintgun", paint_colour) as color|null
	change_colour(new_colour, usr)

/obj/item/device/floor_painter/verb/choose_preset_colour()
	set name = "Choose Preset Colour"
	set desc = "Choose a paintgun colour."
	set category = "Object"
	set src in usr

	if(usr.incapacitated())
		return
	var/new_colour = input(usr, "Choose a colour.", "paintgun", paint_colour) as color|anything in preset_colors
	if(new_colour && new_colour != paint_colour)
		paint_colour = preset_colors[new_colour]
		to_chat(usr, "<span class='notice'>You set \the [src] to paint with <font color='[paint_colour]'>a new colour</font>.</span>")

/obj/item/device/floor_painter/verb/choose_decal()
	set name = "Choose Decal"
	set desc = "Choose a paintgun decal."
	set category = "Object"
	set src in usr

	if(usr.incapacitated())
		return

	var/new_decal = input("Select a decal.") as null|anything in decals
	if(new_decal && !isnull(decals[new_decal]))
		decal = new_decal
		to_chat(usr, "<span class='notice'>You set \the [src] decal to '[decal]'.</span>")

/obj/item/device/floor_painter/verb/choose_direction()
	set name = "Choose Direction"
	set desc = "Choose a paintgun direction."
	set category = "Object"
	set src in usr

	if(usr.incapacitated())
		return

	var/new_dir = input("Select a direction.") as null|anything in paint_dirs
	if(new_dir && !isnull(paint_dirs[new_dir]))
		paint_dir = new_dir
		to_chat(usr, "<span class='notice'>You set \the [src] direction to '[paint_dir]'.</span>")

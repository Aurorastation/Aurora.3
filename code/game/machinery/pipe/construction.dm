/obj/item/pipe
	name = "pipe"
	desc = "A pipe"
	var/pipe_type = 0
	//var/pipe_dir = 0
	var/pipename
	var/connect_types = CONNECT_TYPE_REGULAR
	force = 16
	icon = 'icons/obj/pipe-item.dmi'
	icon_state = "simple"
	item_state = "buildpipe"
	randpixel = 5
	w_class = WEIGHT_CLASS_NORMAL
	level = 2
	obj_flags = OBJ_FLAG_ROTATABLE
	dir = SOUTH
	var/constructed_path = /obj/machinery/atmospherics/pipe/simple/hidden
	var/pipe_class = PIPE_CLASS_BINARY
	var/rotate_class = PIPE_ROTATE_STANDARD

/obj/item/pipe/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	var/pipe_color_check = color || PIPE_COLOR_GREY
	var/found_color_name = "Unknown"
	for(var/color_name in GLOB.pipe_colors)
		var/color_value = GLOB.pipe_colors[color_name]
		if(pipe_color_check == color_value)
			found_color_name = color_name
			break
	. += "This pipe is: <span style='color:[pipe_color_check == PIPE_COLOR_GREY ? COLOR_GRAY : pipe_color_check]'>[capitalize(found_color_name)]</span>"

/obj/item/pipe/Initialize(mapload, obj/machinery/atmospherics/make_from)
	. = ..(mapload, null)
	if(!make_from)
		return
	if(!make_from.dir)
		set_dir(SOUTH)
	else
		set_dir(make_from.dir)
	name = make_from.name
	desc = make_from.desc
	desc_extended = make_from.desc_extended
	desc_mechanics = make_from.desc_mechanics

	connect_types = make_from.connect_types
	color = make_from.pipe_color
	icon = make_from.build_icon
	icon_state = make_from.build_icon_state
	pipe_class = make_from.pipe_class
	rotate_class = make_from.rotate_class
	constructed_path = make_from.type

	randpixel_xy()

//called when a turf is attacked with a pipe item
/obj/item/pipe/afterattack(turf/simulated/floor/target, mob/user, proximity)
	if(!proximity)
		return
	if(isfloor(target))
		user.unEquip(src, target)
		return TRUE
	else
		return ..()

/obj/item/pipe/rotate(mob/user, anchored_ignore)
	. = ..()
	sanitize_dir()

/obj/item/pipe/Move(atom/newloc, direct, glide_size_override = 0, update_dir = TRUE)
	var/old_dir = dir
	. = ..()
	set_dir(old_dir)

/obj/item/pipe/proc/sanitize_dir()
	switch(rotate_class)
		if(PIPE_ROTATE_TWODIR)
			if(dir==2)
				set_dir(1)
			else if(dir==8)
				set_dir(4)
		if(PIPE_ROTATE_ONEDIR)
			set_dir(2)

/obj/item/pipe/attack_self(mob/user)
	return rotate(user)

/obj/item/pipe/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.tool_behaviour != TOOL_WRENCH)
		return ..()
	if (!isturf(loc))
		return ITEM_INTERACT_BLOCKING
	construct_pipe(user)
	return ITEM_INTERACT_SUCCESS

/obj/item/pipe/proc/construct_pipe(mob/user)
	sanitize_dir()
	var/obj/machinery/atmospherics/fake_machine = constructed_path
	var/pipe_dir = base_pipe_initialize_directions(dir, initial(fake_machine.connect_dir_type))

	for(var/obj/machinery/atmospherics/M in loc)
		if((M.initialize_directions & pipe_dir) && M.check_connect_types_construction(M,src))	// matches at least one direction on either type of pipe & same connection type
			loc.balloon_alert(user, "already same type pipe!")
			return
	// no conflicts found

	var/obj/machinery/atmospherics/pipe = new constructed_path(get_turf(src))

	pipe.pipe_color = color
	pipe.set_dir(dir)
	pipe.set_initial_level()
	pipe.build()
	. = pipe

	playsound(loc, 'sound/items/Ratchet.ogg', 50, 1)
	user.balloon_alert_to_viewers("fastened", "pipe fastened")
	qdel(src)	// remove the pipe item

/obj/item/machine_chassis
	var/build_type

/obj/item/machine_chassis/attackby(obj/item/attacking_item, mob/user, params)
	if(attacking_item.tool_behaviour != TOOL_WRENCH)
		return ..()
	if (!isturf(loc))
		return ITEM_INTERACT_BLOCKING
	var/obj/machinery/machine = new build_type(get_turf(src), dir, FALSE)
	machine.RefreshParts()
	playsound(loc, 'sound/items/Ratchet.ogg', 50, 1)
	user.balloon_alert_to_viewers("fastened", "[name] fastened")
	qdel(src)
	return ITEM_INTERACT_SUCCESS

/obj/item/machine_chassis/air_sensor
	name = "gas sensor"
	desc = "A sensor. It detects gasses."
//	icon = 'icons/obj/structures/airfilter.dmi'
	icon_state = "gsensor1"
	w_class = WEIGHT_CLASS_BULKY
	build_type = /obj/machinery/air_sensor

/obj/item/machine_chassis/pipe_meter
	name = "meter"
	desc = "A meter that can measure gas inside pipes or in the general area."
	icon = 'icons/obj/pipe-item.dmi'
	icon_state = "meter"
	item_state = "buildpipe"
	w_class = WEIGHT_CLASS_BULKY
	build_type = /obj/machinery/meter

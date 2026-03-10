ABSTRACT_TYPE(/obj/machinery/atmospherics/pipe)
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED
	var/datum/gas_mixture/air_temporary // used when reconstructing a pipeline that broke
	var/datum/pipeline/parent
	var/volume = 0
	/// Whether the pipe is leaking or not.
	/// DO NOT SET OR READ DIRECTLY
	/// use [set_leaking(TRUE/FALSE)] or [is_leaking()]
	VAR_PRIVATE/leaking = FALSE
	force = 25

	use_power = POWER_USE_OFF

	var/maximum_pressure = ATMOS_DEFAULT_MAX_PRESSURE
	var/fatigue_pressure = ATMOS_DEFAULT_FATIGUE_PRESSURE
	var/alert_pressure = ATMOS_DEFAULT_ALERT_PRESSURE
	//minimum pressure before check_pressure(...) should be called

	can_buckle = TRUE
	buckle_require_restraints = TRUE
	buckle_lying = -TRUE
	pipe_class = PIPE_CLASS_BINARY
	build_icon_state = "simple"
	build_icon = 'icons/obj/pipe-item.dmi'
	interact_offline = TRUE

	// Type of burstpipe to use on burst()
	var/burst_type = /obj/machinery/atmospherics/pipe/burst/standard

	///The sound this pipe will emit while leaking
	var/leak_looping_sound_type = /datum/looping_sound/pipe_leak

	///The looping sound used during pipe leakage
	VAR_PRIVATE/datum/looping_sound/leak_looping_sound

/obj/machinery/atmospherics/pipe/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "This pipe, and all other pipes, can be safely connected or disconnected by a pipe wrench. The internal pressure of the pipe must \
	be below 300 kPa to do this."
	. += "Using a regular wrench on a pressurized pipe is not a good idea."
	. += "Special pipe types, like Supply, Scrubber, Fuel, and Aux, will not connect to normal pipes or to each other. If you want to connect them, use \
	a Universal Adapter pipe."
	. += "Use an Analyzer on a pipe to get details on its contents."

/obj/machinery/atmospherics/pipe/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	var/pipe_color_check = pipe_color || PIPE_COLOR_GREY
	var/found_color_name = "Unknown"
	for(var/color_name in GLOB.pipe_colors)
		var/color_value = GLOB.pipe_colors[color_name]
		if(pipe_color_check == color_value)
			found_color_name = color_name
			break
	. += "This pipe is: <span style='color:[pipe_color_check == PIPE_COLOR_GREY ? COLOR_GRAY : pipe_color_check]'>[capitalize(found_color_name)]</span>"

/obj/machinery/atmospherics/pipe/drain_power()
	return -1

/obj/machinery/atmospherics/pipe/Initialize(mapload)
	if(istype(get_turf(src), /turf/simulated/wall) || istype(get_turf(src), /turf/unsimulated/wall))
		level = 1
	. = ..()
	if(!mapload)
		return INITIALIZE_HINT_NORMAL

/obj/machinery/atmospherics/pipe/hides_under_flooring()
	return level != 2

// TODO: ATOM HEALTH
///obj/machinery/atmospherics/pipe/on_death()
//	burst()

/obj/machinery/atmospherics/pipe/proc/set_leaking(new_leaking)
	if(new_leaking && !leaking)
		START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
		leaking = TRUE
		if(parent)
			parent.leaks |= src
			if(parent.network)
				parent.network.leaks |= src
	else if (!new_leaking && leaking)
		STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
		leaking = FALSE
		if(parent)
			parent.leaks -= src
			if(parent.network)
				parent.network.leaks -= src

/obj/machinery/atmospherics/pipe/proc/is_leaking()
	return leaking

/obj/machinery/atmospherics/pipe/proc/update_sound(playing)
	if(playing && !leak_looping_sound)
		//Start the leak looping sound
		leak_looping_sound = new leak_looping_sound_type(src)
		leak_looping_sound.start()
	else if (!playing)
		// Stop it
		leak_looping_sound?.stop()
		QDEL_NULL(leak_looping_sound)

/obj/machinery/atmospherics/pipe/atmos_init()
	qdel(parent)
	..()
	var/turf/T = loc
	if(level == 1 && isturf(T) && !T.is_plating())
		hide(TRUE)

/obj/machinery/atmospherics/pipe/proc/try_leak()
	var/missing = FALSE
	for(var/direction in GLOB.cardinals)
		if((direction & initialize_directions) && !length(nodes_in_dir(direction)))
			missing = TRUE
			break
	set_leaking(missing)

/obj/machinery/atmospherics/pipe/hide(var/i)
	var/turf/turf = loc
	if(istype(turf, /turf/simulated))
		set_invisibility(i ? INVISIBILITY_ABSTRACT : 0)
	queue_icon_update()

/obj/machinery/atmospherics/pipe/proc/pipeline_expansion()
	return nodes_to_networks || list()

/obj/machinery/atmospherics/pipe/proc/check_pressure(pressure)
	//Return 1 if parent should continue checking other pipes
	//Return null if parent should stop checking other pipes. Recall: qdel(src) will by default return null

	return 1

/obj/machinery/atmospherics/pipe/return_air()
	if(!parent)
		parent = new /datum/pipeline()
		parent.build_pipeline(src)

	return parent.air

/obj/machinery/atmospherics/pipe/build_network()
	if(!parent)
		parent = new /datum/pipeline()
		parent.build_pipeline(src)

	return parent.return_network()

/obj/machinery/atmospherics/pipe/network_expand(datum/pipe_network/new_network, obj/machinery/atmospherics/pipe/reference)
	if(!parent)
		parent = new /datum/pipeline()
		parent.build_pipeline(src)

	return parent.network_expand(new_network, reference)

/obj/machinery/atmospherics/pipe/return_network(obj/machinery/atmospherics/reference)
	if(!parent)
		parent = new /datum/pipeline()
		parent.build_pipeline(src)

	return parent.return_network(reference)

/obj/machinery/atmospherics/pipe/Destroy()
	QDEL_NULL(parent)
	QDEL_NULL(leak_looping_sound)
	if(air_temporary)
		loc?.assume_air(air_temporary)
		air_temporary = null
	if(leaking)
		STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)

	. = ..()

/obj/machinery/atmospherics/pipe/attackby(obj/item/attacking_item, mob/user)
	//if (istype(src, /obj/machinery/atmospherics/unary/tank))
		//return ..()

	if(istype(attacking_item, /obj/item/analyzer) && Adjacent(user))
		var/obj/item/analyzer/A = attacking_item
		A.analyze_gases(src, user)
		return FALSE

	if (attacking_item.tool_behaviour != TOOL_WRENCH && !istype(attacking_item, /obj/item/pipewrench))
		return ..()
	var/turf/T = src.loc
	if (level==1 && isturf(T) && !T.is_plating())
		to_chat(user, SPAN_WARNING("You must remove the plating first!"))
		return TRUE

	var/datum/gas_mixture/int_air = return_air()
	var/datum/gas_mixture/env_air = loc?.return_air()

	if ((XGM_PRESSURE(int_air)-XGM_PRESSURE(env_air)) > PRESSURE_EXERTED)
		if(!istype(attacking_item, /obj/item/pipewrench))
			to_chat(user, SPAN_WARNING("You cannot unwrench \the [src], it is too exerted due to internal pressure."))
			add_fingerprint(user)
			return TRUE
		else
			to_chat(user, SPAN_WARNING("You struggle to unwrench \the [src] with your pipe wrench."))
	to_chat(user, SPAN_NOTICE("You begin to unfasten \the [src]..."))
	if(attacking_item.use_tool(src, user, istype(attacking_item, /obj/item/pipewrench) ? 80 : 40, volume = 50))
		user.visible_message( \
			SPAN_NOTICE("\The [user] unfastens \the [src]."), \
			SPAN_NOTICE("You have unfastened \the [src]."), \
			"You hear a ratchet.")
		new /obj/item/pipe(loc, src)
		qdel(src)
		return TRUE

/obj/machinery/atmospherics/proc/change_color(new_color)
	pipe_color = new_color
	update_icon()

/obj/machinery/atmospherics/pipe/color_cache_name(var/obj/machinery/atmospherics/node)
	if(istype(src, /obj/machinery/atmospherics/unary/tank))
		return ..()

	if(istype(node, /obj/machinery/atmospherics/pipe/manifold) || istype(node, /obj/machinery/atmospherics/pipe/manifold4w))
		if(pipe_color == node.pipe_color)
			return node.pipe_color
		else
			return null
	else if(istype(node, /obj/machinery/atmospherics/pipe/simple))
		return node.pipe_color
	else
		return pipe_color

/obj/machinery/pipe/dismantle()
	for(var/obj/machinery/meter/meter in get_turf(src))
		if(meter.target == src)
			meter.dismantle()
	..()

/obj/machinery/atmospherics/pipe/simple
	icon = 'icons/atmos/pipes.dmi'
	icon_state = "11"
	name = "pipe"
	desc = "A one meter section of regular pipe"

	volume = ATMOS_DEFAULT_VOLUME_PIPE

	dir = SOUTH
	initialize_directions = SOUTH|NORTH

	var/minimum_temperature_difference = 300
	var/thermal_conductivity = 0 //WALL_HEAT_TRANSFER_COEFFICIENT No

	level = 1
	gfi_layer_rotation = GFI_ROTATION_DEFDIR

	rotate_class = PIPE_ROTATE_TWODIR
	connect_dir_type = SOUTH | NORTH

/obj/machinery/atmospherics/pipe/simple/Initialize(mapload)
	. = ..()
	if(mapload)
		var/turf/T = loc
		var/image/I = image(icon, T, icon_state, dir, pixel_x, pixel_y)
		I.plane = ABOVE_LIGHTING_PLANE
		I.color = color
		I.alpha = 125
		LAZYADD(T.blueprints, I)

/obj/machinery/atmospherics/pipe/process()
	if(!parent || !loc) //This should cut back on the overhead calling build_network thousands of times per cycle
		..()
	else if(parent.air?.compare(loc.return_air()))
		update_sound(FALSE)
		. = PROCESS_KILL
	else if(leaking)
		parent.mingle_with_turf(loc, volume)
		var/air = XGM_PRESSURE(parent.air)
		if(air)
			update_sound(TRUE)
		else
			update_sound(FALSE)
	else
		. = PROCESS_KILL

/obj/machinery/atmospherics/pipe/simple/check_pressure(pressure)
	// Don't ask me, it happened somehow.
	if(!isturf(loc))
		return TRUE

	var/datum/gas_mixture/environment = loc.return_air()

	var/pressure_difference = pressure - XGM_PRESSURE(environment)

	if(pressure_difference > maximum_pressure)
		burst()

	else if(pressure_difference > fatigue_pressure)
		set_leaking(TRUE)
		if(prob(5))
			burst()
		else return TRUE

	else
		set_leaking(FALSE)
		return TRUE

/obj/machinery/atmospherics/pipe/proc/burst()
	parent?.temporarily_store_air()
	src.visible_message(SPAN_DANGER("\The [src] bursts!"), SPAN_DANGER("You hear a loud bang."));
	playsound(src.loc, 'sound/effects/bang.ogg', 25, 1)
	var/datum/effect/effect/system/smoke_spread/smoke = new
	smoke.set_up(1,0, src.loc, 0)
	smoke.start()
	var/turf/T=get_turf(src)
	var/area/A=get_area(src)
	message_admins("Pipe burst at location [ADMIN_VERBOSEJMP(T)].")
	log_game("Pipe burst in area [A.name]")

// TODO: Finish Icons
//	// Disconnect first.
//	for(var/obj/machinery/atmospherics/node as anything in nodes_to_networks)
//		QDEL_NULL(nodes_to_networks[node])
//		node.disconnect(src)
//	LAZYNULL(nodes_to_networks)

//	for(var/direction in GLOB.cardinals)
//		if(initialize_directions & direction)
//			var/obj/machinery/atmospherics/pipe/burst/broken_pipe = new burst_type(loc, direction, connect_types)
//			broken_pipe.color = src.color

	qdel(src)

/obj/machinery/atmospherics/pipe/simple/update_icon()
	if(!atmos_initialised)
		return

	alpha = 255

	ClearOverlays()

	var/integrity_key = ""
	for(var/direction in GLOB.cardinals) // go through initialize directions in flag order, add "1" if there's a node and "0" if not, that's the key
		if(!(direction & initialize_directions))
			continue
		integrity_key += "[!!length(nodes_in_dir(direction))]"

	icon_state = "[integrity_key][icon_connect_type]"
	color = pipe_color
	var/mutable_appearance/emissive_base_blocker = emissive_blocker(icon, "[integrity_key][icon_connect_type]")
	emissive_base_blocker.dir = src.dir
	AddOverlays(emissive_base_blocker)

	try_leak()

/obj/machinery/atmospherics/pipe/simple/visible
	level = 2

/obj/machinery/atmospherics/pipe/simple/visible/scrubbers
	name = "Scrubbers pipe"
	desc = "A one meter section of scrubbers pipe."
	icon_state = "11-scrubbers"
	connect_types = CONNECT_TYPE_SCRUBBER
	icon_connect_type = "-scrubbers"
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/simple/visible/supply
	name = "Air supply pipe"
	desc = "A one meter section of supply pipe"
	icon_state = "11-supply"
	connect_types = CONNECT_TYPE_SUPPLY
	icon_connect_type = "-supply"
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/simple/visible/fuel
	name = "Fuel pipe"
	desc = "A one meter section of fuel pipe."
	icon_state = "11-fuel"
	connect_types = CONNECT_TYPE_FUEL
	icon_connect_type = "-fuel"
	color = PIPE_COLOR_YELLOW

/obj/machinery/atmospherics/pipe/simple/visible/aux
	name = "Auxiliary pipe"
	desc = "A one meter section of auxiliary pipe."
	icon_state = "11-aux"
	connect_types = CONNECT_TYPE_AUX
	icon_connect_type = "-aux"
	color = PIPE_COLOR_CYAN

/obj/machinery/atmospherics/pipe/simple/visible/yellow
	color = PIPE_COLOR_YELLOW

/obj/machinery/atmospherics/pipe/simple/visible/cyan
	color = PIPE_COLOR_CYAN

/obj/machinery/atmospherics/pipe/simple/visible/green
	color = PIPE_COLOR_GREEN

/obj/machinery/atmospherics/pipe/simple/visible/black
	color = PIPE_COLOR_BLACK

/obj/machinery/atmospherics/pipe/simple/visible/red
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/simple/visible/blue
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/simple/visible/purple
	color = PIPE_COLOR_PURPLE

/obj/machinery/atmospherics/pipe/simple/hidden
	level = 1
	alpha = 128		//set for the benefit of mapping - this is reset to opaque when the pipe is spawned in game

/obj/machinery/atmospherics/pipe/simple/hidden/scrubbers
	name = "Scrubbers pipe"
	desc = "A one meter section of scrubbers pipe."
	icon_state = "11-scrubbers"
	connect_types = CONNECT_TYPE_SCRUBBER
	icon_connect_type = "-scrubbers"
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/simple/hidden/supply
	name = "Air supply pipe"
	desc = "A one meter section of supply pipe."
	icon_state = "11-supply"
	connect_types = CONNECT_TYPE_SUPPLY
	icon_connect_type = "-supply"
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/simple/hidden/fuel
	name = "Fuel pipe"
	desc = "A one meter section of fuel pipe."
	icon_state = "11-fuel"
	connect_types = CONNECT_TYPE_FUEL
	icon_connect_type = "-fuel"
	color = PIPE_COLOR_YELLOW

/obj/machinery/atmospherics/pipe/simple/hidden/aux
	name = "Auxiliary pipe"
	desc = "A one meter section of auxiliary pipe."
	icon_state = "11-aux"
	connect_types = CONNECT_TYPE_AUX
	icon_connect_type = "-aux"
	color = PIPE_COLOR_CYAN

/obj/machinery/atmospherics/pipe/simple/hidden/yellow
	color = PIPE_COLOR_YELLOW

/obj/machinery/atmospherics/pipe/simple/hidden/cyan
	color = PIPE_COLOR_CYAN

/obj/machinery/atmospherics/pipe/simple/hidden/green
	color = PIPE_COLOR_GREEN

/obj/machinery/atmospherics/pipe/simple/hidden/black
	color = PIPE_COLOR_BLACK

/obj/machinery/atmospherics/pipe/simple/hidden/red
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/simple/hidden/blue
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/simple/hidden/purple
	color = PIPE_COLOR_PURPLE

/obj/machinery/atmospherics/pipe/manifold
	name = "pipe manifold"
	desc = "A manifold composed of regular pipes."
	icon = 'icons/atmos/manifold.dmi'
	icon_state = "map"

	volume = ATMOS_DEFAULT_VOLUME_PIPE * 1.5

	dir = SOUTH
	initialize_directions = EAST|NORTH|WEST

	var/obj/machinery/atmospherics/node3
	build_icon_state = "manifold"

	level = 1

	pipe_class = PIPE_CLASS_TRINARY
	connect_dir_type = NORTH | EAST | WEST

	gfi_layer_rotation = GFI_ROTATION_OVERDIR

/obj/machinery/atmospherics/pipe/manifold/Initialize(mapload)
	if(mapload)
		var/turf/T = loc
		var/image/I = image(icon, T, icon_state, dir, pixel_x, pixel_y)
		I.plane = ABOVE_LIGHTING_PLANE
		I.color = pipe_color
		I.alpha = 125
		LAZYADD(T.blueprints, I)

	alpha = 255
	. = ..()

/obj/machinery/atmospherics/pipe/manifold/update_icon()
	if(!atmos_initialised)
		return

	icon_state = null
	ClearOverlays()
	var/list/base_overlays = list()
	var/mutable_appearance/connect_icon = mutable_appearance(icon, "core[icon_connect_type]")
	connect_icon.color = pipe_color
	base_overlays += connect_icon
	var/mutable_appearance/emissive_base_blocker = emissive_blocker(icon, "core[icon_connect_type]")
	base_overlays += emissive_base_blocker
	var/mutable_appearance/clamps_icon = mutable_appearance(icon, "clamps[icon_connect_type]")
	base_overlays += clamps_icon
	var/mutable_appearance/emissive_clamps_blocker = emissive_blocker(icon, "clamps[icon_connect_type]")
	base_overlays += emissive_clamps_blocker
	AddOverlays(base_overlays)

	underlays.Cut()
	for(var/direction in GLOB.cardinals)
		if(!(direction & initialize_directions))
			continue
		var/list/check_nodes = nodes_in_dir(direction)
		add_underlay(get_turf(src), length(check_nodes) && check_nodes[1], direction, icon_connect_type, icon = 'icons/atmos/manifold_underlays.dmi')

	try_leak()

/obj/machinery/atmospherics/pipe/manifold/visible
	icon_state = "map"
	level = 2

/obj/machinery/atmospherics/pipe/manifold/visible/scrubbers
	name = "scrubbers pipe manifold"
	desc = "A manifold composed of scrubbers pipes"
	icon_state = "map-scrubbers"
	connect_types = CONNECT_TYPE_SCRUBBER
	icon_connect_type = "-scrubbers"
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/manifold/visible/supply
	name = "air supply pipe manifold"
	desc = "A manifold composed of supply pipes."
	icon_state = "map-supply"
	connect_types = CONNECT_TYPE_SUPPLY
	icon_connect_type = "-supply"
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/manifold/visible/fuel
	name = "fuel pipe manifold"
	desc = "A manifold composed of fuel piping."
	icon_state = "map-fuel"
	connect_types = CONNECT_TYPE_FUEL
	icon_connect_type = "-fuel"
	color = PIPE_COLOR_YELLOW

/obj/machinery/atmospherics/pipe/manifold/visible/aux
	name = "auxiliary pipe manifold"
	desc = "A manifold composed of auxiliary piping."
	icon_state = "map-aux"
	connect_types = CONNECT_TYPE_AUX
	icon_connect_type = "-aux"
	color = PIPE_COLOR_CYAN

/obj/machinery/atmospherics/pipe/manifold/visible/yellow
	color = PIPE_COLOR_YELLOW

/obj/machinery/atmospherics/pipe/manifold/visible/cyan
	color = PIPE_COLOR_CYAN

/obj/machinery/atmospherics/pipe/manifold/visible/green
	color = PIPE_COLOR_GREEN

/obj/machinery/atmospherics/pipe/manifold/visible/black
	color = PIPE_COLOR_BLACK

/obj/machinery/atmospherics/pipe/manifold/visible/red
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/manifold/visible/blue
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/manifold/visible/purple
	color = PIPE_COLOR_PURPLE

/obj/machinery/atmospherics/pipe/manifold/hidden
	icon_state = "map"
	level = 1
	alpha = 128		//set for the benefit of mapping - this is reset to opaque when the pipe is spawned in game

/obj/machinery/atmospherics/pipe/manifold/hidden/scrubbers
	name = "scrubbers pipe manifold"
	desc = "A manifold composed of scrubbers pipes."
	icon_state = "map-scrubbers"
	connect_types = CONNECT_TYPE_SCRUBBER
	icon_connect_type = "-scrubbers"
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/manifold/hidden/supply
	name = "air supply pipe manifold"
	desc = "A manifold composed of supply pipes."
	icon_state = "map-supply"
	connect_types = CONNECT_TYPE_SUPPLY
	icon_connect_type = "-supply"
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/manifold/hidden/fuel
	name = "Fuel pipe manifold"
	desc = "A manifold composed of fuel pipes."
	icon_state = "map-fuel"
	connect_types = CONNECT_TYPE_FUEL
	icon_connect_type = "-fuel"
	color = PIPE_COLOR_YELLOW

/obj/machinery/atmospherics/pipe/manifold/hidden/aux
	name = "Auxiliary pipe"
	desc = "A manifold composed of auxiliary pipes."
	icon_state = "map-aux"
	connect_types = CONNECT_TYPE_AUX
	icon_connect_type = "-aux"
	color = PIPE_COLOR_CYAN

/obj/machinery/atmospherics/pipe/manifold/hidden/yellow
	color = PIPE_COLOR_YELLOW

/obj/machinery/atmospherics/pipe/manifold/hidden/cyan
	color = PIPE_COLOR_CYAN

/obj/machinery/atmospherics/pipe/manifold/hidden/green
	color = PIPE_COLOR_GREEN

/obj/machinery/atmospherics/pipe/manifold/hidden/black
	color = PIPE_COLOR_BLACK

/obj/machinery/atmospherics/pipe/manifold/hidden/red
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/manifold/hidden/blue
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/manifold/hidden/purple
	color = PIPE_COLOR_PURPLE

/obj/machinery/atmospherics/pipe/manifold4w
	name = "4-way pipe manifold"
	desc = "A manifold composed of regular pipes."
	icon = 'icons/atmos/manifold.dmi'
	icon_state = "map_4way"

	volume = ATMOS_DEFAULT_VOLUME_PIPE * 2

	dir = SOUTH
	initialize_directions = NORTH|SOUTH|EAST|WEST

	level = 1

	pipe_class = PIPE_CLASS_QUATERNARY
	rotate_class = PIPE_ROTATE_ONEDIR
	connect_dir_type = NORTH | SOUTH | EAST | WEST

/obj/machinery/atmospherics/pipe/manifold4w/Initialize(mapload)
	if(mapload)
		var/turf/T = loc
		var/image/I = image(icon, T, icon_state, dir, pixel_x, pixel_y)
		I.plane = ABOVE_LIGHTING_PLANE
		I.color = color
		I.alpha = 125
		LAZYADD(T.blueprints, I)

	. = ..()

	alpha = 255
	icon = null

/obj/machinery/atmospherics/pipe/manifold4w/update_icon(var/safety = 0)
	if(!atmos_initialised)
		return

	icon_state = null

	alpha = 255

	ClearOverlays()
	var/list/base_overlays = list()
	var/mutable_appearance/connect_icon = mutable_appearance(icon, "4way[icon_connect_type]")
	connect_icon.color = pipe_color
	base_overlays += connect_icon
	var/mutable_appearance/emissive_base_blocker = emissive_blocker(icon, "4way[icon_connect_type]")
	base_overlays += emissive_base_blocker
	var/mutable_appearance/clamps_icon = mutable_appearance(icon, "clamps_4way[icon_connect_type]")
	base_overlays += clamps_icon
	var/mutable_appearance/emissive_clamps_blocker = emissive_blocker(icon, "clamps_4way[icon_connect_type]")
	base_overlays += emissive_clamps_blocker
	AddOverlays(base_overlays)

	underlays.Cut()
	for(var/direction in GLOB.cardinals)
		if(!(direction & initialize_directions))
			continue
		var/list/check_nodes = nodes_in_dir(direction)
		add_underlay(get_turf(src), length(check_nodes) && check_nodes[1], direction, icon_connect_type)

	try_leak()

/obj/machinery/atmospherics/pipe/manifold4w/visible
	icon_state = "map_4way"
	level = 2

/obj/machinery/atmospherics/pipe/manifold4w/visible/scrubbers
	name = "4-way scrubbers pipe manifold"
	desc = "A manifold composed of scrubbers pipes."
	icon_state = "map_4way-scrubbers"
	connect_types = CONNECT_TYPE_SCRUBBER
	icon_connect_type = "-scrubbers"
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/manifold4w/visible/supply
	name = "4-way air supply pipe manifold"
	desc = "A manifold composed of supply pipes"
	icon_state = "map_4way-supply"
	connect_types = CONNECT_TYPE_SUPPLY
	icon_connect_type = "-supply"
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/manifold4w/visible/fuel
	name = "4-way fuel pipe manifold"
	desc = "A manifold composed of fuel pipes."
	icon_state = "map_4way-fuel"
	connect_types = CONNECT_TYPE_FUEL
	icon_connect_type = "-fuel"
	color = PIPE_COLOR_YELLOW

/obj/machinery/atmospherics/pipe/manifold4w/visible/aux
	name = "4-way auxiliary pipe manifold"
	desc = "A manifold composed of auxiliary pipes"
	icon_state = "map_4way-aux"
	connect_types = CONNECT_TYPE_AUX
	icon_connect_type = "-aux"
	color = PIPE_COLOR_CYAN

/obj/machinery/atmospherics/pipe/manifold4w/visible/yellow
	color = PIPE_COLOR_YELLOW

/obj/machinery/atmospherics/pipe/manifold4w/visible/cyan
	color = PIPE_COLOR_CYAN

/obj/machinery/atmospherics/pipe/manifold4w/visible/green
	color = PIPE_COLOR_GREEN

/obj/machinery/atmospherics/pipe/manifold4w/visible/black
	color = PIPE_COLOR_BLACK

/obj/machinery/atmospherics/pipe/manifold4w/visible/red
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/manifold4w/visible/blue
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/manifold4w/visible/purple
	color = PIPE_COLOR_PURPLE

/obj/machinery/atmospherics/pipe/manifold4w/hidden
	icon_state = "map_4way"
	level = 1
	alpha = 128		//set for the benefit of mapping - this is reset to opaque when the pipe is spawned in game

/obj/machinery/atmospherics/pipe/manifold4w/hidden/scrubbers
	name = "4-way scrubbers pipe manifold"
	desc = "A manifold composed of scrubbers pipes."
	icon_state = "map_4way-scrubbers"
	connect_types = CONNECT_TYPE_SCRUBBER
	icon_connect_type = "-scrubbers"
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/manifold4w/hidden/supply
	name = "4-way air supply pipe manifold"
	desc = "A manifold composed of supply pipes."
	icon_state = "map_4way-supply"
	connect_types = CONNECT_TYPE_SUPPLY
	icon_connect_type = "-supply"
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/manifold4w/hidden/fuel
	name = "4-way fuel pipe manifold"
	desc = "A manifold composed of fuel pipes."
	icon_state = "map_4way-fuel"
	connect_types = CONNECT_TYPE_FUEL
	icon_connect_type = "-fuel"
	color = PIPE_COLOR_YELLOW

/obj/machinery/atmospherics/pipe/manifold4w/hidden/aux
	name = "4-way auxiliary pipe manifold"
	desc = "A manifold composed of auxiliary pipes."
	icon_state = "map_4way-aux"
	connect_types = CONNECT_TYPE_AUX
	icon_connect_type = "-aux"
	color = PIPE_COLOR_CYAN

/obj/machinery/atmospherics/pipe/manifold4w/hidden/yellow
	color = PIPE_COLOR_YELLOW

/obj/machinery/atmospherics/pipe/manifold4w/hidden/cyan
	color = PIPE_COLOR_CYAN

/obj/machinery/atmospherics/pipe/manifold4w/hidden/green
	color = PIPE_COLOR_GREEN

/obj/machinery/atmospherics/pipe/manifold4w/hidden/black
	color = PIPE_COLOR_BLACK

/obj/machinery/atmospherics/pipe/manifold4w/hidden/red
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/manifold4w/hidden/blue
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/manifold4w/hidden/purple
	color = PIPE_COLOR_PURPLE

/obj/machinery/atmospherics/pipe/cap
	name = "pipe endcap"
	desc = "An endcap for pipes"
	icon = 'icons/atmos/pipes.dmi'
	icon_state = "cap"
	level = 2

	volume = 35

	pipe_class = PIPE_CLASS_UNARY
	dir = SOUTH
	initialize_directions = SOUTH
	build_icon_state = "cap"

/obj/machinery/atmospherics/pipe/cap/update_icon()
	alpha = 255
	icon_state = "cap[icon_connect_type]"
	color = pipe_color

/obj/machinery/atmospherics/pipe/cap/visible
	level = 2
	icon_state = "cap"

/obj/machinery/atmospherics/pipe/cap/visible/scrubbers
	name = "scrubbers pipe endcap"
	desc = "An endcap for scrubbers pipes"
	connect_types = CONNECT_TYPE_SCRUBBER
	icon_connect_type = "-scrubbers"
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/cap/visible/supply
	name = "supply pipe endcap"
	desc = "An endcap for supply pipes"
	connect_types = CONNECT_TYPE_SUPPLY
	icon_connect_type = "-supply"
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/cap/visible/fuel
	name = "fuel pipe endcap"
	desc = "An endcap for fuel pipes"
	connect_types = CONNECT_TYPE_FUEL
	icon_connect_type = "-fuel"
	color = PIPE_COLOR_YELLOW

/obj/machinery/atmospherics/pipe/cap/visible/aux
	name = "auxiliary pipe endcap"
	desc = "An endcap for auxiliary pipes"
	connect_types = CONNECT_TYPE_AUX
	icon_connect_type = "-aux"
	color = PIPE_COLOR_CYAN

/obj/machinery/atmospherics/pipe/cap/hidden
	level = 1
	icon_state = "cap"
	alpha = 128

/obj/machinery/atmospherics/pipe/cap/hidden/scrubbers
	name = "scrubbers pipe endcap"
	desc = "An endcap for scrubbers pipes"
	connect_types = CONNECT_TYPE_SCRUBBER
	icon_connect_type = "-scrubbers"
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/cap/hidden/supply
	name = "supply pipe endcap"
	desc = "An endcap for supply pipes"
	connect_types = CONNECT_TYPE_SUPPLY
	icon_connect_type = "-supply"
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/cap/hidden/fuel
	name = "fuel pipe endcap"
	desc = "An endcap for fuel pipes"
	connect_types = CONNECT_TYPE_FUEL
	icon_connect_type = "-fuel"
	color = PIPE_COLOR_YELLOW

/obj/machinery/atmospherics/pipe/cap/hidden/aux
	name = "auxiliary pipe endcap"
	desc = "An endcap for auxiliary pipes"
	connect_types = CONNECT_TYPE_AUX
	icon_connect_type = "-aux"
	color = PIPE_COLOR_CYAN


/obj/machinery/atmospherics/pipe/simple/visible/universal
	name = "universal pipe adapter"
	desc = "An adapter for regular, supply, scrubbers, fuel, and auxiliary pipes."
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SUPPLY|CONNECT_TYPE_SCRUBBER|CONNECT_TYPE_FUEL|CONNECT_TYPE_AUX
	icon_state = "map_universal"
	gfi_layer_rotation = GFI_ROTATION_OVERDIR

/obj/machinery/atmospherics/pipe/simple/visible/universal/mechanics_hints(mob/user, distance, is_adjacent)
	. = list()
	. += "This allows you to connect 'normal' pipes, blue 'supply' pipes, red 'scrubber' pipes, yellow 'fuel' pipes, and cyan 'aux' pipes together."
	. += ..()

/obj/machinery/atmospherics/pipe/simple/visible/universal/update_icon()
	if(!atmos_initialised)
		return

	icon_state = "universal"

	alpha = 255

	underlays.Cut()
	for(var/direction in GLOB.cardinals)
		if(direction & initialize_directions)
			universal_underlays(direction)

/obj/machinery/atmospherics/pipe/simple/hidden/universal
	name = "universal pipe adapter"
	desc = "An adapter for regular, supply, scrubbers, fuel, and auxiliary pipes."
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SUPPLY|CONNECT_TYPE_SCRUBBER|CONNECT_TYPE_FUEL|CONNECT_TYPE_AUX
	icon_state = "map_universal"
	build_icon_state = "universal"
	gfi_layer_rotation = GFI_ROTATION_OVERDIR

/obj/machinery/atmospherics/pipe/simple/hidden/universal/mechanics_hints(mob/user, distance, is_adjacent)
	. = list()
	. += "This allows you to connect 'normal' pipes, blue 'supply' pipes, red 'scrubber' pipes, yellow 'fuel' pipes, and cyan 'aux' pipes together."
	. += ..()

/obj/machinery/atmospherics/pipe/simple/hidden/universal/update_icon()
	if(!atmos_initialised)
		return

	icon_state = "universal"

	alpha = 255

	underlays.Cut()
	for(var/direction in GLOB.cardinals)
		if(direction & initialize_directions)
			universal_underlays(direction)

/obj/machinery/atmospherics/proc/universal_underlays(direction)
	var/turf/T = loc
	var/connections = list("", "-supply", "-scrubbers", "-fuel", "-aux")
	for(var/obj/machinery/atmospherics/node as anything in nodes_in_dir(direction))
		if(node.icon_connect_type in connections)
			connections[node.icon_connect_type] = node
	for(var/suffix in connections)
		add_underlay(T, connections[suffix], direction, suffix, "retracted", 'icons/atmos/universal_adapter_underlays.dmi')

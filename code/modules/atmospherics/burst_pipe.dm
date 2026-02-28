ABSTRACT_TYPE(/obj/machinery/atmospherics/pipe/burst)
	name = "burst_pipe"
	desc = DESC_PARENT
	icon = 'icons/atmos/burst_pipes.dmi'
	icon_state = "burst"

	level = 2

	volume = ATMOS_DEFAULT_VOLUME_PIPE * 1.5

	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SUPPLY|CONNECT_TYPE_SCRUBBER|CONNECT_TYPE_AUX|CONNECT_TYPE_FUEL|CONNECT_TYPE_HE

	dir = SOUTH
	initialize_directions = SOUTH

	pipe_class = PIPE_CLASS_UNARY

/obj/machinery/atmospherics/pipe/burst/Initialize(mapload, _dir, _connect_types)
	dir = _dir
	connect_types = _connect_types
	initialize_directions = dir
	atmos_init()
	update_icon()
	. = ..()

/obj/machinery/atmospherics/pipe/burst/update_icon()
	alpha = 255

/obj/machinery/atmospherics/pipe/burst/process(seconds_per_tick)
	if(!parent)
		..()
	else
		parent.mingle_with_turf(loc, volume)

/obj/machinery/atmospherics/pipe/burst/attackby(obj/item/attacking_item, mob/user)
	if (attacking_item.tool_behaviour != TOOL_WRENCH && !istype(attacking_item, /obj/item/pipewrench))
		return ..()
	to_chat(user, SPAN_NOTICE("You begin to remove \the [src]..."))
	if(attacking_item.use_tool(src, user, istype(attacking_item, /obj/item/pipewrench) ? 100 : 50, volume = 50))
		user.visible_message( \
			SPAN_NOTICE("\The [user] removes \the [src]."), \
			SPAN_NOTICE("You have removed \the [src]."), \
			"You hear a ratchet.")
		qdel(src)
		return TRUE

/obj/machinery/atmospherics/pipe/burst/standard
	name = "burst pipe"
	desc = "The mangled remains of a gas pipe that burst. It leaks like a sieve."

/obj/machinery/atmospherics/pipe/burst/heat
	name = "burst heat exchanging pipe"
	desc = "The mangled remains of a heat exchanging pipe that burst. It leaks like a sieve."
	icon_state = "burst_he"

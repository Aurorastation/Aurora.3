#define PIPE_STRAIGHT 2
#define PIPE_BENT     5

/singleton/fabricator_recipe/pipe/straight
	name = "pipe fitting"
	rotate_class = PIPE_ROTATE_TWODIR
	constructed_path = /obj/machinery/atmospherics/pipe/simple/hidden

/singleton/fabricator_recipe/pipe/straight/scrubbers
	category = "Scrubber Pipes"
	name = "scrubber pipe fitting"
	pipe_color = PIPE_COLOR_RED
	connect_types = CONNECT_TYPE_SCRUBBER
	constructed_path = /obj/machinery/atmospherics/pipe/simple/hidden/scrubbers

/singleton/fabricator_recipe/pipe/straight/supply
	category = "Supply Pipes"
	name = "supply pipe fitting"
	pipe_color = PIPE_COLOR_BLUE
	connect_types = CONNECT_TYPE_SUPPLY
	constructed_path = /obj/machinery/atmospherics/pipe/simple/hidden/supply

/singleton/fabricator_recipe/pipe/straight/fuel
	category = "Fuel Pipes"
	name = "fuel pipe fitting"
	pipe_color = PIPE_COLOR_YELLOW
	connect_types = CONNECT_TYPE_FUEL
	constructed_path = /obj/machinery/atmospherics/pipe/simple/hidden/fuel

/singleton/fabricator_recipe/pipe/straight/aux
	category = "Auxiliary Pipes"
	name = "auxiliary pipe fitting"
	pipe_color = PIPE_COLOR_CYAN
	connect_types = CONNECT_TYPE_AUX
	constructed_path = /obj/machinery/atmospherics/pipe/simple/hidden/aux

/singleton/fabricator_recipe/pipe/bent
	name = "bent pipe fitting"
	dir = PIPE_BENT
	rotate_class = PIPE_ROTATE_TWODIR

/singleton/fabricator_recipe/pipe/bent/scrubbers
	category = "Scrubber Pipes"
	name = "scrubber bent pipe fitting"
	pipe_color = PIPE_COLOR_RED
	connect_types = CONNECT_TYPE_SCRUBBER
	constructed_path = /obj/machinery/atmospherics/pipe/simple/hidden/scrubbers

/singleton/fabricator_recipe/pipe/bent/supply
	category = "Supply Pipes"
	name = "supply bent pipe fitting"
	pipe_color = PIPE_COLOR_BLUE
	connect_types = CONNECT_TYPE_SUPPLY
	constructed_path = /obj/machinery/atmospherics/pipe/simple/hidden/supply

/singleton/fabricator_recipe/pipe/bent/fuel
	category = "Fuel Pipes"
	name = "fuel bent pipe fitting"
	pipe_color = PIPE_COLOR_YELLOW
	connect_types = CONNECT_TYPE_FUEL
	constructed_path = /obj/machinery/atmospherics/pipe/simple/hidden/fuel

/singleton/fabricator_recipe/pipe/bent/aux
	category = "Auxiliary Pipes"
	name = "auxiliary bent pipe fitting"
	pipe_color = PIPE_COLOR_CYAN
	connect_types = CONNECT_TYPE_AUX
	constructed_path = /obj/machinery/atmospherics/pipe/simple/hidden/aux

/singleton/fabricator_recipe/pipe/manifold
	name = "pipe manifold fitting"
	build_icon_state = "manifold"
	constructed_path = /obj/machinery/atmospherics/pipe/manifold/hidden
	pipe_class = PIPE_CLASS_TRINARY
	rotate_class = PIPE_ROTATE_STANDARD

/singleton/fabricator_recipe/pipe/manifold/scrubbers
	category = "Scrubber Pipes"
	name = "scrubber pipe manifold fitting"
	pipe_color = PIPE_COLOR_RED
	connect_types = CONNECT_TYPE_SCRUBBER
	constructed_path = /obj/machinery/atmospherics/pipe/manifold/hidden/scrubbers

/singleton/fabricator_recipe/pipe/manifold/supply
	category = "Supply Pipes"
	name = "supply pipe manifold fitting"
	pipe_color = PIPE_COLOR_BLUE
	connect_types = CONNECT_TYPE_SUPPLY
	constructed_path = /obj/machinery/atmospherics/pipe/manifold/hidden/supply

/singleton/fabricator_recipe/pipe/manifold/fuel
	category = "Fuel Pipes"
	name = "fuel pipe manifold fitting"
	pipe_color = PIPE_COLOR_YELLOW
	connect_types = CONNECT_TYPE_FUEL
	constructed_path = /obj/machinery/atmospherics/pipe/manifold/hidden/fuel

/singleton/fabricator_recipe/pipe/manifold/aux
	category = "Auxiliary Pipes"
	name = "auxiliary pipe manifold fitting"
	pipe_color = PIPE_COLOR_CYAN
	connect_types = CONNECT_TYPE_AUX
	constructed_path = /obj/machinery/atmospherics/pipe/manifold/hidden/aux

/singleton/fabricator_recipe/pipe/manifold4w
	name = "four-way pipe manifold fitting"
	build_icon_state = "manifold4w"
	constructed_path = /obj/machinery/atmospherics/pipe/manifold4w/hidden
	pipe_class = PIPE_CLASS_QUATERNARY
	rotate_class = PIPE_ROTATE_ONEDIR

/singleton/fabricator_recipe/pipe/manifold4w/scrubbers
	category = "Scrubber Pipes"
	name = "scrubber four-way pipe manifold fitting"
	pipe_color = PIPE_COLOR_RED
	connect_types = CONNECT_TYPE_SCRUBBER
	constructed_path = /obj/machinery/atmospherics/pipe/manifold4w/hidden/scrubbers

/singleton/fabricator_recipe/pipe/manifold4w/supply
	category = "Supply Pipes"
	name = "supply four-way pipe manifold fitting"
	pipe_color = PIPE_COLOR_BLUE
	connect_types = CONNECT_TYPE_SUPPLY
	constructed_path = /obj/machinery/atmospherics/pipe/manifold4w/hidden/supply

/singleton/fabricator_recipe/pipe/manifold4w/fuel
	category = "Fuel Pipes"
	name = "fuel four-way pipe manifold fitting"
	pipe_color = PIPE_COLOR_YELLOW
	connect_types = CONNECT_TYPE_FUEL
	constructed_path = /obj/machinery/atmospherics/pipe/manifold4w/hidden/fuel

/singleton/fabricator_recipe/pipe/manifold4w/aux
	category = "Auxiliary Pipes"
	name = "auxiliary four-way pipe manifold fitting"
	pipe_color = PIPE_COLOR_CYAN
	connect_types = CONNECT_TYPE_AUX
	constructed_path = /obj/machinery/atmospherics/pipe/manifold4w/hidden/aux

/singleton/fabricator_recipe/pipe/cap
	name = "pipe cap fitting"
	build_icon_state = "cap"
	constructed_path = /obj/machinery/atmospherics/pipe/cap/hidden
	pipe_class = PIPE_CLASS_UNARY
	rotate_class = PIPE_ROTATE_STANDARD

/singleton/fabricator_recipe/pipe/cap/scrubbers
	category = "Scrubber Pipes"
	name = "scrubber pipe cap fitting"
	pipe_color = PIPE_COLOR_RED
	connect_types = CONNECT_TYPE_SCRUBBER
	constructed_path = /obj/machinery/atmospherics/pipe/cap/hidden/scrubbers

/singleton/fabricator_recipe/pipe/cap/supply
	category = "Supply Pipes"
	name = "supply pipe cap fitting"
	pipe_color = PIPE_COLOR_BLUE
	connect_types = CONNECT_TYPE_SUPPLY
	constructed_path = /obj/machinery/atmospherics/pipe/cap/hidden/supply

/singleton/fabricator_recipe/pipe/cap/fuel
	category = "Fuel Pipes"
	name = "fuel pipe cap fitting"
	pipe_color = PIPE_COLOR_YELLOW
	connect_types = CONNECT_TYPE_FUEL
	constructed_path = /obj/machinery/atmospherics/pipe/cap/hidden/fuel

/singleton/fabricator_recipe/pipe/cap/aux
	category = "Auxiliary Pipes"
	name = "auxiliary pipe cap fitting"
	pipe_color = PIPE_COLOR_CYAN
	connect_types = CONNECT_TYPE_AUX
	constructed_path = /obj/machinery/atmospherics/pipe/cap/hidden/aux

/singleton/fabricator_recipe/pipe/up
	name = "upward pipe fitting"
	build_icon_state = "up"
	constructed_path = /obj/machinery/atmospherics/pipe/zpipe/up
	rotate_class = PIPE_ROTATE_STANDARD

/singleton/fabricator_recipe/pipe/up/scrubbers
	category = "Scrubber Pipes"
	name = "scrubber upward pipe fitting"
	pipe_color = PIPE_COLOR_RED
	connect_types = CONNECT_TYPE_SCRUBBER
	constructed_path = /obj/machinery/atmospherics/pipe/zpipe/up/scrubbers

/singleton/fabricator_recipe/pipe/up/supply
	category = "Supply Pipes"
	name = "supply upward pipe fitting"
	pipe_color = PIPE_COLOR_BLUE
	connect_types = CONNECT_TYPE_SUPPLY
	constructed_path = /obj/machinery/atmospherics/pipe/zpipe/up/supply

/singleton/fabricator_recipe/pipe/up/fuel
	category = "Fuel Pipes"
	name = "fuel upward pipe fitting"
	pipe_color = PIPE_COLOR_YELLOW
	connect_types = CONNECT_TYPE_FUEL
	constructed_path = /obj/machinery/atmospherics/pipe/zpipe/up/fuel

/singleton/fabricator_recipe/pipe/up/aux
	category = "Auxiliary Pipes"
	name = "auxiliary upward pipe fitting"
	pipe_color = PIPE_COLOR_CYAN
	connect_types = CONNECT_TYPE_AUX
	constructed_path = /obj/machinery/atmospherics/pipe/zpipe/up/aux

/singleton/fabricator_recipe/pipe/down
	name = "downward pipe fitting"
	build_icon_state = "down"
	constructed_path = /obj/machinery/atmospherics/pipe/zpipe/down
	rotate_class = PIPE_ROTATE_STANDARD

/singleton/fabricator_recipe/pipe/down/scrubbers
	category = "Scrubber Pipes"
	name = "scrubber downward pipe fitting"
	pipe_color = PIPE_COLOR_RED
	connect_types = CONNECT_TYPE_SCRUBBER
	constructed_path = /obj/machinery/atmospherics/pipe/zpipe/down/scrubbers

/singleton/fabricator_recipe/pipe/down/supply
	category = "Supply Pipes"
	name = "supply downward pipe fitting"
	pipe_color = PIPE_COLOR_BLUE
	connect_types = CONNECT_TYPE_SUPPLY
	constructed_path = /obj/machinery/atmospherics/pipe/zpipe/down/supply

/singleton/fabricator_recipe/pipe/down/fuel
	category = "Fuel Pipes"
	name = "fuel downward pipe fitting"
	pipe_color = PIPE_COLOR_YELLOW
	connect_types = CONNECT_TYPE_FUEL
	constructed_path = /obj/machinery/atmospherics/pipe/zpipe/down/fuel

/singleton/fabricator_recipe/pipe/down/aux
	category = "Auxiliary Pipes"
	name = "auxiliary downward pipe fitting"
	pipe_color = PIPE_COLOR_CYAN
	connect_types = CONNECT_TYPE_AUX
	constructed_path = /obj/machinery/atmospherics/pipe/zpipe/down/aux

#undef PIPE_STRAIGHT

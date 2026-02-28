ABSTRACT_TYPE(/singleton/fabricator_recipe/pipe/heat_exchanging)
	connect_types = CONNECT_TYPE_HE
	pipe_color = PIPE_COLOR_DARK_GREY
	category = "Heat Exchanging Pipes"
	constructed_path = /obj/machinery/atmospherics/pipe/simple/heat_exchanging

/singleton/fabricator_recipe/pipe/heat_exchanging/straight
	name = "heat exchanging pipe fitting"
	rotate_class = PIPE_ROTATE_TWODIR

/singleton/fabricator_recipe/pipe/heat_exchanging/bent
	name = "bent heat exchanging pipe fitting"
	dir = PIPE_BENT
	rotate_class = PIPE_ROTATE_TWODIR

/singleton/fabricator_recipe/pipe/heat_exchanging/junction
	name = "heat exchanging pipe adapter"
	build_icon_state = "junction"
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_HE|CONNECT_TYPE_FUEL
	constructed_path = /obj/machinery/atmospherics/pipe/simple/heat_exchanging/junction

/singleton/fabricator_recipe/pipe/heat_exchanging/cap
	name = "heat exchanging pipe cap"
	build_icon_state = "he_cap"
	constructed_path = /obj/machinery/atmospherics/pipe/simple/heat_exchanging/cap
	pipe_class = PIPE_CLASS_UNARY

ABSTRACT_TYPE(/singleton/fabricator_recipe/pipe/device)
	category = "Devices"
	colorable = FALSE
	pipe_color = PIPE_COLOR_WHITE

	name = "portables connector"
	connect_types = CONNECT_TYPE_REGULAR
	build_icon_state = "connector"
	constructed_path = /obj/machinery/atmospherics/portables_connector
	pipe_class = PIPE_CLASS_UNARY
	rotate_class = PIPE_ROTATE_STANDARD

/singleton/fabricator_recipe/pipe/device/connector
//Just here to allow for sane code organization

/singleton/fabricator_recipe/pipe/device/connector/scrubbers
	name = "scrubber portables connector"
	connect_types = CONNECT_TYPE_SCRUBBER
	pipe_color = PIPE_COLOR_RED
	constructed_path = /obj/machinery/atmospherics/portables_connector/scrubber

/singleton/fabricator_recipe/pipe/device/connector/supply
	name = "supply portables connector"
	connect_types = CONNECT_TYPE_SUPPLY
	pipe_color = PIPE_COLOR_BLUE
	constructed_path = /obj/machinery/atmospherics/portables_connector/supply

/singleton/fabricator_recipe/pipe/device/connector/fuel
	name = "fuel portables connector"
	connect_types = CONNECT_TYPE_FUEL
	pipe_color = PIPE_COLOR_YELLOW
	constructed_path = /obj/machinery/atmospherics/portables_connector/fuel

/singleton/fabricator_recipe/pipe/device/connector/aux
	name = "auxiliary portables connector"
	connect_types = CONNECT_TYPE_AUX
	pipe_color = PIPE_COLOR_CYAN
	constructed_path = /obj/machinery/atmospherics/portables_connector/aux

/singleton/fabricator_recipe/pipe/device/adapter
	name = "universal pipe adapter"
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SUPPLY|CONNECT_TYPE_SCRUBBER|CONNECT_TYPE_FUEL|CONNECT_TYPE_HE
	build_icon_state = "universal"
	constructed_path = /obj/machinery/atmospherics/pipe/simple/hidden/universal
	pipe_class = PIPE_CLASS_BINARY
	rotate_class = PIPE_ROTATE_TWODIR

/singleton/fabricator_recipe/pipe/device/passivevent
	name = "passive vent"
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SUPPLY
	build_icon_state = "pvent"
	constructed_path = /obj/machinery/atmospherics/pipe/vent_passive
	pipe_class = PIPE_CLASS_UNARY

/singleton/fabricator_recipe/pipe/device/unaryvent
	name = "unary vent"
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SUPPLY
	build_icon_state = "uvent"
	constructed_path = /obj/machinery/atmospherics/unary/vent_pump
	pipe_class = PIPE_CLASS_UNARY


/singleton/fabricator_recipe/pipe/device/unaryvent/high_volume
	name = "high volume unary vent"
	constructed_path = /obj/machinery/atmospherics/unary/vent_pump/high_volume

/singleton/fabricator_recipe/pipe/device/gaspump
	name = "gas pump"
	connect_types = CONNECT_TYPE_REGULAR
	build_icon_state = "pump"
	constructed_path = /obj/machinery/atmospherics/binary/pump
	pipe_class = PIPE_CLASS_BINARY

/singleton/fabricator_recipe/pipe/device/gaspump/scrubber
	name = "scrubber gas pump"
	connect_types = CONNECT_TYPE_SCRUBBER
	pipe_color = PIPE_COLOR_RED
	constructed_path= /obj/machinery/atmospherics/binary/pump/scrubber

/singleton/fabricator_recipe/pipe/device/gaspump/supply
	name = "supply gas pump"
	connect_types = CONNECT_TYPE_SUPPLY
	pipe_color = PIPE_COLOR_BLUE
	constructed_path= /obj/machinery/atmospherics/binary/pump/supply

/singleton/fabricator_recipe/pipe/device/gaspump/fuel
	name = "fuel gas pump"
	connect_types = CONNECT_TYPE_FUEL
	pipe_color = PIPE_COLOR_YELLOW
	constructed_path= /obj/machinery/atmospherics/binary/pump/fuel

/singleton/fabricator_recipe/pipe/device/gaspump/aux
	name = "auxiliary gas pump"
	connect_types = CONNECT_TYPE_AUX
	pipe_color = PIPE_COLOR_CYAN
	constructed_path= /obj/machinery/atmospherics/binary/pump/aux

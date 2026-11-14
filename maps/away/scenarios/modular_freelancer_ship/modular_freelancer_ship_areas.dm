
// ------------------------- base/parent

ABSTRACT_TYPE(/area/ship/modular_freelancer_ship)
	name = "Base/Parent Area"
	icon_state = "white128a"
	requires_power = TRUE
	base_turf = /turf/space
	color = "#ff00f2"
	generate_dirt = 75

// ------------------------- main modules

// ----------- fore

ABSTRACT_TYPE(/area/ship/modular_freelancer_ship/fore)
	color = "#8f2d2d"

/area/ship/modular_freelancer_ship/fore/crew
	name = "Fore, Crew Quarters"

/area/ship/modular_freelancer_ship/fore/guns
	name = "Fore, Ship Guns"
	color = "#a31414"

/area/ship/modular_freelancer_ship/fore/hallway
	name = "Fore, Hallway"
	color = "#884e4e"

/area/ship/modular_freelancer_ship/fore/port
	name = "Fore, Port"

/area/ship/modular_freelancer_ship/fore/starboard
	name = "Fore, Starboard"

// ----------- mid

ABSTRACT_TYPE(/area/ship/modular_freelancer_ship/mid)
	color = "#3d8f24"

/area/ship/modular_freelancer_ship/mid/hallway
	name = "Mid, Hallway"

/area/ship/modular_freelancer_ship/mid/lounge
	name = "Mid, Hallway, Lounge"

// ----------- shuttles

/area/ship/modular_freelancer_ship/shuttles
	color = "#92882b"

/area/ship/modular_freelancer_ship/shuttles/hallway
	name = "Mid, Hallway"

// ----------- aux

/area/ship/modular_freelancer_ship/aux
	color = "#7b2794"

/area/ship/modular_freelancer_ship/aux/hallway
	name = "Aux, Hallway"

// ----------- aft

ABSTRACT_TYPE(/area/ship/modular_freelancer_ship/aft)
	color = "#2d4697"

/area/ship/modular_freelancer_ship/aft/hallway
	name = "Aft, Hallway"
	color = "#404f83"

/area/ship/modular_freelancer_ship/aft/cic
	name = "Aft, CIC"
	color = "#1134a5"

/area/ship/modular_freelancer_ship/aft/engineering
	name = "Aft, Engineering"

/area/ship/modular_freelancer_ship/aft/atmos
	name = "Aft, Atmos"

// ------------------------- containers

ABSTRACT_TYPE(/area/ship/modular_freelancer_ship/container)
	color = "#2c8f92"

/area/ship/modular_freelancer_ship/container/c01
	name = "Shipping Container, 01"

/area/ship/modular_freelancer_ship/container/c02
	name = "Shipping Container, 02"

/area/ship/modular_freelancer_ship/container/c03
	name = "Shipping Container, 03"

/area/ship/modular_freelancer_ship/container/c04
	name = "Shipping Container, 04"

/area/ship/modular_freelancer_ship/container/c05
	name = "Shipping Container, 05"

/area/ship/modular_freelancer_ship/container/c06
	name = "Shipping Container, 06"

/area/ship/modular_freelancer_ship/container/c0A
	name = "Shipping Container, 0A"

/area/ship/modular_freelancer_ship/container/c0B
	name = "Shipping Container, 0B"

// ------------------------- misc

ABSTRACT_TYPE(/area/ship/modular_freelancer_ship/misc/maint)
	color = "#353535"
	generate_dirt = 150

/area/ship/modular_freelancer_ship/misc/maint/fore
	name = "Maint, Fore"

/area/ship/modular_freelancer_ship/misc/maint/mid
	name = "Maint, Mid"

/area/ship/modular_freelancer_ship/misc/maint/shuttles
	name = "Maint, Shuttles"

/area/ship/modular_freelancer_ship/misc/maint/aux
	name = "Maint, Aux"

/area/ship/modular_freelancer_ship/misc/maint/aft
	name = "Maint, Aft"

/area/ship/modular_freelancer_ship/exterior
	name = "Exterior Catwalks/Lattices"
	icon_state = "exterior"
	needs_starlight = TRUE
	generate_dirt = null

// ------------------------- shuttles

ABSTRACT_TYPE(/area/shuttle/modular_freelancer_shuttle)
	name = "Base/Parent Area"
	icon_state = "white128a"
	requires_power = TRUE
	generate_dirt = 50

/area/shuttle/modular_freelancer_shuttle/fighter
	name = "Fighter Shuttle"
	color = "#d81a1a"

/area/shuttle/modular_freelancer_shuttle/ferry
	name = "Ferry Shuttle"
	color = "#1a36d8"

// ------------------------- fin


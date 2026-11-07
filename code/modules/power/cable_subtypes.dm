// ----------- red

/obj/structure/cable/red
	color = COLOR_RED

/**
 * Mapping helper, replaced by `tools/bapi/autowire.ps1` with straight/corner/junction cables of its color
 * that connect to every adjacent cable pointing at this tile, and to every adjacent autowire.
 * Does not place knots, so place those under APCs/machinery yourself.
 */
/obj/structure/cable/red/autowire
	name = "autowire (run autowire.ps1)"
	icon_state = "autowire"

ABSTRACT_TYPE(/obj/structure/cable/red/knot)

/obj/structure/cable/red/knot/north
	icon_state = "0-1"

/obj/structure/cable/red/knot/south
	icon_state = "0-2"

/obj/structure/cable/red/knot/east
	icon_state = "0-4"

/obj/structure/cable/red/knot/west
	icon_state = "0-8"

/obj/structure/cable/red/knot/northeast
	icon_state = "0-5"

/obj/structure/cable/red/knot/southeast
	icon_state = "0-6"

/obj/structure/cable/red/knot/northwest
	icon_state = "0-9"

/obj/structure/cable/red/knot/southwest
	icon_state = "0-10"

ABSTRACT_TYPE(/obj/structure/cable/red/straight)

/obj/structure/cable/red/straight/north_south
	icon_state = "1-2"

/obj/structure/cable/red/straight/east_west
	icon_state = "4-8"

ABSTRACT_TYPE(/obj/structure/cable/red/corner)

/obj/structure/cable/red/corner/north_east
	icon_state = "1-4"

/obj/structure/cable/red/corner/north_west
	icon_state = "1-8"

/obj/structure/cable/red/corner/south_east
	icon_state = "2-4"

/obj/structure/cable/red/corner/south_west
	icon_state = "2-8"

ABSTRACT_TYPE(/obj/structure/cable/red/bend)

/obj/structure/cable/red/bend/north_northeast
	icon_state = "1-5"

/obj/structure/cable/red/bend/north_southeast
	icon_state = "1-6"

/obj/structure/cable/red/bend/north_northwest
	icon_state = "1-9"

/obj/structure/cable/red/bend/north_southwest
	icon_state = "1-10"

/obj/structure/cable/red/bend/south_northeast
	icon_state = "2-5"

/obj/structure/cable/red/bend/south_southeast
	icon_state = "2-6"

/obj/structure/cable/red/bend/south_northwest
	icon_state = "2-9"

/obj/structure/cable/red/bend/south_southwest
	icon_state = "2-10"

/obj/structure/cable/red/bend/east_northeast
	icon_state = "4-5"

/obj/structure/cable/red/bend/east_southeast
	icon_state = "4-6"

/obj/structure/cable/red/bend/east_northwest
	icon_state = "4-9"

/obj/structure/cable/red/bend/east_southwest
	icon_state = "4-10"

/obj/structure/cable/red/bend/northeast_southeast
	icon_state = "5-6"

/obj/structure/cable/red/bend/northeast_west
	icon_state = "5-8"

/obj/structure/cable/red/bend/northeast_northwest
	icon_state = "5-9"

/obj/structure/cable/red/bend/northeast_southwest
	icon_state = "5-10"

/obj/structure/cable/red/bend/southeast_west
	icon_state = "6-8"

/obj/structure/cable/red/bend/southeast_northwest
	icon_state = "6-9"

/obj/structure/cable/red/bend/southeast_southwest
	icon_state = "6-10"

/obj/structure/cable/red/bend/west_northwest
	icon_state = "8-9"

/obj/structure/cable/red/bend/west_southwest
	icon_state = "8-10"

/obj/structure/cable/red/bend/northwest_southwest
	icon_state = "9-10"

ABSTRACT_TYPE(/obj/structure/cable/red/down)

/obj/structure/cable/red/down/north
	icon_state = "11-1"

/obj/structure/cable/red/down/south
	icon_state = "11-2"

/obj/structure/cable/red/down/east
	icon_state = "11-4"

/obj/structure/cable/red/down/west
	icon_state = "11-8"

/obj/structure/cable/red/down/northeast
	icon_state = "11-5"

/obj/structure/cable/red/down/southeast
	icon_state = "11-6"

/obj/structure/cable/red/down/northwest
	icon_state = "11-9"

/obj/structure/cable/red/down/southwest
	icon_state = "11-10"

ABSTRACT_TYPE(/obj/structure/cable/red/up)

/obj/structure/cable/red/up/knot
	icon_state = "12-0"

// ----------- yellow

/obj/structure/cable/yellow
	color = COLOR_YELLOW

/**
 * Mapping helper, see `/obj/structure/cable/red/autowire`.
 */
/obj/structure/cable/yellow/autowire
	name = "autowire (run autowire.ps1)"
	icon_state = "autowire"

ABSTRACT_TYPE(/obj/structure/cable/yellow/knot)

/obj/structure/cable/yellow/knot/north
	icon_state = "0-1"

/obj/structure/cable/yellow/knot/south
	icon_state = "0-2"

/obj/structure/cable/yellow/knot/east
	icon_state = "0-4"

/obj/structure/cable/yellow/knot/west
	icon_state = "0-8"

/obj/structure/cable/yellow/knot/northeast
	icon_state = "0-5"

/obj/structure/cable/yellow/knot/southeast
	icon_state = "0-6"

/obj/structure/cable/yellow/knot/northwest
	icon_state = "0-9"

/obj/structure/cable/yellow/knot/southwest
	icon_state = "0-10"

ABSTRACT_TYPE(/obj/structure/cable/yellow/straight)

/obj/structure/cable/yellow/straight/north_south
	icon_state = "1-2"

/obj/structure/cable/yellow/straight/east_west
	icon_state = "4-8"

ABSTRACT_TYPE(/obj/structure/cable/yellow/corner)

/obj/structure/cable/yellow/corner/north_east
	icon_state = "1-4"

/obj/structure/cable/yellow/corner/north_west
	icon_state = "1-8"

/obj/structure/cable/yellow/corner/south_east
	icon_state = "2-4"

/obj/structure/cable/yellow/corner/south_west
	icon_state = "2-8"

ABSTRACT_TYPE(/obj/structure/cable/yellow/bend)

/obj/structure/cable/yellow/bend/north_northeast
	icon_state = "1-5"

/obj/structure/cable/yellow/bend/north_southeast
	icon_state = "1-6"

/obj/structure/cable/yellow/bend/north_northwest
	icon_state = "1-9"

/obj/structure/cable/yellow/bend/north_southwest
	icon_state = "1-10"

/obj/structure/cable/yellow/bend/south_northeast
	icon_state = "2-5"

/obj/structure/cable/yellow/bend/south_southeast
	icon_state = "2-6"

/obj/structure/cable/yellow/bend/south_northwest
	icon_state = "2-9"

/obj/structure/cable/yellow/bend/south_southwest
	icon_state = "2-10"

/obj/structure/cable/yellow/bend/east_northeast
	icon_state = "4-5"

/obj/structure/cable/yellow/bend/east_southeast
	icon_state = "4-6"

/obj/structure/cable/yellow/bend/east_northwest
	icon_state = "4-9"

/obj/structure/cable/yellow/bend/east_southwest
	icon_state = "4-10"

/obj/structure/cable/yellow/bend/northeast_southeast
	icon_state = "5-6"

/obj/structure/cable/yellow/bend/northeast_west
	icon_state = "5-8"

/obj/structure/cable/yellow/bend/northeast_northwest
	icon_state = "5-9"

/obj/structure/cable/yellow/bend/northeast_southwest
	icon_state = "5-10"

/obj/structure/cable/yellow/bend/southeast_west
	icon_state = "6-8"

/obj/structure/cable/yellow/bend/southeast_northwest
	icon_state = "6-9"

/obj/structure/cable/yellow/bend/southeast_southwest
	icon_state = "6-10"

/obj/structure/cable/yellow/bend/west_northwest
	icon_state = "8-9"

/obj/structure/cable/yellow/bend/west_southwest
	icon_state = "8-10"

/obj/structure/cable/yellow/bend/northwest_southwest
	icon_state = "9-10"

ABSTRACT_TYPE(/obj/structure/cable/yellow/down)

/obj/structure/cable/yellow/down/north
	icon_state = "11-1"

/obj/structure/cable/yellow/down/south
	icon_state = "11-2"

/obj/structure/cable/yellow/down/east
	icon_state = "11-4"

/obj/structure/cable/yellow/down/west
	icon_state = "11-8"

/obj/structure/cable/yellow/down/northeast
	icon_state = "11-5"

/obj/structure/cable/yellow/down/southeast
	icon_state = "11-6"

/obj/structure/cable/yellow/down/northwest
	icon_state = "11-9"

/obj/structure/cable/yellow/down/southwest
	icon_state = "11-10"

ABSTRACT_TYPE(/obj/structure/cable/yellow/up)

/obj/structure/cable/yellow/up/knot
	icon_state = "12-0"

// ----------- green

/obj/structure/cable/green
	color = COLOR_LIME

/**
 * Mapping helper, see `/obj/structure/cable/red/autowire`.
 */
/obj/structure/cable/green/autowire
	name = "autowire (run autowire.ps1)"
	icon_state = "autowire"

ABSTRACT_TYPE(/obj/structure/cable/green/knot)

/obj/structure/cable/green/knot/north
	icon_state = "0-1"

/obj/structure/cable/green/knot/south
	icon_state = "0-2"

/obj/structure/cable/green/knot/east
	icon_state = "0-4"

/obj/structure/cable/green/knot/west
	icon_state = "0-8"

/obj/structure/cable/green/knot/northeast
	icon_state = "0-5"

/obj/structure/cable/green/knot/southeast
	icon_state = "0-6"

/obj/structure/cable/green/knot/northwest
	icon_state = "0-9"

/obj/structure/cable/green/knot/southwest
	icon_state = "0-10"

ABSTRACT_TYPE(/obj/structure/cable/green/straight)

/obj/structure/cable/green/straight/north_south
	icon_state = "1-2"

/obj/structure/cable/green/straight/east_west
	icon_state = "4-8"

ABSTRACT_TYPE(/obj/structure/cable/green/corner)

/obj/structure/cable/green/corner/north_east
	icon_state = "1-4"

/obj/structure/cable/green/corner/north_west
	icon_state = "1-8"

/obj/structure/cable/green/corner/south_east
	icon_state = "2-4"

/obj/structure/cable/green/corner/south_west
	icon_state = "2-8"

ABSTRACT_TYPE(/obj/structure/cable/green/bend)

/obj/structure/cable/green/bend/north_northeast
	icon_state = "1-5"

/obj/structure/cable/green/bend/north_southeast
	icon_state = "1-6"

/obj/structure/cable/green/bend/north_northwest
	icon_state = "1-9"

/obj/structure/cable/green/bend/north_southwest
	icon_state = "1-10"

/obj/structure/cable/green/bend/south_northeast
	icon_state = "2-5"

/obj/structure/cable/green/bend/south_southeast
	icon_state = "2-6"

/obj/structure/cable/green/bend/south_northwest
	icon_state = "2-9"

/obj/structure/cable/green/bend/south_southwest
	icon_state = "2-10"

/obj/structure/cable/green/bend/east_northeast
	icon_state = "4-5"

/obj/structure/cable/green/bend/east_southeast
	icon_state = "4-6"

/obj/structure/cable/green/bend/east_northwest
	icon_state = "4-9"

/obj/structure/cable/green/bend/east_southwest
	icon_state = "4-10"

/obj/structure/cable/green/bend/northeast_southeast
	icon_state = "5-6"

/obj/structure/cable/green/bend/northeast_west
	icon_state = "5-8"

/obj/structure/cable/green/bend/northeast_northwest
	icon_state = "5-9"

/obj/structure/cable/green/bend/northeast_southwest
	icon_state = "5-10"

/obj/structure/cable/green/bend/southeast_west
	icon_state = "6-8"

/obj/structure/cable/green/bend/southeast_northwest
	icon_state = "6-9"

/obj/structure/cable/green/bend/southeast_southwest
	icon_state = "6-10"

/obj/structure/cable/green/bend/west_northwest
	icon_state = "8-9"

/obj/structure/cable/green/bend/west_southwest
	icon_state = "8-10"

/obj/structure/cable/green/bend/northwest_southwest
	icon_state = "9-10"

ABSTRACT_TYPE(/obj/structure/cable/green/down)

/obj/structure/cable/green/down/north
	icon_state = "11-1"

/obj/structure/cable/green/down/south
	icon_state = "11-2"

/obj/structure/cable/green/down/east
	icon_state = "11-4"

/obj/structure/cable/green/down/west
	icon_state = "11-8"

/obj/structure/cable/green/down/northeast
	icon_state = "11-5"

/obj/structure/cable/green/down/southeast
	icon_state = "11-6"

/obj/structure/cable/green/down/northwest
	icon_state = "11-9"

/obj/structure/cable/green/down/southwest
	icon_state = "11-10"

ABSTRACT_TYPE(/obj/structure/cable/green/up)

/obj/structure/cable/green/up/knot
	icon_state = "12-0"

// ----------- blue

/obj/structure/cable/blue
	color = COLOR_BLUE

/**
 * Mapping helper, see `/obj/structure/cable/red/autowire`.
 */
/obj/structure/cable/blue/autowire
	name = "autowire (run autowire.ps1)"
	icon_state = "autowire"

ABSTRACT_TYPE(/obj/structure/cable/blue/knot)

/obj/structure/cable/blue/knot/north
	icon_state = "0-1"

/obj/structure/cable/blue/knot/south
	icon_state = "0-2"

/obj/structure/cable/blue/knot/east
	icon_state = "0-4"

/obj/structure/cable/blue/knot/west
	icon_state = "0-8"

/obj/structure/cable/blue/knot/northeast
	icon_state = "0-5"

/obj/structure/cable/blue/knot/southeast
	icon_state = "0-6"

/obj/structure/cable/blue/knot/northwest
	icon_state = "0-9"

/obj/structure/cable/blue/knot/southwest
	icon_state = "0-10"

ABSTRACT_TYPE(/obj/structure/cable/blue/straight)

/obj/structure/cable/blue/straight/north_south
	icon_state = "1-2"

/obj/structure/cable/blue/straight/east_west
	icon_state = "4-8"

ABSTRACT_TYPE(/obj/structure/cable/blue/corner)

/obj/structure/cable/blue/corner/north_east
	icon_state = "1-4"

/obj/structure/cable/blue/corner/north_west
	icon_state = "1-8"

/obj/structure/cable/blue/corner/south_east
	icon_state = "2-4"

/obj/structure/cable/blue/corner/south_west
	icon_state = "2-8"

ABSTRACT_TYPE(/obj/structure/cable/blue/bend)

/obj/structure/cable/blue/bend/north_northeast
	icon_state = "1-5"

/obj/structure/cable/blue/bend/north_southeast
	icon_state = "1-6"

/obj/structure/cable/blue/bend/north_northwest
	icon_state = "1-9"

/obj/structure/cable/blue/bend/north_southwest
	icon_state = "1-10"

/obj/structure/cable/blue/bend/south_northeast
	icon_state = "2-5"

/obj/structure/cable/blue/bend/south_southeast
	icon_state = "2-6"

/obj/structure/cable/blue/bend/south_northwest
	icon_state = "2-9"

/obj/structure/cable/blue/bend/south_southwest
	icon_state = "2-10"

/obj/structure/cable/blue/bend/east_northeast
	icon_state = "4-5"

/obj/structure/cable/blue/bend/east_southeast
	icon_state = "4-6"

/obj/structure/cable/blue/bend/east_northwest
	icon_state = "4-9"

/obj/structure/cable/blue/bend/east_southwest
	icon_state = "4-10"

/obj/structure/cable/blue/bend/northeast_southeast
	icon_state = "5-6"

/obj/structure/cable/blue/bend/northeast_west
	icon_state = "5-8"

/obj/structure/cable/blue/bend/northeast_northwest
	icon_state = "5-9"

/obj/structure/cable/blue/bend/northeast_southwest
	icon_state = "5-10"

/obj/structure/cable/blue/bend/southeast_west
	icon_state = "6-8"

/obj/structure/cable/blue/bend/southeast_northwest
	icon_state = "6-9"

/obj/structure/cable/blue/bend/southeast_southwest
	icon_state = "6-10"

/obj/structure/cable/blue/bend/west_northwest
	icon_state = "8-9"

/obj/structure/cable/blue/bend/west_southwest
	icon_state = "8-10"

/obj/structure/cable/blue/bend/northwest_southwest
	icon_state = "9-10"

ABSTRACT_TYPE(/obj/structure/cable/blue/down)

/obj/structure/cable/blue/down/north
	icon_state = "11-1"

/obj/structure/cable/blue/down/south
	icon_state = "11-2"

/obj/structure/cable/blue/down/east
	icon_state = "11-4"

/obj/structure/cable/blue/down/west
	icon_state = "11-8"

/obj/structure/cable/blue/down/northeast
	icon_state = "11-5"

/obj/structure/cable/blue/down/southeast
	icon_state = "11-6"

/obj/structure/cable/blue/down/northwest
	icon_state = "11-9"

/obj/structure/cable/blue/down/southwest
	icon_state = "11-10"

ABSTRACT_TYPE(/obj/structure/cable/blue/up)

/obj/structure/cable/blue/up/knot
	icon_state = "12-0"

// ----------- pink

/obj/structure/cable/pink
	color = COLOR_PINK

/**
 * Mapping helper, see `/obj/structure/cable/red/autowire`.
 */
/obj/structure/cable/pink/autowire
	name = "autowire (run autowire.ps1)"
	icon_state = "autowire"

ABSTRACT_TYPE(/obj/structure/cable/pink/knot)

/obj/structure/cable/pink/knot/north
	icon_state = "0-1"

/obj/structure/cable/pink/knot/south
	icon_state = "0-2"

/obj/structure/cable/pink/knot/east
	icon_state = "0-4"

/obj/structure/cable/pink/knot/west
	icon_state = "0-8"

/obj/structure/cable/pink/knot/northeast
	icon_state = "0-5"

/obj/structure/cable/pink/knot/southeast
	icon_state = "0-6"

/obj/structure/cable/pink/knot/northwest
	icon_state = "0-9"

/obj/structure/cable/pink/knot/southwest
	icon_state = "0-10"

ABSTRACT_TYPE(/obj/structure/cable/pink/straight)

/obj/structure/cable/pink/straight/north_south
	icon_state = "1-2"

/obj/structure/cable/pink/straight/east_west
	icon_state = "4-8"

ABSTRACT_TYPE(/obj/structure/cable/pink/corner)

/obj/structure/cable/pink/corner/north_east
	icon_state = "1-4"

/obj/structure/cable/pink/corner/north_west
	icon_state = "1-8"

/obj/structure/cable/pink/corner/south_east
	icon_state = "2-4"

/obj/structure/cable/pink/corner/south_west
	icon_state = "2-8"

ABSTRACT_TYPE(/obj/structure/cable/pink/bend)

/obj/structure/cable/pink/bend/north_northeast
	icon_state = "1-5"

/obj/structure/cable/pink/bend/north_southeast
	icon_state = "1-6"

/obj/structure/cable/pink/bend/north_northwest
	icon_state = "1-9"

/obj/structure/cable/pink/bend/north_southwest
	icon_state = "1-10"

/obj/structure/cable/pink/bend/south_northeast
	icon_state = "2-5"

/obj/structure/cable/pink/bend/south_southeast
	icon_state = "2-6"

/obj/structure/cable/pink/bend/south_northwest
	icon_state = "2-9"

/obj/structure/cable/pink/bend/south_southwest
	icon_state = "2-10"

/obj/structure/cable/pink/bend/east_northeast
	icon_state = "4-5"

/obj/structure/cable/pink/bend/east_southeast
	icon_state = "4-6"

/obj/structure/cable/pink/bend/east_northwest
	icon_state = "4-9"

/obj/structure/cable/pink/bend/east_southwest
	icon_state = "4-10"

/obj/structure/cable/pink/bend/northeast_southeast
	icon_state = "5-6"

/obj/structure/cable/pink/bend/northeast_west
	icon_state = "5-8"

/obj/structure/cable/pink/bend/northeast_northwest
	icon_state = "5-9"

/obj/structure/cable/pink/bend/northeast_southwest
	icon_state = "5-10"

/obj/structure/cable/pink/bend/southeast_west
	icon_state = "6-8"

/obj/structure/cable/pink/bend/southeast_northwest
	icon_state = "6-9"

/obj/structure/cable/pink/bend/southeast_southwest
	icon_state = "6-10"

/obj/structure/cable/pink/bend/west_northwest
	icon_state = "8-9"

/obj/structure/cable/pink/bend/west_southwest
	icon_state = "8-10"

/obj/structure/cable/pink/bend/northwest_southwest
	icon_state = "9-10"

ABSTRACT_TYPE(/obj/structure/cable/pink/down)

/obj/structure/cable/pink/down/north
	icon_state = "11-1"

/obj/structure/cable/pink/down/south
	icon_state = "11-2"

/obj/structure/cable/pink/down/east
	icon_state = "11-4"

/obj/structure/cable/pink/down/west
	icon_state = "11-8"

/obj/structure/cable/pink/down/northeast
	icon_state = "11-5"

/obj/structure/cable/pink/down/southeast
	icon_state = "11-6"

/obj/structure/cable/pink/down/northwest
	icon_state = "11-9"

/obj/structure/cable/pink/down/southwest
	icon_state = "11-10"

ABSTRACT_TYPE(/obj/structure/cable/pink/up)

/obj/structure/cable/pink/up/knot
	icon_state = "12-0"

// ----------- orange

/obj/structure/cable/orange
	color = COLOR_ORANGE

/**
 * Mapping helper, see `/obj/structure/cable/red/autowire`.
 */
/obj/structure/cable/orange/autowire
	name = "autowire (run autowire.ps1)"
	icon_state = "autowire"

ABSTRACT_TYPE(/obj/structure/cable/orange/knot)

/obj/structure/cable/orange/knot/north
	icon_state = "0-1"

/obj/structure/cable/orange/knot/south
	icon_state = "0-2"

/obj/structure/cable/orange/knot/east
	icon_state = "0-4"

/obj/structure/cable/orange/knot/west
	icon_state = "0-8"

/obj/structure/cable/orange/knot/northeast
	icon_state = "0-5"

/obj/structure/cable/orange/knot/southeast
	icon_state = "0-6"

/obj/structure/cable/orange/knot/northwest
	icon_state = "0-9"

/obj/structure/cable/orange/knot/southwest
	icon_state = "0-10"

ABSTRACT_TYPE(/obj/structure/cable/orange/straight)

/obj/structure/cable/orange/straight/north_south
	icon_state = "1-2"

/obj/structure/cable/orange/straight/east_west
	icon_state = "4-8"

ABSTRACT_TYPE(/obj/structure/cable/orange/corner)

/obj/structure/cable/orange/corner/north_east
	icon_state = "1-4"

/obj/structure/cable/orange/corner/north_west
	icon_state = "1-8"

/obj/structure/cable/orange/corner/south_east
	icon_state = "2-4"

/obj/structure/cable/orange/corner/south_west
	icon_state = "2-8"

ABSTRACT_TYPE(/obj/structure/cable/orange/bend)

/obj/structure/cable/orange/bend/north_northeast
	icon_state = "1-5"

/obj/structure/cable/orange/bend/north_southeast
	icon_state = "1-6"

/obj/structure/cable/orange/bend/north_northwest
	icon_state = "1-9"

/obj/structure/cable/orange/bend/north_southwest
	icon_state = "1-10"

/obj/structure/cable/orange/bend/south_northeast
	icon_state = "2-5"

/obj/structure/cable/orange/bend/south_southeast
	icon_state = "2-6"

/obj/structure/cable/orange/bend/south_northwest
	icon_state = "2-9"

/obj/structure/cable/orange/bend/south_southwest
	icon_state = "2-10"

/obj/structure/cable/orange/bend/east_northeast
	icon_state = "4-5"

/obj/structure/cable/orange/bend/east_southeast
	icon_state = "4-6"

/obj/structure/cable/orange/bend/east_northwest
	icon_state = "4-9"

/obj/structure/cable/orange/bend/east_southwest
	icon_state = "4-10"

/obj/structure/cable/orange/bend/northeast_southeast
	icon_state = "5-6"

/obj/structure/cable/orange/bend/northeast_west
	icon_state = "5-8"

/obj/structure/cable/orange/bend/northeast_northwest
	icon_state = "5-9"

/obj/structure/cable/orange/bend/northeast_southwest
	icon_state = "5-10"

/obj/structure/cable/orange/bend/southeast_west
	icon_state = "6-8"

/obj/structure/cable/orange/bend/southeast_northwest
	icon_state = "6-9"

/obj/structure/cable/orange/bend/southeast_southwest
	icon_state = "6-10"

/obj/structure/cable/orange/bend/west_northwest
	icon_state = "8-9"

/obj/structure/cable/orange/bend/west_southwest
	icon_state = "8-10"

/obj/structure/cable/orange/bend/northwest_southwest
	icon_state = "9-10"

ABSTRACT_TYPE(/obj/structure/cable/orange/down)

/obj/structure/cable/orange/down/north
	icon_state = "11-1"

/obj/structure/cable/orange/down/south
	icon_state = "11-2"

/obj/structure/cable/orange/down/east
	icon_state = "11-4"

/obj/structure/cable/orange/down/west
	icon_state = "11-8"

/obj/structure/cable/orange/down/northeast
	icon_state = "11-5"

/obj/structure/cable/orange/down/southeast
	icon_state = "11-6"

/obj/structure/cable/orange/down/northwest
	icon_state = "11-9"

/obj/structure/cable/orange/down/southwest
	icon_state = "11-10"

ABSTRACT_TYPE(/obj/structure/cable/orange/up)

/obj/structure/cable/orange/up/knot
	icon_state = "12-0"

// ----------- cyan

/obj/structure/cable/cyan
	color = COLOR_CYAN

/**
 * Mapping helper, see `/obj/structure/cable/red/autowire`.
 */
/obj/structure/cable/cyan/autowire
	name = "autowire (run autowire.ps1)"
	icon_state = "autowire"

ABSTRACT_TYPE(/obj/structure/cable/cyan/knot)

/obj/structure/cable/cyan/knot/north
	icon_state = "0-1"

/obj/structure/cable/cyan/knot/south
	icon_state = "0-2"

/obj/structure/cable/cyan/knot/east
	icon_state = "0-4"

/obj/structure/cable/cyan/knot/west
	icon_state = "0-8"

/obj/structure/cable/cyan/knot/northeast
	icon_state = "0-5"

/obj/structure/cable/cyan/knot/southeast
	icon_state = "0-6"

/obj/structure/cable/cyan/knot/northwest
	icon_state = "0-9"

/obj/structure/cable/cyan/knot/southwest
	icon_state = "0-10"

ABSTRACT_TYPE(/obj/structure/cable/cyan/straight)

/obj/structure/cable/cyan/straight/north_south
	icon_state = "1-2"

/obj/structure/cable/cyan/straight/east_west
	icon_state = "4-8"

ABSTRACT_TYPE(/obj/structure/cable/cyan/corner)

/obj/structure/cable/cyan/corner/north_east
	icon_state = "1-4"

/obj/structure/cable/cyan/corner/north_west
	icon_state = "1-8"

/obj/structure/cable/cyan/corner/south_east
	icon_state = "2-4"

/obj/structure/cable/cyan/corner/south_west
	icon_state = "2-8"

ABSTRACT_TYPE(/obj/structure/cable/cyan/bend)

/obj/structure/cable/cyan/bend/north_northeast
	icon_state = "1-5"

/obj/structure/cable/cyan/bend/north_southeast
	icon_state = "1-6"

/obj/structure/cable/cyan/bend/north_northwest
	icon_state = "1-9"

/obj/structure/cable/cyan/bend/north_southwest
	icon_state = "1-10"

/obj/structure/cable/cyan/bend/south_northeast
	icon_state = "2-5"

/obj/structure/cable/cyan/bend/south_southeast
	icon_state = "2-6"

/obj/structure/cable/cyan/bend/south_northwest
	icon_state = "2-9"

/obj/structure/cable/cyan/bend/south_southwest
	icon_state = "2-10"

/obj/structure/cable/cyan/bend/east_northeast
	icon_state = "4-5"

/obj/structure/cable/cyan/bend/east_southeast
	icon_state = "4-6"

/obj/structure/cable/cyan/bend/east_northwest
	icon_state = "4-9"

/obj/structure/cable/cyan/bend/east_southwest
	icon_state = "4-10"

/obj/structure/cable/cyan/bend/northeast_southeast
	icon_state = "5-6"

/obj/structure/cable/cyan/bend/northeast_west
	icon_state = "5-8"

/obj/structure/cable/cyan/bend/northeast_northwest
	icon_state = "5-9"

/obj/structure/cable/cyan/bend/northeast_southwest
	icon_state = "5-10"

/obj/structure/cable/cyan/bend/southeast_west
	icon_state = "6-8"

/obj/structure/cable/cyan/bend/southeast_northwest
	icon_state = "6-9"

/obj/structure/cable/cyan/bend/southeast_southwest
	icon_state = "6-10"

/obj/structure/cable/cyan/bend/west_northwest
	icon_state = "8-9"

/obj/structure/cable/cyan/bend/west_southwest
	icon_state = "8-10"

/obj/structure/cable/cyan/bend/northwest_southwest
	icon_state = "9-10"

ABSTRACT_TYPE(/obj/structure/cable/cyan/down)

/obj/structure/cable/cyan/down/north
	icon_state = "11-1"

/obj/structure/cable/cyan/down/south
	icon_state = "11-2"

/obj/structure/cable/cyan/down/east
	icon_state = "11-4"

/obj/structure/cable/cyan/down/west
	icon_state = "11-8"

/obj/structure/cable/cyan/down/northeast
	icon_state = "11-5"

/obj/structure/cable/cyan/down/southeast
	icon_state = "11-6"

/obj/structure/cable/cyan/down/northwest
	icon_state = "11-9"

/obj/structure/cable/cyan/down/southwest
	icon_state = "11-10"

ABSTRACT_TYPE(/obj/structure/cable/cyan/up)

/obj/structure/cable/cyan/up/knot
	icon_state = "12-0"

// ----------- white

/obj/structure/cable/white
	color = COLOR_WHITE

/**
 * Mapping helper, see `/obj/structure/cable/red/autowire`.
 */
/obj/structure/cable/white/autowire
	name = "autowire (run autowire.ps1)"
	icon_state = "autowire"

ABSTRACT_TYPE(/obj/structure/cable/white/knot)

/obj/structure/cable/white/knot/north
	icon_state = "0-1"

/obj/structure/cable/white/knot/south
	icon_state = "0-2"

/obj/structure/cable/white/knot/east
	icon_state = "0-4"

/obj/structure/cable/white/knot/west
	icon_state = "0-8"

/obj/structure/cable/white/knot/northeast
	icon_state = "0-5"

/obj/structure/cable/white/knot/southeast
	icon_state = "0-6"

/obj/structure/cable/white/knot/northwest
	icon_state = "0-9"

/obj/structure/cable/white/knot/southwest
	icon_state = "0-10"

ABSTRACT_TYPE(/obj/structure/cable/white/straight)

/obj/structure/cable/white/straight/north_south
	icon_state = "1-2"

/obj/structure/cable/white/straight/east_west
	icon_state = "4-8"

ABSTRACT_TYPE(/obj/structure/cable/white/corner)

/obj/structure/cable/white/corner/north_east
	icon_state = "1-4"

/obj/structure/cable/white/corner/north_west
	icon_state = "1-8"

/obj/structure/cable/white/corner/south_east
	icon_state = "2-4"

/obj/structure/cable/white/corner/south_west
	icon_state = "2-8"

ABSTRACT_TYPE(/obj/structure/cable/white/bend)

/obj/structure/cable/white/bend/north_northeast
	icon_state = "1-5"

/obj/structure/cable/white/bend/north_southeast
	icon_state = "1-6"

/obj/structure/cable/white/bend/north_northwest
	icon_state = "1-9"

/obj/structure/cable/white/bend/north_southwest
	icon_state = "1-10"

/obj/structure/cable/white/bend/south_northeast
	icon_state = "2-5"

/obj/structure/cable/white/bend/south_southeast
	icon_state = "2-6"

/obj/structure/cable/white/bend/south_northwest
	icon_state = "2-9"

/obj/structure/cable/white/bend/south_southwest
	icon_state = "2-10"

/obj/structure/cable/white/bend/east_northeast
	icon_state = "4-5"

/obj/structure/cable/white/bend/east_southeast
	icon_state = "4-6"

/obj/structure/cable/white/bend/east_northwest
	icon_state = "4-9"

/obj/structure/cable/white/bend/east_southwest
	icon_state = "4-10"

/obj/structure/cable/white/bend/northeast_southeast
	icon_state = "5-6"

/obj/structure/cable/white/bend/northeast_west
	icon_state = "5-8"

/obj/structure/cable/white/bend/northeast_northwest
	icon_state = "5-9"

/obj/structure/cable/white/bend/northeast_southwest
	icon_state = "5-10"

/obj/structure/cable/white/bend/southeast_west
	icon_state = "6-8"

/obj/structure/cable/white/bend/southeast_northwest
	icon_state = "6-9"

/obj/structure/cable/white/bend/southeast_southwest
	icon_state = "6-10"

/obj/structure/cable/white/bend/west_northwest
	icon_state = "8-9"

/obj/structure/cable/white/bend/west_southwest
	icon_state = "8-10"

/obj/structure/cable/white/bend/northwest_southwest
	icon_state = "9-10"

ABSTRACT_TYPE(/obj/structure/cable/white/down)

/obj/structure/cable/white/down/north
	icon_state = "11-1"

/obj/structure/cable/white/down/south
	icon_state = "11-2"

/obj/structure/cable/white/down/east
	icon_state = "11-4"

/obj/structure/cable/white/down/west
	icon_state = "11-8"

/obj/structure/cable/white/down/northeast
	icon_state = "11-5"

/obj/structure/cable/white/down/southeast
	icon_state = "11-6"

/obj/structure/cable/white/down/northwest
	icon_state = "11-9"

/obj/structure/cable/white/down/southwest
	icon_state = "11-10"

ABSTRACT_TYPE(/obj/structure/cable/white/up)

/obj/structure/cable/white/up/knot
	icon_state = "12-0"

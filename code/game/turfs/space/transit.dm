/turf/space/transit
	name = "bluespace"
	desc = "The blue beyond, a breach into an unknown dimension. Don't lick it."
	desc_info = "Bluespace is a very strange form of pocket dimension, that is largely unpredictable and completely unexplored. While there is speculation about the possibility of celestial bodies existing in Bluespace, it is highly unlikely. Travelling in the Bluespace dimension without a proper gate or Bluespace drive has thus far been proven to be incredibly dangerous, with probes either appearing in unintended locations or never returning at all."
	icon_state = "bluespace-n"
	plane = 0
	use_space_appearance = FALSE
	use_starlight = FALSE
	light_color = COLOR_CYAN_BLUE
	light_power = 6
	light_range = 8

/turf/space/transit/Initialize()
	. = ..()
	update_light()

/turf/space/transit/ChangeTurf(var/turf/N, var/tell_universe=1, var/force_lighting_update = 0, var/allow = 0, var/keep_air = FALSE)
	return ..(N, tell_universe, 1, allow, keep_air)

//Overwrite because we dont want people building rods in space.
/turf/space/transit/attackby(obj/O, mob/user)
	return FALSE

/turf/space/transit/east
	icon_state = "bluespace-e"

/turf/space/transit/south
	icon_state = "bluespace-s"

/turf/space/transit/west
	icon_state = "bluespace-w"
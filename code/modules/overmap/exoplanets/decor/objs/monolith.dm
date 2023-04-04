/obj/structure/monolith
	name = "monolith"
	desc = "An obviously artifical structure of unknown origin."
	icon = 'icons/obj/monolith.dmi'
	icon_state = "jaggy1"
	layer = ABOVE_HUMAN_LAYER
	density = TRUE
	anchored = TRUE
	var/active = FALSE
	var/list/possible_colors = list("#232B2B", COLOR_ASTEROID_ROCK, COLOR_HULL)

/obj/structure/monolith/Initialize()
	. = ..()
	icon_state = "jaggy[rand(1,4)]"
	if(!color)
		color = pick(possible_colors)
	update_icon()

/obj/structure/monolith/update_icon()
	overlays.Cut()
	if(active)
		var/image/I = image(icon,"[icon_state]decor")
		I.appearance_flags = RESET_COLOR
		I.color = get_random_colour(0, 150, 255)
		I.layer = EFFECTS_ABOVE_LIGHTING_LAYER
		add_overlay(I)
		set_light(0.3, 0.1, 2, l_color = I.color)

	var/turf/simulated/floor/exoplanet/T = get_turf(src)
	if(istype(T))
		var/image/I = overlay_image(icon, "dugin", T.dirt_color, RESET_COLOR)
		add_overlay(I)

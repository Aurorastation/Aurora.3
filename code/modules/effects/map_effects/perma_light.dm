// Emits light forever with magic. Useful for mood lighting in Points of Interest.
// Be sure to check how it looks ingame, and fiddle with the settings until it looks right.
/obj/effect/map_effect/perma_light
	name = "permanent light"
	icon_state = "permalight"

	light_range = 3
	light_power = 1
	light_color = "#FFFFFF"

	var/uses_starlight_color = FALSE

/obj/effect/map_effect/perma_light/Initialize(mapload, ...)
	if (uses_starlight_color)
		light_color = SSskybox.background_color
		light_power = SSatlas.current_sector.starlight_power
	return ..()

/obj/effect/map_effect/perma_light/brighter
	name = "permanent light (bright)"
	icon_state = "permalight"

	light_range = 5
	light_power = 3
	light_color = "#FFFFFF"

/obj/effect/map_effect/perma_light/concentrated
	name = "permanent light (concentrated)"

	light_range = 2
	light_power = 5

/obj/effect/map_effect/perma_light/concentrated/halogen
	name = "permanent light (concentrated halogen)"

	light_color = LIGHT_COLOR_HALOGEN

/obj/effect/map_effect/perma_light/starlight
	name = "permanent starlight"
	uses_starlight_color = TRUE

/obj/effect/map_effect/perma_light/starlight/wide
	name = "permanent starlight (wide)"
	light_range = 5

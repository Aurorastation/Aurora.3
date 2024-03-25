// --------------------------------- Caprice

/obj/effect/overmap/visitable/sector/exoplanet/lava/caprice
	name = "Caprice"
	desc = "A scorching-hot volcanic planet close to Tau Ceti."
	charted = "Charted 2147CE, Sol Alliance Department of Colonization."
	icon_state = "globe1"
	color = "#cf1020"
	generated_name = FALSE
	ring_chance = 0

/obj/effect/overmap/visitable/sector/exoplanet/lava/caprice/update_icon()
	return

/obj/effect/overmap/visitable/sector/exoplanet/lava/caprice/generate_ground_survey_result()
	ground_survey_result = "" // so it does not get randomly generated survey results

// --------------------------------- Luthien

/obj/effect/overmap/visitable/sector/exoplanet/desert/luthien
	name = "Luthien"
	desc = "A desert planet with a thin, unbreathable atmosphere of primarily nitrogen."
	charted = "Charted 2147CE, Sol Alliance Department of Colonization."
	icon_state = "globe1"
	rock_colors = list("#e49135")
	color = "#e49135"
	generated_name = FALSE
	ring_chance = 0

/obj/effect/overmap/visitable/sector/exoplanet/lava/luthien/update_icon()
	return

/obj/effect/overmap/visitable/sector/exoplanet/lava/luthien/generate_ground_survey_result()
	ground_survey_result = "" // so it does not get randomly generated survey results

/obj/effect/overmap/visitable/sector/exoplanet/desert/luthien/generate_habitability()
	return HABITABILITY_BAD

// --------------------------------- Valkyrie

/obj/effect/overmap/visitable/sector/exoplanet/barren/valkyrie
	name = "Valkyrie"
	desc = "The moon of Tau Ceti, the third planet to be settled in the system."
	charted = "Natural satellite of Tau Ceti, charted 2147CE, Sol Alliance Department of Colonization."
	icon_state = "globe1"
	rock_colors = list("#4a3f41")
	color = "#4a3f41"
	generated_name = FALSE
	ring_chance = 0

/obj/effect/overmap/visitable/sector/exoplanet/barren/update_icon()
	return

/obj/effect/overmap/visitable/sector/exoplanet/barren/generate_ground_survey_result()
	ground_survey_result = "" // so it does not get randomly generated survey results

// --------------------------------- New Gibson

/obj/effect/overmap/visitable/sector/exoplanet/snow/new_gibson
	name = "New Gibson"
	desc = "An ice world just outside the outer edge of the habitable zone."
	charted = "Charted 2147CE, Sol Alliance Department of Colonization."
	icon_state = "globe1"
	generated_name = FALSE
	ring_chance = 0

/obj/effect/overmap/visitable/sector/exoplanet/snow/new_gibson/update_icon()
	return

/obj/effect/overmap/visitable/sector/exoplanet/snow/new_gibson/generate_ground_survey_result()
	ground_survey_result = "" // so it does not get randomly generated survey results

/obj/effect/overmap/visitable/sector/exoplanet/snow/new_gibson/generate_habitability()
	return HABITABILITY_BAD

// --------------------------------- Chandras

/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid/ice/chandras
	name = "Chandras"
	desc = "An an icy body in a distant orbit of Tau Ceti."
	charted = "Charted 2147CE, Sol Alliance Department of Colonization."
	icon_state = "globe1"
	color = "#b2abbf"
	rock_colors = list("#b2abbf")
	generated_name = FALSE
	ring_chance = 0

/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid/ice/chandras/update_icon()
	return

/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid/ice/chandras/generate_ground_survey_result()
	ground_survey_result = "" // so it does not get randomly generated survey results

/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid/ice/chandras/generate_habitability()
	return HABITABILITY_BAD

// --------------------------------- Dumas

/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid/dumas
	name = "Dumas"
	desc = "An extremely small rocky body that orbits within the far reaches of Tau Ceti."
	charted = "Charted 2147CE, Sol Alliance Department of Colonization."
	icon_state = "asteroid"
	generated_name = FALSE
	ring_chance = 0
	place_near_main = null

/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid/dumas/update_icon()
	return

/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid/dumas/generate_ground_survey_result()
	ground_survey_result = "" // so it does not get randomly generated survey results

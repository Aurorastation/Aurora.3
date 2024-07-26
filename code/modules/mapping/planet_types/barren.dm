/obj/effect/overmap/visitable/sector/exoplanet/barren
	name = "barren exoplanet"
	desc = "An exoplanet that couldn't hold its atmosphere."
	color = "#ad9c9c"
	scanimage = "barren.png"
	planetary_area = /area/exoplanet/barren
	rock_colors = list(COLOR_BEIGE, COLOR_GRAY80, COLOR_BROWN)
	possible_themes = list(/datum/exoplanet_theme/barren)
	features_budget = 6
	surface_color = "#807d7a"
	water_color = null
	ruin_planet_type = PLANET_BARREN
	ruin_allowed_tags = RUIN_AIRLESS|RUIN_LOWPOP|RUIN_MINING|RUIN_SCIENCE|RUIN_HOSTILE|RUIN_WRECK|RUIN_NATURAL
	unit_test_groups = list(1)

	soil_data = list("Rich iron oxide layer", "Low density silicon dioxide layer", "Large rock particle layer", "Trace organic particle layer", "Trace ice crytal layer")

/obj/effect/overmap/visitable/sector/exoplanet/barren/generate_habitability()
	return HABITABILITY_BAD

/obj/effect/overmap/visitable/sector/exoplanet/barren/generate_atmosphere()
	..()
	atmosphere = null

/obj/effect/overmap/visitable/sector/exoplanet/barren/get_surface_color()
	return "#6C6251"

/obj/effect/overmap/visitable/sector/exoplanet/barren/generate_ground_survey_result()
	..()
	if(prob(50))
		ground_survey_result += "<br>Evidence of lava tubes being present in the subsurface"
	if(prob(50))
		ground_survey_result += "<br>Water ice pockets detected deep underground"
	if(prob(50))
		ground_survey_result += "<br>No geothermal activity observed in the planetary core"
	if(prob(50))
		ground_survey_result += "<br>Micro-textural analysis indicates availability of fissile material"
	if(prob(50))
		ground_survey_result += "<br>Surface soil may provide adequate radiation shielding"
	if(prob(50))
		ground_survey_result += "<br>Silicon carbides found deep in the crust"
	if(prob(50))
		ground_survey_result += "<br>Oxygen found in locally stable metal oxides"
	if(prob(40))
		ground_survey_result += "<br>Regolith rich in heavy silicate alloys"
	if(prob(30))
		ground_survey_result += "<br>Relatively high abundance of fusile material, accumulated on the surface by the solar wind"
	if(prob(10))
		ground_survey_result += "<br>Traces of fusile material"
	if(prob(10))
		ground_survey_result += "<br>Carbon nanotubes naturally found in the regolith"

/obj/effect/overmap/visitable/sector/exoplanet/barren/generate_magnet_survey_result()
	..()
	magnet_strength = "[rand(1, 10)] uT/Gauss"
	magnet_difference = "[rand(0,2000)] kilometers"
	magnet_particles = ""
	var/list/particle_types = PARTICLE_TYPES
	var/particles = rand(2,8)
	for(var/i in 1 to particles)
		var/p = pick(particle_types)
		if(i == particles) //Last item, no comma
			magnet_particles += p
		else
			magnet_particles += "[p], "
		particle_types -= p

	day_length = "~[rand(1,200)/100] BCY (Biesel Cycles)"
	if(prob(40))
		magnet_survey_result += "<br>Pockets of zero magnetism detected"
	if(prob(40))
		magnet_survey_result += "<br>Minimal solar protection present"
	if(prob(10))
		magnet_survey_result += "<br>Rich ferromagnetic core found"

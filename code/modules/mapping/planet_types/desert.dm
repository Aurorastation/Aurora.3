/obj/effect/overmap/visitable/sector/exoplanet/desert
	name = "desert exoplanet"
	desc = "An arid exoplanet with sparse biological resources but rich mineral deposits underground."
	color = "#a08444"
	scanimage = "desert.png"
	geology = "Non-existent tectonic activity, minimal geothermal signature"
	weather = "Global full-atmosphere geothermal weather system. Barely-habitable ambient high temperatures. Slow-moving, stagnant meteorological activity prone to unpredictable upset in wind condition"
	planetary_area = /area/exoplanet/desert
	initial_weather_state = /singleton/state/weather/calm/desert_planet
	rock_colors = list(COLOR_BEIGE, COLOR_PALE_YELLOW, COLOR_GRAY80, COLOR_BROWN)
	plant_colors = list("#efdd6f","#7b4a12","#e49135","#ba6222","#5c755e","#420d22")
	possible_themes = list(/datum/exoplanet_theme/desert)
	flora_diversity = 4
	has_trees = FALSE
	surface_color = "#d6cca4"
	water_color = null
	ruin_planet_type = PLANET_DESERT
	ruin_allowed_tags = RUIN_LOWPOP|RUIN_MINING|RUIN_SCIENCE|RUIN_HOSTILE|RUIN_WRECK|RUIN_NATURAL
	soil_data = list("Low density silicon dioxide layer", "Trace gold dust layer", "Trace silver dust layer", "Large rock particle layer", "Trace organic particle layer")
	water_data = list("Sodium ions present", "Calcium ions present", "Sulfate ions present", "Magnesium ions present", "Copper ions present")

	unit_test_groups = list(1)

/obj/effect/overmap/visitable/sector/exoplanet/desert/generate_map()
	lightlevel = rand(5,10)/10	//deserts are usually :lit:
	..()

/obj/effect/overmap/visitable/sector/exoplanet/desert/generate_atmosphere()
	..()
	if(atmosphere)
		var/limit = 1000
		if(habitability_class <= HABITABILITY_OKAY)
			var/datum/species/human/H = /datum/species/human
			limit = initial(H.heat_level_1) - rand(1,10)
		atmosphere.temperature = min(T20C + rand(20, 100), limit)
		atmosphere.update_values()

/obj/effect/overmap/visitable/sector/exoplanet/desert/generate_ground_survey_result()
	..()
	if(prob(40))
		ground_survey_result += "<br>High quality natural fertilizer found in subterranean pockets"
	if(prob(40))
		ground_survey_result += "<br>High nitrogen and phosphorus contents of the soil"
	if(prob(40))
		ground_survey_result += "<br>Chemical extraction indicates soil is rich in major and secondary nutrients for agriculture"
	if(prob(40))
		ground_survey_result += "<br>Analysis indicates low contaminants of the soil"
	if(prob(40))
		ground_survey_result += "<br>Soft clays detected, composed of quartz and calcites"
	if(prob(40))
		ground_survey_result += "<br>Muddy dirt rich in organic material"
	if(prob(40))
		ground_survey_result += "<br>Stratigraphy indicates low risk of tectonic activity in this region"
	if(prob(40))
		ground_survey_result += "<br>Fossilized organic material found settled in sedimentary rock"
	if(prob(10))
		ground_survey_result += "<br>Traces of fissile material"

/obj/effect/overmap/visitable/sector/exoplanet/desert/generate_magnet_survey_result()
	..()
	magnet_strength = "[rand(10, 100)] uT/Gauss"
	magnet_difference = "[rand(0,1500)] kilometers"
	magnet_particles = ""
	var/list/particle_types = PARTICLE_TYPES
	var/particles = rand(1,5)
	for(var/i in 1 to particles)
		var/p = pick(particle_types)
		if(i == particles) //Last item, no comma
			magnet_particles += p
		else
			magnet_particles += "[p], "
		particle_types -= p
	day_length = "~[rand(1,200)/10] BCY (Biesel Cycles)"
	if(prob(40))
		magnet_survey_result += "<br>Highly variable magnetic flux detected"
	if(prob(40))
		magnet_survey_result += "<br>Strong solar winds present"
	if(prob(10))
		magnet_survey_result += "<br>High levels of plasma present in magnetosphere"

/obj/effect/overmap/visitable/sector/exoplanet/desert/adapt_seed(var/datum/seed/S)
	..()
	if(prob(90))
		S.set_trait(TRAIT_REQUIRES_WATER,0)
	else
		S.set_trait(TRAIT_REQUIRES_WATER,1)
		S.set_trait(TRAIT_WATER_CONSUMPTION,1)
	if(prob(75))
		S.set_trait(TRAIT_STINGS,1)
	if(prob(75))
		S.set_trait(TRAIT_CARNIVOROUS,2)
	S.set_trait(TRAIT_SPREAD,0)

/obj/structure/quicksand
	name = "sand"
	icon = 'icons/obj/quicksand.dmi'
	icon_state = "intact0"
	density = 0
	anchored = 1
	can_buckle = 1
	buckle_dir = SOUTH
	var/exposed = 0
	var/busy

/obj/structure/quicksand/New()
	icon_state = "intact[rand(0,2)]"
	..()

/obj/structure/quicksand/user_unbuckle(mob/user)
	if(buckled && !user.stat && !user.restrained())
		if(busy)
			to_chat(user, "<span class='wanoticerning'>[buckled] is already getting out, be patient.</span>")
			return
		var/delay = 60
		if(user == buckled)
			delay *=2
			user.visible_message(
				SPAN_NOTICE("\The [user] tries to climb out of \the [src]."),
				SPAN_NOTICE("You begin to pull yourself out of \the [src]."),
				SPAN_NOTICE("You hear water sloushing.")
				)
		else
			user.visible_message(
				SPAN_NOTICE("\The [user] begins pulling \the [buckled] out of \the [src]."),
				SPAN_NOTICE("You begin to pull \the [buckled] out of \the [src]."),
				SPAN_NOTICE("You hear water sloushing.")
				)
		busy = 1
		if(do_after(user, delay, src))
			busy = 0
			if(user == buckled)
				if(prob(80))
					to_chat(user, SPAN_WARNING("You slip and fail to get out!"))
					return
				user.visible_message(SPAN_NOTICE("\The [buckled] pulls himself out of \the [src]."))
			else
				user.visible_message(SPAN_NOTICE("\The [buckled] has been freed from \the [src] by \the [user]."))
			unbuckle()
		else
			busy = 0
			to_chat(user, SPAN_WARNING("You slip and fail to get out!"))
			return

/obj/structure/quicksand/unbuckle()
	..()
	update_icon()

/obj/structure/quicksand/buckle(var/mob/L)
	..()
	update_icon()

/obj/structure/quicksand/update_icon()
	if(!exposed)
		return
	icon_state = "open"
	overlays.Cut()
	if(buckled)
		overlays += buckled
		var/image/I = image(icon,icon_state="overlay")
		I.layer = ABOVE_HUMAN_LAYER
		overlays += I

/obj/structure/quicksand/proc/expose()
	if(exposed)
		return
	visible_message(SPAN_WARNING("The upper crust breaks, exposing treacherous quicksands underneath!"))
	name = "quicksand"
	desc = "There is no candy at the bottom."
	exposed = 1
	update_icon()

/obj/structure/quicksand/attackby(obj/item/attacking_item, mob/user)
	if(!exposed && attacking_item.force)
		expose()
	else
		..()

/obj/structure/quicksand/Crossed(var/atom/movable/AM)
	if(isliving(AM))
		var/mob/living/L = AM
		if(L.throwing)
			return
		buckle(L)
		if(!exposed)
			expose()
		to_chat(L, SPAN_DANGER("You fall into \the [src]!"))

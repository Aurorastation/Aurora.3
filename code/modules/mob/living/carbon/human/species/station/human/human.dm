/datum/species/human
	name = "Human"
	hide_name = TRUE
	short_name = "hum"
	name_plural = "Humans"
	bodytype = "Human"
	age_max = 125
	economic_modifier = 12

	primitive_form = "Monkey"
	unarmed_types = list(
		/datum/unarmed_attack/stomp,
		/datum/unarmed_attack/kick,
		/datum/unarmed_attack/punch,
		/datum/unarmed_attack/bite
	)
	blurb = "Humanity originated in the Sol system, and over the last four centuries has spread colonies across a wide swathe of space. \
	They hold a wide range of forms and creeds.<br><br>\
	The Sol Alliance is still massively influential, but independent human nations have managed to shake off its dominance and forge their \
	own path. Driven by an unending hunger for wealth, powerful corporate interests are bringing untold wealth to humanity. Unchecked \
	megacorporations have sparked secretive factions to fight their influence, while there is always the risk of someone digging too \
	deep into the secrets of the galaxy..."
	num_alternate_languages = 2
	secondary_langs = list(LANGUAGE_SOL_COMMON, LANGUAGE_SIIK_TAU)
	name_language = null // Use the first-name last-name generator rather than a language scrambler
	mob_size = 9
	spawn_flags = CAN_JOIN
	appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_TONE | HAS_LIPS | HAS_UNDERWEAR | HAS_EYE_COLOR | HAS_SOCKS
	remains_type = /obj/effect/decal/remains/human

	stamina = 130	// Humans can sprint for longer than any other species
	stamina_recovery = 5
	sprint_speed_factor = 0.9
	sprint_cost_factor = 0.5

	climb_coeff = 1
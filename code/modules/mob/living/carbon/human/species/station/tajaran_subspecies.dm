/datum/species/tajaran/zhan_khazan
	name = "Zhan-Khazan Tajara"
	name_plural = "Zhan-Khazan Tajaran"
	blurb = "The Zhan-Khazan are a race of Tajara known for their dark fur and large bulky figures. \
	They were at one point a race of cave-and-mountain dwelling Tajara that traditionally were \
	entrusted with physical work like mining, farming, ranching, and logging. Zhan-Khazan make \
	up a significant amount of Tajara employed in resource gathering, construction, civil jobs \
	such as law enforcement and even culinary work such as butchering. They experience a lot of racism \
	from their fellow Tajara who cite their lackluster test scores, even among Tajara, and their higher \
	crime rates."

	secondary_langs = list(LANGUAGE_SIIK_MAAS, LANGUAGE_SIIK_TAJR, LANGUAGE_DELVAHII, LANGUAGE_SIIK_TAU)

	slowdown = -0.8 //As opposed to -1 for Base tajara
	sprint_speed_factor = 0.55 // As opposed to 0.65
	stamina = 100 // As opposed to 90
	brute_mod = 1.1 // Less Brute Damage
	ethanol_resistance = 1 // Default value
	climb_coeff = 1.1

	cold_level_1 = 160 //RaceDefault 200 Default 260
	cold_level_2 = 100 //RaceDefault 140 Default 200
	cold_level_3 = 50  //RaceDefault 80 Default 120

	heat_level_1 = 320 //RaceDefault 330 Default 360
	heat_level_2 = 360 //RaceDefault 380 Default 400
	heat_level_3 = 700 //RaceDefault 800 Default 1000

	primitive_form = "Zhan-Khazan Farwa"

	num_alternate_languages = 1 // Only one Extra Language

/datum/species/tajaran/m_sai
	name = "M'sai Tajara"
	name_plural = "M'sai Tajaran"
	blurb = "The M'sai are a race of Tajara with slender lithe bodies and \
	lightly covered fur which blends in with the snowy environments of Adhomai. \
	They aren't as well-insulated against Adhomai's cold as their brethren. \
	However, this gives them the benefit of being more agile. Hitorically, they often \
	worked as hunters, later becoming warriors and soldiers as civilization developed."

	slowdown = -1.2 //As opposed to -1 for Base tajara
	sprint_speed_factor = 0.75 // As opposed to 0.65
	stamina = 80 // As opposed to 90
	brute_mod = 1.3 // More Brute Damage
	ethanol_resistance = 0.6 // Species Default 0.8

	cold_level_1 = 220 //RaceDefault 200 Default 260
	cold_level_2 = 160 //RaceDefault 140 Default 200
	cold_level_3 = 100  //RaceDefault 80 Default 120

	heat_level_1 = 340 //RaceDefault 330 Default 360
	heat_level_2 = 390 //RaceDefault 380 Default 400
	heat_level_3 = 900 //RaceDefault 800 Default 1000

	primitive_form = "M'sai Farwa"

	secondary_langs = list(LANGUAGE_SIIK_MAAS, LANGUAGE_SIIK_TAJR, LANGUAGE_SIGN_TAJARA, LANGUAGE_SIIK_TAU)

/datum/species/tajaran/zhan_khazan
    name = "Zhan-Khazan Tajara"
    name_plural = "Zhan-Khazan Tajaran"
    blurb = "Zhan-Khazan are the second most populous of Tajaran ethnicities, and are considered to be \
    the backbone of the Tajaran workforce. Their history as an ethnicity is one not well documented; \
    very little historical texts describing them were preserved in the wake of the Great War, and archaeological \
    dig sites are difficult to preserve given the climate of Adhomai. What is known, however, is that the Zhan-Khazan \
    were at one point a race of cave-and-mountain dwelling Tajara that traditionally were entrusted with physical work \
    like mining, farming, ranching, and logging. "

    slowdown = -0.8 //As opposed to -1 for Base tajara
    sprint_speed_factor = 0.55 // As opposed to 0.65
    stamina = 100 // As opposed to 90
    brute_mod = 1.1 // Less Brute Damage
    ethanol_resistance = 1 // Default value

    cold_level_1 = 160 //RaceDefault 200 Default 260
    cold_level_2 = 100 //RaceDefault 140 Default 200
    cold_level_3 = 50  //RaceDefault 80 Default 120

    heat_level_1 = 320 //RaceDefault 330 Default 360
    heat_level_2 = 360 //RaceDefault 380 Default 400
    heat_level_3 = 700 //RaceDefault 800 Default 1000

    num_alternate_languages = 1 // Only one Extra Language

/datum/species/tajaran/m_sai
    name = "M'sai Tajara"
    name_plural = "M'sai Tajaran"
    blurb = "As the third (though only by a small margin) populous Tajaran ethnic group, the M'sai were at one point \
    the hunters for ancient Tajara and evolved to have lithe, slender forms, and light fur that hid them in the blizzards on Adhomai. \
    As Tajaran society advanced, M'sai could be found in many roles related to combat, including law enforcement and military service. \
    Not all M'sai resign themselves to these positions, however, and enjoy helping Zhan-Khazan on the country farms or performing \
    civil duties in cities from garbage disposal to cargo inspections."

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

    secondary_langs = list(LANGUAGE_SIIK_MAAS, LANGUAGE_SIIK_TAJR, LANGUAGE_SIGN_TAJARA)

// This is a hack around intolerant unit tests.
#define HOLODECK HOLODECK

/datum/map/aurora
	holodeck_programs = list(
		"emptycourt" = new /datum/holodeck_program(
			HOLODECK/source_emptycourt,
			list('sound/music/THUNDERDOME.ogg')
		),
		"boxingcourt" = new /datum/holodeck_program(
			HOLODECK/source_boxingcourt,
			list('sound/music/THUNDERDOME.ogg')
		),
		"basketball" = new /datum/holodeck_program(
			HOLODECK/source_basketball,
			list('sound/music/THUNDERDOME.ogg')
		),
		"thunderdomecourt" = new /datum/holodeck_program(
			HOLODECK/source_thunderdomecourt,
			list('sound/music/THUNDERDOME.ogg')
		),
		"beach" = new /datum/holodeck_program(HOLODECK/source_beach),
		"desert" = new /datum/holodeck_program(
			HOLODECK/source_desert,
			list(
				'sound/effects/wind/wind_2_1.ogg',
				'sound/effects/wind/wind_2_2.ogg',
				'sound/effects/wind/wind_3_1.ogg',
				'sound/effects/wind/wind_4_1.ogg',
				'sound/effects/wind/wind_4_2.ogg',
				'sound/effects/wind/wind_5_1.ogg'
			)
		),
		"snowfield" = new /datum/holodeck_program(
			HOLODECK/source_snowfield,
			list(
				'sound/effects/wind/wind_2_1.ogg',
				'sound/effects/wind/wind_2_2.ogg',
				'sound/effects/wind/wind_3_1.ogg',
				'sound/effects/wind/wind_4_1.ogg',
				'sound/effects/wind/wind_4_2.ogg',
				'sound/effects/wind/wind_5_1.ogg'
			)
		),
		"space" = new /datum/holodeck_program(
			HOLODECK/source_space,
			list(
				'sound/ambience/ambispace.ogg',
				'sound/music/main.ogg',
				'sound/music/space.ogg',
				'sound/music/traitor.ogg'
			)
		),
		"picnicarea" = new /datum/holodeck_program(
			HOLODECK/source_picnicarea,
			list('sound/music/title2.ogg')
		),
		"theatre" = new /datum/holodeck_program(HOLODECK/source_theatre),
		"meetinghall" = new /datum/holodeck_program(HOLODECK/source_meetinghall),
		"courtroom" = new /datum/holodeck_program(
			HOLODECK/source_courtroom, 
			list('sound/music/traitor.ogg')
		),
		"burntest" = new /datum/holodeck_program(
			HOLODECK/source_burntest,
			list()
		),
		"wildlifecarp" = new /datum/holodeck_program(
			HOLODECK/source_wildlife,
			list()
		),
		"chapel" = new /datum/holodeck_program(
			HOLODECK/source_chapel,
			list(
				'sound/ambience/ambicha1.ogg',
				'sound/ambience/ambicha2.ogg',
				'sound/ambience/ambicha3.ogg',
				'sound/ambience/ambicha4.ogg',
				'sound/music/traitor.ogg'
			)
		),
		"gym" = new /datum/holodeck_program(HOLODECK/source_gym),
		"turnoff" = new /datum/holodeck_program(
			HOLODECK/source_plating,
			list()
		)
	)

	holodeck_supported_programs = list(
		"Empty Court"       = "emptycourt",
		"Basketball Court"  = "basketball",
		"Thunderdome Court" = "thunderdomecourt",
		"Boxing Ring"       = "boxingcourt",
		"Beach"             = "beach",
		"Desert"            = "desert",
		"Space"             = "space",
		"Picnic Area"       = "picnicarea",
		"Snow Field"        = "snowfield",
		"Theatre"           = "theatre",
		"Meeting Hall"      = "meetinghall",
		"Courtroom"         = "courtroom",
		"Chapel"            = "chapel",
		"Xavier Trasen Memorial Gymnasium" = "gym"
	)
	holodeck_restricted_programs = list(
		"Atmospheric Burn Simulation" = "burntest",
		"Wildlife Simulation" = "wildlifecarp"
	)

#undef HOLODECK

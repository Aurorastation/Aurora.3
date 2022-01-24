/datum/map/aurora
	holodeck_programs = list(
		"emptycourt" = new /datum/holodeck_program(/area/holodeck/source_emptycourt,
			list('sound/music/THUNDERDOME.ogg')
		),
		"boxingcourt" = new /datum/holodeck_program(/area/holodeck/source_boxingcourt,
			list('sound/music/THUNDERDOME.ogg')
		),
		"basketball" = new /datum/holodeck_program(/area/holodeck/source_basketball,
			list('sound/music/THUNDERDOME.ogg')
		),
		"thunderdomecourt" = new /datum/holodeck_program(/area/holodeck/source_thunderdomecourt,
			list('sound/music/THUNDERDOME.ogg')
		),
		"beach" = new /datum/holodeck_program(/area/holodeck/source_beach),
		"desert" = new /datum/holodeck_program(/area/holodeck/source_desert,
			list(
				'sound/effects/wind/wind_2_1.ogg',
				'sound/effects/wind/wind_2_2.ogg',
				'sound/effects/wind/wind_3_1.ogg',
				'sound/effects/wind/wind_4_1.ogg',
				'sound/effects/wind/wind_4_2.ogg',
				'sound/effects/wind/wind_5_1.ogg'
			)
		),
		"snowfield" = new /datum/holodeck_program(/area/holodeck/source_snowfield,
			list(
				'sound/effects/wind/wind_2_1.ogg',
				'sound/effects/wind/wind_2_2.ogg',
				'sound/effects/wind/wind_3_1.ogg',
				'sound/effects/wind/wind_4_1.ogg',
				'sound/effects/wind/wind_4_2.ogg',
				'sound/effects/wind/wind_5_1.ogg'
			)
		),
		"space" = new /datum/holodeck_program(/area/holodeck/source_space,
			list(
				'sound/ambience/space/space_serithi.ogg',
				'sound/ambience/space/space1.ogg'
			)
		),
		"picnicarea" = new /datum/holodeck_program(/area/holodeck/source_picnicarea,
			list('sound/music/title2.ogg')
		),
		"dininghall" = new /datum/holodeck_program(/area/holodeck/source_dininghall,
			list('sound/music/title2.ogg')
		),
		"theatre" = new /datum/holodeck_program(/area/holodeck/source_theatre),
		"meetinghall" = new /datum/holodeck_program(/area/holodeck/source_meetinghall),
		"courtroom" = new /datum/holodeck_program(/area/holodeck/source_courtroom,
			list('sound/music/traitor.ogg')
		),
		"burntest" = new /datum/holodeck_program(/area/holodeck/source_burntest, list()),
		"wildlifecarp" = new /datum/holodeck_program(/area/holodeck/source_wildlife, list()),
		"chapel" = new /datum/holodeck_program(/area/holodeck/source_chapel,
			list(
				'sound/ambience/chapel/chapel1.ogg',
				'sound/ambience/chapel/chapel2.ogg',
				'sound/ambience/chapel/chapel3.ogg',
				'sound/ambience/chapel/chapel4.ogg'
			)
		),
		"gym" = new /datum/holodeck_program(/area/holodeck/source_gym),
		"battlemonsters" = new /datum/holodeck_program(/area/holodeck/source_battlemonsters,
			list(
				'sound/music/battlemonsters_theme.ogg'
			),
			FALSE
		),
		"turnoff" = new /datum/holodeck_program(/area/holodeck/source_plating)
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
		"Dining Hall"       = "dininghall",
		"Snow Field"        = "snowfield",
		"Theatre"           = "theatre",
		"Meeting Hall"      = "meetinghall",
		"Courtroom"         = "courtroom",
		"Chapel"            = "chapel",
		"Xavier Trasen Memorial Gymnasium" = "gym",
		"Battle Monsters Duelling Arena" = "battlemonsters"
	)
	holodeck_restricted_programs = list(
		"Atmospheric Burn Simulation" = "burntest",
		"Wildlife Simulation" = "wildlifecarp"
	)

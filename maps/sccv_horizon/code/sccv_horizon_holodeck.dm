/datum/map/sccv_horizon
	holodeck_programs = list(
		"emptycourt" = new /datum/holodeck_program(/area/horizon/holodeck/source_emptycourt,
			list('sound/music/THUNDERDOME.ogg')
		),
		"boxingcourt" = new /datum/holodeck_program(/area/horizon/holodeck/source_boxingcourt,
			list('sound/music/THUNDERDOME.ogg')
		),
		"basketball" = new /datum/holodeck_program(/area/horizon/holodeck/source_basketball,
			list('sound/music/THUNDERDOME.ogg')
		),
		"thunderdomecourt" = new /datum/holodeck_program(/area/horizon/holodeck/source_thunderdomecourt,
			list('sound/music/THUNDERDOME.ogg')
		),
		"beach" = new /datum/holodeck_program(/area/horizon/holodeck/source_beach),
		"desert" = new /datum/holodeck_program(/area/horizon/holodeck/source_desert,
			list(
				'sound/effects/wind/wind_2_1.ogg',
				'sound/effects/wind/wind_2_2.ogg',
				'sound/effects/wind/wind_3_1.ogg',
				'sound/effects/wind/wind_4_1.ogg',
				'sound/effects/wind/wind_4_2.ogg',
				'sound/effects/wind/wind_5_1.ogg'
			)
		),
		"snowfield" = new /datum/holodeck_program(/area/horizon/holodeck/source_snowfield,
			list(
				'sound/effects/wind/wind_2_1.ogg',
				'sound/effects/wind/wind_2_2.ogg',
				'sound/effects/wind/wind_3_1.ogg',
				'sound/effects/wind/wind_4_1.ogg',
				'sound/effects/wind/wind_4_2.ogg',
				'sound/effects/wind/wind_5_1.ogg'
			)
		),
		"space" = new /datum/holodeck_program(/area/horizon/holodeck/source_space,
			list(
				'sound/music/ambispace.ogg',
				'sound/music/main.ogg',
				'sound/music/lobby/space.ogg',
				'sound/music/lobby/traitor.ogg'
			)
		),
		"picnicarea" = new /datum/holodeck_program(/area/horizon/holodeck/source_picnicarea,
			list('sound/music/lobby/title2.ogg')
		),
		"dininghall" = new /datum/holodeck_program(/area/horizon/holodeck/source_dininghall,
			list('sound/music/lobby/title2.ogg')
		),
		"theatre" = new /datum/holodeck_program(/area/horizon/holodeck/source_theatre),
		"meetinghall" = new /datum/holodeck_program(/area/horizon/holodeck/source_meetinghall),
		"courtroom" = new /datum/holodeck_program(/area/horizon/holodeck/source_courtroom,
			list('sound/music/lobby/traitor.ogg')
		),
		"burntest" = new /datum/holodeck_program(/area/horizon/holodeck/source_burntest, list()),
		"wildlifecarp" = new /datum/holodeck_program(/area/horizon/holodeck/source_wildlife, list()),
		"chapel" = new /datum/holodeck_program(/area/horizon/holodeck/source_chapel, list()),
		"gym" = new /datum/holodeck_program(/area/horizon/holodeck/source_gym),
		"battlemonsters" = new /datum/holodeck_program(/area/horizon/holodeck/source_battlemonsters,
			list(
				'sound/music/battlemonsters_theme.ogg'
			),
			FALSE
		),
		"biesel" = new /datum/holodeck_program(/area/horizon/holodeck/source_biesel,
			list(
				'sound/effects/wind/wind_2_1.ogg',
				'sound/effects/wind/wind_2_2.ogg',
				'sound/effects/wind/wind_3_1.ogg',
				'sound/effects/wind/wind_4_1.ogg',
				'sound/effects/wind/wind_4_2.ogg',
				'sound/effects/wind/wind_5_1.ogg'
			)
		),
		"jupiter" = new /datum/holodeck_program(/area/horizon/holodeck/source_jupiter,
			list(
				'sound/effects/wind/wind_2_1.ogg',
				'sound/effects/wind/wind_2_2.ogg',
				'sound/effects/wind/wind_3_1.ogg',
				'sound/effects/wind/wind_4_1.ogg',
				'sound/effects/wind/wind_4_2.ogg',
				'sound/effects/wind/wind_5_1.ogg'
			)
		),
		"chapel_tribunal" = new /datum/holodeck_program(/area/horizon/holodeck/source_tribunal),
		"chapel_trinary" = new /datum/holodeck_program(/area/horizon/holodeck/source_trinary),
		"konyang" = new /datum/holodeck_program(/area/horizon/holodeck/source_konyang),
		"moghes" = new /datum/holodeck_program(/area/horizon/holodeck/source_moghes),
		"adhomai" = new /datum/holodeck_program(/area/horizon/holodeck/source_adhomai),
		"pool" = new /datum/holodeck_program(/area/horizon/holodeck/source_pool),
		"sauna" = new /datum/holodeck_program(/area/horizon/holodeck/source_sauna),
		"animal_cafe" = new /datum/holodeck_program(/area/horizon/holodeck/source_cafe),
		"turnoff" = new /datum/holodeck_program(/area/horizon/holodeck/source_plating)
	)

	holodeck_supported_programs = list(
		"Empty Court"        = "emptycourt",
		"Basketball Court"   = "basketball",
		"Animal Cafe"		 = "animal_cafe",
		"Thunderdome Court"  = "thunderdomecourt",
		"Boxing Ring"        = "boxingcourt",
		"Silversun Coast"    = "beach",
		"Desert"             = "desert",
		"Space"              = "space",
		"Picnic Area"        = "picnicarea",
		"Dining Hall"        = "dininghall",
		"Swimming Pool"      = "pool",
		"Sauna"      = "sauna",
		"Bursa Tundra"       = "snowfield",
		"Adhomian Campfire"  = "adhomai",
		"Moghresian Jungle"  = "moghes",
		"Callistean Theatre" = "theatre",
		"Meeting Hall"       = "meetinghall",
		"Courtroom"          = "courtroom",
		"Chapel"             = "chapel",
		"Tribunalist Chapel" = "chapel_tribunal",
		"Trinarist Chapel"   = "chapel_trinary",
		"Foggy Mendell Skyline" = "biesel",
		"Konyanger Boardwalk" = "konyang",
		"Jupiter Upper Atmosphere" = "jupiter",
		"Xavier Trasen Memorial Gymnasium" = "gym",
		"Battle Monsters Duelling Arena" = "battlemonsters",
		"Chessboard" = "chessboard"
	)
	holodeck_restricted_programs = list(
		"Atmospheric Burn Simulation" = "burntest",
		"Wildlife Simulation" = "wildlifecarp"
	)

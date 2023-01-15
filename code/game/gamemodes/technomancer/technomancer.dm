/datum/game_mode/technomancer
	name = "Technomancer"
	config_tag = "technomancer"
	votable = 1
	max_players = 15
	required_players = 5
	required_enemies = 1
	antag_tags = list(MODE_TECHNOMANCER)

/datum/game_mode/technomancer/pre_setup()
	round_description = "An entity possessing advanced, unknown technology is onboard, who is capable of accomplishing amazing feats."
	extended_round_description = "A powerful entity capable of manipulating space around them, has arrived on the [current_map.station_type]. \
	They have a wide variety of powers and functions available to them that makes your own simple moral self tremble with \
	fear and excitement. Ultimately, their purpose is unknown. However, it is up to you and your crew to decide if \
	their powers can be used for good or if their arrival foreshadows the destruction of the entire [current_map.station_type], or worse."
	. = ..()

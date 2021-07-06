/datum/game_mode/heist
	name = "heist"
	config_tag = "heist"
	required_players = 15
	required_enemies = 4
	round_description = "An unidentified bluespace signature has slipped past the Icarus and is approaching the station!"
	extended_round_description = "The galaxy is a place full of dangers, even the inner colonies are not free of such scourges. \
	Raiders and pirates are a well-know threat in the inhabited space, and places such as space stations are easy targets \
	for their greedy plans."
	end_on_antag_death = 1
	antag_tags = list(MODE_RAIDER)

/datum/game_mode/heist/apprentices
	name = "magistake"
	config_tag = "magistake"
	extended_round_description = "The galaxy is a place full of dangers, even the inner colonies are not free of such scourges. \
	Some say that the best raiders have a touch of magic to their art of plunder, but that's just hearsay."
	antag_tags = list(MODE_RAIDER_TECHNO)
	required_players = 12
	required_enemies = 3
/datum/game_mode/ninja
	name = "ninjas"
	config_tag = "ninja"
	required_players = 15
	max_players = 30
	required_enemies = 2
	antag_tags = list(MODE_NINJA)

/datum/game_mode/ninja/pre_setup()
	round_description = "An agent of the Spider Clan is onboard the [current_map.station_type]!"
	extended_round_description = "What was that?! Was that a person or did your eyes just play tricks on you? \
		You have no idea. Those slim-suited, cryptic individuals are an enigma to you and all of your knowledge. \
		Their purpose is unknown. Their mission is unknown. How they arrived to this secure and isolated \
		section of the galaxy, you don't know. What you do know is that there are silent shadow-stalkers piercing \
		through the defenses of the [current_map.station_type] with technological capabilities eons ahead of your time. They can avoid \
		the omniscience of the AI and rival the most hardened weapons your [current_map.station_type] is capable of. Tread lightly and \
		only hope these unknown assassins aren't here for you."
	. = ..()

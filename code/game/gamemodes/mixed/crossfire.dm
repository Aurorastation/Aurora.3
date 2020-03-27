/datum/game_mode/crossfire
	name = "Crossfire (Merc+Heist)"
	round_description = "Mercenaries and raiders are approaching the station."
	extended_round_description = "NanoTrasen's wealth and success created several enemies over the years \
		and many seek to undermine them using illegal ways. Their crown jewel research stations are not safe from those \
		malicious activities."
	config_tag = "crossfire"
	required_players = 25
	required_enemies = 8
	end_on_antag_death = 0
	antag_tags = list(MODE_RAIDER, MODE_MERCENARY)
	require_all_templates = 1

// lowpop heist

/datum/game_mode/burglars
	name = "burglars"
	config_tag = "burglars"
	max_players = 15
	required_enemies = 2
	required_players = 4
	round_description = "Something tiny is on the horizon! Is it the distance, or...?"
	antag_tags = list(MODE_BURGLAR)

/datum/game_mode/burglars/pre_setup()
	extended_round_description = "Two of the Orion Spur's best and brightest (or so they were told) have been tasked with burglarizing a high-grade facility that will change the way capitalism grips this galaxy forever (or so they were told). It is up to the crew to repel them, and up to them to survive and possibly thrive."
	. = ..()

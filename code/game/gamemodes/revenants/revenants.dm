/datum/game_mode/revenants
	name = "Revenants"
	config_tag = "revenants"
	required_players = 10
	required_enemies = 0
	round_autoantag = TRUE
	var/first_spawn_delay = 20 MINUTES
	min_autotraitor_delay = 3 MINUTES
	max_autotraitor_delay = 6 MINUTES
	antag_scaling_coeff = 4 // four people can handle one revenant pretty easily
	round_description = "A bluespace tear has opened up in the space around us, who knows what could invade?"
	extended_round_description = "This a wave defense gamemode. The crew all have to work together to repel an endless horde of bluespace horrors."
	antag_tags = list(MODE_REVENANT)

/datum/game_mode/revenants/New()
	..()
	first_spawn_delay = rand(20 MINUTES, 30 MINUTES)

/datum/game_mode/revenants/process_autoantag()
	if(world.time - round_start_time < first_spawn_delay)
		return
	var/datum/ghostspawner/revenant/R = SSghostroles.get_spawner(MODE_REVENANT)
	var/datum/antagonist/A = GLOB.all_antag_types[MODE_REVENANT]
	A.update_current_antag_max()
	var/previous_count = R.max_count
	R.max_count = min(R.max_count + 1, A.cur_max)
	if(R.max_count > previous_count)
		say_dead_direct("A slot for a Revenant as opened up!<br>Spawn in as it by using the ghost spawner menu in the ghost tab, and try to be good!")
	if(!R.enabled)
		R.enable()
	next_spawn = world.time + rand(min_autotraitor_delay, max_autotraitor_delay)

/datum/responseteam
	var/name = "Default Team"					//ERT name.
	var/max_players = 5							//Fill until this quota is reached.
	var/specialists = 1							//Number of specialist slots.
	var/arrival_message							//The message that we send to newly spawned mobs.
	var/chance									//Probability to get picked.

	var/list/datum/mind/players					//Living player minds.
	var/mob/living/leader						//Living leader.
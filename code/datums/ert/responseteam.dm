/datum/responseteam
	var/name = "Default Team"					//ERT name.
	var/responders = 4							//Amount of base responder slots. These are the normal guys.
	var/specialists = 2							//Amount of base specialist slots. Used upon spawning in the ghost spawner.
	var/leaders = 1								//Leader slots
	var/spawn_message							//The message that we send to newly spawned mobs.
	var/chance									//Probability to get picked.
	var/list/species = list()					//If this ERT is limited to only some species.

	var/datum/outfit/leader_outfit
	var/datum/outfit/specialist_outfit
	var/datum/outfit/grunt_outfit

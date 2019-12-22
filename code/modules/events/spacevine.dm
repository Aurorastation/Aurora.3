/var/global/spacevines_spawned = 0

/datum/event/spacevine
	announceWhen	= 30
	ic_name = "a biohazard"

/datum/event/spacevine/start()
	spacevine_infestation()
	spacevines_spawned = 1

/datum/event/spacevine/announce()
	level_seven_announcement()

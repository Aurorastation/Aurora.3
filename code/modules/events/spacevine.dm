/datum/event/spacevine
	announceWhen	= 30
	ic_name = "a biohazard"

/datum/event/spacevine/start()
	..()

	spacevine_infestation()

/datum/event/spacevine/announce()
	level_seven_announcement(affecting_z)

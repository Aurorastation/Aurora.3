GLOBAL_DATUM(storytellers, /datum/antagonist/storyteller)

/datum/antagonist/storyteller
	id = MODE_STORYTELLER
	role_text = "Storyteller"
	role_text_plural = "Storytellers"
	welcome_text = "You are a Storyteller. Basically a discount admin."
	faction = "storyteller"
	flags = ANTAG_NO_ROUNDSTART_SPAWN | ANTAG_OVERRIDE_JOB
	mob_path = null

	bantype = "storyteller"

/datum/antagonist/storyteller/New()
	..()
	GLOB.storytellers = src

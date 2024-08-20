GLOBAL_DATUM(storytellers, /datum/antagonist/storyteller)

/datum/antagonist/storyteller
	id = MODE_STORYTELLER
	role_text = "Storyteller"
	role_text_plural = "Storytellers"
	welcome_text = "You are a Storyteller. Basically a discount admin."
	faction = "storyteller"
	flags = ANTAG_NO_ROUNDSTART_SPAWN

	bantype = "storyteller"

/datum/antagonist/storyteller/New()
	..(1)
	GLOB.storytellers = src

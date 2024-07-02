GLOBAL_LIST_EMPTY_TYPED(storytellers, /datum/antagonist/storyteller)

/datum/antagonist/storyteller
	id = MODE_STORYTELLER
	landmark_id = "Storyteller"
	role_text = "Storyteller"
	role_text_plural = "Storytellers"
	welcome_text = "You are a Storyteller. Live out your GM fantasy."
	faction = "Storyteller"

	bantype = "storyteller"

	mob_path = /mob/abstract/storyteller
	id_type = null
	valid_species = list()
	allow_no_mob = TRUE

/datum/antagonist/storyteller/New()
	..(1)
	GLOB.storytellers = src

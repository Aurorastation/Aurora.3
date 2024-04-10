GLOBAL_LIST_EMPTY_TYPED(/datum/antagonist/storyteller, storytellers)

/datum/antagonist/storyteller
	id = MODE_STORYTELLER
	landmark_id = "Storyteller"
	role_text = "Storyteller"
	role_text_plural = "Storytellers"
	welcome_text = "You are a Storyteller. Live out your GM fantasy."
	faction = "Storyteller"

	bantype = "storyteller"

	mob_path = /mob/abstract/observer
	id_type = null
	valid_species = list()

/datum/antagonist/actor/New()
	..(1)
	commandos = src

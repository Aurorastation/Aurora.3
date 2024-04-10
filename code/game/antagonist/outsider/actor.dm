GLOBAL_EMPTY_TYPED(/datum/antagonist/actor, actors)

/datum/antagonist/actor
	id = MODE_ACTOR
	landmark_id = "Actor"
	role_text = "Actor"
	role_text_plural = "Actors"
	welcome_text = "You are an actor in a Mission. Roleplay your heart out."
	faction = "actor"

	bantype = "actor"

/datum/antagonist/actor/New()
	..(1)
	commandos = src

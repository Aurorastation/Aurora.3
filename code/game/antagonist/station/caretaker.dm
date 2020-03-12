/datum/antagonist/caretaker
	id = MODE_CARETAKER
	role_text = "Caretaker"
	role_text_plural = "Caretakers"
	bantype = "caretaker"
	feedback_tag = "caretkr_objective"
	antag_indicator = "caretkr"
	welcome_text = "You are a Caretaker! You received a great gift; An egg! Your job is to take care of the egg and whatever comes out of it!"
	flags = ANTAG_SUSPICIOUS | ANTAG_VOTABLE
	antaghud_indicator = "hudcaretaker"

	hard_cap = 2
	hard_cap_round = 4
	initial_spawn_req = 1
	initial_spawn_target = 1

	restricted_jobs = list("AI", "Cyborg")
	protected_jobs = list("Security Officer", "Security Cadet", "Warden", "Detective", "Forensic Technician", "Head of Personnel", "Chief Engineer", "Research Director", "Chief Medical Officer", "Captain", "Head of Security", "Internal Affairs Agent")
	required_age = 31

/datum/antagonist/caretaker/can_become_antag(var/datum/mind/player)
	if(!..())
		return FALSE
	return TRUE

/datum/antagonist/caretaker/equip(var/mob/living/carbon/human/player)
	if(!..())
		return FALSE

	player.put_in_hands(new /obj/item/caretaker_egg)
	return TRUE
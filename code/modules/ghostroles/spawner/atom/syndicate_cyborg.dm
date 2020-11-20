/datum/ghostspawner/syndiborg
	short_name = "syndiborg"
	name = "Syndicate Cyborg"
	desc = "Join in as a Syndicate Cyborg, assist your summoner in their goals, try and make the round fun for the people you're overequipped to deal with."
	tags = list("Antagonist")

	respawn_flag = MINISYNTH //Flag to check for when trying to spawn someone of that type (CREW, ANIMAL, MINISYNTH)
	jobban_job = "Cyborg"
	loc_type = GS_LOC_ATOM
	atom_add_message = "A syndicate cyborg has started its boot process!"

	spawn_mob = /mob/living/silicon/robot/syndicate

/datum/ghostspawner/combat_robot
	name = "Combat Robot"
	short_name = "combatrobot"
	desc = "Join in as a Combat Robot, assist your summoner in their goals, try and make the round fun for the people you're equipped to deal with."
	tags = list("Antagonist")

	respawn_flag = MINISYNTH // Flag to check for when trying to spawn someone of that type (CREW, ANIMAL, MINISYNTH).
	jobban_job = "Cyborg"
	loc_type = GS_LOC_ATOM
	atom_add_message = "A combat robot has started its boot process!"

	spawn_mob = /mob/living/silicon/robot/combat
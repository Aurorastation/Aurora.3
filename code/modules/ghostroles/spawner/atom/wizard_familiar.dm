/datum/ghostspawner/wizard_familiar
	short_name = "wizard_familiar"
	name = "Wizard Familiar"
	desc = "Be a Familiar, act cute, probably end up killing many people somehow."
	tags = list("Antagonist")

	antagonist = TRUE
	loc_type = GS_LOC_ATOM
	atom_add_message = "A wizard familiar has been summoned"

	spawn_mob = /mob/living/simple_animal

/datum/ghostspawner/wizard_familiar/post_spawn(mob/user)
	var/mob/living/simple_animal/A = user
	if(A.wizard_master)
		A.add_spell(new /spell/contract/return_master(A.wizard_master), "const_spell_ready")
		to_chat(src, "<B>You are [src], a familiar to [A.wizard_master]. He is your master and your friend. Aid him in his wizarding duties to the best of your ability.</B>")

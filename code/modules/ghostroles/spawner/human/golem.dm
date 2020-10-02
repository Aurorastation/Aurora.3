/datum/ghostspawner/human/golem
	short_name = "golem"
	name = "Bluespace Golem"
	desc = "Serve your Master."
	tags = list("Xenobiology")

	respawn_flag = ANIMAL
	loc_type = GS_LOC_ATOM

	spawn_mob = /mob/living/carbon/human/golem

//The proc to actually spawn in the user
/datum/ghostspawner/human/golem/spawn_mob(mob/user)
	if(!length(spawn_atoms))
		to_chat(user, SPAN_DANGER("There are no available golem runes to spawn at!"))
		return FALSE

	var/obj/effect/golemrune/rune = select_spawnatom()

	if(user && rune)
		return rune.spawn_golem(user)
	return FALSE

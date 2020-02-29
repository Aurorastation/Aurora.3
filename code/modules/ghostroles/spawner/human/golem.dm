/datum/ghostspawner/human/golem
	short_name = "golem"
	name = "Bluespace Golem"
	desc = "Serve your Master."
	tags = list("Xenobiology")

	respawn_flag = ANIMAL
	enabled = FALSE

	spawn_mob = /mob/living/carbon/human/golem

/datum/ghostspawner/human/golem/select_spawnpoint(var/use)
	return TRUE //We just fake it here, since the spawnpoint is selected if someone is spawned in.

//The proc to actually spawn in the user
/datum/ghostspawner/human/golem/spawn_mob(mob/user)
	var/obj/effect/golemrune/rune
	var/list/global_runes = list()

	for(var/obj/effect/golemrune/eligible_rune in golem_runes)
		global_runes += eligible_rune

	if(!length(global_runes))
		to_chat(user, span("danger", "There are no available golem runes to spawn at!"))
		return FALSE

	rune = pick(global_runes)

	if(user)
		return rune.spawn_golem(user)
	return FALSE
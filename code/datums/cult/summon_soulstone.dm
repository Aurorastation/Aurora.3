/datum/rune/summon_soulstone
	name = "soul stone creation rune"
	desc = "This rune is used to create a soul stone for our usage."

/datum/rune/summon_soulstone/do_rune_action(mob/living/user, atom/movable/A)
	user.say("N'ath reth sh'yro eth d'raggathnor!")
	new /obj/item/device/soulstone(get_turf(A))
	qdel(A)
	return TRUE
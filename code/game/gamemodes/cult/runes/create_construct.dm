/datum/rune/construct
	name = "construct rune"
	desc = "This rune is used to create a shell for one of our constructs. We must populate it with a soul in a soul shard, however."

/datum/rune/construct/do_rune_action(mob/living/user, atom/movable/A)
	user.say("N'ath reth! Sh'yro eth! D'raggathnor!")
	new /obj/structure/constructshell/cult(get_turf(A))
	qdel(A)

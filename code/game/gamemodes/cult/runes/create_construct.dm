/obj/effect/rune/create_construct
	can_talisman = TRUE

/obj/effect/rune/create_construct/do_rune_action(mob/living/user, obj/O = src)
	user.say("N[pick("'","`")]ath reth sh'yro eth d'raggathnor!")
	new /obj/structure/constructshell/cult(get_turf(O))
	qdel(O)
	return TRUE
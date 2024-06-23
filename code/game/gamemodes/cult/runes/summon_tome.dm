/datum/rune/summon_tome
	name = "tome summoning rune"
	desc = "This rune is used to summon a tome for our usage."

/datum/rune/summon_tome/do_rune_action(mob/living/user, atom/movable/A)
	user.say("N'ath reth sh'yro eth d'raggathnor!")
	user.visible_message(SPAN_WARNING("\The [A] disappears with a flash of red light, and in its place lies a book."), \
	SPAN_WARNING("You are blinded by the flash of red light! After you're able to see again, you see a book in place of \the [A]."), \
	SPAN_WARNING("You hear a pop and smell ozone."))
	new /obj/item/book/tome(get_turf(A))
	qdel(A)
	return TRUE

/obj/effect/rune/summon_tome/Initialize(mapload)
	. = ..(mapload, SScult.runes_by_name[/datum/rune/summon_tome::name])

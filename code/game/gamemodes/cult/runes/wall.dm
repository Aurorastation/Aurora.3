/obj/effect/rune/wall/do_rune_action(mob/living/user)
	user.say("Khari[pick("'","`")]d! Eske'te tannin!")
	src.density = !src.density
	user.take_organ_damage(2, 0)
	if(src.density)
		to_chat(user, span("cult", "Your blood flows into the rune, and you feel that the very space over the rune thickens."))
	else
		to_chat(user, span("cult", "Your blood flows into the rune, and you feel as the rune releases its grasp on space."))
	return
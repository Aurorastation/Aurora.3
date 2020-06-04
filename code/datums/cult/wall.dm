/datum/rune/wall
	name = "wall rune"
	desc = "This rune is used to create a wall that the unbelievers cannot go through."
	rune_flags = NO_TALISMAN

/datum/rune/wall/do_rune_action(mob/living/user, atom/movable/A)
	user.say("Khari'd! Eske'te tannin!")
	A.density = !A.density
	user.take_organ_damage(2, 0)
	if(A.density)
		to_chat(user, span("cult", "Your blood flows into the rune, and you feel that the very space over the rune thickens."))
		parent.filters = filter(type="blur", size = 5) 
	else
		to_chat(user, span("cult", "Your blood flows into the rune, and you feel as the rune releases its grasp on space."))
		parent.filters = filter(type="drop_shadow", x = 1, y = 1, size = 4, color = "#FF0000") 
	return
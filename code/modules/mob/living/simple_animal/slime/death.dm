/mob/living/simple_animal/slime/death(gibbed)

	if(stat == DEAD)
		return

	if(!gibbed && is_adult)
		var/mob/living/simple_animal/slime/S = make_new_slime()
		S.rabid = TRUE
		step_away(S, src)
		is_adult = FALSE
		maxHealth = initial(maxHealth)
		revive()
		if(!client)
			rabid = TRUE
		number = rand(1, 1000)
		update_name()
		return

	stop_consumption()
	. = ..(gibbed, "stops moving and partially dissolves...")

	update_icon()

	return
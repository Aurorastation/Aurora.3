/mob/living/carbon/slime/death(gibbed)
	if(stat == DEAD)
		return

	if(!gibbed && is_adult)
		var/new_slime_path = text2path("/mob/living/carbon/slime/[slime_color]")
		var/mob/living/carbon/slime/M = new new_slime_path(loc)
		M.rabid = TRUE
		M.friends = friends.Copy()
		step_away(M, src)
		is_adult = FALSE
		maxHealth = 150
		revive()
		if(!client)
			rabid = TRUE
		number = rand(1, 1000)
		name = "[slime_color] [is_adult ? "adult" : "baby"] slime ([number])"
		real_name = name
		return

	. = ..(gibbed, "seizes up and falls limp...")
	mood = null
	regenerate_icons()
	return
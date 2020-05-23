/spell/targeted/shapeshift/corrupt_form
	name = "Corrupt Form"
	desc = "This spell shapes the wizard into a terrible, terrible beast."
	feedback = "CF"
	normal_transformations = list(/mob/living/simple_animal/hostile/faithless/wizard)
	big_transformations = list(/mob/living/simple_animal/hostile/faithless/wizard)

	invocation = "mutters something dark and twisted as their form begins to twist..."
	invocation_type = SpI_EMOTE
	spell_flags = INCLUDEUSER
	range = -1
	duration = 300
	charge_max = 800
	cooldown_min = 400

	drop_items = 0
	share_damage = 0

	level_max = list(Sp_TOTAL = 3, Sp_SPEED = 2, Sp_POWER = 2)

	newVars = list("name" = "corrupted soul")

	hud_state = "wiz_corrupt"

/spell/targeted/shapeshift/corrupt_form/empower_spell()
	if(!..())
		return 0

	switch(spell_levels[Sp_POWER])
		if(1-2)
			duration += 100
			return "You will now stay corrupted for [duration/10] seconds."
		if(3)
			newVars = list("name" = "\proper corruption incarnate",
						"melee_damage_upper" = 45,
						"resistance" = 6,
						"health" = 650, //since it is foverer i guess it would be fine to turn them into some short of boss
						"maxHealth" = 650)
			duration = 0
			charge_max = 500
			return "You revel in the corruption. You can remain in this form for as long as you wish, and you are able to use it more often."
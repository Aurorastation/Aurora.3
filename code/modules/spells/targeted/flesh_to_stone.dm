/spell/targeted/flesh_to_stone
	name = "Flesh to Stone"
	desc = "This spell turns a single person into an inert statue for a long period of time."
	feedback = "FS"
	school = "transmutation"
	charge_max = 200
	spell_flags = NEEDSCLOTHES | SELECTABLE
	range = 5
	max_targets = 1
	invocation = "STAUN EI"
	invocation_type = SpI_SHOUT
	amt_stunned = 5
	cooldown_min = 100
	cast_sound = 'sound/magic/FleshToStone.ogg'

	hud_state = "wiz_statue"

/spell/targeted/flesh_to_stone/cast(var/list/targets, mob/user)
	..()
	for(var/mob/living/target in targets)
		new /obj/structure/closet/statue(target.loc, target)
		target.visible_message("<span class='danger'>[target] turns into a statue!</span>", "<span class='danger'>Your body turns into stone and you find yourself paralyzed!</span>")
	return
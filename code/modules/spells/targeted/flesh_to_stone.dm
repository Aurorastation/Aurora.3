/spell/targeted/flesh_to_stone
	name = "Flesh to Stone"
	desc = "This spell turns a single person into an inert statue for a long period of time."
	feedback = "FS"
	school = "transmutation"
	charge_max = 600
	spell_flags = NEEDSCLOTHES | SELECTABLE
	range = 3
	max_targets = 1
	invocation = "STAUN EI"
	invocation_type = SpI_SHOUT
	amt_stunned = 5
	cooldown_min = 200
	cast_sound = 'sound/magic/FleshToStone.ogg'

	hud_state = "wiz_statue"

/spell/targeted/flesh_to_stone/cast(var/list/targets, mob/user)
	..()
	for(var/mob/living/target in targets)
		var/obj/structure/closet/statue/statue = new(target.loc, target)
		target.visible_message("<span class='danger'>[target] turns into a statue!</span>")
		statue.appearance = target
		statue.color = list(
					    0.30, 0.3, 0.25,
					    0.30, 0.3, 0.25,
					    0.30, 0.3, 0.25
					)
		statue.name = "statue of [target.name]"
		statue.desc = "An incredibly lifelike stone carving."
	return
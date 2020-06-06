/spell/targeted/raise_dead
	name = "Raise Dead"
	desc = "This spell turns a body into a skeleton servant."
	feedback = "RD"
	school = "necromancy"
	charge_max = 1000
	spell_flags = NEEDSCLOTHES | SELECTABLE
	invocation = "RY'SY FROH YER G'RVE!"
	invocation_type = SpI_SHOUT
	range = 3
	max_targets = 1

	compatible_mobs = list(/mob/living/carbon/human)

	hud_state = "wiz_skeleton"

/spell/targeted/raise_dead/cast(list/targets, mob/user)
	..()

	for(var/mob/living/target in targets)
		if(target.stat != DEAD)
			to_chat(user, SPAN_WARNING("This spell can't affect the living."))
			return FALSE

		if(isundead(target))
			to_chat(user, SPAN_WARNING("This spell can't affect the undead."))
			return FALSE

		if(islesserform(target))
			to_chat(user, SPAN_WARNING("This spell can't affect this lesser creature."))
			return FALSE

		if(isipc(target))
			to_chat(user, SPAN_WARNING("This spell can't affect non-organics."))
			return FALSE

		var/mob/living/carbon/human/skeleton/F = new /mob/living/carbon/human/skeleton(get_turf(target))
		SSghostroles.add_spawn_atom("skeleton", F)
		var/area/A = get_area(F)
		if(A)
			say_dead_direct("A skeleton has been created in [A.name]! Spawn in as it by using the ghost spawner menu in the ghost tab.")
		target.visible_message("<span class='cult'>\The [target] explodes in a shower of gore, a skeleton emerges from the remains!</span>")
		target.gib()
		
		F.master = user
		F.faction = user.faction

		F.preEquipOutfit(/datum/outfit/admin/wizard/skeleton, FALSE)
		F.equipOutfit(/datum/outfit/admin/wizard/skeleton, FALSE)

		return TRUE
/mob/living/simple_animal/hostile/retaliate
	var/list/enemies = list()

/mob/living/simple_animal/hostile/retaliate/Destroy()
	enemies = null
	return ..()

/mob/living/simple_animal/hostile/retaliate/Found(var/atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(!L.stat)
			stance = HOSTILE_STANCE_ATTACK
			return L
		else
			enemies -= L

/mob/living/simple_animal/hostile/retaliate/ListTargets()
	if(!length(enemies))
		return list()
	var/list/see = ..()
	see &= enemies // Remove all entries that aren't in enemies
	return see

/mob/living/simple_animal/hostile/retaliate/handle_attack_by(mob/M)
	enemies |= M
	targets |= M

	for(var/mob/living/simple_animal/hostile/retaliate/H in view(world.view, get_turf(src)))
		if(H.faction == faction)
			H.enemies |= M
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

/mob/living/simple_animal/hostile/retaliate/proc/Retaliate(var/mob/M)
	enemies |= M
	targets |= M

	for(var/mob/living/simple_animal/hostile/retaliate/H in view(world.view, get_turf(src)))
		if(H.faction == faction)
			H.enemies |= M

/mob/living/simple_animal/hostile/retaliate/attack_hand(mob/living/carbon/human/M)
	. = ..()
	if(M.a_intent in list(I_DISARM, I_GRAB, I_HURT))
		Retaliate(M)

/mob/living/simple_animal/hostile/retaliate/attacked_with_item(obj/item/O, mob/user, var/proximity)
	. = ..()
	if(.)
		Retaliate(user)

/mob/living/simple_animal/hostile/retaliate/hitby(atom/movable/AM, speed)
	. = ..()
	if(ismob(AM.thrower))
		Retaliate(AM.thrower)

/mob/living/simple_animal/hostile/retaliate/bullet_act(obj/item/projectile/P, def_zone)
	. = ..()
	if(ismob(P.firer))
		Retaliate(P.firer)
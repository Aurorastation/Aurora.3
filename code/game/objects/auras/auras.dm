/*Auras are simple: They are simple overriders for attackbys, bullet_act, damage procs, etc. They also tick after their respective mob.
They should be used for undeterminate mob effects, like for instance a toggle-able forcefield, or indestructability as long as you don't move.
They should also be used for when you want to effect the ENTIRE mob, like having an armor buff or showering candy everytime you walk.
*/

/obj/aura
	var/mob/living/user

/obj/aura/Destroy()
	if(user)
		user.remove_aura(src)
	return ..()

/obj/aura/proc/added_to(var/mob/living/target)
	user = target
	user.add_aura(src)

/obj/aura/proc/removed()
	user = null

/obj/aura/proc/life_tick()
	return FALSE

/obj/aura/attackby(obj/item/I, mob/user)
	return FALSE

/obj/aura/bullet_act(obj/item/projectile/P, def_zone)
	return FALSE

/obj/aura/hitby(atom/movable/M, speed)
	return FALSE
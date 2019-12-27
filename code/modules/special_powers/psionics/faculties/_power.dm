/datum/special_power/psionic
	var/faculty          // Associated psi faculty.
	var/min_rank         // Minimum psi rank to use this power.
	var/use_grab         // This power has a variant invoked via grab.
	admin_log = TRUE // Whether or not using this power prints an admin attack log.
	use_sound = 'sound/effects/psi/power_used.ogg'

/datum/special_power/psionic/handle_post_power(var/mob/living/user, var/atom/target)
	if(cooldown)
		user.psi.set_cooldown(cooldown)
	if(admin_log && ismob(user) && ismob(target))
		admin_attack_log(user, target, "Used psipower ([name])", "Was subjected to a psipower ([name])", "used a psipower ([name]) on")
	if(use_sound)
		playsound(user.loc, use_sound, 75)
	
/datum/special_power/psionic/invoke(var/mob/living/user, var/atom/target)
	if(!user.psi)
		return FALSE

	if(faculty && min_rank)
		var/user_rank = user.psi.get_rank(faculty)
		if(user_rank < min_rank)
			return FALSE

	if(cost && !user.psi.spend_power(cost))
		return FALSE

	return TRUE
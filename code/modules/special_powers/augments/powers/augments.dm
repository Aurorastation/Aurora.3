/datum/special_power/augment
	var/obj/item/organ/internal/connected_organ

/datum/special_power/augment/handle_post_power(var/mob/living/carbon/human/user, var/atom/target)
	if(cooldown)
		user.augments.set_cooldown(cooldown)
	if(admin_log && ismob(user) && ismob(target))
		admin_attack_log(user, target, "Used psipower ([name])", "Was subject to an augment ([name])", "used an augment ([name]) on")
	if(use_sound)
		playsound(user.loc, use_sound, 75)

/datum/special_power/augment/invoke(var/mob/living/carbon/human/user, var/atom/target)
	if(!user.augments)
		return FALSE

	if(cost && !user.augments.spend_power(cost))
		return FALSE

	return TRUE
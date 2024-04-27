/mob/living/carbon/slime/proc/is_friend(var/mob/potential_friend)
	if(!friends[potential_friend]) // zero or null
		return FALSE
	return TRUE

/mob/living/carbon/slime/proc/increase_friendship(var/mob/friend)
	if(is_friend(friend))
		friends[friend] += 1
	else
		friends[friend] = 1

/mob/living/carbon/slime/proc/decrease_friendship(var/mob/friend)
	if(is_friend(friend))
		friends[friend] = max(0, friends[friend] - 1)

// this block handles becoming more friendly with the person that fed the slime
// LAssailant is a softref to the last person who grabbed a mob, thus, if you grab and pull a monkey
// before feeding them to the slime, they will become more friendly with you, even if you're out of sight. Bluespace!
/mob/living/carbon/slime/proc/check_friendship_increase()
	if(victim && !rabid && !attacked && victim.LAssailant && victim.LAssailant != victim)
		var/real_assailant = victim.LAssailant.resolve()
		if(real_assailant)
			increase_friendship(real_assailant)

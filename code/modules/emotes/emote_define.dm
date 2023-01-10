// Note about emote messages:
// - USER / TARGET will be replaced with the relevant name, in bold.
// - USER_THEM / TARGET_THEM / USER_THEIR / TARGET_THEIR will be replaced with a
//   gender-appropriate version of the same.
// - Impaired messages do not do any substitutions.

/singleton/emote

	var/key                            // Command to use emote ie. '*[key]'
	var/emote_message_1p               // First person message ('You do a flip!')
	var/emote_message_3p               // Third person message ('Urist McShitter does a flip!')
	var/emote_message_impaired         // Deaf/blind message ('You hear someone flipping out.', 'You see someone opening and closing their mouth')

	var/emote_message_1p_target        // 'You do a flip at Urist McTarget!'
	var/emote_message_3p_target        // 'Urist McShitter does a flip at Urist McTarget!'

	var/message_type = VISIBLE_MESSAGE // Audible/visual flag
	var/targetted_emote                // Whether or not this emote needs a target.
	var/check_restraints               // Can this emote be used while restrained?
	var/conscious = 1				   // Do we need to be awake to emote this?
	var/emote_range = 0                // If >0, restricts emote visibility to viewers within range.

/singleton/emote/proc/get_emote_message_1p(var/atom/user, var/atom/target, var/extra_params)
	if(target)
		return emote_message_1p_target
	return emote_message_1p

/singleton/emote/proc/get_emote_message_3p(var/atom/user, var/atom/target, var/extra_params)
	if(target)
		return emote_message_3p_target
	return emote_message_3p

/singleton/emote/proc/can_do_emote(var/mob/user)
	if(conscious && user.stat != CONSCIOUS)
		return FALSE
	return TRUE

/singleton/emote/proc/do_emote(var/atom/user, var/extra_params)
	if(ismob(user) && check_restraints)
		var/mob/M = user
		if(M.restrained())
			to_chat(user, "<span class='warning'>You are restrained and cannot do that.</span>")
			return

	var/atom/target
	if(can_target() && extra_params)
		extra_params = lowertext(extra_params)
		for(var/atom/thing in view(user))
			if(extra_params == lowertext(thing.name))
				target = thing
				break

	var/use_3p
	var/use_1p
	if(emote_message_1p)
		if(target && emote_message_1p_target)
			use_1p = get_emote_message_1p(user, target, extra_params)
			use_1p = replacetext(use_1p, "TARGET_THEM", target.get_pronoun("him"))
			use_1p = replacetext(use_1p, "TARGET_THEIR", target.get_pronoun("his"))
			use_1p = replacetext(use_1p, "TARGET_SELF", target.get_pronoun("himself"))
			use_1p = replacetext(use_1p, "TARGET", "<b>\the [target]</b>")
		else
			use_1p = get_emote_message_1p(user, null, extra_params)
		use_1p = capitalize(use_1p)

	if(emote_message_3p)
		if(target && emote_message_3p_target)
			use_3p = get_emote_message_3p(user, target, extra_params)
			use_3p = replacetext(use_3p, "TARGET_THEM", target.get_pronoun("him"))
			use_3p = replacetext(use_3p, "TARGET_THEIR", target.get_pronoun("his"))
			use_3p = replacetext(use_3p, "TARGET_SELF", target.get_pronoun("himself"))
			use_3p = replacetext(use_3p, "TARGET", "<b>\the [target]</b>")
		else
			use_3p = get_emote_message_3p(user, null, extra_params)
		use_3p = replacetext(use_3p, "USER_THEM", user.get_pronoun("him"))
		use_3p = replacetext(use_3p, "USER_THEIR", user.get_pronoun("his"))
		use_3p = replacetext(use_3p, "USER_SELF", user.get_pronoun("himself"))
		use_3p = replacetext(use_3p, "USER", "<b>\the [user]</b>")
		use_3p = capitalize(use_3p)

	var/use_range = emote_range
	if (!use_range)
		use_range = world.view

	if(!target_check(user, target))
		return

	if(ismob(user))
		var/mob/M = user
		var/check_ghost_hearing = M.client ? GHOSTS_ALL_HEAR : ONLY_GHOSTS_IN_VIEW
		if(message_type == AUDIBLE_MESSAGE)
			M.audible_message(message = use_3p, self_message = use_1p, deaf_message = emote_message_impaired, hearing_distance = use_range, ghost_hearing = check_ghost_hearing)
		else
			M.visible_message(message = use_3p, self_message = use_1p, blind_message = emote_message_impaired, range = use_range, show_observers = FALSE)

	do_extra(user, target)

/singleton/emote/proc/do_extra(var/atom/user, var/atom/target)
	return

/singleton/emote/proc/check_user(var/atom/user)
	return TRUE

/singleton/emote/proc/target_check(var/atom/user, var/atom/target)
	return TRUE

/singleton/emote/proc/can_target()
	return (emote_message_1p_target || emote_message_3p_target)

/singleton/emote/dd_SortValue()
	return key

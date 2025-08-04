ABSTRACT_TYPE(/singleton/overhead_emote)
	var/icon = 'icons/mob/overhead_emote.dmi'
	var/icon_state = "abstract"

	var/emote_description = "abstract"
	var/emote_sound

/singleton/overhead_emote/proc/get_image(var/mob/target)
	var/image/image = image(icon, icon_state)
	image.pixel_y = 18 + target.get_floating_chat_y_offset()
	image.pixel_x = target.get_floating_chat_x_offset()
	return image

/singleton/overhead_emote/proc/start_emote(var/mob/parent, var/mob/victim)
	var/others_message
	if(victim)
		others_message = "<b>[parent]</b> lifts their hand to [emote_description] [victim]!"
	else
		others_message = "<b>[parent]</b> lifts their hand for a [emote_description]!"

	var/self_message
	if(victim)
		self_message = SPAN_NOTICE("You lift your hand to [emote_description] [victim]!")
	else
		self_message = SPAN_NOTICE("You lift your hand for a [emote_description]!")

	parent.visible_message(others_message, self_message)

/singleton/overhead_emote/proc/reciprocate_emote(var/mob/reciprocator, var/mob/original, var/reciprocating_emote_path)
	var/datum/component/overhead_emote/original_emote_component = original.GetComponent(/datum/component/overhead_emote)
	var/singleton/overhead_emote/original_emote = original_emote_component.emote_type

	if(original_emote.type != reciprocating_emote_path)
		fail_emote(reciprocator, original, original_emote_component, original_emote, reciprocating_emote_path)
		return

	var/others_message = "<b>[reciprocator]</b> lifts their to meet [original]'s, delivering a stunning [emote_description]!"
	var/self_message = SPAN_NOTICE("You lift your hand to meet [original]'s, delivering a stunning [emote_description]!")
	reciprocator.visible_message(others_message, self_message)

	INVOKE_ASYNC(reciprocator, TYPE_PROC_REF(/atom/movable, do_attack_animation), original, FIST_ATTACK_ANIMATION)
	INVOKE_ASYNC(original, TYPE_PROC_REF(/atom/movable, do_attack_animation), reciprocator, FIST_ATTACK_ANIMATION)

	if(emote_sound)
		playsound(reciprocator.loc, emote_sound, 30, 1)

	original_emote_component.remove_from_mob()

/singleton/overhead_emote/proc/fail_emote(var/mob/reciprocator, var/mob/original, var/datum/component/overhead_emote/original_emote_component, var/singleton/overhead_emote/original_emote, var/fail_emote_path)
	var/singleton/overhead_emote/fail_emote = GET_SINGLETON(fail_emote_path)

	var/others_message = "<b>[reciprocator]</b> lifts their to meet [original]'s, who was expecting a [original_emote.emote_description], but received a [fail_emote.emote_description] instead."
	var/self_message = SPAN_NOTICE("You lift your hand to meet [original]'s, who was expecting a [original_emote.emote_description], but received a [fail_emote.emote_description] instead.")
	reciprocator.visible_message(others_message, self_message)

	INVOKE_ASYNC(reciprocator, TYPE_PROC_REF(/atom/movable, do_attack_animation), original, FIST_ATTACK_ANIMATION)
	INVOKE_ASYNC(original, TYPE_PROC_REF(/atom/movable, do_attack_animation), reciprocator, FIST_ATTACK_ANIMATION)

	playsound(reciprocator.loc, /singleton/sound_category/punchmiss_sound, 30, 1)

	original_emote_component.remove_from_mob()


/singleton/overhead_emote/highfive
	icon_state = "emote_highfive"
	emote_description = "high-five"
	emote_sound = 'sound/effects/snap.ogg'

/singleton/overhead_emote/fistbump
	icon_state = "emote_fistbump"
	emote_description = "fist-bump"
	emote_sound = 'sound/weapons/Genhit.ogg'

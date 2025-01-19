/singleton/emote/audible/synth
	key = "beep"
	emote_message_3p = "USER beeps."
	emote_sound = 'sound/machines/twobeep.ogg'
	conscious = 0

/singleton/emote/audible/synth/check_user(var/mob/living/user)
	if(istype(user) && user.isSynthetic())
		return ..()
	return FALSE

/singleton/emote/audible/synth/ping
	key = "ping"
	emote_message_3p = "USER pings."
	emote_sound = 'sound/machines/ping.ogg'

/singleton/emote/audible/synth/buzz
	key = "buzz"
	emote_message_3p = "USER buzzes."
	emote_sound = 'sound/machines/buzz-sigh.ogg'

/singleton/emote/audible/synth/confirm
	key = "confirm"
	emote_message_3p = "USER emits an affirmative blip."
	emote_sound = 'sound/machines/synth_yes.ogg'

/singleton/emote/audible/synth/deny
	key = "deny"
	emote_message_3p = "USER emits a negative blip."
	emote_sound = 'sound/machines/synth_no.ogg'

/singleton/emote/audible/synth/alarm
	key = "alarm"
	emote_message_3p = "USER sounds an alarm!"
	emote_sound = 'sound/machines/warning-buzzer.ogg'

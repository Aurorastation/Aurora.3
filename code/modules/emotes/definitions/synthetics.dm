/decl/emote/audible/synth
	key = "beep"
	emote_message_3p = "USER beeps."
	emote_sound = 'sound/machines/twobeep.ogg'

/decl/emote/audible/synth/check_user(var/mob/living/user)
	if(istype(user) && user.isSynthetic())
		return ..()
	return FALSE

/decl/emote/audible/synth/beep
	key = "beep2"
	emote_sound = 'sound/machines/synth_beeptwo.ogg'

/decl/emote/audible/synth/beep/alt
	key = "beep3"
	emote_sound = 'sound/machines/synth_beepthree.ogg'

/decl/emote/audible/synth/ping
	key = "ping"
	emote_message_3p = "USER pings."
	emote_sound = 'sound/machines/ping.ogg'

/decl/emote/audible/synth/ping/alt 
	key = "ping2"
	emote_sound = 'sound/machines/synth_pingtwo.ogg'

/decl/emote/audible/synth/buzz
	key = "buzz"
	emote_message_3p = "USER buzzes."
	emote_sound = 'sound/machines/buzz-sigh.ogg'

/decl/emote/audible/synth/buzz/long
	key = "longbuzz"
	emote_sound = 'sound/machines/synth_longbuzz.ogg'

/decl/emote/audible/synth/confirm
	key = "confirm"
	emote_message_3p = "USER emits an affirmative blip."
	emote_sound = 'sound/machines/synth_yes.ogg'

/decl/emote/audible/synth/deny
	key = "deny"
	emote_message_3p = "USER emits a negative blip."
	emote_sound = 'sound/machines/synth_no.ogg'

/decl/emote/audible/synth/mad
	key = "mad"
	emote_message_3p = "USER emits a harsh buzz."
	emote_sound = 'sound/machines/synth_mad.ogg'

/decl/emote/audible/synth/alert
	key = "alert"
	emote_message_3p = "USER emits a shrill beep."
	emote_sound = 'sound/machines/synth_alert.ogg'

/decl/emote/audible/synth/whirr
	key = "whirr"
	emote_message_3p = "USER whirrs."
	emote_sound = 'sound/machines/synth_whirr.ogg'

/decl/emote/audible/synth/chime
	key = "chime"
	emote_message_3p = "USER chimes."
	emote_sound = 'sound/machines/synth_chime.ogg'

/decl/emote/audible/synth/joy
	key = "joy"
	emote_message_3p = "USER emits a cheerful tune."
	emote_sound = 'sound/machines/synth_joy.ogg'

/decl/emote/audible/synth/buffer
	key = "buffer"
	emote_message_3p = "USER emits several periodic beeps."
	emote_sound = 'sound/machines/synth_process.ogg'

/decl/emote/audible/synth/buffer/alt
	key = "buffer2"
	emote_sound = 'sound/machines/synth_processtwo.ogg'

/decl/emote/audible/synth/greet
	key = "greet"
	emote_message_3p = "USER emits a pleasant chime."
	emote_sound = 'sound/machines/synth_greet.ogg'
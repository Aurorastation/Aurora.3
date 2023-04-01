/singleton/emote/teshari

/singleton/emote/teshari/vomit
	key = "vomit"

/singleton/emote/teshari/vomit/check_user(var/mob/living/carbon/teshari/user)
	return (istype(user) && user.check_has_mouth() && !user.isSynthetic())

/singleton/emote/teshari/vomit/do_emote(var/mob/living/carbon/teshari/user)
	user.vomit(deliberate = TRUE)

/singleton/emote/teshari/deathgasp
	key = "deathgasp"
	emote_message_3p = "USER falls limp and stops moving..." //Fallback. Will be replaced with below proc but emotes won't show without a value in this variable

/singleton/emote/teshari/deathgasp/get_emote_message_3p(var/mob/living/carbon/teshari/user)
	return "USER [user.species.death_message]"

/singleton/emote/teshari/swish
	key = "swish"

/singleton/emote/teshari/swish/do_emote(var/mob/living/carbon/teshari/user)
	user.animate_tail_once()

/singleton/emote/teshari/wag
	key = "wag"

/singleton/emote/teshari/wag/do_emote(var/mob/living/carbon/teshari/user)
	user.animate_tail_start()

/singleton/emote/teshari/sway
	key = "sway"

/singleton/emote/teshari/sway/do_emote(var/mob/living/carbon/teshari/user)
	user.animate_tail_start()

/singleton/emote/teshari/qwag
	key = "qwag"

/singleton/emote/teshari/qwag/do_emote(var/mob/living/carbon/teshari/user)
	user.animate_tail_fast()

/singleton/emote/teshari/fastsway
	key = "fastsway"

/singleton/emote/teshari/fastsway/do_emote(var/mob/living/carbon/teshari/user)
	user.animate_tail_fast()

/singleton/emote/teshari/swag
	key = "swag"

/singleton/emote/teshari/swag/do_emote(var/mob/living/carbon/teshari/user)
	user.animate_tail_stop()

/singleton/emote/teshari/stopsway
	key = "stopsway"

/singleton/emote/teshari/stopsway/do_emote(var/mob/living/carbon/teshari/user)
	user.animate_tail_stop()

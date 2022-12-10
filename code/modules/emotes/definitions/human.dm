/decl/emote/human

/decl/emote/human/vomit
	key = "vomit"

/decl/emote/human/vomit/check_user(var/mob/living/carbon/human/user)
	return (istype(user) && user.check_has_mouth() && !user.isSynthetic())

/decl/emote/human/vomit/do_emote(var/mob/living/carbon/human/user)
	user.vomit(deliberate = TRUE)

/decl/emote/human/deathgasp
	key = "deathgasp"
	emote_message_3p = "USER falls limp and stops moving..." //Fallback. Will be replaced with below proc but emotes won't show without a value in this variable

/decl/emote/human/deathgasp/get_emote_message_3p(var/mob/living/carbon/human/user)
	return "USER [user.species.death_message]"

/decl/emote/human/swish
	key = "swish"

/decl/emote/human/swish/do_emote(var/mob/living/carbon/human/user)
	user.animate_tail_once()

/decl/emote/human/wag
	key = "wag"

/decl/emote/human/wag/do_emote(var/mob/living/carbon/human/user)
	user.animate_tail_start()

/decl/emote/human/sway
	key = "sway"

/decl/emote/human/sway/do_emote(var/mob/living/carbon/human/user)
	user.animate_tail_start()

/decl/emote/human/qwag
	key = "qwag"

/decl/emote/human/qwag/do_emote(var/mob/living/carbon/human/user)
	user.animate_tail_fast()

/decl/emote/human/fastsway
	key = "fastsway"

/decl/emote/human/fastsway/do_emote(var/mob/living/carbon/human/user)
	user.animate_tail_fast()

/decl/emote/human/swag
	key = "swag"

/decl/emote/human/swag/do_emote(var/mob/living/carbon/human/user)
	user.animate_tail_stop()

/decl/emote/human/stopsway
	key = "stopsway"

/decl/emote/human/stopsway/do_emote(var/mob/living/carbon/human/user)
	user.animate_tail_stop()

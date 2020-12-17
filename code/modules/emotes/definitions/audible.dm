/decl/emote/audible
	key = "burp"
	emote_message_3p = "USER burps."
	message_type = AUDIBLE_MESSAGE
	var/emote_sound

/decl/emote/audible/do_extra(var/atom/user)
	var/sound_to_play
	if(emote_sound)
		if(islist(emote_sound))
			sound_to_play = pick(emote_sound)
		else
			sound_to_play = emote_sound
		playsound(user.loc, sound_to_play, 50, 0, vary = FALSE)

/decl/emote/audible/deathgasp_alien
	key = "deathgasp"
	emote_message_3p = "USER lets out a waning guttural screech, green blood bubbling from its maw."

/decl/emote/audible/whimper
	key ="whimper"
	emote_message_3p = "USER whimpers."

/decl/emote/audible/gasp
	key ="gasp"
	emote_message_3p = "USER gasps."
	conscious = 0

/decl/emote/audible/scretch
	key ="scretch"
	emote_message_3p = "USER scretches."

/decl/emote/audible/choke
	key ="choke"
	emote_message_3p = "USER chokes!"
	conscious = 0

/decl/emote/audible/gnarl
	key ="gnarl"
	emote_message_3p = "USER gnarls and shows its teeth.."

/decl/emote/audible/chirp
	key ="chirp"
	emote_message_3p = "USER chirps!"
	emote_sound = 'sound/misc/nymphchirp.ogg'

/decl/emote/audible/multichirp
	key ="mchirp"
	emote_message_3p = "USER chirps a chorus of notes!"
	emote_sound = 'sound/misc/multichirp.ogg'

/decl/emote/audible/paincreak
	key ="pcreak"
	emote_message_3p = "USER creaks in pain!"

/decl/emote/audible/painrustle
	key ="prustle"
	emote_message_3p = "USER rustles in agony!"

/decl/emote/audible/nymphsqueal
	key ="psqueal"
	emote_message_3p = "USER's nymphs squeal in pain!"

/decl/emote/audible/chitter
	key = "chitter"
	emote_message_3p = "USER chitters."
	emote_sound = list('sound/misc/zapsplat/chitter1.ogg', 'sound/misc/zapsplat/chitter2.ogg', 'sound/misc/zapsplat/chitter3.ogg')

/decl/emote/audible/shriek
	key = "shriek"
	emote_message_3p = "USER shrieks!"

/decl/emote/audible/screech
	key = "screech"
	emote_message_3p = "USER screeches!"

/decl/emote/audible/alarm
	key = "alarm"
	emote_message_1p = "You sound an alarm."
	emote_message_3p = "USER sounds an alarm."

/decl/emote/audible/alert
	key = "alert"
	emote_message_1p = "You let out a distressed noise."
	emote_message_3p = "USER lets out a distressed noise."

/decl/emote/audible/notice
	key = "notice"
	emote_message_1p = "You play a loud tone."
	emote_message_3p = "USER plays a loud tone."

/decl/emote/audible/whistle
	key = "whistle"
	emote_message_1p = "You whistle."
	emote_message_3p = "USER whistles."

/decl/emote/audible/boop
	key = "boop"
	emote_message_1p = "You boop."
	emote_message_3p = "USER boops."

/decl/emote/audible/sneeze
	key = "sneeze"
	emote_message_3p = "USER sneezes."

/decl/emote/audible/sniff
	key = "sniff"
	emote_message_3p = "USER sniffs."

/decl/emote/audible/snore
	key = "snore"
	emote_message_3p = "USER snores."
	conscious = 0

/decl/emote/audible/whimper
	key = "whimper"
	emote_message_3p = "USER whimpers."

/decl/emote/audible/yawn
	key = "yawn"
	emote_message_3p = "USER yawns."

/decl/emote/audible/clap
	key = "clap"
	emote_message_3p = "USER claps!"
	emote_sound = 'sound/effects/clap.ogg'

/decl/emote/audible/golfclap
	key = "golfclap"
	emote_message_3p = "USER claps, clearly unimpressed."
	emote_sound = 'sound/effects/golfclap.ogg'

/decl/emote/audible/chuckle
	key = "chuckle"
	emote_message_3p = "USER chuckles."

/decl/emote/audible/cough
	key = "cough"
	emote_message_3p = "USER coughs!"
	conscious = 0

/decl/emote/audible/cry
	key = "cry"
	emote_message_3p = "USER cries."

/decl/emote/audible/sigh
	key = "sigh"
	emote_message_3p = "USER sighs."

/decl/emote/audible/laugh
	key = "laugh"
	emote_message_3p_target = "USER laughs at TARGET."
	emote_message_3p = "USER laughs."

/decl/emote/audible/mumble
	key = "mumble"
	emote_message_3p = "USER mumbles!"

/decl/emote/audible/grumble
	key = "grumble"
	emote_message_3p = "USER grumbles!"

/decl/emote/audible/groan
	key = "groan"
	emote_message_3p = "USER groans!"
	conscious = 0

/decl/emote/audible/moan
	key = "moan"
	emote_message_3p = "USER moans!"
	conscious = 0

/decl/emote/audible/giggle
	key = "giggle"
	emote_message_3p = "USER giggles."

/decl/emote/audible/scream
	key = "scream"
	emote_message_3p = "USER screams!"

/decl/emote/audible/scream/can_do_emote(var/mob/living/user)
	. = ..()
	if(. && ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!H.can_feel_pain())
			return FALSE

/decl/emote/audible/grunt
	key = "grunt"
	emote_message_3p = "USER grunts."

/decl/emote/audible/slap
	key = "slap"
	emote_message_1p_target = "<span class='warning'>You slap TARGET across the face!</span>"
	emote_message_1p = "You slap yourself across the face!"
	emote_message_3p_target = "<span class='warning'>USER slaps TARGET across the face!</span>"
	emote_message_3p = "USER slaps USER_SELF across the face!"
	emote_sound = 'sound/effects/snap.ogg'

/decl/emote/audible/slap/target_check(var/atom/user, var/atom/target)
	if(!ismob(target))
		return FALSE
	if(!target.Adjacent(user))
		return FALSE
	return TRUE

/decl/emote/audible/snap
	key = "snap"
	emote_message_3p = "USER snaps USER_THEIR fingers."
	emote_sound = 'sound/effects/fingersnap.ogg'

/decl/emote/audible/roar
	key = "roar"
	emote_message_3p = "USER roars!"

/decl/emote/audible/bellow
	key = "bellow"
	emote_message_3p = "USER bellows!"

/decl/emote/audible/howl
	key = "howl"
	emote_message_3p = "USER howls!"

/decl/emote/audible/wheeze
	key = "wheeze"
	emote_message_3p = "USER wheezes."

/decl/emote/audible/hiss
	key = "hiss"
	emote_message_3p_target = "USER hisses softly at TARGET."
	emote_message_3p = "USER hisses softly."

/decl/emote/audible/hiss/long
	key = "hiss2"
	emote_sound = 'sound/voice/LizardHiss.ogg'

/decl/emote/audible/hiss/short
	key = "hiss3"
	emote_sound = 'sound/voice/LizardHissShort.ogg'

/decl/emote/audible/lizard_bellow
	key = "bellow"
	emote_message_3p_target = "USER bellows deeply at TARGET!"
	emote_message_3p = "USER bellows!"
	emote_sound = 'sound/voice/LizardBellow.ogg'

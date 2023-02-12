/singleton/emote/audible
	key = "burp"
	emote_message_3p = "USER burps."
	message_type = AUDIBLE_MESSAGE
	var/emote_sound

/singleton/emote/audible/do_extra(var/atom/user)
	var/sound_to_play
	if(emote_sound)
		if(islist(emote_sound))
			sound_to_play = pick(emote_sound)
		else
			sound_to_play = emote_sound
		playsound(user.loc, sound_to_play, 50, 0, vary = FALSE)

/singleton/emote/audible/deathgasp_alien
	key = "deathgasp"
	emote_message_3p = "USER lets out a waning guttural screech, green blood bubbling from its maw."

/singleton/emote/audible/whimper
	key ="whimper"
	emote_message_3p = "USER whimpers."

/singleton/emote/audible/gasp
	key ="gasp"
	emote_message_3p = "USER gasps."
	conscious = 0

/singleton/emote/audible/scretch
	key ="scretch"
	emote_message_3p = "USER scretches."

/singleton/emote/audible/choke
	key ="choke"
	emote_message_3p = "USER chokes!"
	conscious = 0

/singleton/emote/audible/gnarl
	key ="gnarl"
	emote_message_3p = "USER gnarls and shows its teeth.."

/singleton/emote/audible/chirp
	key ="chirp"
	emote_message_3p = "USER chirps!"
	emote_sound = 'sound/misc/nymphchirp.ogg'

/singleton/emote/audible/multichirp
	key ="mchirp"
	emote_message_3p = "USER chirps a chorus of notes!"
	emote_sound = 'sound/misc/multichirp.ogg'

/singleton/emote/audible/paincreak
	key ="pcreak"
	emote_message_3p = "USER creaks in pain!"

/singleton/emote/audible/painrustle
	key ="prustle"
	emote_message_3p = "USER rustles in agony!"

/singleton/emote/audible/nymphsqueal
	key ="psqueal"
	emote_message_3p = "USER's nymphs squeal in pain!"

/singleton/emote/audible/chitter
	key = "chitter"
	emote_message_3p = "USER chitters."
	emote_sound = list('sound/voice/chitter1.ogg', 'sound/voice/chitter2.ogg', 'sound/voice/chitter3.ogg')

/singleton/emote/audible/click
	key = "click"
	emote_message_3p = "USER clicks USER_THEIR mandibles together."
	emote_sound = 'sound/voice/bugclick.ogg'

/singleton/emote/audible/clack
	key = "clack"
	emote_message_3p = "USER clacks USER_THEIR mandibles together."
	emote_sound = 'sound/voice/bugclack.ogg'
/singleton/emote/audible/shriek
	key = "shriek"
	emote_message_3p = "USER shrieks!"

/singleton/emote/audible/screech
	key = "screech"
	emote_message_3p = "USER screeches!"

/singleton/emote/audible/alarm
	key = "alarm"
	emote_message_1p = "You sound an alarm."
	emote_message_3p = "USER sounds an alarm."

/singleton/emote/audible/alert
	key = "alert"
	emote_message_1p = "You let out a distressed noise."
	emote_message_3p = "USER lets out a distressed noise."

/singleton/emote/audible/notice
	key = "notice"
	emote_message_1p = "You play a loud tone."
	emote_message_3p = "USER plays a loud tone."

/singleton/emote/audible/whistle
	key = "whistle"
	emote_message_1p = "You whistle."
	emote_message_3p = "USER whistles."

/singleton/emote/audible/boop
	key = "boop"
	emote_message_1p = "You boop."
	emote_message_3p = "USER boops."

/singleton/emote/audible/sneeze
	key = "sneeze"
	emote_message_3p = "USER sneezes."

/singleton/emote/audible/sniff
	key = "sniff"
	emote_message_3p = "USER sniffs."

/singleton/emote/audible/snore
	key = "snore"
	emote_message_3p = "USER snores."
	conscious = 0

/singleton/emote/audible/whimper
	key = "whimper"
	emote_message_3p = "USER whimpers."

/singleton/emote/audible/yawn
	key = "yawn"
	emote_message_3p = "USER yawns."

/singleton/emote/audible/clap
	key = "clap"
	emote_message_3p = "USER claps!"
	emote_sound = 'sound/effects/clap.ogg'

/singleton/emote/audible/golfclap
	key = "golfclap"
	emote_message_3p = "USER claps, clearly unimpressed."
	emote_sound = 'sound/effects/golfclap.ogg'

/singleton/emote/audible/chuckle
	key = "chuckle"
	emote_message_3p = "USER chuckles."

/singleton/emote/audible/cough
	key = "cough"
	emote_message_3p = "USER coughs!"
	conscious = 0

/singleton/emote/audible/cry
	key = "cry"
	emote_message_3p = "USER cries."

/singleton/emote/audible/sigh
	key = "sigh"
	emote_message_3p = "USER sighs."

/singleton/emote/audible/laugh
	key = "laugh"
	emote_message_3p_target = "USER laughs at TARGET."
	emote_message_3p = "USER laughs."

/singleton/emote/audible/mumble
	key = "mumble"
	emote_message_3p = "USER mumbles."

/singleton/emote/audible/grumble
	key = "grumble"
	emote_message_3p = "USER grumbles."

/singleton/emote/audible/groan
	key = "groan"
	emote_message_3p = "USER groans!"
	conscious = 0

/singleton/emote/audible/moan
	key = "moan"
	emote_message_3p = "USER moans!"
	conscious = 0

/singleton/emote/audible/giggle
	key = "giggle"
	emote_message_3p = "USER giggles."

/singleton/emote/audible/scream
	key = "scream"
	emote_message_3p = "USER screams!"

/singleton/emote/audible/scream/can_do_emote(var/mob/living/user)
	. = ..()
	if(. && ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!H.can_feel_pain())
			return FALSE

/singleton/emote/audible/grunt
	key = "grunt"
	emote_message_3p = "USER grunts."

/singleton/emote/audible/slap
	key = "slap"
	emote_message_1p_target = "<span class='warning'>You slap TARGET across the face!</span>"
	emote_message_1p = "You slap yourself across the face!"
	emote_message_3p_target = "<span class='warning'>USER slaps TARGET across the face!</span>"
	emote_message_3p = "USER slaps USER_SELF across the face!"
	emote_sound = 'sound/effects/snap.ogg'

/singleton/emote/audible/slap/target_check(var/atom/user, var/atom/target)
	if(!ismob(target))
		return FALSE
	if(!target.Adjacent(user))
		return FALSE
	return TRUE

/singleton/emote/audible/snap
	key = "snap"
	emote_message_3p = "USER snaps USER_THEIR fingers."
	emote_sound = 'sound/effects/fingersnap.ogg'

/singleton/emote/audible/roar
	key = "roar"
	emote_message_3p = "USER roars!"

/singleton/emote/audible/bellow
	key = "bellow"
	emote_message_3p = "USER bellows!"

/singleton/emote/audible/howl
	key = "howl"
	emote_message_3p = "USER howls!"

/singleton/emote/audible/wheeze
	key = "wheeze"
	emote_message_3p = "USER wheezes."

/singleton/emote/audible/hiss
	key = "hiss"
	emote_message_3p_target = "USER hisses softly at TARGET."
	emote_message_3p = "USER hisses softly."

/singleton/emote/audible/growl
    key = "growl"
    emote_message_3p_target = "USER growls at TARGET."
    emote_message_3p = "USER growls."
    emote_sound = 'sound/voice/Lizardgrowl.ogg'

/singleton/emote/audible/hiss/long
    key = "hiss2"
    emote_message_3p_target = "USER hisses loudly at TARGET!"
    emote_message_3p = "USER hisses loudly!"
    emote_sound = 'sound/voice/lizardhiss2.ogg'

/singleton/emote/audible/lizard_bellow
	key = "bellow"
	emote_message_3p_target = "USER bellows deeply at TARGET!"
	emote_message_3p = "USER bellows!"
	emote_sound = 'sound/voice/LizardBellow.ogg'

/singleton/emote/audible/warble
	key = "warble"
	emote_message_3p = "USER warbles!"
	emote_sound = 'sound/voice/warble.ogg'

/singleton/emote/audible/croon
	key = "croon"
	emote_message_3p = "USER croons..."
	emote_sound = list('sound/voice/croon1.ogg', 'sound/voice/croon2.ogg')

/singleton/emote/audible/lowarble
	key = "lwarble"
	emote_message_3p = "USER lets out a low, throaty warble!"
	emote_sound = 'sound/voice/low warble.ogg'

/singleton/emote/audible/croak
	key = "croak"
	emote_message_3p = "USER croaks!"
	emote_sound = 'sound/voice/croak.ogg'

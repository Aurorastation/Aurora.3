/datum/emote
	var/id = "none"
	var/message_targeted
	var/message_untargeted
	var/display_flags

/datum/emote/proc/translate_emote(var/emote_string)

/datum/emote/proc/can_emote(var/atom/source)
	var/mob/living/carbon/human/source_human = source
	if(source_human)
		if(display_flags & EMOTE_DISALLOW_VOICELESS)
			if(istype(source_human.wear_mask, /obj/item/clothing/mask/muzzle))
				return 0
			if(source_human.sdisabilities & MUTE)
				return 0
		if(display_flags & EMOTE_DISALLOW_MACHINE && source_human.isSynthetic())
			return 0
		if(display_flags & EMOTE_DISALLOW_ORGANIC && !source_human.isSynthetic())
			return 0
		if(display_flags & EMOTE_DISALLOW_HANDLESS)
			var/obj/item/organ/external/LH = source_human.organs_by_name["l_hand"]
			var/obj/item/organ/external/RH = source_human.organs_by_name["r_hand"]
			if( (!LH || LH.is_stump()) && (!RH || RH.is_stump()) )
				return 0
		if(display_flags & EMOTE_DISALLOW_LEGLESS)
			var/obj/item/organ/external/LL = source_human.organs_by_name["l_leg"]
			var/obj/item/organ/external/RL = source_human.organs_by_name["r_leg"]
			if( (!LL || LL.is_stump()) && (!RL || RL.is_stump()) )
				return 0
		if(display_flags & EMOTE_DISALLOW_TAILLESS)
			if(!source_human.species.tail)
				return 0
	else if(display_flags & EMOTE_DISALLOW_MACHINE)
		return 0

	return 1

/datum/emote/proc/do_emote(var/atom/source, var/atom/target, var/untargeted = message_untargeted, var/targeted = message_targeted)

	var/final_message = untargeted
	if(target && istype(target))
		final_message = targeted
		final_message = replacetext(final_message,"#TARGET","<b>[target]</b>")
	final_message = "<span>[replacetext(final_message,"#SOURCE","<b>[source]</b>")]</span>"

	if(display_flags & EMOTE_AUDIBLE && display_flags & EMOTE_VISIBLE)
		source.visible_message(final_message,final_message)
	else if(display_flags & EMOTE_AUDIBLE)
		source.visible_message("",final_message)
	else if(display_flags & EMOTE_VISIBLE)
		source.visible_message(final_message,"")

/datum/emote/custom
	id = "custom"
	display_flags = EMOTE_AUDIBLE | EMOTE_VISIBLE
	//Just like it is currently, players get a lot of freedom.
	//Don't you fucking exploit this, players.

/datum/emote/custom_visible
	id = "custom_visible"
	display_flags = EMOTE_VISIBLE

/datum/emote/custom_audible
	id = "custom_audible"
	display_flags = EMOTE_VISIBLE

/datum/emote/laugh
	id = "laugh"
	message_targeted = "#SOURCE laughs at #TARGET."
	message_untargeted = "#SOURCE laughs."
	display_flags = EMOTE_AUDIBLE | EMOTE_VISIBLE | EMOTE_DISALLOW_VOICELESS

/datum/emote/giggle
	id = "giggle"
	message_targeted = "#SOURCE giggles at #TARGET."
	message_untargeted = "#SOURCE giggles."
	display_flags = EMOTE_AUDIBLE | EMOTE_VISIBLE | EMOTE_DISALLOW_VOICELESS

/datum/emote/point
	id = "point"
	message_targeted = "#SOURCE points at #TARGET."
	message_untargeted = "#SOURCE points in front of them."
	display_flags = EMOTE_VISIBLE | EMOTE_DISALLOW_HANDLESS

/datum/emote/beep
	id = "beep"
	message_targeted = "#SOURCE beeps at #TARGET."
	message_untargeted = "#SOURCE beeps."
	display_flags = EMOTE_AUDIBLE | EMOTE_DISALLOW_ORGANIC

/datum/emote/scream
	id = "scream"
	message_targeted = "#SOURCE screams at #TARGET."
	message_untargeted = "#SOURCE screams!"
	display_flags = EMOTE_AUDIBLE | EMOTE_VISIBLE | EMOTE_DISALLOW_VOICELESS

/datum/emote/collapse
	id = "collapse"
	message_targeted = "#SOURCE collapses at the sight of #TARGET!"
	message_untargeted = "#SOURCE collapses!"
	display_flags = EMOTE_AUDIBLE | EMOTE_VISIBLE | EMOTE_DISALLOW_VOICELESS

/datum/emote/collapse/do_emote(var/atom/source, var/atom/target, var/untargeted = message_untargeted, var/targeted = message_targeted)
	//. = ..()
	//var/mob/M = source
	//M.Weaken(5)

/datum/emote/whisper
	id = "whisper"
	message_targeted = "#SOURCE whispers towards #TARGET."
	message_untargeted = "#SOURCE whispers."
	display_flags = EMOTE_AUDIBLE | EMOTE_VISIBLE | EMOTE_DISALLOW_VOICELESS

/datum/emote/twitch
	id = "twitch"
	message_targeted = "#SOURCE flinches."
	message_untargeted = "#SOURCE twitches."
	display_flags = EMOTE_AUDIBLE | EMOTE_VISIBLE

/datum/emote/gasp
	id = "gasp"
	message_targeted = "#SOURCE gasps at #TARGET."
	message_untargeted = "#SOURCE gasps."
	display_flags = EMOTE_AUDIBLE | EMOTE_VISIBLE

/datum/emote/gasp_heavy
	id = "gasp_heavy"
	message_targeted = "#SOURCE gasps for air!"
	message_untargeted = "#SOURCE gasps for air!"
	display_flags = EMOTE_AUDIBLE | EMOTE_VISIBLE

/datum/emote/yawn
	id = "yawn"
	message_targeted = "#SOURCE yawns at #TARGET."
	message_untargeted = "#SOURCE yawns."
	display_flags = EMOTE_AUDIBLE | EMOTE_VISIBLE

/datum/emote/snore
	id = "snore"
	message_targeted = "#SOURCE sarcasticly snores at #TARGET."
	message_untargeted = "#SOURCE snores."
	display_flags = EMOTE_AUDIBLE | EMOTE_VISIBLE

/datum/emote/doze
	id = "doze"
	message_targeted = "#SOURCE has trouble keeping their eyes open."
	message_untargeted = "#SOURCE has trouble keeping their eyes open."
	display_flags = EMOTE_VISIBLE | EMOTE_DISALLOW_MACHINE

/datum/emote/limp
	id = "limp"
	message_targeted = "#SOURCE's body becomes limp."
	message_untargeted = "#SOURCE's body becomes limp."
	display_flags = EMOTE_VISIBLE

/datum/emote/bounce
	id = "bounce"
	message_targeted = "#SOURCE bounces towards #TARGET."
	message_untargeted = "#SOURCE bounces in place."
	display_flags = EMOTE_VISIBLE

/datum/emote/sway
	id = "sway"
	message_targeted = "#SOURCE sways towards #TARGET."
	message_untargeted = "#SOURCE sways."
	display_flags = EMOTE_VISIBLE

/datum/emote/light
	id = "light"
	message_targeted = "#SOURCE lights up at the sight of #TARGET."
	message_untargeted = "#SOURCE lights up."
	display_flags = EMOTE_VISIBLE //"Lights up" is pretty ambiguous. Could mean literally or metaphorically.

/datum/emote/vibrate
	id = "vibrate"
	message_targeted = "#SOURCE vibrates towards #TARGET."
	message_untargeted = "#SOURCE vibrates."
	display_flags = EMOTE_VISIBLE | EMOTE_DISALLOW_ORGANIC

/datum/emote/jiggle
	id = "jiggle"
	message_targeted = "#SOURCE jiggles their breasts at #TARGET." //DO YOU THINK THEY'LL NOTICE?
	message_untargeted = "#SOURCE jiggles."
	display_flags = EMOTE_VISIBLE

/datum/emote/alarm
	id = "alarm"
	message_targeted = "#SOURCE hails #TARGET with an alarm!"
	message_untargeted = "#SOURCE sounds off an alarm!"
	display_flags = EMOTE_AUDIBLE | EMOTE_VISIBLE | EMOTE_DISALLOW_ORGANIC

/datum/emote/beepboop
	id = "beepboop"
	message_targeted = "#SOURCE akes an excited beeping booping sound at #TARGET!"
	message_untargeted = "#SOURCE akes an excited beeping booping sound!"
	display_flags = EMOTE_AUDIBLE | EMOTE_VISIBLE | EMOTE_DISALLOW_ORGANIC

/datum/emote/notice
	id = "notice"
	message_targeted = "#SOURCE emits a noticeable beep towards #TARGET."
	message_untargeted = "#SOURCE emits a noticeable beep."
	display_flags = EMOTE_AUDIBLE | EMOTE_DISALLOW_ORGANIC

/datum/emote/gnash
	id = "gnash"
	message_targeted = "#SOURCE gnashes their teeth at #TARGET!"
	message_untargeted = "#SOURCE gnashes their teeth!"
	display_flags = EMOTE_VISIBLE | EMOTE_DISALLOW_MACHINE | EMOTE_DISALLOW_VOICELESS

/datum/emote/flutter
	id = "flutter"
	message_targeted = "#SOURCE flutters towards #TARGET!"
	message_untargeted = "#SOURCE flutters."
	display_flags = EMOTE_VISIBLE

/datum/emote/growl
	id = "growl"
	message_targeted = "#SOURCE growls at #TARGET!"
	message_untargeted = "#SOURCE growls."
	display_flags = EMOTE_AUDIBLE | EMOTE_VISIBLE

/datum/emote/stare
	id = "stare"
	message_targeted = "#SOURCE stares at #TARGET."
	message_untargeted = "#SOURCE stares."
	display_flags = EMOTE_VISIBLE

/datum/emote/watch
	id = "watch"
	message_targeted = "#SOURCE watches #TARGET closely."
	message_untargeted = "#SOURCE watches."
	display_flags = EMOTE_VISIBLE

/datum/emote/examine
	id = "examine"
	message_targeted = "#SOURCE examines #TARGET."
	message_untargeted = "#SOURCE examines their surroundings."
	display_flags = EMOTE_VISIBLE

/datum/emote/wince
	id = "wince"
	message_targeted = "#SOURCE winces at #TARGET."
	message_untargeted = "#SOURCE winces."
	display_flags = EMOTE_AUDIBLE | EMOTE_VISIBLE

/datum/emote/wince_heavy
	id = "wince_heavy"
	message_targeted = "#SOURCE winces painfully at #TARGET!"
	message_untargeted = "#SOURCE winces painfully!"
	display_flags = EMOTE_AUDIBLE | EMOTE_VISIBLE

/datum/emote/blink
	id = "blink"
	message_targeted = "#SOURCE blinks at #TARGET."
	message_untargeted = "#SOURCE blinks."
	display_flags = EMOTE_VISIBLE

/datum/emote/blink_rapid
	id = "blink_rapid"
	message_targeted = "#SOURCE rapidly blinks at #TARGET."
	message_untargeted = "#SOURCE rapidly blinks."
	display_flags = EMOTE_VISIBLE

/datum/emote/cough
	id = "cough"
	message_targeted = "#SOURCE coughs on #TARGET."
	message_untargeted = "#SOURCE coughs."
	display_flags = EMOTE_AUDIBLE | EMOTE_VISIBLE | EMOTE_DISALLOW_DISTANCE

/datum/emote/sneeze
	id = "sneeze"
	message_targeted = "#SOURCE sneezes on #TARGET."
	message_untargeted = "#SOURCE sneezes."
	display_flags = EMOTE_AUDIBLE | EMOTE_VISIBLE | EMOTE_DISALLOW_DISTANCE

/datum/emote/sniff
	id = "sniff"
	message_targeted = "#SOURCE sniffs #TARGET."
	message_untargeted = "#SOURCE sniffs."
	display_flags = EMOTE_AUDIBLE | EMOTE_VISIBLE | EMOTE_DISALLOW_DISTANCE

/datum/emote/heave
	id = "heave"
	message_targeted = "#SOURCE dry heaves!"
	message_untargeted = "#SOURCE dry heaves!"
	display_flags = EMOTE_AUDIBLE | EMOTE_VISIBLE

/datum/emote/sputter
	id = "sputter"
	message_targeted = "#SOURCE sputters!"
	message_untargeted = "#SOURCE sputters!"
	display_flags = EMOTE_AUDIBLE | EMOTE_VISIBLE

/datum/emote/moan
	id = "moan"
	message_targeted = "#SOURCE moans."
	message_untargeted = "#SOURCE moans."
	display_flags = EMOTE_AUDIBLE | EMOTE_VISIBLE

/datum/emote/moan_heavy
	id = "moan_heavy"
	message_targeted = "#SOURCE moans in pain!"
	message_untargeted = "#SOURCE moans in pain!"
	display_flags = EMOTE_AUDIBLE | EMOTE_VISIBLE

/datum/emote/shiver
	id = "shiver"
	message_targeted = "#SOURCE shivers at #TARGET."
	message_untargeted = "#SOURCE shivers."
	display_flags = EMOTE_AUDIBLE | EMOTE_VISIBLE

/datum/emote/wail
	id = "wail"
	message_targeted = "#SOURCE wails at #TARGET!"
	message_untargeted = "#SOURCE wails!"
	display_flags = EMOTE_AUDIBLE | EMOTE_VISIBLE

/datum/emote/hiss
	id = "hiss"
	message_targeted = "#SOURCE hisses at #TARGET."
	message_untargeted = "#SOURCE hisses."
	display_flags = EMOTE_AUDIBLE | EMOTE_VISIBLE

/datum/emote/mrowl
	id = "mrowl"
	message_targeted = "#SOURCE mrowls at #TARGET."
	message_untargeted = "#SOURCE mrowls."
	display_flags = EMOTE_AUDIBLE | EMOTE_VISIBLE

/datum/emote/red
	id = "red"
	message_targeted = "#SOURCE goes red."
	message_untargeted = "#SOURCE goes red."
	display_flags = EMOTE_VISIBLE

/datum/emote/scratch
	id = "scratch"
	message_targeted = "#SOURCE scratches #TARGET.."
	message_untargeted = "#SOURCE scratches themself."
	display_flags = EMOTE_VISIBLE

/datum/emote/jump
	id = "jump"
	message_targeted = "#SOURCE jumps at #TARGET!"
	message_untargeted = "#SOURCE jumps!"
	display_flags = EMOTE_VISIBLE

/datum/emote/cough_blood
	id = "cough_blood"
	message_targeted = "#SOURCE coughs blood on #TARGET!"
	message_untargeted = "#SOURCE coughs up blood!"
	display_flags = EMOTE_VISIBLE
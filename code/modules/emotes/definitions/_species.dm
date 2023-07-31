/datum/species
	var/list/default_emotes = list()

/mob/living/carbon/update_emotes()
	. = ..(skip_sort=1)
	if(species)
		for(var/emote in species.default_emotes)
			var/singleton/emote/emote_datum = GET_SINGLETON(emote)
			if(emote_datum.check_user(src))
				usable_emotes[emote_datum.key] = emote_datum
	usable_emotes = sortAssoc(usable_emotes)

// Specific defines follow.
/datum/species/slime
	default_emotes = list(
		/singleton/emote/visible/bounce,
		/singleton/emote/visible/jiggle,
		/singleton/emote/visible/lightup,
		/singleton/emote/visible/vibrate
		)

/datum/species/unathi
	default_emotes = list(
		/singleton/emote/human/swish,
		/singleton/emote/human/wag,
		/singleton/emote/human/sway,
		/singleton/emote/human/qwag,
		/singleton/emote/human/fastsway,
		/singleton/emote/human/swag,
		/singleton/emote/human/stopsway,
		/singleton/emote/visible/tflick,
		/singleton/emote/audible/lizard_bellow,
		/singleton/emote/audible/hiss,
		/singleton/emote/audible/hiss/long,
		/singleton/emote/audible/growl
		)
	pain_emotes_with_pain_level = list(
		list(/singleton/emote/audible/roar, /singleton/emote/audible/whimper, /singleton/emote/audible/moan) = 70,
		list(/singleton/emote/audible/grunt, /singleton/emote/audible/groan, /singleton/emote/audible/moan) = 40,
		list(/singleton/emote/audible/grunt, /singleton/emote/audible/groan) = 10,
	)

/datum/species/diona
	default_emotes = list(
		/singleton/emote/audible/chirp,
		/singleton/emote/audible/multichirp,
		/singleton/emote/audible/nymphsqueal,
		/singleton/emote/audible/painrustle,
		/singleton/emote/audible/paincreak
	)
	pain_emotes_with_pain_level = list(
		list(/singleton/emote/audible/painrustle, /singleton/emote/audible/paincreak, /singleton/emote/audible/nymphsqueal) = 70,
		list(/singleton/emote/audible/painrustle, /singleton/emote/audible/nymphsqueal) = 40,
		list(/singleton/emote/audible/paincreak) = 10,
	)

/datum/species/bug
	default_emotes = list(
		/singleton/emote/audible/hiss,
		/singleton/emote/audible/chitter,
		/singleton/emote/audible/shriek,
		/singleton/emote/audible/screech,
		/singleton/emote/audible/click,
		/singleton/emote/audible/clack
	)
	pain_emotes_with_pain_level = list(
		list(/singleton/emote/audible/screech, /singleton/emote/audible/shriek) = 70,
		list(/singleton/emote/audible/shriek, /singleton/emote/audible/hiss) = 40,
		list(/singleton/emote/audible/hiss) = 10,
	)

/datum/species/tajaran
	default_emotes = list(
		/singleton/emote/audible/howl,
		/singleton/emote/audible/hiss,
		/singleton/emote/visible/flick,
		/singleton/emote/visible/tflick,
		/singleton/emote/human/swish,
		/singleton/emote/human/wag,
		/singleton/emote/human/sway,
		/singleton/emote/human/qwag,
		/singleton/emote/human/fastsway,
		/singleton/emote/human/swag,
		/singleton/emote/human/stopsway
	)
	pain_emotes_with_pain_level = list(
		list(/singleton/emote/audible/scream, /singleton/emote/audible/whimper, /singleton/emote/audible/moan, /singleton/emote/audible/cry, /singleton/emote/audible/howl) = 70,
		list(/singleton/emote/audible/grunt, /singleton/emote/audible/groan, /singleton/emote/audible/moan, /singleton/emote/audible/hiss) = 40,
		list(/singleton/emote/audible/grunt, /singleton/emote/audible/groan, /singleton/emote/audible/hiss) = 10,
	)

/datum/species/skrell
	default_emotes = list(
		/singleton/emote/audible/warble,
		/singleton/emote/audible/croon,
		/singleton/emote/audible/lowarble,
		/singleton/emote/audible/croak
	)
/mob/living/carbon/human/set_species(var/new_species, var/default_colour = 1)
	UNLINT(. = ..())
	update_emotes()

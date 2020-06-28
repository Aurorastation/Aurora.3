/datum/species
	var/list/default_emotes = list()

/mob/living/carbon/update_emotes()
	. = ..(skip_sort=1)
	if(species)
		for(var/emote in species.default_emotes)
			var/decl/emote/emote_datum = decls_repository.get_decl(emote)
			if(emote_datum.check_user(src))
				usable_emotes[emote_datum.key] = emote_datum
	usable_emotes = sortAssoc(usable_emotes)

// Specific defines follow.
/datum/species/slime
	default_emotes = list(
		/decl/emote/visible/bounce,
		/decl/emote/visible/jiggle,
		/decl/emote/visible/lightup,
		/decl/emote/visible/vibrate
		)

/datum/species/unathi
	default_emotes = list(
		/decl/emote/human/swish,
		/decl/emote/human/wag,
		/decl/emote/human/sway,
		/decl/emote/human/qwag,
		/decl/emote/human/fastsway,
		/decl/emote/human/swag,
		/decl/emote/human/stopsway,
		/decl/emote/audible/lizard_bellow
		)
	pain_emotes_with_pain_level = list(
		list(/decl/emote/audible/roar, /decl/emote/audible/whimper, /decl/emote/audible/moan) = 70,
		list(/decl/emote/audible/grunt, /decl/emote/audible/groan, /decl/emote/audible/moan) = 40,
		list(/decl/emote/audible/grunt, /decl/emote/audible/groan) = 10,
	)

/datum/species/diona
	default_emotes = list(
		/decl/emote/audible/chirp,
		/decl/emote/audible/multichirp,
		/decl/emote/audible/nymphsqueal,
		/decl/emote/audible/painrustle,
		/decl/emote/audible/paincreak
	)
	pain_emotes_with_pain_level = list(
		list(/decl/emote/audible/painrustle, /decl/emote/audible/paincreak, /decl/emote/audible/nymphsqueal) = 70,
		list(/decl/emote/audible/painrustle, /decl/emote/audible/nymphsqueal) = 40,
		list(/decl/emote/audible/paincreak) = 10,
	)

/datum/species/bug
	default_emotes = list(
		/decl/emote/audible/hiss,
		/decl/emote/audible/chitter,
		/decl/emote/audible/shriek,
		/decl/emote/audible/screech
	)
	pain_emotes_with_pain_level = list(
		list(/decl/emote/audible/screech, /decl/emote/audible/shriek) = 70,
		list(/decl/emote/audible/shriek, /decl/emote/audible/hiss) = 40,
		list(/decl/emote/audible/hiss) = 10,
	)

/datum/species/tajaran
	default_emotes = list(
		/decl/emote/audible/howl,
		/decl/emote/audible/hiss
	)
	pain_emotes_with_pain_level = list(
		list(/decl/emote/audible/scream, /decl/emote/audible/whimper, /decl/emote/audible/moan, /decl/emote/audible/cry, /decl/emote/audible/howl) = 70,
		list(/decl/emote/audible/grunt, /decl/emote/audible/groan, /decl/emote/audible/moan, /decl/emote/audible/hiss) = 40,
		list(/decl/emote/audible/grunt, /decl/emote/audible/groan, /decl/emote/audible/hiss) = 10,
	)

/mob/living/carbon/human/set_species(var/new_species, var/default_colour = 1)
	UNLINT(. = ..())
	update_emotes()

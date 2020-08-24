/datum/species/human
	name = SPECIES_HUMAN
	hide_name = TRUE
	short_name = "hum"
	name_plural = "Humans"
	bodytype = BODYTYPE_HUMAN
	age_max = 125
	economic_modifier = 12

	primitive_form = SPECIES_MONKEY
	unarmed_types = list(
		/datum/unarmed_attack/stomp,
		/datum/unarmed_attack/kick,
		/datum/unarmed_attack/punch,
		/datum/unarmed_attack/bite
	)
	blurb = "Humanity originated in the Sol system, and over the last four centuries has spread colonies across a wide swathe of space. \
	They hold a wide range of forms and creeds.<br><br>\
	The Sol Alliance is still massively influential, but independent human nations have managed to shake off its dominance and forge their \
	own path. Driven by an unending hunger for wealth, powerful corporate interests are bringing untold wealth to humanity. Unchecked \
	megacorporations have sparked secretive factions to fight their influence, while there is always the risk of someone digging too \
	deep into the secrets of the galaxy..."
	num_alternate_languages = 2
	secondary_langs = list(LANGUAGE_SOL_COMMON)
	name_language = null // Use the first-name last-name generator rather than a language scrambler
	mob_size = 9
	spawn_flags = CAN_JOIN
	appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_TONE | HAS_LIPS | HAS_UNDERWEAR | HAS_EYE_COLOR | HAS_SOCKS | HAS_SKIN_PRESET
	remains_type = /obj/effect/decal/remains/human

	stamina = 130	// Humans can sprint for longer than any other species
	stamina_recovery = 5
	sprint_speed_factor = 0.9
	sprint_cost_factor = 0.5

	grab_mod = 1.25 //humans are wily fuckers - geeves
	climb_coeff = 1

	inherent_verbs = list(
		/mob/living/carbon/human/proc/tie_hair)

	zombie_type = SPECIES_ZOMBIE
	base_color = "#25032"
	character_color_presets = list("Dark" = "#000000", "Warm" = "#250302", "Cold" = "#1e1e29")

/datum/species/human/handle_npc(var/mob/living/carbon/human/H)
	if(H.stat != CONSCIOUS)
		return

	if(H.get_shock() && H.shock_stage < 40 && prob(3))
		H.emote(pick("moan","groan"))

	if(H.shock_stage > 10 && prob(3))
		H.emote(pick("cry","whimper"))

	if(H.shock_stage >= 40 && prob(3))
		H.emote("scream")

	if(!H.restrained() && H.lying && H.shock_stage >= 60 && prob(3))
		H.custom_emote("thrashes in agony")

	if(!H.restrained() && H.shock_stage < 40 && prob(3))
		var/maxdam = 0
		var/obj/item/organ/external/damaged_organ = null
		for(var/obj/item/organ/external/E in H.organs)
			if(!E.can_feel_pain())
				continue
			var/dam = E.get_damage()
			// make the choice of the organ depend on damage,
			// but also sometimes use one of the less damaged ones
			if(dam > maxdam && (maxdam == 0 || prob(50)) )
				damaged_organ = E
				maxdam = dam
		var/datum/gender/T = gender_datums[H.get_gender()]
		if(damaged_organ)
			if(damaged_organ.status & ORGAN_BLEEDING)
				H.custom_emote("clutches [T.his] [damaged_organ.name], trying to stop the blood.")
			else if(damaged_organ.status & ORGAN_BROKEN)
				H.custom_emote("holds [T.his] [damaged_organ.name] carefully.")
			else if(damaged_organ.burn_dam > damaged_organ.brute_dam && damaged_organ.organ_tag != BP_HEAD)
				H.custom_emote("blows on [T.his] [damaged_organ.name] carefully.")
			else
				H.custom_emote("rubs [T.his] [damaged_organ.name] carefully.")

		for(var/obj/item/organ/I in H.internal_organs)
			if((I.status & ORGAN_DEAD) || BP_IS_ROBOTIC(I))
				continue
			if(I.damage > 2)
				if(prob(2))
					var/obj/item/organ/external/parent = H.get_organ(I.parent_organ)
					H.custom_emote("clutches [T.his] [parent.name]!")

#define HUMAN_EATING_NO_ISSUE		0
#define HUMAN_EATING_NO_MOUTH		1
#define HUMAN_EATING_BLOCKED_MOUTH	2

#define add_clothing_protection(A)	\
	var/obj/item/clothing/C = A; \
	flash_protection += C.flash_protection; \
	equipment_tint_total += C.tint;

/mob/living/carbon/human/can_eat(var/food, var/feedback = 1)
	var/list/status = can_eat_status()
	if(status[1] == HUMAN_EATING_NO_ISSUE)
		return 1
	if(feedback)
		if(status[1] == HUMAN_EATING_NO_MOUTH)
			to_chat(src, "Where do you intend to put \the [food]? You don't have a mouth!")
		else if(status[1] == HUMAN_EATING_BLOCKED_MOUTH)
			to_chat(src, "<span class='warning'>\The [status[2]] is in the way!</span>")
	return 0

/mob/living/carbon/human/can_force_feed(var/feeder, var/food, var/feedback = 1)
	var/list/status = can_eat_status()
	if(status[1] == HUMAN_EATING_NO_ISSUE)
		return 1
	if(feedback)
		if(status[1] == HUMAN_EATING_NO_MOUTH)
			to_chat(feeder, "Where do you intend to put \the [food]? \The [src] doesn't have a mouth!")
		else if(status[1] == HUMAN_EATING_BLOCKED_MOUTH)
			to_chat(feeder, "<span class='warning'>\The [status[2]] is in the way!</span>")
	return 0

/mob/living/carbon/human/proc/can_eat_status()
	if(!check_has_mouth())
		return list(HUMAN_EATING_NO_MOUTH)
	var/obj/item/blocked = check_mouth_coverage()
	if(blocked)
		return list(HUMAN_EATING_BLOCKED_MOUTH, blocked)
	return list(HUMAN_EATING_NO_ISSUE)

#undef HUMAN_EATING_NO_ISSUE
#undef HUMAN_EATING_NO_MOUTH
#undef HUMAN_EATING_BLOCKED_MOUTH

/mob/living/carbon/human/proc/update_equipment_vision()
	flash_protection = 0
	equipment_tint_total = 0
	equipment_see_invis	= 0
	equipment_vision_flags = 0
	equipment_prescription = 0
	equipment_darkness_modifier = 0
	equipment_overlays.Cut()

	var/binoc_check
	if(client)
		binoc_check = client.view == world.view
	else
		binoc_check = TRUE

	if(((!client || client.eye == src || client.eye == loc || client.eye == z_eye) && binoc_check) || HAS_TRAIT(src, TRAIT_COMPUTER_VIEW)) // !client is so the unit tests function
		if(istype(src.head, /obj/item/clothing/head))
			add_clothing_protection(head)
		if(istype(src.glasses, /obj/item/clothing/glasses))
			process_glasses(glasses)
		if(istype(src.wear_mask, /obj/item/clothing/mask))
			add_clothing_protection(wear_mask)
		if(istype(back,/obj/item/rig))
			process_rig(back)

/mob/living/carbon/human/proc/process_glasses(var/obj/item/clothing/glasses/G)
	if(G && G.active)
		equipment_darkness_modifier += G.darkness_view
		equipment_vision_flags |= G.vision_flags
		equipment_prescription = equipment_prescription || G.prescription
		if(G.overlay)
			equipment_overlays |= G.overlay
		if(G.see_invisible >= 0)
			if(equipment_see_invis)
				equipment_see_invis = min(equipment_see_invis, G.see_invisible)
			else
				equipment_see_invis = G.see_invisible

		add_clothing_protection(G)
		G.process_hud(src)

/mob/living/carbon/human/proc/process_rig(var/obj/item/rig/O)
	if(O.visor && O.visor.active && O.visor.vision && O.visor.vision.glasses && (!O.helmet || (head && O.helmet == head)))
		process_glasses(O.visor.vision.glasses)

// Applies organ/markings prefs to this mob.
/mob/living/carbon/human/proc/sync_organ_prefs_to_mob(datum/preferences/prefs, apply_prosthetics = TRUE, apply_markings = TRUE)
	if (apply_prosthetics)
		var/list/rlimb_data = prefs.rlimb_data
		var/list/organ_data = prefs.organ_data
		for(var/name in organ_data)
			var/status = organ_data[name]
			var/obj/item/organ/external/O = organs_by_name[name]
			if(O)
				O.status = 0
				switch(status)

					if ("amputated")
						organs_by_name[O.limb_name] = null
						organs -= O
						if(O.children) // This might need to become recursive.
							for(var/obj/item/organ/external/child in O.children)
								organs_by_name[child.limb_name] = null
								organs -= child

					if ("nymph")
						if (organ_data[name])
							O.AddComponent(/datum/component/nymph_limb)
							var/datum/component/nymph_limb/D = O.GetComponent(/datum/component/nymph_limb)
							if(D)
								D.nymphize(src, O.limb_name, TRUE)

					if ("cyborg")
						if (rlimb_data[name])
							O.force_skintone = FALSE
							for(var/thing in O.children)
								var/obj/item/organ/external/child = thing
								child.force_skintone = FALSE
							O.robotize(rlimb_data[name])
						else
							O.robotize()
			else
				var/obj/item/organ/I = internal_organs_by_name[name]
				if(I)
					switch (status)
						if ("assisted")
							I.mechassist()
						if ("mechanical")
							if (rlimb_data[name])
								I.robotize(rlimb_data[name])
							else
								I.robotize()
						if ("removed")
							qdel(I)

	if (apply_markings)
		for(var/N in organs_by_name)
			var/obj/item/organ/external/O = organs_by_name[N]
			if (O)
				O.genetic_markings = null
				O.temporary_markings = null
				O.invalidate_marking_cache()

		var/list/body_markings = prefs.body_markings
		for(var/M in body_markings)
			var/datum/sprite_accessory/marking/mark_datum = body_marking_styles_list[M]

			if(!istype(mark_datum))
				to_chat(usr, SPAN_WARNING("Invalid body marking [M] selected! Please re-save your markings, as they may have changed."))
				continue
			var/mark_color = "[body_markings[M]]"

			for(var/BP in mark_datum.body_parts)
				var/obj/item/organ/external/O = organs_by_name[BP]
				if(O)
					if(mark_datum.robotize_type_required && O.robotize_type != mark_datum.robotize_type_required)
						continue
					var/list/attr = list("color" = mark_color, "datum" = mark_datum)
					if (mark_datum.is_genetic)
						LAZYINITLIST(O.genetic_markings)
						O.genetic_markings[M] = attr
					else
						LAZYINITLIST(O.temporary_markings)
						O.temporary_markings[M] = attr

/mob/living/carbon/human/proc/sync_trait_prefs_to_mob(datum/preferences/prefs)
	var/list/traits = prefs.disabilities
	for(var/M in traits)
		var/datum/character_disabilities/trait = chargen_disabilities_list[M]
		trait.apply_self(src)

// Helper proc that grabs whatever organ this humantype uses to see.
// Usually eyes, but can be something else.
// If `no_synthetic` is TRUE, returns null for mobs that are mechanical, or for mechanical eyes.
/mob/living/carbon/human/proc/get_eyes(no_synthetic = FALSE)
	if (!species.vision_organ || !species.has_organ[species.vision_organ] || (no_synthetic && (species.flags & IS_MECHANICAL)))
		return null

	var/obj/item/organ/O = internal_organs_by_name[species.vision_organ]
	if (!istype(O, /obj/item/organ/internal/eyes) || (no_synthetic && (O.status & ORGAN_ROBOT)))
		return null

	return O

/mob/living/carbon/human/proc/awaken_psi_basic(var/source, var/allow_latency = TRUE)
	var/static/list/psi_operancy_messages = list(
		"There's something in your skull!",
		"Something is eating your thoughts!",
		"You can feel your brain being rewritten!",
		"Something is crawling over your frontal lobe!",
		"Something is drilling through your skull!",
		"Your head feels like it's going to implode!",
		"Thousands of ants are tunneling in your head!"
		)
	to_chat(src, SPAN_DANGER("An indescribable, brain-tearing sound hisses from [source], and you collapse in a seizure!"))
	seizure()
	var/new_latencies = rand(2,4)
	var/list/faculties = list(PSI_COERCION, PSI_REDACTION, PSI_ENERGISTICS, PSI_PSYCHOKINESIS)
	for(var/i = 1 to new_latencies)
		custom_pain(SPAN_DANGER("<font size = 3>[pick(psi_operancy_messages)]</font>"), 25)
		set_psi_rank(pick_n_take(faculties), allow_latency ? PSI_RANK_LATENT : PSI_RANK_OPERANT) // if set to latent, it spikes anywhere from OPERANT to PARAMOUNT
		sleep(30)
	addtimer(CALLBACK(psi, TYPE_PROC_REF(/datum/psi_complexus, check_latency_trigger), 100, source, TRUE), 4.5 SECONDS)

/mob/living/carbon/human/get_resist_power()
	return species.resist_mod

// Handle cases where the mob's awareness may reside in another mob, but still cares about how its brain is doing
/mob/living/carbon/human/proc/find_mob_consciousness()
	if(istype(bg) && bg.client)
		return bg

	return src

/mob/living/carbon/human/proc/has_hearing_aid()
	if(istype(l_ear, /obj/item/device/hearing_aid) || istype(r_ear, /obj/item/device/hearing_aid))
		return TRUE
	if(has_functioning_augment(BP_AUG_COCHLEAR))
		return TRUE
	return FALSE

/mob/living/carbon/human/proc/has_stethoscope_active()
	var/obj/item/clothing/under/uniform = w_uniform
	var/obj/item/clothing/suit/suit = wear_suit
	if(suit)
		var/obj/item/clothing/accessory/stethoscope/stet = locate() in suit.accessories
		if(stet)
			if(stet.auto_examine)
				return TRUE
	if(uniform)
		var/obj/item/clothing/accessory/stethoscope/stet = locate() in uniform.accessories
		if(stet)
			if(stet.auto_examine)
				return TRUE
	return FALSE

/mob/living/carbon/human/proc/is_submerged()
	if(lying && istype(loc, /turf/simulated/floor/beach/water)) // replace this when we port fluids
		return TRUE
	return FALSE

/mob/living/carbon/human/proc/getCryogenicFactor(var/bodytemperature)
	if(isSynthetic())
		return 0
	if(!species)
		return 0

	if(bodytemperature > species.cold_level_1)
		return 0
	else if(bodytemperature > species.cold_level_2)
		. = 5 * (1 - (bodytemperature - species.cold_level_2) / (species.cold_level_1 - species.cold_level_2))
		. = max(2, .)
	else if(bodytemperature > species.cold_level_3)
		. = 20 * (1 - (bodytemperature - species.cold_level_3) / (species.cold_level_2 - species.cold_level_3))
		. = max(5, .)
	else
		. = 80 * (1 - bodytemperature / species.cold_level_3)
		. = max(20, .)
	return round(.)

// Martial Art Helpers
/mob/living/carbon/human/proc/check_martial_deflection_chance()
	var/deflection_chance = 0
	if(!length(known_martial_arts))
		return deflection_chance
	for(var/art in known_martial_arts)
		var/datum/martial_art/M = art
		deflection_chance = max(deflection_chance, M.deflection_chance)
	return deflection_chance

/mob/living/carbon/human/proc/check_weapon_affinity(var/obj/O, var/parry_chance)
	if(!length(known_martial_arts))
		return FALSE
	var/parry_bonus = 0
	for(var/art in known_martial_arts)
		var/datum/martial_art/M = art
		for(var/type in M.weapon_affinity)
			if(istype(O, type))
				if(parry_chance)
					parry_bonus = max(parry_bonus, M.parry_multiplier)
					continue
				return TRUE
	if(parry_chance)
		return parry_bonus
	return FALSE

/mob/living/carbon/human/proc/check_no_guns()
	if(!length(known_martial_arts))
		return FALSE
	for(var/art in known_martial_arts)
		var/datum/martial_art/M = art
		if(M.no_guns)
			return M.no_guns_message
	return FALSE

/mob/living/carbon/human/get_standard_pixel_x()
	return species.icon_x_offset

/mob/living/carbon/human/get_standard_pixel_y()
	return species.icon_y_offset

/mob/living/carbon/human/get_hearing_protection()
	. = EAR_PROTECTION_NONE

	if ((l_ear?.item_flags & SOUNDPROTECTION) || (r_ear?.item_flags & SOUNDPROTECTION) || (head?.item_flags & SOUNDPROTECTION))
		return EAR_PROTECTION_MAJOR

	if(istype(head, /obj/item/clothing/head/helmet) || HAS_FLAG(mutations, HULK))
		. = EAR_PROTECTION_MODERATE

	return max(EAR_PROTECTION_REDUCED, . - (get_hearing_sensitivity() / 2))

/mob/living/carbon/human/noise_act(intensity = EAR_PROTECTION_MODERATE, stun_pwr = 0, damage_pwr = 0, deafen_pwr = 0)
	intensity -= get_hearing_protection()

	if(intensity <= 0)
		return FALSE

	if(stun_pwr)
		Weaken(stun_pwr * intensity)

	if(deafen_pwr || damage_pwr)
		var/ear_damage = damage_pwr * intensity
		var/deaf = deafen_pwr * intensity
		adjustEarDamage(rand(1, ear_damage), deaf, TRUE)
		sound_to(src, sound('sound/weapons/flash_ring.ogg',0,1,0,100))

	return intensity

/mob/living/carbon/human/get_antag_datum(var/antag_role)
	if(!mind)
		return
	var/datum/D = mind.antag_datums[antag_role]
	if(D)
		return D

/mob/living/carbon/human/set_respawn_time()
	if(species?.respawn_type)
		set_death_time(species.respawn_type, world.time)
	else
		set_death_time(CREW, world.time)

/mob/living/carbon/human/get_contained_external_atoms()
	. = ..() - organs

/mob/living/carbon/human/proc/pressure_resistant()
	if(HAS_FLAG(mutations, COLD_RESISTANCE))
		return TRUE
	var/datum/changeling/changeling = get_antag_datum(MODE_CHANGELING)
	if(changeling?.space_adapted)
		return TRUE
	return FALSE

/mob/living/carbon/human/get_cell()
	var/obj/item/organ/internal/cell/C = internal_organs_by_name[BP_CELL]
	if(C)
		return C.cell

/mob/living/carbon/human/proc/has_functioning_augment(var/aug_tag)
	var/obj/item/organ/internal/augment/aug = internal_organs_by_name[aug_tag]
	if(aug && !aug.is_broken())
		return TRUE
	return FALSE

/mob/living/carbon/human/eyes_protected(var/obj/stab_item, var/stabbed = FALSE) // if stabbed is set to true if we're being stabbed and not just checking
	. = ..()
	if(.)
		return
	for(var/obj/item/protection in list(head, wear_mask, glasses))
		if(protection.protects_eyestab(stab_item, stabbed))
			return TRUE
	return FALSE

/mob/living/carbon/human/get_hearing_sensitivity()
	return species.hearing_sensitivity

/mob/living/carbon/human/proc/is_listening()
	if(src in intent_listener)
		return TRUE
	return FALSE

/mob/living/carbon/human/get_organ_name_from_zone(var/def_zone)
	var/obj/item/organ/external/E = organs_by_name[parse_zone(def_zone)]
	if(E)
		return E.name
	return ..()

/mob/living/carbon/human/is_anti_materiel_vulnerable()
	if(isSynthetic())
		return TRUE
	else
		return FALSE

/mob/living/carbon/human/get_talk_bubble()
	if(!species || !species.talk_bubble_icon)
		return ..()
	return species.talk_bubble_icon

/mob/living/carbon/human/get_floating_chat_x_offset()
	if(!species)
		return ..()
	if(!isnull(species.floating_chat_x_offset))
		return species.floating_chat_x_offset
	return species.icon_x_offset

/mob/living/carbon/human/get_stutter_verbs()
	return species.stutter_verbs

/mob/living/carbon/human/proc/set_tail_style(var/new_style)
	tail_style = new_style
	if(tail_style)
		verbs |= /mob/living/carbon/human/proc/open_tail_storage
	else
		verbs -= /mob/living/carbon/human/proc/open_tail_storage

/mob/living/carbon/human/proc/get_tail_accessory()
	var/obj/item/organ/external/groin/G = organs_by_name[BP_GROIN]
	if(!G)
		return
	if(!G.tail_storage)
		return

	if(length(G.tail_storage.contents))
		return G.tail_storage.contents[1]
	return null

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
					if ("cyborg")
						if (rlimb_data[name])
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
							I.robotize()

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
			var/mark_color = "[body_markings[M]]"

			for(var/BP in mark_datum.body_parts)
				var/obj/item/organ/external/O = organs_by_name[BP]
				if(O)
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
	if (!istype(O, /obj/item/organ/eyes) || (no_synthetic && (O.status & ORGAN_ROBOT)))
		return null

	return O

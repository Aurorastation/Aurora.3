/datum/technomancer/spell/mend_synthetic
	name = "Mend Synthetic"
	desc = "Repairs minor damage to prosthetics.  \
	Instability is split between the target and technomancer, if seperate.  The function will end prematurely \
	if the target is completely healthy, preventing further instability."
	spell_power_desc = "Healing amount increased."
	cost = 50
	obj_path = /obj/item/spell/modifier/mend_synthetic
	ability_icon_state = "tech_mendsynth"
	category = SUPPORT_SPELLS

/obj/item/spell/modifier/mend_synthetic
	name = "mend synthetic"
	desc = "You are the Robotics lab"
	icon_state = "mend_synthetic"
	cast_methods = CAST_MELEE
	aspect = ASPECT_BIOMED // sorta??
	light_color = "#FF5C5C"
	modifier_type = /datum/modifier/technomancer/mend_synthetic
	modifier_duration = 10 SECONDS

/obj/item/spell/modifier/mend_synthetic/on_add_modifier(var/mob/living/L)
	if(!has_synthetic_damage_to_repair(L))
		to_chat(owner, SPAN_WARNING("\The [L] has no synthetic damage to repair."))
		return FALSE
	return ..()

//dont fucking look at it
/obj/item/spell/modifier/mend_synthetic/proc/has_synthetic_damage_to_repair(var/mob/living/L)
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		for(var/obj/item/organ/external/O in H.organs)
			if(BP_IS_ROBOTIC(O) && (O.brute_dam || O.burn_dam))
				return TRUE
		return FALSE
	if(L.isSynthetic() && (L.getBruteLoss() || L.getFireLoss()))
		return TRUE
	return FALSE

/datum/modifier/technomancer/mend_synthetic
	on_created_text = SPAN_WARNING("Sparkles begin to appear around you, and your systems report integrity rising.")
	on_expired_text = SPAN_NOTICE("The sparkles have faded, although your systems seem to be better than before.")

//dont fucking look at it i said!
/datum/modifier/technomancer/mend_synthetic/process()
	. = ..()
	if(!. || QDELETED(src))
		return
	if(isliving(target))
		var/mob/living/M = target
		var/repaired_damage = FALSE
		if(ishuman(M))
			var/mob/living/carbon/human/H = target
			for(var/obj/item/organ/external/E in H.organs)
				var/obj/item/organ/external/O = E
				if(!BP_IS_ROBOTIC(O) || (!O.brute_dam && !O.burn_dam))
					continue
				var/previous_brute = O.brute_dam
				var/previous_burn = O.burn_dam
				O.heal_damage(4 * strength, 4 * strength, 0, TRUE)
				if(O.brute_dam < previous_brute || O.burn_dam < previous_burn)
					repaired_damage = TRUE
		else
			if(M.isSynthetic())
				var/previous_brute = M.getBruteLoss()
				var/previous_burn = M.getFireLoss()
				M.adjustBruteLoss(-4 * strength) // Should heal roughly 20 burn/brute over 10 seconds, as tick() is run every 2 seconds.
				M.adjustFireLoss(-4 * strength) // Ditto.
				repaired_damage = M.getBruteLoss() < previous_brute || M.getFireLoss() < previous_burn
				if(repaired_damage)
					M.updatehealth()

		if(!repaired_damage) // No point existing if the spell can't heal.
			stop()
			return

		M.adjust_instability(1)
		if(source)
			var/mob/living/L = source
			if(istype(L) && L != M)
				L.adjust_instability(1)

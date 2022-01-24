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

/datum/modifier/technomancer/mend_synthetic
	on_created_text = "<span class='warning'>Sparkles begin to appear around you, and your systems report integrity rising.</span>"
	on_expired_text = "<span class='notice'>The sparkles have faded, although your systems seem to be better than before.</span>"

/datum/modifier/technomancer/mend_synthetic/process()
	. = ..()
	if(isliving(target))
		var/mob/living/M = target
		if(!M.getBruteLoss() && !M.getFireLoss()) // No point existing if the spell can't heal.
			stop()
			return
		if(ishuman(M))
			var/mob/living/carbon/human/H = target
			for(var/obj/item/organ/external/E in H.organs)
				var/obj/item/organ/external/O = E
				if(O.robotic >= ORGAN_ROBOT)
					O.heal_damage(4 * strength, 4 * strength, 0, TRUE)
		else
			if(M.isSynthetic())
				M.adjustBruteLoss(-4 * strength) // Should heal roughly 20 burn/brute over 10 seconds, as tick() is run every 2 seconds.
				M.adjustFireLoss(-4 * strength) // Ditto.

		M.adjust_instability(1)
		if(source)
			var/mob/living/L = source
			if(istype(L))
				L.adjust_instability(1)
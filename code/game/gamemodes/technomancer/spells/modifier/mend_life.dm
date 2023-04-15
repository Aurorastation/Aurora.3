/datum/technomancer/spell/mend_life
	name = "Mend Life"
	desc = "Heals minor wounds, such as cuts, bruises, burns, and other non-lifethreatening injuries.  \
	Instability is split between the target and technomancer, if seperate.  The function will end prematurely \
	if the target is completely healthy, preventing further instability."
	spell_power_desc = "Healing amount increased."
	cost = 50
	obj_path = /obj/item/spell/modifier/mend_life
	ability_icon_state = "tech_mendwounds"
	category = SUPPORT_SPELLS

/obj/item/spell/modifier/mend_life
	name = "mend life"
	desc = "Watch your wounds close up before your eyes."
	icon_state = "mend_life"
	cast_methods = CAST_MELEE
	aspect = ASPECT_BIOMED
	light_color = "#FF5C5C"
	modifier_type = /datum/modifier/technomancer/mend_life
	modifier_duration = 10 SECONDS

/datum/modifier/technomancer/mend_life
	on_created_text = "<span class='warning'>Sparkles begin to appear around you, and you feel really.. refreshed.</span>"
	on_expired_text = "<span class='notice'>The sparkles have faded, although you feel healthier than before.</span>"

/datum/modifier/technomancer/mend_life/process()
	. = ..()
	if(isliving(target))
		var/mob/living/M = target
		if(M.isSynthetic()) // Don't heal synths!
			stop()
			return
		if(!M.getBruteLoss() && !M.getFireLoss()) // No point existing if the spell can't heal.
			stop()
			return
		M.adjustBruteLoss(-4 * strength) // Should heal roughly 20 burn/brute over 10 seconds, as tick() is run every 2 seconds.
		M.adjustFireLoss(-4 * strength) // Ditto.
		M.adjust_instability(1)
		if(source)
			var/mob/living/L = source
			if(istype(L))
				L.adjust_instability(1)
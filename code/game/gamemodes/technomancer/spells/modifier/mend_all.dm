// Gambit only spell.  Heals everything unconditionally.

/obj/item/spell/modifier/mend_all
	name = "mend all"
	desc = "One function to heal them all."
	icon_state = "mend_all"
	cast_methods = CAST_MELEE
	aspect = ASPECT_BIOMED
	light_color = "#FF5C5C"
	modifier_type = /datum/modifier/technomancer/mend_life
	modifier_duration = 1 MINUTE

/datum/modifier/technomancer/mend_all
	name = "mend all"
	desc = "You feel serene and well rested."
	mob_overlay_state = "green_sparkles"

	on_created_text = "<span class='warning'>Sparkles begin to appear around you, and all your ills seem to fade away.</span>"
	on_expired_text = "<span class='notice'>The sparkles have faded, although you feel much healthier than before.</span>"
	stacks = MODIFIER_STACK_EXTEND

/datum/modifier/technomancer/mend_all/tick()
	if(!holder.getBruteLoss() && !holder.getFireLoss() && !holder.getToxLoss() && !holder.getOxyLoss() && !holder.getCloneLoss()) // No point existing if the spell can't heal.
		stop()
		return
	holder.adjustBruteLoss(-4 * spell_power) // Should heal roughly 120 damage over 1 minute, as tick() is run every 2 seconds.
	holder.adjustFireLoss(-4 * spell_power)
	holder.adjustToxLoss(-4 * spell_power)
	holder.adjustOxyLoss(-4 * spell_power)
	holder.adjustCloneLoss(-2 * spell_power) // 60 cloneloss
	holder.adjust_instability(1)
	if(origin)
		var/mob/living/L = origin.resolve()
		if(istype(L))
			L.adjust_instability(1) //TODOMATT: Tick this file and figure this out
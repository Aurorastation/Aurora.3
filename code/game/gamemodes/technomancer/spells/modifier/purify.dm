/datum/technomancer/spell/purify
	name = "Purify"
	desc = "Clenses the body of harmful impurities, such as toxins, radiation, viruses, genetic damage, and such.  \
	Instability is split between the target and technomancer, if seperate.  The function will end prematurely \
	if the target is completely healthy, preventing further instability."
	spell_power_desc = "Healing amount increased."
	cost = 25
	obj_path = /obj/item/spell/modifier/purify
	ability_icon_state = "tech_purify"
	category = SUPPORT_SPELLS

/obj/item/spell/modifier/purify
	name = "mend life"
	desc = "Watch your wounds close up before your eyes."
	icon_state = "mend_life"
	cast_methods = CAST_MELEE
	aspect = ASPECT_BIOMED
	light_color = "#FF5C5C"
	modifier_type = /datum/modifier/technomancer/purify
	modifier_duration = 10 SECONDS

/datum/modifier/technomancer/purify
	name = "purify"
	desc = "You feel rather clean and pure."
	mob_overlay_state = "green_sparkles"

	on_created_text = "<span class='warning'>Sparkles begin to appear around you, and you feel really.. pure.</span>"
	on_expired_text = "<span class='notice'>The sparkles have faded, although you feel healthier than before.</span>"
	stacks = MODIFIER_STACK_EXTEND

/datum/modifier/technomancer/purify/tick()
	if(!holder.getToxLoss()) // No point existing if the spell can't heal.
		expire()
		return
	holder.adjustToxLoss(-4 * spell_power) // Should heal roughly 120 damage over 1 minute, as tick() is run every 2 seconds.
	holder.adjust_instability(1)
	if(origin)
		var/mob/living/L = origin.resolve()
		if(istype(L))
			L.adjust_instability(1) //TODOMATT: Tick this file and figure this out
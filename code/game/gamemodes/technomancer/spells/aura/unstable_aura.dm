/datum/technomancer/spell/unstable_aura
	name = "Degen Aura"
	desc = "Destabilizes your enemies, breaking their elements down to their basic levels, slowly killing them from the inside.  \
	For each person within <b>fourteen meters</b> of you, they suffer 1% of their current health every second.  Your allies are \
	unharmed."
	spell_power_desc = "Radius is increased."
	cost = 150
	obj_path = /obj/item/spell/aura/unstable
	ability_icon_state = "tech_unstableaura"
	category = OFFENSIVE_SPELLS

/obj/item/spell/aura/unstable
	name = "degen aura"
	desc = "Breaks down your entities from the inside. Synthetics will take brute damage while organics will take fire damage."
	icon_state = "generic"
	cast_methods = null
	aspect = ASPECT_UNSTABLE
	glow_color = "#CC00CC"

/obj/item/spell/aura/unstable/process()
	if(!pay_energy(200))
		qdel(src)
	var/list/nearby_mobs = range(calculate_spell_power(14),owner)
	for(var/mob/living/L in nearby_mobs)
		if(is_ally(L))
			continue
		
		if(L.loc == owner)
			continue

		var/damage_to_inflict = max(L.health / L.getMaxHealth(), 0) // Otherwise, those in crit would actually be healed.

		var/armor_factor = L.modify_damage_by_armor(BP_CHEST, 30, BURN, armor_pen = 40)
		damage_to_inflict = damage_to_inflict * armor_factor

		if(L.isSynthetic())
			L.adjustBruteLoss(damage_to_inflict)
			if(damage_to_inflict && prob(10))
				to_chat(L, "<span class='danger'>Your chassis seems to slowly be decaying and breaking down.</span>")
		else
			L.adjustFireLoss(damage_to_inflict)
			if(damage_to_inflict && prob(10))
				to_chat(L, "<span class='danger'>You feel almost like you're melting from the inside!</span>")


	adjust_instability(2)
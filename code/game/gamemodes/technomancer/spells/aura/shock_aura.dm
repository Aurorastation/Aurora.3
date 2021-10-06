/datum/technomancer/spell/shock_aura
	name = "Electric Aura"
	desc = "Repeatedly electrocutes enemies within four meters of you, as well as nearby electronics."
	enhancement_desc = "Aura does twice as much damage."
	spell_power_desc = "Radius and damage scaled up."
	cost = 100
	obj_path = /obj/item/spell/aura/shock
	ability_icon_state = "tech_shockaura"
	category = OFFENSIVE_SPELLS

/obj/item/spell/aura/shock
	name = "electric aura"
	desc = "Now you are a walking electrical storm."
	icon_state = "generic"
	cast_methods = null
	aspect = ASPECT_SHOCK
	glow_color = "#0000FF" //TODO

/obj/item/spell/aura/shock/process()
	if(!pay_energy(500))
		qdel(src)
	var/list/nearby_mobs = range(calculate_spell_power(4), owner)
	var/power = calculate_spell_power(7)
	if(check_for_scepter())
		power = calculate_spell_power(15)
	for(var/obj/machinery/light/light in range(calculate_spell_power(7), owner))
		light.flicker()
	for(var/mob/living/L in nearby_mobs)
		if(is_ally(L))
			continue
		
		if(L.loc == owner)
			continue

		if(L.isSynthetic())
			to_chat(L, "<span class='danger'>ERROR: Electrical fault detected!</span>")
			L.stuttering += 3

		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			var/obj/item/organ/external/affected = H.get_organ(check_zone(BP_CHEST))
			H.electrocute_act(power, src, H.get_siemens_coefficient_organ(affected), BP_CHEST)
		else
			L.electrocute_act(power, src, 0.75, BP_CHEST)

	adjust_instability(3)

/datum/technomancer/spell/frost_aura
	name = "Chilling Aura"
	desc = "Lowers the core body temperature of everyone around you (except for your friends), causing them to become very slow if \
	they stay within four meters of you."
	enhancement_desc = "Will make nearby entities even slower."
	spell_power_desc = "Radius and rate of cooling are scaled."
	cost = 100
	obj_path = /obj/item/spell/aura/frost
	ability_icon_state = "tech_frostaura"
	category = DEFENSIVE_SPELLS // Scepter-less frost aura is nonlethal.

/obj/item/spell/aura/frost
	name = "chilling aura"
	desc = "Your enemies will find it hard to chase you if they freeze to death."
	icon_state = "generic"
	cast_methods = null
	aspect = ASPECT_FROST
	glow_color = "#00B3FF"

/obj/item/spell/aura/frost/process()
	if(!pay_energy(100))
		qdel(src)
	var/list/nearby_mobs = range(round(calculate_spell_power(4)),owner)

	var/temp_change = calculate_spell_power(40)
	var/datum/species/baseline = GLOB.all_species["Human"]
	var/temp_cap = baseline.cold_level_2 - 5

	if(check_for_scepter())
		temp_change *= 2
		temp_cap = baseline.cold_level_3 - 5

	for(var/mob/living/carbon/human/H in nearby_mobs)
		if(is_ally(H))
			continue

		var/protection = H.get_cold_protection(1000)
		if(protection < 1)
			var/cold_factor = abs(protection - 1)
			temp_change *= cold_factor
			H.bodytemperature = max(H.bodytemperature - temp_change, temp_cap)

	adjust_instability(1)

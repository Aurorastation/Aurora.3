/datum/technomancer/spell/radiance
	name = "Radiance"
	desc = "Causes you to be very radiant, glowing brightly in visible light, thermal energy, and deadly ionizing radiation.  Note \
	that this WILL affect you."
	enhancement_desc = "Radiation will not affect the caster or their allies."
	spell_power_desc = "Spell power increases the amount of radiation and heat radiated, as well as the radius."
	cost = 100
	ability_icon_state = "swarm_zeropoint"
	obj_path = /obj/item/spell/radiance
	category = OFFENSIVE_SPELLS

/obj/item/spell/radiance
	name = "radiance"
	desc = "You will glow with a radiance similar to that of Supermatter."
	icon_state = "radiance"
	aspect = ASPECT_LIGHT
	var/power = 250
	toggled = 1

/obj/item/spell/radiance/New()
	..()
	set_light(7, 4, l_color = "#D9D900")
	START_PROCESSING(SSprocessing, src)
	log_and_message_admins("has casted [src].")

/obj/item/spell/radiance/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	log_and_message_admins("has stopped maintaining [src].")
	return ..()

/obj/item/spell/radiance/process()
	var/turf/T = get_turf(src)
	if(!istype(T)) return
	var/datum/gas_mixture/removed = null
	var/datum/gas_mixture/env = null
	var/adjusted_power = calculate_spell_power(power)

	if(!istype(T, /turf/space))
		env = T.return_air()
		removed = env.remove(0.25 * env.total_moles)	//Remove gas from surrounding area

		var/thermal_power = 300 * adjusted_power

		removed.add_thermal_energy(thermal_power)
		removed.temperature = between(0, removed.temperature, 10000)

		env.merge(removed)

	for(var/mob/living/L in range(T, round(sqrt(adjusted_power / 2))))
		if(check_for_scepter() && is_ally(L))
			continue
		var/radius = max(get_dist(L, src), 1)
		var/rads = (adjusted_power / 10) * ( 1 / (radius**2) )
		L.apply_effect(rads, IRRADIATE)
	adjust_instability(2)

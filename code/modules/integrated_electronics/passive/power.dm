
/obj/item/integrated_circuit/passive/power
	name = "power thingy"
	desc = "Does power stuff."
	complexity = 5
	origin_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 2, TECH_DATA = 2)
	category_text = "Power - Passive"

/obj/item/integrated_circuit/passive/power/proc/make_energy()
	return

// For calculators.
/obj/item/integrated_circuit/passive/power/solar_cell
	name = "tiny photovoltaic cell"
	desc = "It's a very tiny solar cell, generally used in calculators."
	extended_desc = "The cell generates 1W of energy per second in optimal lighting conditions.  Less light will result in less power being generated."
	icon_state = "solar_cell"
	complexity = 8
	origin_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 3, TECH_DATA = 2)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	var/max_power = 1

/obj/item/integrated_circuit/passive/power/solar_cell/make_energy()
	var/turf/T = get_turf(src)
	var/light_amount = T ? T.get_lumcount() : 0
	var/adjusted_power = max(max_power * light_amount, 0)
	adjusted_power = round(adjusted_power, 0.1)
	if(adjusted_power && assembly)
		assembly.give_power(adjusted_power)

// For fat machines that need fat power, like drones.
/obj/item/integrated_circuit/passive/power/relay
	name = "tesla power relay"
	desc = "A seemingly enigmatic device which connects to nearby APCs wirelessly and draws power from them."
	w_class = ITEMSIZE_NORMAL
	extended_desc = "The siphon generates 250W of energy, so long as an APC is in the same room, with a cell that has energy.  It will always drain \
	from the 'equipment' power channel."
	icon_state = "power_relay"
	complexity = 7
	origin_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 3, TECH_DATA = 2)
	spawn_flags = IC_SPAWN_RESEARCH
	var/power_amount = 250

// For really fat machines.
/obj/item/integrated_circuit/passive/power/relay/large
	name = "large tesla power relay"
	desc = "A seemingly enigmatic device which connects to nearby APCs wirelessly and draws power from them, now in industiral size!"
	w_class = ITEMSIZE_LARGE
	extended_desc = "The siphon generates 2 kW of energy, so long as an APC is in the same room, with a cell that has energy.  It will always drain \
	from the 'equipment' power channel."
	icon_state = "power_relay"
	complexity = 15
	origin_tech = list(TECH_POWER = 6, TECH_ENGINEERING = 5, TECH_DATA = 4)
	spawn_flags = IC_SPAWN_RESEARCH
	power_amount = 2000

/obj/item/integrated_circuit/passive/power/relay/make_energy()
	if(!assembly)
		return
	var/area/A = get_area(src)
	if(A)
		if(A.powered(EQUIP) && assembly.give_power(power_amount))
			A.use_power(power_amount, EQUIP)
			// give_power() handles CELLRATE on its own.

// For implants.
/obj/item/integrated_circuit/passive/power/metabolic_siphon
	name = "metabolic siphon"
	desc = "A complicated piece of technology which converts bodily nutriments of a host into electricity."
	extended_desc = "The siphon generates 10W of energy, so long as the siphon exists inside a biological entity.  The entity will feel an increased \
	appetite and will need to eat more often due to this.  This device will fail if used inside synthetic entities."
	icon_state = "setup_implant"
	complexity = 10
	origin_tech = list(TECH_POWER = 4, TECH_ENGINEERING = 4, TECH_DATA = 4, TECH_BIO = 5)
	spawn_flags = IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/passive/power/metabolic_siphon/proc/test_validity(var/mob/living/carbon/human/host)
	if(!host || host.isSynthetic() || host.stat == DEAD || host.nutrition <= 10)
		return FALSE // Robots and dead people don't have a metabolism.
	return TRUE

/obj/item/integrated_circuit/passive/power/metabolic_siphon/make_energy()
	var/mob/living/carbon/human/host
	if(assembly && istype(assembly, /obj/item/device/electronic_assembly/implant))
		var/obj/item/device/electronic_assembly/implant/implant_assembly = assembly
		if(implant_assembly.implant.imp_in)
			host = implant_assembly.implant.imp_in

			if(test_validity(host))
				assembly.give_power(10)
				host.adjustNutritionLoss(HUNGER_FACTOR)

/obj/item/integrated_circuit/passive/power/metabolic_siphon/synthetic
	name = "internal energy siphon"
	desc = "A small circuit designed to be connected to an internal power wire inside a synthetic entity."
	extended_desc = "The siphon generates 10W of energy, so long as the siphon exists inside a synthetic entity.  The entity need to recharge \
	more often due to this.  This device will fail if used inside organic entities."
	icon_state = "setup_implant"
	complexity = 10
	origin_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 4, TECH_DATA = 3)
	spawn_flags = IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/passive/power/metabolic_siphon/synthetic/test_validity(var/mob/living/carbon/human/host)
	if(!host || !host.isSynthetic() || host.stat == DEAD || host.nutrition <= 10)
		return FALSE // This time we don't want a metabolism.
	return TRUE

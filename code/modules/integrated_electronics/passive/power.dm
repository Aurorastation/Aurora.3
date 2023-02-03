
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
			A.use_power_oneoff(power_amount, EQUIP)
			// give_power() handles CELLRATE on its own.

// For implants.
/obj/item/integrated_circuit/passive/power/metabolic_siphon
	name = "metabolic siphon"
	desc = "A complicated piece of technology which converts bodily nutriments of a host into electricity, or vice versa."
	extended_desc = "The siphon generates 10W of energy, so long as the siphon exists inside a biological entity.  The entity will feel an increased \
	appetite and will need to eat more often due to this.  This device will fail if used inside synthetic entities.\
	If the polarity is reversed, it will instead generate chemical energy with electricity, continuously consuming power from the assembly.\
	It is slightly less efficient than generating power."
	icon_state = "setup_implant"
	complexity = 10
	origin_tech = list(TECH_POWER = 4, TECH_ENGINEERING = 4, TECH_DATA = 4, TECH_BIO = 5)
	spawn_flags = IC_SPAWN_RESEARCH
	inputs = list("reverse" = IC_PINTYPE_BOOLEAN)
	outputs = list("nutrition" = IC_PINTYPE_NUMBER)
	var/inefficiency = 1.2

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
			if(!get_pin_data(IC_INPUT, 1))
				if(test_validity(host))
					assembly.give_power(10)
					host.adjustNutritionLoss(HUNGER_FACTOR)
			else
				if(assembly.draw_power(10*inefficiency)) // slightly less efficient the other way around
					host.adjustNutritionLoss(-HUNGER_FACTOR)
			set_pin_data(IC_OUTPUT, 1, host.nutrition)

/obj/item/integrated_circuit/passive/power/metabolic_siphon/synthetic
	name = "internal energy siphon"
	desc = "A small circuit designed to be connected to an internal power wire inside a synthetic entity."
	extended_desc = "The siphon generates 10W of energy, so long as the siphon exists inside a synthetic entity.  The entity needs to recharge \
	more often due to this. If the polarity is reversed, it will instead transfer electricity back to the entity, continuously consuming power from \
	the assembly. This device will fail if used inside organic entities."
	icon_state = "setup_implant"
	complexity = 10
	origin_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 4, TECH_DATA = 3)
	spawn_flags = IC_SPAWN_RESEARCH
	inefficiency = 1 // it's not converting anything, just transferring power

/obj/item/integrated_circuit/passive/power/metabolic_siphon/synthetic/test_validity(var/mob/living/carbon/human/host)
	if(!host || !host.isSynthetic() || host.stat == DEAD || host.nutrition <= 10)
		return FALSE // This time we don't want a metabolism.
	return TRUE

/obj/item/integrated_circuit/passive/power/chemical_cell
	name = "fuel cell"
	desc = "Produces electricity from chemicals."
	icon_state = "chemical_cell"
	extended_desc = "This is effectively an internal beaker. It will consume and produce power from phoron, slime jelly, welding fuel, carbon,\
	 ethanol, nutriments and blood, in order of decreasing efficiency. It will consume fuel only if the battery can take more energy."
	flags = OPENCONTAINER
	complexity = 4
	inputs = list()
	outputs = list("volume used" = IC_PINTYPE_NUMBER,"self reference" = IC_PINTYPE_REF)
	activators = list()
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 2, TECH_BIO = 2)
	var/volume = 60
	var/list/fuel = list(/singleton/reagent/toxin/phoron/pure = 50000, /singleton/reagent/slimejelly = 25000, /singleton/reagent/fuel = 15000, /singleton/reagent/carbon = 10000, /singleton/reagent/alcohol = 10000, /singleton/reagent/nutriment = 8000, /singleton/reagent/blood = 5000)

/obj/item/integrated_circuit/passive/power/chemical_cell/New()
	..()
	create_reagents(volume)

/obj/item/integrated_circuit/passive/power/chemical_cell/interact(mob/user)
	set_pin_data(IC_OUTPUT, 2, src)
	push_data()
	..()

/obj/item/integrated_circuit/passive/power/chemical_cell/on_reagent_change()
	set_pin_data(IC_OUTPUT, 1, reagents.total_volume)
	push_data()

/obj/item/integrated_circuit/passive/power/chemical_cell/make_energy()
	if(assembly)
		for(var/I in fuel)
			if((assembly.battery.maxcharge - assembly.battery.charge) / CELLRATE > fuel[I])
				if(reagents.remove_reagent(I, 1))
					assembly.give_power(fuel[I])

// Interacts with the powernet.
// Now you can make your own power generation (or poor man's powersink).

/obj/item/integrated_circuit/passive/power/powernet
	name = "power network interface"
	desc = "Gives or takes power from a wire underneath the machine."
	icon_state = "powernet"
	extended_desc = "The assembly must be anchored, with a wrench, and a wire node must be avaiable directly underneath.<br>\
	The first pin determines if power is moved at all. The second pin, if true, will draw from the powernet to charge the assembly's \
	cell, otherwise it will give power from the cell to the powernet."
	complexity = 20
	inputs = list(
		"active" = IC_PINTYPE_BOOLEAN,
		"draw power" = IC_PINTYPE_BOOLEAN
		)
	outputs = list(
		"power in grid" = IC_PINTYPE_NUMBER,
		"surplus power" = IC_PINTYPE_NUMBER,
		"load" = IC_PINTYPE_NUMBER
		)
	activators = list()
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 2, TECH_POWER = 2)
	var/obj/machinery/power/circuit_io/IO = null // Dummy power machine to move energy in/out without a bunch of code duplication.
	var/throughput = 10000 // Give/take up to 10kW.

/obj/item/integrated_circuit/passive/power/powernet/Initialize()
	IO = new(src)
	return ..()

/obj/item/integrated_circuit/passive/power/powernet/Destroy()
	qdel(IO)
	return ..()

/obj/item/integrated_circuit/passive/power/powernet/on_anchored()
	IO.connect_to_network()

/obj/item/integrated_circuit/passive/power/powernet/on_unanchored()
	IO.disconnect_from_network()

/obj/item/integrated_circuit/passive/power/powernet/make_energy()
	if(assembly && assembly.anchored && assembly.battery)
		var/should_act = get_pin_data(IC_INPUT, 1) // Even if this is false, we still need to update the output pins with powernet information.
		var/drawing = get_pin_data(IC_INPUT, 2)

		if(should_act) // We're gonna give or take from the net.
			if(drawing)
				var/to_transfer = min(throughput, (assembly.battery.maxcharge - assembly.battery.charge) / CELLRATE) // So we don't need to draw 10kW if the cell needs much less.
				var/amount = IO.draw_power(to_transfer)
				assembly.give_power(amount)
			else
				var/amount = assembly.draw_power(throughput)
				IO.add_avail(amount)

		set_pin_data(IC_OUTPUT, 1, IO.avail())
		set_pin_data(IC_OUTPUT, 2, IO.surplus())
		set_pin_data(IC_OUTPUT, 3, -IO.surplus()-IO.avail()) // we don't have a viewload() proc on machines and i'm lazy

// Internal power machine for interacting with the powernet.
// It needs a bit of special code since base /machinery/power assumes loc will be a tile.
/obj/machinery/power/circuit_io
	name = "embedded electrical I/O"

/obj/machinery/power/circuit_io/connect_to_network()
	var/turf/T = get_turf(src)
	if(!istype(T))
		return FALSE

	var/obj/structure/cable/C = T.get_cable_node()
	if(!C?.powernet)
		return FALSE

	C.powernet.add_machine(src)
	return TRUE

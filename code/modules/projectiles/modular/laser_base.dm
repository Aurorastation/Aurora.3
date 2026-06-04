/obj/item/laser_components
	icon = 'icons/obj/guns/modular_laser.dmi'
	icon_state = "bfg"
	contained_sprite = TRUE
	w_class = WEIGHT_CLASS_SMALL  //A dissasembled gun is easier to carry, this lets people bring bits of their broken gun back to R&D.
	///The Max HP of the component. This is added to the overall reliability of the weapon.
	var/reliability = 0
	//This multiplies the damage of a shot, the base damage is determined by the capacitor.
	var/damage = 1
	///This multiplies the fire delay of the weapon, the base fire delay is determined by the capacitor.
	var/fire_delay = 1
	///The amount of damage a component has taken. Subtracted from reliability.
	var/condition = 0
	///The base amount of damage this modifier does to other components when the gun is fired.
	var/base_malus = 0.1 //when modifiers get damaged they do not break, but make other components break faster
	///The amount of damage this modifier does to other components. This increases as the modifier itself gets damaged.
	var/malus = 0
	///The malus of all components is multiplied by this value.
	var/malus_multiplier = 1
	///Multiplies the total number of shots the gun can fire before recharge.
	var/shots = 1
	///This is added to the number of shots the gun fires in one click.
	var/burst = 0
	///The amount it's possible to improve a component by repairing it. This increases when the weapon is used, and decreases when it's repaired. When it hits 0, the component can no longer be improved by repairing it, but can still lose reliability.
	var/improvement_potential = 0
	///The total amount the component has been improved by repairs. This is used to put an upper limit on how much a component can be improved.
	var/total_improved = 0
	///Added to the accuracy of the weapon.
	var/accuracy = 0
	///The item required to repair the component.
	var/obj/item/repair_item
	///Lists of the variables on this component that can be improved by repairing it.
	var/list/increasable_stats = list("reliability")
	///List of variables that are better when lower, such as fire delay or malus.
	var/list/decreaseable_stats = list()
	var/gun_overlay

/obj/item/laser_components/proc/degrade(var/increment = 1)
	if(increment)
		condition += increment
		if(condition > reliability)
			condition = reliability

/obj/item/laser_components/proc/handle_improvement(var/skill_level, var/mob/user)

	if (total_improved >= IMPROVEMENT_CAP)
		to_chat(user, SPAN_NOTICE("You don't see any way to improve \the [src] any further."))
		improvement_potential = 0
		return

	while (improvement_potential > 0 && total_improved < IMPROVEMENT_CAP)

		var/improvement = min(abs(improvement_potential / 100), 0.2) //Caps improvement from a single repair to 20%. This spreads the effect out across multiple stats
		var/stat_direction = 1
		var/stat_name = null

		//TODO: Make it possible to target a specific value by repairing with a randomly selected part that research doesn't typically have access to.

		if (increasable_stats.len && decreaseable_stats.len) //Picks a random available stat to upgrade.
			if (prob(50))
				stat_name = pick(increasable_stats)
			else
				stat_name = pick(decreaseable_stats)
				stat_direction = -1
		else if (increasable_stats.len)
			stat_name = pick(increasable_stats)
			stat_direction = 1
		else if (decreaseable_stats.len)
			stat_name = pick(decreaseable_stats)
			stat_direction = -1
		else
			break //No stats to improve, it shouldn't be possible to have improvement potential and no stats to improve, but just in case.

		if (stat_name in src.vars)
			var/initial_value = initial(src.vars[stat_name])
			improvement_potential -= improvement * 100 //Decreases improvement potential before any skill modifiers.

			if (initial_value < 0) //If the stat begins negative, such as base_malus for heat vents, handle comparisons by sign.
				if (stat_direction > 0 && src.vars[stat_name] >= (initial_value * DECREASE_CAP))
					continue
				if (stat_direction < 0 && src.vars[stat_name] <= (initial_value * INCREASE_CAP))
					continue
			else
				if (src.vars[stat_name] >= (initial_value * INCREASE_CAP) && stat_direction > 0) //It is possible to waste improvement potential by hitting the cap on a stat, this is fine, it should be harder to improve a component that's already of high quality.
					continue
				if (src.vars[stat_name] <= (initial_value * DECREASE_CAP) && stat_direction < 0)
					continue

			switch(skill_level ? skill_level : 6)
				if(-INFINITY to 2)
					improvement *= (rand(-5, -1) / 10) //Always damage it.
				if(3)
					improvement *= (rand(-5, 3) / 10)
				if(4)
					improvement *= (rand(3, 5) / 10)
				if(5)
					improvement *= (rand(7, 10) / 10)
				if(6 to INFINITY)
					improvement *= (rand(8, 12) / 10)

			src.vars[stat_name] += stat_direction * abs(initial_value * improvement) //Adds improvement % of the initial value to the stat.

			if (improvement > 0)
				total_improved += improvement * 100
				if (initial_value < 0)
					if (stat_direction > 0 && src.vars[stat_name] >= initial_value * DECREASE_CAP)
						to_chat(user, SPAN_NOTICE("Your repairs to \the [src] have improved its [replacetext(stat_name, "_", " ")] as far as you think is possible."))
					else if (stat_direction < 0 && src.vars[stat_name] <= initial_value * INCREASE_CAP)
						to_chat(user, SPAN_NOTICE("Your repairs to \the [src] have improved its [replacetext(stat_name, "_", " ")] as far as you think is possible."))
					else
						to_chat(user, SPAN_NOTICE("Your careful repairs to \the [src] [stat_direction > 0 ? "increase" : "decrease"] its [replacetext(stat_name, "_", " ")] by [improvement * 100] percent!"))
				else
					if(src.vars[stat_name] >= initial_value * INCREASE_CAP && stat_direction > 0)
						to_chat(user, SPAN_NOTICE("Your repairs to \the [src] have improved its [replacetext(stat_name, "_", " ")] as far as you think is possible."))
					else if(src.vars[stat_name] <= initial_value * DECREASE_CAP && stat_direction < 0)
						to_chat(user, SPAN_NOTICE("Your repairs to \the [src] have improved its [replacetext(stat_name, "_", " ")] as far as you think is possible."))
					else
						to_chat(user, SPAN_NOTICE("Your careful repairs to \the [src] [stat_direction > 0 ? "increase" : "decrease"] its [replacetext(stat_name, "_", " ")] by [improvement * 100] percent!"))

			else if (improvement == 0)
				to_chat(user, SPAN_NOTICE("Your repairs to \the [src], don't seem to improve it, but at least you didn't make it worse."))
			else
				to_chat(user, SPAN_WARNING("Your repairs to \the [src] end up damaging it!"))

		else
			break //The stat to improve isn't on this component, something went wrong with the lists of stats or the component itself.

		if (total_improved > IMPROVEMENT_CAP)
			improvement_potential = 0
			to_chat(user, SPAN_NOTICE("You have improved \the [src] as much as you can."))

/obj/item/laser_components/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(distance > 1)
		return

	var/skill_level = (GET_SKILL_LEVEL(user, FIREARMS_SKILL_COMPONENT) + GET_SKILL_LEVEL(user, RESEARCH_SKILL_COMPONENT))
	switch(skill_level ? skill_level : 6)
		if (-INFINITY to 2)
			if(improvement_potential > 0)
				. += SPAN_WARNING("You don't think you could repair \the [src] without making it worse.")
		if (3)
			if(improvement_potential > 0)
				. += SPAN_WARNING("You might be able to repair \the [src], but you think you're much more likely to make it worse.")
		if (4)
			for (var/stat in increasable_stats)
				if (src.vars[stat] != initial(src.vars[stat]))
					. += SPAN_NOTICE("You can see \the [src]'s [replacetext(stat, "_", " ")] has had some custom work done to it.")
			for (var/stat in decreaseable_stats)
				if (src.vars[stat] != initial(src.vars[stat]))
					. += SPAN_NOTICE("You can see \the [src]'s [replacetext(stat, "_", " ")] has had some custom work done to it.")
			if(improvement_potential > 0)
				. += SPAN_GOOD("You think you could repair \the [src] and improve it, but you might also make it worse if you aren't careful.")
		if (5)
			for (var/stat in increasable_stats)
				if (src.vars[stat] > initial(src.vars[stat]))
					. += SPAN_NOTICE("You can see \the [src]'s [replacetext(stat, "_", " ")] has been improved and increased.")
				else if (src.vars[stat] < initial(src.vars[stat]))
					. += SPAN_WARNING("You can see \the [src]'s [replacetext(stat, "_", " ")] has been degraded and decreased.")
			for (var/stat in decreaseable_stats)
				if (src.vars[stat] < initial(src.vars[stat]))
					. += SPAN_NOTICE("You can see \the [src]'s [replacetext(stat, "_", " ")] has been improved and decreased.")
				else if (src.vars[stat] > initial(src.vars[stat]))
					. += SPAN_WARNING("You can see \the [src]'s [replacetext(stat, "_", " ")] has been degraded and increased.")
			if(improvement_potential > 0)
				. += SPAN_GOOD("You see a few places where damage has revealed design flaws. You could correct them to improve \the [src].")
		if (6 to INFINITY)
			for (var/stat in increasable_stats)
				if (src.vars[stat] > initial(src.vars[stat]))
					. += SPAN_NOTICE("You can see \the [src]'s [replacetext(stat, "_", " ")] has been improved, increasing it by approximately [round((src.vars[stat] - initial(src.vars[stat])) / initial(src.vars[stat]) * 100)] percent.")
				else if (src.vars[stat] < initial(src.vars[stat]))
					. += SPAN_WARNING("You can see \the [src]'s [replacetext(stat, "_", " ")] has been degraded, decreasing it by approximately [round((initial(src.vars[stat]) - src.vars[stat]) / initial(src.vars[stat]) * 100)] percent.")
			for (var/stat in decreaseable_stats)
				if (src.vars[stat] < initial(src.vars[stat]))
					. += SPAN_NOTICE("You can see \the [src]'s [replacetext(stat, "_", " ")] has been improved, decreasing it by approximately [round((src.vars[stat] - initial(src.vars[stat])) / initial(src.vars[stat]) * 100)] percent.")
				else if (src.vars[stat] > initial(src.vars[stat]))
					. += SPAN_WARNING("You can see \the [src]'s [replacetext(stat, "_", " ")] has been degraded, increasing it by approximately [round((initial(src.vars[stat]) - src.vars[stat]) / initial(src.vars[stat]) * 100)] percent.")
			if(improvement_potential > 0)
				. += SPAN_GOOD("You see a few places where damage has revealed design flaws. Correcting them could improve \the [src] by up to [improvement_potential] percent.")

/obj/item/laser_components/attackby(obj/item/attacking_item, mob/user)
	if(!istype(attacking_item, repair_item))
		return ..()
	if (condition == 0 && malus == base_malus)
		to_chat(user, SPAN_WARNING("\The [src] is not damaged."))
		return ..()

	var/skill_level = (GET_SKILL_LEVEL(user, FIREARMS_SKILL_COMPONENT) + GET_SKILL_LEVEL(user, RESEARCH_SKILL_COMPONENT))

	if(attacking_item.tool_behaviour == TOOL_WELDER)
		var/obj/item/weldingtool/WT = attacking_item
		if(WT.isOn() && WT.use_tool(src, user, rand(2 SECONDS, (10 - skill_level) SECONDS), volume = 50) && WT.use(0, user) && repair_module(attacking_item, skill_level, user))
			user.visible_message(
				SPAN_WARNING("[user] begins repairing \the [src]."),
				SPAN_NOTICE("You begin repairing \the [src]."),
				"You hear a welding torch on metal."
			)
		else
			to_chat(user, SPAN_WARNING("You fail to repair \the [src]."))

	else if(do_after(user, rand(2 SECONDS, (10 - skill_level) SECONDS), src, DO_UNIQUE) && repair_module(attacking_item, skill_level, user)) //Used if the repair item is not a tool.
		to_chat(user, SPAN_NOTICE("You repair \the [src]."))
	else
		to_chat(user, SPAN_WARNING("You fail to repair \the [src]."))

/obj/item/laser_components/proc/repair_module(var/obj/item/D, var/skill_level, var/mob/user)
		return 1

/obj/item/laser_components/modifier
	name = "modifier"
	desc = "A basic laser weapon modifier."
	reliability = -5
	var/mod_type
	var/gun_force = 0 //melee damage of the gun
	var/chargetime = 0
	var/burst_delay = 0
	var/scope_name
	var/criticality = 1
	repair_item = /obj/item/weldingtool

/obj/item/laser_components/modifier/condition_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(distance <= 1)
		if(malus > base_malus)
			. += SPAN_WARNING("\The [src] appears damaged.")

/obj/item/laser_components/modifier/degrade(var/increment = 1)
	if(increment)
		malus += increment
		if(malus > abs(base_malus*2))
			malus = abs(base_malus*2)

/obj/item/laser_components/modifier/repair_module(var/obj/item/weldingtool/W, var/skill_level, var/mob/user)
	if(!istype(W))
		return
	if(malus == base_malus)
		return 0
	if(W.use(1)) //Welders burn fuel while active
		handle_improvement(skill_level, user)
		malus = max(malus - 5, base_malus)
		return 1
	return 0

/obj/item/laser_components/capacitor
	name = "capacitor"
	desc = "A basic laser weapon capacitor."
	icon_state = "capacitor"
	shots = 5
	damage = 10
	reliability = 50
	fire_delay = 5
	repair_item = /obj/item/stack/cable_coil
	increasable_stats = list("reliability", "damage", "shots")
	decreaseable_stats = list()

/obj/item/laser_components/capacitor/condition_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(distance <= 1 && condition > 0)
		. += SPAN_WARNING("\The [src] appears damaged.")

/obj/item/laser_components/capacitor/repair_module(var/obj/item/stack/cable_coil/C, var/skill_level, var/mob/user)
	if(!istype(C))
		return
	if(!condition > 0)
		return 0
	if(C.use(2))
		handle_improvement(skill_level, user)
		condition = max(condition - 3 * skill_level, 0)
		return 1
	return 0

/obj/item/laser_components/capacitor/proc/small_fail(var/mob/living/user, var/obj/item/gun/energy/laser/prototype/prototype)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/active_hand = H.get_active_hand()
		var/shock_damage = round(damage * 0.25 *prototype.criticality) + rand(-5, 5)
		if(active_hand)
			H.electrocute_act(shock_damage, prototype, def_zone = BP_L_HAND, tesla_shock = 0)
			H.electrocute_act(shock_damage * 0.4, prototype, def_zone = BP_L_ARM, tesla_shock = 0) //Can arc past insulated gloves and into the arm.
		else
			H.electrocute_act(shock_damage, prototype, def_zone = BP_R_HAND, tesla_shock = 0)
			H.electrocute_act(shock_damage * 0.4, prototype, def_zone = BP_R_ARM, tesla_shock = 0)
	else
		tesla_zap(prototype, 0, 1000*prototype.criticality)
	return

/obj/item/laser_components/capacitor/proc/medium_fail(var/mob/living/user, var/obj/item/gun/energy/laser/prototype/prototype)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/active_hand = H.get_active_hand()
		var/shock_damage = round(damage * 0.5 *prototype.criticality) + rand(-5, 5)
		if(active_hand)
			H.electrocute_act(shock_damage, prototype, def_zone = BP_L_HAND, tesla_shock = 0)
			H.electrocute_act(shock_damage * 0.4, prototype, def_zone = BP_L_ARM, tesla_shock = 0) //Can arc past insulated gloves and into the arm.
		else
			H.electrocute_act(shock_damage, prototype, def_zone = BP_R_HAND, tesla_shock = 0)
			H.electrocute_act(shock_damage * 0.4, prototype, def_zone = BP_R_ARM, tesla_shock = 0)
	else
		tesla_zap(prototype, 0, 2000*prototype.criticality)
	return

/obj/item/laser_components/capacitor/proc/critical_fail(var/mob/living/user, var/obj/item/gun/energy/laser/prototype/prototype)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/active_hand = H.get_active_hand()
		var/shock_damage = round(damage * prototype.criticality) + rand(-5, 5)
		if(active_hand)
			H.electrocute_act(shock_damage, prototype, def_zone = BP_L_HAND, tesla_shock = 0)
			H.electrocute_act(shock_damage * 0.4, prototype, def_zone = BP_L_ARM, tesla_shock = 0) //Can arc past insulated gloves and into the arm.
		else
			H.electrocute_act(shock_damage, prototype, def_zone = BP_R_HAND, tesla_shock = 0)
			H.electrocute_act(shock_damage * 0.4, prototype, def_zone = BP_R_ARM, tesla_shock = 0)
	else
		tesla_zap(prototype, 0, 4000*prototype.criticality)
	return

/obj/item/laser_components/focusing_lens
	name = "focusing lens"
	desc = "A basic laser weapon focusing lens."
	icon_state = "lens"
	var/list/dispersion = list(2, 4, 6, 8, 10)
	accuracy = 1
	repair_item = /obj/item/stack/material/glass
	increasable_stats = list("reliability", "accuracy")
	decreaseable_stats = list()

/obj/item/laser_components/focusing_lens/condition_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(distance <= 1 && condition > 0)
		. += SPAN_WARNING("\The [src] appears damaged.")

/obj/item/laser_components/focusing_lens/repair_module(var/obj/item/stack/material/G, var/skill_level, var/mob/user)
	if(!istype(G))
		return
	if(!condition > 0)
		return 0
	if(G.use(1))
		handle_improvement(skill_level, user)
		condition = max(condition - 3 * skill_level, 0)
		return 1
	return 0

/obj/item/laser_components/modulator
	name = "laser modulator"
	desc = "A modification that modulates the beam into a standard laser beam."
	icon_state = "laser"
	origin_tech = list(TECH_COMBAT = 1, TECH_MAGNET = 2)
	var/obj/projectile/beam/projectile = /obj/projectile/beam
	var/firing_sound = 'sound/weapons/laser1.ogg'

/obj/item/laser_components/modulator/degrade()
	return

/obj/item/laser_assembly
	name = "laser assembly (small)"
	desc = "A case for shoving things into. Hopefully they work."
	icon = 'icons/obj/guns/modular_laser.dmi'
	var/base_icon_state = "small"
	contained_sprite = TRUE
	var/stage = 1
	var/size = CHASSIS_SMALL
	var/modifier_cap = 3

	var/list/gun_mods = list()
	var/obj/item/laser_components/capacitor/capacitor
	var/obj/item/laser_components/focusing_lens/focusing_lens
	var/obj/item/laser_components/modulator/modulator

	var/ready_to_craft = FALSE // Use by weapons analyzer.
	var/datum/weakref/analyzer

/obj/item/laser_assembly/Initialize()
	. = ..()
	update_icon()

/obj/item/laser_assembly/attackby(obj/item/attacking_item, mob/user)
	var/obj/item/laser_components/A = attacking_item
	var/success = FALSE
	if(!istype(A))
		return ..()

	var/skill_level = (GET_SKILL_LEVEL(user, FIREARMS_SKILL_COMPONENT) + GET_SKILL_LEVEL(user, RESEARCH_SKILL_COMPONENT))
	if(!ready_to_craft && skill_level < 5)
		to_chat(user, SPAN_WARNING("You cannot modify \the [src] by hand at your current skill level, you need to use a weapons analyzer."))
		return

	if(ismodifier(A) && gun_mods.len < modifier_cap)
		var/obj/item/laser_components/modifier/m = A
		for(var/v in gun_mods)
			var/obj/item/laser_components/modifier/M = v
			if(M.type == m.type)
				to_chat(user, SPAN_WARNING("\The [name] already has [m]."))
				return FALSE
		gun_mods += A
		user.drop_from_inventory(A,src)
		success = TRUE

	else if(islasercapacitor(A) && stage == 1)
		capacitor = A
		user.drop_from_inventory(A,src)
		stage = 2
		success = TRUE

	else if(isfocusinglens(A) && stage == 2)
		focusing_lens = A
		user.drop_from_inventory(A,src)
		stage = 3
		success = TRUE

	else if(ismodulator(A) && stage == 3)
		modulator = A
		user.drop_from_inventory(A,src)
		success = TRUE

	else
		return ..()
	to_chat(user, SPAN_NOTICE("You insert \the [A] into the assembly."))
	update_icon()
	if(check_completion())
		success = 2 // meaning complete

	return success

/obj/item/laser_assembly/update_icon()
	..()
	underlays.Cut()
	icon_state = "[base_icon_state]_[stage]"
	if(gun_mods.len)
		for(var/obj/item/laser_components/mod in gun_mods)
			if(mod.gun_overlay)
				underlays += mod.gun_overlay


/obj/item/laser_assembly/proc/check_completion()
	if(capacitor && focusing_lens && modulator)
		return finish()

/obj/item/laser_assembly/proc/finish()

	var/obj/structure/machinery/r_n_d/weapons_analyzer/an = analyzer ? analyzer.resolve() : null

	var/obj/item/gun/energy/laser/prototype/A = new /obj/item/gun/energy/laser/prototype
	A.icon_state = icon_state
	A.modifystate = icon_state
	A.origin_chassis = size
	A.capacitor = capacitor
	capacitor.forceMove(A)
	A.focusing_lens = focusing_lens
	focusing_lens.forceMove(A)
	A.modulator = modulator
	modulator.forceMove(A)
	if(gun_mods.len)
		for(var/v in gun_mods)
			var/obj/item/laser_components/modifier/mod = v
			A.gun_mods += mod
			mod.forceMove(A)
			if(mod.gun_overlay)
				A.underlays += mod.gun_overlay
	if(an)
		A.forceMove(an)
		an.item = A
	else
		A.forceMove(get_turf(src))
	A.updatetype()
	A.try_recharge()
	A.pin = null
	gun_mods = null
	focusing_lens = null
	capacitor = null
	qdel(src)
	return TRUE

/obj/item/laser_assembly/get_print_info()
	. = ""
	for(var/i in list(capacitor, focusing_lens, modulator) + gun_mods)
		var/obj/item/laser_components/l_component = i
		if(!l_component)
			continue

		. += "<br>Component Name: [initial(l_component.name)]</br><br>"
		var/l_repair_name = initial(l_component.repair_item.name) ? initial(l_component.repair_item.name) : "nothing"
		if(l_component.reliability != 0)
			. += "Reliability: [l_component.reliability]<br>"
		if(l_component.damage != 1)
			. += "Damage Modifier: [l_component.damage]<br>"
		if(l_component.fire_delay != 1)
			. += "Fire Delay Modifier: [l_component.fire_delay]<br>"
		if(l_component.shots != 1)
			. += "Shots Modifier: [l_component.shots]<br>"
		if(l_component.burst != 0)
			. += "Burst Modifier: [l_component.burst]<br>"
		if(l_component.accuracy != 0)
			. += "Accuracy Modifier: [l_component.accuracy]<br>"
		. += "Repair Tool: [l_repair_name]<br>"

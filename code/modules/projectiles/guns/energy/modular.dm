/obj/item/gun/energy/laser/prototype
	name = "laser prototype"
	desc = "A custom prototype laser weapon."
	icon = 'icons/obj/guns/modular_laser.dmi'
	icon_state = "large_3"
	item_state = "large_3"
	contained_sprite = TRUE
	has_icon_ratio = FALSE
	has_item_ratio = FALSE
	fire_sound = 'sound/weapons/laser1.ogg'
	slot_flags = SLOT_BELT|SLOT_BACK
	w_class = WEIGHT_CLASS_NORMAL
	force = 15
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	can_turret = TRUE
	zoomdevicename = null
	max_shots = 0
	burst_delay = 0
	pin = null
	var/origin_chassis
	var/gun_type
	var/list/gun_mods = list()
	var/obj/item/laser_components/capacitor/capacitor
	var/obj/item/laser_components/focusing_lens/focusing_lens
	var/obj/item/laser_components/modulator/modulator
	var/chargetime
	var/is_charging
	///All malfunction effects are multiplied by this value. It can be increased by some powerful mods and decreased by safety mods.
	var/criticality = 1 //multiplier for the negative effects of capacitor failures. Not just limited to critical failures.
	///This multiplies the malus of all components, above 1 the gun degrades faster, below 1 it degrades slower.
	var/fragility = 1
	///True if the gun has a custom name.
	var/named = 0
	///True if the gun has a custom description.
	var/described = 0
	///When the weapon is disasembled, this is distributed randomly among it's components. When a component with improvement potential is repaired, one appropriate variable gets better by up to improvement potential percent. The actual chance is based on skill level.
	var/improvement_potential = 0 //This is a percentage increase of a single variable on one component, a 100% increase is not a doubling of all stats, it is instead spread out across all components.

/obj/item/gun/energy/laser/prototype/mechanics_hints(mob/user, distance, is_adjacent)
	. = list()
	var/skill_level = (GET_SKILL_LEVEL(user, FIREARMS_SKILL_COMPONENT) + GET_SKILL_LEVEL(user, RESEARCH_SKILL_COMPONENT))
	switch(skill_level ? skill_level : 6)
		if(2)
			. += "Your complete lack of skill in firearms and research will hide all information about this weapon from you, you will also be unable to repair it decreasing its reliability."
		if(3)
			. += "Your low familiarity with firearms and research will hide most information about this weapon from you, you will also struggle to repair it without decreasing it's reliability."
		if(4)
			. += "Your combined familiarity with firearms and research will show you most information about this weapon, you will also be able to repair it without decreasing it's reliability, but are not likely to be able to improve it much."
		if(5)
			. += "Your combined training in firearms and research will show you all information about this weapon, you will also be able to repair it without decreasing it's reliability and have a chance to improve it when repairing."
			. += "It can be improved up to it's improvement potential, which is increased by firing it. Firing it at players increases it most rapidly, following by firing it at simple mobs, then firing it at objects."
		if(6 to INFINITY)
			. += "Your combined professional expertise in firearms and research will show you all information about this weapon, you will also be able to repair it without decreasing it's reliability, and have an excellent chance to improve it when repairing."
			. += "It can be improved up to it's improvement potential, which is increased by firing it. Firing it at players increases it most rapidly, following by firing it at simple mobs, then firing it at objects."

/obj/item/gun/energy/laser/prototype/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(distance > 1)
		return
	var/skill_level = (GET_SKILL_LEVEL(user, FIREARMS_SKILL_COMPONENT) + GET_SKILL_LEVEL(user, RESEARCH_SKILL_COMPONENT))

	if (capacitor.condition > 0 || focusing_lens.condition > 0 || modulator.condition > 0)
		switch(skill_level ? skill_level : 6)
			if (2 to 3) //At this level you can only tell that it's damaged, nothing else.
				. += SPAN_WARNING("It appears to be damaged.")
			if (4 to 5) //At this level you can tell when the weapon is damaged and if it could malfunction.
				if (reliability > 100)
					. += SPAN_NOTICE("It appears to be damaged.")
				else
					. += SPAN_WARNING("It appears to be damaged and could malfunction!")
			if (6 to INFINITY) //At this level you can estimate the weapon's reliability, but only if it's damaged. This won't help if you build a weapon that's inherently unreliable.
				if(improvement_potential > 2.5)
					. += SPAN_GOOD("You see a few places where damage has revealed design flaws. Correcting them could improve one of the weapon's components by up to [round(improvement_potential, 5)]%.")
				switch(reliability)
					if (0 to 65)
						. += SPAN_HIGHDANGER("It appears to be damaged and could go critical! You estimate it to be around [round(reliability, 5)]% reliable!")
					if (66 to 80)
						. += SPAN_DANGER("It appears to be damaged and could overload! You estimate it to be around [round(reliability, 5)]% reliable!")
					if (81 to 100)
						. += SPAN_WARNING("It appears to be damaged and could malfunction! You estimate it to be around [round(reliability, 5)]% reliable!")
					if (101 to INFINITY)
						. += SPAN_NOTICE("It appears to be damaged. You estimate it to be around [round(reliability, 5)]% reliable.")

	switch(skill_level ? skill_level : 6)
		if(2) //At this level you get no information about the weapon at all.
			. += "This weapon is completely incomprehensible to you. It seems to be some sort of energy weapon, but you can't make out any details about how it functions."
		if(3) //At this level you can only tell if the weapon has modifications or not, you can't make out what those modifications are.
			if(gun_mods.len)
				. += "This weapon is mostly incomprehensible to you. You can make out that it has some modifications, but the details of how they function are a mystery."
			if(capacitor)
				. += "You can see \a [capacitor] attached."
			if(focusing_lens)
				. += "You can see \a [focusing_lens] attached."
			if(modulator)
				. += "You can see \a [modulator] attached."
		if(4) //At this level you can identify all components and if they're damaged or not.
			if(gun_mods.len)
				for(var/obj/item/laser_components/modifier/modifier in gun_mods)
					. += "You can see \a [icon2html(modifier, user)][modifier] attached. [modifier.malus > modifier.base_malus ? SPAN_WARNING("It appears to be damaged.") : "It appears to be in good condition."]"
			if(capacitor)
				. += "You can see \a [icon2html(capacitor, user)][capacitor] attached. [capacitor.condition > 0 ? SPAN_WARNING("It appears to be damaged.") : "It appears to be in good condition."]"
			if(focusing_lens)
				. += "You can see \a [icon2html(focusing_lens, user)][focusing_lens] attached. [focusing_lens.condition > 0 ? SPAN_WARNING("It appears to be damaged.") : "It appears to be in good condition."]"
			if(modulator)
				. += "You can see \a [icon2html(modulator, user)][modulator] attached. [modulator.condition > 0 ? SPAN_WARNING("It appears to be damaged.") : "It appears to be in good condition."]"
		if(5) //At this level you can identify all parts and can estimate the health of the three components, but not the modifiers, or the improvement potential.
			if(gun_mods.len)
				for(var/obj/item/laser_components/modifier/modifier in gun_mods)
					. += "You can see \a [icon2html(modifier, user)][modifier] attached. [modifier.malus > modifier.base_malus ? SPAN_WARNING("It appears to be damaged.") : "It appears to be in good condition."]"
			if(capacitor)
				. += "You can see \a [icon2html(capacitor, user)][capacitor] attached. [capacitor.condition > 0 ? SPAN_WARNING("It appears to be [round(max(0, min(100, 100 - ((capacitor.condition / capacitor.reliability) * 100))))]% reliable.") : "It is good condition."]"
			if(focusing_lens)
				. += "You can see \a [icon2html(focusing_lens, user)][focusing_lens] attached. [focusing_lens.condition > 0 ? SPAN_WARNING("It appears to be [round(max(0, min(100, 100 - ((focusing_lens.condition / focusing_lens.reliability) * 100))))]% reliable.") : "It is good condition."]"
			if(modulator)
				. += "You can see \a [icon2html(modulator, user)][modulator] attached. [modulator.condition > 0 ? SPAN_WARNING("It appears to be [round(max(0, min(100, 100 - ((modulator.condition / modulator.reliability) * 100))))]% reliable.") : "It is good condition."]"
		if(6 to INFINITY) //At this level you get the health of the gun, all components and the improvement potential.
			if(gun_mods.len)
				for(var/obj/item/laser_components/modifier/modifier in gun_mods)
					. += "You can see \a [icon2html(modifier, user)][modifier] attached. [modifier.malus > modifier.base_malus ? SPAN_WARNING("It appears to be [round(max(0, min(100, 100 - (((modifier.malus - modifier.base_malus) / modifier.base_malus) * 100))))]% reliable.") : "It is good condition."]" //Base malus can be zero, modifiers with no base malus can't get damaged.
			if(capacitor)
				. += "You can see \a [icon2html(capacitor, user)][capacitor] attached. [capacitor.condition > 0 ? SPAN_WARNING("It appears to be [round(max(0, min(100, 100 - ((capacitor.condition / capacitor.reliability) * 100))))]% reliable.") : "It is good condition."]"
			if(focusing_lens)
				. += "You can see \a [icon2html(focusing_lens, user)][focusing_lens] attached. [focusing_lens.condition > 0 ? SPAN_WARNING("It appears to be [round(max(0, min(100, 100 - ((focusing_lens.condition / focusing_lens.reliability) * 100))))]% reliable.") : "It is good condition."]"
			if(modulator)
				. += "You can see \a [icon2html(modulator, user)][modulator] attached. [modulator.condition > 0 ? SPAN_WARNING("It appears to be [round(max(0, min(100, 100 - ((modulator.condition / modulator.reliability) * 100))))]% reliable.") : "It is good condition."]"

/obj/item/gun/energy/laser/prototype/attackby(obj/item/attacking_item, mob/user)
	var/skill_level = (GET_SKILL_LEVEL(user, FIREARMS_SKILL_COMPONENT) + GET_SKILL_LEVEL(user, RESEARCH_SKILL_COMPONENT))

	if(istype(attacking_item, /obj/item/stack/nanopaste)) //Nanopaste can be used for emergency repairs, but it's not ideal and will reduce the reliability of the gun.
		var/obj/item/stack/nanopaste/N = attacking_item

		if (skill_level ? skill_level : 6)
			to_chat(user, "You begin applying \the [N] to \the [src], repairing it in such a slapdash manner will damage it.")
			if(do_after(user, 12/skill_level SECONDS, src, DO_REPAIR_CONSTRUCT))
				repair_components(N, skill_level, user)

	//TODO: High skilled technicans can add mods to guns after final assembly, requires a rework of the weapon analyzer.
	//if(istype(attacking_item, /obj/item/laser_components/modifier))

	if(attacking_item.tool_behaviour != TOOL_SCREWDRIVER)
		return ..()
	to_chat(user, "You disassemble \the [src].")
	disassemble(user)

/obj/item/gun/energy/laser/prototype/proc/repair_components(var/obj/item/stack/nanopaste/N, var/skill_level, var/mob/user)
	if(capacitor && capacitor.condition > 0)
		if(N.use(1))
			capacitor.condition = max(0, capacitor.condition - 5 * skill_level)
			capacitor.reliability = max(0, capacitor.reliability - 12/skill_level) //Using nanopaste to repair the capacitor reduces its reliability, this is to represent the fact that it's a suboptimal repair job, and to prevent players from using nanopaste as a free repair method.
			to_chat(user, "You repair \the [capacitor]. The leftover nanopaste is gumming up the delicate component, reducing it's reliability.")
	else if(focusing_lens && focusing_lens.condition > 0)
		if(N.use(1))
			focusing_lens.condition = max(0, focusing_lens.condition - 5 * skill_level)
			focusing_lens.reliability = max(0, focusing_lens.reliability - 12/skill_level)
			to_chat(user, "You repair \the [focusing_lens]. The leftover nanopaste is obscuring the lens, reducing its reliability.")
	else if(modulator && modulator.condition > 0)
		if(N.use(1))
			modulator.condition = max(0, modulator.condition - 5 * skill_level)
			modulator.reliability = max(0, modulator.reliability - 12/skill_level)
			to_chat(user, "You repair \the [modulator]. The leftover nanopaste is blocking \the [modulator]'s emitters, reducing its reliability.")
	else
		to_chat(user, "There is nothing to repair on the gun!")

/obj/item/gun/energy/laser/prototype/handle_post_fire(mob/user, atom/target) //This handles the improvement potential gain from firing the weapon. The actual improvement is handled in repair of the individual compoents, this just determines how much improvement potential is gained.
	if(target)
		improvement_potential += (0.1 * IMPROVEMENT_MULTIPLIER) / (max(1, burst))  //100 shots to improve by 1%, you can only improve if your gun takes damage, so it will need many repair cycles for this to be significant.

		if (istype(target, /obj/machinery/portable_atmospherics/hydroponics))
			if (istype(modulator, /obj/item/laser_components/modulator/floramut) || istype(modulator, /obj/item/laser_components/modulator/floramut2))
				improvement_potential += (1  * IMPROVEMENT_MULTIPLIER) / (max(1, burst))
				return ..()

		if(target != user) //No improvement from shooting yourself.
			if(isliving(target))  //No improvement unless your target is a mob.
				var/mob/living/target_mob = target
				if(target_mob.stat != DEAD) //No improvement from shooting at dead things. Bring a doctor in to keep your target dummy alive. This also makes it harder to improve more powerful weapons, as you kill your target faster.
					if(ishuman(target_mob))
						var/mob/living/carbon/human/human_target = target
						if (istype(modulator, /obj/item/laser_components/modulator/taser))
							if (human_target.incapacitated()) //No benefit from tasing someone who's already incapacitated. Get the phramacist to make you oxycomorphine.
								return ..()
						if(human_target.get_species() == SPECIES_MONKEY)
							improvement_potential += (2  * IMPROVEMENT_MULTIPLIER) / (max(1, burst)) //Monkeys die easily, research only gets two boxes of monkey cubes without xenobiology.
							return ..()
						if(human_target.client)
							improvement_potential += (10  * IMPROVEMENT_MULTIPLIER) / (max(1, burst)) //10 seems like a lot, but this is a 20% improvement to 1 variable on 1 component. A 5 mod gun (8 total components), with an average of 3 improvable variables would need 120 shots on a player to max out.
							return ..()

					if(isslime(target_mob))
						if (istype(modulator, /obj/item/laser_components/modulator/freeze))
							improvement_potential += (2 * IMPROVEMENT_MULTIPLIER) / (max(1, burst))
							return ..()

					improvement_potential += (5 * IMPROVEMENT_MULTIPLIER) / (max(1, burst)) //Mechs, protohumans, and any other human mobs without a player.
	..()

/obj/item/gun/energy/laser/prototype/update_icon()
	..()
	underlays.Cut()
	if(length(gun_mods))
		for(var/obj/item/laser_components/mod in gun_mods)
			if(mod.gun_overlay)
				underlays += mod.gun_overlay
	underlays.Cut()
	for(var/v in gun_mods)
		var/obj/item/laser_components/modifier/mod = v
		if(mod.gun_overlay)
			underlays += mod.gun_overlay

/obj/item/gun/energy/laser/prototype/proc/reset_vars()
	burst = initial(burst)
	reliability = initial(reliability)
	burst_delay = initial(burst_delay)
	max_shots = initial(max_shots)
	charge_cost = initial(charge_cost)
	chargetime = initial(chargetime)
	fire_delay = initial(fire_delay)
	fire_delay_wielded = initial(fire_delay_wielded)
	accuracy = initial(accuracy)
	criticality = initial(criticality)
	fragility = initial(fragility)
	fire_sound = initial(fire_sound)
	force = initial(force)
	is_wieldable = initial(is_wieldable)
	action_button_name = initial(action_button_name)


/obj/item/gun/energy/laser/prototype/proc/delayed_overload(var/mob/user)
	if(capacitor.reliability - capacitor.condition > 0)
		to_chat(user, SPAN_DANGER("\The [src.capacitor] stops overloading, you fixed it just in time."))
	else
		if(prob(50 * criticality))
			critical_fail(user)
		else if(prob(75 * criticality))
			medium_fail(user)
		else
			small_fail(user)
	qdel(capacitor)
	capacitor = null
	disassemble(user)

/obj/item/gun/energy/laser/prototype/proc/updatetype(var/mob/user)
	reset_vars() //Reset the gun to its initial values, then recalculate all stats based on the current state of components and mods.

	if(!focusing_lens || !capacitor || !modulator)
		return

	update_chassis()

	reliability = (capacitor.reliability - capacitor.condition) + (focusing_lens.reliability - focusing_lens.condition)

	if(modulator.projectile)
		projectile_type = modulator.projectile

	fire_delay = capacitor.fire_delay
	max_shots = round(capacitor.shots)
	dispersion = focusing_lens.dispersion
	accuracy = focusing_lens.accuracy
	burst += round(focusing_lens.burst)
	fire_sound = modulator.firing_sound
	fragility = capacitor.malus_multiplier

	if(gun_mods.len)
		handle_mod()

	if(capacitor.reliability - capacitor.condition <= 0) //The gun explodes if it's capacitor reaches 0 reliability.
		var/overload_delay = 3/criticality
		var/skill_level = (GET_SKILL_LEVEL(user, FIREARMS_SKILL_COMPONENT) + GET_SKILL_LEVEL(user, RESEARCH_SKILL_COMPONENT))
		switch(skill_level ? skill_level : 6)
			if(2 to 3)
				to_chat(user, SPAN_HIGHDANGER("\The [src] hisses ominously!"))
			if(4 to 5)
				overload_delay *= 1.5
				to_chat(user, SPAN_HIGHDANGER("\The [src] hisses ominously as \the [capacitor]'s housing begins to fail, you release the trigger but it's too late! Get rid of it!"))
			if(6 to INFINITY)
				overload_delay *= 2
				to_chat(user, SPAN_HIGHDANGER("You instantly release the trigger as \the [capacitor]'s housing begins to fail! You have less than [round(overload_delay)] seconds to repair \the [src] or throw it away!"))

		addtimer(CALLBACK(src, PROC_REF(delayed_overload)), overload_delay SECONDS, TIMER_STOPPABLE|TIMER_DELETE_ME)
		animate(src, overload_delay SECONDS + rand(-5, 5), -1, LINEAR_EASING, color = COLOR_RED)
		return

	if(focusing_lens.reliability - focusing_lens.condition <= 0)
		to_chat(user, SPAN_DANGER("\The [src]'s focusing lens shatters with a loud crack!"))
		qdel(focusing_lens)
		focusing_lens = null

	power_supply.maxcharge = max_shots*charge_cost
	charge_cost /= max(1, (burst - 1))
	fire_delay_wielded = fire_delay * 0.75
	accuracy_wielded = accuracy + abs(accuracy)/2
	scoped_accuracy = accuracy_wielded + abs(accuracy)
	w_class = gun_type
	reliability = max(reliability, 1)

/obj/item/gun/energy/laser/prototype/proc/update_chassis()
	switch(origin_chassis)
		if(CHASSIS_SMALL)
			gun_type = CHASSIS_SMALL
			slot_flags = SLOT_BELT | SLOT_HOLSTER
			item_state = "small_3"
		if(CHASSIS_MEDIUM)
			gun_type = CHASSIS_MEDIUM
			slot_flags = SLOT_BELT | SLOT_BACK
			item_state = "medium_3"
			is_wieldable = TRUE
		if(CHASSIS_LARGE)
			gun_type = CHASSIS_LARGE
			slot_flags = SLOT_BACK
			item_state = "large_3"
			is_wieldable = TRUE
			one_hand_fa_penalty = 12

/obj/item/gun/energy/laser/prototype/proc/handle_mod()
	for(var/obj/item/laser_components/modifier/modifier in gun_mods)
		switch(modifier.mod_type)
			if(MOD_SILENCE)
				suppressed = TRUE
			if(MOD_NUCLEAR_CHARGE)
				self_recharge = TRUE
		fire_delay *= modifier.fire_delay
		reliability += modifier.reliability
		burst += modifier.burst
		burst_delay += modifier.burst_delay
		max_shots *= modifier.shots //We want to add all the shot multipliers together, then apply them all at once.
		force = min(force + modifier.gun_force, 40)
		chargetime += modifier.chargetime SECONDS
		accuracy += modifier.accuracy
		criticality *= modifier.criticality
		fragility *= modifier.malus_multiplier
		if(modifier.scope_name)
			zoomdevicename = modifier.scope_name

/obj/item/gun/energy/laser/prototype/consume_next_projectile(var/mob/user, var/bypass_degrade = FALSE)
	if(!power_supply)
		return null
	if(!ispath(projectile_type))
		return null
	if(!power_supply.checked_use(charge_cost))
		return null
	if(!capacitor || capacitor.condition >= capacitor.reliability)
		return null
	if (self_recharge)
		addtimer(CALLBACK(src, PROC_REF(try_recharge)), recharge_time * 2 SECONDS, TIMER_UNIQUE)
	var/obj/projectile/beam/A = new projectile_type(src)
	A.damage = capacitor.damage
	var/damage_coeff = 1
	for(var/obj/item/laser_components/modifier/modifier in gun_mods)
		damage_coeff *= modifier.damage

	if(!bypass_degrade)
		for(var/obj/item/laser_components/modifier/modifier in gun_mods) //This repeats for EVERY MOD, fail chance goes up quadratically with the number of mods
			if(prob(max(1,(gun_mods.len * 2 * damage_coeff)/(max(1,(burst))))))
				capacitor.degrade(modifier.malus * fragility)
			if(prob(max(1,(gun_mods.len * damage_coeff)/(max(1,(burst))))))
				focusing_lens.degrade(modifier.malus * fragility)
			if(prob(max(1,(5 + capacitor.condition)/(max(1,(burst)))))) //Firing a gun with a damaged capacitor risks arcing to other components, damaging them
				modifier.degrade(0.2 * fragility)

	if(burst > 1)
		A.damage = A.damage/(max(1, burst - 1)) //Damage is divided by the number of shots
	damage_coeff *= modulator.damage
	A.damage *= damage_coeff
	A.damage = min(A.damage, 60) //Caps the maximum damage one shot can do, this matches the laser cannon

	updatetype(ismob(loc) ? loc : null)
	return A

/obj/item/gun/energy/laser/prototype/proc/disassemble(var/mob/user)
	var/atom/A = get_turf(src)
	if(!A)
		return

	var/list/damaged_components = list()

	if(capacitor && capacitor.condition > 0)
		damaged_components += capacitor
	if(focusing_lens && focusing_lens.condition > 0)
		damaged_components += focusing_lens
	if(modulator && modulator.condition > 0)
		damaged_components += modulator
	for(var/obj/item/laser_components/modifier/modifier in gun_mods)
		if(modifier.malus > modifier.base_malus)
			damaged_components += modifier

	while(improvement_potential > 0 && damaged_components.len)
		var/list/upgradable_components = list()
		for(var/obj/item/laser_components/component in damaged_components)
			if(component.total_improved < IMPROVEMENT_CAP)
				upgradable_components += component

		if(!upgradable_components.len)
			to_chat(user, SPAN_WARNING("There's nothing to improve on the components of this gun."))
			break

		var/obj/item/laser_components/selected_component = pick(upgradable_components)
		var/potential_to_components = min(rand(0, improvement_potential), 30) //Sends up a random amount up to 30 improvement points to the component.

		if(potential_to_components)
			selected_component.improvement_potential += potential_to_components
			improvement_potential -= potential_to_components

	// Drop all components to the ground
	for(var/obj/item/laser_components/modifier/modifier in gun_mods)
		modifier.forceMove(A)
		gun_mods.Remove(modifier)

	if(capacitor)
		capacitor.forceMove(A)
		capacitor = null
	if(focusing_lens)
		focusing_lens.forceMove(A)
		focusing_lens = null
	if(modulator)
		modulator.forceMove(A)
		modulator = null
	if(pin)
		pin.forceMove(A)
		pin.gun = null
		pin = null
	switch(origin_chassis)
		if(CHASSIS_SMALL)
			new /obj/item/laser_assembly(A)
		if(CHASSIS_MEDIUM)
			new /obj/item/laser_assembly/medium(A)
		if(CHASSIS_LARGE)
			new /obj/item/laser_assembly/large(A)
	qdel(src)

/obj/item/gun/energy/laser/prototype/small_fail(var/mob/user)
	if(capacitor)
		capacitor.small_fail(user, src)
	return

/obj/item/gun/energy/laser/prototype/medium_fail(var/mob/user)
	if(capacitor)
		capacitor.medium_fail(user, src)
	return

/obj/item/gun/energy/laser/prototype/critical_fail(var/mob/user)
	if(capacitor)
		capacitor.critical_fail(user, src)
	return

/obj/item/gun/energy/laser/prototype/can_wield()
	if(origin_chassis >= CHASSIS_MEDIUM)
		return 1
	else
		return 0

/obj/item/gun/energy/laser/prototype/ui_action_click()
	if(src in usr)
		toggle_wield(usr)

/obj/item/gun/energy/laser/prototype/verb/scope()
	set category = "Object.Held"
	set name = "Use Scope"
	set src in usr

	if(zoomdevicename)
		if(wielded)
			toggle_scope(2.0, usr)
		else
			to_chat(usr, SPAN_WARNING("You can't look through the scope without stabilizing the rifle!"))
	else
		to_chat(usr, SPAN_WARNING("This device does not have a scope installed!"))

/obj/item/gun/energy/laser/prototype/special_check(var/mob/user)
	if(is_charging && chargetime)
		to_chat(user, SPAN_DANGER("\The [src] is already charging!"))
		return 0
	if(chargetime)
		user.visible_message(
						SPAN_DANGER("\The [user] begins charging the [src]!"),
						SPAN_DANGER("You begin charging the [src]!"),
						SPAN_DANGER("You hear a low pulsing roar!")
						)
		is_charging = 1

		if(!do_after(user, chargetime))
			is_charging = 0
			return 0

		is_charging = 0

	if(!istype(user.get_active_hand(), src))
		return 0

	return ..()

/obj/item/gun/energy/laser/prototype/verb/rename_gun()
	set name = "Name Prototype"
	set category = "Object.Held"
	set desc = "Name your invention so that its glory might be eternal"
	set src in usr

	var/mob/M = usr
	if(!M.mind)
		return 0

	var/input = sanitizeSafe(input("What do you want to name the gun?", ,""), MAX_NAME_LEN)

	if(src && input && !M.stat && in_range(M,src))
		name = input
		to_chat(M, "You name the gun [input]. Say hello to your new friend.")
		named = 1
		return 1

/obj/item/gun/energy/laser/prototype/verb/describe_gun()
	set name = "Describe Prototype"
	set category = "Object.Held"
	set desc = "Describe your invention so that its glory might be eternal"
	set src in usr

	var/mob/M = usr
	if(!M.mind)
		return 0

	var/input = sanitizeSafe(input("What do you want to name the gun?", ,""))

	if(src && input && !M.stat && in_range(M,src))
		desc = input
		to_chat(M, "You describe the gun as [input]. Say hello to your new friend.")
		described = 1
		return 1

/obj/item/gun/energy/laser/prototype/get_print_info()
	. = ..(FALSE)

	for(var/i in list(capacitor, focusing_lens, modulator) + gun_mods)
		var/obj/item/laser_components/l_component = i

		. += "<br>Component Name: [initial(l_component.name)]</br><br>"
		var/l_repair_name = initial(l_component.repair_item.name) ? initial(l_component.repair_item.name) : "nothing"
		if(l_component.reliability != 0)
			. += "Reliability: [round(l_component.reliability, 1)]<br>"
		if(l_component.damage != 1)
			. += "Damage Modifier: [round(l_component.damage, 0.1)]<br>"
		if(l_component.fire_delay != 1)
			. += "Fire Delay Modifier: [round(l_component.fire_delay, 0.1)]<br>"
		if(l_component.shots != 1)
			. += "Shots Modifier: [round(l_component.shots, 0.1)]<br>"
		if(l_component.burst != 0)
			. += "Burst Modifier: [round(l_component.burst, 1)]<br>"
		if(l_component.accuracy != 0)
			. += "Accuracy Modifier: [round(l_component.accuracy, 0.1)]<br>"
		. += "Repair Tool: [l_repair_name]<br>"

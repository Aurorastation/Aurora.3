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
	var/criticality = 1 //multiplier for the negative effects of capacitor failures. Not just limited to critical failures.
	var/named = 0
	var/described = 0
	///When the weapon is disasembled, this is distributed randomly among it's components. When a component with improvement potential is repaired, it gets better by up to improvement potential percent. The actual chance is based on skill level.
	var/improvement_potential = 0

/obj/item/gun/energy/laser/prototype/mechanics_hints(mob/user, distance, is_adjacent)
	. = list()
	var/skill_level = (GET_SKILL_LEVEL(user, FIREARMS_SKILL_COMPONENT) + GET_SKILL_LEVEL(user, RESEARCH_SKILL_COMPONENT))
	switch(skill_level ? skill_level : 5)
		if(2)
			. += "Your complete lack of skill in firearms and research will hide all information about this weapon from you, you will also be unable to repair it."
		if(3)
			. += "Your low familiarity with firearms and research will hide most information about this weapon from you, you will also struggle to repair it without decreasing it's reliability."
		if(4)
			. += "Your combined familiarity with firearms and research will show you most information about this weapon, you will also be able to repair it without decreasing it's reliability, but are not likely to be able to improve it."
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
		switch(skill_level ? skill_level : 5)
			if (2 to 3) //At this level you can only tell that it's damaged, nothing else.
				. += SPAN_WARNING("It appears to be damaged.")
			if (4 to 5) //At this level you can tell when the weapon is damaged and if it could malfunction.
				if (reliability > 100)
					. += SPAN_WARNING("It appears to be damaged.")
				else
					. += SPAN_DANGER("It appears to be damaged and could malfunction!")
			if (6 to INFINITY) //At this level you can estimate the weapon's reliability, but only if it's damaged. This won't help if you build a weapon that's inherently unreliable.
				switch(reliability)
					if (0 to 65)
						. += SPAN_HIGHDANGER("It appears to be damaged and could go critical! You estimate it to be around [reliability]% reliable!")
					if (66 to 80)
						. += SPAN_DANGER("It appears to be damaged and could overload! You estimate it to be around [reliability]% reliable!")
					if (81 to 100)
						. += SPAN_DANGER("It appears to be damaged and could malfunction! You estimate it to be around [reliability]% reliable!")
					if (101 to INFINITY)
						. += SPAN_WARNING("It appears to be damaged. You estimate it to be around [reliability]% reliable.")

	switch(skill_level ? skill_level : 5)
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
			if(improvement_potential > 0)
				. += SPAN_GOOD("You see a few places where damage has revealed design flaws. Correcting them could improve the weapon by up to [improvement_potential]%.")

/obj/item/gun/energy/laser/prototype/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.tool_behaviour != TOOL_SCREWDRIVER)
		return ..()
	to_chat(user, "You disassemble \the [src].")
	disassemble(user)

/obj/item/gun/energy/laser/attack(mob/living/target_mob, mob/living/user, target_zone)
if(target_mob)
	if(target_mob != user)

		if(isliving(target_mob))
			improvement_potential += 1

			if(ishuman(target_mob))
				improvement_potential += 1


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
	fire_sound = initial(fire_sound)
	force = initial(force)
	is_wieldable = initial(is_wieldable)
	action_button_name = initial(action_button_name)

/obj/item/gun/energy/laser/prototype/proc/updatetype(var/mob/user)
	reset_vars()
	if(!focusing_lens || !capacitor || !modulator)
		disassemble(user)
		return

	update_chassis()
	//TODO: When the skill system test is merged, rework this to give high skills a chance to avoid the failure.
	// if(capacitor.reliability - capacitor.condition <= 0)
	// 	if(prob(66))
	// 		capacitor.small_fail(user)
	// 	else
	// 		capacitor.medium_fail(user)
	// 	qdel(capacitor)
	// 	capacitor = null

	// if(focusing_lens.reliability - focusing_lens.condition <= 0)
	// 	qdel(focusing_lens)
	// 	focusing_lens = null

	reliability = (capacitor.reliability - capacitor.condition) + (focusing_lens.reliability - focusing_lens.condition)

	if(modulator.projectile)
		projectile_type = modulator.projectile

	fire_delay = capacitor.fire_delay
	max_shots = capacitor.shots

	dispersion = focusing_lens.dispersion
	accuracy = focusing_lens.accuracy
	burst += focusing_lens.burst
	fire_sound = modulator.firing_sound

	if(gun_mods.len)
		handle_mod()

	power_supply.maxcharge = max_shots*charge_cost
	charge_cost /= max(1, (burst - 1))
	fire_delay_wielded = fire_delay * 0.75
	accuracy_wielded = accuracy + accuracy/4
	scoped_accuracy = accuracy_wielded + accuracy/4
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

/obj/item/gun/energy/laser/prototype/proc/handle_mod()
	for(var/obj/item/laser_components/modifier/modifier in gun_mods)
		switch(modifier.mod_type)
			if(MOD_SILENCE)
				suppressed = TRUE
			if(MOD_NUCLEAR_CHARGE)
				self_recharge = TRUE
				criticality *= 2
		fire_delay *= modifier.fire_delay
		reliability += modifier.reliability
		burst += modifier.burst
		burst_delay += modifier.burst_delay
		max_shots *= modifier.shots
		force = min(force + modifier.gun_force, 40)
		chargetime += modifier.chargetime*10
		accuracy += modifier.accuracy
		criticality *= modifier.criticality
		if(modifier.scope_name)
			zoomdevicename = modifier.scope_name

/obj/item/gun/energy/laser/prototype/consume_next_projectile(var/mob/user, var/bypass_degrade = FALSE)
	if(!power_supply)
		return null
	if(!ispath(projectile_type))
		return null
	if(!power_supply.checked_use(charge_cost))
		return null
	if(!capacitor)
		return null
	if (self_recharge)
		addtimer(CALLBACK(src, PROC_REF(try_recharge)), recharge_time * 2 SECONDS, TIMER_UNIQUE)
	var/obj/projectile/beam/A = new projectile_type(src)
	A.damage = capacitor.damage
	var/damage_coeff = 1
	for(var/obj/item/laser_components/modifier/modifier in gun_mods)
		damage_coeff *= modifier.damage
	if(burst > 1)
		A.damage = A.damage/(max(1, burst - 1)) //Damage is divided by the number of shots
	damage_coeff *= modulator.damage
	A.damage *= damage_coeff
	A.damage = min(A.damage, 60) //Caps the maximum damage one shot can do, this matches the laser cannon
	if(!bypass_degrade)
		for(var/obj/item/laser_components/modifier/modifier in gun_mods) //This repeats for EVERY MOD, fail chance goes up quadratically with the number of mods
			if(prob((gun_mods.len * damage_coeff)/(max(1,(burst)))))
				capacitor.degrade(modifier.malus)
			if(prob((gun_mods.len * damage_coeff)/(max(1,(burst)))))
				focusing_lens.degrade(modifier.malus)
			if(prob((5 + capacitor.damage)/(max(1,(burst))))) //Firing a gun with a damaged capacitor risks arcing to other components, damaging them
				modifier.degrade(0.2)

	updatetype(ismob(loc) ? loc : null)
	return A

/obj/item/gun/energy/laser/prototype/proc/disassemble(var/mob/user)
	var/atom/A = get_turf(src)
	if(!A)
		return
	var/potential_to_components
	if(gun_mods.len)
		for(var/obj/item/laser_components/modifier/modifier in gun_mods)
			if(modifier.malus > modifier.base_malus)
				potential_to_components = rand(0, improvement_potential)
				if(potential_to_components)
					modifier.improvement_potential += potential_to_components
					improvement_potential -= potential_to_components
			modifier.forceMove(A)
			gun_mods.Remove(modifier)
	if(capacitor)
		if(capacitor.condition > 0)
			potential_to_components = rand(0, improvement_potential)
			if(potential_to_components)
				capacitor.improvement_potential += potential_to_components
				improvement_potential -= potential_to_components
		capacitor.forceMove(A)
		capacitor = null
	if(focusing_lens)
		if(focusing_lens.condition > 0)
			potential_to_components = rand(0, improvement_potential)
			if(potential_to_components)
				focusing_lens.improvement_potential += potential_to_components
				improvement_potential -= potential_to_components
		focusing_lens.forceMove(A)
		focusing_lens = null
	if(modulator)
		if(improvement_potential)
			modulator.improvement_potential += improvement_potential
			improvement_potential = 0
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
		to_chat(user, SPAN_DANGER("\The [src]'s [capacitor] short-circuits!"))
		visible_message(SPAN_DANGER("Sparks fly from \the [src] as it short-circuits!"), range = 6)
		capacitor.small_fail(user, src)
	return

/obj/item/gun/energy/laser/prototype/medium_fail(var/mob/user)
	if(capacitor)
		to_chat(user, SPAN_DANGER("\The [src]'s [capacitor] overloads!"))
		capacitor.medium_fail(user, src)
	return

/obj/item/gun/energy/laser/prototype/critical_fail(var/mob/user)
	if(capacitor)
		to_chat(user, SPAN_DANGER("\The [src]'s [capacitor] goes critical!"))
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
	if(!wielded && (origin_chassis == CHASSIS_LARGE))
		to_chat(user, SPAN_DANGER("You require both hands to fire this weapon!"))
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
		. += "Reliability: [initial(l_component.reliability)]<br>"
		. += "Damage Modifier: [initial(l_component.damage)]<br>"
		. += "Fire Delay Modifier: [initial(l_component.fire_delay)]<br>"
		. += "Shots Modifier: [initial(l_component.shots)]<br>"
		. += "Burst Modifier: [initial(l_component.burst)]<br>"
		. += "Accuracy Modifier: [initial(l_component.accuracy)]<br>"
		. += "Repair Tool: [l_repair_name]<br>"

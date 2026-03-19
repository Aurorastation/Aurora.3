/obj/item/modular_computer/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(is_adjacent)
		. += FONT_SMALL(SPAN_NOTICE("It contains the following hardware:"))
		for(var/obj/CH in get_all_components())
			. += FONT_SMALL(SPAN_NOTICE(" - [capitalize_first_letters(CH.name)]"))
	if(health <= broken_damage)
		. += SPAN_DANGER("It is heavily damaged!")
	else if(health <= maxhealth)
		. += SPAN_WARNING("It is damaged.")

/obj/item/modular_computer/add_damage(damage, damage_flags, damage_type, armor_penetration, obj/weapon)
	. = ..()
	var/component_probability = 0
	switch(damage_type)
		if(DAMAGE_BRUTE)
			component_probability = damage / 2
		if(DAMAGE_BURN)
			component_probability = damage / 1.5

	if(component_probability)
		for(var/obj/item/computer_hardware/H in get_all_components())
			if(prob(component_probability))
				H.take_damage(round(damage / 2))

	update_icon()

/obj/item/modular_computer/on_death()
	visible_message(SPAN_WARNING("\The [src] breaks apart!"))
	new /obj/item/stack/material/steel(get_turf(src), round(steel_sheet_cost/2))
	for(var/obj/item/computer_hardware/H in get_all_components())
		uninstall_component(null, H)
		H.forceMove(get_turf(src))
		if(prob(25))
			H.take_damage(rand(10, 30))
	. = ..()

// Stronger explosions cause serious damage to internal components
// Minor explosions are mostly mitigitated by casing.
/obj/item/modular_computer/ex_act(var/severity)
	add_damage(rand(125, 200) / severity, 30 / severity)

// EMPs are similar to explosions, but don't cause physical damage to the casing. Instead they screw up the components
/obj/item/modular_computer/emp_act(severity)
	. = ..()

	add_damage(rand(100, 200) / severity, 50 / severity)

// "Stun" weapons can cause minor damage to components (short-circuits?)
// "Burn" damage is equally strong against internal components and exterior casing
// "Brute" damage mostly damages the casing.
/obj/item/modular_computer/bullet_act(obj/projectile/hitting_projectile, def_zone, piercing_hit)
	. = ..()
	if(. != BULLET_ACT_HIT)
		return .

	add_damage(hitting_projectile, hitting_projectile.damage_flags(), hitting_projectile.damage_type, hitting_projectile.armor_penetration)

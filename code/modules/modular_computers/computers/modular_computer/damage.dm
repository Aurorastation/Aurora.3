/obj/item/modular_computer/examine(mob/user, distance, is_adjacent)
	. = ..()
	if(is_adjacent)
		to_chat(user, FONT_SMALL(SPAN_NOTICE("It contains the following hardware:")))
		for(var/obj/CH in get_all_components())
			to_chat(user, FONT_SMALL(SPAN_NOTICE(" - [capitalize_first_letters(CH.name)]")))
	if(damage > broken_damage)
		to_chat(user, SPAN_DANGER("It is heavily damaged!"))
	else if(damage)
		to_chat(user, SPAN_WARNING("It is damaged."))

/obj/item/modular_computer/proc/break_apart(msg = TRUE)
	if(msg)
		visible_message(SPAN_WARNING("\The [src] breaks apart!"))
	new /obj/item/stack/material/steel(get_turf(src), round(steel_sheet_cost/2))
	for(var/obj/item/computer_hardware/H in get_all_components())
		uninstall_component(null, H)
		H.forceMove(get_turf(src))
		if(prob(25))
			H.take_damage(rand(10, 30))
	qdel(src)

/obj/item/modular_computer/proc/take_damage(var/amount, var/component_probability, var/damage_casing = TRUE, var/randomize = TRUE, msg=TRUE)
	if(randomize)
		// 75%-125%, rand() works with integers, apparently.
		amount *= (rand(75, 125) / 100.0)
	amount = round(amount)
	if(damage_casing)
		damage += amount
		damage = between(0, damage, max_damage)

	if(component_probability)
		for(var/obj/item/computer_hardware/H in get_all_components())
			if(prob(component_probability))
				H.take_damage(round(amount / 2))

	if(damage >= max_damage)
		break_apart(msg)
	update_icon()

// Stronger explosions cause serious damage to internal components
// Minor explosions are mostly mitigitated by casing.
/obj/item/modular_computer/ex_act(var/severity)
	take_damage(rand(125, 200) / severity, 30 / severity, msg = FALSE)

// EMPs are similar to explosions, but don't cause physical damage to the casing. Instead they screw up the components
/obj/item/modular_computer/emp_act(severity)
	. = ..()

	take_damage(rand(100, 200) / severity, 50 / severity, FALSE)

// "Stun" weapons can cause minor damage to components (short-circuits?)
// "Burn" damage is equally strong against internal components and exterior casing
// "Brute" damage mostly damages the casing.
/obj/item/modular_computer/bullet_act(var/obj/item/projectile/Proj)
	switch(Proj.damage_type)
		if(DAMAGE_BRUTE)
			take_damage(Proj.damage, Proj.damage / 2)
		if(DAMAGE_PAIN)
			take_damage(Proj.damage, Proj.damage / 3, 0)
		if(DAMAGE_BURN)
			take_damage(Proj.damage, Proj.damage / 1.5)

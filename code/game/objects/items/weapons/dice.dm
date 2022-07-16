/obj/item/stack/dice
	name = "d6"
	desc = "A dice with six sides."
	icon = 'icons/obj/dice.dmi'
	icon_state = "d66"
	w_class = ITEMSIZE_TINY
	attack_verb = list("diced")
	max_amount = 6

	base_icon = "d6"
	var/side_mult = 1 // Used for d100s.
	var/sides = 6
	var/weight_roll = 0 // chance of the dice falling on its favored number
	var/favored_number = 1 //related to the var above

/obj/item/stack/dice/Initialize()
	. = ..()
	icon_state = "[base_icon][rand(1,sides)]"

/obj/item/stack/dice/update_icon(var/result)
	check_maptext(SMALL_FONTS(7, get_amount()))
	if(result)
		icon_state = "[base_icon][result]"

/obj/item/stack/dice/attack_self(mob/user)
	if(amount > 1)
		user.visible_message("<b>[user]</b> shakes the die in their hand...", SPAN_NOTICE("You shake the die in your hands..."))
	else
		user.visible_message("<b>[user]</b> raises the dice to their mouth and blows on it...", SPAN_NOTICE("You raise the dice to your mouth and blow on it..."))

/obj/item/stack/dice/throw_impact(atom/hit_atom)
	..()

	var/total_result = 0
	var/list/results = list()
	for(var/i = 1 to amount)
		if(weight_roll && prob(weight_roll))
			results += favored_number
		else
			results += rand(1, sides)
		total_result += results[i]

	if(amount > 1)
		visible_message(SPAN_NOTICE("The die rolls, revealing... <b>[total_result * side_mult]</b>! ([english_list(results, "", " + ", " + ", "")])"))
		update_icon(results[length(results)])
	else
		visible_message(SPAN_NOTICE("\The [name] lands on <b>[total_result * side_mult]</b>.[get_comment(total_result)]"))
		update_icon(total_result)

/obj/item/stack/dice/proc/get_comment(var/result)
	if(sides == result)
		return " Nat [sides * side_mult]!"
	if(result == 1)
		return " Ouch, bad luck."
	return ""

/obj/item/stack/dice/d4
	name = "d4"
	desc = "A dice with four sides."
	icon_state = "d44"
	sides = 4
	base_icon = "d4"

/obj/item/stack/dice/d8
	name = "d8"
	desc = "A dice with eight sides."
	icon_state = "d88"
	sides = 8
	base_icon = "d8"

/obj/item/stack/dice/d10
	name = "d10"
	desc = "A dice with ten sides."
	icon_state = "d1010"
	sides = 10
	base_icon = "d10"

/obj/item/stack/dice/d12
	name = "d12"
	desc = "A dice with twelve sides."
	icon_state = "d1212"
	sides = 12
	base_icon = "d12"

/obj/item/stack/dice/d20
	name = "d20"
	desc = "A dice with twenty sides."
	icon_state = "d2020"
	sides = 20
	base_icon = "d20"

/obj/item/stack/dice/d100
	name = "d100"
	desc = "A dice with ten sides. This one is for the tens digit."
	icon_state = "d10010"
	sides = 10
	side_mult = 10
	base_icon = "d100"

/obj/item/dice
	name = "d6"
	desc = "A dice with six sides."
	icon = 'icons/obj/dice.dmi'
	icon_state = "d66"
	w_class = 1
	var/side_mult = 1 // Used for d100s.
	var/sides = 6
	var/weighted = FALSE //if this dice can cheat or something
	var/favored_number = 1 //related to the var above
	var/weighted_value = 70 //what is the chance of falling on the favored number
	attack_verb = list("diced")

/obj/item/dice/New()
	icon_state = "[name][rand(1,sides)]"

/obj/item/dice/throw_impact(atom/hit_atom)
	..()
	var/result
	if((weighted) && (prob(weighted_value)))
		result = favored_number
	else
		result = rand(1, sides)

	var/comment = ""
	if(sides == 20 && result == 20)
		comment = "Nat 20!"
	else if(sides == 20 && result == 1)
		comment = "Ouch, bad luck."
	icon_state = "[name][result]"
	src.visible_message("<span class='notice'>\The [name] lands on [result * side_mult]. [comment]</span>")

/obj/item/dice/d4
	name = "d4"
	desc = "A dice with four sides."
	icon_state = "d44"
	sides = 4

/obj/item/dice/d8
	name = "d8"
	desc = "A dice with eight sides."
	icon_state = "d88"
	sides = 8

/obj/item/dice/d10
	name = "d10"
	desc = "A dice with ten sides."
	icon_state = "d1010"
	sides = 10

/obj/item/dice/d12
	name = "d12"
	desc = "A dice with twelve sides."
	icon_state = "d1212"
	sides = 12

/obj/item/dice/d20
	name = "d20"
	desc = "A dice with twenty sides."
	icon_state = "d2020"
	sides = 20

/obj/item/dice/d100
	name = "d100"
	desc = "A dice with ten sides. This one is for the tens digit."
	icon_state = "d10010"
	sides = 10
	side_mult = 10
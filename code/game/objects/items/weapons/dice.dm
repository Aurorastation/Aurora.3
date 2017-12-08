	name = "d6"
	desc = "A dice with six sides."
	icon = 'icons/obj/dice.dmi'
	icon_state = "d66"
	w_class = 1
	var/sides = 6
	attack_verb = list("diced")

	icon_state = "[name][rand(1,sides)]"

	..()
	var/result = rand(1, sides)
	var/comment = ""
	if(sides == 20 && result == 20)
		comment = "Nat 20!"
	else if(sides == 20 && result == 1)
		comment = "Ouch, bad luck."
	icon_state = "[name][result]"
	src.visible_message("<span class='notice'>\The [name] lands on [result]. [comment]</span>")

	name = "d4"
	desc = "A dice with four sides."
	icon_state = "d44"
	sides = 4

	name = "d8"
	desc = "A dice with eight sides."
	icon_state = "d88"
	sides = 8

	name = "d10"
	desc = "A dice with ten sides."
	icon_state = "d1010"
	sides = 10

	name = "d12"
	desc = "A dice with twelve sides."
	icon_state = "d1212"
	sides = 12

	name = "d20"
	desc = "A dice with twenty sides."
	icon_state = "d2020"
	sides = 20

	name = "d100"
	desc = "A dice with ten sides. This one is for the tens digit."
	icon_state = "d10010"
	sides = 10
/obj/item/dice
	name = "d6"
	desc = "A dice with six sides."
	icon = 'icons/obj/dice.dmi'
	icon_state = "d66"
	w_class = 1
	var/base_icon = "d6"
	var/side_mult = 1 // Used for d100s.
	var/sides = 6
	var/weighted = FALSE //if this dice can cheat or something
	var/favored_number = 1 //related to the var above
	var/weighted_value = 70 //what is the chance of falling on the favored number
	var/result
	var/comment = ""
	attack_verb = list("diced")

/obj/item/dice/Initialize()
	. = ..()
	icon_state = "[base_icon][rand(1,sides)]"

/obj/item/dice/update_icon(var/result)
	if(result)
		icon_state = "[base_icon][result]"

/obj/item/dice/throw_impact(atom/hit_atom)
	..()
	rollDice(null, 0)

/obj/item/dice/attack_self(mob/user as mob)
	rollDice(user, 1)
	to_chat(user, span("notice", "You roll \the [name] around in your hand. It lands on [result * side_mult]. [comment]"))

/obj/item/dice/proc/rollDice(mob/user as mob, var/silent = 0)
	if((weighted) && (prob(weighted_value)))
		result = favored_number
	else
		result = rand(1, sides)

	if(sides == 20 && result == 20)
		comment = "Nat 20!"
	else if(sides == 20 && result == 1)
		comment = "Ouch, bad luck."
	icon_state = "[name][result]"

	if(!silent)
		src.visible_message("<span class='notice'>\The [name] lands on [result * side_mult]. [comment]</span>")
	update_icon(result)

/obj/item/dice/d4
	name = "d4"
	desc = "A dice with four sides."
	icon_state = "d44"
	sides = 4
	base_icon = "d4"

/obj/item/dice/d8
	name = "d8"
	desc = "A dice with eight sides."
	icon_state = "d88"
	sides = 8
	base_icon = "d8"

/obj/item/dice/d10
	name = "d10"
	desc = "A dice with ten sides."
	icon_state = "d1010"
	sides = 10
	base_icon = "d10"

/obj/item/dice/d12
	name = "d12"
	desc = "A dice with twelve sides."
	icon_state = "d1212"
	sides = 12
	base_icon = "d12"

/obj/item/dice/d20
	name = "d20"
	desc = "A dice with twenty sides."
	icon_state = "d2020"
	sides = 20
	base_icon = "d20"

/obj/item/dice/d100
	name = "d100"
	desc = "A dice with ten sides. This one is for the tens digit."
	icon_state = "d10010"
	sides = 10
	side_mult = 10
	base_icon = "d100"

/*
 *Liar's Dice cup
 */

/obj/item/storage/dicecup
	name = "dice cup"
	desc = "A cup used to conceal and hold dice."
	icon = 'icons/obj/dice.dmi'
	icon_state = "dicecup"
	w_class = 2
	storage_slots = 5
	can_hold = list(
		/obj/item/dice,
		)

/obj/item/storage/dicecup/attack_self(mob/user as mob)
	user.visible_message("<span class='notice'>[user] shakes [src].</span>", \
							 "<span class='notice'>You shake [src].</span>", \
							 "<span class='notice'>You hear dice rolling.</span>")
	rollCup(user)

/obj/item/storage/dicecup/proc/rollCup(mob/user as mob)
	for(var/obj/item/dice/I in src.contents)
		var/obj/item/dice/D = I
		D.rollDice(user, 1)

/obj/item/storage/dicecup/proc/revealDice(var/mob/viewer)
	for(var/obj/item/dice/I in src.contents)
		var/obj/item/dice/D = I
		to_chat(viewer, "The [D.name] shows a [D.result].")

/obj/item/storage/dicecup/verb/peekAtDice()
	set category = "Object"
	set name = "Peek at Dice"
	set desc = "Peek at the dice under your cup."

	revealDice(usr)

/obj/item/storage/dicecup/verb/revealDiceHand()

	set category = "Object"
	set name = "Reveal Dice"
	set desc = "Reveal the dice hidden under your cup."

	for(var/mob/living/player in viewers(3))
		to_chat(player, "[usr] reveals their dice.")
		revealDice(player)

/obj/item/storage/dicecup/loaded/Initialize()
	. = ..()
	for(var/i = 1 to 5)
		new /obj/item/dice( src )

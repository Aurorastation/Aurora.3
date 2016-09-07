/obj/item/weapon/dice
	name = "d6"
	desc = "A dice with six sides."
	icon = 'icons/obj/dice.dmi'
	icon_state = "d66"
	w_class = 1
	var/sides = 6
	attack_verb = list("diced")

/obj/item/weapon/dice/New()
	icon_state = "[name][rand(1,sides)]"

/obj/item/weapon/dice/d20
	name = "d20"
	desc = "A dice with twenty sides."
	icon_state = "d2020"
	sides = 20

/mob/living/carbon/human/throw_item(atom/target)
	var/atom/movable/item = src.get_active_hand()
	if (istype(item, /obj/item/weapon/dice/))
		var/obj/item/weapon/dice/I = item
		var/result = rand(1, I.sides)
		var/comment = ""
		if(I.sides == 20 && result == 20)
			comment = "Nat 20!"
		else if(I.sides == 20 && result == 1)
			comment = "Ouch, bad luck."
		I.icon_state = "[I.name][result]"
		..()
		usr.visible_message("<span class='notice'>\The [I.name] lands on [result]. [comment]</span>")
	else ..()
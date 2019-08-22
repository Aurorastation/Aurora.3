/mob/living/simple_animal/slime
	name = "pet slime"
	desc = "A lovable, domesticated slime."
	icon = 'icons/mob/npc/slimes.dmi'
	icon_state = "grey baby slime"
	icon_living = "grey baby slime"
	icon_dead = "grey baby slime dead"
	speak_emote = list("chirps")
	health = 100
	maxHealth = 100
	response_help  = "pets"
	response_disarm = "shoos"
	response_harm   = "stomps on"
	emote_see = list("jiggles", "bounces in place")
	var/colour = "grey"
	mob_size = 3
	composition_reagent = "slimejelly"

/mob/living/simple_animal/slime/can_force_feed(var/feeder, var/food, var/feedback)
	if(feedback)
		to_chat(feeder, "Where do you intend to put \the [food]? \The [src] doesn't have a mouth!")
	return 0

/mob/living/simple_animal/adultslime
	name = "pet slime"
	desc = "A lovable, domesticated slime."
	icon = 'icons/mob/npc/slimes.dmi'
	health = 200
	maxHealth = 200
	icon_state = "grey adult slime"
	icon_living = "grey adult slime"
	icon_dead = "grey baby slime dead"
	response_help  = "pets"
	response_disarm = "shoos"
	response_harm   = "stomps on"
	emote_see = list("jiggles", "bounces in place")
	var/colour = "grey"
	mob_size = 6
	composition_reagent = "slimejelly"

/mob/living/simple_animal/adultslime/Initialize()
	. = ..()
	add_overlay("aslime-:33")


/mob/living/simple_animal/adultslime/death()
	var/mob/living/simple_animal/slime/S1 = new /mob/living/simple_animal/slime (src.loc)
	S1.icon_state = "[src.colour] baby slime"
	S1.icon_living = "[src.colour] baby slime"
	S1.icon_dead = "[src.colour] baby slime dead"
	S1.colour = "[src.colour]"
	var/mob/living/simple_animal/slime/S2 = new /mob/living/simple_animal/slime (src.loc)
	S2.icon_state = "[src.colour] baby slime"
	S2.icon_living = "[src.colour] baby slime"
	S2.icon_dead = "[src.colour] baby slime dead"
	S2.colour = "[src.colour]"
	qdel(src)

/mob/living/simple_animal/slime/wizard
	desc = "A smallish, blobby creature that bobs up and down slowly. How did it get in here?"

/mob/living/simple_animal/slime/wizard/verb/change_name()
	set name = "Name Slime"
	set category = "IC"
	set src in view(1)

	var/mob/M = usr
	if(!M.mind)	return 0

	if(!name_changed)

		var/input = sanitizeSafe(input("What do you want to name the Slime?", ,""), MAX_NAME_LEN)

		if(src && input && !M.stat && in_range(M,src))
			name = input
			real_name = input
			name_changed = 1
			return 1

	else
		to_chat(usr, "<span class='notice'>[src] already has a name!</span>")
		return
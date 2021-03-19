/datum/rune/freedom
	name = "freedom rune"
	desc = "This rune is used to free a cultist of our choice from captivity."
	rune_flags = NO_TALISMAN

/datum/rune/freedom/do_rune_action(mob/living/user, atom/movable/A)
	var/list/mob/living/carbon/human/cultists = list()
	for(var/datum/mind/H in cult.current_antagonists)
		if(ishuman(H.current))
			cultists += H.current

	var/list/mob/living/carbon/users = list()
	for(var/mob/living/carbon/C in orange(1, A))
		if(iscultist(C) && !C.stat)
			users += C

	if(length(users) >= 3)
		var/mob/living/carbon/human/cultist = input("Choose a cultist you wish to free.", "Followers of Geometer") as null|anything in (cultists - users)
		if(!cultist)
			return fizzle(user, A)
		if(cultist == user) //just to be sure.
			return
		
		var/cultist_free = TRUE
		if(cultist.buckled_to)
			cultist_free = FALSE
			cultist.buckled_to = null
		if(cultist.handcuffed)
			cultist_free = FALSE
			cultist.drop_from_inventory(cultist.handcuffed)
		if(cultist.legcuffed)
			cultist_free = FALSE
			cultist.drop_from_inventory(cultist.legcuffed)
		if(istype(cultist.wear_mask, /obj/item/clothing/mask/muzzle))
			cultist_free = FALSE
			cultist.drop_from_inventory(cultist.wear_mask)
		if(istype(cultist.wear_suit, /obj/item/clothing/suit/straight_jacket))
			cultist_free = FALSE
			cultist.drop_from_inventory(cultist.wear_suit)
		if(istype(cultist.loc, /obj/structure/closet))
			var/obj/structure/closet/C = cultist.loc
			if(C.welded)
				cultist_free = FALSE
				C.welded = FALSE
		if(istype(cultist.loc, /obj/structure/closet/secure_closet))
			var/obj/structure/closet/secure_closet/C = cultist.loc
			if(C.locked)
				cultist_free = FALSE
				C.locked = FALSE
		for(var/obj/machinery/door/airlock/door in range(2, get_turf(cultist)))
			if(door.locked)
				cultist_free = FALSE
				door.unlock()
				door.open()
		
		if(!cultist_free)
			to_chat(cultist, SPAN_CULT("Your fellow cultists have freed you!"))

		for(var/mob/living/carbon/C in users)
			if(cultist_free)
				to_chat(C, SPAN_CULT("\The [cultist] is already free."))
			else
				C.say("Khari'd! Gual'te nikka!")
		qdel(A)
	return fizzle(user, A)
/proc/Christmas_Game_Start()
	for(var/obj/structure/flora/tree/pine/xmas in world)
		if(isNotStationLevel(xmas.z))	continue
		for(var/turf/simulated/floor/T in orange(1,xmas))
			for(var/i=1,i<=rand(1,5),i++)
				new /obj/item/a_gift(T)
	//for(var/mob/living/simple_animal/corgi/Ian/Ian in mob_list)
	//	Ian.place_on_head(new /obj/item/clothing/head/helmet/space/santahat(Ian))

/proc/ChristmasEvent()
	for(var/obj/structure/flora/tree/pine/xmas in world)
		var/mob/living/simple_animal/hostile/tree/evil_tree = new /mob/living/simple_animal/hostile/tree(xmas.loc)
		evil_tree.icon_state = xmas.icon_state
		evil_tree.icon_living = evil_tree.icon_state
		evil_tree.icon_dead = evil_tree.icon_state
		evil_tree.icon_gib = evil_tree.icon_state
		qdel(xmas)


// All Christmas Props, now UNIFIED in one place

// Things in your HAND
/obj/item/toy/xmas_cracker
	name = "xmas cracker"
	icon = 'icons/holidays/christmas/items.dmi'
	icon_state = "cracker"
	desc = "Directions for use: Requires two people, one to pull each end."
	var/cracked = 0

/obj/item/toy/xmas_cracker/attack(mob/target, mob/user, var/target_zone)
	if( !cracked && istype(target,/mob/living/carbon/human) && (target.stat == CONSCIOUS) && !target.get_active_hand() )
		target.visible_message("<span class='notice'>[user] and [target] pop \an [src]! *pop*</span>", "<span class='notice'>You pull \an [src] with [target]! *pop*</span>", "<span class='notice'>You hear a *pop*.</span>")
		var/obj/item/paper/Joke = new /obj/item/paper(user.loc)
		var/title = "[pick("awful","terrible","unfunny")] joke"
		var/content = pick("What did one snowman say to the other?\n\n<i>'Is it me or can you smell carrots?'</i>",
			"Why couldn't the snowman get laid?\n\n<i>He was frigid!</i>",
			"Where are santa's helpers educated?\n\n<i>Nowhere, they're ELF-taught.</i>",
			"What happened to the man who stole advent calanders?\n\n<i>He got 25 days.</i>",
			"What does Santa get when he gets stuck in a chimney?\n\n<i>Claus-trophobia.</i>",
			"Where do you find chili beans?\n\n<i>The north pole.</i>",
			"What do you get from eating tree decorations?\n\n<i>Tinsilitis!</i>",
			"What do snowmen wear on their heads?\n\n<i>Ice caps!</i>",
			"Why is Christmas just like life in NanoTrasen?\n\n<i>You do all the work and the fat guy gets all the credit.</i>",
			"Why doesn't Santa have any children?\n\n<i>Because he only comes down the chimney.</i>")
		Joke.set_content_unsafe(title, content)
		new /obj/item/clothing/head/festive(target.loc)
		user.update_icon()
		cracked = 1
		icon_state = "cracker1"
		var/obj/item/toy/xmas_cracker/other_half = new /obj/item/toy/xmas_cracker(target)
		other_half.cracked = 1
		other_half.icon_state = "cracker2"
		target.put_in_active_hand(other_half)
		playsound(user, 'sound/effects/snap.ogg', 50, 1)
		return 1
	return ..()

// Things on your HEAD
/obj/item/clothing/head/festive
	name = "festive paper hat"
	icon_state = "xmashat"
	desc = "A crappy paper hat that you are REQUIRED to wear."
	flags_inv = 0
	body_parts_covered = 0
	armor = null

/obj/item/clothing/head/festive/santa
	name = "santa hat"
	icon_state = "santahat"
	desc = "A cheap fabric santa hat."

/obj/item/clothing/head/festive/santa/beard
	desc = "A cheap fabric santa hat, this one with a beard."
	body_parts_covered = HEAD
	icon_state = "santahat_alt"

// Things at your PLACE
/obj/structure/sign/christmas/lights
	name = "christmas lights"
	desc = "Flashy."
	icon = 'icons/holidays/christmas/items.dmi'
	icon_state = "xmaslights"
	layer = 4.9

/obj/structure/sign/christmas/wreath
	name = "wreath"
	desc = "Prickly and very festive."
	icon = 'icons/holidays/christmas/items.dmi'
	icon_state = "doorwreath"
	layer = 5

/obj/structure/sign/christmas/garland
	name = "festive garland"
	desc = "Very festive lights. How nice."
	icon = 'icons/holidays/christmas/props.dmi'
	icon_state = "garland_on"
	layer = 4.9

/obj/structure/sign/christmas/tinsel
	name = "tinsel"
	desc = "There used to be more tinsel."
	icon = 'icons/holidays/christmas/props.dmi'
	icon_state = "tinsel_g"
	layer = 5

/obj/structure/sign/christmas/tinsel/red
	name = "red tinsel"
	icon_state = "tinsel_r"

/obj/structure/sign/christmas/tinsel/yellow
	name = "yellow tinsel"
	icon_state = "tinsel_y"

/obj/structure/sign/christmas/tinsel/white
	name = "white tinsel"
	icon_state = "tinsel_w"

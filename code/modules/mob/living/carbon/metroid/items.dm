/obj/item/slime_extract
	name = "slime extract"
	desc = "Goo extracted from a slime. Legends claim these to have \"magical powers\"."
	icon = 'icons/mob/npc/slimes.dmi'
	icon_state = "grey slime extract"
	force = 1.0
	w_class = 1.0
	throwforce = 0
	throw_speed = 3
	throw_range = 6
	origin_tech = list(TECH_BIO = 4)
	var/Uses = 1 // uses before it goes inert
	var/enhanced = 0 //has it been enhanced before?
	flags = OPENCONTAINER

	attackby(obj/item/O as obj, mob/user as mob)
		if(istype(O, /obj/item/slimesteroid2))
			if(enhanced == 1)
				to_chat(user, "<span class='warning'>This extract has already been enhanced!</span>")
				return ..()
			if(Uses == 0)
				to_chat(user, "<span class='warning'>You can't enhance a used extract!</span>")
				return ..()
			to_chat(user, "You apply the enhancer. It now has triple the amount of uses.")
			Uses = 3
			enhanced = 1
			qdel(O)

/obj/item/slime_extract/New()
	..()
	create_reagents(100)
	reagents.add_reagent("slimejelly", 30)

/obj/item/slime_extract/grey
	name = "grey slime extract"
	icon_state = "grey slime extract"

/obj/item/slime_extract/gold
	name = "gold slime extract"
	icon_state = "gold slime extract"

/obj/item/slime_extract/silver
	name = "silver slime extract"
	icon_state = "silver slime extract"

/obj/item/slime_extract/metal
	name = "metal slime extract"
	icon_state = "metal slime extract"

/obj/item/slime_extract/purple
	name = "purple slime extract"
	icon_state = "purple slime extract"

/obj/item/slime_extract/darkpurple
	name = "dark purple slime extract"
	icon_state = "dark purple slime extract"

/obj/item/slime_extract/orange
	name = "orange slime extract"
	icon_state = "orange slime extract"

/obj/item/slime_extract/yellow
	name = "yellow slime extract"
	icon_state = "yellow slime extract"

/obj/item/slime_extract/red
	name = "red slime extract"
	icon_state = "red slime extract"

/obj/item/slime_extract/blue
	name = "blue slime extract"
	icon_state = "blue slime extract"

/obj/item/slime_extract/darkblue
	name = "dark blue slime extract"
	icon_state = "dark blue slime extract"

/obj/item/slime_extract/pink
	name = "pink slime extract"
	icon_state = "pink slime extract"

/obj/item/slime_extract/green
	name = "green slime extract"
	icon_state = "green slime extract"

/obj/item/slime_extract/lightpink
	name = "light pink slime extract"
	icon_state = "light pink slime extract"

/obj/item/slime_extract/black
	name = "black slime extract"
	icon_state = "black slime extract"

/obj/item/slime_extract/oil
	name = "oil slime extract"
	icon_state = "oil slime extract"

/obj/item/slime_extract/adamantine
	name = "adamantine slime extract"
	icon_state = "adamantine slime extract"

/obj/item/slime_extract/bluespace
	name = "bluespace slime extract"
	icon_state = "bluespace slime extract"

/obj/item/slime_extract/pyrite
	name = "pyrite slime extract"
	icon_state = "pyrite slime extract"

/obj/item/slime_extract/cerulean
	name = "cerulean slime extract"
	icon_state = "cerulean slime extract"

/obj/item/slime_extract/sepia
	name = "sepia slime extract"
	icon_state = "sepia slime extract"

/obj/item/slime_extract/rainbow
	name = "rainbow slime extract"
	icon_state = "rainbow slime extract"

////Pet Slime Creation///

/obj/item/slimepotion
	name = "docility potion"
	desc = "A potent chemical mix that will nullify a slime's powers, causing it to become docile and tame."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle19"

	attack(mob/living/carbon/slime/M as mob, mob/user as mob)
		if(!istype(M, /mob/living/carbon/slime))//If target is not a slime.
			to_chat(user, "<span class='warning'>The potion only works on baby slimes!</span>")
			return ..()
		if(M.is_adult) //Can't tame adults
			to_chat(user, "<span class='warning'>Only baby slimes can be tamed!</span>")
			return..()
		if(M.stat)
			to_chat(user, "<span class='warning'>The slime is dead!</span>")
			return..()
		if(M.mind)
			to_chat(user, "<span class='warning'>The slime resists!</span>")
			return ..()
		var/mob/living/simple_animal/slime/pet = new /mob/living/simple_animal/slime(M.loc)
		pet.icon_state = "[M.colour] baby slime"
		pet.icon_living = "[M.colour] baby slime"
		pet.icon_dead = "[M.colour] baby slime dead"
		pet.colour = "[M.colour]"
		to_chat(user, "You feed the slime the potion, removing it's powers and calming it.")
		qdel(M)
		var/newname = sanitize(input(user, "Would you like to give the slime a name?", "Name your new pet", "pet slime") as null|text, MAX_NAME_LEN)

		if (!newname)
			newname = "pet slime"
		pet.name = newname
		pet.real_name = newname
		qdel(src)

/obj/item/slimepotion2
	name = "advanced docility potion"
	desc = "A potent chemical mix that will nullify a slime's powers, causing it to become docile and tame. This one is meant for adult slimes"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle19"

	attack(mob/living/carbon/slime/M as mob, mob/user as mob)
		if(!istype(M, /mob/living/carbon/slime/))//If target is not a slime.
			to_chat(user, "<span class='warning'>The potion only works on slimes!</span>")
			return ..()
		if(M.stat)
			to_chat(user, "<span class='warning'>The slime is dead!</span>")
			return..()
		if(M.mind)
			to_chat(user, "<span class='warning'>The slime resists!</span>")
			return ..()
		var/mob/living/simple_animal/adultslime/pet = new /mob/living/simple_animal/adultslime(M.loc)
		pet.icon_state = "[M.colour] adult slime"
		pet.icon_living = "[M.colour] adult slime"
		pet.icon_dead = "[M.colour] baby slime dead"
		pet.colour = "[M.colour]"
		to_chat(user, "You feed the slime the potion, removing it's powers and calming it.")
		qdel(M)
		var/newname = sanitize(input(user, "Would you like to give the slime a name?", "Name your new pet", "pet slime") as null|text, MAX_NAME_LEN)

		if (!newname)
			newname = "pet slime"
		pet.name = newname
		pet.real_name = newname
		qdel(src)


/obj/item/slimesteroid
	name = "slime steroid"
	desc = "A potent chemical mix that will cause a slime to generate more extract."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle16"

	attack(mob/living/carbon/slime/M as mob, mob/user as mob)
		if(!istype(M, /mob/living/carbon/slime))//If target is not a slime.
			to_chat(user, "<span class='warning'>The steroid only works on baby slimes!</span>")
			return ..()
		if(M.is_adult) //Can't tame adults
			to_chat(user, "<span class='warning'>Only baby slimes can use the steroid!</span>")
			return..()
		if(M.stat)
			to_chat(user, "<span class='warning'>The slime is dead!</span>")
			return..()
		if(M.cores == 3)
			to_chat(user, "<span class='warning'>The slime already has the maximum amount of extract!</span>")
			return..()

		to_chat(user, "You feed the slime the steroid. It now has triple the amount of extract.")
		M.cores = 3
		qdel(src)

/obj/item/slimesteroid2
	name = "extract enhancer"
	desc = "A potent chemical mix that will give a slime extract three uses."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle17"

	/*afterattack(obj/target, mob/user , flag)
		if(istype(target, /obj/item/slime_extract))
			if(target.enhanced == 1)
				to_chat(user, "<span class='warning'>This extract has already been enhanced!</span>")
				return ..()
			if(target.Uses == 0)
				to_chat(user, "<span class='warning'>You can't enhance a used extract!</span>")
				return ..()
			to_chat(user, "You apply the enhancer. It now has triple the amount of uses.")
			target.Uses = 3
			target.enahnced = 1
			qdel(src)*/

/obj/effect/golemrune
	anchored = 1
	desc = "a strange rune used to create golems. It glows when spirits are nearby."
	name = "rune"
	icon = 'icons/obj/rune.dmi'
	icon_state = "golem"
	unacidable = 1
	layer = TURF_LAYER
	var/wizardy = FALSE //if this rune can only be used by a wizard or not

/obj/effect/golemrune/Initialize()
	. = ..()
	START_PROCESSING(SSprocessing, src)
	announce_to_ghosts()

/obj/effect/golemrune/process()
	var/mob/abstract/observer/ghost
	for(var/mob/abstract/observer/O in src.loc)
		if(!O.client)	continue
		if(O.mind && O.mind.current && O.mind.current.stat != DEAD)	continue
		ghost = O
		break
	if(ghost && !(ghost.has_enabled_antagHUD && config.antag_hud_restricted))
		icon_state = "golem2"
	else
		icon_state = "golem"

/obj/effect/golemrune/attack_hand(mob/living/user as mob)
	var/mob/abstract/observer/ghost
	for(var/mob/abstract/observer/O in src.loc)
		if(!O.client)	continue
		if(O.mind && O.mind.current && O.mind.current.stat != DEAD)	continue
		ghost = O
		break

	if(wizardy)
		if(!user.is_wizard())
			to_chat(user, "<span class='notice'>The rune lies silent.</span>")
			return

	if(!ghost)
		to_chat(user, "<span class='warning'>The rune fizzles uselessly. There is no spirit nearby.</span>")
		return
	if(ghost.has_enabled_antagHUD && config.antag_hud_restricted)
		to_chat(ghost, "<span class='warning'>You can not join as a golem with antagHUD on!</span>")
		to_chat(user, "<span class='warning'>The rune fizzles uselessly. There is no spirit nearby.</span>")
		return

	var/golem_type = "Adamantine Golem"

	var/obj/item/stack/material/O = (locate(/obj/item/stack/material) in src.loc)
	if(O && O.amount>=10)
		if(O.material.golem)
			golem_type = O.material.golem
			qdel(O)

	var/mob/living/carbon/human/G = new(src.loc)

	G.key = ghost.key
	G.set_species(golem_type)
	G.name = G.species.get_random_name()
	G.real_name = G.species.get_random_name()
	to_chat(G, "<span class='notice'>You are a golem. Serve [user], and assist them in completing their goals at any cost.</span>")
	qdel(src)

/obj/effect/golemrune/proc/announce_to_ghosts()
	var/area/A = get_area(src)
	if(A)
		say_dead_direct("Golem rune created in [A.name]")

/obj/effect/golemrune/wizard
	wizardy = TRUE

/mob/living/carbon/slime/has_eyes()
	return 0


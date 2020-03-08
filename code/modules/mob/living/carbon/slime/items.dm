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
	var/uses = 1 // uses before it goes inert
	var/enhanced = FALSE //has it been enhanced before?
	flags = OPENCONTAINER

/obj/item/slime_extract/attackby(var/obj/item/O, var/mob/user)
	if(istype(O, /obj/item/slimesteroid2))
		if(enhanced)
			to_chat(user, span("warning", "This extract has already been enhanced!"))
			return ..()
		if(!uses)
			to_chat(user, span("warning", "You can't enhance a used extract!"))
			return ..()
		to_chat(user, span("notice", "You apply the enhancer. It now has triple the amount of uses."))
		uses *= 3
		enhanced = TRUE
		qdel(O)

/obj/item/slime_extract/Initialize()
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

/obj/item/slimepotion/attack(var/mob/living/carbon/slime/M, var/mob/user)
	if(!istype(M, /mob/living/carbon/slime)) //If target is not a slime.
		to_chat(user, span("warning", "The potion only works on baby slimes!"))
		return ..()
	if(M.is_adult) //Can't tame adults
		to_chat(user, span("warning", "Only baby slimes can be tamed!"))
		return ..()
	if(M.stat)
		to_chat(user, span("warning", "The slime is dead!"))
		return..()
	if(M.mind)
		to_chat(user, span("warning", "The slime resists!"))
		return ..()
	var/mob/living/simple_animal/slime/pet = new /mob/living/simple_animal/slime(M.loc)
	pet.icon_state = "[M.colour] baby slime"
	pet.icon_living = "[M.colour] baby slime"
	pet.icon_dead = "[M.colour] baby slime dead"
	pet.colour = "[M.colour]"
	to_chat(user, span("notice", "You feed the slime the potion, removing its powers and calming it."))
	qdel(M)

	var/newname = sanitize(input(user, "Would you like to give the slime a name?", "Name your new pet", "pet slime") as null|text, MAX_NAME_LEN)
	if(!newname)
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
			to_chat(user, span("warning", "The potion only works on slimes!"))
			return ..()
		if(M.stat)
			to_chat(user, span("warning", "The slime is dead!"))
			return ..()
		if(M.mind)
			to_chat(user, span("warning", "The slime resists!"))
			return ..()
		var/mob/living/simple_animal/adultslime/pet = new /mob/living/simple_animal/adultslime(M.loc)
		pet.icon_state = "[M.colour] adult slime"
		pet.icon_living = "[M.colour] adult slime"
		pet.icon_dead = "[M.colour] baby slime dead"
		pet.colour = "[M.colour]"
		to_chat(user, "You feed the slime the potion, removing it's powers and calming it.")
		qdel(M)
		var/newname = sanitize(input(user, "Would you like to give the slime a name?", "Name your new pet", "pet slime") as null|text, MAX_NAME_LEN)

		if(!newname)
			newname = "pet slime"
		pet.name = newname
		pet.real_name = newname
		qdel(src)

/obj/item/slimesteroid
	name = "slime steroid"
	desc = "A potent chemical mix that will cause a slime to generate more extract."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle16"

/obj/item/slimesteroid/attack(mob/living/carbon/slime/M as mob, mob/user as mob)
	if(!istype(M, /mob/living/carbon/slime)) //If target is not a slime.
		to_chat(user, span("warning", "The steroid only works on baby slimes!"))
		return ..()
	if(M.is_adult) //Can't tame adults
		to_chat(user, span("warning", "Only baby slimes can use the steroid!"))
		return ..()
	if(M.stat == DEAD)
		to_chat(user, span("warning", "The slime is dead!"))
		return ..()
	if(M.cores >= 3)
		to_chat(user, span("warning", "The slime already has the maximum amount of extract!"))
		return ..()

	to_chat(user, "You feed the slime the steroid. It now has triple the amount of extract.")
	M.cores *= 3
	qdel(src)

/obj/item/slimesteroid2
	name = "extract enhancer"
	desc = "A potent chemical mix that will give a slime extract three uses."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle17"

var/list/global/golem_runes = list()

/obj/effect/golemrune
	anchored = TRUE
	desc = "A strange rune used to create golems. It glows when spirits are nearby."
	name = "rune"
	icon = 'icons/obj/rune.dmi'
	icon_state = "golem"
	unacidable = TRUE
	layer = TURF_LAYER
	var/wizardy = FALSE //if this rune can only be used by a wizard or not
	var/golem_type = "Adamantine Golem"

/obj/effect/golemrune/Initialize()
	. = ..()
	START_PROCESSING(SSprocessing, src)
	announce_to_ghosts()
	golem_runes += src
	if(length(golem_runes) == 1)
		for(var/role_spawner in SSghostroles.spawners)
			if(role_spawner == "golem")
				var/datum/ghostspawner/human/golem/golem_spawner = SSghostroles.spawners[role_spawner]
				golem_spawner.enable()

/obj/effect/golemrune/Destroy()
	. = ..()
	golem_runes -= src
	if(!length(golem_runes))
		for(var/role_spawner in SSghostroles.spawners)
			if(role_spawner == "golem")
				var/datum/ghostspawner/human/golem/golem_spawner = SSghostroles.spawners[role_spawner]
				golem_spawner.disable()

/obj/effect/golemrune/process()
	var/mob/abstract/observer/ghost
	for(var/mob/abstract/observer/O in src.loc)
		if(!O.client)
			continue
		if(O.mind && O.mind.current && O.mind.current.stat != DEAD)
			continue
		ghost = O
		break
	if(ghost && !(ghost.has_enabled_antagHUD && config.antag_hud_restricted))
		icon_state = "golem2"
	else
		icon_state = "golem"

/obj/effect/golemrune/proc/spawn_golem(var/mob/user)
	var/obj/item/stack/material/O = (locate(/obj/item/stack/material) in src.loc)
	if(O?.amount >= 10)
		if(O.material.golem)
			golem_type = O.material.golem
			O.use(10)

	spark(get_turf(src), 10, alldirs)

	var/mob/living/carbon/human/G = new(src.loc)

	G.key = user.key
	G.set_species(golem_type)
	G.name = G.species.get_random_name()
	G.real_name = G.name
	to_chat(G, span("notice", "You are a golem. Serve your master, and assist them in completing their goals at any cost."))
	qdel(src)

/obj/effect/golemrune/proc/announce_to_ghosts()
	var/area/A = get_area(src)
	if(A)
		say_dead_direct("A golem rune has been created in [A.name]! Access using the ghost spawner menu in the ghost tab.")

/obj/effect/golemrune/wizard
	wizardy = TRUE

/mob/living/carbon/slime/has_eyes()
	return FALSE
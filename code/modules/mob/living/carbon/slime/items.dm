/obj/item/slime_extract
	name = "slime extract"
	desc = "Goo extracted from a slime. Legends claim these to have \"magical powers\"."
	icon = 'icons/mob/npc/slimes.dmi'
	icon_state = "grey slime extract"
	force = 1.0
	w_class = ITEMSIZE_TINY
	throwforce = 0
	throw_speed = 3
	throw_range = 6
	origin_tech = list(TECH_BIO = 4)
	var/uses = 1 // uses before it goes inert
	var/enhanced = FALSE //has it been enhanced before?
	atom_flags = ATOM_FLAG_OPEN_CONTAINER

/obj/item/slime_extract/attackby(var/obj/item/O, var/mob/user)
	if(istype(O, /obj/item/extract_enhancer))
		if(enhanced)
			to_chat(user, SPAN_WARNING("This extract has already been enhanced!"))
			return ..()
		if(!uses)
			to_chat(user, SPAN_WARNING("You can't enhance a used extract!"))
			return ..()
		to_chat(user, SPAN_NOTICE("You apply the enhancer. It now has triple the amount of uses."))
		uses *= 3
		enhanced = TRUE
		qdel(O)
		return TRUE
	. = ..()

/obj/item/slime_extract/Initialize()
	. = ..()
	create_reagents(100)
	reagents.add_reagent(/singleton/reagent/slimejelly, 30)

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

/obj/item/docility_serum
	name = "docility serum"
	desc = "A potent chemical mix that will nullify a slime's powers, causing it to become docile and tame. This one is meant for baby slimes."
	icon = 'icons/obj/item/reagent_containers/glass.dmi'
	icon_state = "bottle-1"
	item_state = "bottle"
	contained_sprite = TRUE

/obj/item/docility_serum/Initialize() // Better than hardsprited in stuff.
	. = ..()
	var/mutable_appearance/filling = mutable_appearance(icon, "[icon_state]-100")
	filling.color = COLOR_PINK
	add_overlay(filling)

/obj/item/docility_serum/attack(mob/living/carbon/slime/M as mob, mob/user as mob)
	if(!istype(M, /mob/living/carbon/slime/))//If target is not a slime.
		to_chat(user, SPAN_WARNING("The docility serum only works on slimes!"))
		return ..()
	if(M.stat)
		to_chat(user, SPAN_WARNING("The slime is dead!"))
		return ..()
	if(M.mind)
		to_chat(user, SPAN_WARNING("The slime is too intelligent to be pacified!"))
		return ..()
	if(M.is_adult)
		to_chat(user, SPAN_WARNING("The serum isn't advanced enough to affect adult slimes."))
		return ..()

	var/mob/living/simple_animal/slime/pet = new /mob/living/simple_animal/slime(M.loc)
	pet.icon_state = "[M.colour] baby slime"
	pet.icon_living = "[M.colour] baby slime"
	pet.icon_dead = "[M.colour] baby slime dead"
	pet.colour = "[M.colour]"
	to_chat(user, SPAN_NOTICE("You feed the slime the docility serum, removing its powers and calming it."))
	qdel(M)

	var/newname = sanitize(input(user, "Would you like to give the slime a name?", "Name your new pet", "pet slime") as null|text, MAX_NAME_LEN)
	if(!newname)
		newname = "pet slime"
	pet.name = newname
	pet.real_name = newname
	qdel(src)

/obj/item/advanced_docility_serum
	name = "advanced docility serum"
	desc = "A potent chemical mix that will nullify a slime's powers, causing it to become docile and tame. This one is meant for adult slimes"
	icon = 'icons/obj/item/reagent_containers/glass.dmi'
	icon_state = "bottle-2"
	item_state = "bottle"
	contained_sprite = TRUE

/obj/item/advanced_docility_serum/Initialize() // Better than hardsprited in stuff.
	. = ..()
	var/mutable_appearance/filling = mutable_appearance(icon, "[icon_state]-100")
	filling.color = COLOR_PALE_PINK
	add_overlay(filling)

/obj/item/advanced_docility_serum/attack(mob/living/carbon/slime/M as mob, mob/user as mob)
	if(!istype(M, /mob/living/carbon/slime/))//If target is not a slime.
		to_chat(user, SPAN_WARNING("The docility serum only works on slimes!"))
		return ..()
	if(M.stat)
		to_chat(user, SPAN_WARNING("The slime is dead!"))
		return ..()
	if(M.mind)
		to_chat(user, SPAN_WARNING("The slime is too intelligent to be pacified!"))
		return ..()
	if(!M.is_adult)
		to_chat(user, SPAN_WARNING("The serum is too advanced to affect baby slimes."))
		return ..()

	var/mob/living/simple_animal/adultslime/pet = new /mob/living/simple_animal/slime(M.loc)
	pet.icon_state = "[M.colour] adult slime"
	pet.icon_living = "[M.colour] adult slime"
	pet.icon_dead = "[M.colour] baby slime dead"
	pet.colour = "[M.colour]"
	to_chat(user, SPAN_NOTICE("You feed the slime the advanced docility serum, removing its powers and calming it."))
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
	icon = 'icons/obj/item/reagent_containers/glass.dmi'
	icon_state = "bottle-3"
	item_state = "bottle"
	contained_sprite = TRUE

/obj/item/slimesteroid/Initialize() // Better than hardsprited in stuff.
	SHOULD_CALL_PARENT(FALSE)

	if(flags_1 & INITIALIZED_1)
		stack_trace("Warning: [src]([type]) initialized multiple times!")
	flags_1 |= INITIALIZED_1

	var/mutable_appearance/filling = mutable_appearance(icon, "[icon_state]-100")
	filling.color = COLOR_GREEN
	add_overlay(filling)

	return INITIALIZE_HINT_NORMAL

/obj/item/slimesteroid/attack(mob/living/carbon/slime/M as mob, mob/user as mob)
	if(!istype(M, /mob/living/carbon/slime)) //If target is not a slime.
		to_chat(user, SPAN_WARNING("The steroid only works on baby slimes!"))
		return ..()
	if(M.is_adult) //Can't tame adults
		to_chat(user, SPAN_WARNING("Only baby slimes can use the steroid!"))
		return ..()
	if(M.stat == DEAD)
		to_chat(user, SPAN_WARNING("The slime is dead!"))
		return ..()
	if(M.cores >= 3)
		to_chat(user, SPAN_WARNING("The slime already has the maximum amount of extract!"))
		return ..()

	to_chat(user, "You feed the slime the steroid. It now has triple the amount of extract.")
	M.cores *= 3
	qdel(src)

/obj/item/extract_enhancer
	name = "extract enhancer"
	desc = "A potent chemical mix that will give a slime extract three uses."
	icon = 'icons/obj/item/reagent_containers/glass.dmi'
	icon_state = "bottle-4"
	item_state = "bottle"
	contained_sprite = TRUE

/obj/item/extract_enhancer/Initialize() // Better than hardsprited in stuff.
	SHOULD_CALL_PARENT(FALSE)

	if(flags_1 & INITIALIZED_1)
		stack_trace("Warning: [src]([type]) initialized multiple times!")
	flags_1 |= INITIALIZED_1

	var/mutable_appearance/filling = mutable_appearance(icon, "[icon_state]-100")
	filling.color = COLOR_BLUE
	add_overlay(filling)

	return INITIALIZE_HINT_NORMAL

/obj/effect/golemrune
	anchored = TRUE
	desc = "A strange rune used to create golems. It glows when spirits are nearby."
	name = "rune"
	icon = 'icons/obj/rune.dmi'
	icon_state = "golem"
	unacidable = TRUE
	layer = TURF_LAYER
	var/golem_type = "Adamantine Golem"

/obj/effect/golemrune/Initialize()
	. = ..()
	START_PROCESSING(SSprocessing, src)
	SSghostroles.add_spawn_atom("golem", src)

/obj/effect/golemrune/random_type/Initialize()
	. = ..()
	golem_type = pick(golem_types)

/obj/effect/golemrune/Destroy()
	SSghostroles.remove_spawn_atom("golem", src)
	return ..()

/obj/effect/golemrune/process()
	var/mob/abstract/observer/ghost
	for(var/mob/abstract/observer/O in src.loc)
		if(!O.client)
			continue
		if(O.mind && O.mind.current && O.mind.current.stat != DEAD)
			continue
		ghost = O
		break
	if(ghost && !(ghost.has_enabled_antagHUD && GLOB.config.antag_hud_restricted))
		icon_state = "golem2"
	else
		icon_state = "golem"

/obj/effect/golemrune/assign_player(var/mob/user)
	var/obj/item/stack/material/O = (locate(/obj/item/stack/material) in src.loc)
	if(O?.amount >= 10)
		if(O.material.golem)
			golem_type = O.material.golem
			O.use(10)

	spark(get_turf(src), 10, GLOB.alldirs)

	var/mob/living/carbon/human/G = new(src.loc)

	G.key = user.key
	G.set_species(golem_type)
	G.name = G.species.get_random_name()
	G.real_name = G.name
	G.set_culture(GET_SINGLETON(/singleton/origin_item/culture/golem))
	G.set_origin(GET_SINGLETON(/singleton/origin_item/origin/golem))
	G.accent = G.origin.possible_accents[1]
	G.citizenship = G.origin.possible_citizenships[1]
	G.religion = G.origin.possible_religions[1]
	G.preEquipOutfit(/datum/outfit/admin/golem, FALSE)
	G.equipOutfit(/datum/outfit/admin/golem, FALSE)
	G.client.init_verbs()
	to_chat(G, SPAN_NOTICE("You are a golem. Serve your master, and assist them in completing their goals at any cost."))

	qdel(src)

	return G

/mob/living/carbon/slime/has_eyes()
	return FALSE

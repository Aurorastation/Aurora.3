// These things get applied to slimes to do things.

/obj/item/slimepotion
	name = "slime agent"
	desc = "A flask containing strange, mysterious substances excreted by a slime."
	icon = 'icons/obj/chemical.dmi'
	w_class = ITEMSIZE_TINY
	origin_tech = list(TECH_BIO = 4)

// This is actually applied to an extract, so no attack() overriding needed.
/obj/item/slimepotion/enhancer
	name = "extract enhancer agent"
	desc = "A potent chemical mix that will give a slime extract an additional two uses."
	icon_state = "potpurple"
	description_info = "This will even work on inert slime extracts, if it wasn't enhanced before.  Extracts enhanced cannot be enhanced again."

// Makes slimes less likely to mutate.
/obj/item/slimepotion/stabilizer
	name = "slime stabilizer agent"
	desc = "A potent chemical mix that will reduce the chance of a slime mutating."
	icon_state = "potcyan"
	description_info = "The slime needs to be alive for this to work.  It will reduce the chances of mutation by 15%."

/obj/item/slimepotion/stabilizer/attack(mob/living/simple_animal/slime/M, mob/user)
	if(!istype(M))
		to_chat(user, "<span class='warning'>The stabilizer only works on slimes!</span>")
		return ..()
	if(M.stat == DEAD)
		to_chat(user, "<span class='warning'>The slime is dead!</span>")
		return ..()
	if(M.mutation_chance == 0)
		to_chat(user, "<span class='warning'>The slime already has no chance of mutating!</span>")
		return ..()

	to_chat(user, "<span class='notice'>You feed the slime the stabilizer. It is now less likely to mutate.</span>")
	M.mutation_chance = between(0, M.mutation_chance - 15, 100)
	playsound(src, 'sound/effects/bubbles.ogg', 50, 1)
	qdel(src)


// The opposite, makes the slime more likely to mutate.
/obj/item/slimepotion/mutator
	name = "slime mutator agent"
	desc = "A potent chemical mix that will increase the chance of a slime mutating."
	description_info = "The slime needs to be alive for this to work.  It will increase the chances of mutation by 12%."
	icon_state = "potred"

/obj/item/slimepotion/mutator/attack(mob/living/simple_animal/slime/M, mob/user)
	if(!istype(M))
		to_chat(user, "<span class='warning'>The mutator only works on slimes!</span>")
		return ..()
	if(M.stat == DEAD)
		to_chat(user, "<span class='warning'>The slime is dead!</span>")
		return ..()
	if(M.mutation_chance == 100)
		to_chat(user, "<span class='warning'>The slime is already guaranteed to mutate!</span>")
		return ..()

	to_chat(user, "<span class='notice'>You feed the slime the mutator. It is now more likely to mutate.</span>")
	M.mutation_chance = between(0, M.mutation_chance + 12, 100)
	playsound(src, 'sound/effects/bubbles.ogg', 50, 1)
	qdel(src)


// Makes the slime friendly forever.
/obj/item/slimepotion/docility
	name = "docility agent"
	desc = "A potent chemical mix that nullifies a slime's hunger, causing it to become docile and tame.  It might also work on other creatures?"
	icon_state = "potlightpink"
	description_info = "The target needs to be alive, not already passive, and have animal-like intelligence."

/obj/item/slimepotion/docility/attack(mob/living/simple_animal/M, mob/user)
	if(!istype(M))
		to_chat(user, "<span class='warning'>The agent only works on creatures!</span>")
		return ..()
	if(M.stat == DEAD)
		to_chat(user, "<span class='warning'>\The [M] is dead!</span>")
		return ..()

	// Slimes.
	if(istype(M, /mob/living/simple_animal/slime))
		var/mob/living/simple_animal/slime/S = M
		if(S.docile)
			to_chat(user, "<span class='warning'>The slime is already docile!</span>")
			return ..()

		S.pacify()
		S.nutrition = 700
		to_chat(M, "<span class='warning'>You absorb the agent and feel your intense desire to feed melt away.</span>")
		to_chat(user, "<span class='notice'>You feed the slime the agent, removing its hunger and calming it.</span>")

	// Simple Animals.
	else if(istype(M, /mob/living/simple_animal))
		var/mob/living/simple_animal/SA = M
		if(SA.intelligence_level > SA_ANIMAL) // So you can't use this on Russians/syndies/hivebots/etc.
			to_chat(user, "<span class='warning'>\The [SA] is too intellient for this to affect them.</span>")
			return ..()
		if(!SA.hostile)
			to_chat(user, "<span class='warning'>\The [SA] is already passive!</span>")
			return ..()

		SA.hostile = FALSE
		to_chat(M, "<span class='warning'>You consume the agent and feel a serene sense of peace.</span>")
		to_chat(user, "<span class='notice'>You feed \the [SA] the agent, calming it.</span>")

	playsound(src, 'sound/effects/bubbles.ogg', 50, 1)
	M.LoseTarget() // So hostile things stop attacking people even if not hostile anymore.
	var/newname = copytext(sanitize(input(user, "Would you like to give \the [M] a name?", "Name your new pet", M.name) as null|text),1,MAX_NAME_LEN)

	if(newname)
		M.name = newname
		M.real_name = newname
	qdel(src)


// Makes slimes make more extracts.
/obj/item/slimepotion/steroid
	name = "slime steroid agent"
	desc = "A potent chemical mix that will increase the amount of extracts obtained from harvesting a slime."
	description_info = "The slime needs to be alive and not an adult for this to work.  It will increase the amount of extracts gained by one, up to a max of five per slime.  \
	Extra extracts are not passed down to offspring when reproducing."
	icon_state = "potpurple"

/obj/item/slimepotion/steroid/attack(mob/living/simple_animal/slime/M, mob/user)
	if(!istype(M))
		to_chat(user, "<span class='warning'>The steroid only works on slimes!</span>")
		return ..()
	if(M.stat == DEAD)
		to_chat(user, "<span class='warning'>The slime is dead!</span>")
		return ..()
	if(M.is_adult) //Can't steroidify adults
		to_chat(user, "<span class='warning'>Only baby slimes can use the steroid!</span>")
		return ..()
	if(M.cores >= 5)
		to_chat(user, "<span class='warning'>The slime already has the maximum amount of extract!</span>")
		return ..()

	to_chat(user, "<span class='notice'>You feed the slime the steroid. It will now produce one more extract.</span>")
	M.cores++
	playsound(src, 'sound/effects/bubbles.ogg', 50, 1)
	qdel(src)


// Makes slimes not try to murder other slime colors.
/obj/item/slimepotion/unity
	name = "slime unity agent"
	desc = "A potent chemical mix that makes the slime feel and be seen as all the colors at once, and as a result not be considered an enemy to any other color."
	description_info = "The slime needs to be alive for this to work.  Slimes unified will not attack or be attacked by other colored slimes, and this will \
	carry over to offspring when reproducing."
	icon_state = "potpink"

/obj/item/slimepotion/unity/attack(mob/living/simple_animal/slime/M, mob/user)
	if(!istype(M))
		to_chat(user, "<span class='warning'>The agent only works on slimes!</span>")
		return ..()
	if(M.stat == DEAD)
		to_chat(user, "<span class='warning'>The slime is dead!</span>")
		return ..()
	if(M.unity == TRUE)
		to_chat(user, "<span class='warning'>The slime is already unified!</span>")
		return ..()

	to_chat(user, "<span class='notice'>You feed the slime the agent. It will now be friendly to all other slimes.</span>")
	to_chat(M, "<span class='notice'>\The [user] feeds you \the [src], and you suspect that all the other slimes will be \
	your friends, at least if you don't attack them first.</span>")
	M.unify()
	playsound(src, 'sound/effects/bubbles.ogg', 50, 1)
	qdel(src)

// Makes slimes not kill (most) humanoids but still fight spiders/carp/bears/etc.
/obj/item/slimepotion/loyalty
	name = "slime loyalty agent"
	desc = "A potent chemical mix that makes an animal deeply loyal to the species of whoever applies this, and will attack threats to them."
	description_info = "The slime or other animal needs to be alive for this to work.  The slime this is applied to will have their 'faction' change to \
	the user's faction, which means the slime will attack things that are hostile to the user's faction, such as carp, spiders, and other slimes."
	icon_state = "potred"

/obj/item/slimepotion/loyalty/attack(mob/living/simple_animal/M, mob/user)
	if(!istype(M))
		to_chat(user, "<span class='warning'>The agent only works on animals!</span>")
		return ..()
	if(M.intelligence_level > SA_ANIMAL) // So you can't use this on Russians/syndies/hivebots/etc.
		to_chat(user, "<span class='warning'>\The [M] is too intellient for this to affect them.</span>")
		return ..()
	if(M.stat == DEAD)
		to_chat(user, "<span class='warning'>The animal is dead!</span>")
		return ..()
	if(M.faction == user.faction)
		to_chat(user, "<span class='warning'>\The [M] is already loyal to your species!</span>")
		return ..()

	to_chat(user, "<span class='notice'>You feed \the [M] the agent. It will now try to murder things that want to murder you instead.</span>")
	to_chat(M, "<span class='notice'>\The [user] feeds you \the [src], and feel that the others will regard you as an outsider now.</span>")
	M.faction = user.faction
	M.attack_same = FALSE
	M.LoseTarget() // So hostile things stop attacking people even if not hostile anymore.
	playsound(src, 'sound/effects/bubbles.ogg', 50, 1)
	qdel(src)


// User befriends the slime with this.
/obj/item/slimepotion/friendship
	name = "slime friendship agent"
	desc = "A potent chemical mix that makes an animal deeply loyal to the the specific entity which feeds them this agent."
	description_info = "The slime or other animal needs to be alive for this to work.  The slime this is applied to will consider the user \
	their 'friend', and will never attack them.  This might also work on other things besides slimes."
	icon_state = "potlightpink"

/obj/item/slimepotion/friendship/attack(mob/living/simple_animal/M, mob/user)
	if(!istype(M))
		to_chat(user, "<span class='warning'>The agent only works on animals!</span>")
		return ..()
	if(M.intelligence_level > SA_ANIMAL) // So you can't use this on Russians/syndies/hivebots/etc.
		to_chat(user, "<span class='warning'>\The [M] is too intellient for this to affect them.</span>")
		return ..()
	if(M.stat == DEAD)
		to_chat(user, "<span class='warning'>The animal is dead!</span>")
		return ..()
	if(user in M.friends)
		to_chat(user, "<span class='warning'>\The [M] is already loyal to you!</span>")
		return ..()

	to_chat(user, "<span class='notice'>You feed \the [M] the agent. It will now be your best friend.</span>")
	to_chat(M, "<span class='notice'>\The [user] feeds you \the [src], and feel that \the [user] wants to be best friends with you.</span>")
	if(isslime(M))
		var/mob/living/simple_animal/slime/S = M
		S.befriend(user)
	else
		M.friends.Add(user)
	M.LoseTarget() // So hostile things stop attacking people even if not hostile anymore.
	playsound(src, 'sound/effects/bubbles.ogg', 50, 1)
	qdel(src)


// Feeds the slime instantly.
/obj/item/slimepotion/feeding
	name = "slime feeding agent"
	desc = "A potent chemical mix that will instantly sediate the slime."
	description_info = "The slime needs to be alive for this to work.  It will instantly grow the slime enough to reproduce."
	icon_state = "potyellow"

/obj/item/slimepotion/feeding/attack(mob/living/simple_animal/slime/M, mob/user)
	if(!istype(M))
		to_chat(user, "<span class='warning'>The mutator only works on slimes!</span>")
		return ..()
	if(M.stat == DEAD)
		to_chat(user, "<span class='warning'>The slime is dead!</span>")
		return ..()

	to_chat(user, "<span class='notice'>You feed the slime the feeding agent. It will now instantly reproduce.</span>")
	M.make_adult()
	M.amount_grown = 10
	M.reproduce()
	playsound(src, 'sound/effects/bubbles.ogg', 50, 1)
	qdel(src)


// Slime cube lives here.  Makes Prometheans.
/obj/item/slime_cube
	name = "slimy monkey cube"
	desc = "Wonder what might come out of this."
	icon = 'icons/mob/slime2.dmi'
	icon_state = "slime cube"
	description_info = "Use in your hand to attempt to create a Promethean.  It functions similarly to a positronic brain, in that a ghost is needed to become the Promethean."
	var/searching = 0

/obj/item/slime_cube/attack_self(mob/user as mob)
	if(!searching)
		user << "<span class='warning'>You stare at the slimy cube, watching as some activity occurs.</span>"
		icon_state = "slime cube active"
		searching = 1
		request_player()
		spawn(60 SECONDS)
			reset_search()

// Sometime down the road it would be great to make all of these 'ask ghosts if they want to be X' procs into a generic datum.
/obj/item/slime_cube/proc/request_player()
	for(var/mob/observer/dead/O in player_list)
		if(!O.MayRespawn())
			continue
		if(O.client)
			if(O.client.prefs.be_special & BE_ALIEN)
				question(O.client)

/obj/item/slime_cube/proc/question(var/client/C)
	spawn(0)
		if(!C)
			return
		var/response = alert(C, "Someone is requesting a soul for a promethean. Would you like to play as one?", "Promethean request", "Yes", "No", "Never for this round")
		if(response == "Yes")
			response = alert(C, "Are you sure you want to play as a promethean?", "Promethean request", "Yes", "No")
		if(!C || 2 == searching)
			return //handle logouts that happen whilst the alert is waiting for a response, and responses issued after a brain has been located.
		if(response == "Yes")
			transfer_personality(C.mob)
		else if(response == "Never for this round")
			C.prefs.be_special ^= BE_ALIEN

/obj/item/slime_cube/proc/reset_search() //We give the players sixty seconds to decide, then reset the timer.
	icon_state = "slime cube"
	if(searching == 1)
		searching = 0
		var/turf/T = get_turf_or_move(src.loc)
		for (var/mob/M in viewers(T))
			M.show_message("<span class='warning'>The activity in the cube dies down. Maybe it will spark another time.</span>")

/obj/item/slime_cube/proc/transfer_personality(var/mob/candidate)
	announce_ghost_joinleave(candidate, 0, "They are a promethean now.")
	src.searching = 2
	var/mob/living/carbon/human/S = new(get_turf(src))
	S.client = candidate.client
	to_chat(S, "<b>You are a promethean, brought into existence on [station_name()].</b>")
	S.mind.assigned_role = "Promethean"
	S.set_species("Promethean")
	S.shapeshifter_set_colour("#2398FF")
	visible_message("<span class='warning'>The monkey cube suddenly takes the shape of a humanoid!</span>")
	var/newname = sanitize(input(S, "You are a Promethean. Would you like to change your name to something else?", "Name change") as null|text, MAX_NAME_LEN)
	if(newname)
		S.real_name = newname
		S.name = S.real_name
		S.dna.real_name = newname
	if(S.mind)
		S.mind.name = S.name
	qdel(src)



// More or less functionally identical to the telecrystal tele.
/obj/item/slime_crystal
	name = "lesser slime cystal"
	desc = "A small, gooy crystal."
	description_info = "This will teleport you to a mostly 'safe' tile when used in-hand, consuming the slime crystal.  \
	It can also teleport someone else, by throwing it at them or attacking them with it."
	icon = 'icons/obj/objects.dmi'
	icon_state = "slime_crystal_small"
	w_class = ITEMSIZE_TINY
	origin_tech = list(TECH_MAGNETS = 6, TECH_BLUESPACE = 3)
	force = 1 //Needs a token force to ensure you can attack because for some reason you can't attack with 0 force things

/obj/item/slime_crystal/apply_hit_effect(mob/living/target, mob/living/user, var/hit_zone)
	target.visible_message("<span class='warning'>\The [target] has been teleported with \the [src] by \the [user]!</span>")
	safe_blink(target, 14)
	qdel(src)

/obj/item/slime_crystal/attack_self(mob/user)
	user.visible_message("<span class='warning'>\The [user] teleports themselves with \the [src]!</span>")
	safe_blink(user, 14)
	qdel(src)

/obj/item/slime_crystal/throw_impact(atom/movable/AM)
	if(!istype(AM))
		return

	if(AM.anchored)
		return

	AM.visible_message("<span class='warning'>\The [AM] has been teleported with \the [src]!</span>")
	safe_blink(AM, 14)
	qdel(src)

/obj/item/weapon/disposable_teleporter/slime
	name = "greater slime crystal"
	desc = "A larger, gooier crystal."
	description_info = "This will teleport you to a specific area once, when used in-hand."
	icon = 'icons/obj/objects.dmi'
	icon_state = "slime_crystal_large"
	uses = 1
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_MAGNETS = 5, TECH_BLUESPACE = 4)



// Very filling food.
/obj/item/weapon/reagent_containers/food/snacks/slime
	name = "slimy clump"
	desc = "A glob of slime that is thick as honey.  For the brave Xenobiologist."
	icon_state = "honeycomb"
	filling_color = "#FFBB00"
	center_of_mass = list("x"=17, "y"=10)
	nutriment_amt = 25 // Very filling.
	nutriment_desc = list("slime" = 10, "sweetness" = 10, "bliss" = 5)

/obj/item/weapon/reagent_containers/food/snacks/slime/New()
	..()
	bitesize = 5
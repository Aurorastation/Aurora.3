#define MAX_STAGES 3

/obj/machinery/antibody_extractor
	name = "antibody extractor"
	desc = "A machine made to extract antibodies. There's a holographic info-label on it..."
	desc_extended = "This machine is made to extract antibodies from a subject. It will only work with the <b>unmutated, original</b> version of the virus. \
					<span class='danger'>This machine will immediately notify the entire facility if used without authorization.</span>"
	icon = 'icons/obj/raccoon_city/extractor.dmi'
	icon_state = "extractor"
	var/working = FALSE
	var/stage = 0
	var/stage_counter = 0
	var/stage_threshold = 100

	var/mob/living/carbon/human/intended_target
	var/mob/living/carbon/human/occupant

/obj/machinery/antibody_extractor/Destroy()
	intended_target = null
	occupant = null
	return ..()

/obj/machinery/antibody_extractor/attack_hand(mob/user)
	if(user == occupant)
		to_chat(user, SPAN_WARNING("You can't activate the extractor from there!"))
		return FALSE

	if(user.use_check_and_message())
		return FALSE

	if(occupant)
		var/time_to_die = tgui_alert(user, "Are you sure?", "Begin Antibody Creation", list("Yes", "No"))
		if(time_to_die == "Yes")
			user.visible_message(SPAN_WARNING("[user] starts fiddling with \the [src]'s controls..."))
			if(do_after(user, 5 SECONDS, src))
				user.visible_message(SPAN_WARNING(FONT_HUGE("[user] activates \the [src] as it begins rumbling!")))
				working = TRUE
				stage = 1
				to_chat(occupant, SPAN_CULT(FONT_HUGE("You are locked by bindings into \the [src] and your arm is stabbed by a needle!")))
				to_world(SPAN_DANGER(FONT_HUGE("A loud alarm echoes from inside the Einstein laboratory, along with converging undead screaming...")))
				sound_to(world, sound('sound/items/raccoon_city/umbrella_alarm.ogg'))

/obj/machinery/antibody_extractor/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(!working)
		. += "It's inactive, and beeping ominously every now and then."
	switch(stage)
		if(1)
			. += SPAN_WARNING("It's sucking dark, almost black blood, from the arm of [occupant] into a container.")
		if(2)
			. += SPAN_DANGER("More and more dark, black blood is being collected and centrifuged.")
		if(3)
			. += SPAN_CULT("The dark, black blood is slowly being treated and filtered into a shiny, white substance...")

/obj/machinery/antibody_extractor/process()
	if(working)
		icon_state = "extractor-active"
		if(stage < MAX_STAGES+1)
			if(stage_counter > stage*stage_threshold)
				stage++
			stage_counter += 10

			switch(stage)
				if(1)
					if(prob(5))
						to_chat(occupant, SPAN_DANGER(FONT_HUGE("The blood is being sucked out of you - the pain is unbearable!")))
						occupant.adjustHalLoss(10)
						occupant.emote("whimper")
				if(2)
					if(prob(5))
						to_chat(occupant, SPAN_DANGER(FONT_HUGE("Your arm feels like it's being torn apart as the needle digs further and further inside!")))
						occupant.adjustHalLoss(20)
						occupant.emote("scream")
				if(3)
					if(prob(5))
						to_chat(occupant, SPAN_DANGER(FONT_HUGE("You feel like you're going to die any second now!")))
						occupant.adjustHalLoss(30)
						occupant.emote("scream")
		else
			if(occupant)
				visible_message(SPAN_CULT(FONT_HUGE("\The [src] finishes working and, with a click, releases [occupant] from their bindings. It helpfully dispenses \
								a vial of shining white liquid...")))
				new /obj/item/reagent_containers/glass/beaker/vial/antidote(get_turf(src))
			working = FALSE
			stage = 0
			stage_counter = 0
			icon_state = "extractor"

/obj/machinery/antibody_extractor/ex_act(severity)
	return

/obj/machinery/antibody_extractor/verb/move_inside()
	set src in oview(1)
	set category = "Object"
	set name = "Enter Extractor"

	if (usr.stat != CONSCIOUS)
		return
	if (occupant)
		to_chat(usr, SPAN_WARNING("Someone is already on the extractor!"))
		return
	usr.pulling = null
	usr.client.perspective = EYE_PERSPECTIVE
	usr.client.eye = src
	usr.forceMove(src)
	occupant = usr
	update_use_power(POWER_USE_ACTIVE)
	update_icon()
	add_fingerprint(usr)

/obj/machinery/antibody_extractor/verb/eject()
	set src in oview(1)
	set category = "Object"
	set name = "Unbuckle Patient"

	if (usr.stat != CONSCIOUS)
		return

	if(working)
		to_chat(usr, SPAN_WARNING("The bindings are keeping [occupant] in place!"))
		return

	go_out()
	add_fingerprint(usr)
	return

/obj/machinery/antibody_extractor/proc/go_out()
	if(!occupant)
		return

	if(working)
		return

	if (occupant.client)
		occupant.client.eye = occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE
	occupant.forceMove(loc)
	occupant = null
	update_use_power(POWER_USE_IDLE)
	update_icon()

/obj/machinery/antibody_extractor/relaymove(mob/user as mob)
	if (user.stat)
		return
	if(working)
		to_chat(user, SPAN_DANGER("The bindings are keeping you locked in place!"))
		return
	go_out()

/obj/machinery/antibody_extractor/attackby(obj/item/attacking_item, mob/user)
	var/obj/item/grab/G = attacking_item
	if (!istype(G, /obj/item/grab) || !isliving(G.affecting) )
		return
	if (occupant)
		to_chat(user, SPAN_WARNING("The extractor is already occupied!"))
		return TRUE

	var/mob/living/M = G.affecting
	var/bucklestatus = M.bucklecheck(user)
	if (!bucklestatus)
		return TRUE

	user.visible_message(SPAN_NOTICE("\The [user] starts buckling \the [M] to \the [src]."), SPAN_NOTICE("You start buckling \the [M] to \the [src]."), range = 3)
	if (do_mob(user, G.affecting, 30, needhand = 0))
		if (M.client)
			M.client.perspective = EYE_PERSPECTIVE
			M.client.eye = src

		M.forceMove(src)
		occupant = M
		update_use_power(POWER_USE_ACTIVE)
		update_icon()
	add_fingerprint(user)
	qdel(G)

/obj/machinery/antibody_extractor/MouseDrop_T(atom/dropping, mob/user)
	if(!istype(user))
		return

	if(!ismob(dropping))
		return

	if (occupant)
		to_chat(user, SPAN_WARNING("The extractor is already occupied!"))
		return

	var/mob/living/L = dropping
	var/bucklestatus = L.bucklecheck(user)
	if (!bucklestatus)
		return

	if(L == user)
		user.visible_message("\The <b>[user]</b> starts buckling to \the [src].", SPAN_NOTICE("You start buckling to \the [src]."), range = 3)
	else
		user.visible_message("\The <b>[user]</b> starts buckling \the [L] to \the [src].", SPAN_NOTICE("You start buckling \the [L] to \the [src]."), range = 3)

	if (do_mob(user, L, 30, needhand = 0))
		if (bucklestatus == 2)
			var/obj/structure/LB = L.buckled_to
			LB.user_unbuckle(user)
		if (L.client)
			L.client.perspective = EYE_PERSPECTIVE
			L.client.eye = src
		L.forceMove(src)
		occupant = L
		update_use_power(POWER_USE_ACTIVE)
		update_icon()
	add_fingerprint(user)

#undef MAX_STAGES

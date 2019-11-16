var/list/ventcrawl_machinery = list(
	/obj/machinery/atmospherics/unary/vent_pump,
	/obj/machinery/atmospherics/unary/vent_scrubber
	)

// Vent crawling whitelisted items, whoo
var/global/list/can_enter_vent_with = list(
	/obj/item/device/mmi,
	/obj/item/implant,
	/obj/item/device/radio/borg,
	/obj/item/holder,
	/obj/machinery/camera,
	/mob/living/simple_animal/borer,
	/mob/living/simple_animal/rat
	)

/mob/living/var/list/icon/pipes_shown = list()
/mob/living/var/last_played_vent
/mob/living/var/is_ventcrawling = 0
/mob/living/var/next_play_vent = 0

/mob/living/proc/can_ventcrawl()
	return 0

/mob/living/Login()
	. = ..()
	//login during ventcrawl
	if(is_ventcrawling && istype(loc, /obj/machinery/atmospherics)) //attach us back into the pipes
		remove_ventcrawl()
		add_ventcrawl(loc)

/mob/living/carbon/slime/can_ventcrawl()
	if(Victim)
		to_chat(src, "<span class='warning'>You cannot ventcrawl while feeding.</span>")
		return 0
	return 1

/mob/living/proc/is_allowed_vent_crawl_item(var/obj/item/carried_item)
	if(is_type_in_list(carried_item, can_enter_vent_with))
		return !get_inventory_slot(carried_item)

/mob/living/carbon/is_allowed_vent_crawl_item(var/obj/item/carried_item)
	if(carried_item in internal_organs)
		return 1
	return ..()

/mob/living/carbon/human/is_allowed_vent_crawl_item(var/obj/item/carried_item)
	if(carried_item in organs)
		return 1
	return ..()

/mob/living/simple_animal/spiderbot/is_allowed_vent_crawl_item(var/obj/item/carried_item)
	if(carried_item == held_item)
		return 1
	return ..()

/mob/living/proc/ventcrawl_carry()
	for(var/atom/A in src.contents)
		if(!is_allowed_vent_crawl_item(A))
			to_chat(src, "<span class='warning'>You can't be carrying that when vent crawling!</span>")
			return 0
	return 1

/obj/machinery/atmospherics/AltClick(mob/living/user)
	if(is_type_in_list(src, ventcrawl_machinery) && user.can_ventcrawl())
		user.handle_ventcrawl(src)
		return 1
	return ..()

/mob/living/carbon/human/can_ventcrawl()
	return issmall(src)

/mob/proc/start_ventcrawl()
	var/atom/pipe
	var/list/pipes = list()
	for(var/obj/machinery/atmospherics/unary/U in range(1))
		if(is_type_in_list(U,ventcrawl_machinery) && Adjacent(U))
			pipes |= U
	if(!pipes || !pipes.len)
		to_chat(usr, "<span class='notice'>There are no pipes that you can ventcrawl into within range!</span>")
		return
	if(pipes.len == 1)
		pipe = pipes[1]
	else
		pipe = input("Crawl Through Vent", "Pick a pipe") as null|anything in pipes
	if(canmove && pipe)
		return pipe

/mob/living/carbon/slime/can_ventcrawl()
	return 1

/mob/living/simple_animal/borer/can_ventcrawl()
	return 1

/mob/living/simple_animal/borer/ventcrawl_carry()
	return 1

/mob/living/simple_animal/rat/can_ventcrawl()
	return 1

/mob/living/simple_animal/spiderbot/can_ventcrawl()
	return 1

/mob/living/carbon/alien/can_ventcrawl()
	return 1

/mob/living/carbon/alien/ventcrawl_carry()
	return 1

/mob/living/proc/size_to_crawldelay(var/size)
	var/delayticks = size * 3
	return delayticks >= 3 ? delayticks : 3

/mob/living/proc/vent_trap_check(var/status, var/atom/location)
	switch (status)
		if ("departing")
			for (var/obj/item/device/assembly/mousetrap/S in location.loc)
				if (prob(25))
					visible_message("<span class='danger'>[src] gets caught in the mousetrap while trying to crawl into the vent!</span>", "<span class='danger'>You get caught in the mousetrap while trying to crawl into the vent!</span>")
					S.Crossed(src) // Triggers mousetrap
					forceMove(location.loc)
		if ("arriving")
			for (var/obj/item/device/assembly/mousetrap/S in location.loc)
				if (prob(75))
					S.Crossed(src) // Triggers mousetrap
		else
			return

/mob/living/var/ventcrawl_layer = 3

/mob/living/proc/handle_ventcrawl(var/atom/clicked_on)

	if(!stat)
		if(!lying)

			var/obj/machinery/atmospherics/unary/vent_found

			if(clicked_on)
				if (Adjacent(clicked_on))
					vent_found = clicked_on
					if(!is_type_in_list(vent_found, ventcrawl_machinery) || !vent_found.can_crawl_through())
						vent_found = null
				else
					to_chat(src, "<span class='warning'>Stand next to the selected vent!</span>")
					return

			if(!vent_found && isnull(clicked_on))
				for(var/obj/machinery/atmospherics/machine in range(1,src))
					if(is_type_in_list(machine, ventcrawl_machinery))
						vent_found = machine

					if(!vent_found || !vent_found.can_crawl_through())
						vent_found = null

					if(vent_found)
						break

			if(vent_found:is_welded()) // welded check
				to_chat(src, "<span class='warning'>You can't crawl into a welded vent!</span>")
				return

			vent_trap_check("departing", vent_found)

			if(vent_found)
				if(vent_found.network && (vent_found.network.normal_members.len || vent_found.network.line_members.len))

					visible_message("<span class='warning'>[src] begins to climb into the ventilation system!</span>","<span class='notice'>You begin climbing into the ventilation system...</span>")
					if(vent_found.air_contents && !issilicon(src))

						switch(vent_found.air_contents.temperature)
							if(0 to BODYTEMP_COLD_DAMAGE_LIMIT)
								to_chat(src, "<span class='danger'>You feel a painful freeze coming from the vent!</span>")
							if(BODYTEMP_COLD_DAMAGE_LIMIT to T0C)
								to_chat(src, "<span class='warning'>You feel an icy chill coming from the vent.</span>")
							if(T0C + 40 to BODYTEMP_HEAT_DAMAGE_LIMIT)
								to_chat(src, "<span class='warning'>You feel a hot wash coming from the vent.</span>")
							if(BODYTEMP_HEAT_DAMAGE_LIMIT to INFINITY)
								to_chat(src, "<span class='danger'>You feel a searing heat coming from the vent!</span>")

						switch(vent_found.air_contents.return_pressure())
							if(0 to HAZARD_LOW_PRESSURE)
								to_chat(src, "<span class='danger'>You feel a rushing draw pulling you into the vent!</span>")
							if(HAZARD_LOW_PRESSURE to WARNING_LOW_PRESSURE)
								to_chat(src, "<span class='warning'>You feel a strong drag pulling you into the vent.</span>")
							if(WARNING_HIGH_PRESSURE to HAZARD_HIGH_PRESSURE)
								to_chat(src, "<span class='warning'>You feel a strong current pushing you away from the vent.</span>")
							if(HAZARD_HIGH_PRESSURE to INFINITY)
								to_chat(src, "<span class='danger'>You feel a roaring wind pushing you away from the vent!</span>")

					if(!do_mob(src, vent_found, mob_size ? size_to_crawldelay(mob_size) : size_to_crawldelay(15), 1, 1))
						return

					if(!client)
						return

					if(!ventcrawl_carry())
						return

					visible_message("<B>[src] scrambles into the ventilation ducts!</B>", "You climb into the ventilation system.")

					forceMove(vent_found)
					add_ventcrawl(vent_found.node)
					sight = (SEE_TURFS|BLIND)

				else
					to_chat(src, "<span class='notice'>This vent is not connected to anything.</span>")

			else
				to_chat(src, "<span class='notice'>You must be standing on or beside an air vent to enter it.</span>")

		else
			to_chat(src, "<span class='notice'>You can't vent crawl while you're stunned!</span>")

	else
		to_chat(src, "<span class='notice'>You must be conscious to do this!</span>")
	return

/mob/living/proc/add_ventcrawl(obj/machinery/atmospherics/starting_machine)
	is_ventcrawling = 1
	//candrop = 0
	var/datum/pipe_network/network = starting_machine.return_network(starting_machine)
	if(!network)
		return
	for(var/datum/pipeline/pipeline in network.line_members)
		for(var/obj/machinery/atmospherics/A in (pipeline.members || pipeline.edges)) // Adds pipe and manifold images
			if(!A.pipe_image)
				A.pipe_image = image(A, A.loc, layer = 20, dir = A.dir)
			pipes_shown += A.pipe_image
			client.images += A.pipe_image
	for (var/obj/machinery/atmospherics/V in network.normal_members) // Adds vent and scrubber images
		if (!V.pipe_image || istype(V, /obj/machinery/atmospherics/unary/vent_pump/))
			V.pipe_image = image(V, V.loc, layer = 20, dir = V.dir)
		pipes_shown += V.pipe_image
		client.images += V.pipe_image

/mob/living/proc/remove_ventcrawl()
	is_ventcrawling = 0
	//candrop = 1
	if(client)
		for(var/image/current_image in pipes_shown)
			client.images -= current_image
		client.eye = src

	pipes_shown.len = 0

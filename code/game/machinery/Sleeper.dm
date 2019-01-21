/obj/machinery/sleeper
	name = "sleeper"
	desc = "A fancy bed with built-in injectors, a dialysis machine, and a limited health scanner."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "sleeper_0"
	density = 1
	anchored = 1
	var/mob/living/carbon/human/occupant = null
	var/list/available_chemicals = list("inaprovaline" = "Inaprovaline", "stoxin" = "Soporific", "paracetamol" = "Paracetamol", "anti_toxin" = "Dylovene", "dexalin" = "Dexalin")
	var/obj/item/weapon/reagent_containers/glass/beaker = null
	var/filtering = 0
	var/allow_occupant_types = list(/mob/living/carbon/human)
	var/disallow_occupant_types = list()

	use_power = 1
	idle_power_usage = 15
	active_power_usage = 200 //builtin health analyzer, dialysis machine, injectors.
	component_types = list(
			/obj/item/weapon/circuitboard/sleeper,
			/obj/item/weapon/stock_parts/capacitor = 2,
			/obj/item/weapon/stock_parts/scanning_module = 2,
			/obj/item/weapon/stock_parts/console_screen,
			/obj/item/weapon/reagent_containers/glass/beaker/large
		)
/obj/machinery/sleeper/Initialize()
	. = ..()
	update_icon()

/obj/machinery/sleeper/machinery_process()
	if(stat & (NOPOWER|BROKEN))
		return

	if(filtering > 0)
		if(beaker)
			if(beaker.reagents.total_volume < beaker.reagents.maximum_volume)
				var/pumped = 0
				for(var/datum/reagent/x in occupant.reagents.reagent_list)
					occupant.reagents.trans_to_obj(beaker, 3)
					pumped++
				if(ishuman(occupant))
					occupant.vessel.trans_to_obj(beaker, pumped + 1)
		else
			toggle_filter()

/obj/machinery/sleeper/update_icon()
	icon_state = "sleeper_[occupant ? "1" : "0"]"

/obj/machinery/sleeper/RefreshParts()
	..()
	var/scan_rating = 0
	var/cap_rating = 0

	for(var/obj/item/weapon/stock_parts/P in component_parts)
		if(isscanner(P))
			scan_rating += P.rating
		else if(iscapacitor(P))
			cap_rating += P.rating

	beaker = locate(/obj/item/weapon/reagent_containers/glass/beaker) in component_parts

	active_power_usage = 200 - (cap_rating + scan_rating)*2

/obj/machinery/sleeper/attack_hand(var/mob/user)
	if(..())
		return 1

	ui_interact(user)

/obj/machinery/sleeper/ui_interact(var/mob/user, var/ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = outside_state)
	var/data[0]

	data["power"] = stat & (NOPOWER|BROKEN) ? 0 : 1

	var/list/reagents = list()
	for(var/T in available_chemicals)
		var/list/reagent = list()
		reagent["id"] = T
		reagent["name"] = available_chemicals[T]
		if(occupant)
			reagent["amount"] = occupant.reagents.get_reagent_amount(T)
		reagents += list(reagent)
	data["reagents"] = reagents.Copy()

	if(occupant)
		data["occupant"] = 1
		switch(occupant.stat)
			if(CONSCIOUS)
				data["stat"] = "Conscious"
			if(UNCONSCIOUS)
				data["stat"] = "Unconscious"
			if(DEAD)
				data["stat"] = "<font color='red'>Dead</font>"
		data["health"] = occupant.health
		if(iscarbon(occupant))
			var/mob/living/carbon/C = occupant
			data["pulse"] = C.get_pulse(GETPULSE_TOOL)
		data["brute"] = occupant.getBruteLoss()
		data["burn"] = occupant.getFireLoss()
		data["oxy"] = occupant.getOxyLoss()
		data["tox"] = occupant.getToxLoss()
	else
		data["occupant"] = 0
	if(beaker)
		data["beaker"] = beaker.reagents.get_free_space()
	else
		data["beaker"] = -1
	data["filtering"] = filtering

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "sleeper.tmpl", "Sleeper UI", 600, 600, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

// #TODO-MERGE: Reimport Nanako's bucklesleeperBS
/obj/machinery/sleeper/Topic(href, href_list)
	if(..())
		return 1

	if(usr == occupant)
		usr << "<span class='warning'>You can't reach the controls from the inside.</span>"
		return

	add_fingerprint(usr)

	if(href_list["eject"])
		go_out()
	if(href_list["beaker"])
		remove_beaker()
	if(href_list["filter"])
		if(filtering != text2num(href_list["filter"]))
			toggle_filter()
	if(href_list["chemical"] && href_list["amount"])
		if(occupant && occupant.stat != DEAD)
			if(href_list["chemical"] in available_chemicals) // Your hacks are bad and you should feel bad
				inject_chemical(usr, href_list["chemical"], text2num(href_list["amount"]))

	return 1

/obj/machinery/sleeper/attack_ai(var/mob/user)
	return attack_hand(user)

/obj/machinery/sleeper/attackby(var/obj/item/I, var/mob/user)
	add_fingerprint(user)
	if(istype(I, /obj/item/weapon/reagent_containers/glass))
		if(!beaker)
			beaker = I
			user.drop_from_inventory(I,src)
			user.visible_message("<span class='notice'>\The [user] adds \a [I] to \the [src].</span>", "<span class='notice'>You add \a [I] to \the [src].</span>")
		else
			user << "<span class='warning'>\The [src] has a beaker already.</span>"
		return
	else if(istype(I, /obj/item/weapon/grab))

		var/obj/item/weapon/grab/G = I
		var/mob/living/L = G.affecting

		if(!istype(L))
			user << "<span class='warning'>\The machine won't accept that.</span>"
			return

		user.visible_message("<span class='notice'>[user] starts putting [G.affecting] into [src].</span>", "<span class='notice'>You start putting [G.affecting] into [src].</span>", range = 3)

		if (do_mob(user, G.affecting, 20, needhand = 0))
			if(occupant)
				user << "<span class='warning'>\The [src] is already occupied.</span>"
				return
			var/bucklestatus = L.bucklecheck(user)

			if (!bucklestatus)//incase the patient got buckled during the delay
				return
			if(L != G.affecting)//incase it isn't the same mob we started with
				return

			var/mob/M = G.affecting
			M.forceMove(src)
			update_use_power(2)
			occupant = M
			update_icon()
			qdel(G)
			return
	else if(isscrewdriver(I))
		user << "You [panel_open ? "open" : "close"] the maintenance panel."
		panel_open = !panel_open

	else if(default_part_replacement(user, I))
		return
/obj/machinery/sleeper/MouseDrop_T(var/mob/target, var/mob/user)
	if(user.stat || user.lying || !Adjacent(user) || !target.Adjacent(user)|| !ishuman(target))
		return
	go_in(target, user)

/obj/machinery/sleeper/relaymove(var/mob/user)
	..()
	go_out()

/obj/machinery/sleeper/emp_act(var/severity)
	if(filtering)
		toggle_filter()

	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return

	if(occupant)
		go_out()

	..(severity)
/obj/machinery/sleeper/proc/toggle_filter()
	if(!occupant || !beaker)
		filtering = 0
		return
	filtering = !filtering

/obj/machinery/sleeper/proc/go_in(var/mob/M, var/mob/user)
	if(!M)
		return
	if(stat & (BROKEN|NOPOWER))
		return
	if(occupant)
		user << "<span class='warning'>\The [src] is already occupied.</span>"
		return

	if(M == user)
		visible_message("\The [user] starts climbing into \the [src].")
	else
		visible_message("\The [user] starts putting [M] into \the [src].")

	if(do_after(user, 20))
		if(occupant)
			user << "<span class='warning'>\The [src] is already occupied.</span>"
			return
		M.stop_pulling()
		if(M.client)
			M.client.perspective = EYE_PERSPECTIVE
			M.client.eye = src
		M.forceMove(src)
		update_use_power(2)
		occupant = M
		update_icon()

/obj/machinery/sleeper/proc/go_out()
	if(!occupant)
		return
	if(occupant.client)
		occupant.client.eye = occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE
	occupant.forceMove(loc)
	occupant = null
	for(var/atom/movable/A in (contents - component_parts)) // In case an object was dropped inside or something
		if(A == beaker)
			continue
		A.forceMove(loc)
	update_use_power(1)
	update_icon()
	toggle_filter()

/obj/machinery/sleeper/proc/remove_beaker()
	if(beaker)
		beaker.forceMove(loc)
		beaker = null
		toggle_filter()

/obj/machinery/sleeper/proc/inject_chemical(var/mob/living/user, var/chemical, var/amount)
	if(stat & (BROKEN|NOPOWER))
		return

	if(occupant && occupant.reagents)
		if(occupant.reagents.get_reagent_amount(chemical) + amount <= 20)
			use_power(amount * CHEM_SYNTH_ENERGY)
			occupant.reagents.add_reagent(chemical, amount)
			user << "Occupant now has [occupant.reagents.get_reagent_amount(chemical)] units of [available_chemicals[chemical]] in their bloodstream."
		else
			user << "The subject has too many chemicals."
	else
		user << "There's no suitable occupant in \the [src]."

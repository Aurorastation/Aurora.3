/obj/machinery/sleeper
	name = "sleeper"
	desc = "A fancy bed with built-in injectors, a dialysis machine, and a limited health scanner."
	desc_info = "The sleeper allows you to clean the blood by means of dialysis, and to administer medication in a controlled environment.<br>\
	<br>\
	Click your target with Grab intent, then click on the sleeper to place them in it. Click the green console, with an empty hand, to open the menu. \
	Click 'Start Dialysis' to begin filtering unwanted chemicals from the occupant's blood. The beaker contained will begin to fill with their \
	contaminated blood, and will need to be emptied when full.<br>\
	<br>\
	You can also inject common medicines directly into their bloodstream.\
	<br>\
	Right-click the cell and click 'Eject Occupant' to remove them.  You can enter the cell yourself by right clicking and selecting 'Enter Sleeper'. \
	Note that you cannot control the sleeper while inside of it."
	icon = 'icons/obj/machinery/sleeper.dmi'
	icon_state = "sleeper"
	density = TRUE
	anchored = TRUE
	clicksound = 'sound/machines/buttonbeep.ogg'
	clickvol = 30

	var/mob/living/carbon/human/occupant = null
	var/list/available_chemicals = list(
		/singleton/reagent/inaprovaline,
		/singleton/reagent/soporific,
		/singleton/reagent/perconol,
		/singleton/reagent/dylovene,
		/singleton/reagent/dexalin,
		/singleton/reagent/tricordrazine
		)
	var/obj/item/reagent_containers/glass/beaker = null
	var/filtering = FALSE
	var/pump = FALSE
	var/list/stasis_settings = list(1, 2, 5, 10)
	var/stasis = 1
	var/allow_occupant_types = list(/mob/living/carbon/human)
	var/disallow_occupant_types = list()
	var/display_loading_message = TRUE

	idle_power_usage = 15
	active_power_usage = 250 //builtin health analyzer, dialysis machine, injectors.
	var/parts_power_usage
	var/stasis_power = 500

	component_types = list(
			/obj/item/circuitboard/sleeper,
			/obj/item/stock_parts/capacitor = 2,
			/obj/item/stock_parts/scanning_module = 2,
			/obj/item/stock_parts/console_screen,
			/obj/item/reagent_containers/glass/beaker/large
		)

/obj/machinery/sleeper/Initialize()
	. = ..()
	update_icon()
	parts_power_usage = active_power_usage

/obj/machinery/sleeper/process()
	if(stat & (NOPOWER|BROKEN))
		return

	if(filtering)
		if(beaker)
			if(beaker.reagents.total_volume < beaker.reagents.maximum_volume)
				var/pumped = 0
				for(var/_x in occupant.reagents.reagent_volumes)
					occupant.reagents.trans_to_obj(beaker, 3)
					pumped++
				if(ishuman(occupant))
					occupant.vessel.trans_to_obj(beaker, pumped + 1)
		else
			toggle_filter()
	if(pump)
		if(beaker && istype(occupant))
			if(beaker.reagents.total_volume < beaker.reagents.maximum_volume)
				var/datum/reagents/ingested = occupant.get_ingested_reagents()
				if(ingested)
					for(var/_x in ingested.reagent_volumes)
						ingested.trans_to_obj(beaker, 1)
		else
			toggle_pump()

	if(iscarbon(occupant) && stasis > 1)
		occupant.SetStasis(stasis)

/obj/machinery/sleeper/update_icon()
	flick("[initial(icon_state)]-anim", src)
	if(occupant)
		icon_state = "[initial(icon_state)]-closed"
		return
	else
		icon_state = initial(icon_state)

/obj/machinery/sleeper/RefreshParts()
	..()
	var/scan_rating = 0
	var/cap_rating = 0

	for(var/obj/item/stock_parts/P in component_parts)
		if(isscanner(P))
			scan_rating += P.rating
		else if(iscapacitor(P))
			cap_rating += P.rating

	beaker = locate(/obj/item/reagent_containers/glass/beaker) in component_parts

	change_power_consumption((initial(active_power_usage) - (cap_rating + scan_rating)*2), POWER_USE_ACTIVE)
	parts_power_usage = active_power_usage

/obj/machinery/sleeper/attack_hand(var/mob/user)
	if(..())
		return TRUE

	ui_interact(user)

/obj/machinery/sleeper/ui_interact(mob/user, var/datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Sleeper", "Sleeper", 450, 500)
		ui.open()

/obj/machinery/sleeper/ui_data(mob/user)
	var/list/data = list()
	data["power"] = stat & (NOPOWER|BROKEN) ? FALSE : TRUE

	if(occupant)
		data["occupant"] = TRUE
		data["stat"] = occupant.stat
		data["stasis"] = stasis
		data["species"] = occupant.get_species()
		data["brain_activity"] = occupant.get_brain_result()
		data["blood_pressure"] = occupant.get_blood_pressure()
		data["blood_pressure_level"] = occupant.get_blood_pressure_alert()
		data["blood_o2"] = occupant.get_blood_oxygenation()
		data["bloodreagents"] = list()
		var/list/blood_reagents = list()
		for(var/_R in occupant.reagents.reagent_volumes)
			var/list/blood_reagent = list()
			var/singleton/reagent/R = GET_SINGLETON(_R)
			blood_reagent["name"] = R.name
			blood_reagent["amount"] = round(REAGENT_VOLUME(occupant.reagents, _R), 0.1)
			LAZYADD(blood_reagents, list(blood_reagent))
		if(LAZYLEN(blood_reagents))
			data["bloodreagents"] = blood_reagents.Copy()
		data["hasstomach"] = FALSE
		data["stomachreagents"] = list()
		var/obj/item/organ/internal/stomach/S = occupant.internal_organs_by_name[BP_STOMACH]
		if(S)
			data["hasstomach"] = TRUE
			var/list/list/stomach_reagents
			for(var/_R in S.ingested.reagent_volumes)
				var/list/stomach_reagent = list()
				var/singleton/reagent/R = GET_SINGLETON(_R)
				stomach_reagent["name"] = R.name
				stomach_reagent["amount"] = round(REAGENT_VOLUME(S.ingested, _R), 0.1)
				LAZYADD(stomach_reagents, list(stomach_reagent))
			if(LAZYLEN(stomach_reagents))
				data["stomachreagents"] = stomach_reagents.Copy()
		if(ishuman(occupant))
			var/mob/living/carbon/human/H = occupant
			data["pulse"] = H.get_pulse(GETPULSE_TOOL)

		var/list/reagents = list()
		for(var/T in available_chemicals)
			var/list/reagent = list()
			reagent["type"] = T
			var/singleton/reagent/C = T
			reagent["name"] = initial(C.name)
			reagents += list(reagent)
		data["reagents"] = reagents.Copy()
		data["stasissettings"] = stasis_settings
	else
		data["occupant"] = FALSE
	if(beaker)
		data["beaker"] = TRUE
		data["beakerfreespace"] = REAGENTS_FREE_SPACE(beaker.reagents)
	else
		data["beaker"] = FALSE
	data["filtering"] = filtering
	data["pump"] = pump

	return data

/obj/machinery/sleeper/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	if(usr == occupant)
		to_chat(usr, SPAN_WARNING("You can't reach the controls from the inside."))
		return FALSE

	add_fingerprint(usr)

	switch(action)
		if("eject")
			go_out()
			. = TRUE
		if("beaker")
			remove_beaker()
			. = TRUE
		if("filter")
			toggle_filter()
			. = TRUE
		if("pump")
			toggle_pump()
			. = TRUE
		if("chemical")
			if(occupant?.stat != DEAD)
				var/chemical = text2path(params["chemical"])
				if(chemical in available_chemicals)
					inject_chemical(usr, chemical, text2num(params["amount"]))
					. = TRUE
		if("stasis")
			var/nstasis = text2num(params["stasis"])
			if(stasis != nstasis)
				stasis = text2num(params["stasis"])
				change_power_consumption(parts_power_usage + (stasis_power * (stasis-1)), POWER_USE_ACTIVE)
				. = TRUE

	return TRUE

/obj/machinery/sleeper/attack_ai(var/mob/user)
	if(!ai_can_interact(user))
		return
	return attack_hand(user)

/obj/machinery/sleeper/attackby(obj/item/attacking_item, mob/user)
	if(!istype(attacking_item, /obj/item/forensics))
		add_fingerprint(user)
	if(istype(attacking_item, /obj/item/reagent_containers/glass))
		if(!beaker)
			beaker = attacking_item
			user.drop_from_inventory(attacking_item, src)
			user.visible_message(SPAN_NOTICE("\The [user] adds \a [attacking_item] to \the [src]."),
									SPAN_NOTICE("You add \a [attacking_item] to \the [src]."))

		else
			to_chat(user, SPAN_WARNING("\The [src] has a beaker already."))
		return TRUE
	else if(istype(attacking_item, /obj/item/grab))

		var/obj/item/grab/G = attacking_item
		var/mob/living/L = G.affecting
		var/bucklestatus = L.bucklecheck(user)
		if(!bucklestatus)
			return TRUE

		if(!istype(L))
			to_chat(user, SPAN_WARNING("The machine won't accept that."))
			return TRUE

		if(display_loading_message)
			user.visible_message(SPAN_NOTICE("[user] starts putting [G.affecting] into [src]."),
									SPAN_NOTICE("You start putting [G.affecting] into [src]."), range = 3)

		if (do_mob(user, G.affecting, 20, needhand = 0))
			if(occupant)
				to_chat(user, SPAN_WARNING("\The [src] is already occupied."))
				return TRUE
			if(L != G.affecting)//incase it isn't the same mob we started with
				return TRUE

			var/mob/M = G.affecting
			M.forceMove(src)
			update_use_power(POWER_USE_ACTIVE)
			occupant = M
			update_icon()
			qdel(G)
		return TRUE
	else if(attacking_item.isscrewdriver())
		src.panel_open = !src.panel_open
		to_chat(user, "You [src.panel_open ? "open" : "close"] the maintenance panel.")
		ClearOverlays()
		if(src.panel_open)
			AddOverlays("[initial(icon_state)]-o")
		return TRUE
	else if(default_part_replacement(user, attacking_item))
		return TRUE

/obj/machinery/sleeper/mouse_drop_receive(atom/dropped, mob/user, params)
	var/mob/target = dropped
	if(!istype(target))
		return

	if(user.stat || user.lying || !Adjacent(user) || !target.Adjacent(user)|| !ishuman(target))
		return

	var/mob/living/L = target
	var/bucklestatus = L.bucklecheck(user)
	if(!bucklestatus)
		return
	if(bucklestatus == 2)
		var/obj/structure/LB = L.buckled_to
		LB.user_unbuckle(user)
	go_in(target, user)

/obj/machinery/sleeper/relaymove(mob/living/user, direction)
	. = ..()

	if(user == occupant)
		go_out()

/obj/machinery/sleeper/emp_act(severity)
	. = ..()

	if(filtering)
		toggle_filter()

	if(stat & (BROKEN|NOPOWER))
		return

	if(occupant)
		go_out()


/obj/machinery/sleeper/proc/toggle_filter()
	if(!occupant || !beaker)
		filtering = FALSE
		return
	filtering = !filtering

/obj/machinery/sleeper/proc/toggle_pump()
	if(!occupant || !beaker)
		pump = FALSE
		return
	pump = !pump
	if(pump)
		to_chat(occupant, SPAN_WARNING("You feel a tube jammed down your throat."))
	else
		to_chat(occupant, SPAN_WARNING("You feel the tube being pulled out of your throat."))

/obj/machinery/sleeper/proc/go_in(var/mob/M, var/mob/user)
	if(!M)
		return
	if(stat & (BROKEN|NOPOWER))
		return
	if(occupant)
		to_chat(user, SPAN_WARNING("\The [src] is already occupied."))
		return

	if(display_loading_message)
		if(M == user)
			visible_message("\The [user] starts climbing into \the [src].")
		else
			visible_message("\The [user] starts putting [M] into \the [src].")

	if(do_after(user, 2 SECONDS, src, DO_UNIQUE))
		if(occupant)
			to_chat(user, SPAN_WARNING("\The [src] is already occupied."))
			return
		M.stop_pulling()
		if(M.client)
			M.client.perspective = EYE_PERSPECTIVE
			M.client.eye = src
		M.forceMove(src)
		update_use_power(POWER_USE_ACTIVE)
		occupant = M
		update_icon()

/obj/machinery/sleeper/proc/go_out()
	if(!occupant)
		return
	if(occupant.client)
		occupant.client.eye = occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE
	occupant.forceMove(get_turf(src))
	occupant = null
	for(var/atom/movable/A in (contents - component_parts)) // In case an object was dropped inside or something
		if(A == beaker)
			continue
		A.forceMove(get_turf(src))
	update_use_power(POWER_USE_IDLE)
	update_icon()
	toggle_filter()
	toggle_pump()

/obj/machinery/sleeper/AltClick()
	if(use_check_and_message(usr))
		go_out()

/obj/machinery/sleeper/proc/remove_beaker()
	if(beaker)
		beaker.forceMove(get_turf(src))
		beaker = null
		toggle_filter()
		toggle_pump()

/obj/machinery/sleeper/proc/inject_chemical(var/mob/living/user, var/chemical, var/add_amount)
	if(stat & (BROKEN|NOPOWER))
		return

	if(occupant?.reagents)
		var/chemical_amount = REAGENT_VOLUME(occupant.reagents, chemical)
		var/is_dylo = ispath(chemical, /singleton/reagent/dylovene)
		var/is_inaprov = ispath(chemical, /singleton/reagent/inaprovaline)
		if(is_dylo || is_inaprov)
			var/dylo_amount = REAGENT_VOLUME(occupant.reagents, /singleton/reagent/dylovene)
			var/inaprov_amount = REAGENT_VOLUME(occupant.reagents, /singleton/reagent/inaprovaline)
			var/tricord_amount = REAGENT_VOLUME(occupant.reagents, /singleton/reagent/tricordrazine)
			if(tricord_amount > 20)
				if(is_dylo && inaprov_amount)
					to_chat(user, SPAN_WARNING("The subject has too much tricordrazine."))
					return
				if(is_inaprov && dylo_amount)
					to_chat(user, SPAN_WARNING("The subject has too much tricordrazine."))
					return
		if(chemical_amount + add_amount <= REAGENTS_OVERDOSE)
			use_power_oneoff(add_amount * CHEM_SYNTH_ENERGY)
			occupant.reagents.add_reagent(chemical, add_amount)
		else
			to_chat(user, SPAN_WARNING("The subject has too many chemicals."))
	else
		to_chat(user, SPAN_WARNING("There's no suitable occupant in \the [src]."))

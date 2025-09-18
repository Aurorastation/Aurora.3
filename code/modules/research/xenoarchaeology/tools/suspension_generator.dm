/obj/machinery/suspension_gen
	name = "suspension field generator"
	desc = "Multi-phase mobile suspension field generator MK III \"Stalwart\". It has stubby bolts up against its treads for stabilising."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "suspension_loose"
	density = TRUE
	obj_flags = OBJ_FLAG_ROTATABLE
	active_power_usage = 25

	var/open = FALSE
	var/screwed = TRUE
	var/field_type = "carbon"

	var/obj/item/cell/cell
	var/obj/effect/suspension_field/suspension_field

/obj/effect/suspension_field/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += SPAN_NOTICE("You can see something floating inside it:")
	. += SPAN_NOTICE(english_list(contents))

/obj/machinery/suspension_gen/Initialize()
	. = ..()
	cell = new /obj/item/cell/high(src)

/obj/machinery/suspension_gen/Destroy()
	deactivate()
	return ..()

/obj/machinery/suspension_gen/process()
	if(suspension_field)
		if(!cell.charge)
			deactivate()
			return
		if(suspension_field.victim_number)
			cell.use(active_power_usage * suspension_field.victim_number)

/obj/machinery/suspension_gen/attack_hand(mob/user)
	. = ..()
	if(.)
		return

	ui_interact(user)

/obj/machinery/suspension_gen/operable(additional_flags)
	if(stat & (BROKEN|additional_flags))
		return FALSE
	if(!cell.charge)
		return FALSE

	return TRUE

/obj/machinery/suspension_gen/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.isscrewdriver())
		if(!open)
			screwed = !screwed
			to_chat(user, SPAN_NOTICE("You [screwed ? "screw" : "unscrew"] the battery panel."))
			update_icon()
		else
			to_chat(user, SPAN_WARNING("\The [src]'s battery panel is open!"))
		return
	else if (attacking_item.iscrowbar())
		if(!screwed)
			if(!suspension_field)
				open = !open
				to_chat(user, SPAN_NOTICE("You crowbar the battery panel [open ? "open" : "in place"]."))
				update_icon()
			else
				to_chat(user, SPAN_WARNING("[src]'s safety locks are engaged, shut it down first."))
		else
			to_chat(user, SPAN_WARNING("Unscrew [src]'s battery panel first."))
	else if (attacking_item.iswrench())
		if(!suspension_field)
			anchored = !anchored
			to_chat(user, SPAN_NOTICE("You wrench the stabilising bolts [anchored ? "into place" : "loose"]."))
			playsound(loc, 'sound/items/wrench.ogg', 40)
			if(anchored)
				desc = "Multi-phase mobile suspension field generator MK III \"Stalwart\". It is firmly held in place by securing bolts."
			else
				desc = "Multi-phase mobile suspension field generator MK III \"Stalwart\". It has stubby bolts aligned along its track for stabilising."
			update_icon()
		else
			to_chat(user, SPAN_WARNING("You are unable to secure [src] while it is active!"))
	else if (istype(attacking_item, /obj/item/cell))
		if(open)
			if(cell)
				to_chat(user, SPAN_WARNING("There is a power cell already installed."))
			else
				user.drop_from_inventory(attacking_item, src)
				cell = attacking_item
				to_chat(user, SPAN_NOTICE("You insert the power cell."))
				update_icon()

/obj/machinery/suspension_gen/ui_interact(mob/user, var/datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SuspensionGenerator", "Suspension Field Generator", 400, 500)
		ui.open()

/obj/machinery/suspension_gen/ui_data(mob/user)
	var/list/data = list()

	data["charge"] = 0
	if(cell)
		data["charge"] = round(cell.percent())

	data["fieldtype"] = field_type

	data["fieldtypes"] = list(
		list("name" = "Diffracted Carbon Dioxide Laser", "type" = "carbon"),
		list("name" = "Potassium Refrigerant Cloud", "type" = "potassium"),
		list("name" = "Nitrogen Tracer Field", "type" = "nitrogen"),
		list("name" = "Mercury Dispersion Wave", "type" = "mercury"),
		list("name" = "Iron Wafer Conduction Field", "type" = "iron")
	)

	data["active"] = !!suspension_field
	data["anchored"] = anchored

	return data

/obj/machinery/suspension_gen/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	if(action == "togglefield")
		if(!anchored)
			return

		if(!suspension_field)
			var/obj/item/cell/cell = get_cell()
			if(cell?.charge > 0)
				if(anchored)
					activate()
		else
			deactivate()
		. = TRUE

	if(action == "fieldtype")
		field_type = params["fieldtype"]
		if(suspension_field)
			suspension_field.field_type = field_type
			. = TRUE

//checks for whether the machine can be activated or not should already have occurred by this point
/obj/machinery/suspension_gen/proc/activate()
	var/turf/T = get_turf(get_step(src,dir))
	suspension_field = new(T)
	suspension_field.field_type = field_type
	visible_message(SPAN_NOTICE("\The [src] activates with a soft beep."))
	playsound(loc, 'sound/machines/softbeep.ogg', 40)
	update_icon()
	START_PROCESSING(SSprocessing, src)

/obj/machinery/suspension_gen/proc/deactivate()
	STOP_PROCESSING(SSprocessing, src)
	visible_message(SPAN_NOTICE("\The [src] deactivates with a gentle shudder and a soft tone."))
	playsound(loc, 'sound/machines/softbeep.ogg', 40)
	QDEL_NULL(suspension_field)
	update_icon()

/obj/machinery/suspension_gen/update_icon()
	icon_state = "suspension_[anchored ? (suspension_field ? "on" : "wrenched") : "loose"]"
	if(!screwed)
		AddOverlays("suspension_panel")
	else
		CutOverlays("suspension_panel")

/obj/machinery/suspension_gen/get_cell()
	return cell

/obj/effect/suspension_field
	name = "energy field"
	icon = 'icons/effects/effects.dmi'
	anchored = TRUE
	density = TRUE

	var/field_type = "chlorine"
	var/victim_number  //number of mobs it affected, needed for generator powerdraw calc

/obj/effect/suspension_field/Initialize()
	. = ..()
	suspend_things()
	START_PROCESSING(SSprocessing, src)

/obj/effect/suspension_field/Destroy()
	for(var/mob/living/M in loc)
		to_chat(M, SPAN_NOTICE("You no longer feel like floating."))
	for(var/atom/movable/A in src)
		A.dropInto(loc)
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/effect/suspension_field/process()
	suspend_things()

/obj/effect/suspension_field/proc/suspend_things()
	victim_number = 0
	var/turf/T = get_turf(src)
	for(var/mob/living/M in T)
		if((isanimal(M) || iscarbon(M)) && field_type != "carbon")
			continue
		if(isrobot(M) && field_type != "iron")
			continue
		M.weakened = max(M.weakened, 3)
		victim_number++
		if(prob(5))
			to_chat(M, SPAN_WARNING("[pick("You feel tingly","You feel like floating","It is hard to speak","You can barely move")]."))
	for(var/obj/item/I in T)
		if(!I.anchored && I.simulated)
			I.forceMove(src)
	update_icon()

/obj/effect/suspension_field/update_icon()
	underlays.Cut()
	var/turf/T = get_turf(src)
	if(T.density)
		icon_state = "shield_normal"
	else
		icon_state = "shield2"
	if(length(contents))
		underlays += "energynet"


/// Simple access terminal.
/// Can put an ID in it, and set or unset some accesses.
/// Intended to be used in ooc/admin spaces, like antag/actor prep areas.
ABSTRACT_TYPE(/obj/machinery/computer/access_terminal)
	name = "self-service access terminal"
	desc = "A simple access terminal. It allows changing one's ID accesses."
	icon = 'icons/obj/computer.dmi'
	icon_state = "altcomputerw"
	light_color = LIGHT_COLOR_BLUE
	icon_screen = "guest"
	icon_scanline = "altcomputerw-scanline"
	density = FALSE
	appearance_flags = TILE_BOUND

	/// The ID card inserted into the terminal.
	var/obj/item/card/id/held_card

/obj/machinery/computer/access_terminal/Destroy()
	if (held_card)
		held_card.forceMove(loc)
		held_card = null
	return ..()

/// Should return a list of `/datum/access`.
/obj/machinery/computer/access_terminal/proc/get_available_accesses()
	. = list()

/obj/machinery/computer/access_terminal/attackby(obj/item/attacking_item, mob/user)
	var/obj/item/card/id/idcard = attacking_item
	if(!held_card && istype(idcard))
		usr.drop_from_inventory(idcard, user)
		held_card = idcard
		update_icon()

/obj/machinery/computer/access_terminal/attack_hand(mob/user)
	. = ..()
	ui_interact(user)

/obj/machinery/computer/access_terminal/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AccessTerminal", "Self-Service Access Terminal", 550, 650)
		ui.open()

/obj/machinery/computer/access_terminal/ui_data(mob/user)
	var/list/data = list()

	if(!istype(held_card))
		return data

	var/list/available_access_datums = get_available_accesses()
	var/list/available_accesses = list()
	for(var/datum/access/access_datum as anything in available_access_datums)
		available_accesses += list(list("desc"=access_datum::desc, "id"=access_datum::id))

	data["is_card_in"] = TRUE
	data["card_name"] = held_card.registered_name
	data["card_assignment"] = held_card.assignment
	data["card_rank"] = held_card.rank
	data["is_agent_id"] = istype(held_card, /obj/item/card/id/syndicate)
	data["available_accesses"] = available_accesses	// list("desc"="abcd", "id"=123)
	data["card_accesses"] = held_card.access		// list(123)

	return data

/obj/machinery/computer/access_terminal/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("toggle_access")
			if(held_card)
				held_card.access ^= list(text2num(params["toggle_access"]))
		if("insert_id")
			if(!held_card)
				var/obj/item/I = ui.user.get_active_hand()
				if (istype(I, /obj/item/card/id))
					ui.user.drop_from_inventory(I,src)
					held_card = I
		if("eject_id")
			if(held_card)
				held_card.forceMove(src.loc)
				if(!ui.user.get_active_hand())
					ui.user.put_in_hands(held_card)
				held_card = null

// ------------------------- subtypes

/// Odyssey subtype, that gets available accesses from the current odyssey scenario.
/obj/machinery/computer/access_terminal/odyssey
	name = "self-service actor access terminal"

/// Returns a list of paths of type `/datum/access/`.
/obj/machinery/computer/access_terminal/odyssey/get_available_accesses()
	. = SSodyssey.scenario.actor_accesses

/// Static access subtype, to be subtyped further while overriding the var, or to be mapped in with accesses.
/obj/machinery/computer/access_terminal/static_access
	var/list/datum/access/available_accesses = list()

/obj/machinery/computer/access_terminal/static_access/get_available_accesses()
	. = available_accesses

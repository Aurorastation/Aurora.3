/obj/machinery/chemical_dispenser
	name = "chemical dispenser"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "dispenser"
	var/icon_state_active = "dispenser_active"
	clicksound = /singleton/sound_category/button_sound

	obj_flags = OBJ_FLAG_ROTATABLE

	var/list/spawn_cartridges = null // Set to a list of types to spawn one of each on New()

	var/list/cartridges = list() // Associative, label -> cartridge
	var/obj/item/reagent_containers/container = null

	var/ui_title = "Chemical Dispenser"

	var/accept_drinking = 0
	var/amount = 30
	var/list/forbidden_containers = list(/obj/item/reagent_containers/glass/bucket) //For containers we don't want people to shove into the chem machine. Like big-ass buckets.
	var/list/drink_accepted = list(/obj/item/reagent_containers/food/drinks, /obj/item/reagent_containers/food/condiment) //Allow these cans/glasses/condiment bottles but forbid ACTUAL food.

	idle_power_usage = 100
	density = 1
	anchored = 1

/obj/machinery/chemical_dispenser/Initialize()
	. = ..()
	if(spawn_cartridges)
		for(var/type in spawn_cartridges)
			add_cartridge(new type(src))

/obj/machinery/chemical_dispenser/examine(mob/user)
	..()
	to_chat(user, "It has [cartridges.len] cartridges installed, and has space for [DISPENSER_MAX_CARTRIDGES - cartridges.len] more.")

/obj/machinery/chemical_dispenser/proc/add_cartridge(obj/item/reagent_containers/chem_disp_cartridge/C, mob/user)
	if(!istype(C))
		if(user)
			to_chat(user, SPAN_WARNING("[C] will not fit in [src]!"))
		return

	if(cartridges.len >= DISPENSER_MAX_CARTRIDGES)
		if(user)
			to_chat(user, SPAN_WARNING("[src] does not have any slots open for [C] to fit into!"))
		return

	if(!C.label)
		if(user)
			to_chat(user, SPAN_WARNING("[C] does not have a label!"))
		return

	if(cartridges[C.label])
		if(user)
			to_chat(user, SPAN_WARNING("[src] already contains a cartridge with that label!"))
		return

	if(user)
		user.drop_from_inventory(C,src)
		to_chat(user, SPAN_NOTICE("You add [C] to [src]."))
	else
		C.forceMove(src)

	cartridges[C.label] = C
	sortTim(cartridges, GLOBAL_PROC_REF(cmp_text_asc))
	SSvueui.check_uis_for_change(src)

/obj/machinery/chemical_dispenser/proc/remove_cartridge(label)
	. = cartridges[label]
	cartridges -= label
	SSvueui.check_uis_for_change(src)

/obj/machinery/chemical_dispenser/attackby(obj/item/W, mob/user)
	if(W.iswrench())
		to_chat(user, SPAN_NOTICE("You begin to [anchored ? "un" : ""]fasten [src]."))
		if(W.use_tool(src, user, 20, volume = 50))
			user.visible_message(
				SPAN_NOTICE("[user] [anchored ? "un" : ""]fastens [src]."),
				SPAN_NOTICE("You have [anchored ? "un" : ""]fastened [src]."),
				"You hear a ratchet.")
			anchored = !anchored
		else
			to_chat(user, SPAN_NOTICE("You decide not to [anchored ? "un" : ""]fasten [src]."))

	else if(istype(W, /obj/item/reagent_containers/chem_disp_cartridge))
		add_cartridge(W, user)

	else if(W.isscrewdriver())
		var/label = input(user, "Which cartridge would you like to remove?", "Chemical Dispenser") as null|anything in cartridges
		if(!label) return
		var/obj/item/reagent_containers/chem_disp_cartridge/C = remove_cartridge(label)
		if(C)
			to_chat(user, SPAN_NOTICE("You remove [C] from [src]."))
			C.forceMove(loc)

	else if(istype(W, /obj/item/reagent_containers/glass) || is_type_in_list(W, drink_accepted))
		if(container)
			to_chat(user, SPAN_WARNING("There is already \a [container] on [src]!"))
			return

		var/obj/item/reagent_containers/RC = W

		if(is_type_in_list(RC, forbidden_containers))
			to_chat(user, SPAN_WARNING("There's no way to fit [RC] into \the [src]!"))
			return

		if(!accept_drinking && is_type_in_list(RC, drink_accepted))
			to_chat(user, SPAN_WARNING("This machine only accepts beakers!"))
			return

		if(!RC.is_open_container())
			to_chat(user, SPAN_WARNING("You don't see how [src] could dispense reagents into [RC]."))
			return

		container =  RC
		user.drop_from_inventory(RC,src)
		to_chat(user, SPAN_NOTICE("You set [RC] on [src]."))
		SSvueui.check_uis_for_change(src) // update all UIs attached to src
		if(icon_state_active)
			icon_state = icon_state_active

	else
		return ..()

/obj/machinery/chemical_dispenser/vueui_data_change(list/data, mob/user, datum/vueui/ui)
	data = ..() || data || list()
	// this is the data which will be sent to the ui
	data["amount"] = amount
	data["glass"] = accept_drinking
	data["isBeakerLoaded"] = !!container
	data["beakerMaxVolume"] = container?.reagents?.maximum_volume
	data["beakerCurrentVolume"] = container?.reagents?.total_volume
	var beakerD[0]
	for(var/_R in container?.reagents?.reagent_volumes)
		var/singleton/reagent/R = GET_SINGLETON(_R)
		beakerD[++beakerD.len] = list("name" = R.name, "volume" = REAGENT_VOLUME(container.reagents, _R))
	data["beakerContents"] = beakerD
	var chemicals[0]
	for(var/label in cartridges)
		var/obj/item/reagent_containers/chem_disp_cartridge/C = cartridges[label]
		chemicals[++chemicals.len] = list("label" = label, "amount" = C.reagents.total_volume)
	data["chemicals"] = chemicals
	return data

/obj/machinery/chemical_dispenser/ui_interact(mob/user)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if(!ui)
		ui = new(user, src, "machinery-chemdisp", 400, 680, ui_title, state = interactive_state)
	ui.open()

/obj/machinery/chemical_dispenser/Topic(href, href_list)
	if(..())
		return TOPIC_NOACTION

	if(href_list["amount"])
		amount = round(text2num(href_list["amount"]), 1) // round to nearest 1
		amount = between(amount, 1, container?.reagents?.maximum_volume || 120) // Since the user can actually type the commands himself, some sanity checking

	else if(href_list["dispense"])
		var/label = href_list["dispense"]
		if(cartridges[label] && container?.is_open_container())
			var/obj/item/reagent_containers/chem_disp_cartridge/C = cartridges[label]
			playsound(src.loc, 'sound/machines/reagent_dispense.ogg', 25, 1)
			C.reagents.trans_to(container, amount)
			addtimer(CALLBACK(SSvueui, TYPE_PROC_REF(/datum/controller/subsystem/processing/vueui, check_uis_for_change), src), 2 SECONDS) //Just in case we get no new data

	else if(href_list["ejectBeaker"])
		if(container)
			var/obj/item/reagent_containers/B = container
			usr.put_in_hands(B)
			container = null
			if(icon_state_active)
				icon_state = initial(icon_state)
			SSvueui.check_uis_for_change(src)

	SSnanoui.update_uis(src)
	add_fingerprint(usr)
	return TOPIC_REFRESH // update UIs attached to this object

/obj/machinery/chemical_dispenser/attack_ai(mob/user as mob)
	if(!ai_can_interact(user))
		return
	ui_interact(user)

/obj/machinery/chemical_dispenser/attack_hand(mob/user as mob)
	ui_interact(user)

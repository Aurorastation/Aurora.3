/obj/structure/chemkit
	name = "makeshift workstation"
	icon = 'icons/obj/makeshift_workstation.dmi'
	icon_state = "workstation"
	desc = "It's a makeshift workstation for grinding, chopping, and heating."
	density = 1

	anchored = 1
	throwpass = 1

	var/obj/item/device/analyzer/analyzer
	var/transfer_out = 0
	var/phase_filter

	var/list/forbidden = list(/obj/item/reagent_containers/inhaler, /obj/item/reagent_containers/hypospray, /obj/item/reagent_containers/glass, /obj/item/extinguisher)
	// duplicate from blender code, since it's not really worth a define. also, it has fewer things.
	var/list/sheet_reagents = list( //have a number of reagents which is a factor of REAGENTS_PER_SHEET (default 20) unless you like decimals
		/obj/item/stack/material/iron = list(/singleton/reagent/iron),
		/obj/item/stack/material/uranium = list(/singleton/reagent/uranium),
		/obj/item/stack/material/phoron = list(/singleton/reagent/toxin/phoron),
		/obj/item/stack/material/gold = list(/singleton/reagent/gold),
		/obj/item/stack/material/silver = list(/singleton/reagent/silver),
		/obj/item/stack/material/steel = list(/singleton/reagent/iron, /singleton/reagent/carbon),
		/obj/item/stack/material/sandstone = list(/singleton/reagent/silicon, /singleton/reagent/acetone),
		/obj/item/stack/material/glass = list(/singleton/reagent/silicate),
		) // removed borosilicate glass, platinum, and plasteel, too tough. just steal a grinder if you need it

/obj/structure/chemkit/Initialize()
	. = ..()
	create_reagents(180)

/obj/structure/chemkit/examine(mob/user)
	. = ..()
	if(analyzer)
		to_chat(user, SPAN_NOTICE("The analyzer displays that the temperature is [round(reagents.get_temperature() - T0C,0.1)]C."))

/obj/structure/chemkit/verb/phase_filter()
	set name = "Set Phase Filter"
	set category = "Object"
	set src in view(1)
	if(use_check_and_message(usr))
		return 0
	phase_filter = input("Which phase do you want to filter?", "Phase Filter", null) as null|anything in list("solid", "liquid", "gas", "none")
	if(phase_filter)
		to_chat(usr, SPAN_NOTICE("You switch to a [phase_filter] filter."))
	if(phase_filter == "none")
		phase_filter = FALSE

/obj/structure/chemkit/verb/eject_contents()
	set name = "Remove Contents"
	set category = "Object"
	set src in view(1)
	if (use_check_and_message(usr))
		return
	for(var/atom/movable/A in contents)
		if(A == analyzer)
			continue
		A.forceMove(loc)

/obj/structure/chemkit/attack_hand(mob/user)
	transfer_out = !transfer_out
	to_chat(user, SPAN_NOTICE("You are now [transfer_out ? "removing from" : "adding to"] \the [src]."))

/obj/structure/chemkit/proc/heat_item(obj/item/W, mob/user)
	var/joules = 0
	if(istype(W, /obj/item/flame))
		joules = 1000 // 1 kJ per match, and we're assuming lighters give as much per use
	else if(W.iswelder())
		joules = 10000 // we'll just have it be ten times stronger
	else if(istype(W, /obj/item/device/assembly/igniter))
		joules = 5000 // half as strong as a welder; this thing has to set off bombs and such
	else
		joules = 500 // we're assuming it's some kind of novelty toy like lunea's gloves, etc; not exactly a match but it still works
	reagents.add_thermal_energy(joules)
	user.visible_message(SPAN_WARNING("[user] holds \the [W] up to \the [src]!"), SPAN_NOTICE("You use \the [W] to heat \the [src]'s contents."), SPAN_NOTICE("You hear something sizzle."))
	user.setClickCooldown(joules/5000) // two seconds for welder, 1/5 second for matches but they run out

/obj/structure/chemkit/proc/trans_item(obj/item/I, mob/user)
	if(transfer_out)
		var/amt = 0
		switch(phase_filter)
			if("solid")
				amt = reagents.trans_ids_to(I.reagents, reagents.get_ids_by_phase(SOLID), REAGENTS_FREE_SPACE(reagents))
			if("liquid")
				amt = reagents.trans_ids_to(I.reagents, reagents.get_ids_by_phase(LIQUID), REAGENTS_FREE_SPACE(reagents))
			if("gas")
				amt = reagents.trans_ids_to(I.reagents, reagents.get_ids_by_phase(GAS), REAGENTS_FREE_SPACE(reagents))
			else
				amt = reagents.trans_to_holder(I.reagents, REAGENTS_FREE_SPACE(reagents))
		if(amt)
			to_chat(user, SPAN_NOTICE("You fill \the [I] with [amt] units from \the [src]."))
	else if(I.reagents && I.reagents.total_volume)
		var/amt = I.reagents.trans_to_holder(reagents, I.reagents.total_volume) // just pour it if you can
		to_chat(user, SPAN_NOTICE("You pour [amt] units from \the [I] into \the [src]."))

/obj/structure/chemkit/proc/smash_sheet(obj/item/stack/stack, mob/user)
	if(!istype(stack))
		return
	var/list/sheet_components = sheet_reagents[stack.type]
	var/amount_to_take = max(0,min(stack.amount,round(REAGENTS_FREE_SPACE(reagents)/REAGENTS_PER_SHEET)))
	if(!amount_to_take)
		return
	stack.use(amount_to_take)
	if(islist(sheet_components))
		amount_to_take = (amount_to_take/(sheet_components.len))
		for(var/n in sheet_components)
			reagents.add_reagent(n, (amount_to_take*REAGENTS_PER_SHEET)*rand(6,8)/10)
	else
		reagents.add_reagent(sheet_components, (amount_to_take*REAGENTS_PER_SHEET)*rand(6,8)/10) // 60% to 80% efficiency when crushing sheets
	to_chat(user, SPAN_NOTICE("You [pick("crush","smash","grind")] [stack] into a fine powder."))
	return

/obj/structure/chemkit/proc/smash(obj/item/I, mob/user)
	if(sheet_reagents[I.type])
		smash_sheet(I, user)
		return
	to_chat(user, SPAN_NOTICE("You [pick("crush","smash","grind")] [I] into a fine [pick("paste","powder","pulp")]."))
	I.reagents.trans_to_holder(reagents, I.reagents.total_volume, rand(7, 10)/10) // 70% to 100% from smashing, since it's pretty thorough
	qdel(I)

/obj/structure/chemkit/proc/chop(obj/item/I, mob/user)
	to_chat(user, SPAN_NOTICE("You [pick("chop","cut","slice")] [I] into [pick("small","tiny")] [pick("pieces","chunks","bits","slices")]."))
	I.reagents.trans_to_holder(reagents, I.reagents.total_volume, rand(4, 8)/10) // 40% to 80% from chopping, since it's not very efficient
	qdel(I)

/obj/structure/chemkit/dismantle()
	new /obj/structure/table(loc)
	new /obj/item/reagent_containers/cooking_container/plate/bowl(loc)
	if(analyzer)
		analyzer.forceMove(loc)
		analyzer = null
	qdel(src)

/obj/structure/chemkit/attackby(obj/item/W, mob/user)
	if(W.iscrowbar())
		dismantle()
		return
	if(!istype(W, /obj/item/reagent_containers/food/snacks) && W.is_open_container())
		trans_item(W, user)
		return
	if(W.isFlameSource())
		heat_item(W, user)
		return
	if(istype(W) && W.force >= 5 && !has_edge(W) && LAZYLEN(contents - analyzer))
		var/obj/item/smashed = pick(contents - analyzer)
		if(!smashed.reagents && !sheet_reagents[smashed.type])
			return // should never happen anyway, but still
		to_chat(user, SPAN_NOTICE("You begin to [pick("crush","smash","grind")] [smashed]."))
		if(!do_after(user, 15 SECONDS))
			return
		smash(smashed, user)
		return
	if(has_edge(W) && LAZYLEN(contents - analyzer))
		var/obj/item/chopped = pick(contents - analyzer)
		if(!chopped.reagents)
			return
		if(!do_after(user, 5 SECONDS))
			return
		chop(chopped, user)
		return
	if(!analyzer && istype(W, /obj/item/device/analyzer))
		user.drop_from_inventory(W)
		analyzer = W
		W.forceMove(src)
		return
	if(!is_type_in_list(W, forbidden) && (W.w_class <= 3.0) && (W.reagents || sheet_reagents[W.type]))
		user.drop_from_inventory(W)
		W.forceMove(src)
		return
	. = ..()

/* Makeshift Still */
/obj/structure/distillery
	name = "makeshift still"
	icon = 'icons/obj/makeshift_workstation.dmi'
	icon_state = "distillery-empty"
	desc = "It's a makeshift still for purifying alcohol."
	density = 1

	anchored = 1

	// we don't have it as an opencontainer because it's handled directly

	var/transfer_out = FALSE
	var/obj/item/weldingtool/welder

/obj/structure/distillery/dismantle()
	var/turf/T = get_turf(src)
	var/obj/structure/reagent_dispensers/keg/keg = new (T)
	if (reagents?.total_volume)
		reagents.trans_to_holder(keg.reagents, reagents.total_volume)
	new /obj/item/stack/rods(T, 3)
	if(welder)
		welder.forceMove(T)
		welder = null
	qdel(src)

/obj/structure/distillery/proc/trans_item(obj/item/W, mob/user)
	if(transfer_out)
		if(!reagents.total_volume)
			to_chat(user, SPAN_NOTICE("[src] is empty."))
			return
		var/amt = reagents.trans_to_holder(W.reagents, reagents.total_volume)
		to_chat(user, SPAN_NOTICE("You fill [W] with [amt] units from [src]."))
		return
	else
		if(!W.reagents?.total_volume)
			to_chat(user, SPAN_NOTICE("[W] is empty."))
			return
		var/amt = 5
		if(istype(W, /obj/item/reagent_containers))
			var/obj/item/reagent_containers/reagent_container = W
			amt = reagent_container.amount_per_transfer_from_this
		W.reagents.trans_to_holder(reagents, amt) // just pour it if you can
		to_chat(user, SPAN_NOTICE("You pour [amt] units from [W] into [src]."))
		return

/obj/structure/distillery/proc/distill()
	if(!reagents?.total_volume) // can't distill nothing
		return
	for(var/_R in reagents.reagent_volumes)
		if(!ispath(_R, /singleton/reagent/alcohol))
			continue
		var/singleton/reagent/alcohol/AR = GET_SINGLETON(_R)
		var/ARvol = REAGENT_VOLUME(reagents, _R)
		var/alcohol_fraction = AR.strength/100
		reagents.add_reagent(/singleton/reagent/water, (1-alcohol_fraction)*ARvol)
		reagents.add_reagent(ispath(_R, /singleton/reagent/alcohol/butanol) ? /singleton/reagent/alcohol/butanol : /singleton/reagent/alcohol, alcohol_fraction*ARvol)
		reagents.remove_reagent(_R, ARvol)
	icon_state = "distillery-off"

/obj/structure/distillery/attackby(obj/item/W, mob/user)
	if(W.iscrowbar())
		dismantle()
		return
	if(!welder && istype(W, /obj/item/weldingtool))
		user.drop_from_inventory(W)
		src.welder = W
		W.forceMove(src)
		icon_state = "distillery-off"
		return
	if(!istype(W, /obj/item/reagent_containers/food/snacks) && W.is_open_container())
		trans_item(W, user)
		return
	if(W.isscrewdriver())
		transfer_out = !transfer_out
		to_chat(user, SPAN_NOTICE("You [transfer_out ? "open" : "close"] the spigot on the keg, ready to [transfer_out ? "remove" : "add"] reagents."))
		return
	if(W.isFlameSource() && istype(welder))
		to_chat(user, SPAN_NOTICE("You light \the [src] and begin the distillation process."))
		addtimer(CALLBACK(src, .proc/distill), 60 SECONDS)
		src.icon_state = "distillery-active"
		return
	. = ..()

/obj/structure/distillery/Initialize()
	. = ..()
	create_reagents(1000) // same as a keg

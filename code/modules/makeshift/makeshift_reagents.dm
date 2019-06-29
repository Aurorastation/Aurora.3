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

	var/list/forbidden = list(/obj/item/weapon/reagent_containers/inhaler, /obj/item/weapon/reagent_containers/hypospray, /obj/item/weapon/reagent_containers/glass, /obj/item/weapon/extinguisher)
	// duplicate from blender code, since it's not really worth a define. also, it has fewer things.
	var/list/sheet_reagents = list( //have a number of reagents which is a factor of REAGENTS_PER_SHEET (default 20) unless you like decimals
		/obj/item/stack/material/iron = list("iron"),
		/obj/item/stack/material/uranium = list("uranium"),
		/obj/item/stack/material/phoron = list("phoron"),
		/obj/item/stack/material/gold = list("gold"),
		/obj/item/stack/material/silver = list("silver"),
		/obj/item/stack/material/steel = list("iron", "carbon"),
		/obj/item/stack/material/sandstone = list("silicon", "acetone"),
		/obj/item/stack/material/glass = list("silicate"),
		) // removed borosilicate glass, platinum, and plasteel, too tough. just steal a grinder if you need it

/obj/structure/chemkit/Initialize()
	. = ..()
	create_reagents(180)

/obj/structure/chemkit/examine(mob/user)
	. = ..()
	if(analyzer)
		to_chat(user, span("notice", "The analyzer displays that the temperature is [round(reagents.get_temperature() - T0C,0.1)]C."))

/obj/structure/chemkit/verb/phase_filter()
	set name = "Set Phase Filter"
	set category = "Object"
	set src in view(1)
	if(!usr.canmove || usr.stat || usr.restrained())
		return 0
	phase_filter = input("Which phase do you want to filter?", "Phase Filter", null) as null|anything in list("solid", "liquid", "gas", "none")
	if(phase_filter)
		to_chat(usr, span("notice", "You switch to a [phase_filter] filter."))
	if(phase_filter == "none")
		phase_filter = FALSE

/obj/structure/chemkit/verb/eject_contents()
	set name = "Remove Contents"
	set category = "Object"
	set src in view(1)
	for(var/atom/movable/A in contents)
		if(A == analyzer)
			continue
		contents -= A
		A.forceMove(loc)

/obj/structure/chemkit/attack_hand(mob/user)
	transfer_out = !transfer_out
	to_chat(user, span("notice", "You are now [transfer_out ? "removing from" : "adding to"] \the [src]."))

/obj/structure/chemkit/attackby(obj/item/weapon/W, mob/user)
	if(W.iscrowbar())
		new /obj/structure/table(loc)
		new /obj/item/weapon/reagent_containers/glass/beaker/bowl(loc)
		if(analyzer)
			analyzer.forceMove(loc)
			analyzer = null
		qdel(src)
		return
	if(!transfer_out && !istype(W, /obj/item/weapon/reagent_containers/food/snacks) && W.is_open_container() && W.reagents)
		W.reagents.trans_to_holder(src.reagents, W.reagents.total_volume) // just pour it if you can
		return
	if(transfer_out && !istype(W, /obj/item/weapon/reagent_containers/food/snacks) && W.is_open_container())
		switch(phase_filter)
			if("solid")
				reagents.trans_ids_to(W.reagents, reagents.get_ids_by_phase(SOLID), reagents.get_free_space())
			if("liquid")
				reagents.trans_ids_to(W.reagents, reagents.get_ids_by_phase(LIQUID), reagents.get_free_space())
			if("gas")
				reagents.trans_ids_to(W.reagents, reagents.get_ids_by_phase(GAS), reagents.get_free_space())
			else
				reagents.trans_to_holder(W.reagents, reagents.get_free_space())
	if(isflamesource(W))
		var/joules = 0
		if(istype(W, /obj/item/weapon/flame))
			joules = 1000 // 1 kJ per match, and we're assuming lighters give as much per use
		else if(W.iswelder())
			joules = 10000 // we'll just have it be ten times stronger
		else if(istype(W, /obj/item/device/assembly/igniter))
			joules = 5000 // half as strong as a welder; this thing has to set off bombs and such
		else
			joules = 500 // we're assuming it's some kind of novelty toy like lunea's gloves, etc; not exactly a match but it still works
		reagents.add_thermal_energy(joules)
		user.visible_message(span("warning", "[user] holds \the [W] up to \the [src]!"), span("notice", "You use \the [W] to heat \the [src]'s contents."), span("notice", "You hear something sizzle."))
		return
	if(istype(W) && W.force >= 5 && !has_edge(W) && LAZYLEN(contents - analyzer))
		var/obj/item/smashed = pick(contents - analyzer)
		if(!smashed.reagents && !sheet_reagents[smashed.type])
			return // should never happen anyway, but still
		to_chat(user, span("notice", "You begin to [pick("crush","smash","grind")] [smashed]."))
		if(!do_after(user, 15 SECONDS))
			return
		contents -= smashed
		if(sheet_reagents[smashed.type])
			var/obj/item/stack/stack = smashed
			if(istype(stack))
				var/list/sheet_components = sheet_reagents[stack.type]
				var/amount_to_take = max(0,min(stack.amount,round(reagents.get_free_space()/REAGENTS_PER_SHEET)))
				if(amount_to_take)
					stack.use(amount_to_take)
					if(QDELETED(stack))
						contents -= stack
					if(islist(sheet_components))
						amount_to_take = (amount_to_take/(sheet_components.len))
						for(var/i in sheet_components)
							reagents.add_reagent(i, (amount_to_take*REAGENTS_PER_SHEET)*rand(6,8)/10)
					else
						reagents.add_reagent(sheet_components, (amount_to_take*REAGENTS_PER_SHEET)*rand(6,8)/10) // 60% to 80% efficiency when crushing sheets
					to_chat(user, span("notice", "You [pick("crush","smash","grind")] [smashed] into a fine powder."))
					return
		to_chat(user, span("notice", "You [pick("crush","smash","grind")] [smashed] into a fine [pick("paste","powder","pulp")]."))
		smashed.reagents.trans_to_holder(reagents, smashed.reagents.total_volume, rand(7, 10)/10) // 70% to 100% from smashing, since it's pretty thorough
		qdel(smashed)
		return
	if(has_edge(W) && LAZYLEN(contents - analyzer))
		var/obj/item/chopped = pick(contents - analyzer)
		if(!chopped.reagents)
			return
		if(!do_after(user, 5 SECONDS))
			return
		to_chat(user, span("notice", "You [pick("chop","cut","slice")] [chopped] into [pick("small","tiny")] [pick("pieces","chunks","bits","slices")]."))
		contents -= chopped
		chopped.reagents.trans_to_holder(src.reagents, chopped.reagents.total_volume, rand(4, 8)/10) // 40% to 80% from chopping, since it's not very efficient
		qdel(chopped)
		return
	if(!analyzer && istype(W, /obj/item/device/analyzer))
		user.drop_from_inventory(W)
		src.analyzer = W
		W.forceMove(src)
		return
	if(!is_type_in_list(W, forbidden) && (W.w_class <= 3.0) && (W.reagents || sheet_reagents[W.type]))
		user.drop_from_inventory(W)
		W.forceMove(src)
		src.contents += W
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
	var/obj/item/weapon/weldingtool/welder

/obj/structure/distillery/attackby(obj/item/weapon/W, mob/user)
	if(W.iscrowbar())
		var/obj/structure/reagent_dispensers/keg/beerkeg/keg = new (loc)
		keg.filled = FALSE
		if (src.reagents && src.reagents.total_volume)
			src.reagents.trans_to_holder(keg.reagents, src.reagents.total_volume)
		new /obj/item/stack/rods(get_turf(src), 3)
		if(welder)
			welder.forceMove(loc)
			welder = null
		qdel(src)
		return
	if(!welder && istype(W, /obj/item/weapon/weldingtool))
		user.drop_from_inventory(W)
		src.welder = W
		W.forceMove(src)
		icon_state = "distillery-off"
		return
	if(!istype(W, /obj/item/weapon/reagent_containers/food/snacks) && W.is_open_container())
		if(!transfer_out)
			if(!W.reagents || !W.reagents.total_volume)
				to_chat(user, span("notice", "\The [W] is empty."))
				return
			var/amt = min(10, W.reagents.total_volume)
			W.reagents.trans_to_holder(src.reagents, amt) // just pour it if you can
			to_chat(user, span("notice", "You pour [amt] units from \the [W] into \the [src]."))
			return
		if(transfer_out)
			if(!src.reagents.total_volume)
				to_chat(user, span("notice", "\The [src] is empty."))
				return
			src.reagents.trans_to_holder(W.reagents, src.reagents.total_volume)
			to_chat(user, span("notice", "You fill \the [W] with reagents from \the [src]."))
			return
	if(W.isscrewdriver())
		transfer_out = !transfer_out
		to_chat(user, span("notice", "You [transfer_out ? "open" : "close"] the spigot on the keg, ready to [transfer_out ? "remove" : "add"] reagents."))
		return
	if(isflamesource(W) && istype(welder))
		to_chat(user, span("notice", "You light \the [src] and begin the distillation process."))
		addtimer(CALLBACK(src, .proc/distill), 600)
		src.icon_state = "distillery-active"
		return
	. = ..()

/obj/structure/distillery/proc/distill()
	if(!reagents || !reagents.total_volume) // can't distill nothing
		return
	for(var/datum/reagent/R in src.reagents.reagent_list)
		if(!istype(R, /datum/reagent/alcohol))
			return
		var/datum/reagent/alcohol/AR = R
		reagents.add_reagent("water", (1-(AR.strength/100))*AR.volume)
		if(istype(AR, /datum/reagent/alcohol/ethanol))
			reagents.add_reagent("ethanol", (AR.strength/100)*AR.volume)
		if(istype(AR, /datum/reagent/alcohol/butanol))
			reagents.add_reagent("butanol", (AR.strength/100)*AR.volume)
		reagents.remove_reagent(AR.id, AR.volume)
	src.icon_state = "distillery-off"

/obj/structure/distillery/Initialize()
	. = ..()
	create_reagents(1000) // same as a keg
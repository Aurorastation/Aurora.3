/obj/structure/chemkit
	name = "makeshift workstation"
	icon = 'icons/obj/makeshift_workstation.dmi'
	icon_state = "workstation"
	desc = "It's a makeshift workstation for grinding, chopping, and heating."
	density = 1

	anchored = 1
	throwpass = 1

	flags = OPENCONTAINER

	var/obj/item/device/analyzer/analyzer

	// duplicate from blender code, since it's not really worth a define
	var/list/sheet_reagents = list( //have a number of reagents which is a factor of REAGENTS_PER_SHEET (default 20) unless you like decimals
		/obj/item/stack/material/iron = list("iron"),
		/obj/item/stack/material/uranium = list("uranium"),
		/obj/item/stack/material/phoron = list("phoron"),
		/obj/item/stack/material/gold = list("gold"),
		/obj/item/stack/material/silver = list("silver"),
		/obj/item/stack/material/platinum = list("platinum"),
		/obj/item/stack/material/mhydrogen = list("hydrogen"),
		/obj/item/stack/material/steel = list("iron", "carbon"),
		/obj/item/stack/material/plasteel = list("iron", "iron", "carbon", "carbon", "platinum"), //8 iron, 8 carbon, 4 platinum,
		/obj/item/stack/material/sandstone = list("silicate", "acetone"),
		/obj/item/stack/material/glass = list("silicate"),
		/obj/item/stack/material/glass/phoronglass = list("platinum", "silicate", "silicate", "silicate"), //5 platinum, 15 silicate,
		)

/obj/structure/chemkit/Initialize()
	. = ..()
	create_reagents(180)

/obj/structure/chemkit/examine(mob/user)
	. = ..()
	if(analyzer)
		to_chat(user, span("notice", "The analyzer displays that the temperature is [round(reagents.get_temperature() - T0C,0.1)]C."))

/obj/structure/chemkit/attackby(obj/item/weapon/W, mob/user)
	if(W.iscrowbar())
		new /obj/structure/table(loc)
		new /obj/item/weapon/reagent_containers/glass/beaker/bowl(loc)
		if(analyzer)
			analyzer.forceMove(loc)
			analyzer = null
		qdel(src)
		return
	if(istype(W) && W.force > 10 && !has_edge(W))
		var/obj/item/smashed = pick(contents)
		if(!smashed.reagents && !sheet_reagents[smashed.type])
			return // should never happen anyway, but still
		if(!do_after(user, 15 SECONDS))
			return
		contents -= smashed
		if(sheet_reagents[smashed.type])
			var/obj/item/stack/stack = smashed
			if(istype(stack))
				var/amount_to_take = max(0,min(stack.amount,round(reagents.get_free_space()/REAGENTS_PER_SHEET)))
				if(amount_to_take)
					stack.use(amount_to_take)
					if(QDELETED(stack))
						contents -= stack
					reagents.add_reagent(sheet_reagents[stack.type], (amount_to_take*REAGENTS_PER_SHEET)*rand(6,8)/10) // 60% to 80% efficiency when crushing sheets
					to_chat(user, span("notice", "You [pick("crush","smash","grind")] [smashed] into a fine powder."))
					return
		to_chat(user, span("notice", "You [pick("crush","smash","grind")] [smashed] into a fine [pick("paste","powder","pulp")]."))
		smashed.reagents.trans_to_holder(reagents, smashed.reagents.total_volume, rand(7, 10)/10) // 70% to 100% from smashing, since it's pretty thorough
		qdel(smashed)
		return
	if(has_edge(W))
		var/obj/item/chopped = pick(contents)
		if(!chopped.reagents)
			return
		if(!do_after(user, 5 SECONDS))
			return
		to_chat(user, span("notice", "You [pick("chop","cut","slice")] [chopped] into [pick("small","tiny")] [pick("pieces","chunks","bits","slices")]."))
		contents -= chopped
		chopped.reagents.trans_to_holder(src.reagents, chopped.reagents.total_volume, rand(4, 8)/10) // 40% to 80% from chopping, since it's not very efficient
		qdel(chopped)
		return
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
	if(!analyzer && istype(W, /obj/item/device/analyzer))
		user.drop_from_inventory(W)
		src.analyzer = W
		W.forceMove(src)
		return
	if(!istype(W, /obj/item/weapon/reagent_containers/food) && W.is_open_container() && W.reagents)
		W.reagents.trans_to_holder(src.reagents, W.reagents.total_volume) // just pour it if you can
		return
	if(W.reagents || sheet_reagents[W.type])
		user.drop_from_inventory(W)
		W.forceMove(src)
		src.contents += W
		return
	. = ..()

/* Makeshift Still */
/obj/structure/distillery
	name = "makeshift workstation"
	icon = 'icons/obj/makeshift_workstation.dmi'
	icon_state = "distillery-empty"
	desc = "It's a makeshift workstation for grinding, chopping, and heating."
	density = 1

	anchored = 1

	flags = OPENCONTAINER

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
	if(!istype(W, /obj/item/weapon/reagent_containers/food) && W.is_open_container())
		if(!transfer_out && W.reagents)
			W.reagents.trans_to_holder(src.reagents, W.reagents.total_volume) // just pour it if you can
			return
		if(transfer_out)
			src.reagents.trans_to_holder(W.reagents, src.reagents.total_volume)
			return
	if(isflamesource(W) && istype(welder))
		to_chat(user, span("notice", "You light \the [src] and begin the distillation process."))
		addtimer(CALLBACK(src, .proc/distill), 60)
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
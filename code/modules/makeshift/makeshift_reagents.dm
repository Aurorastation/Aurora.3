/obj/structure/chemkit
	name = "makeshift workstation"
	icon = 'icons/obj/makeshift_workstation.dmi'
	icon_state = "workstation"
	desc = "It's a makeshift workstation for grinding, chopping, and heating."
	density = 1
	
	anchored = 1
	throwpass = 1
	var/maxhealth = 10
	var/health = 10

/obj/structure/chemkit/Initialize()
	. = ..()
	create_reagents(180)

/obj/structure/chemkit/attackby(obj/item/I, mob/user)
	if(I.iswrench())
		new /obj/structure/table(loc)
		new /obj/item/weapon/reagent_containers/glass/beaker/bowl(loc)
		qdel(src)
		return
	if(I.force > 10)
		smashed = pick(contents)
		if(!smashed.reagents && !sheet_reagents[smashed.type])
			return // should never happen anyway, but still
		if(!do_after(user, 15 SECONDS))
			return
		contents -= smashed
		if(sheet_reagents[smashed.type])
			var/obj/item/stack/stack = smashed
			if(istype(stack))
				var/amount_to_take = max(0,min(stack.amount,round(remaining_volume/REAGENTS_PER_SHEET)))
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
	if(has_edge(I))
		chopped = pick(contents)
		if(!
		if(!do_after(user, 5 SECONDS))
			return
		to_chat(user, span("notice", "You [pick("chop","cut","slice")] [src] into [pick("small","tiny")] [pick("pieces","chunks","bits","slices")]."))
		contents -= chopped
		chopped.reagents.trans_to_holder(src.reagents, smashed.reagents.total_volume, rand(4, 8)/10) // 40% to 80% from chopping, since it's not very efficient
		qdel(chopped)
		return
	if(I.reagents || sheet_reagents[I.type])
		user.drop_from_inventory(I)
		I.forceMove(src)
		src.contents += I
		return 
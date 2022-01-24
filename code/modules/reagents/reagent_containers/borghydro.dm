/obj/item/reagent_containers/hypospray/borghypo
	name = "cyborg hypospray"
	desc = "An advanced chemical synthesizer and injection system, designed for heavy-duty medical equipment."
	icon = 'icons/obj/syringe.dmi'
	item_state = "hypo"
	icon_state = "borghypo"
	amount_per_transfer_from_this = 5
	volume = 30
	possible_transfer_amounts = null

	var/mode = 1
	var/charge_cost = 50
	var/charge_tick = 0
	var/recharge_time = 5 //Time it takes for shots to recharge (in seconds)

	var/list/reagent_ids = list(/decl/reagent/tricordrazine, /decl/reagent/inaprovaline)
	var/list/reagent_volumes = list()
	var/list/reagent_names = list()

	center_of_mass = null

/obj/item/reagent_containers/hypospray/borghypo/medical
	reagent_ids = list(/decl/reagent/bicaridine, /decl/reagent/kelotane, /decl/reagent/dylovene, /decl/reagent/dexalin, /decl/reagent/inaprovaline, /decl/reagent/perconol, /decl/reagent/mortaphenyl, /decl/reagent/thetamycin)

/obj/item/reagent_containers/hypospray/borghypo/rescue
	reagent_ids = list(/decl/reagent/tricordrazine, /decl/reagent/inaprovaline, /decl/reagent/dylovene, /decl/reagent/perconol, /decl/reagent/mortaphenyl, /decl/reagent/dexalin, /decl/reagent/adrenaline)

/obj/item/reagent_containers/hypospray/borghypo/Initialize()
	. = ..()

	for(var/T in reagent_ids)
		reagent_volumes[T] = volume
		var/decl/reagent/R = decls_repository.get_decl(T)
		reagent_names += R.name

	START_PROCESSING(SSprocessing, src)

/obj/item/reagent_containers/hypospray/borghypo/update_icon()
	return

/obj/item/reagent_containers/hypospray/borghypo/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/item/reagent_containers/hypospray/borghypo/process() //Every [recharge_time] seconds, recharge some reagents for the cyborg+
	if(++charge_tick < recharge_time)
		return 0
	charge_tick = 0

	if(isrobot(loc))
		var/mob/living/silicon/robot/R = loc
		if(R && R.cell)
			for(var/T in reagent_ids)
				if(reagent_volumes[T] < volume)
					R.cell.use(charge_cost)
					reagent_volumes[T] = min(reagent_volumes[T] + 5, volume)
	return 1

/obj/item/reagent_containers/hypospray/borghypo/inject(var/mob/living/M, var/mob/user, proximity)
	if(!proximity || !istype(M))
		return

	if(!reagent_volumes[reagent_ids[mode]])
		to_chat(user,"<span class='warning'>The injector is empty.</span>")
		return

	user.visible_message("<span class='notice'>[user] injects [M] with their hypospray!</span>", "<span class='notice'>You inject [M] with your hypospray!</span>", "<span class='notice'>You hear a hissing noise.</span>")
	to_chat(M,"<span class='notice'>You feel a tiny prick!</span>")

	if(M.reagents)
		var/t = min(amount_per_transfer_from_this, reagent_volumes[reagent_ids[mode]])
		M.reagents.add_reagent(reagent_ids[mode], t)
		reagent_volumes[reagent_ids[mode]] -= t
		admin_inject_log(user, M, src, reagent_ids[mode], reagents.get_temperature(), t)
		to_chat(user,"<span class='notice'>[t] units injected. [reagent_volumes[reagent_ids[mode]]] units remaining.</span>")
	return

/obj/item/reagent_containers/hypospray/borghypo/afterattack(atom/target, mob/user, proximity)
	if (!proximity)
		return

	if (!isliving(target))
		return ..()

/obj/item/reagent_containers/hypospray/borghypo/attack_self(mob/user as mob) //Change the mode
	var/t = ""
	for(var/i = 1 to reagent_ids.len)
		if(t)
			t += ", "
		if(mode == i)
			t += "<b>[reagent_names[i]]</b>"
		else
			t += "<a href='?src=\ref[src];reagent=[reagent_ids[i]]'>[reagent_names[i]]</a>"
	t = "Available reagents: [t]."
	to_chat(user, t)

	return

/obj/item/reagent_containers/hypospray/borghypo/Topic(var/href, var/list/href_list)
	if(href_list["reagent"])
		var/t = reagent_ids.Find(text2path(href_list["reagent"]))
		if(t)
			playsound(loc, 'sound/effects/pop.ogg', 50, 0)
			mode = t
			var/decl/reagent/R = decls_repository.get_decl(reagent_ids[mode])
			to_chat(usr, "<span class='notice'>Synthesizer is now producing '[R.name]'.</span>")

/obj/item/reagent_containers/hypospray/borghypo/examine(mob/user)
	if(!..(user, 2))
		return

	var/decl/reagent/R = decls_repository.get_decl(reagent_ids[mode])

	to_chat(user, "<span class='notice'>It is currently producing [R.name] and has [reagent_volumes[reagent_ids[mode]]] out of [volume] units left.</span>")

/obj/item/reagent_containers/hypospray/borghypo/service
	name = "cyborg drink synthesizer"
	desc = "A portable drink dispenser."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "shaker"
	charge_cost = 20
	recharge_time = 3
	volume = 60
	possible_transfer_amounts = list(5, 10, 20, 30)
	reagent_ids = list(/decl/reagent/alcohol/beer, /decl/reagent/alcohol/coffee/kahlua, /decl/reagent/alcohol/whiskey, /decl/reagent/alcohol/wine, /decl/reagent/alcohol/vodka, /decl/reagent/alcohol/gin, /decl/reagent/alcohol/rum, /decl/reagent/alcohol/tequila, /decl/reagent/alcohol/vermouth, /decl/reagent/alcohol/cognac, /decl/reagent/alcohol/ale, /decl/reagent/alcohol/mead, /decl/reagent/water, /decl/reagent/sugar, /decl/reagent/drink/ice, /decl/reagent/drink/tea, /decl/reagent/drink/icetea, /decl/reagent/drink/space_cola, /decl/reagent/drink/spacemountainwind, /decl/reagent/drink/dr_gibb, /decl/reagent/drink/spaceup, /decl/reagent/drink/tonic, /decl/reagent/drink/sodawater, /decl/reagent/drink/lemon_lime, /decl/reagent/drink/orangejuice, /decl/reagent/drink/limejuice, /decl/reagent/drink/watermelonjuice, /decl/reagent/drink/coffee, /decl/reagent/drink/coffee/espresso)

/obj/item/reagent_containers/hypospray/borghypo/service/attack(var/mob/M, var/mob/user)
	return

/obj/item/reagent_containers/hypospray/borghypo/service/afterattack(var/obj/target, var/mob/user, var/proximity)
	if(!proximity)
		return

	if(!target.is_open_container() || !target.reagents)
		return

	if(!reagent_volumes[reagent_ids[mode]])
		to_chat(user, "<span class='notice'>[src] is out of this reagent, give it some time to refill.</span>")
		return

	if(!REAGENTS_FREE_SPACE(target.reagents))
		to_chat(user, "<span class='notice'>[target] is full.</span>")
		return

	var/rid = reagent_ids[mode]
	var/decl/reagent/R = decls_repository.get_decl(rid)
	var/temp = R.default_temperature
	var/amt = min(amount_per_transfer_from_this, reagent_volumes[rid])
	target.reagents.add_reagent(rid, amt, temperature = temp)
	reagent_volumes[rid] -= amt
	to_chat(user, "<span class='notice'>You transfer [amt] units of the solution to [target].</span>")
	return

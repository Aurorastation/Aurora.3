/obj/item/reagent_containers/hypospray/borghypo
	name = "cyborg hypospray"
	desc = "An advanced chemical synthesizer and injection system, designed for heavy-duty medical equipment."
	desc_info = "Stationbound synthesizers produce specific reagents dependent on the selected module, which you can select by using it. \
	The reagents recharge automatically at the cost of energy.<br> Alt Click the synthesizer to change the transfer amount."
	desc_fluff = null
	icon = 'icons/obj/syringe.dmi'
	icon_state = "medical_synth"
	item_state = "hypo"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = null
	volume = 30
	time = 1.5 SECONDS

	var/mode = 1
	var/charge_cost = 50
	var/charge_tick = 0
	var/recharge_time = 5 //Time it takes for shots to recharge (in seconds)

	var/list/reagent_ids = list(/decl/reagent/tricordrazine, /decl/reagent/inaprovaline)
	var/list/reagent_volumes = list()
	var/list/reagent_names = list()

	center_of_mass = null

/obj/item/reagent_containers/hypospray/borghypo/medical
	reagent_ids = list(/decl/reagent/bicaridine, /decl/reagent/kelotane, /decl/reagent/dexalin, /decl/reagent/inaprovaline, /decl/reagent/dylovene, /decl/reagent/perconol, /decl/reagent/mortaphenyl, /decl/reagent/thetamycin)

/obj/item/reagent_containers/hypospray/borghypo/rescue
	reagent_ids = list(/decl/reagent/tricordrazine, /decl/reagent/dexalin, /decl/reagent/inaprovaline, /decl/reagent/dylovene, /decl/reagent/perconol, /decl/reagent/mortaphenyl, /decl/reagent/adrenaline, /decl/reagent/coagzolug)

/obj/item/reagent_containers/hypospray/borghypo/hacked
	reagent_ids = list(/decl/reagent/toxin/zombiepowder, /decl/reagent/toxin/cyanide, /decl/reagent/polysomnine, /decl/reagent/toxin/panotoxin, /decl/reagent/toxin/berserk, /decl/reagent/wulumunusha)


/obj/item/reagent_containers/hypospray/borghypo/Initialize()
	. = ..()

	for(var/T in reagent_ids)
		reagent_volumes[T] = volume
		var/decl/reagent/R = decls_repository.get_decl(T)
		reagent_names += R.name

	update_icon()
	START_PROCESSING(SSprocessing, src)

/obj/item/reagent_containers/hypospray/borghypo/update_icon()
	cut_overlays()

	var/rid = reagent_ids[mode]
	var/decl/reagent/R = decls_repository.get_decl(rid)
	if(reagent_volumes[rid])
		filling = image(icon, src, "[initial(icon_state)][reagent_volumes[rid]]")
		filling.color = R.get_color()
		add_overlay(filling)

		var/mutable_appearance/reagent_bar = mutable_appearance(icon, "[initial(icon_state)]_reagents")
		reagent_bar.color = R.get_color()
		add_overlay(reagent_bar)

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
					update_icon()
	return 1

/obj/item/reagent_containers/hypospray/borghypo/inject(var/mob/living/M, var/mob/user, proximity)
	if(!proximity || !istype(M))
		return

	if(!reagent_volumes[reagent_ids[mode]])
		to_chat(user, SPAN_WARNING("The injector is empty."))
		return
	
	user.visible_message(SPAN_NOTICE("[user] injects [M] with their hypospray!"), SPAN_NOTICE("You inject [M] with your hypospray!"), SPAN_NOTICE("You hear a hissing noise."))
	to_chat(M, SPAN_NOTICE("You feel a tiny prick!"))
	playsound(src, 'sound/items/hypospray.ogg',25)

	if(M.reagents)
		var/t = min(amount_per_transfer_from_this, reagent_volumes[reagent_ids[mode]])
		M.reagents.add_reagent(reagent_ids[mode], t)
		reagent_volumes[reagent_ids[mode]] -= t
		admin_inject_log(user, M, src, reagent_ids[mode], reagents.get_temperature(), t)
		to_chat(user, SPAN_NOTICE("[t] units injected. [reagent_volumes[reagent_ids[mode]]] units remaining."))

	update_icon()
	return TRUE

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
			to_chat(usr, SPAN_NOTICE("Synthesizer is now producing '[R.name]'."))
			update_icon()

/obj/item/reagent_containers/hypospray/borghypo/examine(mob/user)
	if(!..(user, 2))
		return

	var/decl/reagent/R = decls_repository.get_decl(reagent_ids[mode])
	to_chat(user, SPAN_NOTICE("It is currently producing [R.name] and has [reagent_volumes[reagent_ids[mode]]] out of [volume] units left."))

/obj/item/reagent_containers/hypospray/borghypo/service
	name = "cyborg drink synthesizer"
	desc = "A portable drink synthesizer and dispenser."
	icon = 'icons/obj/shaker.dmi'
	icon_state = "drink_synth"
	charge_cost = 20
	recharge_time = 3
	volume = 60
	possible_transfer_amounts = list(5, 10, 20, 30)
	reagent_ids = list(/decl/reagent/alcohol/beer, /decl/reagent/alcohol/coffee/kahlua, /decl/reagent/alcohol/whiskey, /decl/reagent/alcohol/wine, /decl/reagent/alcohol/vodka, /decl/reagent/alcohol/gin, /decl/reagent/alcohol/rum, /decl/reagent/alcohol/tequila, /decl/reagent/alcohol/vermouth, /decl/reagent/alcohol/cognac, /decl/reagent/alcohol/ale, /decl/reagent/alcohol/mead, /decl/reagent/water, /decl/reagent/sugar, /decl/reagent/drink/ice, /decl/reagent/drink/tea, /decl/reagent/drink/icetea, /decl/reagent/drink/space_cola, /decl/reagent/drink/spacemountainwind, /decl/reagent/drink/dr_gibb, /decl/reagent/drink/spaceup, /decl/reagent/drink/tonic, /decl/reagent/drink/sodawater, /decl/reagent/drink/lemon_lime, /decl/reagent/drink/orangejuice, /decl/reagent/drink/limejuice, /decl/reagent/drink/watermelonjuice, /decl/reagent/drink/coffee, /decl/reagent/drink/coffee/espresso)

/obj/item/reagent_containers/hypospray/borghypo/service/update_icon()
	underlays.Cut()
	cut_overlays()

	var/rid = reagent_ids[mode]
	var/decl/reagent/R = decls_repository.get_decl(rid)
	if(reagent_volumes[rid])
		var/mutable_appearance/filling = mutable_appearance('icons/obj/shaker.dmi', "[icon_state]-0")
		var/percent = round((reagent_volumes[rid] / volume) * 100)
		switch(percent)
			if(0 to 9)				filling.icon_state = "[icon_state]-0"
			if(10 to 19)			filling.icon_state = "[icon_state]-10"
			if(20 to 39)			filling.icon_state = "[icon_state]-20"
			if(40 to 59)			filling.icon_state = "[icon_state]-40"
			if(60 to 79)			filling.icon_state = "[icon_state]-60"
			if(80 to 90)			filling.icon_state = "[icon_state]-80"
			if(91 to INFINITY)		filling.icon_state = "[icon_state]-100"
		filling.color = R.get_color()
		add_overlay(filling)

/obj/item/reagent_containers/hypospray/borghypo/service/attack(var/mob/M, var/mob/user)
	return

/obj/item/reagent_containers/hypospray/borghypo/service/afterattack(var/obj/target, var/mob/user, var/proximity)
	if(!proximity)
		return

	if(!target.is_open_container() || !target.reagents)
		return

	if(!reagent_volumes[reagent_ids[mode]])
		to_chat(user, SPAN_NOTICE("[src] is out of this reagent, give it some time to refill."))
		return

	if(!REAGENTS_FREE_SPACE(target.reagents))
		to_chat(user, SPAN_NOTICE("[target] is full."))
		return

	var/rid = reagent_ids[mode]
	var/decl/reagent/R = decls_repository.get_decl(rid)
	var/temp = R.default_temperature
	var/amt = min(amount_per_transfer_from_this, reagent_volumes[rid])
	target.reagents.add_reagent(rid, amt, temperature = temp)
	reagent_volumes[rid] -= amt
	to_chat(user, SPAN_NOTICE("You transfer [amt] units of [R.name] to [target]."))
	playsound(src.loc, /decl/sound_category/generic_pour_sound, 50, 1)
	dispense()
	return

/obj/item/reagent_containers/hypospray/borghypo/service/proc/dispense()
	var/decl/reagent/R = decls_repository.get_decl(reagent_ids[mode])
	var/mutable_appearance/reagent_overlay = mutable_appearance('icons/obj/shaker.dmi', "disp")
	reagent_overlay.color = R.get_color()
	underlays += reagent_overlay
	underlays += image('icons/obj/shaker.dmi', "[icon_state]-disp")
	flick("disp-mask", src)
	update_icon()

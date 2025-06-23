/atom/movable/screen/psi/hub
	name = "Psi"
	icon_state = "psi_active"
	screen_loc = "EAST-1:28,CENTER-3:11"
	hidden = FALSE
	maptext_x = 6
	maptext_y = -8
	var/image/on_cooldown

/atom/movable/screen/psi/hub/New(var/mob/living/_owner)
	on_cooldown = image(icon, "cooldown")
	..()
	START_PROCESSING(SSprocessing, src)

/atom/movable/screen/psi/hub/update_icon()
	if(!owner.psi)
		return

	icon_state = owner.psi.suppressed ? "psi_suppressed" : "psi_active"

/atom/movable/screen/psi/hub/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	owner = null
	. = ..()

/atom/movable/screen/psi/hub/process()
	if(!istype(owner))
		qdel(src)
		return
	if(!owner.psi)
		return
	maptext = SMALL_FONTS(7, "[round((owner.psi.stamina/owner.psi.max_stamina)*100)]%")
	update_icon()

/atom/movable/screen/psi/hub/Click(var/location, var/control, var/params)
	ui_interact(owner)
	update_icon()

/atom/movable/screen/psi/hub/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "PsionicShop", "Psionic Point Shop", 400, 500)
		ui.open()

/atom/movable/screen/psi/hub/ui_state(mob/user)
	return GLOB.conscious_state

/atom/movable/screen/psi/hub/ui_status(mob/user, datum/ui_state/state)
	return UI_INTERACTIVE

/atom/movable/screen/psi/hub/ui_data(mob/user)
	var/list/data = list()
	var/owner_rank = owner.psi.get_rank()
	data["available_psionics"] = list()
	data["psi_rank"] = GLOB.psychic_ranks_to_strings[owner_rank]
	data["psi_points"] = owner.psi.psi_points
	data["bought_powers"] = owner.psi.psionic_powers
	for(var/singleton/psionic_power/P in GET_SINGLETON_SUBTYPE_LIST(/singleton/psionic_power))
		if((P.ability_flags & PSI_FLAG_SPECIAL) && !(P.type in owner.psi.psionic_powers))
			continue
		if(owner_rank < P.minimum_rank)
			continue
		/// Apex and Limitless abilities are automatically given, but we want them to have said abilities in the point shop so the users know what they do.
		if(owner_rank < PSI_RANK_APEX && (P.ability_flags & PSI_FLAG_APEX))
			continue
		if(owner_rank < PSI_RANK_LIMITLESS && (P.ability_flags & PSI_FLAG_LIMITLESS))
			continue
		if(!(P.ability_flags & PSI_FLAG_CANON))
			if(owner_rank < PSI_RANK_HARMONIOUS && (P.ability_flags & PSI_FLAG_EVENT))
				continue
		if(owner_rank < PSI_RANK_HARMONIOUS && (P.ability_flags & PSI_FLAG_ANTAG))
			continue
		if(!(owner.mind in GLOB.loners.current_antagonists) && (P.ability_flags & PSI_FLAG_LONER))
			continue
		data["available_psionics"] += list(
			list(
				"name" = P.name,
				"desc"  = P.desc,
				"point_cost" = P.point_cost,
				"minimum_rank" = P.minimum_rank,
				"path" = P.type
			)
		)
	return data

/atom/movable/screen/psi/hub/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return TRUE

	switch(action)
		if("buy")
			var/psionic_path = text2path(params["buy"])
			if(ispath(psionic_path))
				var/singleton/psionic_power/P = GET_SINGLETON(psionic_path)
				if(P.point_cost > owner.psi.psi_points)
					to_chat(owner, SPAN_WARNING("You can't afford that!"))
					return
				if(P.apply(owner))
					to_chat(owner, SPAN_NOTICE("You are now capable of using [P.name]."))
					owner.psi.psi_points = max(owner.psi.psi_points - P.point_cost, 0)
					return TRUE

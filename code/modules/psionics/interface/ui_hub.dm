/obj/screen/psi/hub
	name = "Psi"
	icon_state = "psi_suppressed"
	screen_loc = "EAST-1:28,CENTER-3:11"
	hidden = FALSE
	maptext_x = 6
	maptext_y = -8
	var/image/on_cooldown

/obj/screen/psi/hub/New(var/mob/living/_owner)
	on_cooldown = image(icon, "cooldown")
	..()
	START_PROCESSING(SSprocessing, src)

/obj/screen/psi/hub/update_icon()

	if(!owner.psi)
		return

	icon_state = owner.psi.suppressed ? "psi_suppressed" : "psi_active"

/obj/screen/psi/hub/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	owner = null
	. = ..()

/obj/screen/psi/hub/process()
	if(!istype(owner))
		qdel(src)
		return
	if(!owner.psi)
		return
	maptext = "[round((owner.psi.stamina/owner.psi.max_stamina)*100)]%"
	update_icon()

/obj/screen/psi/hub/Click(var/location, var/control, var/params)
	var/list/click_params = params2list(params)
	if(click_params["shift"])
		ui_interact(owner)
		return

	if(owner.psi.suppressed && owner.psi.stun)
		to_chat(owner, "<span class='warning'>You are dazed and reeling, and cannot muster enough focus to do that!</span>")
		return

	owner.psi.suppressed = !owner.psi.suppressed
	to_chat(owner, "<span class='notice'>You are <b>[owner.psi.suppressed ? "now suppressing" : "no longer suppressing"]</b> your psi-power.</span>")
	if(owner.psi.suppressed)
		owner.psi.hide_auras()
	else
		sound_to(owner, sound('sound/effects/psi/power_unlock.ogg'))
		owner.psi.show_auras()
	update_icon()

/obj/screen/psi/hub/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "PsionicShop", "Psionic Point Shop", 400, 500)
		ui.open()

/obj/screen/psi/hub/ui_state(mob/user)
    return conscious_state

/obj/screen/psi/hub/ui_status(mob/user, datum/ui_state/state)
    return UI_INTERACTIVE

/obj/screen/psi/hub/ui_data(mob/user)
	var/list/data = list()
	data["available_psionics"] = list()
	data["psi_rank"] = psychic_ranks_to_strings[owner.psi.get_rank()]
	data["psi_points"] = owner.psi.psi_points
	data["bought_powers"] = owner.psi.psionic_powers
	for(var/singleton/psionic_power/P in GET_SINGLETON_SUBTYPE_LIST(/singleton/psionic_power))
		if(owner.psi.get_rank() < P.minimum_rank)
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

/obj/screen/psi/hub/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return TRUE

	switch(action)
		if("buy")
			var/psionic_path = text2path(params["buy"])
			if(ispath(psionic_path))
				var/singleton/psionic_power/P = GET_SINGLETON(psionic_path)
				P.apply(owner)
				to_chat(owner, SPAN_NOTICE("You are now capable of using [P.name]."))
				return TRUE

// the damage menu is a menu which you can use to damage human mobs
// it's accessible via the drop down list when you VV a human mob

/datum/tgui_module/damage_menu
	var/datum/weakref/target_human

/datum/tgui_module/damage_menu/New(var/datum/weakref/target, var/mob/user)
	var/mob/living/carbon/human/H = target.resolve()
	if(istype(H))
		target_human = target
	ui_interact(user)

/datum/tgui_module/damage_menu/ui_interact(mob/user, var/datum/tgui/ui)
	if(!user.client.holder)
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		var/human_name = "Geoff"
		var/human_ckey = "None"
		var/mob/living/carbon/H = target_human.resolve()
		if(H)
			human_name = H.real_name
			if(H.ckey)
				human_ckey = H.ckey
		ui = new(user, src, "DamageMenu", "Damage Menu | [human_name] ([human_ckey])", 600, 600)
	ui.open()

/datum/tgui_module/damage_menu/ui_data(mob/user)
	var/list/data = list()
	if(!user.client.holder)
		return

	var/mob/living/carbon/H = target_human.resolve()
	if(!istype(H))
		to_chat(user, SPAN_DANGER("The humanoid target couldn't be found, closing UI."))
		SStgui.close_uis(src)
		return

	var/list/limbs = list()
	for(var/name in H.species.has_limbs)
		limbs += list(list("name" = capitalize_first_letters(parse_zone(name)), "present" = !!H.organs_by_name[name]))
	var/list/organs = list()
	for(var/name in H.species.has_organ)
		organs += list(list("name" = capitalize_first_letters(name), "present" = !!H.internal_organs_by_name[name]))

	data["limbs"] = limbs
	data["organs"] = organs

	return data

/datum/tgui_module/damage_menu/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(!check_rights(R_ADMIN))
		return

	var/mob/living/carbon/human/H = target_human.resolve()
	if(!istype(H))
		return

	switch(action)
		if("limb")
			var/obj/item/organ/external/L = H.organs_by_name[reverse_parse_zone(lowertext(params["name"]))]
			if(!L)
				to_chat(usr, SPAN_WARNING("\The [H] doesn't have that limb!"))
				return
			switch(params["action"])
				if("brute")
					var/damage_dealt = tgui_input_number(usr, "How much brute damage do you want to deal? (Current Brute: [L.brute_dam] | Current Burn; [L.burn_dam])", "Brute Damage")
					if(damage_dealt)
						L.take_damage(damage_dealt, 0)
						log_and_message_admins("used the Damage Menu to deploy deal [damage_dealt] [params["action"]] to [H]'s [params["name"]]", usr, get_turf(H))
				if("burn")
					var/damage_dealt = tgui_input_number(usr, "How much burn damage do you want to deal? (Current Brute: [L.brute_dam] | Current Burn; [L.burn_dam])", "Burn Damage")
					if(damage_dealt)
						L.take_damage(0, damage_dealt)
						log_and_message_admins("used the Damage Menu to deploy deal [damage_dealt] [params["action"]] to [H]'s [params["name"]]", usr, get_turf(H))
				if("infection")
					switch(alert(usr, "Do you want to increase or decrease the infection level? (Current: [L.estimated_infection_level()])", "Infection Level", "Increase", "Decrease", "Cancel"))
						if("Increase")
							L.increase_germ_level()
							log_and_message_admins("used the Damage Menu to increase the infection level of [H]'s [params["name"]]", usr, get_turf(H))
						if("Decrease")
							L.decrease_germ_level()
							log_and_message_admins("used the Damage Menu to decrease the infection level of [H]'s [params["name"]]", usr, get_turf(H))
				if("shatter")
					if(L.brute_dam < L.min_broken_damage * GLOB.config.organ_health_multiplier)
						L.take_damage(L.brute_dam + ((L.min_broken_damage * GLOB.config.organ_health_multiplier) - L.brute_dam))
					L.fracture()
					log_and_message_admins("used the Damage Menu to shatter [H]'s [params["name"]]", usr, get_turf(H))
				if("arterial")
					if(L.status & ORGAN_ARTERY_CUT)
						if(alert(usr, "Do you want to stop the arterial bleeding?", "Arterial Bleeding", "Yes", "No") == "Yes")
							L.status &= ~ORGAN_ARTERY_CUT
							L.update_damages()
							log_and_message_admins("used the Damage Menu to stop an arterial bleed in [H]'s [params["name"]]", usr, get_turf(H))
					else
						if(alert(usr, "Do you want to start an arterial bleed?", "Arterial Bleeding", "Yes", "No") == "Yes")
							if(L.sever_artery())
								log_and_message_admins("used the Damage Menu to start an arterial bleed in [H]'s [params["name"]]", usr, get_turf(H))
							else
								to_chat(usr, SPAN_WARNING("For whatever reason, \the [L] cannot gain an arterial bleed!"))
				if("sever")
					switch(alert(usr, "Do you want to cleanly sever the limb, or gib it into blood and gore?", "Sever Limb", "Cleanly Sever", "Gib", "Cancel"))
						if("Cleanly Sever")
							L.droplimb(TRUE, DROPLIMB_EDGE)
							log_and_message_admins("used the Damage Menu to cleanly sever [H]'s [params["name"]]", usr, get_turf(H))
						if("Gib")
							L.droplimb(FALSE, DROPLIMB_BLUNT)
							log_and_message_admins("used the Damage Menu to gib [H]'s [params["name"]]", usr, get_turf(H))
		if("organ")
			var/obj/item/organ/internal/O = H.internal_organs_by_name[lowertext(params["name"])]
			if(!O)
				to_chat(usr, SPAN_WARNING("\The [H] doesn't have that organ!"))
				return
			switch(params["action"])
				if("damage")
					var/damage_dealt = tgui_input_number(usr, "How much damage do you want to deal? (Current Damage: [O.damage])", "Brute Damage")
					if(damage_dealt)
						O.take_internal_damage(damage_dealt)
						log_and_message_admins("used the Damage Menu to deal [damage_dealt] [params["action"]] to [H]'s [params["name"]]", usr, get_turf(H))
				if("infection")
					switch(alert(usr, "Do you want to increase or decrease the infection level? (Current: [O.estimated_infection_level()])", "Infection Level", "Increase", "Decrease", "Cancel"))
						if("Increase")
							O.increase_germ_level()
							log_and_message_admins("used the Damage Menu to increase the infection level of [H]'s [params["name"]]", usr, get_turf(H))
						if("Decrease")
							O.decrease_germ_level()
							log_and_message_admins("used the Damage Menu to decrease the infection level of [H]'s [params["name"]]", usr, get_turf(H))
				if("bruise")
					if(O.damage < O.min_bruised_damage)
						O.take_damage(O.damage + (O.min_bruised_damage - O.damage) + 1)
						log_and_message_admins("used the Damage Menu to bruise [H]'s [params["name"]]", usr, get_turf(H))
				if("break")
					if(O.damage < O.min_broken_damage)
						O.take_damage(O.damage + (O.min_broken_damage - O.damage) + 1)
						log_and_message_admins("used the Damage Menu to break [H]'s [params["name"]]", usr, get_turf(H))
				if("remove")
					O.removed(H)
					qdel(O)
					log_and_message_admins("used the Damage Menu to remove and delete [H]'s [params["name"]]", usr, get_turf(H))
		if("misc")
			log_and_message_admins("used the Damage Menu to deploy [params["action"]] on [H]", usr, get_turf(H))
			switch(params["action"])
				if("wind")
					toggle_wind_paralysis(H, usr)
				if("gigashatter")
					H.gigashatter()
				if("kill")
					H.death(FALSE)
				if("gib")
					H.gib()
				if("dust")
					H.dust()

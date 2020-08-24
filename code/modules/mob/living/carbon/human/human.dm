/mob/living/carbon/human
	name = "unknown"
	real_name = "unknown"
	voice_name = "unknown"
	icon = 'icons/mob/human.dmi'
	icon_state = "body_m_s"

	var/list/hud_list[10]
	var/embedded_flag	  //To check if we've need to roll for damage on movement while an item is imbedded in us.
	var/obj/item/rig/wearing_rig // This is very not good, but it's much much better than calling get_rig() every update_canmove() call.
	mob_size = 9//Based on average weight of a human

/mob/living/carbon/human/Initialize(mapload, var/new_species = null)
	if(!dna)
		dna = new /datum/dna(null)
		// Species name is handled by set_species()

	if(!species)
		if(new_species)
			set_species(new_species,1)
		else
			set_species()

	if(species)
		real_name = species.get_random_name(gender)
		name = real_name
		if(mind)
			mind.name = real_name

	// Randomize nutrition and hydration. Defines are in __defines/mobs.dm
	if(max_nutrition > 0)
		nutrition = rand(CREW_MINIMUM_NUTRITION*100, CREW_MAXIMUM_NUTRITION*100) * max_nutrition * 0.01
	if(max_hydration > 0)
		hydration = rand(CREW_MINIMUM_HYDRATION*100, CREW_MAXIMUM_HYDRATION*100) * max_hydration * 0.01

	hud_list[HEALTH_HUD]      = new /image/hud_overlay('icons/mob/hud_med.dmi', src, "100")
	hud_list[STATUS_HUD]      = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudhealthy")
	hud_list[ID_HUD]          = new /image/hud_overlay('icons/hud/hud_security.dmi', src, "hudunknown")
	hud_list[WANTED_HUD]      = new /image/hud_overlay('icons/hud/hud_security.dmi', src, "hudblank")
	hud_list[IMPLOYAL_HUD]    = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")
	hud_list[IMPCHEM_HUD]     = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")
	hud_list[IMPTRACK_HUD]    = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")
	hud_list[SPECIALROLE_HUD] = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")
	hud_list[STATUS_HUD_OOC]  = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudhealthy")
	hud_list[LIFE_HUD]	      = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudhealthy")

	//Scaling down the ID hud
	var/image/holder = hud_list[ID_HUD]
	holder.pixel_x = -3
	holder.pixel_y = 24
	hud_list[ID_HUD] = holder

	holder = hud_list[IMPLOYAL_HUD]
	holder.pixel_y = 2
	hud_list[IMPLOYAL_HUD] = holder

	holder = hud_list[IMPCHEM_HUD]
	holder.pixel_y = 2
	hud_list[IMPCHEM_HUD] = holder

	holder = hud_list[IMPTRACK_HUD]
	holder.pixel_y = 2
	hud_list[IMPTRACK_HUD] = holder


	holder = hud_list[WANTED_HUD]
	holder.pixel_x = -3
	holder.pixel_y = 14
	hud_list[WANTED_HUD] = holder


	human_mob_list |= src

	. = ..()

	hide_underwear.Cut()
	for(var/category in global_underwear.categories_by_name)
		hide_underwear[category] = FALSE

	if(dna)
		dna.ready_dna(src)
		dna.real_name = real_name
		sync_organ_dna()
	make_blood()

	pixel_x = species.icon_x_offset
	pixel_y = species.icon_y_offset

/mob/living/carbon/human/Destroy()
	human_mob_list -= src
	for(var/organ in organs)
		qdel(organ)
	organs = null
	internal_organs_by_name = null
	internal_organs = null
	organs_by_name = null
	bad_internal_organs = null
	bad_external_organs = null

	QDEL_NULL(vessel)

	QDEL_NULL(DS)
	// qdel and null out our equipment.
	QDEL_NULL(shoes)
	QDEL_NULL(belt)
	QDEL_NULL(gloves)
	QDEL_NULL(glasses)
	QDEL_NULL(head)
	QDEL_NULL(l_ear)
	QDEL_NULL(r_ear)
	QDEL_NULL(wear_id)
	QDEL_NULL(r_store)
	QDEL_NULL(l_store)
	QDEL_NULL(s_store)
	QDEL_NULL(wear_suit)
	// Do this last so the mob's stuff doesn't drop on del.
	QDEL_NULL(w_uniform)

	return ..()

/mob/living/carbon/human/can_devour(atom/movable/victim, var/silent = FALSE)
	if(!should_have_organ(BP_STOMACH))
		return ..()

	var/obj/item/organ/internal/stomach/stomach = internal_organs_by_name[BP_STOMACH]
	if(!stomach || !stomach.is_usable())
		if(!silent)
			to_chat(src, SPAN_WARNING("Your stomach is not functional!"))
		return FALSE

	if(!stomach.can_eat_atom(victim))
		if(!silent)
			to_chat(src, SPAN_WARNING("You are not capable of devouring \the [victim] whole!"))
		return FALSE

	if(stomach.is_full(victim))
		if(!silent)
			to_chat(src, SPAN_WARNING("Your [stomach.name] is full!"))
		return FALSE

	if(species?.gluttonous & GLUT_MESSY)
		if(ismob(victim))
			var/mob/M = victim
			if(ishuman(victim))
				to_chat(src, SPAN_WARNING("You can't devour humanoids!"))
				return FALSE
			for(var/obj/item/grab/G in M.grabbed_by)
				if(G && G.state < GRAB_NECK)
					if(!silent)
						to_chat(src, SPAN_WARNING("You need a tighter hold on \the [M]!"))
					return FALSE
		else
			return FALSE

	. = stomach.get_devour_time(victim) || ..()

/mob/living/carbon/human/get_ingested_reagents()
	if(should_have_organ(BP_STOMACH))
		var/obj/item/organ/internal/stomach/stomach = internal_organs_by_name[BP_STOMACH]
		if(stomach)
			return stomach.ingested
	return touching

/mob/living/carbon/human/proc/metabolize_ingested_reagents()
	if(should_have_organ(BP_STOMACH))
		var/obj/item/organ/internal/stomach/stomach = internal_organs_by_name[BP_STOMACH]
		if(stomach)
			stomach.metabolize()

/mob/living/carbon/human/get_fullness()
	if(!should_have_organ(BP_STOMACH))
		return ..()
	var/obj/item/organ/internal/stomach/stomach = internal_organs_by_name[BP_STOMACH]
	if(stomach)
		return nutrition + (stomach.ingested.total_volume * 10)
	return 0

/mob/living/carbon/human/Stat()
	..()
	if(statpanel("Status"))
		stat("Intent:", "[a_intent]")
		stat("Move Mode:", "[m_intent]")
		if(emergency_shuttle)
			var/eta_status = emergency_shuttle.get_status_panel_eta()
			if(eta_status)
				stat(null, eta_status)
		if(is_diona() && DS)
			stat("Biomass:", "[round(nutrition)] / [max_nutrition]")
			stat("Energy:", "[round(DS.stored_energy)] / [round(DS.max_energy)]")
			if(DS.regen_limb)
				stat("Regeneration Progress:", " [round(DS.regen_limb_progress)] / [LIMB_REGROW_REQUIREMENT]")
		if (internal)
			if (!internal.air_contents)
				qdel(internal)
			else
				stat("Internal Atmosphere Info", internal.name)
				stat("Tank Pressure", internal.air_contents.return_pressure())
				stat("Distribution Pressure", internal.distribute_pressure)

		if(back && istype(back,/obj/item/rig))
			var/obj/item/rig/suit = back
			var/cell_status = "ERROR"
			if(suit.cell) cell_status = "[suit.cell.charge]/[suit.cell.maxcharge]"
			stat(null, "Suit charge: [cell_status]")

		if(mind)
			if(mind.vampire)
				stat("Usable Blood", mind.vampire.blood_usable)
				stat("Total Blood", mind.vampire.blood_total)
			if(mind.changeling)
				stat("Chemical Storage", mind.changeling.chem_charges)
				stat("Genetic Damage Time", mind.changeling.geneticdamage)

/mob/living/carbon/human/ex_act(severity)
	if(!blinded)
		flick("flash", flash)

	var/b_loss = null
	var/f_loss = null

	if (is_diona() == DIONA_WORKER)//Thi
		diona_contained_explosion_damage(severity)

	switch (severity)
		if (1.0)
			b_loss += 500
			f_loss = 100
			if (!prob(getarmor(null, "bomb")))
				gib()
				return
			else
				var/atom/target = get_edge_target_turf(src, get_dir(src, get_step_away(src, src)))
				throw_at(target, 200, 4)
			//return
//				var/atom/target = get_edge_target_turf(user, get_dir(src, get_step_away(user, src)))
				//user.throw_at(target, 200, 4)

		if (2.0)
			b_loss = 60
			f_loss = 60

			if (!istype(l_ear, /obj/item/clothing/ears/earmuffs) && !istype(r_ear, /obj/item/clothing/ears/earmuffs))
				ear_damage += 30
				ear_deaf += 120
			if (prob(70))
				Paralyse(10)

		if(3.0)
			b_loss = 30
			if (!istype(l_ear, /obj/item/clothing/ears/earmuffs) && !istype(r_ear, /obj/item/clothing/ears/earmuffs))
				ear_damage += 15
				ear_deaf += 60
			if (prob(50))
				Paralyse(10)

	// factor in armor
	var/protection = BLOCKED_MULT(getarmor(null, "bomb"))
	b_loss *= protection
	f_loss *= protection

	var/update = 0

	// focus most of the blast on one organ
	var/obj/item/organ/external/take_blast = pick(organs)
	update |= take_blast.take_damage(b_loss * 0.7, f_loss * 0.7, used_weapon = "Explosive blast")

	// distribute the remaining 30% on all limbs equally (including the one already dealt damage)
	b_loss *= 0.3
	f_loss *= 0.3

	var/weapon_message = "Explosive Blast"

	for(var/obj/item/organ/external/temp in organs)
		switch(temp.name)
			if(BP_HEAD)
				update |= temp.take_damage(b_loss * 0.2, f_loss * 0.2, used_weapon = weapon_message)
			if(BP_CHEST)
				update |= temp.take_damage(b_loss * 0.4, f_loss * 0.4, used_weapon = weapon_message)
			if(BP_L_ARM)
				update |= temp.take_damage(b_loss * 0.05, f_loss * 0.05, used_weapon = weapon_message)
			if(BP_R_ARM)
				update |= temp.take_damage(b_loss * 0.05, f_loss * 0.05, used_weapon = weapon_message)
			if(BP_L_LEG)
				update |= temp.take_damage(b_loss * 0.05, f_loss * 0.05, used_weapon = weapon_message)
			if(BP_R_LEG)
				update |= temp.take_damage(b_loss * 0.05, f_loss * 0.05, used_weapon = weapon_message)
			if(BP_R_FOOT)
				update |= temp.take_damage(b_loss * 0.05, f_loss * 0.05, used_weapon = weapon_message)
			if(BP_L_FOOT)
				update |= temp.take_damage(b_loss * 0.05, f_loss * 0.05, used_weapon = weapon_message)
			if(BP_R_ARM)
				update |= temp.take_damage(b_loss * 0.05, f_loss * 0.05, used_weapon = weapon_message)
			if(BP_L_ARM)
				update |= temp.take_damage(b_loss * 0.05, f_loss * 0.05, used_weapon = weapon_message)
	if(update)	UpdateDamageIcon()

/mob/living/carbon/human/proc/implant_loyalty(mob/living/carbon/human/M, override = FALSE) // Won't override by default.
	if(!config.use_loyalty_implants && !override) return // Nuh-uh.

	var/obj/item/implant/mindshield/L
	if(isipc(M))
		L = new/obj/item/implant/mindshield/ipc(M)
	else
		L = new/obj/item/implant/mindshield(M)
	L.imp_in = M
	L.implanted = 1
	var/obj/item/organ/external/affected = M.organs_by_name[BP_HEAD]
	affected.implants += L
	L.part = affected
	L.implanted(src)

/mob/living/carbon/human/proc/is_loyalty_implanted(mob/living/carbon/human/M)
	for(var/L in M.contents)
		if(istype(L, /obj/item/implant/mindshield))
			for(var/obj/item/organ/external/O in M.organs)
				if(L in O.implants)
					return 1
	return 0

/mob/living/carbon/human/restrained()
	if (handcuffed)
		return 1
	if (istype(wear_suit, /obj/item/clothing/suit/straight_jacket))
		return 1
	return 0

/mob/living/carbon/human/var/co2overloadtime = null
/mob/living/carbon/human/var/temperature_resistance = T0C+75


/mob/living/carbon/human/show_inv(mob/user as mob)
	if(user.incapacitated() || !user.Adjacent(src))
		return

	var/obj/item/clothing/under/suit = null
	if(istype(w_uniform, /obj/item/clothing/under))
		suit = w_uniform

	user.set_machine(src)
	var/dat = "<B><HR><FONT size=3>[name]</FONT></B><BR><HR>"

	if(internals)
		dat += "<B>Internals: [internal ? "On" : "Off"]</B><BR>"

	if(suit)
		var/list/modes = list("Off" = 1, "Binary Sensors" = 2, "Vitals Tracker" = 3, "Tracking Beacon" = 4)
		dat += "<B>Suit Sensors: [modes[suit.sensor_mode + 1]]</B><BR>"

	if(internals || suit)
		dat += "<HR>"

	for(var/entry in species.hud.gear)
		var/list/slot_ref = species.hud.gear[entry]
		if((slot_ref["slot"] in list(slot_l_store, slot_r_store)))
			continue
		var/obj/item/thing_in_slot = get_equipped_item(slot_ref["slot"])
		dat += "<BR><B>[slot_ref["name"]]:</b> <a href='?src=\ref[src];item=[slot_ref["slot"]]'>[istype(thing_in_slot) ? thing_in_slot : "nothing"]</a>"

	dat += "<BR><HR>"

	if(species.hud.has_hands)
		dat += "<BR><b>Left hand:</b> <A href='?src=\ref[src];item=[slot_l_hand]'>[istype(l_hand) ? l_hand : "nothing"]</A>"
		dat += "<BR><b>Right hand:</b> <A href='?src=\ref[src];item=[slot_r_hand]'>[istype(r_hand) ? r_hand : "nothing"]</A>"

	var/has_mask // 0, no mask | 1, mask but it's down | 2, mask and it's ready
	var/has_helmet
	if(istype(wear_mask, /obj/item/clothing/mask))
		var/obj/item/clothing/mask/M = wear_mask
		has_mask = 1
		if(!M.hanging)
			has_mask = 2
	if(istype(head, /obj/item/clothing/head/helmet/space))
		has_helmet = TRUE

	var/has_tank
	if(istype(back, /obj/item/tank) || istype(belt, /obj/item/tank) || istype(s_store, /obj/item/tank))
		has_tank = TRUE

	if((has_mask == 2|| has_helmet) && has_tank)
		dat += "<BR><A href='?src=\ref[src];item=internals'>Toggle internals [internal ? "off" : "on"]</A>"

	// Other incidentals.
	if(istype(suit) && suit.has_sensor == 1)
		dat += "<BR><A href='?src=\ref[src];item=sensors'>Set sensors</A>"
	if(handcuffed)
		dat += "<BR><A href='?src=\ref[src];item=[slot_handcuffed]'>Handcuffed</A>"
	if(legcuffed)
		dat += "<BR><A href='?src=\ref[src];item=[slot_legcuffed]'>Legcuffed</A>"

	if(has_mask)
		var/obj/item/clothing/mask/M = wear_mask
		if(M.adjustable)
			dat += "<BR><A href='?src=\ref[src];item=mask'>Adjust mask</A>"
	if(has_tank && internal)
		dat += "<BR><A href='?src=\ref[src];item=tank'>Check air tank</A>"
	if(suit && LAZYLEN(suit.accessories))
		dat += "<BR><A href='?src=\ref[src];item=tie'>Remove accessory</A>"
	dat += "<BR><A href='?src=\ref[src];item=splints'>Remove splints</A>"
	dat += "<BR><A href='?src=\ref[src];item=pockets'>Empty pockets</A>"
	dat += "<BR><A href='?src=\ref[user];refresh=1'>Refresh</A>"
	dat += "<BR><A href='?src=\ref[user];mach_close=mob[name]'>Close</A>"

	user << browse(dat, text("window=mob[name];size=340x540"))
	onclose(user, "mob[name]")
	return

// called when something steps onto a human
// this handles mulebots and vehicles
/mob/living/carbon/human/Crossed(var/atom/movable/AM)
	..()
	if(istype(AM, /obj/machinery/bot/mulebot))
		var/obj/machinery/bot/mulebot/MB = AM
		MB.RunOver(src)

	if(istype(AM, /obj/vehicle))
		var/obj/vehicle/V = AM
		V.RunOver(src)

// Get rank from ID, ID inside PDA, PDA, ID in wallet, etc.
/mob/living/carbon/human/proc/get_authentification_rank(var/if_no_id = "No id", var/if_no_job = "No job")
	var/obj/item/device/pda/pda = wear_id
	if (istype(pda))
		if (pda.id)
			return pda.id.rank
		else
			return pda.ownrank
	else
		var/obj/item/card/id/id = get_idcard()
		if(id)
			return id.rank ? id.rank : if_no_job
		else
			return if_no_id

//gets assignment from ID or ID inside PDA or PDA itself
//Useful when player do something with computers
/mob/living/carbon/human/proc/get_assignment(var/if_no_id = "No ID", var/if_no_job = "No Job")
	var/obj/item/card/id/I = GetIdCard()
	if(istype(I))
		return I.assignment ? I.assignment : if_no_job
	else
		return if_no_id

//gets name from ID or ID inside PDA or PDA itself
//Useful when player do something with computers
/mob/living/carbon/human/proc/get_authentification_name(var/if_no_id = "Unknown")
	var/obj/item/card/id/I = GetIdCard()
	if(istype(I))
		return I.registered_name
	else
		return if_no_id

//repurposed proc. Now it combines get_id_name() and get_face_name() to determine a mob's name variable. Made into a seperate proc as it'll be useful elsewhere
/mob/living/carbon/human/proc/get_visible_name()
	if( wear_mask && (wear_mask.flags_inv&HIDEFACE) )	//Wearing a mask which hides our face, use id-name if possible
		return get_id_name("Unknown")
	if( head && (head.flags_inv&HIDEFACE) )
		return get_id_name("Unknown")		//Likewise for hats
	var/face_name = get_face_name()
	var/id_name = get_id_name("")
	if(id_name && (id_name != face_name))
		return "[face_name] (as [id_name])"
	return face_name

//Returns "Unknown" if facially disfigured and real_name if not. Useful for setting name when polyacided or when updating a human's name variable
/mob/living/carbon/human/proc/get_face_name()
	var/obj/item/organ/external/head = get_organ(BP_HEAD)
	if(!head || head.disfigured || head.is_stump() || !real_name || (HUSK in mutations) )	//disfigured. use id-name if possible
		return "Unknown"
	return real_name

//gets name from ID or PDA itself, ID inside PDA doesn't matter
//Useful when player is being seen by other mobs
/mob/living/carbon/human/proc/get_id_name(var/if_no_id = "Unknown")
	. = if_no_id
	if(istype(wear_id,/obj/item/device/pda))
		var/obj/item/device/pda/P = wear_id
		return P.owner
	if(wear_id)
		var/obj/item/card/id/I = wear_id.GetID()
		if(I)
			return I.registered_name
	return

//gets ID card object from special clothes slot or null.
/mob/living/carbon/human/proc/get_idcard()
	if(wear_id)
		return wear_id.GetID()

/mob/living/carbon/human/electrocute_act(var/shock_damage, var/obj/source, var/base_siemens_coeff = 1.0, var/def_zone = null, var/tesla_shock = 0, var/ground_zero)
	var/list/damage_areas = list()
	if(status_flags & GODMODE)	return 0	//godmode

	if (!tesla_shock)
		shock_damage *= base_siemens_coeff
	if (shock_damage<1)
		return 0

	var/obj/item/organ/internal/augment/tesla/tesla = internal_organs_by_name[BP_AUG_TESLA]
	if(tesla?.check_shock())
		tesla.actual_charges = min(tesla.actual_charges+1, tesla.max_charges)
		return FALSE

	if(!def_zone)
		//The way this works is by damaging multiple areas in an "Arc" if no def_zone is provided. should be pretty easy to add more arcs if it's needed. though I can't imangine a situation that can apply.
		switch ((h_style == "Floorlength Braid" || h_style == "Very Long Hair") ? rand(1, 7) : rand(1, 6))
			if(1)
				damage_areas = list(BP_L_HAND, BP_L_ARM, BP_CHEST, BP_R_ARM, BP_R_HAND)
			if(2)
				damage_areas = list(BP_R_HAND, BP_R_ARM, BP_CHEST, BP_L_ARM, BP_L_HAND)
			if(3)
				damage_areas = list(BP_L_HAND, BP_L_ARM, BP_CHEST, BP_GROIN, BP_L_LEG, BP_L_FOOT)
			if(4)
				damage_areas = list(BP_L_HAND, BP_L_ARM, BP_CHEST, BP_GROIN, BP_R_LEG, BP_R_FOOT)
			if(5)
				damage_areas = list(BP_R_HAND, BP_R_ARM, BP_CHEST, BP_GROIN, BP_R_LEG, BP_R_FOOT)
			if(6)
				damage_areas = list(BP_R_HAND, BP_R_ARM, BP_CHEST, BP_GROIN, BP_L_LEG, BP_L_FOOT)
			if(7)//snowflake arc - only happens when they have long hair.
				damage_areas = list(BP_R_HAND, BP_R_ARM, BP_CHEST, BP_HEAD)
				h_style = "skinhead"
				visible_message(SPAN_WARNING("[src]'s hair gets a burst of electricty through it, burning and turning to dust!"), SPAN_DANGER("your hair burns as the current flows through it, turning to dust!"), SPAN_NOTICE("You hear a crackling sound, and smell burned hair!."))
				update_hair()
	else
		damage_areas = list(def_zone)

	if(!ground_zero)
		ground_zero = pick(damage_areas)

	if(!(ground_zero in damage_areas))
		damage_areas.Add(ground_zero) //sucks to suck, get more zappy time bitch

	var/obj/item/organ/external/contact = get_organ(check_zone(ground_zero))
	shock_damage *= get_siemens_coefficient_organ(contact)

	var/obj/item/organ/external/affecting
	for (var/area in damage_areas)
		affecting = get_organ(check_zone(area))
		var/emp_damage
		switch(shock_damage)
			if(-INFINITY to 5)
				emp_damage = 0
			if(6 to 19)
				emp_damage = 3
			if(20 to 49)
				emp_damage = 2
			else
				emp_damage = 1

		if(emp_damage)
			for(var/obj/item/organ/O in affecting.internal_organs)
				O.emp_act(emp_damage)
				emp_damage *= 0.4
			for(var/obj/item/I in affecting.implants)
				I.emp_act(emp_damage)
				emp_damage *= 0.4
			for(var/obj/item/I in affecting)
				I.emp_act(emp_damage)
				emp_damage *= 0.4

		apply_damage(shock_damage, BURN, area, used_weapon="Electrocution")
		shock_damage *= 0.4
		playsound(loc, "sparks", 50, 1, -1)

	if (shock_damage > 15)
		visible_message(
		SPAN_WARNING("[src] was shocked by the [source]!"),
		SPAN_DANGER("You feel a powerful shock course through your body!"),
		SPAN_WARNING("You hear a heavy electrical crack.")
		)
		Stun(10)//This should work for now, more is really silly and makes you lay there forever
		Weaken(10)

	else
		visible_message(
		SPAN_WARNING("[src] was mildly shocked by the [source]."),
		SPAN_WARNING("You feel a mild shock course through your body."),
		SPAN_WARNING("You hear a light zapping.")
		)

	spark(loc, 5, alldirs)

	return shock_damage

/mob/living/carbon/human/Topic(href, href_list)
	if (href_list["refresh"])
		if((machine)&&(in_range(src, usr)))
			show_inv(machine)

	if (href_list["mach_close"])
		var/t1 = text("window=[]", href_list["mach_close"])
		unset_machine()
		src << browse(null, t1)

	if(href_list["item"])
		handle_strip(href_list["item"],usr)

	if(href_list["criminal"])
		if(hasHUD(usr,"security"))

			var/modified = 0
			var/perpname = "wot"
			if(wear_id)
				var/obj/item/card/id/I = wear_id.GetID()
				if(I)
					perpname = I.registered_name
				else
					perpname = name
			else
				perpname = name

			if(perpname)
				var/datum/record/general/R = SSrecords.find_record("name", perpname)
				if(istype(R) && istype(R.security))
					var/setcriminal = input(usr, "Specify a new criminal status for this person.", "Security HUD", ) in list("None", "*Arrest*", "Search", "Incarcerated", "Parolled", "Released", "Cancel")
					if(hasHUD(usr, "security"))
						if(setcriminal != "Cancel")
							R.security.criminal = setcriminal
							modified = 1

							spawn()
								BITSET(hud_updateflag, WANTED_HUD)
								if(istype(usr,/mob/living/carbon/human))
									var/mob/living/carbon/human/U = usr
									U.handle_regular_hud_updates()
								if(istype(usr,/mob/living/silicon/robot))
									var/mob/living/silicon/robot/U = usr
									U.handle_regular_hud_updates()

			if(!modified)
				to_chat(usr, SPAN_WARNING("Unable to locate a data core entry for this person."))

	if (href_list["secrecord"])
		if(hasHUD(usr,"security"))
			var/perpname = "wot"
			var/read = 0

			if(wear_id)
				if(istype(wear_id,/obj/item/card/id))
					perpname = wear_id:registered_name
				else if(istype(wear_id,/obj/item/device/pda))
					var/obj/item/device/pda/tempPda = wear_id
					perpname = tempPda.owner
			else
				perpname = src.name
			var/datum/record/general/R = SSrecords.find_record("name", perpname)
			if(istype(R) && istype(R.security))
				if(hasHUD(usr,"security"))
					to_chat(usr, "<b>Name:</b> [R.name]]	<b>Criminal Status:</b> [R.security.criminal]")
					to_chat(usr, "<b>Crimes:</b> [R.security.crimes]")
					to_chat(usr, "<b>Notes:</b> [R.security.notes]")
					to_chat(usr, "<a href='?src=\ref[src];secrecordComment=`'>\[View Comment Log\]</a>")
					read = 1

			if(!read)
				to_chat(usr, SPAN_WARNING("Unable to locate a data core entry for this person."))

	if (href_list["secrecordComment"])
		if(hasHUD(usr,"security"))
			var/perpname = "wot"
			var/read = 0

			if(wear_id)
				if(istype(wear_id,/obj/item/card/id))
					perpname = wear_id:registered_name
				else if(istype(wear_id,/obj/item/device/pda))
					var/obj/item/device/pda/tempPda = wear_id
					perpname = tempPda.owner
			else
				perpname = src.name
			var/datum/record/general/R = SSrecords.find_record("name", perpname)
			if(istype(R) && istype(R.security))
				if(hasHUD(usr, "security"))
					read = 1
					if(R.security.comments.len > 0)
						for(var/comment in R.security.comments)
							to_chat(usr, comment)
					else
						to_chat(usr, "No comments found")
					to_chat(usr, "<a href='?src=\ref[src];secrecordadd=`'>\[Add comment\]</a>")

			if(!read)
				to_chat(usr, SPAN_WARNING("Unable to locate a data core entry for this person."))

	if (href_list["secrecordadd"])
		if(hasHUD(usr,"security"))
			var/perpname = "wot"
			if(wear_id)
				if(istype(wear_id,/obj/item/card/id))
					perpname = wear_id:registered_name
				else if(istype(wear_id,/obj/item/device/pda))
					var/obj/item/device/pda/tempPda = wear_id
					perpname = tempPda.owner
			else
				perpname = src.name
			var/datum/record/general/R = SSrecords.find_record("name", perpname)
			if(istype(R) && istype(R.security))
				var/t1 = sanitize(input("Add Comment:", "Sec. records", null, null)  as message)
				if ( !(t1) || usr.stat || usr.restrained() || !(hasHUD(usr,"security")) )
					return
				if(istype(usr,/mob/living/carbon/human))
					var/mob/living/carbon/human/U = usr
					R.security.comments += text("Made by [U.get_authentification_name()] ([U.get_assignment()]) on [time2text(world.realtime, "DDD MMM DD hh:mm:ss")], [game_year]<BR>[t1]")
				if(istype(usr,/mob/living/silicon/robot))
					var/mob/living/silicon/robot/U = usr
					R.security.comments += text("Made by [U.name] ([U.mod_type] [U.braintype]) on [time2text(world.realtime, "DDD MMM DD hh:mm:ss")], [game_year]<BR>[t1]")

	if (href_list["medical"])
		if(hasHUD(usr,"medical"))
			var/perpname = "wot"
			var/modified = 0

			if(wear_id)
				if(istype(wear_id,/obj/item/card/id))
					perpname = wear_id:registered_name
				else if(istype(wear_id,/obj/item/device/pda))
					var/obj/item/device/pda/tempPda = wear_id
					perpname = tempPda.owner
			else
				perpname = src.name

			var/datum/record/general/R = SSrecords.find_record("name", perpname)
			if(istype(R))
				var/setmedical = input(usr, "Specify a new medical status for this person.", "Medical HUD", R.physical_status) in list("*SSD*", "*Deceased*", "Physically Unfit", "Active", "Disabled", "Cancel")

				if(hasHUD(usr,"medical"))
					if(setmedical != "Cancel")
						R.physical_status = setmedical
						modified = 1
						SSrecords.reset_manifest()

						spawn()
							if(istype(usr,/mob/living/carbon/human))
								var/mob/living/carbon/human/U = usr
								U.handle_regular_hud_updates()
							if(istype(usr,/mob/living/silicon/robot))
								var/mob/living/silicon/robot/U = usr
								U.handle_regular_hud_updates()

			if(!modified)
				to_chat(usr, SPAN_WARNING("Unable to locate a data core entry for this person."))

	if (href_list["medrecord"])
		if(hasHUD(usr,"medical"))
			var/perpname = "wot"
			var/read = 0

			if(wear_id)
				if(istype(wear_id,/obj/item/card/id))
					perpname = wear_id:registered_name
				else if(istype(wear_id,/obj/item/device/pda))
					var/obj/item/device/pda/tempPda = wear_id
					perpname = tempPda.owner
			else
				perpname = src.name
			var/datum/record/general/R = SSrecords.find_record("name", perpname)
			if(istype(R) && istype(R.medical))
				if(hasHUD(usr, "medical"))
					to_chat(usr, "<b>Name:</b> [R.name]	<b>Blood Type:</b> [R.medical.blood_type]")
					to_chat(usr, "<b>DNA:</b> [R.medical.blood_dna]")
					to_chat(usr, "<b>Disabilities:</b> [R.medical.disabilities]")
					to_chat(usr, "<b>Notes:</b> [R.medical.notes]")
					to_chat(usr, "<a href='?src=\ref[src];medrecordComment=`'>\[View Comment Log\]</a>")
					read = 1

			if(!read)
				to_chat(usr, SPAN_WARNING("Unable to locate a data core entry for this person."))

	if (href_list["medrecordComment"])
		if(hasHUD(usr,"medical"))
			var/perpname = "wot"
			var/read = 0

			if(wear_id)
				if(istype(wear_id,/obj/item/card/id))
					perpname = wear_id:registered_name
				else if(istype(wear_id,/obj/item/device/pda))
					var/obj/item/device/pda/tempPda = wear_id
					perpname = tempPda.owner
			else
				perpname = src.name
			var/datum/record/general/R = SSrecords.find_record("name", perpname)
			if(istype(R) && istype(R.medical))
				if(hasHUD(usr, "medical"))
					read = 1
					if(R.medical.comments.len > 0)
						for(var/comment in R.medical.comments)
							to_chat(usr, comment)
					else
						to_chat(usr, "No comments found")
					to_chat(usr, "<a href='?src=\ref[src];medrecordadd=`'>\[Add comment\]</a>")

			if(!read)
				to_chat(usr, SPAN_WARNING("Unable to locate a data core entry for this person."))

	if (href_list["medrecordadd"])
		if(hasHUD(usr,"medical"))
			var/perpname = "wot"
			if(wear_id)
				if(istype(wear_id,/obj/item/card/id))
					perpname = wear_id:registered_name
				else if(istype(wear_id,/obj/item/device/pda))
					var/obj/item/device/pda/tempPda = wear_id
					perpname = tempPda.owner
			else
				perpname = src.name
			var/datum/record/general/R = SSrecords.find_record("name", perpname)
			if(istype(R) && istype(R.medical))
				var/t1 = sanitize(input("Add Comment:", "Med. records", null, null)  as message)
				if ( !(t1) || use_check(usr) || !(hasHUD(usr,"medical")) )
					return
				if(ishuman(usr))
					var/mob/living/carbon/human/U = usr
					R.medical.comments += text("Made by [U.get_authentification_name()] ([U.get_assignment()]) on [time2text(world.realtime, "DDD MMM DD hh:mm:ss")], [game_year]<BR>[t1]")
				if(isrobot(usr))
					var/mob/living/silicon/robot/U = usr
					R.medical.comments += text("Made by [U.name] ([U.mod_type] [U.braintype]) on [time2text(world.realtime, "DDD MMM DD hh:mm:ss")], [game_year]<BR>[t1]")

	if (href_list["lookitem"])
		var/obj/item/I = locate(href_list["lookitem"])
		if(!I)
			return
		src.examinate(I)

	if (href_list["lookitem_desc_only"])
		var/obj/item/I = locate(href_list["lookitem_desc_only"])
		if(!I)
			return
		usr.examinate(I, 1)

	if (href_list["lookmob"])
		var/mob/M = locate(href_list["lookmob"])
		if(!M)
			return
		src.examinate(M)

	if (href_list["flavor_change"])
		if(src != usr)
			log_and_message_admins("attempted to use a exploit to change the flavor text of [src]", usr)
			return
		switch(href_list["flavor_change"])
			if("done")
				src << browse(null, "window=flavor_changes")
				return
			if("general")
				var/msg = sanitize(input(usr,"Update the general description of your character. This will be shown regardless of clothing, and may include OOC notes and preferences.","Flavor Text",html_decode(flavor_texts[href_list["flavor_change"]])) as message, extra = 0)
				flavor_texts[href_list["flavor_change"]] = msg
				return
			else
				var/msg = sanitize(input(usr,"Update the flavor text for your [href_list["flavor_change"]].","Flavor Text",html_decode(flavor_texts[href_list["flavor_change"]])) as message, extra = 0)
				flavor_texts[href_list["flavor_change"]] = msg
				set_flavor()
				return
	..()
	return

///eyecheck()
///Returns a number between -1 to 2
/mob/living/carbon/human/eyecheck(ignore_inherent = FALSE)
	if(!species.vision_organ || !species.has_organ[species.vision_organ]) //No eyes, can't hurt them.
		return FLASH_PROTECTION_MAJOR

	var/obj/item/organ/I = get_eyes()	// Eyes are fucked, not a 'weak point'.
	if (I && I.status & ORGAN_CUT_AWAY)
		return FLASH_PROTECTION_MAJOR

	if (ignore_inherent)
		return flash_protection

	return species.inherent_eye_protection ? max(species.inherent_eye_protection, flash_protection) : flash_protection

//Used by various things that knock people out by applying blunt trauma to the head.
//Checks that the species has a BP_HEAD (brain containing organ) and that hit_zone refers to it.
/mob/living/carbon/human/proc/headcheck(var/target_zone, var/brain_tag = BP_BRAIN)
	if(!species.has_organ[brain_tag])
		return 0

	var/obj/item/organ/affecting = internal_organs_by_name[brain_tag]

	target_zone = check_zone(target_zone)
	if(!affecting || affecting.parent_organ != target_zone)
		return 0

	//if the parent organ is significantly larger than the brain organ, then hitting it is not guaranteed
	var/obj/item/organ/parent = get_organ(target_zone)
	if(!parent)
		return 0

	if(parent.w_class > affecting.w_class + 1)
		return prob(100 / 2**(parent.w_class - affecting.w_class - 1))

	return 1

/mob/living/carbon/human/IsAdvancedToolUser(var/silent)

	if(is_berserk())
		if(!silent)
			to_chat(src, SPAN_WARNING("You are in no state to use that!"))
		return 0

	if(!species.has_fine_manipulation)
		if(!silent)
			to_chat(src, SPAN_WARNING("You don't have the dexterity to use that!"))
		return 0

	if(disabilities & MONKEYLIKE)
		if(!silent)
			to_chat(src, SPAN_WARNING("You don't have the dexterity to use that!"))
		return 0

	return 1

/mob/living/carbon/human/abiotic(var/full_body = 0)
	if(full_body && ((src.l_hand && !( src.l_hand.abstract )) || (src.r_hand && !( src.r_hand.abstract )) || (src.back || src.wear_mask || src.head || src.shoes || src.w_uniform || src.wear_suit || src.glasses || src.l_ear || src.r_ear || src.gloves)))
		return 1

	if( (src.l_hand && !src.l_hand.abstract) || (src.r_hand && !src.r_hand.abstract) )
		return 1

	return 0


/mob/living/carbon/human/proc/check_dna()
	dna.check_integrity(src)
	return

/mob/living/carbon/human/get_species(var/reference = 0)
	if(!species)
		set_species()
	if (reference)
		return species
	else
		return species.name

/mob/living/carbon/human/proc/play_xylophone()
	if(!src.xylophone)
		visible_message(SPAN_WARNING("\The [src] begins playing \his ribcage like a xylophone. It's quite spooky."), SPAN_NOTICE("You begin to play a spooky refrain on your ribcage."), SPAN_WARNING("You hear a spooky xylophone melody."))
		var/song = pick('sound/effects/xylophone1.ogg','sound/effects/xylophone2.ogg','sound/effects/xylophone3.ogg')
		playsound(loc, song, 50, 1, -1)
		xylophone = 1
		spawn(1200)
			xylophone=0
	return

/mob/living/carbon/human/proc/check_has_mouth()
	// Todo, check stomach organ when implemented.
	var/obj/item/organ/external/head/H = get_organ(BP_HEAD)
	if(!H || !H.can_intake_reagents)
		return 0
	return 1

/mob/living/proc/empty_stomach()
	return

/mob/living/carbon/human/empty_stomach()
	Stun(3)

	var/obj/item/organ/internal/stomach/stomach = internal_organs_by_name[BP_STOMACH]
	var/nothing_to_puke = FALSE
	if(should_have_organ(BP_STOMACH))
		if(!istype(stomach) || (stomach.ingested.total_volume <= 5 && stomach.contents.len == 0))
			nothing_to_puke = TRUE
	else if(!(locate(/mob) in contents))
		nothing_to_puke = TRUE

	if(nothing_to_puke)
		custom_emote(1,"dry heaves.")
		return

	var/list/vomitCandidate = typecacheof(/obj/machinery/disposal) + typecacheof(/obj/structure/sink) + typecacheof(/obj/structure/toilet)
	var/obj/vomitReceptacle
	for(var/obj/vessel in view(1, src))
		if(!is_type_in_typecache(vessel, vomitCandidate))
			continue
		if(!vessel.Adjacent(src))
			continue
		vomitReceptacle = vessel
		break

	var/obj/effect/decal/cleanable/vomit/splat
	if(vomitReceptacle)
		src.visible_message(SPAN_WARNING("[src] vomits into \the [vomitReceptacle]!"), SPAN_WARNING("You vomit into \the [vomitReceptacle]!"))
		splat = new /obj/effect/decal/cleanable/vomit(vomitReceptacle)
	else
		src.visible_message(SPAN_WARNING("\The [src] vomits!"), SPAN_WARNING("You vomit!"))
		var/turf/location = loc
		if(istype(location, /turf/simulated))
			splat = new /obj/effect/decal/cleanable/vomit(location)

	if(should_have_organ(BP_STOMACH))
		for(var/a in stomach.contents)
			var/atom/movable/A = a
			if(vomitReceptacle)
				A.dropInto(vomitReceptacle)
			else
				A.dropInto(get_turf(src))
			if((species.gluttonous & GLUT_PROJECTILE_VOMIT) && !vomitReceptacle)
				A.throw_at(get_edge_target_turf(src,dir),7,7,src)
	else
		for(var/mob/M in contents)
			if(vomitReceptacle)
				M.dropInto(vomitReceptacle)
			else
				M.dropInto(get_turf(src))
			if((species.gluttonous & GLUT_PROJECTILE_VOMIT) && !vomitReceptacle)
				M.throw_at(get_edge_target_turf(src,dir),7,7,src)

	if(stomach.ingested.total_volume)
		stomach.ingested.trans_to_obj(splat, min(15, stomach.ingested.total_volume))
	handle_additional_vomit_reagents(splat)
	splat.update_icon()

	playsound(get_turf(src), 'sound/effects/splat.ogg', 50, 1)

/mob/living/carbon/human/proc/vomit(var/timevomit = 1, var/level = 3, var/deliberate = FALSE)

	set waitfor = 0

	if(!check_has_mouth() || isSynthetic() || !timevomit || !level || stat == DEAD || lastpuke)
		return

	if(deliberate)
		if(incapacitated())
			to_chat(src, SPAN_WARNING("You cannot do that right now."))
			return
		visible_message(SPAN_WARNING("\The [src] retches a bit..."))
		if(!do_after(src, 30))
			return
		timevomit = max(timevomit, 5)

	timevomit = Clamp(timevomit, 1, 10)
	level = Clamp(level, 1, 3)

	lastpuke = TRUE
	to_chat(src, SPAN_WARNING("You feel nauseous..."))
	if(level > 1)
		sleep(150 / timevomit)	//15 seconds until second warning
		to_chat(src, SPAN_WARNING("You feel like you are about to throw up!"))
		if(level > 2)
			sleep(100 / timevomit)	//and you have 10 more for mad dash to the bucket
			empty_stomach()
	sleep(350)	//wait 35 seconds before next volley
	lastpuke = FALSE

// A damaged stomach can put blood in your vomit.
/mob/living/carbon/human/handle_additional_vomit_reagents(var/obj/effect/decal/cleanable/vomit/vomit)
	..()
	if(should_have_organ(BP_STOMACH))
		var/obj/item/organ/internal/stomach/stomach = internal_organs_by_name[BP_STOMACH]
		if(!stomach || stomach.is_broken() || (stomach.is_bruised() && prob(stomach.damage)))
			if(should_have_organ(BP_HEART))
				vessel.trans_to_obj(vomit, 5)
			else
				reagents.trans_to_obj(vomit, 5)

/mob/living/carbon/human/get_digestion_product()
	return species.get_digestion_product(src)

/mob/living/carbon/human/proc/morph()
	set name = "Morph"
	set category = "Superpower"

	if(stat!=CONSCIOUS)
		reset_view(0)
		remoteview_target = null
		return

	if(!(mMorph in mutations))
		src.verbs -= /mob/living/carbon/human/proc/morph
		return

	var/new_facial = input("Please select facial hair color.", "Character Generation",rgb(r_facial,g_facial,b_facial)) as color
	if(new_facial)

		r_facial = hex2num(copytext(new_facial, 2, 4))
		g_facial = hex2num(copytext(new_facial, 4, 6))
		b_facial = hex2num(copytext(new_facial, 6, 8))

	var/new_hair = input("Please select hair color.", "Character Generation",rgb(r_hair,g_hair,b_hair)) as color
	if(new_facial)
		r_hair = hex2num(copytext(new_hair, 2, 4))
		g_hair = hex2num(copytext(new_hair, 4, 6))
		b_hair = hex2num(copytext(new_hair, 6, 8))

	var/new_eyes = input("Please select eye color.", "Character Generation",rgb(r_eyes,g_eyes,b_eyes)) as color
	if(new_eyes)
		r_eyes = hex2num(copytext(new_eyes, 2, 4))
		g_eyes = hex2num(copytext(new_eyes, 4, 6))
		b_eyes = hex2num(copytext(new_eyes, 6, 8))
		update_eyes()

	var/new_tone = input("Please select skin tone level: 1-220 (1=albino, 35=caucasian, 150=black, 220='very' black)", "Character Generation", "[35-s_tone]")  as text

	if (!new_tone)
		new_tone = 35
	s_tone = max(min(round(text2num(new_tone)), 220), 1)
	s_tone =  -s_tone + 35

	// hair
	var/list/all_hairs = typesof(/datum/sprite_accessory/hair) - /datum/sprite_accessory/hair
	var/list/hairs = list()

	// loop through potential hairs
	for(var/x in all_hairs)
		var/datum/sprite_accessory/hair/H = new x // create new hair datum based on type x
		hairs.Add(H.name) // add hair name to hairs
		qdel(H) // delete the hair after it's all done

	var/new_style = input("Please select hair style", "Character Generation",h_style)  as null|anything in hairs

	// if new style selected (not cancel)
	if (new_style)
		h_style = new_style

	// facial hair
	var/list/all_fhairs = typesof(/datum/sprite_accessory/facial_hair) - /datum/sprite_accessory/facial_hair
	var/list/fhairs = list()

	for(var/x in all_fhairs)
		var/datum/sprite_accessory/facial_hair/H = new x
		fhairs.Add(H.name)
		qdel(H)

	new_style = input("Please select facial style", "Character Generation",f_style)  as null|anything in fhairs

	if(new_style)
		f_style = new_style

	var/new_gender = alert(usr, "Please select gender.", "Character Generation", "Male", "Female")
	if (new_gender)
		if(new_gender == "Male")
			gender = MALE
		else
			gender = FEMALE
	regenerate_icons()
	check_dna()

	visible_message(SPAN_NOTICE("\The [src] morphs and changes [get_visible_gender() == MALE ? "his" : get_visible_gender() == FEMALE ? "her" : "their"] appearance!"), SPAN_NOTICE("You change your appearance!"), SPAN_WARNING("Oh, god!  What the hell was that?  It sounded like flesh getting squished and bone ground into a different shape!"))

/mob/living/carbon/human/proc/remotesay()
	set name = "Project mind"
	set category = "Superpower"

	if(stat!=CONSCIOUS)
		reset_view(0)
		remoteview_target = null
		return

	if(!(mRemotetalk in src.mutations))
		src.verbs -= /mob/living/carbon/human/proc/remotesay
		return
	var/list/creatures = list()
	for(var/hh in human_mob_list)
		var/mob/living/carbon/human/H = hh
		if (H.client)
			creatures += hh

	var/mob/target = input("Who do you want to project your mind to ?") as null|anything in creatures
	if (isnull(target))
		return

	var/say = sanitize(input("What do you wish to say"))
	if(mRemotetalk in target.mutations)
		target.show_message(SPAN_NOTICE("You hear [src.real_name]'s voice: [say]"))
	else
		target.show_message(SPAN_NOTICE("You hear a voice that seems to echo around the room: [say]"))
	usr.show_message(SPAN_NOTICE("You project your mind into [target.real_name]: [say]"))
	log_say("[key_name(usr)] sent a telepathic message to [key_name(target)]: [say]",ckey=key_name(usr))
	for(var/mob/abstract/observer/G in dead_mob_list)
		G.show_message("<i>Telepathic message from <b>[src]</b> to <b>[target]</b>: [say]</i>")

/mob/living/carbon/human/proc/remoteobserve()
	set name = "Remote View"
	set category = "Superpower"

	if(stat!=CONSCIOUS)
		remoteview_target = null
		reset_view(0)
		return

	if(!(mRemote in src.mutations))
		remoteview_target = null
		reset_view(0)
		src.verbs -= /mob/living/carbon/human/proc/remoteobserve
		return

	if(client.eye != client.mob)
		remoteview_target = null
		reset_view(0)
		return

	var/list/mob/creatures = list()

	for(var/h in human_mob_list)
		var/mob/living/carbon/human/H = h
		if (!H.client)
			continue

		var/turf/temp_turf = get_turf(H)
		if((temp_turf.z != 1 && temp_turf.z != 5) || H.stat!=CONSCIOUS) //Not on mining or the station. Or dead
			continue
		creatures += h

	var/mob/target = input ("Who do you want to project your mind to ?") as mob in creatures

	if (target)
		remoteview_target = target
		reset_view(target)
	else
		remoteview_target = null
		reset_view(0)

/mob/living/carbon/human/succumb()
	set hidden = TRUE

	if(shock_stage > 50 && (maxHealth * 0.6) > get_total_health())
		adjustBrainLoss(health + maxHealth * 2) // Deal 2x health in BrainLoss damage, as before but variable.
		to_chat(src, SPAN_NOTICE("You have given up life and succumbed to death."))
	else
		to_chat(src, SPAN_WARNING("You are not injured enough to succumb to death!"))

/mob/living/carbon/human/proc/get_visible_gender()
	if(wear_suit && wear_suit.flags_inv & HIDEJUMPSUIT && ((head && head.flags_inv & HIDEMASK) || wear_mask))
		return NEUTER
	return gender

/mob/living/carbon/human/proc/increase_germ_level(n)
	if(gloves)
		gloves.germ_level += n
	else
		germ_level += n

/mob/living/carbon/human/revive(reset_to_roundstart = TRUE)

	if(species && !(species.flags & NO_BLOOD))
		vessel.add_reagent(/datum/reagent/blood,560-vessel.total_volume)
		fixblood()

	// Fix up all organs.
	species.create_organs(src)

	var/datum/preferences/prefs
	if (client)
		prefs = client.prefs
	else if (ckey)	// Mob might be logged out.
		prefs = preferences_datums[ckey(ckey)]	// run the ckey through ckey() here so that aghosted mobs can be rejuv'd too. (Their ckeys are prefixed with @)

	if (prefs && real_name == prefs.real_name)
		// Re-apply the mob's markings and prosthetics if their pref is their current char.
		sync_organ_prefs_to_mob(prefs, reset_to_roundstart)	// Don't apply prosthetics if we're a ling rejuving.

	if(!client || !key) //Don't boot out anyone already in the mob.
		for (var/obj/item/organ/internal/brain/H in world)
			if(H.brainmob)
				if(H.brainmob.real_name == src.real_name)
					if(H.brainmob.mind)
						H.brainmob.mind.transfer_to(src)
						qdel(H)

	losebreath = 0
	shock_stage = 0

	//Fix husks
	mutations.Remove(HUSK)
	status_flags &= ~DISFIGURED	//Fixes the unknown status
	if(src.client)
		SSjobs.EquipAugments(src, src.client.prefs)
	update_body(1)
	update_eyes()

	..()

/mob/living/carbon/human/handle_breath(datum/gas_mixture/breath)
	if(status_flags & GODMODE)
		return

	if(!species.has_organ[BP_LUNGS])
		return

	var/species_organ = species.breathing_organ
	if(!species_organ)
		return

	var/obj/item/organ/internal/lungs/L = internal_organs_by_name[species_organ]

	if(!L || nervous_system_failure())
		failed_last_breath = TRUE
	else
		failed_last_breath = L.handle_breath(breath)

	return !failed_last_breath

/mob/living/carbon/human/proc/is_lung_ruptured()
	var/species_organ = species.breathing_organ
	var/obj/item/organ/internal/lungs/L = internal_organs_by_name[species_organ]
	return L && L.is_bruised()

/mob/living/carbon/human/proc/rupture_lung()
	var/species_organ = species.breathing_organ
	var/obj/item/organ/internal/lungs/L = internal_organs_by_name[species_organ]
	if(L && !L.is_bruised())
		custom_pain("You feel a stabbing pain in your chest!", 50)
		L.bruise()

//returns 1 if made bloody, returns 0 otherwise
/mob/living/carbon/human/add_blood(mob/living/carbon/human/M as mob)
	if (!..())
		return 0
	//if this blood isn't already in the list, add it
	if(istype(M))
		if(!blood_DNA[M.dna.unique_enzymes])
			blood_DNA[M.dna.unique_enzymes] = M.dna.b_type
	hand_blood_color = blood_color
	src.update_inv_gloves()	//handles bloody hands overlays and updating
	verbs += /mob/living/carbon/human/proc/bloody_doodle
	return 1 //we applied blood to the item

/mob/living/carbon/human/proc/get_full_print()
	if(!dna ||!dna.uni_identity)
		return
	return md5(dna.uni_identity)

/mob/living/carbon/human/clean_blood(var/clean_feet)
	.=..()
	if(gloves)
		if(gloves.clean_blood())
			update_inv_gloves(1)
		gloves.germ_level = 0
	else
		if(!isnull(bloody_hands))
			bloody_hands = null
			update_inv_gloves(1)
		germ_level = 0

	gunshot_residue = null
	if(clean_feet && !shoes)
		footprint_color = null
		feet_blood_DNA = null
		update_inv_shoes(1)

	if(blood_color)
		blood_color = null
		return 1

/mob/living/carbon/human/get_visible_implants(var/class = 0)

	var/list/visible_implants = list()
	for(var/obj/item/organ/external/organ in src.organs)
		for(var/obj/item/O in organ.implants)
			if(!istype(O,/obj/item/implant) && (O.w_class > class) && !istype(O,/obj/item/material/shard/shrapnel))
				visible_implants += O

	return(visible_implants)

/mob/living/carbon/human/embedded_needs_process()
	for(var/obj/item/organ/external/organ in src.organs)
		for(var/obj/item/O in organ.implants)
			if(!istype(O, /obj/item/implant)) //implant type items do not cause embedding effects, see handle_embedded_objects()
				return 1
	return 0

/mob/living/carbon/human/proc/handle_embedded_objects()

	for(var/obj/item/organ/external/organ in src.organs)
		if(organ.status & ORGAN_SPLINTED) //Splints prevent movement.
			continue
		for(var/obj/item/O in organ.implants)
			if(!istype(O,/obj/item/implant) && prob(5)) //Moving with things stuck in you could be bad.
				// All kinds of embedded objects cause bleeding.
				if(!can_feel_pain())
					to_chat(src, SPAN_WARNING("You feel [O] moving inside your [organ.name]."))
				else
					var/msg = pick( \
						SPAN_WARNING("A spike of pain jolts your [organ.name] as you bump [O] inside."), \
						SPAN_WARNING("Your movement jostles [O] in your [organ.name] painfully."), \
						SPAN_WARNING("Your movement jostles [O] in your [organ.name] painfully."))
					custom_pain(msg, 10, 10, organ)

/mob/living/carbon/human/verb/check_pulse()
	set category = "Object"
	set name = "Check pulse"
	set desc = "Approximately count somebody's pulse. Requires you to stand still at least 6 seconds."
	set src in view(1)
	var/self = 0

	if(usr.stat || usr.restrained() || !isliving(usr)) return

	if(usr == src)
		self = 1

	if (src.species.flags & NO_BLOOD)
		to_chat(usr, SPAN_WARNING(self ? "You have no pulse." : "[src] has no pulse!"))
		return

	if(!self)
		usr.visible_message(SPAN_NOTICE("[usr] kneels down, puts \his hand on [src]'s wrist and begins counting their pulse."),\
		"You begin counting [src]'s pulse")
	else
		usr.visible_message(SPAN_NOTICE("[usr] begins counting their pulse."),\
		"You begin counting your pulse.")

	if(pulse())
		to_chat(usr, SPAN_NOTICE("[self ? "You have a" : "[src] has a"] pulse! Counting..."))
	else
		to_chat(usr, SPAN_WARNING("[src] has no pulse!"))	//it is REALLY UNLIKELY that a dead person would check his own pulse)
		return

	to_chat(usr, "You must[self ? "" : " both"] remain still until counting is finished.")
	if(do_mob(usr, src, 60))
		var/pulsae = src.get_pulse(GETPULSE_HAND)
		var/introspect = self ? "Your" : "[src]'s"
		to_chat(usr, SPAN_NOTICE("[introspect] pulse is [pulsae]."))
	else
		to_chat(usr, SPAN_WARNING("You failed to check the pulse. Try again."))

/mob/living/carbon/human/proc/set_species(var/new_species, var/default_colour, var/kpg=0, var/change_hair = TRUE)
	cached_bodytype = null
	if(!dna)
		if(!new_species)
			new_species = SPECIES_HUMAN
	else
		if(!new_species)
			new_species = dna.species
		else
			dna.species = new_species

	// No more invisible screaming wheelchairs because of set_species() typos.
	if(!all_species[new_species])
		new_species = SPECIES_HUMAN

	if(species)

		if(species.name && species.name == new_species)
			return
		if(species.language)
			remove_language(species.language)
		if(species.default_language)
			remove_language(species.default_language)
		// Clear out their species abilities.
		species.remove_inherent_verbs(src)
		holder_type = null

	species = all_species[new_species]

	if(species.language)
		add_language(species.language)

	if(species.default_language)
		add_language(species.default_language)

	if(species.base_color && default_colour)
		//Apply colour.
		r_skin = hex2num(copytext(species.base_color,2,4))
		g_skin = hex2num(copytext(species.base_color,4,6))
		b_skin = hex2num(copytext(species.base_color,6,8))
	else
		r_skin = 0
		g_skin = 0
		b_skin = 0

	if(species.holder_type)
		holder_type = species.holder_type

	icon_state = lowertext(species.name)

	species.create_organs(src)

	species.handle_post_spawn(src,kpg) // should be zero by default

	maxHealth = species.total_health

	spawn(0)
		regenerate_icons()
		if (vessel)
			vessel.add_reagent(/datum/reagent/blood,560-vessel.total_volume)
			fixblood()

	// Rebuild the HUD. If they aren't logged in then login() should reinstantiate it for them.
	if(client && client.screen)
		client.screen.len = null
		if(hud_used)
			qdel(hud_used)
		hud_used = new /datum/hud(src)

	if (src.is_diona())
		setup_gestalt(1)

	burn_mod = species.burn_mod
	brute_mod = species.brute_mod

	max_stamina = species.stamina
	stamina = max_stamina
	sprint_speed_factor = species.sprint_speed_factor
	sprint_cost_factor = species.sprint_cost_factor
	stamina_recovery = species.stamina_recovery

	exhaust_threshold = species.exhaust_threshold
	max_nutrition = BASE_MAX_NUTRITION * species.max_nutrition_factor
	max_hydration = BASE_MAX_HYDRATION * species.max_hydration_factor

	nutrition_loss = HUNGER_FACTOR * species.nutrition_loss_factor
	hydration_loss = THIRST_FACTOR * species.hydration_loss_factor

	if(change_hair)
		species.set_default_hair(src)

	if(species)
		return 1
	else
		return 0

/mob/living/carbon/human/proc/bloody_doodle()
	set category = "IC"
	set name = "Write in blood"
	set desc = "Use blood on your hands to write a short message on the floor or a wall, murder mystery style."

	if (src.stat)
		return

	if (usr != src)
		return 0 //something is terribly wrong

	if (!bloody_hands)
		verbs -= /mob/living/carbon/human/proc/bloody_doodle

	if (src.gloves)
		to_chat(src, SPAN_WARNING("Your [src.gloves] are getting in the way."))
		return

	var/turf/simulated/T = src.loc
	if (!istype(T)) //to prevent doodling out of mechs and lockers
		to_chat(src, SPAN_WARNING("You cannot reach the floor."))
		return

	var/direction = input(src,"Which way?","Tile selection") as anything in list("Here","North","South","East","West")
	if (direction != "Here")
		T = get_step(T,text2dir(direction))
	if (!istype(T))
		to_chat(src, SPAN_WARNING("You cannot doodle there."))
		return

	var/num_doodles = 0
	for (var/obj/effect/decal/cleanable/blood/writing/W in T)
		num_doodles++
	if (num_doodles > 4)
		to_chat(src, SPAN_WARNING("There is no space to write on!"))
		return

	var/max_length = bloody_hands * 30 //tweeter style

	var/message = sanitize(input("Write a message. It cannot be longer than [max_length] characters.","Blood writing", ""))

	if (message)
		var/used_blood_amount = round(length(message) / 30, 1)
		bloody_hands = max(0, bloody_hands - used_blood_amount) //use up some blood

		if (length(message) > max_length)
			message += "-"
			to_chat(src, SPAN_WARNING("You ran out of blood to write with!"))

		var/obj/effect/decal/cleanable/blood/writing/W = new(T)
		W.basecolor = (hand_blood_color) ? hand_blood_color : "#A10808"
		W.update_icon()
		W.message = message
		W.add_fingerprint(src)

/mob/living/carbon/human/can_inject(var/mob/user, var/error_msg, var/target_zone)
	. = 1

	if(!target_zone)
		if(!user)
			target_zone = pick(BP_CHEST,BP_CHEST,BP_CHEST,"left leg","right leg","left arm", "right arm", BP_HEAD)
		else
			target_zone = user.zone_sel.selecting

	var/obj/item/organ/external/affecting = get_organ(target_zone)
	var/fail_msg
	if(!affecting)
		. = 0
		fail_msg = "They are missing that limb."
	else if (affecting.status & ORGAN_ROBOT)
		. = 0
		fail_msg = "That limb is robotic."
	else
		switch(target_zone)
			if(BP_HEAD)
				if(head && head.item_flags & THICKMATERIAL)
					. = 0
			else
				if(wear_suit && wear_suit.item_flags & THICKMATERIAL)
					. = 0
	if(!. && error_msg && user)
		if(!fail_msg)
			fail_msg = "There is no exposed flesh or thin material [target_zone == BP_HEAD ? "on their head" : "on their body"] to inject into."
		to_chat(user, SPAN_ALERT("[fail_msg]"))

/mob/living/carbon/human/print_flavor_text(var/shrink = 1)
	var/list/equipment = list(src.head,src.wear_mask,src.glasses,src.w_uniform,src.wear_suit,src.gloves,src.shoes)
	var/head_exposed = 1
	var/face_exposed = 1
	var/eyes_exposed = 1
	var/torso_exposed = 1
	var/arms_exposed = 1
	var/legs_exposed = 1
	var/hands_exposed = 1
	var/feet_exposed = 1

	for(var/obj/item/clothing/C in equipment)
		if(C.body_parts_covered & HEAD)
			head_exposed = 0
		if(C.body_parts_covered & FACE)
			face_exposed = 0
		if(C.body_parts_covered & EYES)
			eyes_exposed = 0
		if(C.body_parts_covered & UPPER_TORSO)
			torso_exposed = 0
		if(C.body_parts_covered & ARMS)
			arms_exposed = 0
		if(C.body_parts_covered & HANDS)
			hands_exposed = 0
		if(C.body_parts_covered & LEGS)
			legs_exposed = 0
		if(C.body_parts_covered & FEET)
			feet_exposed = 0

	flavor_text = ""
	for (var/T in flavor_texts)
		if(flavor_texts[T] && flavor_texts[T] != "")
			if((T == "general") || (T == BP_HEAD && head_exposed) || (T == "face" && face_exposed) || (T == BP_EYES && eyes_exposed) || (T == "torso" && torso_exposed) || (T == "arms" && arms_exposed) || (T == "hands" && hands_exposed) || (T == "legs" && legs_exposed) || (T == "feet" && feet_exposed))
				flavor_text += flavor_texts[T]
				flavor_text += "\n\n"
	if(!shrink)
		return flavor_text
	else
		return ..()

/mob/living/carbon/human/getDNA()
	if(species.flags & NO_SCAN)
		return null
	..()

/mob/living/carbon/human/setDNA()
	if(species.flags & NO_SCAN)
		return
	..()

/mob/living/carbon/human/has_brain()
	if(internal_organs_by_name[BP_BRAIN])
		var/obj/item/organ/brain = internal_organs_by_name[BP_BRAIN] // budget fix until MMIs and stuff get made internal or you think of a better way, sorry matt
		if(brain && istype(brain))
			return 1
	return 0

/mob/living/carbon/human/has_eyes()
	var/obj/item/organ/internal/eyes = get_eyes()
	if(istype(eyes) && !(eyes.status & ORGAN_CUT_AWAY))
		return 1
	return 0

/mob/living/carbon/human/slip(var/slipped_on, stun_duration=8)
	if((species.flags & NO_SLIP) || (shoes && (shoes.item_flags & NOSLIP)))
		return 0
	. = ..(slipped_on,stun_duration)

/mob/living/carbon/human/proc/undislocate()
	set category = "Object"
	set name = "Undislocate Joint"
	set desc = "Pop a joint back into place. Extremely painful."
	set src in view(1)

	if(!isliving(usr) || !usr.canClick())
		return

	usr.setClickCooldown(20)

	if(usr.stat > 0)
		to_chat(usr, "You are unconcious and cannot do that!")
		return

	if(usr.restrained())
		to_chat(usr, "You are restrained and cannot do that!")
		return

	var/mob/S = src
	var/mob/U = usr
	var/self = null
	if(S == U)
		self = 1 // Removing object from yourself.

	var/list/limbs = list()
	for(var/limb in organs_by_name)
		var/obj/item/organ/external/current_limb = organs_by_name[limb]
		if(current_limb && current_limb.dislocated == 2)
			limbs |= limb
	var/choice = input(usr,"Which joint do you wish to relocate?") as null|anything in limbs

	if(!choice)
		return

	var/obj/item/organ/external/current_limb = organs_by_name[choice]

	if(self)
		U.visible_message(SPAN_WARNING("[U] tries to relocate their [current_limb.joint]..."), \
		SPAN_WARNING("You brace yourself to relocate your [current_limb.joint]..."))
	else
		U.visible_message(SPAN_WARNING("[U] tries to relocate [S]'s [current_limb.joint]..."), \
		SPAN_WARNING("You begin to relocate [S]'s [current_limb.joint]..."))

	if(!do_after(U, 30))
		return
	if(!choice || !current_limb || !S || !U)
		return

	if(self)
		U.visible_message(SPAN_DANGER("[U] pops their [current_limb.joint] back in!"), \
		SPAN_DANGER("You pop your [current_limb.joint] back in!"))
		playsound(src.loc, "fracture", 50, 1, -2)
	else
		U.visible_message(SPAN_DANGER("[U] pops [S]'s [current_limb.joint] back in!"), \
		SPAN_DANGER("You pop [S]'s [current_limb.joint] back in!"))
		playsound(src.loc, "fracture", 50, 1, -2)
	current_limb.undislocate()

/mob/living/carbon/human/drop_from_inventory(var/obj/item/W, var/atom/target = null)
	if(W in organs)
		return
	..()

/mob/living/carbon/human/reset_view(atom/A, update_hud = 1)
	..()
	if(update_hud)
		handle_regular_hud_updates()


/mob/living/carbon/human/can_stand_overridden()
	if(wearing_rig && wearing_rig.ai_can_move_suit(check_for_ai = 1))
		// Actually missing a leg will screw you up. Everything else can be compensated for.
		for(var/limbcheck in list(BP_L_LEG,BP_R_LEG))
			var/obj/item/organ/affecting = get_organ(limbcheck)
			if(!affecting)
				return 0
		return 1
	return 0

/mob/living/carbon/human/MouseDrop(var/atom/over_object)
	var/mob/living/carbon/human/H = over_object
	if(holder_type && istype(H) && H.a_intent == I_HELP && !H.lying && !issmall(H) && Adjacent(H))
		get_scooped(H, (usr == src))
		return
	return ..()



/mob/living/carbon/human/AltClickOn(var/atom/A)
	var/doClickAction = 1
	if (istype(get_active_hand(), /obj/item))
		var/obj/item/I = get_active_hand()
		doClickAction = I.alt_attack(A,src)

	if (doClickAction)
		..()

/mob/living/carbon/human/verb/toggle_underwear()
	set name = "Toggle Underwear"
	set desc = "Shows/hides selected parts of your underwear."
	set category = "Object"

	if(stat)
		return
	var/datum/category_group/underwear/UWC = input(usr, "Choose underwear:", "Show/hide underwear") as null|anything in global_underwear.categories
	if(!UWC)
		return
	var/datum/category_item/underwear/UWI = all_underwear[UWC.name]
	if(!UWI || UWI.name == "None")
		to_chat(src, "<span class='notice'>You do not have [UWC.gender==PLURAL ? "[UWC.display_name]" : "any [UWC.display_name]"].</span>")
		return
	hide_underwear[UWC.name] = !hide_underwear[UWC.name]
	update_underwear(1)
	to_chat(src, "<span class='notice'>You [hide_underwear[UWC.name] ? "take off" : "put on"] your [UWC.display_name].</span>")

/mob/living/carbon/human/verb/pull_punches()
	set name = "Pull Punches"
	set desc = "Try not to hurt them."
	set category = "IC"

	if(stat) return
	pulling_punches = !pulling_punches
	to_chat(src, SPAN_NOTICE("You are now [pulling_punches ? "pulling your punches" : "not pulling your punches"]."))
	return

/mob/living/carbon/human/proc/get_traumas()
	. = list()
	var/obj/item/organ/internal/brain/B = internal_organs_by_name[BP_BRAIN]
	if(istype(B, /obj/item/organ/internal/borer))
		return
	if(B && should_have_organ(BP_BRAIN) && !isipc(src))
		. = B.traumas

/mob/living/carbon/human/proc/has_trauma_type(brain_trauma_type, consider_permanent = FALSE)
	var/obj/item/organ/internal/brain/B = internal_organs_by_name[BP_BRAIN]
	if(B && should_have_organ(BP_BRAIN) && !isipc(src))
		. = B.has_trauma_type(brain_trauma_type, consider_permanent)

/mob/living/carbon/human/proc/gain_trauma(datum/brain_trauma/trauma, permanent = FALSE, list/arguments)
	var/obj/item/organ/internal/brain/B = internal_organs_by_name[BP_BRAIN]
	if(B && should_have_organ(BP_BRAIN) && !isipc(src))
		. = B.gain_trauma(trauma, permanent, arguments)

/mob/living/carbon/human/proc/gain_trauma_type(brain_trauma_type = /datum/brain_trauma, permanent = FALSE)
	var/obj/item/organ/internal/brain/B = internal_organs_by_name[BP_BRAIN]
	if(B && should_have_organ(BP_BRAIN) && !isipc(src))
		. = B.gain_trauma_type(brain_trauma_type, permanent)

/mob/living/carbon/human/proc/cure_trauma_type(brain_trauma_type, cure_permanent = FALSE)
	var/obj/item/organ/internal/brain/B = internal_organs_by_name[BP_BRAIN]
	if(B && should_have_organ(BP_BRAIN) && !isipc(src))
		. = B.cure_trauma_type(brain_trauma_type, cure_permanent)

/mob/living/carbon/human/proc/cure_all_traumas(cure_permanent = FALSE, cure_type = "")
	var/obj/item/organ/internal/brain/B = internal_organs_by_name[BP_BRAIN]
	if(B && should_have_organ(BP_BRAIN) && !isipc(src))
		. = B.cure_all_traumas(cure_permanent, cure_type)

/mob/living/carbon/human/get_metabolism(metabolism)
	return ..() * (species ? species.metabolism_mod : 1)

/mob/living/carbon/human/is_clumsy()
	if(CLUMSY in mutations)
		return TRUE
	if(CE_CLUMSY in chem_effects)
		return TRUE

	var/bac = get_blood_alcohol()
	var/SR = species.ethanol_resistance
	if(SR>0)
		if(bac > INTOX_REACTION*SR)
			return TRUE

	return FALSE

// Similar to get_pulse, but returns only integer numbers instead of text.
/mob/living/carbon/human/proc/get_pulse_as_number()
	var/obj/item/organ/internal/heart/heart_organ = internal_organs_by_name[BP_HEART]
	if(!heart_organ)
		return 0

	switch(pulse())
		if(PULSE_NONE)
			return 0
		if(PULSE_SLOW)
			return rand(40, 60)
		if(PULSE_NORM)
			return rand(60, 90)
		if(PULSE_FAST)
			return rand(90, 120)
		if(PULSE_2FAST)
			return rand(120, 160)
		if(PULSE_THREADY)
			return PULSE_MAX_BPM
	return 0

/mob/living/carbon/human/proc/get_pulse(var/method)	//method 0 is for hands, 1 is for machines, more accurate
	var/obj/item/organ/internal/heart/heart_organ = internal_organs_by_name[BP_HEART]
	if(!heart_organ)
		// No heart, no pulse
		return "0"

	var/bpm = get_pulse_as_number()
	if(bpm >= PULSE_MAX_BPM)
		return method ? ">[PULSE_MAX_BPM]" : "extremely weak and fast, patient's artery feels like a thread"

	return "[method ? bpm : bpm + rand(-10, 10)]"

/mob/living/carbon/human/proc/pulse()
	var/obj/item/organ/internal/heart/heart = internal_organs_by_name[BP_HEART]
	return heart ? heart.pulse : PULSE_NONE

/mob/living/carbon/human/move_to_stomach(atom/movable/victim)
	var/obj/item/organ/internal/stomach/stomach = internal_organs_by_name[BP_STOMACH]
	if(istype(stomach))
		victim.forceMove(stomach)

/mob/living/carbon/human/need_breathe()
	if(!(mNobreath in mutations) && species.breathing_organ && species.has_organ[species.breathing_organ])
		return 1
	else
		return 0

//Get fluffy numbers
/mob/living/carbon/human/proc/blood_pressure()
	if(status_flags & FAKEDEATH)
		return list(Floor(120+rand(-5,5))*0.25, Floor(80+rand(-5,5)*0.25))
	var/blood_result = get_blood_circulation()
	return list(Floor((120+rand(-5,5))*(blood_result/100)), Floor((80+rand(-5,5))*(blood_result/100)))

//Formats blood pressure for text display
/mob/living/carbon/human/proc/get_blood_pressure()
	var/list/bp = blood_pressure()
	return "[bp[1]]/[bp[2]]"

//Works out blood pressure alert level -- not very accurate
/mob/living/carbon/human/proc/get_blood_pressure_alert()
	var/list/bp = blood_pressure()
	// For a blood pressure, e.g. 120/80
	var/systolic_alert // this is the top number '120' -- highest pressure when heart beats
	var/diastolic_alert // this is the bottom number '80' -- lowest pressure when heart relaxes

	switch(bp[1])
		if(BP_HIGH_SYSTOLIC to INFINITY)
			systolic_alert = BLOOD_PRESSURE_HIGH
		if(BP_PRE_HIGH_SYSTOLIC to BP_HIGH_SYSTOLIC)
			systolic_alert = BLOOD_PRESSURE_PRE_HIGH
		if(BP_IDEAL_SYSTOLIC to BP_PRE_HIGH_SYSTOLIC)
			systolic_alert = BLOOD_PRESSURE_IDEAL
		if(-INFINITY to BP_IDEAL_SYSTOLIC)
			systolic_alert = BLOOD_PRESSURE_LOW

	switch(bp[2])
		if(BP_HIGH_DIASTOLIC to INFINITY)
			diastolic_alert = BLOOD_PRESSURE_HIGH
		if(BP_PRE_HIGH_DIASTOLIC to BP_HIGH_DIASTOLIC)
			diastolic_alert = BLOOD_PRESSURE_PRE_HIGH
		if(BP_IDEAL_DIASTOLIC to BP_PRE_HIGH_DIASTOLIC)
			diastolic_alert = BLOOD_PRESSURE_IDEAL
		if(-INFINITY to BP_IDEAL_DIASTOLIC)
			diastolic_alert = BLOOD_PRESSURE_LOW

	if(systolic_alert == BLOOD_PRESSURE_HIGH || diastolic_alert == BLOOD_PRESSURE_HIGH)
		return BLOOD_PRESSURE_HIGH
	if(systolic_alert == BLOOD_PRESSURE_PRE_HIGH || diastolic_alert == BLOOD_PRESSURE_PRE_HIGH)
		return BLOOD_PRESSURE_PRE_HIGH
	if(systolic_alert == BLOOD_PRESSURE_LOW || diastolic_alert == BLOOD_PRESSURE_LOW)
		return BLOOD_PRESSURE_LOW
	if(systolic_alert <= BLOOD_PRESSURE_IDEAL && diastolic_alert <= BLOOD_PRESSURE_IDEAL)
		return BLOOD_PRESSURE_IDEAL

//Point at which you dun breathe no more. Separate from asystole crit, which is heart-related.
/mob/living/carbon/human/nervous_system_failure()
	return getBrainLoss() >= maxHealth * 0.75

// Check if we should die.
/mob/living/carbon/human/proc/handle_death_check()
	if(should_have_organ(BP_BRAIN) && !is_mechanical()) //robots don't die via brain damage
		var/obj/item/organ/internal/brain/brain = internal_organs_by_name[BP_BRAIN]
		if(!brain || (brain.status & ORGAN_DEAD))
			return TRUE
	return species.handle_death_check(src)

/mob/living/carbon/human/should_have_organ(var/organ_check)
	return (species?.has_organ[organ_check])

/mob/living/carbon/human/proc/resuscitate()
	if(!is_asystole() || !should_have_organ(BP_HEART))
		return
	var/obj/item/organ/internal/heart/heart = internal_organs_by_name[BP_HEART]
	if(istype(heart) && !(heart.status & ORGAN_DEAD))
		if(!nervous_system_failure())
			visible_message("<b>[src]</b> jerks and gasps for breath!")
		else
			visible_message("<b>[src]</b> twitches a bit as \his heart restarts!")
		shock_stage = min(shock_stage, 100) // 120 is the point at which the heart stops.
		if(getOxyLoss() >= 75)
			setOxyLoss(75)
		heart.pulse = PULSE_NORM
		heart.handle_pulse()
		return TRUE

/mob/living/carbon/human/proc/make_adrenaline(var/amount)
	if(stat == CONSCIOUS)
		reagents.add_reagent(/datum/reagent/adrenaline, amount)

/mob/living/carbon/human/proc/gigashatter()
	for(var/obj/item/organ/external/E in organs)
		E.fracture()
	return

/mob/living/carbon/human/get_bullet_impact_effect_type(var/def_zone)
	var/obj/item/organ/external/E = get_organ(def_zone)
	if(!E || E.is_stump())
		return BULLET_IMPACT_NONE
	if(BP_IS_ROBOTIC(E))
		return BULLET_IMPACT_METAL
	return BULLET_IMPACT_MEAT

/mob/living/carbon/human/bullet_impact_visuals(var/obj/item/projectile/P, var/def_zone, var/damage)
	..()
	switch(get_bullet_impact_effect_type(def_zone))
		if(BULLET_IMPACT_MEAT)
			if(P.damage_type == BRUTE)
				var/hit_dir = get_dir(P.starting, src)
				var/obj/effect/decal/cleanable/blood/B = blood_splatter(get_step(src, hit_dir), src, 1, hit_dir)
				B.icon_state = pick("dir_splatter_1","dir_splatter_2")
				var/scale = min(1, round(P.damage / 50, 0.2))
				var/matrix/M = new()
				B.transform = M.Scale(scale)

/mob/living/carbon/human/apply_radiation_effects()
	. = ..()
	if(. == TRUE)
		if(src.is_diona())
			var/damage = rand(15, 30)
			src.adjustToxLoss(-damage)
			if(prob(5))
				damage = rand(20, 60)
				src.adjustToxLoss(-damage)
			to_chat(src, SPAN_NOTICE("You can feel flow of energy which makes you regenerate."))

		src.apply_effect((rand(15,30)),IRRADIATE,blocked = src.getarmor(null, "rad"))
		if(prob(4))
			src.apply_effect((rand(20,60)),IRRADIATE,blocked = src.getarmor(null, "rad"))
			if (prob(75))
				randmutb(src) // Applies bad mutation
				domutcheck(src,null,MUTCHK_FORCED)
			else
				randmutg(src) // Applies good mutation
				domutcheck(src,null,MUTCHK_FORCED)

/mob/living/carbon/human/get_accent_icon(var/datum/language/speaking = null)
	var/used_accent = accent //starts with the mob's default accent

	if(mind?.changeling)
		used_accent = mind.changeling.mimiced_accent

	if(istype(back,/obj/item/rig)) //checks for the rig voice changer module
		var/obj/item/rig/rig = back
		if(rig.speech && rig.speech.voice_holder && rig.speech.voice_holder.active && rig.speech.voice_holder.current_accent)
			used_accent = rig.speech.voice_holder.current_accent

	for(var/obj/item/gear in list(wear_mask,wear_suit,head)) //checks for voice changers masks now
		if(gear)
			var/obj/item/voice_changer/changer = locate() in gear
			if(changer && changer.active && changer.current_accent)
				used_accent = changer.current_accent

	return ..(speaking, used_accent)

/mob/living/carbon/human/proc/generate_valid_accent()
	var/list/valid_accents = new()
	for(var/current_accents in species.allowed_accents)
		valid_accents += current_accents

	return valid_accents

/mob/living/carbon/human/proc/set_accent(var/new_accent)
	accent = new_accent
	if(!(accent in species.allowed_accents))
		accent = species.default_accent
	return TRUE

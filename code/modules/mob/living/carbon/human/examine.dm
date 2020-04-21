/mob/living/carbon/human/examine(mob/user)
	var/skipgloves = 0
	var/skipsuitstorage = 0
	var/skipjumpsuit = 0
	var/skipshoes = 0
	var/skipmask = 0
	var/skipears = 0
	var/skipeyes = 0
	var/skipface = 0
	var/skipbody = 0

	//exosuits and helmets obscure our view and stuff.
	if(wear_suit)
		skipbody |= wear_suit.body_parts_covered
		skipgloves = wear_suit.flags_inv & HIDEGLOVES
		skipsuitstorage = wear_suit.flags_inv & HIDESUITSTORAGE
		skipjumpsuit = wear_suit.flags_inv & HIDEJUMPSUIT
		skipshoes = wear_suit.flags_inv & HIDESHOES

	if(head)
		skipbody |= head.body_parts_covered
		skipbody &= ~HEAD // head covering incorrectly hides 'face' damage
		skipbody |= (skipbody & FACE) ? HEAD : 0 // if you hide face damage, however, then go ahead and hide head damage, since that's where face damage is
		skipmask = head.flags_inv & HIDEMASK
		skipeyes = head.flags_inv & HIDEEYES
		skipears = head.flags_inv & HIDEEARS
		skipface = head.flags_inv & HIDEFACE

	if(wear_mask)
		skipbody |= wear_mask.body_parts_covered
		skipbody |= (wear_mask.body_parts_covered & FACE) ? HEAD : 0 // same as above
		skipface |= wear_mask.flags_inv & HIDEFACE

	if(w_uniform)
		skipbody |= w_uniform.body_parts_covered

	if(gloves)
		skipbody |= gloves.body_parts_covered

	if(shoes)
		skipbody |= shoes.body_parts_covered

	var/list/msg = list("<span class='info'>*---------*\nThis is ")

	var/datum/gender/T = gender_datums[gender]
	if(skipjumpsuit && skipface) //big suits/masks/helmets make it hard to tell their gender
		T = gender_datums[PLURAL]
	else
		if(icon)
			msg += "\icon[icon] " //fucking BYOND: this should stop dreamseeker crashing if we -somehow- examine somebody before their icon is generated

	if(!T)
		// Just in case someone VVs the gender to something strange. It'll runtime anyway when it hits usages, better to CRASH() now with a helpful message.
		CRASH("Gender datum was null; key was '[(skipjumpsuit && skipface) ? PLURAL : gender]'")

	msg += "<EM>[src.name]</EM>"

	if(!species.hide_name)
		msg += ", a <b><font color='[species.examine_color || species.flesh_color]'>[species.name]</font></b>"
	msg += "!\n"

	if (should_have_organ(BP_IPCTAG) && internal_organs_by_name[BP_IPCTAG])
		msg += "[T.He] [T.is] wearing a tag designating them as Integrated Positronic Chassis <b>[src.real_name]</b>.\n"

	//uniform
	if(w_uniform && !skipjumpsuit)
		//Ties
		var/tie_msg
		var/tie_msg_warn
		if(istype(w_uniform,/obj/item/clothing/under))
			var/obj/item/clothing/under/U = w_uniform
			if(LAZYLEN(U.accessories))
				tie_msg += ". Attached to it is [lowertext(english_list(U.accessories))]"
				tie_msg_warn += "! Attached to it is [lowertext(english_list(U.accessories))]"

		if(w_uniform.blood_color)
			msg += "<span class='warning'>[T.He] [T.is] wearing \icon[w_uniform] [w_uniform.gender==PLURAL?"some":"a"] [fluid_color_type_map(w_uniform.blood_color)]-stained <a href='?src=\ref[src];lookitem_desc_only=\ref[w_uniform]'>[w_uniform.name]</a>[tie_msg_warn].</span>\n"
		else
			msg += "[T.He] [T.is] wearing \icon[w_uniform] <a href='?src=\ref[src];lookitem_desc_only=\ref[w_uniform]'>\a [w_uniform]</a>[tie_msg].\n"

	//head
	if(head)
		if(head.blood_color)
			msg += "<span class='warning'>[T.He] [T.is] wearing \icon[head] [head.gender==PLURAL?"some":"a"] [fluid_color_type_map(head.blood_color)]-stained <a href='?src=\ref[src];lookitem_desc_only=\ref[head]'>[head.name]</a> on [T.his] head!</span>\n"
		else
			msg += "[T.He] [T.is] wearing \icon[head] <a href='?src=\ref[src];lookitem_desc_only=\ref[head]'>\a [head]</a> on [T.his] head.\n"

	//suit/armour
	if(wear_suit)
		var/tie_msg
		var/tie_msg_warn
		if(istype(wear_suit,/obj/item/clothing/suit))
			var/obj/item/clothing/suit/U = wear_suit
			if(LAZYLEN(U.accessories))
				tie_msg += ". Attached to it is [lowertext(english_list(U.accessories))]"
				tie_msg_warn += "! Attached to it is [lowertext(english_list(U.accessories))]"

		if(wear_suit.blood_color)
			msg += "<span class='warning'>[T.He] [T.is] wearing \icon[wear_suit] [wear_suit.gender==PLURAL?"some":"a"] [fluid_color_type_map(wear_suit.blood_color)]-stained <a href='?src=\ref[src];lookitem_desc_only=\ref[wear_suit]'>[wear_suit.name]</a>[tie_msg_warn].</span>\n"
		else
			msg += "[T.He] [T.is] wearing \icon[wear_suit] <a href='?src=\ref[src];lookitem_desc_only=\ref[wear_suit]'>\a [wear_suit]</a>[tie_msg].\n"

		//suit/armour storage
		if(s_store && !skipsuitstorage)
			if(s_store.blood_color)
				msg += "<span class='warning'>[T.He] [T.is] carrying \icon[s_store] [s_store.gender==PLURAL?"some":"a"] [fluid_color_type_map(s_store.blood_color)]-stained <a href='?src=\ref[src];lookitem_desc_only=\ref[s_store]'>[s_store.name]</a> on [T.his] [wear_suit.name]!</span>\n"
			else
				msg += "[T.He] [T.is] carrying \icon[s_store] <a href='?src=\ref[src];lookitem_desc_only=\ref[s_store]'>\a [s_store]</a> on [T.his] [wear_suit.name].\n"
	else if(s_store && !skipsuitstorage)
		if(s_store.blood_color)
			msg += "<span class='warning'>[T.He] [T.is] carrying \icon[s_store] [s_store.gender==PLURAL?"some":"a"] [fluid_color_type_map(s_store.blood_color)]-stained <a href='?src=\ref[src];lookitem_desc_only=\ref[s_store]'>[s_store.name]</a> on [T.his] chest!</span>\n"
		else
			msg += "[T.He] [T.is] carrying \icon[s_store] <a href='?src=\ref[src];lookitem_desc_only=\ref[s_store]'>\a [s_store]</a> on [T.his] chest.\n"

	//back
	if(back)
		if(back.blood_color)
			msg += "<span class='warning'>[T.He] [T.has] \icon[back] [fluid_color_type_map(back.blood_color)]-stained <a href='?src=\ref[src];lookitem_desc_only=\ref[back]'>[back]</a> on [T.his] back.</span>\n"
		else
			msg += "[T.He] [T.has] \icon[back] <a href='?src=\ref[src];lookitem_desc_only=\ref[back]'>\a [back]</a> on [T.his] back.\n"

	//left hand
	if(l_hand)
		if(l_hand.blood_color)
			msg += "<span class='warning'>[T.He] [T.is] holding \icon[l_hand] [l_hand.gender==PLURAL?"some":"a"] [fluid_color_type_map(l_hand.blood_color)]-stained <a href='?src=\ref[src];lookitem_desc_only=\ref[l_hand]'>[l_hand.name]</a> in [T.his] left hand!</span>\n"
		else
			msg += "[T.He] [T.is] holding \icon[l_hand] <a href='?src=\ref[src];lookitem_desc_only=\ref[l_hand]'>\a [l_hand]</a> in [T.his] left hand.\n"

	//right hand
	if(r_hand)
		if(r_hand.blood_color)
			msg += "<span class='warning'>[T.He] [T.is] holding \icon[r_hand] [r_hand.gender==PLURAL?"some":"a"] [fluid_color_type_map(r_hand.blood_color)]-stained <a href='?src=\ref[src];lookitem_desc_only=\ref[r_hand]'>[r_hand.name]</a> in [T.his] right hand!</span>\n"
		else
			msg += "[T.He] [T.is] holding \icon[r_hand] <a href='?src=\ref[src];lookitem_desc_only=\ref[r_hand]'>\a [r_hand]</a> in [T.his] right hand.\n"

	//gloves
	if(gloves && !skipgloves)
		if(gloves.blood_color)
			msg += "<span class='warning'>[T.He] [T.has] \icon[gloves] [gloves.gender==PLURAL?"some":"a"] [fluid_color_type_map(gloves.blood_color)]-stained <a href='?src=\ref[src];lookitem_desc_only=\ref[gloves]'>[gloves.name]</a> on [T.his] hands!</span>\n"
		else
			msg += "[T.He] [T.has] \icon[gloves] <a href='?src=\ref[src];lookitem_desc_only=\ref[gloves]'>\a [gloves]</a> on [T.his] hands.\n"
	else if(blood_color)
		msg += "<span class='warning'>[T.He] [T.has] [fluid_color_type_map(hand_blood_color)]-stained hands!</span>\n"

	//handcuffed?
	if(handcuffed)
		if(istype(handcuffed, /obj/item/handcuffs/cable))
			msg += "<span class='warning'>[T.He] [T.is] \icon[handcuffed] restrained with cable!</span>\n"
		else
			msg += "<span class='warning'>[T.He] [T.is] \icon[handcuffed] handcuffed!</span>\n"

	//buckled
	if(buckled)
		msg += "<span class='warning'>[T.He] [T.is] \icon[buckled] buckled to [buckled]!</span>\n"

	//belt
	if(belt)
		if(belt.blood_color)
			msg += "<span class='warning'>[T.He] [T.has] \icon[belt] [belt.gender==PLURAL?"some":"a"] [fluid_color_type_map(belt.blood_color)]-stained <a href='?src=\ref[src];lookitem_desc_only=\ref[belt]'>[belt.name]</a> about [T.his] waist!</span>\n"
		else
			msg += "[T.He] [T.has] \icon[belt] <a href='?src=\ref[src];lookitem_desc_only=\ref[belt]'>\a [belt]</a> about [T.his] waist.\n"

	//shoes
	if(shoes && !skipshoes)
		if(shoes.blood_color)
			msg += "<span class='warning'>[T.He] [T.is] wearing \icon[shoes] [shoes.gender==PLURAL?"some":"a"] [fluid_color_type_map(shoes.blood_color)]-stained <a href='?src=\ref[src];lookitem_desc_only=\ref[shoes]'>[shoes.name]</a> on [T.his] feet!</span>\n"
		else
			msg += "[T.He] [T.is] wearing \icon[shoes] <a href='?src=\ref[src];lookitem_desc_only=\ref[shoes]'>\a [shoes]</a> on [T.his] feet.\n"
	else if(footprint_color)
		msg += "<span class='warning'>[T.He] [T.has] [fluid_color_type_map(footprint_color)]-stained feet!</span>\n"

	//mask
	if(wear_mask && !skipmask)
		if(wear_mask.blood_color)
			msg += "<span class='warning'>[T.He] [T.has] \icon[wear_mask] [wear_mask.gender==PLURAL?"some":"a"] [fluid_color_type_map(wear_mask.blood_color)]-stained <a href='?src=\ref[src];lookitem_desc_only=\ref[wear_mask]'>[wear_mask.name]</a> on [T.his] face!</span>\n"
		else
			msg += "[T.He] [T.has] \icon[wear_mask] <a href='?src=\ref[src];lookitem_desc_only=\ref[wear_mask]'>\a [wear_mask]</a> on [T.his] face.\n"

	//eyes
	if(glasses && !skipeyes)
		if(glasses.blood_color)
			msg += "<span class='warning'>[T.He] [T.has] \icon[glasses] [glasses.gender==PLURAL?"some":"a"] [fluid_color_type_map(glasses.blood_color)]-stained <a href='?src=\ref[src];lookitem_desc_only=\ref[glasses]'>[glasses]</a> covering [T.his] eyes!</span>\n"
		else
			msg += "[T.He] [T.has] \icon[glasses] <a href='?src=\ref[src];lookitem_desc_only=\ref[glasses]'>\a [glasses]</a> covering [T.his] eyes.\n"

	//left ear
	if(l_ear && !skipears)
		msg += "[T.He] [T.has] \icon[l_ear] <a href='?src=\ref[src];lookitem_desc_only=\ref[l_ear]'>\a [l_ear]</a> on [T.his] left ear.\n"

	//right ear
	if(r_ear && !skipears)
		msg += "[T.He] [T.has] \icon[r_ear] <a href='?src=\ref[src];lookitem_desc_only=\ref[r_ear]'>\a [r_ear]</a> on [T.his] right ear.\n"

	//ID
	if(wear_id)
		/*var/id
		if(istype(wear_id, /obj/item/device/pda))
			var/obj/item/device/pda/pda = wear_id
			id = pda.owner
		else if(istype(wear_id, /obj/item/card/id)) //just in case something other than a PDA/ID card somehow gets in the ID slot :c
			var/obj/item/card/id/idcard = wear_id
			id = idcard.registered_name
		if(id && (id != real_name) && (get_dist(src, usr) <= 1) && prob(10))
			msg += "<span class='warning'>[T.He] [T.is] wearing \icon[wear_id] \a [wear_id] yet something doesn't seem right...</span>\n"
		else*/
		msg += "[T.He] [T.is] wearing \icon[wear_id] <a href='?src=\ref[src];lookitem_desc_only=\ref[wear_id]'>\a [wear_id]</a>.\n"

	//Jitters
	if(is_jittery)
		if(jitteriness >= 300)
			msg += "<span class='warning'><B>[T.He] [T.is] convulsing violently!</B></span>\n"
		else if(jitteriness >= 200)
			msg += "<span class='warning'>[T.He] [T.is] extremely jittery.</span>\n"
		else if(jitteriness >= 100)
			msg += "<span class='warning'>[T.He] [T.is] twitching ever so slightly.</span>\n"

	//splints
	for(var/organ in list(BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_R_FOOT,BP_L_FOOT))
		var/obj/item/organ/external/o = get_organ(organ)
		if(o)
			if(o.status & ORGAN_SPLINTED)
				msg += "<span class='warning'>[T.He] [T.has] a splint on [T.his] [o.name]!</span>\n"
			if(o.applied_pressure == src)
				msg += "<span class='warning'>[T.He] [T.is] applying pressure to [T.his] [o.name]!</span>\n"

	if(mSmallsize in mutations)
		msg += "[T.He] [T.is] small halfling!\n"

	var/distance = get_dist(user,src)
	if(istype(user, /mob/abstract/observer) || user.stat == 2) // ghosts can see anything
		distance = 1
	if (src.stat && !(src.species.flags & NO_BLOOD))	// No point checking pulse of a species that doesn't have one.
		msg += "<span class='warning'>[T.He] [T.is]n't responding to anything around [T.him] and seems to be unconscious.</span>\n"
		if((stat == DEAD || is_asystole() || src.losebreath) && distance <= 3)
			msg += "<span class='warning'>[T.He] [T.does] not appear to be breathing.</span>\n"
		if(istype(user, /mob/living/carbon/human) && !user.stat && Adjacent(user))
			spawn (0)
				user.visible_message("<b>[user]</b> checks [src]'s pulse.", "You check [src]'s pulse.")
				if (do_mob(user, src, 15))
					if(pulse() == PULSE_NONE)
						to_chat(user, "<span class='deadsay'>[T.He] [T.has] no pulse.</span>")
					else
						to_chat(user, "<span class='deadsay'>[T.He] [T.has] a pulse!</span>")

	else if (src.stat)
		msg += span("warning", "[T.He] [T.is] not responding to anything around [T.him].\n")

	if(fire_stacks)
		msg += "[T.He] [T.is] covered in some liquid.\n"
	if(on_fire)
		msg += "<span class='danger'>[T.He] [T.is] on fire!</span>\n"
	msg += "<span class='warning'>"

	msg += "</span>"

	var/have_client = client
	var/inactivity = client ? client.inactivity : null

	if(bg)
		disconnect_time = bg.disconnect_time
		have_client = bg.client
		inactivity =  have_client ? bg.client.inactivity : null


	if(species.show_ssd && (!species.has_organ[BP_BRAIN] || has_brain()) && stat != DEAD)
		if(!key)
			msg += "<span class='deadsay'>[T.He] [T.is] [species.show_ssd]. It doesn't look like [T.he] [T.is] waking up anytime soon.</span>\n"
		else if(!client && !bg)
			msg += "<span class='deadsay'>[T.He] [T.is] [species.show_ssd].</span>\n"
		if(have_client && ((inactivity / 600) > 10)) // inactivity/10/60 > 10 MINUTES
			msg += "<span class='deadsay'>\[Inactive for [round(inactivity / 600)] minutes.\]\n</span>"
		else if(!have_client && (world.realtime - disconnect_time) >= 5 MINUTES)
			msg += "<span class='deadsay'>\[Disconnected/ghosted [(world.realtime - disconnect_time)/600] minutes ago.\]\n</span>"

	var/list/wound_flavor_text = list()
	var/list/is_bleeding = list()

	for(var/organ_tag in species.has_limbs)

		var/list/organ_data = species.has_limbs[organ_tag]
		var/organ_descriptor = organ_data["descriptor"]

		var/obj/item/organ/external/E = organs_by_name[organ_tag]
		if(!E)
			wound_flavor_text["[organ_descriptor]"] = "<span class='warning'><b>[T.He] [T.is] missing [T.his] [organ_descriptor].</b></span>\n"
		else if(E.is_stump())
			wound_flavor_text["[organ_descriptor]"] = "<span class='warning'><b>[T.He] [T.has] a stump where [T.his] [organ_descriptor] should be.</b></span>\n"
		else
			continue

	for(var/obj/item/organ/external/temp in organs)
		if(temp)
			if(skipbody & temp.body_part)
				continue
			if(temp.status & ORGAN_ASSISTED)
				if(!(temp.brute_dam + temp.burn_dam))
					//wound_flavor_text["[temp.name]"] = "<span class='warning'>[T.He] [T.has] a robot [temp.name]!</span>\n"
					// No need to notify about robotic limbs if they're not damaged, really.
					continue
				else
					wound_flavor_text["[temp.name]"] = "<span class='warning'>[T.He] [T.has] a robot [temp.name]. It has[temp.get_wounds_desc()]!</span>\n"
			else if(temp.wounds.len > 0 || temp.open)
				if(temp.is_stump() && temp.parent_organ && organs_by_name[temp.parent_organ])
					var/obj/item/organ/external/parent = organs_by_name[temp.parent_organ]
					wound_flavor_text["[temp.name]"] = "<span class='warning'>[T.He] [T.has] [temp.get_wounds_desc()] on [T.his] [parent.name].</span><br>"
				else
					wound_flavor_text["[temp.name]"] = "<span class='warning'>[T.He] [T.has] [temp.get_wounds_desc()] on [T.his] [temp.name].</span><br>"
				if(temp.status & ORGAN_BLEEDING)
					is_bleeding["[temp.name]"] = "<span class='danger'>[T.His] [temp.name] is bleeding!</span><br>"
			else
				wound_flavor_text["[temp.name]"] = ""
			if(temp.dislocated == 2)
				wound_flavor_text["[temp.name]"] += "<span class='warning'>[T.His] [temp.joint] is dislocated!</span><br>"
			if(((temp.status & ORGAN_BROKEN) && temp.brute_dam > temp.min_broken_damage) || (temp.status & ORGAN_MUTATED))
				wound_flavor_text["[temp.name]"] += "<span class='warning'>[T.His] [temp.name] is dented and swollen!</span><br>"

	//Handles the text strings being added to the actual description.
	//If they have something that covers the limb, and it is not missing, put flavortext.  If it is covered but bleeding, add other flavortext.

	for(var/limb in wound_flavor_text)
		msg += wound_flavor_text[limb]
		is_bleeding[limb] = null
	for(var/limb in is_bleeding)
		msg += is_bleeding[limb]
	for(var/obj/item/organ/external/organ in src.organs)
		for(var/obj/item/O in organ.implants)
			if(!istype(O,/obj/item/implant) && !istype(O,/obj/item/material/shard/shrapnel))
				msg += "<span class='danger'>[src] [T.has] \a [O] sticking out of [T.his] [organ.name]!</span>\n"
	if(digitalcamo)
		msg += "[T.He] [T.is] a little difficult to identify.\n"

	if(hasHUD(user,"security"))
		var/perpname = "wot"
		var/criminal = "None"

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
				criminal = R.security.criminal

			msg += "<span class = 'deptradio'>Criminal status:</span> <a href='?src=\ref[src];criminal=1'>\[[criminal]\]</a>\n"
			msg += "<span class = 'deptradio'>Security records:</span> <a href='?src=\ref[src];secrecord=`'>\[View\]</a>  <a href='?src=\ref[src];secrecordadd=`'>\[Add comment\]</a>\n"

	if(hasHUD(user,"medical"))
		var/perpname = "wot"
		var/medical = "None"

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
			medical = R.physical_status

		msg += "<span class = 'deptradio'>Physical status:</span> <a href='?src=\ref[src];medical=1'>\[[medical]\]</a>\n"
		msg += "<span class = 'deptradio'>Medical records:</span> <a href='?src=\ref[src];medrecord=`'>\[View\]</a> <a href='?src=\ref[src];medrecordadd=`'>\[Add comment\]</a>\n"


	if(print_flavor_text()) msg += "[print_flavor_text()]\n"

	msg += "*---------*</span>"
	if (pose)
		if( findtext(pose,".",length(pose)) == 0 && findtext(pose,"!",length(pose)) == 0 && findtext(pose,"?",length(pose)) == 0 )
			pose = addtext(pose,".") //Makes sure all emotes end with a period.
		msg += "\n[T.He] [pose]"

	to_chat(user, msg.Join())

//Helper procedure. Called by /mob/living/carbon/human/examine() and /mob/living/carbon/human/Topic() to determine HUD access to security and medical records.
/proc/hasHUD(mob/M as mob, hudtype)
	if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		switch(hudtype)
			if("security")
				return istype(H.glasses, /obj/item/clothing/glasses/hud/security) || istype(H.glasses, /obj/item/clothing/glasses/sunglasses/sechud)
			if("medical")
				return istype(H.glasses, /obj/item/clothing/glasses/hud/health)
			else
				return 0
	else if(istype(M, /mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = M
		switch(hudtype)
			if("security")
				return istype(R.module_state_1, /obj/item/borg/sight/hud/sec) || istype(R.module_state_2, /obj/item/borg/sight/hud/sec) || istype(R.module_state_3, /obj/item/borg/sight/hud/sec)
			if("medical")
				return istype(R.module_state_1, /obj/item/borg/sight/hud/med) || istype(R.module_state_2, /obj/item/borg/sight/hud/med) || istype(R.module_state_3, /obj/item/borg/sight/hud/med)
			else
				return 0
	else
		return 0

/proc/fluid_color_type_map(var/supplied_color)
	var/static/list/color_map = list(
					COLOR_HUMAN_BLOOD = "blood",
					COLOR_DIONA_BLOOD = "blood",
					COLOR_SKRELL_BLOOD = "blood",
					COLOR_VAURCA_BLOOD = "blood",
					COLOR_IPC_BLOOD = "oil",
					COLOR_OIL = "oil",
					COLOR_SNOW = "snow",
					COLOR_ASH = "ash",
						)

	var/output_text = color_map[supplied_color] || "fluid"
	return output_text

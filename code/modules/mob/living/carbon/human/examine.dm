#define SEC_HUDTYPE "security"
#define MED_HUDTYPE "medical"

/mob/living/carbon/human/proc/get_covered_body_parts(var/thick)
	var/skipbody = 0
	for(var/obj/item/clothing/C in list(wear_suit, head, wear_mask, w_uniform, gloves, shoes))
		if(!thick || (C.item_flags & THICKMATERIAL))
			skipbody |= C.body_parts_covered
	return skipbody

/mob/living/carbon/human/proc/get_covered_clothes()
	var/skipitems = 0
	for(var/obj/item/clothing/C in list(wear_suit, head, wear_mask, w_uniform, gloves, shoes))
		skipitems |= C.flags_inv
	return skipitems

/mob/living/carbon/human/proc/examine_pulse(mob/user)
	if(user.stat || user.incapacitated() || !ishuman(user))
		return

	var/mob/living/carbon/human/H = user
	if(H.has_stethoscope_active())
		var/obj/item/organ/organ = src.get_organ(user.zone_sel.selecting)
		if(organ)
			user.visible_message("<b>[user]</b> checks [src] with a stethoscope.", "You check [src] with the stethoscope on your person.")
			to_chat(user, SPAN_NOTICE("You place the stethoscope against [src]'s [organ.name]. You hear <b>[english_list(organ.listen())]</b>."))
		else
			to_chat(user, SPAN_WARNING("[src] is missing that limb!"))

	else if(src.stat && !(src.species.flags & NO_BLOOD))
		user.visible_message("<b>[user]</b> checks [src]'s pulse.", "You check [src]'s pulse.")
		if(do_mob(user, src, 15))
			if(pulse() == PULSE_NONE || (status_flags & FAKEDEATH))
				to_chat(user, "<span class='deadsay'>[get_pronoun("He")] [get_pronoun("has")] no pulse.</span>")
			else
				to_chat(user, "<span class='deadsay'>[get_pronoun("He")] [get_pronoun("has")] a pulse!</span>")

/mob/living/carbon/human/examine(mob/user)
	var/skipbody = get_covered_body_parts()
	var/skipbody_thick = get_covered_body_parts(TRUE)
	var/skipitems = get_covered_clothes()

	//exosuits and helmets obscure our view and stuff.
	var/skipgloves = skipitems & HIDEGLOVES
	var/skipsuitstorage = skipitems & HIDESUITSTORAGE
	var/skipjumpsuit = skipitems & HIDEJUMPSUIT
	var/skipshoes = skipitems & HIDESHOES
	var/skipmask = skipitems & HIDEMASK
	var/skipeyes = skipitems & HIDEEYES
	var/skipears = skipitems & HIDEEARS
	var/skipwrists = skipitems & HIDEWRISTS

	var/list/msg = list("<span class='info'>*---------*\nThis is ")

	if(icon)
		msg += icon2html(icon, user)

	msg += "<EM>[src.name]</EM>"

	if(!species.hide_name)
		msg += ", a <b><font color='[species.examine_color || species.flesh_color]'>[species.name]</font></b>"
	msg += "!\n"

	//uniform
	if(w_uniform && !skipjumpsuit)
		//Ties
		var/tie_msg
		var/tie_msg_warn
		if(istype(w_uniform,/obj/item/clothing/under))
			var/obj/item/clothing/under/U = w_uniform
			if(LAZYLEN(U.accessories))
				tie_msg += ". Attached to it is"
				tie_msg_warn += "! Attached to it is"
				var/list/accessory_descs = list()
				for(var/accessory in U.accessories)
					if(istype(accessory, /obj/item/clothing/accessory/holster)) //so you can't see what kind of gun a holster is holding from afar
						accessory_descs += "\a [accessory]"
					else
						accessory_descs += "<a href='?src=\ref[src];lookitem_desc_only=\ref[accessory]'>\a [accessory]</a>"

				tie_msg += " [lowertext(english_list(accessory_descs))]"
				tie_msg_warn += " [lowertext(english_list(accessory_descs))]"

		if(w_uniform.blood_color)
			msg += "<span class='warning'>[get_pronoun("He")] [get_pronoun("is")] wearing [icon2html(w_uniform, user)] [w_uniform.gender==PLURAL?"some":"a"] [fluid_color_type_map(w_uniform.blood_color)]-stained <a href='?src=\ref[src];lookitem_desc_only=\ref[w_uniform]'>[w_uniform.name]</a>[tie_msg_warn].</span>\n"
		else
			msg += "[get_pronoun("He")] [get_pronoun("is")] wearing [icon2html(w_uniform, user)] <a href='?src=\ref[src];lookitem_desc_only=\ref[w_uniform]'>\a [w_uniform]</a>[tie_msg].\n"

	//head
	if(head)
		if(head.blood_color)
			msg += "<span class='warning'>[get_pronoun("He")] [get_pronoun("is")] wearing [icon2html(head, user)] [head.gender==PLURAL?"some":"a"] [fluid_color_type_map(head.blood_color)]-stained <a href='?src=\ref[src];lookitem_desc_only=\ref[head]'>[head.name]</a> [head.get_head_examine_text(src)]!</span>\n"
		else
			msg += "[get_pronoun("He")] [get_pronoun("is")] wearing [icon2html(head, user)] <a href='?src=\ref[src];lookitem_desc_only=\ref[head]'>\a [head]</a> [head.get_head_examine_text(src)].\n"

	//suit/armor
	if(wear_suit)
		var/tie_msg
		var/tie_msg_warn
		if(istype(wear_suit,/obj/item/clothing/suit))
			var/obj/item/clothing/suit/U = wear_suit
			if(LAZYLEN(U.accessories))
				tie_msg += ". Attached to it is"
				tie_msg_warn += "! Attached to it is"
				var/list/accessory_descs = list()
				for(var/accessory in U.accessories)
					accessory_descs += "<a href='?src=\ref[src];lookitem_desc_only=\ref[accessory]'>\a [accessory]</a>"

				tie_msg += " [lowertext(english_list(accessory_descs))]"
				tie_msg_warn += " [lowertext(english_list(accessory_descs))]"

		if(wear_suit.blood_color)
			msg += "<span class='warning'>[get_pronoun("He")] [get_pronoun("is")] wearing [icon2html(wear_suit, user)] [wear_suit.gender==PLURAL?"some":"a"] [fluid_color_type_map(wear_suit.blood_color)]-stained <a href='?src=\ref[src];lookitem_desc_only=\ref[wear_suit]'>[wear_suit.name]</a>[tie_msg_warn].</span>\n"
		else
			msg += "[get_pronoun("He")] [get_pronoun("is")] wearing [icon2html(wear_suit, user)] <a href='?src=\ref[src];lookitem_desc_only=\ref[wear_suit]'>\a [wear_suit]</a>[tie_msg].\n"

		//suit/armor storage
		if(s_store && !skipsuitstorage)
			if(s_store.blood_color)
				msg += "<span class='warning'>[get_pronoun("He")] [get_pronoun("is")] carrying [icon2html(s_store, user)] [s_store.gender==PLURAL?"some":"a"] [fluid_color_type_map(s_store.blood_color)]-stained <a href='?src=\ref[src];lookitem_desc_only=\ref[s_store]'>[s_store.name]</a> on [get_pronoun("his")] [wear_suit.name]!</span>\n"
			else
				msg += "[get_pronoun("He")] [get_pronoun("is")] carrying [icon2html(s_store, user)] <a href='?src=\ref[src];lookitem_desc_only=\ref[s_store]'>\a [s_store]</a> on [get_pronoun("his")] [wear_suit.name].\n"
	else if(s_store && !skipsuitstorage)
		if(s_store.blood_color)
			msg += "<span class='warning'>[get_pronoun("He")] [get_pronoun("is")] carrying [icon2html(s_store, user)] [s_store.gender==PLURAL?"some":"a"] [fluid_color_type_map(s_store.blood_color)]-stained <a href='?src=\ref[src];lookitem_desc_only=\ref[s_store]'>[s_store.name]</a> on [get_pronoun("his")] chest!</span>\n"
		else
			msg += "[get_pronoun("He")] [get_pronoun("is")] carrying [icon2html(s_store, user)] <a href='?src=\ref[src];lookitem_desc_only=\ref[s_store]'>\a [s_store]</a> on [get_pronoun("his")] chest.\n"

	//back
	if(back)
		if(back.blood_color)
			msg += "<span class='warning'>[get_pronoun("He")] [get_pronoun("has")] [icon2html(back, user)] [fluid_color_type_map(back.blood_color)]-stained <a href='?src=\ref[src];lookitem_desc_only=\ref[back]'>[back]</a> on [get_pronoun("his")] back.</span>\n"
		else
			msg += "[get_pronoun("He")] [get_pronoun("has")] [icon2html(back, user)] <a href='?src=\ref[src];lookitem_desc_only=\ref[back]'>\a [back]</a> on [get_pronoun("his")] back.\n"

	//left hand
	if(l_hand)
		if(l_hand.blood_color)
			msg += "<span class='warning'>[get_pronoun("He")] [get_pronoun("is")] holding [icon2html(l_hand, user)] [l_hand.gender==PLURAL?"some":"a"] [fluid_color_type_map(l_hand.blood_color)]-stained <a href='?src=\ref[src];lookitem_desc_only=\ref[l_hand]'>[l_hand.name]</a> in [get_pronoun("his")] left hand!</span>\n"
		else
			msg += "[get_pronoun("He")] [get_pronoun("is")] holding [icon2html(l_hand, user)] <a href='?src=\ref[src];lookitem_desc_only=\ref[l_hand]'>\a [l_hand]</a> in [get_pronoun("his")] left hand.\n"

	//right hand
	if(r_hand)
		if(r_hand.blood_color)
			msg += "<span class='warning'>[get_pronoun("He")] [get_pronoun("is")] holding [icon2html(r_hand, user)] [r_hand.gender==PLURAL?"some":"a"] [fluid_color_type_map(r_hand.blood_color)]-stained <a href='?src=\ref[src];lookitem_desc_only=\ref[r_hand]'>[r_hand.name]</a> in [get_pronoun("his")] right hand!</span>\n"
		else
			msg += "[get_pronoun("He")] [get_pronoun("is")] holding [icon2html(r_hand, user)] <a href='?src=\ref[src];lookitem_desc_only=\ref[r_hand]'>\a [r_hand]</a> in [get_pronoun("his")] right hand.\n"

	//gloves
	if(gloves && !skipgloves)
		var/gloves_name = gloves
		if(gloves.blood_color)
			msg += "<span class='warning'>[get_pronoun("He")] [get_pronoun("has")] [icon2html(gloves, user)] [gloves.gender==PLURAL?"some":"a"] [fluid_color_type_map(gloves.blood_color)]-stained <a href='?src=\ref[src];lookitem_desc_only=\ref[gloves]'>[gloves_name]</a> on [get_pronoun("his")] hands!</span>\n"
		else
			msg += "[get_pronoun("He")] [get_pronoun("has")] [icon2html(gloves, user)] <a href='?src=\ref[src];lookitem_desc_only=\ref[gloves]'>\a [gloves_name]</a> on [get_pronoun("his")] hands.\n"
	else if(blood_color)
		msg += "<span class='warning'>[get_pronoun("He")] [get_pronoun("has")] [fluid_color_type_map(hand_blood_color)]-stained hands!</span>\n"

	//belt
	if(belt)
		if(belt.blood_color)
			msg += "<span class='warning'>[get_pronoun("He")] [get_pronoun("has")] [icon2html(belt, user)] [belt.gender==PLURAL?"some":"a"] [fluid_color_type_map(belt.blood_color)]-stained <a href='?src=\ref[src];lookitem_desc_only=\ref[belt]'>[belt.name]</a> about [get_pronoun("his")] waist!</span>\n"
		else
			msg += "[get_pronoun("He")] [get_pronoun("has")] [icon2html(belt, user)] <a href='?src=\ref[src];lookitem_desc_only=\ref[belt]'>\a [belt]</a> about [get_pronoun("his")] waist.\n"

	//shoes
	if(shoes && !skipshoes)
		if(shoes.blood_color)
			msg += "<span class='warning'>[get_pronoun("He")] [get_pronoun("is")] wearing [icon2html(shoes, user)] [shoes.gender==PLURAL?"some":"a"] [fluid_color_type_map(shoes.blood_color)]-stained <a href='?src=\ref[src];lookitem_desc_only=\ref[shoes]'>[shoes.name]</a> on [get_pronoun("his")] feet!</span>\n"
		else
			msg += "[get_pronoun("He")] [get_pronoun("is")] wearing [icon2html(shoes, user)] <a href='?src=\ref[src];lookitem_desc_only=\ref[shoes]'>\a [shoes]</a> on [get_pronoun("his")] feet.\n"
	else if(footprint_color)
		msg += "<span class='warning'>[get_pronoun("He")] [get_pronoun("has")] [fluid_color_type_map(footprint_color)]-stained feet!</span>\n"

	//mask
	if(wear_mask && !skipmask)
		if(wear_mask.blood_color)
			msg += "<span class='warning'>[get_pronoun("He")] [get_pronoun("has")] [icon2html(wear_mask, user)] [wear_mask.gender==PLURAL?"some":"a"] [fluid_color_type_map(wear_mask.blood_color)]-stained <a href='?src=\ref[src];lookitem_desc_only=\ref[wear_mask]'>[wear_mask.name]</a> [wear_mask.get_mask_examine_text(src)]!</span>\n"
		else
			msg += "[get_pronoun("He")] [get_pronoun("has")] [icon2html(wear_mask, user)] <a href='?src=\ref[src];lookitem_desc_only=\ref[wear_mask]'>\a [wear_mask]</a> [wear_mask.get_mask_examine_text(src)].\n"

	//eyes
	if(glasses && !skipeyes)
		if(glasses.blood_color)
			msg += "<span class='warning'>[get_pronoun("He")] [get_pronoun("has")] [icon2html(glasses, user)] [glasses.gender==PLURAL?"some":"a"] [fluid_color_type_map(glasses.blood_color)]-stained <a href='?src=\ref[src];lookitem_desc_only=\ref[glasses]'>[glasses]</a> covering [get_pronoun("his")] eyes!</span>\n"
		else
			msg += "[get_pronoun("He")] [get_pronoun("has")] [icon2html(glasses, user)] <a href='?src=\ref[src];lookitem_desc_only=\ref[glasses]'>\a [glasses]</a> covering [get_pronoun("his")] eyes.\n"

	//left ear
	if(l_ear && !skipears)
		msg += "[get_pronoun("He")] [get_pronoun("has")] [icon2html(l_ear, user)] <a href='?src=\ref[src];lookitem_desc_only=\ref[l_ear]'>\a [l_ear]</a> [l_ear.get_ear_examine_text(src, "left")].\n"

	//right ear
	if(r_ear && !skipears)
		msg += "[get_pronoun("He")] [get_pronoun("has")] [icon2html(r_ear, user)] <a href='?src=\ref[src];lookitem_desc_only=\ref[r_ear]'>\a [r_ear]</a> [r_ear.get_ear_examine_text(src, "right")].\n"

	//ID
	if(wear_id)
		var/id_name = wear_id
		msg += "[get_pronoun("He")] [get_pronoun("is")] wearing [icon2html(wear_id, user)] <a href='?src=\ref[src];lookitem_desc_only=\ref[wear_id]'>\a [id_name]</a>.\n"

	//wrists
	if(wrists && !skipwrists)
		msg += "[get_pronoun("He")] [get_pronoun("is")] wearing [icon2html(wrists, user)] <a href='?src=\ref[src];lookitem_desc_only=\ref[wrists]'>\a [wrists]</a> on [get_pronoun("his")] [wrists.gender==PLURAL?"wrists":"wrist"].\n"

	//Jitters
	if(is_jittery)
		if(jitteriness >= 300)
			msg += "<span class='warning'><B>[get_pronoun("He")] [get_pronoun("is")] convulsing violently!</B></span>\n"
		else if(jitteriness >= 200)
			msg += "<span class='warning'>[get_pronoun("He")] [get_pronoun("is")] extremely jittery.</span>\n"
		else if(jitteriness >= 100)
			msg += "<span class='warning'>[get_pronoun("He")] [get_pronoun("is")] twitching ever so slightly.</span>\n"

	//splints
	for(var/organ in list(BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_R_FOOT,BP_L_FOOT))
		var/obj/item/organ/external/o = get_organ(organ)
		if(o)
			if(o.status & ORGAN_SPLINTED)
				msg += "<span class='warning'>[get_pronoun("He")] [get_pronoun("has")] a splint on [get_pronoun("his")] [o.name]!</span>\n"
			if(o.applied_pressure == src)
				msg += "<span class='warning'>[get_pronoun("He")] [get_pronoun("is")] applying pressure to [get_pronoun("his")] [o.name]!</span>\n"

	if(HAS_FLAG(mutations, mSmallsize))
		msg += "[get_pronoun("He")] [get_pronoun("is")] small halfling!\n"
	//height
	if(height)
		msg += "[SPAN_NOTICE("[assembleHeightString(user)]")]\n"

	//buckled_to
	if(buckled_to)
		msg += "[get_pronoun("He")] [get_pronoun("is")] buckled to [icon2html(buckled_to, user)] [buckled_to].\n"

	//handcuffed?
	if(handcuffed)
		msg += "<span class='warning'>[get_pronoun("He")] [get_pronoun("has")] [icon2html(handcuffed, user)] cuffs around [get_pronoun("his")] wrists!</span>\n"

	//handcuffed?
	if(legcuffed)
		msg += "<span class='warning'>[get_pronoun("He")] [get_pronoun("has")] [icon2html(legcuffed, user)] cuffs around [get_pronoun("his")] ankles!</span>\n"

	//Red Nightshade
	if(is_berserk())
		msg += "<span class='warning'><B>[get_pronoun("He")] [get_pronoun("has")] engorged veins, which appear a vibrant red!</B></span>\n"

	var/distance = get_dist(user,src)
	if(istype(user, /mob/abstract/observer) || user.stat == DEAD) // ghosts can see anything
		distance = 1

	if((src.stat || (status_flags & FAKEDEATH)) && !(src.species.flags & NO_BLOOD))	// No point checking pulse of a species that doesn't have one.
		msg += "<span class='warning'>[get_pronoun("He")] [get_pronoun("is")]n't responding to anything around [get_pronoun("him")] and seems to be unconscious.</span>\n"
		if(distance <= 3 && ((stat == DEAD || is_asystole() || src.losebreath) || (status_flags & FAKEDEATH)))
			msg += "<span class='warning'>[get_pronoun("He")] [get_pronoun("does")] not appear to be breathing.</span>\n"

	else if (src.stat)
		msg += SPAN_WARNING("[get_pronoun("He")] [get_pronoun("is")] not responding to anything around [get_pronoun("him")].\n")

	if(fire_stacks)
		msg += "[get_pronoun("He")] [get_pronoun("is")] covered in some liquid.\n"

	if(on_fire)
		msg += "<span class='danger'>[get_pronoun("He")] [get_pronoun("is")] on fire!</span>\n"

	//when the player is winded by an admin
	if(paralysis > 6000)
		msg += "<span><font size='3'><font color='#002eb8'><b>OOC Information:</b></font> <font color='red'>This player has been winded by a member of staff! Please freeze all roleplay involving their character until the matter is resolved! Adminhelp if you have further questions.</font></font></span>\n"

	msg += "<span class='warning'>"

	msg += "</span>"

	var/have_client = client
	var/inactivity = client ? client.inactivity : null

	if(bg)
		disconnect_time = bg.disconnect_time
		have_client = bg.client
		inactivity =  have_client ? bg.client.inactivity : null


	if(species.show_ssd && (!species.has_organ[BP_BRAIN] || has_brain()) && stat != DEAD && !(status_flags & FAKEDEATH))
		if(!vr_mob && !key)
			msg += "<span class='deadsay'>[get_pronoun("He")] [get_pronoun("is")] [species.show_ssd]. It doesn't look like [get_pronoun("he")] [get_pronoun("is")] waking up anytime soon.</span>\n"
		else if(!vr_mob && !client && !bg)
			msg += "<span class='deadsay'>[get_pronoun("He")] [get_pronoun("is")] [species.show_ssd].</span>\n"
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
			wound_flavor_text["[organ_descriptor]"] = "<span class='warning'><b>[get_pronoun("He")] [get_pronoun("is")] missing [get_pronoun("his")] [organ_descriptor].</b></span>\n"
		else if(E.is_stump())
			wound_flavor_text["[organ_descriptor]"] = "<span class='warning'><b>[get_pronoun("He")] [get_pronoun("has")] a stump where [get_pronoun("his")] [organ_descriptor] should be.</b></span>\n"
		else
			continue

	for(var/obj/item/organ/external/temp in organs)
		if(temp)
			var/body_part = temp.body_part
			if(temp.body_part & HEAD)
				body_part &= ~HEAD
				body_part |= (temp.body_part & FACE) ? HEAD : 0
			if(skipbody_thick & body_part)
				continue
			var/thin_covering = (skipbody & body_part) ? TRUE : FALSE
			if((temp.status & ORGAN_ASSISTED) && !thin_covering)
				if(!(temp.brute_dam + temp.burn_dam) && !(temp.open))
					continue
				else
					wound_flavor_text["[temp.name]"] = "<span class='warning'>[get_pronoun("He")] [get_pronoun("has")] [temp.get_wounds_desc()] on [get_pronoun("his")] [temp.name].</span><br>"
			else if(length(temp.wounds) || temp.open)
				if(!thin_covering)
					if(temp.is_stump() && temp.parent_organ && organs_by_name[temp.parent_organ])
						var/obj/item/organ/external/parent = organs_by_name[temp.parent_organ]
						wound_flavor_text["[temp.name]"] = "<span class='warning'>[get_pronoun("He")] [get_pronoun("has")] [temp.get_wounds_desc()] on [get_pronoun("his")] [parent.name].</span><br>"
					else
						wound_flavor_text["[temp.name]"] = "<span class='warning'>[get_pronoun("He")] [get_pronoun("has")] [temp.get_wounds_desc()] on [get_pronoun("his")] [temp.name].</span><br>"
				if(temp.status & ORGAN_BLEEDING)
					if(thin_covering)
						is_bleeding["[temp.body_part_class()]"] = "<span class='danger'>[get_pronoun("He")] [temp.covered_bleed_report(species.blood_type)]</span><br>"
					else
						is_bleeding["[temp.name]"] = "<span class='danger'>[get_pronoun("His")] [temp.name] is bleeding!</span><br>"
			else
				wound_flavor_text["[temp.name]"] = ""
			if(temp.dislocated == 2)
				wound_flavor_text["[temp.name]"] += "<span class='warning'>[get_pronoun("His")] [temp.joint] is dislocated!</span><br>"
			if(((temp.status & ORGAN_BROKEN) && temp.brute_dam > temp.min_broken_damage) || (temp.status & ORGAN_MUTATED))
				wound_flavor_text["[temp.name]"] += "<span class='warning'>[get_pronoun("His")] [temp.name] is dented and swollen!</span><br>"

	//Handles the text strings being added to the actual description.
	//If they have something that covers the limb, and it is not missing, put flavortext.  If it is covered but bleeding, add other flavortext.

	for(var/limb in wound_flavor_text)
		if(wound_flavor_text[limb])
			msg += wound_flavor_text[limb]
			is_bleeding[limb] = null
	for(var/limb in is_bleeding)
		msg += is_bleeding[limb]
	for(var/obj/item/organ/external/organ in src.organs)
		for(var/obj/item/O in organ.implants)
			if(!istype(O,/obj/item/implant) && !istype(O,/obj/item/material/shard/shrapnel))
				msg += "<span class='danger'>[src] [get_pronoun("has")] \a [O] sticking out of [get_pronoun("his")] [organ.name]!</span>\n"
	if(digitalcamo)
		msg += "[get_pronoun("He")] [get_pronoun("is")] a little difficult to identify.\n"

	if(hasHUD(user,SEC_HUDTYPE))
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

	if(hasHUD(user,MED_HUDTYPE))
		var/perpname = "wot"
		var/medical = "None"

		var/obj/item/card/id/ID = GetIdCard()
		if(ID)
			perpname = ID.registered_name
		else
			perpname = src.name

		var/datum/record/general/R = SSrecords.find_record("name", perpname)
		if(istype(R))
			medical = R.physical_status

		msg += "<span class = 'deptradio'>Physical Status:</span> <a href='?src=\ref[src];medical=1'>\[[medical]\]</a>\n"
		msg += "<span class = 'deptradio'>Medical Records:</span> <a href='?src=\ref[src];medrecord=`'>\[View\]</a> <a href='?src=\ref[src];medrecordadd=`'>\[Add Comment\]</a>\n"
		msg += "<span class = 'deptradio'>Triage Tag:</span> <a href='?src=\ref[src];triagetag=1'>\[[triage_tag]\]</a>\n"


	if(print_flavor_text()) msg += "[print_flavor_text()]\n"

	msg += "*---------*</span>"

	if(src in intent_listener)
		msg += SPAN_NOTICE("\n[get_pronoun("He")] looks like [get_pronoun("he")] [get_pronoun("is")] listening intently to [get_pronoun("his")] surroundings.")

	var/datum/vampire/V = get_antag_datum(MODE_VAMPIRE)
	if(V && (V.status & VAMP_DRAINING))
		var/obj/item/grab/G = get_active_hand()
		msg += SPAN_ALERT(FONT_LARGE("\n[get_pronoun("He")] is biting [G.affecting]'[G.affecting.get_pronoun("end")] neck!"))

	if (pose)
		if( findtext(pose,".",length(pose)) == 0 && findtext(pose,"!",length(pose)) == 0 && findtext(pose,"?",length(pose)) == 0 )
			pose = addtext(pose,".") //Makes sure all emotes end with a period.
		msg += "\n[get_pronoun("He")] [pose]"

	to_chat(user, msg.Join())
	if(Adjacent(user))
		INVOKE_ASYNC(src, PROC_REF(examine_pulse), user)

//Helper procedure. Called by /mob/living/carbon/human/examine() and /mob/living/carbon/human/Topic() to determine HUD access to security and medical records.
/proc/hasHUD(mob/M, hudtype)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/clothing/glasses/G = H.glasses
		var/eye_hud = 0
		var/hud = 0
		// Checks for eye sensor HUD
		var/obj/item/organ/internal/augment/eye_sensors/E = locate() in H.internal_organs
		if(E)
			eye_hud = E.check_hud(hudtype)
		if(G)
			switch(hudtype)
				if(SEC_HUDTYPE)
					hud = G.is_sec_hud()
				if(MED_HUDTYPE)
					hud = G.is_med_hud()
		return hud || eye_hud
	else if(istype(M, /mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = M
		switch(hudtype)
			if(SEC_HUDTYPE)
				return R.sensor_mode_sec()
			if(MED_HUDTYPE)
				return R.sensor_mode_med()
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

/mob/living/carbon/human/assembleHeightString(mob/examiner)
	var/list/heightString = list()
	var/descriptor
	if(height == HEIGHT_NOT_USED)
		return heightString

	// Compare to Species Average
	if(species.species_height != HEIGHT_NOT_USED)
		switch(height - species.species_height)
			if(-999 to -100)
				descriptor = "miniscule"
			if(-99 to -50)
				descriptor = "tiny"
			if(-49 to -11)
				descriptor = "small"
			if(-10 to 10)
				descriptor = "about average height"
			if(11 to 50)
				descriptor = "tall"
			if(51 to 100)
				descriptor = "huge"
			else
				descriptor = "gargantuan"
		heightString += "[get_pronoun("He")] look[get_pronoun("end")] [descriptor]"
		if(!species.hide_name)
			heightString += " for a [species.name]"


	if(examiner.height == HEIGHT_NOT_USED)
		return heightString

	switch(height - examiner.height)
		if(-999 to -100)
			descriptor = "absolutely tiny compared to"
		if(-99 to -51)
			descriptor = "much smaller than"
		if(-50 to -21)
			descriptor = "significantly shorter than"
		if(-20 to -11)
			descriptor = "shorter than"
		if(-10 to -6)
			descriptor = "slightly shorter than"
		if(-5 to 5)
			descriptor = "around the same height as"
		if(6 to 10)
			descriptor = "slightly taller than"
		if(11 to 20)
			descriptor = "taller than"
		if(21 to 50)
			descriptor = "significantly taller than"
		if(51 to 100)
			descriptor = "much larger than"
		else
			descriptor = "to tower over"
	if(heightString)
		return heightString += ", and [get_pronoun("he")] seem[get_pronoun("end")] [descriptor] you."
	return "[get_pronoun("He")] seem[get_pronoun("end")] [descriptor] you."

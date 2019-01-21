/client/proc/spawn_duty_officer()
	set category = "Special Verbs"
	set name = "Spawn CCIA Agent"
	set desc = "Spawns a CCIA Agent to agent around."

	if(!check_rights(R_CCIAA))	return

	if(!holder)
		return //how did they get here?

	if(!ROUND_IS_STARTED)
		to_chat(src,"<span class='warning'>The game hasn't started yet!</span>")
		return

	if(istype(mob, /mob/abstract/new_player))
		to_chat(src,"<span class='warning'>You can't be in the lobby to join as a duty officer.</span>")
		return

	if (alert(usr, "Do you want to cancel or proceed?", "Are you sure?", "Proceed", "Cancel") == "Cancel")
		to_chat(src,"<span class='notice'>Cancelled.</span>")
		return

	if(mob.mind && mob.mind.special_role == "CCIA Agent")
		to_chat(src,"<span class='warning'>You are already a CCIA Agent.</span>")
		verbs += /client/proc/returntobody
		return

	var/wasLiving = 0
	if(istype(mob, /mob/living))
		holder.original_mob = mob
		wasLiving = 1

	var/obj/effect/landmark/L
	for (var/obj/effect/landmark/landmark in landmarks_list)
		if(landmark.name == "CCIAAgent")
			L = landmark
			break

	if (!L)
		return
		
	var/new_name = input(usr, "Pick a name","Name") as text
	var/mob/living/carbon/human/M = new(null)

	M.check_dna(M)

	M.real_name = new_name
	M.name = new_name
	M.age = input("Enter your characters age:","Num") as num
	if(!M.age)
		M.age = rand(35,50)
	if(M.age < 33 || M.age > 60)
		to_chat(src,"<span class='warning'>The age you selected was not in a valid range for a Duty Officer.</span>")
		if(M.age < 33)
			M.age = 33
		else
			M.age = 60
		to_chat(src,"<span class='warning'>Your age has been set to [M.age].</span>")

	M.dna.ready_dna(M)

	M.mind = new
	M.mind.current = M
	M.mind.original = M
	if(wasLiving)
		M.mind.admin_mob_placeholder = mob
	M.mind.assigned_role = "Central Command Internal Affairs Agent"
	M.mind.special_role = "CCIA Agent"
	M.forceMove(L.loc)
	M.key = key

	M.change_appearance(APPEARANCE_ALL, M.loc, check_species_whitelist = 1)

	if(wasLiving)
		clear_cciaa_job(holder.original_mob)
		addtimer(CALLBACK(holder.original_mob, /mob/.proc/invalidate_key_tmr), 1)

	M.equip_to_slot_or_del(new /obj/item/clothing/under/rank/centcom_officer(M), slot_w_uniform)
	M.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(M), slot_shoes)
	M.equip_to_slot_or_del(new /obj/item/clothing/gloves/white(M), slot_gloves)
	M.equip_to_slot_or_del(new /obj/item/device/radio/headset/ert/ccia(M), slot_l_ear)
	M.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(M), slot_glasses)
	M.equip_to_slot_or_del(new /obj/item/clothing/head/beret/centcom/officer(M), slot_head)
	M.equip_to_slot_or_del(new /obj/item/weapon/reagent_containers/spray/pepper(M), slot_l_store)
	M.equip_to_slot_or_del(new /obj/item/device/taperecorder/cciaa(M), slot_r_store)

	var/obj/item/clothing/suit/storage/toggle/internalaffairs/suit = new(M)
	suit.name = "central command internal affairs jacket"
	M.equip_to_slot_or_del(suit, slot_wear_suit)

	var/obj/item/weapon/storage/backpack/satchel/bag = new(M)
	bag.name = "officer's leather satchel"
	bag.desc = "A well cared for leather satchel for Nanotrasen officers."
	M.equip_to_slot_or_del(bag, slot_back)
	if(M.backbag == 1)
		M.equip_to_slot_or_del(new /obj/item/weapon/stamp/centcomm(M), slot_in_backpack)

	var /obj/item/weapon/storage/lockbox/lockbox = new(M)
	lockbox.req_access = list(access_cent_captain)
	lockbox.name = "CCIA agent briefcase"
	lockbox.desc = "A smart looking briefcase with a NT logo on the side"
	lockbox.storage_slots = 8
	lockbox.max_storage_space = 16
	M.equip_to_slot_or_del(lockbox, slot_l_hand)

	var/obj/item/device/pda/central/pda = new(M)
	pda.owner = M.real_name
	pda.ownjob = "Central Command Internal Affairs Agent"
	pda.name = "PDA-[M.real_name] ([pda.ownjob])"

	M.equip_to_slot_or_del(pda, slot_belt)

	M.implant_loyalty(M, 1)

	var/obj/item/weapon/card/id/centcom/W = new(M)
	W.name = "[M.real_name]'s ID Card"
	W.item_state = "id_inv"
	W.access = get_all_accesses() | get_centcom_access("CCIA Agent")
	W.assignment = "Central Command Internal Affairs Agent"
	W.registered_name = M.real_name
	M.equip_to_slot_or_del(W, slot_wear_id)

	verbs += /client/proc/returntobody

/client/proc/returntobody()
	set name = "Return to mob"
	set desc = "The Agent's work is done, return to your original mob"
	set category = "Special Verbs"

	if(!check_rights(0))		return

	if (!mob.mind || !(mob.mind.special_role in list("CCIA Agent", "ERT Commander")))
		verbs -= /client/proc/returntobody
		return

	if(!holder)		return

	var/mob/M = mob
	var/area/A = get_area(M)

	if(M.stat == DEAD)
		if(holder.original_mob)
			if(holder.original_mob.client)
				if(alert(src, "There is someone else in your old body.\nWould you like to ghost instead?", "There is someone else in your old body, you will be ghosted", "Yes", "No") == "Yes")
					M.mind.special_role = null
					mob.ghostize(1)
					return
				else
					return
			holder.original_mob.key = key
			holder.original_mob = null
			return
		M.mind.special_role = null
		mob.ghostize(1)
		return

	if(!is_type_in_list(A,centcom_areas))
		src << "<span class='warning'>You need to be back at central to do this.</span>"
		return

	if(holder.original_mob)
		if(holder.original_mob == M)
			verbs -= /client/proc/returntobody
			return

		if(holder.original_mob.client)
			if(alert(src, "There is someone else in your old body.\nWould you like to ghost instead?", "There is someone else in your old body, you will be ghosted", "Yes", "No") == "Yes")
				M.mind.special_role = null
				mob.ghostize(0)
			else
				return
		else
			holder.original_mob.key = key

		holder.original_mob = null
	else
		if(mob.mind.admin_mob_placeholder)
			if(mob.mind.admin_mob_placeholder.client)
				if(alert(src, "There is someone else in your old body.\nWould you like to ghost instead?", "There is someone else in your old body, you will be ghosted", "Yes", "No") == "Yes")
					M.mind.special_role = null
					mob.ghostize(0)
				else
					return
			else
				mob.mind.admin_mob_placeholder.key = key
			M.mind.admin_mob_placeholder = null
		else
			M.mind.special_role = null
			mob.ghostize(0)
	verbs -= /client/proc/returntobody
	qdel(M)

/proc/clear_cciaa_job(var/mob/living/carbon/human/M)
	addtimer(CALLBACK(GLOBAL_PROC, /proc/actual_clear_ccia_job, M), 9000)

/proc/actual_clear_ccia_job(mob/living/carbon/human/H)
	if (!H.client)
		var/oldjob = H.mind.assigned_role
		SSjobs.FreeRole(oldjob)

/datum/admins/proc/create_admin_fax(var/department in alldepartments)
	set name = "Send admin fax"
	set desc = "Send a fax from Central Command"
	set category = "Special Verbs"

	if (!check_rights(R_ADMIN|R_CCIAA|R_FUN))
		usr << "<span class='warning'>You do not have enough powers to do this.</span>"
		return

	if (!department)
		usr << "<span class='warning'>No target department specified!</span>"
		return

	var/obj/machinery/photocopier/faxmachine/fax = null

	for (var/obj/machinery/photocopier/faxmachine/F in allfaxes)
		if (F.department == department)
			fax = F
			break

	if (!fax)
		usr << "<span class='warning'>Couldn't find a fax machine to send this to!</span>"
		return

	//todo: sanitize
	var/input = input(usr, "Please enter a message to reply to via secure connection. NOTE: BBCode does not work, but HTML tags do! Use <br> for line breaks.", "Outgoing message from Centcomm", "") as message|null
	if (!input)
		usr << "<span class='warning'>Cancelled.</span>"
		return

	var/customname = input(usr, "Pick a title for the report", "Title") as text|null
	if (!customname)
		usr << "<span class='warning'>Cancelled.</span>"
		return
	var/announce = alert(usr, "Do you wish to announce the fax being sent?", "Announce Fax", "Yes", "No")
	if(announce == "Yes")
		announce = 1

	// Create the reply message
	var/obj/item/weapon/paper/P = new /obj/item/weapon/paper( null ) //hopefully the null loc won't cause trouble for us
	P.name = "[current_map.boss_name] - [customname]"
	P.info = input
	P.update_icon()

	// Stamps
	var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
	stampoverlay.icon_state = "paper_stamp-cent"
	if(!P.stamped)
		P.stamped = new
	P.stamped += /obj/item/weapon/stamp
	P.add_overlay(stampoverlay)
	P.stamps += "<HR><i>This paper has been stamped by the Central Command Quantum Relay.</i>"

	if(fax.receivefax(P))
		if(announce == 1)
			command_announcement.Announce("A fax has been sent to the [department] fax machine.", "Fax Sent")
		usr << "<span class='notice'>Message transmitted successfully.</span>"
		log_and_message_admins("sent a fax message to the [department] fax machine. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[fax.x];Y=[fax.y];Z=[fax.z]'>JMP</a>)")

		sent_faxes += P
	else
		usr << "<span class='warning'>Message reply failed.</span>"
		qdel(P)
	return

/client/proc/check_fax_history()
	set name = "Check fax history"
	set desc = "Look up the faxes sent this round."
	set category = "Special Verbs"

	if (!check_rights(R_ADMIN|R_CCIAA|R_FUN))
		usr << "<span class='warning'>You do not have enough powers to do this.</span>"
		return

	var/data = "<center><a href='?_src_=holder;CentcommFaxReply=1'>Send New Fax</a></center>"
	data += "<hr>"
	data += "<center><b>Received Faxes:</b></center><br>"

	if (arrived_faxes && arrived_faxes.len)
		for (var/obj/item/item in arrived_faxes)
			data += "[item.name] - <a href='?_src_=holder;AdminFaxView=\ref[item]'>view message</a><br>"
	else
		data += "<center>No faxes have been received.</center>"

	data += "<hr><center><b>Sent Faxes:</b></center><br>"

	if (sent_faxes && sent_faxes.len)
		for (var/obj/item/item in sent_faxes)
			data += "[item.name] - <a href='?_src_=holder;AdminFaxView=\ref[item]'>view message</a><br>"
	else
		data += "<center>No faxes have been sent out.</center>"

	usr << browse("<HTML><HEAD><TITLE>Centcomm Fax History</TITLE></HEAD><BODY>[data]</BODY></HTML>", "window=Centcomm Fax History")

/client/proc/view_duty_log()
	set category = "Special Verbs"
	set name = "Get Duty Log"
	set desc = "Download a log or file from an investigation"

	var/path = browse_files("data/dutylogs/")
	if(!path)
		return

	if(file_spam_check())
		return

	message_admins("[key_name_admin(src)] accessed file: [path]")
	usr << run( file(path) )
	feedback_add_details("admin_verb","DOGL") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

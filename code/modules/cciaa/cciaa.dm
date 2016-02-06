/client/proc/spawn_duty_officer()
	set category = "Special Verbs"
	set name = "Spawn CCIA Agent"
	set desc = "Spawns a CCIA Agent to agent around."

	if(!check_rights(list(R_CCIAA)))	return

	if(!holder)
		return //how did they get here?

	if(!ticker)
		alert("Wait until the game starts")
		return

	if(ticker.current_state < GAME_STATE_PLAYING)
		src << "\red The game hasn't started yet!"
		return

	if(istype(mob, /mob/new_player))
		src << "\red You can't be in the lobby to join as a duty officer"
		return

	if(mob.mind && mob.mind.special_role == "CCIA Agent")
		src << "\red You are already a CCIA Agent"
		verbs += /client/proc/returntobody
		return

	var/wasLiving = 0
	if(istype(mob, /mob/living))
		holder.original_mob = mob
		wasLiving = 1

	for (var/obj/effect/landmark/L in landmarks_list)
		if(L.name == "CCIAAgent")
			var/new_name = input(usr, "Pick a name","Name") as null|text
			var/mob/living/carbon/human/M = new(null)

			var/new_facial = input("Please select facial hair color.", "Character Generation") as color
			if(new_facial)
				M.r_facial = hex2num(copytext(new_facial, 2, 4))
				M.g_facial = hex2num(copytext(new_facial, 4, 6))
				M.b_facial = hex2num(copytext(new_facial, 6, 8))

			var/new_hair = input("Please select hair color.", "Character Generation") as color
			if(new_facial)
				M.r_hair = hex2num(copytext(new_hair, 2, 4))
				M.g_hair = hex2num(copytext(new_hair, 4, 6))
				M.b_hair = hex2num(copytext(new_hair, 6, 8))

			var/new_eyes = input("Please select eye color.", "Character Generation") as color
			if(new_eyes)
				M.r_eyes = hex2num(copytext(new_eyes, 2, 4))
				M.g_eyes = hex2num(copytext(new_eyes, 4, 6))
				M.b_eyes = hex2num(copytext(new_eyes, 6, 8))

			var/new_tone = input("Please select skin tone level: 1-220 (1=albino, 35=caucasian, 150=black, 220='very' black)", "Character Generation")  as text

			if (!new_tone)
				new_tone = 35
			M.s_tone = max(min(round(text2num(new_tone)), 220), 1)
			M.s_tone =  -M.s_tone + 35

			// hair
			var/list/all_hairs = typesof(/datum/sprite_accessory/hair) - /datum/sprite_accessory/hair
			var/list/hairs = list()

			// loop through potential hairs
			for(var/x in all_hairs)
				var/datum/sprite_accessory/hair/H = new x
				hairs.Add(H.name)
				qdel(H)
			//hair
			var/new_hstyle = input(usr, "Select a hair style", "Grooming")  as null|anything in hair_styles_list
			if(new_hstyle)
				M.h_style = new_hstyle

			// facial hair
			var/new_fstyle = input(usr, "Select a facial hair style", "Grooming")  as null|anything in facial_hair_styles_list
			if(new_fstyle)
				M.f_style = new_fstyle

			var/new_gender = alert(usr, "Please select gender.", "Character Generation", "Male", "Female")
			if (new_gender)
				if(new_gender == "Male")
					M.gender = MALE
				else
					M.gender = FEMALE
			//M.rebuild_appearance()
			M.update_hair()
			M.update_body()
			M.check_dna(M)

			M.real_name = new_name
			M.name = new_name
			M.age = input("Enter your characters age:","Num") as null|num
			if(!M.age)
				M.age = rand(35,50)
			if(M.age < 33 || M.age > 60)
				src << "\red The age you selected was not in a valid range for a Duty Officer"
				if(M.age < 33)
					M.age = 33
				else
					M.age = 60
				src << "\red Your age has been set to [M.age]"

			M.dna.ready_dna(M)

			//Creates mind stuff.
			M.mind = new
			M.mind.current = M
			M.mind.original = M
			if(wasLiving)
				M.mind.admin_mob_placeholder = mob
			M.mind.assigned_role = "Central Command Internal Affairs Agent"
			M.mind.special_role = "CCIA Agent"
			M.loc = L.loc
			M.key = key

			if(wasLiving)
				clear_cciaa_job(holder.original_mob)
				spawn(1)
					holder.original_mob.key = "@[key]"

			M.equip_to_slot_or_del(new /obj/item/clothing/under/rank/centcom_officer(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/gloves/white(M), slot_gloves)
			M.equip_to_slot_or_del(new /obj/item/device/radio/headset/ert(M), slot_l_ear)
			M.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(M), slot_glasses)
			M.equip_to_slot_or_del(new /obj/item/clothing/head/beret/centcom/officer(M), slot_head)
			M.equip_to_slot_or_del(new /obj/item/weapon/reagent_containers/spray/pepper(M), slot_l_store)
			M.equip_to_slot_or_del(new /obj/item/device/taperecorder/cciaa(M), slot_r_store)

			var/obj/item/weapon/storage/backpack/satchel/bag = new(M)
			bag.name = "officer's leather satchel"
			bag.desc = "A well cared for leather satchel for Nanotrasen officers."
			M.equip_to_slot_or_del(bag, slot_back)
			if(M.backbag == 1)
				M.equip_to_slot_or_del(new /obj/item/weapon/stamp/centcomm(M.back), slot_in_backpack)

			var /obj/item/weapon/storage/lockbox/lockbox = new(M)
			lockbox.req_access = list(access_cent_captain)
			lockbox.name = "A CCIA Agent briefcase"
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

			var/obj/item/weapon/card/id/W = new(M)
			W.name = "[M.real_name]'s ID Card"
			W.icon_state = "centcom"
			W.item_state = "id_inv"
			W.access = get_all_accesses() + get_centcom_access("CCIAA")
			W.assignment = "Central Command Internal Affairs Agent"
			W.registered_name = M.real_name
			M.equip_to_slot_or_del(W, slot_wear_id)

			verbs += /client/proc/returntobody
			break

/client/proc/returntobody()
	set name = "Return to mob"
	set desc = "The Agent's work is done, return to your original mob"
	set category = "Special Verbs"

	if(!check_rights(list()))		return

	if(!mob.mind || mob.mind.special_role != "CCIA Agent")
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
		src << "\red You need to be back at central to do this"
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
	spawn(9000)
		if(!M.client)
			var/oldjob = M.mind.assigned_role
			job_master.FreeRole(oldjob)
	return

/datum/admins/proc/create_admin_fax(var/department in alldepartments)
	set name = "Send admin fax"
	set desc = "Send a fax from Central Command"
	set category = "Special Verbs"

	if (!check_rights(list(R_ADMIN,R_CCIAA,R_FUN)))
		usr << "\red You do not have enough powers to do this."
		return

	if (!department)
		usr << "\red No target department specified!"
		return

	var/obj/machinery/photocopier/faxmachine/fax = null

	for (var/obj/machinery/photocopier/faxmachine/F in allfaxes)
		if (F.department == department)
			fax = F
			break

	if (!fax)
		usr << "\red Couldn't find a fax machine to send this to!"
		return

	//todo: sanitize
	var/input = input(usr, "Please enter a message to reply to via secure connection. NOTE: BBCode does not work, but HTML tags do! Use <br> for line breaks.", "Outgoing message from Centcomm", "") as message|null
	if (!input)
		usr << "\red Cancelled."
		return

	var/customname = input(usr, "Pick a title for the report", "Title") as text|null

	// Create the reply message
	var/obj/item/weapon/paper/P = new /obj/item/weapon/paper( null ) //hopefully the null loc won't cause trouble for us
	P.name = "[command_name()]- [customname]"
	P.info = input
	P.update_icon()

	// Stamps
	var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
	stampoverlay.icon_state = "paper_stamp-cent"
	if(!P.stamped)
		P.stamped = new
	P.stamped += /obj/item/weapon/stamp
	P.overlays += stampoverlay
	P.stamps += "<HR><i>This paper has been stamped by the Central Command Quantum Relay.</i>"

	if(fax.recievefax(P))
		usr << "\blue Message transmitted successfully."
		log_and_message_admins("sent a fax message to the [department] fax machine. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[fax.x];Y=[fax.y];Z=[fax.z]'>JMP</a>)")
	else
		usr << "\red Message reply failed."

	spawn(100)
		qdel(P)
	return

/client/proc/check_fax_history()
	set name = "Check fax history"
	set desc = "Look up the faxes sent this round."
	set category = "Special Verbs"

	if (!check_rights(list(R_ADMIN,R_CCIAA,R_FUN)))
		usr << "\red You do not have enough powers to do this."
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

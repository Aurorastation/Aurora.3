/client/proc/spawn_ert_commander()
	set category = "Special Verbs"
	set name = "Spawn ERT Commander"
	set desc = "Spawns an ERT Commander."

	if(!check_rights(R_CCIAA))	return

	if(!holder)
		return //how did they get here?

	if(!ROUND_IS_STARTED)
		to_chat(src,"<span class='warning'>The game hasn't started yet!</span>")
		return

	if(istype(mob, /mob/abstract/new_player))
		to_chat(src,"<span class='warning'>You can't be in the lobby to join as a commander.</span>")
		return

	if (alert(usr, "Do you want to cancel or proceed?", "Are you sure?", "Proceed", "Cancel") == "Cancel")
		to_chat(src,"<span class='notice'>Cancelled.</span>")
		return

	if(mob.mind && mob.mind.special_role == "ERT Commander")
		to_chat(src,"<span class='warning'>You are already an ERT Commander.</span>")
		verbs += /client/proc/returntobody
		return

	var/wasLiving = 0
	if(istype(mob, /mob/living))
		holder.original_mob = mob
		wasLiving = 1

	var/obj/effect/landmark/L
	for (var/obj/effect/landmark/landmark in landmarks_list)
		if(landmark.name == "ERTCommander")
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
		to_chat(src,"<span class='warning'>The age you selected was not in a valid range for a Commander.</span>")
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
	M.mind.assigned_role = "Emergency Response Team Commander"
	M.mind.special_role = "ERT Commander"
	M.forceMove(L.loc)
	M.key = key

	M.change_appearance(APPEARANCE_ALL, M.loc, check_species_whitelist = 1)

	if(wasLiving)
		clear_cciaa_job(holder.original_mob)
		addtimer(CALLBACK(holder.original_mob, /mob/.proc/invalidate_key_tmr), 1)

	M.equip_to_slot_or_del(new /obj/item/clothing/under/rank/centcom_commander(M), slot_w_uniform)
	M.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(M), slot_shoes)
	M.equip_to_slot_or_del(new /obj/item/clothing/gloves/white(M), slot_gloves)
	M.equip_to_slot_or_del(new /obj/item/device/radio/headset/ert(M), slot_l_ear)
	M.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(M), slot_glasses)
	M.equip_to_slot_or_del(new /obj/item/clothing/head/beret/centcom/commander(M), slot_head)
	M.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/vest/heavy/ert/commander(M), slot_wear_suit)
	M.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel, slot_back)

			

	var/obj/item/device/pda/central/pda = new(M)
	pda.owner = M.real_name
	pda.ownjob = "Emergency Response Team Commander"
	pda.name = "PDA-[M.real_name] ([pda.ownjob])"

	M.equip_to_slot_or_del(pda, slot_belt)

	M.implant_loyalty(M, 1)

	var/obj/item/weapon/card/id/centcom/W = new(M)
	W.name = "[M.real_name]'s ID Card"
	W.item_state = "id_inv"
	W.access = get_all_accesses() | get_centcom_access("BlackOps Commander")
	W.assignment = "Emergency Response Team Commander"
	W.registered_name = M.real_name
	M.equip_to_slot_or_del(W, slot_wear_id)

	verbs += /client/proc/returntobody

/mob/proc/invalidate_key_tmr()
    key = "@[key]"
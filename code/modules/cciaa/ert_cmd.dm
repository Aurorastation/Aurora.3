/client/proc/spawn_ert_commander()
	set category = "Special Verbs"
	set name = "Spawn Response Team Commander"
	set desc = "Spawns a Response Team Commander."

	if(!check_rights(R_CCIAA))	return

	if(!holder)
		return //how did they get here?

	if(!ROUND_IS_STARTED)
		to_chat(src,"<span class='warning'>The game hasn't started yet!</span>")
		return

	if(!SSresponseteam.send_emergency_team)
		to_chat(usr, "No emergency response team is currently being sent.")
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

	if(mob.mind && mob.mind.special_role == "TCFL Commander")
		to_chat(src,"<span class='warning'>You are already a TCFL Commander.</span>")
		verbs += /client/proc/returntobody
		return

	var/wasLiving = 0
	if(istype(mob, /mob/living))
		holder.original_mob = mob
		wasLiving = 1

	var/obj/effect/landmark/L
	for (var/obj/effect/landmark/landmark in landmarks_list)
		if(landmark.name == "ERTCommander" && SSresponseteam.ert_type == "NanoTrasen Response Team")
			L = landmark
			break
		else if (landmark.name == "TCFLCommander" && SSresponseteam.ert_type == "Tau Ceti Foreign Legion")
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

	if(SSresponseteam.ert_type == "NanoTrasen Response Team")

		M.mind.assigned_role = "Emergency Response Team Commander"
		M.mind.special_role = "ERT Commander"
		M.forceMove(L.loc)
		M.key = key

		M.change_appearance(APPEARANCE_ALL, M.loc, check_species_whitelist = 1)

		if(wasLiving)
			clear_cciaa_job(holder.original_mob)
			addtimer(CALLBACK(holder.original_mob, /mob/.proc/invalidate_key_tmr), 1)

		var/datum/outfit/O = /datum/outfit/admin/nt/ert_commander
		if(O)
			M.preEquipOutfit(O,FALSE)
			M.equipOutfit(O,FALSE)

	if(SSresponseteam.ert_type == "Tau Ceti Foreign Legion")

		M.mind.assigned_role = "Tau Ceti Foreign Legion Commander"
		M.mind.special_role = "TCFL Commander"
		M.forceMove(L.loc)
		M.key = key

		M.change_appearance(APPEARANCE_ALL, M.loc, check_species_whitelist = 1)

		if(wasLiving)
			clear_cciaa_job(holder.original_mob)
			addtimer(CALLBACK(holder.original_mob, /mob/.proc/invalidate_key_tmr), 1)

		var/datum/outfit/O = /datum/outfit/admin/tcfl_commander
		if(O)
			M.preEquipOutfit(O,FALSE)
			M.equipOutfit(O,FALSE)

	verbs += /client/proc/returntobody

/mob/proc/invalidate_key_tmr()
    key = "@[key]"
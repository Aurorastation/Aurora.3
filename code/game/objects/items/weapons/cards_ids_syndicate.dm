/obj/item/card/id/syndicate
	name = "agent card"
	assignment = "Agent"
	origin_tech = list(TECH_ILLEGAL = 3)
	iff_faction = IFF_SYNDICATE
	can_copy_access = TRUE
	access_copy_msg = "The microscanner activates as you pass it over the ID, copying its access."

	/// Used by Agent ID cards to prevent them from being tracked over the camera network while active.
	var/electronic_warfare = FALSE
	/// Internal energy required by Agent ID cards to run Electronic Warfare mode (or any other special behaviors that might be added.)
	var/charge = 10000
	/// Base charge used per tick while electronic_warfare = TRUE.
	var/electronic_warfare_discharge_rate = 50
	/// Charge regained per tick while electronic warfare = FALSE (and if not fully charged).
	var/card_recharge_rate = 100
	/// Whether or not the card has given the user a low-charge (<20%) warning to avoid spam. Gets reset back to FALSE when EW mode is disabled.
	var/low_charge_warning_given = FALSE
	/// Used by Agent ID cards (which have mutable apparent identities) to register who the Real registered user actually is, no matter what the card might be displaying.
	var/mob/registered_user = null
	var/image/obfuscation_image

/obj/item/card/id/syndicate/antagonist_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(registered_user == user)
		. += "Use this card on yourself to either show it to those nearby (the standard behavior) or to open its secret UI."

	. += "This card has an 'Electronic Warfare' mode, which prevents the registered user from being automatically tracked by cameras while they are wearing it."
	. += "	- Electronic Warfare mode can be toggled on or off through its main UI, accessed by using the card on yourself."
	. += "	- Electronic Warfare mode costs energy while active (<b>[electronic_warfare_discharge_rate]/tick</b>); the amount of charge left is visible (only to the registered user) on examination."
	. += "	- Electronic Warfare mode will be automatically toggled off if the card is dropped or thrown."
	. += "	- A warning message (visible only to the wearer of the card) will be displayed when the card is down to 20% of its initial charge."
	. += "	- While Electronic Warfare mode is disabled, if not fully charged, the card will <b>automatically recharge itself</b> at a rate of <b>[card_recharge_rate]/tick</b>."

/obj/item/card/id/syndicate/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(is_adjacent)
		if(user == registered_user)
			. += SPAN_NOTICE("It is at <b>[charge]/[initial(charge)]</b> charge.")

/obj/item/card/id/syndicate/New(mob/user as mob)
	..()
	access = GLOB.syndicate_access.Copy()
	START_PROCESSING(SSprocessing, src)

/obj/item/card/id/syndicate/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	unset_registered_user(registered_user)
	return ..()

/obj/item/card/id/syndicate/process()
	if(electronic_warfare)
		charge = max(0, charge - electronic_warfare_discharge_rate)
		// If we haven't already alerted, and charge is low...
		if(!low_charge_warning_given && charge <= (initial(charge) / 5))
			// And if the registered user is currently holding/wearing the card and not doing silly nonsense...
			var/mob/living/carbon/human/registered_human_user = registered_user
			if(istype(registered_human_user) && src == registered_human_user.GetIdCard())
				// Display the message.
				to_chat(registered_human_user, SPAN_WARNING("\The [src] issues a subtle warning pulse that its internal charge is running low."))
				low_charge_warning_given = TRUE
		if(charge <= 0)
			if(ismob(loc))
				to_chat(loc, SPAN_WARNING("\The [src] runs out of power and deactivates."))
				electronic_warfare = FALSE
				check_obfuscation()
	else if(charge != initial(charge))
		charge = min(initial(charge), charge + card_recharge_rate)

/obj/item/card/id/syndicate/prevent_tracking()
	return electronic_warfare

/obj/item/card/id/syndicate/attack_self(mob/user as mob)
	// We use the fact that registered_name is not unset should the owner be vaporized, to ensure the id doesn't magically become unlocked.
	if(!registered_user && register_user(user))
		to_chat(user, SPAN_NOTICE("The microscanner marks you as its owner, preventing others from accessing its internals."))
	if(registered_user == user)
		switch(alert("Would you like edit the ID, or show it?","Show or Edit?", "Edit","Show"))
			if("Edit")
				ui_interact(user)
			if("Show")
				..()
	else
		..()

/obj/item/card/id/syndicate/proc/register_user(var/mob/user)
	if(!istype(user) || user == registered_user)
		return FALSE
	unset_registered_user()
	registered_user = user
	user.set_id_info(src)
	RegisterSignal(user, COMSIG_QDELETING, PROC_REF(on_user_deletion))
	return TRUE

/obj/item/card/id/syndicate/proc/on_user_deletion(datum/source)
	SIGNAL_HANDLER
	unset_registered_user(source)

/obj/item/card/id/syndicate/proc/unset_registered_user(var/mob/user)
	if(!registered_user || (user && user != registered_user))
		return
	UnregisterSignal(registered_user, COMSIG_QDELETING)
	registered_user = null

/obj/item/card/id/syndicate/throw_at()
	..()
	electronic_warfare = FALSE
	check_obfuscation()

/obj/item/card/id/syndicate/dropped()
	..()
	electronic_warfare = FALSE
	check_obfuscation()

/obj/item/card/id/syndicate/on_give()
	check_obfuscation()

/obj/item/card/id/syndicate/update_icon()
	ClearOverlays()
	if(electronic_warfare)
		var/mutable_appearance/electro_overlay = mutable_appearance(icon, "electronic_warfare")
		AddOverlays(electro_overlay)

/obj/item/card/id/syndicate/proc/check_obfuscation()
	if(electronic_warfare)
		if(ismob(loc))
			obfuscation_image = image("loc" = loc)
			obfuscation_image.override = TRUE
			SSai_obfuscation.add_obfuscation_image(obfuscation_image)
		else if(obfuscation_image)
			electronic_warfare = FALSE
			SSai_obfuscation.remove_obfuscation_image(obfuscation_image)
			QDEL_NULL(obfuscation_image)
	else
		if(obfuscation_image)
			SSai_obfuscation.remove_obfuscation_image(obfuscation_image)
		QDEL_NULL(obfuscation_image)
	update_icon()

/obj/item/card/id/syndicate/ui_interact(mob/user, var/datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AgentID", "AgentID", 500, 600)
		ui.open()

/obj/item/card/id/syndicate/ui_data(var/mob/user)
	var/list/data = list()

	data["name"] = name
	data["age"] = age
	data["sex"] = sex
	data["blood_type"] = blood_type
	data["dna_hash"] = dna_hash
	data["fingerprint_hash"] = fingerprint_hash
	data["employer_faction"] = employer_faction
	data["assignment"] = assignment
	data["citizenship"] = citizenship
	data["electronic_warfare"] = electronic_warfare

	return data

/obj/item/card/id/syndicate/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/living/carbon/human/user = usr

	if(!ishuman(user))
		to_chat(usr, "Something has gone wrong; usr is not human. Please report this message and the details of how you received it on the GitHub issues tracker.")
		return

	switch(action)
		// USER INFORMATION ACTIONS
		if("setName")
			var/newName = sanitize(params["name"])
			if(!isnull(newName))
				if(newName == "")
					newName = initial(name)
				else
					name = newName
				to_chat(user, SPAN_NOTICE("Name has been set to '[name]'."))
		if("setAge")
			var/newAge = params["age"]
			if(!isnull(newAge))
				if(newAge < 0)
					age = initial(age)
				else
					age = newAge
				to_chat(user, SPAN_NOTICE("Age has been set to '[age]'."))
		if("setSex")
			var/newSex = sanitize(params["sex"])
			if(!isnull(newSex))
				if(newSex == "")
					newSex = initial(sex)
				else
					sex = newSex
				to_chat(user, SPAN_NOTICE("Sex has been set to '[sex]'."))
		if("updatePhoto")
			set_id_photo(user)
			to_chat(user, SPAN_NOTICE("Photo changed."))

		// BIOMETRIC DATA ACTIONS
		if("setBloodType")
			var/default = blood_type
			if(default == initial(blood_type) && ishuman(user))
				var/mob/living/carbon/human/H = user
				if(H.dna)
					default = H.dna.b_type
			var/newBloodType = sanitize(params["bloodtype"])
			if(!isnull(newBloodType))
				src.blood_type = newBloodType
				to_chat(user, SPAN_NOTICE("Blood type changed to '[newBloodType]'."))
		if("setDNAHash")
			var/default = dna_hash
			if(default == initial(dna_hash) && ishuman(user))
				var/mob/living/carbon/human/H = user
				if(H.dna)
					default = H.dna.unique_enzymes
			var/newDNAHash = sanitize(params["dnahash"])
			if(!isnull(newDNAHash))
				src.dna_hash = newDNAHash
				to_chat(user, SPAN_NOTICE("DNA hash changed to '[newDNAHash]'."))
		if("setFingerprintHash")
			var/default = fingerprint_hash
			if(default == initial(fingerprint_hash) && ishuman(user))
				var/mob/living/carbon/human/H = user
				if(H.dna)
					default = md5(H.dna.uni_identity)
			var/newFingerprintHash = sanitize(params["fingerprinthash"])
			if(!isnull(newFingerprintHash))
				src.fingerprint_hash = newFingerprintHash
				to_chat(user, SPAN_NOTICE("Fingerprint hash changed to '[newFingerprintHash]'."))

		// AFFILIATION DETAIL ACTIONS
		if("setEmployer")
			var/newEmployer = sanitize(params["employer"])
			if(!isnull(newEmployer))
				src.employer_faction = newEmployer
				to_chat(user, SPAN_NOTICE("Faction changed to '[newEmployer]'."))
		if("setAssignment")
			var/newAssignment = sanitize(params["assignment"])
			if(!isnull(newAssignment))
				src.assignment = newAssignment
				to_chat(user, SPAN_NOTICE("Occupation changed to '[newAssignment]'."))
				update_name()
		if("setCitizenship")
			var/newCitizenship = sanitize(params["citizenship"])
			if(!isnull(newCitizenship))
				src.citizenship = newCitizenship
				to_chat(user, SPAN_NOTICE("Citizenship changed to '[newCitizenship]'."))

		// CARD MANAGEMENT ACTIONS
		if("setCardAppearance")
			var/datum/card_state/choice = tgui_input_list(user, "Select the appearance for this card.", "Agent Card Appearance", id_card_states(), icon_state)
			if(choice)
				src.icon_state = choice.icon_state
				src.item_state = choice.item_state
				to_chat(usr, SPAN_NOTICE("Appearance changed to [choice]."))
		if("enableElectronicWarfare")
			to_chat(user, SPAN_NOTICE("Electronic warfare enabled."))
			electronic_warfare = TRUE
			low_charge_warning_given = FALSE
			check_obfuscation()
		if("disableElectronicWarfare")
			to_chat(user, SPAN_NOTICE("Electronic warfare disabled."))
			electronic_warfare = FALSE
			low_charge_warning_given = FALSE
			check_obfuscation()
		if("factoryReset")
			age = initial(age)
			access = GLOB.syndicate_access.Copy()
			assignment = initial(assignment)
			blood_type = initial(blood_type)
			citizenship = initial(citizenship)
			dna_hash = initial(dna_hash)
			electronic_warfare = initial(electronic_warfare)
			fingerprint_hash = initial(fingerprint_hash)
			icon_state = initial(icon_state)
			name = initial(name)
			registered_name = initial(registered_name)
			unset_registered_user()
			sex = initial(sex)
			employer_faction = initial(employer_faction)
			to_chat(user, SPAN_NOTICE("All information has been deleted from \the [src]."))

GLOBAL_LIST_INIT_TYPED(id_card_states, /datum/card_state, null)
/proc/id_card_states()
	if(!GLOB.id_card_states)
		GLOB.id_card_states = list()
		for(var/path in typesof(/obj/item/card/id))
			var/obj/item/card/id/ID = path
			var/datum/card_state/CS = new()
			CS.icon_state = initial(ID.icon_state)
			CS.item_state = initial(ID.item_state)
			CS.name = initial(ID.name) + " - " + initial(ID.icon_state)
			GLOB.id_card_states += CS
		sortTim(GLOB.id_card_states, GLOBAL_PROC_REF(cmp_cardstate), FALSE)

	return GLOB.id_card_states

/datum/card_state
	var/name
	var/icon_state
	var/item_state

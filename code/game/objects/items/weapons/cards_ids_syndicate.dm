/obj/item/card/id/syndicate
	name = "agent card"
	assignment = "Agent"
	origin_tech = list(TECH_ILLEGAL = 3)
	iff_faction = IFF_SYNDICATE
	can_copy_access = TRUE
	access_copy_msg = "The microscanner activates as you pass it over the ID, copying its access."
	var/charge = 10000
	var/electronic_warfare = FALSE
	var/image/obfuscation_image
	var/mob/registered_user = null

/obj/item/card/id/syndicate/New(mob/user as mob)
	..()
	access = syndicate_access.Copy()
	START_PROCESSING(SSprocessing, src)

/obj/item/card/id/syndicate/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	unset_registered_user(registered_user)
	return ..()

/obj/item/card/id/syndicate/examine(mob/user)
	..()
	if(Adjacent(user))
		if(user == registered_user)
			to_chat(user, FONT_SMALL(SPAN_NOTICE("It is at [charge]/[initial(charge)] charge.")))

/obj/item/card/id/syndicate/process()
	if(electronic_warfare)
		charge = max(0, charge - 50)
		if(charge <= 0)
			if(ismob(loc))
				to_chat(loc, SPAN_WARNING("\The [src] runs out of power and deactivates."))
				electronic_warfare = FALSE
				check_obfuscation()
	else if(charge != initial(charge))
		charge = min(initial(charge), charge + 100)

/obj/item/card/id/syndicate/prevent_tracking()
	return electronic_warfare

/obj/item/card/id/syndicate/attack_self(mob/user as mob)
	// We use the fact that registered_name is not unset should the owner be vaporized, to ensure the id doesn't magically become unlocked.
	if(!registered_user && register_user(user))
		to_chat(user, "<span class='notice'>The microscanner marks you as its owner, preventing others from accessing its internals.</span>")
	if(registered_user == user)
		switch(alert("Would you like edit the ID, or show it?","Show or Edit?", "Edit","Show"))
			if("Edit")
				ui_interact(user)
			if("Show")
				..()
	else
		..()

/obj/item/card/id/syndicate/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]
	var/entries[0]
	entries[++entries.len] = list("name" = "Age", 				"value" = age)
	entries[++entries.len] = list("name" = "Appearance",		"value" = "Set")
	entries[++entries.len] = list("name" = "Assignment",		"value" = assignment)
	entries[++entries.len] = list("name" = "Blood Type",		"value" = blood_type)
	entries[++entries.len] = list("name" = "DNA Hash", 			"value" = dna_hash)
	entries[++entries.len] = list("name" = "Fingerprint Hash",	"value" = fingerprint_hash)
	entries[++entries.len] = list("name" = "Name", 				"value" = registered_name)
	entries[++entries.len] = list("name" = "Photo", 			"value" = "Update")
	entries[++entries.len] = list("name" = "Sex", 				"value" = sex)
	entries[++entries.len] = list("name" = "Citizenship",		"value" = citizenship)
	entries[++entries.len] = list("name" = "Religion",			"value" = religion)
	entries[++entries.len] = list("name" = "Faction",			"value" = employer_faction)
	entries[++entries.len] = list("name" = "Factory Reset",		"value" = "Use With Care")
	data["electronic_warfare"] = electronic_warfare
	data["entries"] = entries

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "agent_id_card.tmpl", "Agent id", 600, 400)
		ui.set_initial_data(data)
		ui.open()

/obj/item/card/id/syndicate/proc/register_user(var/mob/user)
	if(!istype(user) || user == registered_user)
		return FALSE
	unset_registered_user()
	registered_user = user
	user.set_id_info(src)
	destroyed_event.register(user, src, /obj/item/card/id/syndicate/proc/unset_registered_user)
	return TRUE

/obj/item/card/id/syndicate/proc/unset_registered_user(var/mob/user)
	if(!registered_user || (user && user != registered_user))
		return
	destroyed_event.unregister(registered_user, src)
	registered_user = null

/obj/item/card/id/syndicate/CanUseTopic(mob/user)
	if(user != registered_user)
		return STATUS_CLOSE
	return ..()


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
	cut_overlays()
	if(electronic_warfare)
		var/mutable_appearance/electro_overlay = mutable_appearance(icon, "electronic_warfare")
		add_overlay(electro_overlay)

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

/obj/item/card/id/syndicate/Topic(href, href_list, var/datum/topic_state/state)
	if(..())
		return 1

	var/user = usr
	if(href_list["electronic_warfare"])
		electronic_warfare = text2num(href_list["electronic_warfare"])
		to_chat(user, SPAN_NOTICE("Electronic warfare [electronic_warfare ? "enabled" : "disabled"]."))
		check_obfuscation()
	else if(href_list["set"])
		switch(href_list["set"])
			if("Age")
				var/new_age = input(user,"What age would you like to put on this card?","Agent Card Age", age) as null|num
				if(!isnull(new_age) && CanUseTopic(user, state))
					if(new_age < 0)
						age = initial(age)
					else
						age = new_age
					to_chat(user, "<span class='notice'>Age has been set to '[age]'.</span>")
					. = 1
			if("Appearance")
				var/datum/card_state/choice = input(user, "Select the appearance for this card.", "Agent Card Appearance") as null|anything in id_card_states()
				if(choice && CanUseTopic(user, state))
					src.icon_state = choice.icon_state
					src.item_state = choice.item_state
					to_chat(usr, "<span class='notice'>Appearance changed to [choice].</span>")
					. = 1
			if("Assignment")
				var/new_job = sanitize(input(user,"What assignment would you like to put on this card?\nChanging assignment will not grant or remove any access levels.","Agent Card Assignment", assignment) as null|text)
				if(!isnull(new_job) && CanUseTopic(user, state))
					src.assignment = new_job
					to_chat(user, "<span class='notice'>Occupation changed to '[new_job]'.</span>")
					update_name()
					. = 1
			if("Blood Type")
				var/default = blood_type
				if(default == initial(blood_type) && ishuman(user))
					var/mob/living/carbon/human/H = user
					if(H.dna)
						default = H.dna.b_type
				var/new_blood_type = sanitize(input(user,"What blood type would you like to be written on this card?","Agent Card Blood Type",default) as null|text)
				if(!isnull(new_blood_type) && CanUseTopic(user, state))
					src.blood_type = new_blood_type
					to_chat(user, "<span class='notice'>Blood type changed to '[new_blood_type]'.</span>")
					. = 1
			if("DNA Hash")
				var/default = dna_hash
				if(default == initial(dna_hash) && ishuman(user))
					var/mob/living/carbon/human/H = user
					if(H.dna)
						default = H.dna.unique_enzymes
				var/new_dna_hash = sanitize(input(user,"What DNA hash would you like to be written on this card?","Agent Card DNA Hash",default) as null|text)
				if(!isnull(new_dna_hash) && CanUseTopic(user, state))
					src.dna_hash = new_dna_hash
					to_chat(user, "<span class='notice'>DNA hash changed to '[new_dna_hash]'.</span>")
					. = 1
			if("Fingerprint Hash")
				var/default = fingerprint_hash
				if(default == initial(fingerprint_hash) && ishuman(user))
					var/mob/living/carbon/human/H = user
					if(H.dna)
						default = md5(H.dna.uni_identity)
				var/new_fingerprint_hash = sanitize(input(user,"What fingerprint hash would you like to be written on this card?","Agent Card Fingerprint Hash",default) as null|text)
				if(!isnull(new_fingerprint_hash) && CanUseTopic(user, state))
					src.fingerprint_hash = new_fingerprint_hash
					to_chat(user, "<span class='notice'>Fingerprint hash changed to '[new_fingerprint_hash]'.</span>")
					. = 1
			if("Name")
				var/new_name = sanitizeName(input(user,"What name would you like to put on this card?","Agent Card Name", registered_name) as null|text)
				if(!isnull(new_name) && CanUseTopic(user, state))
					src.registered_name = new_name
					update_name()
					to_chat(user, "<span class='notice'>Name changed to '[new_name]'.</span>")
					. = 1
			if("Photo")
				set_id_photo(user)
				to_chat(user, "<span class='notice'>Photo changed.</span>")
				. = 1
			if("Sex")
				var/new_sex = sanitize(input(user,"What sex would you like to put on this card?","Agent Card Sex", sex) as null|text)
				if(!isnull(new_sex) && CanUseTopic(user, state))
					src.sex = new_sex
					to_chat(user, "<span class='notice'>Sex changed to '[new_sex]'.</span>")
					. = 1
			if("Citizenship")
				var/new_citizenship = sanitize(input(user,"Which citizenship would you like to put on this card?","Agent Card Citizenship", citizenship) as null|text)
				if(!isnull(new_citizenship) && CanUseTopic(user,state))
					src.citizenship = new_citizenship
					to_chat(user, SPAN_NOTICE("Citizenship changed to '[new_citizenship]'."))
					. = 1
			if("Religion")
				var/new_religion = sanitize(input(user,"What religion would you like to put on this card?","Agent Card Religion", religion) as null|text)
				if(!isnull(new_religion) && CanUseTopic(user,state))
					src.religion = new_religion
					to_chat(user, SPAN_NOTICE("Religion changed to '[new_religion]'."))
					. = 1
			if("Faction")
				var/new_faction = sanitize(input(user,"Which faction would you like to put on this card?","Agent Card Faction", employer_faction) as null|text)
				if(!isnull(new_faction) && CanUseTopic(user,state))
					src.employer_faction = new_faction
					to_chat(user, SPAN_NOTICE("Faction changed to '[new_faction]'."))
					. = 1
			if("Factory Reset")
				if(alert("This will factory reset the card, including access and owner. Continue?", "Factory Reset", "No", "Yes") == "Yes" && CanUseTopic(user, state))
					age = initial(age)
					access = syndicate_access.Copy()
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
					religion = initial(religion)
					sex = initial(sex)
					employer_faction = initial(employer_faction)
					to_chat(user, "<span class='notice'>All information has been deleted from \the [src].</span>")
					. = 1

	// Always update the UI, or buttons will spin indefinitely
	SSnanoui.update_uis(src)

/var/global/list/id_card_states
/proc/id_card_states()
	if(!id_card_states)
		id_card_states = list()
		for(var/path in typesof(/obj/item/card/id))
			var/obj/item/card/id/ID = path
			var/datum/card_state/CS = new()
			CS.icon_state = initial(ID.icon_state)
			CS.item_state = initial(ID.item_state)
			CS.name = initial(ID.name) + " - " + initial(ID.icon_state)
			id_card_states += CS
		sortTim(id_card_states, /proc/cmp_cardstate, FALSE)

	return id_card_states

/datum/card_state
	var/name
	var/icon_state
	var/item_state

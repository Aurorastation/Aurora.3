/obj/machinery/computer/sentencing
	name = "criminal sentencing console"
	desc = "Used to generate a criminal sentence."
	icon_state = "computerw"
	icon_screen = "securityw"
	light_color = LIGHT_COLOR_ORANGE
	req_one_access = list( access_brig, access_heads )
	circuit = "/obj/item/circuitboard/sentencing"
	density = 0

	var/datum/crime_incident/incident
	var/menu_screen = "main_menu"

	var/datum/browser/menu = new( null, "crim_sentence", "Criminal Sentencing", 710, 725 )
	var/console_tag

/obj/machinery/computer/sentencing/New()
	..()

	if( console_tag )
		tag = console_tag

/obj/machinery/computer/sentencing/attack_hand(mob/user as mob)
	if(..())
		return
	if(stat & (NOPOWER|BROKEN))
		return
	ui_interact(user)

/obj/machinery/computer/sentencing/attackby(obj/item/O as obj, user as mob)
	if( istype( O, /obj/item/paper/incident ) && menu_screen == "import_incident" )
		usr.drop_from_inventory(O,src)

		if( import( O ))
			ping( "\The [src] pings, \"Successfully imported incident report!\"" )
			menu_screen = "incident_report"
		else
			to_chat(user, "<span class='alert'>Could not import incident report.</span>")

		qdel( O )
	else if( istype( O, /obj/item/paper ) && menu_screen == "import_incident" )
		to_chat(user, "<span class='alert'>This console only accepts authentic incident reports. Copies are invalid.</span>")

	..()

/obj/machinery/computer/sentencing/proc/import( var/obj/item/paper/incident/I )
	incident = null

	if( istype( I ) && I.incident )
		incident = I.incident

	return incident

/obj/machinery/computer/sentencing/ui_interact( mob/user as mob )
	. = ""

	switch( menu_screen )
		if( "import_incident" )
			. += import_incident()
		if( "incident_report" )
			. += incident_report()
		/*if( "process_judiciary_report" )
			. += process_judiciary_report()*/
		if( "low_severity" )
			. += add_charges()
		if( "med_severity" )
			. += add_charges()
		if( "high_severity" )
			. += add_charges()
		else
			. += main_menu()

	menu.set_user( user )
	menu.set_content( . )
	menu.open()

	onclose(user, "crim_sentence")

	return

/obj/machinery/computer/sentencing/proc/main_menu()
	. = "<center><h2>Welcome! Please select an option!</h2><br>"
	. += "<a href='?src=\ref[src];button=import_incident'>Import Incident</a>   <a href='?src=\ref[src];button=new_incident'>New Report</a></center>"

	return .

/obj/machinery/computer/sentencing/proc/import_incident()
	. = "<center><h2>Incident Import</h2><br>"
	. += "Insert an existing Securty Incident Report paper."

	. += "<br><hr>"
	. += "<a href='?src=\ref[src];button=change_menu;choice=main_menu'>Cancel</a></center>"

	return .

/obj/machinery/computer/sentencing/proc/incident_report()
	. = ""
	if( !istype( incident ))
		. += "There was an error loading the incident, please <a href='?src=\ref[src];button=change_menu;choice=main_menu'>Try Again</a>"
		return .

	// Criminal and sentence
	. += "<table class='border'>"
	. += "<tr>"
	. += "<th>Convict:</th>"
	. += "<td><a href='?src=\ref[src];button=change_criminal;'>"
	if( istype(incident.card) )
		var/obj/item/card/id/card = incident.card.resolve()
		. += "[card]"
	else
		. += "None"
	. += "</a></td>"
	. += "</tr>"

	. += "<tr>"
	. += "<th>Brig Sentence:</th>"
	. += "<td><a href='?src=\ref[src];button=change_brig;'>"
	if( incident.brig_sentence )
		if( incident.brig_sentence < PERMABRIG_SENTENCE )
			. += "[incident.brig_sentence] MINUTES"
		else
			. += "HOLDING UNTIL TRANSFER"
			// . += "</a></td>"
			//
			// . += "</tr><tr>"

	else
		. += "None"
	. += "</a></td>"

	. += "</tr>"
	. += "<tr>"
	. += "<th>Fine:</th>"
	. += "<td><a href='?src=\ref[src];button=change_fine;'>"
	if( incident.fine )
		. += "[incident.fine] Credits"
		// . += "</a></td>"
		//
		// . += "</tr><tr>"

	else
		. += "None"
	. += "</a></td>"
	. += "</tr>"

	. += "</table>"

	. += "<br>"

	. += list_witnesses()

	. += list_evidence()

	. += list_notes()

	. += "<br>"

	// Charges list
	. += list_charges( 1 )

	. += "<br><hr>"
	. += "<center>"
	. += "<a href='?src=\ref[src];button=render_guilty'>Render Guilty</a>"
	. += "<a href='?src=\ref[src];button=render_guilty_fine'>Render Guilty - Fine</a>"
	. += "</center>"

	return .

/obj/machinery/computer/sentencing/proc/list_charges( var/buttons = 0 )
	. += "<table class='border'>"
	. += "<tr>"
	if( buttons )
		. += "<th colspan='3'>Charges <a href='?src=\ref[src];button=change_menu;choice=low_severity'>Add</a></th>"
	else
		. += "<th colspan='2'>Charges</th>"
	. += "</tr>"
	for( var/datum/law/L in incident.charges )
		. += "<tr>"
		. += "<td><b>[L.name]</b></td>"
		. += "<td><i>[L.desc]</i></td>"
		if( buttons )
			. += "<td><a href='?src=\ref[src];button=remove_charge;law=\ref[L]'>Remove</a></td>"
		. += "</tr>"
	. += "</table>"

/obj/machinery/computer/sentencing/proc/list_sentence()
	. = ""

	. += "<table class='border'>"

	. += "<tr><th colspan='2'>Convict</th></tr>"
	. += "<tr><td colspan='2'><center>"
	if( istype(incident.card) )
		var/obj/item/card/id/card = incident.card.resolve()
		. += "[card]"
	else
		. += "None"
	. += "</center></td></tr>"

	. += "<tr>"
	. += "<th colspan='2'>Sentence</th>"
	. += "</tr><tr>"
	. += "<td>Brig</td>"
	. += "<td>"
	if( incident.brig_sentence )
		if( incident.brig_sentence < PERMABRIG_SENTENCE )
			. += "[incident.brig_sentence] MINUTES"
		else
			. += "HOLDING UNTIL TRANSFER"
	else
		. += "None"
	. += "</td>"

	. += "</tr><tr>"

	. += "</table>"

	return .

/obj/machinery/computer/sentencing/proc/list_witnesses()
	. = ""

	var/list/witnesses = incident.arbiters["Witness"]

	. += "<table class='border'>"
	. += "<tr>"
	. += "<th>Witnesses <a href='?src=\ref[src];button=add_arbiter;title=Witness'>Add</a></th>"
	. += "</tr>"

	for( var/witness in witnesses )
		. += "<tr>"

		if( witnesses[witness] )
			. += "<td>"
			. += "[witness]: "
			. += "</td><td>"
			. += "<i>[witnesses[witness]]</i>"
		else
			. += "<td colspan='2'>"
			. += "[witness]"

		. += "</td><td>"
		. += "<a href='?src=\ref[src];button=add_witness_notes;choice=\ref[witness]'>Notes</a><br>"
		. += "<a href='?src=\ref[src];button=remove_witness;choice=\ref[witness]'>Remove</a>"
		. += "</td></tr>"

	. += "</table>"

	return .

/obj/machinery/computer/sentencing/proc/list_evidence()
	. = ""

	var/list/evidence = incident.evidence

	. += "<table class='border'>"
	. += "<tr>"
	. += "<th>Evidence<a href='?src=\ref[src];button=add_evidence'>Add</a></th>"
	. += "</tr>"

	for( var/item in evidence )
		. += "<tr>"

		if( evidence[item] )
			. += "<td>"
			. += "[item]: "
			. += "</td><td>"
			. += "<i>[evidence[item]]</i>"
		else
			. += "<td colspan='2'>"
			. += "[item]"

		. += "</td><td>"
		. += "<a href='?src=\ref[src];button=add_evidence_notes;choice=\ref[item]'>Notes</a><br>"
		. += "<a href='?src=\ref[src];button=remove_evidence;choice=\ref[item]'>Remove</a>"
		. += "</td></tr>"

	. += "</table>"

	return .

/obj/machinery/computer/sentencing/proc/list_notes()
	. = ""

	// Incident notes table
	. += "<table class='border'>"
	. += "<tr>"
	. += "<th>Incident Summary <a href='?src=\ref[src];button=add_notes'>Change</a></th>"
	. += "</tr>"
	if( incident.notes )
		. += "<tr>"
		. += "<td><i>[incident.notes]</i></td>"
		. += "</tr>"
	. += "</table>"

	return .

/obj/machinery/computer/sentencing/proc/add_charges()
	. = ""

	if( !istype( incident ))
		. += "There was an error loading the incident, please <a href='?src=\ref[src];button=change_menu;choice=main_menu'>Try Again</a>"
		return .

	if( !istype( SSlaw ))
		. += "There was an error loading corporate regulations, please <a href='?src=\ref[src];button=change_menu;choice=main_menu'>Try Again</a>"
		return .

	. += charges_header()
	. += "<hr>"
	switch( menu_screen )
		if( "low_severity" )
			. += low_severity()
		if( "med_severity" )
			. += med_severity()
		if( "high_severity" )
			. += high_severity()

	. += "<br><hr>"
	. += "<center><a href='?src=\ref[src];button=change_menu;choice=incident_report'>Return</a></center>"

/obj/machinery/computer/sentencing/proc/charges_header()
	. = "<center>"

	if( menu_screen == "low_severity" )
		. += "Low Severity"
	else
		. += "<a href='?src=\ref[src];button=change_menu;choice=low_severity'>Low Severity</a>"

	. += " - "

	if( menu_screen == "med_severity" )
		. += "Medium Severity"
	else
		. += "<a href='?src=\ref[src];button=change_menu;choice=med_severity'>Medium Severity</a>"

	. += " - "

	if( menu_screen == "high_severity" )
		. += "High Severity"
	else
		. += "<a href='?src=\ref[src];button=change_menu;choice=high_severity'>High Severity</a>"

	. += " - <a href='?src=\ref[src];button=change_menu;choice=incident_report'>Return</a>"
	. += "</center>"

	return .

/obj/machinery/computer/sentencing/proc/low_severity()
	. = ""

	// Low severity
	. += "<table class='border'>"
	. += "<tr>"
	. += "<th colspan='5'>Misdemeanors</th>"
	. += "</tr>"

	. += "<tr>"
	. += "<th>Name</th>"
	. += "<th>Description</th>"
	. += "<th>Brig Sentence</th>"
	. += "<th>Fine</th>"
	. += "<th>Button</th>"
	. += "</tr>"

	for( var/datum/law/L in SSlaw.low_severity )
		. += "<tr>"
		. += "<td><b>[L.name]</b></td>"
		. += "<td><i>[L.desc]</i></td>"
		. += "<td>[L.get_brig_time_string()]</td>"
		. += "<td>[L.get_fine_string()]</td>"
		. += "<td><a href='?src=\ref[src];button=add_charge;law=\ref[L]'>Charge</a></td>"
		. += "</tr>"

	. += "</table>"

	return .

/obj/machinery/computer/sentencing/proc/med_severity()
	. = ""

	// Med severity
	. += "<table class='border'>"
	. += "<tr>"
	. += "<th colspan='5'>Indictable Offences</th>"
	. += "</tr>"

	. += "<tr>"
	. += "<th>Name</th>"
	. += "<th>Description</th>"
	. += "<th>Brig Sentence</th>"
	. += "<th>Fine</th>"
	. += "<th>Button</th>"
	. += "</tr>"

	for( var/datum/law/L in SSlaw.med_severity )
		. += "<tr>"
		. += "<td><b>[L.name]</b></td>"
		. += "<td><i>[L.desc]</i></td>"
		. += "<td>[L.get_brig_time_string()]</td>"
		. += "<td>[L.get_fine_string()]</td>"
		. += "<td><a href='?src=\ref[src];button=add_charge;law=\ref[L]'>Charge</a></td>"
		. += "</tr>"

	. += "</table>"

	return .

/obj/machinery/computer/sentencing/proc/high_severity()
	. = ""

	// High severity
	. += "<table class='border'>"
	. += "<tr>"
	. += "<th colspan='5'>Capital Offences</th>"
	. += "</tr>"

	. += "<tr>"
	. += "<th>Name</th>"
	. += "<th>Description</th>"
	. += "<th>Brig Sentence</th>"
	. += "<th>Button</th>"
	. += "</tr>"

	for( var/datum/law/L in SSlaw.high_severity )
		. += "<tr>"
		. += "<td><b>[L.name]</b></td>"
		. += "<td><i>[L.desc]</i></td>"
		. += "<td>[L.get_brig_time_string()]</td>"
		. += "<td><a href='?src=\ref[src];button=add_charge;law=\ref[L]'>Charge</a></td>"
		. += "</tr>"

	. += "</table>"

	return .

/obj/machinery/computer/sentencing/proc/render_innocent( var/mob/user )
	var/obj/item/card/id/card = incident.card.resolve()
	ping( "\The [src] pings, \"[card] has been found innocent of the accused crimes!\"" )

	qdel( incident )
	incident = null
	menu_screen = "main_menu"

/obj/machinery/computer/sentencing/proc/render_guilty( var/mob/living/user )
	if( !incident )
		to_chat(user, "<span class='alert'>There is no active case!</span>")
		return

	if( !istype( user ))
		return

	var/error = print_incident_report()

	if( error )
		to_chat(user, "<span class='alert'>[error]</span>")
		return

	print_incident_overview(incident.renderGuilty(user, 0))
	var/obj/item/card/id/card = incident.card.resolve()
	if( incident.brig_sentence < PERMABRIG_SENTENCE)
		ping( "\The [src] pings, \"[card.registered_name] has been found guilty of their crimes!\"" )
	else
		pingx3( "\The [src] pings, \"[card.registered_name] has been found guilty of their crimes and earned a HuT Sentence\"" )

	incident = null
	menu_screen = "main_menu"

/obj/machinery/computer/sentencing/proc/render_guilty_fine( var/mob/living/user )
	if(!incident)
		to_chat(user, "<span class='alert'>There is no active case!</span>")
		return

	if(!istype(user))
		return

	if(incident.fine <= 0)
		buzz("\The [src] buzzes, \"No fine has been entered!\"")
		return

	//Lets check if there is a felony amongst the crimes
	for(var/datum/law/L in incident.charges)
		if(L.felony)
			buzz("\The [src] buzzes, \"The crimes are too severe to apply a fine!\"")
		if(!L.can_fine())
			buzz("\The [src] buzzes, \"It is not possible to fine for [L.name]\"")
			return

	//Try to resole the security account first
	var/datum/money_account/security_account = SSeconomy.get_department_account("Security")
	if(!security_account)
		buzz("\The [src] buzzes, \"Could not get security account!\"")
		return

	var/obj/item/card/id/card = incident.card.resolve()
	//Let´s get the account of the suspect and verify they have enough money
	var/datum/money_account/suspect_account = SSeconomy.get_account(card.associated_account_number)
	if(!suspect_account)
		buzz("\The [src] buzzes, \"Could not get suspect account!\"")
		return

	if(suspect_account.money < incident.fine)
		buzz("\The [src] buzzes, \"There is not enough money in the account to pay the fine!\"")
		return

	SSeconomy.charge_to_account(suspect_account.account_number,security_account.owner_name,"Incident: [incident.UID]","Sentencing Console",-incident.fine)
	SSeconomy.charge_to_account(security_account.account_number,suspect_account.owner_name,"Incident: [incident.UID]Fine","Sentencing Console",incident.fine)
	print_incident_overview(incident.renderGuilty(user,1))

	ping("\The [src] pings, \"[card.registered_name] has been fined for their crimes!\"")

	incident = null
	menu_screen = "main_menu"

/obj/machinery/computer/sentencing/proc/print_incident_overview(var/text)
	var/obj/item/paper/P = new /obj/item/paper
	P.set_content_unsafe("Incident Summary",text)
	print(P)

/obj/machinery/computer/sentencing/proc/print_incident_report( var/sentence = 1 )
	var/error = incident.missingSentenceReq()

	if( error )
		return error

	if( printing )
		return "The machine is already printing something!"

	var/obj/item/paper/incident/I = new /obj/item/paper/incident
	I.incident = incident
	I.sentence = sentence
	I.name = "Encoded Incident Report"
	print( I )

	return 0

/obj/machinery/computer/sentencing/Topic(href, href_list)
	if(..())
		return

	if(stat & (NOPOWER|BROKEN))
		return 0 // don't update UIs attached to this object

	usr.set_machine(src)

	switch(href_list["button"])
		if( "import_incident" )
			menu_screen = "import_incident"
		if( "new_incident" )
			incident = new()

			menu_screen = "incident_report"
		if( "change_menu" )
			menu_screen = href_list["choice"]
		if( "change_criminal" )
			var/obj/item/card/id/C = usr.get_active_hand()
			if( istype( C ))
				if( incident && C.mob )
					incident.criminal = C.mob
					incident.card = WEAKREF(C)
					ping( "\The [src] pings, \"Convict [C] verified.\"" )
			else if( incident.criminal )
				ping( "\The [src] pings, \"Convict cleared.\"" )
				incident.criminal = null
				incident.card = null
		if( "change_brig" )
			if( !incident )
				return
			var/number = input( usr, "Enter a number between [incident.getMinBrigSentence()] and [incident.getMaxBrigSentence()] minutes", "Brig Sentence", 0) as num
			if( number < incident.getMinBrigSentence() )
				to_chat(usr, "<span class='alert'>The entered sentence was less than the minimum sentence!</span>")
			else if( number > incident.getMaxBrigSentence() )
				to_chat(usr, "<span class='alert'>The entered sentence was greater than the maximum sentence!</span>")
			else
				incident.brig_sentence = number

		if( "change_fine" )
			if( !incident )
				return
			var/number = input( usr, "Enter a number between [incident.getMinFine()] and [incident.getMaxFine()] credits", "Fine", 0) as num
			if( number < incident.getMinFine() )
				to_chat(usr, "<span class='alert'>The entered sentence was less than the minimum sentence!</span>")
			else if( number > incident.getMaxFine() )
				to_chat(usr, "<span class='alert'>The entered sentence was greater than the maximum sentence!</span>")
			else
				incident.fine = number

		if( "print_encoded_form" )
			var/error = print_incident_report( 0 )

			if( error )
				to_chat(usr, "<span class='alert'>[error]</span>")
			else
				incident = null
				menu_screen = "main_menu"

		if( "add_arbiter" )
			var/title = href_list["title"]
			var/obj/item/card/id/C = usr.get_active_hand()
			if( istype( C ))
				if( incident && C.mob )
					var/error = incident.addArbiter( C, title )
					if( !error )
						ping( "\The [src] pings, \"[title] [C.mob] verified.\"" )
					else
						to_chat(usr, "<span class='alert'>\The [src] buzzes, \"[error]\"</span>")
			else
				ping( "\The [src] pings, \"[title] cleared.\"" )
				incident.arbiters[title] = null

		if( "add_evidence" )
			var/obj/O = usr.get_active_hand()

			if( istype( O ))
				var/list/L = incident.evidence
				L += O
				incident.evidence = L
		if( "add_charge" )
			incident.charges += locate( href_list["law"] )
			incident.refreshSentences()
			ping( "\The [src] pings, \"Successfully added charge\"" )
		if( "remove_charge" )
			incident.charges -= locate( href_list["law"] )
			incident.refreshSentences()
			ping( "\The [src] pings, \"Successfully removed charge\"" )
		if( "remove_witness" )
			var/list/L = incident.arbiters["Witness"]
			L -= locate( href_list["choice"] )
			incident.arbiters["Witness"] = L
		if( "remove_evidence" )
			var/list/L = incident.evidence
			L -= locate( href_list["choice"] )
			incident.evidence = L
		if( "add_witness_notes" )
			var/list/L = incident.arbiters["Witness"]
			var/W = locate( href_list["choice"] )

			var/notes  = sanitize( input( usr,"Summarize what the witness said:","Witness Report", html_decode( L[W] )) as message, MAX_PAPER_MESSAGE_LEN, extra = 0)
			if( notes != null )
				L[W] = notes

			incident.arbiters["Witness"] = L
		if( "add_evidence_notes" )
			var/list/L = incident.evidence
			var/E = locate( href_list["choice"] )

			var/notes  = sanitize( input( usr,"Describe the relevance of this evidence:","Evidence Report", html_decode( L[E] )) as message, MAX_PAPER_MESSAGE_LEN, extra = 0)
			if( notes != null )
				L[E] = notes

			incident.evidence = L
		if( "add_notes" )
			if( !incident )
				return

			var/incident_notes  = sanitize( input( usr,"Describe the incident here:","Incident Report", html_decode( incident.notes )) as message, MAX_PAPER_MESSAGE_LEN, extra = 0)
			if( incident_notes != null )
				incident.notes = incident_notes
		if( "render_guilty" )
			if( !incident )
				return
			if( !incident.notes )
				if( alert("No incident notes were added. Adding a short description of the incident is highly recommended. Do you still want to continue with the print?",,"Yes","No") == "No" )
					return
			render_guilty( usr )
		if( "render_guilty_fine" )
			//Check for the notes
			if( !incident.notes )
				if( alert("No incident notes were added. Adding a short description of the incident is highly recommended. Do you still want to continue with the print?",,"Yes","No") == "No" )
					return
			//Get the ID Card
			render_guilty_fine( usr )

	add_fingerprint(usr)
	updateUsrDialog()

/obj/machinery/computer/sentencing/courtroom
	console_tag = "sentencing_courtroom"

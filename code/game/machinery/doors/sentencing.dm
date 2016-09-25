/obj/machinery/computer/sentencing
	name = "criminal sentencing console"
	desc = "Used to generate a criminal sentence."
	icon_state = "sentence"
	req_one_access = list( access_brig, access_heads )
	circuit = "/obj/item/weapon/circuitboard/sentencing"

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
	if( istype( O, /obj/item/weapon/paper/form/incident ) && menu_screen == "import_incident" )
		usr.drop_item()
		O.loc = src

		if( import( O ))
			ping( "\The [src] pings, \"Successfully imported incident report!\"" )
			menu_screen = "incident_report"
		else
			user << "<span class='alert'>Could not import incident report.</span>"

		qdel( O )
	else if( istype( O, /obj/item/weapon/paper ) && menu_screen == "import_incident" )
		user << "<span class='alert'>This console only accepts authentic incident reports. Copies are invalid.</span>"

	..()

/obj/machinery/computer/sentencing/proc/import( var/obj/item/weapon/paper/form/incident/I )
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
		if( "process_judiciary_report" )
			. += process_judiciary_report()
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
	. += "<th>Defendant:</th>"
	. += "<td><a href='?src=\ref[src];button=change_criminal;'>"
	if( incident.criminal )
		. += "[incident.criminal]"
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
			. += "</a></td>"

			. += "</tr><tr>"

			. += "<th>Prison Sentence:</th>"
			. += "<td><a href='?src=\ref[src];button=change_prison;'>"
			if( incident.prison_sentence )
				if( incident.prison_sentence < PERMAPRISON_SENTENCE )
					. += "[incident.prison_sentence] DAYS"
				else
					. += "LIFE SENTENCE"
			else
				. += "None"
	else
		. += "None"
	. += "</a></td>"
	. += "</tr>"

	. += "</table>"

	. += "<br>"

	. += list_notes()

	. += "<br>"

	// Charges list
	. += list_charges( 1 )

	. += "<br><hr>"
	. += "<center>"
	if( incident.getMaxSeverity() <= 1.0 )
		. += "<a href='?src=\ref[src];button=render_guilty'>Render Guilty</a>"
	else
		. += "<a href='?src=\ref[src];button=begin_process'>Begin [incident.getCourtType()]</a>"

	. += " <a href='?src=\ref[src];button=print_encoded_form'>Export Incident</a> "
	. += "<a href='?src=\ref[src];button=change_menu;choice=main_menu'>Cancel</a></center>"

	return .

/obj/machinery/computer/sentencing/proc/process_judiciary_report()
	. = ""

	. += "<table><tr><td valign='top'>"

	. += list_sentence()

	. += "</td><td valign='top'>"

	. += list_judges()

	. += "</td></tr><tr><td valign='top' colspan='2'>"

	. += list_charges()

	. += "</td></tr><tr><td valign='top' colspan='2'>"

	. += list_notes()

	. += "</td></tr><tr><td valign='top' colspan='2'>"

	. += list_witnesses()

	. += "</td></tr><tr><td valign='top' colspan='2'>"

	. += list_evidence()

	. += "</td></tr></table>"

	. += "<br><hr>"
	. += "<center>"
	. += "<a href='?src=\ref[src];button=verdict'>Render Verdict</a>"
	. += "<a href='?src=\ref[src];button=change_menu;choice=incident_report'>Cancel Court</a></center>"

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

/obj/machinery/computer/sentencing/proc/list_judges()
	. = ""

	var/severity = incident.getMaxSeverity()

	. += "<table class='border'>"
	. += "<tr><th colspan='2'>Judges</th></tr>"
	. += "<tr>"

	. += "<td><b>Chief Justice:</b></td>"
	. += "<td><a href='?src=\ref[src];button=add_arbiter;title=Chief Justice'>"

	if( incident.arbiters["Chief Justice"] )
		. += "[incident.arbiters["Chief Justice"]]"
	else
		. += "None"

	. += "</a></td></tr>"

	if( severity == 3.0 )
		. += "<tr>"

		. += "<td><b>Justice #1:</b></td>"
		. += "<td><a href='?src=\ref[src];button=add_arbiter;title=Justice #1'>"

		if( incident.arbiters["Justice #1"] )
			. += "[incident.arbiters["Justice #1"]]"
		else
			. += "None"

		. += "</a></td>"

		. += "</tr><tr>"

		. += "<td><b>Justice #2:</b></td>"
		. += "<td><a href='?src=\ref[src];button=add_arbiter;title=Justice #2'>"

		if( incident.arbiters["Justice #2"] )
			. += "[incident.arbiters["Justice #2"]]"
		else
			. += "None"

		. += "</a></td>"

		. += "</tr>"

	. += "</table>"

	return .

/obj/machinery/computer/sentencing/proc/list_sentence()
	. = ""

	. += "<table class='border'>"

	. += "<tr><th colspan='2'>Defendant</th></tr>"
	. += "<tr><td colspan='2'><center>"
	if( incident.criminal )
		. += "[incident.criminal]"
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

	. += "<td>Prison</td>"
	. += "<td>"
	if( incident.prison_sentence )
		if( incident.prison_sentence < PERMAPRISON_SENTENCE )
			. += "[incident.prison_sentence] DAYS"
		else
			. += "LIFE SENTENCE"
	else
		. += "None"
	. += "</td>"
	. += "</tr>"

	. += "</table>"

	return .

/obj/machinery/computer/sentencing/proc/list_witnesses()
	. = ""

	var/list/witnesses = incident.arbiters["Witness"]

	. += "<table class='border'>"
	. += "<th colspan='3'>Witnesses <a href='?src=\ref[src];button=add_arbiter;title=Witness'>Add</a></th>"

	for( var/witness in witnesses )
		. += "<tr>"

		if( witnesses[witness] )
			. += "<td>"
			. += "</b>[witness]</b>"
			. += "</td><td>"
			. += "<i>[witnesses[witness]]</i>"
		else
			. += "<td colspan='2'>"
			. += "<b>[witness]</b>"

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
	. += "<th colspan='3'>Evidence <a href='?src=\ref[src];button=add_evidence'>Add</a></th>"

	for( var/item in evidence )
		. += "<tr>"

		if( evidence[item] )
			. += "<td>"
			. += "<b>[item]</b>"
			. += "</td><td>"
			. += "<i>[evidence[item]]</i>"
		else
			. += "<td colspan='2'>"
			. += "<b>[item]</b>"

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

	if( !istype( corp_regs ))
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
//	. += "<th>Fine</th>"
	. += "<th>Button</th>"
	. += "</tr>"

	for( var/datum/law/L in corp_regs.low_severity )
		. += "<tr>"
		. += "<td><b>[L.name]</b></td>"
		. += "<td><i>[L.desc]</i></td>"
		. += "<td>[L.min_brig_time] - [L.max_brig_time] minutes</td>"
//		. += "<td>$[L.min_fine] - $[L.max_fine]</td>"
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
	. += "<th>Prison Sentence</th>"
//	. += "<th>Fine</th>"
	. += "<th>Button</th>"
	. += "</tr>"

	for( var/datum/law/L in corp_regs.med_severity )
		. += "<tr>"
		. += "<td><b>[L.name]</b></td>"
		. += "<td><i>[L.desc]</i></td>"
		. += "<td>[L.min_brig_time] - [L.max_brig_time] minutes</td>"
		. += "<td>[L.min_prison_time] - [L.max_prison_time] days</td>"
//		. += "<td>$[L.min_fine] - $[L.max_fine]</td>"
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
	. += "<th>Prison Sentence</th>"
	. += "<th>Button</th>"
	. += "</tr>"

	for( var/datum/law/L in corp_regs.high_severity )
		. += "<tr>"
		. += "<td><b>[L.name]</b></td>"
		. += "<td><i>[L.desc]</i></td>"
		. += "<td>[L.min_brig_time] - [L.max_brig_time] minutes</td>"
		. += "<td>[L.min_prison_time] - [L.max_prison_time] days</td>"
		. += "<td><a href='?src=\ref[src];button=add_charge;law=\ref[L]'>Charge</a></td>"
		. += "</tr>"

	. += "</table>"

	return .

/obj/machinery/computer/sentencing/proc/render_verdict( var/mob/living/user )
	if( menu_screen != "process_judiciary_report" )
		user << "<span class='alert'>The trial is not in session!</span>"
		return

	if( !istype( user ) || incident.arbiters["Chief Justice"] != user )
		user << "<span class='alert'>You are not the Chief Justice!</span>"
		return

	if( incident.getMaxSeverity() >= 3.0 && ( !incident.arbiters["Justice #1"] || !incident.arbiters["Justice #2"] ))
		user << "<span class='alert'>Theres not enough judges to reach a verdict!</span>"
		return

	var/verdict = alert( user, "What was decided as the verdict?",,"Guilty","Innocent", "Cancel" )
	switch( verdict )
		if( "Cancel" )
			return
		if( "Guilty" )
			render_guilty( usr )
		if( "Innocent" )
			render_innocent( usr )

/obj/machinery/computer/sentencing/proc/render_innocent( var/mob/user )
	ping( "\The [src] pings, \"[incident.criminal] has been found innocent of the accused crimes!\"" )

	qdel( incident )
	incident = null
	menu_screen = "main_menu"

/obj/machinery/computer/sentencing/proc/render_guilty( var/mob/living/user )
	if( !incident )
		user << "<span class='alert'>There is no active case!</span>"
		return

	if( !istype( user ))
		return

	if( incident.getMaxSeverity() >= 2.0 && incident.arbiters["Chief Justice"] != user )
		user << "<span class='alert'>You are not the Chief Justice!</span>"
		return

	var/error = print_incident_report()

	if( error )
		user << "<span class='alert'>[error]</span>"
		return

	incident.renderGuilty( user )

	ping( "\The [src] pings, \"[incident.criminal] has been found guilty of their crimes!\"" )

	incident = null
	menu_screen = "main_menu"

/obj/machinery/computer/sentencing/proc/print_incident_report( var/sentence = 1 )
	var/error = incident.missingSentenceReq()

	if( error )
		return error

	if( printing )
		return "The machine is already printing something!"

	var/obj/item/weapon/paper/form/incident/I = new /obj/item/weapon/paper/form/incident
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
			var/obj/item/weapon/card/id/C = usr.get_active_hand()
			if( istype( C ))
				if( incident && C.mob )
					incident.criminal = C.mob
					ping( "\The [src] pings, \"Defendant [C.mob] verified.\"" )
			else if( incident.criminal )
				ping( "\The [src] pings, \"Defendant cleared.\"" )
				incident.criminal = null
		if( "change_brig" )
			if( !incident )
				return

			var/number = input( usr, "Enter a number between [incident.getMinBrigSentence()] and [incident.getMaxBrigSentence()] minutes", "Brig Sentence", 0) as num
			if( number < incident.getMinBrigSentence() )
				usr << "<span class='alert'>The entered sentence was less than the minimum sentence!</span>"
			else if( number > incident.getMaxBrigSentence() )
				usr << "<span class='alert'>The entered sentence was greater than the maximum sentence!</span>"
			else
				incident.brig_sentence = number

		if( "change_prison" )
			if( !incident )
				return

			var/number = input( usr, "Enter a number between [incident.getMinPrisonSentence()] and [incident.getMaxPrisonSentence()] days", "Prison Sentence", 0) as num
			if( number < incident.getMinPrisonSentence() )
				usr << "<span class='alert'>The entered sentence was less than the minimum sentence!</span>"
			else if( number > incident.getMaxPrisonSentence() )
				usr << "<span class='alert'>The entered sentence was greater than the maximum sentence!</span>"
			else
				incident.prison_sentence = number
		if( "print_encoded_form" )
			var/error = print_incident_report( 0 )

			if( error )
				usr << "<span class='alert'>[error]</span>"
			else
				incident = null
				menu_screen = "main_menu"
		if( "begin_process" )
			var/severity = incident.getMaxSeverity()
			var/error

			if( severity == 2.0 )
				error = incident.missingCourtReq()
			else if( severity == 3.0 )
				error = incident.missingTribunalReq()
			else
				error = "Selected crimes do not require a tribunal!"

			if( !error )
				menu_screen = "process_judiciary_report"
				ping( "\The [src] pings, \"Beginning [incident.getCourtType()] proceedings!\"" )
			else
				usr << "<span class='alert'>[error]</span>"
		if( "add_arbiter" )
			var/title = href_list["title"]
			var/obj/item/weapon/card/id/C = usr.get_active_hand()
			if( istype( C ))
				if( incident && C.mob )
					var/error = incident.addArbiter( C, title )
					if( !error )
						ping( "\The [src] pings, \"[title] [C.mob] verified.\"" )
					else
						usr << "<span class='alert'>[error]</span>"
			else if( incident.arbiters[title] )
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
		if( "remove_charge" )
			incident.charges -= locate( href_list["law"] )
			incident.refreshSentences()
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
			if( !incident.notes )
				if( alert("No incident notes were added. Adding a short description of the incident is highly recommended. Do you still want to continue with the print?",,"Yes","No") == "No" )
					return

			render_guilty( usr )
		if( "verdict" )
			if( !incident.notes )
				if( alert("No incident notes were added. Adding a short description of the incident is highly recommended. Do you still want to continue with the print?",,"Yes","No") == "No" )
					return

			render_verdict( usr )

	add_fingerprint(usr)
	updateUsrDialog()

/obj/machinery/computer/sentencing/wall
	name = "criminal sentencing wall console"
	icon_state = "sentencew"
	density = 0

/obj/machinery/computer/sentencing/wall/courtroom
	console_tag = "sentencing_courtroom"

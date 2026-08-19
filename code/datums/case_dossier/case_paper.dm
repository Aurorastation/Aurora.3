/datum/investigation_case/proc/paper_escape(var/value)
	if(!value)
		return "N/A"

	var/text = trim("[value]")
	if(!length(text))
		return "N/A"

	text = html_encode(text)

	text = replacetext(text, "\[", "&#91;")
	text = replacetext(text, "\]", "&#93;")

	text = replacetext(text, ascii2text(13) + ascii2text(10), "\[br\]")
	text = replacetext(text, ascii2text(13), "\[br\]")
	text = replacetext(text, ascii2text(10), "\[br\]")

	return text

/datum/investigation_case/proc/paper_bullet(var/value)
	return "\[*\] [paper_escape(value)]"

/datum/investigation_case/proc/printable_person(var/datum/investigation_person/person, var/fallback_role)
	var/list/parts = list()

	parts += person.role || fallback_role
	parts += person.name || "Unnamed"

	if(person.notes)
		parts += person.notes

	return paper_bullet(jointext(parts, " - "))

/datum/investigation_case/proc/printable_people()
	var/list/out = list()

	for(var/datum/investigation_person/person in victims)
		out += printable_person(person, "Victim")

	for(var/datum/investigation_person/person in suspects)
		out += printable_person(person, "Suspect")

	for(var/datum/investigation_person/person in witnesses)
		out += printable_person(person, "Witness")

	if(!length(out))
		out += paper_bullet("None recorded")

	return jointext(out, "\n")

/datum/investigation_case/proc/printable_attached_documents()
	var/list/out = list()

	for(var/datum/case_dossier_report/report in report_refs)
		out += paper_bullet("[report.id || "Unindexed"] - [report.title || "Untitled paperwork"]")

	for(var/datum/evidence_item/photo/photo in photo_refs)
		out += paper_bullet("[photo.id || "Unindexed"] - [photo.label || "Untitled photograph"]")

	if(!length(out))
		out += paper_bullet("None recorded")

	return jointext(out, "\n")

/datum/investigation_case/proc/printable_evidence_item(var/datum/evidence_item/item)
	var/id = paper_escape(item.id || "Unindexed")
	var/name = paper_escape(item.label || "Unnamed evidence")
	var/type = paper_escape(item.evidence_type || "Unspecified")
	var/location = paper_escape(item.location || "Unspecified")

	return "\[*\] \[b\][id]\[/b\] - [name] - \[b\]Type:\[/b\] [type] - \[b\]Location:\[/b\] [location]"

/datum/investigation_case/proc/printable_evidence()
	var/list/out = list()

	for(var/datum/evidence_item/item in evidence_refs)
		out += printable_evidence_item(item)

	for(var/datum/evidence_item/photo/photo in photo_refs)
		out += printable_evidence_item(photo)

	if(!length(out))
		out += paper_bullet("None recorded")

	return jointext(out, "\n")

/datum/investigation_case/proc/print_case_paper(var/mob/user, var/paper_name, var/text)
	if(!user)
		return FALSE

	var/obj/item/paper/P = new(get_turf(user))
	P.set_content(paper_name, text, FALSE)
	user.put_in_any_hand_if_possible(P)

	to_chat(user, SPAN_NOTICE("You print [paper_name]."))
	return TRUE

/datum/investigation_case/proc/print_summary(var/mob/user)
	var/list/narrative = list()
	narrative += paper_bullet(summary || "No narrative recorded.")

	if(timeline)
		narrative += paper_bullet("Timeline:")
		narrative += "\[list\]"
		narrative += print_multiline_list(timeline)
		narrative += "\[/list\]"

	var/list/conclusion = list()
	conclusion += paper_bullet(findings || "No findings recorded.")

	var/list/notes = list()
	notes += paper_bullet("Status: [status]")
	notes += paper_bullet("Created by: [created_by || "Unknown"]")
	notes += paper_bullet("Created at: [created_at || "Unknown"]")
	notes += paper_bullet("Last updated: [updated_at || "Unknown"]")

	if(length(tags))
		notes += paper_bullet("Tags: [jointext(tags, ", ")]")

	var/report = {"
\[table\]\[cell\]\[hr\]\[small\]\[center\]\[logo_scc\]\[br\]\[b\]Stellar Corporate Conglomerate
SCCV Horizon\[/b\]\[hr\]\[b\]Form 0205
\[large\]Case Report\[/large\]\[/b\]\[/center\]\[hr\]\[b\]Date:\[/b\] \[date\]
\[b\]Index:\[/b\] \[field\]

\[b\]Case Number:\[/b\] [paper_escape(case_id)]
\[b\]Attached Documents:\[/b\]\[list\]
[printable_attached_documents()]
\[/list\]\[hr\]\[b\]Involved Personnel:\[/b\]\[list\]
[printable_people()]
\[/list\]\[b\]Narrative:\[/b\]\[list\]
[jointext(narrative, "\n")]
\[/list\]\[b\]Conclusion:\[/b\]\[list\]
[jointext(conclusion, "\n")]
\[/list\]\[b\]Additional Notes:\[/b\]\[list\]
[jointext(notes, "\n")]
\[/list\]\[hr\]\[b\]Time Printed:\[/b\] [paper_escape(worldtime2text())]
\[b\]Investigative Personnel:\[/b\] [paper_escape(investigator || user.real_name)]
\[b\]Relevant Signatures:\[/b\]
\[field\]\[hr\]\[/table\]"}

	return print_case_paper(user, "SCCF-0205 - Case Report ([case_id])", report)

/datum/investigation_case/proc/print_evidence_log(var/mob/user)
	var/manifest = {"
\[table\]\[cell\]\[hr\]\[small\]\[center\]\[logo_scc\]\[br\]\[b\]Stellar Corporate Conglomerate
SCCV Horizon\[/b\]\[hr\]\[b\]Form 0211
\[large\]Evidence Manifest\[/large\]\[/b\]\[/center\]\[hr\]\[b\]Date:\[/b\] \[date\]
\[b\]Index:\[/b\] \[field\]

\[b\]Case Number:\[/b\] [paper_escape(case_id)]
\[b\]Attached Documents:\[/b\]\[list\]
[printable_attached_documents()]
\[/list\]\[hr\]\[b\]Evidence:\[/b\]\[list\]
[printable_evidence()]
\[/list\]\[hr\]\[b\]Investigative Personnel:\[/b\] [paper_escape(investigator || user.real_name)]
\[b\]Relevant Signatures:\[/b\] \[field\]\[hr\]\[/table\]"}

	return print_case_paper(user, "SCCF-0211 - Evidence Manifest ([case_id])", manifest)

/datum/investigation_case/proc/print_multiline_list(var/value, var/fallback = "None recorded")
	if(!value)
		return paper_bullet(fallback)

	var/text = trim("[value]")
	if(!length(text))
		return paper_bullet(fallback)

	var/list/out = list()
	var/list/lines = splittext(text, ascii2text(10))

	for(var/line in lines)
		line = trim(line)

		if(!length(line))
			continue

		out += paper_bullet(line)

	if(!length(out))
		return paper_bullet(fallback)

	return jointext(out, "\n")

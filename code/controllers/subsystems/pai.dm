/var/datum/controller/subsystem/pai/SSpai

/datum/controller/subsystem/pai
	name = "pAI"
	init_order = SS_INIT_MISC_FIRST
	flags = SS_NO_FIRE

	var/list/pai_software_by_key
	var/list/default_pai_software

	var/inquirer = null
	var/list/pai_candidates = list()
	var/list/asked = list()
	var/list/all_pai_devices = list()

	var/askDelay = 1 MINUTE

/datum/controller/subsystem/pai/New()
	NEW_SS_GLOBAL(SSpai)
	LAZYINITLIST(pai_software_by_key)
	LAZYINITLIST(default_pai_software)

/datum/controller/subsystem/pai/Recover()
	pai_software_by_key = SSpai.pai_software_by_key
	default_pai_software = SSpai.default_pai_software

/datum/controller/subsystem/pai/Topic(href, list/href_list)
	if(href_list["download"])
		var/datum/paiCandidate/candidate = locate(href_list["candidate"])
		var/obj/item/device/paicard/card = locate(href_list["device"])
		if (!(candidate in pai_candidates))
			return

		if(card.pai)
			return
		if(istype(card,/obj/item/device/paicard) && istype(candidate,/datum/paiCandidate))
			var/mob/living/silicon/pai/pai = new(card)
			if(!candidate.name)
				pai.name = pick(ninja_names)
			else
				pai.name = candidate.name
			pai.real_name = pai.name
			pai.key = candidate.key

			card.setPersonality(pai)
			card.looking_for_personality = 0

			if(pai.mind) update_antag_icons(pai.mind)

			pai_candidates -= candidate
			usr << browse(null, "window=findPai")

	var/datum/vueui/ui = href_list["vueui"]
	if(!istype(ui))
		return

	if(href_list["submit_candidate"])
		var/datum/paiCandidate/candidate = ui.metadata["candidate"]
		if(!istype(candidate))
			return
		href_list["submit_candidate"]["name"] = sanitizeSafe(href_list["submit_candidate"]["name"], MAX_NAME_LEN)
		href_list["submit_candidate"]["description"] = sanitize(href_list["submit_candidate"]["description"])
		href_list["submit_candidate"]["role"] = sanitize(href_list["submit_candidate"]["role"])
		href_list["submit_candidate"]["comments"] = sanitize(href_list["submit_candidate"]["comments"])
		if(href_list["submit_candidate"]["name"])
			candidate.name = href_list["submit_candidate"]["name"]
		if(href_list["submit_candidate"]["description"])
			candidate.description = href_list["submit_candidate"]["description"]
		if(href_list["submit_candidate"]["role"])
			candidate.role = href_list["submit_candidate"]["role"]
		if(href_list["submit_candidate"]["comments"])
			candidate.comments = href_list["submit_candidate"]["comments"]
		if(length(candidate.name) < 1)
			to_chat(ui.user, "Please set your pAI name.")
			return
		candidate.ready = 1
		for(var/obj/item/device/paicard/p in all_pai_devices)
			if(p.looking_for_personality == 1)
				p.alertUpdate()
		ui.close()

/datum/controller/subsystem/pai/proc/revokeCandidancy(mob/M as mob)
	var/datum/paiCandidate/candidate
	if(!istype(M))
		return FALSE
	for(var/datum/paiCandidate/c in pai_candidates)
		if(!istype(c))
			continue
		if(c.key == M.key)
			candidate = c
			break
	if(!candidate)
		return FALSE
	candidate.ready = FALSE
	return TRUE


/datum/controller/subsystem/pai/proc/recruitWindow(mob/M as mob)
	var/datum/paiCandidate/candidate
	for(var/datum/paiCandidate/c in pai_candidates)
		if(!istype(c) || !istype(M))
			break
		if(c.key == M.key)
			candidate = c
	if(!candidate)
		candidate = new /datum/paiCandidate()
		candidate.key = M.key
		pai_candidates.Add(candidate)

	// Load the data before displaying.
	if (!config.sql_saves)
		candidate.savefile_load(M)
	else
		M.client.prefs.load_preferences()
		var/pai = M.client.prefs.pai
		if(pai["name"])
			candidate.name = sanitizeSafe(pai["name"], MAX_NAME_LEN)
		if(pai["description"])
			candidate.description = sanitize(pai["description"])
		if(pai["role"])
			candidate.role = sanitize(pai["role"])
		if(pai["comments"])
			candidate.comments = sanitize(pai["comments"])

	var/datum/vueui/ui = SSvueui.get_open_ui(M, src)
	if(!ui)
		ui = new(M, src, "misc-pai-recruit", 580, 590, "pAI Personality Configuration", list(
			"name" = candidate.name,
			"description" = candidate.description,
			"role" = candidate.role,
			"comments" = candidate.comments),
		state = interactive_state)
		ui.metadata = list("candidate" = candidate)
		ui.header = "minimal"

	return ui.open()

/datum/controller/subsystem/pai/proc/findPAI(obj/item/device/paicard/p, mob/user)
	requestRecruits(user)
	var/list/available = list()
	for(var/datum/paiCandidate/c in SSpai.pai_candidates)
		if(c.ready)
			var/found = 0
			for(var/mob/abstract/observer/o in player_list)
				if(o.key == c.key && o.MayRespawn())
					found = 1
			if(found)
				available.Add(c)
	var/dat = ""

	dat += {"
		<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">
		<html>
			<head>
				<style>
					body {
						margin-top:5px;
						font-family:Verdana;
						color:white;
						font-size:13px;
						background-image:url('uiBackground.png');
						background-repeat:repeat-x;
						background-color:#272727;
						background-position:center top;
					}
					table {
						font-size:13px;
					}
					table.desc {
						border-collapse:collapse;
						font-size:13px;
						border: 1px solid #161616;
						width:100%;
					}
					table.download {
						border-collapse:collapse;
						font-size:13px;
						border: 1px solid #161616;
						width:100%;
					}
					tr.d0 td, tr.d0 th {
						background-color: #506070;
						color: white;
					}
					tr.d1 td, tr.d1 th {
						background-color: #708090;
						color: white;
					}
					tr.d2 td {
						background-color: #00FF00;
						color: white;
						text-align:center;
					}
					td.button {
						border: 1px solid #161616;
						background-color: #40628a;
						text-align: center;
					}
					td.download {
						border: 1px solid #161616;
						background-color: #40628a;
						text-align: center;
					}
					th {
						text-align:left;
						width:125px;
						vertical-align:top;
					}
					a.button {
						color:white;
						text-decoration: none;
					}
				</style>
			</head>
			<body>
				<b><font size='3px'>pAI Availability List</font></b><br><br>
	"}
	dat += "<p>Displaying available AI personalities from central database... If there are no entries, or if a suitable entry is not listed, check again later as more personalities may be added.</p>"

	for(var/datum/paiCandidate/c in available)
		dat += {"
				<table class="desc">
					<tr class="d0">
						<th>Name:</th>
						<td>[c.name]</td>
					</tr>
					<tr class="d1">
						<th>Description:</th>
						<td>[c.description]</td>
					</tr>
					<tr class="d0">
						<th>Preferred Role:</th>
						<td>[c.role]</td>
					</tr>
					<tr class="d1">
						<th>OOC Comments:</th>
						<td>[c.comments]</td>
					</tr>
				</table>
				<table class="download">
					<td class="download"><a href='byond://?src=\ref[src];download=1;candidate=\ref[c];device=\ref[p]' class="button"><b>Download [c.name]</b></a>
					</td>
				</table>
				<br>
		"}

	dat += {"
			</body>
		</html>
	"}

	user << browse(dat, "window=findPai")

/datum/controller/subsystem/pai/proc/requestRecruits(mob/user)
	inquirer = user
	for(var/mob/abstract/observer/O in player_list)
		if(!O.MayRespawn())
			continue
		if(jobban_isbanned(O, "pAI"))
			continue
		if(asked.Find(O.key))
			if(world.time < asked[O.key] + askDelay)
				continue
			else
				asked.Remove(O.key)
		if(O.client)
			if(BE_PAI in O.client.prefs.be_special_role)
				question(O.client)

/datum/controller/subsystem/pai/proc/question(client/C)
	set waitfor = FALSE

	if(!C)
		return
	asked.Add(C.key)
	asked[C.key] = world.time
	var/response = alert(C, "[inquirer] is requesting a pAI personality. Would you like to play as a personal AI?", "pAI Request", "Yes", "No", "Never for this round")
	if(!C)	return		//handle logouts that happen whilst the alert is waiting for a response.
	if(response == "Yes")
		recruitWindow(C.mob)
	else if (response == "Never for this round")
		C.prefs.be_special_role -= BE_PAI

/datum/paiCandidate
	var/name
	var/key
	var/description
	var/role
	var/comments
	var/ready = 0

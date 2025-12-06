GLOBAL_DATUM_INIT(revdata, /datum/getrev, new)

/datum/getrev
	var/commit
	var/date
	var/originmastercommit
	var/list/testmerge = list()

/datum/getrev/New()
	commit = rustg_git_revparse("HEAD")
	if (commit)
		date = rustg_git_commit_date(commit)
	originmastercommit = rustg_git_revparse("origin/master")

/datum/getrev/proc/load_tgs_info()
	testmerge = world.TgsTestMerges()
	var/datum/tgs_revision_information/revinfo = world.TgsRevision()
	if (revinfo)
		commit = revinfo.commit
		date = revinfo.timestamp || rustg_git_commit_date(commit)
		originmastercommit = revinfo.origin_commit

	// Goes to DD log and config_error.txt
	log_world(get_log_message())

/datum/getrev/proc/get_log_message()
	var/list/msg = list()
	msg += "Server Revision Information: [date]"
	if (originmastercommit)
		msg += " (origin/master: [originmastercommit])"

	for(var/line in testmerge)
		var/datum/tgs_revision_information/test_merge/tm = line
		msg += "Test merge active of PR #[tm.number] commit [tm.head_commit]"

	if (commit && commit != originmastercommit)
		msg += "HEAD: [commit]"
	else if (!originmastercommit)
		msg += "No commit information available."

	return msg.Join("\n")

/datum/getrev/proc/GetTestMergeInfo(header = TRUE)
	if (!length(testmerge))
		return ""
	. = header ? "The following PRs are currently test-merged on the server:<br>" : ""
	for (var/line in testmerge)
		var/datum/tgs_revision_information/test_merge/tm = line
		var/cm = tm.head_commit
		var/details = ": '" + html_encode(tm.title) + "' by " + html_encode(tm.author) + " at commit " + html_encode(copytext_char(cm, 1, 11))
		. += "<a href=\"[GLOB.config.githuburl]/pull/[tm.number]\">#[tm.number][details]</a><br>"

/client/verb/showrevinfo()
	set category = "OOC"
	set name = "Show Server Revision"
	set desc = "Check the current server code revision"

	var/list/msg = list()
	// BYOND info
	msg += "<b>BYOND Version:</b> [world.byond_version].[world.byond_build]"
	if(DM_VERSION != world.byond_version || DM_BUILD != world.byond_build)
		msg += "<i>Compiled with BYOND Version:</i> [DM_VERSION].[DM_BUILD]"

	// Rev info
	var/datum/getrev/revdata = GLOB.revdata
	msg += "<br><b>Server Revision Info:</b>"
	msg += "Server revision compiled on: [revdata.date]"
	var/pc = revdata.originmastercommit
	if(pc)
		msg += "Master commit: <a href=\"[GLOB.config.githuburl]/commit/[pc]\">[pc]</a>"
	if(length(revdata.testmerge))
		msg += revdata.GetTestMergeInfo()
	if(revdata.commit && revdata.commit != revdata.originmastercommit)
		msg += "Local commit: [revdata.commit]"
	else if(!pc)
		msg += SPAN_ALERT("No commit information available!")
	if(world.TgsAvailable())
		var/datum/tgs_version/version = world.TgsVersion()
		msg += "TGS version: [version.raw_parameter]"
		var/datum/tgs_version/api_version = world.TgsApiVersion()
		msg += "DMAPI version: [api_version.raw_parameter]"
	else
		msg += SPAN_ALERT("TGS API not available!")

	to_chat(src, SPAN_INFO(msg.Join("<br>")))

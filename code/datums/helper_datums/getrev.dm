var/global/datum/getrev/revdata = new()

/hook/startup/proc/initialize_test_merges()
	if (!revdata)
		log_debug("GETREV: No rev found.")
		return TRUE

	revdata.testmerge_initialize()

	return TRUE

/datum/getrev
	var/branch
	var/revision
	var/date
	var/showinfo
	var/list/datum/tgs_revision_information/test_merge/test_merges
	var/greeting_info

/datum/getrev/New()
	var/list/head_branch = file2list(".git/HEAD", "\n")
	if(head_branch.len)
		branch = copytext(head_branch[1], 17)

	var/list/head_log = file2list(".git/logs/HEAD", "\n")
	for(var/line=head_log.len, line>=1, line--)
		if(head_log[line])
			var/list/last_entry = text2list(head_log[line], " ")
			if(last_entry.len < 2)	continue
			revision = last_entry[2]
			// Get date/time
			if(last_entry.len >= 5)
				var/unix_time = text2num(last_entry[5])
				if(unix_time)
					date = unix2date(unix_time)
			break

	world.log << "Running revision:"
	world.log << branch
	world.log << date
	world.log << revision

client/verb/showrevinfo()
	set category = "OOC"
	set name = "Show Server Revision"
	set desc = "Check the current server code revision"

	if(revdata.revision)
		to_chat(src, "<b>Server revision:</b> [revdata.branch] - [revdata.date]")
		if(config.githuburl)
			to_chat(src, "<a href='[config.githuburl]/commit/[revdata.revision]'>[revdata.revision]</a>")
		else
			to_chat(src, revdata.revision)
	else
		to_chat(src, "Revision unknown")

	to_chat(src, "<b>Current Map:</b> [current_map.full_name]")

/datum/getrev/proc/testmerge_overview()
	if (!test_merges.len)
		return

	var/list/out = list("<br><center><font color='purple'><b>PRs test-merged for this round:</b><br>")

	for (var/TM in test_merges)
		out += testmerge_short_overview(TM)

	out += "</font></center><br>"

	return out.Join()

/datum/getrev/proc/generate_greeting_info()
	if (!test_merges.len)
		greeting_info = {"<div class="alert alert-info">
		                  There are currently no test merges loaded onto the server.
		                  </div>"}
		return

	var/list/out = list("<p>There are currently [test_merges.len] PRs being tested live.</p>",
		{"<table class="table table-hover">"}
	)

	for (var/TM in test_merges)
		out += testmerge_long_oveview(TM)

	out += "</table>"

	greeting_info = out.Join()

/datum/getrev/proc/testmerge_initialize()
	var/datum/tgs_api/api = TGS_READ_GLOBAL(tgs)

	if (api)
		log_debug("GETREV: TGS API found.")
		test_merges = api.TestMerges()
		log_debug("GETREV: [test_merges.len] test merges found.")
	else
		log_debug("GETREV: No TGS API found.")
		test_merges = list()

	generate_greeting_info()

/datum/getrev/proc/testmerge_short_overview(datum/tgs_revision_information/test_merge/tm)
	. = list()

	. += "<hr><p>PR #[tm.number]: \"[html_encode(tm.title)]\""
	. += "<br>\tAuthor: [html_encode(tm.author)]"

	if (config.githuburl)
		. += "<br>\t<a href='[config.githuburl]pull/[tm.number]'>\[Details...\]</a>"

	. += "</p>"

/datum/getrev/proc/testmerge_long_oveview(datum/tgs_revision_information/test_merge/tm)
	var/divid = "pr[tm.number]"

	. = list()
	. += {"<tr data-toggle="collapse" data-target="#[divid]" class="clickable">"}
	. += {"<th>PR #[tm.number] - [html_encode(tm.title)]</th>"}
	. += {"</tr><tr><td class="hiddenRow"><div id="[divid]" class="collapse">"}
	. += {"<table class="table">"}
	. += {"<tr><th>Author:</th><td>[html_encode(tm.author)]</td></tr>"}
	. += {"<tr><th>Merged:</th><td>[tm.time_merged]</td></tr>"}

	if (config.githuburl)
		. += {"<tr><td colspan="2"><a href="?JSlink=github;pr=[tm.number]">Link to Github</a></td></tr>"}

	. += {"<tr><th>Description:</th><td>[html_encode(tm.body)]</td></tr>"}
	. += {"</table></div></td></tr>"}

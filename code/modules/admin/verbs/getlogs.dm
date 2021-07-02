/*
	HOW DO I LOG RUNTIMES?
	Firstly, start dreamdeamon if it isn't already running. Then select "world>Log Session" (or press the F3 key)
	navigate the popup window to the data/logs/runtime/ folder from where your tgstation .dmb is located.
	(you may have to make this folder yourself)

	OPTIONAL: 	you can select the little checkbox down the bottom to make dreamdeamon save the log everytime you
				start a world. Just remember to repeat these steps with a new name when you update to a new revision!

	Save it with the name of the revision your server uses (e.g. r3459.txt).
	Game Masters will now be able to grant access any runtime logs you have archived this way!
	This will allow us to gather information on bugs across multiple servers and make maintaining the TG
	codebase for the entire /TG/station commuity a TONNE easier :3 Thanks for your help!
*/


//This proc allows Game Masters to grant a client access to the .getruntimelog verb
//Permissions expire at the end of each round.
//Runtimes can be used to meta or spot game-crashing exploits so it's advised to only grant coders that
//you trust access. Also, it may be wise to ensure that they are not going to play in the current round.
/client/proc/giveruntimelog()
	set name = ".giveruntimelog"
	set desc = "Give somebody access to any session logfiles saved to the /log/runtime/ folder."
	set category = null

	if(!src.holder)
		to_chat(src, "<span class='warning'>Only Admins may use this command.</span>")
		return

	var/client/target = input(src,"Choose somebody to grant access to the server's runtime logs (permissions expire at the end of each round):","Grant Permissions",null) as null|anything in clients
	if(!istype(target,/client))
		to_chat(src, "<span class='warning'>Error: giveruntimelog(): Client not found.</span>")
		return

	target.verbs |= /client/proc/getruntimelog
	to_chat(target, "<span class='warning'>You have been granted access to runtime logs. Please use them responsibly or risk being banned.</span>")
	return


//This proc allows download of runtime logs saved within the data/logs/ folder by dreamdeamon.
//It works similarly to show-server-log.
/client/proc/getruntimelog()
	set name = ".getruntimelog"
	set desc = "Retrieve any session logfiles saved by dreamdeamon."
	set category = null

	var/path = browse_files("data/logs/_runtime/")
	if(!path)
		return

	if(file_spam_check())
		return

	message_admins("[key_name_admin(src)] accessed file: [path]")
	src << run( file(path) )
	to_chat(src, "Attempting to send file, this may take a fair few minutes if the file is very large.")
	return


//This proc allows download of past server logs saved within the data/logs/ folder.
//It works similarly to show-server-log.
/client/proc/getserverlog()
	set name = ".getserverlog"
	set desc = "Fetch logfiles from data/logs"
	set category = null

	var/path = browse_files("data/logs/")
	if(!path)
		return

	if(file_spam_check())
		return

	message_admins("[key_name_admin(src)] accessed file: [path]")
	src << run( file(path) )
	to_chat(src, "Attempting to send file, this may take a fair few minutes if the file is very large.")
	return


//Other log stuff put here for the sake of organisation

/client/proc/view_signal_log()
	set name = "View Signaler Log"
	set desc = "Use this to view who sent signaler signals to things."
	set category = "Admin"

	var/text_signal_log = ""
	for(var/log in signal_log)
		text_signal_log += "[log]<br>"

	var/datum/browser/signal_win = new(usr, "signallog", "Signal Log", 550, 500)
	signal_win.set_content(text_signal_log)
	signal_win.open()
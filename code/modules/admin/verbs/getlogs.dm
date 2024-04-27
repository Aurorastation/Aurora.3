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

/**
 * Allows a client that has this proc to download the runtime logs of the current round
 */
/client/proc/getruntimelog()
	set name = ".getruntimelog"
	set desc = "Retrieve any session logfiles saved by dreamdeamon."
	set category = null

	var/path = LOGPATH(GLOB.config.logfiles["world_runtime_log"])

	if(file_spam_check())
		return

	message_admins("[key_name_admin(src)] accessed file: [path]")
	src << run( file(path) )
	to_chat(src, "Attempting to send file, this may take a fair few minutes if the file is very large.")


//This proc allows download of past server logs saved within the data/logs/ folder.
//It works similarly to show-server-log.
/**
 * Allows a client that has this proc the download of a log file of the active round
 *
 * Assigned only to admins currently
 */
/client/proc/getserverlog()
	set name = ".getserverlog"
	set desc = "Fetch logfiles from data/logs"
	set category = null

	var/path = browse_files(LOGPATH("")) //Prompt for which file to download, understands subfolders from files
	if(!path)
		return

	if(file_spam_check())
		return

	message_admins("[key_name_admin(src)] accessed file: [path]")
	src << run( file(path) )
	to_chat(src, "Attempting to send file, this may take a fair few minutes if the file is very large.")

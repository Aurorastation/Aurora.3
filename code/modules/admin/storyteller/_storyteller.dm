GLOBAL_LIST_INIT(storyteller_verbs, list(/datum/admins/proc/storyteller_panel))

/mob/living/storyteller/proc/storyteller_panel()
	set name = "Storyteller Panel"
	set category = "Storyteller"

	if(client?.holder)
		client.holder.storyteller_panel()
		feedback_add_details("admin_verb","STP")

/datum/admins/proc/storyteller_panel()
	if(!check_rights(R_STORYTELLER))
		return

	var/dat = {"
		<center><B>Storyteller Panel</B></center><hr>\n
		"}
	dat += {"
		<BR>
		<A href='?src=\ref[src];create_object=1'>Create Object</A><br>
		<A href='?src=\ref[src];create_turf=1'>Create Turf</A><br>
		<A href='?src=\ref[src];create_mob=1'>Create Mob</A><br>
		"}

	usr << browse(dat, "window=storytellerpanel;size=210x280")

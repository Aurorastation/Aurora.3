/datum/admin_secret_item/admin_secret/show_crew_manifest
	name = "Show Crew Manifest"

/datum/admin_secret_item/admin_secret/show_crew_manifest/execute(var/mob/user)
	. = ..()
	if(!.)
		return
	SSrecords.open_manifest_tgui(user)

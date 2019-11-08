var/list/admin_verbs_lighting = list(
	/client/proc/lighting_hide_verbs,
	/client/proc/lighting_flush,
	/client/proc/lighting_reconsider_target,
	/client/proc/lighting_build_overlay,
	/client/proc/lighting_clear_overlay,
	/client/proc/lighting_toggle_profiling
)

/client/proc/lighting_show_verbs()
	set category = "Debug"
	set name = "Show Lighting Verbs"
	set desc = "Shows the lighting debug verbs."

	if (!check_rights(R_DEBUG|R_DEV)) return

	src << span("notice", "Lighting debug verbs have been shown.")
	verbs += admin_verbs_lighting

/client/proc/lighting_hide_verbs()
	set category = "Lighting"
	set name = "Hide Lighting Verbs"
	set desc = "Hides the lighting debug verbs."

	if (!check_rights(R_DEBUG|R_DEV)) return

	src << span("notice", "Lighting debug verbs have been hidden.")
	verbs -= admin_verbs_lighting

/client/proc/lighting_flush()
	set category = "Lighting"
	set name = "Flush Work Queue"
	set desc = "Flushes the lighting processor's current work queue."

	if (!check_rights(R_DEBUG|R_DEV)) return

	if (alert("Flush Lighting Work Queue? This will invalidate all pending lighting updates.", "Reset Lighting", "No", "No", "Yes") != "Yes")
		return

	log_and_message_admins("has flushed the lighting processor queues.")
	SSlighting.light_queue = list()
	SSlighting.corner_queue = list()
	SSlighting.overlay_queue = list()

/client/proc/lighting_reconsider_target(turf/T in turfs)
	set category = "Lighting"
	set name = "Reconsider Visibility"
	set desc = "Triggers a visibility update for a turf."

	if (!check_rights(R_DEBUG|R_DEV)) return

	if (TURF_IS_DYNAMICALLY_LIT(T))
		src << "That turf is not dynamically lit."
		return

	log_and_message_admins("has triggered a lighting update for turf \ref[T] - [T] at ([T.x],[T.y],[T.z]) in area [T.loc].")

	T.reconsider_lights()

/client/proc/lighting_build_overlay(turf/T in turfs)
	set category = "Lighting"
	set name = "Build Overlay"
	set desc = "Builds a lighting overlay for a turf if it does not have one."

	if (!check_rights(R_DEBUG|R_DEV)) return

	if (T.lighting_overlay)
		src << "That turf already has a lighting overlay."
		return

	log_and_message_admins("has generated a lighting overlay for turf \ref[T] - [T] ([T.x],[T.y],[T.z]) in area [T.loc].")

	T.lighting_build_overlay()

/client/proc/lighting_clear_overlay(turf/T in turfs)
	set category = "Lighting"
	set name = "Clear Overlay"
	set desc = "Clears a lighting overlay for a turf if it has one."

	if (!check_rights(R_DEBUG|R_DEV)) return
		
	if (!T.lighting_overlay)
		src << "That turf doesn't have a lighting overlay."
		return

	log_and_message_admins("has cleared a lighting overlay for turf \ref[T] - [T] ([T.x],[T.y],[T.z]) in area [T.loc].")

	T.lighting_clear_overlay()

/client/proc/lighting_toggle_profiling()
	set category = "Lighting"
	set name = "Profile Lighting"
	set desc = "Spams the database with lighting updates. Y'know, just 'cause."

	if (!check_rights(R_DEBUG|R_SERVER)) return

	if (!establish_db_connection(dbcon))
		usr << span("alert", "Unable to start profiling: No active database connection.")
		return

	lighting_profiling = !lighting_profiling
	log_and_message_admins("has [lighting_profiling ? "enabled" : "disabled"] lighting profiling.")

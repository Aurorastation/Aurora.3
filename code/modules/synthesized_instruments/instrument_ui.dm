// Base datum for synthesized instrument UI modules (song editor, echo editor, usage info).
// Provides the minimum interface expected by SStgui: a host reference and ui_host().
/datum/instrument_ui
	/// Display name shown in the TGUI window title bar.
	var/name
	/// The instrument atom that owns this UI datum; used to resolve the UI host for SStgui.
	var/atom/host

/// Delegates host resolution to the referenced instrument atom, enabling SStgui to find the UI host.
/datum/instrument_ui/ui_host(mob/user)
	return host?.ui_host()

/datum/instrument_ui/Destroy()
	host = null
	return ..()

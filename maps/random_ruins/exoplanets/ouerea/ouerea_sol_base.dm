/datum/map_template/ruin/exoplanet/ouerea_sol_base
	name = "Abandoned Solarian Base"
	id = "ouerea_sol_base"
	description = "A shuttle port on Ouerea, abandoned by the Sol Alliance"
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_UUEOAESA)
	prefix = "ouerea/"
	suffix = "ouerea_sol_base.dmm"
	unit_test_groups = list(1)

/area/ouerea_sol
	name = "Solarian Shuttle Port"
	icon_state = "bluenew"
	requires_power = TRUE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/barren
	area_flags = AREA_FLAG_RAD_SHIELDED|AREA_FLAG_INDESTRUCTIBLE_TURFS
	area_blurb = "This area seems to be a shuttle port - though one long-since abandoned. Flags of the Sol Alliance hang tattered, occasionally stirred in the breeze."

/obj/item/paper/sol_ouerea
	name = "Urgent Transmission - SAMV Yincheng"
	info = "words"

/obj/item/paper/sol_ouerea/Initialize()
	. = ..()
	var/T = parsepencode(
		{"\[center\]\[flag_sol\]\[/center\]
		\[lang=1\]\[center\]\[b\]SAMV Yincheng Emergency Transmission\[/b\]\[/center\]
		\[center\]\[b\]July 7th, 2457\[/b\]\[/center\]
		\[b\]TO:\[/b\] Major Alice Okami, Ouerea Resupply Station 6
		\[b\]FROM:\[/b\] SAMV Yincheng, Desk of Captain Johan Redford
		\[b\]MESSAGE:\[/b] As of sixteen minutes ago, the planet of Ouerea has been ceded to the Izweski Hegemony by Prime Minister Chater. All Alliance military personnel are to withdraw
		from the sector within the next three days. You are to assist in the evacuation of any human inhabitants of the planet who wish to leave, and to ensure that no recoverable military property or
		sensitive information is left behind. Transportation shuttles from the Yincheng will be arriving shortly to assist in this matter.\[/lang]"})
	info = T
	icon_state = "paper_words"

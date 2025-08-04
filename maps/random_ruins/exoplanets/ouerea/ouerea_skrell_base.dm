/datum/map_template/ruin/exoplanet/ouerea_skrell_base
	name = "Abandoned Nralakk Base"
	id = "ouerea_skrell_base"
	description = "A research base on Ouerea, abandoned by the Nralakk Federtaion"
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_UUEOAESA)
	prefix = "ouerea/"
	suffix = "ouerea_skrell_base.dmm"
	unit_test_groups = list(3)

/area/ouerea_skrell
	name = "Nralakk Research Base"
	icon_state = "bluenew"
	requires_power = TRUE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/barren
	area_flags = AREA_FLAG_RAD_SHIELDED|AREA_FLAG_INDESTRUCTIBLE_TURFS
	area_blurb = "This encampment bears the unmistakable signs of Skrell construction, with several large Nralakk Federation flags hanging by its entryway. The walls have begun to rust, and the banners seem to be quite tattered."

/obj/item/paper/skrell_ouerea
	name = "Transmission - NFV Orq'wesi"
	info = "warble"

/obj/item/paper/skrell_ouerea/Initialize()
	. = ..()
	var/T = parsepencode(
		{"\[center\]\[flag_nralakk\]\[/center\]
		\[lang=k\]\[center\]\[b\]Transmission - NFV Orq'wesi\[/b\]\[/center\]
		\[center\]\[b\]July 12th, 2457\[/b\]\[/center\]
		\[b\]TO:\[/b\] Research Director Volqix Quxum, Ouerea Observation Post 9
		\[b\]FROM:\[/b\] NFV Orq'wesi, Qukala Command
		\[b\]MESSAGE:\[/b] Due to the recent aggressive actions of the Unathi fleet, the Grand Council has agreed to cede Ouerea to the Izweski Hegemony. In exchange, the Unathi will return all prisoners \
		taken, as well as allowing Federation vessels to evacuate any Skrell citizens who desire it. A Qukala vessel will be touching down near your location shortly, to extract you and your team.\
		Any and all sensitive documents or research materials are to be brought with you or destroyed."\[/lang]"})
	info = T
	icon_state = "paper_words"

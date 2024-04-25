/datum/map_template/ruin/away_site/sensor_relay
	name = "sensor relay"
	description = "A ring-shaped installation with a powerful sensor suite. These stations were originally built during the pre-Interstellar War era by the Solarian Alliance’s Department of Colonization as a method of making interstellar travel safer. Thousands of these “beacon stations” were built by the Alliance and many were abandoned during the Interstellar War and its aftermath. While they have been mostly replaced in more developed sectors, such as Liberty’s Cradle and the Jewel Worlds, beacon stations are still a common sight in less developed sectors of the Orion Spur such as the Badlands and Weeping Stars."

	prefix = "away_site/sensor_relay/"
	suffixes = list("sensor_relay.dmm")

	sectors = ALL_POSSIBLE_SECTORS
	id = "sensor_relay"
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED

	unit_test_groups = list(1)

/singleton/submap_archetype/sensor_relay
	map = "sensor_relay"
	descriptor = "A sensor relay."

/obj/effect/overmap/visitable/sector/sensor_relay
	name = "sensor relay"
	icon = 'icons/obj/overmap/overmap_stationary.dmi'
	icon_state = "sensor_relay"
	color = COLOR_STEEL
	desc = "A ring-shaped installation with a powerful sensor suite. These stations were originally built during the pre-Interstellar War era by the Solarian Alliance’s Department of Colonization as a method of making interstellar travel safer. Thousands of these “beacon stations” were built by the Alliance and many were abandoned during the Interstellar War and its aftermath. While they have been mostly replaced in more developed sectors, such as Liberty’s Cradle and the Jewel Worlds, beacon stations are still a common sight in less developed sectors of the Orion Spur such as the Badlands and Weeping Stars."
	comms_support = TRUE
	comms_name = "Sensor Relay"

/obj/effect/overmap/visitable/sector/sensor_relay/handle_sensor_state_change(var/on)
	if(on)
		icon_state = "[initial(icon_state)]_active"
	else
		icon_state = initial(icon_state)

/area/sensor_relay
	icon = 'maps/away/away_site/sensor_relay/sensor_relay_sprites.dmi'
	name = "Sensor Relay"
	icon_state = "sensor_base"
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP
	requires_power = TRUE
	base_turf = /turf/space

/area/sensor_relay/maintenance
	name = "Sensor Relay - Maintenance"
	icon_state = "sensor_orange"

/area/sensor_relay/quarters
	name = "Sensor Relay - Quarters"
	icon_state = "sensor_magenta"

/area/sensor_relay/janitor
	name = "Sensor Relay - Cleaning"
	icon_state = "sensor_cyan"

/area/sensor_relay/workshop
	name = "Sensor Relay - Workshop & EVA"
	icon_state = "sensor_purple"

/area/sensor_relay/monitoring
	name = "Sensor Relay - Monitoring"
	icon_state = "sensor_red"

/area/sensor_relay/dining
	name = "Sensor Relay - Dining"
	icon_state = "sensor_cyan"

/area/sensor_relay/hydroponics
	name = "Sensor Relay - Hydroponics"
	icon_state = "sensor_green"

/area/sensor_relay/airlocks
	name = "Sensor Relay - Airlocks"
	icon_state = "sensor_red"

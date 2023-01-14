/datum/map_template/ruin/away_site/sensor_relay
	name = "sensor relay"
	description = "An independent sensor relay. It's a ring-shaped installation with a powerful sensor suite located in the center. The project to deploy these in sectors across the galaxy was started years ago by an extremely rich Solarian investment banker, claiming that it'd be 'The next best thing since lighthouses!'. The project actually went well, making a lot of profit by selling sensor data to civilian and military entities alike, but funding dried up after the inventor passed away. Now, these relays are used as temporary resting points for weary travelers looking to save a dime."
	suffixes = list("away_site/sensor_relay/sensor_relay.dmm")
	sectors = ALL_POSSIBLE_SECTORS
	id = "sensor_relay"
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED

/singleton/submap_archetype/sensor_relay
	map = "sensor_relay"
	descriptor = "A sensor relay."

/obj/effect/overmap/visitable/sector/sensor_relay
	name = "sensor relay"
	icon_state = "sensor_relay"
	desc = "An independent sensor relay. It's a ring-shaped installation with a powerful sensor suite located in the center. The project to deploy these in sectors across the galaxy was started years ago by an extremely rich Solarian investment banker, claiming that it'd be 'The next best thing since lighthouses!'. The project actually went well, making a lot of profit by selling sensor data to civilian and military entities alike, but funding dried up after the inventor passed away. Now, these relays are used as temporary resting points for weary travelers looking to save a dime."
	comms_support = TRUE
	comms_name = "relay"

/obj/effect/overmap/visitable/sector/sensor_relay/handle_sensor_state_change(var/on)
	if(on)
		icon_state = "[initial(icon_state)]_active"
	else
		icon_state = initial(linked.icon_state)

/area/sensor_relay
	icon = 'maps/away/away_site/sensor_relay/sensor_relay_sprites.dmi'
	name = "Sensor Relay"
	icon_state = "sensor_relay_area"
	flags = HIDE_FROM_HOLOMAP
	requires_power = TRUE
	base_turf = /turf/space
	no_light_control = TRUE

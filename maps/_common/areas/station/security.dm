
//Security

/area/security
	no_light_control = 1
	station_area = 1
	holomap_color = HOLOMAP_AREACOLOR_SECURITY

/area/security/main
	name = "Security - Equipment Room"
	icon_state = "security"

// For mapppers
/area/security/hallway
	name = "Security - Hallway"
	lightswitch = TRUE
	icon_state = "security"

/area/security/lobby
	name = "Security - Lobby"
	icon_state = "security"
	allow_nightmode = 1
	no_light_control = 0

/area/security/brig
	name = "Security - Brig"
	lightswitch = TRUE
	icon_state = "brig"

/area/security/brig/prison_break()
	for(var/obj/structure/closet/secure_closet/brig/temp_closet in src)
		temp_closet.locked = 0
		temp_closet.icon_state = temp_closet.icon_closed
	for(var/obj/machinery/door_timer/temp_timer in src)
		temp_timer.releasetime = 1
	..()

/area/security/prison
	name = "Security - Prison Wing"
	lightswitch = TRUE
	icon_state = "sec_prison"

/area/security/prison/prison_break()
	for(var/obj/structure/closet/secure_closet/brig/temp_closet in src)
		temp_closet.locked = 0
		temp_closet.icon_state = temp_closet.icon_closed
	for(var/obj/machinery/door_timer/temp_timer in src)
		temp_timer.releasetime = 1
	..()

/area/security/warden
	name = "Security - Warden's Office"
	icon_state = "Warden"

/area/security/armoury
	name = "Security - Armory"
	icon_state = "Warden"

/area/security/forensics_office
	name = "Security - Forensic Office"
	icon_state = "detective"
	sound_env = MEDIUM_SOFTFLOOR

/area/security/detectives_office
	name = "Security - Detective's Office"
	icon_state = "detective"

/area/security/investigations
	name = "Security - Investigations Division"
	icon_state = "detective"

/area/security/training
	name = "Security - Training Wing"
	icon_state = "firingrange"

/area/security/range
	name = "Security - Firing Range"
	icon_state = "firingrange"
	flags = FIRING_RANGE

/area/security/tactical
	name = "Security - Tactical Equipment"
	icon_state = "Tactical"

/area/security/security_office
	name = "Security - Security Office"
	icon_state = "security"

/*
	New()
		..()

		spawn(10) //let objects set up first
			for(var/turf/turfToGrayscale in src)
				if(turfToGrayscale.icon)
					var/icon/newIcon = icon(turfToGrayscale.icon)
					newIcon.GrayScale()
					turfToGrayscale.icon = newIcon
				for(var/obj/objectToGrayscale in turfToGrayscale) //1 level deep, means tables, apcs, locker, etc, but not locker contents
					if(objectToGrayscale.icon)
						var/icon/newIcon = icon(objectToGrayscale.icon)
						newIcon.GrayScale()
						objectToGrayscale.icon = newIcon
*/

/area/security/nuke_storage
	name = "Vault"
	icon_state = "nuke_storage"
	holomap_color = null
	flags = HIDE_FROM_HOLOMAP

/area/security/checkpoint
	name = "Security Checkpoint"
	icon_state = "checkpoint1"

/area/security/checkpoint2
	name = "Security - Arrivals Checkpoint"
	icon_state = "security"

/area/security/bridge_surface_checkpoint
	name = "Bridge Security Checkpoint"
	icon_state = "security"

/area/security/checkpoint/supply
	name = "Security Post - Cargo Bay"
	icon_state = "checkpoint1"

/area/security/checkpoint/engineering
	name = "Security Post - Engineering"
	icon_state = "checkpoint1"

/area/security/checkpoint/medical
	name = "Security Post - Medbay"
	icon_state = "checkpoint1"

/area/security/checkpoint/science
	name = "Security Post - Science"
	icon_state = "checkpoint1"

/area/security/vacantoffice
	name = "Vacant Office"
	icon_state = "security"

/area/security/vacantoffice2
	name = "Security - Meeting Room"
	icon_state = "security"


//Security

/area/security
	no_light_control = 1
	station_area = 1
	holomap_color = HOLOMAP_AREACOLOR_SECURITY

/area/security/main
	name = "Security - Equipment Room"
	icon_state = "security"

// For mapppers
/area/security/lobby
	name = "Security - Lobby"
	icon_state = "security"
	allow_nightmode = 1
	no_light_control = 0

/area/security/brig
	name = "Security - Brig"
	lightswitch = TRUE
	area_flags = AREA_FLAG_PRISON
	icon_state = "brig"

/area/security/brig/prison_break()
	for(var/obj/structure/closet/secure_closet/brig/temp_closet in src)
		temp_closet.locked = 0
		temp_closet.update_icon()
	for(var/obj/machinery/door_timer/temp_timer in src)
		temp_timer.releasetime = 1
	..()

/area/security/brig/control_room
	name = "Security - Brig Control Room"
	icon_state = "brig_control"
	lightswitch = FALSE
	no_light_control = 0

/area/security/brig/processing
	name = "Security - Brig Processing"
	icon_state = "brig_proc"
	no_light_control = 0

/area/security/brig/processing_secondary
	name = "Security - Brig Secondary Processing"
	icon_state = "brig_proc_two"
	no_light_control = 0

/area/security/prison
	name = "Security - Prison Wing"
	lightswitch = TRUE
	area_flags = AREA_FLAG_PRISON
	icon_state = "sec_prison"

/area/security/prison/prison_break()
	for(var/obj/structure/closet/secure_closet/brig/temp_closet in src)
		temp_closet.locked = 0
		temp_closet.update_icon()
	for(var/obj/machinery/door_timer/temp_timer in src)
		temp_timer.releasetime = 1
	..()

/area/security/warden
	name = "Security - Warden's Office"
	icon_state = "Warden"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR
	no_light_control = 0

/area/security/armory
	name = "Security - Armory"
	icon_state = "Warden"
	ambience = AMBIENCE_HIGHSEC
	no_light_control = 0

/area/security/investigations
	name = "Security - Investigations Division"
	icon_state = "investigations"
	allow_nightmode = 1
	no_light_control = 0

/area/security/investigations_storage
	name = "Security - Evidence Storage"
	icon_state = "evidence"
	no_light_control = 0

/area/security/forensics_office
	name = "Security - Forensic Office"
	icon_state = "investigations_office"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR
	no_light_control = 0

/area/security/forensics_laboratory
	name = "Security - Forensic Laboratory"
	icon_state = "investigations_office"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
	no_light_control = 0

/area/security/forensics_morgue
	name = "Security - Autopsy Lab"
	icon_state = "morgue"
	ambience = AMBIENCE_GHOSTLY
	no_light_control = 0

/area/security/break_room
	name = "Security - Break Room"
	icon_state = "security"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR
	no_light_control = 0

/area/security/training
	name = "Security - Training Wing"
	icon_state = "training"
	allow_nightmode = 1
	no_light_control = 0

/area/security/training_theoretical
	name = "Security - Theoretical Training"
	icon_state = "training_office"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR
	no_light_control = 0

/area/security/training_crimescene
	name = "Security - Crime Scene Training"
	icon_state = "training_office"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
	no_light_control = 0

/area/security/range
	name = "Security - Firing Range"
	icon_state = "firingrange"
	area_flags = AREA_FLAG_FIRING_RANGE
	no_light_control = 0

/area/security/tactical
	name = "Security - Tactical Equipment"
	icon_state = "Tactical"
	ambience = AMBIENCE_HIGHSEC
	no_light_control = 0

/area/security/security_office
	name = "Security - Security Office"
	icon_state = "security"
	no_light_control = 0

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
	ambience = AMBIENCE_HIGHSEC
	holomap_color = null
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP
	no_light_control = 0

/area/security/checkpoint
	name = "Security Checkpoint"
	icon_state = "checkpoint1"
	no_light_control = 0

/area/security/checkpoint2
	name = "Security - Arrivals Checkpoint"
	icon_state = "security"
	ambience = AMBIENCE_ARRIVALS

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
	no_light_control = 0

/area/security/vacantoffice2
	name = "Security - Meeting Room"
	no_light_control = 0

/area/security/penal_colony
	name = "\improper Security - Penal Mining Colony"
	icon_state = "security"
	icon_state = "security"
	holomap_color = null
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP | AREA_FLAG_PRISON
	sound_environment = SOUND_AREA_LARGE_ENCLOSED
	ambience = AMBIENCE_HIGHSEC

/area/security/penal_colony/warden
	name = "\improper Security - Remote Warden's Office"
	icon_state = "Warden"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/security/penal_colony/prison
	name = "\improper Security - Remote Prison Wing"
	icon_state = "sec_prison"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

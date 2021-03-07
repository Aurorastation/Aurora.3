// Used for creating the exchange areas.
/area/turbolift
	name = "Turbolift"
	base_turf = /turf/simulated/open
	requires_power = 1
	station_area = 1
	sound_env = SMALL_ENCLOSED
	ambience = AMBIENCE_ELEVATOR

	var/lift_floor_label = null
	var/lift_floor_name = null
	var/lift_announce_str = "Ding!"
	var/arrival_sound = 'sound/machines/ding.ogg'

	var/turbolift_req_access = null
	var/turbolift_req_one_access = null

	var/list/doors = list()
	var/obj/structure/lift/button/ext_panel
	var/datum/turbolift/lift

//We power this area via the turbolift controller
/area/turbolift/get_apc()
	var/obj/machinery/turbolift_controller = lift.controller
	if(!istype(turbolift_controller))
		return null
	var/area/A = get_area(turbolift_controller)
	return A.get_apc()

//called when a lift has queued this floor as a destination
/area/turbolift/proc/pending_move(var/datum/turbolift/lift)
	if(ext_panel)
		ext_panel.light_up()

//called when a lift arrives at this floor
/area/turbolift/proc/arrived(var/datum/turbolift/lift)
	lift.open_doors(src)
	if(ext_panel)
		ext_panel.reset()

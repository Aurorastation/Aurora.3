/**
 * A basic template loader system, allows placing objects, items, turfs in a specified area.
 * Currently this function doesn't support the following:
 *
 * * Uploading templates in-game.
 * * Even number area dimensions.
 */
/datum/room_template
	var/name = "base template"

	/// Top-down view of the room template, which can be edited like the example below:
	/**
	 * Define some vars that contains object-turf paths in New() like this:
	 * var/W = /turf/simulated/wall
	 * var/F = /turf/simulated/floor/plating
	 * var/G = /obj/effect/map_effect/window_spawner/full/reinforced
	 * var/A = /obj/machinery/door/airlock
	 * var/list/AF = list(A, F)
	 *
	 * then:
	 * layouts = list(
	 *	list(
	 *		list(W, G, W, W, W),
	 *		list(W, F, F, F, W),
	 *		list(W, W, W, AF, W)
	 *	) = "average college student dorm",
	 * )
	 * This is a layout of a 5x3 (5 width, 3 height) room. Vars can contain whatever path you want and you can fit multiple layouts in here.
	 * You can also enter values to the keys in this list, it'll be displayed in template selection UI. Make sure each value is unique.
	 * This system also supports placing multiple atoms per turf, needs to be defined inside a list on the turf represented in layout, see the example above.
	 * Keep the area dimension as odd numbers, reason explained below.
	 */
	var/list/layouts

	/// Lists for keeping record of template related placements, incase the user wants to revert it.
	var/list/placed_template_objects = list()
	var/list/replaced_turfs = list()
	var/list/deleted_blueprints = list()

/datum/room_template/proc/template_selection(turf/center)
	var/list/options = list()
	var/list/chosen_layout = list()

	for(var/key in layouts)
		options += layouts[key]

	var/choice = tgui_input_list(usr, "Choose a template to place.", "Template Selection", options)

	if(!choice)
		return

	for(var/key in layouts)
		if(layouts[key] == choice) // this is the reason every value needs to be unique
			chosen_layout = key
			break

	if(chosen_layout)
		build_the_template(center, chosen_layout)

/datum/room_template/proc/build_the_template(turf/center, list/chosen_layout)
	var/height = length(chosen_layout)
	var/width = length(chosen_layout[1])
	var/starting_x = center.x - round(width / 2) // this system assumes it's always at the center, hence even numbers aren't supported
	var/starting_y = center.y + round(height / 2)
	var/starting_z = center.z

	if(width % 2 == 0 || height % 2 == 0)
		CRASH("Room template [name] has a layout with even dimensions as width or height. Only odd numbers are supported.")

	for(var/row in 1 to height)
		for(var/column in 1 to width)
			// The math and reasoning behind this is, due to how we arrange reading the layout list
			// (consider the top-down view, and now visualise the list getting flattened), we start placing the template from top-left corner to bottom right.
			// We simply pick a turf that is specified by width*height area, and see where this exact turf corrresponds to in the layout given to us.
			var/turf/T = locate(starting_x + column - 1, starting_y - row + 1, starting_z) // we're locating while assuming we're in the center
			if(!T || T.density)
				continue

			var/tile_data = chosen_layout[row][column]
			if(!tile_data)
				continue

			for(var/obj/structure/blueprint/colliding_blueprint in T)
				deleted_blueprints += list(list("turf" = T, "type" = colliding_blueprint.type))
				qdel(colliding_blueprint)

			if(islist(tile_data))
				for(var/i in tile_data)
					place_tile_data(T, i)
			else
				place_tile_data(T, tile_data)

	// Finalizing template placement
	if(usr?.client)
		if(tgui_alert(usr, "Would you like to keep the placed template?", "Template Confirmation", list("Confirm", "Cancel")) != "Confirm")
			QDEL_LAZYLIST(placed_template_objects) // revert placed objects

			for(var/turf/T in replaced_turfs) // restore turfs
				T.ChangeTurf(replaced_turfs[T])

			for(var/tile in deleted_blueprints) // restore blueprints
				var/blueprint_to_restore = tile["type"]
				new blueprint_to_restore(tile["turf"])

			to_chat(usr, SPAN_NOTICE("Template has been reverted."))

	replaced_turfs = null
	deleted_blueprints = null

/datum/room_template/proc/place_tile_data(turf/T, tile_data)
	if(ispath(tile_data, /turf)) // Turf
		replaced_turfs[T] = T.type
		T.ChangeTurf(tile_data)
		return

	placed_template_objects += new tile_data(T) // Object or anything else

// ---- Subtypes

// Base Planner Templates
/datum/room_template/base_planner_template
	name = "Base Planner Template"

/datum/room_template/base_planner_template/New()
	var/G = /obj/structure/blueprint/girder
	var/W = /obj/structure/blueprint/window_frame
	var/A = /obj/structure/blueprint/airlock_frame
	var/F = /obj/structure/blueprint/turf_plating
	var/list/AF = list(A, F)
	var/N

	layouts = list(
		list(
			list(G, G ,G, G, G),
			list(G, F, F, F, G),
			list(G, F, F, F, G),
			list(G, F, F, F, G),
			list(G, G, G, G, G),
		) = "5x5 Room",

		list(
			list(G, G ,G, G, G, G, G),
			list(G, F, F, F, F, F, G),
			list(G, F, F, F, F, F, G),
			list(G, F, F, F, F, F, G),
			list(G, F, F, F, F, F, G),
			list(G, F, F, F, F, F, G),
			list(G, G, G, G, G, G, G),
		) = "7x7 Room",

		list(
			list(N, G, G, AF, W, AF, G, G, N),
			list(G, G, F, F, F, F, F, G, G),
			list(G, F, F, F, F, F, F, F, G),
			list(W, F, F, F, F, F, F, F, W),
			list(W, F, F, F, F, F, F, F, W),
			list(W, F, F, F, F, F, F, F, W),
			list(G, F, F, F, F, F, F, F, G),
			list(G, G, F, F, F, F, F, G, G),
			list(N, G, G, AF, W, AF, G, G, N)
		) = "9x9 Room with Windows and Airlocks",

		list(
			list(N, G ,W, A, A, G, G, G, G, G, N),
			list(G, G ,F, F, F, G, F, F, F, G, G),
			list(G, F ,F, F, F, G, F, F, F, F, W),
			list(G, F ,F, F, F, AF, F, F, F, F, AF),
			list(W, F ,F, F, F, W, F, F, F, F, G),
			list(W, F ,F, F, F, G, G, F, F, F, G),
			list(W, F ,F, F, F, F, G, G, W, G, G),
			list(G, F ,F, F, F, F, W, F, F, F, G),
			list(G, F ,F, F, F, F, AF, F, F, F, G),
			list(G, G ,F, F, F, F, G, F, F, G, G),
			list(N, G ,W, AF, AF, G, G, G, G, G, N),
		) = "11x11 Base Template"
	)

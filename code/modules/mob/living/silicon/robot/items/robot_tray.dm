// A special tray for the service droid. Allow droid to pick up and drop items as if they were using the tray normally
// Click on table to unload, click on item to load. Alt+click to load everything on tile
/obj/item/tray/robotray
	name = "RoboTray"
	desc = "An autoloading tray specialized for carrying refreshments."

/obj/item/tray/robotray/afterattack(atom/target, mob/user, proximity)
	if(isturf(target) || istype(target,/obj/structure/table) )
		var foundtable = istype(target,/obj/structure/table/)
		if(!foundtable) //it must be a turf!
			for(var/obj/structure/table/T in target)
				foundtable = TRUE
				break
		var/turf/dropspot
		if(!foundtable) // don't unload things onto walls or other silly places.
			dropspot = get_turf(user)
		else if ( isturf(target) ) // they clicked on a turf with a table in it
			dropspot = target
		else					// they clicked on a table
			dropspot = get_turf(target)
		if(foundtable)
			unload_at_loc(dropspot, src)
		else
			spill(user,dropspot)
		current_weight = 0

	return ..()

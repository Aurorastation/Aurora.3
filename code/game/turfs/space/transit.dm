/turf/space/transit
	var/pushdirection // push things that get caught in the transit tile this direction
	plane = 0

/turf/space/transit/Initialize()
	update_icon()
	initialized = TRUE
	return INITIALIZE_HINT_NORMAL

/turf/space/transit/update_icon()
	icon_state = ""

	var/dira=""
	var/i=0
	switch(pushdirection)
		if(SOUTH) // North to south
			dira="ns"
			i=1+(abs((x^2)-y)%15) // Vary widely across X, but just decrement across Y

		if(NORTH) // South to north  I HAVE NO IDEA HOW THIS WORKS I'M SORRY.  -Probe
			dira="ns"
			i=1+(abs((x^2)-y)%15) // Vary widely across X, but just decrement across Y

		if(WEST) // East to west
			dira="ew"
			i=1+(((y^2)+x)%15) // Vary widely across Y, but just increment across X

		if(EAST) // West to east
			dira="ew"
			i=1+(((y^2)-x)%15) // Vary widely across Y, but just increment across X


		/*
		if(NORTH) // South to north (SPRITES DO NOT EXIST!)
			dira="sn"
			i=1+(((x^2)+y)%15) // Vary widely across X, but just increment across Y

		if(EAST) // West to east (SPRITES DO NOT EXIST!)
			dira="we"
			i=1+(abs((y^2)-x)%15) // Vary widely across X, but just increment across Y
		*/

		else
			icon_state="black"
	if(icon_state != "black")
		icon_state = "speedspace_[dira]_[i]"

/turf/space/transit/ChangeTurf(var/turf/N, var/tell_universe=1, var/force_lighting_update = 0, var/allow = 0, var/keep_air = FALSE)
	return ..(N, tell_universe, 1, allow, keep_air)

//Overwrite because we dont want people building rods in space.
/turf/space/transit/attackby(obj/O as obj, mob/user as mob)
	return 0

/turf/space/transit/north // moving to the north

	pushdirection = SOUTH  // south because the space tile is scrolling south
	icon_state="debug-north"

	// Isn't legacy code fun.
	// These are here so I don't have to remap all this shit.
	shuttlespace_ns1
	shuttlespace_ns2
	shuttlespace_ns3
	shuttlespace_ns4
	shuttlespace_ns5
	shuttlespace_ns6
	shuttlespace_ns7
	shuttlespace_ns8
	shuttlespace_ns9
	shuttlespace_ns10
	shuttlespace_ns11
	shuttlespace_ns12
	shuttlespace_ns13
	shuttlespace_ns14
	shuttlespace_ns15

/turf/space/transit/south // moving to the south

	pushdirection = NORTH
	icon_state="debug-south"

/turf/space/transit/east // moving to the east

	pushdirection = WEST
	icon_state="debug-east"

	shuttlespace_ew1
	shuttlespace_ew2
	shuttlespace_ew3
	shuttlespace_ew4
	shuttlespace_ew5
	shuttlespace_ew6
	shuttlespace_ew7
	shuttlespace_ew8
	shuttlespace_ew9
	shuttlespace_ew10
	shuttlespace_ew11
	shuttlespace_ew12
	shuttlespace_ew13
	shuttlespace_ew14
	shuttlespace_ew15

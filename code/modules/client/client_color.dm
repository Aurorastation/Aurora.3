/datum/client_color
	var/client_color = "" //Any client.color-valid value
	var/priority = 1 //Since only one client.color can be rendered on screen, we take the one with the highest priority value:
	//eg: "Bloody screen" > "goggles color" as the former is much more important


/mob
	var/list/client_colors = list()



/*
	Adds an instance of color_type to the mob's client_colors list
	color_type - a typepath (subtyped from /datum/client_color)
*/
/mob/proc/add_client_color(color_type)
	if(!ispath(/datum/client_color))
		return

	var/datum/client_color/CC = new color_type()
	client_colors |= CC
	sortTim(client_colors, /proc/cmp_clientcolor_priority)
	update_client_color()


/*
	Removes an instance of color_type from the mob's client_colors list
	color_type - a typepath (subtyped from /datum/client_color)
*/
/mob/proc/remove_client_color(color_type)
	if(!ispath(/datum/client_color))
		return

	for(var/cc in client_colors)
		var/datum/client_color/CC = cc
		if(CC.type == color_type)
			client_colors -= CC
			qdel(CC)
			break
	update_client_color()


/*
	Resets the mob's client.color to null, and then sets it to the highest priority
	client_color datum, if one exists
*/
/mob/proc/update_client_color()
	if(!client)
		return
	client.color = null
	if(!client_colors.len)
		return
	var/datum/client_color/CC = client_colors[1]
	if(CC)
		animate(client, color = CC.client_color)

/datum/client_color/monochrome
	client_color = list(0.33,0.33,0.33, 0.33,0.33,0.33, 0.33,0.33,0.33)
	priority = INFINITY

/datum/client_color/deuteranopia
	client_color = list(0.47,0.38,0.15, 0.54,0.31,0.15, 0,0.3,0.7)
	priority = 100

/datum/client_color/protanopia
	client_color = list(0.51,0.4,0.12, 0.49,0.41,0.12, 0,0.2,0.76)
	priority = 100

/datum/client_color/tritanopia
	client_color = list(0.95,0.07,0, 0,0.44,0.52, 0.05,0.49,0.48)
	priority = 100

/datum/client_color/berserk
	client_color = "#AF111C"
	priority = 100
/datum/event/meteor_chunks
	ic_name = "meteor chunks"
	no_fake = 1
	var/turf/spawn_loc

/datum/event/meteor_chunks/announce()
	for(var/mob/living/carbon/human/H in human_mob_list)
		if(H.z == 3)
			to_chat(H, "<span class='danger'><font size=3>A bright flash illuminates the skies!</font></span>")
			flick("e_flash", H.flash)

/datum/event/meteor_chunks/start()
	var/area/a = random_station_area()
	spawn_loc = a.random_space()
	explosion(spawn_loc,1,2,4)
	addtimer(CALLBACK(src, .proc/drop_meteor), 5 SECONDS)

/datum/event/meteor_chunks/proc/drop_meteor()
	var/drop_x = spawn_loc.x-2
	var/drop_y = spawn_loc.y-2
	var/drop_z = spawn_loc.z
	spawn_loc.visible_message("<span class='danger'>A flaming rocks falls from the skies!</span>",)
	new /datum/random_map/automata/meteor_chunk(null,drop_x,drop_y,drop_z,4,4)
	log_and_message_admins("A meteor chunk has landed at (<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[spawn_loc.x];Y=[spawn_loc.y];Z=[spawn_loc.z]'>JMP</a>)")
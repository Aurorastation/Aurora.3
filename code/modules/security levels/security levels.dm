/var/security_level = 0
//0 = code green
//1 = code yellow
//2 = code blue
//3 = code red
//4 = code delta

//config.alert_desc_blue_downto
/var/datum/announcement/priority/security/security_announcement_sound = new(do_log = 0, do_newscast = 1, new_sound = sound('sound/misc/announcements/security_level.ogg'))
/var/datum/announcement/priority/security/security_announcement = new(do_log = 0, do_newscast = 1)

/proc/set_security_level(var/level)
	switch(level)
		if("green")
			level = SEC_LEVEL_GREEN
		if("blue")
			level = SEC_LEVEL_BLUE
		if("red")
			level = SEC_LEVEL_RED
		if("yellow")
			level = SEC_LEVEL_YELLOW
		if("delta")
			level = SEC_LEVEL_DELTA

	//Will not be announced if you try to set to the same level as it already is
	if(level >= SEC_LEVEL_GREEN && level <= SEC_LEVEL_DELTA && level != security_level)
		switch(level)
			if(SEC_LEVEL_GREEN)
				security_announcement.Announce("[config.alert_desc_green]", "Attention! Security level lowered to green.")
				security_level = SEC_LEVEL_GREEN
				SSnightlight.end_temp_disable()
			if(SEC_LEVEL_BLUE)
				if(security_level < SEC_LEVEL_BLUE)
					security_announcement_sound.Announce("[config.alert_desc_blue_upto]", "Attention! Security level elevated to blue.")
				else
					security_announcement.Announce("[config.alert_desc_blue_downto]", "Attention! Security level lowered to blue.")
				security_level = SEC_LEVEL_BLUE
				SSnightlight.end_temp_disable()
			if(SEC_LEVEL_YELLOW)
				security_announcement_sound.Announce("[config.alert_desc_yellow_to]", "Attention! Biohazard alert declared!")
				security_level = SEC_LEVEL_YELLOW
				SSnightlight.end_temp_disable()
			if(SEC_LEVEL_RED)
				if(security_level < SEC_LEVEL_RED)
					security_announcement_sound.Announce("[config.alert_desc_red_upto]", "Attention! Security level elevated to red!")
					SSnightlight.temp_disable()
				else
					security_announcement.Announce("[config.alert_desc_red_downto]", "Attention! Code red!")
				security_level = SEC_LEVEL_RED
				post_display_status("alert", "redalert")
			if(SEC_LEVEL_DELTA)
				security_announcement_sound.Announce("[config.alert_desc_delta]", "Attention! Delta security level reached!", new_sound = 'sound/effects/siren.ogg')
				security_level = SEC_LEVEL_DELTA
				SSnightlight.temp_disable()

		var/newlevel = get_security_level()
		for(var/obj/machinery/power/apc/powercontrol in SSmachinery.processing_machines)
			if(isContactLevel(powercontrol.z))
				powercontrol.manage_emergency(newlevel)

/proc/get_security_level()
	switch(security_level)
		if(SEC_LEVEL_GREEN)
			return "green"
		if(SEC_LEVEL_BLUE)
			return "blue"
		if(SEC_LEVEL_YELLOW)
			return "yellow"
		if(SEC_LEVEL_RED)
			return "red"
		if(SEC_LEVEL_DELTA)
			return "delta"

/proc/num2seclevel(var/num)
	switch(num)
		if(SEC_LEVEL_GREEN)
			return "green"
		if(SEC_LEVEL_BLUE)
			return "blue"
		if(SEC_LEVEL_YELLOW)
			return "yellow"
		if(SEC_LEVEL_RED)
			return "red"
		if(SEC_LEVEL_DELTA)
			return "delta"

/proc/seclevel2num(var/seclevel)
	switch( lowertext(seclevel) )
		if("green")
			return SEC_LEVEL_GREEN
		if("blue")
			return SEC_LEVEL_BLUE
		if("yellow")
			return SEC_LEVEL_BLUE
		if("red")
			return SEC_LEVEL_RED
		if("delta")
			return SEC_LEVEL_DELTA


/*DEBUG
/mob/verb/set_thing0()
	set_security_level(0)
/mob/verb/set_thing1()
	set_security_level(1)
/mob/verb/set_thing2()
	set_security_level(2)
/mob/verb/set_thing3()
	set_security_level(3)
*/

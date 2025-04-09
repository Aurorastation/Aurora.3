//Uncommenting ALLOW_HOLIDAYS in config.txt will enable Holidays
var/global/Holiday = null

//Just thinking ahead! Here's the foundations to a more robust Holiday event system.
//It's easy as hell to add stuff. Just set Holiday to something using the switch (or something else)
//then use if(Holiday == "MyHoliday") to make stuff happen on that specific day only
//Please, Don't spam stuff up with easter eggs, I'd rather somebody just delete this than people cause
//the game to lag even more in the name of one-day content.

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//ALSO, MOST IMPORTANTLY: Don't add stupid stuff! Discuss bonus content with Project-Heads first please!//
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//																							~Carn

/hook/startup/proc/updateHoliday()
	Get_Holiday()
	return 1

//sets up the Holiday global variable. Shouldbe called on game configuration or something.
/proc/Get_Holiday()
	if(!Holiday)	return		// Holiday stuff was not enabled in the config!

	Holiday = null				// reset our switch now so we can recycle it as our Holiday name

	var/YY	=	text2num(time2text(world.timeofday, "YY")) 	// get the current year
	var/MM	=	text2num(time2text(world.timeofday, "MM")) 	// get the current month
	var/DD	=	text2num(time2text(world.timeofday, "DD")) 	// get the current day

	//Main switch. If any of these are too dumb/inappropriate, or you have better ones, feel free to change whatever
	switch(MM)
		if(1)	//Jan
			switch(DD)
				if(1)							Holiday = "New Year's Day"
				if(2)							Holiday = "Xanan Founding Day"
				if(9)							Holiday = "Tajaran Coming of Dawn"
				if(15)							Holiday = "New Kingdom of Adhomai Ice Waltz"
				if(18)							Holiday = "Red Coalition Secession Day"
				if (22)
					if(YY==23)					Holiday = "Lunarian Zhongqiu Jie Festival"

		if(2)	//Feb
			switch(DD)
				if(1)							Holiday = "C'thur Independence Day"
				if(3)							Holiday = "Dominian Feast of Devotion"
				if(10)
					if(YY==24)					Holiday = "Lunarian Zhongqiu Jie Festival"
				if(14)							Holiday = "Valentine's Day"
				if(29)							Holiday = "Leap Day"


		if(3)	//Mar
			switch(DD)
				if(4)							Holiday = "People's Republic of Adhomai Victory Day"
				if(11)							Holiday = "Assunzioni Assumption of the Fading Lights"
				if(17)							Holiday = "St. Patrick's Day"
				if(20)							Holiday = "Spring Vernal Equinox"
				if(28)							Holiday = "All-Xanu Peace Day"
				if(31)
					if(YY == 24)  				Holiday = "Easter"

		if(4)	//Apr
			switch(DD)
				if(1)							Holiday = "April Fool's Day"
				if(3)							Holiday = "Dominian Feast of Faith"
				if(9)
					Holiday = "Silversun Festival of the Silver Seas"
					if(YY == 23 && prob(50))				Holiday = "Easter"
				if(20)
					if(YY == 25) 				Holiday = "Easter"
				if(22)							Holiday = "Earth Day"

		if(5)	//May
			switch(DD)
				if(1)							Holiday = "International Workers' Day"
				if(5)							Holiday = "Tau Ceti Republic Day"
				if(6)							Holiday = "Eridani Diversity Day"
				if(14)							Holiday = "Galatean Graduation Day"
				if(22)							Holiday = "Dominian Worker's Day"
				if(30)							Holiday = "People's Republic of Adhomai President's Day"

		if(6)	//Jun
			switch(DD)
				if(6)							Holiday = "Mictlani Tago de Eksterterano"
				if(14)
					Holiday = "New Gibson Remembrance Day"
					if(prob(50))				Holiday = "Skrell Qu'Qyu-Poxii"
				if(15)							Holiday = "Colettish Republic Day"
				if(18)							Holiday = "Callistean Landfall Day"
				if(22)							Holiday = "Colettish Civil Guard Day"
				if(26)							Holiday = "Callistean Pigeon Day"

		if(7)	//Jul
			switch(DD)
				if(1)							Holiday = "Xanan Election Day"
				if(4)
					Holiday = "DPRA Democratic Revolution Day"
					if(prob(50))				Holiday = "DPRA Liberation Day"
				if(7)							Holiday = "Dominian Founding Day"
				if(16)							Holiday = "Lunarian Apollo Day"
				if(17)							Holiday = "Solarian Reunification Day"
				if(29)							Holiday = "Dominian Victory Day"


		if(8)	//Aug
			switch(DD)
				if(1)							Holiday = "Himean Independence Day"
				if(13)							Holiday = "Xanan Independence Day"
				if(19)							Holiday = "Damascene Independence Day"
				if(21)							Holiday = "Venusian Ascension Day"
				if(27)							Holiday = "Vaurca Hive War Commemoration"

		if(9)	//Sep
			switch(DD)
				if(3)							Holiday = "Dominian Feast of Joy"
				if(5)							Holiday = "Si'akh Final Judgement Day"
				if(6)							Holiday = "New Gibson Celebration of the Solstice"
				if(19)							Holiday = "Talk-Like-a-Pirate Day"
				if(24)							Holiday = "Tau Ceti Heritage Day"

		if(10)	//Oct
			switch(DD)
				if(1)							Holiday = "Frontier Victory Day"
				if(5)							Holiday = "Colettish Colonization Day"
				if(9)							Holiday = "K'lax Technology Day"
				if(16)							Holiday = "Galatean Federation Day"
				if(27)							Holiday = "New Kingdom of Adhomai Day of Rightful Restoration"
				if(31)
					Holiday = "Halloween"
					if(YY == 24)  				Holiday = "Halloween and the day of Shi-rra Arr’Kahata"

		if(11)	//Nov
			switch(DD)
				if(1)							Holiday = "Dia de los Muertos"
				if(17)							Holiday = "Dominian Navy Day"
				if(18)							Holiday = "Kulkarni Day"
				if(24)							Holiday = "Konyang Independence Day"
				if(26)							Holiday = "Tajaran Armistice Day"
				if(28)							Holiday = "Interstellar Peace Day"

		if(12)	//Dec
			switch(DD)
				if(3)							Holiday = "Dominian Feast of Renewal"
				if(7)							Holiday = "Unathi Keeping of Memories"
				if(15)							Holiday = "Lunarian Pervoprohodets Day"
				if(24)							Holiday = "Christmas Eve"
				if(25)							Holiday = "Christmas"
				if(26)							Holiday = "Boxing Day"
				if(27)							Holiday = "New Gibson Unity Day"
				if(31)							Holiday = "New Year's Eve"

	if(!Holiday)
		//Friday the 13th
		if(DD == 13)
			if(time2text(world.timeofday, "DDD") == "Fri")
				Holiday = "Friday the 13th"

//Allows GA and GM to set the Holiday variable
/client/proc/Set_Holiday(T as text|null)
	set name = "Set Holiday"
	set category = "Fun"
	set desc = "Force-set the Holiday variable to make the game think it's a certain day. Set to 'None' to unset the Holiday"
	if(!check_rights(R_SERVER))
		return FALSE

	if(!T)
		T = tgui_input_text(src, "Type in a holiday below, or type 'None' to unset any holiday", "What Holiday is today?", "")
		if(!T)
			return FALSE
	else if (T == "None")
		Holiday = null
		message_admins(SPAN_NOTICE("ADMIN: Event: [key_name(src)] unset today's Holiday."))
		log_admin("[key_name(src)] unset today's Holiday")
		return TRUE

	Holiday = T

	Holiday_Game_Start()

	message_admins(SPAN_NOTICE("ADMIN: Event: [key_name(src)] force-set Holiday to \"[Holiday]\""))
	log_admin("[key_name(src)] force-set Holiday to \"[Holiday]\"")
	return TRUE

//Run at the  start of a round
/proc/Holiday_Game_Start()
	if(Holiday)
		to_world(SPAN_NOTICE("and..."))
		to_world("<h4>Happy [Holiday] Everybody!</h4>")
		switch(Holiday)			//special holidays
			if("Easter")
				Easter_Game_Start()
			if("Christmas Eve","Christmas")
				Christmas_Game_Start()

	return

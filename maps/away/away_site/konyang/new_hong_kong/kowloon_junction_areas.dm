/area/kowloon_junction
	name = "Kowloon Junction - Spaceport"
	requires_power = 0
	no_light_control = 1
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP | AREA_FLAG_RAD_SHIELDED | AREA_FLAG_INDESTRUCTIBLE_TURFS
	base_turf = /turf/simulated/floor/exoplanet/dirt_konyang
	ambience = AMBIENCE_KONYANG_TRAFFIC
	sound_environment = SOUND_ENVIRONMENT_CITY
	is_outside = TRUE
	var/lighting = FALSE //Is this area automatically lit?

/area/kowloon_junction/Initialize()
	. = ..()
	if(lighting)
		for(var/turf/T in src)
			T.set_light(MINIMUM_USEFUL_LIGHT_RANGE, 50, COLOR_WHITE) //Same light level as Konyang proper

//outside
/area/kowloon_junction/outdoors
	name = "Kowloon Junction - Outdoors"
	icon_state = "green"
	area_blurb = "The sounds and smells of Kowloon Junction bombard you from all directions. Skyscrapers and hills tower up further into the city."
	area_blurb_category = "kowloon_outdoors"
	lighting = TRUE

/area/kowloon_junction/coast
	name = "Kowloon Junction - Waterside"
	ambience = AMBIENCE_KONYANG_WATER
	area_blurb = "The crashing sounds of waves on the shore punctuates the air. The vast ocean spreads out as far as the eye can see, looking almost flat."
	area_blurb_category = "kowloon_shore"
	lighting = TRUE

/area/kowloon_junction/water
	name = "Point Verdant - Open Water"
	icon_state = "fitness_pool"
	lighting = TRUE

/area/kowloon_junction/water/deep
	name = "Point Verdant - Deep Water"
	lighting = TRUE

//inside
/area/kowloon_junction/interior
	name = "Kowloon Junction - Indoors"
	icon_state = "purple"
	requires_power = 0
	sound_environment = SOUND_AREA_LARGE_SOFTFLOOR
	ambience = AMBIENCE_KONYANG_RAIN_MUFFLED
	is_outside = FALSE

/area/kowloon_junction/interior/shallow//For open-walled areas, like awnings and balconies
	sound_environment = SOUND_ENVIRONMENT_CITY

/area/kowloon_junction/interior/rockwall
	name = "Kowloon Junction - Rockwalls"
	icon_state = "invi"

/area/kowloon_junction/interior/minimart
	name = "Kowloon Junction - MiniMart"
	icon_state = "yellow"

/area/kowloon_junction/interior/vendingmart
	name = "Kowloon Junction - Vending Machine Market"

/area/kowloon_junction/interior/chapel
	name = "Kowloon Junction - Trinary Perfection Chapel"
	icon_state = "chapel"
	ambience = AMBIENCE_CHAPEL

/area/kowloon_junction/interior/chapel_office
	name = "Kowloon Junction - Trinary Perfection Chapel Office"
	icon_state = "chapeloffice"

/area/kowloon_junction/interior/laundromat
	name = "Kowloon Junction - Laundromat"

/area/kowloon_junction/interior/self_serve_hotel
	name = "Kowloon Junction - Hotel"
	icon_state = "crew_quarters"
	area_blurb = "Disinfectant and polyester linens greet your nose at this self service hotel. Its not very welcoming, but its a place to rest."
	area_blurb_category = "kowloon_hotel"

/area/kowloon_junction/interior/corporate_office_bottom
	name = "Kowloon Junction - Corporate Offices"
	icon_state = "conference"

/area/kowloon_junction/interior/corporate_office_top
	name = "Kowloon Junction - Corporate Offices"
	icon_state = "conference"

/area/kowloon_junction/interior/arcade
	name = "Kowloon Junction - Arcade"
	area_blurb = "The deafening avalanche of arcade and slot machines begging for your attention fill the air, all promising fantastic gaming experiences for fun and prizes."
	area_blurb_category = "kowloon_arcade"

/area/kowloon_junction/interior/public_bathroom
	name = "Kowloon Junction - Public Bathroom"
	icon_state = "toilet"
	area_blurb = "The overpowering smell of disinfectant and generic soap sting the nostrils."
	area_blurb_category = "kowloon_public_bathroom"

/area/kowloon_junction/interior/restaurant_bottom
	name = "Kowloon Junction - UP!Burger Restaurant"
	icon_state = "kitchen"

/area/kowloon_junction/interior/restaurant_top
	name = "Kowloon Junction - UP!Burger Break Room"
	icon_state = "kitchen"

/area/kowloon_junction/interior/shared_warehouse
	name = "Kowloon Junction - Shared Warehouse"
	icon_state = "quartloading"

//Police and such
/area/kowloon_junction/interior/police
	name = "Kowloon Junction - Police Department"
	icon_state = "security"

//Gang areas
/area/kowloon_junction/interior/gang
	name = "Kowloon Junction - Gang Hideout"
	icon_state = "merc"

/area/kowloon_junction/interior/gang/divebar
	name = "Kowloon Junction - Dive Bar"
	icon_state = "bar"
	area_blurb = "The sounds of rap, rock, and jazz float through the air, along with the thick haze of tobacco smoke. \
	The acrid smell of the cigarettes mixes with vapors of sugary drinks and liquor, spilt on the linoleum floors."
	area_blurb_category = "kowloon_divebar"

/area/kowloon_junction/interior/gang/divebar_doors
	name = "Kowloon Junction - Dive Bar Doors"
	icon_state = "bar"

/area/kowloon_junction/interior/gang/gang_topfloor
	name = "Kowloon Junction - Gang Hideout Top Floor"

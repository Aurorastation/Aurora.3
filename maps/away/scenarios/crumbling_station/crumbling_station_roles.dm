// Crew roles - this is the crew of the station.
/singleton/role/crumbling_station
	name = "Crumbling Station Crew"
	desc = "You are a member of the crew of an ancient, struggling commercial station, built deep into an asteroid. You may work loading cargo on and off the shuttles that frequent the installation, as a janitor, in the kitchen as a cook or as a clerk at the commissary. Life here is not easy, but it is all you have. Get by, stay alive, and try to keep your pride."
	outfit = /obj/outfit/admin/generic/crumbling_station_crew

/singleton/role/crumbling_station/engineer
	name = "Crumbling Station Engineer"
	desc = "You are an engineer working at an ancient, struggling commercial station. Your job is to keep the station functioning as well as you can with the limited supplies you have, to operate the station's supermatter reactor, and to operate the station's atmospheric systems. Remember, you can send carbon dioxide into the fuel bay near the docks via atmospherics!"
	outfit = /obj/outfit/admin/generic/crumbling_station_crew/engineer

/singleton/role/crumbling_station/medic
	name = "Crumbling Station Medical Professional"
	desc = "You are a medical professional working at an ancient, struggling commercial station. You may be a doctor, a paramedic, or a nurse, doing what you can with the pigsty of a medical wing you have inherited to keep both your crew and paying visitors as healthy as possible. Remember, you don't work for free."
	outfit = /obj/outfit/admin/generic/crumbling_station_crew/medic

/singleton/role/crumbling_station/security
	name = "Crumbling Station Security Guard"
	desc = "You are a security guard working at an ancient, struggling commercial station. You are trusted by the administrator of the station with access to its bridge, and with the power to enforce their will on the crew. Keep the station profitable, enforce the will of your superior, and keep the peace."
	outfit = /obj/outfit/admin/generic/crumbling_station_crew/highsec/security

/singleton/role/crumbling_station/administrator
	name = "Crumbling Station Administration"
	desc = "You are the administrator of an ancient, struggling commercial station, entrusted with the lives of all aboard. This place, as misbegotten and decrepit as it is, represents your livelihood. Your crew may complain about your management of station resources, or about the force with which you keep the peace, or how you ration their food - it does not matter. Profit is your sole concern."
	outfit = /obj/outfit/admin/generic/crumbling_station_crew/highsec/administrator

// Non-crew roles - these are visitors to the station that may be on one side of the law or the other.
// Probably got onto the station via the shuttle docked in the northwest of the map.
/singleton/role/crumbling_station/legal_visitor
	name = "Crumbling Station Civilian Visitor"
	desc = "You are a visitor to an ancient, struggling commercial station, having boarded on your own ship independently. You keep to the correct side of the law, generally speaking, and you mind your own business - who knows what kind of person passes through places like this?"
	outfit = /obj/outfit/admin/generic/crumbling_station_crew/legal_visitor

/singleton/role/crumbling_station/illegal_visitor
	name = "Crumbling Station Criminal Visitor"
	desc = "You are a visitor to an ancient, struggling commerical station, having found your way onto it by any means imaginable. You identify as an independent soul; you like to find your own way in life, and you'll do anything to keep yourself free. You have contraband on your person - don't be searched, and if anyone threatens you, make them regret the provocation."
	outfit = /obj/outfit/admin/generic/crumbling_station_crew/illegal_visitor

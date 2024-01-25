//Light's Edge sectors
/datum/space_sector/lights_edge//Uses the Weeping Stars attributes since it's neighboring and this is not exactly the void just yet
	name = SECTOR_LIGHTS_EDGE
	description = "Необычное место, почти не заселённое даже в наше время, Конец света был самым удалённым регионом в рамках Юго-Восточной экспансии Альянса. \
	Это место почти не пытались колонизировать до межзвёздной войны, и большая часть попыток в любом случае оказывалась неудачей, система Ассунзион, впрочем, \
	является исключением, став одной из самых успешных колоний в регионе. Система названа так из за своего соседа: Моря Лемур, неизученного участка космоса, \
	полностью лишённого звёзд. И Конец Света и Море Лемур являются домом для множестве неизвестных науке феноменов, из за чего, концентрация учёных в этом регионе зашкаливает."
	skybox_icon = "weeping_stars"
	starlight_color = "#615bff"
	starlight_power = 1//slightly darker though for spooky factor
	starlight_range = 2

/datum/space_sector/lemurian_sea//The actual proposed area of void as written. Should be as dark as possible, due to no starlight
	name = SECTOR_LEMURIAN_SEA
	description = "Море Лемур - интересный астрологический феномен: большой участок космоса, полностью лишённый звёзд. Море было открыто совсем недавно, и \
	лишь недавно оно было признано отдельным от Конца Света объектом. В целом, путешественникам не рекомендуется здесь летать: очень многие сообщают о \
	чувстве тревоги во время путешествия в море, а количество пропавших без вести кораблей бьёт любые рекорды."
	skybox_icon = "void"//its just black
	possible_exoplanets = null//nothing should be here
	starlight_color = "#000000"
	starlight_power = 0
	starlight_range = 0

//Comments contain criteria for whatever these sectors literally define, for future-proofing and consistency
//Generic sectors are generic intermediate areas for when we can't attribute locale to anywhere in specific
//Tau ceti sectors
#define SECTOR_ROMANOVICH			"Облако Романовича"	//The fat cloud of rocks surrounding Tau Ceti and its gravity well
#define SECTOR_TAU_CETI				"Тау Кита"			//Tau Ceti and its gravity well, Biesel and its subfactions are found here
#define SECTOR_CORP_ZONE			"Корпоративная Зона Восстановления"	//The entire corporate reconstruction zone borders
#define ALL_TAU_CETI_SECTORS		list(SECTOR_ROMANOVICH, SECTOR_TAU_CETI, SECTOR_CORP_ZONE)

//Badlands sectors, at least six factions are here so its noteworthy
#define SECTOR_VALLEY_HALE			"Долина Гейля"	//Generic sector but is also used for the entire Elyran territory
#define SECTOR_BADLANDS				"Дикий Космос"		//Generic sector
//Elyran sectors
#define SECTOR_NEW_ANKARA			"Ново-Анкара"	//New Ankara and its gravity well, Persepolis and New Suez are found here
#define SECTOR_AEMAQ				"Аль-Ваквак"		//al-Wakwak and its gravity well, Aemaqq is found here
//Tajaran and Unathi sectors
#define SECTOR_SRANDMARR			"С'ранд'марр"	//S'r'and'marr and its gravity well, Adhomai and Raskara are found here
#define SECTOR_NRRAHRAHUL			"Нррахрахул"	//Nrrahrahul and its gravity well, Hro'zamal is found here
#define SECTOR_GAKAL				"Гакал"			//Gakal and its gravity well, Gakal'zaal is found here.
#define SECTOR_UUEOAESA				"Уоэуэ-Эса"		//Uueoa-Esa and its gravity well, Moghes and Ouerea are found here.
#define ALL_BADLAND_SECTORS		list(SECTOR_VALLEY_HALE, SECTOR_BADLANDS, SECTOR_NEW_ANKARA, SECTOR_AEMAQ, SECTOR_SRANDMARR, SECTOR_NRRAHRAHUL, SECTOR_GAKAL, SECTOR_UUEOAESA)

//Coalition-aligned sectors
#define SECTOR_COALITION			"Коалиция Колоний"	//For if we want to specify coalition assets, but not focused on a particular planet
#define SECTOR_WEEPING_STARS		"Рыдающие Звёзды"		//Generic sector
#define SECTOR_ARUSHA				"Аруша"			//Generic sector
#define SECTOR_LIBERTYS_CRADLE		"Колыбель Свободы"	//Generic sector
#define SECTOR_BURZSIA				"Бурзсия" 			//Burzsia I and II are here
#define SECTOR_HANEUNIM				"Ганеуним"			//Haneunim and its gravity well, Konyang is found here
#define ALL_COALITION_SECTORS	list(SECTOR_COALITION, SECTOR_WEEPING_STARS, SECTOR_ARUSHA, SECTOR_LIBERTYS_CRADLE, SECTOR_BURZSIA, SECTOR_HANEUNIM)

//Light's edge, which should have unique properties all around
#define SECTOR_LIGHTS_EDGE			"Конец Света"	//For the area of Light's Edge that is somewhat inhabited
#define SECTOR_LEMURIAN_SEA			"Море Лемур"	//For the actual black void area
#define ALL_VOID_SECTORS		list(SECTOR_LIGHTS_EDGE, SECTOR_LEMURIAN_SEA)

//Generic sectors, particularly ones that can be seen regardless of region the ship is in
#define SECTOR_STAR_NURSERY			"Звёздная Колыбель"	//Used by the idris cruise map
#define SECTOR_GENERIC				"Непримечательный Сектор"
#define ALL_GENERIC_SECTORS		list(SECTOR_STAR_NURSERY, SECTOR_GENERIC)

//For sectors where corporate entities can or should appear. Corporate ships having this tag can be seen more reliably
#define ALL_CORPORATE_SECTORS	list(ALL_TAU_CETI_SECTORS, SECTOR_SRANDMARR, SECTOR_UUEOAESA, ALL_COALITION_SECTORS, ALL_GENERIC_SECTORS, SECTOR_GAKAL, SECTOR_NRRAHRAHUL, SECTOR_BADLANDS)//Currently excludes Elyran sectors and Light's Edge

//For highly dangerous sectors with high piracy. Civilian and leisure ships should be less common or not found here.
#define ALL_DANGEROUS_SECTORS	list(SECTOR_BADLANDS, ALL_VOID_SECTORS)

#define ALL_POSSIBLE_SECTORS	list(ALL_TAU_CETI_SECTORS, ALL_BADLAND_SECTORS, ALL_COALITION_SECTORS, ALL_VOID_SECTORS, ALL_GENERIC_SECTORS, ALL_CORPORATE_SECTORS)

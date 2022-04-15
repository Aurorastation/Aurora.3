#define RELIGIONS_SOLARIAN list(RELIGION_CHRISTIANITY, RELIGION_ISLAM, RELIGION_BUDDHISM, RELIGION_HINDU, RELIGION_TAOISM, RELIGION_JUDAISM, RELIGION_OTHER)
#define CITIZENSHIPS_SOLARIAN list(CITIZENSHIP_SOL, CITIZENSHIP_BIESEL, CITIZENSHIP_ERIDANI, CITIZENSHIP_COALITION)

/decl/origin_item/culture/solarian
	name = "Solarian"
	desc = "YOU ARE RACIST AS FUCK PLACEHOLDER PLACEHOLDER YELL AT MATT IF THIS SOMEHOW GETS ON LIVE"
	possible_origins = list(
		/decl/origin_item/origin/sol_system,
		/decl/origin_item/origin/earth,
		/decl/origin_item/origin/venus,
		/decl/origin_item/origin/mars, 
		/decl/origin_item/origin/jupiter,
		/decl/origin_item/origin/pluto
	)

/decl/origin_item/origin/sol_system
	name = "Sol System"
	desc = "The cradle of humanity itself, the Sol System stands above most other systems in terms of its quality of life, wealth, influence, and population. \
			Undisputedly controlled by the Solarian Alliance, the Sol System will likely remain the unofficial capital for centuries to come."
	possible_accents = list(ACCENT_SOL)
	possible_citizenships = CITIZENSHIPS_SOLARIAN
	possible_religions = RELIGIONS_SOLARIAN

/decl/origin_item/origin/earth
	name = "Earth"
	desc = "Perhaps the single most important planet in the Orion Spur, Earth is the homeworld of humanity. Most megacorporations originated on Earth, and many still operate from it. Expensive climate restoration efforts undertaken by the Solarian Alliance in cooperation with Zeng-Hu Pharmaceuticals have restored much of Earth’s climate, though the scars of humanity’s industrialization can still be seen across its surface."
	possible_accents = list(ACCENT_EARTH)
	possible_citizenships = CITIZENSHIPS_SOLARIAN
	possible_religions = RELIGIONS_SOLARIAN

/decl/origin_item/origin/venus
	name = "Venus"
	desc = "Venus is the cultural capital of the Alliance, and its residents mostly dwell in floating settlements referred to as “aerostats.” While wealthy and culturally rich, Venus is deeply divided between Cythereans, those involved in the cultural industry, and Jintarians, those involved in other industries. Cytherean culture is well known throughout the Orion Spur, and is typically stereotyped as hedonistic."
	possible_accents = list(ACCENT_VENUS, ACCENT_VENUSJIN)
	possible_citizenships = CITIZENSHIPS_SOLARIAN
	possible_religions = RELIGIONS_SOLARIAN

/decl/origin_item/origin/mars
	name = "Mars"
	desc = "Martians as a people have suffered grievously throughout their history. Most recently the 2462 Violet Dawn catastrophe rendered much of their planet uninhabitable, and placed much of the rest on the brink of collapse. As a result many Martians can be found abroad, and many Solarian planets have recently gained significant refugee populations of Martians."
	possible_accents = list(ACCENT_MARTIAN)
	possible_citizenships = list(CITIZENSHIP_SOL, CITIZENSHIP_BIESEL, CITIZENSHIP_COALITION)
	possible_religions = RELIGIONS_SOLARIAN

/decl/origin_item/origin/jupiter
	name = "Jupiter"
	desc = "The three major inhabited moons of Jupiter - Callisto, Ganymede, and Europa - are key Solarian worlds. Callisto serves as a major port for the Alliance, Ganymede produces much of the food the Alliance consumes, and Europa is a major research hub. The Jovian Moons are home to a remarkable diversity of humanity, and humans from almost anywhere in the Orion Spur can be found in their ports."
	possible_accents = list(ACCENT_JUPITER, ACCENT_EUROPA)
	possible_citizenships = CITIZENSHIPS_SOLARIAN
	possible_religions = RELIGIONS_SOLARIAN

/decl/origin_item/origin/pluto
	name = "Pluto"
	desc = "One of the last bodies in the Sol System to be colonized, Pluto's economy is centered around Helium-3 mining and refinement. Originally colonized by the Union of Soviet Socialist Republics, Pluto has retained much of its Soviet-bloc influences up to the present day. Going abroad from Pluto is often a slow process: one must either navigate the Party bureaucracy that defines much of life on the planet, or enter (and win) the Party's labour lottery."
	important_information = "Pluto's unique status as a colony established by the USSR and its unique system of government that is distrustful of outsiders from \"corporate influenced,\" places, characters born on Pluto will have names and appearances characteristic of the peoples native to the Eastern European or Baltic republics in the USSR, Russia, the Caucasus Mountains, or Central Asia. Only native Plutonians may select the Plutonian accent. This is enforceable by server moderators and admins."
	possible_accents = list(ACCENT_PLUTO)
	possible_citizenships = CITIZENSHIPS_SOLARIAN
	possible_religions = RELIGIONS_SOLARIAN
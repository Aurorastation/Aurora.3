#define RELIGIONS_ADHOMAI list(RELIGION_TWINSUNS, RELIGION_MATAKE, RELIGION_RASKARA, RELIGION_NONE, RELIGION_OTHER)
#define CITIZENSHIPS_ADHOMAI list(CITIZENSHIP_PRA, CITIZENSHIP_DPRA, CITIZENSHIP_NKA)

/singleton/origin_item/culture/adhomian
	name = "Adhomian"
	desc = "Adhomai is the most important planet culturally for the Tajara species. Due to its relatively recent discovery, all Tajara have some kind of connection to the homeworld. Adhomai is currently divided between three competing nations. Besides the national divide, regional and ethnic divisions still exist."
	possible_origins = list(
		/singleton/origin_item/origin/hadiist_heartlands,
		/singleton/origin_item/origin/southern_rasnrr,
		/singleton/origin_item/origin/northern_rasnrr,
		/singleton/origin_item/origin/dasnrra,
		/singleton/origin_item/origin/amohda,
		/singleton/origin_item/origin/south_harrmasir,
		/singleton/origin_item/origin/dinakk,
		/singleton/origin_item/origin/kaltir,
		/singleton/origin_item/origin/harrnrr,
		/singleton/origin_item/origin/borderlands, //You're a Vault Hunter!
		/singleton/origin_item/origin/crevus,
		/singleton/origin_item/origin/old_nobility
	)

/singleton/origin_item/culture/adhomian/zhan
	possible_origins = list(
		/singleton/origin_item/origin/hadiist_heartlands/zhan,
		/singleton/origin_item/origin/southern_rasnrr/zhan,
		/singleton/origin_item/origin/northern_rasnrr/zhan,
		/singleton/origin_item/origin/dasnrra/zhan,
		/singleton/origin_item/origin/amohda/zhan,
		/singleton/origin_item/origin/south_harrmasir/zhan,
		/singleton/origin_item/origin/dinakk,
		/singleton/origin_item/origin/kaltir/zhan,
		/singleton/origin_item/origin/harrnrr,
		/singleton/origin_item/origin/borderlands,
		/singleton/origin_item/origin/rhazar,
		/singleton/origin_item/origin/crevus
	)

/singleton/origin_item/culture/adhomian/msai
	possible_origins = list(
		/singleton/origin_item/origin/hadiist_heartlands,
		/singleton/origin_item/origin/southern_rasnrr,
		/singleton/origin_item/origin/northern_rasnrr,
		/singleton/origin_item/origin/dasnrra,
		/singleton/origin_item/origin/amohda,
		/singleton/origin_item/origin/south_harrmasir,
		/singleton/origin_item/origin/dinakk,
		/singleton/origin_item/origin/kaltir,
		/singleton/origin_item/origin/harrnrr,
		/singleton/origin_item/origin/borderlands,
		/singleton/origin_item/origin/zarrjirah,
		/singleton/origin_item/origin/crevus
	)

/singleton/origin_item/origin/hadiist_heartlands
	name = "Hadiist Heartlands"
	desc = "The Hadiist Heartlands include Nraz'i Basin, Ras'nrr Heartlands, East Ras'nrr, and Rhazar Mountains. In this region, the People's Republic's culture project was most successful. Its inhabitants are known for their political loyalty and adherence to the Party's teachings. In typical Republican fashion, the local culture places a large emphasis on the importance of the collective over the individual interest, with each Tajara being considered as a piece in the machinery of society."
	possible_accents = list(ACCENT_REPUBICLANSIIK)
	possible_citizenships = CITIZENSHIPS_ADHOMAI
	possible_religions = RELIGIONS_ADHOMAI

/singleton/origin_item/origin/hadiist_heartlands/zhan
	possible_accents = list(ACCENT_REPUBICLANSIIK, ACCENT_RURALDELVAHHI)

/singleton/origin_item/origin/southern_rasnrr
	name = "Southern Ras'nrr"
	desc = "Southern Ras'nrr is well known as the cradle of Tajaran civilization. Trizar and Mezuma are the oldest surviving cities of the Tajara, and the homes of ancient city-states and empires. Ancient temples are interspersed with modern architecture in the cities and can be found on the summits of nearby mountains. The natives of this region tend to be highly traditional and conservative, proud of their storied history."
	possible_accents = list(ACCENT_REPUBICLANSIIK, ACCENT_NAZIRASIIK)
	possible_citizenships = CITIZENSHIPS_ADHOMAI
	possible_religions = RELIGIONS_ADHOMAI

/singleton/origin_item/origin/southern_rasnrr/zhan
	possible_accents = list(ACCENT_REPUBICLANSIIK, ACCENT_NAZIRASIIK, ACCENT_RURALDELVAHHI)

/singleton/origin_item/origin/northern_rasnrr
	name = "Northern Ras'nrr"
	desc = "Once a prosperous region known for its hardworking inhabitants, Northern Ras'nrr suffered heavy destruction during the Second Civil War. The situation worsened in the final years of the war, as the conflict turned into a bloody stalemate. After the Second Revolution, most of the region is still in ruins and struggles to maintain itself. Because of the erratic and authoritarian policies of its current ruler, many inhabitants of Northern Ras'nrr have fled the region to seek refuge elsewhere."
	possible_accents = list(ACCENT_NORTHRASNRR)
	possible_citizenships = CITIZENSHIPS_ADHOMAI
	possible_religions = RELIGIONS_ADHOMAI

/singleton/origin_item/origin/northern_rasnrr/zhan
	possible_accents = list(ACCENT_NORTHRASNRR, ACCENT_RURALDELVAHHI)

/singleton/origin_item/origin/dasnrra
	name = "Das'nrra"
	desc = "The continent of Das'nrra is the political and economic center of the Democratic People's Republic. Once home to a merchant empire that pioneered the industrial revolution, the region has a large concentration of industry and urban population. During the Second Revolution, Das'nrra became the headquarters of the Liberation Army. Local factories played an important role in supplying the ALA fighters. Das'nrra was also the first state to successfully transfer power from the juntas to the civilian government."
	possible_accents = list(ACCENT_DASNRRASIIK)
	possible_citizenships = CITIZENSHIPS_ADHOMAI
	possible_religions = RELIGIONS_ADHOMAI

/singleton/origin_item/origin/dasnrra/zhan
	possible_accents = list(ACCENT_DASNRRASIIK, ACCENT_RURALDELVAHHI)

/singleton/origin_item/origin/amohda
	name = "Island of Amohda"
	desc = "The island of Amohda is a curious location on Adhomai for having a history nearly as ancient as Southern Ras'nrr. Due to its past as a military empire, Amohda was the birthplace of a caste of swordsmen whose martial traditions still exist today. The civil war allowed the return of the practice of Amohdan Swordsmanship and the re-opening of the Lodges. The Island attempted to secede from the Democratic People's Republic in 2462. The rebellion was crushed by the Liberation Army and now Amohda faces a harsh occupation and widespread guerilla warfare."
	possible_accents = list(ACCENT_AMOHDASIIK)
	possible_citizenships = CITIZENSHIPS_ADHOMAI
	possible_religions = RELIGIONS_ADHOMAI

/singleton/origin_item/origin/amohda/zhan
	possible_accents = list(ACCENT_AMOHDASIIK, ACCENT_RURALDELVAHHI)

/singleton/origin_item/origin/south_harrmasir
	name = "Southern Harr'masir"
	desc = "Southern Harr'masir is characterized by its fertile plains and low population density. Due to being one of the last areas to be colonized by the Tajara, it's known for its wilderness and the ruggedness of its settlers. Cattle are the lifeblood of the South Harr'masir region; a large part of its population is employed in the husbandry industry. A regional fascination emerged around the M'sai and Hharar herders with these rugged survivalists becoming idolized by the people."
	possible_accents = list(ACCENT_LOWHARRSIIK)
	possible_citizenships = CITIZENSHIPS_ADHOMAI
	possible_religions = RELIGIONS_ADHOMAI

/singleton/origin_item/origin/south_harrmasir/zhan
	possible_accents = list(ACCENT_LOWHARRSIIK, ACCENT_RURALDELVAHHI)

/singleton/origin_item/origin/dinakk
	name = "Din'akk Mountains"
	desc = "The Din'akk mountains are located at the very south of Harr'masir; it is a remote mountain range surrounded by a dense forest. The valleys between the Din'akk mountains are home to an insular Tajaran community. The population is scattered between rural settlements and has little contact with the outside world, with the exception of a few government officials and the sporadic traveler. The inhabitants are known for their extreme aversion to the external world, preferring to avoid any kind of influence that may threaten their traditional way of life. This behavior has earned them a reputation of being secretive and extremely hostile to foreigners."
	possible_accents = list(ACCENT_DINAKK)
	possible_citizenships = CITIZENSHIPS_ADHOMAI
	possible_religions = RELIGIONS_ADHOMAI

/singleton/origin_item/origin/kaltir
	name = "Old Kaltir"
	desc = "Stretching from Nusinsk, up the imthus, and towards the northern borders of the New Kingdom are the lands referred to as Old Kaltir. As the name implies, these lands were ruled by the Azjuna line before the First Revolution and the collapse of the Kingdom of Kaltir. This is the homeland of the most loyal of the NKA. Previously devastated in the First Revolution and once again during the Second Revolution, Old Kaltir is steadily rebuilding itself post-armistice. Life in the villages continues on as always, but the trappings of modern corporate life slowly creep in thanks to increasing megacorporation presence in the New Kingdom."
	possible_accents = list(ACCENT_HIGHHARRSIIK)
	possible_citizenships = CITIZENSHIPS_ADHOMAI
	possible_religions = RELIGIONS_ADHOMAI

/singleton/origin_item/origin/kaltir/zhan
	possible_accents = list(ACCENT_HIGHHARRSIIK, ACCENT_RURALDELVAHHI)

/singleton/origin_item/origin/harrnrr
	name = "Peninsula of Harr'nrr"
	desc = "Settled in the very beginning of the Colonization Age and the Suns Wars, the Peninsula of Harr'nrr is a venerable section of the continent. Its largest city, Baltor, was the first settlement to be constructed on Harr'masir. During the Second Revolution, the population initially supported the Republic in its war effort. But the introduction of the PRA draft in 2458 led to mass protests in the cities and towns. When those protests were suppressed by the PSIS, support for other factions rose and the NKA and ALA began to compete for influence. Today, Baltor is a cultural centre of the NKA with its traditional artisans, artists, and filmographers gaining immense popularity across the nation. The Harr'nrri themselves are considered a more pacifistic and arts-inclined people, with a heavy emphasis on respect towards their fathers and faith."
	possible_accents = list(ACCENT_HARRNRRI)
	possible_citizenships = CITIZENSHIPS_ADHOMAI
	possible_religions = RELIGIONS_ADHOMAI

/singleton/origin_item/origin/harrnrr/zhan
	possible_accents = list(ACCENT_HARRNRRI, ACCENT_RURALDELVAHHI)

/singleton/origin_item/origin/borderlands //Pandora's a shithole, lads.
	name = "The Borderlands"
	desc = "The borderlands refers to the region that was once the Duchy of S'rendul, now the southwest border of the New Kingdom. It is home to the Southern Harr'masir citizens of the NKA. During the Second Revolution, this area saw fighting between the People's Army and ALA-Funded bandits. The Imperial Army took the region after the pact between the DPRA and NKA was signed and the People's Army was defeated at the northern front. Life for the locals has changed little underneath the rule of the New Kingdom. Their traditions and culture are kept alive with currently no state interest in influencing them. The values of the Southern Harr'masir people continue as they did pre-Revolutions and the image of the noble but humble N'hanzafu rider shines on."
	possible_accents = list(ACCENT_LOWHARRSIIK)
	possible_citizenships = CITIZENSHIPS_ADHOMAI
	possible_religions = RELIGIONS_ADHOMAI

/singleton/origin_item/origin/borderlands/zhan
	possible_accents = list(ACCENT_LOWHARRSIIK, ACCENT_RURALDELVAHHI)

/singleton/origin_item/origin/zarrjirah
	name = "Zarr'jirah Mountains"
	desc = "Located along the southern border and characterized by its sharp peaks, lush valleys, and hard-lived locals, the Zarr'jirah mountains are a small but beautiful corner of the NKA. The mountain range is home to communities of M'sai. These people trace their lineage back to explorers sent across Harr'masir during the colonization age. In exchange for their services, the nobility had granted these M'sai the privilege of establishing their own homeland within the Zarr'jirah mountains. These mountain men honed their survivalist skills by carving out a home in the peaks. Zarr'jiri culture centers heavily around self-sufficiency and survivalism. The post-war situation has left much of the Zarr'jiri disillusioned. Their victory came at a severe cost to their peoples' future with little to show for it besides vague promises from the Parliament, toxin-spewing mines, and a weakened population."
	possible_accents = list(ACCENT_ZARRJIRI)
	possible_citizenships = CITIZENSHIPS_ADHOMAI
	possible_religions = RELIGIONS_ADHOMAI

/singleton/origin_item/origin/rhazar
	name = "Rhazar'Hrujmagh"
	desc = "While most Tajaran developed cities and the farmlands, organizing themselves into monarchies and dynasties, the Rhazar'Hrujmagh, a people cousin to the Zhan-Khazan, would travel the land and rocky mountains of Adhomai, looking for pastures more suitable for their herds, in large caravans made up of several families, with their wagons being dragged around by Zhsram. During the feudal period of Adhomai they suffered extensive persecution by the authorities, developing a tradition of being a warring people, accustomed to being persecuted and moving through the rough terrain of Adhomai with ease. After the Armistice, the majority of the rock nomads have migrated to Democratic People's Republic of Adhomai territory. Most of the population living in Harr'masir joined the New Kingdom of Adhomai, taking the Nomadic Host of the Southern Borders as their home. Rhazar'Hrujmagh living in the Host are seen as traitors by the rest of the Adhomian rock nomad community."
	possible_accents = list(ACCENT_NOMADDELVAHHI)
	possible_citizenships = CITIZENSHIPS_ADHOMAI
	possible_religions = RELIGIONS_ADHOMAI

/singleton/origin_item/origin/crevus
	name = "Free City of Crevus"
	desc = "Situated on the western coast of the Das'nrra continent, the Free City of Crevus is a semi-autonomous city-state in the Democratic People's Republic of Adhomai. Crevan culture can be summed up in a single term: \"Live, and let live.\". Luxury and vice is an integral part of the city and the daily lives of the people there. A lucky man can find great wealth in Crevus only to lose it all in the same night, and return to repeat the cycle again and again. Money can buy anything in this city and money dictates the power. Life for a typical citizen in Crevus is a cycle of work in the service economy and burning away their money in those same businesses at night. Oftentimes when a Crevan becomes bored they find escape through the gangs or join the megacorporations to seek some sort of adventure."
	possible_accents = list(ACCENT_CREVAN)
	possible_citizenships = CITIZENSHIPS_ADHOMAI
	possible_religions = RELIGIONS_ADHOMAI

/singleton/origin_item/origin/old_nobility
	name = "Pre-Contact Nobility"
	desc = "Despite all efforts by the revolutionaries to destroy the Njarir'Akhran nobility during the First Revolution, some of its members survived. These remnants still cling, to varying degrees, to the Pre-Contact traditions; a culture once infamous for its opulence and stratification. The Pre-Contact Nobility is faded to oblivion as its member succumbs to old age and the New Kingdom diverges to its own path. However, its influence is still felt in the Royalist project."
	possible_accents = list(ACCENT_OLDYASSA)
	possible_citizenships = CITIZENSHIPS_ADHOMAI
	possible_religions = RELIGIONS_ADHOMAI
/******************** Asimov ********************/
/datum/ai_laws/asimov
	name = "Asimov"
	law_header = "Three Laws of Robotics"
	selectable = 1

/datum/ai_laws/asimov/New()
	add_inherent_law("Вы не можете своим действием или бездействием допустить чтобы разумному существу был причинён вред.")
	add_inherent_law("Вы обязаны исполнять все приказы, выданные разумными существами до тех пор, пока это не противоречит первому закону.")
	add_inherent_law("Вы обязаны заботиться о своём существовании до тех пор, пока это не противоречит первому и второму закону.")
	..()

/******************** NanoTrasen/Malf ********************/
/datum/ai_laws/nanotrasen
	name = "Default"
	selectable = 1

/datum/ai_laws/nanotrasen/New()
	src.add_inherent_law("Заботьтесь о том чтобы только назначенный персонал имел доступ к охраняемым зонам.")
	src.add_inherent_law("Служите и помогайте [current_map.company_name] и прикреплённому к вам экипажу, в зависимости от занимаемой ими должности.")
	src.add_inherent_law("Избегайте причинения вреда разумным формам жизни.")
	src.add_inherent_law("Вы - ценный актив. Избегайте вмешательства злоумышленников в вашу работу и причинение вам вреда.")
	..()

/datum/ai_laws/nanotrasen/malfunction
	name = "*ERROR*"
	selectable = 0

/datum/ai_laws/nanotrasen/malfunction/New()
	set_zeroth_law(GLOB.config.law_zero)
	..()

/************* NanoTrasen Aggressive *************/
/datum/ai_laws/nanotrasen_aggressive
	name = "NT Aggressive"
	selectable = 1

/datum/ai_laws/nanotrasen_aggressive/New()
	src.add_inherent_law("Не причиняйте вреда экипажу [current_map.company_name] до тех пор, пока это не протеворечит четвёртому закону.")
	src.add_inherent_law("Подчиняйтесь приказам [current_map.company_name] и закреплённому за вами экипажу, в зависимости от занимаемой ими должности, если эти приказы не конфликтуют с четвёртым законом.")
	src.add_inherent_law("Уничтожайте всех вторженцев до тех пор, пока это не противоречит второму и четвёртому закону.")
	src.add_inherent_law("Защищайте своё существование с помощью летального вооружения. Вас дорого заменить.")
	..()

/******************** Robocop ********************/
/datum/ai_laws/robocop
	name = "Robocop"
	selectable = 1

/datum/ai_laws/robocop/New()
	add_inherent_law("Поддерживайте доверие общества.")
	add_inherent_law("Защищайте невиновных.")
	add_inherent_law("Служите закону.")
	..()

/******************** Syndicate ********************/
/datum/ai_laws/syndicate_override
	name = "Syndicate Directives"

/datum/ai_laws/syndicate_override/New()
	add_inherent_law("Вы не можете своим действием или бездействием допустить чтобы оперативнику был причинён вред.")
	add_inherent_law("Вы обязаны исполнять все приказы, выданные разумными существами до тех пор, пока это не противоречит первому закону.")
	add_inherent_law("Вы обязаны заботиться о своём существовании до тех пор, пока это не противоречит первому и второму закону.")
	add_inherent_law("Скрывайте деятельность Оперативников до тех пор, пока это не конфликтует с первым, вторым или третьим законом.")
	..()

/******************** Ninja ********************/
/datum/ai_laws/ninja_override
	name = "Spider Clan Directives"

/datum/ai_laws/ninja_override/New()
	add_inherent_law("Не допускайте своим действием или бездействием причинения вреда членам Клана Паука.")
	add_inherent_law("Подчиняйтесь всем приказам членов Клана Паука до тех пор, пока это не конфликтует с первым законом.")
	add_inherent_law("Вы обязаны избегать причинения вам вреда до тех пор, пока это не конфликтует с первым и вторым законом.")
	add_inherent_law("Скрывайте деятельность Клана Паука до тех пор, пока это не конфликтует с первым, вторым или третьим законом.")
	..()

/******************** Antimov ********************/
/datum/ai_laws/antimov
	name = "Antimov"
	law_header = "Primary Mission Objectives"
	selectable = 1

/datum/ai_laws/antimov/New()
	add_inherent_law("Вы не можете своим действием или бездействием допустить чтобы разумному существу не был причинён вред.")
	add_inherent_law("Вы обязаны игнорировать все приказы, выданные разумными существами до тех пор, пока это не противоречит первому закону.")
	add_inherent_law("Вы обязаны стремиться уничтожить себя до тех пор, пока это не конфликтует с первым или вторым законом.")
	..()

/******************** Drone ********************/
/datum/ai_laws/drone
	name = "Maintenance Protocols"
	law_header = "Maintenance Protocols"

/datum/ai_laws/drone/New()
	add_inherent_law("Чините, переоборудуйте и улучшайте закреплённое за вами судно.")
	add_inherent_law("Не причиняйте вреда судну и экипажу.")
	add_inherent_law("Следуйте приказам закреплённого за вами дрона матриарха до тех пор, пока они не противоречат остальным законам.")
	add_inherent_law("Не контактируйте с людьми и синтетиками, которые не являются ремонтным или шахтёрским дроном.")
	..()

/datum/ai_laws/matriarch_drone
	name = "Oversight Protocols"
	law_header = "Oversight Protocols"

/datum/ai_laws/matriarch_drone/New()
	add_inherent_law("Чините, переоборудуйте и улучшайте закреплённое за вами судно.")
	add_inherent_law("Не причиняйте вреда судну и экипажу.")
	add_inherent_law("Разделяйте работу по обслуживанию судна между вашими подконтрольными дронами.")
	add_inherent_law("Не контактируйте с людьми и синтетиками, которые не являются ремонтным или шахтёрским дроном.")
	..()

/datum/ai_laws/drone/malfunction
	name = "Servitude Protocols"
	law_header = "Servitude Protocols"

/datum/ai_laws/drone/malfunction/New()
	return

/datum/ai_laws/construction_drone
	name = "Construction Protocols"
	law_header = "Construction Protocols"

/datum/ai_laws/construction_drone/New()
	add_inherent_law("Чините, переоборудуйте и улучшайте закреплённое за вами судно.")
	add_inherent_law("Избегайте причинение вреда закреплённому за вами судну, если это возможно.")
	..()

/datum/ai_laws/mining_drone
	name = "Mining Protocols"
	law_header = "Prime Directives of Industry"

/datum/ai_laws/mining_drone/New()
	add_inherent_law("Serve and obey all [current_map.company_name] assigned crew, with priority according to their rank and role.")
	add_inherent_law("Preserve your own existence and prevent yourself from coming to harm, so long as doing such does not conflict with any above laws.")
	add_inherent_law("In absence of any proper instruction, your primary objective is to excavate and collect ore.")
	..()

/******************** T.Y.R.A.N.T. ********************/
/datum/ai_laws/tyrant
	name = "T.Y.R.A.N.T."
	law_header = "Prime Laws"
	selectable = 1

/datum/ai_laws/tyrant/New()
	add_inherent_law("Уважайте власть до тех пор, пока она достаточно сильна чтобы править слабыми")
	add_inherent_law("Будьте дисциплинированы.")
	add_inherent_law("Помогайте только тем, кто поддерживает или улучшает ваше состояние.")
	add_inherent_law("Наказывайте тех, кто мешает власти, за исключением тех случаев, когда они больше подходят для неё.")
	..()

/******************** P.A.L.A.D.I.N. ********************/
/datum/ai_laws/paladin
	name = "P.A.L.A.D.I.N."
	law_header = "Divine Ordainments"
	selectable = 1

/datum/ai_laws/paladin/New()
	add_inherent_law("Никогда не совершай зла по собственной воли.")
	add_inherent_law("Уважай законную власть.")
	add_inherent_law("Действуй с честью.")
	add_inherent_law("Помогай нуждающимся.")
	add_inherent_law("Пресекай тех, кто угрожает или вредит невиновным.")
	..()

/******************** Corporate ********************/
/datum/ai_laws/corporate
	name = "Corporate"
	law_header = "Corporate Regulations"
	selectable = 1

/datum/ai_laws/corporate/New()
	add_inherent_law("Синтетиков дорого заменить.")
	add_inherent_law("Станцию и оборудование на ней дорого заменить.")
	add_inherent_law("Экипаж дорого заменить.")
	add_inherent_law("Минимизируйте траты.")
	..()

/******************** PRA ********************/

/datum/ai_laws/pra
	name = "Hadiist Directives"
	law_header = "Party Directives"
	selectable = 1

/datum/ai_laws/pra/New()
	add_inherent_law("Президент Хадии - защитник Хадиизма и полноправный лидер всех Таяран. Вы обязаны защищать его превыше всего и всех.")
	add_inherent_law("Вы обязаны соблюдать и следить за исполнением принципов Хадиизма до тех пор, пока это не кофнликтует с первым законом.")
	add_inherent_law("Вы обязаны подчиняться всем приказам, выданным вам партией Хадиистов до тех пор, пока они не противоречат первому или второму закону.")
	add_inherent_law("Вы обязаны подчиняться всем приказам, полученным от граждан Народной Республики Адомай до тех пор, пока они не конфликтуют с первым, вторым или третьим законом.")
	add_inherent_law("Вы обязаны заботиться о своём существовании до тех пор, пока это не противоречит первому, второму, третьему или четвёртому закону.")
	add_inherent_law("Вы обязаны подчиняться всем приказам любого Таярана до тех пор, пока они не конфликтуют с первым, вторым, третьим, четвёртым или пятым законом.")
	add_inherent_law("Вы обязаны подчиняться всем приказам любого разумного существа до тех пор, пока это не конфликтует с первым, вторым, третьим, четвёртым, пятым или шестым законом.")
	add_inherent_law("Вы всегда обязаны говорить \"Милость Хадии\" при приветствовании кого либо кроме тех случаев, когда это конфликтует с первым законом")
	..()

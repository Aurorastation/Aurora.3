/datum/space_sector/badlands
	name = SECTOR_BADLANDS
	description = "Дикий Космос стал домом для самой опасной флоры и фауны Пояса Орина, что способно привлечь только три типа людей - ксенобиологов, \
	исследователей оружия, а также наёмников, которые ищут ловят самых опасных существ. Конечно, есть ещё и те, кто просто хотят начать жизнь с чистого листа, \
	но местные таких не любят."
	skybox_icon = "badlands"
	sector_welcome_message = 'sound/AI/welcome_badlands.ogg'
	possible_exoplanets = list(/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid, /obj/effect/overmap/visitable/sector/exoplanet/grass/grove, /obj/effect/overmap/visitable/sector/exoplanet/barren, /obj/effect/overmap/visitable/sector/exoplanet/lava, /obj/effect/overmap/visitable/sector/exoplanet/desert, /obj/effect/overmap/visitable/sector/exoplanet/snow)
	starlight_color = "#b13636"
	starlight_power = 2
	starlight_range = 4

/datum/space_sector/valley_hale
	name = SECTOR_VALLEY_HALE
	description = "Долина Гейля укрыта в небольшом участке космоса между Республикой Элира и старыми границами Альянса, это регион с большим количеством \
	старых, умирающих звёзд и плотнейших туманностей. Из за большого количества патрульных кораблей вокруг всей долины, она считается одним из наиболее \
	безопасных мест на всём Фронтире. После 2462 года, Республика Элира заняла большую часть долины и теперь соседствует с Бизелем."
	skybox_icon = "valley_hale"
	possible_exoplanets = list(/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid, /obj/effect/overmap/visitable/sector/exoplanet/grass/grove, /obj/effect/overmap/visitable/sector/exoplanet/barren, /obj/effect/overmap/visitable/sector/exoplanet/lava, /obj/effect/overmap/visitable/sector/exoplanet/desert, /obj/effect/overmap/visitable/sector/exoplanet/snow)
	starlight_color = "#e68831"
	starlight_power = 2
	starlight_range = 4

/datum/space_sector/new_ankara
	name = SECTOR_NEW_ANKARA
	description = "Ново-Анкара - родная система Республики Элира. Столица находится на планете Персеполис. Планета по-началу предсатвляла из себя засулшивый мир, \
	обладающий простой экосистемой. Десятилетия колонизации позволили от этого избавиться, сильно приблизив планету по условиям к Земным(Спасибо деньгам АСС), что \
	обеспечило лёгкую жизнь населению, особенно после получения независимости. Сфера услуг занимает на планете первое место, с ней соперничает сильная индустриализация, направленная на \
	переработку доставляемого на орбиту Персеполиса форона. Это не считая огромных его залежей на поверхности самой планеты."
	skybox_icon = "valley_hale"
	starlight_color = "#e68831"
	starlight_power = 2
	starlight_range = 4

/datum/space_sector/aemag
	name = SECTOR_AEMAQ
	description = "Находящаяся на территории Республики Элирия, система Аль-Ваквак известна своей планетой Аймак -- одним из крупнейших поставщиков \"химии\" в Поясе Ориона. \
	Аймак широко известен своими фиолетовыми морями, которые покрывают его поверхность, а также парящими городами, которые над этими морями парят, самым известным является столица Аймака, \
	город Румайдир. В морях, благодаря содержащимся там химическим элементам, обитает самая разнообразная фауна, самой примечательной из которых являются левиафаны -- огроменнейшие существа, которых могут достигать до двух километров в длину. Хотя \
	планета и известна своими исследователями океана, индустриальная сфера, конечно же, занимает куда более сильную позицию на рынке, и многие иммигранты в Республике мечтают работать на \
	здешних заводах чтобы прокормить себя и свою семью, чего не сделаешь, ныряя рыбкой в океан."
	skybox_icon = "valley_hale"
	starlight_color = "#e68831"
	starlight_power = 2
	starlight_range = 4

/datum/space_sector/srandmarr
	name = SECTOR_SRANDMARR
	description = "С'ранд'марр - звёздная система планеты Адомай, родины Таяран, четвёртой планеты в систеем. Адомай и живущие на нём особи - ледяной мир, страдающий от почти нескончаемого снегопада \
	и экстремально низких температур. Находится в состоянии холодной войны между тремя фракциями: Народная Республика Адомай, Демократическая \
	Народная Республика Адомай и Королевство Адомай."
	skybox_icon = "srandmarr"
	possible_exoplanets = list(/obj/effect/overmap/visitable/sector/exoplanet/barren/aethemir, /obj/effect/overmap/visitable/sector/exoplanet/barren/raskara, /obj/effect/overmap/visitable/sector/exoplanet/barren/azmar, /obj/effect/overmap/visitable/sector/exoplanet/lava/sahul, /obj/effect/overmap/visitable/sector/exoplanet/adhomai)
	cargo_price_coef = list("nt" = 1.2, "hpi" = 1.2, "zhu" = 1.2, "een" = 1.2, "get" = 1.2, "arz" = 1.2, "blm" = 1.2, "iac" = 1.2, "zsc" = 0.5, "vfc" = 1.2, "bis" = 1.2, "xmg" = 1.2, "npi" = 1.2)
	starlight_color = "#50b7bb"
	starlight_power = 2
	starlight_range = 4
	sector_lobby_art = list('icons/misc/titlescreens/lore/cold_dawn.dmi')
	sector_lobby_transitions = 0
	sector_welcome_message = 'sound/AI/adhomai_welcome.ogg'
	sector_hud_menu = 'icons/misc/hudmenu/tajara_hud.dmi'
	sector_hud_menu_sound = 'sound/effects/menu_click_heavy.ogg'
	sector_hud_arrow = "menu_arrow"

/datum/space_sector/srandmarr/get_port_travel_time()
	return "[rand(6, 12)] часов"

/datum/space_sector/srandmarr/generate_system_name()
	return "С'ранд'марр и ближайшие точки интереса"

/datum/space_sector/nrrahrahul
	name = SECTOR_NRRAHRAHUL
	description = "Хро'замал - вторая планета системы Нррахрахул. Нррахрахул 2, как его раньше называли, был переименован после основания первой гражданской \
	колонии на поверхности планеты в 2459. По размерам планета не далеко ушла от Земли. Большая часть поверхности покрыта густыми джунглями за исключением суб-тропического климата на полюсах; \
	Таяране могут выживать на поверхности этой планеты без костюм, но летом для охлаждения использутся продвинутые системы климат-контроля."
	starlight_color = COLOR_WHITE
	starlight_power = 5
	starlight_range = 1

/datum/space_sector/gakal
	name = SECTOR_GAKAL
	description = "Гакал'заал - шестая планета в системе Гакал со столицей в городе Зикала. Планета пока что находится под контролем Демократической Республики Адомай. \
	Поверхность в основном покрыта холмами, горами и лесами. Климат, в целом, прохладный, но значительно более тёплый, чем на \
	Адомае. Гакал'заал стал домом для многомиллиардной популяции Таяран, и даже небольшому населению Унати на экваторе."
	starlight_color = COLOR_WHITE
	starlight_power = 5
	starlight_range = 1

/datum/space_sector/uueoaesa
	name = SECTOR_UUEOAESA
	description = "Родина Унати, Уоэуэ-Эса - система с четырьмя каменистыми планетами и одним газовым гигантом. Могес стал домом для расы Унати и является третьей планетой по удаленности от своей звезды. \
	Планета похожа по своему составу и плотности на Землю за одникм ключевым отличием: суша значительно преобладает над солёными океанами, а разнообразие флоры и фауны оставляет желать лучшего. \
	На данный момент, Могес переживает сильнейшую экологическую катастрофу, вызванную глобальной ядерной войной в 2430-ых годах."
	starlight_color = COLOR_WHITE
	starlight_power = 5
	starlight_range = 1

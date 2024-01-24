/datum/space_sector/tau_ceti
	name = SECTOR_TAU_CETI
	description = "Тау Кита - одна из ближайших к Солнцу звёзд, которая служит штабом для Nanotrasen. Тау Кита формально управляется \
	Республикой Бизель, молодым государством, получившем независимость от финансово-нестабильного Альянса Солнечной Системы в 2452, не \
	без помощи Nanotrasen. Альянс всё ещё горюет из за потери такой важной системы, пока корпорация наслаждается почти безграничным над ней контролем."
	cargo_price_coef = list("nt" = 0.8, "hpi" = 0.8, "zhu" = 0.8, "een" = 1, "get" = 0.8, "arz" = 1, "blm" = 1,
								"iac" = 1, "zsc" = 1, "vfc" = 1, "bis" = 0,8, "xmg" = 0.8, "npi" = 0.8)
	possible_exoplanets = list(/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid, /obj/effect/overmap/visitable/sector/exoplanet/barren)
	starlight_color = "#9cd0fd"
	starlight_power = 5
	starlight_range = 2

/datum/space_sector/romanovich
	name = SECTOR_ROMANOVICH
	description = "Облако Романовича - зона скопления металлических, ледяных и каменистых астероидов на большом удалении от Тау Киты. Облако богато ценными \
	металлами, а также радиоактивными элементами, и очевидно, почти всё сырьё, используемое на Тау Ките, родом отсюда. Здесь также находится такое редкое \
	месторождения Форона, загадочного элемента, незаменимого в энергетической промышленности и биохимии. Почти все залежи Форона в облаке находятся под контролем \
	Nanotrasen, которой также принадлежат многие научные базы в этой зоне."
	possible_exoplanets = list(/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid, /obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid/romanovich)
	starlight_color = "#9cd0fd"
	starlight_power = 5
	starlight_range = 2

	meteors_minor = list(
		/obj/effect/meteor/medium     = 80,
		/obj/effect/meteor/dust       = 30,
		/obj/effect/meteor/irradiated = 30,
		/obj/effect/meteor/big        = 30,
		/obj/effect/meteor/flaming    = 10,
		/obj/effect/meteor/golden     = 10,
		/obj/effect/meteor/silver     = 10
		)

	meteors_moderate = list(
		/obj/effect/meteor/medium     = 80,
		/obj/effect/meteor/big        = 30,
		/obj/effect/meteor/dust       = 30,
		/obj/effect/meteor/irradiated = 30,
		/obj/effect/meteor/flaming    = 10,
		/obj/effect/meteor/golden     = 10,
		/obj/effect/meteor/silver     = 10,
		/obj/effect/meteor/emp        = 10
		)

	meteors_major = list(
		/obj/effect/meteor/medium     = 80,
		/obj/effect/meteor/big        = 30,
		/obj/effect/meteor/dust       = 30,
		/obj/effect/meteor/irradiated = 30,
		/obj/effect/meteor/emp        = 30,
		/obj/effect/meteor/flaming    = 10,
		/obj/effect/meteor/golden     = 10,
		/obj/effect/meteor/silver     = 10
		)

	meteors_normal = list(\
		/obj/effect/meteor/medium=8,\
		/obj/effect/meteor/dust=3,\
		/obj/effect/meteor/irradiated=3,\
		/obj/effect/meteor/big=3,\
		/obj/effect/meteor/flaming=1,\
		/obj/effect/meteor/golden=1,\
		/obj/effect/meteor/silver=1\
		)

	meteors_threatening = list(\
		/obj/effect/meteor/big=10,\
		/obj/effect/meteor/medium=5,\
		/obj/effect/meteor/golden=3,\
		/obj/effect/meteor/silver=3,\
		/obj/effect/meteor/flaming=3,\
		/obj/effect/meteor/irradiated=3,\
		/obj/effect/meteor/emp=3\
		)

	meteors_catastrophic = list(\
		/obj/effect/meteor/big=75,\
		/obj/effect/meteor/flaming=10,\
		/obj/effect/meteor/irradiated=10,\
		/obj/effect/meteor/emp=10,\
		/obj/effect/meteor/medium=5,\
		/obj/effect/meteor/golden=4,\
		/obj/effect/meteor/silver=4
		)

	meteors_armageddon = list(\
		/obj/effect/meteor/big=25,\
		/obj/effect/meteor/flaming=10,\
		/obj/effect/meteor/irradiated=10,\
		/obj/effect/meteor/emp=10,\
		/obj/effect/meteor/medium=3,\
		/obj/effect/meteor/golden=2,\
		/obj/effect/meteor/silver=2\
		)

	meteors_cataclysm = list(\
		/obj/effect/meteor/big=40,\
		/obj/effect/meteor/emp=20,\
		/obj/effect/meteor/irradiated=10,\
		/obj/effect/meteor/golden=10,\
		/obj/effect/meteor/silver=10,\
		/obj/effect/meteor/flaming=10,\
		/obj/effect/meteor/supermatter=1\
		)

/datum/space_sector/corp_zone
	name = SECTOR_CORP_ZONE
	description = "Бывшие системы Альянса, которые теперь заняты Республикой, называют Корпоративной Зоной Восстановления. \
	Зона или КЗВ - это зона хаоса и экономической нестабильности, состоящая из бывших колоний Альянса, которые хотя бы живут достаточно мирно, по сравнению со своими соседями \
	из Дикого Космоса. Текущей ситуации поспособствовали два главных фактора: всеобъемлющее присутствие Звёздного Корпоративного Конгломерата и поддержка от Республики Бизель. \
	Варлорды и другие недоброжелатели (в сторону Бизеля) избегают залетать в эти системы чтобы избежать гнева Конгломерата, предпочитая атаковать его союзников."
	possible_exoplanets = list(/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid, /obj/effect/overmap/visitable/sector/exoplanet/barren, /obj/effect/overmap/visitable/sector/exoplanet/grass/grove)
	starlight_color = "#9cd0fd"
	starlight_power = 5
	starlight_range = 2

/datum/religion/twinsuns
	name = RELIGION_TWINSUNS
	description = "The worship of the twin Adhomai suns, S'rendarr and Messa has a long-standing tradition among the Tajara people and has archaeologically been regarded, with the \
	exclusion of other minor sects, as one of the oldest known religion along with the worship of Ma'ta'ke. The religion itself created by Njarir'Akhran, it has changed hands and forms, \
	eventually transforming into what it is today. The religion holds onto very traditional values, promoting collectivism, sharing, helping those in need."
	nulloptions = list(
		"Tajaran charm" = /obj/item/nullrod/charm
	)
	unique_book_path = /obj/item/device/versebook/twinsuns

/datum/religion/matake
	name = RELIGION_MATAKE
	description = "The second largest religion is the worship of the Snow God Mata'ke and his cohort companion gods, which dates back to ancient Tajaran times. A figure of legend, \
	Mata'ke is believed to have been the head of a hardy tribe of mountain dwellers which regularly came to the aid of other tribes which were constantly plagued by bandits and wild \
	animals. He was revered as a fierce warrior capable of fighting a platoon of men by himself, but also as a kind soul for the records of his dealings with other tribes show \
	understanding and kindness. He is upheld to be the ultimate Tajara- powerful, wise, and magnanimous. Followers of Mata'ke himself endeavor to emulate his grandeur, while others \
	attempt to emulate the other gods."
	nulloptions = list(
		"Tajaran charm" = /obj/item/nullrod/charm,
		"Mata'ke Sword" = /obj/item/nullrod/matake,
		"Rredouane Sword" = /obj/item/nullrod/rredouane,
		"Shumaila Hammer" = /obj/item/nullrod/shumaila,
		"Zhukamir Ladle" = /obj/item/nullrod/zhukamir,
		"Azubarre Torch" = /obj/item/nullrod/azubarre
	)
	unique_book_path = /obj/item/device/versebook/matake

/datum/religion/raskara
	name = RELIGION_RASKARA
	description = "Raskariim, commonly known as The Cult of Raskara are a prolific cult on Adhomai. The religion has been created on Adhomai but with the free commerce, a few human \
	members have been recorded. While Raskara may seem like a single deity it is in fact split into three aspects, each one leading down a different path and seemingly every path \
	subverting something S'rendarr and Messa stands for. This faith will appear as Ma'ta'ke in the records."
	book_name = "ma'ta'ke legends"
	nulloptions = list(
		"Tajaran charm" = /obj/item/nullrod/charm,
		"Mata'ke Sword" = /obj/item/nullrod/matake,
		"Rredouane Sword" = /obj/item/nullrod/rredouane,
		"Shumaila Hammer" = /obj/item/nullrod/shumaila,
		"Zhukamir Ladle" = /obj/item/nullrod/zhukamir,
		"Azubarre Torch" = /obj/item/nullrod/azubarre
	)

/datum/religion/raskara/get_records_name()
	return RELIGION_MATAKE

/datum/religion/raskara_alt
	name = RELIGION_RASKARA_ALT
	description = "Raskariim, commonly known as The Cult of Raskara are a prolific cult on Adhomai. The religion has been created on Adhomai but with the free commerce, a few human \
	members have been recorded. While Raskara may seem like a single deity it is in fact split into three aspects, each one leading down a different path and seemingly every path \
	subverting something S'rendarr and Messa stands for. This faith will appear as S'rendarr and Messa in the records."
	book_name = "holy scrolls"
	book_sprite = "holylight"
	nulloptions = list(
		"Tajaran charm" = /obj/item/nullrod/charm
	)

/datum/religion/raskara_alt/get_records_name()
	return RELIGION_TWINSUNS

/obj/item/clothing/under/tajaran
	name = "laborer clothes"
	desc = "A rough but thin outfit, providing air flow but also protection from working hazards."
	icon = 'icons/obj/tajara_items.dmi'
	icon_state = "taj_labor"
	item_state = "taj_labor"
	contained_sprite = TRUE
	desc_extended = "Having direct and friendly contact with humanity, The People's Republic of Adhomai has been the most influenced by the spacer fashion. The most known \
	being the \"assistant jumpsuits\" which directly inspired the design of factory overalls, the plight and low pay of the assistants being close to the hearts of Tajara Hadiist \
	workers and their Republic."
	no_overheat = TRUE

/obj/item/clothing/under/tajaran/fancy
	name = "fancy uniform"
	desc = "Worn by princes, barons and lords of Adhomai, now in stores near you!"
	icon_state = "male_taj_fancy"
	item_state = "male_taj_fancy"
	desc_extended = "While money and riches are at an all time low, the New Kingdom is symbolized by one thing, hope. While the often attacked, poor and shaggy nation is compared to \
	the others in quite a poor state, it holds a \"stiff upper muzzle\" attitude, not letting their enemies get under their skin. Unlike the PRA if someone can afford it, they flaunt it, \
	nobles and peasants live in the same streets, drink the same water and eat the same food and thus even wear the same clothes. On the streets they look very similar to PRA Tajara, \
	overcoats, white shirts, pants although often in poorer state. However jewelry, tail adornments and veils are in rich abundance, often showing off small and intricate details of \
	individual personalities. But where the NKA really shines are their parties and special events."

/obj/item/clothing/under/tajaran/fancy/alt1
	icon_state = "male_taj_fancy_alt1"
	item_state = "male_taj_fancy_alt1"

/obj/item/clothing/under/tajaran/fancy/alt2
	icon_state = "male_taj_fancy_alt2"
	item_state = "male_taj_fancy_alt2"

/obj/item/clothing/under/tajaran/nt
	name = "NanoTrasen overalls"
	desc = "Overalls meant for NanoTrasen employees of xeno descent, modified to prevent overheating."
	icon_state = "ntoveralls"
	item_state = "ntoveralls"

/obj/item/clothing/under/tajaran/matake
	name = "Mata'ke priest garments"
	desc = "Simple linen garments worn by Mata'ke priests."
	icon_state = "matakeuniform"
	item_state = "matakeuniform"
	desc_extended = "The priesthood of Mata'ke is comprised of only men and strangely enough, hunters. Like their patron, all priests of Mata'ke must prove themselves capable, \
	practical, strong and masters of Adhomai wilderness. Every clan and temple of Mata'ke has a different way of testing its applicants and these tests are always kept as a strict \
	secret, the only thing known is that the majority of applicants never return. After they're accepted, priests of Mata'ke dress in furs and carry silver \
	weapons, usually daggers for ease of transport and to simulate Mata'ke's sword. There is a remarkably low amount of Njarir'Akhran in the Mata'ke priesthood."

/obj/item/clothing/under/tajaran/cosmonaut
	name = "kosmostrelki uniform"
	desc = "A military uniform used by the forces of the People's Republic of Adhomai orbital fleet."
	icon_state = "cosmonaut"
	item_state = "cosmonaut"
	desc_extended = "The People's Republic of Adhomai enjoys having the only militarized spaceships of all the factions on Adhomai. Initially they relied on contracting outside \
	protection from NanoTrasen and the Sol Alliance in order to defend their orbit from raiders. However, the Republican Navy has striven to become independent. With the help of \
	contracted engineers, access to higher education abroad and training from Sol Alliance naval advisers, the People's Republic has been able to commission and crew some of its own \
	ships. The Republican Navy's space-arm primarily conducts counter piracy operations in conjunction with fending off raiders."
	starting_accessories = (/obj/item/clothing/accessory/storage/bayonet)
	siemens_coefficient = 0.5 // Every Kosmostrelki is expected to assist in repairs when push comes to shove, so their uniform is slightly better at absorbing shocks compared to other combat uniforms
	armor = list(
		melee = ARMOR_MELEE_SMALL,
		bullet = ARMOR_BALLISTIC_MINOR)

/obj/item/clothing/under/tajaran/cosmonaut/commissar
	name = "kosmostrelki commissar uniform"
	desc = "A military uniform used by Party Commissars attached to kosmostrelki units."
	icon_state = "space_commissar"
	item_state = "space_commissar"
	desc_extended = "Party Commissars are high ranking members of the Party of the Free Tajara under the Leadership of Hadii attached to army units, who ensures that soldiers and \
	their commanders follow the principles of Hadiism. Their duties are not only limited to enforcing the republican ideals among the troops and reporting possible subversive elements, \
	they are expected to display bravery in combat and lead by example."
	starting_accessories = (/obj/item/clothing/accessory/holster/hip)

/obj/item/clothing/under/tajaran/cosmonaut/captain
	name = "orbital fleet captain uniform"
	desc = "A military uniform used by a captain of the People's Republic of Adhomai orbital fleet."
	icon_state = "orbital_captain"
	item_state = "orbital_captain"

/obj/item/clothing/under/tajaran/database_freighter
	name = "orbital fleet surveyor uniform"
	desc = "A pratical uniform used by the crew of the orbital fleet's database freighters."
	icon_state = "database_freighter"
	item_state = "database_freighter"

/obj/item/clothing/under/tajaran/database_freighter/captain
	name = "orbital fleet head surveyor uniform"
	desc = "A pratical uniform used by the captains of the orbital fleet's database freighters."
	icon_state = "database_freighter_captain"
	item_state = "database_freighter_captain"

/obj/item/clothing/under/tajaran/summer
	name = "adhomian summerwear"
	desc = "A simple piece of adhomian summerwear made with linen."
	icon_state = "summerwear"
	item_state = "summerwear"

/obj/item/clothing/under/tajaran/mechanic
	name = "machinist uniform"
	desc = "A simple and robust overall used by Adhomian urban workers."
	icon_state = "mechanic"
	item_state = "mechanic"
	desc_extended = "The quality of life for an urban dweller in Nal'tor, or any other major city, can vary considerably according to the Tajara's occupation, education and standing \
	with the Party. The average worker that labours in the industrial suburbs, can expect an honest living to be made, and a modest lifestyle to be led. The majority of the city labourers \
	work in government run factories and spaceports, with stable but strict work hours and schedule the Hadii regime boasts of its fairness to the worker."

/obj/item/clothing/under/tajaran/raakti_shariim
	name = "\improper Raakti Shariim uniform"
	desc = "A blue and lilac adhomian uniform with pale-gold insignia, worn by members of the NKA's Raakti Shariim."
	icon = 'icons/obj/tajara_items.dmi'
	icon_state = "raakti_shariim_uniform"
	item_state = "raakti_shariim_uniform"
	desc_extended = "The Raakti Shariim (Royal Peacekeepers in Ceti Basic) are the New Kingdom of Adhomai's policing and \
		peacekeeping force, working closely with both the Royal Constabulary and the Royal Ministry of Intelligence to \
		seek out internal threats to the Kingdom such as spies, terrorists, and other domestic enemies to the crown. \
		The Raakti Shariim's uniforms incorporate a dark, navy blue paired with a lilac accent and pale-gold twin-sun \
		insignia."

/obj/item/clothing/under/dress/tajaran
	name = "fancy adhomian dress"
	desc = "Created for the rich and party-loving circles of Adhomai, this dress is fashioned from smooth silk and is see through at parts. This one is white."
	icon = 'icons/obj/tajara_items.dmi'
	icon_state = "taj_dress_white"
	item_state = "taj_dress_white"
	contained_sprite = TRUE
	no_overheat = TRUE
	desc_extended = "Today the fashion that dominates Adhomai shares few similarities to the clothing of old Furs, linen, hemp, silk and other such fabrics were traded for \
	synthetic versions, creating a massive boom in the nylon industry and textile industry in the cities. Jeans, overcoats, army uniforms, parade uniforms, flags, pants, shirts, ties, \
	suspenders, overalls are now the fashion of every Tajara from Nal'Tor to Kaltir. The protests of \"Old fashion\" supporters usually shatter against how effective and cheap it is to \
	make the human clothes are. There are a few notable branches, the long-coat and fedora \"gangster style\". Leather jacket wearing \"Greaser\" or the popular amongst females, short \
	and colorful dress wearing \"Flapper\" variety of clothing."

/obj/item/clothing/under/dress/tajaran/blue
	desc = "Created for the rich and party-loving circles of Adhomai, this dress is fashioned from smooth silk and is see through at parts. This one is blue."
	icon = 'icons/obj/tajara_items.dmi'
	icon_state = "taj_dress_skyblue"
	item_state = "taj_dress_skyblue"

/obj/item/clothing/under/dress/tajaran/green
	desc = "Created for the rich and party-loving circles of Adhomai, this dress is fashioned from smooth silk and is see through at parts. This one is green."
	icon = 'icons/obj/tajara_items.dmi'
	icon_state = "taj_dress_green"
	item_state = "taj_dress_green"

/obj/item/clothing/under/dress/tajaran/red
	desc = "Created for the rich and party-loving circles of Adhomai, this dress is fashioned from smooth silk and is see through at parts. This one is red."
	icon = 'icons/obj/tajara_items.dmi'
	icon_state = "taj_dress_red"
	item_state = "taj_dress_red"

/obj/item/clothing/under/dress/tajaran/fancy
	name = "noble adhomian dress"
	desc = "The classical dress of the Adhomian royalty, only to be worn during the special occassions. This one is crimson red."
	icon = 'icons/obj/tajara_items.dmi'
	icon_state = "taj_dress_fancy"
	item_state = "taj_dress_fancy"

/obj/item/clothing/under/dress/tajaran/fancy/black
	desc = "The classical dress of the Adhomian royalty, only to be worn during the special occassions. This one is dark black."
	icon_state = "taj_dress_fancy_dark"
	item_state = "taj_dress_fancy_dark"

/obj/item/clothing/under/dress/tajaran/long
	name = "adhomian dress"
	desc = "A prim and proper dress, covers from neck to ankle."
	icon_state = "longdress"
	item_state = "longdress"

/obj/item/clothing/under/dress/tajaran/long/update_icon()
	cut_overlays()
	var/image/buttons = image(icon, null, "longdress_buttons")
	buttons.appearance_flags = RESET_COLOR
	add_overlay(buttons)

/obj/item/clothing/under/dress/tajaran/long/get_mob_overlay(var/mob/living/carbon/human/H, var/mob_icon, var/mob_state, var/slot)
	var/image/I = ..()
	if(slot == slot_w_uniform_str)
		var/image/buttons = image(mob_icon, null, "longdress_un_buttons")
		buttons.appearance_flags = RESET_COLOR
		I.add_overlay(buttons)
	return I

/obj/item/clothing/under/dress/tajaran/formal
	name = "fancy uniform with skirt"
	desc = "Formal Tajaran clothing with a skirt."
	icon_state = "female_taj_fancy"
	item_state = "female_taj_fancy"

/obj/item/clothing/under/dress/tajaran/formal/alt1
	icon_state = "female_taj_fancy_alt1"
	item_state = "female_taj_fancy_alt1"

/obj/item/clothing/under/dress/tajaran/formal/alt2
	icon_state = "female_taj_fancy_alt2"
	item_state = "female_taj_fancy_alt2"

/obj/item/clothing/under/dress/tajaran/summer
	name = "adhomian summer dress"
	desc = "An Adhomian dress usually worn during the summer."
	icon_state = "summer-dress"
	item_state = "summer-dress"
	body_parts_covered = LOWER_TORSO
	starting_accessories = list(/obj/item/clothing/accessory/tajaran/summershirt)

/obj/item/clothing/under/pants/tajaran
	name = "adhomian summer pants"
	desc = "A pair of adhomian pants usually worn during the summer."
	icon = 'icons/obj/tajara_items.dmi'
	icon_state = "summer-pants"
	item_state = "summer-pants"
	contained_sprite = TRUE
	starting_accessories = list(/obj/item/clothing/accessory/tajaran/summershirt)
	desc_extended = "Having direct and friendly contact with humanity, The People's Republic of Adhomai has been the most influenced by the spacer fashion. The most known \
	being the \"assistant jumpsuits\" which directly inspired the design of factory overalls, the plight and low pay of the assistants being close to the hearts of Tajara Hadiist \
	workers and their Republic."

/obj/item/clothing/under/tajaran/pra_uniform
	name = "republican army uniform"
	desc = "A military uniform used by the forces of Grand People's Army."
	icon_state = "prauniform"
	item_state = "prauniform"
	starting_accessories = list(/obj/item/clothing/accessory/storage/bayonet)
	siemens_coefficient = 0.7
	armor = list(
		melee = ARMOR_MELEE_SMALL,
		bullet = ARMOR_BALLISTIC_MINOR)

/obj/item/clothing/under/tajaran/nka_uniform
	name = "imperial adhomian army uniform"
	desc = "A military uniform used by the forces of the New Kingdom of Adhomai's army."
	icon_state = "nka_uniform"
	item_state = "nka_uniform"
	starting_accessories = list(/obj/item/clothing/accessory/storage/bayonet)
	armor = list(melee = ARMOR_MELEE_SMALL)

/obj/item/clothing/under/tajaran/consular
	name = "people's republic consular uniform"
	desc = "An olive uniform used by the diplomatic service of the People's Republic of Adhomai."
	icon_state = "pra_consular"
	item_state = "pra_consular"

/obj/item/clothing/under/tajaran/consular/dpra
	name = "democratic people's republic consular uniform"
	desc = "A grey uniform used by the diplomatic service of the Democratic People's Republic of Adhomai."
	icon_state = "dpra_consular"
	item_state = "dpra_consular"

/obj/item/clothing/under/tajaran/consular/nka
	name = "new kingdom consular uniform"
	desc = "A blue uniform used by the diplomatic service of the New Kingdom of Adhomai."
	icon_state = "nka_consular"
	item_state = "nka_consular"

/obj/item/clothing/under/tajaran/dpra
	name = "al'mariist laborer clothes"
	desc = "Clothes commonly used by Das'nrra's workers. Due to their ubiquitousness, they became a symbol of the common Al'mariist people."
	icon_state = "dpra_worker"
	item_state = "dpra_worker"

/obj/item/clothing/under/tajaran/dpra/alt
	icon_state = "dpra_worker_alt"
	item_state = "dpra_worker_alt"

/obj/item/clothing/under/tajaran/nka_noble
	name = "noble adhomian clothes"
	desc = "Clothes frequently worn by the New Kingdom's nobles. Likely a hand-me-down."
	icon_state = "nka_noble_uniform"
	item_state = "nka_noble_uniform"

/obj/item/clothing/under/tajaran/nka_noble/update_icon()
	cut_overlays()
	var/image/lining = image(icon, null, "nka_noble_uniform_lining")
	lining.appearance_flags = RESET_COLOR
	add_overlay(lining)

/obj/item/clothing/under/tajaran/nka_noble/get_mob_overlay(var/mob/living/carbon/human/H, var/mob_icon, var/mob_state, var/slot)
	var/image/I = ..()
	if(slot == slot_w_uniform_str)
		var/image/lining = image(mob_icon, null, "nka_noble_uniform_un_lining")
		lining.appearance_flags = RESET_COLOR
		I.add_overlay(lining)
	return I

/obj/item/clothing/under/tajaran/archeologist
	name = "archeologist uniform"
	desc = "A rugged uniform used by Adhomian archeologists. It is already covered in dirt and ancient dust."
	icon_state = "explorer_uniform"
	item_state = "explorer_uniform"

/obj/item/clothing/under/tajaran/army_commissar
	name = "army commissar uniform"
	desc = "A military uniform used by Party Commissars attached to military units."
	icon_state = "pracommisar"
	item_state = "pracommisar"
	desc_extended = "Party Commissars are high ranking members of the Party of the Free Tajara under the Leadership of Hadii attached to army units, who ensures that soldiers and \
	their commanders follow the principles of Hadiism. Their duties are not only limited to enforcing the republican ideals among the troops and reporting possible subversive elements, \
	they are expected to display bravery in combat and lead by example."
	starting_accessories = (/obj/item/clothing/accessory/holster/hip)

/obj/item/clothing/under/tajaran/psis
	name = "people's strategic intelligence service uniform"
	desc = "An uniform used by the agents of the People's Strategic Intelligence Service. The sight of this uniform is feared by most Tajara."
	icon_state = "pracommisar"
	item_state = "pracommisar"
	desc_extended = "The People's Strategic Intelligence service is the main intelligence agency of the People's Republic. In the wake of the revolution that had won the species their independence, \
	the budding government recognized the need for covert operations. Several agents and informants are employed by the PSIS, both in domestic and foreign theaters. The agency makes use of \
	espionage, sabotage, assassination, interrogation, blackmail, and all other short of subterfuge, during their operations. Subversive elements within the People's Republican are dealt with \
	quickly, usually through night raids and abductions conducted with aid of black unmarked cars. Tajara residing in other systems are not truly safe from the Intelligence Service, as they are \
	known to deploy their agents against off-world targets. Republican spies, enforces and collaborators are present in Mendell City's district six, carrying out orders or watching their fellow Tajara."
	starting_accessories = (/obj/item/clothing/accessory/holster/hip)
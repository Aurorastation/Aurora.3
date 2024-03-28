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
	desc_extended = "The People's Republic of Adhomai enjoys having the first militarized spaceships of all the factions on Adhomai. Initially they relied on contracting outside \
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

/obj/item/clothing/under/tajaran/nka_uniform/commander
	name = "imperial adhomian army officer uniform"
	desc = "A military uniform used by the officers of the New Kingdom of Adhomai's army."
	icon_state = "nka_commander"
	item_state = "nka_commander"
	starting_accessories = null

/obj/item/clothing/under/tajaran/nka_uniform/sailor
	name = "royal navy sailor uniform"
	desc = "A military uniform used by the sailor of the New Kingdom of Adhomai's navy."
	icon_state = "nka_sailor"
	item_state = "nka_sailor"

/obj/item/clothing/under/tajaran/consular
	name = "people's republic consular uniform"
	desc = "An olive uniform used by the diplomatic service of the People's Republic of Adhomai."
	icon_state = "pra_consular"
	item_state = "pra_consular"

/obj/item/clothing/under/tajaran/consular/female
	icon_state = "pra_con_f"
	item_state = "pra_con_f"

/obj/item/clothing/under/tajaran/consular/dpra
	name = "democratic people's republic consular uniform"
	desc = "A grey uniform used by the diplomatic service of the Democratic People's Republic of Adhomai."
	icon_state = "dpra_consular"
	item_state = "dpra_consular"

/obj/item/clothing/under/tajaran/consular/dpra/female
	icon_state = "dpra_con_f"
	item_state = "dpra_con_f"

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

/obj/item/clothing/under/tajaran/nka_merchant_navy
	name = "her majesty's mercantile flotilla crew uniform"
	desc = "An uniform used by the crew of the New Kingdom's merchant space ships. It is clearly inspired by the ones used back on Adhomai."
	icon_state = "nka_merchant_navy"
	item_state = "nka_merchant_navy"

/obj/item/clothing/under/tajaran/nka_merchant_navy/alt
	icon_state = "nka_merchant_navy_alt"
	item_state = "nka_merchant_navy_alt"

/obj/item/clothing/under/tajaran/nka_merchant_navy/captain
	name = "her majesty's mercantile flotilla captain uniform"
	desc = "An uniform used by the captain of the New Kingdom's merchant space ships. Not as fancy as the ones used in the Royal Navy."
	icon_state = "nka_merchant_captain"
	item_state = "nka_merchant_captain"

/obj/item/clothing/under/tajaran/pvsm
	name = "people's volunteer spacer militia uniform"
	desc = "A military uniform used by the forces of the People's Volunteer Spacer Militia."
	icon_state = "pvsm_crewman"
	item_state = "pvsm_crewman"
	desc_extended = "Having only recently claimed a space-positioned base alongside Gakal'zaal, the DPRA lacks any sort of trained force when it comes to orbital defense. Not wanting to \
	rely purely on mercenaries due to the expenses and their scant loyalty, a militia was organized. Members of the Spacer Militia come from a variety of backgrounds: some coming back \
	after being employed by mega-corporations; others from asteroid belts; some soldiers from Adhomai; and more from the Free Gakal'zaal Station itself, having worked on it as maintenance."
	starting_accessories = (/obj/item/clothing/accessory/storage/bayonet)
	siemens_coefficient = 0.5
	armor = list(
		melee = ARMOR_MELEE_SMALL,
		bullet = ARMOR_BALLISTIC_MINOR)

/obj/item/clothing/under/tajaran/pvsm/captain
	name = "people's volunteer spacer militia captain uniform"
	desc = "A military uniform used by the captains of the People's Volunteer Spacer Militia."
	icon_state = "pvsm_captain"
	item_state = "pvsm_captain"

/obj/item/clothing/under/tajaran/ala
	name = "adhomai liberation army uniform"
	desc = "A military uniform issued to soldiers of the adhomai liberation army."
	icon_state = "ala-soldier-civ"
	item_state = "ala-soldier-civ"
	starting_accessories = list(/obj/item/clothing/accessory/storage/bayonet)
	siemens_coefficient = 0.7
	armor = list(
		melee = ARMOR_MELEE_SMALL,
		bullet = ARMOR_BALLISTIC_MINOR)

/obj/item/clothing/under/tajaran/ala/wraps
	icon_state = "ala-grunt-wraps"
	item_state = "ala-grunt-wraps"

/obj/item/clothing/under/tajaran/ala/black
	icon_state = "ala-soldat"
	item_state = "ala-soldat"

/obj/item/clothing/under/tajaran/ala/black/dress
	name = "adhomai liberation army dress uniform"
	icon_state = "ala-soldatdress"
	item_state = "ala-soldatdress"

/obj/item/clothing/under/tajaran/ala/black/officer
	name = "adhomai liberation army officer uniform"
	desc = "A military uniform issued to officers of the adhomai liberation army."
	icon_state = "ala-officer"
	item_state = "ala-officer"

/obj/item/clothing/under/tajaran/tesla_body
	name = "tesla rejuvenation suit worker uniform"
	desc = "A massive jumpsuit issued to Tajara grafted in Tesla Rejuvenation Suits."
	icon_state = "tesla_body_jumpsuit"
	item_state = "tesla_body_jumpsuit"
	species_restricted = list(BODYTYPE_TESLA_BODY)
	sprite_sheets = list(BODYTYPE_TESLA_BODY = 'icons/mob/species/tajaran/tesla_body/uniform.dmi')

/obj/item/clothing/under/tajaran/archeologist
	name = "archaeologist uniform"
	desc = "A rugged uniform used by Adhomian archaeologists. It is already covered in dirt and ancient dust."
	icon_state = "explorer_uniform"
	item_state = "explorer_uniform"

/obj/item/clothing/under/tajaran/army_commissar
	name = "army commissar uniform"
	desc = "A military uniform used by Party Commissars attached to military units."
	desc_extended = "Party Commissars are high ranking members of the Party of the Free Tajara under the Leadership of Hadii attached to army units, who ensures that soldiers and \
	their commanders follow the principles of Hadiism. Their duties are not only limited to enforcing the republican ideals among the troops and reporting possible subversive elements, \
	they are expected to display bravery in combat and lead by example."
	icon_state = "pracommisar"
	item_state = "pracommisar"
	starting_accessories = (/obj/item/clothing/accessory/holster/hip)

/obj/item/clothing/under/tajaran/psis
	name = "people's strategic intelligence service uniform"
	desc = "An uniform used by the agents of the People's Strategic Intelligence Service. The sight of this uniform is feared by most Tajara."
	desc_extended = "The People's Strategic Intelligence service is the main intelligence agency of the People's Republic. In the wake of the revolution that had won the species their independence, \
	the budding government recognized the need for covert operations. Several agents and informants are employed by the PSIS, both in domestic and foreign theaters. The agency makes use of \
	espionage, sabotage, assassination, interrogation, blackmail, and all other short of subterfuge, during their operations. Subversive elements within the People's Republican are dealt with \
	quickly, usually through night raids and abductions conducted with aid of black unmarked cars. Tajara residing in other systems are not truly safe from the Intelligence Service, as they are \
	known to deploy their agents against off-world targets. Republican spies, enforces and collaborators are present in Mendell City's district six, carrying out orders or watching their fellow Tajara."
	icon_state = "psis"
	item_state = "psis"
	starting_accessories = (/obj/item/clothing/accessory/holster/hip)

// Red Polka Dot Dress
/obj/item/clothing/under/dress/tajaran/polka_dot
	name = "red polka dot dress"
	desc = "A newer fashion style, this dress sports a jaunty, summery print with a scandalous shape by tajara standards. This one is red."
	desc_extended = "Fundamentally at odds with the more traditional \"Flapper\" variety of clothing popular in the 2440s and 2450s, newer, more revealing and less restrictive dresses have found themselves surging amongst the teenage and young adult demographic on Adhomai, and in the People's Republic of Adhomai specifically. Many parents do not approve of these new styles, but shops sell them all the same, and celebrities flaunt them at red carpet events. Like it or not, times have begun to change."
	icon = 'icons/obj/item/clothing/under/dress/tajaran/polka_dot_dresses.dmi'
	icon_state = "polka_red"
	item_state = "polka_red"

// Black Polka Dot Dress
/obj/item/clothing/under/dress/tajaran/polka_dot/black
	name = "black polka dot dress"
	desc = "A newer fashion style, this dress sports a jaunty, summery print with a scandalous shape by tajara standards. This one is black."
	icon_state = "polka_black"
	item_state = "polka_black"

// Floral Dress
/obj/item/clothing/under/dress/tajaran/floral
	name = "floral dress"
	desc = "A newer fashion style, this flower-printed blouse and pencil skirt sport a colorful print and a scandalous shape by tajara standards."
	icon = 'icons/obj/item/clothing/under/dress/tajaran/floral_dress.dmi'
	icon_state = "floral_dress"
	item_state = "floral_dress"

// Plaid Housewife Dress
/obj/item/clothing/under/dress/tajaran/housewife
	name = "plaid housewife dress"
	desc = "A modest plaid dress, done in the latest tajaran styles."
	icon = 'icons/obj/item/clothing/under/dress/tajaran/housewife_dresses.dmi'
	icon_state = "housewife_plaid"
	item_state = "housewife_plaid"

// Mauve Housewife Dress
/obj/item/clothing/under/dress/tajaran/housewife/mauve
	name = "mauve housewife dress"
	desc = "A modest mauve dress with a white collar, done in the latest tajaran styles."
	icon_state = "housewife_mauve"
	item_state = "housewife_mauve"
	desc_extended = "Born of changing styles in the People's Republic and elsewhere, this dress blends the newer, more flattering shapes and traditional modestness so that the modern tajara woman may avail herself of the latest fashion trends. It blends this earnestness and fashionability together in a beautiful compromise, so it should come as no surprise that housewives and middle-aged women are oft found in dresses just like this."

// Yellow Housewife Dress
/obj/item/clothing/under/dress/tajaran/housewife/yellow
	name = "yellow housewife dress"
	desc = "A modest yellow dress, accented in black, done in the latest tajaran styles."
	icon_state = "housewife_yellow"
	item_state = "housewife_yellow"

// Adhomian Evening Suit
/obj/item/clothing/under/tajaran/fancy/evening_suit
	name = "adhomian evening suit"
	desc = "A rich purple evening suit meant for lounging or other luxury."
	icon = 'icons/obj/item/clothing/under/tajaran/fancy/evening_suit.dmi'
	icon_state = "evening_suit"
	item_state = "evening_suit"

// High-waisted Men's Wear
/obj/item/clothing/under/tajaran/high_waisted
	name = "high-waisted men's wear"
	desc = "Dark, black, and high-waisted trousers with accompanying vibrant yellow shirt, for the modern and fashionable men."
	desc_extended = "Fashion for men, much like for women, is slowly moving away from many-layered outfits and extravagant and flashy suits and dresses; one would be hard-pressed to find young men sporting three-piece suits any longer. Teenage boys and young adults are drawn more and more to relaxing styles and more comfortable fits that would never have found root on Adhomai before. Now, though, up-and-coming businessmen and well-to-do middle-class boys would rather wear trousers and a dress shirt than waste time with vests and oxfords."
	icon = 'icons/obj/item/clothing/under/tajaran/high_waisted_wear.dmi'
	icon_state = "high_waisted"
	item_state = "high_waisted"

// High-waisted Men's Business Wear
/obj/item/clothing/under/tajaran/high_waisted/business
	name = "high-waisted men's business wear"
	desc = "Blue trousers and a white dress shirt with accompanying tie, all for the eventual fashionable used car salesman."
	icon_state = "high_waisted_business"
	item_state = "high_waisted_business"

// Relaxed Men's Wear
/obj/item/clothing/under/tajaran/relaxed
	name = "relaxed men's wear"
	desc = "Plaid pants and an unbuttoned silk shirt mean comfort and style."
	desc_extended = "Fashion for men, much like for women, is slowly moving away from many-layered outfits and extravagant and flashy suits and dresses; one would be hard-pressed to find young men sporting three-piece suits any longer. Teenage boys and young adults are drawn more and more to relaxing styles and more comfortable fits that would never have found root on Adhomai before. Now, though, up-and-coming businessmen and well-to-do middle-class boys would rather wear trousers and a dress shirt than waste time with vests and oxfords."
	icon = 'icons/obj/item/clothing/under/tajaran/relaxed_wear.dmi'
	icon_state = "relaxed_wear"
	item_state = "relaxed_wear"

// Stylish Relaxed Men's Wear
/obj/item/clothing/under/tajaran/relaxed/stylish
	name = "stylish relaxed men's wear"
	desc = "Blue trousers and a silken shirt with matching accents. It even has a pocket."
	icon_state = "stylish_relaxed_wear"
	item_state = "stylish_relaxed_wear"

// Smart Study Outfit
/obj/item/clothing/under/tajaran/smart
	name = "smart study outfit"
	desc = "A brown, interwoven argyle sweater with accompanying trousers - for the modern academian in all of us."
	desc_extended = "Fashion for men, much like for women, is slowly moving away from many-layered outfits and extravagant and flashy suits and dresses; one would be hard-pressed to find young men sporting three-piece suits any longer. Teenage boys and young adults are drawn more and more to relaxing styles and more comfortable fits that would never have found root on Adhomai before. Now, though, up-and-coming businessmen and well-to-do middle-class boys would rather wear trousers and a dress shirt than waste time with vests and oxfords."
	icon = 'icons/obj/item/clothing/under/tajaran/smart_study_outfit.dmi'
	icon_state = "study_outfit"
	item_state = "study_outfit"

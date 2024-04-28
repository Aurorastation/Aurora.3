//
// Signs
//

/obj/structure/sign
	name = "sign"
	desc = "A sign."
	icon = 'icons/obj/signs.dmi'
	anchored = TRUE
	density = FALSE
	opacity = FALSE
	layer = ABOVE_WINDOW_LAYER
	w_class = ITEMSIZE_NORMAL
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED

/obj/structure/sign/ex_act(severity)
	qdel(src)

/obj/structure/sign/attackby(obj/item/attacking_item, mob/user) // Deconstruction.
	if(attacking_item.isscrewdriver() && !istype(src, /obj/structure/sign/double))
		user.visible_message(SPAN_NOTICE("\The [user] starts to unfasten \the [src]."), SPAN_NOTICE("You start to unfasten \the [src]."))
		if(attacking_item.use_tool(src, user, 0, volume = 50))
			unfasten(user)
	else ..()

/obj/structure/sign/proc/unfasten(mob/user)
	user.visible_message(SPAN_NOTICE("\The [user] unfastens \the [src]."), SPAN_NOTICE("You unfasten \the [src]."))
	var/obj/item/sign/S = new(src.loc)
	S.name = name
	S.desc = desc
	S.icon_state = icon_state
	S.sign_state = icon_state
	qdel(src)

/obj/item/sign
	name = "sign"
	desc = "A sign."
	icon = 'icons/obj/signs.dmi'
	w_class = ITEMSIZE_HUGE
	var/sign_state = ""

/obj/item/sign/attackby(obj/item/attacking_item, mob/user) // Construction.
	if(attacking_item.isscrewdriver() && isturf(user.loc))
		var/direction = tgui_input_list(user, "In which direction?", "Select Direction", list("North", "East", "South", "West", "Cancel"))
		if(direction == "Cancel") return
		if(QDELETED(src)) //Prevents spawning multiple new signs with queued dialogues
			return
		var/obj/structure/sign/S = new(get_turf(user))
		switch(direction)
			if("North")
				S.pixel_y = 32
			if("East")
				S.pixel_x = 32
			if("South")
				S.pixel_y = -32
			if("West")
				S.pixel_x = -32
			else return
		S.name = name
		S.desc = desc
		S.icon_state = sign_state
		to_chat(user, "You fasten \the [S] with your [attacking_item].")
		qdel(src)
	else ..()

//
// Generic Signs
//

/obj/structure/sign/double/map
	name = "station map"
	desc = "A framed picture of the station."

/obj/structure/sign/double/map/left
	icon_state = "map-left"

/obj/structure/sign/double/map/right
	icon_state = "map-right"

/obj/structure/sign/examroom
	name = "\improper EXAM sign"
	desc = "A sign which reads 'EXAM ROOM'."
	icon_state = "examroom"

/obj/structure/sign/vacuum
	name = "\improper VACUUM AHEAD sign"
	desc = "A warning sign which reads 'VACUUM AHEAD'."
	icon_state = "space"

/obj/structure/sign/deathsposal
	name = "\improper DISPOSAL LEADS TO SPACE sign"
	desc = "A warning sign which reads 'DISPOSAL LEADS TO SPACE'."
	icon_state = "deathsposal"

/obj/structure/sign/pods
	name = "\improper ESCAPE PODS sign"
	desc = "A warning sign which reads 'ESCAPE PODS'."
	icon_state = "pods"

/obj/structure/sign/nosmoking_1
	name = "\improper NO SMOKING sign"
	desc = "A warning sign which reads 'NO SMOKING'."
	icon_state = "nosmoking"

/obj/structure/sign/nosmoking_2
	name = "\improper NO SMOKING sign"
	desc = "A warning sign which reads 'NO SMOKING'."
	icon_state = "nosmoking2"

/obj/structure/sign/greencross
	name = "\improper MEDICAL sign"
	desc = "The Intergalactic symbol of Medical institutions. You'll probably get help here."
	icon_state = "greencross"

/obj/structure/sign/goldenplaque
	name = "\improper The Most Robust Men Award for Robustness sign"
	desc = "To be Robust is not an action or a way of life, but a mental state. Only those with the force of Will strong enough to act during a crisis, saving friend from foe, are truly Robust. Stay Robust my friends."
	icon_state = "goldenplaque"

/obj/structure/sign/kiddieplaque
	name = "\improper AI developers plaque sign"
	desc = "Next to the extremely long list of names and job titles, there is a drawing of a little child. Beneath the image, someone has scratched the word \"PACKETS\""
	icon_state = "kiddieplaque"

/obj/structure/sign/kiddieplaque/janitor
	name = "\improper Janitorial Oath sign"
	desc = "A humble wooden plaque. In simple lettering begin the words: \"Primum non sordes\"."

/obj/structure/sign/atmosplaque
	name = "\improper FEA atmospherics division plaque"
	desc = "This plaque commemorates the fall of the Atmos FEA division. For all the charred, dizzy, and brittle men who have died in its hands."
	icon_state = "atmosplaque"

/obj/structure/sign/science
	name = "\improper SCIENCE sign"
	desc = "A warning sign which reads 'SCIENCE'."
	icon_state = "science1"

/obj/structure/sign/chemistry
	name = "\improper CHEMISTRY sign"
	desc = "A warning sign which reads 'CHEMISTRY'."
	icon_state = "chemistry1"

/obj/structure/sign/pharmacy
	name = "\improper PHARMACY sign"
	desc = "A warning sign which reads 'PHARMACY'."
	icon_state = "pharmacy1"

/obj/structure/sign/botany
	name = "\improper HYDROPONICS sign"
	desc = "A warning sign which reads 'HYDROPONICS'."
	icon_state = "hydro1"

/obj/structure/sign/patients_only
	name = "\improper PATIENTS ONLY sign"
	desc = "A big blue sign that reads 'PATIENTS ONLY'. Underneath you can read: 'Authorized personnel only. Tresspassers will be prosecuted by the security department.'"
	icon_state = "patients_only"

/obj/structure/sign/staff_only
	name = "\improper STAFF ONLY sign"
	desc = "A big blue sign that reads 'STAFF ONLY'"
	icon_state = "staff_only"

//
// Location and Direction Signs
//

/obj/structure/sign/directions
	name = "direction sign"
	desc = "A direction sign, claiming to know the way."
	icon_state = null

/obj/structure/sign/directions/science
	name = "\improper SCIENCE DEAPRTMENT sign"
	desc = "A direction sign, pointing out which way the science department is."
	icon_state = "direction_sci"

/obj/structure/sign/directions/engineering
	name = "\improper ENGINEERING DEPARTMENT sign"
	desc = "A direction sign, pointing out which way the engineering department is."
	icon_state = "direction_eng"

/obj/structure/sign/directions/security
	name = "\improper SECURITY DEPARTMENT sign"
	desc = "A direction sign, pointing out which way the security department is."
	icon_state = "direction_sec"

/obj/structure/sign/directions/medical
	name = "\improper MEDICAL DEPARTMENT sign"
	desc = "A direction sign, pointing out which way the medical department is."
	icon_state = "direction_med"

/obj/structure/sign/directions/custodial
	name = "\improper CUSTODIAL CLOSET sign"
	desc = "A direction sign, pointing out which way a custodial closet is."
	icon_state = "direction_custodial"

/obj/structure/sign/directions/evac
	name = "\improper ESCAPE DOCK sign"
	desc = "A direction sign, pointing out which way the escape dock is."
	icon_state = "direction_evac"

/obj/structure/sign/directions/cryo
	name = "\improper CRYOGENICS STORAGE sign"
	desc = "A direction sign, pointing out which way the cryogenics storage is."
	icon_state = "direction_cryo"

/obj/structure/sign/directions/dock
	name = "arrivals/departures dock sign"
	desc = "A direction sign, pointing out which way the arrivals/departures dock is."
	icon_state = "direction_dock"

/obj/structure/sign/directions/civ
	name = "\improper CIVILIAN sign"
	desc = "A direction sign, pointing out which way the civilian sector is."
	icon_state = "direction_civ"

/obj/structure/sign/directions/com
	name = "\improper COMMAND sign"
	desc = "A direction sign, pointing out which way the command sector is."
	icon_state = "direction_com"

/obj/structure/sign/directions/tcom
	name = "\improper TELECOMMUNICATIONS sign"
	desc = "A direction sign, pointing out which way telecommunications is."
	icon_state = "direction_tcom"

/obj/structure/sign/directions/tram
	name = "\improper TRAM STATION sign"
	desc = "A direction sign, pointing out which way the tram station is."
	icon_state = "direction_tram"

/obj/structure/sign/directions/mndl
	name = "\improper Mendell Transport Shuttle sign"
	desc = "A direction sign, pointing out which way the Mendell City Transport Shuttle is."
	icon_state = "direction_mndl"

/obj/structure/sign/directions/all
	name = "\improper ALL DEPARTMENTS sign"
	desc = "A multi-coloured direction sign, pointing out in which all main departments are located."
	icon_state = "direction_all"

/obj/structure/sign/directions/prop
	name = "\improper PROPULSION sign"
	desc = "A direction sign, pointing out which way the nearest propulsion area is."
	icon_state = "direction_prop"

//
// Danger, Warning, and Hazard Signs
//

/obj/structure/sign/securearea
	name = "\improper WARNING: SECURE AREA sign"
	desc = "A warning sign which reads \"WARNING: SECURE AREA\"."
	icon_state = "securearea"

/obj/structure/sign/biohazard
	name = "\improper WARNING: BIOHAZARD sign"
	desc = "A warning sign which reads \"WARNING: BIOHAZARD\"."
	icon_state = "bio"

/obj/structure/sign/electricshock
	name = "\improper DANGER: HIGH VOLTAGE sign"
	desc = "A danger sign which reads \"DANGER: HIGH VOLTAGE\"."
	icon_state = "shock"

/obj/structure/sign/electricshock/tesla
	name = "\improper TESLA REACTOR - DANGER: HIGH VOLTAGE sign"
	desc = "A danger sign which reads \"TESLA REACTOR - DANGER: HIGH VOLTAGE\" and \"HIGH POWER MAGNETIC FIELDS IN USE\"."
	icon_state = "shock"

/obj/structure/sign/fire
	name = "\improper DANGER: FIRE sign"
	desc = "A danger sign which reads \"DANGER: FIRE\"."
	icon_state = "fire"

/obj/structure/sign/radiation
	name = "\improper RADIATION HAZARD sign"
	desc = "A hazard sign which reads \"RADIATION HAZARD\"."
	icon_state = "radiation"

/obj/structure/sign/drop
	name = "\improper DANGER: DROP HAZARD sign"
	desc = "A danger sign which reads \"DANGER: DROP HAZARD\"."
	icon_state = "drop"

/obj/structure/sign/vacuum
	name = "\improper DANGER: VACUUM sign"
	desc = "A danger sign which reads \"DANGER: VACUUM\"."
	icon_state = "vacuum"

/obj/structure/sign/crush
	name = "\improper DANGER: CRUSH HAZARD sign"
	desc = "A danger sign which reads \"DANGER: CRUSH HAZARD\" and \"AUTOMATIC EQUIPMENT STARTS AND STOPS AUTOMATICALLY\"."
	icon_state = "crush"

//
// Emergency Signs
//

// Emergency (Parent)
/obj/structure/sign/emergency
	name = "emergency sign"
	desc = "An emergency sign."
	icon_state = null

// Emergency
/obj/structure/sign/emergency/exit
	name = "\improper EMERGENCY EXIT sign"
	desc = "A green sign pointing towards an emergency exit."
	icon_state = "emerg_exit"

/obj/structure/sign/emergency/exit/ladder
	name = "\improper EMERGENCY EXIT LADDER sign"
	desc = "A green sign that depicts a person climbing the ladder towards the arrow's direction, pointing at the emergency exit."
	icon_state = "emerg_exitZ"

/obj/structure/sign/emergency/exit/stairs
	name = "\improper EMERGENCY EXIT STAIRS sign"
	desc = "A green sign that depicts a person using stairs towards the arrow's direction, pointing at the emergency exit."
	icon_state = "emerg_exitZ_stairs"

// Evacuation
/obj/structure/sign/emergency/evacuation
	name = "\improper EVACUATION ROUTE sign"
	desc = "A green sign pointing towards an evacuation route."
	icon_state = "emerg_exit"

/obj/structure/sign/emergency/evacuation/ladder
	name = "\improper EVACUATION ROUTE sign"
	desc = "A green sign that depicts a person climbing a ladder towards an evacuation route."
	icon_state = "emerg_exitZ"

/obj/structure/sign/emergency/evacuation/stairs
	name = "\improper EVACUATION ROUTE sign"
	desc = "A green sign that depicts a person using a stairwell, moving towards an evacuation route."
	icon_state = "emerg_exitZ_stairs"

/obj/structure/sign/emergency/evacuation/pods
	name = "\improper EVACUATION PODS sign"
	desc = "A green sign that depicts an evacuation pod, with the text \"EVACUATION PODS\" under it."
	icon_state = "emerg_pods"

// Miscellanous
/obj/structure/sign/emergency/meetingpoint
	name = "\improper EMERGENCY MEETING POINT sign"
	desc = "A green sign which depicts a group of people in the middle of the sign, being pointed at by arrows."
	icon_state = "meeting_point"

// Paintings

/obj/structure/sign/painting_frame
	name = "empty frame"
	desc = "An empty painting frame."
	icon_state = "painting_frame"
	w_class = ITEMSIZE_SMALL

/obj/item/sign/painting_frame
	name = "empty frame"
	desc = "An empty painting frame."
	icon_state = "painting_frame"
	w_class = ITEMSIZE_SMALL

/obj/structure/sign/painting_frame/tsunami_kami
	name = "tsunami kami"
	desc = "A painting designed to replicate traditional woodblock styles. This one seems to be based off an ancient and venerable painting of a wave, paired with that of a woman."
	icon_state = "tsunami_kami"
	w_class = ITEMSIZE_SMALL

/obj/structure/sign/painting_frame/hadii
	name = "president Hadii portrait"
	desc = "A portrait of President Hadii. An essential item in any Hadiist household."
	icon_state = "hadii_painting"
	desc_extended = "A state-endorsed cult of personality has been established around President Hadii. Through a robust propaganda system, republican citizens are informed daily about Malik's \
	achievements and how only through his guidance the Republican can prosper. Portraits of President Hadii can be found in most Hadiist homes and government buildings. Njadrasanukii is known for \
	his speeches praising his own administration and the bravery of his people; his voice can be heard frequently on the radio. While many admire him as a strong leader, others fear his ruthless \
	ways of dealing with the opposition."

/obj/item/sign/painting_frame/hadii
	name = "president Hadii portrait"
	desc = "A portrait of President Hadii. An essential item in any Hadiist household."
	icon_state = "hadii_painting"
	sign_state = "hadii_painting"
	desc_extended = "A state-endorsed cult of personality has been established around President Hadii. Through a robust propaganda system, republican citizens are informed daily about Malik's \
	achievements and how only through his guidance the Republican can prosper. Portraits of President Hadii can be found in most Hadiist homes and government buildings. Njadrasanukii is known for \
	his speeches praising his own administration and the bravery of his people; his voice can be heard frequently on the radio. While many admire him as a strong leader, others fear his ruthless \
	ways of dealing with the opposition."

/obj/structure/sign/painting_frame/nated
	name = "supreme commander Nated portrait"
	desc = "A portrait of Supreme Ccommander Nated. Commonly seen in junta controlled territories."
	icon_state = "nated_painting"
	desc_extended = "For a decade, Halkiikijr led the Liberation Army as an effective opposing force against the People's Republic and the New Kingdom. He favored the extensive use of irregular \
	warfare coupled with the deployment of the army to secure decisive battles. A cult of personality formed around Halkiikijr; extremists claimed that he was a prophet sent by the Gods. The \
	Supreme Commander took advantage of this belief to cultivate undying loyalty and fanaticism among his followers."

/obj/item/sign/painting_frame/nated
	name = "supreme commander Nated portrait"
	desc = "A portrait of Supreme Ccommander Nated. Commonly seen in junta controlled territories."
	icon_state = "nated_painting"
	sign_state = "nated_painting"
	desc_extended = "For a decade, Halkiikijr led the Liberation Army as an effective opposing force against the People's Republic and the New Kingdom. He favored the extensive use of irregular \
	warfare coupled with the deployment of the army to secure decisive battles. A cult of personality formed around Halkiikijr; extremists claimed that he was a prophet sent by the Gods. The \
	Supreme Commander took advantage of this belief to cultivate undying loyalty and fanaticism among his followers."

/obj/structure/sign/painting_frame/harrlala
	name = "President Harrlala portrait"
	desc = "A portrait of President Almrah Harrlala. The current leader of the Al'mariist civilian government."
	icon_state = "harrlala_painting"
	desc_extended = "Following the Armistice, President Almrah Harrlala continued with her internal policies while maintaining a strong stance against foreign dominance. Under her rule, schools to \
	preserve local cultures and languages were established, Gakal’zaal was liberated from the Unathi rule, and the DPRA developed its nuclear program. Her status as one of the first female rulers \
	in modern Tajaran history has inspired many women to engage in DPRA politics. However, her regime is plagued with deep issues. The ghost of separatism lingers over the nation after the Amohdan \
	attempt to secede. Her ability to reconcile the various factions in the government was severely doubted when she failed to draw a plan to handle the rebellious island. Since the return of \
	Halkiikijr to power, the authoritarian elements see this as a moment of weakness in the young Republic. President Harrlala must be ready to face further opposition if she wants to see her \
	vision of Adhomai come to life."

/obj/item/sign/painting_frame/harrlala
	name = "President Harrlala portrait"
	desc = "A portrait of President Almrah Harrlala. The current leader of the Al'mariist civilian government."
	icon_state = "harrlala_painting"
	sign_state = "harrlala_painting"
	desc_extended = "Following the Armistice, President Almrah Harrlala continued with her internal policies while maintaining a strong stance against foreign dominance. Under her rule, schools to \
	preserve local cultures and languages were established, Gakal’zaal was liberated from the Unathi rule, and the DPRA developed its nuclear program. Her status as one of the first female rulers \
	in modern Tajaran history has inspired many women to engage in DPRA politics. However, her regime is plagued with deep issues. The ghost of separatism lingers over the nation after the Amohdan \
	attempt to secede. Her ability to reconcile the various factions in the government was severely doubted when she failed to draw a plan to handle the rebellious island. Since the return of \
	Halkiikijr to power, the authoritarian elements see this as a moment of weakness in the young Republic. President Harrlala must be ready to face further opposition if she wants to see her \
	vision of Adhomai come to life."

/obj/structure/sign/painting_frame/almari
	name = "president Al'mari portrait"
	desc = "A portrait of President Al'mari Hadii. An idol to Hadiist and Al'mariists."
	icon_state = "almarii_painting"

/obj/item/sign/painting_frame/almari
	name = "president Al'mari portrait"
	desc = "A portrait of President Al'mari Hadii. An idol to Hadiist and Al'mariists."
	icon_state = "almarii_painting"
	sign_state = "almarii_painting"

/obj/structure/sign/painting_frame/vahzirthaamro
	name = "king Vahzirthaamro portrait"
	desc = "A portrait of King Vahzirthaamro Azunja. Even after his death, the King remains an important figure."
	icon_state = "vahzirthaamro_painting"
	desc_extended = "In 2449, in the middle of the night, Vahzirthaamro was released in secret along with the entirety of his retinue, as they quickly spread from town to town, asking for assistance \
	from newly appointed officials and workers. Before long, the reminiscent families of the Kaltir region were happy to rejoin their flock. By 2450 his claim to rule had spread to all of Northern \
	Harr'masir, and the New Kingdom of Adhomai officially seceded as an independent nation under the newly declared King Vahzirthaamro Azunja. He then led the Kingdom for the next decade, \
	managing the balance between the different factions within the government and the ongoing war. Vahzirthaamro became a unifying figure for the population. After successfully securing Kaltir's \
	ancient lands and negotiating the armistice that brought the end to the war, King Vahzirthaamro passed away in 2463. "

/obj/item/sign/painting_frame/vahzirthaamro
	name = "king Vahzirthaamro portrait"
	desc = "A portrait of King Vahzirthaamro Azunja. Even after his death, the King remains an important figure."
	icon_state = "vahzirthaamro_painting"
	sign_state = "vahzirthaamro_painting"
	desc_extended = "In 2449, in the middle of the night, Vahzirthaamro was released in secret along with the entirety of his retinue, as they quickly spread from town to town, asking for assistance \
	from newly appointed officials and workers. Before long, the reminiscent families of the Kaltir region were happy to rejoin their flock. By 2450 his claim to rule had spread to all of Northern \
	Harr'masir, and the New Kingdom of Adhomai officially seceded as an independent nation under the newly declared King Vahzirthaamro Azunja. He then led the Kingdom for the next decade, \
	managing the balance between the different factions within the government and the ongoing war. Vahzirthaamro became a unifying figure for the population. After successfully securing Kaltir's \
	ancient lands and negotiating the armistice that brought the end to the war, King Vahzirthaamro passed away in 2463. "

/obj/structure/sign/painting_frame/shumaila
	name = "queen Shumaila portrait"
	desc = "A portrait of Queen Shumaila Azunja. Despite her short reign, she already has attracted a loyal following."
	icon_state = "shumaila_painting"
	desc_extended = "Since entering the public eye in 2459, Shumaila enjoys much support from the women of Kaltir. Many look to her as an inspiration, buying military style jackets to emulate her \
	look, given that Shumaila became one of the few Tajara women to lead a nation. However, this fame has also led to calls from the nobility and her family to choose a husband. Shumaila retains \
	that her marriage comes after her coronation. She was finally crowned in 2463 after King Azunja passed away. Outside of continuing her uncle's legacy, her plans to the Kingdom are still unclear to the wide public."

/obj/item/sign/painting_frame/shumaila
	name = "queen Shumaila portrait"
	desc = "A portrait of Queen Shumaila Azunja. Despite her short reign, she already has attracted a loyal following."
	icon_state = "shumaila_painting"
	sign_state = "shumaila_painting"
	desc_extended = "Since entering the public eye in 2459, Shumaila enjoys much support from the women of Kaltir. Many look to her as an inspiration, buying military style jackets to emulate her \
	look, given that Shumaila became one of the few Tajara women to lead a nation. However, this fame has also led to calls from the nobility and her family to choose a husband. Shumaila retains \
	that her marriage comes after her coronation. She was finally crowned in 2463 after King Azunja passed away. Outside of continuing her uncle's legacy, her plans to the Kingdom are still unclear to the wide public."

/obj/item/sign/painting_frame/goddess
	name = "tribunal triptych"
	desc = "A small portrait of the Goddess. Representative of all three Aspects in one: the Tribunal."
	icon_state = "goddess_unaspected"
	sign_state = "goddess_unaspected"
	desc_extended = "An all-powerful and all-knowing female supreme deity, the Goddess is the highest authority in the Moroz Holy Tribunal. Also \
	known as Our Lady of Moroz, the Goddess is said to dwell on a utopian version of Moroz referred to as the Morozian Kingdom, or Kingdom of Moroz, \
	where the souls of righteous Tribunalists pass to after they leave the mortal realm."

/obj/structure/sign/painting_frame/goddess
	name = "tribunal triptych"
	desc = "A small portrait of the Goddess. Representative of all three Aspects in one: the Tribunal."
	icon_state = "goddess_unaspected"
	desc_extended = "An all-powerful and all-knowing female supreme deity, the Goddess is the highest authority in the Moroz Holy Tribunal. Also \
	known as Our Lady of Moroz, the Goddess is said to dwell on a utopian version of Moroz referred to as the Morozian Kingdom, or Kingdom of Moroz, \
	where the souls of righteous Tribunalists pass to after they leave the mortal realm."

/obj/item/sign/painting_frame/goddess/soldier
	name = "icon of the soldier"
	desc = "A small portrait of the Goddess, representing the Aspect of the Soldier."
	icon_state = "goddess_soldier"
	sign_state = "goddess_soldier"
	desc_extended = "Commonly worshiped by House Strelitz and the naval sections of House Zhao, the Soldier aspect of the Goddess is beloved by many members \
	of the Imperial military and the Tribunal Investigations Constabulary. This aspect is generally depicted as wearing antiquated armor in the style of the \
	knights of old Earth and often wielding an ornate sword while carrying the Imperial standard aloft, though some depictions- particularly those of \
	the 56th Jadranic Infantry Regiment- discard this antiquated appearance for the arms and armor of the modern Imperial Army."

/obj/structure/sign/painting_frame/goddess/soldier
	name = "icon of the soldier"
	desc = "A small portrait of the Goddess, representing the Aspect of the Soldier."
	icon_state = "goddess_soldier"
	desc_extended = "Commonly worshiped by House Strelitz and the naval sections of House Zhao, the Soldier aspect of the Goddess is beloved by many members \
	of the Imperial military and the Tribunal Investigations Constabulary. This aspect is generally depicted as wearing antiquated armor in the style of the \
	knights of old Earth and often wielding an ornate sword while carrying the Imperial standard aloft, though some depictions- particularly those of \
	the 56th Jadranic Infantry Regiment- discard this antiquated appearance for the arms and armor of the modern Imperial Army."

/obj/item/sign/painting_frame/goddess/artisan
	name = "icon of the artisan"
	desc = "A small portrait of the Goddess, representing the Aspect of the Artisan."
	icon_state = "goddess_artisan"
	sign_state = "goddess_artisan"
	desc_extended = "Commonly worshiped by the more mercantile section of House Caladius, many tradesmen, and wealthy businesspeople across the Empire, \
	the Artisan aspect of the Goddess is beloved by tradesmen, merchants, and those involved in the financial sector. Depictions of this aspect vary somewhat \
	but generally fall into two categories: some depict the Artisan as wearing the clothing of House Caladius, while others depict Her in house-neutral businesswear. \
	Some depictions of the Artisan clad the Goddess in the boilersuit uniform of a typical Imperial factory worker to symbolize the efforts even Ma’zals make to better the Empire."

/obj/structure/sign/painting_frame/goddess/artisan
	name = "icon of the artisan"
	desc = "A small portrait of the Goddess, representing the Aspect of the Artisan."
	icon_state = "goddess_artisan"
	desc_extended = "Commonly worshiped by the more mercantile section of House Caladius, many tradesmen, and wealthy businesspeople across the Empire, \
	the Artisan aspect of the Goddess is beloved by tradesmen, merchants, and those involved in the financial sector. Depictions of this aspect vary somewhat \
	but generally fall into two categories: some depict the Artisan as wearing the clothing of House Caladius, while others depict Her in house-neutral businesswear. \
	Some depictions of the Artisan clad the Goddess in the boilersuit uniform of a typical Imperial factory worker to symbolize the efforts even Ma’zals make to better the Empire."

/obj/item/sign/painting_frame/goddess/scholar
	name = "icon of the scholar"
	desc = "A small portrait of the Goddess, representing the Aspect of the Scholar."
	icon_state = "goddess_scholar"
	sign_state = "goddess_scholar"
	desc_extended = "Commonly worshiped by House Volvalaad and the engineering sections of House Zhao, the Scholar aspect of the Goddess is beloved \
	by the Empire’s scientists, academics, and researchers. This aspect is often pictured wearing the uniform of a researcher and often depicts the Goddess \
	as holding an open book and writing in it with an inkwell pen- items which are intended to symbolically represent the quest for knowledge is ever ongoing. \
	Some depictions, particularly those commissioned by House Volvalaad, depict the Goddess as holding the human genome in her hands; a symbolic representation of \
	the Volvalaad’s mastery of geneboosting."

/obj/structure/sign/painting_frame/goddess/scholar
	name = "icon of the scholar"
	desc = "A small portrait of the Goddess, representing the Aspect of the Scholar."
	icon_state = "goddess_scholar"
	desc_extended = "Commonly worshiped by House Volvalaad and the engineering sections of House Zhao, the Scholar aspect of the Goddess is beloved \
	by the Empire’s scientists, academics, and researchers. This aspect is often pictured wearing the uniform of a researcher and often depicts the Goddess \
	as holding an open book and writing in it with an inkwell pen- items which are intended to symbolically represent the quest for knowledge is ever ongoing. \
	Some depictions, particularly those commissioned by House Volvalaad, depict the Goddess as holding the human genome in her hands; a symbolic representation of \
	the Volvalaad’s mastery of geneboosting."

/obj/item/sign/painting_frame/martyr
	name = "icon of the captain"
	desc = "A small portrait of Captain Lotte Kiefer, a Tribunalist martyr."
	icon_state = "martyr_lotte"
	sign_state = "martyr_lotte"
	desc_extended = "Born in 2332 to a family of Strelitz-affiliated minor nobles, Captain Lotte Kiefer of the Imperial Alliance’s Army rose through the ranks \
	of the early Imperial Army to become its youngest Captain and was in command of the 74th Jinxiang Infantry Company when  the War of Moroz broke out in 2355. \
	Called to duty by the Imperial Alliance, Kiefer and the 74th eagerly answered the call and volunteered to serve as a vanguard force intended to take and secure \
	a Tribunalist cathedral within the Confederated States’ borders in Outer Fisanduh out of a fear non-Tribunalist Fisanduhians would destroy it. Throwing caution \
	to the wind and placing their faith in the Goddess upon their holy mission, Kiefer and the 74th surged forward faster than any other Imperial unit and arrived \
	at the cathedral shortly before the Confederated States of Fisanduh Army was about to detonate the structure. Kiefer perished in the fighting- killed instantly \
	by a sniper’s bullet during an assault- but the 74th ultimately took the cathedral intact, preserving it for generations of future Tribunalists. In 2367 Kiefer \
	was declared a Holy Martyr and is commonly venerated in her home of Jinxiang and throughout the Imperial Army."

/obj/structure/sign/painting_frame/martyr
	name = "icon of the captain"
	desc = "A small portrait of Captain Lotte Kiefer, a Tribunalist martyr."
	icon_state = "martyr_lotte"
	desc_extended = "Born in 2332 to a family of Strelitz-affiliated minor nobles, Captain Lotte Kiefer of the Imperial Alliance’s Army rose through the ranks \
	of the early Imperial Army to become its youngest Captain and was in command of the 74th Jinxiang Infantry Company when  the War of Moroz broke out in 2355. \
	Called to duty by the Imperial Alliance, Kiefer and the 74th eagerly answered the call and volunteered to serve as a vanguard force intended to take and secure \
	a Tribunalist cathedral within the Confederated States’ borders in Outer Fisanduh out of a fear non-Tribunalist Fisanduhians would destroy it. Throwing caution \
	to the wind and placing their faith in the Goddess upon their holy mission, Kiefer and the 74th surged forward faster than any other Imperial unit and arrived \
	at the cathedral shortly before the Confederated States of Fisanduh Army was about to detonate the structure. Kiefer perished in the fighting- killed instantly \
	by a sniper’s bullet during an assault- but the 74th ultimately took the cathedral intact, preserving it for generations of future Tribunalists. In 2367 Kiefer \
	was declared a Holy Martyr and is commonly venerated in her home of Jinxiang and throughout the Imperial Army."

/obj/item/sign/painting_frame/martyr/matteo
	name = "icon of the constable"
	desc = "A small portrait of Tribunalist Constable Matteo Torres, a Tribunalist martyr."
	icon_state = "martyr_matteo"
	sign_state = "martyr_matteo"
	desc_extended = "Born in 2355 to a minor Secondary family aligned with House Caladius, Tribunalist Constable Maximo Torres was a Senior Constable assigned to assist \
	and protect Tribunalist clergy in Outer Fisanduh during the peak of the Fisanduh Freedom Front’s activities in the late 24th century. A devout Tribunalist and resolute \
	constable, Torres ensured no harm came to his charges and endeared himself to the local Fisanduhians in his county by working to understand their grievances. But despite \
	his efforts the 3F still attempted to assault and kill his charges and would have succeeded on 19 December, 2398, if not for his sacrifice. At the moment an improvised \
	explosive device detonated Torres, thinking nothing of himself, threw himself bodily in front of a priestess and took a piece of shrapnel which would have certainly killed her. \
	Unfortunately, Senior Constable Torres bled out shortly after shooting his attacker dead with his service revolver. It is a testament to his character that Fisanduhian \
	Tribunalists them escorted his body and his living charge to the nearest Gendarmerie station unharmed. Senior Constable Torres was quickly declared a Holy Martyr in 2399 \
	and is commonly venerated by officers of both the Tribunal Investigations Constabulary and the secular Imperial Dominian Constabulary."

/obj/structure/sign/painting_frame/martyr/matteo
	name = "icon of the constable"
	desc = "A small portrait of Tribunalist Constable Matteo Torres, a Tribunalist martyr."
	icon_state = "martyr_matteo"
	desc_extended = "Born in 2355 to a minor Secondary family aligned with House Caladius, Tribunalist Constable Maximo Torres was a Senior Constable assigned to assist \
	and protect Tribunalist clergy in Outer Fisanduh during the peak of the Fisanduh Freedom Front’s activities in the late 24th century. A devout Tribunalist and resolute \
	constable, Torres ensured no harm came to his charges and endeared himself to the local Fisanduhians in his county by working to understand their grievances. But despite \
	his efforts the 3F still attempted to assault and kill his charges and would have succeeded on 19 December, 2398, if not for his sacrifice. At the moment an improvised \
	explosive device detonated Torres, thinking nothing of himself, threw himself bodily in front of a priestess and took a piece of shrapnel which would have certainly killed her. \
	Unfortunately, Senior Constable Torres bled out shortly after shooting his attacker dead with his service revolver. It is a testament to his character that Fisanduhian \
	Tribunalists them escorted his body and his living charge to the nearest Gendarmerie station unharmed. Senior Constable Torres was quickly declared a Holy Martyr in 2399 \
	and is commonly venerated by officers of both the Tribunal Investigations Constabulary and the secular Imperial Dominian Constabulary."

/obj/item/sign/painting_frame/martyr/valeria
	name = "icon of the commoner"
	desc = "A small portrait of Valeria Pokorni, a Tribunalist martyr."
	icon_state = "martyr_valeria"
	sign_state = "martyr_valeria"
	desc_extended = "Born c. 2403 to an impoverished and rural algae farming family on Sun Reach, Valeria Pokorni, along with the rest of her family, were early Tribunalist converts \
	upon the remote world then ruled over by the Pirate Lords. The Pokorni family practiced their faith in secret but kept to the Edicts and were ultimately delivered from the evil of \
	the Pirate Lords by the Imperial Army’s intervention in 2422, which they welcomed with open arms. Valeria soon found work as a medical assistant for the 23rd Jadranic Infantry Regiment \
	and proved herself a useful member of its support staff who endeared herself to the regimental medical team, even if her Vulgar Morozi was halting at best. Tragedy, however, struck in \
	early 2423 when rebels against the Imperial Army ambushed the 23rd’s medical tent and attempted to slaughter its unarmed staff. Valeria, thinking nothing of her own safety, blocked the \
	door to the tent with her body as the insurgents attempted to shoot through it. While she ultimately perished to gunfire, her sacrifice allowed the medical tent to be evacuated and let \
	the 23rd capture all insurgents involved in the attack. Formerly a frontierswoman with no nation to call her own, she was buried with military honors and became the first Holy Martyr of \
	Sun Reach in 2426. She is commonly venerated on Sun Reach and by Ma’zals throughout the Empire."

/obj/structure/sign/painting_frame/martyr/valeria
	name = "icon of the commoner"
	desc = "A small portrait of Valeria Pokorni, a Tribunalist martyr."
	icon_state = "martyr_valeria"
	desc_extended = "Born c. 2403 to an impoverished and rural algae farming family on Sun Reach, Valeria Pokorni, along with the rest of her family, were early Tribunalist converts \
	upon the remote world then ruled over by the Pirate Lords. The Pokorni family practiced their faith in secret but kept to the Edicts and were ultimately delivered from the evil of \
	the Pirate Lords by the Imperial Army’s intervention in 2422, which they welcomed with open arms. Valeria soon found work as a medical assistant for the 23rd Jadranic Infantry Regiment \
	and proved herself a useful member of its support staff who endeared herself to the regimental medical team, even if her Vulgar Morozi was halting at best. Tragedy, however, struck in \
	early 2423 when rebels against the Imperial Army ambushed the 23rd’s medical tent and attempted to slaughter its unarmed staff. Valeria, thinking nothing of her own safety, blocked the \
	door to the tent with her body as the insurgents attempted to shoot through it. While she ultimately perished to gunfire, her sacrifice allowed the medical tent to be evacuated and let \
	the 23rd capture all insurgents involved in the attack. Formerly a frontierswoman with no nation to call her own, she was buried with military honors and became the first Holy Martyr of \
	Sun Reach in 2426. She is commonly venerated on Sun Reach and by Ma’zals throughout the Empire."

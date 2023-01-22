/obj/item/storage/box/fancy/cigarettes/pra
	name = "\improper Labourer's Choice cigarette packet"
	desc = "Jokingly referred to an essential part of a working class citizen's breakfast, beside state-provided provisions."
	desc_extended = "Imported from the People's Republic of Adhomai."
	icon_state = "prapacket"
	item_state = "Dpacket"
	storage_slots = 7
	cigarette_to_spawn = /obj/item/clothing/mask/smokable/cigarette/adhomai
	can_hold = list(/obj/item/clothing/mask/smokable/cigarette, /obj/item/flame/lighter, /obj/item/trash/cigbutt, /obj/item/tajcard)

/obj/item/storage/box/fancy/cigarettes/pra/update_icon()
	. = ..()
	var/card_count = instances_of_type_in_list(new /obj/item/tajcard, src.contents) //having cards in here doesn't count for icon
	if(opened)
		icon_state = "[initial(icon_state)][contents.len - card_count]"

/obj/item/storage/box/fancy/cigarettes/pra/fill()
	..()
	new /obj/item/tajcard(src)

/obj/item/storage/box/fancy/cigarettes/dpra
	name = "\improper Shastar List'ya cigarette packet"
	desc = "Rumored to be a de-facto currency for Adhominian knuckles off-planet."
	desc_extended = "Imported from the Democratic People's Republic of Adhomai."
	icon_state = "dprapacket"
	item_state = "Bpacket"
	cigarette_to_spawn = /obj/item/clothing/mask/smokable/cigarette/adhomai

/obj/item/storage/box/fancy/cigarettes/nka
	name = "\improper Gato Royales cigarette packet"
	desc = "Popular with the aristocrats of the New Kingdom of Adhomai for its mild menthol flavor."
	desc_extended = "Imported from the New Kingdom of Adhomai."
	icon_state = "nkapacket"
	item_state = "Fpacket"
	cigarette_to_spawn = /obj/item/clothing/mask/smokable/cigarette/adhomai

/obj/item/tajcard
	name = "collectable tajaran card"
	desc = "A collectable card with an illustration of a famous Tajaran figure, usually found inside cigarette packets."
	icon = 'icons/obj/playing_cards.dmi'
	icon_state = "tajcig"
	drop_sound = 'sound/items/drop/paper.ogg'
	pickup_sound = 'sound/items/pickup/paper.ogg'
	w_class = ITEMSIZE_SMALL
	var/list/figures = list("hadii", "tesla", "headmaster", "commissar", "almanq", "yasmin", "andrey", "paratrooper", "scout")

/obj/item/tajcard/Initialize()
	. = ..()
	var/selected = pick(figures)
	set_card(selected)

/obj/item/tajcard/proc/set_card(var/figure)
	if(!figure)
		return

	icon_state = "tajcig_[figure]"

	switch(figure)

		if("hadii")
			desc += " This one has the picture of President Njadrasanukii Hadii."
			desc_extended = "Njadrasanukii Hadii was born in 2402 to the noble Njarir'Akhran Hadii line. He got involved with the military at an early age, becoming a cadet for the \
			Royal Navy at 16. During the revolution, he briefly fought for the loyalists but was recalled to the Hadii Citadel to help defend his family's ancestral home. Following the \
			revolution and the Hadii's rise in the new Federal Republic, Njadrasanukii was given the office of Vice-President under his brother Al'Mari Hadii. He assumed the office of \
			president on 2451 after the assassination of his brother. Infamous for his harsh decrees and tendency to betray his word, Njadrasanukii is not trustworthy but holds the \
			planet of Adhomai in his iron grip nonetheless."

		if("tesla")
			desc += " This one has the picture of a tesla trooper."
			desc_extended = "Formed in 2461, the Tesla Brigade is an experimental force composed of augmented veterans. Created after the intense casualties of the Das'nrra campaign and the \
			severe loss of Republican Guard units. Additional funding and focus was placed on a previously shelved proposal for heavily armed shock and high technology assault troopers. A \
			special unit designated to withstand the numerical disadvantages and prolonged engagements special forces of the Republic often faces."

		if("headmaster")
			desc += " This one has the picture of Headmaster Harrrdanim Tyr'adrr."
			desc_extended = "Harrrdanim was born in 2411 to an M'sai line. He entered military service at a young age. His high intelligence and robust health soon had him successfully \
			enter the Royal Enforcers; the elite all-M'sai special forces available to the nobility. He was taken prisoner during the First Revolution and released uner condition that \
			he acts as a spy against subversive elements. Soon Harrrdanim became known as one of the most effective and ruthless secret agents available to the government and eventually \
			rose the ranks to become Headmaster of the People's Strategic Intelligence Service. He is known and feared across Adhomai and has spawned an entire 'spy thriller' genre in \
			the Republic."

		if("commissar")
			desc += " This one has the picture of party commissar."
			desc_extended = "Party Commissars are high ranking members of the Party of the Free Tajara under the Leadership of Hadii attached to army units, who ensures that soldiers and \
			their commanders follow the principles of Hadiism. Their duties are not only limited to enforcing the republican ideals among the troops and reporting possible subversive elements, \
			they are expected to display bravery in combat and lead by example."

		if("almanq")
			desc += " This one has the picture of Rikdar Al'Manq."
			desc_extended = "Rikdar was born on 2429 the noble Njarir'Akhran Bayan line in Nal'Tor. However, his parents were disappeared by Republic secret police in one of the \
			frequent purges of Njarir'Akhran and he was put into state-run foster care. He has raised in the House Of Young Patriots orphanage until he was adopted at 14 to Hharar \
			parents and took their last name of Al'Manq. Rikdar graduated university on at 20 years old in 2450 with a Bachelors of Arts. Having already received several high-profile \
			commissions, including the then-President Al'Mari Hadii, whose portrait was done a week before his death. Rikdar remains extremely popular on Adhomai. The People's Republic \
			remains a quiet supporter of his work, and state officials pay him handsome commissions for their portraits to be done."

		if("yasmin")
			desc += " This one has the picture of Yasmin Piaf."
			desc_extended = "Yasmin Piaf, was born in 2434 in the suburbs of Nal'tor to a particularly well off Njarir'Akhran family. Even from her young age, \
			Yasmin was interested in music. She was part of her school's choir and participated in several nation-wide contests for the honor of singing for President Rhagrrhuzau Hadii. \
			Eventually, she graduated and went on to the Academy of Musical Arts with full scholarship. Yet her voice, described by some as angelic and innocent, found purchase with an \
			aging generation of Tajara who wished a brief return to peaceful normalcy following the First Revolution. Yasmin Piaf has become one of the most famous singers in the modern \
			era - one who has fostered a close relationship with State officials."

		if("andrey")
			desc += " This one has the picture of Andrey Borisov."
			desc_extended = "Born in 2416 to aline of M'sai warriors, Andrey was not even two years old before humanity stumbled across Adhomai and lit the flame that ignited the \
			First Revolution. As the newly founded People's Republic began the arduous transition from a movement to a government, Andrey's connections with the upper echelon of \
			PRA politicians bore fruit. He was taken on as a member of an officer's general staff, headquartered in Nal'Tor. His position put him in contact with the elite, however, \
			and many found him charming and personable. His ascension from lowly	secretary to the major news anchor was one that involved plenty of political maneuvering, money - \
			and, rumored by some, violence - but ultimately Andrey had proved his loyalty to the political elite of the People's Republic and he was rewarded with the honor of being their mouthpiece"

		if("paratrooper")
			desc += " This one has the picture of a republican guard."
			desc_extended = "Following the end of the first revolution, many veterans especially of the Ha'narr Corps had become hardened warriors with exceptional abilities. \
			Seeking to mate the heavily refined combat effectiveness of shock troop units which formed among front-line infantry with the survival skills and mobility of the Ha'narrii, \
			the Republican Guard was formed by absorbing all of these units as a hard-hitting highly mobile airborne special forces unit in 2435. They primarily draw recruits from \
			promising and outstanding members of the Ha'narr Corps, as well as shock infantry divisions, not at all unlike their original founding members. Their iconic light blue \
			berets inspire awe and admiration on the battlefield among their teammates, and fear among their enemies. The Republican Guard primarily deploys by airdropping from high \
			altitude aircraft in special thick cold resistant pressurized soft suits, and unlike the Ha'narr, carry a considerable amount of equipment for combat operations."

		if("scout")
			desc += " This one has the picture of a Ha'narr scout."
			desc_extended = "Originally formed in 2421 during the first revolution, the Ha'narr Corps served as a reconnaissance, scouting and special operations unit for the \
			rebellion. Although it was disbanded at the end of the first revolution, it was reformed at the dawn of the second revolution as the inflexibility of the Republican Army \
			proved to be a vital weakness which these units corrected for. The training regime for Ha'narrii is typically anywhere in between one to three months, with recruits trained \
			in basic survival and reconnaissance skills emphasizing on self dependence within the frozen wilderness of Adhomai.  As a scouting unit, Ha'narri travel lightly on equipment, \
			carrying primarily the essentials for survival and only a token amount of ammunition. Many detachments also make use of snow skiis in order to travel quickly in mountainous regions. \
			They are well-known for their iconic thick light-colored cloaks which they wear while traversing the vast countrysides for warmth, as well as camouflage."

/obj/item/pocketwatch/adhomai
	name = "adhomian watch"
	desc = "A watch made in the traditional adhomian style. It can be stored in a pocket or worn around the neck."
	desc_extended = "Baltoris a fortress founded during the Gunpowder Age; it was the landing site of the royal armies during the Suns'wars. Baltor plays a strategic role in controlling the \
	Ras'val sea during the war. A town emerged around the fort over time, attracted by the safety provided by the military presence. The city is known for its skilled watchmaker artisans, \
	a trade that has been passed down through generations. The Mez'gin clock tower, located at the town square, is one of its points of interest."
	icon = 'icons/obj/tajara_items.dmi'
	icon_state = "adhomai_clock"
	item_state = "adhomai_clock"
	contained_sprite = TRUE
	slot_flags = SLOT_MASK
	var/static/months = list("Menshe-aysaif", "Sil'nryy-aysaif", "Menshe-rhazzimy", "Sil'nryy-rhazzimy")

/obj/item/pocketwatch/adhomai/get_mask_examine_text(mob/user)
	return "around [user.get_pronoun("his")] neck"

/obj/item/pocketwatch/adhomai/checktime(mob/user)
	set category = "Object"
	set name = "Check Time"
	set src in usr

	if(closed)
		to_chat(usr, SPAN_WARNING("You check your watch, realising it's closed."))
	else

		var/adhomian_year = game_year + 1158
		var/current_month = text2num(time2text(world.realtime, "MM"))
		var/current_day = text2num(time2text(world.realtime, "DD"))
		var/adhomian_day
		var/adhomian_month = src.months[Ceil(current_month/3)]
		switch(current_month)
			if(2, 5, 8, 11)
				current_day += 31
			if(6, 9, 12)
				current_day += 61
			if(3)
				current_day += 59 + isLeap(text2num(time2text(world.realtime, "YYYY"))) // we can conveniently use the result of `isLeap` to add 1 when we are in a leap year
		var/real_time = text2num(time2text(world.time + (REALTIMEOFDAY - (TIME_OFFSET HOURS)), "hh"))
		var/adhomian_time = real_time
		if(ISEVEN(current_day))
			adhomian_time = real_time + 24
		adhomian_day = Floor(current_day / 2)
		to_chat(usr, "You check your [src.name], glancing over at the watch face, reading the time to be '[adhomian_time]'. Today's date is the '[adhomian_day]th day of [adhomian_month], [adhomian_year]'.")


/obj/item/flame/lighter/adhomai
	name = "adhomian lighter"
	desc = "An adhomian lighter, designed to protect the flame from the strong winds of the Tajaran homeworld."
	icon = 'icons/obj/tajara_items.dmi'
	icon_state = "trenchlighter"
	item_state = "trenchlighter"
	base_state = "trenchlighter"
	contained_sprite = TRUE
	activation_sound = 'sound/items/cigs_lighters/zippo_on.ogg'
	deactivation_sound = 'sound/items/cigs_lighters/zippo_off.ogg'
	drop_sound = 'sound/items/drop/accessory.ogg'
	pickup_sound = 'sound/items/pickup/accessory.ogg'
	var/protection = FALSE

/obj/item/flame/lighter/adhomai/update_icon()
	if(!protection)
		icon_state = "[base_state]"
		item_state = "[base_state]"
		return

	if(lit)
		icon_state = "[base_state]-on"
		item_state = "[base_state]-on"
	else
		icon_state = "[base_state]-proc"
		item_state = "[base_state]"

/obj/item/flame/lighter/adhomai/attack_self(mob/living/user)
	if(!protection)
		to_chat(user, SPAN_WARNING("You fail to light \the [src], you need to lift the windshield before lighting it."))
		return FALSE
	else
		..()

/obj/item/flame/lighter/adhomai/attack_hand(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.l_store == src && !H.get_active_hand())
			H.put_in_hands(src)
			H.l_store = null
			return
		if(H.r_store == src && !H.get_active_hand())
			H.put_in_hands(src)
			H.r_store = null
			return
		if(H.belt == src && !H.get_active_hand())
			H.put_in_hands(src)
			H.belt = null
			return

	if (loc == user)
		if(!lit)
			protection = !protection
			playsound(src.loc, 'sound/weapons/blade_open.ogg', 50, 1)
			update_icon()
	else
		..()

	add_fingerprint(user)

/obj/item/flame/lighter/adhomai/AltClick(mob/user)
	if(Adjacent(user) && !lit)
		protection = !protection
		playsound(src.loc, 'sound/weapons/blade_open.ogg', 50, 1)
		update_icon()
	
/obj/item/stack/dice/tajara
	name = "adhomian dice"
	desc = "An adhomian dice made out of wood. Commonly used to play Suns and Moon."
	icon = 'icons/obj/tajara_items.dmi'
	icon_state = "brother1"
	base_icon = "brother"

/obj/item/stack/dice/tajara/alt
	icon_state = "sister1"
	base_icon = "sister"

/obj/item/storage/pill_bottle/dice/tajara
	name = "bag of adhomian dice"
	desc = "A bag containing enough dice to play Suns and Moon."
	icon = 'icons/obj/tajara_items.dmi'
	desc_extended = "Suns and Moon is a very common dice game. It is played by all, though the lower classes have the tendency to gamble whereas upper classes play it just for fun. The ease and universality \
	of the rules has garnered it quite the reputation. Die will usually have an image of Rredouane fixed upon them. Parks will commonly have designated spots for people to play Suns and Moon. Disputes are \
	also solved through this game."
	starts_with = list(
		/obj/item/stack/dice/tajara = 3,
		/obj/item/stack/dice/tajara/alt = 3
	)

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
	cigarette_to_spawn = /obj/item/clothing/mask/smokable/cigarette/adhomai/menthol

/obj/item/tajcard
	name = "collectable tajaran card"
	desc = "A collectable card with an illustration of a famous Tajaran figure, usually found inside cigarette packets."
	icon = 'icons/obj/item/playing_cards.dmi'
	icon_state = "tajcig"
	drop_sound = 'sound/items/drop/paper.ogg'
	pickup_sound = 'sound/items/pickup/paper.ogg'
	w_class = WEIGHT_CLASS_SMALL
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

/obj/item/clothing/wrists/watch/pocketwatch/adhomai
	name = "adhomian watch"
	desc = "A watch made in the traditional adhomian style. It can be stored in a pocket or worn around the neck."
	desc_extended = "Baltoris a fortress founded during the Gunpowder Age; it was the landing site of the royal armies during the Suns'wars. Baltor plays a strategic role in controlling the \
	Ras'val sea during the war. A town emerged around the fort over time, attracted by the safety provided by the military presence. The city is known for its skilled watchmaker artisans, \
	a trade that has been passed down through generations. The Mez'gin clock tower, located at the town square, is one of its points of interest."
	icon = 'icons/obj/tajara_items.dmi'
	icon_state = "adhomai_clock"
	item_state = "adhomai_clock"
	contained_sprite = TRUE
	slot_flags = SLOT_MASK | SLOT_WRISTS | SLOT_BELT | SLOT_S_STORE

/obj/item/clothing/wrists/watch/pocketwatch/adhomai/get_mask_examine_text(mob/user)
	return "around [user.get_pronoun("his")] neck"

/obj/item/clothing/wrists/watch/pocketwatch/adhomai/checktime(mob/user)
	set category = "Object.Equipped"
	set name = "Check Time"
	set src in usr

	if(closed)
		to_chat(usr, SPAN_WARNING("You check your watch, realising it's closed."))
	else
		to_chat(usr, SPAN_NOTICE("You check your [name], glancing over at the watch face, reading the time to be '[tajaran_time()]'. Today's date is the '[tajaran_date()]th day of [tajaran_month()], [tajaran_year()]'."))

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

/obj/item/journal/winter_quest
	name = "\improper Winter Quest rulebook"
	desc = "A core rulebook for winter quest, a tabletop roleplaying game originating from Little Adhomai."
	desc_extended = "The first pen-and-paper role-playing game created by a Tajara. Its rules are known to favor interpretation over dice rolls. Combat encounters are notoriously deadly and short. Since character death is common, the game has a fast character creation system. Winter Quest usually uses a fantasy world inspired by Adhomian mythology; however, other settings have been published using its rule set."
	icon_state = "winterquest"
	has_closed_overlay = FALSE
	color = null

/obj/item/journal/winter_quest/Initialize()
	. = ..()
	var/obj/item/folder/embedded/E = generate_index("Rules")
	var/obj/item/folder/embedded/W = generate_index("Supplementals")
	var/obj/item/paper/C = new /obj/item/paper(E)
	C.set_content("Character Creation", "<h1>Character Creation</h1><br>Characters are perhaps the most important part of a quest. They are the vessels through which the players experience the story laid out by the Story Master. As such, character creation is simple and flexible. Remember, the Winter Forest is a dangerous place. A character may be personal, but death is around every Shaan! \
	<br>The process of creating a character is simple. \
	<dl><dt><b>Step 1:</b> Choose an Ethnicity<dt> \
	<dd>M'sai, Zhan-Khazan, Hharar, or Njarir'akhran.</dd> \
	<dt><b>Step 2:</b> Choose a Name<dt> \
	<dt><b>Step 3:</b> Choose Archetype<dt> \
	<dd>Hunter, Mystic, Warrior, Scholar, Outlaw, Noble, Priest, Laborer, or Frontiersman.</dd> \
	<dt><b>Step 4:</b> Define Three Traits<dt> \
	<dd>Examples: Strong, Clever, Loyal or Silent, Quick, Cunning.</dd> \
	<dt><b>Step 5:</b> Define One Flaw<dt> \
	<dd>Examples: Impulsive, Cowardly, Distrusted.</dd> \
	<dt><b>Step 6:</b> Equipment<dt> \
	<dd>Each character begins with one weapon, one tool, and one personal item.</dd> \
	<dt><b>Step 7:</b> Background<dt> \
	<dd>A one or two-sentence origin story.</dd> \
	<dd>Example: Raska, a silent M'sai hunter, is strong, patient, and loyal, but distrusted by the village. She carries a bow, a hunting knife, and her father's Ma'ta'ke talisman.</dd><dl> \
	<br>After a character has been made, remember to verify it with the Story Master. Once they give the all-clear, the quest can begin!")
	var/obj/item/paper/T = new /obj/item/paper(E)
	T.set_content("Challenges and Combat", "<h1>Challenges</h1> \
	<br>A quest is nothing without obstacles to overcome. Throughout the quest, the Story Master will provide challenges to the progress of the questers. These challenges must be resolved through <b>resolutions</b>. These resolutions are short answers as to how the equipment, archetype, and traits of your character are capable of conquering the challenge. The other players alongside the Story Master then examine this resolution to determine whether it solves the challenge, or is incapable of besting the test. \
	<dl> <dt><b>Story Master's Question:</b><dt> \
	<dd>The Story Master will present a challenge, then ask '<i>How would your character conquer this challenge?</i>'</dd> \
	<dt><b>Player's Answer:</b><dt> \
	<dd>The player answers the Story Master with how their character's traits, equipment, and archetype would solve the challenge. Other characters may assist if permitted by the Story Master.</dd> \
	<dt><b>Judgement:</b><dt> \
	<dd>The other players and Story Master determine if the answer is convincing. They may ask questions to clarify. If the table thinks the answer is convincing, the player succeeds. If the answer is unconvincing or contradictory, the player fails.</dd> \
	<dt><b>Flaws matter:</b><dt> \
	<dd>If a character flaw is relevant to a challenge, it may override the traits of a character and automatically fail the challenge.</dd> \
	<br><h1>Combat</h1><br> \
	<br>No quest is complete without battles and heroism. Whether slaying bloodthirsty Ha'rron with a Kazarrhaldiye or harnessing the light of the Twin Suns, combat carries out much like any other challenge. The order of combat is determined narratively. The first character or creature to attack goes first, followed by the defender, then other characters and creatures as determined by their traits. \
	<br><br>An attack begins with an attempt. The character or creature makes an attack, and uses their traits and weapons to explain why this attack should be successful. The defender does the same with their own traits, equipment, and environment. The other players and Story Master determine who has the advantage in the conflict. One of three outcomes may result from combat: Deathly blow, wounding blow, or shielded blow. \
	<dl> <dt><b>First Strike:</b><dt> \
	<dd>The initiator of combat narrates their attack, and how their traits and weapons support their action.</dd> \
	<dt><b>Defender's Response:</b><dt> \
	<dd>The defender uses their traits, equipment, and environment to explain how they survive the attack.</dd> \
	<dt><b>Judgement:</b><dt> \
	<dd>The other players and Story Master determine if the answer is convincing. They may ask questions to clarify. If the table thinks the answer is convincing, the player succeeds. If the answer is unconvincing or contradictory, the player fails.</dd> \
	<dt><b>The Verdict:</b><dt> \
	<dd>One of three results may occur based on how high the advantage is for one side over the other.</dd> \
	<dd><b>Fatal Blow:</b> The defender dies.</dd> \
	<dd><b>Wounding Blow:</b> The defender survives, but is left with a new scar or permanent injury (new flaw).</dd> \
	<dd><b>Shielded Blow:</b> The defender survives successfully.</dd> \
	<dt><b>Riposte:</b><dt> \
	<dd>The defender may choose to either escape or counter attack.</dd> \
	<dd><b>Escape:</b> The defender runs from the confrontation. This may lead to a negative effect depending on context.</dd> \
	<dd><b>Counter Attack:</b> The defender becomes the attacker. The combat sequence resets.</dd>")
	var/obj/item/paper/P = new /obj/item/paper(E)
	P.set_content("Progress and Beyond the Forest", "<h1>Progress</h1> \
	<br>Progress on a quest comes in many forms. Knuckles, items, and maybe even reputation. However, each character progresses in their own way on a quest. Following key events along one's own winter quest, certain changes in a character may occur. \
	<dl><dt><b>Survival:</b><dt> \
	<dd>Surviving strenuous events, and possible combat, can result in a new flaw.</dd> \
	<dt><b>Success:</b><dt> \
	<dd>Completing a quest or major event can result in a new trait.</dd> \
	<dt><b>Change:</b><dt> \
	<dd>Some story events may change a character. Replace a trait with a flaw.</dd> \
	<br>Remember, flaws are not a bad thing. Stories are best when a character overcomes their flaws to achieve great feats. Each character is defined by their traits and flaws that show their history, their battles, and their successes or failures.  \
	<br><h1>Beyond the Forest</h1> \
	<br>Winter Quest was originally created to bring together players of all kinds to join in a creative and collaborative process. The setting of the Winter Forest and its fantastical denizens are not the only way to experience the joy of collaborative play. The heart of it all comes out when a collection of people get together to experience a story together. So do not limit yourself to the cold Winter Forest. The system is adaptable to all kinds of settings and play. Similarly, these rules are not law. Altering the guidelines listed above, adding new ones in, whatever the heart desires. It is in the hands of the Story Master and players to decide. So long as everyone involved agrees, the Spur is the limit. So get out there, and get questing.")
	var/obj/item/paper/S = new /obj/item/paper(W)
	S.set_content("Rredouane Mode and Discipline", "<h1>Rredouane Mode</h1> \
	<br>In lieu of the narrative conflict system, the use of Suns and Moon dice can be included into standard Winter Quest play for an additional level of tension, conflict, and a little luck. All challenges and conflicts are no longer decided by table judgement, but rather the results of the dice. \
	<br>When a challenge or conflict appears, the Story Master will determine the difficulty in besting the obstacle. This ranges from one to six dice. The player will similarly be granted a range of one to six dice based on their answer to the obstacle. The Player and Store Master then roll these dice and count any dice that land with a four or higher. Whoever has the higher number of success dice wins. In cases of a tie, an extra die is rolled until a winner is found. \
	<dl><dt><b>Step 1:</b> The Story Master presents a challenge or conflict.<dt> \
	<dd>Difficulty dictates the number of dice. Easy challenges have one die, but range up to 6 dice for the most difficult tasks.</dd> \
	<dt><b>Step 2:</b> The Player is granted one to six dice based on their answer.<dt> \
	<dd>Much like a traditional challenge or conflict, the Player may use their character's traits, equipment, and archetype to justify a higher dice count.</dd> \
	<dt><b>Step 3:</b> The Story Master and Player roll their dice.<dt> \
	<dd>Any die with a number four or above is counted as a success.</dd> \
	<dt>If the Player has more successes, the character succeeds. If the Story Master has more successes, the character loses.</dt> \
	<dt>In <b>conflicts</b>, if the defender wins by one or two successes over the attacker, they receive a <b>wounding blow</b>.</dt></dl> \
	<br><h1>Discipline</h1><br> \
	<br>Questing can be brutal. Sometimes it feels like the world is against a character. However, through discipline (and maybe a little faith), one can change the winds of the situation. In Winter Quest, that would take the form of Discipline. \
	<br>Discipline is a point that is awarded by the Story Master. It is recommended to keep Discipline a rare resource handed out for especially daunting, heroic, or legendary actions. It could be used as a reward for finishing a grueling quest, and being particularly cunning in an answer. \
	<br>Discipline operates differently when used in traditional or Rredouane modes. In traditional Winter Quest, Discipline overrules a table decision. In challenges, this converts a failure to a success or a success to a failure. During conflict, this improves the outcome by one level. A Fatal Blow becomes a Wounding Blow. A Wounding Blow becomes a Shielded Blow. When the Rredouane Mode supplement is in use, Discipline provides one extra die to the player's dice pool. \
	<dl><dt>-Story Masters may hand out Discipline to a character.</dt> \
	<dd>Recommended reasons are for heroic acts, cunning or creative answers, or completing major quests.</dd> \
	<dt>-Players may use Discipline to alter the outcome of a challenge or conflict.<dt> \
	<dd>During challenges, the result of a challenge flips.</dd>\
	<dd>During combat, the outcome of a conflict improves by one level.</dd> \
	<dt>-In Rredouane Mode, Discipline adds one die to a player's dice pool.</dt></dl>")
	for(var/i = 1 to 5)
		var/obj/item/paper/R = new /obj/item/paper(W)
		R.set_content("Character Sheet", "<table border=1 cellspacing=0 cellpadding=3 style='border: 1px solid black;'><td><center><b>Winter Quest</b> \
		<br><i>Character sheet</i></center><hr><b>Player:</b> <span class=\"paper_field\"></span> \
		<br><b>Character:</b> <span class=\"paper_field\"></span> \
		<br><b>Quest:</b> <span class=\"paper_field\"></span> \
		<hr><b>Ethnicity:</b> <span class=\"paper_field\"></span> \
		<br><b>Archetype:</b> <span class=\"paper_field\"></span> \
		<br><b>Traits:</b><ul><li><span class=\"paper_field\"></span></li><li><span class=\"paper_field\"></span></li><li><span class=\"paper_field\"></span></li></ul> \
		<b>Flaws:</b><ul><li><span class=\"paper_field\"></span></li></ul> \
		<b>Equipment:</b><ul><li><span class=\"paper_field\"></span></li><li><span class=\"paper_field\"></span></li><li><span class=\"paper_field\"></span></li></ul> \
		<b>Background:</b><ul><li><span class=\"paper_field\"></span></li></ul></td></tr></table> \
		")
	update_icon()

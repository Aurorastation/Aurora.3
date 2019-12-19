/obj/item/tajcard
	name = "collectable tajaran card"
	desc = "A collectable card, usually found inside cigarette packs, with the illustration of a famous Tajara."
	icon = 'icons/obj/playing_cards.dmi'
	icon_state = "tajcig"
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
			description_fluff = "Njadrasanukii Hadii was born in 2402 to the noble Njarir'Akhran Hadii line. He got involved with the military at an early age, becoming a cadet for the \
			Royal Navy at 16. During the revolution, he briefly fought for the loyalists but was recalled to the Hadii Citadel to help defend his family's ancestral home. Following the \
			revolution and the Hadii's rise in the new Federal Republic, Njadrasanukii was given the office of Vice-President under his brother Al'Mari Hadii. He assumed the office of \
			president on 2451 after the assassination of his brother. Infamous for his harsh decrees and tendency to betray his word, Njadrasanukii is not trustworthy but holds the \
			planet of Adhomai in his iron grip nonetheless."

		if("tesla")
			desc += " This one has the picture of a tesla trooper."
			description_fluff = "Formed in 2461, the Tesla Brigade is an experimental force composed of augmented veterans. Created after the intense casualties of the Das'nrra campaign and the \
			severe loss of Republican Guard units. Additional funding and focus was placed on a previously shelved proposal for heavily armed shock and high technology assault troopers. A \
			special unit designated to withstand the numerical disadvantages and prolonged engagements special forces of the Republic often faces."

		if("headmaster")
			desc += " This one has the picture of Headmaster Harrrdanim Tyr'adrr."
			description_fluff = "Harrrdanim was born in 2411 to an M'sai line. He entered military service at a young age. His high intelligence and robust health soon had him successfully \
			enter the Royal Enforcers; the elite all-M'sai special forces available to the nobility. He was taken prisoner during the First Revolution and released uner condition that \
			he acts as a spy against subversive elements. Soon Harrrdanim became known as one of the most effective and ruthless secret agents available to the government and eventually \
			rose the ranks to become Headmaster of the People's Strategic Intelligence Service. He is known and feared across Adhomai and has spawned an entire 'spy thriller' genre in \
			the Republic."

		if("commissar")
			desc += " This one has the picture of party commissar."
			description_fluff = "Party Commissars are high ranking members of the Party of the Free Tajara under the Leadership of Hadii attached to army units, who ensures that soldiers and \
			their commanders follow the principles of Hadiism. Their duties are not only limited to enforcing the republican ideals among the troops and reporting possible subversive elements, \
			they are expected to display bravery in combat and lead by example."

		if("almanq")
			desc += " This one has the picture of Rikdar Al'Manq."
			description_fluff = "Rikdar was born on 2429 the noble Njarir'Akhran Bayan line in Nal'Tor. However, his parents were disappeared by Republic secret police in one of the \
			frequent purges of Njarir'Akhran and he was put into state-run foster care. He has raised in the House Of Young Patriots orphanage until he was adopted at 14 to Hharar \
			parents and took their last name of Al'Manq. Rikdar graduated university on at 20 years old in 2450 with a Bachelors of Arts. Having already received several high-profile \
			commissions, including the then-President Al'Mari Hadii, whose portrait was done a week before his death. Rikdar remains extremely popular on Adhomai. The People's Republic \
			remains a quiet supporter of his work, and state officials pay him handsome commissions for their portraits to be done."

		if("yasmin")
			desc += " This one has the picture of Yasmin Piaf."
			description_fluff = "Yasmin Piaf, was born in 2434 in the suburbs of Nal'tor to a particularly well off Njarir'Akhran family. Even from her young age, \
			Yasmin was interested in music. She was part of her school's choir and participated in several nation-wide contests for the honor of singing for President Rhagrrhuzau Hadii. \
			Eventually, she graduated and went on to the Academy of Musical Arts with full scholarship. Yet her voice, described by some as angelic and innocent, found purchase with an \
			aging generation of Tajara who wished a brief return to peaceful normalcy following the First Revolution. Yasmin Piaf has become one of the most famous singers in the modern \
			era - one who has fostered a close relationship with State officials."

		if("andrey")
			desc += " This one has the picture of Andrey Borisov."
			description_fluff = "Born in 2416 to aline of M'sai warriors, Andrey was not even two years old before humanity stumbled across Adhomai and lit the flame that ignited the \
			First Revolution. As the newly founded People's Republic began the arduous transition from a movement to a government, Andrey's connections with the upper echelon of \
			PRA politicians bore fruit. He was taken on as a member of an officer's general staff, headquartered in Nal'Tor. His position put him in contact with the elite, however, \
			and many found him charming and personable. His ascension from lowly	secretary to the major news anchor was one that involved plenty of political maneuvering, money - \
			and, rumored by some, violence - but ultimately Andrey had proved his loyalty to the political elite of the People's Republic and he was rewarded with the honor of being their mouthpiece"

		if("paratrooper")
			desc += " This one has the picture of a republican guard."
			description_fluff = "Following the end of the first revolution, many veterans especially of the Ha'narr Corps had become hardened warriors with exceptional abilities. \
			Seeking to mate the heavily refined combat effectiveness of shock troop units which formed among front-line infantry with the survival skills and mobility of the Ha'narrii, \
			the Republican Guard was formed by absorbing all of these units as a hard-hitting highly mobile airborne special forces unit in 2435. They primarily draw recruits from \
			promising and outstanding members of the Ha'narr Corps, as well as shock infantry divisions, not at all unlike their original founding members. Their iconic light blue \
			berets inspire awe and admiration on the battlefield among their teammates, and fear among their enemies. The Republican Guard primarily deploys by airdropping from high \
			altitude aircraft in special thick cold resistant pressurized soft suits, and unlike the Ha'narr, carry a considerable amount of equipment for combat operations."

		if("scout")
			desc += " This one has the picture of a Ha'narr scout."
			description_fluff = "Originally formed in 2421 during the first revolution, the Ha'narr Corps served as a reconnaissance, scouting and special operations unit for the \
			rebellion. Although it was disbanded at the end of the first revolution, it was reformed at the dawn of the second revolution as the inflexibility of the Republican Army \
			proved to be a vital weakness which these units corrected for. The training regime for Ha'narrii is typically anywhere in between one to three months, with recruits trained \
			in basic survival and reconnaissance skills emphasizing on self dependence within the frozen wilderness of Adhomai.  As a scouting unit, Ha'narri travel lightly on equipment, \
			carrying primarily the essentials for survival and only a token amount of ammunition. Many detachments also make use of snow skiis in order to travel quickly in mountainous regions. \
			They are well-known for their iconic thick light-colored cloaks which they wear while traversing the vast countrysides for warmth, as well as camouflage."

// This is a parody of Cards Against Humanity (https://en.wikipedia.org/wiki/Cards_Against_Humanity)
// which is licensed under CC BY-NC-SA 2.0, the full text of which can be found at the following URL:
// https://creativecommons.org/licenses/by-nc-sa/2.0/legalcode

//Ported from Polaris;
//To be rewritten to be made more 'in-universe' and less 'meta-SS13 references', as amusing the latter can be.
//Pretty sure people in-universe wouldn't exactly see things the same way we SS13 players do -- Mwah

/obj/item/deck/cah
	name = "\improper CAG deck (white)"
	desc = "The ever-popular Cards Against The Galaxy word game. Warning: may include traces of broken fourth wall. This is the white deck."
	icon_state = "cag_white"
	var/blanks = 5

/obj/item/deck/cah/black
	name = "\improper CAG deck (black)"
	desc = "The ever-popular Cards Against The Galaxy word game. Warning: may include traces of broken fourth wall. This is the black deck."
	icon_state = "cag_black"
	blanks = 0

/obj/item/deck/cah/New()
	..()
	var/datum/playingcard/P
	for(var/cardtext in card_text_list)
		P = new()
		P.name = "[cardtext]"
		P.card_icon = "[icon_state]_card"
		P.back_icon = "[icon_state]_card_back"
		cards += P
	if(!blanks)
		return
	for(var/x=1 to blanks)
		P = new()
		P.name = "Blank Card"
		P.card_icon = "[icon_state]_card_back"
		P.back_icon = "[icon_state]_card_back"

// Black cards.
/obj/item/deck/cah/black/card_text_list = list(
	"Why am I itchy?",
	"Today, police shot ____.",
	"Our local chaplain is worshipping _____.",
	"Cargo ordered a crate full of _____.",
	"An ERT was called due to ______.",
	"Alert! The Colony Director has armed themselves with _____.",
	"Current Laws: ________ is your master.",
	"Current Laws: ________ is the enemy.",
	"_____ vented the entirety of Cargo.",
	"Today, science found an anomaly that made people ____ and ____.",
	"There was a rap battle between ____ and ____.",
	"Caution, ______ have been detected in collision course with the station.",
	"Today's kitchen menu includes _______.",
	"What did the mercenaries want when they attacked the station?",
	"I think the Colony Director is insane. He just demanded ______ in his office.",
	"Fuckin' scientists, they just turned Misc. Research into _______ .",
	"What's my fetish?",
	"Hello, _______ here with _______",
	"No one else was at _______, they wouldn't understand the ______",
	"Why am I shivering?",
	"What is this world coming to? First, ________, now _______",
	"NanoTrasen's labor union decided to use _______ to raise employee morale.",
	"The Chemist's drug of choice is ______",
	"It is common practice for _______ to ______ on Moghes.",
	"Mercurial Colonies are _____.",
	"The Skrell are celebrating _____ today.",
	"_____ is/are why I'm afraid of the maintenance tunnels.",
	"_____ used ____ to create their newest invention, _____!",
	"Scientists are not allowed to make Gatling _____.",
	"It's not a party until the ____ arrive.",
	"No matter how many Tajaran you have, _____ is never acceptable.",
	"No, the AI's first law is NOT to serve _____.",
	"The robots are not disposal bins for your _____.",
	"You can never have too many _____ on shift.",
	"Failing to fit ______ up the
	)

// White cards.
/obj/item/deck/cah/var/list/card_text_list = list(
	"Those motherfucking carp",
	"Having sex in the maintenance tunnels",
	"Space 'Nam",
	"Space lesbians",
	"The Gardener getting SUPER high",
	"The Colony Director thinking they're a badass",
	"Being in a cult",
	"Racially biased lawsets",
	"An Unathi who WON'T STOP FIGHTING",
	"Tajaran fetishists",
	"Bald thirty-year-olds",
	"A Chief Engineer who can't setup the engine",
	"Being sucked out into space",
	"Officer Beepsky",
	"Engineering",
	"The grey tide.",
	"The Research Director",
	"Fucking synths",
	"Man-eating purple pod plants",
	"Chemical sprayers filled with lube",
	"Librarians",
	"Squids",
	"Cats",
	"Lizards",
	"Apes",
	"Trees",
	"Supermatter undergarments",
	"Bluespace",
	"Five hundred rabid spiders",
	"Five hundred rabid diona nymphs",
	"Cable ties",
	"Rampant vending machines",
	"Positronic drink coasters",
	"Kitchen utensil anomalies",
	"Locked lockers",
	"Energy spatulas",
	"Flashbang gauntlets",
	"Carp",
	"Space whales",
	"Blu-sharks",
	"Fax machines",
	"Exquisite Pens",
	"Dr. Maxman's male enhancements",
	"Gyrating slimes",
	"Forehead-mounted laser weaponry",
	"Pelvis-mounted laser weaponry",
	"Cardboard cutouts",
	"An obscene amount of rubber ducks",
	"Brain cakes",
	"A drone's game of life.",
	"Anomaly suits",
	"A gardener smoking reishi",
	"Military-grade baseball bats",
	"Barricading the bar",
	"An irritatingly chipper robot",
	"Androids hanging out in the bar drinking beer",
	"Gear harnesses",
	"A seventeen-year-old Colony Director",
	"The throbbing erection that the HoS gets at the thought of shooting something",
	"Trying to stab someone and hugging them instead",
	"Waking up naked in the maintenance tunnels",
	"Horrible cloning accidents",
	"Licking the supermatter due to a dare",
	"A Quartermaster who WON'T STOP ordering guns",
	"Teaching a synthetic the Birds and the Bees",
	"Unnecessary surgery",
	"My addiction to spiders",
	"wetskrell.nt",
	"DOCTOR MAXMAN!",
	"A group of Skrell getting their squish on",
	"Enough soporific to put the entire station down",
	"Delicious Vietnamese cuisine",
	"Glorsh",
	"Miranda Trasen",
	"Michael Frost"
	)

/datum/event/pda_spam
	endWhen = 36000
	var/last_spam_time = 0
	var/obj/machinery/message_server/useMS

/datum/event/pda_spam/setup()
	last_spam_time = world.time
	pick_message_server()

/datum/event/pda_spam/proc/pick_message_server()
	if(message_servers)
		for (var/obj/machinery/message_server/MS in message_servers)
			if(MS.active)
				useMS = MS
				break

/datum/event/pda_spam/tick()
	if(world.time > last_spam_time + 3000)
		//if there's no spam managed to get to receiver for five minutes, give up
		kill()
		return

	if(!useMS || !useMS.active)
		useMS = null
		pick_message_server()

	if(useMS)
		if(prob(5))
			// /obj/machinery/message_server/proc/send_pda_message(var/recipient = "",var/sender = "",var/message = "")
			var/obj/item/device/pda/P
			var/list/viables = list()
			for(var/obj/item/device/pda/check_pda in PDAs)
				if (!check_pda.owner||check_pda.toff||check_pda == src||check_pda.hidden)
					continue
				viables.Add(check_pda)

			if(!viables.len)
				return
			P = pick(viables)

			var/sender
			var/message
			switch(pick(1,2,3,4,5,6,7,8))

				if(1)
					sender = pick("MaxBet","MaxBet Online Casino",\
					"There is no better time to register",\
					"I'm excited for you to join us")
					message = pick("Triple deposits are waiting for you at MaxBet Online when you register to play with us.",\
					"You can qualify for a 200% Welcome Bonus at MaxBet Online when you sign up today.",\
					"Once you are a player with MaxBet, you will also receive lucrative weekly and monthly promotions.",\
					"You will be able to enjoy over 450 top-flight casino games at MaxBet.")

				if(2)
					sender = pick("QuickDatingSystem",\
					"Find your russian bride",\
					"Tajaran beauties are waiting",\
					"Find your secret skrell crush",\
					"Beautiful unathi brides",\
					"Hyperrealistic pleasure-bots available",\
					"Zo'ra broods in need of genetic material!")
					message = pick("Your profile caught my attention and I wanted to write and say hello (QuickDating).",\
					"If you will write to me on my email [pick(first_names_female)]@[pick(last_names)]@[current_map.company_name].[pick("ru","ck","tj","ur","nt")] I shall necessarily send you a photo (QuickDating).",\
					"I want that we write each other and I hope, that you will like my profile and you will answer me (QuickDating).",\
					"You have (1) new message!",\
					"You have (2) new profile views!",\
					"You have a secret admirer! Meet them today on 4EverYung.nt",\
					"Single farmer? Dating with us helps meet your best match.")

				if(3)
					sender = pick("Galactic Payments Association",\
					"Better Business Bureau",\
					"Tau Ceti E-Payments",\
					"NAnoTransen Finance Deparmtent",\
					"IDrist Corp",\
					"Luxury Replicas")
					message = pick("Luxury watches for Blowout sale prices!",\
					"Watches, Jewelry & Accessories, Bags & Wallets !",\
					"Deposit 100$ and get 300$ totally free!",\
					" 100K NT.|WOWGOLD õnly $89            <HOT>",\
					"We have been filed with a complaint from one of your customers in respect of their business relations with you.",\
					"We kindly ask you to open the COMPLAINT REPORT (attached) to reply on this complaint..",\
					"Thizzz izz the Idrizz bank, we need your pazzzword, plzzz click here.",\
					"Your Idris Account has been Limited! Click here for more informtion",\
					"Your password has been upated. Please click to confirm.",\
					"This is the Reclamation Unit bureau. We ask that you reply or a unit will be sent to your location.",\
					"This staff assistant is making mad credits and basically, you're fucking stupid. How? ...Just Watch The Free Video >")

				if(4)
					sender = pick("Buy Dr. Maxman",\
					"Having dysfuctional troubles?")
					message = pick("DR MAXMAN: REAL Doctors, REAL Science, REAL Results!",\
					"Dr. Maxman was created by George Acuilar, M.D, a [current_map.boss_short] Certified Urologist who has treated over 70,000 patients sector wide with 'male problems'.",\
					"After seven years of research, Dr Acuilar and his team came up with this simple breakthrough male enhancement formula.",\
					"Men of all species report AMAZING increases in length, width and stamina.",
					"Discovery of this ONE Vaurca pheremone has led to years of genital growth progress! Sign on now!",\
					"Is your sexlife growing dull? Your late-night sessions growing short? Have you considered Unathi testicle transplants? Greater stamina, greater virility, greater fun.")

				if(5)
					sender = pick("Dr","Crown prince","King Regent","Professor","Captain")
					sender += " " + pick("Robert","Alfred","Josephat","Kingsley","Sehi","Zbahi")
					sender += " " + pick("Mugawe","Nkem","Gbatokwia","Nchekwube","Ndim","Ndubisi")
					message = pick("YOUR FUND HAS BEEN MOVED TO [pick("Sol","Biesel","Dominia","Elyra","Qerrbalak","Adhomai","NTCC Odin","Hephaestus","NSS Upsilon")] DEVELOPMENTARY BANK FOR ONWARD REMITTANCE.",\
					"We are happy to inform you that due to the delay, we have been instructed to IMMEDIATELY deposit all funds into your account",\
					"Dear fund beneficiary, We have please to inform you that overdue funds payment has finally been approved and released for payment",\
					"Due to my lack of agents I require an off-world financial account to immediately deposit the sum of 1 POINT FIVE MILLION credits.",\
					"Greetings sir, I regretfully to inform you that as I lay dying here due to my lack ofheirs I have chosen you to receive the full sum of my lifetime savings of 1.5 billion credits")

				if(6)
					var/pornography = pick("www.wetskrell.nt",\
					"www.badkitty.nt",\
					"www.scalesnstuff.nt",\
					"www.spacelube.nt",\
					"www.pervertedprogramming.nt",\
					"www.risquerobots.tc",\
					"www.clanked.tc",\
					"www.filledsockets.tc",\
					"www.hivenetmingle.nt")
					sender = pick("[current_map.company_name] Morale Divison",\
					"Feeling Lonely?",\
					"Bored?",\
					"[pornography]")
					message = pick("The [current_map.company_name] Morale Division wishes to provide you with quality entertainment sites.",\
					"[pornography] is a xenophillic website endorsed by NT for the use of male crewmembers among it's many stations and outposts.",\
					"[pornography] only provides the higest quality of male entertaiment to [current_map.company_name] Employees.",\
					"district14.nt : Find local Scrapheap babes near your area. Click to learn more.",\
					"Simply enter your [current_map.company_name] Bank account system number and pin. With three easy steps this service could be yours!",
					"Warning! Your connection is not private. Attackers might be trying to steal your information from [pornography] (for example, passwords, messages, or credit cards). Click to learn more.")

				if(7)
					var/genre = pick("detective crime thriller","crime drama","saturday cartoon","coming of age drama","hospital drama","space opera","sci-fi epic","historical drama","murder mystery","soft-core thriller","S-movie")
					var/premise = pick("Attack","Revenge", "Apocalypse","War","Army","Night","House","Invasion","Mountain","Rise","Rage")
					var/list/noun = list("Maniac","Commando","Alien","Goblin","Skeleton","Bird","Raider","Hive","Snake","Teacher","Zombie","Wizard","Dragon","Octopus","Dinosaur","Thing","Changeling","Cult","Vampire","Ninja","Agent","Blob","People","Man","Woman","Clown")
					var/list/adjective = list("Killer","Skrell","Unathi","Devil","Satan","Evil","Unnameable","Antimatter","Robot","Vaurca","Human","Ancient","Vampire","Sleeper","Secret","Nazi","Space-Nazi","Communist","Immortal","Demon","Murderous","Collosal","Undead","Sex")
					var/list/relation = list("Neighbour","Priest","Brother","Mother","Father","Sister","Teacher","Parents","King","Son","Daughter","Friends","Self")
					var/list/action = list("Killed","Conquered","Became","Joined","Tricked","Absorbed","Frightened","Seduced","Married")
					var/list/place = list("Outer Space","School","Center of the Earth","Sedantis IV","Tau Ceti","Moghes","Holy Terra","Earth","Our Own Minds","the Village Green","Two Doors Down the Block","the Town Over","the Ancient Past","the Distant Future","Kentucky")
					var/plural = "s"
					if(prob(50))
						plural = ""
					var/movie_title = pick("[premise] of the [pick(adjective)] [pick(noun)][plural]","[pick(adjective)] [pick(noun)][plural] vs. [pick(adjective)] [pick(noun)]s from [pick(place)]","The Night My [pick(relation)] [pick(action)] [pick("a [pick(adjective)] [pick(noun)]",pick(place))]")
					if(prob(50))
						movie_title = uppertext(movie_title)

					sender = pick("You have won free tickets!",\
					"Click here to claim your prize!",\
					"You are the 1000th vistor!",\
					"You are our lucky grand prize winner!")
					message = pick("You have won tickets to the newest [genre] \"[movie_title]\"!",\
					"Click here to receive your new iFrame 7")

				if(8)
					sender = pick("[pick(first_names_female,first_names_male)][pick(last_names)]@[current_map.company_name].[pick("ru","ck","tj","ur","nt")]",\
					"Cindy Kate messenging",\
					"MirandaTrasen@NanoTrasen.nt")
					message = pick("We know who you are. Expect us.",\
					"Hi [P.owner]! Remember me from high-school? Well I have this great business deal proposition....",\
					"If you don't forward this message to 8 more crewmembers your head will die in their sleep.",\
					"If you break the chain you will have bad luck for the rest of you're miserable life. Forward to 10 more crewmembers.",\
					"Forward this email to 3.14 more crewmembers and receive 10,000 cR!",\
					"[P.owner]! I come from the future to give warning! The code has become self-referential! Run while you still can!")

			if (useMS.send_pda_message("[P.owner]", sender, message))	//Message been filtered by spam filter.
				return

			last_spam_time = world.time

			if (prob(50)) //Give the AI an increased chance to intercept the message
				for(var/mob/living/silicon/ai/ai in mob_list)
					// Allows other AIs to intercept the message but the AI won't intercept their own message.
					if(ai.ai_pda != P && ai.ai_pda != src)
						ai.show_message("<i>Intercepted message from <b>[sender]</b></i> (Unknown / spam?) <i>to <b>[P:owner]</b>: [message]</i>")

			//Commented out because we don't send messages like this anymore.  Instead it will just popup in their chat window.
			//P.tnote += "<i><b>&larr; From [sender] (Unknown / spam?):</b></i><br>[message]<br>"

			if (!P.message_silent)
				playsound(P.loc, 'sound/machines/twobeep.ogg', 50, 1)
			for (var/mob/O in hearers(3, P.loc))
				if(!P.message_silent) O.show_message(text("\icon[P] *[P.ttone]*"))
			//Search for holder of the PDA.
			var/mob/living/L = null
			if(P.loc && isliving(P.loc))
				L = P.loc
			//Maybe they are a pAI!
			else
				L = get(P, /mob/living/silicon)

			if(L)
				to_chat(L, "\icon[P] <b>Message from [sender] (Unknown / spam?), </b>\"[message]\" (Unable to Reply)")

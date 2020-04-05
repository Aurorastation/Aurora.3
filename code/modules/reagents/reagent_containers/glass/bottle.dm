
//Not to be confused with /obj/item/reagent_containers/food/drinks/bottle

/obj/item/reagent_containers/glass/bottle
	name = "bottle"
	desc = "A small bottle."
	icon = 'icons/obj/chemical.dmi'
	icon_state = null
	item_state = "atoxinbottle"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,60)
	flags = 0
	volume = 60
	fragile = 4
	var/list/reagents_to_add

/obj/item/reagent_containers/glass/bottle/on_reagent_change()
	update_icon()

/obj/item/reagent_containers/glass/bottle/pickup(mob/user)
	..()
	update_icon()

/obj/item/reagent_containers/glass/bottle/dropped(mob/user)
	..()
	update_icon()

/obj/item/reagent_containers/glass/bottle/attack_hand()
	..()
	update_icon()

/obj/item/reagent_containers/glass/bottle/Initialize()
	. = ..()
	if(!icon_state)
		icon_state = "bottle-[rand(1,4)]"

	for(var/v in reagents_to_add)
		reagents.add_reagent(v, reagents_to_add[v])

	update_icon()

/obj/item/reagent_containers/glass/bottle/update_icon()
	cut_overlays()

	if(reagents.total_volume && (icon_state == "bottle-1" || icon_state == "bottle-2" || icon_state == "bottle-3" || icon_state == "bottle-4"))
		var/image/filling = image('icons/obj/reagentfillings.dmi', src, "[icon_state]10")

		var/percent = round((reagents.total_volume / volume) * 100)
		switch(percent)
			if(0 to 9)		filling.icon_state = "[icon_state]--10"
			if(10 to 24) 	filling.icon_state = "[icon_state]-10"
			if(25 to 49)	filling.icon_state = "[icon_state]-25"
			if(50 to 74)	filling.icon_state = "[icon_state]-50"
			if(75 to 79)	filling.icon_state = "[icon_state]-75"
			if(80 to 90)	filling.icon_state = "[icon_state]-80"
			if(91 to INFINITY)	filling.icon_state = "[icon_state]-100"

		filling.color = reagents.get_color()
		add_overlay(filling)

	if (!is_open_container())
		add_overlay("lid_bottle")

/obj/item/reagent_containers/glass/bottle/norepinephrine
	name = "norepinephrine bottle"
	desc = "A small bottle. Contains norepinephrine - used to stabilize patients."
	icon_state = "bottle-4"
	reagents_to_add = list("norepinephrine" = 60)
	
/obj/item/reagent_containers/glass/bottle/toxin
	name = "toxin bottle"
	desc = "A small bottle of toxins. Do not drink, it is poisonous."
	icon_state = "bottle-3"
	reagents_to_add = list("toxin" = 60)

/obj/item/reagent_containers/glass/bottle/cyanide
	name = "cyanide bottle"
	desc = "A small bottle of cyanide. Bitter almonds?"
	icon_state = "bottle-3"
	reagents_to_add = list("cyanide" = 30)

/obj/item/reagent_containers/glass/bottle/stoxin
	name = "soporific bottle"
	desc = "A small bottle of soporific. Just the fumes make you sleepy."
	icon_state = "bottle-3"
	reagents_to_add = list("stoxin" = 60)

/obj/item/reagent_containers/glass/bottle/chloralhydrate
	name = "chloral hydrate bottle"
	desc = "A small bottle of Choral Hydrate. Mickey's Favorite!"
	icon_state = "bottle-3"
	reagents_to_add = list("chloralhydrate" = 30)

/obj/item/reagent_containers/glass/bottle/antitoxin
	name = "dylovene bottle"
	desc = "A small bottle of dylovene. Counters poisons, and repairs damage. A wonder drug."
	icon_state = "bottle-4"
	reagents_to_add = list("dylovene" = 60)

/obj/item/reagent_containers/glass/bottle/mutagen
	name = "unstable mutagen bottle"
	desc = "A small bottle of unstable mutagen. Randomly changes the DNA structure of whoever comes in contact."
	icon_state = "bottle-1"
	reagents_to_add = list("mutagen" = 60)

/obj/item/reagent_containers/glass/bottle/ammonia
	name = "ammonia bottle"
	desc = "A small bottle."
	icon_state = "bottle-1"
	reagents_to_add = list("ammonia" = 60)

/obj/item/reagent_containers/glass/bottle/diethylamine
	name = "diethylamine bottle"
	desc = "A small bottle."
	icon_state = "bottle-4"
	reagents_to_add = list("diethylamine" = 60)

/obj/item/reagent_containers/glass/bottle/with_virus
	name = "virus bottle"
	desc = "A small bottle. Contains some virus."
	icon_state = "bottle-4"
	var/datum/disease/disease

/obj/item/reagent_containers/glass/bottle/with_virus/Initialize()
	var/datum/disease/F = new disease(0)
	var/list/data = list("viruses"= list(F))
	if(!icon_state)
		icon_state = "bottle-[rand(1,4)]"
	reagents.add_reagent("blood", 20, data)
	
	update_icon()

/obj/item/reagent_containers/glass/bottle/with_virus/flu_virion
	name = "Flu virion culture bottle"
	desc = "A small bottle. Contains H13N1 flu virion culture in synthblood medium."
	disease = /datum/disease/advance/flu	

/obj/item/reagent_containers/glass/bottle/with_virus/epiglottis_virion
	name = "Epiglottis virion culture bottle"
	desc = "A small bottle. Contains Epiglottis virion culture in synthblood medium."
	disease = /datum/disease/advance/voice_change

/obj/item/reagent_containers/glass/bottle/with_virus/liver_enhance_virion
	name = "Liver enhancement virion culture bottle"
	desc = "A small bottle. Contains liver enhancement virion culture in synthblood medium."
	disease = /datum/disease/advance/heal

/obj/item/reagent_containers/glass/bottle/with_virus/hullucigen_virion
	name = "Hullucigen virion culture bottle"
	desc = "A small bottle. Contains hullucigen virion culture in synthblood medium."
	icon = 'icons/obj/chemical.dmi'
	disease =  /datum/disease/advance/hullucigen

/obj/item/reagent_containers/glass/bottle/with_virus/pierrot_throat
	name = "Pierrot's Throat culture bottle"
	desc = "A small bottle. Contains H0NI<42 virion culture in synthblood medium."
	disease = /datum/disease/pierrot_throat

/obj/item/reagent_containers/glass/bottle/with_virus/cold
	name = "Rhinovirus culture bottle"
	desc = "A small bottle. Contains XY-rhinovirus culture in synthblood medium."
	disease = /datum/disease/advance/cold

/obj/item/reagent_containers/glass/bottle/with_virus/random
	name = "Random culture bottle"
	desc = "A small bottle. Contains a random disease."
	disease = /datum/disease/advance

/obj/item/reagent_containers/glass/bottle/with_virus/retrovirus
	name = "Retrovirus culture bottle"
	desc = "A small bottle. Contains a retrovirus culture in a synthblood medium."
	disease = /datum/disease/dna_retrovirus

/obj/item/reagent_containers/glass/bottle/with_virus/gbs
	name = "GBS culture bottle"
	desc = "A small bottle. Contains Gravitokinetic Bipotential SADS+ culture in synthblood medium."//Or simply - General BullShit
	disease = /datum/disease/gbs
	amount_per_transfer_from_this = 5

/obj/item/reagent_containers/glass/bottle/with_virus/fake_gbs
	name = "GBS culture bottle"
	desc = "A small bottle. Contains Gravitokinetic Bipotential SADS- culture in synthblood medium."//Or simply - General BullShit
	disease = /datum/disease/fake_gbs

/obj/item/reagent_containers/glass/bottle/with_virus/brainrot
	name = "Brainrot culture bottle"
	desc = "A small bottle. Contains Cryptococcus Cosmosis culture in synthblood medium."
	disease = /datum/disease/brainrot

/obj/item/reagent_containers/glass/bottle/with_virus/magnitis
	name = "Magnitis culture bottle"
	desc = "A small bottle. Contains a small dosage of Fukkos Miracos."
	disease = /datum/disease/magnitis

/obj/item/reagent_containers/glass/bottle/with_virus/wizarditis
	name = "Wizarditis culture bottle"
	desc = "A small bottle. Contains a sample of Rincewindus Vulgaris."
	disease = /datum/disease/wizarditis

/obj/item/reagent_containers/glass/bottle/pacid
	name = "Polytrinic Acid Bottle"
	desc = "A small bottle. Contains a small amount of Polytrinic Acid"
	icon_state = "bottle-4"
	reagents_to_add = list("pacid" = 60)

/obj/item/reagent_containers/glass/bottle/adminordrazine
	name = "Adminordrazine Bottle"
	desc = "A small bottle. Contains the liquid essence of the gods."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "holyflask"
	reagents_to_add = list("adminordrazine" = 60)

/obj/item/reagent_containers/glass/bottle/capsaicin
	name = "capsaicin bottle"
	desc = "A small bottle. Contains hot sauce."
	icon_state = "bottle-4"
	reagents_to_add = list("capsaicin" = 60)

/obj/item/reagent_containers/glass/bottle/frostoil
	name = "frost oil bottle"
	desc = "A small bottle. Contains cold sauce."
	icon_state = "bottle-4"
	reagents_to_add = list("frostoil" = 60)

/obj/item/reagent_containers/glass/bottle/pyrosilicate
	name = "pyrosilicate bottle"
	desc = "A small bottle. Contains pyrosilicate - used to heat up reagents."
	icon_state = "bottle-4"
	reagents_to_add = list("pyrosilicate" = 60)

/obj/item/reagent_containers/glass/bottle/cryosurfactant
	name = "cryosurfactant bottle"
	desc = "A small bottle. Contains cryosurfactant - used to cool down reagents."
	icon_state = "bottle-4"
	reagents_to_add = list("cryosurfactant" = 60)

/obj/item/reagent_containers/glass/bottle/phoron_salt
	name = "phoron salt bottle"
	desc = "A small bottle. Contains phoron salt - a mysterious and unstable chemical."
	icon_state = "bottle-4"
	reagents_to_add = list("phoron_salt" = 60)

/obj/item/reagent_containers/glass/bottle/epinephrine
	name = "epinephrine bottle"
	desc = "A small bottle. Contains epinephrine. Epinephrine, also known as adrenaline, is a super strength stimulant and painkiller intended to keep a patient alive while in critical condition. Overdose causes heart damage and an energy boost equivelent to hyperzine."
	icon_state = "bottle-4"
	reagents_to_add = list("adrenaline" = 60)

/obj/item/reagent_containers/glass/bottle/dexalin_plus
	name = "dexalin plus bottle"
	desc = "A small bottle. Contains Dexalin Plus that is used in the treatment of oxygen deprivation. It is highly effective, and is twice as powerful and lasts twice as long when inhaled."
	icon_state = "bottle-4"
	reagents_to_add = list("dexalinp" = 60)

/obj/item/reagent_containers/glass/bottle/deltamivir
	name = "deltamivir bottle"
	desc = "A small bottle. Contains deltamivir. An all-purpose antiviral agent."
	icon_state = "bottle-4"
	reagents_to_add = list("deltamivir" = 60)

/obj/item/reagent_containers/glass/bottle/coughsyrup
	name = "cough syrup bottle"
	desc = "A small bottle of cough syrup. Don't take too much!"
	icon_state = "bottle-3"
	reagents_to_add = list("coughsyrup" = 60)

/obj/item/reagent_containers/glass/bottle/thetamycin
	name = "thetamycin bottle"
	desc = "A small bottle of thetamycin. Used for disinfecting whatever wounds security caused."
	icon_state = "bottle-4"
	reagents_to_add = list("thetamycin" = 60)
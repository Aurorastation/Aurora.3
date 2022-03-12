
//Not to be confused with /obj/item/reagent_containers/food/drinks/bottle

/obj/item/reagent_containers/glass/bottle
	name = "bottle"
	desc = "A small bottle."
	icon = 'icons/obj/chemical.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/stacks/lefthand_medical.dmi',
		slot_r_hand_str = 'icons/mob/items/stacks/righthand_medical.dmi',
		)
	icon_state = null
	item_state = "bottle"
	filling_states = "20;40;60;80;100"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(5,10,15,25,30,60)
	flags = 0
	volume = 60

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

	update_icon()

/obj/item/reagent_containers/glass/bottle/update_icon() // You know, bottles should be a subtype of beakers. But not gonna change a million and one paths today. - Wezzy.
	cut_overlays()

	if(reagents?.total_volume)
		var/mutable_appearance/filling = mutable_appearance('icons/obj/reagentfillings.dmi', "[icon_state]-[get_filling_state()]")
		filling.color = reagents.get_color()
		add_overlay(filling)

	if(!is_open_container())
		var/lid_icon = "lid_[icon_state]"
		var/mutable_appearance/lid = mutable_appearance(icon, lid_icon)
		add_overlay(lid)

	if(label_text)
		var/label_icon = "label_[icon_state]"
		var/mutable_appearance/label = mutable_appearance(icon, label_icon)
		add_overlay(label)

/obj/item/reagent_containers/glass/bottle/inaprovaline
	name = "inaprovaline bottle"
	desc = "A small bottle. Contains inaprovaline - used to stabilize patients."
	icon_state = "bottle-4"
	reagents_to_add = list(/decl/reagent/inaprovaline = 60)

/obj/item/reagent_containers/glass/bottle/toxin
	name = "toxin bottle"
	desc = "A small bottle of toxins. Do not drink, it is poisonous."
	icon_state = "bottle-3"
	reagents_to_add = list(/decl/reagent/toxin = 60)

/obj/item/reagent_containers/glass/bottle/cyanide
	name = "cyanide bottle"
	desc = "A small bottle of cyanide. Bitter almonds?"
	icon_state = "bottle-3"
	reagents_to_add = list(/decl/reagent/toxin/cyanide = 30)

/obj/item/reagent_containers/glass/bottle/stoxin
	name = "soporific bottle"
	desc = "A small bottle of soporific. Just the fumes make you sleepy."
	icon_state = "bottle-3"
	reagents_to_add = list(/decl/reagent/soporific = 60)

/obj/item/reagent_containers/glass/bottle/polysomnine
	name = "chloral hydrate bottle"
	desc = "A small bottle of Choral Hydrate. Mickey's Favorite!"
	icon_state = "bottle-3"
	reagents_to_add = list(/decl/reagent/polysomnine = 30)

/obj/item/reagent_containers/glass/bottle/antitoxin
	name = "dylovene bottle"
	desc = "A small bottle of dylovene. Counters poisons, and repairs damage. A wonder drug."
	icon_state = "bottle-4"
	reagents_to_add = list(/decl/reagent/dylovene = 60)

/obj/item/reagent_containers/glass/bottle/saline
	name = "saline bottle"
	desc = "A small bottle of saline for attaching to drips. Re-hydrates a patient and helps with increasing blood volume."
	icon_state = "bottle-3"
	reagents_to_add = list(/decl/reagent/saline = 60)

/obj/item/reagent_containers/glass/bottle/mutagen
	name = "unstable mutagen bottle"
	desc = "A small bottle of unstable mutagen. Randomly changes the DNA structure of whoever comes in contact."
	icon_state = "bottle-1"
	reagents_to_add = list(/decl/reagent/mutagen = 60)

/obj/item/reagent_containers/glass/bottle/ammonia
	name = "ammonia bottle"
	desc = "A small bottle."
	icon_state = "bottle-1"
	reagents_to_add = list(/decl/reagent/ammonia = 60)

/obj/item/reagent_containers/glass/bottle/diethylamine
	name = "diethylamine bottle"
	desc = "A small bottle."
	icon_state = "bottle-4"
	reagents_to_add = list(/decl/reagent/diethylamine = 60)

/obj/item/reagent_containers/glass/bottle/pacid
	name = "polytrinic acid bottle"
	desc = "A small bottle. Contains a small amount of Polytrinic Acid"
	icon_state = "bottle-4"
	reagents_to_add = list(/decl/reagent/acid/polyacid = 60)

/obj/item/reagent_containers/glass/bottle/nitroglycerin
	name = "nitroglycerin bottle"
	desc = "A small bottle. Contains a small amount of Nitroglycerin."
	icon_state = "bottle-4"
	reagents_to_add = list(/decl/reagent/nitroglycerin = 60)

/obj/item/reagent_containers/glass/bottle/adminordrazine
	name = "adminordrazine bottle"
	desc = "A small bottle. Contains the liquid essence of the gods."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "holyflask"
	reagents_to_add = list(/decl/reagent/adminordrazine = 60)

/obj/item/reagent_containers/glass/bottle/capsaicin
	name = "capsaicin bottle"
	desc = "A small bottle. Contains hot sauce."
	icon_state = "bottle-4"
	reagents_to_add = list(/decl/reagent/capsaicin = 60)

/obj/item/reagent_containers/glass/bottle/frostoil
	name = "frost oil bottle"
	desc = "A small bottle. Contains cold sauce."
	icon_state = "bottle-4"
	reagents_to_add = list(/decl/reagent/frostoil = 60)

/obj/item/reagent_containers/glass/bottle/pyrosilicate
	name = "pyrosilicate bottle"
	desc = "A small bottle. Contains pyrosilicate - used to heat up reagents."
	icon_state = "bottle-4"
	reagents_to_add = list(/decl/reagent/pyrosilicate = 60)

/obj/item/reagent_containers/glass/bottle/cryosurfactant
	name = "cryosurfactant bottle"
	desc = "A small bottle. Contains cryosurfactant - used to cool down reagents."
	icon_state = "bottle-4"
	reagents_to_add = list(/decl/reagent/cryosurfactant = 60)

/obj/item/reagent_containers/glass/bottle/epinephrine
	name = "epinephrine bottle"
	desc = "A small bottle. Contains epinephrine. Epinephrine, also known as adrenaline, is a super strength stimulant and painkiller intended to keep a patient alive while in critical condition. Overdose causes heart damage and an energy boost equivelent to hyperzine."
	icon_state = "bottle-4"
	reagents_to_add = list(/decl/reagent/adrenaline = 60)

/obj/item/reagent_containers/glass/bottle/dexalin_plus
	name = "dexalin plus bottle"
	desc = "A small bottle. Contains Dexalin Plus that is used in the treatment of oxygen deprivation. It is highly effective, and is twice as powerful and lasts twice as long when inhaled."
	icon_state = "bottle-4"
	reagents_to_add = list(/decl/reagent/dexalin/plus = 60)

/obj/item/reagent_containers/glass/bottle/coughsyrup
	name = "cough syrup bottle"
	desc = "A small bottle of cough syrup. Don't take too much!"
	icon_state = "bottle-3"
	reagents_to_add = list(/decl/reagent/coughsyrup = 60)

/obj/item/reagent_containers/glass/bottle/thetamycin
	name = "thetamycin bottle"
	desc = "A small bottle of thetamycin. Used for disinfecting whatever wounds security caused."
	icon_state = "bottle-4"
	reagents_to_add = list(/decl/reagent/thetamycin = 60)

/obj/item/reagent_containers/glass/bottle/bicaridine
	name = "bicaridine bottle"
	desc = "A small bottle. Contains bicaridine - treats damaged tissues."
	icon_state = "bottle-1"
	reagents_to_add = list(/decl/reagent/bicaridine = 60)

/obj/item/reagent_containers/glass/bottle/butazoline
	name = "butazoline bottle"
	desc = "A small bottle. Contains butazoline - treats damaged tissues."
	icon_state = "bottle-1"
	reagents_to_add = list(/decl/reagent/butazoline = 60)

/obj/item/reagent_containers/glass/bottle/dermaline
	name = "dermaline bottle"
	desc = "A small bottle. Contains dermaline - treats burnt tissues."
	icon_state = "bottle-2"
	reagents_to_add = list(/decl/reagent/dermaline = 60)

/obj/item/reagent_containers/glass/bottle/peridaxon
	name = "peridaxon bottle"
	desc = "A small bottle. Contains peridaxon - treats damaged organs."
	icon_state = "bottle-2"
	reagents_to_add = list(/decl/reagent/peridaxon = 60)

/obj/item/reagent_containers/glass/bottle/mortaphenyl
	name = "mortaphenyl bottle"
	desc = "A small bottle. Contains mortaphenyl - treats mild-severe pain as a result of severe, physical injury."
	icon_state = "bottle-3"
	reagents_to_add = list(/decl/reagent/mortaphenyl = 60)

/obj/item/reagent_containers/glass/bottle/perconol
	name = "perconol bottle"
	desc = "A small bottle. Contains perconol - treats minor-moderate pain as a result of physical injury."
	icon_state = "bottle-3"
	reagents_to_add = list(/decl/reagent/perconol = 60)

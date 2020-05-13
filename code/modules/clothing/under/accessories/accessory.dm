/obj/item/clothing/accessory
	name = "tie"
	desc = "A neosilk clip-on tie."
	icon = 'icons/obj/clothing/ties.dmi'
	icon_state = "bluetie"
	item_state = ""	//no inhands
	overlay_state = null
	slot_flags = SLOT_TIE
	w_class = 2.0
	var/slot = "decor"
	var/obj/item/clothing/has_suit = null		//the suit the tie may be attached to
	var/image/inv_overlay = null	//overlay used when attached to clothing.
	var/image/mob_overlay = null
	var/flippable = 0 //whether it has an attack_self proc which causes the icon to flip horizontally
	var/flipped = 0

/obj/item/clothing/accessory/Destroy()
	on_removed()
	return ..()

/obj/item/clothing/accessory/proc/get_inv_overlay()
	if(!inv_overlay)
		if(!mob_overlay)
			get_mob_overlay()

		var/tmp_icon_state = "[overlay_state? "[overlay_state]" : "[icon_state]"]"
		if(icon_override)
			if("[tmp_icon_state]_tie" in icon_states(icon_override))
				tmp_icon_state = "[tmp_icon_state]_tie"
		inv_overlay = image(icon = mob_overlay.icon, icon_state = tmp_icon_state, dir = SOUTH)
		if(contained_sprite)
			tmp_icon_state = "[tmp_icon_state]"
			inv_overlay = image("icon" = icon, "icon_state" = "[tmp_icon_state]_w", dir = SOUTH)
	if(color)
		inv_overlay.color = color
	return inv_overlay

/obj/item/clothing/accessory/proc/get_mob_overlay()
	if(!mob_overlay)
		var/tmp_icon_state = "[overlay_state? "[overlay_state]" : "[icon_state]"]"
		if(icon_override)
			if("[tmp_icon_state]_mob" in icon_states(icon_override))
				tmp_icon_state = "[tmp_icon_state]_mob"
			mob_overlay = image("icon" = icon_override, "icon_state" = "[tmp_icon_state]")
		else if(contained_sprite)
			tmp_icon_state = "[src.item_state][WORN_UNDER]"
			mob_overlay = image("icon" = icon, "icon_state" = "[tmp_icon_state]")
		else
			mob_overlay = image("icon" = INV_ACCESSORIES_DEF_ICON, "icon_state" = "[tmp_icon_state]")
	if(color)
		mob_overlay.color = color
	return mob_overlay

//when user attached an accessory to S
/obj/item/clothing/accessory/proc/on_attached(var/obj/item/clothing/S, var/mob/user)
	if(!istype(S))
		return
	has_suit = S
	loc = has_suit
	has_suit.add_overlay(get_inv_overlay())

	if(user)
		to_chat(user, "<span class='notice'>You attach \the [src] to \the [has_suit].</span>")
		src.add_fingerprint(user)

/obj/item/clothing/accessory/proc/on_removed(var/mob/user)
	if(!has_suit)
		return
	has_suit.cut_overlay(get_inv_overlay())
	has_suit = null
	if(user)
		usr.put_in_hands(src)
		src.add_fingerprint(user)
	else
		src.forceMove(get_turf(src))

//default attackby behaviour
/obj/item/clothing/accessory/attackby(obj/item/I, mob/user)
	..()

//default attack_hand behaviour
/obj/item/clothing/accessory/attack_hand(mob/user as mob)
	if(has_suit)
		return	//we aren't an object on the ground so don't call parent
	..()

//default attack_self behaviour
/obj/item/clothing/accessory/attack_self(mob/user as mob)
	if(flippable)
		if(!flipped)
			if(!overlay_state)
				icon_state = "[icon_state]_flip"
				flipped = 1
			else
				overlay_state = "[overlay_state]_flip"
				flipped = 1
		else
			if(!overlay_state)
				icon_state = initial(icon_state)
				flipped = 0
			else
				overlay_state = initial(overlay_state)
				flipped = 0
		to_chat(usr, "You change \the [src] to be on your [src.flipped ? "right" : "left"] side.")
		update_clothing_icon()
		inv_overlay = null
		mob_overlay = null
		return
	..()

/obj/item/clothing/accessory/red
	name = "red tie"
	icon_state = "redtie"

/obj/item/clothing/accessory/tie/red_clip
	name = "red tie with a clip"
	icon_state = "redcliptie"

/obj/item/clothing/accessory/tie/orange
	name = "orange tie"
	icon_state = "orangetie"

/obj/item/clothing/accessory/tie/yellow
	name = "yellow tie"
	icon_state = "yellowtie"

/obj/item/clothing/accessory/horrible
	name = "horrible tie"
	desc = "A neosilk clip-on tie. This one is disgusting."
	icon_state = "horribletie"

/obj/item/clothing/accessory/tie/green
	name = "green tie"
	icon_state = "greentie"

/obj/item/clothing/accessory/tie/darkgreen
	name = "dark green tie"
	icon_state = "dgreentie"

/obj/item/clothing/accessory/blue
	name = "blue tie"
	icon_state = "bluetie"

/obj/item/clothing/accessory/tie/blue_clip
	name = "blue tie with a clip"
	icon_state = "bluecliptie"

/obj/item/clothing/accessory/tie/navy
	name = "navy tie"
	icon_state = "navytie"

/obj/item/clothing/accessory/tie/purple
	name = "purple tie"
	icon_state = "purpletie"

/obj/item/clothing/accessory/tie/black
	name = "black tie"
	icon_state = "blacktie"

/obj/item/clothing/accessory/tie/white
	name = "white tie"
	icon_state = "whitetie"

/obj/item/clothing/accessory/tie/bowtie
	name = "bowtie"
	desc = "Snazzy!"
	icon_state = "bowtie"

/obj/item/clothing/accessory/stethoscope
	name = "stethoscope"
	desc = "An outdated medical apparatus for listening to the sounds of the human body. It also makes you look like you know what you're doing."
	icon_state = "stethoscope"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_medical.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_medical.dmi',
		)
	flippable = 1

/obj/item/clothing/accessory/stethoscope/attack(mob/living/carbon/human/M, mob/living/user)
	if(ishuman(M) && isliving(user))
		if(user.a_intent == I_HELP)
			var/obj/item/organ/organ = M.get_organ(user.zone_sel.selecting)
			if(organ)
				user.visible_message(span("notice", "[user] places [src] against [M]'s [organ.name] and listens attentively."), 
									 "You place [src] against [M]'s [organ.name]. You hear <b>[english_list(organ.listen())]</b>.")
				return
	return ..(M,user)

//Religious items
/obj/item/clothing/accessory/rosary
	name = "rosary"
	desc = "A form of prayer psalter used in the Catholic Church, with a string of beads attached to it."
	icon = 'icons/obj/clothing/chaplain.dmi'
	icon_state = "rosary"
	overlay_state = "rosary"
	flippable = 1

	slot_flags = SLOT_BELT | SLOT_TIE

	drop_sound = 'sound/items/drop/scrap.ogg'

//Medals
/obj/item/clothing/accessory/medal
	name = "bronze medal"
	desc = "A bronze medal."
	icon_state = "bronze"
	overlay_state = "bronze"
	flippable = 1

	drop_sound = 'sound/items/drop/scrap.ogg'

/obj/item/clothing/accessory/medal/conduct
	name = "distinguished conduct medal"
	desc = "A bronze medal awarded for distinguished conduct. Whilst a great honor, this is most basic award on offer. It is often awarded by a captain to a member of their crew."
	icon_state = "bronze_nt"

/obj/item/clothing/accessory/medal/bronze_heart
	name = "bronze heart medal"
	desc = "A bronze heart-shaped medal awarded for sacrifice. It is often awarded posthumously or for severe injury in the line of duty."
	icon_state = "bronze_heart"

/obj/item/clothing/accessory/medal/nobel_science
	name = "\improper Nobel science award"
	desc = "A bronze medal which represents significant contributions to the field of science or engineering."

/obj/item/clothing/accessory/medal/sol
	name = "\improper ASSN medal of bravery"
	desc = "A bronze medal dedicated to those who have demonstrated courageous acts in the name of the Alliance of Sovereign Solarian Nations."
	icon_state = "bronze_sol"

/obj/item/clothing/accessory/medal/iron
	name = "iron medal"
	desc = "A simple iron medal."
	icon_state = "iron"
	overlay_state = "iron"

/obj/item/clothing/accessory/medal/iron/merit
	name = "iron merit medal"
	desc = "An iron medal awarded to NanoTrasen employees for merit."
	icon_state = "iron_nt"

/obj/item/clothing/accessory/medal/iron/star
	name = "iron star medal"
	desc = "An iron medal awarded to those who have provided service to their profession in the field of medical organisation, and/or to physicians by enhancing overall health and well-being of colleagues on both personal and professional levels."
	icon_state = "iron_star"
	overlay_state = "iron_star"

/obj/item/clothing/accessory/medal/iron/sol
	name = "\improper ASSN medal of effort"
	desc = "An iron medal awarded for distinguished effort conducted by an individual in the name of the Alliance of Sovereign Solarion Nations."
	icon_state = "iron_sol"

/obj/item/clothing/accessory/medal/silver
	name = "silver medal"
	desc = "A silver medal."
	icon_state = "silver"
	overlay_state = "silver"

/obj/item/clothing/accessory/medal/silver/valor
	name = "medal of valor"
	desc = "A silver medal awarded for acts of exceptional valor."
	icon_state = "silver_sword"

/obj/item/clothing/accessory/medal/silver/security
	name = "robust security award"
	desc = "An award for distinguished combat and sacrifice in defence of corporate commercial interests. Often awarded to security staff."
	icon_state = "silver_nt"

/obj/item/clothing/accessory/medal/silver/sol
	name = "\improper ASSN medal of service"
	desc = "A silver medal held for those who have served for long periods of time with pristine conduct in the name of the Alliance of Sovereign Solarian Nations."
	icon_state = "silver_sol"

/obj/item/clothing/accessory/medal/gold
	name = "gold medal"
	desc = "A prestigious golden medal."
	icon_state = "gold"
	overlay_state = "gold"

/obj/item/clothing/accessory/medal/gold/star
	name = "gold star medal"
	desc = "Some sort of medal with finely-cut gold. There is a small arch depicted on it."
	icon_state = "gold_star"

/obj/item/clothing/accessory/medal/gold/sun
	name = "gold sun medal"
	desc = "A finely rounded gold medal with small, complicated engravings running all around it."
	icon_state = "gold_sun"

/obj/item/clothing/accessory/medal/gold/captain
	name = "medal of captaincy"
	desc = "A golden medal awarded exclusively to those promoted to the rank of captain. It signifies the codified responsibilities of a captain, and their undisputable authority over their crew."
	icon_state = "gold_nt"

/obj/item/clothing/accessory/medal/gold/heroism
	name = "medal of exceptional heroism"
	desc = "An extremely rare golden medal awarded only by company officials. To receive such a medal is the highest honor and as such, very few exist. This medal is almost never awarded to anybody but commanders."
	icon_state = "gold_crest"

/obj/item/clothing/accessory/medal/gold/sol
	name = "\improper ASSN medal of distinction"
	desc = "A gold medal reserved only for those with excellent performance in both combat and political training, for selflessness, and for bravery displayed in service under the Alliance of Sovereign Solarian Nations."
	icon_state = "gold_sol"

/obj/item/clothing/accessory/medal/white_heart
	name = "distinguished volunteer's medal"
	desc = "A white medal with a red cross on it for those who have performed outstanding medical services as a volunteer for the Interstellar Aid Corps."
	icon_state = "white_heart"
	overlay_state = "white_heart"

/obj/item/clothing/accessory/suspenders
	name = "suspenders"
	desc = "They suspend the illusion of the mime's play."
	icon_state = "suspenders"
	item_state = "suspenders"

/obj/item/clothing/accessory/scarf
	name = "white scarf"
	desc = "A simple scarf, to protect your neck from the cold of space."
	icon_state = "whitescarf"
	item_state = "whitescarf"
	overlay_state = "whitescarf"
	flippable = 1

/obj/item/clothing/accessory/scarf/yellow
	name = "yellow scarf"
	icon_state = "yellowscarf"
	item_state = "yellowscarf"
	overlay_state = "yellowscarf"

/obj/item/clothing/accessory/scarf/green
	name = "green scarf"
	icon_state = "greenscarf"
	item_state = "greenscarf"
	overlay_state = "greenscarf"

/obj/item/clothing/accessory/scarf/purple
	name = "purple scarf"
	icon_state = "purplescarf"
	item_state = "purplescarf"
	overlay_state = "purplescarf"

/obj/item/clothing/accessory/scarf/black
	name = "black scarf"
	icon_state = "blackscarf"
	item_state = "blackscarf"
	overlay_state = "blackscarf"

/obj/item/clothing/accessory/scarf/red
	name = "red scarf"
	icon_state = "redscarf"
	item_state = "redscarf"
	overlay_state = "redscarf"

/obj/item/clothing/accessory/scarf/orange
	name = "orange scarf"
	icon_state = "orangescarf"
	item_state = "orangescarf"
	overlay_state = "orangescarf"

/obj/item/clothing/accessory/scarf/light_blue
	name = "light blue scarf"
	icon_state = "lightbluescarf"
	item_state = "lightbluescarf"
	overlay_state = "lightbluescarf"

/obj/item/clothing/accessory/scarf/dark_blue
	name = "dark blue scarf"
	icon_state = "darkbluescarf"
	item_state = "darkbluescarf"
	overlay_state = "darkbluescarf"

/obj/item/clothing/accessory/scarf/zebra
	name = "zebra scarf"
	icon_state = "zebrascarf"
	item_state = "zebrascarf"
	overlay_state = "zebrascarf"

/obj/item/clothing/accessory/chaps
	name = "brown chaps"
	desc = "A pair of loose, brown leather chaps."
	icon_state = "chaps"
	item_state = "chaps"

/obj/item/clothing/accessory/chaps/black
	name = "black chaps"
	desc = "A pair of loose, black leather chaps."
	icon_state = "chaps_black"
	item_state = "chaps_black"

/*
* Poncho
*/

/obj/item/clothing/accessory/poncho
	name = "poncho"
	desc = "A simple, comfortable poncho."
	icon_state = "classicponcho"
	item_state = "classicponcho"
	icon_override = 'icons/mob/ties.dmi'
	allowed = list(/obj/item/tank/emergency_oxygen,/obj/item/storage/bible,/obj/item/nullrod,/obj/item/reagent_containers/food/drinks/bottle/holywater)
	slot_flags = SLOT_OCLOTHING | SLOT_TIE
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	siemens_coefficient = 0.9
	w_class = 3
	slot = "over"
	var/allow_tail_hiding = TRUE //in case if you want to allow someone to switch the HIDETAIL var or not

/obj/item/clothing/accessory/poncho/verb/toggle_hide_tail()
	set name = "Toggle Tail Coverage"
	set category = "Object"

	if(allow_tail_hiding)
		flags_inv ^= HIDETAIL
		to_chat(usr, "<span class='notice'>[src] will now [flags_inv & HIDETAIL ? "hide" : "show"] your tail.</span>")

/obj/item/clothing/accessory/poncho/big
	name = "large poncho"
	desc = "A simple, comfortable poncho. Noticibly larger around the shoulders."
	item_state = "classicponcho-big"
	icon_state = "classicponcho-big"

/obj/item/clothing/accessory/poncho/green
	name = "green poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is green."
	icon_state = "greenponcho"
	item_state = "greenponcho"

/obj/item/clothing/accessory/poncho/green/big
	name = "large green poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is green. Noticibly larger around the shoulders."
	icon_state = "greenponcho-big"
	item_state = "greenponcho-big"

/obj/item/clothing/accessory/poncho/red
	name = "red poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is red."
	icon_state = "redponcho"
	item_state = "redponcho"

/obj/item/clothing/accessory/poncho/red/big
	name = "large red poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is red. Noticibly larger around the shoulders."
	icon_state = "redponcho-big"
	item_state = "redponcho-big"

/obj/item/clothing/accessory/poncho/purple
	name = "purple poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is purple."
	icon_state = "purpleponcho"
	item_state = "purpleponcho"

/obj/item/clothing/accessory/poncho/blue
	name = "blue poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is blue."
	icon_state = "blueponcho"
	item_state = "blueponcho"

/obj/item/clothing/accessory/poncho/roles/medical
	name = "medical poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is white with green and blue tint, standard Medical colors."
	icon_state = "medponcho"
	item_state = "medponcho"

/obj/item/clothing/accessory/poncho/roles/engineering
	name = "engineering poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is yellow and orange, standard Engineering colors."
	icon_state = "engiponcho"
	item_state = "engiponcho"

/obj/item/clothing/accessory/poncho/roles/science
	name = "science poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is white with purple trim, standard NanoTrasen Science colors."
	icon_state = "sciponcho"
	item_state = "sciponcho"

/obj/item/clothing/accessory/poncho/roles/cargo
	name = "cargo poncho"
	desc = "A simple, comfortable cloak without sleeves. This one is tan and grey, the colors of Cargo."
	icon_state = "cargoponcho"
	item_state = "cargoponcho"

/*
 * Cloak
 */
/obj/item/clothing/accessory/poncho/roles/cloak
	name = "quartermaster's cloak"
	desc = "An elaborate brown and gold cloak."
	icon_state = "qmcloak"
	item_state = "qmcloak"
	body_parts_covered = null

/obj/item/clothing/accessory/poncho/roles/cloak/ce
	name = "chief engineer's cloak"
	desc = "An elaborate cloak worn by the chief engineer."
	icon_state = "cecloak"
	item_state = "cecloak"

/obj/item/clothing/accessory/poncho/roles/cloak/cmo
	name = "chief medical officer's cloak"
	desc = "An elaborate cloak meant to be worn by the chief medical officer."
	icon_state = "cmocloak"
	item_state = "cmocloak"

/obj/item/clothing/accessory/poncho/roles/cloak/hop
	name = "head of personnel's cloak"
	desc = "An elaborate cloak meant to be worn by the head of personnel."
	icon_state = "hopcloak"
	item_state = "hopcloak"

/obj/item/clothing/accessory/poncho/roles/cloak/rd
	name = "research director's cloak"
	desc = "An elaborate cloak meant to be worn by the research director."
	icon_state = "rdcloak"
	item_state = "rdcloak"

/obj/item/clothing/accessory/poncho/roles/cloak/qm
	name = "quartermaster's cloak"
	desc = "An elaborate cloak meant to be worn by the quartermaster."
	icon_state = "qmcloak"
	item_state = "qmcloak"

/obj/item/clothing/accessory/poncho/roles/cloak/captain
	name = "captain's cloak"
	desc = "An elaborate cloak meant to be worn by the Captain."
	icon_state = "capcloak"
	item_state = "capcloak"

/obj/item/clothing/accessory/poncho/roles/cloak/hos
	name = "head of security's cloak"
	desc = "An elaborate cloak meant to be worn by the Head of Security."
	icon_state = "hoscloak"
	item_state = "hoscloak"

/obj/item/clothing/accessory/poncho/roles/cloak/cargo
	name = "brown cloak"
	desc = "A simple brown and black cloak worn by crate jockeys."
	icon_state = "cargocloak"
	item_state = "cargocloak"

/obj/item/clothing/accessory/poncho/roles/cloak/mining
	name = "trimmed purple cloak"
	desc = "A trimmed purple and brown cloak worn by dwarves."
	icon_state = "miningcloak"
	item_state = "miningcloak"

/obj/item/clothing/accessory/poncho/roles/cloak/service
	name = "green cloak"
	desc = "A simple green and blue cloak worn by.. Who?"
	icon_state = "servicecloak"
	item_state = "servicecloak"

/obj/item/clothing/accessory/poncho/roles/cloak/engineer
	name = "gold cloak"
	desc = "A simple gold and brown cloak worn by grease monkeys."
	icon_state = "engicloak"
	item_state = "engicloak"

/obj/item/clothing/accessory/poncho/roles/cloak/atmos
	name = "yellow cloak"
	desc = "A trimmed yellow and blue cloak worn by airbenders."
	icon_state = "atmoscloak"
	item_state = "atmoscloak"

/obj/item/clothing/accessory/poncho/roles/cloak/research
	name = "purple cloak"
	desc = "A simple purple and white cloak worn by nerds."
	icon_state = "scicloak"
	item_state = "scicloak"

/obj/item/clothing/accessory/poncho/roles/cloak/medical
	name = "blue cloak"
	desc = "A simple blue and white cloak worn by suit sensor activists."
	icon_state = "medcloak"
	item_state = "medcloak"

/obj/item/clothing/accessory/poncho/roles/cloak/security
	name = "dark blue cloak"
	desc = "A simple dark blue cloak awarded by NanoTrasen for failing the introductory literacy test."
	icon_state = "seccloak"
	item_state = "seccloak"

/obj/item/clothing/accessory/poncho/shouldercape
	name = "shoulder cape"
	desc = "A simple shoulder cape."
	description_fluff = "In Skrellian tradition, the length of cape typically signifies experience in various fields."
	icon_state = "starcape"
	item_state = "starcape"
	flippable = 1

/obj/item/clothing/accessory/poncho/shouldercape/star
	name = "star cape"
	desc = "A simple looking cape with a couple of runes woven into the fabric."
	icon_state = "starcape"
	item_state = "starcape"
	overlay_state = "starcape"

/obj/item/clothing/accessory/poncho/shouldercape/nebula
	name = "nebula cape"
	desc = "A decorated cape. Starry patterns have been woven into the fabric."
	icon_state = "nebulacape"
	item_state = "nebulacape"
	overlay_state = "nebulacape"

/obj/item/clothing/accessory/poncho/shouldercape/nova
	name = "nova cape"
	desc = "A heavily decorated cape with emblems on the shoulders. An ornate starry design has been woven into the fabric of it"
	icon_state = "novacape"
	item_state = "novacape"
	overlay_state = "novacape"

/obj/item/clothing/accessory/poncho/shouldercape/galaxy
	name = "galaxy cape"
	desc = "An extremely decorated cape with an intricately made design has been woven into the fabric of this cape with great care."
	icon_state = "galaxycape"
	item_state = "galaxycape"
	overlay_state = "galaxycape"

/obj/item/clothing/accessory/poncho/trinary
    name = "trinary perfection cape"
    desc = "A brilliant red and brown cape, commonly worn by those who serve the Trinary Perfection."
    icon_state = "trinary_cape"
    item_state = "trinary_cape"
    overlay_state = "trinary_cape"

//tau ceti legion ribbons
/obj/item/clothing/accessory/legion
	name = "seniority ribbons"
	desc = "A ribbon meant to attach to the chest and sling around the shoulder accompanied by two medallions, marking seniority in a Tau Ceti Foreign Legion."
	icon_state = "senior_ribbon"
	item_state = "senior_ribbon"
	overlay_state = "senior_ribbon"
	slot = "over"
	flippable = 1

/obj/item/clothing/accessory/legion/specialist
	name = "specialist medallion"
	desc = "Two small medallions, one worn on the shoulder and the other worn on the chest. Meant to display the rank of specialist troops in a Tau Ceti Foreign Legion."
	icon_state = "specialist_medallion"
	item_state = "specialist_medallion"
	overlay_state = "specialist_medallion"

/obj/item/clothing/accessory/offworlder
	name = "venter assembly"
	desc = "A series of complex tubing meant to dissipate heat from the skin passively."
	icon_state = "venter"
	item_state = "venter"
	slot = "over"

/obj/item/clothing/accessory/offworlder/bracer
	name = "legbrace"
	desc = "A lightweight polymer frame meant to brace and hold someone's legs upright comfortably."
	icon_state = "legbrace"
	item_state = "legbrace"
	drop_sound = 'sound/items/drop/gun.ogg'

/obj/item/clothing/accessory/offworlder/bracer/neckbrace
	name = "neckbrace"
	desc = "A lightweight polymer frame meant to brace and hold someone's neck upright comfortably."
	icon_state = "neckbrace"
	item_state = "neckbrace"

/obj/item/clothing/accessory/tc_pin
	name = "Tau Ceti pin"
	desc = "A small, Tau Ceti flag pin of the Republic of Tau Ceti."
	icon_state = "tc-pin"
	item_state = "tc-pin"
	overlay_state = "tc-pin"
	flippable = 1
	drop_sound = 'sound/items/drop/ring.ogg'

/obj/item/clothing/accessory/sol_pin
	name = "Sol Alliance pin"
	desc = "A small pin of the Sol Alliance, shaped like a golden sun."
	icon_state = "sol-pin"
	item_state = "sol-pin"
	overlay_state = "sol-pin"
	flippable = 1
	drop_sound = 'sound/items/drop/ring.ogg'

/obj/item/clothing/accessory/dogtags
	name = "dogtags"
	desc = "A pair of engraved metal identification tags."
	icon_state = "tags"
	item_state = "tags"
	overlay_state = "tags"
	drop_sound = 'sound/items/drop/scrap.ogg'

/obj/item/clothing/accessory/sleevepatch
	name = "sleeve patch"
	desc = "An embroidered patch which can be attached to the shoulder sleeve of clothing."
	icon_state = "patch"
	overlay_state = "patch"
	flippable = 1
	drop_sound = 'sound/items/drop/gloves.ogg'

/obj/item/clothing/accessory/sleevepatch/necro
	name = "\improper Necropolis Industries sleeve patch"
	desc = "An embroidered patch which can be attached to the shoulder sleeve of clothing. This one bears the Necropolis Industries logo."
	icon_state = "necro_patch"
	overlay_state = "necro_patch"

/obj/item/clothing/accessory/sleevepatch/necrosec
	name = "\improper Necropolis Industries Security sleeve patch"
	desc = "An embroidered patch which can be attached to the shoulder sleeve of clothing. This one bears the Necropolis Industries logo with an insignia."
	icon_state = "necrosec_patch"
	overlay_state = "necrosec_patch"

/obj/item/clothing/accessory/sleevepatch/erisec
	name = "\improper EPMC sleeve patch"
	desc = "A digital patch which can be attached to the shoulder sleeve of clothing. This one denotes the wearer as an Eridani Private Military Contractor."
	icon_state = "erisec_patch"
	overlay_state = "erisec_patch"

/obj/item/clothing/accessory/sleevepatch/idrissec
	name = "\improper Idris Incorporated sleeve patch"
	desc = "A digital patch which can be attached to the shoulder sleeve of clothing. This one shows the Idris Incorporated logo with a flashing chevron."
	icon_state = "idrissec_patch"
	overlay_state = "idrissec_patch"
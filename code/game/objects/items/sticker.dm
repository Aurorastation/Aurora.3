/obj/item/sticker
	name = "sticker"
	desc = "It's a sticker."
	icon = 'icons/obj/sticker.dmi'
	icon_state = "sticker"
	item_flags = ITEM_FLAG_NO_BLUDGEON
	w_class = WEIGHT_CLASS_TINY
	vis_flags = VIS_INHERIT_LAYER | VIS_INHERIT_DIR

	var/datum/weakref/attached
	var/list/rand_icons

/obj/item/sticker/Initialize()
	. = ..()
	if(LAZYLEN(rand_icons))
		icon_state = pick(rand_icons)

/obj/item/sticker/attack_hand(mob/user)
	if(!isliving(user) || !attached)
		return ..()

	if(user.a_intent == I_HELP)
		remove_sticker(user)
		return

	var/atom/movable/attached_atom = attached.resolve()
	if(attached_atom)
		attached_atom.attack_hand(user) // don't allow people to make sticker armor

/obj/item/sticker/attack_ranged(mob/user)
	if(!attached)
		return

	var/atom/movable/attached_atom = attached.resolve()
	if(attached_atom && user.Adjacent(attached_atom))
		attack_hand(user)

/obj/item/sticker/attackby(obj/item/attacking_item, mob/user)
	if(!attached)
		return ..()

	var/atom/movable/attached_atom = attached.resolve()
	if(attached_atom)
		attached_atom.attackby(attacking_item, user) // don't allow people to make sticker armor
		return TRUE

/obj/item/sticker/afterattack(atom/movable/target, mob/user, proximity_flag, click_parameters)
	if(!proximity_flag)
		return
	if(!istype(target) || (ismob(target) && !isbot(target)))
		return
	if(!target.can_attach_sticker(user, src))
		return

	var/list/mouse_control = mouse_safe_xy(click_parameters)
	pixel_x = mouse_control["icon-x"] - 16
	pixel_y = mouse_control["icon-y"] - 16

	attach_to(user, target)

/obj/item/sticker/proc/attach_to(var/mob/user, var/atom/movable/A)
	to_chat(user, SPAN_NOTICE("You attach \the [src] to \the [A]."))
	user.drop_from_inventory(src, A)
	attached = WEAKREF(A)
	A.add_vis_contents(src)

/obj/item/sticker/proc/remove_sticker(var/mob/user)
	user.put_in_hands(src)
	var/atom/movable/attached_atom = attached.resolve()
	if(attached_atom)
		to_chat(user, SPAN_NOTICE("You remove \the [src] from \the [attached_atom]."))
		attached_atom.remove_vis_contents(src)
		attached = null

//
//generic stickers, catch all for anything that doesn't fit in another category
//
/obj/item/sticker/generic
	name = "sccv horizon sticker"
	desc = "A sticker of the vague shape of the SCCV Horizon."
	icon_state = "sccvhorizon"

/obj/item/sticker/generic/goldstar
	name = "gold star"
	desc = "A sticker of a gold star, for those overachievers."
	icon_state = "goldstar"

/obj/item/sticker/generic/googly_eye
	name = "googly eye"
	desc = "A large googly eye sticker."
	rand_icons = list("googly", "googly1", "googly2")

/obj/item/sticker/generic/sol
	name = "sol flag"
	desc = "A vinyl sticker of the ASSN's flag."
	icon_state = "sol"

/obj/item/sticker/generic/sancolette
	name = "san collete sticker"
	desc = "A round sticker of the San Colette flag."
	icon_state = "sancolette"

/obj/item/sticker/generic/domadice
	name = "domadice sticker"
	desc = "A vinyl sticker of the Domadice plush. Popular with a niche crowd."
	icon_state = "domadice"

/obj/item/sticker/generic/schlorgo
	name = "schlorgo sticker"
	desc = "A sticker of the Schlorgo. A penguin like animal mostly made of fat, renowned for its resistance to all blunt force."
	icon_state = "schlorgo"

/obj/item/sticker/generic/peace
	name = "peace sign sticker"
	desc = "A peace sign, white on a black background. It has become a universal symbol among humans, \
	and still remains popular among student protestors to this day."
	icon_state = "peace"

/obj/item/sticker/generic/smile
	name = "smiley face sticker"
	desc = "A yellow smiley face. A meme 500 years old, the universal sign for positivity. :)"
	icon_state = "smile"

/obj/item/sticker/generic/redheart
	name = "red heart sticker"
	desc = "A red heart outlined in white, ready to declare love, seal secrets, or just make any surface 100% more adorable."
	icon_state = "heart-red"

/obj/item/sticker/generic/smallredheart
	name = "small red heart sticker"
	desc = "The smaller counterpart to its larger sticker. Perfect for when you want to add a hint of love without overwhelming the room."
	icon_state = "smallheart-red"

/obj/item/sticker/generic/pinkheart
	name = "pink heart sticker"
	desc = "A pink heart outlined in white, perfect for spreading a little sweetness without saying a word."
	icon_state = "heart-pink"

/obj/item/sticker/generic/smallpinkheart
	name = "small pink heart sticker"
	desc = "A tiny pink heart sticker, as cute as it is subtle—because who says you can't be sweet without making a big fuss?"
	icon_state = "smallheart-pink"

/obj/item/sticker/generic/blackheart
	name = "black heart sticker"
	desc = "A black heart sticker, because nothing says 'I'm complicated' like a heart that's too cool for color."
	icon_state = "heart-black"

/obj/item/sticker/generic/smallblackheart
	name = "small black heart sticker"
	desc = "A tiny black heart sticker, just like yours—dark and a little bit harder to find than you'd like to admit."
	icon_state = "smallheart-black"

//
//All of the major corporations logos. Unless we add or remove a megacorp, these should remain unchanged.
//
/obj/item/sticker/corporate
	name = "scc sticker"
	desc = "A sticker of the Stellar Corporate Conglomerate's logo."
	icon_state = "scc"

/obj/item/sticker/corporate/nt
	name = "nanotrasen sticker"
	desc = "A sticker of the NanoTrasen Corporation logo"
	icon_state = "nanotrasen"

/obj/item/sticker/corporate/zavodskoi
	name = "zavodskoi sticker"
	desc = "A sticker of the Zavodskoi Interstellar logo."
	icon_state = "zavodskoi"

/obj/item/sticker/corporate/hephaestus1
	name = "orange hephaestus sticker"
	desc = "A sticker of the Hephaestus Industries logo."
	icon_state = "hephaestus"

/obj/item/sticker/corporate/hephaestus2
	name = "green hephaestus sticker"
	desc = "A sticker of the Hephaestus Industries logo."
	icon_state = "hephaestus2"

/obj/item/sticker/corporate/idris
	name = "idris sticker"
	desc = "A sticker of the Idris Incorporated logo."
	icon_state = "idris"
//
//Anything religion specific stickers go here.
//
/obj/item/sticker/religious
	name = "triple goddess sticker"
	desc = "A sticker of Luna, in her waxing, full, and waning phases. A symbol that can represent many neopagan religious movements."
	icon_state = "threemoongoddess"

/obj/item/sticker/religious/cross
	name = "cross sticker"
	desc = "A simple black and white sticker of a cross. As genericly christian as possible, usable by just about any branch."
	icon_state = "cross"

/obj/item/sticker/religious/crucifix
	name = "crucifix sticker"
	desc = "A golden crucifix sticker. Vampire warding power not guaranteed."
	icon_state = "crucifix"

//I'm sure there's a better name than islam for this, but it was the name on the sprite when i first got it. And its kinda funny to just call it "islam."
/obj/item/sticker/religious/islam
	name = "star and crescent sticker"
	desc = "A yellow star and crescent on a blue background. As generically islamic as possible."
	icon_state = "islam"

/obj/item/sticker/religious/twinsuns
	name = "twin suns sticker"
	desc = "A vinyl sticker of the Tajaran Twin Suns."
	icon_state = "twinsuns"

/obj/item/sticker/religious/luceism
	name = "luceism sticker"
	desc = "A vinyl sticker of the Luceian Square, a major holy symbol of Luceism."
	icon_state = "luceism"

/obj/item/sticker/religious/tribunal
	name = "tribunal eye sticker"
	desc = "A red and black vinyl sticker of the Tribunal Eye, the main religious symbol of Tribunalism."
	icon_state = "tribunal"

/obj/item/sticker/religious/trinary
	name = "trinary sticker"
	desc = "A vinyl sticker, depicting a religious symbol of the Trinary Perfection."
	icon_state = "trinary"

//
//All the flagpole stickers made by LforLouise.
//

/obj/item/sticker/flagpole
	name = "white flagp sticker"
	desc = "A white flag on a flagpole."
	icon_state = "poleflagtemplate"

/obj/item/sticker/flagpole/biesel
	name = "biesel flag sticker"
	desc = "The flag of the Republic of Biesel on a flagpole."
	icon_state = "bieselpole"

/obj/item/sticker/flagpole/biesel/gibson
	name = "new gibson flag sticker"
	desc = "The flag of New Gibson on a flagpole."
	icon_state = "gibsonpole"

/obj/item/sticker/flagpole/biesel/mictlan
	name = "mictlan flag sticker"
	desc = "The flag of Mictlan on a flagpole."
	icon_state = "mictlanpole"

/obj/item/sticker/flagpole/biesel/valkyrie
	name = "valkyrie flag sticker"
	desc = "The flag of Valkyrie on a flagpole."
	icon_state = "valkyriepole"

/obj/item/sticker/flagpole/biesel/port_antilla
	name = "port antilla flag sticker"
	desc = "The flag of Port Antilla on a flagpole."
	icon_state = "portantillapole"

/obj/item/sticker/flagpole/persepolis
	name = "persepolis flag sticker"
	desc = "The flag of Persepolis on a flagpole."
	icon_state = "persepolispole"

/obj/item/sticker/flagpole/persepolis/aemaq
	name = "aemaq flag sticker"
	desc = "The flag of Aemaq on a flagpole."
	icon_state = "aemaqpole"

/obj/item/sticker/flagpole/persepolis/damascus
	name = "damascus flag sticker"
	desc = "The flag of Damascus II on a flagpole."
	icon_state = "damascuspole"

/obj/item/sticker/flagpole/persepolis/medinapole
	name = "medina flag sticker"
	desc = "The flag of Medina on a flagpole."
	icon_state = "medinapole"

/obj/item/sticker/flagpole/persepolis/newsuez
	name = "new suez flag sticker"
	desc = "The flag of New Suez on a flagpole."
	icon_state = "newsuezpole"

/obj/item/sticker/flagpole/assn
	name = "assn flag sticker"
	desc = "The flag of the Alliance of Sovereign Solarian Nations on a flagpole."
	icon_state = "assnpole"

/obj/item/sticker/flagpole/assn/callisto
	name = "callisto flag sticker"
	desc = "The flag of Callisto on a flagpole."
	icon_state = "callistopole"

/obj/item/sticker/flagpole/assn/europa
	name = "europa flag sticker"
	desc = "The flag of Europa on a flagpole."
	icon_state = "europapole"

/obj/item/sticker/flagpole/assn/luna
	name = "luna flag sticker"
	desc = "The flag of Luna on a flagpole."
	icon_state = "lunapole"

/obj/item/sticker/flagpole/assn/mars
	name = "mars flag sticker"
	desc = "The flag of Mars on a flagpole."
	icon_state = "marspole"

/obj/item/sticker/flagpole/assn/pluto
	name = "pluto flag sticker"
	desc = "The flag of Pluto on a flagpole."
	icon_state = "plutopole"

/obj/item/sticker/flagpole/assn/venus
	name = "venus flag"
	desc = "The flag of Venus on a flagpole."
	icon_state = "venuspole"

/obj/item/sticker/flagpole/assn/newhaiphong
	name = "new hai phong sticker"
	desc = "The flag of New Hai Phong on a flagpole."
	icon_state = "newhaiphongpole"

/obj/item/sticker/flagpole/assn/sancolette
	name = "san colette sticker"
	desc = "The flag of San Colette on a flagpole."
	icon_state = "sancolettepole"

/obj/item/sticker/flagpole/assn/silversun
	name = "silversun sticker"
	desc = "The flag of Silversun on a flagpole."
	icon_state = "silversunpole"

/obj/item/sticker/flagpole/assn/visegrad
	name = "visegrad sticker"
	desc = "The flag of Visegrad on a flagpole."
	icon_state = "visegradpole"

/obj/item/sticker/flagpole/coalition
	name = "coalition of colonies sticker"
	desc = "The flag of the Coalition of Colonies on a flagpole."
	icon_state = "cocpole"

/obj/item/sticker/flagpole/coalition/assunzione
	name = "assunzione flag sticker"
	desc = "The flag of Assunzione on a flagpole."
	icon_state = "assunzionepole"

/obj/item/sticker/flagpole/coalition/burzsiapole
	name = "burzsia flag sticker"
	desc = "The flag of Burzsia on a flagpole."
	icon_state = "burzsiapole"

/obj/item/sticker/flagpole/coalition/gadpathur
	name = "gadpathur flag sticker"
	desc = "The flag of Gadpathur on a flagpole."
	icon_state = "gadpathurpole"

/obj/item/sticker/flagpole/coalition/galatea
	name = "galatea flag sticker"
	desc = "The flag of Galatea on a flagpole."
	icon_state = "galateapole"

/obj/item/sticker/flagpole/coalition/himeo
	name = "himeo flag sticker"
	desc = "The flag of himeo on a flagpole."
	icon_state = "himeopole"

/obj/item/sticker/flagpole/coalition/konyang
	name = "konyang flag sticker"
	desc = "The flag of Konyang on a flagpole."
	icon_state = "konyangpole"

/obj/item/sticker/flagpole/coalition/scarab
	name = "scarab emblem sticker"
	desc = "The flag of the symbol of the Scarabs confederation on a flagpole."
	icon_state = "scarabpole"

/obj/item/sticker/flagpole/coalition/xanu
	name = "all xanu republic flag sticker"
	desc = "The flag of the All Xanu-Republic on a flagpole."
	icon_state = "xanupole"

/obj/item/sticker/flagpole/coalition/vysoka
	name = "vysoka flag sticker"
	desc = "The flag of Vysoka on a flagpole."
	icon_state = "vysokapole"

/obj/item/sticker/flagpole/dominia
	name = "moroz flag sticker"
	desc = "The flag of Moroz and the Keeser Royal Family on a flagpole."
	icon_state = "morozpole"

/obj/item/sticker/flagpole/dominia/caladius
	name = "caladius flag sticker"
	desc = "The flag and standard of House Caladius on a flagpole."
	icon_state = "caladiuspole"

/obj/item/sticker/flagpole/dominia/volvalaad
	name = "volvalaad flag sticker"
	desc = "The flag and standard of House Volvalaad on a flagpole."
	icon_state = "volvalaadpole"

/obj/item/sticker/flagpole/dominia/zhao
	name = "zhao flag sticker"
	desc = "The flag and standard of House Zhao on a flagpole."
	icon_state = "zhaopole"

/obj/item/sticker/flagpole/dominia/strelitzpole
	name = "strelitz flag sticker"
	desc = "The flag and standard of House Strelitz on a flagpole."
	icon_state = "strelitzpole"

/obj/item/sticker/flagpole/dominia/kazhkz
	name = "kazhkz flag sticker"
	desc = "The flag and standard of House Kazhkz on a flagpole."
	icon_state = "kazhkzpole"

/obj/item/sticker/flagpole/dominia/hansan
	name = "han'san flag sticker"
	desc = "The flag and standard of Clan Han'san on a flagpole."
	icon_state = "hansanpole"

/obj/item/sticker/flagpole/dominia/frontier
	name = "imperial frontier flag sticker"
	desc = "The flag of the Imperial Frontier on a flagpole."
	icon_state = "frontierpole"

/obj/item/sticker/flagpole/nralakk
	name = "nralakk federation flag sticker"
	desc = "The flag of the Nralakk Federation on a flagpole."
	icon_state = "nralakkfedpole"

/obj/item/sticker/flagpole/nralakk/aweiji
	name = "aweiji flag sticker"
	desc = "The flag of Aweiji on a flagpole."
	icon_state = "aweijipole"

/obj/item/sticker/flagpole/nralakk/aloise
	name = "aloise flag sticker"
	desc = "The flag of Aloise on a flagpole."
	icon_state = "aloisepole"

/obj/item/sticker/flagpole/nralakk/xrim
	name = "xrim flag sticker"
	desc = "The flag of Xrim on a flagpole."
	icon_state = "xrimpole"

/obj/item/sticker/flagpole/adhomai
	name = "pra flag sticker"
	desc = "The flag of the People's Republic of Adhomai on a flagpole."
	icon_state = "prapole"

/obj/item/sticker/flagpole/adhomai/dpra
	name = "dpra flag sticker"
	desc = "The flag of the Democratic People's Republic of Adhomai on a flagpole."
	icon_state = "dprapole"

/obj/item/sticker/flagpole/adhomai/nka
	name = "nka flag sticker"
	desc = "The flag of the New Kingdom of Adhomai on a flagpole."
	icon_state = "nkapole"

/obj/item/sticker/flagpole/adhomai/crevus
	name = "crevus flag sticker"
	desc = "The flag of the Free City of Crevus on a flagpole."
	icon_state = "crevuspole"

/obj/item/sticker/flagpole/hieroaetheria
	name = "consortium flag sticker"
	desc = "The flag of The Consortium of Hieroaetheria on a flagpole."
	icon_state = "consortiumpole"

/obj/item/sticker/flagpole/hieroaetheria/ekane
	name = "ekane flag sticker"
	desc = "The flag of the Eternal Republic of the Ekane on a flagpole."
	icon_state = "ekanepole"

/obj/item/sticker/flagpole/hieroaetheria/glaorr
	name = "gla'orr flag sticker"
	desc = "The flag of the Union of Gla'orr on a flagpole."
	icon_state = "glaorrpole"

/obj/item/sticker/flagpole/hegemony
	name = "hegemony flag sticker"
	desc = "The flag of the Hegemony on a flagpole."
	icon_state = "hegemonypole"

/obj/item/sticker/flagpole/hegemony/ouerea
	name = "ouerea flag sticker"
	desc = "The flag of Ouerea on a flagpole."
	icon_state = "ouereapole"

/obj/item/sticker/flagpole/hegemony/queendom
	name = "sezk-hakh queendom flag sticker"
	desc = "The flag of the Queendom of Sezk-Hakh on a flagpole."
	icon_state = "queendompole"

//
//Anti Establishment flags, for the once were's and freedom fighters.
//
// Fishanduh, exiled to Xanu Prime
/obj/item/sticker/flagpole/resistance
	name = "fisanduh flag sticker"
	desc = "The flag of the Confederated States of Fisanduh on a flagpole."
	icon_state = "fisanduhpole"

//Free Tajaran Council, exiled to Himeo
/obj/item/sticker/flagpole/resistance/ftc
	name = "free tajaran council sticker"
	desc = "The flag of the Free Tajaran Council on a flagpole."
	icon_state = "ftcpole"

//Traverse Resistance, exiled to Biesel.
/obj/item/sticker/flagpole/resistance/traverse
	name = "traverse resistance flag sticker"
	desc = "The flag of on a flagpole."
	icon_state = "freetraversepole"

//Old Konyang, handed its L during the civil war by CoC Konyang.
/obj/item/sticker/flagpole/resistance/solkonyang
	name = "old konyang flag sticker"
	desc = "The old Solarian flag of Konyang on a flagpole."
	icon_state = "solkonyangpole"

//Ouerea Rebels, in truce with the establishment... for now.
/obj/item/sticker/flagpole/resistance/newouerea
	name = "new ouerea flag sticker"
	desc = "The flag of on a flagpole."
	icon_state = "newouereapole"

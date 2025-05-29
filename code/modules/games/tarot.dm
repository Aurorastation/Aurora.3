/* this is a playing card deck based off of the Rider-Waite Tarot Deck.
*/

/obj/item/deck/tarot
	name = "deck of tarot cards"
	desc = "For all your occult needs!"
	icon_state = "deck_tarot"
	hand_type = /obj/item/hand/tarot

/obj/item/hand/tarot
	deck_type = /obj/item/deck/tarot

/obj/item/deck/tarot/generate_deck()
	var/datum/playingcard/P
	for(var/name in list("Fool","Magician","High Priestess","Empress","Emperor","Hierophant","Lovers","Chariot","Strength","Hermit","Wheel of Fortune","Justice","Hanged Man","Death","Temperance","Devil","Tower","Star","Moon","Sun","Judgement","World"))
		P = new()
		P.name = "[name]"
		P.card_icon = "tarot_major"
		P.back_icon = "card_back_tarot"
		cards += P
	for(var/suit in list("wands","pentacles","cups","swords"))
		for(var/number in list("ace","two","three","four","five","six","seven","eight","nine","ten","page","knight","queen","king"))
			P = new()
			P.name = "[number] of [suit]"
			P.card_icon = "tarot_[suit]"
			P.back_icon = "card_back_tarot"
			cards += P

/obj/item/deck/tarot/AltClick(var/mob/user as mob)
	var/list/newcards = list()
	while(cards.len)
		var/datum/playingcard/P = pick(cards)
		P.name = replacetext(P.name," reversed","")
		if(prob(50))
			P.name += " reversed"
		newcards += P
		cards -= P
	cards = newcards
	playsound(src.loc, 'sound/items/cards/cardshuffle.ogg', 100, 1, -4)
	user.visible_message("\The [user] shuffles \the [src].")

/// Tajaran tarot deck.
/obj/item/deck/tarot/adhomai
	name = "adhomian divination cards deck"
	desc = "An adhomian deck of divination cards, used to read the one's fortune or play games."
	icon_state = "deck_adhomai"
	hand_type = /obj/item/hand/tarot/adhomai

/obj/item/hand/tarot/adhomai
	deck_type = /obj/item/deck/tarot/adhomai

/obj/item/deck/tarot/adhomai/generate_deck()
	var/datum/playingcard/P
	for(var/name in list("D'as'ral Massacre","Mystic","Suns' Sister","Queen","King","Father of the Parivara","S'rendal'Matir","Tank","Enforcer","Kraszarrumalkarii","Rredouane's Dice","Great Revolution","Assassin","Assassination","Dymtris Line",
	"Rrak'narrr","Steeple","Messa","Raskara","S'rendarr","Kazarrhaldiye","Adhomai"))
		P = new()
		P.name = "[name]"
		P.card_icon = "adhomai_major"
		P.back_icon = "card_back_adhomai"
		cards += P
	for(var/suit in list("wands","pentacles","cups","swords"))


		for(var/number in list("ace","two","three","four","five","six","seven","eight","nine","ten","serf","soldier","queen","king"))
			P = new()
			P.name = "[number] of [suit]"
			P.card_icon = "adhomai_[suit]"
			P.back_icon = "card_back_adhomai"
			cards += P

/// Skrellian tarot decks.
/obj/item/deck/tarot/nralakk
	name = "qwei'paqui homeworld deck"
	desc = "A Skrellian deck of tarot cards depicting the main constellations of Nralakk."
	icon_state = "deck_nralakk"

/obj/item/deck/tarot/nralakk/generate_deck()
	var/datum/playingcard/P
	for(var/name in list("Island","Hatching Egg","Star Chanter","Jiu'x'klua","Stormcloud","Gnarled Tree","Poet","Bloated Toad","Void","Qu'Poxii","Fisher","Mountain","Sraso","Nioh"))
		P = new()
		P.name = "[name]"
		var/suit = "nralakk"
		switch(name)
			if("Island")
				P.desc = "One of the main constellations that is shared by both Qeblak and Weishii. It is associated with Loneliness. Introspection. Earth. Rising above or Sinking beneath. Reality."
			if("Hatching Egg")
				name = "egg"
				P.desc = "One of the main constellations that is shared by both Qeblak and Weishii. It is associated with New beginnings. A fresh start. Youth. Life. Excitement. Ignorance. Foolishness. Joy."
			if("Star Chanter")
				name = "chanter"
				P.desc = "One of the main constellations that is shared by both Qeblak and Weishii. It is associated with Wisdom. Spirituality. Connection with the stars. Connection to history. Aloofness. A rigid path. Air."
			if("Jiu'x'klua")
				name = "klua"
				P.desc = "One of the main constellations that is shared by both Qeblak and Weishii. It is associated with Art. Creation. Loss. Sadness. Longing. Communication. The imaginary."
			if("Stormcloud")
				P.desc = "One of the main constellations that is shared by both Qeblak and Weishii. It is associated with Conflict. Shock. Surprises. Tension. Endurance. Strength. Force. Fire."
			if("Gnarled Tree")
				name = "gnarledtree"
				P.desc = "One of the main constellations that is shared by both Qeblak and Weishii. It is associated with Age. Wisdom. Sickness. Frailty, or, in certain orientations, toughness. Rigidity. Tradition. Plantlife. Balance."
			if("Poet")
				P.desc = "One of the main constellations that is shared by both Qeblak and Weishii. it is associated with Communication. Progress. Science. Advancement. Longing. Art. Expression. Loneliness. Contentment. Dreams."
			if("Bloated Toad")
				name = "bloatedtoad"
				P.desc = "One of the main constellations that is shared by both Qeblak and Weishii. it is associated with Greed. Arrogance. Wealth. Success. Smugness. Laziness. Accomplishment. Adulthood."
			if("Void")
				P.desc = "One of the main constellations that is shared by both Qeblak and Weishii. it is associated with Death. Endings. Mystery. The unknown. Fear. Danger. Creation."
			if("Qu'Poxii")
				name = "qupoxii"
				P.desc = "One of the main constellations that is shared by both Qeblak and Weishii. it is associated with Love. Friendship. Company. Opposites. Teamwork. Happiness. The material. Safety. Progress. Support."
			if("Fisher")
				P.desc = "One of the main constellations that is shared by both Qeblak and Weishii. it is associated with  Hard work. Stagnation. Embarrassment. Water. Patience. A long, but productive wait."
			if("Mountain")
				suit = "aweiji"
				P.desc = "One of the local constellations on the planet Aweiji. It is associated with Self-analysis. Feelings of accomplishment. Clearer view."
			if("Sraso")
				suit = "aweiji"
				P.desc = "One of the local constellations on the planet Aweiji. It is associated with Sustainability. Growth. Safety."
			if("Nioh")
				suit = "aweiji"
				P.desc = "One of the local constellations on the planet Aweiji. It is associated with Trust. Reliance. Perseverance. Survival."
		P.card_icon = "[suit]_[lowertext(name)]"
		P.back_icon = "card_off_[suit]"
		cards += P

/obj/item/deck/tarot/nonnralakk
	name = "qwei'paqui colonist deck"
	desc = "A Skrellian deck of tarot cards depicting the local constellations of planets outside Nralakk."
	icon_state = "deck_nonnralakk"
	hand_type = /obj/item/hand/tarot/nonnralakk

/obj/item/hand/tarot/nonnralakk
	deck_type = /obj/item/deck/tarot/nonnralakk

/obj/item/deck/tarot/nonnralakk/generate_deck()
	var/datum/playingcard/P
	for(var/name in list("Shell","Wave","Trident","Palm Tree","Pulque","Eel","Iqi Star","Sky-Grazer","Dyn"))
		P = new()
		P.name = "[name]"
		var/suit = "slz"
		switch(name)
			if("Shell")
				P.desc = "One of the local constellations revered by the Skrell of Mendell City's Starlight Zone. It is associated with Home, Family (Severson). Refuge, Safety (Lekan)."
			if("Wave")
				P.desc = "One of the local constellations revered by the Skrell of Mendell City's Starlight Zone. It is associated with Pilgrimage, Journey (Severson). Escape, Freedom (Lekan)."
			if("Trident")
				P.desc = "One of the local constellations revered by the Skrell of Mendell City's Starlight Zone. It is associated with Protection, Security (Severson). Oppression, Subjugation (Lekan)."
			if("Palm Tree")
				name = "palm"
				suit = "mict"
				P.desc = "One of the local constellations on the planet Mictlan. It is associated with Tranquility. Agitation. Anxiety. Peace."
			if("Pulque")
				suit = "mict"
				P.desc = "One of the local constellations on the planet Mictlan. It is associated with Togetherness. Comraderie. Overindulgence. Celebration."
			if("Eel")
				suit = "mict"
				P.desc = "One of the local constellations on the planet Mictlan. It is associated with Turncoat. The unanticipated. Intrigue. Forthcoming."
			if("Iqi Star")
				name = "iqi"
				suit = "newgib"
				P.desc = "One of the local constellations on the planet New Gibson. It is associated with Self-Advancement. Social standing. Success."
			if("Sky-Grazer")
				name = "skygrazer"
				suit = "newgib"
				P.desc = "One of the local constellations on the planet New Gibson. It is associated with Expressiveness. Freedom. Adventure."
			if("Dyn")
				suit = "newgib"
				P.desc = "One of the local constellations on the planet New Gibson. It is associated with Survival. Generosity. Community."
		P.card_icon = "[suit]_[lowertext(name)]"
		P.back_icon = "card_off_[suit]"
		cards += P

/// Lyodii tarot deck.
/obj/item/deck/tarot/lyodii
	name = "lyodii fatesayer deck"
	icon = 'icons/obj/item/playing_cards.dmi'
	icon_state = "lyodii_deck"
	desc = "A traditionally made deck of fatesayer cards, used by the people of the Lyod to tell one's fate."
	desc_extended = "These 'cards' are actually rectangular pieces of bone, engraved with different religious imagery. They are then painted with soot or blood-ink. Usually made by tribal shamans in \
	agonizingly difficult work, these are hand-crafted by each tribe - thus some imagery can deviate from one another. A deck consists of 36 pieces, divided as follows: Spirits, Beasts, Winds and Paths \
	each having eight cards in their stack and Bones, with four cards. Traditionally a Bone card is drawn, then one each of the rest. The Bone cards put the other four cards into perspective so one's fate \
	can be determined. More modern iterations of these Fatesayer decks are also made by the few permanent settlements in the Lyod, to sell them off. They are not using real bone and the imagery is usually more \
	refined and detailed, since they are machine-made."
	drop_sound = 'sound/items/drop/bone_drop.ogg'
	pickup_sound = 'sound/items/drop/bone_drop.ogg'
	hand_type = /obj/item/hand/tarot/lyodii

/*
/obj/item/deck/tarot/lyodii/AltClick(var/mob/user as mob)
	playsound(src.loc, 'sound/items/cards/bone_shuffle.ogg', 100, 1, -4)
	user.visible_message("\The [user] rearranges \the [src].")
*/
/obj/item/hand/tarot/lyodii
	deck_type = /obj/item/deck/tarot/lyodii
	desc = "A deck of lyodii Fatesayer cards."
	drop_sound = 'sound/items/drop/bone_drop.ogg'
	pickup_sound = 'sound/items/drop/bone_drop.ogg'

/*
/obj/item/deck/tarot/lyodii/generate_deck()
	var/datum/playingcard/P
	for(var/name in list("The Chieftain","The Shaman","The Crown of Ice","The Dreaming Girl","The Flamewalker","The Tall Stranger","The Mother","The Hollowed Man","The Tenelote","The Arctic Fox","The Bisumoi","The Prejoroub",
	"The Yastr","The Ptarmigan","The Reindeer","The Snow Hare","The North Wind","The South Wind","The East Wind","The West Wind","The Windless Day","The Black Gale","The Whisper Breeze","The Stormcry","The Frozen Footprint",
	"The Shared Fire","The Broken Edict","The Silent Hunt","The Lost Tribe","The Marked Bone","The Buried Blade","The Icebound Oath","The Bone of Birth","The Bone of Death","The Bone of Choice","The Goddess"))
		P = new()
		P.card_icon = "beasts"
		P.back_icon = "card_back_lyodii"
		cards += P
*/
/obj/item/deck/tarot/lyodii/spirits
	name = "lyodii fatesayer spirits deck"
	desc = "A traditionally made deck of fatesayer cards, used by the people of the Lyod. This stack contains the Spirits cards. "
	icon_state = "lyodii_deck"
	item_state = "lyodii_deck"

/obj/item/deck/tarot/lyodii/spirits/generate_deck()
	var/datum/playingcard/P
	for(var/name in list("Chieftain","Shaman","Crown of Ice","Dreaming Girl","Flamewalker","Tall Stranger","Mother","Hollowed Man"))
		P = new()
		P.name = "[name]"
		switch(name)
			if("Chieftain")
				P.desc = "A tall figure stands before a wind-beaten tent, draped in heavy furs. One hand holds a carved antler staff, the other raised toward a gathering of smaller shadowy figures. The chieftain's eyes are closed in \
				burdened contemplation. Behind him, the sun is barely visible over the horizon. It is associated with: leadership, burden, guidance."
			if("Shaman")
				P.desc = "A kneeling figure surrounded by animal bones and burning herbs. Her face is painted with blood and soot. Behind her, a spectral shape looms but no details can be made out. It is associated with: wisdom, communion \
				with spirits, madness."
			if("Crown of Ice")
				P.desc = "A throne of cracked glacier-ice, on it sitting a crown of deep blue ice. There are two sockets embedded in the crown, one with a sapphire, one empty. It is associated with: harsh judge, death's herald."
			if("Dreaming Girl")
				P.desc = "A young girl sleeping in a snowdrift, untouched by cold. Above her, the night sky swirls with auroras forming vague shapes. Her expression is peaceful, but a tear of blood escapes one eye. It is associated with: \
				prophecy, confusion, hidden truths."
			if("Flamewalker")
				P.desc = "A cloaked figure walking across an icefield. He's burning. Fire doesn’t consume him— it emerges from his footprints. He carries a bundle of books and bones wrapped in red cloth. It is associated with: \
				change-bringing, exile, innovation."
			if("Tall Stranger")
				P.desc = "A faceless, well-built and tall standing figure in fine red-gilded robes stands at atop a snowdrift. He holds a sword in one hand, the other's clenched to a fist. No footprints are left where he stands. \
				It is associated with: deception, fate disguised, dishonesty."
			if("Mother")
				P.desc = "A woman cradling a baby in one arm, a ceremonial blade in the other. Her expression is conflicted. Behind her, two paths diverge—one leads to a firelit camp, the other into a storm. It is associated with: \
				choices, nurture vs. law, duality."
			if("Hollowed Man")
				P.desc = "A man torso unclothed, kneels in the snow. A hole where his heart should be reveals a swirling void inside. Spirits drift around him. It is associated with: sacrifice, emptiness, spiritual rebirth."
		P.card_icon = "spirits"
		P.back_icon = "card_back_lyodii"
		cards += P

/obj/item/deck/tarot/lyodii/paths
	name = "lyodii fatesayer paths deck"
	desc = "A traditionally made deck of fatesayer cards, used by the people of the Lyod. This stack contains the Paths cards. "
	icon_state = "lyodii_deck"
	item_state = "lyodii_deck"

/obj/item/deck/tarot/lyodii/paths/generate_deck()
	var/datum/playingcard/P
	for(var/name in list("Frozen Footprint","Shared Fire","Broken Edict","Silent Hunt","Lost Tribe","Marked Bone","Buried Blade","Icebound Oath"))
		P = new()
		P.name = "[name]"
		switch(name)
			if("Frozen Footprint")
				P.desc = "A single footprint frozen solid in a cracked icy path. It glows faintly, untouched by time. Around it, scattered is a bloodied cloth and a broken spearhead. It is associated with: missed opportunity, consequences."
			if("Shared Fire")
				P.desc = "everal figures gather around a fire in the middle of a blizzard. Though cold rages around them, their circle is warm. Shadows on the tent walls show animals instead of people. One figure extends a \
				hand to the viewer. It is associated with: community, sacrifice, loyality."
			if("Broken Edict")
				P.desc = "A sacred tablet cracked down the middle, one half buried in snow, the crack forms a lightning-shaped glyph. A fox sits nearby, watching. It is associated with: rebellion, righteousness, moral ambiguity."
			if("Silent Hunt")
				P.desc = "A hunter crouches in the snow, bow drawn, breath invisible. Behind them, a spectral beast stalks them in silence. No footprints in the snow. Both hunter and hunted wear the same carved mask. It is associated with: \
				patience, waiting, unspoken action."
			if("Lost Tribe")
				P.desc = "A caravan of silhouettes walks endlessly across a snowplain beneath a starry sky. One member carries a banner with, but it is impossible to see what it shows. It is associated with: disconnection, wandering."
			if("TMarked Bone")
				P.desc = "A long, polished bone lies on a shrine, carved with fresh glyphs bleeding red ink, a spectral bird watches from above. The glyphs emit a faint glow. It is associated with: signs from the Goddess, omens."
			if("Buried Blade")
				P.desc = "A ritual dagger protrudes from a snowbank, only its hilt visible. Blood stains the snow nearby. The hilt is wrapped in two colors. A snowflake lands, forming a glyph for 'lies'. It is associated with: \
				hidden conflict, denial."
			if("Icebound Oath")
				P.desc = "Two figures clasp wrists, their hands frozen together by blue ice. One looks determined, the other regretful. A small fire burns in the background. It is associated with: duty, promise, burdens kept too long."
		P.card_icon = "paths"
		P.back_icon = "card_back_lyodii"
		cards += P

/obj/item/deck/tarot/lyodii/beasts
	name = "lyodii fatesayer beasts deck"
	desc = "A traditionally made deck of fatesayer cards, used by the people of the Lyod. This stack contains the Beasts cards. "
	icon_state = "lyodii_deck"
	item_state = "lyodii_deck"

/obj/item/deck/tarot/lyodii/beasts/generate_deck()
	var/datum/playingcard/P
	for(var/name in list("Tenelote","Arctic Fox","Bisumoi","Prejoroub","Yastr","Ptarmigan","Reindeer","Snow Hare"))
		P = new()
		P.name = "[name]"
		switch(name)
			if("Tenelote")
				P.desc = "A massive white-furred Tenelote, horned, stands atop a frozen ridge. Its eyes glow faintly blue, snow spirals upward around it. Broken spears stick out of its flank, yet it stands unbowed. Behind it, \
				a blizzard is approaching. It is associated with: strength, endurance, ferocity."
			if("Arctic Fox")
				P.desc = "A small, sleek fox slinks through moonlit snow, looking back over its shoulder with knowing eyes. One pawprint glows faintly. Its tail is split in two. In the snow nearby: a discarded bone dice and a \
				trail of feathers. It is associated with: cunning, hidden paths, trickery."
			if("Bisumoi")
				P.desc = "A towering moose-like creature with two sets of twisted antlers resembling roots and glyphs. It gazes at the viewer through milky eyes while snow falls silently around it. It is associated with: \
				ancient wisdom, balance, ancestral memory."
			if("Prejoroub")
				P.desc = "A long-winged bird, vulture-like but with a face that resembles a skull, circles over a field strewn with bones. Feathers fall from its wings, where they land, fire erupts. Its shadow is shaped like a wolf. \
				It is associated with: death, scavenging, what must be taken."
			if("Yastr")
				P.desc = "A flock of thin-necked bird with long wings fly across the tundra under a blazing sunset. The lead bird looks back, as if uncertain. A single figure watches from afar, unseen by the beasts. It is associated with: \
			migration, movement, restlessness."
			if("Ptarmigan")
				P.desc = " deceptively calm snowbird perches on a branch above a frozen lake. Beneath the ice, shadows twist and churn. One eye of the bird is missing. A bloodied feather drifts down toward the viewer. It is associated with: \
				danger beneath calm, betrayal."
			if("Reindeer")
				P.desc = "A scarred reindeer stands within a ring of tribal totems. It bows its head, offering its antlers to a shamanic figure. Runes burned into its flank. Each totem around it is engraved with different runes. \
				It is associated with: loyalty, hunger, bonds."
			if("Snow Hare")
				P.desc = "A white hare dashes through the snow under a full moon, carrying a leaf bundle in its mouth. Behind it in the sky there's a shooting star. Three small spirits follow behind, barely visible. Snowflakes around \
				the hare are all different glyphs. It is associated with: small joys, fleeting beauty, messages."
		P.card_icon = "beasts"
		P.back_icon = "card_back_lyodii"
		cards += P
/obj/item/deck/tarot/lyodii/winds
	name = "lyodii fatesayer winds deck"
	desc = "A traditionally made deck of fatesayer cards, used by the people of the Lyod. This stack contains the Winds cards. "
	icon_state = "lyodii_deck"
	item_state = "lyodii_deck"

/obj/item/deck/tarot/lyodii/winds/generate_deck()
	var/datum/playingcard/P
	for(var/name in list("North Wind","South Wind","East Wind","West Wind","Windless Day","Black Gale","Whisper Breeze","Stormcry"))
		P = new()
		P.name = "[name]"
		switch(name)
			if("North Wind")
				P.desc = "A gentle, blue-hued gust flows over a landscape, moving over a firelit camp. Spirals of warmth rise from the fires. The wind forms a protective circle. It is associated with: mercy, home, unexpected aid."
			if("South Wind")
				P.desc = "A crimson gale howls down a mountainside, tearing trees from the ground. A figure walks into it, teeth bared. Faint, distorted faces can be seen in the gusts. Shattered ice-crystals fly like knives. \
				It is associated with: cruelty, challenge, reckoning."
			if("East Wind")
				P.desc = "A pale wind carries seeds and starlight across a dark horizon. Dawn breaks just as the wind touches the earth. One cloud overhead resembles an open eye. It is associated with: beginnings, clarity, sacred insight."
			if("West Wind")
				P.desc = "A wind brushes over a field of grave markers made of bone. Spirits rise gently in its wake. Faint faces drift briefly along the wind. The moon watches in the sky. It is associated with: endings, \
				mystery, ancestral voices."
			if("Windless Day")
				P.desc = "A completely still scene, a frozen lake, unmoving trees, a bird suspended in midair. A sense of being trapped in time. A small crack in the lake surface forms the glyph for 'waiting'. It is associated with: \
				stagnation, hidden tension."
			if("Black Gale")
				P.desc = "A storm-black wind crashes into tents, tearing them apart as lightning strikes nearby. The wind has claws. Each lightning bolt forms a different rune for destruction, punishment. It is associated with: \
				upheaval, divine punishment."
			if("Whisper Breeze")
				P.desc = "A soft breeze curls around a sleeping child’s ear, one candle stands nearby. It is associated with: secrets, subtle shifts."
			if("Stormcry")
				P.desc = "Rain and wind mix with wailing spirit-faces. A lone figure kneels on a clifftop, arms raised in anguish. Tears fall upward, the wind feels heavy. It is associated with: rage, grief, release."
		P.card_icon = "winds"
		P.back_icon = "card_back_lyodii"
		cards += P

/obj/item/deck/tarot/lyodii/bones
	name = "lyodii fatesayer bones deck"
	desc = "A traditionally made deck of fatesayer cards, used by the people of the Lyod. This stack contains the Bones cards. "
	icon_state = "lyodii_deck"
	item_state = "lyodii_deck"

/obj/item/deck/tarot/lyodii/bones/generate_deck()
	var/datum/playingcard/P
	for(var/name in list("Bone of Birth","Bone of Death","Bone of Choice","Goddess"))
		P = new()
		P.name = "[name]"
		P.card_icon = "bones"
		P.back_icon = "card_back_lyodii"
		switch(name)
			if("Bone of Birth")
				P.desc = "A curved rib bone floats in a pool of water, illuminated from below. Inside it, a tiny sprout grows. In the water’s reflection, the bone looks like a cradle. It is associated with: legacy, fate beginning to move."
			if("Bone of Death")
				P.desc = "A skull, half-buried in snow, with a single red flower growing from one eye socket. A spirit form rises behind the skull, birds fly overhead. It is associated with: inevitable ends, sacred cycles."
			if("Bone of Choice")
				P.desc = "A forked femur lies between two paths—one lined with fire, the other shadowy. A hand hesitates above it. The bone is marked with tally marks and blood-stained glyphs. It is associated with: the moment of truth, \
				taking action."
			if("Goddess")
				P.desc = "A glowing, diffuse spectral form floats above a ritual circle of bones. Light spills from the heavens onto it. Snowflakes falling nearby take on different shapes of animals, eyes and hands. It is associated with: \
				divine will, judgement, revelation."
				P.card_icon = "goddess"
		cards += P

/obj/item/storage/box/lyodii
	name = "fatesayer box"
	desc = "A small leather case to to hold all 36 cards of a Fatesayer deck."
	icon_state = "card_holder_empty"
	icon = 'icons/obj/storage/misc.dmi'
	can_hold = list(/obj/item/deck/tarot/lyodii, /obj/item/hand, /obj/item/card)
	storage_slots = 5 //Needs to hold all five Fatesayer cards. Can't hold BM cards, though.
	use_sound = 'sound/items/drop/shoes.ogg'
	drop_sound = 'sound/items/drop/hat.ogg'

/obj/item/storage/box/lyodii/fill()
	..()
	new /obj/item/deck/tarot/lyodii/spirits(src)
	new /obj/item/deck/tarot/lyodii/paths(src)
	new /obj/item/deck/tarot/lyodii/beasts(src)
	new /obj/item/deck/tarot/lyodii/winds(src)
	new /obj/item/deck/tarot/lyodii/bones(src)

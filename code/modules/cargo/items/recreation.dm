/singleton/cargo_item/crayonbox
	category = "recreation"
	name = "box of crayons"
	supplier = "getmore"
	description = "Nontoxic crayons! For drawing, writing, painting. Warranty void if consumed."
	price = 30
	items = list(
		/obj/item/storage/box/fancy/crayons
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/painting_kit
	category = "recreation"
	name = "painting kit"
	supplier = "virgo"
	description = "A painter's kit containing an easel, a small canvas, and some paints. Additional canvases sold separately."
	price = 350
	items = list(
		/obj/structure/easel,
		/obj/item/canvas,
		/obj/item/storage/box/fancy/crayons,
		/obj/item/reagent_containers/glass/rag,
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/canvas_small
	category = "recreation"
	name = "small canvas"
	supplier = "virgo"
	description = "A painting canvas. Does not include the tools required to use it."
	price = 50
	items = list(
		/obj/item/canvas
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/canvas_medium
	category = "recreation"
	name = "medium canvas"
	supplier = "virgo"
	description = "A painting canvas. Does not include the tools required to use it."
	price = 80
	items = list(
		/obj/item/canvas/nineteen_nineteen
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/canvas_large
	category = "recreation"
	name = "large canvas"
	supplier = "virgo"
	description = "A painting canvas. Does not include the tools required to use it."
	price = 100
	items = list(
		/obj/item/canvas/twentythree_twentythree
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/trumpet
	category = "recreation"
	name = "trumpet"
	supplier = "virgo"
	description = "A trumpet for those triumphant tooting sessions."
	price = 300
	items = list(
		/obj/item/synthesized_instrument/trumpet
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/guitar
	category = "recreation"
	name = "guitar"
	supplier = "virgo"
	description = "An acoustic guitar for those balcony serenades."
	price = 190
	items = list(
		/obj/item/synthesized_instrument/guitar
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/violin
	category = "recreation"
	name = "violin"
	supplier = "virgo"
	description = "A wooden musical instrument with four strings and a bow."
	price = 250
	items = list(
		/obj/item/synthesized_instrument/violin
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/polyguitar
	category = "recreation"
	name = "polyguitar"
	supplier = "virgo"
	description = "An electric polyguitar. 100% digital audio."
	price = 250
	items = list(
		/obj/item/synthesized_instrument/guitar/multi
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/piano
	category = "recreation"
	name = "piano"
	supplier = "virgo"
	description = "Like a regular piano, but always in tune! Even if the musician isn't."
	price = 1200
	items = list(
		/obj/structure/synthesized_instrument/synthesizer/piano
	)
	container_type = "box"
	groupable = FALSE
	spawn_amount = 1

/singleton/cargo_item/pianosoundsynthesizer
	category = "recreation"
	name = "synthesizer 3.0"
	supplier = "virgo"
	description = "An expensive sound synthesizer. Great for those orchestra-of-one performances."
	price = 1900
	items = list(
		/obj/structure/synthesized_instrument/synthesizer
	)
	container_type = "box"
	groupable = FALSE
	spawn_amount = 1

/singleton/cargo_item/jukebox
	category = "recreation"
	name = "juke box"
	supplier = "nanotrasen"
	description = "A common sight in any modern space bar, this jukebox has all the space classics."
	price = 500
	items = list(
		/obj/structure/machinery/media/jukebox
	)
	container_type = "box"
	groupable = FALSE
	spawn_amount = 1

/singleton/cargo_item/adhomian_phonograph
	category = "recreation"
	name = "adhomian phonograph"
	supplier = "zharkov"
	description = "An Adhomian record player."
	price = 700
	items = list(
		/obj/structure/machinery/media/jukebox/phonograph
	)
	container_type = "box"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/waterballoons
	category = "recreation"
	name = "water balloons (x10)"
	supplier = "nanotrasen"
	description = "Ten empty water balloons for water balloon fights."
	price = 3.25
	items = list(
		/obj/item/toy/waterballoon
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 10

/singleton/cargo_item/balloons
	category = "recreation"
	name = "balloons (x10)"
	supplier = "nanotrasen"
	description = "Ten empty regular balloons. Can be filled using a tank of air or other gas. Warranty void if filled with hydrogen."
	price = 2.50
	items = list(
		/obj/item/toy/balloon
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 10

/singleton/cargo_item/toysword
	category = "recreation"
	name = "toy sword"
	supplier = "nanotrasen"
	description = "A cheap, plastic replica of a blue energy sword. Realistic sounds and colors! Ages 8 and up."
	price = 12
	items = list(
		/obj/item/toy/sword
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/replicakatana
	category = "recreation"
	name = "replica katana"
	supplier = "nanotrasen"
	description = "A cheap plastic katana. Useful for pretending you're a samurai or for tabletop roleplaying sessions."
	price = 16
	items = list(
		/obj/item/toy/katana
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/foamdart
	category = "recreation"
	name = "foam darts (x5)"
	supplier = "nanotrasen"
	description = "It's some foam darts, for use in foam weaponry. Ages 8 and up."
	price = 3.50
	items = list(
		/obj/item/toy/ammo/crossbow
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 5

/singleton/cargo_item/foamdartcrossbow
	category = "recreation"
	name = "foam dart crossbow"
	supplier = "nanotrasen"
	description = "A weapon favored by many overactive children. Ages 8 and up."
	price = 20
	items = list(
		/obj/item/toy/crossbow
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/gravitationalsingularitytoy
	category = "recreation"
	name = "gravitational singularity toy"
	supplier = "getmore"
	description = "'Singulo' brand spinning toy. Certified mesmerizing since 2440."
	price = 8
	items = list(
		/obj/item/toy/spinningtoy
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/randomplushies
	category = "recreation"
	name = "random plushies (x4)"
	supplier = "nanotrasen"
	description = "Four random surplus plushies from a local toy store's clearance sale. People grow old, apparently."
	price = 45
	items = list(
		/obj/random/plushie
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 4

/singleton/cargo_item/therapydoll
	category = "recreation"
	name = "therapy doll"
	supplier = "virgo"
	description = "A toy for therapeutic and recreational purposes."
	price = 22
	items = list(
		/obj/item/toy/plushie/therapy
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/snappop
	category = "recreation"
	name = "snap pop (x5)"
	supplier = "nanotrasen"
	description = "A number of snap pops."
	price = 12
	items = list(
		/obj/item/toy/snappop
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 5

/singleton/cargo_item/redlasertagequipmentset
	category = "recreation"
	name = "red laser tag equipment set"
	supplier = "nanotrasen"
	description = "A two-player set of red-team laser tag equipment consisting of a helmet, armor, and a gun."
	price = 150
	items = list(
		/obj/item/clothing/head/helmet/riot/laser_tag,
		/obj/item/clothing/suit/armor/riot/laser_tag,
		/obj/item/gun/energy/lasertag/red
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 2

/singleton/cargo_item/bluelasertagequipmentset
	category = "recreation"
	name = "blue laser tag equipment set"
	supplier = "nanotrasen"
	description = "A two-player set of blue-team laser blue equipment consisting of a helmet, armor, and a gun."
	price = 150
	items = list(
		/obj/item/clothing/head/helmet/riot/laser_tag/blue,
		/obj/item/clothing/suit/armor/riot/laser_tag/blue,
		/obj/item/gun/energy/lasertag/blue
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 2

/singleton/cargo_item/lyodiicards
	category = "recreation"
	name = "lyodii fatesayer cards"
	supplier = "orion"
	description = "A lyodii Fatesayer card deck. Exported from Moroz, used to tell your fate."
	price = 120 //It's a niche novelty thing made in relatively small export quantities
	items = list(
		/obj/item/storage/box/lyodii
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/game_helm
	category = "recreation"
	name = "InUs Game-Helm"
	supplier = "orion"
	description = "A popular portable gaming console with thousands of games available for play."
	price = 150
	items = list(
		/obj/item/gamehelm
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/whiteboard
	category = "recreation"
	name = "whiteboard"
	supplier = "orion"
	description = "A standard whiteboard."
	price = 100
	items = list(
		/obj/structure/whiteboard
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/whiteboard_portable
	category = "recreation"
	name = "portable whiteboard"
	supplier = "orion"
	description = "A portable whiteboard, smaller than the standard alternatives."
	price = 75
	items = list(
		/obj/item/portable_whiteboard
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/playingcards
	category = "recreation"
	name = "deck of cards"
	supplier = "getmore"
	description = "A simple deck of playing cards."
	price = 3
	items = list(
		/obj/item/deck/cards
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/tarotdeck
	category = "recreation"
	name = "deck of tarot cards"
	supplier = "getmore"
	description = "A deck of tarot cards, for fortune-telling or parlor games."
	price = 10
	items = list(
		/obj/item/deck/tarot
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/kotahideck
	category = "recreation"
	name = "KOTAHI deck"
	supplier = "getmore"
	description = "A deck of KOTAHI cards. House rules to argue over not included."
	price = 6
	items = list(
		/obj/item/deck/kotahi
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/dicepack
	category = "recreation"
	name = "pack of dice"
	supplier = "getmore"
	description = "A small pack containing a dozen six-sided dice and four twenty-sided dice."
	price = 8
	items = list(
		/obj/item/storage/pill_bottle/dice
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/gamingdicepack
	category = "recreation"
	name = "pack of gaming dice"
	supplier = "getmore"
	description = "A small pack containing a set of polyhedral dice for tabletop games."
	price = 12
	items = list(
		/obj/item/storage/pill_bottle/dice/gaming
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/chessset
	category = "recreation"
	name = "chess set"
	supplier = "getmore"
	description = "A simple chess set with magnetic pieces."
	price = 25
	items = list(
		/obj/item/chessboard
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/chalkbox
	category = "recreation"
	name = "box of drafting chalk"
	supplier = "getmore"
	description = "A box of chalk, for drafting floor plans or drawing on floors."
	price = 22
	items = list(
		/obj/item/storage/box/fancy/crayons/chalkbox
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

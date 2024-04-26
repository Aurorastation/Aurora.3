/obj/item/reagent_containers/food/snacks/tajaran_bread
	name = "adhomian bread"
	desc = "A traditional tajaran bread, usually baked with blizzard ears' flour."
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "tajaran_bread"
	bitesize = 2
	reagents_to_add = list(/singleton/reagent/nutriment = 5)
	reagent_data = list(/singleton/reagent/nutriment = list("bread" = 2))
	desc_extended = "While the People's republic territory includes several different regional cultures, it is possible to find common culinary traditions among its population. \
	Bread, baked with flour produced from a variation of the Blizzard Ears, is considered an essential part of a worker's breakfast."
	filling_color = "#BD8939"

/obj/item/reagent_containers/food/snacks/hardbread
	name = "adhomian hard bread"
	desc = "A long-lasting tajaran bread. It is usually prepared for long journeys, hard winters or military campaigns."
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "loaf"
	bitesize = 1
	reagents_to_add = list(/singleton/reagent/nutriment = 15)
	reagent_data = list(/singleton/reagent/nutriment = list("crusty bread" = 2))
	slice_path = /obj/item/reagent_containers/food/snacks/hardbread_slice
	slices_num = 6
	throw_range = 5
	throwforce = 10
	w_class = ITEMSIZE_NORMAL
	filling_color = "#BD8939"
	desc_extended = "The adhomian hard bread is type of tajaran bread, made from Blizzard Ears's flour, water and spice, usually basked in the shape of a loaf. \
	It is known for its hard crust, bland taste and for being long lasting. The hard bread was usually prepared for long journeys, hard winters or military campaigns, \
	due to its shelf life. Certain folk stories and jokes claim that such food could also be used as an artillery ammunition or thrown at besieging armies during sieges."

/obj/item/reagent_containers/food/snacks/hardbread_slice
	name = "adhomian hard bread slice"
	desc = "A long-lasting Tajaran bread slice. It is usually prepared for long journeys, hard winters, or military campaigns."
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "hardbread_slice"
	filling_color = "#BD8939"
	bitesize = 2
	throwforce = 2

/obj/item/reagent_containers/food/snacks/stew/tajaran
	name = "adhomian stew"
	desc = "An adhomian stew, made with nav'twir meat and native plants."
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "tajaran_stew"
	bitesize = 2
	reagents_to_add = list(/singleton/reagent/nutriment = 4, /singleton/reagent/nutriment/protein = 4, /singleton/reagent/water = 4)
	reagent_data = list(/singleton/reagent/nutriment = list("sweetness" = 2))
	desc_extended = "Traditional adhomian stews are made with diced vegetables, such as Nif-Berries, and meat, Snow Strider is commonly used by the rural population, while \
	industrialized Fatshouters's beef is prefered by the city's inhabitants."
	filling_color = "#BD8939"

/obj/item/reagent_containers/food/snacks/soup/earthenroot
	name = "earthen-root soup"
	desc = "A soup made with earthen-root, a traditional dish from Northern Harr'masir."
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "tajaran_soup"
	bitesize = 2
	reagents_to_add = list(/singleton/reagent/nutriment = 4)
	desc_extended = "The Earth-Root soup is a common sight on the tables, of all social sectors, in the Northern Harr'masir. Prepared traditionally with water, Earth-Root and \
	other plants, such as the Nif-Berries."
	filling_color = "#BD8939"

/obj/item/reagent_containers/food/snacks/adhomian_sausage
	name = "fatshouters bloodpudding"
	desc = "A mixture of fatshouters meat, offal, blood and blizzard ears flour."
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "adhomian_sausage"
	filling_color = "#DB0000"
	bitesize = 2
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 12)

/obj/item/reagent_containers/food/snacks/nomadskewer
	name = "nomad skewer"
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "nomad_skewer"
	desc = "Fatshouter meat on a stick, served with flora native to Adhomai."
	trash = /obj/item/stack/rods
	filling_color = "#FFFEE0"
	center_of_mass = list("x"=17, "y"=15)
	bitesize = 2
	reagent_data = list(/singleton/reagent/nutriment = list("oily berries" = 8))
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 4, /singleton/reagent/nutriment = 8, /singleton/reagent/nutriment/triglyceride/oil = 3, /singleton/reagent/sugar = 3, /singleton/reagent/drink/earthenrootjuice = 6)

/obj/item/reagent_containers/food/snacks/fermented_worm
	name = "fermented hma'trra"
	desc = "A larged piece of fermented glacier worm meat."
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "fermented_worm"
	filling_color = "#DB0000"
	bitesize = 4
	reagents_to_add = list(/singleton/reagent/nutriment/protein/seafood = 20, /singleton/reagent/ammonia = 10)

/obj/item/reagent_containers/food/snacks/fermented_worm_sandwich
	name = "fermented hma'trra sandwich"
	desc = "A Tajaran delicacy that stinks as bad as it looks. Some claim the meat is an acquired taste and swear by its flavour."
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "hardbread_fermented"
	reagents_to_add = list(/singleton/reagent/nutriment = 10, /singleton/reagent/nutriment/protein/seafood = 15, /singleton/reagent/ammonia = 10)
	reagent_data = list(/singleton/reagent/nutriment = list("crusty bread" = 2), /singleton/reagent/nutriment/protein/seafood = list("salty, tangy fish" = 3))
	bitesize = 3

/obj/item/reagent_containers/food/snacks/earthenroot_mash
	name = "mashed earthen-root"
	desc = "Mounds of mashed earthen-root. Soft and pillowy."
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "earthenroot_mash"
	trash = /obj/item/trash/plate
	filling_color = "#3884a7"
	reagents_to_add = list(/singleton/reagent/nutriment = 4)
	reagent_data = list(/singleton/reagent/nutriment = list("mashed earthenroot" = 4))
	bitesize = 1

/obj/item/reagent_containers/food/snacks/earthenroot_chopped
	name = "chopped earthen-root"
	desc = "Chopped earthen-root. Cooking this would make it nicer."
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "earthenroot_chopped"
	trash = /obj/item/trash/plate
	filling_color = "#5498b8"
	reagents_to_add = list(/singleton/reagent/nutriment = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("sweet, chunky earthenroot" = 3))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/earthenroot_fries
	name = "earthen-root fries"
	desc = "A plate full of fresh earthen-root fries. A crispy sweet Adhomian treat."
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "earthenroot_fries"
	trash = /obj/item/trash/plate
	filling_color = "#3884a7"
	reagents_to_add = list(/singleton/reagent/nutriment = 4, /singleton/reagent/nutriment/triglyceride/oil = 1.2)
	reagent_data = list(/singleton/reagent/nutriment = list("crispy sweet earthen-root fries" = 4))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/earthenroot_wedges
	name = "fried earthen-root wedges"
	desc = "Some fried wedges made from earthen-root. Chunkier than fries, but still crispy."
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "earthenroot_wedges"
	trash = /obj/item/trash/plate
	filling_color = "#3884a7"
	reagents_to_add = list(/singleton/reagent/nutriment = 4, /singleton/reagent/nutriment/triglyceride/oil = 1.2)
	reagent_data = list(/singleton/reagent/nutriment = list("crispy sweet earthen-root wedges" = 4))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/salad/earthenroot
	name = "earthen-root salad"
	desc = "A Tajaran salad containing earthen-root, sarmikhir, herbs and cream. A great option for the more healthy-minded."
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "earthenroot_salad"
	trash = /obj/item/trash/snack_bowl
	reagents_to_add = list(/singleton/reagent/nutriment = 10)
	reagent_data = list(/singleton/reagent/nutriment = list("sweet chunky earthen-root" = 2, "sour cream" = 2, "oily berries" = 2, "sweet herbs" = 2))
	bitesize = 3

/obj/item/reagent_containers/food/snacks/sarmikhir_sandwich
	name = "sarmikhir sandwich"
	desc = "A Tajaran sandwich with hard bread and sour cream. A staple of the Hadiist breakfast menu."
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "hardbread_sourcream"
	reagents_to_add = list(/singleton/reagent/nutriment = 12)
	reagent_data = list(/singleton/reagent/nutriment = list("crusty bread" = 2, "sour cream" = 2))

/obj/item/reagent_containers/food/snacks/tunneler_meategg
	name = "tunneler meategg"
	desc = "An Adhomian ice tunneler egg cooked with a layer of meat. All the protein that you'll need!"
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "tunneler_scotchegg"
	trash = /obj/item/trash/plate
	reagents_to_add = list(/singleton/reagent/nutriment/protein/egg = 3, /singleton/reagent/nutriment/protein = 7, /singleton/reagent/nutriment = 5)
	reagent_data = list(/singleton/reagent/nutriment/protein = list("savoury meat" = 3), /singleton/reagent/nutriment = list("meaty bread" = 1))

/obj/item/reagent_containers/food/snacks/tunneler_souffle
	name = "tunneler souffle"
	desc = "A souffle made from an Adhomian ice tunneler egg and traditional sour cream."
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "tunneler_souffle"
	reagents_to_add = list(/singleton/reagent/nutriment/protein/egg = 3, /singleton/reagent/nutriment = 5, /singleton/reagent/drink/milk/cream = 5)
	reagent_data = list(/singleton/reagent/nutriment = list("baked dough" = 2))

/obj/item/reagent_containers/food/snacks/adhomian_porridge
	name = "adhomian porridge"
	desc = "A truly basic adhomian peasant food that is very similar to oatmeal."
	icon = 'icons/obj/item/reagent_containers/food/soup.dmi'
	icon_state = "oatmeal"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#caaf7c"
	center_of_mass = list("x"=15, "y"=9)
	reagents_to_add = list(/singleton/reagent/nutriment = 8, /singleton/reagent/drink/milk/adhomai = 5)
	reagent_data = list(/singleton/reagent/nutriment = list("oatmeal" = 3))
	bitesize = 2

// Tajaran ingredients
/obj/item/mollusc/clam/rasval
	name = "ras'val clam"
	desc = "An adhomian clam, native to the sea of Ras'val."
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "ras'val_clams"
	meat_type = /obj/item/reagent_containers/food/snacks/clam
	shell_type = /obj/item/trash/mollusc_shell/clam/rasval

/obj/item/trash/mollusc_shell/clam/rasval
	name = "ras'val clam shell"
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "ras'val_clams_shell"

/obj/item/reagent_containers/food/snacks/clam
	name = "Ras'val clam"
	desc = "An adhomian clam, native from the sea of Ras'val."
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "clam"
	bitesize = 2
	desc_extended = "Fishing and shellfish has a part in the diet of the population at the coastal areas, even if the ice can be an obstacle to most experienced fisherman. \
	Spicy Ras'val clams, named after the sea, are a famous treat, being appreciated in other systems besides S'rand'marr."
	reagents_to_add = list(/singleton/reagent/nutriment/protein/seafood = 2)
	filling_color = "#FFE7C2"

/obj/item/reagent_containers/food/snacks/adhomian_can
	name = "canned fatshouters meat"
	desc = "A piece of salted fatshouter's meat stored inside a metal can."
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "canned"
	bitesize = 2
	trash = /obj/item/trash/can/adhomian_can
	desc_extended = "While the People's republic territory includes several different regional cultures, it is possible to find common culinary traditions among its population. \
	Salt-cured Fatshouters's meat also has been introduced widely, facilitated by the recent advances in the livestock husbandry techniques."
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 5, /singleton/reagent/sodiumchloride = 2)
	filling_color = "#D63C3C"

/obj/item/reagent_containers/food/snacks/hmatrrameat
	name = "Hma'trra fillet"
	desc = "A fillet of glacier worm meat."
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "fishfillet"
	filling_color = "#FFDEFE"
	bitesize = 6
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 6)

// Tajaran cakes

/obj/item/reagent_containers/food/snacks/cone_cake
	name = "cone cake"
	desc = "A spongy cone-shaped cake covered in sugar."
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "conecake"
	bitesize = 2
	reagents_to_add = list(/singleton/reagent/nutriment = 15)
	reagent_data = list(/singleton/reagent/nutriment = list("Incredible sweetness" = 8, "Cake" = 7))
	desc_extended = "A spongy, sugar-coated cake that's baked on a spit shaped like a cone, giving it a signature look. Often sold alongside Azvah due to similar preparation methods, the difference between them being the unique shape, the crisp, flaky outside, and the tooth-aching sweetness of the dish that turns some foreigners away."
	filling_color = "#BD8939"


/obj/item/reagent_containers/food/snacks/avah
	name = "avah"
	desc = "A large fried dough ball covered in a sweet cream icing."
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "avah"
	bitesize = 2
	reagents_to_add = list(/singleton/reagent/nutriment = 7, /singleton/reagent/nutriment/protein/cheese = 5)
	reagent_data = list(/singleton/reagent/nutriment = list("Oily dough" = 7), /singleton/reagent/nutriment/protein/cheese = list("sweet cream cheese" = 5))
	desc_extended = "Used to only mean 'sweets' or 'sweet thing', now singularly refers to a particular dessert. The batter is grilled and made into soft, spherical shapes, and then covered with fruit jams, sugar, or sweet cream cheese. These treats are often sold at festivals and celebrations, and foreigners compare them to pancakes."
	filling_color = "#BD8939"

/obj/item/reagent_containers/food/snacks/chipplate/miniavah_basket
	name = "mini-avah basket"
	desc = "A basket of mini-avahs, a small variant of a traditional avah filled with meat that are the perfect size for dipping."
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "miniavahs_3"
	vendingobject = /obj/item/reagent_containers/food/snacks/chip/miniavah
	unitname = "mini-avah"
	trash = /obj/item/trash/chipbasket
	bitesize = 6
	reagents_to_add = list(/singleton/reagent/nutriment = 9, /singleton/reagent/nutriment/protein = 9)
	reagent_data = list(/singleton/reagent/nutriment = list("baked dough" = 3), /singleton/reagent/nutriment/protein = list("savoury meat" = 3))

/obj/item/reagent_containers/food/snacks/chipplate/miniavah_basket/update_icon()
	switch(reagents.total_volume)
		if(1 to 6)
			icon_state = "miniavahs_1"
		if(7 to 12)
			icon_state = "miniavahs_2"
		if(18 to INFINITY)
			icon_state = "miniavahs_3"

/obj/item/reagent_containers/food/snacks/chip/miniavah/on_consume(mob/M as mob)
	if(reagents && reagents.total_volume)
		icon_state = bitten_state
	. = ..()

/obj/item/reagent_containers/food/snacks/chip/miniavah
	name = "mini-avah"
	desc = "A miniature avah, a traditional Adhomian treat. This one is filled with meat, and is the perfect size for dipping."
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "avah_full"
	bitten_state = "avah_half"
	bitesize = 3

/obj/item/reagent_containers/food/snacks/chip/miniavah/cheese
	name = "cheese mini-avah"
	desc = "A miniature avah filled with meat. This one has cheese on it."
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "avah_full_queso"
	bitten_state = "avah_half_queso"
	bitesize = 2
	filling_color = "#FFF454"

/obj/item/reagent_containers/food/snacks/chip/miniavah/salsa
	name = "salsa mini-avah"
	desc = "A miniature avah filled with meat. This one has salsa on it."
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "avah_full_salsa"
	bitten_state = "avah_half_salsa"
	bitesize = 2
	filling_color = "#FF4D36"

/obj/item/reagent_containers/food/snacks/chip/miniavah/guac
	name = "guac mini-avah"
	desc = "A miniature avah filled with meat. This one has guac on it."
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "avah_full_guac"
	bitten_state = "avah_half_guac"
	bitesize = 2
	filling_color = "#35961D"

/obj/item/reagent_containers/food/snacks/chip/miniavah/sourcream
	name = "sourcream mini-avah"
	desc = "A miniature avah filled with meat. This one has sour cream on it."
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "avah_full_sourcream"
	bitten_state = "avah_half_sourcream"
	bitesize = 2
	filling_color = "#e4e4e4"

/obj/item/reagent_containers/food/snacks/chip/miniavah/tajhummus
	name = "hummus mini-avah"
	desc = "A miniature avah filled with meat. This one has sweet hummus on it."
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "avah_full_hummus"
	bitten_state = "avah_half_hummus"
	bitesize = 2
	filling_color = "#cca628"

/obj/item/reagent_containers/food/snacks/chip/miniavah/hummus
	name = "hummus mini-avah"
	desc = "A miniature avah filled with meat. This one has hummus on it."
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "avah_full_hummus"
	bitten_state = "avah_half_hummus"
	bitesize = 2
	filling_color = "#cca628"

/obj/item/reagent_containers/food/snacks/hardbread_pudding
	name = "hardbread pudding"
	desc = "Traditional Adhomian hardbread pudding, sliceable into four slices. Topped with delicious sweet cream."
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "hardbread_pudding_whole"
	slice_path = /obj/item/reagent_containers/food/snacks/hardbread_bun
	slices_num = 4
	trash = /obj/item/trash/tray
	reagents_to_add = list(/singleton/reagent/nutriment = 30, /singleton/reagent/drink/milk/cream = 15)
	reagent_data = list(/singleton/reagent/nutriment = list("soft bread" = 3), /singleton/reagent/drink/milk/cream = list("sweet cream" = 3))

/obj/item/reagent_containers/food/snacks/hardbread_bun
	name = "hardbread bun"
	desc = "A bun made out of hardbread pudding. Topped with sweet cream."
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "hardbread_pudding_bun"
	trash = /obj/item/trash/snack_bowl

// Tajaran pies
/obj/item/reagent_containers/food/snacks/fruit_rikazu
	name = "fruit rikazu"
	desc = "A small, crispy Adhomian pie meant for one person filled with fruits."
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "rikazu_fruit"
	bitesize = 2
	reagents_to_add = list(/singleton/reagent/nutriment = 8)
	reagent_data = list(/singleton/reagent/nutriment = list("crispy dough" = 4, "sweet fruit" = 4))
	desc_extended = "Small pies, often hand-sized, usually made by folding dough overstuffing of fruit and cream cheese; commonly served hot. The simple preparation makes it a fast favorite, and the versatility of the ingredients has gained its favor with Tajara of all creeds. Different variations of Rikazu pop up all over Adhomai, some filled with meats, or vegetables, or even imported ingredients, like chocolate filling."
	filling_color = "#BD8939"

/obj/item/reagent_containers/food/snacks/meat_rikazu
	name = "meat rikazu"
	desc = "A small, crispy Adhomian pie meant for one person filled with meat."
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "rikazu_meat"
	bitesize = 2
	reagents_to_add = list(/singleton/reagent/nutriment = 4, /singleton/reagent/nutriment/protein = 4)
	reagent_data = list(/singleton/reagent/nutriment = list("crispy dough" = 4), /singleton/reagent/nutriment/protein = list("savory meat" = 4))
	desc_extended = "Small pies, often hand-sized, usually made by folding dough overstuffing of fruit and cream cheese; commonly served hot. The simple preparation makes it a fast favorite, and the versatility of the ingredients has gained its favor with Tajara of all creeds. Different variations of Rikazu pop up all over Adhomai, some filled with meats, or vegetables, or even imported ingredients, like chocolate filling."
	filling_color = "#BD8939"

/obj/item/reagent_containers/food/snacks/vegetable_rikazu
	name = "vegetable rikazu"
	desc = "A small, crispy Adhomian pie meant for one person filled with vegetables."
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "rikazu_veg"
	bitesize = 2
	reagents_to_add = list(/singleton/reagent/nutriment = 8)
	reagent_data = list(/singleton/reagent/nutriment = list("crispy dough" = 4, "crunchy vegetables" = 4))
	desc_extended = "Small pies, often hand-sized, usually made by folding dough overstuffing of fruit and cream cheese; commonly served hot. The simple preparation makes it a fast favorite, and the versatility of the ingredients has gained its favor with Tajara of all creeds. Different variations of Rikazu pop up all over Adhomai, some filled with meats, or vegetables, or even imported ingredients, like chocolate filling."
	filling_color = "#BD8939"

/obj/item/reagent_containers/food/snacks/chocolate_rikazu
	name = "chocolate rikazu"
	desc = "A small, crispy Adhomian pie meant for one person filled with chocolate."
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "rikazu_choc"
	bitesize = 2
	reagents_to_add = list(/singleton/reagent/nutriment = 8)
	reagent_data = list(/singleton/reagent/nutriment = list("crispy dough" = 4, "smooth chocolate" = 4))
	desc_extended = "Small pies, often hand-sized, usually made by folding dough overstuffing of fruit and cream cheese; commonly served hot. The simple preparation makes it a fast favorite, and the versatility of the ingredients has gained its favor with Tajara of all creeds. Different variations of Rikazu pop up all over Adhomai, some filled with meats, or vegetables, or even imported ingredients, like chocolate filling."
	filling_color = "#BD8939"

/obj/item/reagent_containers/food/snacks/dirt_roast
	name = "roasted dirtberries"
	desc = "A bag of warm roasted dirtberries covered in spice."
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "roast_dirtberries"
	bitesize = 2
	reagents_to_add = list(/singleton/reagent/nutriment = 4, /singleton/reagent/condiment/syrup_caramel = 4)
	reagent_data = list(/singleton/reagent/nutriment = list("warm crunchy nuts" = 2, "cinnamon" = 2), /singleton/reagent/condiment/syrup_caramel = list("caramel" = 5))
	desc_extended = "A traditional snack consisting of oven-roasted dirtberries covered in a mixture of spice and caramel. These crunchy fruits are usually sold at outdoor festivals and events and are enjoyed for their warming effect and pleasant taste."
	filling_color = "#BD8939"

/obj/item/reagent_containers/food/snacks/sliceable/fatshouter_fillet
	name = "fatshouter fillet"
	desc = "A medium rare fillet of Fatshouter meat covered in an earthenroot pate and wrapped in a flaky crust."
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "fatshouterfillet_full"
	bitesize = 2
	slice_path = /obj/item/reagent_containers/food/snacks/fatshouterslice
	slices_num = 5
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 10, /singleton/reagent/nutriment = 10, /singleton/reagent/alcohol/messa_mead = 5)
	reagent_data = list(/singleton/reagent/nutriment/protein = list("juicy meat" = 10), /singleton/reagent/nutriment = list("flaky dough" = 5, "savoury vegetables" = 5))
	desc_extended = "for a time was considered the benchmark by which to rate the abilities of a chef. The production of this exquisite dish is no easy task, the preparation process begins with the aging of a high-grade tenderloin steak acquired from a Fatshouter fed exclusively on dirtberries. The high starch content of the dirtberries ensures that the creature has a high fat percentage and imparts a unique flavour to the meat and traditionally Noble families would keep a raise small herds of Fatshouters specifically for the production of this dish. After 28 days of dry aging, the tenderloin is ready for use. One day prior to serving the dish, a pâté is made by sauteéing thinly sliced pieces of earthenroot soaked in a generous amount of Messa's Mead and then thickened with lard before being ground into a fine paste and left to - chill. On the day that the dish is to be served a flaky pastry dough is made. Next the aged 7 tenderloin is trimmed of accumulated mold and rind and coated in a dryrub after which the chilled pâté is spread across the surface of the meat and it is wrapped in the thinly rolled pastry dough. Next the pastry is washed with a small amount of clarified lard to give the crust a nice shine, after which it is placed into a large oven and cooked at a high heat for around 40 minutes. Though the dish was regarded as a symbol of the blatant excess and overindulgence of the ruling elite, it has since been reintroduced to the public by enterprising chefs seeking to recapture the high-class culinary culture of the past."
	filling_color = "#BD8939"

/obj/item/reagent_containers/food/snacks/fatshouterslice
	name = "fatshouter fillet slice"
	desc = "A medium rare fillet of Fatshouter meat covered in an earthenroot pate and wrapped in a flaky crust."
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "fatshouterfillet_slice"
	filling_color = "#FF7575"
	desc_extended = "for a time was considered the benchmark by which to rate the abilities of a chef. The production of this exquisite dish is no easy task, the preparation process begins with the aging of a high-grade tenderloin steak acquired from a Fatshouter fed exclusively on dirtberries. The high starch content of the dirtberries ensures that the creature has a high fat percentage and imparts a unique flavour to the meat and traditionally Noble families would keep a raise small herds of Fatshouters specifically for the production of this dish. After 28 days of dry aging, the tenderloin is ready for use. One day prior to serving the dish, a pâté is made by sauteéing thinly sliced pieces of earthenroot soaked in a generous amount of Messa's Mead and then thickened with lard before being ground into a fine paste and left to - chill. On the day that the dish is to be served a flaky pastry dough is made. Next the aged 7 tenderloin is trimmed of accumulated mold and rind and coated in a dryrub after which the chilled pâté is spread across the surface of the meat and it is wrapped in the thinly rolled pastry dough. Next the pastry is washed with a small amount of clarified lard to give the crust a nice shine, after which it is placed into a large oven and cooked at a high heat for around 40 minutes. Though the dish was regarded as a symbol of the blatant excess and overindulgence of the ruling elite, it has since been reintroduced to the public by enterprising chefs seeking to recapture the high-class culinary culture of the past."
	bitesize = 2

/obj/item/reagent_containers/food/snacks/fatshouterslice/filled
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 2, /singleton/reagent/nutriment = 2, /singleton/reagent/alcohol/messa_mead = 1)
	reagent_data = list(/singleton/reagent/nutriment/protein = list("juicy meat" = 2), /singleton/reagent/nutriment = list("flaky dough" = 1, "savoury vegetables" = 1))

/obj/item/reagent_containers/food/snacks/sliceable/zkahnkowafull
	name = "Zkah'nkowa"
	desc = "A large smoked sausage."
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "zkah'nkowa_full"
	bitesize = 2
	slice_path = /obj/item/reagent_containers/food/snacks/zkahnkowaslice
	slices_num = 5
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 25)
	reagent_data = list(/singleton/reagent/nutriment/protein = list("salty" = 10, "smoky meat" = 15))
	desc_extended = "A canned variety of the Fatshouter Bloodpudding, known for its low-fat content and lighter color. It was created shortly after the First Revolution to ease the food shortage after the conflict. Its low cost and nutritious value allowed it to become a staple of the Hadiist diet."
	filling_color = "#BD8939"

/obj/item/reagent_containers/food/snacks/zkahnkowaslice
	name = "Zkah'nkowa slice"
	desc = "A slice of smoked sausage."
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "zkah'nkowa_slice"
	filling_color = "#FF7575"
	desc_extended = "A canned variety of the Fatshouter Bloodpudding, known for its low-fat content and lighter color. It was created shortly after the First Revolution to ease the food shortage after the conflict. Its low cost and nutritious value allowed it to become a staple of the Hadiist diet."
	bitesize = 2

/obj/item/reagent_containers/food/snacks/zkahnkowaslice/filled
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 5)
	reagent_data = list(/singleton/reagent/nutriment/protein = list("salty" = 3, "smoky meat" = 5))

/obj/item/reagent_containers/food/snacks/creamice
	name = "creamice"
	desc = "A bowl of delicious Tajaran ice cream"
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "creamice"
	bitesize = 2
	reagents_to_add = list(/singleton/reagent/nutriment = 8)
	reagent_data = list(/singleton/reagent/nutriment = list("creamy" = 3, "sweet" = 3, "cold" = 2))
	desc_extended = "The traditional dessert of Northern Harr'masir is considered by many as being the mixture of ice, Fatshouters's milk, sugar, and Nif-Berries' oil, named Creamice. The popular tales claim it was invented after a famine desolated the land, resulting in the population resorting to eating snow, however, such tale has been classified by most historians as nothing but fiction. Creamice is commonly consumed by the nobility since they are the ones that can afford the luxury of refrigeration."
	filling_color = "#BD8939"

/obj/item/reagent_containers/food/snacks/stuffed_earthenroot
	name = "stuffed earthen-root"
	desc = "An earthen-root stuffed with Adhomian meat. Crunchy on the outside, savoury on the inside."
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "earthenroot_stuffed"
	trash = /obj/item/trash/plate
	reagents_to_add = list(/singleton/reagent/nutriment = 8, /singleton/reagent/nutriment/protein = 7)
	reagent_data = list(/singleton/reagent/nutriment = list("sweet earthen-root" = 3), /singleton/reagent/nutriment/protein = list("smoky, salty meat"))
	bitesize = 3

/obj/item/reagent_containers/food/snacks/lardwich
	name = "hro'zamal lard sandwhich"
	desc = "A lard sandwhich prepared in the style of Hro'zamal, usually made from Schlorrgo lard."
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "lardwich"
	reagent_data = list(/singleton/reagent/nutriment = list("bread" = 2))
	reagents_to_add = list(/singleton/reagent/nutriment = 6, /singleton/reagent/nutriment/triglyceride = 5)
	bitesize = 2
	filling_color = "#BD8939"

/obj/item/reagent_containers/food/snacks/explorer_ration
	name = "m'sai scout ration"
	desc = "A mixture of meat, fat and adhomian berries commonly prepared by m'sai explorers and soldiers."
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "scoutration_wrap"
	reagent_data = list(/singleton/reagent/nutriment = list("berries" = 1))
	reagents_to_add = list(/singleton/reagent/nutriment = 4, /singleton/reagent/nutriment/protein = 6 , /singleton/reagent/nutriment/triglyceride = 5)
	bitesize = 1
	var/wrap = TRUE
	filling_color = "#BD8939"

/obj/item/reagent_containers/food/snacks/explorer_ration/update_icon()
	if(wrap)
		icon_state = "scoutration_wrap"
	else
		icon_state = "scoutration_open"

/obj/item/reagent_containers/food/snacks/explorer_ration/attack_self(mob/user)
	src.wrap = !src.wrap
	to_chat(usr, "You [src.wrap ? "wrap" : "unwrap"] \the [src].")
	update_icon()
	return

/obj/item/reagent_containers/food/snacks/explorer_ration/standard_feed_mob(var/mob/user, var/mob/target)
	if(wrap)
		to_chat(user, SPAN_NOTICE("You must unwrap \the [src] first."))
		return
	..()

// Tajaran Seafood

/obj/item/reagent_containers/food/snacks/spicy_clams
	name = "spicy Ras'val clams"
	desc = "A famous adhomian clam dish, named after the Ras'val sea."
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "spicy_clams"
	bitesize = 2
	trash = /obj/item/trash/snack_bowl
	desc_extended = "Fishing and shellfish has a part in the diet of the population at the coastal areas, even if the ice can be an obstacle to most experienced fisherman. \
	Spicy Ras'val clams, named after the sea, are a famous treat, being appreciated in other system besides S'rand'marr."
	reagents_to_add = list(/singleton/reagent/nutriment/protein/seafood = 4, /singleton/reagent/capsaicin = 1)
	filling_color = "#FFE7C2"

/obj/item/reagent_containers/food/snacks/clam_pasta
	name = "ras'val pasta"
	desc = "A Tajaran pasta made from earthen-root, boiled with Ras'val clams. For the seafood lovers that can't handle spice."
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "earthenroot_clambake"
	trash = /obj/item/trash/plate
	reagents_to_add = list(/singleton/reagent/nutriment = 6, /singleton/reagent/nutriment/protein/seafood = 6)
	reagent_data = list(/singleton/reagent/nutriment = list("sweet and salty earthen-root" = 3), /singleton/reagent/nutriment/protein/seafood = list("salty clam meat"))
	bitesize = 3

/obj/item/reagent_containers/food/snacks/soup/tajfish
	name = "adhomian fish soup"
	desc = "A creamy Adhomian fish soup, garnished with sweet herbs."
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "adhomian_fish_soup"
	trash = /obj/item/trash/snack_bowl
	reagents_to_add = list(/singleton/reagent/nutriment/protein/seafood = 6, /singleton/reagent/drink/milk/cream = 4, /singleton/reagent/water = 4)
	reagent_data = list(/singleton/reagent/nutriment/protein/seafood = list("creamy, sweet fish" = 3))

// Tajaran candy
/obj/item/reagent_containers/food/snacks/chipplate/tajcandy
	name = "plate of sugar tree candy"
	desc = "A plate full of adhomian candy made from sugar tree, a plant native to Adhomai."
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "cubes26"
	trash = /obj/item/trash/candybowl
	vendingobject = /obj/item/reagent_containers/food/snacks/tajcandy
	reagent_data = list(/singleton/reagent/nutriment = list("candy" = 1))
	bitesize = 1
	reagents_to_add = list(/singleton/reagent/nutriment = 26)
	unitname = "candy"
	filling_color = "#FCA03D"

/obj/item/reagent_containers/food/snacks/chipplate/tajcandy/update_icon()
	switch(reagents.total_volume)
		if(1)
			icon_state = "cubes1"
		if(2 to 5)
			icon_state = "cubes5"
		if(6 to 10)
			icon_state = "cubes10"
		if(11 to 15)
			icon_state = "cubes15"
		if(16 to 20)
			icon_state = "cubes20"
		if(21 to 25)
			icon_state = "cubes25"
		if(26 to INFINITY)
			icon_state = "cubes26"

/obj/item/reagent_containers/food/snacks/tajcandy
	name = "sugar tree candy"
	desc = "An adhomian candy made from the sugar tree fruit."
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "tajcandy"
	reagents_to_add = list(/singleton/reagent/nutriment = 1, /singleton/reagent/sugar = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("candy" = 3))
	bitesize = 1
	filling_color = "#FCA03D"

// Tajaran Dips
/obj/item/reagent_containers/food/snacks/dip/sarmikhir
	name = "sarmikhir"
	desc = "A traditional Tajaran cream made of fermented Fatshouter milk. Traditionally used with bread or as condiment."
	nachotrans = /obj/item/reagent_containers/food/snacks/chip/nacho/sourcream
	avahtrans = /obj/item/reagent_containers/food/snacks/chip/miniavah/sourcream
	chiptrans = /obj/item/reagent_containers/food/snacks/chip/sourcream
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "dip_sourcream"
	reagents_to_add = list(/singleton/reagent/nutriment = 20)
	reagent_data = list(/singleton/reagent/nutriment = list("sour cream" = 20))
	filling_color = "#e4e4e4"

/obj/item/reagent_containers/food/snacks/dip/tajhummus
	name = "hrikhir"
	desc = "A savoury Tajaran dip, typically paired with avahs."
	nachotrans = /obj/item/reagent_containers/food/snacks/chip/nacho/tajhummus
	avahtrans = /obj/item/reagent_containers/food/snacks/chip/miniavah/tajhummus
	chiptrans = /obj/item/reagent_containers/food/snacks/chip/tajhummus
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "dip_hummus"
	reagents_to_add = list(/singleton/reagent/nutriment = 20)
	reagent_data = list(/singleton/reagent/nutriment = list("sweet hummus" = 20))
	filling_color = "#cca628"

// Tajaran gelatin-based food A.K.A The Meal memes

/obj/item/reagent_containers/food/snacks/seafoodmousse
	name = "seafood mousse"
	desc = "A culinary classic on Adhomai that relies on gelatin to hold its shape. It even has a smile traced on it! Aw.."
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "fish_mousse"
	reagents_to_add = list(/singleton/reagent/nutriment = 4, /singleton/reagent/nutriment/protein/seafood = 6)
	reagent_data = list(/singleton/reagent/nutriment = list("sour cream" = 2), /singleton/reagent/nutriment/protein/seafood = list("jiggly seafood" = 3))
	filling_color = "#FF7F7F"
	trash = /obj/item/trash/snacktray
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/vegello
	name = "garden vegetable gelatin salad"
	desc = "Shredded Messa's Tears, chopped earthenroot, and dirtberries make up the many layers of this salad, with the whole thing set in savory gelatin."
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "vegello_salad"
	slice_path = /obj/item/reagent_containers/food/snacks/vegello_slice
	slices_num = 6
	filling_color = "#B7BA8F"
	reagent_data = list(/singleton/reagent/nutriment = list("jiggly vegetables" = 10, "bouncy gelatin" = 10))
	bitesize = 3

/obj/item/reagent_containers/food/snacks/vegello_slice
	name = "garden vegetable gelatin salad slice"
	desc = "A slice of jiggly, bouncy veggie-laden gelatin. Scrumptious!"
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "vegello_salad_slice"
	trash = /obj/item/trash/plate
	filling_color = "#B7BA8F0"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/fruitgello
	name = "gelatin dessert"
	desc = "Sweet, fruity gelatin with a decadent cream topping, sprinkled with dirtberries."
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "fruitgello_dessert"
	reagents_to_add = list(/singleton/reagent/nutriment = 4, /singleton/reagent/drink/milk/cream = 4)
	reagent_data = list(/singleton/reagent/nutriment = list("jiggly fruit" = 4), /singleton/reagent/drink/milk/cream = list("whipped cream" = 3))
	filling_color = "#F3C5CF"
	trash = /obj/item/trash/plate
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/aspicfatshouter
	name = "fatshouter in aspic"
	desc = "A large solid chunk of Adhomian meat, with hard-boiled tunneler eggs interspersed, contained within a savory aspic package and topped with sarmikhir. Great at parties!"
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "meatjello_cube"
	slice_path = /obj/item/reagent_containers/food/snacks/aspicfatshouter_slice
	slices_num = 5
	filling_color = "#967951"
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 15, /singleton/reagent/nutriment = 10, /singleton/reagent/nutriment/protein/egg = 5)
	reagent_data = list(/singleton/reagent/nutriment = list("sour cream" = 5, "bouncy gelatin" = 5), /singleton/reagent/nutriment/protein = list("jiggly meat" = 15), /singleton/reagent/nutriment/protein/egg = list("hard-boiled eggs" = 3))
	bitesize = 3

/obj/item/reagent_containers/food/snacks/aspicfatshouter_slice
	name = "slice of fatshouter in aspic"
	desc = "The amount of meat contained in this chunk of wobbly aspic is intimidating."
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "meatjello_cube_slice"
	trash = /obj/item/trash/plate
	filling_color = "#967951"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/fatshouterbake
	name = "fatshouter bake"
	desc = "Made popular during the war, due to the rationing restrictions, the fatshouter bake is merely a canned cube of fatshouter meat roasted with sugar tree candy stuffed inside."
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "fatshouter_bake"
	slice_path = /obj/item/reagent_containers/food/snacks/fatshouterbake_slice
	slices_num = 4
	trash = /obj/item/trash/grease
	filling_color = "#94372A"
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 16, /singleton/reagent/nutriment = 8)
	reagent_data = list(/singleton/reagent/nutriment = list("roasted, sweet fruit" = 3), /singleton/reagent/nutriment/protein = list("jiggly meat" = 3))
	bitesize = 3

/obj/item/reagent_containers/food/snacks/fatshouterbake_slice
	name = "slice of fatshouter bake"
	desc = "A slice of slow-cooked canned meat smothered in roasted sugar tree fruit."
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "fatshouter_bake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#94372A"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/chipplate/crownfurter
	name = "crown roast of adhomian frankfurters"
	desc = "A party favorite, several adhomian sausages have been set upright around a center of sarmikhir for ease of dipping. It's finger food!"
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "crownfurter14"
	trash = /obj/item/trash/tray
	vendingobject = /obj/item/reagent_containers/food/snacks/tajfurter
	reagent_data = list(/singleton/reagent/nutriment = list("sour cream" = 2), /singleton/reagent/nutriment/protein = list("roasted sausage"  = 2))
	bitesize = 2
	reagents_to_add = list(/singleton/reagent/nutriment = 14, /singleton/reagent/nutriment/protein = 14)
	unitname = "dipped frankfurter"
	filling_color = "#94372A"

/obj/item/reagent_containers/food/snacks/chipplate/crownfurter/update_icon()
	switch(reagents.total_volume)
		if(1 to 7)
			icon_state = "crownfurter2"
		if(8 to 11)
			icon_state = "crownfurter4"
		if(12 to 15)
			icon_state = "crownfurter6"
		if(16 to 19)
			icon_state = "crownfurter8"
		if(20 to 23)
			icon_state = "crownfurter10"
		if(24 to 27)
			icon_state = "crownfurter12"
		if(28 to INFINITY)
			icon_state = "crownfurter14"

/obj/item/reagent_containers/food/snacks/tajfurter
	name = "dipped frankfurter"
	desc = "Traditional adhomian sausage dipped in sarmikhir. Delicious!."
	icon = 'icons/obj/item/reagent_containers/food/cultural/tajara.dmi'
	icon_state = "franksingle"
	reagents_to_add = list(/singleton/reagent/nutriment = 2, /singleton/reagent/nutriment/protein = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("sour cream" = 2), /singleton/reagent/nutriment/protein = list("roasted sausage" = 2))
	bitesize = 1
	filling_color = "#94372A"

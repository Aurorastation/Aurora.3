/singleton/recipe/humanburger
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/human,
		/obj/item/reagent_containers/food/snacks/bun
	)
	result = /obj/item/reagent_containers/food/snacks/human/burger

/singleton/recipe/mouseburger
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/meat/rat
	)
	result = /obj/item/reagent_containers/food/snacks/burger/mouse

/singleton/recipe/plainburger
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/meat //do not place this recipe before /singleton/recipe/humanburger
	)
	result = /obj/item/reagent_containers/food/snacks/burger

/singleton/recipe/xenoburger
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/xenomeat
	)
	result = /obj/item/reagent_containers/food/snacks/burger/xeno

/singleton/recipe/fishburger
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/fish
	)
	result = /obj/item/reagent_containers/food/snacks/burger/fish

/singleton/recipe/tofuburger
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/tofu
	)
	result = /obj/item/reagent_containers/food/snacks/burger/tofu

/singleton/recipe/slimeburger
	reagents = list(/singleton/reagent/slimejelly = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/bun
	)
	result = /obj/item/reagent_containers/food/snacks/burger/jelly/slime

/singleton/recipe/jellyburger
	reagents = list(/singleton/reagent/nutriment/cherryjelly = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/bun
	)
	result = /obj/item/reagent_containers/food/snacks/burger/jelly/cherry

/singleton/recipe/bigbiteburger
	items = list(
		/obj/item/reagent_containers/food/snacks/burger,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/meat
	)
	reagents = list(/singleton/reagent/nutriment/protein/egg = 3)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/burger/bigbite

/singleton/recipe/superbiteburger
	fruit = list("tomato" = 1)
	reagents = list(/singleton/reagent/sodiumchloride = 5, /singleton/reagent/blackpepper = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/burger/bigbite,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/boiledegg
	)
	result = /obj/item/reagent_containers/food/snacks/burger/superbite

/singleton/recipe/ntmuffin
	appliance = SKILLET
	items = list(
		/obj/item/reagent_containers/food/snacks/plumphelmetbiscuit,
		/obj/item/reagent_containers/food/snacks/sausage,
		/obj/item/reagent_containers/food/snacks/friedegg,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/burger/nt_muffin

/singleton/recipe/bearburger
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/bearmeat
	)
	result = /obj/item/reagent_containers/food/snacks/burger/bear

/singleton/recipe/baconburger
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/bacon,
		/obj/item/reagent_containers/food/snacks/bacon
	)
	result = /obj/item/reagent_containers/food/snacks/burger/bacon

/singleton/recipe/chickenfillet //Also just combinable, like burgers and hot dogs.
	items = list(
		/obj/item/reagent_containers/food/snacks/chickenkatsu,
		/obj/item/reagent_containers/food/snacks/bun
	)
	result = /obj/item/reagent_containers/food/snacks/chickenfillet

/singleton/recipe/chickenparm
	appliance = SKILLET
	fruit = list("tomato" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/chicken,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/bun,
	)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/chickenparm

/singleton/recipe/sloppyjoe
	appliance = SKILLET
	items = list(
		/obj/item/reagent_containers/food/snacks/bun
	)
	reagents = list(/singleton/reagent/nutriment/protein = 6 , /singleton/reagent/nutriment/barbecue = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/sloppyjoe

/singleton/recipe/nakarka_hamburger
	appliance = SKILLET
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/cutlet,
		/obj/item/reagent_containers/food/snacks/nakarka_wedge
	)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/burger/nakarka_hamburger

/singleton/recipe/nakarka_hamburger_alt
	appliance = SKILLET
	items = list(
		/obj/item/reagent_containers/food/snacks/burger,
		/obj/item/reagent_containers/food/snacks/nakarka_wedge
	)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/burger/nakarka_hamburger

/singleton/recipe/mossburger
	appliance = SKILLET
	fruit = list("moss" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/cutlet,
	)
	result = /obj/item/reagent_containers/food/snacks/burger/moss

/singleton/recipe/mossburger_sad
	fruit = list("moss" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/burger
	)
	result = /obj/item/reagent_containers/food/snacks/burger/moss/sad

/singleton/recipe/bigbite_mossburger
	appliance = SKILLET
	fruit = list("moss" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/burger/moss,
		/obj/item/reagent_containers/food/snacks/cutlet,
		/obj/item/reagent_containers/food/snacks/cutlet,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
	)
	reagents = list(/singleton/reagent/nutriment/protein/egg = 3)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/burger/bigbite/moss

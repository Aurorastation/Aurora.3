/obj/item/reagent_containers/food/snacks/cookie/gingerbread
	name = "Gingerbread Man"
	desc = "Run run run, as fast as you can.. You can't catch me.. I'm the Gingerbread man!"
	icon = 'icons/holidays/christmas/christmascookies.dmi'
	icon_state = "gingerbread_man"

/obj/item/reagent_containers/food/snacks/cookie/gingerbread/cane
	name = "Gingerbread Cane"
	desc = "For when Gingy' breaks his legs."
	icon = 'icons/holidays/christmas/christmascookies.dmi'
	icon_state = "gingerbread_cane"

/obj/item/reagent_containers/food/snacks/cookie/gingerbread/snowflake
	name = "Gingerbread Snowflake"
	desc = "For when the gingerbreadmans uncle disagrees with him at Christmas dinner."
	icon = 'icons/holidays/christmas/christmascookies.dmi'
	icon_state = "gingerbread_snowflake"

/obj/item/reagent_containers/food/snacks/cookie/gingerbreadtree
	name = "Gingerbread Tree"
	desc = "You stole Gingy's tree? Really? How rude."
	icon = 'icons/holidays/christmas/christmascookies.dmi'
	icon_state = "gingerbread_tree"

/obj/item/reagent_containers/food/snacks/cookie/gingerbread/bell
	name = "Gingerbread Bell"
	desc = "A gingerbread bell that has no relation to the Gingerbread man whatsoever..why is there a crack in it?"
	icon = 'icons/holidays/christmas/christmascookies.dmi'
	icon_state = "gingerbread_bell"

// christmas cookies tray
/obj/item/reagent_containers/food/snacks/chipplate/christmas_cookies
	name = "tray of christmas gingerbread cookies"
	desc = "A tray full of traditional Christmas cookies!"
	icon = 'icons/holidays/christmas/christmascookies.dmi'
	icon_state = "cookietray_100"
	trash = /obj/item/trash/cookietray
	vendingobject = /obj/item/reagent_containers/food/snacks/cookie/gingerbread
	reagent_data = list(/singleton/reagent/nutriment = list("candy" = 1))
	bitesize = 1
	reagents_to_add = list(/singleton/reagent/nutriment = 10)
	unitname = "candy"
	filling_color = "#FCA03D"

/obj/item/reagent_containers/food/snacks/chipplate/christmas_cookies/update_icon()
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

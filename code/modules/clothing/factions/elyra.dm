/obj/item/clothing/under/elyra_holo
	name = "elyran holographic suit"
	desc = "A marvel of Elyran technology, uses hardlight fabric and masks to transform a skin-tight, cozy suit into cultural apparel of your choosing. Has a dial for Midenean, Aemaqii and Perispolisean clothes respectively."
	icon = 'icons/clothing/under/uniforms/elyra_holoclothes.dmi'
	icon_state = "holosuit_fem"
	item_state = "holosuit_fem"
	contained_sprite = TRUE
	action_button_name = "Transform Holoclothing"
	var/cooldown = 0
	var/clothing_mode = 0
	var/list/names = list(
		"base holographic suit",
		"medinean artisans holo-dress",
		"aemaqii ocean holo-dress",
		"perispolisean desert holo-dress"
		)

	var/list/descriptions = list(
		"A form-fitting holographic dress with striking purple and white coloration. It possesses high-fidelity, artistic representation of Elyran Medinean culture markers coating its tightly-woven hardlight fabric.",
		"A fine holo-dress which owes its overall design to the chemical seas of Aemaqq, with itself flowing gently in waves. It looks particularly cozy, and protective against a cold ocean breeze.",
		"A loose, airy holo-dress with clashing earthen and bright colors. The design is iconic among the Elyran Perispolisean native populations due to its expressive contrast and the hot climate."
		)

/obj/item/clothing/under/elyra_holo/masc
	icon_state = "holosuit_masc"
	item_state = "holosuit_masc"
	names = list(
		"base holographic suit",
		"medinean artisans holo-suit",
		"aemaqii fur outfit",
		"perispolisean nomads outfit"
		)
	descriptions = list(
		"A tight-fitting hardlight suit decorated with golden highlights to contrast its red, purplish overshirt and jet black pants. A favorite among the Elyran planet of Medina.",
		"High quality, and colorful fur derived from the colder regions of Aemaqq's chemical seas. Were this outfit real, you'd probably assume the thick, stump and even branch-like fur to be extracted from one of its countless sea leviathans. Even the holographic variant is excellent at trapping heat.",
		"A loose holographic outfit, sturdy, baggy and cool with plentiful pockets. The baggy over-wear is a trend on the Elyran world Perispolis due to its hot climate, and this particular style has spread like wildfire across other warm worlds as well. "
		)

/obj/item/clothing/under/elyra_holo/Initialize()
	for(var/option in names)
		if(!clothing_mode)
			names[option] = image('icons/clothing/under/uniforms/elyra_holoclothes.dmi', icon_state)
			clothing_mode = 1
		else
			names[option] = image('icons/clothing/under/uniforms/elyra_holoclothes.dmi', initial(icon_state) + "_[names.Find(option) - 1]")
	clothing_mode = 0
	.=..()

/obj/item/clothing/under/elyra_holo/attack_self(mob/user)
	select_appearance(user)

/obj/item/clothing/under/elyra_holo/verb/transform_holoclothing()
	set name = "Transform Holoclothing"
	set category = "Object"
	set src in usr
	select_appearance(usr)

/obj/item/clothing/under/elyra_holo/proc/select_appearance(mob/user)
	if(!(cooldown + 7 SECONDS < world.time))
		to_chat(user, SPAN_WARNING("The hardlight fabric needs time to recover before transforming again!"))
		return
	var/appearance_choice = RADIAL_INPUT(user, names)
	if(!appearance_choice)
		return
	clothing_mode = names.Find(appearance_choice) - 1
	cooldown = world.time

	addtimer(CALLBACK(src, .proc/transform_holoclothing_appearance, user), 20)
	set_light(2, 1.5, COLOR_NAVY_BLUE)
	icon_state = initial(icon_state) + "_transition"
	item_state = initial(item_state) + "_transition"
	addtimer(CALLBACK(src, /atom/.proc/set_light, 0), 22)
	update_clothing_icon()

/obj/item/clothing/under/elyra_holo/proc/transform_holoclothing_appearance(mob/user as mob)
	if(!clothing_mode)
		name = initial(name)
		desc = initial(desc)
		icon_state = initial(icon_state)
		item_state = initial(item_state)
	else
		name = names[clothing_mode + 1]
		desc = descriptions[clothing_mode]
		icon_state = initial(icon_state) + "_[clothing_mode]"
		item_state = initial(item_state) + "_[clothing_mode]"

	update_clothing_icon()
	user.update_action_buttons()

/obj/item/clothing/under/elyra_holo/emp_act()
	if(clothing_mode && icon_state != initial(icon_state))
		clothing_mode = 0
		transform_holoclothing_appearance()
		cooldown = world.time + 100 SECONDS
		spark(src, 1, alldirs)

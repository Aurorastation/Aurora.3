/obj/item/clothing/accessory/aodai
	name = "ao dai"
	desc = "A long, split tunic worn over trousers."
	icon = 'icons/clothing/under/uniforms/newhaiphong.dmi'
	icon_state = "aodai"
	item_state = "aodai"
	contained_sprite = TRUE

/obj/item/clothing/accessory/aodai/nhp
	desc = "A split tunic worn over trousers. This one is cropped and sleeveless."
	icon_state = "aodaicrop"
	item_state = "aodaicrop"

/obj/item/clothing/head/nonla
	name = "non la"
	desc = "A conical straw hat enjoyed particularly by residents of New Hai Phong, to protect the head from sweltering suns and heavy rains."
	icon = 'icons/clothing/under/uniforms/newhaiphong.dmi'
	icon_state = "nonla"
	item_state = "nonla"
	contained_sprite = TRUE

/obj/item/clothing/head/nonla/get_mob_overlay(var/mob/living/carbon/human/human, var/mob_icon, var/mob_state, var/slot) //Exists so that the main sprite doesn't cover up hair that should be in front, thanks Geeves
	var/image/I = ..()
	if(slot == slot_head_str)
		var/image/hat_backing = image(mob_icon, null, "nonla_backing", human ? human.layer - 0.01 : MOB_LAYER - 0.01)
		I.add_overlay(hat_backing)
	return I


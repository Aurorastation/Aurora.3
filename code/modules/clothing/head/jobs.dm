//Bartender
/obj/item/clothing/head/chefhat
	name = "chef's hat"
	desc = "It's a hat used by chefs to keep hair out of your food. Judging by the food in the mess, they don't work."
	icon_state = "chefhat"
	item_state = "chefhat"

/obj/item/clothing/head/chefhat/nt
	icon = 'icons/obj/item/clothing/department_uniforms/service.dmi'
	contained_sprite = TRUE
	icon_state = "nt_chef_hat"
	item_state = "nt_chef_hat"

/obj/item/clothing/head/chefhat/idris
	icon = 'icons/obj/item/clothing/department_uniforms/service.dmi'
	contained_sprite = TRUE
	icon_state = "idris_chef_hat"
	item_state = "idris_chef_hat"


/obj/item/clothing/head/hairnet
	name = "hairnet"
	desc = "A hairnet used to keep the hair out of the way and out of the food."
	icon_state = "hairnet"
	item_state = "hairnet"
	flags_inv = BLOCKHEADHAIR
	sprite_sheets = list(
		"Tajara" = 'icons/mob/species/tajaran/helmet.dmi'
		)
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand.dmi',
		)

//HOP
/obj/item/clothing/head/caphat/hop
	name = "crew resource's hat"
	desc = "A stylish hat that both protects you from enraged former-crewmembers and gives you a false sense of authority."
	icon_state = "hopcap"

/obj/item/clothing/head/caphat/xo
	name = "executive officer cap"
	desc = "A stylish cap issued to SCC executive officers."
	icon = 'icons/obj/item/clothing/department_uniforms/command.dmi'
	contained_sprite = TRUE
	icon_state = "executive_officer_cap"
	item_state = "executive_officer_cap"

/obj/item/clothing/head/caphat/bridge_crew
	name = "bridge crew cap"
	desc = "A stylish cap issued to the bridge crew of SCC vessels."
	icon = 'icons/obj/item/clothing/department_uniforms/command.dmi'
	contained_sprite = TRUE
	icon_state = "bridge_crew_cap"
	item_state = "bridge_crew_cap"

/obj/item/clothing/head/caphat/bridge_crew/alt
	name = "bridge crew cap"
	desc = "A more formal hat in a Colettish style, authorized for the bridge crew of SCC vessels."
	desc_extended = "Designed to allow the wearer to wear both a peaked cap and a radio headset, Colettish 'crusher' caps are prized throughout the Alliance and Republic for their comfort."
	icon_state = "bridge_crew_cap_alt"
	item_state = "bridge_crew_cap_alt"

//Chaplain
/obj/item/clothing/head/chaplain_hood
	name = "chaplain's hood"
	desc = "It's hood that covers the head. It keeps you warm during the space winters."
	icon_state = "chaplain_hood"
	flags_inv = BLOCKHAIR

//Chaplain
/obj/item/clothing/head/nun_hood
	name = "nun hood"
	desc = "Maximum piety in this star system."
	icon_state = "nun_hood"
	flags_inv = BLOCKHAIR

//Medical

/obj/item/clothing/head/headmirror
	name = "otolaryngologist's mirror"
	desc = "Turn your head and cough."
	desc_extended = "That's an Ear, Nose and/or Throat surgeon to you, mister."
	icon = 'icons/obj/item/clothing/department_uniforms/medical.dmi'
	contained_sprite = TRUE
	icon_state = "headmirror"
	item_state = "headmirror"

/obj/item/clothing/head/surgery
	name = "surgical cap"
	desc = "A cap surgeons wear during operations. Keeps their hair from tickling your internal organs."
	icon = 'icons/obj/item/clothing/department_uniforms/medical.dmi'
	icon_state = "surgcap_nt"
	item_state = "surgcap_nt"
	contained_sprite = TRUE
	flags_inv = BLOCKHEADHAIR

/obj/item/clothing/head/surgery/zeng
	icon_state = "surgcap_zeng"
	item_state = "surgcap_zeng"

/obj/item/clothing/head/surgery/pmc
	icon_state = "surgcap_pmc"
	item_state = "surgcap_pmc"

/obj/item/clothing/head/surgery/pmc/alt
	icon_state = "surgcap_pmc_alt"
	item_state = "surgcap_pmc_alt"

// Zavodskoi and Idris don't have medical jobs, but jobs like xenobiologist and investigators use them ancilliarily.

/obj/item/clothing/head/surgery/zavod
	icon_state = "surgcap_zav"
	item_state = "surgcap_zav"

/obj/item/clothing/head/surgery/idris
	icon_state = "surgcap_idris"
	item_state = "surgcap_idris"

//Detective

/obj/item/clothing/head/det
	name = "fedora"
	desc = "A brown fedora - either the cornerstone of a detective's style or a poor attempt at looking cool, depending on the person wearing it."
	icon_state = "brown_fedora"
	item_state_slots = list(
		slot_l_hand_str = "det_hat",
		slot_r_hand_str = "det_hat"
		)
	allowed = list(/obj/item/reagent_containers/food/snacks/candy_corn, /obj/item/pen)
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_MINOR
	)
	siemens_coefficient = 0.75

/obj/item/clothing/head/det/grey
	icon_state = "grey_fedora"
	desc = "A grey fedora - either the cornerstone of a detective's style or a poor attempt at looking cool, depending on the person wearing it."

/obj/item/clothing/head/warden
	name = "warden hat"
	desc = "A warden hat. For showing who is in charge of the brig."
	icon = 'icons/obj/item/clothing/department_uniforms/security.dmi'
	icon_state = "nt_warden_hat"
	item_state = "nt_warden_hat"
	flags_inv = HIDEEARS
	contained_sprite = TRUE

/obj/item/clothing/head/warden/zavod
	icon_state = "zav_warden_hat"
	item_state = "zav_warden_hat"
	
/obj/item/clothing/head/warden/zavod/alt
	icon_state = "zav_warden_hat_alt"
	item_state = "zav_warden_hat_alt"

/obj/item/clothing/head/warden/pmc
	icon_state = "pmc_warden_hat"
	item_state = "pmc_warden_hat"

/obj/item/clothing/head/warden/idris
	icon_state = "idris_warden_hat"
	item_state = "idris_warden_hat"

/obj/item/clothing/head/hos
	name = "head of security hat"
	desc = "The navy blue parade hat of the Head of Security. For showing the officers who's in charge."
	icon = 'icons/obj/item/clothing/department_uniforms/command.dmi'
	icon_state = "hos_hat"
	item_state = "hos_hat"
	flags_inv = HIDEEARS
	contained_sprite = TRUE

/obj/item/clothing/head/flatcap/bartender
	name = "bartender flatcap"
	desc = "A simple hat issued to bartenders to protect their eyes from the glare of crappy neo-contemporary hipster light installations."
	desc_extended = "The hat once associated with the chimney sweeps and coal miners of yesteryear. \
	Now resigned to sit on the heads of snooty upper-class bartenders and baristas. \
	You consider the irony. The service industry is equally as soul-crushing, just with minimum wage. \
	Worker's rights tentatively grace your grey matter before you return to your job. \
	Hey, at least it isn't as physically demanding. \
	You should probably stop singing sixteen-tons when wearing this hat, though."
	icon = 'icons/obj/item/clothing/department_uniforms/service.dmi'
	contained_sprite = TRUE
	icon_state = "nt_bartender_flatcap"
	item_state = "nt_bartender_flatcap"


/obj/item/clothing/head/flatcap/bartender/idris
	icon_state = "idris_bartender_flatcap"
	item_state = "idris_bartender_flatcap"

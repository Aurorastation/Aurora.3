/datum/ghostspawner/human/merchantass
	short_name = "merchantass"
	name = "Merchants Assistant"
	desc = "Assist the Merchant with their duties."
	tags = list("External")

	enabled = FALSE
	spawnpoints = list("MerchantAss")
	req_perms = null
	max_count = 1

	//Vars related to human mobs
	outfit = /datum/outfit/merchant_assistant
	possible_species = list("Human", "Off-Worlder Human", "Tajara", "Tajara", "M'sai Tajara", "Zhan-Khazan Tajara", "Skrell", "Unathi", "Vaurca Warrior", "Vaurca Worker", "Baseline Frame", "Hephaestus G1 Industrial Frame", "Hephaestus G2 Industrial Frame", "Xion Industrial Frame", "Zeng-Hu Mobility Frame", "Bishop Accessory Frame", "Shell Frame", "Diona")
	possible_genders = list(MALE,FEMALE)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Merchants Assistant"
	special_role = "Merchants Assistant"
	respawn_flag = null

	mob_name = null

/datum/ghostspawner/human/merchantass/can_edit(mob/user)
    . = ..()
    var/is_merchant = FALSE

    if(ishuman(user))
        var/mob/living/carbon/human/H = user
        is_merchant = (H.job == "Merchant")

    return . || is_merchant
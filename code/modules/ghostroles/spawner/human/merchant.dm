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
	possible_species = list(SPECIES_HUMAN, SPECIES_OFFWORLDER_HUMAN, SPECIES_TAJARA, SPECIES_TAJARA, SPECIES_MSAI_TJARA, SPECIES_ZHAN_KHAZAN_TAJARA
, SPECIES_SKRELL, SPECIES_UNATHI, SPECIES_AUTAKH_UNATHI, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_WORKER, SPECIES_IPC, SPECIES_HEPHAESTUS_G1_IPC, SPECIES_HEPHAESTUS_G2_IPC, SPECIES_XION_IPC, SPECIES_ZENGHU_IPC, SPECIES_BISHOP_IPC, SPECIES_SHELL_IPC, SPECIES_DIONA)
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

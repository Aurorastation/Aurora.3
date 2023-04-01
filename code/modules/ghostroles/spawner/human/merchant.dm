/datum/ghostspawner/teshari/merchantass
	short_name = "merchantass"
	name = "Merchants Assistant"
	desc = "Assist the Merchant with their duties."
	tags = list("External")

	enabled = FALSE
	spawnpoints = list("MerchantAss")
	req_perms = null
	max_count = 1

	//Vars related to teshari mobs
	outfit = /datum/outfit/merchant_assistant
	possible_species = list(SPECIES_teshari, SPECIES_teshari_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_UNATHI, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_WORKER, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL, SPECIES_DIONA)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Merchants Assistant"
	special_role = "Merchants Assistant"
	respawn_flag = null

	mob_name = null

/datum/ghostspawner/teshari/merchantass/can_edit(mob/user)
    . = ..()
    var/is_merchant = FALSE

    if(isteshari(user))
        var/mob/living/carbon/teshari/H = user
        is_merchant = (H.job == "Merchant")

    return . || is_merchant
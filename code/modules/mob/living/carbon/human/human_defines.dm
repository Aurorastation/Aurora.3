/mob/living/carbon/human
	//Hair colour and style
	var/r_hair = 0
	var/g_hair = 0
	var/b_hair = 0
	var/h_style = "Bald"

	//Hair gradient color and style
	var/r_grad = 0
	var/g_grad = 0
	var/b_grad = 0
	var/g_style = "None"

	//Facial hair colour and style
	var/r_facial = 0
	var/g_facial = 0
	var/b_facial = 0
	var/f_style = "Shaved"

	//Eye colour
	var/r_eyes = 0
	var/g_eyes = 0
	var/b_eyes = 0

	var/s_tone = 0	//Skin tone

	//Skin colour
	var/r_skin = 0
	var/g_skin = 0
	var/b_skin = 0

	var/size_multiplier = 1 //multiplier for the mob's icon size
	var/damage_multiplier = 1 //multiplies melee combat damage
	var/icon_update = 1 //whether icon updating shall take place

	var/lip_style = null	//no lipstick by default- arguably misleading, as it could be used for general makeup

	var/age = 30		//Player's age (pure fluff)
	var/b_type = "A+"	//Player's bloodtype

	var/list/all_underwear = list()
	var/list/all_underwear_metadata = list()
	var/list/hide_underwear = list()
	var/backbag = OUTFIT_BACKPACK		//Which backpack type the player has chosen. Nothing, Satchel or Backpack.
	var/backbag_style = 1
	var/pda_choice = OUTFIT_TAB_PDA
	var/headset_choice = OUTFIT_HEADSET

	var/last_chew = 0 // Used for hand chewing

	// General information
	var/citizenship = ""
	var/employer_faction = ""
	var/religion = ""

	//Equipment slots
	var/obj/item/wear_suit = null
	var/obj/item/w_uniform = null
	var/obj/item/shoes = null
	var/obj/item/belt = null
	var/obj/item/gloves = null
	var/obj/item/glasses = null
	var/obj/item/head = null
	var/obj/item/l_ear = null
	var/obj/item/r_ear = null
	var/obj/item/wear_id = null
	var/obj/item/r_store = null
	var/obj/item/l_store = null
	var/obj/item/s_store = null
	var/obj/item/wrists = null

	var/used_skillpoints = 0
	var/skill_specialization = null
	var/list/skills = list()

	var/icon/stand_icon = null
	var/icon/lying_icon = null

	var/voice = ""	//Instead of new say code calling GetVoice() over and over and over, we're just going to ask this variable, which gets updated in Life()

	var/speech_problem_flag = 0

	var/miming = null //Toggle for the mime's abilities.
	var/special_voice = "" // For changing our voice. Used by a symptom.

	var/last_dam = -1	//Used for determining if we need to process all organs or just some or even none.
	var/list/bad_external_organs = list()// organs we check until they are good.

	var/list/bad_internal_organs = list()//A list of internal organs which are damaged.
	//This isnt used for regular processing, since all internal organs are regularly processed anyway, but it can be used as a shortlist for calls that only care about damaged organs

	var/xylophone = 0 //For the spoooooooky xylophone cooldown

	var/mob/remoteview_target = null
	var/hand_blood_color

	var/list/flavor_texts = list()
	var/list/gunshot_residue
	var/pulling_punches // Are you trying not to hurt your opponent?

	mob_bump_flag = HUMAN
	mob_push_flags = ~HEAVY
	mob_swap_flags = ~HEAVY

	var/flash_protection = 0				// Total level of flash protection
	var/equipment_tint_total = 0			// Total level of visualy impairing items
	var/equipment_darkness_modifier			// Darkvision modifier from equipped items
	var/equipment_vision_flags				// Extra vision flags from equipped items
	var/equipment_see_invis					// Max see invibility level granted by equipped items
	var/equipment_prescription				// Eye prescription granted by equipped items
	var/list/equipment_overlays = list()	// Extra overlays from equipped items

	var/is_noisy = FALSE		// if TRUE, movement should make sound.
	var/bodyfall_sound = /decl/sound_category/bodyfall_sound
	var/footsound = /decl/sound_category/blank_footsteps

	var/last_x = 0
	var/last_y = 0

	var/cached_bodytype

	var/stance_damage = 0 //Whether this mob's ability to stand has been affected

	var/datum/unarmed_attack/default_attack	//default unarmed attack

	var/datum/martial_art/primary_martial_art = null
	var/list/datum/martial_art/known_martial_arts = null

	var/triage_tag = TRIAGE_NONE

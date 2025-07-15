/obj/item/clothing/head/centhat
	name = "\improper CentComm. hat"
	icon_state = "centcom"
	item_state_slots = list(
		slot_l_hand_str = "centhat",
		slot_r_hand_str = "centhat"
		)
	desc = "It's good to be emperor."
	siemens_coefficient = 0.9

/obj/item/clothing/head/pin
	name = "hair pin"
	desc = "A nice hair pin."
	icon = 'icons/obj/item/clothing/head/hair_pins.dmi'
	contained_sprite = TRUE
	icon_state = "pin"
	item_state = "pin"
	slot_flags = SLOT_HEAD | SLOT_EARS
	body_parts_covered = 0
	drop_sound = 'sound/items/drop/ring.ogg'
	pickup_sound = 'sound/items/pickup/ring.ogg'

/obj/item/clothing/head/pin/clover
	icon_state = "cloverpin"
	item_state = "cloverpin"
	name = "clover pin"
	desc = "A hair pin in the shape of a clover leaf. Smells of mischief."

/obj/item/clothing/head/pin/butterfly
	icon_state = "butterflypin"
	item_state = "butterflypin"
	name = "butterfly pin"
	desc = "A hair pin in the shape of a bright blue butterfly."

/obj/item/clothing/head/pin/magnetic
	icon_state = "magnetpin"
	item_state = "magnetpin"
	name = "magnetic 'pin'"
	desc = "Finally, a hair pin even a robot chassis can use."
	slot_flags = SLOT_HEAD
	matter = list(DEFAULT_WALL_MATERIAL = 10)

/obj/item/clothing/head/pin/flower
	name = "red flower pin"
	icon_state = "hairflower"
	item_state = "hairflower"
	desc = "Smells nice."

/obj/item/clothing/head/pin/flower/blue
	icon_state = "hairflower_blue"
	item_state = "hairflower_blue"
	name = "blue flower pin"

/obj/item/clothing/head/pin/flower/pink
	item_state = "hairflower_pink"
	icon_state = "hairflower_pink"
	name = "pink flower pin"

/obj/item/clothing/head/pin/flower/yellow
	icon_state = "hairflower_yellow"
	item_state = "hairflower_yellow"
	name = "yellow flower pin"

/obj/item/clothing/head/pin/flower/violet
	icon_state = "hairflower_violet"
	item_state = "hairflower_violet"
	name = "violet flower pin"

/obj/item/clothing/head/pin/flower/orange
	icon_state = "hairflower_orange"
	item_state = "hairflower_orange"
	name = "orange flower pin"

/obj/item/clothing/head/pin/flower/white
	icon_state = "hairflower_white"
	item_state = "hairflower_white"
	name = "white flower pin"

/obj/item/clothing/head/pin/flower/silversun
	icon_state = "hairflower_silversun"
	item_state = "hairflower_silversun"
	name = "silversun flower pin"
	desc = "A Silversun dawnflower pin, named after the same flower. This particular version is an artificial recreation, and lacks the distinctive bioluminescence of the original."

/obj/item/clothing/head/pin/ribbon
	name = "hair ribbon parent item"
	desc = DESC_PARENT
	icon = 'icons/obj/item/clothing/head/hair_ribbons.dmi'
	contained_sprite = TRUE

/obj/item/clothing/head/pin/ribbon/head
	name = "hair ribbon"
	desc = "A length of ribbon acting as a headband."
	icon_state = "ribbon"
	item_state = "ribbon"

/obj/item/clothing/head/pin/ribbon/back
	name = "hair bow"
	desc = "A hair bow with a small removable clip on the back, so it can be attached to hair or tied into it."
	icon_state = "bow"
	item_state = "bow"

/obj/item/clothing/head/pin/ribbon/small
	name = "small hair bow"
	desc = "A ribbon tied into a small bow with a clip on the back to attach to hair."
	icon_state = "bow_small"
	item_state = "bow_small"

/obj/item/clothing/head/powdered_wig
	name = "powdered wig"
	desc = "A powdered wig."
	icon_state = "pwig"
	item_state = "pwig"

/obj/item/clothing/head/that
	name = "top-hat"
	desc = "It's an amish looking hat."
	icon_state = "tophat"
	item_state = "tophat"
	siemens_coefficient = 0.9

/obj/item/clothing/head/redcoat
	name = "redcoat's hat"
	icon_state = "redcoat"
	desc = "<i>'I guess it's a redhead.'</i>"

/obj/item/clothing/head/mailman
	name = "station cap"
	icon_state = "mailman"
	desc = "<i>Choo-choo</i>!"

/obj/item/clothing/head/nursehat
	name = "nurse's hat"
	desc = "It allows quick identification of trained medical personnel."
	icon_state = "nursehat"
	siemens_coefficient = 0.9

/obj/item/clothing/head/syndicatefake
	name = "red space-helmet replica"
	item_state_slots = list(
		slot_l_hand_str = "syndicate-helm-black-red",
		slot_r_hand_str = "syndicate-helm-black-red"
		)
	icon_state = "syndicate"
	desc = "A plastic replica of a bloodthirsty mercenary's space helmet, you'll look just like a real murderous criminal operative in this! This is a toy, it is not made for use in space!"
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR
	siemens_coefficient = 2.0
	body_parts_covered = HEAD|FACE|EYES

/obj/item/clothing/head/cardborg
	name = "cardborg helmet"
	desc = "A helmet made out of a box."
	icon_state = "cardborg_h"
	item_state = "cardborg_h"
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE
	body_parts_covered = HEAD|FACE|EYES
	drop_sound = 'sound/items/drop/cardboardbox.ogg'
	pickup_sound = 'sound/items/pickup/cardboardbox.ogg'

/obj/item/clothing/head/justice
	name = "justice hat"
	desc = "Fight for what's righteous!"
	icon_state = "justicered"
	flags_inv = BLOCKHAIR
	body_parts_covered = HEAD|EYES

/obj/item/clothing/head/justice/blue
	icon_state = "justiceblue"

/obj/item/clothing/head/justice/yellow
	icon_state = "justiceyellow"

/obj/item/clothing/head/justice/green
	icon_state = "justicegreen"

/obj/item/clothing/head/justice/pink
	icon_state = "justicepink"

/obj/item/clothing/head/rabbitears
	name = "rabbit ears"
	desc = "Wearing these makes you look useless."
	icon_state = "bunny"
	body_parts_covered = 0

/obj/item/clothing/head/flatcap
	name = "flat cap"
	desc = "A working man's hat."
	icon = 'icons/obj/item/clothing/head/flat_cap.dmi'
	icon_state = "flat_cap_brown"
	item_state = "flat_cap_brown"
	contained_sprite = TRUE
	siemens_coefficient = 0.9

/obj/item/clothing/head/flatcap/colourable
	icon_state = "flat_cap"
	item_state = "flat_cap"

/obj/item/clothing/head/pirate
	name = "pirate hat"
	desc = "Yarr."
	icon_state = "pirate"

/obj/item/clothing/head/hgpiratecap
	name = "pirate hat"
	desc = "Yarr."
	icon_state = "hgpiratecap"

/obj/item/clothing/head/bowler
	name = "bowler-hat"
	desc = "Gentleman, elite aboard!"
	icon_state = "bowler"

//stylish bs12 hats

/obj/item/clothing/head/bowlerhat
	name = "bowler hat"
	icon_state = "bowler_hat"
	desc = "For the gentleman of distinction."

/obj/item/clothing/head/beaverhat
	name = "beaver hat"
	icon_state = "beaver_hat"
	desc = "Soft felt makes this hat both comfortable and elegant."

/obj/item/clothing/head/boaterhat
	name = "boater hat"
	icon_state = "boater_hat"
	desc = "The ultimate in summer fashion."

/obj/item/clothing/head/feathertrilby
	name = "feather trilby"
	icon = 'icons/obj/item/clothing/head/feather_trilby.dmi'
	icon_state = "feather_trilby"
	item_state = "feather_trilby"
	contained_sprite = TRUE
	desc = "A sharp, stylish hat with a feather."

/obj/item/clothing/head/fez
	name = "fez"
	desc = "You should wear a fez. Fezzes are cool."
	icon_state = "fez"
	item_flags = ITEM_FLAG_SHOW_FLAVOR_TEXT

//end bs12 hats

/obj/item/clothing/head/witchwig
	name = "witch costume wig"
	desc = "Eeeee~heheheheheheh!"
	icon_state = "witch"
	flags_inv = BLOCKHAIR
	siemens_coefficient = 2.0

/obj/item/clothing/head/chicken
	name = "chicken suit head"
	desc = "Bkaw!"
	icon_state = "chickenhead"
	item_state_slots = list(
		slot_l_hand_str = "chickensuit",
		slot_r_hand_str = "chickensuit"
		)
	sprite_sheets = list(
		BODYTYPE_VAURCA_BULWARK = 'icons/mob/species/bulwark/head.dmi'
	)
	flags_inv = BLOCKHAIR
	siemens_coefficient = 0.7
	body_parts_covered = HEAD|FACE|EYES

/obj/item/clothing/head/bearpelt
	name = "bear pelt hat"
	desc = "Fuzzy."
	icon_state = "bearpelt"
	flags_inv = BLOCKHEADHAIR
	siemens_coefficient = 0.7

/obj/item/clothing/head/philosopher_wig
	name = "natural philosopher's wig"
	desc = "A stylish monstrosity unearthed from Earth's Renaissance period. With this most distinguish'd wig, you'll be ready for your next soiree!"
	icon_state = "philosopher_wig"
	item_state_slots = list(
		slot_l_hand_str = "pwig",
		slot_r_hand_str = "pwig"
		)
	flags_inv = BLOCKHAIR
	siemens_coefficient = 2.0 //why is it so conductive?!

/obj/item/clothing/head/plain_hood
	name = "plain hood"
	desc = "A simple hood made of cloth, worn for myriad reasons - cultural, religious, protection from the elements, a fashion statement... or perhaps you simply want to look like you intend to give quests to adventurers who walk into your favorite tavern."
	icon = 'icons/obj/item/clothing/head/plain_hood.dmi'
	icon_state = "plain_hood"
	item_state = "plain_hood"
	body_parts_covered = HEAD
	flags_inv = HIDEEARS|BLOCKHEADHAIR
	contained_sprite = TRUE

/obj/item/clothing/head/hijab //It might've taken a year but here's your Hijab's, Dea.
	name = "hijab"
	desc = "Encompassing cloth headwear worn by some human cultures and religions."
	icon = 'icons/obj/clothing/hijabs.dmi'
	icon_state = "hijab"
	item_state = "hijab"
	flags_inv = BLOCKHAIR
	body_parts_covered = 0
	contained_sprite = 1
	slot_flags = SLOT_EARS  | SLOT_HEAD

/obj/item/clothing/head/hijab/get_ear_examine_text(var/mob/user, var/ear_text = "left")
	return "on [user.get_pronoun("his")] head"

/obj/item/clothing/head/hijab/red
	color = COLOR_RED

/obj/item/clothing/head/hijab/orange
	color = COLOR_ORANGE

/obj/item/clothing/head/hijab/yellow
	color = COLOR_YELLOW

/obj/item/clothing/head/hijab/green
	color = COLOR_GREEN

/obj/item/clothing/head/hijab/blue
	color = COLOR_BLUE

/obj/item/clothing/head/hijab/purple
	color = COLOR_PURPLE

/obj/item/clothing/head/hijab/brown
	color = COLOR_BROWN

/obj/item/clothing/head/hijab/grey
	color = COLOR_GRAY50

/obj/item/clothing/head/hijab/black
	color = COLOR_GRAY20

/obj/item/clothing/head/sombrero
	name = "sombrero"
	desc = "You can practically taste the fiesta."
	icon_state = "sombrero"
	sprite_sheets = list(
		BODYTYPE_VAURCA_BULWARK = 'icons/mob/species/bulwark/head.dmi'
	)

/obj/item/clothing/head/kippah
	name = "kippah"
	desc = "A head covering commonly worn by those of Jewish faith."
	icon = 'icons/obj/item/clothing/head/kippahs.dmi'
	icon_state = "kippah"
	item_state = "kippah"
	contained_sprite = 1

/obj/item/clothing/head/turban
	name = "turban"
	desc = "A sturdy cloth, worn around the head."
	icon = 'icons/obj/item/clothing/head/turban.dmi'
	icon_state = "turban"
	item_state = "turban"
	flags_inv = BLOCKHEADHAIR
	contained_sprite = TRUE

/obj/item/clothing/head/turban/red
	color = COLOR_RED

/obj/item/clothing/head/turban/orange
	color = COLOR_ORANGE

/obj/item/clothing/head/turban/yellow
	color = COLOR_YELLOW

/obj/item/clothing/head/turban/green
	color = COLOR_GREEN

/obj/item/clothing/head/turban/blue
	color = COLOR_BLUE

/obj/item/clothing/head/turban/purple
	color = COLOR_PURPLE

/obj/item/clothing/head/turban/brown
	color = COLOR_BROWN

/obj/item/clothing/head/turban/grey
	color = COLOR_GRAY50

/obj/item/clothing/head/turban/black
	color = COLOR_GRAY20

//praise verkister
/obj/item/clothing/head/headbando
	name = "basic headband"
	desc = "Perfect for martial artists, sweaty rogue operators, and tunnel gangsters."
	icon_state = "headbando"
	item_state = "headbando"

/obj/item/clothing/head/headbando/random/Initialize()
	. = ..()
	color = get_random_colour(lower = 150)

//Flower crowns
/obj/item/clothing/head/sunflower_crown
	name = "sunflower crown"
	desc = "A flower crown weaved with sunflowers."
	icon_state = "sunflower_crown"
	item_state = "sunflower_crown"
	body_parts_covered = 0
	drop_sound = 'sound/items/drop/herb.ogg'
	pickup_sound = 'sound/items/pickup/herb.ogg'

/obj/item/clothing/head/lavender_crown
	name = "harebell crown"
	desc = "A flower crown weaved with harebells."
	icon_state = "lavender_crown"
	item_state = "lavender_crown"
	body_parts_covered = 0
	drop_sound = 'sound/items/drop/herb.ogg'
	pickup_sound = 'sound/items/pickup/herb.ogg'

/obj/item/clothing/head/poppy_crown
	name = "poppy crown"
	desc = "A flower crown weaved with poppies."
	icon_state = "poppy_crown"
	item_state = "poppy_crown"
	body_parts_covered = 0
	drop_sound = 'sound/items/drop/herb.ogg'
	pickup_sound = 'sound/items/pickup/herb.ogg'

//Tau Ceti Foreign Legion

/obj/item/clothing/head/legion/legate
	name = "TCFL peaked cap"
	desc = "A stark red peaked cap. Worn by senior officers of the Tau Ceti Foreign Legion."
	icon_state = "legion_cap"
	item_state = "legion_cap"

/obj/item/clothing/head/fake_culthood
	name = "occultist hood"
	icon_state = "culthood"
	desc = "A torn, dust-caked hood. Very authentic!"
	flags_inv = HIDEFACE|HIDEEARS|HIDEEYES
	body_parts_covered = HEAD|EYES
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE

/obj/item/clothing/head/tanker
	name = "tanker cap"
	desc = "A padded skullcap for those prone to bumping their heads against hard surfaces."
	icon_state = "tank"
	flags_inv = BLOCKHEADHAIR

/obj/item/clothing/head/papersack
	name = "paper sack hat"
	desc = "A paper sack with crude holes cut out for eyes. Useful for hiding one's identity or ugliness."
	icon_state = "papersack"
	flags_inv = BLOCKHEADHAIR

/obj/item/clothing/head/papersack/smiley
	name = "paper sack hat"
	desc = "A paper sack with crude holes cut out for eyes and a sketchy smile drawn on the front. Not creepy at all."
	icon_state = "papersack_smile"
	flags_inv = BLOCKHEADHAIR

/obj/item/clothing/head/hachimaki
	name = "konyanger hachimaki"
	desc = "A simple headband emblazoned with the taijitu national emblem of the planet Konyang. It is typically worn as a symbol of effort or courage, or perhaps national pride and patriotic sentiment."
	icon = 'icons/obj/item/clothing/head/hachimaki.dmi'
	icon_state = "hachimaki"
	item_state = "hachimaki"
	contained_sprite = TRUE

/obj/item/clothing/head/leader_headband
	name = "militia leader headband"
	desc = "A simple headband that is used to denote the leader of a Horizon militia team."
	icon = 'icons/obj/item/clothing/head/leader_headband.dmi'
	icon_state = "leader_headband"
	item_state = "leader_headband"
	contained_sprite = TRUE

//sol stuff

/obj/item/clothing/head/sol
	name = "sol navy utility cover"
	desc = "A military cover issued to Solarian Navy personnel as part of their utility uniform."
	icon = 'icons/obj/item/clothing/head/sol_army.dmi'
	icon_state = "navy_utility"
	item_state = "navy_utility"
	contained_sprite = TRUE
	armor = list(
		MELEE = ARMOR_MELEE_MINOR
		)

/obj/item/clothing/head/sol/dress
	name = "sol navy black peaked cap"
	desc = "A black cap issued as part of the Sol Alliance naval officer uniforms. This one is worn by junior officers."
	icon_state = "navy_cap_officer"
	item_state = "navy_cap_officer"

/obj/item/clothing/head/sol/dress/officer
	name = "sol navy officer peaked cap"
	desc = "A white cap issued as part of the Sol Alliance naval officer uniforms. This one is worn by senior officers."
	icon_state = "navy_cap_senioroff"
	item_state = "navy_cap_senioroff"

/obj/item/clothing/head/sol/dress/admiral
	name = "sol navy admiral peaked cap"
	desc = "A white cap issued as part of the Sol Alliance naval officer uniforms. This one is worn by admirals."
	icon_state = "navy_cap_admiral"
	item_state = "navy_cap_admiral"

//solarian marines

/obj/item/clothing/head/sol/marine
	name = "sol marine utility cover"
	desc = "An eight pointed cover issued to Sol Alliance marines as part of their field uniform."
	icon_state = "marine_utility"
	item_state = "marine_utility"

/obj/item/clothing/head/sol/marine/grey
	name = "sol marine utility cover"
	desc = "An eight pointed cover issued to Sol Alliance marines as part of their field uniform."
	icon_state = "marine_utility_grey"
	item_state = "marine_utility_grey"

/obj/item/clothing/head/sol/garrison
	name = "sol marine garrison cap"
	desc = "A green garrison cap issued to Sol Alliance marines."
	icon_state = "greengarrisoncap"
	item_state = "greengarrisoncap"

/obj/item/clothing/head/sol/dress/marine
	name = "sol marine peaked cap"
	desc = "A green cap issued as part of the Sol Alliance marine service and dress uniforms."
	icon_state = "whitepeakcap"
	item_state = "whitepeakcap"

//solarian army

/obj/item/clothing/head/helmet/sol
	name = "sol combat helmet"
	desc = "A woodland colored helmet made from advanced ceramic."
	icon = 'icons/obj/item/clothing/head/sol_army.dmi'
	icon_state = "helmet_tac_sol"
	item_state = "helmet_tac_sol"
	armor = list(
		MELEE = ARMOR_MELEE_MAJOR,
		BULLET = ARMOR_BALLISTIC_MEDIUM,
		LASER = ARMOR_LASER_RIFLE,
		ENERGY = ARMOR_ENERGY_SMALL,
		BOMB = ARMOR_BOMB_PADDED
	)
	contained_sprite = TRUE

/obj/item/clothing/head/sol/army
	name = "sol army field cap"
	desc = "A cloth field issued to Solarian soldiers as part of their field uniform."
	icon_state = "army_field"
	item_state = "army_field"

/obj/item/clothing/head/sol/army/grey
	name = "sol army field cap"
	desc = "A cloth field issued to Solarian soldiers as part of their field uniform."
	icon_state = "army_field_grey"
	item_state = "army_field_grey"

/obj/item/clothing/head/sol/army/service
	name = "sol army peaked cap"
	desc = "A green peaked cap issued as part of Solarian Army service uniforms. A small silver pin of the ASSN seal is attached to the peak. A enlisted-person or NCO should wear this."
	icon_state = "army_cap"
	item_state = "army_cap"

/obj/item/clothing/head/sol/army/service/officer
	name = "sol army officer peaked cap"
	desc = "A green peaked cap issued as part of Solarian Army service uniforms. A large gold pin of the ASSN seal is attached to the peak. A Second Lieutenant, First Lieutenant or Captain should wear this."
	icon_state = "army_cap_officer"
	item_state = "army_cap_officer"

/obj/item/clothing/head/sol/army/service/senioroff
	name = "sol army senior officer peaked cap"
	desc = "A green peaked cap issued as part of Solarian Army service uniforms. A large gold pin of the ASSN seal is attached to the peak and leaf-shaped embellishments rap around the visor. A Major, Lieutenant Colonel or Colonel should wear this."
	icon_state = "army_cap_senioroff"
	item_state = "army_cap_senioroff"

/obj/item/clothing/head/sol/army/service/general
	name = "sol army general peaked cap"
	desc = "A green peaked cap issued as part of Solarian Army service uniforms. A large gold pin of the ASSN seal is attached to the peak and leaf-shaped embellishments rap around the visor. A Brigadier General, Major General, Lieutenant General or full General should wear this."
	icon_state = "army_cap_general"
	item_state = "army_cap_general"

/obj/item/clothing/head/sol/army/service/garrison
	name = "sol army garrison cap"
	desc = "A green garrison cap issued as part of Solarian Army service uniforms, for when a peaked cap is impractical or unnecessary. All enlisted-people and NCOs should wear this."
	icon_state = "army_garrison"
	item_state = "army_garrison"

/obj/item/clothing/head/sol/army/service/garrison/officer
	name = "sol army garrison cap"
	desc = "A green garrison cap issued as part of Solarian Army service uniforms, for when a peaked cap is impractical or unnecessary. A golden rank pin is attached to one side. All officers, including generals, should wear this."
	icon_state = "army_garrison_officer"
	item_state = "army_garrison_officer"

/obj/item/clothing/head/sol/army/service/campaign
	name = "sol army campaign hat"
	desc = "A green campaign hat issued as part of Solarian Army service uniforms. The NCOs that scream at you more than the normal ones should wear this."
	icon_state = "army_campaign"
	item_state = "army_campaign"

//Konyang Armed Forces

/obj/item/clothing/head/konyang/army
	name = "konyang army field cap"
	desc = "A cloth field cap issued to Konyang soldiers as part of their field uniform."
	icon = 'icons/obj/item/clothing/head/konyang.dmi'
	icon_state = "konyang_army_cap"
	item_state = "konyang_army_cap"
	contained_sprite = TRUE

/obj/item/clothing/head/konyang/army/officer
	name = "konyang army officer peaked cap"
	desc = "A green peaked cap issued to officers of the Konyang Army."
	icon_state = "konyang_army_off_cap"
	item_state = "konyang_army_off_cap"

/obj/item/clothing/head/konyang/navy
	name = "konyang navy officer peaked cap"
	desc = "A white peaked cap issued to officers of the Konyang Navy."
	icon = 'icons/obj/item/clothing/head/konyang.dmi'
	icon_state = "konyang_navy_cap"
	item_state = "konyang_navy_cap"
	contained_sprite = TRUE

/obj/item/clothing/head/konyang/space
	name = "konyang aerospace forces officer peaked cap"
	desc = "A white peaked cap issued to officers of the Konyang Aerospace Forces."
	icon = 'icons/obj/item/clothing/head/konyang.dmi'
	icon_state = "konyang_space_cap"
	item_state = "konyang_space_cap"
	contained_sprite = TRUE

/obj/item/clothing/head/konyang/police
	name = "konyang national police hat"
	desc = "A white peaked cap issued to personnel of the Konyang National Police"
	icon = 'icons/obj/item/clothing/head/konyang.dmi'
	icon_state = "konyang_police_hat"
	item_state = "konyang_police_hat"
	contained_sprite = TRUE

/obj/item/clothing/head/konyang/police/lieutenant
	name = "konyang national police lieutenant's hat"
	desc = "A white peaked cap issued to personnel of the Konyang National Police"
	icon_state = "konyang_police_lieutenant_hat"
	item_state = "konyang_police_lieutenant_hat"

/obj/item/clothing/head/konyang/burger
	name = "\improper UP! Burger cap"
	desc = "An astoundingly bright orange hat, worn by employees of UP! Burger (or Burger UP!, depending on preference), a Gwok Group subsidiary."
	icon = 'icons/obj/item/clothing/head/konyang.dmi'
	icon_state = "upburger-cap"
	item_state = "upburger-cap"
	contained_sprite = TRUE

/obj/item/clothing/head/helmet/konyang
	name = "konyang army helmet"
	desc = "A woodland colored helmet made from advanced ceramic."
	icon = 'icons/obj/item/clothing/head/konyang.dmi'
	icon_state = "helmet_konyang_army"
	item_state = "helmet_konyang_army"
	armor = list(
		MELEE = ARMOR_MELEE_MAJOR,
		BULLET = ARMOR_BALLISTIC_MEDIUM,
		LASER = ARMOR_LASER_RIFLE,
		ENERGY = ARMOR_ENERGY_SMALL,
		BOMB = ARMOR_BOMB_PADDED
	)
	contained_sprite = TRUE

/obj/item/clothing/head/helmet/konyang/navy
	name = "konyang navy helmet"
	desc = "A pale blue colored helmet made from advanced ceramic."
	icon_state = "helmet_konyang_navy"
	item_state = "helmet_konyang_navy"

/obj/item/clothing/head/helmet/konyang/pilot
	name = "konyang mechatronic corps helmet"
	desc = "A white colored helmet made from advanced ceramic."
	icon_state = "helmet_pilot"
	item_state = "helmet_pilot"

/obj/item/clothing/head/xanu
	name = "xanu armed forces garrison cap"
	desc = "A garrison cap belonging to a member of the All-Xanu Spacefleet."
	icon = 'icons/obj/item/clothing/head/xanu_army.dmi'
	icon_state = "xanu_garrison_enlisted"
	item_state = "xanu_garrison_enlisted"
	contained_sprite = TRUE

/obj/item/clothing/head/xanu/officer
	name = "xanu armed forces officer garrison cap"
	desc = "A garrison cap belonging to an officer of the All-Xanu Spacefleet."
	icon_state = "xanu_garrison_comm"
	item_state = "xanu_garrison_comm"

/obj/item/clothing/head/xanu/senior
	name = "xanu armed forces senior officer garrison cap"
	desc = "A garrison cap belonging to a high-ranking officer of the All-Xanu Spacefleet."
	icon_state = "xanu_garrison_cap"
	item_state = "xanu_garrison_cap"

/obj/item/clothing/head/grupo_amapola
	name = "Grupo Amapola officer cap"
	desc = "A peaked officer's cap bearing the poppy of the military contracting group Grupo Amapola."
	icon = 'icons/obj/item/clothing/head/pmcg.dmi'
	icon_state = "amapola_officer_hat"
	item_state = "amapola_officer_hat"
	contained_sprite = TRUE

/obj/item/clothing/head/grupo_amapola/ute
	name = "Grupo Amapola utility cover"
	desc = "A softcap in green camo, issued to members of the military contracting group Grupo Amapola."
	icon_state = "amapola_ute_hat"
	item_state = "amapola_ute_hat"

/obj/item/clothing/head/peaked_cap
	name = "corporate peaked cap"
	desc = "A military-style corporate peaked cap. This one bears the emblem of NanoTrasen Incorporated."
	icon_state = "nt_warden_hat"
	item_state = "nt_warden_hat"
	icon = 'icons/obj/item/clothing/department_uniforms/security.dmi'
	contained_sprite = TRUE

/obj/item/clothing/head/peaked_cap/no_logo
	desc = "A military-style corporate peaked cap. This one bears the colors of NanoTrasen Incorporated."
	icon_state = "nt_warden_hat_nologo"
	item_state = "nt_warden_hat_nologo"

/obj/item/clothing/head/peaked_cap/zavodskoi
	desc = "A military-style corporate peaked cap. This one bears the emblem of Zavodskoi Interstellar."
	icon_state = "zav_warden_hat"
	item_state = "zav_warden_hat"

/obj/item/clothing/head/peaked_cap/zavodskoi/no_logo
	desc = "A military-style corporate peaked cap. This one bears the colors of Zavodskoi Interstellar."
	icon_state = "zav_warden_hat_nologo"
	item_state = "zav_warden_hat_nologo"

/obj/item/clothing/head/peaked_cap/zavodskoi/alt
	icon_state = "zav_warden_hat_alt"
	item_state = "zav_warden_hat_alt"

/obj/item/clothing/head/peaked_cap/zavodskoi/alt/no_logo
	desc = "A military-style corporate peaked cap. This one bears the colors of Zavodskoi Interstellar."
	icon_state = "zav_warden_hat_alt_nologo"
	item_state = "zav_warden_hat_alt_nologo"

/obj/item/clothing/head/peaked_cap/idris
	desc = "A military-style corporate peaked cap. This one bears the emblem of Idris Incorporated."
	icon_state = "idris_warden_hat"
	item_state = "idris_warden_hat"

/obj/item/clothing/head/peaked_cap/idris/no_logo
	desc = "A military-style corporate peaked cap. This one bears the colors of Idris Incorporated."
	icon_state = "idris_warden_hat_nologo"
	item_state = "idris_warden_hat_nologo"

/obj/item/clothing/head/peaked_cap/pmcg
	desc = "A military-style corporate peaked cap. This one bears the emblem of the Private Military Contracting Group."
	icon_state = "pmc_warden_hat"
	item_state = "pmc_warden_hat"

/obj/item/clothing/head/peaked_cap/pmcg/no_logo
	desc = "A military-style corporate peaked cap. This one bears the colors of the Private Military Contracting Group."
	icon_state = "pmc_warden_hat_nologo"
	item_state = "pmc_warden_hat_nologo"

//goblin.stev's stuff
/obj/item/clothing/head/qeburger_visor
	name = "Quick-E-Burger Food Technician Visor"
	desc = "For stylish employees on the retail grind, the Quick-E-Burger Food Technician Visor is the latest in form-first fashion! Supplied and manufactured in bulk by Quick-E-Burger's parent company, Orion Express, the Food Technician Visor is equipped with an innovative easy-to-use velcro headstrap to keep the company's prime product sky-high, and its light-resistant plastic visor is perfect for keeping sun, lights, and disappointed family-members alike out of employees' eyes!"
	icon = 'icons/obj/clothing/hats/orion.dmi'
	icon_state = "quickeburger_visorcap"
	item_state = "quickeburger_visorcap"
	contained_sprite = TRUE

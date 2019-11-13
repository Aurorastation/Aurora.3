//Unathi clothing.

/obj/item/clothing/suit/unathi/robe
	name = "roughspun robes"
	desc = "A traditional Unathi garment."
	icon_state = "robe-unathi"
	item_state = "robe-unathi"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS

/obj/item/clothing/suit/unathi/robe/robe_coat //I was at a loss for names under-the-hood.
	name = "tzirzi robes"
	desc = "A casual Moghes-native garment typically worn by Unathi while planet-side."
	icon = 'icons/obj/unathi_items.dmi'
	icon_state = "robe_coat"
	item_state = "robe_coat"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS
	contained_sprite = 1

/obj/item/clothing/suit/unathi/mantle
	name = "hide mantle"
	desc = "A rather grisly selection of cured hides and skin, sewn together to form a ragged mantle."
	icon_state = "mantle-unathi"
	item_state = "mantle-unathi"
	body_parts_covered = UPPER_TORSO

//Taj clothing.

/obj/item/clothing/suit/storage/toggle/labcoat/tajaran
	name = "people's republic medical coat"
	desc = "A sterile insulated coat made of leather stitched over fur."
	icon_state = "taj_jacket"
	item_state = "taj_jacket"
	icon_open = "taj_jacket_open"
	icon_closed = "taj_jacket"
	description_fluff = "Today the fashion that dominates Adhomai shares few similarities to the clothing of old Furs, linen, hemp, silk and other such fabrics were traded for \
	synthetic versions, creating a massive boom in the nylon industry and textile industry in the cities. Jeans, overcoats, army uniforms, parade uniforms, flags, pants, shirts, ties, \
	suspenders, overalls are now the fashion of every Tajara from Nal'Tor to Kaltir. The protests of \"Old fashion\" supporters usually shatter against how effective and cheap it is to \
	make the human clothes are. There are a few notable branches, the long-coat and fedora \"gangster style\". Leather jacket wearing \"Greaser\" or the popular amongst females, short \
	and colorful dress wearing \"Flapper\" variety of clothing."

/obj/item/clothing/suit/storage/tajaran
	name = "tajaran naval coat"
	desc = "A thick wool coat from Adhomai."
	icon_state = "naval_coat"
	item_state = "naval_coat"
	description_fluff = "Today the fashion that dominates Adhomai shares few similarities to the clothing of old Furs, linen, hemp, silk and other such fabrics were traded for \
	synthetic versions, creating a massive boom in the nylon industry and textile industry in the cities. Jeans, overcoats, army uniforms, parade uniforms, flags, pants, shirts, ties, \
	suspenders, overalls are now the fashion of every Tajara from Nal'Tor to Kaltir. The protests of \"Old fashion\" supporters usually shatter against how effective and cheap it is to \
	make the human clothes are. There are a few notable branches, the long-coat and fedora \"gangster style\". Leather jacket wearing \"Greaser\" or the popular amongst females, short \
	and colorful dress wearing \"Flapper\" variety of clothing."

/obj/item/clothing/suit/storage/tajaran/cloak
	name = "commoner cloak"
	desc = "A tajaran cloak made with the middle class in mind, fancy but nothing special."
	icon = 'icons/obj/tajara_items.dmi'
	icon_state = "taj_commoncloak"
	item_state = "taj_commoncloak"
	contained_sprite = TRUE
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS

/obj/item/clothing/suit/storage/tajaran/cloak/fancy
	name = "royal cloak"
	desc = "A cloak fashioned from the best materials, meant for tajara of high standing."
	icon_state = "taj_fancycloak"
	item_state = "taj_fancycloak"

/obj/item/clothing/suit/storage/tajaran/nomad
	name = "adhomian wool coat"
	desc = "An adhomian coat, this one is a design commonly found among the Rhazar'Hrujmagh people."
	icon = 'icons/obj/tajara_items.dmi'
	icon_state = "zhan_coat"
	item_state = "zhan_coat"
	contained_sprite = TRUE

/obj/item/clothing/suit/storage/tajaran/messa
	name = "sun sister robe"
	desc = "A robe worn by the female priests of the S'rand'Marr religion."
	icon = 'icons/obj/tajara_items.dmi'
	icon_state = "messarobes"
	item_state = "messarobes"
	contained_sprite = TRUE
	description_fluff = "The official religious body of the S'rendarr & Messa religion  is reffered to as \"Parivara\" or roughly translated \"Family\". This branch is further split into \
	the female Sun Sisters and male Priest's of S'rendarr. Currently their main role is to act as mediator and to remain out of political matters, there is however a certain unspoken \
	agitation about the religion of Mata'ke and S'rrendars position within that pantheon. Further the Parivara has called multiple summits over the courses of war, which usually result \
	in temporary cease-fires from all sides."
	allowed = list(/obj/item/tank/emergency_oxygen,/obj/item/storage/bible,/obj/item/nullrod,/obj/item/reagent_containers/food/drinks/bottle/holywater)

/obj/item/clothing/suit/storage/tajaran/matake
	name = "Mata'ke priest mantle"
	desc = "A mantle worn by the priests of Mata'ke."
	icon = 'icons/obj/tajara_items.dmi'
	icon_state = "matakecoat"
	item_state = "matakecoat"
	contained_sprite = TRUE
	description_fluff = "The priesthood of Mata'ke is comprised of only men and strangely enough, hunters. Like their patron, all priests of Mata'ke must prove themselves capable, \
	practical, strong and masters of Adhomai wilderness. Every clan and temple of Mata'ke has a different way of testing its applicants and these tests are always kept as a strict \
	secret, the only thing known is that the majority of applicants never return. After they're accepted, priests of Mata'ke dress in furs and carry silver \
	weapons, usually daggers for ease of transport and to simulate Mata'ke's sword. There is a remarkably low amount of Njarir'Akhran in the Mata'ke priesthood."
	allowed = list(/obj/item/tank/emergency_oxygen,/obj/item/storage/bible,/obj/item/nullrod,/obj/item/reagent_containers/food/drinks/bottle/holywater)

/obj/item/clothing/suit/storage/hooded/tajaran
	name = "gruff cloak"
	desc = "A cloak designated for the lowest classes."
	icon = 'icons/obj/tajara_items.dmi'
	icon_state = "taj_cloak"
	item_state = "taj_cloak"
	contained_sprite = TRUE
	flags_inv = HIDETAIL
	hoodtype = /obj/item/clothing/head/winterhood
	description_fluff = "Today the fashion that dominates Adhomai shares few similarities to the clothing of old Furs, linen, hemp, silk and other such fabrics were traded for \
	synthetic versions, creating a massive boom in the nylon industry and textile industry in the cities. Jeans, overcoats, army uniforms, parade uniforms, flags, pants, shirts, ties, \
	suspenders, overalls are now the fashion of every Tajara from Nal'Tor to Kaltir. The protests of \"Old fashion\" supporters usually shatter against how effective and cheap it is to \
	make the human clothes are. There are a few notable branches, the long-coat and fedora \"gangster style\". Leather jacket wearing \"Greaser\" or the popular amongst females, short \
	and colorful dress wearing \"Flapper\" variety of clothing."

/obj/item/clothing/suit/storage/hooded/tajaran/priest
	name = "sun priest robe"
	desc = "A robe worn by male priests of the S'rand'marr religion."
	icon = 'icons/obj/tajara_items.dmi'
	icon_state = "priestrobe"
	item_state = "priestrobe"
	contained_sprite = TRUE
	flags_inv = 0
	allowed = list(/obj/item/tank/emergency_oxygen,/obj/item/storage/bible,/obj/item/nullrod,/obj/item/reagent_containers/food/drinks/bottle/holywater)
	description_fluff = "The official religious body of the S'rendarr & Messa religion  is reffered to as \"Parivara\" or roughly translated \"Family\". This branch is further split into \
	the female Sun Sisters and male Priest's of S'rendarr. Currently their main role is to act as mediator and to remain out of political matters, there is however a certain unspoken \
	agitation about the religion of Mata'ke and S'rrendars position within that pantheon. Further the Parivara has called multiple summits over the courses of war, which usually result \
	in temporary cease-fires from all sides."

/obj/item/clothing/head/tajaran
	icon = 'icons/obj/tajara_items.dmi'
	contained_sprite = TRUE
	description_fluff = "Today the fashion that dominates Adhomai shares few similarities to the clothing of old Furs, linen, hemp, silk and other such fabrics were traded for \
	synthetic versions, creating a massive boom in the nylon industry and textile industry in the cities. Jeans, overcoats, army uniforms, parade uniforms, flags, pants, shirts, ties, \
	suspenders, overalls are now the fashion of every Tajara from Nal'Tor to Kaltir. The protests of \"Old fashion\" supporters usually shatter against how effective and cheap it is to \
	make the human clothes are. There are a few notable branches, the long-coat and fedora \"gangster style\". Leather jacket wearing \"Greaser\" or the popular amongst females, short \
	and colorful dress wearing \"Flapper\" variety of clothing."

/obj/item/clothing/head/tajaran/circlet
	name = "golden dress circlet"
	desc = "A golden circlet with a pearl in the middle of it."
	icon_state = "taj_circlet"
	item_state = "taj_circlet"

/obj/item/clothing/head/tajaran/circlet/silver
	name = "silver dress circlet"
	desc = "A silver circlet with a pearl in the middle of it."
	icon_state = "taj_circlet_s"
	item_state = "taj_circlet_s"

/obj/item/clothing/head/tajaran/fur
	name = "adhomian fur hat"
	desc = "A typical tajaran hat, made with the fur of some adhomian animal."
	icon_state = "fur_hat"
	item_state = "fur_hat"

/obj/item/clothing/head/tajaran/matake
	name = "Mata'ke priest hat"
	desc = "An adorned religious crown used by Mata'ke priests."
	icon_state = "matakehat"
	item_state = "matakehat"
	description_fluff = "The priesthood of Mata'ke is comprised of only men and strangely enough, hunters. Like their patron, all priests of Mata'ke must prove themselves capable, \
	practical, strong and masters of Adhomai wilderness. Every clan and temple of Mata'ke has a different way of testing its applicants and these tests are always kept as a strict \
	secret, the only thing known is that the majority of applicants never return. After they're accepted, priests of Mata'ke dress in furs and carry silver \
	weapons, usually daggers for ease of transport and to simulate Mata'ke's sword. There is a remarkably low amount of Njarir'Akhran in the Mata'ke priesthood."

/obj/item/clothing/mask/tajara
	name = "sun sister veil"
	desc = "A veil worn by the female Priests of the S'rand'Marr religion."
	icon = 'icons/obj/tajara_items.dmi'
	icon_state = "veil"
	item_state = "veil"
	contained_sprite = TRUE

/obj/item/clothing/shoes/tajara
	name = "native tajaran foot-wear"
	desc = "Native foot and leg wear worn by Tajara, completely covering the legs in wraps and the feet in adhomian fabric."
	icon = 'icons/obj/tajara_items.dmi'
	icon_state = "adhomai_shoes"
	item_state = "adhomai_shoes"
	body_parts_covered = FEET|LEGS
	species_restricted = list("Tajara")
	contained_sprite = TRUE
	description_fluff = "Today the fashion that dominates Adhomai shares few similarities to the clothing of old Furs, linen, hemp, silk and other such fabrics were traded for \
	synthetic versions, creating a massive boom in the nylon industry and textile industry in the cities. Jeans, overcoats, army uniforms, parade uniforms, flags, pants, shirts, ties, \
	suspenders, overalls are now the fashion of every Tajara from Nal'Tor to Kaltir. The protests of \"Old fashion\" supporters usually shatter against how effective and cheap it is to \
	make the human clothes are. There are a few notable branches, the long-coat and fedora \"gangster style\". Leather jacket wearing \"Greaser\" or the popular amongst females, short \
	and colorful dress wearing \"Flapper\" variety of clothing."

//Vaurca clothing

/obj/item/clothing/suit/vaurca
	name = "hive cloak"
	desc = "A fashionable robe tailored for nonhuman proportions, this one is red and golden."
	icon = 'icons/obj/vaurca_items.dmi'
	icon_state = "robegold"
	item_state = "robegold"
	contained_sprite = TRUE
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS

/obj/item/clothing/suit/vaurca/silver
	desc = "A fashionable robe tailored for nonhuman proportions, this one is red and silver."
	icon_state = "robesilver"
	item_state = "robesilver"

/obj/item/clothing/suit/vaurca/brown
	desc = "A fashionable robe tailored for nonhuman proportions, this one is brown and silver."
	icon_state = "robebrown"
	item_state = "robebrown"

/obj/item/clothing/suit/vaurca/blue
	desc = "A fashionable robe tailored for nonhuman proportions, this one is blue and golden."
	icon_state = "robeblue"
	item_state = "robeblue"

/obj/item/clothing/suit/vaurca/shaper
	name = "shaper robes"
	desc = "Commonly worn by Preimmients, these robes are meant to catch pheromones, obfuscating hive affiliation."
	icon_state = "shaper_robes"
	item_state = "shaper_robes"
	species_restricted = list("Vaurca")

/obj/item/clothing/suit/vaurca/mantle
	name = "vaurcan mantle"
	desc = "This mantle is commonly worn in dusty underground areas, its wide upper covering acting as a kind of dust umbrella."
	icon_state = "vacmantle"
	item_state = "vacmantle"
	body_parts_covered = UPPER_TORSO

/obj/item/clothing/suit/vaurca/breeder
	name = "zo'ra representative clothes"
	desc = "A large piece of clothing used by Zo'ra representatives."
	icon = 'icons/mob/species/breeder/inventory.dmi'
	item_state = "representative_clothes"
	icon_state = "representative_clothes"
	contained_sprite = FALSE
	species_restricted = list("Vaurca Breeder")
	sprite_sheets = list("Vaurca Breeder" = 'icons/mob/species/breeder/suit.dmi')
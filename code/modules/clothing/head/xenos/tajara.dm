/obj/item/clothing/head/tajaran
	icon = 'icons/obj/tajara_items.dmi'
	contained_sprite = TRUE
	desc_fluff = "Today the fashion that dominates Adhomai shares few similarities to the clothing of old Furs, linen, hemp, silk and other such fabrics were traded for \
	synthetic versions, creating a massive boom in the nylon industry and textile industry in the cities. Jeans, overcoats, army uniforms, parade uniforms, flags, pants, shirts, ties, \
	suspenders, overalls are now the fashion of every Tajara from Nal'Tor to Kaltir. The protests of \"Old fashion\" supporters can't stand against how undeniably effective and cheap \
	to produce Human clothes are. There are a few notable branches, the long-coat and fedora \"gangster style\". Leather jacket wearing \"Greaser\" or the popular amongst females, short \
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
	desc_fluff = "The priesthood of Mata'ke is comprised of only men and strangely enough, hunters. Like their patron, all priests of Mata'ke must prove themselves capable, \
	practical, strong and masters of Adhomai wilderness. Every clan and temple of Mata'ke has a different way of testing its applicants and these tests are always kept as a strict \
	secret, the only thing known is that the majority of applicants never return. After they're accepted, priests of Mata'ke dress in furs and carry silver \
	weapons, usually daggers for ease of transport and to simulate Mata'ke's sword. There is a remarkably low amount of Njarir'Akhran in the Mata'ke priesthood."

/obj/item/clothing/head/tajaran/cosmonaut_commissar
	name = "kosmostrelki commissar hat"
	desc = "A peaked cap used by Party Commissars attached to kosmostrelki units."
	icon_state = "space_commissar_hat"
	item_state = "space_commissar_hat"
	desc_fluff = "Party Commissars are high ranking members of the Party of the Free Tajara under the Leadership of Hadii attached to army units, who ensures that soldiers and \
	their commanders follow the principles of Hadiism. Their duties are not only limited to enforcing the republican ideals among the troops and reporting possible subversive elements, \
	they are expected to display bravery in combat and lead by example."

/obj/item/clothing/head/tajaran/raskara
	name = "raskariim mask"
	desc = "A face concealing mask worn by the members of the cult of Raskara."
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR
	body_parts_covered = HEAD|FACE|EYES
	species_restricted = list("Tajara")
	icon_state = "raskara_mask"
	item_state = "raskara_mask"

/obj/item/clothing/head/tajaran/pra_beret
	name = "republican army beret"
	desc = "A green beret issued to republican soldiers."
	icon_state = "praberet"
	item_state = "praberet"

/obj/item/clothing/head/tajaran/pra_beret
	name = "service cap"
	desc = "A simple service cap worn by soldiers of the Adhomai Imperial Army."
	icon_state = "nkahat"
	item_state = "nkahat"

/obj/item/clothing/head/tajaran/consular
	name = "consular service cap"
	desc = "A service cap worn by the diplomatic service of the People's Republic of Adhomai."
	icon_state = "pra_consularhat"
	item_state = "pra_consularhat"

/obj/item/clothing/head/tajaran/consular/dpra
	desc = "A service cap worn by the diplomatic service of the Democratic People's Republic of Adhomai."
	icon_state = "dpra_consularhat"
	item_state = "dpra_consularhat"

/obj/item/clothing/head/tajaran/consular/nka
	name = "royal consular hat"
	desc = "A fancy hat worn by the diplomatic service of the New Kingdom of Adhomai."
	icon_state = "nka_consularhat"
	item_state = "nka_consularhat"

/obj/item/clothing/head/helmet/tajara
	name = "amohdan swordsmen helmet"
	desc = "A helmet used by the traditional warriors of Amohda."
	icon = 'icons/obj/tajara_items.dmi'
	icon_state = "amohdan_helmet"
	item_state = "amohdan_helmet"
	contained_sprite = TRUE
	body_parts_covered = HEAD|FACE|EYES
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR
	species_restricted = list("Tajara")
	armor = list(melee = 60, bullet = 50, laser = 20, energy = 10, bomb = 5, bio = 0, rad = 0)
	allow_hair_covering = FALSE
	desc_fluff = "The Feudal Era of Amohda is famous for the steel swords which became common. Many renowned swordsmen and famous warriors would travel the land fighting duels of \
	single combat in their quests to become the greatest swordsman. Modern Amohda is a mix between loyalists to the NKA and to the DPRA, with almost universal praise for a return to \
	traditional culture, yet often violent disagreement about the course of the island's political future. A sizable third party of monarchists which advocate the reestablishment of the \
	Imperial Amohdan dynasty also exists, fragmenting the monarchist factions on the island and further complicating political violence in the area."
	siemens_coefficient = 0.35

/obj/item/clothing/head/helmet/kettle
	name = "kettle helmet"
	desc = "A kettle helmet used by the forces of the new Kingdom of Adhomai."
	icon = 'icons/obj/tajara_items.dmi'
	icon_state = "kettle"
	item_state = "kettle"
	contained_sprite = TRUE
	armor = list(melee = 50, bullet = 50, laser = 20, energy = 10, bomb = 5, bio = 0, rad = 0)

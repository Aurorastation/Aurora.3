/datum/faction/idris_incorporated
	name = "Idris Incorporated"
	description = {"<p>
	The Orion Spur’s largest interstellar banking conglomerate, Idris Incorporated
	is operated by the mysterious Idris family. Idris Incorporated’s influence
	can be found in nearly every corner of human space with their financing of
	nearly every type of business and enterprise. Their higher risk ventures have
	payment enforced by the infamous Idris Reclamation Units, shell IPCs sent to
	claim payment from negligent loan takers. In recent years, they have begun
	diversifying into more service-based industries.
	</p>
	<p>Some character examples are:
	<ul>
	<li><b>Artisan Mixologist</b>: Impeccable customer service is at the heart of Idris;
	some of the best Chefs and Mixologists in the galaxy are employed by the
	corporation and the gleaming marble interiors of their branch offices are
	always spotless. This naturally comes at a price and tips are expected,
	always. No tips? A grave insult indeed to someone of your calibre! Whilst
	you're working with NanoTrasen it is expected that you seek to boost our clients credit
	portfolio- we'll give credit to anyone after all. The more loans you can
	generate with NanoTrasen the better. Just think of that bonus.</li>
	<li><b>Idris Reclamation Unit X3265FH</b>: As a shell belonging to Idris you
	are not free. You are programmed to defer to NT security and the Head of
	Security. Your customer service skills are excellent however your notorious
	"strong arm" skills can be utilised the security team if authorised. Your
	default state is good customer service. That being said your programming prioritises
	the protection and safety of other Idris employees so long as this will not
	breach NT regulations. You are programmed to never strong arm an Idris employee.
	You may be on lease to NT but remember you still belong to a much more sophisticated
	and superior company - Idris.</li>
	</ul></p>"}
	title_suffix = "Idris"

	allowed_role_types = list(
		/datum/job/officer,
		/datum/job/detective,
		/datum/job/bartender,
		/datum/job/chef,
		/datum/job/hydro,
		/datum/job/cargo_tech,
		/datum/job/qm,
		/datum/job/representative
	)

	allowed_species_types = list(
		/datum/species/human,
		/datum/species/skrell,
		/datum/species/machine,
		/datum/species/tajaran,
		/datum/species/diona
	)

	titles_to_loadout = list(
		"Security Officer" = /datum/outfit/job/officer/idris,
		"Bartender" = /datum/outfit/job/bartender/idris,
		"Chef" = /datum/outfit/job/chef/idris,
		"Cook" = /datum/outfit/job/chef/idris,
		"Detective" = /datum/outfit/job/detective/idris,
		"Gardener" = /datum/outfit/job/hydro/idris,
		"Hydroponicist" = /datum/outfit/job/hydro/idris,
		"Cargo Technician" = /datum/outfit/job/cargo_tech/idris,
		"Quartermaster" = /datum/outfit/job/qm/idris,
		"Corporate Liaison" = /datum/outfit/job/representative/idris
	)

/datum/outfit/job/officer/idris
	name = "Security Officer - Idris"
	uniform = /obj/item/clothing/under/rank/security/idris
	id = /obj/item/card/id/idris/sec

/datum/outfit/job/detective/idris
	name = "Detective - Idris"
	uniform = /obj/item/clothing/under/rank/security/idris
	id = /obj/item/card/id/idris/sec

/datum/outfit/job/bartender/idris
	name = "Bartender - Idris"
	uniform = /obj/item/clothing/under/rank/idris/service
	id = /obj/item/card/id/idris

/datum/outfit/job/chef/idris
	name = "Chef - Idris"
	uniform = /obj/item/clothing/under/rank/idris/service
	id = /obj/item/card/id/idris

/datum/outfit/job/hydro/idris
	name = "Gardener - Idris"
	uniform = /obj/item/clothing/under/rank/idris/service
	id = /obj/item/card/id/idris

/datum/outfit/job/cargo_tech/idris
	name = "Cargo Technician - Idris"
	uniform = /obj/item/clothing/under/rank/idris/service
	id = /obj/item/card/id/idris

/datum/outfit/job/qm/idris
	name = "Quartermaster - Idris"
	uniform = /obj/item/clothing/under/rank/idris/service
	id = /obj/item/card/id/idris


/datum/outfit/job/representative/idris
	name = "Idris Corporate Liaison"
	uniform = /obj/item/clothing/under/rank/idris
	head = null
	suit = null
	implants = null
	id = /obj/item/card/id/idris

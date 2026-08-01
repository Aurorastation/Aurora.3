/singleton/origin_item/culture/biesellite
	name = "Biesellite"
	desc = "Relatively new compared to other cultures across the Orion Spur, the Biesellite culture was forged from the fire borne by its independence. Since its inception, it has continued to evolve, especially with the recent expansion of the Republic of Biesel into the Solarian Alliance's Outer Ring after its abandonment during the collapse. Despite its recent acquisition, the Corporate Reconstruction Zone as it is now known has begun adjusting and blending their own cultures into the Biesellite way of life, those not bending the knee and aligning are often bastions of insurgency and unrest."
	possible_origins = list(
		/singleton/origin_item/origin/biesel,
		/singleton/origin_item/origin/new_gibson,
		/singleton/origin_item/origin/reade,
		/singleton/origin_item/origin/valkyrie
	)

/singleton/origin_item/origin/biesel
	name = "Biesel"
	desc = "One of the first colonies outside of the Sol System, Biesel has since flourished into an economic and cultural powerhouse within the greater Orion Spur, and sets the cultural benchmark for the greater Republic of Biesel. Many of Biesel's inhabitants reside within Mendell City, a large metropolis that stretches across the plains of Biesel, and has various districts each with its own culture."
	possible_accents = list(ACCENT_CETI)
	possible_citizenships = list(CITIZENSHIP_BIESEL, CITIZENSHIP_SOL)
	possible_religions = RELIGIONS_BIESEL

/singleton/origin_item/origin/new_gibson
	name = "New Gibson"
	desc = "New Gibson is the largest moon of Reade and the Industrial Heart of Tau Ceti. Historically, it has been neglected by both the Solarian Alliance and the Republic of Biesel, dealing with crisis after crisis. As such, its people are hardened, insular, and often resentful. However, they are experts at their crafts, be it mining, engineering, or phoronics."
	possible_accents = list(ACCENT_GIBSON)
	possible_citizenships = list(CITIZENSHIP_BIESEL, CITIZENSHIP_SOL)
	possible_religions = RELIGIONS_BIESEL
	origin_traits = list(TRAIT_ORIGIN_COLD_RESISTANCE)
	origin_traits_descriptions = list("are more acclimatised to the cold.")

/singleton/origin_item/origin/reade
	name = "Reade"
	desc = "A gas giant in outer Tau Ceti, home to both platforms within the planet's atmosphere and countless smaller outposts in orbit and on its many moons. A fledgling culture defined by company and military towns can be found within the non-unified Reade's atmosphere, with city state-like platforms competing with one another and responsible for much of the Republic of Biesel's military shipbuilding. In orbit and among its moons, smaller off-worlder communities can be found."
	possible_accents = list(ACCENT_READE)
	possible_citizenships = list(CITIZENSHIP_BIESEL, CITIZENSHIP_SOL)
	possible_religions = RELIGIONS_BIESEL

/singleton/origin_item/origin/valkyrie
	name = "Valkyrie"
	desc = "Lighting up the night sky of Biesel, Valkyrie is an incredibly important port of trade within Tau Ceti, and hosts a significant amount of megacorporate facilities within its orbit, on its surface, as well as deep within the canyons and crevices. Valkyrie has not been spared by the multiculturalism that has dispersed across Tau Ceti, and actively encourages it through their incredibly relaxed immigration policies that allow for a remarkable amount of diversity to exist."
	possible_accents = list(ACCENT_VALKYRIE)
	possible_citizenships = list(CITIZENSHIP_BIESEL, CITIZENSHIP_SOL)
	possible_religions = RELIGIONS_BIESEL

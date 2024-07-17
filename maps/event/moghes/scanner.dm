/obj/machinery/computer/terminal/scanner
	name = "\improper Zeng-Hu Analysis Terminal"
	desc = "A terminal designed to collect and process environmental data, often used by Zeng-Hu planetary survey teams. Bioscanner and survey probe reports, as well as various samples, papers, and data disks from the area, can be inserted into this terminal in order to collect a complete environmental survey of the region."
	desc_info = "There are many scannable and sampleable items within the Izilukh region. Though duplicate data can still be added, a more complete report will be provided if you bring a wide variety of samples. How thorough your exploration and research is will affect both the final result of the analysis, and the future of the humanitarian project. Explore, and see what you can find."
	icon_screen = "gyrotron_screen"
	icon_keyboard = "tech_key"
	var/scan_progress = 0
	var/list/scanned = list()

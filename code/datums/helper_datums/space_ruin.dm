/datum/space_ruin
    var/name
    var/file_name
    var/weight = 1
    var/list/valid_maps = null
    var/list/characteristics = null

/datum/space_ruin/New(var/i_name, var/i_file_name)
    name = i_name
    file_name = i_file_name

/datum/space_ruin/proc/get_contact_report()
    var/list/schar = sortList(characteristics) //Sort them alphabetically to avoid metaing based on the order
    var/ruintext = "<center><img src = ntlogo.png><br><h2><br><b>Icarus Reading Report</h2></b></FONT size><HR></center>"
    ruintext += "<b><font face='Courier New'>The Icarus sensors located a away site with the possible characteristics:</font></b><br><ul>"

    for(var/characteristic in schar)
        if(prob(characteristics[characteristic]))
            ruintext += "<li>[characteristic]</li>"

    ruintext += "</ul><HR>"

    ruintext += "<b><font face='Courier New'>This reading has been detected within shuttle range of the [current_map.station_name] and deemed safe for survey by [current_map.company_name] personnel. \
    The designated research director, or a captain level decision may determine the goal of any missions to this site. On-site command is deferred to any nearby command staff.</font></b><br>"

    return ruintext
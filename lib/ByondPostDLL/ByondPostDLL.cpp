/*
	Copyright (C) 2016 Oisin Carr & Skull132

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#include <curl\curl.h>

extern "C" __declspec(dllexport) char *send_post_request(int argc, char *argv[])
{
	if (argc < 2)
	{
		return "proc=1";
	}

	curl_global_init(CURL_GLOBAL_DEFAULT);
	CURL *curl = curl_easy_init();

	if (!curl)
	{
		return "proc=2";
	}

	// Initialize variables.
	static char return_value[32];
	long http_code = 0;
	CURLcode res;
	struct curl_slist *chunk = NULL;

	for (int i = 2; i < argc; i++)
	{
		chunk = curl_slist_append(chunk, argv[i]);
	}

	// Set curl options.
	curl_easy_setopt(curl, CURLOPT_URL, argv[0]);

	curl_easy_setopt(curl, CURLOPT_HTTPHEADER, chunk);
	curl_easy_setopt(curl, CURLOPT_POST, 1L);

	char *data = argv[1];

	curl_easy_setopt(curl, CURLOPT_POSTFIELDS, data);

	// Save the response.
	res = curl_easy_perform(curl);

	// Get the response code and save it to http_code.
	curl_easy_getinfo(curl, CURLINFO_RESPONSE_CODE, &http_code);

	// Clean up the session info.
	curl_global_cleanup();

	// Create the feedback message.
	// Format used is key=value&key=value.
	snprintf(return_value, 32, "http=%d&curl=%d", http_code, res);

	return return_value;
}

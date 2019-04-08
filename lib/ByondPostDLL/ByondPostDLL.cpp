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

#define EXTERN_DLL_EXPORT extern "C" __declspec(dllexport)

#include <string>
#include <thread>
#include <iostream>
#include <fstream>

using namespace std;

// Global buffer for the GET request callback.
static string getBuffer;

// Helper function prototypes. Definitions at the bottom.
CURL *SetupCurl(char *url, struct curl_slist *header);
void LogException(exception& e);
static size_t WriteCallback(void *contents, size_t size, size_t nmemb, void *userp);

EXTERN_DLL_EXPORT char *send_post_request(int argc, char *argv[])
{
	if (argc < 2)
	{
		return "proc=1";
	}

	// Giant try-catch block, for simplicity sake.
	try
	{
		// Initialize variables.
		CURL *curl = NULL;
		static char return_value[33] = {0};
		long http_code = 0;
		CURLcode res;
		struct curl_slist *headers = NULL;

		for (int i = 2; i < argc; i++)
		{
			headers = curl_slist_append(headers, argv[i]);
		}

		// Set up cURL.
		curl = SetupCurl(argv[0], headers);

		if (!curl)
		{
			return "proc=2";
		}

		// Set additional cURL options.
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
	catch (exception& e)
	{
		// Catch any exceptions that are encountered and log them.
		LogException(e);

		return "proc=3";
	}
}

EXTERN_DLL_EXPORT char *send_get_request(int argc, char *argv[])
{
	// If you're not using this with at least 1 custom header, why /are/ you using it?
	// Use world.Export() instead you dolt.
	if (argc < 2)
	{
		return "proc=1";
	}

	// Catch any exceptions you find.
	try
	{
		// Initialize variables.
		getBuffer.clear();

		CURL *curl = NULL;
		long http_code = 0;
		CURLcode res;
		struct curl_slist *headers = NULL;

		// Generate headers.
		for (int i = 1; i < argc; i++)
		{
			headers = curl_slist_append(headers, argv[i]);
		}

		// Initialize cURL.
		curl = SetupCurl(argv[0], headers);

		if (!curl)
		{
			return "proc=2";
		}

		// Set additional options.
		curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteCallback);
		curl_easy_setopt(curl, CURLOPT_WRITEDATA, &getBuffer);

		// Save the response.
		res = curl_easy_perform(curl);

		// Get the response code and save it to http_code.
		curl_easy_getinfo(curl, CURLINFO_RESPONSE_CODE, &http_code);

		// Clean up the session info.
		curl_global_cleanup();

		if (res != CURLE_OK || http_code != 200)
		{
			static char return_value[33] = { 0 };
			// Create the feedback message.
			// Format used is key=value&key=value.
			snprintf(return_value, 32, "http=%d&curl=%d", http_code, res);

			return return_value;
		}
		else
		{
			// No error, return the body.
			return (char *)getBuffer.c_str();
		}
	}
	catch (exception& e)
	{
		LogException(e);

		return "proc=3";
	}
}

/**
 * A function to set up a CURL object.
 *
 * Expects a URL and a header. Header can be NULL.
 * Will also run curl_global_init() with default settings.
 *
 * Will return a pointer to the CURL object. NULL upon failure.
 */
CURL *SetupCurl(char *url, struct curl_slist *header)
{
	CURL *curl = NULL;

	if (!url || !strlen(url))
	{
		return NULL;
	}

	// Run cURL global init.
	curl_global_init(CURL_GLOBAL_DEFAULT);

	// Easy init the thing itself.
	curl = curl_easy_init();

	// Init failed. RIP.
	if (!curl)
	{
		return NULL;
	}

	// Set timeout to 2 seconds per request.
	curl_easy_setopt(curl, CURLOPT_TIMEOUT, 2L);

	// Set the URL.
	curl_easy_setopt(curl, CURLOPT_URL, url);

	// If we have headers, set them.
	if (header)
	{
		curl_easy_setopt(curl, CURLOPT_HTTPHEADER, header);
	}

	return curl;
}

/**
 * Function for exception logging.
 *
 * Excepts an exception reference as an argument.
 */
void LogException(exception& e)
{
	ofstream fp;

	fp.open("CURL-ERROR.txt");

	if (fp.is_open())
	{
		fp << e.what() << std::endl;
		fp.close();
	}

	return;
}

/**
 * A callback function that cURL uses for writing down request results.
 */
static size_t WriteCallback(void *contents, size_t size, size_t nmemb, void *userp)
{
	size_t realsize = size *nmemb;
	getBuffer.append((char *)contents, realsize);

	return realsize;
}

/**
* Copyright (c) 2017 "Werner Maisl"
*
* This file is part of Aurora.3
* Aurora.3 is free software: you can redistribute it and/or modify
* it under the terms of the GNU Affero General Public License as
* published by the Free Software Foundation, either version 3 of the
* License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU Affero General Public License for more details.
*
* You should have received a copy of the GNU Affero General Public License
* along with this program. If not, see <http://www.gnu.org/licenses/>.
*
*/

#define EXTERN_DLL_EXPORT extern "C" __declspec(dllexport)

#include <fstream>

#include "boost/asio.hpp"
using namespace boost::asio;

// Expects 3 Args:
// Arg 1: Destination IP
// Arg 2: Destination Port
// Arg 3: Message String
EXTERN_DLL_EXPORT const char *send_udp_data(int argc, char *argv[])
{
	std::ofstream myfile;


	try
	{
		if (argc < 3)
		{
			return "proc=2";
		}

		int port = std::stoi(argv[1]);

		io_service io_service;
		ip::udp::socket socket(io_service);
		ip::udp::endpoint remote_endpoint;
		socket.open(ip::udp::v4());

		remote_endpoint = ip::udp::endpoint(ip::address::from_string(argv[0]), port);

		boost::system::error_code err;

		size_t request_length = strlen(argv[2]);

		socket.send_to(buffer(argv[2], request_length), remote_endpoint, 0, err);

		socket.close();
		myfile.close();
		return "proc=0";
	}
	catch (std::exception& ex)
	{
		myfile.open("UDP-ERROR.txt");
		myfile << ex.what() << std::endl;
		myfile.close();
		return ex.what();
	}
}

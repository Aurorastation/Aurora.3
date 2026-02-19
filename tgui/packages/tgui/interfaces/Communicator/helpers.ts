import { Address, CommunicatorData } from './types';

export function GetUserByAddress(data: CommunicatorData, address: Address) {
  return data.allUsers.find((user) => user.address === address);
}

export function GetUserByName(data: CommunicatorData, name: string) {
  return data.allUsers.find((user) => user.username === name);
}

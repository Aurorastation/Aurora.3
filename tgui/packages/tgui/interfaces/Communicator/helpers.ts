import type { ActiveUser, CommunicatorData, UserDetails } from './types';

const MAX_ADDRESS_CHARACTERS = 16;

export function FormatAddress(newValue: string) {
  const alphanumeric = newValue
    .toLowerCase()
    .replaceAll(/[^0-9a-z]/g, '')
    .slice(0, MAX_ADDRESS_CHARACTERS);
  return alphanumeric.match(/\w{1,4}/g)?.join(':') || alphanumeric;
}

export function GetUserByAddress(data: CommunicatorData, address: string) {
  return data.allUsers.find((user) => user.address === address);
}

export function GetUserByName(data: CommunicatorData, name: string) {
  return data.allUsers.find((user) => user.username === name);
}

export function SortUsersByName<T extends UserDetails>(userList: T[]) {
  return [...userList].sort((userA, userB) => {
    const nameA = userA.username.toLowerCase();
    const nameB = userB.username.toLowerCase();
    if (nameA < nameB) {
      return -1;
    }
    if (nameA > nameB) {
      return 1;
    }
    return 0;
  });
}

export function UserIsActive(user: UserDetails): user is ActiveUser {
  return (user as ActiveUser).visible !== undefined;
}

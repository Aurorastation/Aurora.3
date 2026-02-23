import { CommunicatorData, ActiveUser, UserDetails } from './types';

export function GetUserByAddress(data: CommunicatorData, address: string) {
  return data.allUsers.find((user) => user.address === address);
}

export function GetUserByName(data: CommunicatorData, name: string) {
  return data.allUsers.find((user) => user.username === name);
}

export function SortUsersByName<T extends UserDetails>(userList: T[]) {
  return userList.sort((userA, userB) => {
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

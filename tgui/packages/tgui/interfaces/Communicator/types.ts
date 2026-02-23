import { BooleanLike } from 'common/react';

export type CommunicatorData = {
  noID?: BooleanLike;
  currentTab: CommunicatorTab;
  ringerOn: BooleanLike;

  callDuration: string;
  callSettings: CallSettings;

  friendsList: FriendsList;
  connectedCallers: string[];
  callRequests: RequestsList;
  videoRequests: RequestsList;
  friendRequests: RequestsList;

  userComm: ActiveUser;
  allUsers: ActiveUser[];
};

type CallSettings = {
  speakerphoneOn: BooleanLike;
  microphoneOn: BooleanLike;
};

type FriendsList = {
  active: ActiveUser[];
  missing: UserDetails[];
};

type RequestsList = {
  incoming: string[];
  outgoing: string[];
};

export interface UserDetails {
  address: string;
  username: string;
}

export interface ActiveUser extends UserDetails {
  visible: BooleanLike;
  connectingToAddr: string;
}

// Mirror of the defines in 'code/modules/modular_computers/file_system/programs/generic/communicator/calls.dm'.
export enum CommunicatorTab {
  Home,
  Phone,
  Contacts,
  Messaging,
  Settings,
  ActiveCall,
}

export type App = {
  name: string;
  icon: string;
  tab: CommunicatorTab;
};

const PhoneApp: App = {
  name: 'Phone',
  icon: 'phone',
  tab: CommunicatorTab.Phone,
};

const ContactsApp: App = {
  name: 'Contacts',
  icon: 'user',
  tab: CommunicatorTab.Contacts,
};

const MessagingApp: App = {
  name: 'Messaging',
  icon: 'comment-alt',
  tab: CommunicatorTab.Messaging,
};

const SettingsApp: App = {
  name: 'Settings',
  icon: 'cog',
  tab: CommunicatorTab.Settings,
};

export const Apps = [PhoneApp, ContactsApp, MessagingApp, SettingsApp];

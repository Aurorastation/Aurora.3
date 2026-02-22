import { BooleanLike } from 'common/react';

export type CommunicatorData = {
  noID?: BooleanLike;
  currentTab: CommunicatorTab;
  ringerOn: BooleanLike;

  connectingToCall: BooleanLike;
  callDuration: string;
  callSettings: CallSettings;

  friendsList: string[]; // List of friend names
  connectedCallers: string[];
  callRequests: RequestsList;
  videoRequests: RequestsList;
  friendRequests: RequestsList;

  userComm: User;
  allUsers: User[];
};

type CallSettings = {
  speakerphoneOn: BooleanLike;
  microphoneOn: BooleanLike;
};

type RequestsList = {
  incoming: string[];
  outgoing: string[];
};

export type User = {
  address: string;
  username: string;
  visible: BooleanLike;
};

// Mirror of the defines in 'code/modules/modular_computers/file_system/programs/generic/communicator.dm'.
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

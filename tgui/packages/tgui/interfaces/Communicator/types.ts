// Type alias for exonet addresses, to make things a little easier to understand
export type Address = string;

export type CommunicatorData = {
  currentTab: CommunicatorTab;
  callDuration: string;
  callSettings: CallSettings;

  friendsList: string[]; // List of friend names
  connectedCallers: string[];
  callRequests: RequestsList;
  videoRequests: RequestsList;
  friendRequests: RequestsList;

  user?: User;
  allUsers: User[];
};

type CallSettings = {
  speakerphoneOn: boolean;
  microphoneOn: boolean;
};

type RequestsList = {
  incoming: string[];
  outgoing: string[];
};

export type User = {
  address: Address;
  username: string;
  visible: boolean;
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

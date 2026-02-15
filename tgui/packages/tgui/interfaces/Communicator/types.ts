// Type alias for exonet addresses, to make things a little easier to understand
export type Address = string;

export type CommunicatorData = {
  callRequests: RequestsList;
  videoRequests: RequestsList;
  friendRequests: RequestsList;

  friendsList: User[];
  user?: User;
  allUsers: User[];
};

type RequestsList = {
  incoming: string[];
  outgoing: string[];
};

export type User = {
  address: Address;
  username: string;
  visible: boolean;
  ref: string;
};

export enum CommunicatorTab {
  Home,
  Phone,
  Contacts,
  Messaging,
  Settings,
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

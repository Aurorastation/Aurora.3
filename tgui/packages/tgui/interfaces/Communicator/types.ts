// Type alias for exonet addresses, to make things a little easier to understand
export type Address = string;

export type CommunicatorData = {
  callRequests: RequestsList;
  videoRequests: RequestsList;
  friendRequests: RequestsList;

  friendsList: Contact[];
  user: User;
  allUsers: User[];
};

type RequestsList = {
  incoming: Address[];
  outgoing: Address[];
};

type User = {
  username: string;
  address: Address;
  visible: boolean;
  ref: string;
};

export type Contact = {
  address: Address;
  name: string;
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

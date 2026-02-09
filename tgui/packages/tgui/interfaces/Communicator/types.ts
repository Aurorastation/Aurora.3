import { BooleanLike } from 'common/react';

// Type alias for exonet addresses, to make things a little easier to understand
type Address = string;

export type CommunicatorData = {
  ownerName: string;
  ownerOccupation: string;

  incomingCalls: CommContact[];
  outgoingCalls: CommContact[];
  connectedCallers: {
    ownerName: string;
    ref: string;
  };
  flashlightOn: BooleanLike;

  time: string;
  connectionStatus: BooleanLike;
};

export type ContactsTabData = {
  friendsList: CommContact[];
  incomingFriendRequests: Address[];
  outgoingFriendRequests: Address[];
  publicDevices: CommContact[];
};

export type CommContact = {
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

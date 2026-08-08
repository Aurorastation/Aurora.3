import type { BooleanLike } from 'tgui-core/react';

// #region Data types

type Address = string;

export type CommunicatorData = {
  noID?: BooleanLike;
  canReset: BooleanLike;
  currentTab: CommunicatorTab;
  silent: BooleanLike;
	observer: BooleanLike;
	deviceTierName: string;
	registeredIdName: string | null;

  activeCall?: VoiceCall;
  activeChats: TextChat[];
  callSettings: CallSettings;

  friendsList: FriendsList;
  callRequests: RequestsList;
  friendRequests: RequestsList;
  featureRequests: FeatureRequest[];

  userComm: ActiveUser;
  allUsers: ActiveUser[];
};

type CallSettings = {
  speakerphoneOn: BooleanLike;
  microphoneOn: BooleanLike;
  videoOn: BooleanLike;
  hologramOn: BooleanLike;
  canVideo: BooleanLike;
  canHologram: BooleanLike;
  videoPending: BooleanLike;
  hologramPending: BooleanLike;
};

export type RequestsList = {
  incoming: Address[];
  outgoing: Address[];
};

export type FeatureRequest = {
  address: Address;
  feature: 'video' | 'hologram';
};

type FriendsList = {
  active: ActiveUser[];
  missing: UserDetails[];
};

type VoiceCall = {
  connectedComms: Address[];
  duration: string;
};

export type TextChat = {
  chatTarget: Address;
  targetName: string;
  messages: TextMessage[];
};

type TextMessage = {
  content: string;
  senderAddress: string;
  timeSent: string;
};

export interface UserDetails {
  address: string;
  username: string;
}

export interface ActiveUser extends UserDetails {
  visible: BooleanLike;
  connectingToAddr: string | null;
  tier: CommunicatorTier;
}

export enum CommunicatorTier {
  Basic = 1,
  Video,
  Holographic,
}

// #endregion
// #region Interface types

// Mirror of the defines in 'code/__DEFINES/communicator.dm'.
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
  name: 'Messages',
  icon: 'comment-alt',
  tab: CommunicatorTab.Messaging,
};

const SettingsApp: App = {
  name: 'Settings',
  icon: 'cog',
  tab: CommunicatorTab.Settings,
};

export const Apps = [PhoneApp, ContactsApp, MessagingApp, SettingsApp];

// #endregion

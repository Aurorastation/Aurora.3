import { BooleanLike } from "common/react";

export type CommunicatorData = {
  ownerName: string;
  ownerOccupation: string;

  incomingCalls: CallTarget[];
  outgoingCalls: CallTarget[];
  connectedCallers: {
    ownerName: string;
    ref: string;
  };
  flashlightOn: BooleanLike;

  time: string;
  connectionStatus: BooleanLike;
};

type CallTarget = {
  address: string;
  name: string;
};

export enum CommunicatorTab {
  Home,
  Phone,
  Contacts,
  Messaging,
  Settings
}

export type App = {
  name: string;
  icon: string;
  tab: CommunicatorTab;
}

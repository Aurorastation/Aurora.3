import './styles/main.scss';

import { useEffect, useReducer, useRef, useState } from 'react';

import { playCloseSounds, playOpenSounds } from './audio';
import { AdminPage } from './pages/AdminPage';
import { HomePage } from './pages/HomePage';
import { LeaveBodyPage } from './pages/LeaveBodyPage';
import { PlayersPage } from './pages/PlayersPage';
import { QuitPage } from './pages/QuitPage';

type Page = 'home' | 'admin' | 'players' | 'leave_body' | 'quit';

export type PlayerInfo = {
  ckey: string;
  displayName: string;
  rank?: string;
  ping?: number;
};

export type ServerState = {
  stationName: string;
  roundId: string;
  mapName: string;
  serverTime: string;
  shiftTime: string;
  timeDilation: string;
  canLeaveBody: boolean;
  canAdminHelp: boolean;
  isLobby: boolean;
  isReady: boolean;
  joinLabel: string;
  canJoin: boolean;
  canManifest: boolean;
  lobbyBackgrounds: string[];
  lobbyTransitionMs: number;
  lobbyMenuSound: string;
  lobbyButtonIcons: {
    join: string;
    character: string;
    manifest: string;
    observe: string;
    changelog: string;
    polls: string;
    lore: string;
  };
  resources: ResourceLink[];
  admins: PlayerInfo[];
  players: PlayerInfo[];
};

export type ResourceLink = {
  id: string;
  label: string;
  tooltip: string;
};

type State = {
  page: Page;
  isOpen: boolean;
  showResources: boolean;
  serverState: ServerState | null;
};

type Action =
  | { type: 'open' }
  | { type: 'close' }
  | { type: 'navigate'; page: Page }
  | { type: 'toggleResources' }
  | { type: 'serverUpdate'; state: Partial<ServerState> };

function reducer(state: State, action: Action): State {
  switch (action.type) {
    case 'open':
      return { ...state, isOpen: true };
    case 'close':
      return { ...state, isOpen: false, page: 'home', showResources: false };
    case 'navigate':
      return { ...state, page: action.page, showResources: false };
    case 'toggleResources':
      return { ...state, showResources: !state.showResources };
    case 'serverUpdate':
      return {
        ...state,
        serverState: { ...state.serverState!, ...action.state },
      };
  }
}

const initialState: State = {
  page: 'home',
  isOpen: false,
  showResources: false,
  serverState: null,
};

function sendAction(action: string, payload?: Record<string, unknown>) {
  Byond.sendMessage('action', { action, ...payload });
}

let resizeFrozen = false;
export function isResizeFrozen() {
  return resizeFrozen;
}

function openMenu(dispatch: React.Dispatch<Action>, silent = false) {
  setTimeout(() => {
    resizeFrozen = false;
  }, 100);
  Byond.winset('mapwindow.escape_menu', { 'is-visible': true });
  if (!silent) {
    playOpenSounds();
  }
  sendAction('opened');
  dispatch({ type: 'open' });
}

function closeMenu(
  dispatch: React.Dispatch<Action>,
  silent = false,
  notifyServer = true,
) {
  resizeFrozen = true;
  Byond.winset('mapwindow.escape_menu', { 'is-visible': false });
  Byond.winset('map', { focus: true });
  if (!silent) {
    playCloseSounds();
  }
  if (notifyServer) {
    sendAction('closed');
  }
  dispatch({ type: 'close' });
}

export function EscapeMenu() {
  const [state, dispatch] = useReducer(reducer, initialState);
  const isOpenRef = useRef(false);
  const isLobbyRef = useRef(false);
  isOpenRef.current = state.isOpen;
  isLobbyRef.current = state.serverState?.isLobby ?? false;

  useEffect(() => {
    Byond.subscribeTo('init', (data: ServerState) => {
      dispatch({ type: 'serverUpdate', state: data });
    });

    Byond.subscribeTo('state', (data: Partial<ServerState>) => {
      dispatch({ type: 'serverUpdate', state: data });
    });

    Byond.subscribeTo('open', (data?: { silent?: boolean }) => {
      if (!isOpenRef.current) {
        openMenu(dispatch, data?.silent);
      }
    });

    Byond.subscribeTo('close', (data?: { silent?: boolean }) => {
      if (isOpenRef.current) {
        closeMenu(dispatch, data?.silent, false);
      }
    });

    Byond.subscribeTo('toggle', () => {
      if (isLobbyRef.current && isOpenRef.current) {
        sendAction('toggle_request');
        return;
      }
      if (isOpenRef.current) {
        closeMenu(dispatch);
      } else {
        openMenu(dispatch);
      }
    });
  }, []);

  if (!state.serverState) {
    return null;
  }

  const navigate = (page: Page) => dispatch({ type: 'navigate', page });

  const handleAction = (action: string, payload?: Record<string, unknown>) => {
    sendAction(action, payload);
  };

  const handleClose = () => {
    if (!state.serverState!.isLobby) {
      closeMenu(dispatch);
    }
  };

  const refocusMap = () => {
    Byond.winset('map', { focus: true });
  };

  return (
    <div
      className={
        'escape-menu' +
        (state.serverState.isLobby ? ' escape-menu--lobby' : '')
      }
      onClick={refocusMap}
    >
      <LobbyBackground serverState={state.serverState} />
      <div className="escape-menu__overlay" />
      <div className="escape-menu__content">
        <Details serverState={state.serverState} />
        {state.page === 'home' && (
          <HomePage
            serverState={state.serverState}
            onNavigate={navigate}
            onAction={handleAction}
            onClose={handleClose}
            showResources={state.showResources}
            onToggleResources={() => dispatch({ type: 'toggleResources' })}
          />
        )}
        {state.page === 'admin' && (
          <AdminPage
            serverState={state.serverState}
            onNavigate={navigate}
            onAction={handleAction}
            onClose={handleClose}
          />
        )}
        {state.page === 'players' && (
          <PlayersPage serverState={state.serverState} onNavigate={navigate} />
        )}
        {state.page === 'leave_body' && (
          <LeaveBodyPage
            onNavigate={navigate}
            onAction={handleAction}
            onClose={handleClose}
          />
        )}
        {state.page === 'quit' && (
          <QuitPage onNavigate={navigate} onAction={handleAction} />
        )}
      </div>
    </div>
  );
}

function LobbyBackground({ serverState }: { serverState: ServerState }) {
  const [activeIndex, setActiveIndex] = useState(0);
  const backgrounds = serverState.lobbyBackgrounds;

  useEffect(() => {
    setActiveIndex(0);
    if (backgrounds.length < 2 || !serverState.lobbyTransitionMs) {
      return;
    }
    const timer = setInterval(() => {
      setActiveIndex((index) => (index + 1) % backgrounds.length);
    }, serverState.lobbyTransitionMs);
    return () => clearInterval(timer);
  }, [backgrounds.join('|'), serverState.lobbyTransitionMs]);

  return (
    <div className="escape-menu__background">
      {backgrounds.map((background, index) => (
        <span
          key={background}
          className={
            `escape-menu__background-frame ${background}` +
            (index === activeIndex
              ? ' escape-menu__background-frame--active'
              : '')
          }
        />
      ))}
    </div>
  );
}

function Details({ serverState }: { serverState: ServerState }) {
  return (
    <div className="escape-menu__details">
      <div>Round ID: {serverState.roundId || 'Unset'}</div>
      <div>Server Time: {serverState.serverTime}</div>
      <div>Shift Time: {serverState.shiftTime}</div>
      <div>Map: {serverState.mapName || 'Loading...'}</div>
      <div>Time Dilation: {serverState.timeDilation}%</div>
    </div>
  );
}

import { useEffect, useState } from 'react';
import { Tooltip } from 'tgui-core/components';

import { playLobbyButtonSound } from '../audio';
import type { ServerState } from '../EscapeMenu';

type HomeServerState = Pick<
  ServerState,
  | 'stationName'
  | 'canLeaveBody'
  | 'canAdminHelp'
  | 'isLobby'
  | 'isReady'
  | 'joinLabel'
  | 'canJoin'
  | 'canManifest'
  | 'lobbyButtonIcons'
  | 'lobbyMenuSound'
  | 'resources'
>;

type Props = {
  serverState: HomeServerState;
  onNavigate: (page: 'admin' | 'players' | 'leave_body' | 'quit') => void;
  onAction: (action: string) => void;
  onClose: () => void;
  showResources: boolean;
  onToggleResources: () => void;
};

const COLLAPSE_DURATION = 400;

export function HomePage({
  serverState,
  onNavigate,
  onAction,
  onClose,
  showResources,
  onToggleResources,
}: Props) {
  const [mounted, setMounted] = useState(false);
  const [collapsing, setCollapsing] = useState(false);

  useEffect(() => {
    if (showResources) {
      setMounted(true);
      setCollapsing(false);
    } else if (mounted) {
      setCollapsing(true);
      const timer = setTimeout(() => {
        setMounted(false);
        setCollapsing(false);
      }, COLLAPSE_DURATION);
      return () => clearTimeout(timer);
    }
  }, [showResources]);

  return (
    <>
      <div className="escape-menu__home-column">
        <div className="escape-menu__title">
          <div className="escape-menu__subtitle">Another day on...</div>
          <div className="escape-menu__station-name">
            {serverState.stationName}
          </div>
        </div>
        <div
          className={
            'escape-menu__buttons' +
            (serverState.isLobby
              ? ' escape-menu__buttons--lobby'
              : ' escape-menu__buttons--ingame')
          }
        >
          {serverState.isLobby ? (
            <>
              <MenuButton
                onClick={() => onAction('lobby_join')}
                disabled={!serverState.canJoin}
                ready={serverState.isReady}
                iconClass={serverState.lobbyButtonIcons.join}
                label={serverState.joinLabel}
                sound={serverState.lobbyMenuSound}
              >
                {serverState.joinLabel}
              </MenuButton>
              <MenuButton
                onClick={() => onAction('character')}
                iconClass={serverState.lobbyButtonIcons.character}
                label="Character Setup"
                sound={serverState.lobbyMenuSound}
              >
                Character Setup
              </MenuButton>
              <MenuButton
                onClick={() => onAction('lobby_manifest')}
                disabled={!serverState.canManifest}
                iconClass={serverState.lobbyButtonIcons.manifest}
                label="Crew Manifest"
                sound={serverState.lobbyMenuSound}
              >
                Crew Manifest
              </MenuButton>
              <MenuButton
                onClick={() => onAction('lobby_observe')}
                iconClass={serverState.lobbyButtonIcons.observe}
                label="Observe"
                sound={serverState.lobbyMenuSound}
              >
                Observe
              </MenuButton>
              <MenuButton
                onClick={() => onAction('resource_changelog')}
                iconClass={serverState.lobbyButtonIcons.changelog}
                label="Changelog"
                sound={serverState.lobbyMenuSound}
              >
                Changelog
              </MenuButton>
              <MenuButton
                onClick={() => onAction('lobby_polls')}
                iconClass={serverState.lobbyButtonIcons.polls}
                label="Polls"
                sound={serverState.lobbyMenuSound}
              >
                Polls
              </MenuButton>
              <MenuButton
                onClick={() => onAction('lobby_lore')}
                iconClass={serverState.lobbyButtonIcons.lore}
                label="Current Lore Summary"
                sound={serverState.lobbyMenuSound}
              >
                Current Lore Summary
              </MenuButton>
            </>
          ) : (
            <>
              <MenuButton onClick={onClose}>Resume</MenuButton>
              <MenuButton
                onClick={() => {
                  onAction('character');
                  onClose();
                }}
              >
                Character Setup
              </MenuButton>
              <MenuButton onClick={() => onNavigate('players')}>
                Players
              </MenuButton>
              <MenuButton onClick={() => onNavigate('admin')}>
                Admin Help
              </MenuButton>
              <MenuButton
                onClick={() => onNavigate('leave_body')}
                disabled={!serverState.canLeaveBody}
              >
                Leave Body
              </MenuButton>
              <MenuButton onClick={() => onNavigate('quit')}>Quit</MenuButton>
            </>
          )}
        </div>
      </div>
      <div className="escape-menu__resources">
        {mounted && (
          <div
            className={
              'escape-menu__resource-list' +
              (collapsing ? ' escape-menu__resource-list--collapsing' : '')
            }
          >
            {serverState.resources.map((resource) => (
              <Tooltip
                key={resource.id}
                position="top"
                content={resource.tooltip}
              >
                <button
                  className="escape-menu__resource-button"
                  onClick={() => onAction(`resource_${resource.id}`)}
                >
                  <IconButton iconClass={resource.id} />
                  <span className="escape-menu__resource-button-label">
                    {resource.label}
                  </span>
                </button>
              </Tooltip>
            ))}
          </div>
        )}
        <button
          className="escape-menu__resource-toggle"
          onClick={onToggleResources}
        >
          <IconButton iconClass="resources" />
          <span className="escape-menu__resource-label">Resources</span>
        </button>
      </div>
    </>
  );
}

function IconButton({ iconClass }: { iconClass: string }) {
  return (
    <div className="escape-menu__icon-button">
      <span className="escape-menu-icons40x40 template" />
      <span
        className={`escape-menu-icons40x40 ${iconClass} escape-menu__icon-overlay`}
      />
    </div>
  );
}

type MenuButtonProps = {
  children: React.ReactNode;
  onClick: () => void;
  disabled?: boolean;
  blinking?: boolean;
  ready?: boolean;
  tooltip?: string;
  iconClass?: string;
  label?: string;
  sound?: string;
};

function MenuButton({
  children,
  onClick,
  disabled,
  blinking,
  ready,
  tooltip,
  iconClass,
  label,
  sound,
}: MenuButtonProps) {
  const playSound = () => {
    if (sound && !disabled) {
      playLobbyButtonSound(sound);
    }
  };

  const button = (
    <button
      className={
        'escape-menu__menu-button' +
        (disabled ? ' escape-menu__menu-button--disabled' : '') +
        (blinking ? ' escape-menu__menu-button--blinking' : '') +
        (ready ? ' escape-menu__menu-button--ready' : '')
      }
      onClick={
        disabled
          ? undefined
          : () => {
              playSound();
              onClick();
            }
      }
      onMouseEnter={playSound}
      aria-label={label}
    >
      {iconClass ? (
        <span className={`escape-menu__lobby-button-icon ${iconClass}`} />
      ) : (
        children
      )}
    </button>
  );

  if (tooltip) {
    return <Tooltip content={tooltip}>{button}</Tooltip>;
  }

  return button;
}

import type { PlayerInfo, ServerState } from '../EscapeMenu';

type Props = {
  serverState: ServerState;
  onNavigate: (page: 'home') => void;
};

export function PlayersPage({ serverState, onNavigate }: Props) {
  return (
    <>
      <BackButton onClick={() => onNavigate('home')} />
      <div className="escape-menu__player-list">
        {serverState.admins.length > 0 ? (
          <PlayerSection title="Admins">
            {serverState.admins.map((admin) => (
              <PlayerEntry key={admin.ckey} player={admin} />
            ))}
          </PlayerSection>
        ) : (
          <div className="escape-menu__player-section-title">
            No Admins Online!
          </div>
        )}
        <PlayerSection title="Players">
          {serverState.players.map((player) => (
            <PlayerEntry key={player.ckey} player={player} />
          ))}
        </PlayerSection>
      </div>
    </>
  );
}

function BackButton({ onClick }: { onClick: () => void }) {
  return (
    <button className="escape-menu__back-button" onClick={onClick}>
      <div className="escape-menu__icon-button">
        <span className="escape-menu-icons40x40 template" />
        <span className="escape-menu-icons40x40 back escape-menu__icon-overlay" />
      </div>
      <span>Back</span>
    </button>
  );
}

function PlayerSection({
  title,
  children,
}: {
  title: string;
  children: React.ReactNode;
}) {
  return (
    <div className="escape-menu__player-section">
      <div className="escape-menu__player-section-title">{title}</div>
      <div className="escape-menu__player-grid">{children}</div>
    </div>
  );
}

function PlayerEntry({ player }: { player: PlayerInfo }) {
  return (
    <div className="escape-menu__player-entry">
      <span className="escape-menu__player-name">
        {player.displayName}
        {player.ping !== undefined && (
          <span className="escape-menu__player-ping"> ({player.ping}ms)</span>
        )}
      </span>
      {player.rank && (
        <span className="escape-menu__player-rank">{player.rank}</span>
      )}
    </div>
  );
}

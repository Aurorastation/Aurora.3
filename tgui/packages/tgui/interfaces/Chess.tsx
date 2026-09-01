import { useEffect } from 'react';
import { Box, Button, Icon, Stack } from 'tgui-core/components';
import { useBackend, useLocalState } from '../backend';
import { Window } from '../layouts';

type ChessData = {
  board: string[];
  white_player: string | null;
  black_player: string | null;
  user_color: 'w' | 'b' | null;
  computer_color: 'w' | 'b' | null;
  computer_difficulty: Difficulty;
  orientation: 'w' | 'b';
  turn: 'w' | 'b';
  status: 'waiting' | 'playing' | 'white_wins' | 'black_wins' | 'draw';
  en_passant: number;
  white_castle_kingside: boolean;
  white_castle_queenside: boolean;
  black_castle_kingside: boolean;
  black_castle_queenside: boolean;
  last_from: number | null;
  last_to: number | null;
  captured: string[];
  position_version: number;
};

type Color = 'w' | 'b';
type Promotion = 'q' | 'r' | 'b' | 'n';
type Difficulty = 'novice' | 'casual' | 'club' | 'expert';
type GameStatus = ChessData['status'];
type CastlingRights = {
  wk: boolean;
  wq: boolean;
  bk: boolean;
  bq: boolean;
};

const pieceGlyphs: Record<string, string> = {
  wk: '♔',
  wq: '♕',
  wr: '♖',
  wb: '♗',
  wn: '♘',
  wp: '♙',
  bk: '♚',
  bq: '♛',
  br: '♜',
  bb: '♝',
  bn: '♞',
  bp: '♟',
};

const colorName = (color: 'w' | 'b') => (color === 'w' ? 'White' : 'Black');

const oppositeColor = (color: Color): Color => (color === 'w' ? 'b' : 'w');

const pathIsClear = (
  board: string[],
  fromX: number,
  fromY: number,
  toX: number,
  toY: number,
) => {
  const stepX = Math.sign(toX - fromX);
  const stepY = Math.sign(toY - fromY);
  let x = fromX + stepX;
  let y = fromY + stepY;
  while (x !== toX || y !== toY) {
    if (board[y * 8 + x]) {
      return false;
    }
    x += stepX;
    y += stepY;
  }
  return true;
};

const isPseudoLegal = (
  board: string[],
  from: number,
  destination: number,
  color: Color,
  enPassant: number,
  castling: CastlingRights,
  attacksOnly = false,
): boolean => {
  if (from === destination) {
    return false;
  }
  const piece = board[from];
  const target = board[destination];
  if (!piece || piece.charAt(0) !== color || target?.charAt(0) === color) {
    return false;
  }

  const fromX = from % 8;
  const fromY = Math.floor(from / 8);
  const toX = destination % 8;
  const toY = Math.floor(destination / 8);
  const dx = toX - fromX;
  const dy = toY - fromY;
  const absDx = Math.abs(dx);
  const absDy = Math.abs(dy);

  switch (piece.charAt(1)) {
    case 'p': {
      const direction = color === 'w' ? -1 : 1;
      if (attacksOnly) {
        return absDx === 1 && dy === direction;
      }
      if (dx === 0 && dy === direction && !target) {
        return true;
      }
      const startRank = color === 'w' ? 6 : 1;
      if (
        dx === 0 &&
        fromY === startRank &&
        dy === 2 * direction &&
        !target &&
        !board[from + direction * 8]
      ) {
        return true;
      }
      return (
        absDx === 1 &&
        dy === direction &&
        (!!target || destination === enPassant)
      );
    }
    case 'n':
      return (absDx === 1 && absDy === 2) || (absDx === 2 && absDy === 1);
    case 'b':
      return absDx === absDy && pathIsClear(board, fromX, fromY, toX, toY);
    case 'r':
      return (
        (dx === 0 || dy === 0) && pathIsClear(board, fromX, fromY, toX, toY)
      );
    case 'q':
      return (
        (absDx === absDy || dx === 0 || dy === 0) &&
        pathIsClear(board, fromX, fromY, toX, toY)
      );
    case 'k': {
      if (absDx <= 1 && absDy <= 1) {
        return true;
      }
      if (attacksOnly || dy !== 0 || absDx !== 2) {
        return false;
      }
      const homeSquare = color === 'w' ? 60 : 4;
      const kingside = dx > 0;
      const canCastle = castling[`${color}${kingside ? 'k' : 'q'}`];
      const enemy = oppositeColor(color);
      const rookSquare = homeSquare + (kingside ? 3 : -4);
      const passSquare = homeSquare + (kingside ? 1 : -1);
      return (
        from === homeSquare &&
        canCastle &&
        board[rookSquare] === `${color}r` &&
        pathIsClear(board, fromX, fromY, rookSquare % 8, fromY) &&
        !isSquareAttacked(board, from, enemy, enPassant, castling) &&
        !isSquareAttacked(board, passSquare, enemy, enPassant, castling) &&
        !isSquareAttacked(board, destination, enemy, enPassant, castling)
      );
    }
  }
  return false;
};

const isSquareAttacked = (
  board: string[],
  square: number,
  byColor: Color,
  enPassant: number,
  castling: CastlingRights,
) =>
  board.some(
    (piece, from) =>
      piece?.charAt(0) === byColor &&
      isPseudoLegal(board, from, square, byColor, enPassant, castling, true),
  );

const isInCheck = (
  board: string[],
  color: Color,
  enPassant: number,
  castling: CastlingRights,
) => {
  const kingSquare = board.indexOf(`${color}k`);
  return (
    kingSquare < 0 ||
    isSquareAttacked(
      board,
      kingSquare,
      oppositeColor(color),
      enPassant,
      castling,
    )
  );
};

const applyMove = (
  board: string[],
  from: number,
  destination: number,
  promotion: Promotion,
  enPassant: number,
) => {
  const nextBoard = [...board];
  const piece = nextBoard[from];
  const color = piece.charAt(0) as Color;
  const type = piece.charAt(1);
  if (type === 'p' && destination === enPassant && !nextBoard[destination]) {
    nextBoard[destination + (color === 'w' ? 8 : -8)] = '';
  }
  if (type === 'k' && Math.abs((destination % 8) - (from % 8)) === 2) {
    const kingside = destination > from;
    const rookFrom = from + (kingside ? 3 : -4);
    const rookTo = from + (kingside ? 1 : -1);
    nextBoard[rookTo] = nextBoard[rookFrom];
    nextBoard[rookFrom] = '';
  }
  nextBoard[destination] = piece;
  nextBoard[from] = '';
  const destinationRank = Math.floor(destination / 8);
  if (type === 'p' && (destinationRank === 0 || destinationRank === 7)) {
    nextBoard[destination] = `${color}${promotion}`;
  }
  return nextBoard;
};

const isLegalMove = (
  board: string[],
  from: number,
  destination: number,
  color: Color,
  enPassant: number,
  castling: CastlingRights,
) => {
  if (
    board[destination]?.charAt(1) === 'k' ||
    !isPseudoLegal(board, from, destination, color, enPassant, castling)
  ) {
    return false;
  }
  const testBoard = applyMove(board, from, destination, 'q', enPassant);
  return !isInCheck(testBoard, color, enPassant, castling);
};

const hasLegalMove = (
  board: string[],
  color: Color,
  enPassant: number,
  castling: CastlingRights,
) =>
  board.some(
    (piece, from) =>
      piece?.charAt(0) === color &&
      board.some((_, destination) =>
        isLegalMove(board, from, destination, color, enPassant, castling),
      ),
  );

const updatedCastlingRights = (
  current: CastlingRights,
  piece: string,
  from: number,
  destination: number,
) => {
  const next = { ...current };
  if (piece === 'wk') {
    next.wk = false;
    next.wq = false;
  } else if (piece === 'bk') {
    next.bk = false;
    next.bq = false;
  }
  if (from === 63 || destination === 63) next.wk = false;
  if (from === 56 || destination === 56) next.wq = false;
  if (from === 7 || destination === 7) next.bk = false;
  if (from === 0 || destination === 0) next.bq = false;
  return next;
};

const evaluateMove = (
  data: ChessData,
  from: number,
  destination: number,
  promotion: Promotion,
  castling: CastlingRights,
) => {
  const piece = data.board[from];
  const color = piece.charAt(0) as Color;
  const type = piece.charAt(1);
  const enPassant = data.en_passant;
  let captured = data.board[destination];
  if (type === 'p' && destination === enPassant && !captured) {
    captured = data.board[destination + (color === 'w' ? 8 : -8)];
  }
  const board = applyMove(data.board, from, destination, promotion, enPassant);
  const nextCastling = updatedCastlingRights(
    castling,
    piece,
    from,
    destination,
  );
  const nextEnPassant =
    type === 'p' && Math.abs(destination - from) === 16
      ? (from + destination) / 2
      : -1;
  const nextTurn = oppositeColor(color);
  let status: GameStatus = 'playing';
  if (!hasLegalMove(board, nextTurn, nextEnPassant, nextCastling)) {
    status = isInCheck(board, nextTurn, nextEnPassant, nextCastling)
      ? color === 'w'
        ? 'white_wins'
        : 'black_wins'
      : 'draw';
  }
  return {
    board,
    captured,
    status,
    en_passant: nextEnPassant,
    white_castle_kingside: nextCastling.wk ? 1 : 0,
    white_castle_queenside: nextCastling.wq ? 1 : 0,
    black_castle_kingside: nextCastling.bk ? 1 : 0,
    black_castle_queenside: nextCastling.bq ? 1 : 0,
  };
};

type SearchPosition = {
  board: string[];
  turn: Color;
  enPassant: number;
  castling: CastlingRights;
};

type ChessMove = {
  from: number;
  destination: number;
};

const difficultyLabels: Record<Difficulty, string> = {
  novice: 'Novice · ~400 ELO',
  casual: 'Casual · ~800 ELO',
  club: 'Club · ~1200 ELO',
  expert: 'Expert · ~1600 ELO',
};

const generateLegalMoves = (position: SearchPosition): ChessMove[] => {
  const moves: ChessMove[] = [];
  for (let from = 0; from < 64; from++) {
    if (position.board[from]?.charAt(0) !== position.turn) {
      continue;
    }
    for (let destination = 0; destination < 64; destination++) {
      if (
        isLegalMove(
          position.board,
          from,
          destination,
          position.turn,
          position.enPassant,
          position.castling,
        )
      ) {
        moves.push({ from, destination });
      }
    }
  }
  return moves;
};

const advancePosition = (
  position: SearchPosition,
  move: ChessMove,
): SearchPosition => {
  const piece = position.board[move.from];
  const type = piece.charAt(1);
  return {
    board: applyMove(
      position.board,
      move.from,
      move.destination,
      'q',
      position.enPassant,
    ),
    turn: oppositeColor(position.turn),
    enPassant:
      type === 'p' && Math.abs(move.destination - move.from) === 16
        ? (move.from + move.destination) / 2
        : -1,
    castling: updatedCastlingRights(
      position.castling,
      piece,
      move.from,
      move.destination,
    ),
  };
};

const materialValue: Record<string, number> = {
  p: 100,
  n: 320,
  b: 330,
  r: 500,
  q: 900,
  k: 0,
};

const evaluatePosition = (position: SearchPosition, computer: Color) => {
  let score = 0;
  position.board.forEach((piece, square) => {
    if (!piece) {
      return;
    }
    const value = materialValue[piece.charAt(1)] || 0;
    const x = square % 8;
    const y = Math.floor(square / 8);
    const centerBonus = 7 - (Math.abs(3.5 - x) + Math.abs(3.5 - y));
    const pieceScore = value + centerBonus * (piece.charAt(1) === 'p' ? 2 : 1);
    score += piece.charAt(0) === computer ? pieceScore : -pieceScore;
  });
  return score;
};

const minimax = (
  position: SearchPosition,
  depth: number,
  computer: Color,
  alpha: number,
  beta: number,
): number => {
  const moves = generateLegalMoves(position);
  if (!moves.length) {
    if (
      isInCheck(
        position.board,
        position.turn,
        position.enPassant,
        position.castling,
      )
    ) {
      return position.turn === computer ? -100000 - depth : 100000 + depth;
    }
    return 0;
  }
  if (depth === 0) {
    return evaluatePosition(position, computer);
  }

  const maximizing = position.turn === computer;
  let best = maximizing ? -Infinity : Infinity;
  for (const move of moves) {
    const score = minimax(
      advancePosition(position, move),
      depth - 1,
      computer,
      alpha,
      beta,
    );
    if (maximizing) {
      best = Math.max(best, score);
      alpha = Math.max(alpha, best);
    } else {
      best = Math.min(best, score);
      beta = Math.min(beta, best);
    }
    if (beta <= alpha) {
      break;
    }
  }
  return best;
};

const chooseComputerMove = (
  position: SearchPosition,
  difficulty: Difficulty,
): ChessMove | null => {
  const moves = generateLegalMoves(position);
  if (!moves.length) {
    return null;
  }
  if (difficulty === 'novice') {
    return moves[Math.floor(Math.random() * moves.length)];
  }

  const depth = difficulty === 'expert' ? 2 : difficulty === 'club' ? 1 : 0;
  const noise = difficulty === 'casual' ? 240 : difficulty === 'club' ? 45 : 8;
  let bestMove = moves[0];
  let bestScore = -Infinity;
  for (const move of moves) {
    const next = advancePosition(position, move);
    const score =
      minimax(next, depth, position.turn, -Infinity, Infinity) +
      Math.random() * noise;
    if (score > bestScore) {
      bestScore = score;
      bestMove = move;
    }
  }
  return bestMove;
};

const PlayerPlaque = (props: {
  color: 'w' | 'b';
  name: string | null;
  active: boolean;
  isUser: boolean;
}) => (
  <Box
    className={[
      'Chess__player',
      props.active ? 'Chess__player--active' : '',
      props.active && props.isUser ? 'Chess__player--yourTurn' : '',
    ].join(' ')}
  >
    <Box className={`Chess__color Chess__color--${props.color}`} />
    <Box className="Chess__playerText">
      <Box className="Chess__playerColor">{colorName(props.color)}</Box>
      <Box className="Chess__playerName">
        {props.name || 'Open seat'} {props.isUser && <span>· You</span>}
      </Box>
    </Box>
    {props.active && props.isUser ? (
      <Box className="Chess__yourTurn">
        <Icon name="play" /> Your turn
      </Box>
    ) : (
      props.active && <Icon name="chess-knight" className="Chess__turnIcon" />
    )}
  </Box>
);

export const Chess = (props) => {
  const { act, data } = useBackend<ChessData>();
  const [selected, setSelected] = useLocalState<number | null>(
    'selectedSquare',
    null,
  );
  const [promotion, setPromotion] = useLocalState<Promotion>(
    'promotionPiece',
    'q',
  );
  const [soloDifficulty, setSoloDifficulty] = useLocalState<Difficulty>(
    'soloDifficulty',
    'casual',
  );

  const isBlackView = data.orientation === 'b';
  const squares = Array.from({ length: 64 }, (_, index) =>
    isBlackView ? 63 - index : index,
  );
  const topColor = isBlackView ? 'w' : 'b';
  const bottomColor = isBlackView ? 'b' : 'w';
  const players = {
    w:
      data.computer_color === 'w'
        ? difficultyLabels[data.computer_difficulty]
        : data.white_player,
    b:
      data.computer_color === 'b'
        ? difficultyLabels[data.computer_difficulty]
        : data.black_player,
  };
  const castling: CastlingRights = {
    wk: !!data.white_castle_kingside,
    wq: !!data.white_castle_queenside,
    bk: !!data.black_castle_kingside,
    bq: !!data.black_castle_queenside,
  };
  const canMove = data.status === 'playing' && data.user_color === data.turn;
  const inCheck =
    data.status === 'playing' &&
    isInCheck(data.board, data.turn, data.en_passant, castling);
  const legalTargets = new Set<number>();
  if (selected !== null && data.user_color) {
    for (let destination = 0; destination < 64; destination++) {
      if (
        isLegalMove(
          data.board,
          selected,
          destination,
          data.user_color,
          data.en_passant,
          castling,
        )
      ) {
        legalTargets.add(destination);
      }
    }
  }

  useEffect(() => {
    if (
      data.status !== 'playing' ||
      !data.user_color ||
      data.computer_color !== data.turn
    ) {
      return;
    }
    const timer = setTimeout(() => {
      const move = chooseComputerMove(
        {
          board: data.board,
          turn: data.turn,
          enPassant: data.en_passant,
          castling,
        },
        data.computer_difficulty,
      );
      if (!move) {
        return;
      }
      act('computer_move', {
        from: move.from,
        to: move.destination,
        promotion: 'q',
        position_version: data.position_version,
        ...evaluateMove(data, move.from, move.destination, 'q', castling),
      });
    }, 350);
    return () => clearTimeout(timer);
  }, [
    data.position_version,
    data.status,
    data.turn,
    data.computer_color,
    data.user_color,
  ]);

  const statusText = (() => {
    if (data.status === 'waiting') {
      return 'Choose sides to begin';
    }
    if (data.status === 'white_wins') {
      return 'White wins';
    }
    if (data.status === 'black_wins') {
      return 'Black wins';
    }
    if (data.status === 'draw') {
      return 'Draw by stalemate';
    }
    if (data.computer_color === data.turn) {
      return `${colorName(data.turn)} computer is thinking…`;
    }
    if (data.user_color === data.turn) {
      return `Your turn${inCheck ? ' · You are in check!' : ''}`;
    }
    return `${colorName(data.turn)} to move${inCheck ? ' · Check!' : ''}`;
  })();

  const clickSquare = (square: number) => {
    if (!canMove) {
      return;
    }
    const piece = data.board[square];
    if (selected === null) {
      if (piece?.charAt(0) === data.user_color) {
        setSelected(square);
      }
      return;
    }
    if (piece?.charAt(0) === data.user_color) {
      setSelected(square);
      return;
    }
    if (!legalTargets.has(square)) {
      setSelected(null);
      return;
    }
    act('move', {
      from: selected,
      to: square,
      promotion,
      position_version: data.position_version,
      ...evaluateMove(data, selected, square, promotion, castling),
    });
    setSelected(null);
  };

  return (
    <Window width={500} height={590}>
      <Window.Content>
        <Box className="Chess">
          <PlayerPlaque
            color={topColor}
            name={players[topColor]}
            active={data.status === 'playing' && data.turn === topColor}
            isUser={data.user_color === topColor}
          />

          <Box className="Chess__status">{statusText}</Box>

          <Box className="Chess__boardFrame">
            <Box className="Chess__board">
              {squares.map((square, displayIndex) => {
                const piece = data.board[square] || '';
                const canonicalX = square % 8;
                const canonicalY = Math.floor(square / 8);
                const displayRow = Math.floor(displayIndex / 8);
                const displayColumn = displayIndex % 8;
                const isLight = (canonicalX + canonicalY) % 2 === 0;
                const isSelected = selected === square;
                const wasMoved =
                  data.last_from === square || data.last_to === square;
                const isLegalTarget = legalTargets.has(square);
                return (
                  <button
                    className={[
                      'Chess__square',
                      isLight ? 'Chess__square--light' : 'Chess__square--dark',
                      isSelected ? 'Chess__square--selected' : '',
                      wasMoved ? 'Chess__square--last' : '',
                      isLegalTarget ? 'Chess__square--legal' : '',
                    ].join(' ')}
                    key={square}
                    onClick={() => clickSquare(square)}
                    type="button"
                  >
                    {displayColumn === 0 && (
                      <span className="Chess__rank">{8 - canonicalY}</span>
                    )}
                    {displayRow === 7 && (
                      <span className="Chess__file">
                        {String.fromCharCode(97 + canonicalX)}
                      </span>
                    )}
                    {piece && (
                      <span
                        className={`Chess__piece Chess__piece--${piece.charAt(0)}`}
                      >
                        {pieceGlyphs[piece]}
                      </span>
                    )}
                  </button>
                );
              })}
            </Box>
          </Box>

          <PlayerPlaque
            color={bottomColor}
            name={players[bottomColor]}
            active={data.status === 'playing' && data.turn === bottomColor}
            isUser={data.user_color === bottomColor}
          />

          <Stack className="Chess__controls" align="center" justify="center">
            {!data.user_color && !data.white_player && (
              <Stack.Item>
                <Button
                  icon="chess-king"
                  content="Play White"
                  onClick={() => act('join', { color: 'w' })}
                />
              </Stack.Item>
            )}
            {!data.user_color && !data.black_player && (
              <Stack.Item>
                <Button
                  icon="chess-king"
                  content="Play Black"
                  onClick={() => act('join', { color: 'b' })}
                />
              </Stack.Item>
            )}
            {data.user_color && (
              <>
                <Stack.Item>
                  <Button
                    icon="flag"
                    content="Resign"
                    disabled={data.status !== 'playing'}
                    onClick={() => act('resign')}
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button
                    icon="door-open"
                    content="Leave"
                    onClick={() => act('leave')}
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button
                    icon="rotate"
                    content="New game"
                    disabled={data.status === 'playing'}
                    onClick={() => act('reset')}
                  />
                </Stack.Item>
              </>
            )}
          </Stack>

          {!data.user_color &&
            !data.white_player &&
            !data.black_player &&
            !data.computer_color && (
              <Box className="Chess__solo">
                <select
                  aria-label="Computer difficulty"
                  value={soloDifficulty}
                  onChange={(event) =>
                    setSoloDifficulty(event.currentTarget.value as Difficulty)
                  }
                >
                  {(Object.keys(difficultyLabels) as Difficulty[]).map(
                    (difficulty) => (
                      <option key={difficulty} value={difficulty}>
                        {difficultyLabels[difficulty]}
                      </option>
                    ),
                  )}
                </select>
                <Button
                  icon="robot"
                  content="Solo as White"
                  onClick={() =>
                    act('start_solo', {
                      color: 'w',
                      difficulty: soloDifficulty,
                    })
                  }
                />
                <Button
                  icon="robot"
                  content="Solo as Black"
                  onClick={() =>
                    act('start_solo', {
                      color: 'b',
                      difficulty: soloDifficulty,
                    })
                  }
                />
              </Box>
            )}

          {(data.white_player || data.black_player || data.computer_color) && (
            <Box className="Chess__footer">
              <Box className="Chess__captured">
                {data.captured.length
                  ? data.captured.map((piece, index) => (
                      <span key={`${piece}-${index}`}>
                        {pieceGlyphs[piece]}
                      </span>
                    ))
                  : 'No captures'}
              </Box>
              {data.user_color && (
                <Box className="Chess__promotion">
                  Promote to
                  {(['q', 'r', 'b', 'n'] as const).map((piece) => (
                    <button
                      className={promotion === piece ? 'selected' : ''}
                      key={piece}
                      onClick={() => setPromotion(piece)}
                      type="button"
                    >
                      {pieceGlyphs[`${data.user_color}${piece}`]}
                    </button>
                  ))}
                </Box>
              )}
            </Box>
          )}
        </Box>
      </Window.Content>
    </Window>
  );
};

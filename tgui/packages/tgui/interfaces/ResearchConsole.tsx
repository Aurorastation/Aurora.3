import {
  Box,
  Button,
  Icon,
  LabeledList,
  NoticeBox,
  ProgressBar,
  Section,
  Stack,
  Table,
  Tabs,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { useBackend, useLocalState } from '../backend';
import { Window } from '../layouts';
import { SearchBar } from './common/SearchBar';
import {
  ResearchFabricator,
  type ResearchFabricatorData,
} from './ResearchFabricator';

type ResearchConsoleData = {
  manufacturer: string;
  screen: string;
  authorized: BooleanLike;
  emagged: BooleanLike;
  network_sync: BooleanLike;
  busy_message: string;
  devices: {
    analyzer: number;
    protolathe: number;
    imprinter: number;
    mechfab: number;
    silo: number;
  };
  loaded_disk: LoadedDisk | null;
  research_points?: number;
  tech_nodes?: TechNode[];
  technologies?: Technology[];
  designs?: Design[];
  analyzer?: AnalyzerData;
  fabricator?: ResearchFabricatorData;
  queue_amount: number;
};

type TechNode = {
  id: string;
  name: string;
  description: string;
  branch: string;
  corporation?: string;
  tier: number;
  cost: number;
  prereqs: string[];
  unlocks: string[];
  icon: string;
  unlocked: BooleanLike;
  can_unlock: BooleanLike;
  can_afford: BooleanLike;
  invested?: number;
  is_outermost?: BooleanLike;
  needs_maintenance?: BooleanLike;
};

type LoadedDisk = {
  type: 'technology' | 'design';
  name: string;
  stored_name?: string;
  stored_description?: string;
  stored_level?: number;
};

type Technology = {
  id: string;
  name: string;
  description: string;
  level: number;
  progress: number;
  threshold: number;
  complete: BooleanLike;
};

type Design = {
  path: string;
  name: string;
  description: string;
  category: string;
};

type ResearchBounty = {
  id: string;
  category: string;
  corporation: string;
  title: string;
  description: string;
  criteria: string[];
  reward_points: number;
  matches_loaded: BooleanLike;
  input_spec?: string;
  output_spec?: string;
  test_summary?: string;
};

type AnalyzerData = {
  linked: BooleanLike;
  busy?: BooleanLike;
  bounty_rerolls?: number;
  bounties?: ResearchBounty[];
  item?: {
    name: string;
    stack: BooleanLike;
    points?: number;
    is_prototype?: BooleanLike;
    is_seed?: BooleanLike;
    is_slime_core?: BooleanLike;
    is_circuit?: BooleanLike;
    is_survey_disk?: BooleanLike;
    is_artifact?: BooleanLike;
    matched_bounty?: string | null;
    specs?: {
      damage: number;
      max_shots: number;
      burst: number;
      fire_delay: number;
      reliability: number;
      self_recharge: BooleanLike;
      mods_count: number;
      armor_penetration: number;
      stun: BooleanLike;
    };
    seed_specs?: {
      species: string;
      potency: number;
      yield: number;
      endurance: number;
      maturation: number;
      production: number;
      toxins_tolerance: number;
      heat_tolerance: number;
      special_traits: string[];
    };
    slime_specs?: {
      uses: number;
      enhanced: BooleanLike;
    };
    circuit_specs?: {
      components: number;
      numberpads: number;
      textpads: number;
      buttons: number;
      toggles: number;
      screens: number;
    };
    survey_specs?: {
      planet: string;
      survey_type: string;
    };
    artifact_specs?: {
      artifact_id: string;
      trigger_type: string;
      effect_type: string;
      has_secondary: BooleanLike;
    };
    technologies: AnalyzerTechnology[];
  };
};

type AnalyzerTechnology = {
  name: string;
  item_level: number;
  current_level: number;
  progress: number;
  threshold: number;
};

export const ResearchConsole = () => {
  const { data } = useBackend<ResearchConsoleData>();

  return (
    <Window width={1200} height={800} theme={data.manufacturer}>
      <Window.Content scrollable>
        {data.screen === 'main' && <MainMenu />}
        {data.screen === 'busy' && (
          <Section title="Research Console">
            <NoticeBox info>{data.busy_message}</NoticeBox>
            <ProgressBar value={1} maxValue={1}>
              Please wait...
            </ProgressBar>
          </Section>
        )}
        {data.screen === 'levels' && (
          <TechTree
            techNodes={data.tech_nodes ?? []}
            researchPoints={data.research_points ?? 0}
          />
        )}
        {data.screen === 'designs' && (
          <DesignList designs={data.designs ?? []} />
        )}
        {data.screen === 'tech_disk' && (
          <DiskMenu technologies={data.technologies ?? []} />
        )}
        {data.screen === 'design_disk' && (
          <DiskMenu designs={data.designs ?? []} />
        )}
        {data.screen === 'analyzer' && <Analyzer analyzer={data.analyzer} />}
        {data.screen === 'protolathe' && data.fabricator && (
          <ResearchFabricator
            fabricator={data.fabricator}
            queueAmount={data.queue_amount}
            title="Protolathe"
          />
        )}
        {data.screen === 'imprinter' && data.fabricator && (
          <ResearchFabricator
            fabricator={data.fabricator}
            queueAmount={data.queue_amount}
            title="Circuit Imprinter"
          />
        )}
        {data.screen === 'mechfab' && data.fabricator && (
          <ResearchFabricator
            fabricator={data.fabricator}
            queueAmount={data.queue_amount}
            title="Synthetic Fabricator"
          />
        )}
        {data.screen === 'settings' && <Settings />}
      </Window.Content>
    </Window>
  );
};

const BackButton = () => {
  const { act } = useBackend();
  return (
    <Button icon="arrow-left" content="Back" onClick={() => act('back')} />
  );
};

const MainMenu = () => {
  const { act, data } = useBackend<ResearchConsoleData>();

  return (
    <Stack vertical>
      <Stack.Item>
        <NoticeBox info>
          <Stack align="center" justify="space-between">
            <Stack.Item>
              <Icon name="atom" size={1.3} mr={1} />
              <Box inline fontSize={1.2} bold color="teal">
                Research Data Points: {(data.research_points ?? 0).toLocaleString()} pts
              </Box>
            </Stack.Item>
          </Stack>
        </NoticeBox>
      </Stack.Item>

      <Stack.Item>
        <Section title="Research Database">
          <Button
            icon="project-diagram"
            content="Technology Tree"
            onClick={() => act('set_screen', { screen: 'levels' })}
          />
          <Button
            icon="book"
            content="Researched Designs"
            onClick={() => act('set_screen', { screen: 'designs' })}
          />
          <Button
            icon="print"
            content="Print Summary"
            onClick={() => act('print_research', { detailed: false })}
          />
          <Button
            icon="print"
            content="Print Detailed Report"
            onClick={() => act('print_research', { detailed: true })}
          />
        </Section>
      </Stack.Item>

      <Stack.Item>
        <Section title="Loaded Disk">
          {data.loaded_disk ? (
            <Stack align="center">
              <Stack.Item grow>
                <Box bold>{data.loaded_disk.name}</Box>
                <Box>{data.loaded_disk.stored_name ?? 'Empty'}</Box>
              </Stack.Item>
              <Stack.Item>
                <Button
                  icon="floppy-disk"
                  content="Disk Operations"
                  onClick={() =>
                    act('set_screen', {
                      screen:
                        data.loaded_disk?.type === 'technology'
                          ? 'tech_disk'
                          : 'design_disk',
                    })
                  }
                />
              </Stack.Item>
            </Stack>
          ) : (
            <NoticeBox>No disk loaded.</NoticeBox>
          )}
        </Section>
      </Stack.Item>

      <Stack.Item>
        <Section title="Connected Machinery">
          {data.devices.silo ? (
            <NoticeBox success>Shared material silo connected.</NoticeBox>
          ) : (
            <NoticeBox danger>
              No shared material silo connected. Fabrication is unavailable.
            </NoticeBox>
          )}
          <Button
            icon="recycle"
            content="Destructive Analyzer"
            disabled={!data.devices.analyzer}
            onClick={() => act('set_screen', { screen: 'analyzer' })}
          />
          <Button
            icon="industry"
            content="Protolathe"
            disabled={!data.devices.protolathe}
            onClick={() => act('set_screen', { screen: 'protolathe' })}
          />
          <Button
            icon="microchip"
            content="Circuit Imprinter"
            disabled={!data.devices.imprinter}
            onClick={() => act('set_screen', { screen: 'imprinter' })}
          />
          <Button
            icon="robot"
            content="Synthetic Fabricator"
            disabled={!data.devices.mechfab}
            onClick={() => act('set_screen', { screen: 'mechfab' })}
          />
        </Section>
      </Stack.Item>

      <Stack.Item>
        <Section title="Console">
          <Button
            icon="gear"
            content="Settings"
            disabled={!data.authorized}
            onClick={() => act('set_screen', { screen: 'settings' })}
          />
        </Section>
      </Stack.Item>
    </Stack>
  );
};

const NODE_W = 108;
const NODE_H = 98;
const TILE_SIZE = 62;
const GAP_X = 28;
const GAP_Y = 44;
const CANVAS_PAD = 20;

type NodePosition = {
  x: number;
  y: number;
  node: TechNode;
};

const computeBranchLayout = (branchNodes: TechNode[]) => {
  const tiers = Array.from(new Set(branchNodes.map((n) => n.tier))).sort(
    (a, b) => a - b,
  );
  const byTier: Record<number, TechNode[]> = {};
  for (const t of tiers) {
    byTier[t] = branchNodes.filter((n) => n.tier === t);
  }

  // Order each tier by parent position (barycenter) to keep branches untangled
  const orderIndex: Record<string, number> = {};
  for (let i = 0; i < tiers.length; i++) {
    const t = tiers[i];
    if (i === 0) {
      byTier[t].sort((a, b) => a.name.localeCompare(b.name));
    } else {
      byTier[t].sort((a, b) => {
        const avgA =
          a.prereqs.length > 0
            ? a.prereqs.reduce((acc, p) => acc + (orderIndex[p] ?? 0), 0) /
              a.prereqs.length
            : 0;
        const avgB =
          b.prereqs.length > 0
            ? b.prereqs.reduce((acc, p) => acc + (orderIndex[p] ?? 0), 0) /
              b.prereqs.length
            : 0;
        if (avgA !== avgB) return avgA - avgB;
        return a.name.localeCompare(b.name);
      });
    }
    byTier[t].forEach((node, idx) => {
      orderIndex[node.id] = idx;
    });
  }

  const maxCols = Math.max(...tiers.map((t) => byTier[t].length), 1);
  const canvasWidth = Math.max(
    760,
    maxCols * NODE_W + (maxCols - 1) * GAP_X + CANVAS_PAD * 2,
  );
  const canvasHeight =
    tiers.length * NODE_H +
    Math.max(0, tiers.length - 1) * GAP_Y +
    CANVAS_PAD * 2;

  const positions: Record<string, NodePosition> = {};
  tiers.forEach((t, rowIdx) => {
    const rowNodes = byTier[t];
    const rowWidth =
      rowNodes.length * NODE_W + Math.max(0, rowNodes.length - 1) * GAP_X;
    const startX = (canvasWidth - rowWidth) / 2;
    const y = CANVAS_PAD + rowIdx * (NODE_H + GAP_Y);
    rowNodes.forEach((node, colIdx) => {
      positions[node.id] = {
        x: startX + colIdx * (NODE_W + GAP_X),
        y,
        node,
      };
    });
  });

  const edges: Array<{
    key: string;
    from: NodePosition;
    to: NodePosition;
  }> = [];
  for (const node of branchNodes) {
    const to = positions[node.id];
    if (!to) continue;
    for (const prereqId of node.prereqs) {
      const from = positions[prereqId];
      if (from) {
        edges.push({ key: `${prereqId}->${node.id}`, from, to });
      }
    }
  }

  return { positions, edges, canvasWidth, canvasHeight };
};

const formatShortPts = (pts: number) => {
  if (pts <= 0) return 'FREE';
  if (pts >= 1000) {
    const k = pts / 1000;
    return `${Number.isInteger(k) ? k : k.toFixed(1)}k`;
  }
  return `${pts}`;
};

const TechNodeCard = ({
  node,
  selected,
  onSelect,
}: {
  node: TechNode;
  selected: boolean;
  onSelect: () => void;
}) => {
  const isUnlocked = Boolean(node.unlocked);
  const canUnlock = Boolean(node.can_unlock);
  const canAfford = Boolean(node.can_afford);
  const needsMaintenance = Boolean(node.needs_maintenance);

  const borderColor = selected
    ? '#ffc107'
    : needsMaintenance
      ? '#e0a800'
      : isUnlocked
        ? '#28a745'
        : canUnlock
          ? canAfford
            ? '#17a2b8'
            : '#b58900'
          : '#6c3434';

  const bgColor = needsMaintenance
    ? 'rgba(72, 54, 18, 0.88)'
    : isUnlocked
      ? 'rgba(22, 62, 34, 0.88)'
      : canUnlock && canAfford
        ? 'rgba(18, 56, 68, 0.88)'
        : canUnlock
          ? 'rgba(42, 36, 20, 0.88)'
          : 'rgba(38, 20, 24, 0.88)';

  const iconColor = needsMaintenance
    ? 'yellow'
    : isUnlocked
      ? 'good'
      : canUnlock && canAfford
        ? 'teal'
        : canUnlock
          ? 'average'
          : 'bad';

  return (
    <div
      onClick={onSelect}
      title={`${node.name} (${node.corporation || 'NanoTrasen'})`}
      style={{
        width: `${NODE_W}px`,
        height: `${NODE_H}px`,
        cursor: 'pointer',
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'center',
        justifyContent: 'flex-start',
        boxSizing: 'border-box',
      }}
    >
      <Box
        style={{
          position: 'relative',
          width: `${TILE_SIZE}px`,
          height: `${TILE_SIZE}px`,
          border: `2px solid ${borderColor}`,
          borderRadius: '6px',
          backgroundColor: bgColor,
          boxShadow: selected ? '0 0 10px rgba(255, 193, 7, 0.55)' : 'none',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          flexShrink: 0,
        }}
      >
        <Icon name={node.icon || 'flask'} size={2} color={iconColor} />
        <Box
          style={{
            position: 'absolute',
            bottom: '2px',
            right: '3px',
            fontSize: '0.72em',
            fontWeight: 'bold',
            lineHeight: 1,
            padding: '1px 3px',
            borderRadius: '3px',
            backgroundColor: 'rgba(10, 12, 16, 0.85)',
            color: needsMaintenance
              ? '#f0ad4e'
              : isUnlocked
                ? '#5cb85c'
                : canUnlock && canAfford
                  ? '#5bc0de'
                  : '#bbb',
          }}
        >
          {needsMaintenance ? '!' : isUnlocked ? '✓' : formatShortPts(node.cost)}
        </Box>
      </Box>
      <Box
        mt={0.4}
        fontSize={0.78}
        bold={selected}
        color={selected ? 'white' : isUnlocked ? 'silver' : 'label'}
        textAlign="center"
        style={{
          width: `${NODE_W}px`,
          display: '-webkit-box',
          WebkitLineClamp: 2,
          WebkitBoxOrient: 'vertical',
          overflow: 'hidden',
          lineHeight: '1.15em',
          maxHeight: '2.3em',
          wordBreak: 'break-word',
        }}
      >
        {node.name}
      </Box>
    </div>
  );
};

const TechTree = ({
  techNodes,
  researchPoints,
}: {
  techNodes: TechNode[];
  researchPoints: number;
}) => {
  const { act } = useBackend();
  const branches = Array.from(new Set(techNodes.map((n) => n.branch)));
  const [selectedBranch, setSelectedBranch] = useLocalState<string>(
    'research-tech-branch-v2',
    branches[0] ?? '',
  );
  const [selectedNodeId, setSelectedNodeId] = useLocalState<string | null>(
    'research-tech-selected-node',
    null,
  );
  const [searchTerm, setSearchTerm] = useLocalState('research-tree-search', '');

  const activeBranch = branches.includes(selectedBranch)
    ? selectedBranch
    : (branches[0] ?? '');

  const search = searchTerm.trim().toLowerCase();
  const searchMatches = search
    ? techNodes.filter(
        (n) =>
          n.name.toLowerCase().includes(search) ||
          n.description.toLowerCase().includes(search) ||
          n.branch.toLowerCase().includes(search) ||
          n.unlocks.some((u) => u.toLowerCase().includes(search)),
      )
    : [];

  const branchNodes = techNodes.filter((n) => n.branch === activeBranch);
  const layout = computeBranchLayout(branchNodes);
  const totalUnlocked = techNodes.filter((n) => n.unlocked).length;

  const selectedNode =
    techNodes.find((n) => n.id === selectedNodeId) ?? branchNodes[0] ?? null;

  return (
    <Stack vertical fill>
      <Stack.Item>
        <Section
          title="Research & Technology Tree"
          buttons={
            <Stack align="center">
              <Stack.Item>
                <SearchBar
                  query={searchTerm}
                  onSearch={setSearchTerm}
                  placeholder="Search nodes or item unlocks..."
                />
              </Stack.Item>
              <Stack.Item>
                <BackButton />
              </Stack.Item>
            </Stack>
          }
        >
          <NoticeBox info mb={1}>
            <Stack align="center" justify="space-between">
              <Stack.Item>
                <Icon name="atom" size={1.3} mr={1} />
                <Box inline fontSize={1.2} bold color="teal">
                  Research Data Points: {researchPoints.toLocaleString()} pts
                </Box>
              </Stack.Item>
              <Stack.Item>
                <Box inline bold color="label">
                  Unlocked: {totalUnlocked} / {techNodes.length} Nodes
                </Box>
              </Stack.Item>
            </Stack>
          </NoticeBox>

          {!search && (
            <Tabs>
              {branches.map((branch) => {
                const count = techNodes.filter(
                  (n) => n.branch === branch && n.unlocked,
                ).length;
                const total = techNodes.filter(
                  (n) => n.branch === branch,
                ).length;
                return (
                  <Tabs.Tab
                    key={branch}
                    selected={activeBranch === branch}
                    onClick={() => {
                      setSelectedBranch(branch);
                      const first = techNodes.find((n) => n.branch === branch);
                      if (first) setSelectedNodeId(first.id);
                    }}
                  >
                    {branch} ({count}/{total})
                  </Tabs.Tab>
                );
              })}
            </Tabs>
          )}
        </Section>
      </Stack.Item>

      <Stack.Item grow>
        <Stack fill>
          <Stack.Item grow style={{ minWidth: 0 }}>
            <Section fill scrollable>
              {search ? (
                searchMatches.length === 0 ? (
                  <NoticeBox>
                    No nodes or unlocked items match "{searchTerm}".
                  </NoticeBox>
                ) : (
                  <Stack wrap>
                    {searchMatches.map((node) => (
                      <Stack.Item key={node.id} mr={1} mb={1}>
                        <TechNodeCard
                          node={node}
                          selected={selectedNode?.id === node.id}
                          onSelect={() => setSelectedNodeId(node.id)}
                        />
                      </Stack.Item>
                    ))}
                  </Stack>
                )
              ) : (
                <Box
                  style={{
                    position: 'relative',
                    width: `${layout.canvasWidth}px`,
                    height: `${layout.canvasHeight}px`,
                    margin: '0 auto',
                  }}
                >
                  <svg
                    width={layout.canvasWidth}
                    height={layout.canvasHeight}
                    style={{
                      position: 'absolute',
                      top: 0,
                      left: 0,
                      pointerEvents: 'none',
                    }}
                  >
                    {layout.edges.map(({ key, from, to }) => {
                      const x1 = from.x + NODE_W / 2;
                      const y1 = from.y + NODE_H;
                      const x2 = to.x + NODE_W / 2;
                      const y2 = to.y;
                      const midY = (y1 + y2) / 2;
                      const bothUnlocked =
                        Boolean(from.node.unlocked) &&
                        Boolean(to.node.unlocked);
                      const parentUnlocked = Boolean(from.node.unlocked);
                      const stroke = bothUnlocked
                        ? '#28a745'
                        : parentUnlocked
                          ? '#17a2b8'
                          : '#555';
                      return (
                        <path
                          key={key}
                          d={`M ${x1} ${y1} C ${x1} ${midY}, ${x2} ${midY}, ${x2} ${y2}`}
                          fill="none"
                          stroke={stroke}
                          strokeWidth={bothUnlocked || parentUnlocked ? 3 : 2}
                          strokeDasharray={parentUnlocked ? undefined : '5,4'}
                        />
                      );
                    })}
                  </svg>

                  {Object.values(layout.positions).map(({ x, y, node }) => (
                    <Box
                      key={node.id}
                      style={{
                        position: 'absolute',
                        left: `${x}px`,
                        top: `${y}px`,
                      }}
                    >
                      <TechNodeCard
                        node={node}
                        selected={selectedNode?.id === node.id}
                        onSelect={() => setSelectedNodeId(node.id)}
                      />
                    </Box>
                  ))}
                </Box>
              )}
            </Section>
          </Stack.Item>

          <Stack.Item width="360px" style={{ flexShrink: 0 }}>
            <Section fill title="Technology Node">
              {selectedNode ? (
                <Stack vertical fill>
                  <Stack.Item>
                    <Stack align="center" mb={0.8}>
                      <Stack.Item>
                        <Box
                          style={{
                            width: '48px',
                            height: '48px',
                            borderRadius: '6px',
                            border: '2px solid rgba(255, 255, 255, 0.2)',
                            backgroundColor: 'rgba(15, 20, 28, 0.9)',
                            display: 'flex',
                            alignItems: 'center',
                            justifyContent: 'center',
                          }}
                        >
                          <Icon
                            name={selectedNode.icon || 'flask'}
                            size={1.8}
                            color={
                              selectedNode.needs_maintenance
                                ? 'yellow'
                                : selectedNode.unlocked
                                  ? 'good'
                                  : selectedNode.can_unlock
                                    ? 'teal'
                                    : 'label'
                            }
                          />
                        </Box>
                      </Stack.Item>
                      <Stack.Item grow style={{ minWidth: 0 }}>
                        <Box bold fontSize={1.1} color="white">
                          {selectedNode.name}
                        </Box>
                        <Box fontSize={0.85} color="label">
                          {selectedNode.branch} • Tier {selectedNode.tier}
                        </Box>
                      </Stack.Item>
                    </Stack>
                  </Stack.Item>

                  <Stack.Item>
                    <Box mb={0.8}>
                      <Box bold fontSize={0.8} color="label" mb={0.2}>
                        CORPORATE SPONSOR
                      </Box>
                      <Box bold color="teal">
                        <Icon name="building" mr={0.5} />
                        {selectedNode.corporation || 'NanoTrasen'}
                      </Box>
                    </Box>

                    <Box mb={0.8}>
                      <Box bold fontSize={0.8} color="label" mb={0.2}>
                        RESEARCH COST
                      </Box>
                      <Box
                        bold
                        color={
                          selectedNode.cost <= 0
                            ? 'good'
                            : selectedNode.can_afford || selectedNode.unlocked
                              ? 'teal'
                              : 'yellow'
                        }
                      >
                        {selectedNode.cost > 0
                          ? `${selectedNode.cost.toLocaleString()} pts`
                          : 'Baseline (0 pts)'}
                      </Box>
                    </Box>

                    {Boolean(selectedNode.unlocked) &&
                      selectedNode.cost > 0 && (
                        <Box mb={0.8}>
                          <Box bold fontSize={0.8} color="label" mb={0.2}>
                            PERSISTENCE STABILITY
                          </Box>
                          <Box
                            bold
                            color={
                              selectedNode.needs_maintenance ? 'yellow' : 'good'
                            }
                          >
                            {(
                              selectedNode.invested ?? selectedNode.cost
                            ).toLocaleString()}{' '}
                            / {selectedNode.cost.toLocaleString()} pts
                          </Box>
                          {Boolean(selectedNode.is_outermost) && (
                            <Box fontSize={0.8} italic color="grey">
                              Outermost node — decays at{' '}
                              {selectedNode.cost.toLocaleString()} pts/day
                              across rounds
                            </Box>
                          )}
                        </Box>
                      )}

                    <Box mb={0.8}>
                      <Box bold fontSize={0.8} color="label" mb={0.2}>
                        OVERVIEW
                      </Box>
                      <Box fontSize={0.95} color="silver">
                        {selectedNode.description}
                      </Box>
                    </Box>

                    <Box mb={0.8}>
                      <Box bold fontSize={0.8} color="label" mb={0.3}>
                        PREREQUISITES
                      </Box>
                      {selectedNode.prereqs.length > 0 ? (
                        <Stack wrap>
                          {selectedNode.prereqs.map((prereqId) => {
                            const pNode = techNodes.find(
                              (p) => p.id === prereqId,
                            );
                            const met = Boolean(pNode?.unlocked);
                            return (
                              <Stack.Item key={prereqId} mr={0.5} mb={0.5}>
                                <Button
                                  compact
                                  icon={met ? 'check' : 'times'}
                                  color={met ? 'good' : 'bad'}
                                  content={pNode ? pNode.name : prereqId}
                                  onClick={() => {
                                    if (pNode) {
                                      setSelectedBranch(pNode.branch);
                                      setSelectedNodeId(pNode.id);
                                    }
                                  }}
                                />
                              </Stack.Item>
                            );
                          })}
                        </Stack>
                      ) : (
                        <Box fontSize={0.9} color="grey">
                          No prerequisites
                        </Box>
                      )}
                    </Box>
                  </Stack.Item>

                  <Stack.Item grow style={{ minHeight: 0 }}>
                    <Box bold fontSize={0.8} color="label" mb={0.3}>
                      UNLOCKS ({selectedNode.unlocks.length})
                    </Box>
                    <Section
                      fill
                      scrollable
                      style={{ backgroundColor: 'rgba(10, 12, 16, 0.5)' }}
                    >
                      {selectedNode.unlocks.length > 0 ? (
                        selectedNode.unlocks.map((item, idx) => (
                          <Box
                            key={`${item}-${idx}`}
                            fontSize={0.9}
                            color="teal"
                            mb={0.2}
                          >
                            • {item}
                          </Box>
                        ))
                      ) : (
                        <Box fontSize={0.9} color="grey">
                          None
                        </Box>
                      )}
                    </Section>
                  </Stack.Item>

                  <Stack.Item mt={0.8}>
                    {selectedNode.needs_maintenance ? (
                      <Button
                        fluid
                        textAlign="center"
                        color="average"
                        icon="wrench"
                        disabled={researchPoints <= 0}
                        content={
                          researchPoints > 0
                            ? `Maintain (+${Math.min(researchPoints, selectedNode.cost - (selectedNode.invested ?? 0)).toLocaleString()} pts)`
                            : `Decayed (${selectedNode.invested ?? 0}/${selectedNode.cost} pts)`
                        }
                        onClick={() =>
                          act('maintain_node', { id: selectedNode.id })
                        }
                      />
                    ) : selectedNode.unlocked ? (
                      <Button
                        fluid
                        textAlign="center"
                        disabled
                        color="good"
                        icon="check"
                        content="Researched"
                      />
                    ) : selectedNode.can_unlock && selectedNode.can_afford ? (
                      <Button
                        fluid
                        textAlign="center"
                        color="green"
                        icon="lightbulb"
                        content={`Research (${selectedNode.cost.toLocaleString()} pts)`}
                        onClick={() =>
                          act('unlock_node', { id: selectedNode.id })
                        }
                      />
                    ) : selectedNode.can_unlock && !selectedNode.can_afford ? (
                      <Button
                        fluid
                        textAlign="center"
                        disabled
                        icon="coins"
                        content={`Need ${(selectedNode.cost - researchPoints).toLocaleString()} more pts`}
                      />
                    ) : (
                      <Button
                        fluid
                        textAlign="center"
                        disabled
                        icon="lock"
                        content="Prerequisites Locked"
                      />
                    )}
                  </Stack.Item>
                </Stack>
              ) : (
                <NoticeBox>Select a technology node to inspect.</NoticeBox>
              )}
            </Section>
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};

const DesignList = ({ designs }: { designs: Design[] }) => {
  const [searchTerm, setSearchTerm] = useLocalState(
    'research-design-search',
    '',
  );
  const search = searchTerm.trim().toLowerCase();
  const visible = designs.filter(
    (design) => !search || design.name.toLowerCase().includes(search),
  );

  return (
    <Section
      fill
      scrollable
      title="Researched Designs"
      buttons={
        <Stack>
          <Stack.Item>
            <SearchBar
              query={searchTerm}
              onSearch={setSearchTerm}
              placeholder="Search designs"
            />
          </Stack.Item>
          <Stack.Item>
            <BackButton />
          </Stack.Item>
        </Stack>
      }
    >
      <Table>
        <Table.Row header>
          <Table.Cell>Name</Table.Cell>
          <Table.Cell>Category</Table.Cell>
          <Table.Cell>Description</Table.Cell>
        </Table.Row>
        {visible.map((design) => (
          <Table.Row key={design.path}>
            <Table.Cell>{design.name}</Table.Cell>
            <Table.Cell>{design.category}</Table.Cell>
            <Table.Cell>{design.description}</Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
};

const DiskMenu = ({
  technologies,
  designs,
}: {
  technologies?: Technology[];
  designs?: Design[];
}) => {
  const { act, data } = useBackend<ResearchConsoleData>();
  const disk = data.loaded_disk;

  if (!disk) {
    return (
      <Section title="Disk Operations" buttons={<BackButton />}>
        <NoticeBox>No disk loaded.</NoticeBox>
      </Section>
    );
  }

  return (
    <Stack vertical fill>
      <Stack.Item>
        <Section title="Disk Operations" buttons={<BackButton />}>
          <LabeledList>
            <LabeledList.Item label="Disk">{disk.name}</LabeledList.Item>
            <LabeledList.Item label="Stored data">
              {disk.stored_name ?? 'Empty'}
            </LabeledList.Item>
            {!!disk.stored_description && (
              <LabeledList.Item label="Description">
                {disk.stored_description}
              </LabeledList.Item>
            )}
          </LabeledList>
          <Button
            icon="upload"
            content="Upload to Database"
            disabled={!disk.stored_name}
            onClick={() => act('upload_disk')}
          />
          <Button.Confirm
            icon="eraser"
            content="Erase Disk"
            disabled={!disk.stored_name}
            onClick={() => act('clear_disk')}
          />
          <Button
            icon="eject"
            content="Eject Disk"
            onClick={() => act('eject_disk')}
          />
        </Section>
      </Stack.Item>

      <Stack.Item grow>
        {disk.type === 'technology' ? (
          <Section fill scrollable title="Copy Technology to Disk">
            <LabeledList>
              {technologies?.map((technology) => (
                <LabeledList.Item
                  key={technology.id}
                  label={technology.name}
                  buttons={
                    <Button
                      icon="copy"
                      content="Copy"
                      onClick={() => act('copy_tech', { id: technology.id })}
                    />
                  }
                >
                  Level {technology.level}
                </LabeledList.Item>
              ))}
            </LabeledList>
          </Section>
        ) : (
          <Section fill scrollable title="Copy Design to Disk">
            <LabeledList>
              {designs?.map((design) => (
                <LabeledList.Item
                  key={design.path}
                  label={design.name}
                  buttons={
                    <Button
                      icon="copy"
                      content="Copy"
                      onClick={() =>
                        act('copy_design', { design: design.path })
                      }
                    />
                  }
                >
                  {design.category}
                </LabeledList.Item>
              ))}
            </LabeledList>
          </Section>
        )}
      </Stack.Item>
    </Stack>
  );
};

const BountyList = ({
  bounties,
  rerolls,
  emptyText,
}: {
  bounties: ResearchBounty[];
  rerolls: number;
  emptyText: string;
}) => {
  const { act } = useBackend();
  if (bounties.length === 0) {
    return <NoticeBox>{emptyText}</NoticeBox>;
  }
  return (
    <Stack vertical>
      {bounties.map((bounty) => (
        <Stack.Item key={bounty.id} mb={1}>
          <Section
            title={`${bounty.corporation} — ${bounty.title}`}
            buttons={
              <Stack align="center">
                {Boolean(bounty.matches_loaded) && (
                  <Stack.Item>
                    <Box bold color="good" mr={1}>
                      <Icon name="check-circle" mr={0.3} />
                      Loaded Item Matches!
                    </Box>
                  </Stack.Item>
                )}
                <Stack.Item>
                  <Box bold color="teal" mr={1}>
                    +{bounty.reward_points.toLocaleString()} pts
                  </Box>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    icon="sync"
                    disabled={rerolls <= 0}
                    tooltip={
                      rerolls > 0
                        ? `Use 1 reroll (${rerolls} remaining)`
                        : 'No rerolls remaining — complete a bounty to earn +1'
                    }
                    content="New Contract"
                    onClick={() => act('reroll_bounty', { id: bounty.id })}
                  />
                </Stack.Item>
              </Stack>
            }
          >
            <Box mb={0.5}>{bounty.description}</Box>
            {bounty.input_spec && bounty.output_spec && (
              <Box fontSize={0.9} mb={0.5}>
                <Box>
                  <Box bold inline mr={0.5} color="label">
                    Inputs:
                  </Box>
                  <Box inline>{bounty.input_spec}</Box>
                </Box>
                <Box>
                  <Box bold inline mr={0.5} color="label">
                    Outputs:
                  </Box>
                  <Box inline>{bounty.output_spec}</Box>
                </Box>
              </Box>
            )}
            <Box fontSize={0.9}>
              <Box bold inline mr={0.5} color="label">
                Required Criteria:
              </Box>
              <Box inline color="teal">
                {bounty.criteria.join(' • ')}
              </Box>
            </Box>
            {bounty.test_summary && (
              <Box
                fontSize={0.9}
                mt={0.5}
                bold
                color={bounty.matches_loaded ? 'good' : 'bad'}
              >
                <Icon
                  name={bounty.matches_loaded ? 'check' : 'times'}
                  mr={0.4}
                />
                Unit Test Result: {bounty.test_summary}
              </Box>
            )}
          </Section>
        </Stack.Item>
      ))}
    </Stack>
  );
};

const Analyzer = ({ analyzer }: { analyzer?: AnalyzerData }) => {
  const { act } = useBackend();
  const [bountyTab, setBountyTab] = useLocalState<
    | 'firearms'
    | 'xenobotany'
    | 'xenobiology'
    | 'circuits'
    | 'survey'
    | 'xenoarch'
  >('research-bounty-tab', 'firearms');

  const bounties = analyzer?.bounties ?? [];
  const firearmBounties = bounties.filter((b) => b.category === 'firearms');
  const xenobotanyBounties = bounties.filter(
    (b) => b.category === 'xenobotany',
  );
  const xenobiologyBounties = bounties.filter(
    (b) => b.category === 'xenobiology',
  );
  const circuitBounties = bounties.filter((b) => b.category === 'circuits');
  const surveyBounties = bounties.filter((b) => b.category === 'survey');
  const xenoarchBounties = bounties.filter((b) => b.category === 'xenoarch');
  const isBountyItem = Boolean(
    analyzer?.item?.is_prototype ||
      analyzer?.item?.is_seed ||
      analyzer?.item?.is_slime_core ||
      analyzer?.item?.is_circuit ||
      analyzer?.item?.is_survey_disk ||
      analyzer?.item?.is_artifact,
  );

  return (
    <Stack vertical>
      <Stack.Item>
        <Section title="Destructive Analyzer" buttons={<BackButton />}>
          {!analyzer?.linked ? (
            <NoticeBox danger>No destructive analyzer linked.</NoticeBox>
          ) : analyzer.busy ? (
            <NoticeBox info>The analyzer is currently processing.</NoticeBox>
          ) : !analyzer.item ? (
            <NoticeBox>
              No item loaded. Insert a custom prototype energy weapon, plant
              seed packet, slime extract, custom electronic assembly, planetary
              survey data disk, or drag-and-drop an alien artifact onto the
              Destructive Analyzer.
            </NoticeBox>
          ) : (
            <>
              <Box bold fontSize={1.3} mb={1}>
                {analyzer.item.name}
              </Box>
              {isBountyItem ? (
                analyzer.item.matched_bounty ? (
                  <NoticeBox success mb={1}>
                    <Icon name="check-circle" mr={1} />
                    Matches Contract: <b>{analyzer.item.matched_bounty}</b> —
                    Reward:{' '}
                    <b>+{(analyzer.item.points ?? 0).toLocaleString()}</b>{' '}
                    Research Data Points
                  </NoticeBox>
                ) : (
                  <NoticeBox danger mb={1}>
                    <Icon name="exclamation-triangle" mr={1} />
                    Does not match any active corporate request. Analyzing will
                    only yield{' '}
                    <b>+{(analyzer.item.points ?? 0).toLocaleString()}</b>{' '}
                    baseline points.
                  </NoticeBox>
                )
              ) : (
                analyzer.item.points !== undefined &&
                analyzer.item.points > 0 && (
                  <NoticeBox success mb={1}>
                    <Icon name="atom" mr={1} />
                    Estimated Research Yield:{' '}
                    <b>+{analyzer.item.points.toLocaleString()}</b> Research
                    Data Points
                  </NoticeBox>
                )
              )}

              {analyzer.item.specs && (
                <Box mb={1}>
                  <LabeledList>
                    <LabeledList.Item label="Damage">
                      {analyzer.item.specs.damage} (AP:{' '}
                      {analyzer.item.specs.armor_penetration}%,{' '}
                      {analyzer.item.specs.stun ? 'Stun-Capable' : 'Lethal'})
                    </LabeledList.Item>
                    <LabeledList.Item label="Burst / Fire Delay">
                      Burst {analyzer.item.specs.burst} / Delay{' '}
                      {analyzer.item.specs.fire_delay}
                    </LabeledList.Item>
                    <LabeledList.Item label="Capacity / Recharge">
                      {analyzer.item.specs.max_shots} shots (
                      {analyzer.item.specs.self_recharge
                        ? 'Self-Recharging'
                        : 'External Cell'}
                      )
                    </LabeledList.Item>
                    <LabeledList.Item label="Reliability / Mods">
                      {analyzer.item.specs.reliability}% (
                      {analyzer.item.specs.mods_count} mods installed)
                    </LabeledList.Item>
                  </LabeledList>
                </Box>
              )}

              {analyzer.item.seed_specs && (
                <Box mb={1}>
                  <LabeledList>
                    <LabeledList.Item label="Species">
                      {analyzer.item.seed_specs.species}
                    </LabeledList.Item>
                    <LabeledList.Item label="Potency / Yield / Endurance">
                      Potency {analyzer.item.seed_specs.potency} | Yield{' '}
                      {analyzer.item.seed_specs.yield} | Endurance{' '}
                      {analyzer.item.seed_specs.endurance}
                    </LabeledList.Item>
                    <LabeledList.Item label="Growth Cycle">
                      Maturation {analyzer.item.seed_specs.maturation} |
                      Production {analyzer.item.seed_specs.production}
                    </LabeledList.Item>
                    <LabeledList.Item label="Tolerances">
                      Toxins {analyzer.item.seed_specs.toxins_tolerance} | Heat{' '}
                      {analyzer.item.seed_specs.heat_tolerance}
                    </LabeledList.Item>
                    <LabeledList.Item label="Special Traits">
                      {analyzer.item.seed_specs.special_traits.length > 0
                        ? analyzer.item.seed_specs.special_traits.join(', ')
                        : 'None'}
                    </LabeledList.Item>
                  </LabeledList>
                </Box>
              )}

              {analyzer.item.circuit_specs && (
                <Box mb={1}>
                  <LabeledList>
                    <LabeledList.Item label="Total Circuits">
                      {analyzer.item.circuit_specs.components} installed
                    </LabeledList.Item>
                    <LabeledList.Item label="Detected Inputs">
                      Number Pads: {analyzer.item.circuit_specs.numberpads} |
                      Text Pads: {analyzer.item.circuit_specs.textpads} |
                      Buttons: {analyzer.item.circuit_specs.buttons} | Toggles:{' '}
                      {analyzer.item.circuit_specs.toggles}
                    </LabeledList.Item>
                    <LabeledList.Item label="Detected Outputs">
                      Screens: {analyzer.item.circuit_specs.screens}
                    </LabeledList.Item>
                  </LabeledList>
                </Box>
              )}

              {analyzer.item.slime_specs && (
                <Box mb={1}>
                  <LabeledList>
                    <LabeledList.Item label="Extract Status">
                      <Box
                        inline
                        bold
                        color={
                          analyzer.item.slime_specs.uses > 0 ? 'good' : 'bad'
                        }
                      >
                        {analyzer.item.slime_specs.uses > 0
                          ? `Active (${analyzer.item.slime_specs.uses} uses)`
                          : 'Inert / Depleted'}
                      </Box>
                    </LabeledList.Item>
                    <LabeledList.Item label="Enhanced">
                      {analyzer.item.slime_specs.enhanced ? 'Yes' : 'No'}
                    </LabeledList.Item>
                  </LabeledList>
                </Box>
              )}

              {analyzer.item.survey_specs && (
                <Box mb={1}>
                  <LabeledList>
                    <LabeledList.Item label="Target Sector">
                      {analyzer.item.survey_specs.planet}
                    </LabeledList.Item>
                    <LabeledList.Item label="Survey Probe Type">
                      {analyzer.item.survey_specs.survey_type}
                    </LabeledList.Item>
                  </LabeledList>
                </Box>
              )}

              {analyzer.item.artifact_specs && (
                <Box mb={1}>
                  <LabeledList>
                    <LabeledList.Item label="Artifact ID">
                      {analyzer.item.artifact_specs.artifact_id}
                    </LabeledList.Item>
                    <LabeledList.Item label="Primary Trigger">
                      {analyzer.item.artifact_specs.trigger_type}
                    </LabeledList.Item>
                    <LabeledList.Item label="Effect Signature">
                      {analyzer.item.artifact_specs.effect_type}
                    </LabeledList.Item>
                    <LabeledList.Item label="Secondary Resonance">
                      {analyzer.item.artifact_specs.has_secondary
                        ? 'Detected'
                        : 'None'}
                    </LabeledList.Item>
                  </LabeledList>
                </Box>
              )}

              <Button.Confirm
                icon="recycle"
                color={
                  isBountyItem && !analyzer.item.matched_bounty ? 'bad' : 'good'
                }
                content={
                  isBountyItem
                    ? analyzer.item.matched_bounty
                      ? 'Submit Sample & Claim Reward'
                      : 'Analyze Unmatched Sample'
                    : 'Process Survey Data Disk'
                }
                onClick={() => act('analyzer_deconstruct')}
              />
              <Button
                icon="eject"
                content="Eject Item"
                onClick={() => act('analyzer_eject')}
              />
            </>
          )}
        </Section>
      </Stack.Item>

      <Stack.Item>
        <Section
          title="Megacorporation Research Requests"
          buttons={
            <Box bold color={(analyzer?.bounty_rerolls ?? 0) > 0 ? 'teal' : 'bad'}>
              <Icon name="sync" mr={0.5} />
              Rerolls Remaining: {analyzer?.bounty_rerolls ?? 0}
            </Box>
          }
        >
          <Tabs mb={1}>
            <Tabs.Tab
              selected={bountyTab === 'firearms'}
              onClick={() => setBountyTab('firearms')}
            >
              <Icon name="crosshairs" mr={0.5} />
              Custom Firearm Data ({firearmBounties.length})
            </Tabs.Tab>
            <Tabs.Tab
              selected={bountyTab === 'xenobotany'}
              onClick={() => setBountyTab('xenobotany')}
            >
              <Icon name="seedling" mr={0.5} />
              Xenobotany Seed Data ({xenobotanyBounties.length})
            </Tabs.Tab>
            <Tabs.Tab
              selected={bountyTab === 'xenobiology'}
              onClick={() => setBountyTab('xenobiology')}
            >
              <Icon name="biohazard" mr={0.5} />
              Xenobiology Slime Cores ({xenobiologyBounties.length})
            </Tabs.Tab>
            <Tabs.Tab
              selected={bountyTab === 'circuits'}
              onClick={() => setBountyTab('circuits')}
            >
              <Icon name="microchip" mr={0.5} />
              Custom Circuit Requests ({circuitBounties.length})
            </Tabs.Tab>
            <Tabs.Tab
              selected={bountyTab === 'survey'}
              onClick={() => setBountyTab('survey')}
            >
              <Icon name="globe" mr={0.5} />
              Planetary Survey Data ({surveyBounties.length})
            </Tabs.Tab>
            <Tabs.Tab
              selected={bountyTab === 'xenoarch'}
              onClick={() => setBountyTab('xenoarch')}
            >
              <Icon name="gem" mr={0.5} />
              Xenoarchaeology Finds ({xenoarchBounties.length})
            </Tabs.Tab>
          </Tabs>

          {bountyTab === 'firearms' && (
            <BountyList
              bounties={firearmBounties}
              rerolls={analyzer?.bounty_rerolls ?? 0}
              emptyText="No active firearm requests available."
            />
          )}

          {bountyTab === 'xenobotany' && (
            <BountyList
              bounties={xenobotanyBounties}
              rerolls={analyzer?.bounty_rerolls ?? 0}
              emptyText="No active xenobotany seed requests available."
            />
          )}

          {bountyTab === 'xenobiology' && (
            <BountyList
              bounties={xenobiologyBounties}
              rerolls={analyzer?.bounty_rerolls ?? 0}
              emptyText="No active xenobiology slime core requests available."
            />
          )}

          {bountyTab === 'circuits' && (
            <BountyList
              bounties={circuitBounties}
              rerolls={analyzer?.bounty_rerolls ?? 0}
              emptyText="No active custom circuit requests available."
            />
          )}

          {bountyTab === 'survey' && (
            <BountyList
              bounties={surveyBounties}
              rerolls={analyzer?.bounty_rerolls ?? 0}
              emptyText="No active planetary survey requests available."
            />
          )}

          {bountyTab === 'xenoarch' && (
            <BountyList
              bounties={xenoarchBounties}
              rerolls={analyzer?.bounty_rerolls ?? 0}
              emptyText="No active xenoarchaeology requests available."
            />
          )}
        </Section>
      </Stack.Item>
    </Stack>
  );
};

const Settings = () => {
  const { act, data } = useBackend<ResearchConsoleData>();

  return (
    <Stack vertical>
      <Stack.Item>
        <Section title="Console Settings" buttons={<BackButton />}>
          <Button
            icon="network-wired"
            selected={!!data.network_sync}
            content={
              data.network_sync
                ? 'Network Connection Enabled'
                : 'Network Connection Disabled'
            }
            onClick={() => act('toggle_sync')}
          />
          <Button
            icon="sync"
            content="Sync Database with Network"
            disabled={!data.network_sync}
            onClick={() => act('sync_network')}
          />
          <Button
            icon="search"
            content="Find Nearby Devices"
            onClick={() => act('find_devices')}
          />
          <Button.Confirm
            icon="trash"
            color="bad"
            content="Reset Research Database"
            onClick={() => act('reset_database')}
          />
        </Section>
      </Stack.Item>

      <Stack.Item>
        <Section title="Linked Devices">
          {Object.entries(data.devices).map(([device, count]) => (
            <Button.Confirm
              key={device}
              icon="unlink"
              content={`Disconnect ${formatDeviceName(device)} (${count})`}
              disabled={!count}
              onClick={() => act('disconnect', { device })}
            />
          ))}
        </Section>
      </Stack.Item>
    </Stack>
  );
};

const formatDeviceName = (device: string) => {
  switch (device) {
    case 'analyzer':
      return 'Destructive Analyzer';
    case 'protolathe':
      return 'Protolathe';
    case 'imprinter':
      return 'Circuit Imprinter';
    case 'mechfab':
      return 'Synthetic Fabricator';
    case 'silo':
      return 'Material Silo';
    default:
      return device;
  }
};

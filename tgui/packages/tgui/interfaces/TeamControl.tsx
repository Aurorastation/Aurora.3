import {
  Box,
  Button,
  Dropdown,
  Input,
  LabeledList,
  NoticeBox,
  Section,
  Stack,
  Table,
  Tabs,
  Tooltip,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { useBackend, useLocalState } from '../backend';
import { NtosWindow } from '../layouts';
import { sanitizeText } from '../sanitize';

type CommsData = {
  emagged: BooleanLike;
  net_syscont: BooleanLike;
  ntnet_communications_available: BooleanLike;
  message_printing_intercepts: BooleanLike;
  have_printer: BooleanLike;

  can_call_shuttle: BooleanLike;
  isAI: BooleanLike;
  authenticated: BooleanLike;
  boss_short: string;
  current_security_level: number;
  current_maint_all_access: BooleanLike;

  def_SEC_LEVEL_YELLOW: number;
  def_SEC_LEVEL_BLUE: number;
  def_SEC_LEVEL_GREEN: number;

  messages: Message[];

  evac_options: EvacOption[];
};

type Message = {
  id: number;
  title: string;
  contents: string;
};

type EvacOption = {
  option_text: string;
  option_target: string;
  needs_syscontrol: BooleanLike;
  silicon_allowed: BooleanLike;
};

type TeamControlData = CommsData & {
  destination_contacts: DestinationContact[];
  teams: Team[];
};

type Team = {
  id: string;
  name: string;
  lead: string;
  operator: string;
  primary_objective: string;
  secondary_objective: string;
  group_summary: string;
  destination_context: DestinationContext;
  roster: RosterRow[];
  logs: LogEntry[];
};

type DestinationContext = {
  name: string;
  contact_status: string;
};

type DestinationContact = {
  name: string;
  ref: string;
  source: string;
};

type RosterRow = {
  key: string;
  name: string;
  assignment: string;
  is_lead: BooleanLike;
  state: string;
  location_state: string;
  area: string;
  x: number;
  y: number;
  z: number;
  sector: string;
  deployed_offship: BooleanLike;
  lead_distance_band: string;
  lead_offset: string;
  group_relationship: string;
  group_type: string;
  group_sort: number;
};

type MonitorRow = RosterRow & {
  teamId: string;
  teamName: string;
};

type LogEntry = {
  time: string;
  world_time: number;
  action: string;
  actor: string;
  details: string;
};

const emptyDestination: DestinationContext = {
  name: 'Unknown',
  contact_status: 'unset',
};

export const TeamControl = (props) => {
  const { act, data } = useBackend<TeamControlData>();
  const teams = data.teams || [];
  const [selectedTeamId, setSelectedTeamId] = useLocalState<string>(
    'selectedTeamId',
    teams[0]?.id || '',
  );
  const [commandPanel, setCommandPanel] = useLocalState<string>(
    'commandPanel',
    'comms',
  );

  const selectedTeam =
    teams.find((team) => team.id === selectedTeamId) || teams[0] || null;
  const monitorRows = sortRosterRows(
    selectedTeam
      ? (selectedTeam.roster || []).map((row) => ({
          ...row,
          teamId: selectedTeam.id,
          teamName: selectedTeam.name,
        }))
      : [],
  );

  return (
    <NtosWindow width={1800} height={1000}>
      <NtosWindow.Content scrollable>
        {!data.authenticated ? (
          <NoticeBox>Command access required.</NoticeBox>
        ) : (
          ''
        )}
        <Stack vertical fill>
          <Stack.Item basis="45%">
            <CommandOverview
              teams={teams}
              commandPanel={commandPanel}
              setCommandPanel={setCommandPanel}
              ntnetAvailable={data.ntnet_communications_available}
            />
          </Stack.Item>
          <Stack.Item grow>
            <TeamsSection
              teams={teams}
              selectedTeam={selectedTeam}
              selectedTeamId={selectedTeam?.id || ''}
              setSelectedTeamId={setSelectedTeamId}
              monitorRows={monitorRows}
              destinationContacts={data.destination_contacts || []}
              act={act}
            />
          </Stack.Item>
        </Stack>
      </NtosWindow.Content>
    </NtosWindow>
  );
};

const CommandOverview = (props: {
  teams: Team[];
  commandPanel: string;
  setCommandPanel: (value: string) => void;
  ntnetAvailable: BooleanLike;
}) => {
  const { teams, commandPanel, setCommandPanel, ntnetAvailable } = props;
  const visiblePanel = ['messages', 'logs'].includes(commandPanel)
    ? commandPanel
    : 'comms';

  return (
    <Section
      title="Command Overview"
      buttons={
        <Button
          icon="network-wired"
          content={`NTNet ${ntnetAvailable ? 'Available' : 'Unavailable'}`}
          color={ntnetAvailable ? 'green' : 'red'}
        />
      }
      fill
    >
      <Stack fill>
        <Stack.Item width="18%">
          <Tabs fluid vertical>
            <Tabs.Tab
              selected={visiblePanel === 'comms'}
              icon="building-columns"
              onClick={() => setCommandPanel('comms')}
            >
              Comms
            </Tabs.Tab>
            <Tabs.Tab
              selected={visiblePanel === 'messages'}
              icon="envelope-open-text"
              onClick={() => setCommandPanel('messages')}
            >
              Messages
            </Tabs.Tab>
            <Tabs.Tab
              selected={visiblePanel === 'logs'}
              icon="list"
              onClick={() => setCommandPanel('logs')}
            >
              Logs
            </Tabs.Tab>
          </Tabs>
        </Stack.Item>
        <Stack.Item width="1%"></Stack.Item>
        <Stack.Item grow>
          {visiblePanel === 'comms' && <CommandCommsPanel />}
          {visiblePanel === 'messages' && <CommandMessagesPanel />}
          {visiblePanel === 'logs' && <CommandLogs teams={teams} />}
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const TeamsSection = (props: {
  teams: Team[];
  selectedTeam: Team | null;
  selectedTeamId: string;
  setSelectedTeamId: (value: string) => void;
  monitorRows: MonitorRow[];
  destinationContacts: DestinationContact[];
  act: (action: string, params?: Record<string, unknown>) => void;
}) => {
  const {
    teams,
    selectedTeam,
    selectedTeamId,
    setSelectedTeamId,
    monitorRows,
    destinationContacts,
    act,
  } = props;

  return (
    <Section title="Teams" fill>
      {teams.length ? (
        <Stack vertical fill>
          <Stack.Item>
            <Tabs fluid>
              {teams.map((team) => (
                <Tabs.Tab
                  key={team.id}
                  selected={selectedTeamId === team.id}
                  onClick={() => setSelectedTeamId(team.id)}
                >
                  {team.name}
                </Tabs.Tab>
              ))}
            </Tabs>
          </Stack.Item>
          <Stack.Item grow>
            <Stack fill>
              <Stack.Item width="31%">
                {selectedTeam ? (
                  <TeamStatusOrders
                    team={selectedTeam}
                    destinationContacts={destinationContacts}
                    act={act}
                  />
                ) : (
                  <NoticeBox>No team selected.</NoticeBox>
                )}
              </Stack.Item>
              <Stack.Item width="1%"></Stack.Item>
              <Stack.Item grow>
                <TeamMonitor
                  rows={monitorRows}
                  showTeam={false}
                  act={act}
                />
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      ) : (
        <NoticeBox>No teams available.</NoticeBox>
      )}
    </Section>
  );
};

const TeamStatusOrders = (props: {
  team: Team;
  destinationContacts: DestinationContact[];
  act: (action: string, params?: Record<string, unknown>) => void;
}) => {
  const { team, destinationContacts, act } = props;
  const destination = team.destination_context || emptyDestination;
  const destinationOptions = destinationContacts.map((contact) => ({
    displayText: `${contact.name} (${contact.source})`,
    value: contact.ref,
  }));

  return (
    <Section
      title="Team Status / Orders"
      fill
      scrollable
      buttons={
        <>
          <Button
            icon="user-check"
            tooltip="Claim"
            disabled={team.operator !== 'Unassigned'}
            onClick={() => act('claim', { id: team.id })}
          />
          <Button
            icon="user-pen"
            tooltip="Override"
            disabled={team.operator === 'Unassigned'}
            onClick={() => act('override', { id: team.id })}
          />
          <Button
            icon="user-xmark"
            tooltip="Release"
            disabled={team.operator === 'Unassigned'}
            onClick={() => act('release', { id: team.id })}
          />
          <Button
            icon="user-plus"
            tooltip="Add Member"
            onClick={() => act('add_member', { id: team.id })}
          />
          <Button
            icon="pen"
            tooltip="Rename"
            onClick={() => act('rename_team', { id: team.id })}
          />
          <Button
            icon="dice"
            tooltip="Random Name"
            onClick={() => act('randomize_team_name', { id: team.id })}
          />
        </>
      }
    >
      <LabeledList>
        <LabeledList.Item label="Operator">
          {team.operator}
        </LabeledList.Item>
        <LabeledList.Item label="Lead">{team.lead}</LabeledList.Item>
        <LabeledList.Item label="Group Status">
          {team.group_summary}
        </LabeledList.Item>
        <LabeledList.Item label="Primary">
          <Stack align="center">
            <Stack.Item grow>{team.primary_objective || 'Unset'}</Stack.Item>
            <Stack.Item>
              <Button
                icon="pen-to-square"
                tooltip="Set"
                onClick={() =>
                  act('set_objective', { id: team.id, slot: 'primary' })
                }
              />
              <Button
                icon="bell"
                tooltip="Remind"
                disabled={!team.primary_objective}
                onClick={() =>
                  act('remind_objective', { id: team.id, slot: 'primary' })
                }
              />
              <Button
                icon="trash"
                tooltip="Clear"
                color="red"
                disabled={!team.primary_objective}
                onClick={() =>
                  act('clear_objective', { id: team.id, slot: 'primary' })
                }
              />
            </Stack.Item>
          </Stack>
        </LabeledList.Item>
        <LabeledList.Item label="Secondary">
          <Stack align="center">
            <Stack.Item grow>{team.secondary_objective || 'Unset'}</Stack.Item>
            <Stack.Item>
              <Button
                icon="pen-to-square"
                tooltip="Set"
                onClick={() =>
                  act('set_objective', { id: team.id, slot: 'secondary' })
                }
              />
              <Button
                icon="bell"
                tooltip="Remind"
                disabled={!team.secondary_objective}
                onClick={() =>
                  act('remind_objective', {
                    id: team.id,
                    slot: 'secondary',
                  })
                }
              />
              <Button
                icon="trash"
                tooltip="Clear"
                color="red"
                disabled={!team.secondary_objective}
                onClick={() =>
                  act('clear_objective', {
                    id: team.id,
                    slot: 'secondary',
                  })
                }
              />
            </Stack.Item>
          </Stack>
        </LabeledList.Item>
        <LabeledList.Item label="Destination">
          <Stack align="center">
            <Stack.Item grow>{destination.name}</Stack.Item>
            <Stack.Item>
              <Dropdown
                width="220px"
                selected={null}
                options={destinationOptions}
                placeholder={
                  destinationOptions.length
                    ? 'Set destination...'
                    : 'No contacts'
                }
                disabled={!destinationOptions.length}
                onSelected={(value) =>
                  act('set_destination', {
                    id: team.id,
                    contact: value,
                  })
                }
              />
            </Stack.Item>
            <Stack.Item>
              <Button
                icon="xmark"
                tooltip="Clear"
                disabled={destination.contact_status === 'unset'}
                onClick={() => act('clear_destination', { id: team.id })}
              />
            </Stack.Item>
          </Stack>
        </LabeledList.Item>
        <LabeledList.Item label="Contact Status">
          {destination.contact_status}
        </LabeledList.Item>
      </LabeledList>
      <Button
        fluid
        mt={1}
        icon="envelope"
        content="Message Team"
        onClick={() => act('message_team', { id: team.id })}
      />
      <Button
        fluid
        icon="user"
        content="Message Lead"
        disabled={team.lead === 'Unassigned'}
        onClick={() => act('message_lead', { id: team.id })}
      />
    </Section>
  );
};


const CommandCommsPanel = (props) => {
  return (
    <Stack fill>
      <Stack.Item width="50%">
        <CommunicationsOptions />
      </Stack.Item>
      <Stack.Item width="50%">
        <StatusDisplaySettings />
      </Stack.Item>
    </Stack>
  );
};

const CommandMessagesPanel = (props) => {
  const { data } = useBackend<TeamControlData>();

  return (
    <Section title="Message List" fill scrollable>
      {data.messages?.length ? (
        <MessageList
          messages={data.messages}
          havePrinter={data.have_printer}
          ntnetAvailable={data.ntnet_communications_available}
        />
      ) : (
        'There are no messages.'
      )}
    </Section>
  );
};

const CommunicationsOptions = (props) => {
  const { act, data } = useBackend<CommsData>();
  const [choosingAlert, setChoosingAlert] = useLocalState<boolean>(
    'choosingAlert',
    false,
  );

  return (
    <Section title="Communications Options">
      <Stack vertical>
        <Stack.Item>
          <Button
            content="Make Announcement"
            icon="newspaper"
            disabled={data.isAI || !data.ntnet_communications_available}
            onClick={() => act('announce')}
          />
        </Stack.Item>
        <Stack.Item>
          <Button
            content={
              data.emagged ? (
                <Box as="span">
                  Send Emergency Message To{' '}
                  <Box as="span" color="red">
                    #UNKN#
                  </Box>
                </Box>
              ) : (
                `Send Emergency Message To ${data.boss_short}`
              )
            }
            icon="compass"
            disabled={data.isAI || !data.ntnet_communications_available}
            onClick={() =>
              act('message', {
                target: data.emagged ? 'emagged' : 'regular',
              })
            }
          />
        </Stack.Item>
        <Stack.Item>
          <Button
            content="Change Alert Level"
            icon="lightbulb"
            selected={choosingAlert}
            disabled={!data.ntnet_communications_available || !data.net_syscont}
            onClick={() => setChoosingAlert(!choosingAlert)}
          />
          {choosingAlert ? (
            <>
              <Button
                content="Green"
                color="green"
                disabled={
                  data.current_security_level === data.def_SEC_LEVEL_GREEN ||
                  !data.ntnet_communications_available ||
                  !data.net_syscont
                }
                onClick={() =>
                  act('setalert', { target: data.def_SEC_LEVEL_GREEN })
                }
              />
              <Button
                content="Blue"
                color="blue"
                disabled={
                  data.current_security_level === data.def_SEC_LEVEL_BLUE ||
                  !data.ntnet_communications_available ||
                  !data.net_syscont
                }
                onClick={() =>
                  act('setalert', { target: data.def_SEC_LEVEL_BLUE })
                }
              />
              <Button
                content="Yellow"
                color="yellow"
                disabled={
                  data.current_security_level === data.def_SEC_LEVEL_YELLOW ||
                  !data.ntnet_communications_available ||
                  !data.net_syscont
                }
                onClick={() =>
                  act('setalert', { target: data.def_SEC_LEVEL_YELLOW })
                }
              />
            </>
          ) : (
            ''
          )}
        </Stack.Item>
        <Stack.Item>
          <Button
            content={
              data.current_maint_all_access
                ? 'Disable Maintenance Emergency Access'
                : 'Enable Maintenance Emergency Access'
            }
            color={data.current_maint_all_access ? 'red' : ''}
            icon="door-closed"
            onClick={() => act('emergencymaint')}
          />
        </Stack.Item>
        <Stack.Item>
          <Button
            content={
              data.message_printing_intercepts
                ? 'Disable Message Print Intercept'
                : 'Enable Message Print Intercept'
            }
            icon="print"
            selected={!!data.message_printing_intercepts}
            disabled={!data.have_printer || !data.ntnet_communications_available}
            onClick={() => act('toggleintercept')}
          />
        </Stack.Item>
        {!!data.can_call_shuttle && !!data.evac_options?.length && (
          <Stack.Item>
            <Section title="Evacuation">
              {data.evac_options.map((option) => (
                <Button
                  key={option.option_target}
                  content={option.option_text}
                  icon="door-open"
                  disabled={
                    !data.can_call_shuttle ||
                    (!!option.needs_syscontrol && !data.net_syscont) ||
                    (!!data.isAI && !option.silicon_allowed)
                  }
                  onClick={() =>
                    act('evac', { target: option.option_target })
                  }
                />
              ))}
            </Section>
          </Stack.Item>
        )}
      </Stack>
    </Section>
  );
};

const StatusDisplaySettings = (props) => {
  const { act } = useBackend<CommsData>();
  const [firstLine, setFirstLine] = useLocalState<string>('firstLine', '');
  const [secondLine, setSecondLine] = useLocalState<string>('secondLine', '');

  return (
    <Section
      title="Status Display Settings"
      buttons={
        <Button
          content="Clear"
          icon="trash"
          onClick={() => act('setstatus', { target: 'blank' })}
        />
      }
    >
      <Button
        content="Ship Time"
        icon="clock"
        onClick={() => act('setstatus', { target: 'time' })}
      />
      <Button
        content="ETA"
        icon="door-open"
        onClick={() => act('setstatus', { target: 'shuttle' })}
      />
      <Section
        title="Custom Message"
        buttons={
          <Button
            content="Set"
            icon="check"
            onClick={() =>
              act('setstatus', {
                target: 'message',
                line1: firstLine,
                line2: secondLine,
              })
            }
          />
        }
      >
        <Input
          value={firstLine}
          placeholder="First line"
          width={20}
          onChange={(value) => setFirstLine(value)}
        />
        <Input
          value={secondLine}
          placeholder="Second line"
          width={20}
          onChange={(value) => setSecondLine(value)}
        />
      </Section>
      <Section title="Alerts">
        <Button
          content="Blue Alert"
          icon="circle-exclamation"
          color="blue"
          onClick={() =>
            act('setstatus', { target: 'alert', alert: 'bluealert' })
          }
        />
        <Button
          content="Red Alert"
          icon="triangle-exclamation"
          color="red"
          onClick={() =>
            act('setstatus', { target: 'alert', alert: 'redalert' })
          }
        />
        <Button
          content="Lockdown"
          icon="lock"
          color="average"
          onClick={() =>
            act('setstatus', { target: 'alert', alert: 'lockdown' })
          }
        />
        <Button
          content="Biohazard"
          icon="biohazard"
          color="yellow"
          onClick={() =>
            act('setstatus', { target: 'alert', alert: 'biohazard' })
          }
        />
        <Button
          content="Radiation"
          icon="radiation"
          color="yellow"
          onClick={() =>
            act('setstatus', { target: 'alert', alert: 'radiation' })
          }
        />
      </Section>
    </Section>
  );
};

const MessageList = (props: {
  messages: Message[];
  havePrinter: BooleanLike;
  ntnetAvailable: BooleanLike;
}) => {
  const { act } = useBackend<CommsData>();
  const { messages, havePrinter, ntnetAvailable } = props;
  const [viewingMessage, setViewingMessage] = useLocalState<string | null>(
    'viewingMessage',
    null,
  );
  const selectedMessage = messages.find(
    (message) => `${message.id}` === viewingMessage,
  );
  const activeMessage = selectedMessage || messages[messages.length - 1];

  return (
    <Stack fill>
      <Stack.Item width="30%">
        <Section title="History" fill scrollable>
          {messages.slice().reverse().map((message) => (
            <Button
              fluid
              key={message.id}
              content={message.title}
              selected={`${message.id}` === `${activeMessage?.id}`}
              onClick={() => setViewingMessage(`${message.id}`)}
            />
          ))}
        </Section>
      </Stack.Item>
      <Stack.Item grow>
        {activeMessage ? (
          <Section
            title={activeMessage.title}
            fill
            scrollable
            buttons={
              <Button
                content="Print"
                icon="print"
                disabled={!havePrinter || !ntnetAvailable}
                onClick={() =>
                  act('printmessage', {
                    contents: activeMessage.contents,
                    title: activeMessage.title,
                  })
                }
              />
            }
          >
            <Box
              // biome-ignore lint/security/noDangerouslySetInnerHtml: Is sanitized by DOMPurify.
              dangerouslySetInnerHTML={processMessage(activeMessage.contents)}
            />
          </Section>
        ) : (
          <NoticeBox>There are no messages.</NoticeBox>
        )}
      </Stack.Item>
    </Stack>
  );
};

const processMessage = (value) => {
  const contentHtml = { __html: sanitizeText(value) };
  return contentHtml;
};

const TeamMonitor = (props: {
  rows: MonitorRow[];
  showTeam: boolean;
  act: (action: string, params?: Record<string, unknown>) => void;
}) => {
  const {
    rows,
    showTeam,
    act,
  } = props;

  return (
    <Section fill scrollable fitted title={showTeam ? 'Command Monitor' : 'Team Monitor'}>
      <Table>
        <Table.Row header>
          {showTeam && <Table.Cell>Team</Table.Cell>}
          <Table.Cell header>Name</Table.Cell>
          <Table.Cell header>Assignment</Table.Cell>
          <Table.Cell header>Contact</Table.Cell>
          <Table.Cell header>X</Table.Cell>
          <Table.Cell header>Y</Table.Cell>
          <Table.Cell header>Z</Table.Cell>
          <Table.Cell header>
            <Tooltip content="Groups are automatic topology components: main body, detached subgroups, minor groups, or isolated members." position="top">
              <Box as="span" inline>
                Group
              </Box>
            </Tooltip>
          </Table.Cell>
          <Table.Cell header>
            <Tooltip content="Bands describe this member's distance range from the team lead when both have tracking-grade suit sensors." position="top">
              <Box as="span" inline>
                Band
              </Box>
            </Tooltip>
          </Table.Cell>
          <Table.Cell header>
            <Tooltip content="Offset shows this member's lead-relative area, range, bearing, z-level, or contact-level separation." position="top">
              <Box as="span" inline>
                Offset
              </Box>
            </Tooltip>
          </Table.Cell>
          {!showTeam && <Table.Cell>Actions</Table.Cell>}
        </Table.Row>
        {rows.length ? (
          rows.map((row) => (
            <Table.Row
              key={`${row.teamId}-${row.key}`}
              className="candystripe"
              color={row.is_lead ? 'yellow' : undefined}
            >
              {showTeam && <Table.Cell>{row.teamName}</Table.Cell>}
              <Table.Cell>{row.name}</Table.Cell>
              <Table.Cell>{row.assignment}</Table.Cell>
              <Table.Cell>
                {row.location_state === 'tracking'
                  ? `${row.sector}`
                  : row.location_state}
              </Table.Cell>
              <Table.Cell>{row.x}</Table.Cell>
              <Table.Cell>{row.y}</Table.Cell>
              <Table.Cell>{row.z}</Table.Cell>
              <Table.Cell color={groupRelationshipColor(row.group_type)}>
                {row.group_relationship}
              </Table.Cell>
              <Table.Cell color={leadDistanceBandColor(row.lead_distance_band)}>
                {row.lead_distance_band}
              </Table.Cell>
              <Table.Cell>{row.lead_offset}</Table.Cell>
              {!showTeam && (
                <Table.Cell>
                  <Button
                    icon="star"
                    tooltip="Set team lead"
                    color={row.is_lead ? 'yellow' : ''}
                    onClick={() =>
                      act('set_lead', {
                        id: row.teamId,
                        member: row.key,
                      })
                    }
                  />
                  <Button
                    icon="trash"
                    color="red"
                    tooltip="Remove from team"
                    onClick={() =>
                      act('remove_member', {
                        id: row.teamId,
                        member: row.key,
                      })
                    }
                  />
                </Table.Cell>
              )}
            </Table.Row>
          ))
        ) : (
          <Table.Row>
            <Table.Cell colSpan={9}>
              No roster rows available.
            </Table.Cell>
          </Table.Row>
        )}
      </Table>
    </Section>
  );
};

const CommandLogs = (props: { teams: Team[] }) => {
  const logs = props.teams
    .flatMap((team) =>
      (team.logs || []).map((log) => ({
        ...log,
        teamName: team.name,
      })),
    )
    .sort((a, b) => b.world_time - a.world_time);

  return (
    <Section title="Command Logs" fill scrollable>
      <Table>
        <Table.Row header>
          <Table.Cell>Time</Table.Cell>
          <Table.Cell>Team</Table.Cell>
          <Table.Cell>Actor</Table.Cell>
          <Table.Cell>Action</Table.Cell>
          <Table.Cell>Details</Table.Cell>
        </Table.Row>
        {logs.length ? (
          logs.map((log) => (
            <Table.Row
              key={`${log.teamName}-${log.world_time}-${log.action}-${log.actor}`}
            >
              <Table.Cell>{log.time}</Table.Cell>
              <Table.Cell>{log.teamName}</Table.Cell>
              <Table.Cell>{log.actor}</Table.Cell>
              <Table.Cell>{log.action}</Table.Cell>
              <Table.Cell>{log.details}</Table.Cell>
            </Table.Row>
          ))
        ) : (
          <Table.Row>
            <Table.Cell colSpan={5}>No logs available.</Table.Cell>
          </Table.Row>
        )}
      </Table>
    </Section>
  );
};

const sortRosterRows = (rows: MonitorRow[]) => {
  return rows
    .sort((a, b) => {
      const leadSort = Number(b.is_lead) - Number(a.is_lead);
      if (leadSort) {
        return leadSort;
      }
      const groupSort = (a.group_sort ?? 5000) - (b.group_sort ?? 5000);
      if (groupSort) {
        return groupSort;
      }
      const teamSort = a.teamName.localeCompare(b.teamName);
      if (teamSort) {
        return teamSort;
      }
      return a.name.localeCompare(b.name);
    });
};

const leadDistanceBandColor = (band: string) => {
  switch (band) {
    case 'Close':
      return 'good';
    case 'Extended':
      return 'average';
    case 'Distant':
    case 'Separate z':
      return 'bad';
    case 'No tracking':
      return 'yellow';
    default:
      return 'label';
  }
};

const groupRelationshipColor = (groupType: string) => {
  switch (groupType) {
    case 'main_body':
      return 'good';
    case 'detached_subgroup':
    case 'minor_detached_group':
      return 'average';
    case 'isolated':
      return 'bad';
    case 'untracked':
      return 'yellow';
    default:
      return 'label';
  }
};

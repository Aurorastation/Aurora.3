import { useState } from 'react';
import {
  Box,
  Button,
  LabeledList,
  NoticeBox,
  Section,
  Table,
  Tabs,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { useBackend, useLocalState } from '../backend';
import { Window } from '../layouts';

// ---- Types ----

type AirAlarmData = {
  // Status
  has_environment: BooleanLike;
  environment: EnvironmentEntry[];
  total_danger: number;
  atmos_alarm: BooleanLike;
  target_temperature: number;
  // Access
  locked: BooleanLike;
  remote_view: BooleanLike;
  shorted: BooleanLike;
  rcon: number;
  // Mode
  mode: number;
  modes: ModeEntry[];
  // Devices
  vents: VentEntry[];
  scrubbers: ScrubberEntry[];
  // Thresholds
  thresholds: ThresholdEntry[];
};

type EnvironmentEntry = {
  name: string;
  value: number;
  unit: string;
  danger_level: number;
};

type ModeEntry = {
  name: string;
  description: string;
  mode: number;
  danger: BooleanLike;
};

type VentEntry = {
  id_tag: string;
  long_name: string;
  power: BooleanLike;
  checks: number;
  direction: string;
  external: number;
};

type ScrubberEntry = {
  id_tag: string;
  long_name: string;
  power: BooleanLike;
  scrubbing: BooleanLike;
  panic: BooleanLike;
  filters: FilterEntry[];
};

type FilterEntry = {
  name: string;
  command: string;
  val: BooleanLike;
};

type ThresholdEntry = {
  name: string;
  settings: ThresholdSetting[];
};

type ThresholdSetting = {
  env: string;
  val: number;
  selected: number;
};

// ---- Helpers ----

const DANGER_COLOR: Record<number, string> = {
  0: 'good',
  1: 'average',
  2: 'bad',
};

const DANGER_LABEL: Record<number, string> = {
  0: 'Optimal',
  1: 'Caution',
  2: 'DANGER: Internals Required',
};

const RCON_NO = 1;
const RCON_AUTO = 2;
const RCON_YES = 3;

// ---- Root component ----

export const AirAlarm = (props) => {
  const { act, data } = useBackend<AirAlarmData>();
  const [tab, setTab] = useLocalState('tab', 'status');
  const lockedMessage = data.remote_view
    ? data.rcon === RCON_AUTO
      ? 'Remote control is available only while this alarm is active.'
      : 'Remote control is disabled for this alarm.'
    : 'Swipe ID card to unlock interface.';

  const tabs = [
    { id: 'status', label: 'Status' },
    { id: 'vents', label: 'Vents' },
    { id: 'scrubbers', label: 'Scrubbers' },
    { id: 'mode', label: 'Mode' },
    { id: 'sensors', label: 'Sensors' },
  ];

  return (
    <Window title="Air Alarm" width={380} height={580} theme="hephaestus">
      <Window.Content scrollable>
        <StatusSection />
        {data.locked ? (
          <NoticeBox>{lockedMessage}</NoticeBox>
        ) : (
          <Section>
            <Tabs>
              {tabs.map((t) => (
                <Tabs.Tab
                  key={t.id}
                  selected={tab === t.id}
                  onClick={() => setTab(t.id)}
                >
                  {t.label}
                </Tabs.Tab>
              ))}
            </Tabs>
            {tab === 'status' && <MainSection />}
            {tab === 'vents' && <VentsSection />}
            {tab === 'scrubbers' && <ScrubbersSection />}
            {tab === 'mode' && <ModeSection />}
            {tab === 'sensors' && <SensorsSection />}
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};

// ---- Status section (always visible) ----

const StatusSection = (props) => {
  const { act, data } = useBackend<AirAlarmData>();

  return (
    <Section title="Air Status">
      {data.has_environment ? (
        <LabeledList>
          {data.environment.map((entry) => (
            <LabeledList.Item key={entry.name} label={entry.name}>
              <Box color={DANGER_COLOR[entry.danger_level]}>
                {entry.value.toFixed(1)} {entry.unit}
              </Box>
            </LabeledList.Item>
          ))}
          <LabeledList.Item label="Local Status">
            <Box color={DANGER_COLOR[data.total_danger]}>
              {DANGER_LABEL[data.total_danger]}
            </Box>
          </LabeledList.Item>
          <LabeledList.Item label="Area Status">
            {data.atmos_alarm ? (
              <Box color="bad">Atmosphere alert in area</Box>
            ) : (
              'No alerts'
            )}
          </LabeledList.Item>
        </LabeledList>
      ) : (
        <NoticeBox danger>
          Warning: Cannot obtain air sample for analysis.
        </NoticeBox>
      )}
      <Box mt={1}>
        <LabeledList>
          <LabeledList.Item label="Remote Control">
            <Button
              content="Off"
              selected={data.rcon === RCON_NO}
              disabled={!!data.shorted || !!data.remote_view}
              onClick={() => act('rcon', { value: RCON_NO })}
            />
            <Button
              content="Auto"
              selected={data.rcon === RCON_AUTO}
              disabled={!!data.shorted || !!data.remote_view}
              onClick={() => act('rcon', { value: RCON_AUTO })}
            />
            <Button
              content="On"
              selected={data.rcon === RCON_YES}
              disabled={!!data.shorted || !!data.remote_view}
              onClick={() => act('rcon', { value: RCON_YES })}
            />
          </LabeledList.Item>
          <LabeledList.Item label="Thermostat">
            <Button
              content={`${data.target_temperature}°C`}
              disabled={!!data.shorted}
              onClick={() => act('temperature')}
            />
          </LabeledList.Item>
        </LabeledList>
      </Box>
    </Section>
  );
};

// ---- Main tab ----

const MainSection = (props) => {
  const { act, data } = useBackend<AirAlarmData>();

  return (
    <Section title="Controls">
      <Button
        fluid
        color={data.atmos_alarm ? 'good' : 'bad'}
        disabled={!!data.shorted}
        onClick={() => act(data.atmos_alarm ? 'atmos_reset' : 'atmos_alarm')}
      >
        {data.atmos_alarm
          ? 'Reset Area Atmospheric Alarm'
          : 'Activate Area Atmospheric Alarm'}
      </Button>
      <Box mt={1}>
        <Button
          fluid
          color={data.mode === 3 ? 'bad' : 'average'}
          disabled={!!data.shorted}
          onClick={() => act('mode', { mode: data.mode === 3 ? 1 : 3 })}
        >
          {data.mode === 3
            ? 'PANIC SIPHON ACTIVE — Turn off'
            : 'Activate Panic Siphon'}
        </Button>
      </Box>
    </Section>
  );
};

// ---- Vents tab ----

const VentsSection = (props) => {
  const { act, data } = useBackend<AirAlarmData>();
  const [ventOverrides, setVentOverrides] = useState<
    Record<string, Partial<Pick<VentEntry, 'power' | 'checks'>>>
  >({});

  if (!data.vents.length) {
    return <NoticeBox>No vents connected.</NoticeBox>;
  }

  return (
    <>
      {data.vents.map((vent) => {
        const localVent = ventOverrides[vent.id_tag];
        const power = localVent?.power ?? vent.power;
        const checks = localVent?.checks ?? vent.checks;

        return (
          <Section key={vent.id_tag} title={vent.long_name}>
            <LabeledList>
              <LabeledList.Item label="Operating">
                <Button
                  content={power ? 'On' : 'Off'}
                  color={power ? 'default' : 'bad'}
                  disabled={!!data.shorted}
                  onClick={() => {
                    const val = power ? 0 : 1;
                    setVentOverrides((vents) => ({
                      ...vents,
                      [vent.id_tag]: { ...vents[vent.id_tag], power: val },
                    }));
                    act('command', {
                      id_tag: vent.id_tag,
                      command: 'power',
                      val,
                    });
                  }}
                />
              </LabeledList.Item>
              <LabeledList.Item label="Operation Mode">
                {vent.direction === 'siphon' ? 'Siphoning' : 'Pressurizing'}
              </LabeledList.Item>
              <LabeledList.Item label="Pressure Checks">
                <Button
                  content="External"
                  selected={!!(checks & 1)}
                  disabled={!!data.shorted}
                  onClick={() => {
                    const val = checks ^ 1;
                    setVentOverrides((vents) => ({
                      ...vents,
                      [vent.id_tag]: { ...vents[vent.id_tag], checks: val },
                    }));
                    act('command', {
                      id_tag: vent.id_tag,
                      command: 'checks',
                      val,
                    });
                  }}
                />
                <Button
                  content="Internal"
                  selected={!!(checks & 2)}
                  disabled={!!data.shorted}
                  onClick={() => {
                    const val = checks ^ 2;
                    setVentOverrides((vents) => ({
                      ...vents,
                      [vent.id_tag]: { ...vents[vent.id_tag], checks: val },
                    }));
                    act('command', {
                      id_tag: vent.id_tag,
                      command: 'checks',
                      val,
                    });
                  }}
                />
              </LabeledList.Item>
              <LabeledList.Item label="External Pressure Bound">
                <Button
                  content={`${vent.external.toFixed(2)} kPa`}
                  disabled={!!data.shorted}
                  onClick={() =>
                    act('command', {
                      id_tag: vent.id_tag,
                      command: 'set_external_pressure',
                    })
                  }
                />
                <Button
                  content="Reset"
                  disabled={!!data.shorted}
                  onClick={() =>
                    act('command', {
                      id_tag: vent.id_tag,
                      command: 'reset_external_pressure',
                    })
                  }
                />
              </LabeledList.Item>
            </LabeledList>
          </Section>
        );
      })}
    </>
  );
};

// ---- Scrubbers tab ----

const ScrubbersSection = (props) => {
  const { act, data } = useBackend<AirAlarmData>();
  const [scrubberOverrides, setScrubberOverrides] = useState<
    Record<
      string,
      Partial<Pick<ScrubberEntry, 'power' | 'scrubbing'>> & {
        filters?: Record<string, BooleanLike>;
      }
    >
  >({});

  if (!data.scrubbers.length) {
    return <NoticeBox>No scrubbers connected.</NoticeBox>;
  }

  return (
    <>
      {data.scrubbers.map((scrubber) => {
        const localScrubber = scrubberOverrides[scrubber.id_tag];
        const power = localScrubber?.power ?? scrubber.power;
        const scrubbing = localScrubber?.scrubbing ?? scrubber.scrubbing;

        return (
          <Section key={scrubber.id_tag} title={scrubber.long_name}>
            <LabeledList>
              <LabeledList.Item label="Operating">
                <Button
                  content={power ? 'On' : 'Off'}
                  color={power ? 'default' : 'bad'}
                  disabled={!!data.shorted}
                  onClick={() => {
                    const val = power ? 0 : 1;
                    setScrubberOverrides((scrubbers) => ({
                      ...scrubbers,
                      [scrubber.id_tag]: {
                        ...scrubbers[scrubber.id_tag],
                        power: val,
                      },
                    }));
                    act('command', {
                      id_tag: scrubber.id_tag,
                      command: 'power',
                      val,
                    });
                  }}
                />
              </LabeledList.Item>
              <LabeledList.Item label="Operation Mode">
                <Button
                  content={scrubbing ? 'Scrubbing' : 'Siphoning'}
                  color={scrubbing ? 'default' : 'bad'}
                  disabled={!!data.shorted}
                  onClick={() => {
                    const val = scrubbing ? 0 : 1;
                    setScrubberOverrides((scrubbers) => ({
                      ...scrubbers,
                      [scrubber.id_tag]: {
                        ...scrubbers[scrubber.id_tag],
                        scrubbing: val,
                      },
                    }));
                    act('command', {
                      id_tag: scrubber.id_tag,
                      command: 'scrubbing',
                      val,
                    });
                  }}
                />
              </LabeledList.Item>
              <LabeledList.Item label="Filters">
                {scrubber.filters.map((filter) => {
                  const filterValue =
                    localScrubber?.filters?.[filter.command] ?? filter.val;

                  return (
                    <Button
                      key={filter.command}
                      content={filter.name}
                      selected={!!filterValue}
                      disabled={!!data.shorted}
                      onClick={() => {
                        const val = filterValue ? 0 : 1;
                        setScrubberOverrides((scrubbers) => ({
                          ...scrubbers,
                          [scrubber.id_tag]: {
                            ...scrubbers[scrubber.id_tag],
                            filters: {
                              ...scrubbers[scrubber.id_tag]?.filters,
                              [filter.command]: val,
                            },
                          },
                        }));
                        act('command', {
                          id_tag: scrubber.id_tag,
                          command: filter.command,
                          val,
                        });
                      }}
                    />
                  );
                })}
              </LabeledList.Item>
            </LabeledList>
          </Section>
        );
      })}
    </>
  );
};

// ---- Mode tab ----

const ModeSection = (props) => {
  const { act, data } = useBackend<AirAlarmData>();

  return (
    <Section title="Environmental Mode">
      {data.modes.map((m) => (
        <Box key={m.mode} mb={0.5}>
          <Button
            fluid
            color={
              data.mode === m.mode ? (m.danger ? 'bad' : 'good') : 'default'
            }
            selected={data.mode === m.mode}
            disabled={!!data.shorted}
            onClick={() => act('mode', { mode: m.mode })}
          >
            <Box bold style={{ display: 'inline-block' }}>
              {m.name}
            </Box>{' '}
            — {m.description}
          </Button>
        </Box>
      ))}
    </Section>
  );
};

// ---- Sensors tab ----

const THRESHOLD_LABELS = ['Min²', 'Min¹', 'Max¹', 'Max²'];

const SensorsSection = (props) => {
  const { act, data } = useBackend<AirAlarmData>();

  return (
    <Section title="Alarm Thresholds">
      <Box fontSize="0.85em" color="label" mb={1}>
        Partial pressure for gases (kPa). Negative values disable the threshold.
      </Box>
      <Table>
        <Table.Row header>
          <Table.Cell>Gas</Table.Cell>
          {THRESHOLD_LABELS.map((label, i) => (
            <Table.Cell key={i} textAlign="center">
              {label}
            </Table.Cell>
          ))}
        </Table.Row>
        {data.thresholds.map((threshold) => (
          <Table.Row key={threshold.name}>
            <Table.Cell>{threshold.name}</Table.Cell>
            {threshold.settings.map((setting) => (
              <Table.Cell key={setting.val} textAlign="center">
                <Button
                  content={
                    setting.selected >= 0 ? setting.selected.toFixed(2) : 'Off'
                  }
                  disabled={!!data.shorted || !!data.locked}
                  onClick={() =>
                    act('command', {
                      command: 'set_threshold',
                      env: setting.env,
                      threshold: setting.val,
                    })
                  }
                />
              </Table.Cell>
            ))}
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
};

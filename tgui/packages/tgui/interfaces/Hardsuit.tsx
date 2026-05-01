import { useBackend } from '../backend';
import {
  Box,
  Button,
  Collapsible,
  Divider,
  LabeledList,
  NoticeBox,
  ProgressBar,
  Section,
  Stack,
  Table,
} from '../components';
import { Window } from '../layouts';
import { BooleanLike } from '../../common/react';

type RigCharge = {
  caption: string;
  index: string;
};

type RigModule = {
  index: number;
  name: string;
  desc: string;

  can_use: BooleanLike;
  can_select: BooleanLike;
  can_toggle: BooleanLike;
  is_active: BooleanLike;

  engagecost: number;
  activecost: number;
  passivecost: number;

  engagestring: string;
  activatestring: string;
  deactivatestring: string;

  damage: number;

  chargetype?: string;
  charges?: RigCharge[];
};

type Data = {
  primarysystem?: string;

  ai?: BooleanLike;

  seals: BooleanLike;
  sealing: BooleanLike;

  helmet: string;
  gauntlets: string;
  boots: string;
  chest: string;

  charge: number;
  maxcharge: number;
  chargestatus: number;
  emagged: BooleanLike;

  coverlock: BooleanLike;
  interfacelock: BooleanLike;

  aicontrol: BooleanLike;
  aioverride: BooleanLike;

  securitycheck: BooleanLike;
  malf: number;

  modules?: RigModule[];
};

const pill = (text: string, color?: string) => (
  <Box inline bold color={color}>
    {text}
  </Box>
);

const SuitStatusSection = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const interfaceOffline = !!data.interfacelock || (data.malf ?? 0) > 0;
  const aiOverriddenForWearer = !!data.aicontrol && !data.ai;
  const coverControlOffline = !!data.emagged || !data.securitycheck;

  const chargeFrac =
    data.maxcharge > 0
      ? Math.max(0, Math.min(1, data.charge / data.maxcharge))
      : 0;

  const suitStatus = (() => {
    if (data.sealing) return pill('PROCESSING', 'average');
    if (data.seals) return pill('INACTIVE', 'bad');
    return pill('ACTIVE', 'good');
  })();

  const coverStatus = (() => {
    if (coverControlOffline) {
      return pill('ERROR - MAINT LOCK OFFLINE', 'average');
    }
    return data.coverlock ? pill('LOCKED', 'bad') : pill('UNLOCKED', 'good');
  })();

  return (
    <Section
      title="Suit Status"
      fill
      buttons={
        <Stack>
          <Stack.Item>
            <Button icon="shield" onClick={() => act('examine_armor')}>
              Armor
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button icon="file-alt" onClick={() => act('examine_fluff')}>
              Info
            </Button>
          </Stack.Item>
        </Stack>
      }
    >
      {interfaceOffline ? (
        <NoticeBox danger>ERROR: INTERFACE OFFLINE</NoticeBox>
      ) : aiOverriddenForWearer ? (
        <NoticeBox danger>CONTROL OVERRIDDEN BY AI</NoticeBox>
      ) : null}

      <LabeledList>
        <LabeledList.Item label="Charge">
          <ProgressBar value={chargeFrac}>
            {data.charge}/{data.maxcharge}
          </ProgressBar>
        </LabeledList.Item>

        <LabeledList.Item
          label="Suit"
          buttons={
            <Button
              icon="circle-arrow-right"
              onClick={() => act('toggle_seals')}
            >
              Toggle
            </Button>
          }
        >
          {suitStatus}
        </LabeledList.Item>

        <LabeledList.Item
          label="Cover"
          buttons={
            <Button
              icon={data.coverlock ? 'lock' : 'lock-open'}
              disabled={coverControlOffline}
              onClick={() => act('toggle_suit_lock')}
            >
              Toggle
            </Button>
          }
        >
          {coverStatus}
        </LabeledList.Item>

        <LabeledList.Item
          label="AI Override"
          buttons={
            <Button
              icon="circle-arrow-right"
              onClick={() => act('toggle_ai_control')}
            >
              Toggle
            </Button>
          }
        >
          {data.aioverride ? pill('ENABLED', 'good') : pill('DISABLED', 'bad')}
        </LabeledList.Item>

        <LabeledList.Item label="Primary System">
          {data.primarysystem ? (
            <Box>{data.primarysystem}</Box>
          ) : (
            <Box color="average">None</Box>
          )}
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

const HardwareSection = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const pieceDisabled = !!data.sealing;

  return (
    <Section title="Hardware" fill>
      <LabeledList>
        <LabeledList.Item
          label="Helmet"
          buttons={
            <Button
              icon="circle-arrow-right"
              disabled={pieceDisabled}
              onClick={() => act('toggle_piece', { piece: 'helmet' })}
            >
              Toggle
            </Button>
          }
        >
          {data.helmet}
        </LabeledList.Item>

        <LabeledList.Item
          label="Gauntlets"
          buttons={
            <Button
              icon="circle-arrow-right"
              disabled={pieceDisabled}
              onClick={() => act('toggle_piece', { piece: 'gauntlets' })}
            >
              Toggle
            </Button>
          }
        >
          {data.gauntlets}
        </LabeledList.Item>

        <LabeledList.Item
          label="Boots"
          buttons={
            <Button
              icon="circle-arrow-right"
              disabled={pieceDisabled}
              onClick={() => act('toggle_piece', { piece: 'boots' })}
            >
              Toggle
            </Button>
          }
        >
          {data.boots}
        </LabeledList.Item>

        <LabeledList.Item
          label="Chestpiece"
          buttons={
            <Button
              icon="circle-arrow-right"
              disabled={pieceDisabled}
              onClick={() => act('toggle_piece', { piece: 'chest' })}
            >
              Toggle
            </Button>
          }
        >
          {data.chest}
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

const moduleTypeAction = (m: RigModule) => {
  if (m.can_select) return 'Select';
  if (m.can_toggle) return 'Toggle';
  if (m.can_use) return 'Use';
  return '—';
};

const ModulesSection = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const systemsOffline = !!data.seals || !!data.sealing;

  if (systemsOffline) {
    return (
      <Section title="Modules" fill>
        <NoticeBox danger>HARDSUIT SYSTEMS OFFLINE</NoticeBox>
      </Section>
    );
  }

  const modules = data.modules ?? [];
  return (
    <Section
      title="Modules"
      fill
      buttons={
        data.primarysystem
          ? `Selected: ${data.primarysystem}`
          : 'No primary system'
      }
    >
      {!modules.length ? (
        <NoticeBox>No Modules Detected</NoticeBox>
      ) : (
        <Table>
          <Table.Row header>
            <Table.Cell width={1} />
            <Table.Cell width={1} />
            <Table.Cell width={1} />
            <Table.Cell>Name</Table.Cell>
            <Table.Cell width={1} textAlign="center">
              <Button
                color="transparent"
                icon="plug"
                tooltip="Passive Power Cost"
                tooltipPosition="top"
              />
            </Table.Cell>
            <Table.Cell width={1} textAlign="center">
              <Button
                color="transparent"
                icon="lightbulb"
                tooltip="Active Power Cost"
                tooltipPosition="top"
              />
            </Table.Cell>
            <Table.Cell width={1} textAlign="center">
              <Button
                color="transparent"
                icon="bolt"
                tooltip="Engage Cost"
                tooltipPosition="top"
              />
            </Table.Cell>
          </Table.Row>

          {modules.map((m) => {
            const selected =
              data.primarysystem && m.name === data.primarysystem;
            const damagedTag =
              m.damage === 1 ? (
                <Box inline ml={1} color="average">
                  (damaged)
                </Box>
              ) : m.damage > 1 ? (
                <Box inline ml={1} color="bad">
                  (destroyed)
                </Box>
              ) : null;

            const disableAll = m.damage > 1;

            return (
              <Table.Row key={`m-${m.index}`}>
                {/* Engage/Use */}
                <Table.Cell width={1}>
                  <Button
                    icon="power-off"
                    tooltip={moduleTypeAction(m)}
                    tooltipPosition="left"
                    disabled={disableAll || !m.can_use}
                    onClick={() =>
                      act('interact_module', { index: m.index, mode: 'engage' })
                    }
                  />
                </Table.Cell>

                {/* Toggle */}
                <Table.Cell width={1}>
                  <Button
                    icon={m.is_active ? 'toggle-on' : 'toggle-off'}
                    selected={!!m.is_active}
                    tooltip={m.is_active ? 'Deactivate' : 'Activate'}
                    tooltipPosition="left"
                    disabled={disableAll || !m.can_toggle}
                    onClick={() =>
                      act('interact_module', {
                        index: m.index,
                        mode: m.is_active ? 'deactivate' : 'activate',
                      })
                    }
                  />
                </Table.Cell>

                {/* Select */}
                <Table.Cell width={1}>
                  <Button
                    icon={selected ? 'check-square-o' : 'square-o'}
                    selected={selected}
                    tooltip="Select"
                    tooltipPosition="left"
                    disabled={disableAll || !m.can_select}
                    onClick={() =>
                      act('interact_module', { index: m.index, mode: 'select' })
                    }
                  />
                </Table.Cell>

                <Table.Cell>
                  <Collapsible
                    title={
                      <Box>
                        <Box
                          inline
                          bold
                          color={m.is_active ? 'good' : 'average'}
                        >
                          {m.name}
                        </Box>
                        {damagedTag}
                      </Box>
                    }
                  >
                    <Section mt={1}>
                      <Box fontSize="12px">{m.desc}</Box>

                      {!!m.charges?.length && (
                        <>
                          <Divider />
                          <Box mb={0.5}>
                            <Box inline bold>
                              Selected charge:{' '}
                            </Box>
                            <Box inline>{m.chargetype || 'none'}</Box>
                          </Box>

                          <Stack wrap>
                            {m.charges.map((c) => (
                              <Stack.Item key={`${m.index}-${c.index}`}>
                                <Button
                                  onClick={() =>
                                    act('interact_module', {
                                      index: m.index,
                                      mode: 'select_charge_type',
                                      charge_type: c.index,
                                    })
                                  }
                                >
                                  {c.caption}
                                </Button>
                              </Stack.Item>
                            ))}
                          </Stack>
                        </>
                      )}
                    </Section>
                  </Collapsible>
                </Table.Cell>

                <Table.Cell width={1} textAlign="center">
                  {m.passivecost}
                </Table.Cell>
                <Table.Cell width={1} textAlign="center">
                  {m.activecost}
                </Table.Cell>
                <Table.Cell width={1} textAlign="center">
                  {m.engagecost}
                </Table.Cell>
              </Table.Row>
            );
          })}
        </Table>
      )}
    </Section>
  );
};

export const Hardsuit = (props, context) => {
  const { data } = useBackend<Data>(context);
  const interfaceBreak = !!data.interfacelock || (data.malf ?? 0) > 0;

  return (
    <Window width={600} height={600} title="Integrated Hardsuit Controller">
      <Window.Content scrollable={!interfaceBreak}>
        <Stack vertical>
          <Stack.Item>
            <Stack>
              <Stack.Item grow>
                <SuitStatusSection />
              </Stack.Item>
              <Stack.Item grow>
                <HardwareSection />
              </Stack.Item>
            </Stack>
          </Stack.Item>

          <Stack.Item>
            <ModulesSection />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

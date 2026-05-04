import { useBackend } from '../backend';
import {
  Box,
  Button,
  Collapsible,
  Dropdown,
  LabeledList,
  NoticeBox,
  NumberInput,
  ProgressBar,
  Section,
  Stack,
  Table,
} from '../components';
import { Window } from '../layouts';
import { BooleanLike } from '../../common/react';

type RigCharge = {
  chargetype: string;
  charges: number;
  index: string;
};

type RigModule = {
  index: number;
  module_name: string;
  desc: string;

  module_type: number;
  module_toggleable: BooleanLike;
  module_active: BooleanLike;

  engagecost: number;
  activecost: number;
  passivecost: number;

  engagestring: string;
  activatestring: string;
  deactivatestring: string;

  damage: number;

  chargetype?: string;
  charges?: RigCharge[];
  ref: string;
  configuration_data?: ModuleConfig;
};

type ModuleConfigEntry = {
  key: string;
  display_name: string;
  type: 'number' | 'bool' | 'color' | 'list' | 'button' | 'pin';
  value: any;
  values?: any[];
};

type ModuleConfig = Record<string, ModuleConfigEntry>;

type Data = {
  primarysystem?: string;
  primarysystem_ref?: string;

  ai?: BooleanLike;

  seals: BooleanLike;
  sealing: BooleanLike;

  helmet: string;
  gauntlets: string;
  boots: string;
  chest: string;

  charge: number;
  maxcharge: number;
  chargedisplay: string;
  chargestatus: number;
  time_to_drain: string;
  emagged: BooleanLike;

  coverlock: BooleanLike;
  interfacelock: BooleanLike;

  aicontrol: BooleanLike;
  aioverride: BooleanLike;

  id_lock: BooleanLike;

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

  const chargeFrac =
    data.maxcharge > 0
      ? Math.max(0, Math.min(1, data.charge / data.maxcharge))
      : 0;

  const suitStatus = (() => {
    if (data.sealing) return pill('PROCESSING', 'average');
    if (data.seals) return pill('INACTIVE', 'bad');
    return pill('ACTIVE', 'good');
  })();

  return (
    <Section
      title="Suit Status"
      fill
      buttons={
        <Stack>
          <Stack.Item>
            <Button icon="power-off" onClick={() => act('toggle_seals')}>
              Toggle Suit
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
          <ProgressBar value={chargeFrac}>{data.chargedisplay}</ProgressBar>
        </LabeledList.Item>
        <LabeledList.Item label="Charge Duration">
          <Box color="average">{data.time_to_drain}</Box>
        </LabeledList.Item>

        <LabeledList.Item label="Suit">{suitStatus}</LabeledList.Item>

        <LabeledList.Item label="Cover">
          {' '}
          <Button
            icon={data.coverlock ? 'lock' : 'lock-open'}
            onClick={() => act('toggle_suit_lock')}
          >
            {data.coverlock ? pill('ENABLED', 'good') : pill('DISABLED', 'bad')}
          </Button>
        </LabeledList.Item>

        <LabeledList.Item label="AI Override">
          <Button
            icon="circle-arrow-right"
            onClick={() => act('toggle_ai_control')}
          >
            {data.aioverride
              ? pill('ENABLED', 'good')
              : pill('DISABLED', 'bad')}
          </Button>
        </LabeledList.Item>

        <LabeledList.Item label="ID Lock">
          <Button
            icon={data.id_lock ? 'lock' : 'lock-open'}
            onClick={() => act('toggle_id_lock')}
          >
            {data.id_lock ? pill('ENABLED', 'good') : pill('DISABLED', 'bad')}
          </Button>
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

const HardwareSection = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const pieceDisabled = !!data.sealing;

  return (
    <Section
      title="Hardware"
      fill
      buttons={
        <Stack>
          <Stack.Item>
            <Button icon="shield" onClick={() => act('examine_armor')}>
              Armor
            </Button>
            <Button icon="file-alt" onClick={() => act('examine_fluff')}>
              Info
            </Button>
          </Stack.Item>
        </Stack>
      }
    >
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
          <Box color={data.sealing ? 'average' : data.seals ? 'bad' : 'good'}>
            {data.helmet}
          </Box>
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
          <Box color={data.sealing ? 'average' : data.seals ? 'bad' : 'good'}>
            {data.gauntlets}
          </Box>
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
          <Box color={data.sealing ? 'average' : data.seals ? 'bad' : 'good'}>
            {data.boots}
          </Box>
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
          <Box color={data.sealing ? 'average' : data.seals ? 'bad' : 'good'}>
            {data.chest}
          </Box>
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
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

  const hasBoolConfigEntry = (configuration_data: any): boolean => {
    if (!configuration_data) return false;

    if (Array.isArray(configuration_data)) {
      return (
        configuration_data.some((e) => e?.type === 'bool') ||
        configuration_data.some(
          (e) =>
            Array.isArray(e?.entries) &&
            e.entries.some((x) => x?.type === 'bool'),
        )
      );
    }

    if (typeof configuration_data === 'object') {
      const values = Object.values(configuration_data);
      return values.some((v: any) => hasBoolConfigEntry(v));
    }

    return false;
  };

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
            const selected = data.primarysystem_ref === m.ref;
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

            const moduleTypeAction =
              m.module_type === 2
                ? 'Engage'
                : m.module_type === 3 && !m.module_active
                  ? 'Select'
                  : m.module_type === 3 && m.module_active
                    ? 'Deselect'
                    : null;

            // Handles disabling Toggle button
            const hasBoolConfig = hasBoolConfigEntry(m.configuration_data);
            const toggleDisabled =
              disableAll || (m.module_type >= 2 && !hasBoolConfig);

            // Handles disabling Select/Use button
            const selectDisabled = disableAll || m.module_type < 2;

            return (
              <Table.Row key={`m-${m.index}`}>
                <Table.Cell width={1}>
                  <Button
                    icon={m.module_active ? 'toggle-on' : 'toggle-off'}
                    selected={selected}
                    tooltip={m.module_active ? 'Disable' : 'Enable'}
                    tooltipPosition="left"
                    disabled={toggleDisabled}
                    color={m.module_active ? 'good' : ''}
                    onClick={() =>
                      act('interact_module', {
                        index: m.index,
                        mode: m.module_active ? 'deactivate' : 'activate',
                      })
                    }
                  />
                </Table.Cell>

                {/* 2) Select */}
                <Table.Cell width={1}>
                  <Button
                    icon={selected ? 'check-square-o' : 'square-o'}
                    selected={data.primarysystem === m.module_name}
                    tooltip={moduleTypeAction}
                    tooltipPosition="left"
                    disabled={selectDisabled}
                    onClick={() =>
                      act('interact_module', {
                        index: m.index,
                        mode: 'select',
                      })
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
                          color={m.module_active ? 'good' : 'average'}
                        >
                          {m.module_name}
                        </Box>
                        {damagedTag}
                      </Box>
                    }
                  >
                    <Section mt={1}>
                      <Box fontSize="12px">{m.desc}</Box>

                      {!!m.charges?.length && (
                        <Stack wrap>
                          {m.charges.map((c) => (
                            <Stack.Item key={`${m.index}-${c.index}`}>
                              <Button
                                color={c.index === m.chargetype ? 'green' : ''}
                                disabled={c.charges <= 0}
                                onClick={() =>
                                  act('interact_module', {
                                    index: m.index,
                                    mode: 'select_charge_type',
                                    charge_type: c.index,
                                  })
                                }
                              >
                                {c.chargetype} ({c.charges})
                              </Button>
                            </Stack.Item>
                          ))}
                        </Stack>
                      )}
                    </Section>
                  </Collapsible>
                  <Box>
                    {
                      <ConfigureScreen
                        configuration_data={m.configuration_data}
                        module_ref={m.ref}
                      />
                    }
                  </Box>
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

const ConfigureScreen = (props, context) => {
  const { configuration_data, module_ref } = props;

  const keys = Object.keys(configuration_data || {});
  if (!keys.length) {
    return null;
  }

  return (
    <Box pb={1}>
      <LabeledList>
        {keys.map((k) => {
          const entry = configuration_data[k];
          return (
            <ConfigureDataEntry
              key={entry.key || k}
              entryKey={entry.key || k}
              display_name={entry.display_name}
              type={entry.type}
              value={entry.value}
              values={entry.values}
              module_ref={module_ref}
            />
          );
        })}
      </LabeledList>
    </Box>
  );
};

const ConfigureDataEntry = (props, context) => {
  const { type } = props;
  const configureEntryTypes = {
    number: <ConfigureNumberEntry {...props} />,
    bool: <ConfigureBoolEntry {...props} />,
    color: <ConfigureColorEntry {...props} />,
    list: <ConfigureListEntry {...props} />,
    button: <ConfigureButtonEntry {...props} />,
    pin: <ConfigurePinEntry {...props} />,
  };

  return (
    <LabeledList.Item label={props.display_name}>
      {configureEntryTypes[type]}
    </LabeledList.Item>
  );
};

const ConfigureNumberEntry = (props, context) => {
  const { act } = useBackend(context);
  const { entryKey, value, values, module_ref } = props;
  return (
    <NumberInput
      value={value}
      minValue={-50}
      maxValue={50}
      step={1}
      stepPixelSize={5}
      width="39px"
      onChange={(value) =>
        act('configure', {
          key: entryKey,
          value: value,
          ref: module_ref,
        })
      }
    />
  );
};

const ConfigureBoolEntry = (props, context) => {
  const { act } = useBackend(context);
  const { entryKey, value, module_ref } = props;

  return (
    <Button.Checkbox
      checked={value}
      onClick={() =>
        act('configure', {
          key: entryKey,
          value: value,
          ref: module_ref,
        })
      }
    />
  );
};

const ConfigureColorEntry = (props, context) => {
  const { act } = useBackend(context);
  const { entryKey, value, values, module_ref } = props;
  return (
    <>
      <Button
        icon="paint-brush"
        onClick={() =>
          act('configure', {
            key: entryKey,
            ref: module_ref,
          })
        }
      />
      <Box color={value} mr={0.5} />
    </>
  );
};

const ConfigureListEntry = (props, context) => {
  const { act } = useBackend(context);
  const { entryKey, value, values, module_ref } = props;

  return (
    <Dropdown
      width="280px"
      selected={value}
      options={values || []}
      onSelected={(v) =>
        act('configure', {
          ref: module_ref,
          key: entryKey,
          value: v,
        })
      }
    />
  );
};

const ConfigurePinEntry = (props, context) => {
  const { act } = useBackend(context);
  const { entryKey, value, values, module_ref } = props;
  return (
    <Button
      onClick={() =>
        act('configure', { key: entryKey, value: !value, ref: module_ref })
      }
      icon="thumbtack"
      selected={value}
      tooltip="Pin"
      tooltipPosition="left"
    />
  );
};

const ConfigureButtonEntry = (props, context) => {
  const { act } = useBackend(context);
  const { entryKey, value, values, module_ref } = props;
  return (
    <Button
      onClick={() => act('configure', { key: entryKey, ref: module_ref })}
      selected={value}
      icon={value}
    />
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

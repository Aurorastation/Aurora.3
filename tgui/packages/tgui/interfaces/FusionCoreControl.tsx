import { round } from '../../common/math';
import { BooleanLike } from '../../common/react';
import { capitalize } from '../../common/string';
import { useBackend, useSharedState } from '../backend';
import { Box, Button, Dimmer, Divider, Flex, LabeledList, NoticeBox, NumberInput, ProgressBar, Section } from '../components';
import { Window } from '../layouts';

export type FusionCoreData = {
  cores: Core[];
  manufacturer: string;
};

type Core = {
  id: number;
  ref: string;
  field: BooleanLike;
  field_strength: number;
  field_strength_max: number;
  entropy_multiplier: number;
  instability_multiplier: number;
  power_multiplier: number;
  power: number;
  size: number;
  instability: number;
  temperature: number;
  power_available: string;
  power_usage: string;
  power_generated: string;
  shutdown_safe: BooleanLike;
  reactants: Reactant[];
};

type Reactant = {
  name: string;
  amount: number;
};

export const FusionCoreControl = (props, context) => {
  const { act, data } = useBackend<FusionCoreData>(context);
  const [override, setOverride] = useSharedState<boolean>(
    context,
    'override',
    false
  );
  return (
    <Window resizable width={800} height={500} theme={data.manufacturer}>
      <Window.Content scrollable>
        {data.cores && data.cores.length ? (
          data.cores.map((core) => (
            <Section
              title={'INDRA Core ' + core.id}
              key={core.id}
              buttons={
                core.field ? (
                  <Button
                    content="Shutdown"
                    color="red"
                    icon="radiation"
                    onClick={() => act('toggle_active', { machine: core.ref })}
                    disabled={!core.field || (!core.shutdown_safe && !override)}
                  />
                ) : (
                  <Button
                    content="Initiate Fusion"
                    color="green"
                    icon="star"
                    onClick={() =>
                      act('toggle_active', {
                        machine: core.ref,
                      })
                    }
                    disabled={core.field}
                  />
                )
              }>
              {!core.shutdown_safe ? (
                <NoticeBox>
                  Fusion core shutdown locked for safety reasons.{' '}
                  <Button
                    content="Override"
                    color="red"
                    icon="radiation"
                    disabled={override}
                    onClick={() => setOverride(!override)}
                  />
                </NoticeBox>
              ) : (
                ''
              )}
              <Flex>
                <Flex.Item grow={1}>
                  <LabeledList>
                    <LabeledList.Item label="Power Available" color="yellow">
                      {core.power_available}
                    </LabeledList.Item>
                  </LabeledList>
                </Flex.Item>
                <Flex.Item grow={1}>
                  <LabeledList>
                    <LabeledList.Item label="Power Usage" color="red">
                      {core.power_usage}
                    </LabeledList.Item>
                  </LabeledList>
                </Flex.Item>
                <Flex.Item grow={1}>
                  <LabeledList>
                    <LabeledList.Item label="Power Generated" color="green">
                      {core.power_generated}
                    </LabeledList.Item>
                  </LabeledList>
                </Flex.Item>
              </Flex>
              <Divider />
              <Flex>
                <Flex.Item grow={1}>
                  <Box m={2}>
                    <Box fontSize={1.5}>
                      Field status:{' '}
                      <Box as="span" bold color={core.field ? 'good' : 'bad'}>
                        {core.field ? 'Online' : 'Offline'}.
                      </Box>
                    </Box>
                    <Divider />
                    <LabeledList>
                      <LabeledList.Item label="Field Strength">
                        <NumberInput
                          value={core.field_strength}
                          unit="tesla"
                          minValue={20}
                          maxValue={core.field_strength_max * 100}
                          stepPixelSize={15}
                          onDrag={(e, value) =>
                            act('strength', {
                              strength: value,
                              machine: core.ref,
                            })
                          }
                        />
                      </LabeledList.Item>
                      <LabeledList.Item label="Field Size">
                        {core.size}{' '}
                        {core.size > 1 || core.size < 1 ? 'meters' : 'meter'}
                      </LabeledList.Item>
                      <LabeledList.Item label="Instability">
                        {core.instability < 0 ? (
                          <Box as="span" color="red">
                            Core offline.
                          </Box>
                        ) : (
                          <ProgressBar
                            ranges={{
                              good: [0, 25],
                              average: [25, 75],
                              bad: [75, 100],
                            }}
                            value={core.instability}
                            minValue={0}
                            maxValue={100}
                          />
                        )}
                      </LabeledList.Item>
                      <LabeledList.Item label="Plasma Temperature">
                        {core.temperature < 0 ? (
                          <Box as="span" color="red">
                            Core offline.
                          </Box>
                        ) : (
                          round(core.temperature, 0.1) + ' kelvin'
                        )}
                      </LabeledList.Item>
                    </LabeledList>
                  </Box>
                </Flex.Item>
                <Flex.Item grow={1}>
                  <Box m={2}>
                    <Box fontSize={1.5}>Reactants</Box>
                    {core.reactants && core.reactants.length ? (
                      core.reactants.map((reactant) => (
                        <Section key={reactant.name}>
                          <Dimmer>
                            {capitalize(reactant.name)} (
                            {round(reactant.amount, 0.1)})
                          </Dimmer>
                        </Section>
                      ))
                    ) : (
                      <NoticeBox>No reactants detected.</NoticeBox>
                    )}
                  </Box>
                </Flex.Item>
              </Flex>
            </Section>
          ))
        ) : (
          <NoticeBox>No fusion cores detected.</NoticeBox>
        )}
      </Window.Content>
    </Window>
  );
};

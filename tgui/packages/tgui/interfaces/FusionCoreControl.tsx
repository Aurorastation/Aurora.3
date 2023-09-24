import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Box, Button, Dimmer, Divider, LabeledList, NoticeBox, NumberInput, ProgressBar, Section } from '../components';
import { Window } from '../layouts';

export type FusionCoreData = {
  cores: Core[];
  manufacturer: string;
};

type Core = {
  id: number;
  ref: string;
  field: BooleanLike;
  field_strength: number; // backend only, user facing value is power
  power: number;
  size: number;
  instability: number;
  temperature: number;
  power_status: string;
  shutdown_safe: BooleanLike;
  reactants: Reactant[];
};

type Reactant = {
  name: string;
  amount: number;
};

export const FusionCoreControl = (props, context) => {
  const { act, data } = useBackend<FusionCoreData>(context);

  return (
    <Window resizable theme={data.manufacturer}>
      <Window.Content scrollable>
        {data.cores && data.cores.length ? (
          data.cores.map((core) => (
            <Section
              title={'Fusion Core ' + core.id}
              key={core.id}
              buttons={
                core.field ? (
                  <Button
                    content="Shutdown"
                    color="red"
                    icon="radiation"
                    onClick={() => act('toggle_active', { machine: core.ref })}
                    disabled={!core.field || !core.shutdown_safe}
                  />
                ) : (
                  <Button
                    content="Initiate Fusion"
                    color="green"
                    icon="star"
                    onClick={() =>
                      act('toggle_active', {
                        toggle_active: 1,
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
                  <Button content="Override" color="red" icon="radiation" />
                </NoticeBox>
              ) : (
                ''
              )}
              <Box fontSize={1.5}>
                Field status:{' '}
                <Box as="span" bold color={core.field ? 'good' : 'bad'}>
                  {core.field ? 'Online' : 'Offline'}.
                </Box>
              </Box>
              <Divider />
              <LabeledList>
                <LabeledList.Item label="Power Status">
                  {core.power_status} W
                </LabeledList.Item>
                <LabeledList.Item label="Field Strength">
                  <NumberInput
                    value={core.field_strength}
                    unit="tesla"
                    minValue={0}
                    maxValue={100}
                    stepPixelSize={15}
                    onDrag={(e, value) =>
                      act('set_strength', {
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
                    core.temperature + 'K'
                  )}
                </LabeledList.Item>
              </LabeledList>
              <Section title="Reactants">
                {core.reactants && core.reactants.length ? (
                  core.reactants.map((reactant) => (
                    <Section key={reactant.name}>
                      <Dimmer>
                        {reactant.name}: {reactant.amount}
                      </Dimmer>
                    </Section>
                  ))
                ) : (
                  <NoticeBox>No reactants detected.</NoticeBox>
                )}
              </Section>
            </Section>
          ))
        ) : (
          <NoticeBox>No fusion cores detected.</NoticeBox>
        )}
      </Window.Content>
    </Window>
  );
};

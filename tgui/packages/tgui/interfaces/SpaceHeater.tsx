import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Box, Button, Flex, LabeledList, Knob, ProgressBar, Section } from '../components';
import { Window } from '../layouts';

export type SpaceHeaterData = {
  is_on: BooleanLike;
  is_active: BooleanLike;
  power_cell_inserted: BooleanLike;
  power_cell_charge: number;
  panel_open: BooleanLike;
  heating_power: number;
  current_temperature: number;
  set_temperature: number;
  set_temperature_max: number;
  set_temperature_min: number;
};

export const SpaceHeater = (props, context) => {
  const { act, data } = useBackend<SpaceHeaterData>(context);

  return (
    <Window width="382" height="277">
      <Window.Content>
        <Section
          title="Device Configuration"
          buttons={
            <Button
              content={data.is_on ? 'On' : 'Off'}
              icon={data.is_on ? 'power-off' : 'times'}
              color={!data.is_on ? 'red' : 'green'}
              onClick={() => act('powerToggle')}
            />
          }>
          <Box>
            <Section fill title="Power Status">
              <LabeledList>
                <LabeledList.Item label="Power State">
                  {data.is_on ? (
                    <Box color="good">On</Box>
                  ) : (
                    <Box color="bad">Off</Box>
                  )}
                </LabeledList.Item>
                <LabeledList.Item label="Activity State">
                  {data.is_active ? (
                    <Box color="good">Active</Box>
                  ) : data.is_on ? (
                    <Box color="bad">Inactive</Box>
                  ) : (
                    <Box color="average">Standby</Box>
                  )}
                </LabeledList.Item>
                <LabeledList.Item label="Power Cell">
                  {data.power_cell_inserted ? (
                    <ProgressBar
                      ranges={{
                        good: [75, 100],
                        average: [30, 75],
                        bad: [0, 30],
                      }}
                      value={data.power_cell_charge}
                      minValue={0}
                      maxValue={100}
                    />
                  ) : (
                    <Box color="bad">No power cell.</Box>
                  )}
                </LabeledList.Item>
              </LabeledList>
            </Section>
            <Flex direction="row" align="stretch">
              <Flex.Item grow={1}>
                <Section fill title="Environment Status">
                  <LabeledList>
                    <LabeledList.Item label="Current Temperature">
                      {data.current_temperature ? data.current_temperature : 20}
                      ° C
                    </LabeledList.Item>
                    <LabeledList.Item label="Set Temperature">
                      {data.set_temperature ? data.set_temperature : 20}° C
                    </LabeledList.Item>
                  </LabeledList>
                </Section>
              </Flex.Item>
              <Flex.Item grow={1}>
                <Section fill title="Temperature Control">
                  <Knob
                    size={1.5}
                    color={
                      data.set_temperature > 20
                        ? 'yellow'
                        : data.set_temperature < 20
                          ? 'lightblue'
                          : 'slategray'
                    }
                    value={data.set_temperature}
                    unit="C"
                    minValue={data.set_temperature_min}
                    maxValue={data.set_temperature_max}
                    step={1}
                    stepPixelSize={2}
                    onDrag={(e, value) =>
                      act('tempSet', {
                        set_temperature: value,
                      })
                    }
                  />
                </Section>
              </Flex.Item>
            </Flex>
          </Box>
        </Section>
      </Window.Content>
    </Window>
  );
};

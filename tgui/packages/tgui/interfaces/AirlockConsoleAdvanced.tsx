import { useBackend } from '../backend';
import { Box, Button, LabeledList, ProgressBar, Section } from '../components';
import { Window } from '../layouts';

export type AdvancedAirlockConsoleData = {
  chamber_pressure: number;
  has_exterior_sensor: boolean;
  external_pressure: number;
  has_interior_sensor: boolean;
  internal_pressure: number;
  processing: boolean;
  purge: boolean;
  secure: boolean;
};

export const AdvancedAirlockConsole = (props, context) => {
  const { act, data } = useBackend<AdvancedAirlockConsoleData>(context);

  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section title="Status">
          <Box>
            <LabeledList>
              <LabeledList.Item label="External Pressure">
                {data.has_exterior_sensor ? (
                  <ProgressBar
                    ranges={{
                      average: [120, Infinity],
                      good: [80, 120],
                      bad: [-Infinity, 80],
                    }}
                    value={data.external_pressure}
                    minValue={0}
                    maxValue={200}>
                    {data.external_pressure} kPa
                  </ProgressBar>
                  ) : (
                    <Box>Error - No Sensor Detected</Box>
                  )}
              </LabeledList.Item>
              <LabeledList.Item label="Chamber Pressure">
                <ProgressBar
                  ranges={{
                    average: [120, Infinity],
                    good: [80, 120],
                    bad: [-Infinity, 80],
                  }}
                  value={data.chamber_pressure}
                  minValue={0}
                  maxValue={200}>
                  {data.chamber_pressure} kPa
                </ProgressBar>
              </LabeledList.Item>
              <LabeledList.Item label="Internal Pressure">
                {data.has_interior_sensor ? (
                  <ProgressBar
                    ranges={{
                      average: [120, Infinity],
                      good: [80, 120],
                      bad: [-Infinity, 80],
                    }}
                    value={data.internal_pressure}
                    minValue={0}
                    maxValue={200}>
                    {data.internal_pressure} kPa
                  </ProgressBar>
                  ) : (
                    <Box>Error - No Sensor Detected</Box>
                  )}
              </LabeledList.Item>
            </LabeledList>
          </Box>
        </Section>
        <Section title="Controls">
          <Box>
            <Button
              content="Cycle to Exterior"
              icon="arrow-right-from-bracket"
              onClick={() => act('command', { command: 'cycle_ext' })}
            />
            <Button
              content="Cycle to Interior"
              icon="arrow-right-to-bracket"
              onClick={() => act('command', { command: 'cycle_int' })}
            />
          </Box>
          <Box>
            <Button
              content="Force Exterior Door"
              icon="circle-exclamation"
              color='yellow'
              onClick={() => act('command', { command: 'force_ext' })}
            />
            <Button
              content="Force Interior Door"
              icon="circle-exclamation"
              color='yellow'
              onClick={() => act('command', { command: 'force_int' })}
            />
          </Box>
          <Box>
            <Button
              content="Purge"
              icon="refresh"
              tooltip="Pumps all air out of the airlock before refilling it; removed air will be pumped in the same direction as the airlock is cycled, if multiple outflow targets exist."
              disabled={!data.processing}
              color={!data.processing ? null : 'red'}
              onClick={() => act('command', { command: 'purge' })}
            />
            <Button
              content="Secure"
              icon={data.secure ? 'locked' : 'unlocked'}
              tooltip="Bolts airlock doors during cycles. Default enabled; use extreme caution if disabling."
              disabled={!data.processing}
              color={!data.processing ? 'green' : 'red'}
              onClick={() => act('command', { command: 'secure' })}
            />
          </Box>
        </Section>
      </Window.Content>
    </Window>
  );
};

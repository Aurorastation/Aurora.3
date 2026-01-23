import { useBackend } from '../backend';
import { Box, Button, LabeledList, ProgressBar, Section } from '../components';
import { Window } from '../layouts';

export type StandardAirlockConsoleData = {
  chamber_pressure: number;
  processing: boolean;
};

export const AirlockConsoleStandard = (props, context) => {
  const { act, data } = useBackend<StandardAirlockConsoleData>(context);

  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section title="Status">
          <Box>
            <LabeledList>
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
        </Section>
      </Window.Content>
    </Window>
  );
};

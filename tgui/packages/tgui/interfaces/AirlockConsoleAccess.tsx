import { useBackend } from '../backend';
import { Box, Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

export type StatusData = {
  state: string;
  lock: string;
};

export type AccessAirlockConsoleData = {
  exterior_status: StatusData;
  interior_status: StatusData;
  processing: boolean;
};

export const AirlockConsoleAccess = (props, context) => {
  const { act, data } = useBackend<AccessAirlockConsoleData>(context);

  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section title="Status">
          <Box>
            <LabeledList>
              <LabeledList.Item label="Exterior Door Status">
                {data.exterior_status.state === 'open' ? (
                    <Box>Open</Box>) : (
                    <Box>Locked</Box>
                )
                }
              </LabeledList.Item>
              <LabeledList.Item label="Interior Door Status">
                {data.interior_status.state === 'open' ? (
                    <Box>Open</Box>) : (
                    <Box>Locked</Box>
                )
                }
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
        </Section>
      </Window.Content>
    </Window>
  );
};

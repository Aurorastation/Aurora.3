import { useBackend } from '../backend';
import { Box, LabeledList, Section } from '../components';
import { Window } from '../layouts';

export type AirlockData = {
  name: string;
  override_enabled: boolean;
};

export type MultiDockingConsoleData = {
  docking_status: string;
  airlocks: AirlockData[];
};

export const MultiDockingConsole = (props, context) => {
  const { act, data } = useBackend<MultiDockingConsoleData>(context);

  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section title="Status">
          <Box>
            <LabeledList>
              <LabeledList.Item label="Docking Port Status">
                {data.docking_status === 'docked' ? (
                  <Box>Docked</Box>
                ) : data.docking_status === 'docking' ? (
                  <Box>Docking</Box>
                ) : data.docking_status === 'undocking' ? (
                  <Box>Undocking</Box>
                ) : data.docking_status === 'undocked' ? (
                  <Box>Not in use</Box>
                ) : (
                  <Box>Error</Box>
                )}
              </LabeledList.Item>
            </LabeledList>
          </Box>
        </Section>
        <Section title="Airlocks">
          <LabeledList>
            {data.airlocks.map((airlock) => (
              <LabeledList.Item label={airlock.name} key={airlock.name}>
                {airlock.override_enabled ? (
                  <Box>Override Enabled</Box>
                ) : (
                  <Box>Status OK</Box>
                )}
              </LabeledList.Item>
            ))}
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};

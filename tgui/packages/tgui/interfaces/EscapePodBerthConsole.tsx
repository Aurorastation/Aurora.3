import { useBackend } from '../backend';
import { Box, Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

export type EscapePodBerthConsoleData = {
  docking_status: string;
  override_enabled: boolean;
  armed: boolean;
};

export const EscapePodBerthConsole = (props, context) => {
  const { act, data } = useBackend<EscapePodBerthConsoleData>(context);

  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section title="Status">
          <Box>
            <LabeledList>
              <LabeledList.Item label="Escape Pod Status">
                {data.docking_status === 'docked' ? (
                  data.armed ? (
                    <Box>Armed</Box>
                  ) : (
                    <Box>Systems OK - Awaiting Arming</Box>
                  )
                ) : data.docking_status === 'docking' ? (
                  <Box>Initializing...</Box>
                ) : data.docking_status === 'undocking' ? (
                  <Box>Ejecting - STAND CLEAR!</Box>
                ) : data.docking_status === 'undocked' ? (
                  <Box>Pod Ejected</Box>
                ) : (
                  <Box>Error</Box>
                )}
              </LabeledList.Item>
            </LabeledList>
          </Box>
        </Section>
        <Section title="Controls">
          <Box>
            <Button
              content="Force Exterior Door"
              icon="circle-exclamation"
              disabled={!data.armed || !data.override_enabled}
              color={!data.armed || data.override_enabled ? 'red' : null}
              onClick={() => act('command', { command: 'force_door' })}
            />
            <Button
              content="Override"
              icon="triangle-exclamation"
              disabled={!data.armed}
              color={
                !data.armed ? null : data.override_enabled ? 'red' : 'yellow'
              }
              onClick={() => act('command', { command: 'toggle_override' })}
            />
          </Box>
        </Section>
      </Window.Content>
    </Window>
  );
};

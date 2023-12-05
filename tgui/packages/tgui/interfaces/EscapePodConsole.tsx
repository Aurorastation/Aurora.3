import { useBackend } from '../backend';
import { Box, Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

export type EscapePodConsoleData = {
  docking_status: string;
  override_enabled: boolean;
  door_state: string;
  door_lock: string;
  can_force: boolean;
  is_armed: boolean;
};

export const EscapePodConsole = (props, context) => {
  const { act, data } = useBackend<EscapePodConsoleData>(context);

  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section title="Status">
          <Box>
            <LabeledList>
              <LabeledList.Item label="Escape Pod Status">
                {data.docking_status === 'docked' ? (
                  data.override_enabled ? (
                    <Box>Docked - Override Enabled</Box>
                  ) : (
                    <Box>Docked</Box>
                  )
                ) : data.docking_status === 'docking' ? (
                  data.override_enabled ? (
                    <Box>Docking - Override Enabled</Box>
                  ) : (
                    <Box>Docking</Box>
                  )
                ) : data.docking_status === 'undocking' ? (
                  data.override_enabled ? (
                    <Box>Undocking - Override Enabled</Box>
                  ) : (
                    <Box>Undocking</Box>
                  )
                ) : data.docking_status === 'undocked' ? (
                  data.override_enabled ? (
                    <Box>Override Enabled</Box>
                  ) : (
                    <Box>Not in use</Box>
                  )
                ) : (
                  <Box>Error</Box>
                )}
              </LabeledList.Item>
              <LabeledList.Item label="Docking Hatch">
                {data.docking_status === 'docked' ? (
                  data.door_state === 'open' ? (
                    <Box>Open</Box>
                  ) : data.door_state === 'closed' ? (
                    <Box>Closed</Box>
                  ) : (
                    <Box>Error</Box>
                  )
                ) : data.docking_status === 'docking' ? (
                  data.door_state === 'open' ? (
                    <Box>Open</Box>
                  ) : data.door_state === 'closed' &&
                    data.door_lock === 'locked' ? (
                    <Box>Secured</Box>
                  ) : data.door_state === 'closed' &&
                    data.door_lock === 'unlocked' ? (
                    <Box>Unsecured</Box>
                  ) : (
                    <Box>Error</Box>
                  )
                ) : data.docking_status === 'undocking' ? (
                  data.door_state === 'open' ? (
                    <Box>Open</Box>
                  ) : data.door_state === 'closed' &&
                    data.door_lock === 'locked' ? (
                    <Box>Secured</Box>
                  ) : data.door_state === 'closed' &&
                    data.door_lock === 'unlocked' ? (
                    <Box>Unsecured</Box>
                  ) : (
                    <Box>Error</Box>
                  )
                ) : data.docking_status === 'undocked' ? (
                  data.door_state === 'open' ? (
                    <Box>Open</Box>
                  ) : data.door_state === 'closed' &&
                    data.door_lock === 'locked' ? (
                    <Box>Secured</Box>
                  ) : data.door_state === 'closed' &&
                    data.door_lock === 'unlocked' ? (
                    <Box>Unsecured</Box>
                  ) : (
                    <Box>Error</Box>
                  )
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
              disabled={!data.override_enabled}
              color={data.override_enabled ? 'red' : null}
              onClick={() => act('command', { command: 'force_door' })}
            />
            <Button
              content="Override"
              icon="triangle-exclamation"
              color={data.override_enabled ? 'red' : 'yellow'}
              onClick={() => act('command', { command: 'toggle_override' })}
            />
          </Box>
          <Box>
            <Button
              content={data.is_armed ? 'Armed' : 'Arm'}
              icon="key"
              disabled={data.is_armed}
              color={data.is_armed ? null : 'red'}
              onClick={() => act('command', { command: 'manual_arm' })}
            />
            <Button
              content="Manual Eject"
              icon="arrow-up-from-bracket"
              disabled={!data.can_force}
              color={data.can_force ? 'red' : null}
              onClick={() => act('command', { command: 'force_launch' })}
            />
          </Box>
        </Section>
      </Window.Content>
    </Window>
  );
};

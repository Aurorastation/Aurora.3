import { useBackend } from '../backend';
import { Button, Section, Box, LabeledList } from '../components';
import { Window } from '../layouts';

export type ShuttleControlConsoleData = {
  shuttle_status: string;
  shuttle_state: string;
  has_docking: boolean;
  docking_status: string;
  docking_override: boolean;
  can_launch: boolean;
  can_cancel: boolean;
  can_force: boolean;
  can_rename_ship: boolean;
  ship_name: string;
};

export const ShuttleControlConsole = (props, context) => {
  const { act, data } = useBackend<ShuttleControlConsoleData>(context);

  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section title="Shuttle Status">
          <Box>{data.shuttle_status}</Box>
          <Box>Ship designation and name: {data.ship_name}</Box>
          {data.can_rename_ship ? (
            <Box>
              <Button
                content="Rename"
                icon="pen"
                onClick={() => act('rename')}
              />
            </Box>
          ) : null}
          <Box>
            <LabeledList>
              <LabeledList.Item label="Engines">
                {data.shuttle_state == 'idle' ? (
                  <Box>Idle</Box>
                ) : data.shuttle_state == 'warmup' ? (
                  <Box>Starting Ignition</Box>
                ) : data.shuttle_state == 'in_transit' ? (
                  <Box>Engaged</Box>
                ) : (
                  <Box>Error</Box>
                )}
              </LabeledList.Item>
              {data.has_docking ? (
                <LabeledList.Item label="Docking Status">
                  {data.docking_status == 'docked' ? (
                    <Box>Docked</Box>
                  ) : data.docking_status == 'docking' ? (
                    data.docking_override ? (
                      <Box>Docking-Manual</Box>
                    ) : (
                      <Box>Docking</Box>
                    )
                  ) : data.docking_status == 'undocking' ? (
                    data.docking_override ? (
                      <Box>Undocking-Manual</Box>
                    ) : (
                      <Box>Undocking</Box>
                    )
                  ) : data.docking_status == 'undocked' ? (
                    <Box>Undocked</Box>
                  ) : (
                    <Box>Error</Box>
                  )}
                </LabeledList.Item>
              ) : null}
            </LabeledList>
          </Box>
        </Section>
        <Section title="Shuttle Control">
          <Button
            content="Launch Shuttle"
            icon="rocket"
            disabled={!data.can_launch}
            onClick={() => act('move')}
          />
          <Button
            content="Cancel Launch"
            icon="ban"
            disabled={!data.can_cancel}
            onClick={() => act('cancel')}
          />
          <Button
            content="Force Launch"
            icon="triangle-exclamation"
            color="red"
            disabled={!data.can_force}
            onClick={() => act('force')}
          />
        </Section>
      </Window.Content>
    </Window>
  );
};

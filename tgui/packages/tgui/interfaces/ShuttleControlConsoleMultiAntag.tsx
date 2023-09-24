import { useBackend } from '../backend';
import { Button, Section, Box, LabeledList } from '../components';
import { Window } from '../layouts';

export type ShuttleControlConsoleMultiAntagData = {
  shuttle_status: string;
  shuttle_state: string;
  has_docking: boolean;
  docking_status: string;
  docking_override: boolean;
  can_launch: boolean;
  can_cancel: boolean;
  can_force: boolean;
  can_rename_ship: boolean;
  can_pick: boolean;
  cloaked: boolean;
  ship_name: string;
  destination_name: string;
};

export const ShuttleControlConsoleMultiAntag = (props, context) => {
  const { act, data } =
    useBackend<ShuttleControlConsoleMultiAntagData>(context);

  return (
    <Window resizable theme="syndicate">
      <Window.Content scrollable>
        <Section title="Shuttle Status">
          <Box pb={2}>{data.shuttle_status}</Box>
          <Box pb={1}>Ship designation and name: {data.ship_name}</Box>
          {data.can_rename_ship ? (
            <Box pb={2}>
              <Button
                content="Rename"
                icon="pen"
                onClick={() => act('rename')}
              />
            </Box>
          ) : null}
          <Box pb={1}>
            Cloaking field is {data.cloaked ? 'enabled' : 'disabled'}.
          </Box>
          <Box pb={2}>
            <Button
              content="Toggle"
              icon={data.cloaked ? 'toggle-on' : 'toggle-off'}
              onClick={() => act('toggle_cloaked')}
            />
          </Box>
          <Box>
            <LabeledList>
              <LabeledList.Item label="Drive">
                {data.shuttle_state == 'idle' ? (
                  <Box>Idle</Box>
                ) : data.shuttle_state == 'warmup' ? (
                  <Box>Spinning up</Box>
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
        <Section title="Destination Control">
          <Box pb={1}>
            <LabeledList>
              <LabeledList.Item label="Current Destination">
                {data.destination_name}
              </LabeledList.Item>
            </LabeledList>
          </Box>
          <Button
            content="Choose Destination"
            icon="plane-arrival"
            disabled={!data.can_pick}
            onClick={() => act('pick')}
          />
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

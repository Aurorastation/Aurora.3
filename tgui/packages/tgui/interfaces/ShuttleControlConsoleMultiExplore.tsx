import { useBackend } from '../backend';
import { Button, Section, Box, LabeledList } from '../components';
import { Window } from '../layouts';

export type ShuttleControlConsoleMultiExploreData = {
  shuttle_status: string;
  shuttle_state: string;
  has_docking: boolean;
  docking_status: string;
  docking_override: boolean;
  can_launch: boolean;
  can_cancel: boolean;
  can_force: boolean;
  can_pick: boolean;
  destination_name: string;
  fuel_usage: number;
  remaining_fuel: number;
  fuel_span: string;
};

export const ShuttleControlConsoleMultiExplore = (props, context) => {
  const { act, data } =
    useBackend<ShuttleControlConsoleMultiExploreData>(context);

  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section title="Shuttle Status">
          <Box pb={1}>{data.shuttle_status}</Box>
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
        <Section title="Destination Control">
          <Box pb={1}>
            <LabeledList>
              <LabeledList.Item label="Current Destination">
                {data.destination_name}
              </LabeledList.Item>
            </LabeledList>
          </Box>
          <Box pb={1}>
            <Button
              content="Choose Destination"
              icon="plane-arrival"
              disabled={!data.can_pick}
              onClick={() => act('pick')}
            />
          </Box>
          {data.fuel_usage ? (
            <Box>
              <LabeledList>
                <LabeledList.Item label="Est. Delta-V Budget">
                  {data.remaining_fuel} m/s
                </LabeledList.Item>
                <LabeledList.Item label="Avg. Delta-V Per Maneuver">
                  {data.fuel_usage} m/s
                </LabeledList.Item>
              </LabeledList>
            </Box>
          ) : null}
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

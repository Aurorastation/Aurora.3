import { useBackend } from '../backend';
import { Button, Section, Box, LabeledList } from '../components';
import { Window } from '../layouts';

export type ShuttleControlConsoleLiftData = {
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

export const ShuttleControlConsoleLift = (props, context) => {
  const { act, data } = useBackend<ShuttleControlConsoleLiftData>(context);

  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section title="Lift Status">
          <LabeledList>
            <LabeledList.Item label="Status">
              {data.shuttle_state == 'idle' ? (
                <Box>Idle</Box>
              ) : data.shuttle_state == 'warmup' ? (
                <Box>Spinning up</Box>
              ) : data.shuttle_state == 'in_transit' ? (
                <Box>Moving</Box>
              ) : (
                <Box>Error</Box>
              )}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Lift Controls">
          <Button
            content="Move Lift"
            icon="elevator"
            disabled={!data.can_launch}
            onClick={() => act('move')}
          />
          <Button
            content="Stop Lift"
            icon="ban"
            disabled={!data.can_cancel}
            onClick={() => act('cancel')}
          />
        </Section>
      </Window.Content>
    </Window>
  );
};

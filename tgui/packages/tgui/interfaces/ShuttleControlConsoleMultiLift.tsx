import { useBackend } from '../backend';
import { Button, Section, Box, LabeledList } from '../components';
import { Window } from '../layouts';

export type ShuttleControlConsoleMultiLiftData = {
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
  destinations: string[];
};

export const ShuttleControlConsoleMultiLift = (props, context) => {
  const { act, data } = useBackend<ShuttleControlConsoleMultiLiftData>(context);

  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section title="Lift Panel">
          <Box pb={2}>{data.shuttle_status}</Box>
          <LabeledList>
            {data.destinations.reverse().map((destination) => (
              <LabeledList.Item label={destination} key={destination}>
                <Button
                  content="Go To"
                  icon="arrow-right-to-bracket"
                  disabled={!data.can_pick}
                  onClick={() => act('pick', { destination: destination })}
                />
              </LabeledList.Item>
            ))}
          </LabeledList>
          <Box pt={2}>
            <Button
              content="STOP"
              icon="triangle-exclamation"
              disabled={!data.can_cancel}
              onClick={() => act('cancel')}
            />
          </Box>
        </Section>
      </Window.Content>
    </Window>
  );
};

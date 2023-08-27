import { useBackend } from '../backend';
import { Button, Section, LabeledList, Box, Divider } from '../components';
import { Window } from '../layouts';

export type TurboLiftData = {
  floors: Object[];
  currentFloor: Number;
  doorsOpen: Boolean;
};

export const TurboLift = (props, context) => {
  const { act, data } = useBackend<TurboLiftData>(context);

  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section title="Lift Panel">
          <LabeledList>
            {
              data.floors.reverse()
              .map((floor, index) => (
                <LabeledList.Item label={floor}>
                  <Button
                    content={
                      data.floors.length - index === data.currentFloor ? 'Current Floor' :
                      'Go To'
                    }
                    icon={
                      data.floors.length - index === data.currentFloor ? 'elevator' :
                      'arrow-right-to-bracket'
                    }
                    disabled={data.floors.length - index === data.currentFloor}
                    onClick={() => act('move_to_floor', { floor: index })}
                    color={data.floors.length - index === data.currentFloor ? '' : 'good'}
                  />
                </LabeledList.Item>
              ))
            }
          </LabeledList>
          <Divider/>
          <Button
            icon={data.doorsOpen ? 'door-closed' : 'door-open'}
            content={data.doorsOpen ? 'Close Doors' : 'Open Doors'}
            onClick={() => act('toggle_doors')}
          />
          <Button
            icon="triangle-exclamation"
            color="red"
            content="Emergency Stop"
            onClick={() => act('emergency_stop')}
          />
        </Section>
      </Window.Content>
    </Window>
  );
};

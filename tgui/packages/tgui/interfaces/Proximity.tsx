import { useBackend } from '../backend';
import { Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

export type ProximityData = {

}

export const Proximity = (props, context) => {
  const { act, data } = useBackend<ProximityData>(context);

  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section title="Auxiliary Timing Unit">
          <Button
            content=
          />
        </Section>
      </Window.Content>
    </Window>
  );
};

import { useBackend } from '../backend';
import { Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

export type AIData = {

}

export const AIMaintenance = (props, context) => {
  const { act, data } = useBackend<AIData>(context);

  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section title="Title">

        </Section>
      </Window.Content>
    </Window>
  );
};

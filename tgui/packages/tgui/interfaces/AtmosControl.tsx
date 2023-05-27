import { useBackend } from '../backend';
import { Section } from '../components';
import { Window } from '../layouts';

export type AtmosData = {
  
};

export const AtmosControl = (props, context) => {
  const { act, data } = useBackend<AtmosData>(context);

  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section title="Title" />
      </Window.Content>
    </Window>
  );
};

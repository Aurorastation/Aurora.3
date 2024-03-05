import { useBackend } from '../backend';
import { Section } from '../components';
import { Window } from '../layouts';

export type OutbreakData = {};

export const Outbreak = (props, context) => {
  const { act, data } = useBackend<OutbreakData>(context);

  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section title="Outbreak Controller">Outbreak content here.</Section>
      </Window.Content>
    </Window>
  );
};

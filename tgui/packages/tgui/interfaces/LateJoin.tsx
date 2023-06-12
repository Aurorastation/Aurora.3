import { useBackend } from '../backend';
import { Section } from '../components';
import { Window } from '../layouts';

export type UIData = {};

export const LateJoin = (props, context) => {
  const { act, data } = useBackend<UIData>(context);

  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section>test</Section>
      </Window.Content>
    </Window>
  );
};

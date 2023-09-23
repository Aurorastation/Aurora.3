import { useBackend } from '../backend';
import { Section } from '../components';
import { Window } from '../layouts';

export type FusionGyrotronControl = {
  manufacturer: string;
};

export const FusionInjectorControl = (props, context) => {
  const { act, data } = useBackend<FusionGyrotronControl>(context);

  return (
    <Window resizable theme={data.manufacturer}>
      <Window.Content scrollable>
        <Section title="Title" />
      </Window.Content>
    </Window>
  );
};

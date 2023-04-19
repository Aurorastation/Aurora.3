import { useBackend } from '../backend';
import { Button, Section, Box } from '../components';
import { Window } from '../layouts';

type ShipGun = {
  name: string;
  caliber: string;
  ammunition: string;
};

export const Gunnery = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section title="Ajax Targeting Console">
          <Button
            icon="calendar"
            content="View Targeting Grid"
            onClick={() => act('viewing')}
          />

          {!!!data.targeting && (
            <Box bold>{'No target designated.'}</Box>
        )}
        </Section>
      </Window.Content>
    </Window>
  );
};

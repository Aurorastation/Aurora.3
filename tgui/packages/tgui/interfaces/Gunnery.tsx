import { useBackend } from '../backend';
import { Button, Section, Box, BlockQuote } from '../components';
import { Dropdown } from '../components/MenuBar';
import { Window } from '../layouts';

type ShipGun = {
  name: string;
  caliber: string;
  ammunition: string;
};

type GunneryData = {
  guns: ShipGun[];
  entry_points: string[];
  targeting: Targeting;
};

type Targeting = {
  name: string;
  shiptype: string;
  distance: number;
};

export const GunneryWindow = (props, context) => {
  const { act, data } = useBackend<GunneryData>(context);
  const { entry_points } = data;
  if (!data.targeting) {
    return (
      <Section collapsing title="Targeting Information">
        <Box bold>No target designated.</Box>
      </Section>
    );
  } else {
    return (
      <Section>
        <Section collapsing title="Lock-On Information">
          <Box bold>Target:</Box>
          <BlockQuote>{data.targeting.name}</BlockQuote>
          <Box bold>Type: </Box>{' '}
          <BlockQuote>{data.targeting.shiptype}</BlockQuote>
          <Box bold>Distance: </Box>{' '}
          <BlockQuote>{data.targeting.distance} click(s)</BlockQuote>
        </Section>
        <Section collapsing title="Targeting Calibration">
          <Dropdown options={entry_points} />
        </Section>
      </Section>
    );
  }
};

export const Gunnery = (props, context) => {
  const { act, data } = useBackend<GunneryData>(context);
  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section title="Ajax Targeting Console">
          <Button
            icon="calendar"
            color="red"
            content="View Targeting Grid"
            onClick={() => act('viewing')}
          />
        </Section>
        <GunneryWindow />
      </Window.Content>
    </Window>
  );
};

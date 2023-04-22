import { capitalizeAll } from '../../common/string';
import { useBackend } from '../backend';
import { Button, Section, Box, BlockQuote } from '../components';
import { Dropdown } from '../components/Dropdown';
import { Window } from '../layouts';

type ShipGun = {
  name: string;
  caliber: string;
  ammunition: string;
  ammunition_type: string;
};

export type GunneryData = {
  guns: ShipGun[];
  cannon: ShipGun;
  gun_list: string[];
  entry_points: string[];
  targeting: Targeting;
  selected_entrypoint: string;
};

type Targeting = {
  name: string;
  shiptype: string;
  distance: number;
};

export const GunneryWindow = (props, context) => {
  const { act, data } = useBackend<GunneryData>(context);
  const { entry_points } = data;
  const { guns } = data;
  let gun_names: String[];
  gun_names = [];
  gun_names = guns.map((gun) => {
    return capitalizeAll(gun.name);
  });
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
          <Dropdown
            options={entry_points}
            displayText={data.selected_entrypoint}
            width="100%"
            onSelected={(value) =>
              act('select_entrypoint', { entrypoint: value })
            }
          />
        </Section>
        <Section collapsing title="Weaponry Control">
          <Dropdown
            options={gun_names}
            width="100%"
            onSelected={(value) => act('select_gun', { gun: value })}
          />
          {data.cannon && (
            <Section>
              <Box bold>Type:</Box>
              <BlockQuote>{data.cannon.name}</BlockQuote>
              <Box bold>Caliber:</Box>
              <BlockQuote>{data.cannon.caliber}</BlockQuote>
              <Box bold>Loaded:</Box>
              <BlockQuote>{data.cannon.ammunition_type}</BlockQuote>
              <Box bold>Ammunition Type:</Box>
              <BlockQuote>{data.cannon.ammunition_type}</BlockQuote>
            </Section>
          )}
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

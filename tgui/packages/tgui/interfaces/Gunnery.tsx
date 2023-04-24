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
  z_levels: string[];
  selected_z: number;
  targeting: Targeting;
  selected_entrypoint: string;
  mobile_platform: boolean;
  platform_directions: string[];
  platform_direction: string;
};

type Targeting = {
  name: string;
  shiptype: string;
  distance: number;
};

export const GunneryWindow = (props, context) => {
  const { act, data } = useBackend<GunneryData>(context);
  const { entry_points, z_levels, guns, platform_directions } = data;
  let gun_names: String[];
  gun_names = [];
  gun_names = guns.map((gun) => {
    return capitalizeAll(gun.name);
  });
  let target_name;
  if (data.targeting) {
    target_name = capitalizeAll(data.targeting.name);
  }
  let cannon_name;
  let cannon_caliber;
  if (data.cannon) {
    cannon_name = capitalizeAll(data.cannon.name);
    cannon_caliber = capitalizeAll(data.cannon.caliber);
  }
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
          <BlockQuote>{target_name}</BlockQuote>
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
          {data.z_levels && (
            <Section>
              <Box as bold>
                Deck Filter
              </Box>
              <Dropdown
                options={z_levels}
                displayText={data.selected_z}
                width="100%"
                onSelected={(value) => act('select_z', { z: value })}
              />
            </Section>
          )}
          {data.mobile_platform && (
            <Section>
              <Dropdown
                options={platform_directions}
                displayText={data.platform_direction}
                width="100%"
                onSelected={(value) =>
                  act('platform_direction', { dir: value })
                }
              />
            </Section>
          )}
        </Section>
        <Section collapsing title="Weaponry Control">
          <Dropdown
            options={gun_names}
            width="100%"
            displayText={cannon_name ? cannon_name : ''}
            onSelected={(value) => act('select_gun', { gun: value })}
          />
          {data.cannon && (
            <Section>
              <Box bold>Type:</Box>
              <BlockQuote>{cannon_name}</BlockQuote>
              <Box bold>Caliber:</Box>
              <BlockQuote>{cannon_caliber}</BlockQuote>
              <Box bold>Loaded:</Box>
              <BlockQuote>{data.cannon.ammunition}</BlockQuote>
              <Box bold>Ammunition Type:</Box>
              <BlockQuote>{data.cannon.ammunition_type}</BlockQuote>
              <Button
                color="red"
                icon="exclamation-triangle"
                content="FIRE"
                onClick={() => act('fire')}
              />
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

import { BooleanLike } from '../../common/react';
import { capitalizeAll } from '../../common/string';
import { useBackend } from '../backend';
import { Button, Section, Box, LabeledList } from '../components';
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
  mobile_platform: BooleanLike;
  platform_directions: string[];
  platform_direction: string;
  destination_map_image: any; // base64 icon
  destination_x: number;
  destination_y: number;
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
    const map_size = 255;
    const zoom_mod = 2.0;
    const center_point_x = data.destination_x;
    const center_point_y = data.destination_y;
    return (
      <Section>
        <Section collapsing title="Lock-On Information">
          <LabeledList>
            <LabeledList.Item label="Target">{target_name}</LabeledList.Item>
            <LabeledList.Item label="Type">
              {data.targeting.shiptype}
            </LabeledList.Item>
            <LabeledList.Item label="Distance">
              {data.targeting.distance} click(s)
            </LabeledList.Item>
          </LabeledList>
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
          {data.z_levels ? (
            <Section>
              <Box bold>Deck Filter</Box>
              <Dropdown
                options={z_levels}
                displayText={data.selected_z}
                width="100%"
                onSelected={(value) => act('select_z', { z: value })}
              />
            </Section>
          ) : (
            ''
          )}
          {data.mobile_platform ? (
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
          ) : (
            ''
          )}
        </Section>
        <Section collapsing title="Scan?">
          {data.destination_map_image ? (
            <Section title="Scan">
              <svg
                height={'250px'}
                width={'100%'}
                viewBox={`0 0 ${map_size} ${map_size}`}
                overflow={'hidden'}>
                <g
                  transform={`translate(
                ${
                  (map_size * (zoom_mod - 1.0)) / -2 +
                  (255 / 2 - center_point_x)
                }
                ${
                  (map_size * (zoom_mod - 1.0)) / -2 +
                  (255 / 2 - (map_size - center_point_y))
                }
              )`}>
                  <image
                    width={map_size * zoom_mod}
                    height={map_size * zoom_mod}
                    xlinkHref={`data:image/jpeg;base64,${data.destination_map_image}`}
                  />
                  <polygon
                    points="3,0 0,3 -3,0 0,-3"
                    fill="#FF0000"
                    stroke="#FFFF00"
                    stroke-width="0.5"
                    transform={`translate(
                      ${center_point_x * zoom_mod}
                      ${(map_size - center_point_y) * zoom_mod}
                    )`}
                  />
                  <circle
                    r={16}
                    cx={0}
                    cy={0}
                    fill="none"
                    stroke="#FF0000"
                    stroke-width="1"
                    transform={`translate(
                      ${center_point_x * zoom_mod}
                      ${(map_size - center_point_y) * zoom_mod}
                    )`}
                  />
                  <rect
                    x={-24}
                    y={-24}
                    width={48}
                    height={48}
                    stroke="red"
                    stroke-width="1"
                    fill="none"
                    transform={`translate(
                    ${center_point_x * zoom_mod}
                    ${(map_size - center_point_y) * zoom_mod}
                  )`}
                  />
                  <text
                    x="26"
                    y="-8"
                    text-anchor="left"
                    fill="red"
                    font-size="12"
                    transform={`translate(
                    ${center_point_x * zoom_mod}
                    ${(map_size - center_point_y) * zoom_mod}
                  )`}>
                    {data.destination_x}
                  </text>
                  <text
                    x="26"
                    y="8"
                    text-anchor="left"
                    fill="red"
                    font-size="12"
                    transform={`translate(
                    ${center_point_x * zoom_mod}
                    ${(map_size - center_point_y) * zoom_mod}
                  )`}>
                    {data.destination_y}
                  </text>
                </g>
              </svg>
            </Section>
          ) : (
            ''
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
              <LabeledList>
                <LabeledList.Item label="Type">{cannon_name}</LabeledList.Item>
                <LabeledList.Item label="Caliber">
                  {cannon_caliber}
                </LabeledList.Item>
                <LabeledList.Item label="Loaded">
                  {data.cannon.ammunition}
                </LabeledList.Item>
                <LabeledList.Item label="Ammunition Type">
                  {data.cannon.ammunition_type}
                </LabeledList.Item>
              </LabeledList>
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
    <Window resizable theme="zavodskoi">
      <Window.Content scrollable>
        <Section title="Ajax Targeting Console">
          <Button
            icon="calendar"
            color="red"
            content="View Targeting Grid"
            onClick={() => act('viewing')}
          />
          <GunneryWindow />
        </Section>
      </Window.Content>
    </Window>
  );
};

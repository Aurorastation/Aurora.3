import { useBackend, useLocalState } from '../backend';
import { Tabs, Slider, Input, Box, Section, Table } from '../components';
import { NtosWindow } from '../layouts';
import { TextInputModal } from './TextInputModal';

export type MapData = {
  map_images: any; // base64 icon
  map_images_e: any; // base64 icon
  user_x: number;
  user_y: number;
  user_z: number;
};

export const Map = (props, context) => {
  const { act, data } = useBackend<MapData>(context);

  const [minimapZoom, setMinimapZoom] = useLocalState<number>(
    context,
    `minimapZoom`,
    100
  );

  const map_size = 255;
  const zoom_mod = minimapZoom / 100.0;

  return (
    <NtosWindow resizable>
      <NtosWindow.Content scrollable>
        <Section title="Map Program">
          <Section fitted>
            <Tabs>
              <Tabs.Tab
                height="20%"
                onClick={() => act('z_override', { z_override: 1 })}>
                1
              </Tabs.Tab>
              <Tabs.Tab
                height="20%"
                onClick={() => act('z_override', { z_override: 2 })}>
                2
              </Tabs.Tab>
              <Tabs.Tab
                height="20%"
                onClick={() => act('z_override', { z_override: 3 })}>
                3
              </Tabs.Tab>
            </Tabs>
          </Section>
          <Slider
            animated
            step={1}
            stepPixelSize={10}
            value={minimapZoom}
            minValue={100}
            maxValue={200}
            onChange={(e, value) => setMinimapZoom(value)}>
            Zoom: {minimapZoom}%
          </Slider>
          <svg
            height={'500px'}
            width={'100%'}
            viewBox={`0 0 ${map_size} ${map_size}`}
            overflow={'hidden'}>
            <rect width={map_size} height={map_size} />
            <g
              transform={`translate(
                ${(map_size * (zoom_mod - 1.0)) / -2 + (255 / 2 - data.user_x)}
                ${
                  (map_size * (zoom_mod - 1.0)) / -2 +
                  (255 / 2 - (map_size - data.user_y))
                }
              )`}>
              <image
                width={map_size * zoom_mod}
                height={map_size * zoom_mod}
                xlinkHref={`data:image/jpeg;base64,${
                  data.map_images_e[data.user_z - 1]
                }`}
              />
              <polygon
                points="3,0 0,3 -3,0 0,-3"
                fill="#FF0000"
                stroke="#FFFF00"
                stroke-width="0.5"
                transform={`translate(
                  ${data.user_x * zoom_mod}
                  ${(map_size - data.user_y) * zoom_mod}
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
                  ${data.user_x * zoom_mod}
                  ${(map_size - data.user_y) * zoom_mod}
                )`}
              />
            </g>
          </svg>
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};

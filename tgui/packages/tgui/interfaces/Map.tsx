import { useBackend } from '../backend';
import { Input, Box, Section, Table } from '../components';
import { NtosWindow } from '../layouts';
import { TextInputModal } from './TextInputModal';

export type MapData = {
  map_images: any; // base64 icon
  user_x: number;
  user_y: number;
  user_z: number;
};

export const Map = (props, context) => {
  const { act, data } = useBackend<MapData>(context);

  return (
    <NtosWindow resizable>
      <NtosWindow.Content scrollable>
        <Section title="Map Program">
          <svg
            height={500}
            width={500}
            viewBox="0 0 480 480"
            overflow={'hidden'}>
            <rect width="480" height="480" />
            <g transform="translate(-240 -240)">
              <image
                width={480 * 2}
                height={480 * 2}
                xlinkHref={`data:image/jpeg;base64,${
                  data.map_images[data.user_z - 1]
                }`}
              />
              <polygon
                points="4,0 0,4 -4,0 0,-4"
                fill="#FF0000"
                stroke="white"
                stroke-width="0.5"
                transform={`translate(${(data.user_x + (480 - 255) / 2) * 2} ${
                  (255 - data.user_y + (480 - 255) / 2) * 2
                })`}
              />
              <circle
                r={16}
                cx={0}
                cy={0}
                fill="none"
                stroke="#FF0000"
                stroke-width="1"
                transform={`translate(${(data.user_x + (480 - 255) / 2) * 2} ${
                  (255 - data.user_y + (480 - 255) / 2) * 2
                })`}
              />
            </g>
          </svg>
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};

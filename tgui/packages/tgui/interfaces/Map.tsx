import { useBackend } from '../backend';
import { Box, Section, Table } from '../components';
import { NtosWindow } from '../layouts';

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
            height={510}
            width={510}
            viewBox="0 0 255 255"
            overflow={'hidden'}>
            <rect width="255" height="255" />
            <image
              // x="-50"
              // y="-50"
              width={255}
              height={255}
              xlinkHref={`data:image/jpeg;base64,${
                data.map_images[data.user_z - 1]
              }`}
            />
            <polygon
              points="2,0 0,2 -2,0 0,-2"
              fill="#5c83b0"
              stroke="white"
              stroke-width="0.5"
              transform={`translate(${data.user_x} ${data.user_y})`}
            />
          </svg>
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};

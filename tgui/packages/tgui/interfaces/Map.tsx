import { useBackend } from '../backend';
import { Box, Section, Table } from '../components';
import { NtosWindow } from '../layouts';

export type MapData = {
  map_images: any; // base64 icon
};

export const Map = (props, context) => {
  const { act, data } = useBackend<MapData>(context);

  return (
    <NtosWindow resizable>
      <NtosWindow.Content scrollable>
        <Section title="Map Program">
          {data.map_images.map((map_image) => (
            <Box
              as="img"
              m={0}
              src={`data:image/jpeg;base64,${map_image}`}
              width="100%"
              // height="100%"
              style={{
                '-ms-interpolation-mode': 'nearest-neighbor',
              }}
            />
          ))}
          {/* <Box
            as="img"
            m={0}
            src={`data:image/jpeg;base64,${data.map_images[0]}`}
            width="100%"
            // height="100%"
            style={{
              '-ms-interpolation-mode': 'nearest-neighbor',
            }}
          /> */}
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};

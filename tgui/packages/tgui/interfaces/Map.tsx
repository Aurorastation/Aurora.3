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
          {/* <div style="width: 200px; height: 200px; overflow: hidden;">
            <img
              // src={`data:image/jpeg;base64,${data.map_images[2]}`}
              src="https://wiki.aurorastation.org/images/d/d6/Corapt2EG.png"
              // style="clip: rect(0px,510px,510px,0px);"
              // style="width: 300px; height: 337px; object-fit: cover; object-position: 100% 0;"
              // width={200}
              // height={200}
              // style="clip: rect(0, 512px, 512px, 0); position: absolute;"
              // style="clip: rect(100px, 100px, 100px, 100px); position: absolute; display: inline-block; overflow: hidden;"
              // style="clip: rect(1000px, 1000px, 1000px, 1000px); position: absolute;"
            />
          </div> */}
          {/* <div
            style={`background-image:\
            url('data:image/jpeg;base64,${data.map_images[2]}');\
            width:300px;\
            height:300px;\
            background-position:center; border: solid; border-color: white`}>
            &nbsp;
          </div> */}
          <svg
            height={400}
            width={400}
            viewBox="0 0 1000 1000"
            overflow={'hidden'}>
            <rect width="1000" height="1000" />
            <image
              x="-500"
              y="-500"
              width={2000}
              height={2000}
              xlinkHref={`data:image/jpeg;base64,${data.map_images[2]}`}
            />
          </svg>

          {/* </Box> */}
          {/* {data.map_images.map((map_image) => (
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
          ))} */}
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

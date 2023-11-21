import { paginate } from 'common/collections';
import { useBackend, useLocalState } from '../backend';
import { Tabs, Slider, Section, NoticeBox, Table } from '../components';
import { NtosWindow } from '../layouts';

export type MapData = {
  map_image: any; // base64 icon
  user_x: number;
  user_y: number;
  user_z: number;
  station_levels: number[];
  z_override: number;
  dept_colors_map: { d: string; c: string }[];
};

export const Map = (props, context) => {
  const { act, data } = useBackend<MapData>(context);

  const [minimapZoom, setMinimapZoom] = useLocalState<number>(
    context,
    `minimapZoom`,
    100
  );

  const [showLegend, setShowLegend] = useLocalState<boolean>(
    context,
    `showLegend`,
    false
  );

  const map_size = 255;
  const zoom_mod = minimapZoom / 100.0;

  return (
    <NtosWindow resizable>
      <NtosWindow.Content scrollable>
        <Section title="Map Program">
          <Tabs>
            <Tabs.Tab>Levels: </Tabs.Tab>
            {data.station_levels?.map((station_level) => (
              <Tabs.Tab
                key={station_level}
                width="50px"
                backgroundColor={
                  data.z_override === station_level ? '#4972a1' : null
                }
                icon={data.user_z === station_level ? 'user' : 'minus'}
                onClick={() =>
                  act('z_override', { z_override: station_level })
                }>
                {station_level}
              </Tabs.Tab>
            ))}
            {data.z_override ? (
              <Tabs.Tab
                icon="filter-circle-xmark"
                onClick={() => act('z_override', { z_override: 0 })}>
                Clear Override
              </Tabs.Tab>
            ) : (
              ''
            )}
            <Tabs.Tab
              icon="fa-circle-question"
              onClick={() => setShowLegend(!showLegend)}>
              {showLegend ? 'Hide Legend' : 'Show Legend'}
            </Tabs.Tab>
          </Tabs>
          {showLegend ? (
            <NoticeBox color="grey">
              <Table>
                {paginate(data.dept_colors_map, 2).map((a) => (
                  <Table.Row key={a}>
                    <Table.Cell color={a[0].c}>{a[0].d}</Table.Cell>
                    <Table.Cell color={a[1].c}>{a[1].d}</Table.Cell>
                  </Table.Row>
                ))}
              </Table>
            </NoticeBox>
          ) : (
            ''
          )}
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
                xlinkHref={`data:image/jpeg;base64,${data.map_image}`}
              />
              {!data.z_override || data.user_z === data.z_override ? (
                <>
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
                </>
              ) : (
                ''
              )}
            </g>
          </svg>
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};

import { useBackend } from '../backend';
import { Button, Section, Box, LabeledList } from '../components';
import { Window } from '../layouts';

export type ShuttleControlConsoleMultiExploreData = {
  shuttle_status: string;
  shuttle_state: string;
  has_docking: boolean;
  docking_status: string;
  docking_override: boolean;
  can_launch: boolean;
  can_cancel: boolean;
  can_force: boolean;
  can_pick: boolean;
  destination_name: string;
  destination_map_image: any; // base64 icon
  destination_x: number;
  destination_y: number;
  fuel_usage: number;
  remaining_fuel: number;
  fuel_span: string;
};

export const ShuttleControlConsoleMultiExplore = (props, context) => {
  const { act, data } =
    useBackend<ShuttleControlConsoleMultiExploreData>(context);

  const map_size = 255;
  const zoom_mod = 2.0;
  const center_point_x = data.destination_x;
  const center_point_y = data.destination_y;

  const rand = Math.random() * 1.0;

  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section title="Shuttle Status">
          <Box pb={1}>{data.shuttle_status}</Box>
          <Box>
            <LabeledList>
              <LabeledList.Item label="Engines">
                {data.shuttle_state === 'idle'
                  ? 'Idle'
                  : data.shuttle_state === 'warmup'
                    ? 'Starting Ignition'
                    : data.shuttle_state === 'in_transit'
                      ? 'Engaged'
                      : 'Error'}
              </LabeledList.Item>
              {data.has_docking ? (
                <LabeledList.Item label="Docking Status">
                  {data.docking_status === 'docked'
                    ? 'Docked'
                    : data.docking_status === 'docking'
                      ? data.docking_override
                        ? 'Docking-Manual'
                        : 'Docking'
                      : data.docking_status === 'undocking'
                        ? data.docking_override
                          ? 'Undocking-Manual'
                          : 'Undocking'
                        : data.docking_status === 'undocked'
                          ? 'Undocked'
                          : 'Error'}
                </LabeledList.Item>
              ) : null}
            </LabeledList>
          </Box>
        </Section>
        <Section title="Destination Control">
          <Box pb={1}>
            <LabeledList>
              <LabeledList.Item label="Current Destination">
                {data.destination_name}
              </LabeledList.Item>
            </LabeledList>
          </Box>
          <Box pb={1}>
            <Button
              content="Choose Destination"
              icon="plane-arrival"
              disabled={!data.can_pick}
              onClick={() => act('pick')}
            />
          </Box>
          {data.fuel_usage ? (
            <Box>
              <LabeledList>
                <LabeledList.Item label="Est. Delta-V Budget">
                  {data.remaining_fuel} m/s
                </LabeledList.Item>
                <LabeledList.Item label="Avg. Delta-V Per Maneuver">
                  {data.fuel_usage} m/s
                </LabeledList.Item>
              </LabeledList>
            </Box>
          ) : null}
        </Section>

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
        <Section title="Shuttle Control">
          <Button
            content="Launch Shuttle"
            icon="rocket"
            disabled={!data.can_launch}
            onClick={() => act('move')}
          />
          <Button
            content="Cancel Launch"
            icon="ban"
            disabled={!data.can_cancel}
            onClick={() => act('cancel')}
          />
          <Button
            content="Force Launch"
            icon="triangle-exclamation"
            color="red"
            disabled={!data.can_force}
            onClick={() => act('force')}
          />
        </Section>
      </Window.Content>
    </Window>
  );
};

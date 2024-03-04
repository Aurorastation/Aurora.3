import { randomInteger } from 'common/random';
import { useBackend } from '../backend';
import { Button, Section, Box, LabeledList, NoticeBox } from '../components';
import { Window } from '../layouts';
import { MinimapView } from './common/MinimapView';

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
  jump_to_overmap_capable: boolean;
  can_jump_to_overmap: boolean;
  world_time: number;
};

export const ShuttleControlConsoleMultiExplore = (props, context) => {
  const { act, data } =
    useBackend<ShuttleControlConsoleMultiExploreData>(context);

  const recharge_time = Math.floor((360000 - data.world_time) / 10 / 60);

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
            {MinimapView({
              map_image: data.destination_map_image,
              x: data.destination_x,
              y: data.destination_y,
            })}
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

        {data.jump_to_overmap_capable ? (
          <Section title="Warp Drive Control">
            {data.can_jump_to_overmap ? (
              <NoticeBox warning>
                Warp drive ready
                <br />
                <Button
                  content="Long-range jump to next sector"
                  icon="rocket"
                  color="blue"
                  onClick={() => act('jump_to_overmap')}
                />
                <br />
                Jump will be executed immediately
              </NoticeBox>
            ) : (
              ''
            )}
            <NoticeBox info>
              Jump drive: Suzuki-Zhang Hammer Drive (Modified)
              <br />
              Serial number: 0{randomInteger(1000000, 9999999)}.2137.EE
              <br />
              Status:{' '}
              {data.can_jump_to_overmap ? 'Operational' : 'Recharging...'}
              <br />
              Recharge time:{' '}
              {data.can_jump_to_overmap
                ? 'Approx 9 hours'
                : recharge_time + ' minutes remaining...'}
            </NoticeBox>
          </Section>
        ) : (
          ''
        )}
      </Window.Content>
    </Window>
  );
};

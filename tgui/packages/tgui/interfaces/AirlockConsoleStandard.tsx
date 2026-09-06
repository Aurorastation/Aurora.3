import {
  Box,
  Button,
  LabeledList,
  ProgressBar,
  Section,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { useBackend } from '../backend';
import { Window } from '../layouts';

export type StandardAirlockConsoleData = {
  chamber_pressure: number;
  controller_powered: BooleanLike;
  cycle_status: string;
  exterior_door_lock: string;
  exterior_door_power?: BooleanLike;
  exterior_door_state: string;
  interior_door_lock: string;
  interior_door_power?: BooleanLike;
  interior_door_state: string;
  pump_status: 'off' | 'release' | 'siphon' | 'unknown';
  processing: boolean;
};

const doorStatus = (state: string, lock: string, power?: BooleanLike) => {
  if (power === undefined || power === null) {
    return 'No Response';
  }
  return `${state === 'open' ? 'Open' : 'Closed'} / ${lock === 'locked' ? 'Bolted' : 'Unbolted'} (${power ? 'Online' : 'No Power'})`;
};

const doorColor = (state: string, power?: BooleanLike) => {
  if (power === undefined || power === null) {
    return 'yellow';
  }
  return !power ? 'red' : state === 'open' ? 'yellow' : 'green';
};

const pumpStatus = (status: StandardAirlockConsoleData['pump_status']) => {
  switch (status) {
    case 'release':
      return 'Pressurizing';
    case 'siphon':
      return 'Depressurizing';
    case 'off':
      return 'Off';
    default:
      return 'No Response';
  }
};

export const AirlockConsoleStandard = (props) => {
  const { act, data } = useBackend<StandardAirlockConsoleData>();

  return (
    <Window>
      <Window.Content scrollable>
        <Section title="Status">
          <Box>
            <LabeledList>
              <LabeledList.Item
                label="Controller Power"
                color={data.controller_powered ? 'green' : 'red'}
              >
                {data.controller_powered ? 'Online' : 'No Power'}
              </LabeledList.Item>
              <LabeledList.Item
                label="Cycle"
                color={data.processing ? 'yellow' : 'green'}
              >
                {data.cycle_status}
              </LabeledList.Item>
              <LabeledList.Item label="Pump">
                {pumpStatus(data.pump_status)}
              </LabeledList.Item>
              <LabeledList.Item
                label="Exterior Door"
                color={doorColor(
                  data.exterior_door_state,
                  data.exterior_door_power,
                )}
              >
                {doorStatus(
                  data.exterior_door_state,
                  data.exterior_door_lock,
                  data.exterior_door_power,
                )}
              </LabeledList.Item>
              <LabeledList.Item
                label="Interior Door"
                color={doorColor(
                  data.interior_door_state,
                  data.interior_door_power,
                )}
              >
                {doorStatus(
                  data.interior_door_state,
                  data.interior_door_lock,
                  data.interior_door_power,
                )}
              </LabeledList.Item>
              <LabeledList.Item label="Chamber Pressure">
                <ProgressBar
                  ranges={{
                    average: [120, Infinity],
                    good: [80, 120],
                    bad: [-Infinity, 80],
                  }}
                  value={data.chamber_pressure}
                  minValue={0}
                  maxValue={200}
                >
                  {data.chamber_pressure} kPa
                </ProgressBar>
              </LabeledList.Item>
            </LabeledList>
          </Box>
        </Section>
        <Section title="Controls">
          <Box>
            <Button
              content="Cycle to Exterior"
              icon="arrow-right-from-bracket"
              onClick={() => act('command', { command: 'cycle_ext' })}
            />
            <Button
              content="Cycle to Interior"
              icon="arrow-right-to-bracket"
              onClick={() => act('command', { command: 'cycle_int' })}
            />
          </Box>
          <Box>
            <Button
              content="Force Exterior Door"
              icon="circle-exclamation"
              color="yellow"
              onClick={() => act('command', { command: 'force_ext' })}
            />
            <Button
              content="Force Interior Door"
              icon="circle-exclamation"
              color="yellow"
              onClick={() => act('command', { command: 'force_int' })}
            />
          </Box>
        </Section>
      </Window.Content>
    </Window>
  );
};

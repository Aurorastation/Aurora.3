import {
  Box,
  Button,
  LabeledList,
  NumberInput,
  Section,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { useBackend } from '../backend';
import { Window } from '../layouts';

export type ShieldData = {
  owned_capacitor: BooleanLike;
  active: BooleanLike;
  time_since_fail: number;
  multiz: BooleanLike;
  field_radius: number;
  min_field_radius: number;
  max_field_radius: number;
  average_field: number;
  progress_field: number;
  power_take: number;
  shield_power: number;
  strengthen_rate: number;
  max_strengthen_rate: number;
  target_field_strength: number;
};

export const ShieldGenerator = (props) => {
  const { act, data } = useBackend<ShieldData>();

  return (
    <Window>
      <Window.Content scrollable>
        <Section
          title="Shield Information"
          buttons={
            <Button
              content={data.active ? 'Online' : 'Offline'}
              color={data.active ? 'good' : 'bad'}
              icon={data.active ? 'power-off' : 'times'}
              onClick={() => act('toggle')}
            />
          }
        >
          <LabeledList>
            <LabeledList.Item label="Capacitor">
              {data.owned_capacitor ? (
                <Box color="good">Connected</Box>
              ) : (
                <Box color="bad">Not Found</Box>
              )}
            </LabeledList.Item>
            <LabeledList.Item label="Multi-Level Shield">
              <Button
                content={data.multiz ? 'Online' : 'Offline'}
                color={data.multiz ? 'good' : 'bad'}
                icon={data.multiz ? 'power-off' : 'times'}
                onClick={() => act('multiz')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Field Status">
              {data.time_since_fail > 2 ? (
                <Box color="good">Stable</Box>
              ) : (
                <Box color="bad">Unstable</Box>
              )}
            </LabeledList.Item>
            <LabeledList.Item label="Overall Strength">
              {data.average_field} Renwick ({data.progress_field}%)
            </LabeledList.Item>
            <LabeledList.Item label="Upkeep Power">
              {data.power_take} W
            </LabeledList.Item>
            <LabeledList.Item label="Shield Generation Power">
              {data.shield_power} W
            </LabeledList.Item>
          </LabeledList>
          <Section title="Settings">
            <LabeledList>
              <LabeledList.Item label="Coverage Radius">
                <NumberInput
                  value={data.field_radius}
                  step={1}
                  minValue={data.min_field_radius}
                  maxValue={data.max_field_radius}
                  onDrag={(value) => act('size_set', { size_set: value })}
                />
              </LabeledList.Item>
              <LabeledList.Item label="Charge Rate">
                <NumberInput
                  value={data.strengthen_rate}
                  step={1}
                  minValue={1}
                  maxValue={data.max_strengthen_rate}
                  stepPixelSize={20}
                  onDrag={(value) => act('charge_set', { charge_set: value })}
                />
              </LabeledList.Item>
              <LabeledList.Item label="Maximum Field Strength">
                <NumberInput
                  value={data.target_field_strength}
                  step={1}
                  minValue={1}
                  maxValue={10}
                  stepPixelSize={10}
                  onDrag={(value) => act('field_set', { field_set: value })}
                />
              </LabeledList.Item>
            </LabeledList>
          </Section>
        </Section>
      </Window.Content>
    </Window>
  );
};

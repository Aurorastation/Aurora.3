import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Button, Box, LabeledList, Section, NumberInput } from '../components';
import { Window } from '../layouts';

export type ShieldData = {
  owned_capacitor: BooleanLike;
  active: BooleanLike;
  time_since_fail: number;
  multi_unlocked: BooleanLike;
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

export const ShieldGenerator = (props, context) => {
  const { act, data } = useBackend<ShieldData>(context);

  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section
          title="Shield Information"
          buttons={
            <Button
              content={data.active ? 'Online' : 'Offline'}
              color={data.active ? "good" : "bad"}
              icon={data.active ? 'power-off' : 'times'}
              onClick={() => act('toggle')}
            />
          }>
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
                color={data.multiz ? "good" : "bad"}
                icon={data.multiz ? 'power-off' : 'times'}
                onClick={() => act('multiz')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Field Status">
              {data.time_since_fail > 2 ? (
                <Box color="bad">Unstable</Box>
              ) : (
                <Box color="good">Stable</Box>
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
                  minValue={data.min_field_radius}
                  maxValue={data.max_field_radius}
                  onDrag={(e, value) => act('size_set', { size_set: value })}
                />
              </LabeledList.Item>
              <LabeledList.Item label="Charge Rate">
                <NumberInput
                  value={data.strengthen_rate}
                  minValue={1}
                  maxValue={data.max_strengthen_rate}
                  stepPixelSize={20}
                  onDrag={(e, value) =>
                    act('charge_set', { charge_set: value })
                  }
                />
              </LabeledList.Item>
              <LabeledList.Item label="Maximum Field Strength">
                <NumberInput
                  value={data.target_field_strength}
                  minValue={1}
                  maxValue={10}
                  stepPixelSize={10}
                  onDrag={(e, value) => act('field_set', { field_set: value })}
                />
              </LabeledList.Item>
            </LabeledList>
          </Section>
        </Section>
      </Window.Content>
    </Window>
  );
};

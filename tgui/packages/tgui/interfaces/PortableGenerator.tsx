import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Button, Box, LabeledList, Section, ProgressBar, Knob } from '../components';
import { capitalizeAll } from '../../common/string';
import { Window } from '../layouts';

export type GeneratorData = {
  active: BooleanLike;
  output_set: number;
  output_max: number;
  output_min: number;
  output_safe: number;
  temperature_current: number;
  temperature_max: number;
  temperature_overheat: number;
  temperature_min: number;
  is_broken: BooleanLike;
  is_ai: BooleanLike;
  fuel: Fuel;
  uses_coolant: BooleanLike;
  coolant_stored: number;
  coolant_capacity: number;
  output_watts: number;
};

type Fuel = {
  fuel_stored: number;
  fuel_capacity: number;
  fuel_usage: number;
  fuel_type: string;
};

export const PortableGenerator = (props, context) => {
  const { act, data } = useBackend<GeneratorData>(context);

  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section
          title="Generator Status"
          buttons={
            <Button
              content={data.active ? 'Stop' : 'Start'}
              color={data.active ? 'bad' : ''}
              icon={data.active ? 'times' : 'power-off'}
              onClick={() => act(data.active ? 'disable' : 'enable')}
              disabled={data.is_broken}
            />
          }>
          <LabeledList>
            <LabeledList.Item label="Status">
              <Box color={data.active ? 'good' : 'bad'}>
                {data.active ? 'Online' : 'Offline'}
              </Box>
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Fuel">
          <LabeledList>
            <LabeledList.Item label="Fuel Type">
              {capitalizeAll(data.fuel.fuel_type)}
            </LabeledList.Item>
            <LabeledList.Item label="Fuel Level">
              <ProgressBar
                ranges={{
                  good: [
                    data.fuel.fuel_capacity * 0.5,
                    data.fuel.fuel_capacity,
                  ],
                  average: [
                    data.fuel.fuel_capacity * 0.3,
                    data.fuel.fuel_capacity * 0.5,
                  ],
                  bad: [0, data.fuel.fuel_capacity * 0.3],
                }}
                value={data.fuel.fuel_stored}
                maxValue={data.fuel.fuel_capacity}
                minValue={0}>
                {data.fuel.fuel_stored} cm³ / {data.fuel.fuel_capacity} cm³
              </ProgressBar>
            </LabeledList.Item>
            {data.fuel.fuel_usage > 0 ? (
              <LabeledList.Item label="Fuel Usage">
                {data.fuel.fuel_usage} cm³/s - (
                {Math.round(data.fuel.fuel_stored / data.fuel.fuel_usage)} s
                remaining)
              </LabeledList.Item>
            ) : (
              ''
            )}
            <LabeledList.Item label="Control">
              <Button
                content="Eject Fuel"
                icon="trash"
                color="bad"
                disabled={data.is_ai || data.is_broken}
                onClick={() => act('eject')}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Output">
          <LabeledList>
            <LabeledList.Item label="Power Setting">
              <Box
                color={
                  data.output_set > data.output_safe
                    ? 'bad'
                    : data.output_set <= data.output_safe
                      ? 'good'
                      : ''
                }>
                {data.output_set} / {data.output_max} ({data.output_watts} W)
              </Box>
            </LabeledList.Item>
            <LabeledList.Item label="Control">
              <Knob
                size={1.25}
                color={data.output_set > data.output_safe && 'red'}
                value={data.output_set}
                minValue={data.output_min}
                maxValue={data.output_max}
                step={1}
                stepPixelSize={25}
                onDrag={(e, value) =>
                  act('set_power', {
                    set_power: value,
                  })
                }
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Temperature">
          <LabeledList>
            <LabeledList.Item label="Temperature">
              <ProgressBar
                ranges={{
                  good: [data.temperature_min * 0.8, data.temperature_max],
                  average: [data.temperature_max * 0.8, data.temperature_max],
                  bad: [data.temperature_max, data.temperature_max * 1.5],
                }}
                value={data.temperature_current}
                minValue={data.temperature_min}
                maxValue={data.temperature_max * 1.5}>
                {Math.max(data.temperature_min, data.temperature_current)}C
              </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Item label="Status">
              <Box
                color={
                  data.temperature_overheat > 50
                    ? 'bad'
                    : data.temperature_overheat > 20
                      ? 'average'
                      : data.temperature_overheat > 1
                        ? 'average'
                        : 'good'
                }
              />
              {data.temperature_overheat > 50
                ? 'DANGER: CRITICAL OVERHEAT! DEACTIVATE IMMEDIATELY!'
                : data.temperature_overheat > 20
                  ? 'WARNING: Overheating!'
                  : data.temperature_overheat > 1
                    ? 'Temperature High'
                    : 'Nominal'}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        {data.uses_coolant ? (
          <Section title="Coolant">
            <ProgressBar
              ranges={{
                good: [data.coolant_stored * 0.5, data.coolant_stored],
                average: [data.coolant_stored * 0.3, data.coolant_stored * 0.5],
                bad: [0, data.coolant_stored * 0.3],
              }}
              value={data.coolant_stored}
              minValue={0}
              maxValue={data.coolant_capacity}
            />
          </Section>
        ) : (
          ''
        )}
      </Window.Content>
    </Window>
  );
};

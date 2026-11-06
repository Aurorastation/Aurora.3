import {
  AnimatedNumber,
  Box,
  Button,
  Knob,
  LabeledList,
  Section,
} from 'tgui-core/components';
import { round } from 'tgui-core/math';
import type { BooleanLike } from 'tgui-core/react';
import { useBackend } from '../backend';
import { Window } from '../layouts';

export type ThermostatData = {
  broken: BooleanLike;
  thermostat: number;
  power_setting: 'low' | 'medium' | 'high';
  cooling_output: number;
  bodytemperature: number;
  temperature_safety: number;
  estimated_power_consumption: number;
  safety_burnt: BooleanLike;
  locked_thermostat: BooleanLike;
};

export const CoolingUnitThermostat = (props) => {
  const { act, data } = useBackend<ThermostatData>();

  return (
    <Window
      theme={data.broken ? 'spookyconsole' : 'hephaestus'}
      width={400}
      height={350}
    >
      <Window.Content scrollable>
        {data.broken ? <Broken /> : <ThermostatWindow />}
      </Window.Content>
    </Window>
  );
};

export const ThermostatWindow = (props) => {
  const { act, data } = useBackend<ThermostatData>();

  // K = C + 273.15 | C = K – 273.15
  return (
    <Section title="Cooling Power Regulation">
      <Box>
        <Box textAlign="center">
          My internals are currently at{' '}
          <AnimatedNumber value={round(data.bodytemperature, 1)} />
          °C.
        </Box>
        <Box mt={1}>
          <LabeledList>
            <LabeledList.Item label="Cooling cutoff">
              <AnimatedNumber value={round(data.thermostat, 1)} />°C
            </LabeledList.Item>
            <LabeledList.Item label="Rated cooling output">
              <AnimatedNumber value={round(data.cooling_output, 1)} /> K/s
            </LabeledList.Item>
            <LabeledList.Item label="Maximum power draw">
              <AnimatedNumber
                value={round(data.estimated_power_consumption, 1)}
              />
              kW
            </LabeledList.Item>
          </LabeledList>
        </Box>
        <Box mt={2} textAlign="center">
          <Knob
            size={2}
            value={
              data.power_setting === 'low'
                ? 1
                : data.power_setting === 'medium'
                  ? 2
                  : 3
            }
            minValue={1}
            maxValue={3}
            step={1}
            stepPixelSize={50}
            onChange={(_, value) =>
              act('change_power_setting', {
                power_setting:
                  value <= 1 ? 'low' : value >= 3 ? 'high' : 'medium',
              })
            }
          />
          <Box bold>
            {data.power_setting === 'low'
              ? 'Low Power'
              : data.power_setting === 'medium'
                ? 'Medium Power'
                : 'High Power'}
          </Box>
          <Box color="label">
            Low
            {'  •  '}
            Medium
            {'  •  '}
            High
          </Box>
        </Box>
      </Box>
      &nbsp;
      {data.safety_burnt ? (
        <Box textAlign="center" bold textColor="bad">
          TEMPERATURE SAFETY UNAVAILABLE
        </Box>
      ) : (
        <LabeledList>
          <LabeledList.Item label="Safety">
            <Button.Checkbox
              content={data.temperature_safety ? 'engaged' : 'DISENGAGED'}
              disabled={data.safety_burnt}
              color={data.temperature_safety ? 'good' : 'bad'}
              icon={data.temperature_safety ? 'lock' : 'unlock'}
              checked={data.temperature_safety}
              onClick={() => act('temperature_safety')}
            />
          </LabeledList.Item>
        </LabeledList>
      )}
    </Section>
  );
};

export const Broken = (props) => {
  const { act, data } = useBackend<ThermostatData>();

  return (
    <Section title="CRITICAL ERROR 0x0127F29">
      <Box as="span" textColor="red" fontSize={3}>
        ERROR ER0RR $R0RRO$!R41.%%!!(%$^^__+ @#F0E4/ERROR ER0RR
        $R0RRO$!R41.%%!!(%$^^__+ @#F0E4/ERROR ER0RR $R0RRO$!R41.%%!!(%$^^__+
        @#F0E4/ERROR ER0RR $R0RRO$!R41.%%!!(%$^^__+ @#F0E4/
      </Box>
    </Section>
  );
};

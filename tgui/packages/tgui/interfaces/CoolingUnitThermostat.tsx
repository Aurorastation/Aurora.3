import { BooleanLike } from 'common/react';
import { useBackend } from '../backend';
import { AnimatedNumber, Box, Knob, Section } from '../components';
import { Window } from '../layouts';

export type ThermostatData = {
  broken: BooleanLike;
  thermostat: number;
  thermostat_min: number;
  thermostat_max: number;
  passive_temp_change: number;
  bodytemperature: number;
};

export const CoolingUnitThermostat = (props, context) => {
  const { act, data } = useBackend<ThermostatData>(context);

  return (
    <Window
      resizable
      theme={data.broken ? 'spookyconsole' : 'hephaestus'}
      width={300}
      height={200}>
      <Window.Content scrollable>
        {data.broken ? <Broken /> : <ThermostatWindow />}
      </Window.Content>
    </Window>
  );
};

export const ThermostatWindow = (props, context) => {
  const { act, data } = useBackend<ThermostatData>(context);

  // K = C + 273.15 | C = K – 273.15
  return (
    <Section title="Thermostat Regulation">
      <Box>
        <Knob
          size={2}
          value={data.thermostat}
          minValue={data.thermostat_min}
          maxValue={data.thermostat_max}
          step={5}
          stepPixelSize={25}
          unit={'°C'}
          onDrag={(e, value) =>
            act('change_thermostat', {
              change_thermostat: value,
            })
          }
        />
      </Box>
      &nbsp;
      <Box textAlign="centre" bold>
        My internals are currently at{' '}
        <AnimatedNumber value={data.bodytemperature} />
        °C.
      </Box>
    </Section>
  );
};

export const Broken = (props, context) => {
  const { act, data } = useBackend<ThermostatData>(context);

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

import { BooleanLike } from 'common/react';
import { useBackend } from '../backend';
import { Button, Box, Slider, Section } from '../components';
import { Window } from '../layouts';

export type CapacitorData = {
  active: BooleanLike;
  time_since_fail: number;
  stored_charge: number;
  max_charge: number;
  charge_rate: number;
  max_charge_rate: number;
};

export const ShieldCapacitor = (props, context) => {
  const { act, data } = useBackend<CapacitorData>(context);

  return (
    <Window resizable theme="hephaestus">
      <Window.Content scrollable>
        <Section
          title="Shield Capacitor Control Console"
          buttons={
            <Button
              color={data.active ? 'good' : 'bad'}
              content={data.active ? 'Online' : 'Offline'}
              icon={data.active ? 'power-off' : 'times'}
              onClick={() => act('toggle')}
            />
          }>
          <Box color={data.time_since_fail > 2 ? 'good' : 'bad'}>
            Capacitor Status: {data.time_since_fail > 2 ? 'OK' : 'Discharging!'}
          </Box>
          <Box>
            Stored Energy: {data.stored_charge} kJ {'('}
            {100 * (data.stored_charge / data.max_charge)}%{')'}
          </Box>
          <Slider
            animated
            step={1000}
            stepPixelSize={1}
            value={data.charge_rate}
            minValue={0}
            maxValue={data.max_charge_rate}
            onChange={(e, value) =>
              act('setChargeRate', { charge_rate: value })
            }>
            {data.charge_rate} W
          </Slider>
        </Section>
      </Window.Content>
    </Window>
  );
};

import { BooleanLike } from 'common/react';
import { useBackend } from '../backend';
import { Section, Box, ProgressBar, Button, Knob } from '../components';
import { Window } from '../layouts';

export type PumpData = {
  portConnected: BooleanLike;
  tankPressure: number;
  targetpressure: number;
  pump_dir: BooleanLike;
  minpressure: number;
  maxpressure: number;
  powerDraw: number;
  cellCharge: number;
  cellMaxCharge: number;
  on: BooleanLike;
  hasHoldingTank: BooleanLike;
  holdingTank: Tank;
};

type Tank = {
  name: string;
  tankPressure: number;
};

export const PortablePump = (props, context) => {
  const { act, data } = useBackend<PumpData>(context);
  // Extract `health` and `color` variables from the `data` object.

  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section
          title="Pump Status"
          buttons={
            <>
              <Button
                content={data.on ? 'On' : 'Off'}
                icon={data.on ? 'power-off' : 'times'}
                color={!data.on && 'danger'}
                onClick={() => act('power')}
              />
              <Button
                content={data.pump_dir ? 'Out' : 'In'}
                icon={data.pump_dir ? 'arrow-up' : 'arrow-down'}
                onClick={() => act('direction')}
              />
            </>
          }>
          <Box>
            <b>Tank Pressure: </b>
            {data.tankPressure} kPa
          </Box>
          <Box>
            <b>Port Status: </b>
            {data.portConnected ? 'Connected ' : 'Disconnected'}
          </Box>
          <Box>
            <b>Power Draw: </b>
            {data.powerDraw} W
          </Box>
          <Box>
            <b>Cell Charge: </b>
          </Box>
          <ProgressBar
            ranges={{
              good: [data.cellMaxCharge * 0.8, data.cellMaxCharge],
              average: [data.cellMaxCharge * 0.4, data.cellMaxCharge * 0.8],
              bad: [0, data.cellMaxCharge * 0.4],
            }}
            value={data.cellCharge}
            minValue={0}
            maxValue={data.cellMaxCharge}
          />
        </Section>
        <Section
          title="Holding Tank Status"
          buttons={
            !!data.hasHoldingTank && (
              <Button
                icon="eject"
                content="Eject"
                onClick={() => act('remove_tank')}
              />
            )
          }>
          {data.hasHoldingTank ? (
            <HoldingTankWindow />
          ) : (
            <Box>No holding tank inserted.</Box>
          )}
        </Section>
        <Section title="Power Regulator Status">
          <Box>Target Pressure:</Box>
          <ProgressBar
            ranges={{
              good: [data.maxpressure * 0.8, data.maxpressure],
              average: [data.maxpressure * 0.4, data.maxpressure * 0.8],
              bad: [0, data.maxpressure * 0.4],
            }}
            value={data.targetpressure}
            minValue={data.minpressure}
            maxValue={data.maxpressure}
          />
          <Knob
            size={1.25}
            value={data.targetpressure}
            unit="kPa"
            minValue={data.minpressure}
            maxValue={data.maxpressure}
            onDrag={(e, value) =>
              act('pressure_set', {
                pressure_set: value,
              })
            }
          />
        </Section>
      </Window.Content>
    </Window>
  );
};

export const HoldingTankWindow = (props, context) => {
  const { act, data } = useBackend<PumpData>(context);
  return (
    <Section>
      <Box>
        <b>Tank Label:</b>
      </Box>
      {data.holdingTank.name}
      <Box>
        <b>Tank Pressure:</b>
      </Box>
      {data.holdingTank.tankPressure} kPa
    </Section>
  );
};

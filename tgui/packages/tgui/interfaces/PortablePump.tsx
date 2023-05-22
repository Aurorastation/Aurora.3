import { BooleanLike } from 'common/react';
import { useBackend } from '../backend';
import { Section, Box, ProgressBar, Button, Knob } from '../components';
import { Window } from '../layouts';

export type PumpData = {
  portConnected: BooleanLike;
  tankPressure: number;
  targetPressure: number;
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
        <Section title="Pump Status">
          <Box bold>Tank Pressure: </Box>
          {data.tankPressure}
          <Box bold>Port Status: </Box>{' '}
          {data.portConnected ? 'Connected ' : 'Disconnected'}
          <Box bold>Power Draw: </Box> {data.powerDraw} W
          <Box bold>Cell Charge: </Box>
          <ProgressBar
            ranges={{
              good: [data.cellMaxCharge * 0.8, data.cellMaxCharge],
              average: [data.cellMaxCharge * 0.4, data.cellMaxCharge * 0.8],
              bad: [0, data.cellMaxCharge * 0.4],
            }}
            value={data.cellCharge}
            minValue={0}
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
            value={data.targetPressure}
            minValue={data.minpressure}
          />
          <Knob
            size={1.25}
            value={data.targetPressure}
            unit="kPa"
            minValue={data.minpressure}
            maxValue={data.maxpressure}
            step={5}
            stepPixelSize={1}
            onDrag={(e, value) =>
              act('pressure_set', {
                pressure: value,
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

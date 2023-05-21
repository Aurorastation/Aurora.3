import { BooleanLike } from 'common/react';
import { useBackend } from '../backend';
import { Button, LabeledList, Section, Box, BlockQuote } from '../components';
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
          <Box as bold>
            Tank Pressure:
          </Box>
          <BlockQuote>
            {data.tankPressure}
          </BlockQuote>
        </Section>
      </Window.Content>
    </Window>
  );
};

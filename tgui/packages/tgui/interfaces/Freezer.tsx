import { BooleanLike } from 'common/react';
import { useBackend } from '../backend';
import { Section, Button, Knob, Box, ProgressBar } from '../components';
import { Window } from '../layouts';

export type FreezerData = {
  on: BooleanLike;
  gasPressure: number;
  gasTemperature: number;
  minGasTemperature: number;
  maxGasTemperature: number;
  targetGasTemperature: number;
  powerSetting: number;
  gasTemperatureBadTop: number;
  gasTemperatureBadBottom: number;
  gasTemperatureAvgTop: number;
  gasTemperatureAvgBottom: number;
};

export const Freezer = (props, context) => {
  const { act, data } = useBackend<FreezerData>(context);

  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section
          title="Power Level"
          buttons={
            <Button
              content={data.on ? 'On' : 'Off'}
              icon={data.on ? 'power-off' : 'times'}
              color={!data.on && 'danger'}
              onClick={() => act('power')}
            />
          }>
          <Box textAlign="center">
            <b>Gas Pressure: </b> {data.gasPressure} kPa
          </Box>
          <Knob
            size={1.25}
            value={data.powerSetting}
            minValue={0}
            maxValue={100}
            onDrag={(e, value) =>
              act('setPower', {
                setPower: value,
              })
            }
          />
        </Section>
        <Section title="Gas Temperature">
          <Box>
            <b>Current:</b>
          </Box>
          <ProgressBar
            ranges={{
              good: [data.maxGasTemperature * 0.8, data.maxGasTemperature],
              average: [
                data.maxGasTemperature * 0.4,
                data.maxGasTemperature * 0.8,
              ],
              bad: [0, data.maxGasTemperature * 0.4],
            }}
            value={data.gasTemperature}
            minValue={data.minGasTemperature}
            maxValue={data.maxGasTemperature}>
            <Box>{data.gasTemperature} K</Box>
          </ProgressBar>
          <Box>
            <b>Target:</b>
          </Box>
          <ProgressBar
            ranges={{
              good: [data.maxGasTemperature * 0.8, data.maxGasTemperature],
              average: [
                data.maxGasTemperature * 0.4,
                data.maxGasTemperature * 0.8,
              ],
              bad: [0, data.maxGasTemperature * 0.4],
            }}
            value={data.targetGasTemperature}
            minValue={data.minGasTemperature}
            maxValue={data.maxGasTemperature}>
            <Box>{data.targetGasTemperature} K</Box>
          </ProgressBar>
          <Knob
            size={1.25}
            value={data.targetGasTemperature}
            minValue={0}
            maxValue={1000}
            unit="K"
            onDrag={(e, value) =>
              act('temp', {
                temp: value,
              })
            }
          />
        </Section>
      </Window.Content>
    </Window>
  );
};

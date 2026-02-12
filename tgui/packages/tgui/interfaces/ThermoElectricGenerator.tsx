import {
  Box,
  LabeledList,
  NoticeBox,
  ProgressBar,
  Section,
  Stack,
} from '../components';
import { useBackend } from '../backend';
import { round } from 'common/math';
import { Window } from '../layouts';
import { BooleanLike } from '../../common/react';

type Data = {
  totalOutput: number;
  maxTotalOutput: number;
  thermalOutput: number;
  circConnected: BooleanLike;

  primaryDir?: string;
  primaryOutput?: number;
  primaryFlowCapacity?: number;
  primaryInletPressure?: number;
  primaryInletTemperature?: number;
  primaryOutletPressure?: number;
  primaryOutletTemperature?: number;

  secondaryDir?: string;
  secondaryOutput?: number;
  secondaryFlowCapacity?: number;
  secondaryInletPressure?: number;
  secondaryInletTemperature?: number;
  secondaryOutletPressure?: number;
  secondaryOutletTemperature?: number;
};

// Round numbers to one decimal place
const f1 = (n?: number) => round(n ?? 0, 0.1);

export const ThermoElectricGenerator = (_props, context) => {
  const { data } = useBackend<Data>(context);
  const {
    totalOutput,
    maxTotalOutput,
    thermalOutput,
    circConnected,

    primaryDir,
    primaryOutput,
    primaryFlowCapacity,
    primaryInletPressure,
    primaryInletTemperature,
    primaryOutletPressure,
    primaryOutletTemperature,

    secondaryDir,
    secondaryOutput,
    secondaryFlowCapacity,
    secondaryInletPressure,
    secondaryInletTemperature,
    secondaryOutletPressure,
    secondaryOutletTemperature,
  } = data;

  const bothConnected = !!circConnected;
  const maxValue = Math.max(maxTotalOutput || 0, 0.001);

  return (
    <Window width={550} height={300}>
      <Window.Content scrollable>
        <Section>
          <LabeledList>
            <LabeledList.Item label="Total Output">
              <ProgressBar
                value={totalOutput || 0}
                minValue={0}
                maxValue={maxValue}
              />
              <Box mt={0.5}>{f1(totalOutput)} kW</Box>
            </LabeledList.Item>
            <LabeledList.Item label="Thermal Output">
              {f1(thermalOutput)} kWth
            </LabeledList.Item>
          </LabeledList>
        </Section>

        {bothConnected ? (
          <Stack>
            <Stack.Item grow basis={0}>
              <CirculatorBlock
                title="Primary Circulator"
                dir={primaryDir}
                output={primaryOutput}
                flowCapacity={primaryFlowCapacity}
                inletPressure={primaryInletPressure}
                inletTemperature={primaryInletTemperature}
                outletPressure={primaryOutletPressure}
                outletTemperature={primaryOutletTemperature}
              />
            </Stack.Item>
            <Stack.Item grow basis={0}>
              <CirculatorBlock
                title="Secondary Circulator"
                dir={secondaryDir}
                output={secondaryOutput}
                flowCapacity={secondaryFlowCapacity}
                inletPressure={secondaryInletPressure}
                inletTemperature={secondaryInletTemperature}
                outletPressure={secondaryOutletPressure}
                outletTemperature={secondaryOutletTemperature}
              />
            </Stack.Item>
          </Stack>
        ) : (
          <NoticeBox danger>
            ERROR: Both circulators must be connected!
          </NoticeBox>
        )}
      </Window.Content>
    </Window>
  );
};

const CirculatorBlock = (props: {
  title: string;
  dir?: string;
  output?: number;
  flowCapacity?: number;
  inletPressure?: number;
  inletTemperature?: number;
  outletPressure?: number;
  outletTemperature?: number;
}) => {
  const {
    title,
    dir,
    output,
    flowCapacity,
    inletPressure,
    inletTemperature,
    outletPressure,
    outletTemperature,
  } = props;

  return (
    <Section title={`${title} (${dir ?? '-'})`} fill>
      <LabeledList>
        <LabeledList.Item label="Turbine Output">
          {f1(output)} kWth
        </LabeledList.Item>
        <LabeledList.Item label="Flow Capacity">
          {f1(flowCapacity)} %
        </LabeledList.Item>
      </LabeledList>

      <Box mt={1} />

      <LabeledList>
        <LabeledList.Item label="Inlet Pressure">
          {f1(inletPressure)} kPa
        </LabeledList.Item>
        <LabeledList.Item label="Inlet Temperature">
          {f1(inletTemperature)} K
        </LabeledList.Item>
      </LabeledList>

      <Box mt={1} />

      <LabeledList>
        <LabeledList.Item label="Outlet Pressure">
          {f1(outletPressure)} kPa
        </LabeledList.Item>
        <LabeledList.Item label="Outlet Temperature">
          {f1(outletTemperature)} K
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

export default ThermoElectricGenerator;

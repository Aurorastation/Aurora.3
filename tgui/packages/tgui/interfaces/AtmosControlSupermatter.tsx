import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Section, LabeledList, Button, NumberInput } from '../components';
import { Window } from '../layouts';
import { AtmosControl } from './AtmosControl';

export type TankData = {
  maxrate: number;
  maxpressure: number;
  input: Input;
  output: Output;
};

type Input = {
  power: BooleanLike;
  rate: number;
  setrate: number;
};

type Output = {
  power: BooleanLike;
  pressure: number;
  setpressure: number;
};

export const AtmosControlSupermatter = (props, context) => {
  const { act, data } = useBackend<TankData>(context);
  return (
    <Window resizable theme="hephaestus">
      <Window.Content scrollable>
        <Section>
          <AtmosControl />
        </Section>
        <Section title="Core Cooling Control System">
          {data.input ? (
            <InputWindow />
          ) : (
            <Button
              content="Search Input Port"
              onClick={() => act('in_refresh_status')}
            />
          )}
          {data.output ? (
            <OutputWindow />
          ) : (
            <Button
              content="Search Output Port"
              onClick={() => act('out_refresh_status')}
            />
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};

export const InputWindow = (props, context) => {
  const { act, data } = useBackend<TankData>(context);
  return (
    <LabeledList>
      <LabeledList.Item label="Input">
        <Button
          content={data.input.power ? 'Injecting' : 'On Hold'}
          selected={data.input.power}
          icon="power-off"
          onClick={() => act('in_toggle_injector')}
        />
      </LabeledList.Item>
      <LabeledList.Item label="Flowrate Limit">
        <NumberInput
          value={data.input.rate}
          minValue={0}
          maxValue={data.maxrate}
          unit="L/s"
          step={10}
          onDrag={(e, value) =>
            act('in_set_flowrate', { in_set_flowrate: value })
          }
        />
      </LabeledList.Item>
    </LabeledList>
  );
};

export const OutputWindow = (props, context) => {
  const { act, data } = useBackend<TankData>(context);
  return (
    <Section>
      <LabeledList>
        <LabeledList.Item label="Core Outpump">
          <Button
            content={data.output.power ? 'Open' : 'Closed'}
            selected={data.output.power}
            icon="power-off"
            onClick={() => act('out_toggle_power')}
          />
        </LabeledList.Item>
        <LabeledList.Item label="Min Core Pressure">
          <NumberInput
            value={data.output.pressure}
            minValue={0}
            maxValue={data.maxpressure}
            unit="kPa"
            step={100}
            onDrag={(e, value) =>
              act('out_set_pressure', { out_set_pressure: value })
            }
          />
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

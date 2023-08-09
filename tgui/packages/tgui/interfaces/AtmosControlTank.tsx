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

export const AtmosControlTank = (props, context) => {
  const { act, data } = useBackend<TankData>(context);
  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section>
          <AtmosControl />
        </Section>
        <Section title="Tank Control System">
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
          color={data.input.power ? 'good' : ''}
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
        <LabeledList.Item label="Output">
          <Button
            content={data.output.power ? 'Open' : 'Closed'}
            color={data.output.power ? 'good' : ''}
            icon="power-off"
            onClick={() => act('out_toggle_power')}
          />
        </LabeledList.Item>
        <LabeledList.Item label="Pressure Limit">
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

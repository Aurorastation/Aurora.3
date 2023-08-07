import { BooleanLike } from 'common/react';
import { useBackend } from '../backend';
import { Button, LabeledList, NumberInput, Section } from '../components';
import { Window } from '../layouts';

type Data = {
  on: BooleanLike;
  max_rate: number;
  rate: number;
  pressure: number;
  max_pressure: number;
  flow_rate: number;
  regulate_mode: number;
};

export const AtmosPressureRegulator = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const {
    on,
    max_rate,
    max_pressure,
    rate,
    pressure,
    flow_rate,
    regulate_mode,
  } = data;

  return (
    <Window width={350} height={175}>
      <Window.Content>
        <Section>
          <LabeledList>
            <LabeledList.Item label="Valve">
              <Button
                icon={on ? 'power-off' : 'times'}
                content={on ? 'Open' : 'Closed'}
                selected={on}
                onClick={() => act('toggle_valve')}
              />
            </LabeledList.Item>

            <LabeledList.Item label="Pressure Regulation">
              <Button
                icon={'ban'}
                content="Off"
                selected={regulate_mode === 0}
                onClick={() => act('regulate_off')}
              />
              <Button
                icon={'arrow-right-to-bracket'}
                content="Input"
                selected={regulate_mode === 1}
                onClick={() => act('regulate_input')}
              />
              <Button
                icon={'arrow-right-from-bracket'}
                content="Output"
                selected={regulate_mode === 2}
                onClick={() => act('regulate_output')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Target Pressure">
              <NumberInput
                animated
                value={pressure}
                unit="kPa"
                width="75px"
                minValue={0}
                maxValue={max_pressure}
                step={10}
                onChange={(_, value) =>
                  act('pressure', {
                    pressure: value,
                  })
                }
              />
              <Button
                ml={1}
                icon="maximize"
                content="Max"
                disabled={pressure === max_pressure}
                onClick={() =>
                  act('pressure', {
                    pressure: 'max',
                  })
                }
              />
            </LabeledList.Item>
            <LabeledList.Item label="Transfer Rate Limit">
              <NumberInput
                animated
                value={rate}
                width="63px"
                unit="L/s"
                minValue={0}
                maxValue={max_rate}
                onChange={(_, value) =>
                  act('rate', {
                    rate: value,
                  })
                }
              />
              <Button
                ml={1}
                icon="maximize"
                content="Max"
                disabled={rate === max_rate}
                onClick={() =>
                  act('rate', {
                    rate: 'max',
                  })
                }
              />
            </LabeledList.Item>
            <LabeledList.Item label="Flow">{flow_rate} L/s</LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};

import { BooleanLike } from 'common/react';
import { useBackend } from '../backend';
import { Button, LabeledList, ProgressBar, NumberInput, Section } from '../components';
import { Window } from '../layouts';

type Data = {
  on: BooleanLike;
  max_rate: number;
  rate: number;
  pressure: number;
  max_pressure: number;
  power_draw: number;
  max_power_draw: number;
  flow_rate: number;
};

export const AtmosPump = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const {
    on,
    max_rate,
    max_pressure,
    max_power_draw,
    rate,
    pressure,
    power_draw,
    flow_rate,
  } = data;

  return (
    <Window width={320} height={150}>
      <Window.Content>
        <Section>
          <LabeledList>
            <LabeledList.Item label="Power">
              <Button
                icon={on ? 'power-off' : 'times'}
                content={on ? 'On' : 'Off'}
                selected={on}
                onClick={() => act('power')}
              />
            </LabeledList.Item>
            {max_rate ? (
              <LabeledList.Item label="Transfer Rate">
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
                  icon="plus"
                  content="Max"
                  disabled={rate === max_rate}
                  onClick={() =>
                    act('rate', {
                      rate: 'max',
                    })
                  }
                />
              </LabeledList.Item>
            ) : (
              <LabeledList.Item label="Output Pressure">
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
                  icon="plus"
                  content="Max"
                  disabled={pressure === max_pressure}
                  onClick={() =>
                    act('pressure', {
                      pressure: 'max',
                    })
                  }
                />
              </LabeledList.Item>
            )}
            {max_power_draw ? (
              <LabeledList.Item label="Load">
                <ProgressBar
                  animated
                  color={(() => {
                    if (power_draw > (max_power_draw / 3) * 2) {
                      return 'red';
                    } else if (power_draw > max_power_draw / 3) {
                      return 'yellow';
                    } else {
                      return 'green';
                    }
                  })()}
                  minValue={0}
                  maxValue={max_power_draw}
                  value={power_draw}>
                  {power_draw} W
                </ProgressBar>
              </LabeledList.Item>
            ) : (
              ''
            )}
            <LabeledList.Item label="Flow">{flow_rate} L/s</LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};

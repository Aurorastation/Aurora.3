import { toFixed } from '../../common/math';
import { useBackend } from '../backend';
import { Button, NumberInput, Section, LabeledList } from '../components';
import { Window } from '../layouts';

export type SignalerData = {
  frequency: number;
  code: number;
};

export const Signaler = (props, context) => {
  const { act, data } = useBackend<SignalerData>(context);

  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section
          title="Frequency"
          buttons={
            <Button
              content="Send Signal"
              icon="wifi"
              onClick={() => act('send')}
            />
          }>
          <LabeledList>
            <LabeledList.Item label="Frequency">
              <NumberInput
                minValue={12}
                maxValue={16}
                unit="kHz"
                value={data.frequency / 10}
                step={0.2}
                stepPixelSize={6}
                format={(value) => toFixed(value, 2)}
                width="80px"
                onChange={(e, value) => act('freq', { freq: value * 10 })}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Code">
              <NumberInput
                animate
                step={1}
                stepPixelSize={6}
                minValue={1}
                maxValue={100}
                value={data.code}
                width="80px"
                onDrag={(e, value) =>
                  act('code', {
                    code: value,
                  })
                }
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};

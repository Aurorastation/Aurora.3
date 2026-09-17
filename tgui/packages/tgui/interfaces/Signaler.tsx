import {
  Button,
  LabeledList,
  NumberInput,
  Section,
} from 'tgui-core/components';
import { toFixed } from 'tgui-core/math';
import { useBackend } from '../backend';
import { Window } from '../layouts';

export type SignalerData = {
  frequency: number;
  code: number;
};

export const Signaler = (props) => {
  const { act, data } = useBackend<SignalerData>();

  return (
    <Window>
      <Window.Content scrollable>
        <Section
          title="Frequency"
          buttons={
            <Button
              content="Send Signal"
              icon="wifi"
              onClick={() => act('send')}
            />
          }
        >
          <LabeledList>
            <LabeledList.Item label="Frequency">
              <NumberInput
                minValue={120}
                maxValue={160}
                unit="kHz"
                value={data.frequency}
                step={0.1}
                stepPixelSize={6}
                format={(value) => toFixed(value, 1)}
                width="80px"
                onChange={(value) => act('freq', { freq: value })}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Code">
              <NumberInput
                step={1}
                stepPixelSize={6}
                minValue={1}
                maxValue={100}
                value={data.code}
                width="80px"
                onChange={(value) =>
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

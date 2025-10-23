import {
  Button,
  LabeledList,
  NumberInput,
  Section,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { useBackend } from '../backend';
import { Window } from '../layouts';

export type ProximityData = {
  timeractive: BooleanLike;
  scanning: BooleanLike;
  range: number;
  time: number;
};

export const Proximity = (props) => {
  const { act, data } = useBackend<ProximityData>();

  return (
    <Window>
      <Window.Content scrollable>
        <Section
          title="Timing Unit"
          buttons={
            <Button
              content={data.timeractive ? 'Armed' : 'Not Armed'}
              color={data.timeractive ? 'danger' : ''}
              icon="clock"
              onClick={() => act('time')}
            />
          }
        >
          <LabeledList>
            <LabeledList.Item label="Time Left">
              <NumberInput
                minValue={10}
                maxValue={600}
                step={5}
                unit="s"
                value={data.time}
                onChange={(value) => act('tp', { tp: Math.round(value) })}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Settings">
          <LabeledList>
            <LabeledList.Item label="Scanning">
              <Button
                content={data.scanning ? 'Armed' : 'Not Armed'}
                color={data.scanning ? 'good' : ''}
                icon="wifi"
                onClick={() => act('scanning')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Range">
              <NumberInput
                minValue={1}
                maxValue={5}
                step={1}
                value={data.range}
                onDrag={(e, value) => act('range', { range: value })}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};

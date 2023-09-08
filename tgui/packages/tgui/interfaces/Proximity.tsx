import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Button, NumberInput, Section, LabeledList } from '../components';
import { Window } from '../layouts';

export type ProximityData = {
  timeractive: BooleanLike;
  scanning: BooleanLike;
  range: number;
  time: number;
};

export const Proximity = (props, context) => {
  const { act, data } = useBackend<ProximityData>(context);

  return (
    <Window resizable>
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
          }>
          <LabeledList>
            <LabeledList.Item label="Time Left">
              <NumberInput
                minValue={10}
                maxValue={600}
                unit="s"
                value={data.time}
                format={(value) => Math.round(value)}
                onChange={(e, value) => act('tp', { tp: value })}
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

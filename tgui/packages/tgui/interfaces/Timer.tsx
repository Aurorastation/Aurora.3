import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Button, NumberInput, Section, LabeledList } from '../components';
import { Window } from '../layouts';

export type TimerData = {
  timeractive: BooleanLike;
  time: number;
};

export const Timer = (props, context) => {
  const { act, data } = useBackend<TimerData>(context);

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
                onDrag={(e, value) => act('tp', { tp: value })}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};

import {
  Button,
  LabeledList,
  NumberInput,
  Section,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { useBackend } from '../backend';
import { Window } from '../layouts';

export type TimerData = {
  timeractive: BooleanLike;
  time: number;
};

export const Timer = (props) => {
  const { act, data } = useBackend<TimerData>();

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

import {
  Box,
  Button,
  LabeledList,
  NumberInput,
  Section,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { useBackend } from '../backend';
import { Window } from '../layouts';

export type FireAlarmData = {
  alertLevel: string;
  time: number;
  active: BooleanLike;
  timing: BooleanLike;
};

export const FireAlarm = (props) => {
  const { act, data } = useBackend<FireAlarmData>();
  return (
    <Window theme="hephaestus" title="Fire Alarm">
      <Window.Content scrollable>
        <Section title="Alert Level">
          {data.alertLevel.toLocaleUpperCase()}
        </Section>
        <Section title="Fire Alarm Control">
          <Button onClick={() => act('activate_alarm')} disabled={data.active}>
            Activate
          </Button>
          <Button onClick={() => act('reset_alarm')} disabled={!data.active}>
            Reset
          </Button>
        </Section>
        <Section title="Timed Lockdown">
          <Box>
            Current Timer:{' '}
            {data.time > 1
              ? `${(data.time / 10).toFixed(0).toString()} seconds`
              : 'Not Set'}
          </Box>
          <LabeledList>
            <LabeledList.Item label="Set Activation Timer">
              <NumberInput
                animated
                value={
                  data.time > 1
                    ? `${(data.time / 10).toFixed(0).toString()} seconds`
                    : 'Not Set'
                }
                width="75px"
                minValue={0}
                maxValue={600}
                step={2}
                onChange={(value) => act('set_timer', { set_timer: value })}
              />
            </LabeledList.Item>
          </LabeledList>
          <br />
          <Button
            onClick={() => act('start_timer')}
            disabled={data.timing || !data.time}
          >
            Start Timer
          </Button>
          <Button onClick={() => act('stop_timer')} disabled={!data.timing}>
            Stop Timer
          </Button>
        </Section>
      </Window.Content>
    </Window>
  );
};

import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Section, Button, Box } from '../components';
import { Window } from '../layouts';

export type FireAlarmData = {
  alertLevel: String;
  time: number;
  active: BooleanLike;
  timing: BooleanLike;
};

export const FireAlarm = (props, context) => {
  const { act, data } = useBackend<FireAlarmData>(context);
  return (
    <Window resizable theme="hephaestus" title="Fire Alarm">
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
          <Box title="Current Timer">
            {data.time > 1
              ? (data.time / 10).toFixed(0).toString() + ' seconds'
              : 'Not Set'}
          </Box>
          <Button.Input
            content="Set Activation Timer"
            onCommit={(e, value) => {
              act('set_timer', {
                set_timer: value,
              });
            }}
          />
          <br />
          <Button
            onClick={() => act('start_timer')}
            disabled={data.timing || !data.time}>
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

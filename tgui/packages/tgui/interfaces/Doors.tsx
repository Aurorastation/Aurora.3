import { BooleanLike } from 'common/react';
import { time } from 'console';
import { useBackend } from '../backend';
import { Section, ProgressBar } from '../components';
import { Window } from '../layouts';

export type DoorsData = {
  doorName: string;
  doorArea: string;
  open: BooleanLike;
  main_power_lost_until: number;
  main_power_lost_at: number;
  backup_power_lost_until: number;
  backup_power_lost_at: number;
  electrified_until: number;
  electrified_at: number;
  aiCanBolt: BooleanLike;
  idScan: BooleanLike;
  bolts: BooleanLike;
  lights: BooleanLike;
  safeties: BooleanLike;
  timing: BooleanLike;
  isAi: BooleanLike;
  boltsOverride: BooleanLike;
  isAdmin: BooleanLike;
};

export const Doors = (props, context) => {
  const { act, data } = useBackend<DoorsData>(context);
  const door_title = data.doorArea + data.doorName;
  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section title={door_title}>
          <ProgressBar
            ranges={{
              good: [data.main_power_lost_at === 0],
              average: [data.main_power_lost_at > 0],
              bad: [data.main_power_lost_at === -1],
            }}
            value={time}
            minValue={data.main_power_lost_at}
            maxValue={data.main_power_lost_until || 10}
          >
            {get_power_status_message(data.main_power_lost_until, time)}
          </ProgressBar>
        </Section>
      </Window.Content>
    </Window>
  );
};

const get_power_status_message = (state, time) => {
  if (state === -1) {
    return 'Offline';
  } else if (state === 0) {
    return 'Online';
  } else {
    let timeleft = Math.max(Math.round((state - time) / 10), 0);
    return 'Interrupted, ' + { timeleft } + 's remaining';
  }
};

import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Section, ProgressBar, Button, Box } from '../components';
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
  idscan: BooleanLike;
  bolts: BooleanLike;
  lights: BooleanLike;
  safeties: BooleanLike;
  timing: BooleanLike;
  isAi: BooleanLike;
  boltsOverride: BooleanLike;
  isAdmin: BooleanLike;
  wtime: number;
};

export const Doors = (props, context) => {
  const { act, data } = useBackend<DoorsData>(context);
  const door_title = data.doorArea + ' - ' + data.doorName;
  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section
          title={door_title}
          buttons={
            <Button
              content="Interrupt"
              disabled={data.main_power_lost_until !== 0}
              onClick={() => act('main_power')}
            />
          }>
          <ProgressBar
            ranges={{
              good: [0, 1],
              average: [1.1, Infinity],
              bad: [-2, 0],
            }}
            value={
              data.main_power_lost_until > 0
                ? data.wtime
                : data.main_power_lost_until
            }
            minValue={data.main_power_lost_until ? data.main_power_lost_at : 1}
            maxValue={data.main_power_lost_until}>
            {get_power_status_message(data.main_power_lost_until, data.wtime)}
          </ProgressBar>
        </Section>
        <Section
          title="Backup Power"
          buttons={
            <Button
              content="Interrupt"
              disabled={data.backup_power_lost_until !== 0}
              onClick={() => act('backup_power')}
            />
          }>
          <ProgressBar
            ranges={{
              good: [0, 1],
              average: [1.1, Infinity],
              bad: [-2, 0],
            }}
            value={
              data.backup_power_lost_until > 0
                ? data.wtime
                : data.backup_power_lost_until
            }
            minValue={
              data.backup_power_lost_until ? data.backup_power_lost_at : 1
            }
            maxValue={data.backup_power_lost_until}>
            {get_power_status_message(data.backup_power_lost_until, data.wtime)}
          </ProgressBar>
        </Section>
        <Section
          title="Electrified Status"
          buttons={
            <>
              <Button
                content="R"
                disabled={data.electrified_until === 0}
                onClick={() => act('electrify_permanently', { activate: 0 })}
              />
              {data.isAdmin && !data.isAi ? (
                <>
                  <Button
                    content="T"
                    disabled={data.electrified_until > 0}
                    onClick={() => act('electrify_temporary', { activate: 1 })}
                  />
                  <Button
                    content="P"
                    disabled={data.electrified_until === -1}
                    onClick={() =>
                      act('electrify_permanently', { activate: 1 })
                    }
                  />
                </>
              ) : (
                ''
              )}
            </>
          }>
          <ProgressBar
            ranges={{
              good: [0, 1],
              average: [1.1, Infinity],
              bad: [-2, 0],
            }}
            value={
              data.electrified_until > 0 ? data.wtime : data.electrified_until
            }
            minValue={data.electrified_until ? data.electrified_at : 1}
            maxValue={data.electrified_until}>
            {get_electrified_message(data.electrified_until, data.wtime)}
          </ProgressBar>
        </Section>
        <Section title="Commands">
          <Box>
            <Box as="span" bold>
              Bolts:{' '}
            </Box>
            <Button
              content="Raised"
              disabled={data.isAi && !data.isAdmin && data.aiCanBolt}
              color={data.bolts && 'good'}
              onClick={() => act('bolts', { activate: 0 })}
            />
            <Button
              content="Dropped"
              disabled={
                data.isAi && !data.isAdmin && data.aiCanBolt && !data.bolts
              }
              color={!data.bolts && 'good'}
              onClick={() => act('bolts', { activate: 1 })}
            />
            <Button
              content={!data.bolts ? 'Raise Now' : 'Drop Now'}
              color="danger"
              disabled={!data.boltsOverride}
              onClick={() =>
                act('bolts_override', { activate: data.bolts ? 1 : 0 })
              }
            />
          </Box>
          <Box>
            <Box as="span" bold>
              IDScan:{' '}
            </Box>
            <Button
              content="On"
              color={data.idscan && 'good'}
              onClick={() => act('idscan', { activate: 1 })}
            />
            <Button
              content="Off"
              color={!data.idscan && 'good'}
              onClick={() => act('idscan', { activate: 0 })}
            />
          </Box>
          <Box>
            <Box as="span" bold>
              Bolt Lights:{' '}
            </Box>
            <Button
              content="On"
              color={data.lights && 'good'}
              onClick={() => act('lights', { activate: 1 })}
            />
            <Button
              content="Off"
              color={!data.lights && 'good'}
              onClick={() => act('lights', { activate: 0 })}
            />
          </Box>
          <Box>
            <Box as="span" bold>
              Safeties:{' '}
            </Box>
            <Button
              content="Nominal"
              color={data.safeties && 'good'}
              onClick={() => act('safeties', { activate: 0 })}
            />
            <Button
              content="Overridden"
              color={!data.safeties && 'danger'}
              onClick={() => act('safeties', { activate: 1 })}
            />
          </Box>
          <Box>
            <Box as="span" bold>
              Timing:{' '}
            </Box>
            <Button
              content="Nominal"
              color={data.timing && 'good'}
              onClick={() => act('timing', { activate: 0 })}
            />
            <Button
              content="Overridden"
              color={!data.timing && 'danger'}
              onClick={() => act('timing', { activate: 1 })}
            />
          </Box>
          <Box>
            <Box as="span" bold>
              Door State:{' '}
            </Box>
            <Button
              content="Open"
              color={data.open && 'good'}
              onClick={() => act('open', { activate: 1 })}
            />
            <Button
              content="Closed"
              color={!data.open && 'good'}
              onClick={() => act('open', { activate: 0 })}
            />
          </Box>
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
    return 'Interrupted, ' + timeleft + 's remaining';
  }
};

const get_electrified_message = (electrified, time) => {
  if (electrified === 0) {
    return 'Safe';
  } else if (electrified === -1) {
    return 'Permanently';
  } else {
    let electrified_message = Math.max(
      Math.round((electrified - time) / 10),
      0
    );
    return 'Electrified, ' + electrified_message + 's remaining';
  }
};

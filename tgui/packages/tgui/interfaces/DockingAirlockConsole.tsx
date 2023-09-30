import { useBackend } from '../backend';
import { Box, Button, LabeledList, ProgressBar, Section } from '../components';
import { Window } from '../layouts';

export type StatusData = {
  state: string;
  lock: string;
};

export type DockingAirlockConsoleData = {
  chamber_pressure: number;
  exterior_status: StatusData;
  interior_status: StatusData;
  processing: boolean;
  docking_status: string;
  airlock_disabled: boolean;
  override_enabled: boolean;
};

export const DockingAirlockConsole = (props, context) => {
  const { act, data } = useBackend<DockingAirlockConsoleData>(context);

  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section title="Status">
          <Box>
            <LabeledList>
              <LabeledList.Item label="Docking Port Status">
                {data.docking_status === 'docked' ? (
                  data.override_enabled ? (
                    <Box>Docked - Override Enabled</Box>
                  ) : (
                    <Box>Docked</Box>
                  )
                ) : data.docking_status === 'docking' ? (
                  data.override_enabled ? (
                    <Box>Docking - Override Enabled</Box>
                  ) : (
                    <Box>Docking</Box>
                  )
                ) : data.docking_status === 'undocking' ? (
                  data.override_enabled ? (
                    <Box>Undocking - Override Enabled</Box>
                  ) : (
                    <Box>Undocking</Box>
                  )
                ) : data.docking_status === 'undocked' ? (
                  data.override_enabled ? (
                    <Box>Override Enabled</Box>
                  ) : (
                    <Box>Not in use</Box>
                  )
                ) : (
                  <Box>Error</Box>
                )}
              </LabeledList.Item>
              <LabeledList.Item label="Chamber Pressure">
                <ProgressBar
                  ranges={{
                    average: [120, Infinity],
                    good: [80, 120],
                    bad: [-Infinity, 80],
                  }}
                  value={data.chamber_pressure}
                  minValue={0}
                  maxValue={200}>
                  {data.chamber_pressure} kPa
                </ProgressBar>
              </LabeledList.Item>
            </LabeledList>
          </Box>
        </Section>
        <Section title="Controls">
          <Box>
            <Button
              content="Cycle to Exterior"
              icon="arrow-right-from-bracket"
              onClick={() => act('command', { command: 'cycle_ext' })}
            />
            <Button
              content="Cycle to Interior"
              icon="arrow-right-to-bracket"
              onClick={() => act('command', { command: 'cycle_int' })}
            />
          </Box>
          <Box>
            <Button
              content="Force Exterior Door"
              icon="circle-exclamation"
              disabled={data.airlock_disabled}
              color={
                data.airlock_disabled
                  ? null
                  : data.interior_status.state === 'open'
                    ? 'red'
                    : 'yellow'
              }
              onClick={() => act('command', { command: 'force_ext' })}
            />
            <Button
              content="Force Interior Door"
              icon="circle-exclamation"
              disabled={data.airlock_disabled}
              color={
                data.airlock_disabled
                  ? null
                  : data.exterior_status.state === 'open'
                    ? 'red'
                    : 'yellow'
              }
              onClick={() => act('command', { command: 'force_int' })}
            />
          </Box>
          <Box>
            <Button
              content="Abort"
              icon="ban"
              disabled={data.airlock_disabled || !data.processing}
              color={data.airlock_disabled || !data.processing ? null : 'red'}
              onClick={() => act('command', { command: 'abort' })}
            />
          </Box>
        </Section>
      </Window.Content>
    </Window>
  );
};

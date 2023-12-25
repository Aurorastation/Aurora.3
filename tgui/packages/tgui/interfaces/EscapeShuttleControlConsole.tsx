import { useBackend } from '../backend';
import { Button, Section, Box, LabeledList } from '../components';
import { Window } from '../layouts';

export type AuthData = {
  auth_name: string;
  auth_hash: string;
};

export type EscapeShuttleControlConsoleData = {
  shuttle_status: string;
  shuttle_state: string;
  has_docking: boolean;
  docking_status: string;
  docking_override: boolean;
  can_launch: boolean;
  can_cancel: boolean;
  can_force: boolean;
  auth_list: AuthData[];
  has_auth: boolean;
};

export const EscapeShuttleControlConsole = (props, context) => {
  const { act, data } = useBackend<EscapeShuttleControlConsoleData>(context);

  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section title="Shuttle Status">
          <Box>{data.shuttle_status}</Box>
          <Box>
            <LabeledList>
              <LabeledList.Item label="Bluespace Drive:">
                {data.shuttle_state === 'idle'
                  ? 'Idle'
                  : data.shuttle_state === 'warmup'
                    ? 'Spinning Up'
                    : data.shuttle_state === 'in_transit'
                      ? 'Engaged'
                      : 'Error'}
              </LabeledList.Item>
              {data.has_docking ? (
                <LabeledList.Item label="Docking Status:">
                  {data.docking_status === 'docked'
                    ? 'Docked'
                    : data.docking_status === 'docking'
                      ? data.docking_override
                        ? 'Docking-Manual'
                        : 'Docking'
                      : data.docking_status === 'undocking'
                        ? data.docking_override
                          ? 'Undocking-Manual'
                          : 'Undocking'
                        : data.docking_status === 'undocked'
                          ? 'Undocked'
                          : 'Error'}
                </LabeledList.Item>
              ) : null}
            </LabeledList>
          </Box>
        </Section>
        <Section title="Shuttle Authorization">
          {data.has_auth ? (
            <Box>Access Granted. Shuttle controls unlocked.</Box>
          ) : (
            <Box>Additional authorization required.</Box>
          )}
          {data.auth_list.map((auth) =>
            auth.auth_hash ? (
              <Button
                content={auth.auth_name}
                icon="eject"
                onClick={() => act('removeid', { removeid: auth.auth_hash })}
              />
            ) : (
              <Button content="" icon="eject" onClick={() => act('scanid')} />
            )
          )}
        </Section>
        <Section title="Shuttle Control">
          <Button
            content="Launch Shuttle"
            icon="rocket"
            disabled={!data.can_launch}
            onClick={() => act('move')}
          />
          <Button
            content="Cancel Launch"
            icon="ban"
            disabled={!data.can_cancel}
            onClick={() => act('cancel')}
          />
          <Button
            content="Force Launch"
            icon="triangle-exclamation"
            color="red"
            disabled={!data.can_force}
            onClick={() => act('force')}
          />
        </Section>
      </Window.Content>
    </Window>
  );
};

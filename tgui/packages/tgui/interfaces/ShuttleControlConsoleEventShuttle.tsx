import { useBackend, useLocalState } from '../backend';
import { Button, Section, Box, LabeledList, NoticeBox, Input } from '../components';
import { Window } from '../layouts';

export type ShuttleControlConsoleEventShuttleData = {
  shuttle_status: string;
  shuttle_state: string;
  has_docking: boolean;
  docking_status: string;
  docking_override: boolean;
  can_launch: boolean;
  can_cancel: boolean;
  can_force: boolean;
  can_rename_ship: boolean;
  ship_name: string;
  auth_code: string;
};

export const ShuttleControlConsoleEventShuttle = (props, context) => {
  const { act, data } =
    useBackend<ShuttleControlConsoleEventShuttleData>(context);
  const [authCodeInput, setAuthCodeInput] = useLocalState<string>(
    context,
    `authCodeInput`,
    ``
  );

  const authCodeOk = authCodeInput == data.auth_code;

  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section title="Shuttle Status">
          <Box>{data.shuttle_status}</Box>
          <Box>Ship designation and name: {data.ship_name}</Box>
          {data.can_rename_ship ? (
            <Box>
              <Button
                content="Rename"
                icon="pen"
                onClick={() => act('rename')}
              />
            </Box>
          ) : null}
          <Box>
            <LabeledList>
              <LabeledList.Item label="Engines">
                {data.shuttle_state === 'idle'
                  ? 'Idle'
                  : data.shuttle_state === 'warmup'
                    ? 'Starting Ignition'
                    : data.shuttle_state === 'in_transit'
                      ? 'Engaged'
                      : 'Error'}
              </LabeledList.Item>
              {data.has_docking ? (
                <LabeledList.Item label="Docking Status">
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
        <Section title="Shuttle Control">
          <Button
            content="Launch Shuttle"
            icon="rocket"
            disabled={!data.can_launch || !authCodeOk}
            onClick={() => act('move', { auth_code_input: authCodeInput })}
          />
          <Button
            content="Cancel Launch"
            icon="ban"
            disabled={!data.can_cancel || !authCodeOk}
            onClick={() => act('cancel', { auth_code_input: authCodeInput })}
          />
          <Button
            content="Force Launch"
            icon="triangle-exclamation"
            color="red"
            disabled={!data.can_force || !authCodeOk}
            onClick={() => act('force', { auth_code_input: authCodeInput })}
          />
        </Section>
        <Section title="">
          <NoticeBox warning>
            The Konyang Armed Forces have blocked this shuttle from leaving. An
            authorization code must be inputted to allow departure.
            <br />
            <br />
            <Input
              width="100%"
              value={authCodeInput}
              placeholder="Authorization Code"
              onInput={(e, v) => setAuthCodeInput(v)}
              onChange={(e, v) => setAuthCodeInput(v)}
            />
            <br />
            {authCodeOk ? (
              <NoticeBox success>Authorization code correct.</NoticeBox>
            ) : (
              <NoticeBox danger>Invalid authorization code.</NoticeBox>
            )}
          </NoticeBox>
        </Section>
      </Window.Content>
    </Window>
  );
};

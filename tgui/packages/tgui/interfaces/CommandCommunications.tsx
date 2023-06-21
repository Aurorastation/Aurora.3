import { BooleanLike } from '../../common/react';
import { useBackend, useLocalState } from '../backend';
import { Box, Button, Section, Stack } from '../components';
import { NtosWindow } from '../layouts';

export type CommsData = {
  emagged: BooleanLike;
  net_comms: BooleanLike;
  net_syscont: BooleanLike;
  message_printing_intercepts: BooleanLike;
  have_printer: BooleanLike;

  can_call_shuttle: BooleanLike;
  message_line1: string;
  message_line2: string;
  state: number;
  isAI: BooleanLike;
  authenticated: BooleanLike;
  boss_short: string;
  current_security_level: number;
  current_security_level_title: string;
  current_maint_all_access: BooleanLike;

  def_SEC_LEVEL_DELTA: number;
  def_SEC_LEVEL_YELLOW: number;
  def_SEC_LEVEL_BLUE: number;
  def_SEC_LEVEL_GREEN: number;

  messages: string[];
  message_deletion_allowed: BooleanLike;
  message_current_id: number;
  message_current: string;

  evac_options: EvacOption[];
};

type EvacOption = {
  option_text: string;
  option_target: string;
  needs_syscontrol: BooleanLike;
  silicon_allowed: BooleanLike;
};

export const CommandCommunications = (props, context) => {
  const { act, data } = useBackend<CommsData>(context);
  const [choosingAlert, setChoosingAlert] = useLocalState<boolean>(
    context,
    `choosingAlert`,
    false
  );
  return (
    <NtosWindow resizable width={550} height={420}>
      <NtosWindow.Content scrollable>
        <Section title="Communications Options">
          <Stack vertical>
            <Stack.Item>
              <Button
                content="Make Announcement"
                icon="newspaper"
                disabled={data.isAI || !data.net_comms}
                onClick={() => act('announce')}
              />
            </Stack.Item>
            <Stack.Item>
              <Button
                content={
                  data.emagged ? (
                    <Box as="span">
                      Send Emergency Message To{' '}
                      <Box as="span" color="red">
                        #UNKN#
                      </Box>
                    </Box>
                  ) : (
                    'Send Emergency Message To ' + data.boss_short
                  )
                }
                icon="compass"
                disabled={data.isAI || !data.net_comms}
                onClick={() =>
                  act('message', {
                    target: data.emagged ? 'emagged' : 'regular',
                  })
                }
              />
            </Stack.Item>
            <Stack.Item>
              <Button
                content="Change Alert Level"
                icon="lightbulb"
                selected={choosingAlert}
                disabled={data.isAI || !data.net_comms || !data.net_syscont}
                onClick={() => setChoosingAlert(!choosingAlert)}
              />
              {choosingAlert ? (
                <>
                  <Button
                    content="Green"
                    color="green"
                    disabled={
                      data.current_security_level ===
                        data.def_SEC_LEVEL_GREEN ||
                      data.isAI ||
                      !data.net_comms ||
                      !data.net_syscont
                    }
                    onClick={() =>
                      act('setalert', { target: data.def_SEC_LEVEL_GREEN })
                    }
                  />
                  <Button
                    content="Blue"
                    color="blue"
                    disabled={
                      data.current_security_level === data.def_SEC_LEVEL_BLUE ||
                      data.isAI ||
                      !data.net_comms ||
                      !data.net_syscont
                    }
                    onClick={() =>
                      act('setalert', { target: data.def_SEC_LEVEL_BLUE })
                    }
                  />
                  <Button
                    content="Yellow"
                    color="yellow"
                    disabled={
                      data.current_security_level ===
                        data.def_SEC_LEVEL_YELLOW ||
                      data.isAI ||
                      !data.net_comms ||
                      !data.net_syscont
                    }
                    onClick={() =>
                      act('setalert', { target: data.def_SEC_LEVEL_YELLOW })
                    }
                  />
                </>
              ) : (
                ''
              )}
            </Stack.Item>
            <Stack.Item>
              <Button
                content={
                  data.current_maint_all_access
                    ? 'Disable Maintenance Emergency Access'
                    : 'Enable Maintenance Emergency Access'
                }
                color={data.current_maint_all_access ? 'red' : ''}
                icon="door-closed"
                onClick={() => act('emergencymaint')}
              />
            </Stack.Item>
          </Stack>
        </Section>
        <Section title="Status Display Settings" buttons={<Button content="Clear" onClick={() => act('setstatus', { target : blank})} />}>
            
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};

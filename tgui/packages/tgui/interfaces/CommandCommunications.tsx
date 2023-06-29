import { BooleanLike } from '../../common/react';
import { useBackend, useLocalState } from '../backend';
import { Box, Button, Collapsible, Input, Section, Stack } from '../components';
import { NtosWindow } from '../layouts';
import { sanitizeText } from '../sanitize';

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

  messages: Message[];
  message_deletion_allowed: BooleanLike;
  message_current_id: number;
  message_current: string;

  evac_options: EvacOption[];
};

type Message = {
  id: number;
  title: string;
  contents: string;
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

  const [firstLine, setFirstLine] = useLocalState<string>(
    context,
    `firstLine`,
    ''
  );
  const [secondLine, setSecondLine] = useLocalState<string>(
    context,
    `secondLine`,
    ''
  );

  return (
    <NtosWindow resizable width={600} height={500}>
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
                disabled={!data.net_comms || !data.net_syscont}
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
        <Collapsible content="Status Display Settings">
          <Section
            title="Status Display Settings"
            buttons={
              <Button
                content="Clear"
                icon="trash"
                onClick={() => act('setstatus', { target: 'blank' })}
              />
            }>
            <Button
              content="Ship Time"
              icon="clock"
              onClick={() => act('setstatus', { target: 'time' })}
            />
            <Button
              content="ETA"
              icon="door-open"
              onClick={() => act('setstatus', { target: 'shuttle' })}
            />
            <Section
              title="Custom Message"
              buttons={
                <Button
                  content="Set"
                  icon="check"
                  onClick={() =>
                    act('setstatus', {
                      target: 'message',
                      line1: firstLine,
                      line2: secondLine,
                    })
                  }
                />
              }>
              <Input
                value={firstLine}
                placeholder="First line"
                width={20}
                onInput={(e, v) => setFirstLine(v)}
              />
              <Input
                value={secondLine}
                placeholder="Second line"
                width={20}
                onInput={(e, v) => setSecondLine(v)}
              />
            </Section>
            <Section title="Alerts">
              <Button
                content="Red Alert"
                icon="traffic-light"
                color="red"
                onClick={() =>
                  act('setstatus', { target: 'alert', alert: 'redalert' })
                }
              />
              <Button
                content="Lockdown"
                icon="lock"
                color="average"
                onClick={() =>
                  act('setstatus', { target: 'alert', alert: 'lockdown' })
                }
              />
              <Button
                content="Biohazard"
                icon="biohazard"
                color="yellow"
                onClick={() =>
                  act('setstatus', { target: 'alert', alert: 'biohazard' })
                }
              />
            </Section>
          </Section>
        </Collapsible>
        <Section title="Message List">
          {data.messages && data.messages.length ? (
            <MessageList />
          ) : (
            'There are no messages.'
          )}
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};

export const MessageList = (props, context) => {
  const { act, data } = useBackend<CommsData>(context);
  const [viewingMessage, setViewingMessage] = useLocalState<number | null>(
    context,
    'viewingMessage',
    null
  );

  return viewingMessage ? (
    <Section>
      {data.messages
        .filter((message) => message.id === viewingMessage)
        .map((message) => (
          <Section
            title={message.title}
            key={message.id}
            buttons={
              <>
                <Button
                  content="Back"
                  icon="arrow-alt-circle-left"
                  onClick={() => setViewingMessage(null)}
                />
                <Button
                  content="Print"
                  icon="print"
                  disabled={!data.have_printer}
                  onClick={() =>
                    act('printmessage', {
                      contents: message.contents,
                      title: message.title,
                    })
                  }
                />
                <Button
                  content="Delete"
                  color="red"
                  icon="trash"
                  disabled={!data.message_deletion_allowed}
                  onClick={() => act('delmessage', { messageid: message.id })}
                />
              </>
            }>
            <Box
              style={{ 'white-space': 'pre-line' }}
              dangerouslySetInnerHTML={processMessage(message.contents)}
            />
          </Section>
        ))}
    </Section>
  ) : (
    <Section>
      <Section>
        {data.messages.map((message) => (
          <Button
            key={message.id}
            content={message.title}
            onClick={() => setViewingMessage(message.id)}
          />
        ))}
      </Section>
    </Section>
  );
};

const processMessage = (value) => {
  const contentHtml = { __html: sanitizeText(value) };
  return contentHtml;
};

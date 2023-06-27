import { BooleanLike } from '../../common/react';
import { useBackend, useLocalState, useSharedState } from '../backend';
import { Box, Button, Input, Section, Stack, Table, Tabs } from '../components';
import { NtosWindow } from '../layouts';

export type ChatData = {
  service: BooleanLike;
  registered: BooleanLike;
  signal: BooleanLike;
  ringtone: string;
  netadmin_mode: BooleanLike;
  can_netadmin_mode: BooleanLike;
  message_mute: BooleanLike;

  msg: string[];
  channels: Channel[];
  users: User[];
};

type Channel = {
  ref: string;
  title: string;
  direct: BooleanLike;
  password: BooleanLike;
  can_interact: BooleanLike;
  can_manage: BooleanLike;
  focused: BooleanLike;
  users: User[];
};

type User = {
  ref: string;
  username: string;
};

export const ChatClient = (props, context) => {
  const { act, data } = useBackend<ChatData>(context);
  let [active, setActive] = useSharedState<Channel | null>(
    context,
    'active',
    null
  );
  const [editingRingtone, setEditingRingtone] = useLocalState(
    context,
    'editingRingtone',
    0
  );
  const [searchTerm, setSearchTerm] = useLocalState<string>(
    context,
    `searchTerm`,
    ``
  );

  return (
    <NtosWindow resizable width={700}>
      <NtosWindow.Content scrollable>
        <Section
          title="Users"
          buttons={
            <>
              <Button
                content={
                  data.message_mute ? 'Unmute Messages' : 'Mute Messages'
                }
                icon="times"
                onClick={() => act('mute_message')}
              />
              <Button
                content={'Ringtone: ' + data.ringtone}
                onClick={() => setEditingRingtone(editingRingtone ? 0 : 1)}
              />
              {editingRingtone ? (
                <Input
                  value={data.ringtone}
                  placeholder={data.ringtone}
                  onChange={(e, v) => act('ringtone', { ringtone: v })}
                />
              ) : (
                ''
              )}
              {data.can_netadmin_mode || data.netadmin_mode ? (
                <Button
                  content={
                    data.netadmin_mode ? 'Exit Admin Mode' : 'Admin Mode'
                  }
                  selected={data.netadmin_mode}
                  onClick={() => act('toggleadmin')}
                />
              ) : (
                ''
              )}
            </>
          }>
          {data.users && data.users.length ? <Users /> : 'There are no users.'}
          {!active ? <ChannelsWindow /> : ''}
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};

export const Users = (props, context) => {
  const { act, data } = useBackend<ChatData>(context);
  const [searchTerm, setSearchTerm] = useLocalState<string>(
    context,
    `searchTerm`,
    ``
  );
  let [active, setActive] = useSharedState<Channel | null>(
    context,
    'active',
    null
  );

  return (
    <Section>
      <Section fitted>
        <Tabs>
          <Tabs.Tab
            height="20%"
            selected={!active}
            onClick={() => setActive(null)}>
            All
          </Tabs.Tab>
          {data.channels
            .filter((chn) => chn.can_interact)
            .map((channel) => (
              <Tabs.Tab
                height="10%"
                key={channel.ref}
                selected={active && active.ref === channel.ref}
                onClick={() => setActive(channel)}>
                {channel.title}
              </Tabs.Tab>
            ))}
        </Tabs>
      </Section>
      {active ? <Chat /> : <AllUsers />}
    </Section>
  );
};

export const AllUsers = (props, context) => {
  const { act, data } = useBackend<ChatData>(context);
  const [searchTerm, setSearchTerm] = useLocalState<string>(
    context,
    `searchTerm`,
    ``
  );
  let [active, setActive] = useSharedState<Channel | null>(
    context,
    'active',
    null
  );

  return (
    <Stack vertical>
      <Input
        autoFocus
        autoSelect
        placeholder="Search by name"
        height="10%"
        width="40%"
        maxLength={512}
        onInput={(e, value) => {
          setSearchTerm(value);
        }}
        value={searchTerm}
      />
      {data.users
        .filter(
          (usr) =>
            usr.username?.toLowerCase().indexOf(searchTerm.toLowerCase()) > -1
        )
        .map((user) => (
          <Stack.Item key={user.ref}>
            <Button
              content={user.username}
              onClick={() => act('direct', { direct: user.ref })}
            />
          </Stack.Item>
        ))}
    </Stack>
  );
};

export const Chat = (props, context) => {
  const { act, data } = useBackend<ChatData>(context);
  const [newMessage, setNewMessage] = useLocalState<string>(
    context,
    `newMessage`,
    ``
  );
  const [password, setPassword] = useLocalState<string>(
    context,
    `password`,
    ``
  );
  const [title, setTitle] = useLocalState<string>(context, `title`, ``);
  let [active] = useLocalState<Channel | null>(context, 'active', null);

  return (
    <Section
      title="Conversation"
      buttons={
        <>
          {active && active.can_manage && !active.direct ? (
            <>
              <Button
                key={active.ref}
                content={password ? 'Close Menu' : 'Set Password'}
                onClick={() => setPassword(password ? '' : 'New Password')}
              />
              {password ? (
                <Input
                  placeholder={password}
                  value={password}
                  onInput={(e, v) => setPassword(v)}
                  onChange={(e, v) =>
                    act('set_password', {
                      password: password,
                      target: active ? active.ref : '',
                    })
                  }
                />
              ) : (
                ''
              )}
              <Button
                key={active.ref}
                content={title ? 'Close Menu' : 'Set Title'}
                onClick={() => setTitle(title ? '' : 'New Title')}
              />
              {title ? (
                <Input
                  placeholder={title}
                  value={title}
                  onInput={(e, v) => setTitle(v)}
                  onChange={(e, v) =>
                    act('change_title', {
                      title: title,
                      target: active ? active.ref : '',
                    })
                  }
                />
              ) : (
                ''
              )}
              <Button
                content="Delete"
                color="red"
                onClick={() =>
                  act('delete', { delete: active ? active.ref : '' })
                }
              />
            </>
          ) : (
            ''
          )}
          <Button
            content="Leave"
            disabled={active && active.direct}
            onClick={() => act('leave', { leave: active ? active.ref : '' })}
          />
          <Button
            content="Enable STT"
            selected={active && active.focused}
            onClick={() => act('focus', { focus: active ? active.ref : '' })}
          />
        </>
      }>
      {active &&
        data.msg &&
        data.msg.map((message) => (
          <Box
            key={message}
            preserveWhitespace
            fontFamily="arial"
            backgroundColor="#000000">
            {message}
          </Box>
        ))}
      &nbsp;
      <Box>
        <Input
          value={newMessage}
          placeholder="Type your message. Press enter to send."
          width="100%"
          onInput={(e, v) => setNewMessage(v)}
          onChange={(e, v) =>
            act('send', {
              message: newMessage,
              target: active ? active.ref : '',
            })
          }
        />
      </Box>
      <Box py={2}>
        <Table>
          {active &&
            !active.direct &&
            active.users.map((user) => (
              <Table.Row key={user.ref}>
                <Table.Cell>{user.username}</Table.Cell>
                <Table.Cell>
                  <Button
                    content="Kick"
                    icon="user"
                    disabled={active && !active.can_manage}
                    onClick={() =>
                      act('kick', {
                        target: active ? active.ref : '',
                        user: user.ref,
                      })
                    }
                  />
                </Table.Cell>
              </Table.Row>
            ))}
        </Table>
      </Box>
    </Section>
  );
};

export const ChannelsWindow = (props, context) => {
  const { act, data } = useBackend<ChatData>(context);
  const [channelSearchTerm, setChannelSearchTerm] = useLocalState<string>(
    context,
    `channelSearchTerm`,
    ``
  );
  let [active, setActive] = useSharedState<Channel | null>(
    context,
    'active',
    null
  );
  const [channelName, setChannelName] = useLocalState(
    context,
    'channelName',
    ''
  );
  const [joinPassword, setJoinPassword] = useLocalState(
    context,
    'joinPassword',
    ''
  );

  return (
    <Section
      title="Channels"
      buttons={
        <>
          <Button
            content="New Channel"
            onClick={() =>
              setChannelName(channelName ? '' : 'New Channel Name')
            }
          />
          {channelName ? (
            <Input
              placeholder={channelName}
              value={channelName}
              onInput={(e, v) => setChannelName(v)}
              onChange={() => act('new_channel', { new_channel: channelName })}
            />
          ) : (
            ''
          )}
        </>
      }>
      <Stack vertical>
        <Input
          autoFocus
          autoSelect
          placeholder="Search by name"
          height="10%"
          width="40%"
          maxLength={512}
          onInput={(e, value) => {
            setChannelSearchTerm(value);
          }}
          value={channelSearchTerm}
        />
        {data.channels
          .filter(
            (chn) =>
              chn.title
                ?.toLowerCase()
                .indexOf(channelSearchTerm.toLowerCase()) > -1 && !chn.direct
          )
          .map((channel) => (
            <Stack.Item key={channel.ref}>
              {channel.password ? (
                <>
                  <Button
                    content={channel.title}
                    onClick={() => setJoinPassword('Password')}
                  />
                  {joinPassword ? (
                    <Input
                      value={joinPassword}
                      onInput={(e, v) => setJoinPassword(v)}
                      onChange={(e, v) =>
                        act('join', {
                          target: channel.ref,
                          password: joinPassword,
                        })
                      }
                    />
                  ) : (
                    ''
                  )}
                </>
              ) : (
                <Button
                  content={channel.title}
                  onClick={() => act('join', { target: channel.ref })}
                />
              )}
            </Stack.Item>
          ))}
      </Stack>
    </Section>
  );
};

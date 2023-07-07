import { BooleanLike } from '../../common/react';
import { useBackend, useLocalState } from '../backend';
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

  active: Channel;
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
          {!data.active ? <ChannelsWindow /> : ''}
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

  return (
    <Section>
      <Section fitted>
        <Tabs>
          <Tabs.Tab
            height="20%"
            selected={!data.active}
            onClick={() => act('set_active', { set_active: null })}>
            All
          </Tabs.Tab>
          {data.channels
            .filter((chn) => chn.can_interact)
            .map((channel) => (
              <Tabs.Tab
                height="10%"
                key={channel.ref}
                selected={data.active && data.active.ref === channel.ref}
                onClick={() => act('set_active', { set_active: channel.ref })}>
                {channel.title}
              </Tabs.Tab>
            ))}
        </Tabs>
      </Section>
      {data.active && data.active.can_interact ? <Chat /> : <AllUsers />}
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

  return (
    <Section
      title="Conversation"
      buttons={
        <>
          {data.active && data.active.can_manage && !data.active.direct ? (
            <>
              <Button
                key={data.active.ref}
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
                      target: data.active ? data.active.ref : '',
                    })
                  }
                />
              ) : (
                ''
              )}
              <Button
                key={data.active.ref}
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
                      target: data.active ? data.active.ref : '',
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
                  act('delete', { delete: data.active ? data.active.ref : '' })
                }
              />
            </>
          ) : (
            ''
          )}
          <Button
            content="Leave"
            disabled={data.active && data.active.direct}
            onClick={() =>
              act('leave', { leave: data.active ? data.active.ref : '' })
            }
          />
          <Button
            content="Enable STT"
            selected={data.active && data.active.focused}
            onClick={() =>
              act('focus', { focus: data.active ? data.active.ref : '' })
            }
          />
        </>
      }>
      {data.active &&
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
          selfClear
          strict
          onInput={(e, v) => setNewMessage(v)}
          onChange={(e, v) =>
            act('send', {
              message: newMessage,
              target: data.active ? data.active.ref : '',
            })
          }
        />
      </Box>
      <Box py={2}>
        <Table>
          {data.active &&
            !data.active.direct &&
            data.active.users.map((user) => (
              <Table.Row key={user.ref}>
                <Table.Cell>{user.username}</Table.Cell>
                <Table.Cell>
                  <Button
                    content="Kick"
                    icon="user"
                    disabled={data.active && !data.active.can_manage}
                    onClick={() =>
                      act('kick', {
                        target: data.active ? data.active.ref : '',
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

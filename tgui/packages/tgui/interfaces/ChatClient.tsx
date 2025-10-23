import {
  Box,
  Button,
  Input,
  Section,
  Stack,
  Table,
  Tabs,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { useBackend, useLocalState } from '../backend';
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

export const ChatClient = (props) => {
  const { act, data } = useBackend<ChatData>();
  const [editingRingtone, setEditingRingtone] = useLocalState(
    'editingRingtone',
    0,
  );
  const [searchTerm, setSearchTerm] = useLocalState<string>(`searchTerm`, ``);

  return (
    <NtosWindow width={700}>
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
                content={`Ringtone: ${data.ringtone}`}
                onClick={() => setEditingRingtone(editingRingtone ? 0 : 1)}
              />
              {editingRingtone ? (
                <Input
                  value={data.ringtone}
                  placeholder={data.ringtone}
                  onChange={(v) => act('ringtone', { ringtone: v })}
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
          }
        >
          {data.users?.length ? <Users /> : 'There are no users.'}
          {!data.active ? <ChannelsWindow /> : ''}
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};

export const Users = (props) => {
  const { act, data } = useBackend<ChatData>();
  const [searchTerm, setSearchTerm] = useLocalState<string>(`searchTerm`, ``);

  return (
    <Section>
      <Section fitted>
        <Tabs pl="15px" pr="15px">
          <Tabs.Tab
            height="20%"
            selected={!data.active}
            onClick={() => act('set_active', { set_active: null })}
          >
            All
          </Tabs.Tab>
          {data.channels?.length
            ? data.channels
                .filter((chn) => chn.can_interact)
                .map((channel) => (
                  <Tabs.Tab
                    height="10%"
                    key={channel.ref}
                    selected={data.active && data.active.ref === channel.ref}
                    onClick={() =>
                      act('set_active', { set_active: channel.ref })
                    }
                  >
                    {channel.title}
                  </Tabs.Tab>
                ))
            : null}
        </Tabs>
      </Section>
      {data.active?.can_interact ? <Chat /> : <AllUsers />}
    </Section>
  );
};

export const AllUsers = (props) => {
  const { act, data } = useBackend<ChatData>();
  const [searchTerm, setSearchTerm] = useLocalState<string>(`searchTerm`, ``);

  return (
    <Stack vertical>
      <Input
        autoFocus
        autoSelect
        placeholder="Search by name"
        height="10%"
        width="40%"
        maxLength={512}
        onChange={(value) => {
          setSearchTerm(value);
        }}
        value={searchTerm}
      />
      {data.users?.length &&
        data.users
          .filter(
            (usr) =>
              usr.username?.toLowerCase().indexOf(searchTerm.toLowerCase()) >
              -1,
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

export const Chat = (props) => {
  const { act, data } = useBackend<ChatData>();
  const [newMessage, setNewMessage] = useLocalState<string>(`newMessage`, ``);

  const [creatingJoinPassword, setCreatingJoinPassword] = useLocalState(
    'creatingJoinPassword',
    0,
  );

  const [password, setPassword] = useLocalState<string>(`password`, ``);

  const [creatingTitle, setCreatingTitle] = useLocalState('creatingTitle', 0);

  const [title, setTitle] = useLocalState<string>(`title`, ``);

  return (
    <Section
      title="Conversation"
      buttons={
        <>
          {data.active?.can_manage && !data.active.direct ? (
            <>
              <Button
                key={data.active.ref}
                content={creatingJoinPassword ? 'Close Menu' : 'Set Password'}
                onClick={() => {
                  setPassword('');
                  setCreatingJoinPassword(creatingJoinPassword ? 0 : 1);
                }}
              />
              {creatingJoinPassword ? (
                <Input
                  placeholder="New Password"
                  value={password}
                  onChange={(v) => {
                    setPassword(v);
                    act('set_password', {
                      password: password,
                      target: data.active ? data.active.ref : '',
                    });
                    setCreatingJoinPassword(0);
                  }}
                />
              ) : (
                ''
              )}
              <Button
                key={data.active.ref}
                content={creatingTitle ? 'Close Menu' : 'Set Title'}
                onClick={() => {
                  setTitle('');
                  setCreatingTitle(creatingTitle ? 0 : 1);
                }}
              />
              {creatingTitle ? (
                <Input
                  placeholder="New Title"
                  value={title}
                  onChange={(v) => {
                    setTitle(v);
                    act('change_title', {
                      title: title,
                      target: data.active ? data.active.ref : '',
                    });
                    setCreatingTitle(0);
                  }}
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
            disabled={data.active?.direct}
            onClick={() =>
              act('leave', { leave: data.active ? data.active.ref : '' })
            }
          />
          <Button
            content="Enable STT"
            selected={data.active?.focused}
            onClick={() =>
              act('focus', { focus: data.active ? data.active.ref : '' })
            }
          />
        </>
      }
    >
      {data.active &&
        data.msg &&
        data.msg.map((message) => (
          <Box
            key={message}
            preserveWhitespace
            fontFamily="arial"
            backgroundColor="#000000"
          >
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
          onChange={(v) => {
            setNewMessage(v);
            act('send', {
              message: newMessage,
              target: data.active ? data.active.ref : '',
            });
          }}
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

export const ChannelsWindow = (props) => {
  const { act, data } = useBackend<ChatData>();
  const [channelSearchTerm, setChannelSearchTerm] = useLocalState<string>(
    `channelSearchTerm`,
    ``,
  );

  const [creatingChannelName, setCreatingChannelName] = useLocalState(
    'creatingChannelName',
    0,
  );

  const [channelName, setChannelName] = useLocalState('channelName', '');

  const [enteringJoinPassword, setEnteringJoinPassword] = useLocalState(
    'enteringJoinPassword',
    0,
  );

  const [joinPassword, setJoinPassword] = useLocalState('joinPassword', '');

  return (
    <Section
      title="Channels"
      buttons={
        <>
          <Button
            content={creatingChannelName ? 'Close Menu' : 'New Channel'}
            onClick={() => {
              setChannelName('');
              setCreatingChannelName(creatingChannelName ? 0 : 1);
            }}
          />
          {creatingChannelName ? (
            <Input
              placeholder="New Channel Name"
              value={channelName}
              onChange={(v) => {
                setChannelName(v);
                act('new_channel', { new_channel: channelName });
                setCreatingChannelName(0);
              }}
            />
          ) : (
            ''
          )}
        </>
      }
    >
      <Stack vertical>
        <Input
          autoFocus
          autoSelect
          placeholder="Search by name"
          height="10%"
          width="40%"
          maxLength={512}
          onChange={(value) => {
            setChannelSearchTerm(value);
          }}
          value={channelSearchTerm}
        />
        {data.channels?.length
          ? data.channels
              .filter(
                (chn) =>
                  chn.title
                    ?.toLowerCase()
                    .indexOf(channelSearchTerm.toLowerCase()) > -1 &&
                  !chn.direct,
              )
              .map((channel) => (
                <Stack.Item key={channel.ref}>
                  {channel.password ? (
                    <>
                      <Button
                        content={channel.title}
                        onClick={() => {
                          setJoinPassword('');
                          setEnteringJoinPassword(enteringJoinPassword ? 0 : 1);
                        }}
                      />
                      {enteringJoinPassword ? (
                        <Input
                          placeholder="Enter Password"
                          value={joinPassword}
                          onChange={(v) => {
                            setJoinPassword(v);
                            act('join', {
                              target: channel.ref,
                              password: joinPassword,
                            });
                            setEnteringJoinPassword(0);
                          }}
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
              ))
          : null}
      </Stack>
    </Section>
  );
};

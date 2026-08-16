import { Box, Button, Flex, Icon, Input, Section } from 'tgui-core/components';
import { useBackend, useLocalState } from '../../backend';
import { CommunicatorTab } from './types';
import type { CommunicatorData, TextChat } from './types';

export const CommunicatorMessagesTab = () => {
  const { act, data } = useBackend<CommunicatorData>();
  const { activeChats } = data;

  const [selectedChatAddr, setSelectedChatAddr] = useLocalState<string | null>(
    'SelectedChatAddr',
    null,
  );
  const selectedChat = activeChats.find(
    (chat) => chat.chatTarget === selectedChatAddr,
  );

  return (
    <Section
      title="Messages"
      fill
      buttons={
        selectedChat ? (
          <Button
            icon="circle-left"
            iconPosition="right"
            onClick={() => setSelectedChatAddr(null)}
          >
            Back
          </Button>
        ) : (
          <Button
            icon="pen-to-square"
            iconPosition="right"
            onClick={() =>
              act('switch_tab', { new_tab: CommunicatorTab.Contacts })
            }
          >
            New Chat
          </Button>
        )
      }
    >
      {selectedChat ? (
        <ChatView selectedChat={selectedChat} />
      ) : (
        <AllChatList />
      )}
    </Section>
  );
};

const ChatView = ({ selectedChat }: { selectedChat: TextChat }) => {
  const { act, data } = useBackend<CommunicatorData>();
  const targetOnline = data.allUsers.some(
    (user) => user.address === selectedChat.chatTarget,
  );

  return (
    <Flex direction="column" height="100%" justify="space-between">
      <Flex.Item>
        <Box bold fontSize={1.5} mb={1}>
          {selectedChat.targetName || '[UNKNOWN]'}
        </Box>
        <Box color="label">{selectedChat.chatTarget}</Box>
      </Flex.Item>
      <Flex.Item grow my={1} overflowY="auto">
        {selectedChat.messages.length ? (
          selectedChat.messages.map((message, index) => {
            const sentByUser = message.senderAddress === data.userComm.address;
            return (
              <Box
                key={`${message.timeSent}-${index}`}
                backgroundColor={sentByUser ? '#174c70' : '#303030'}
                color="white"
                p={1}
                my={0.5}
                ml={sentByUser ? 6 : 0}
                mr={sentByUser ? 0 : 6}
                style={{ borderRadius: '6px', wordBreak: 'break-word' }}
              >
                <Box>{message.content}</Box>
                <Box color="label" textAlign="right" fontSize={0.9}>
                  {message.timeSent}
                </Box>
              </Box>
            );
          })
        ) : (
          <Box color="label" textAlign="center" mt={4}>
            No messages yet.
          </Box>
        )}
      </Flex.Item>
      <Flex.Item>
        <Input
          fluid
          selfClear
          maxLength={512}
          disabled={!targetOnline || !!data.observer}
          placeholder={
            targetOnline ? 'Type a message and press Enter' : 'Contact is offline'
          }
          onEnter={(message) => {
            if (message.trim().length) {
              act('send_message', {
                target_address: selectedChat.chatTarget,
                message,
              });
            }
          }}
        />
      </Flex.Item>
    </Flex>
  );
};

const AllChatList = () => {
  const { data } = useBackend<CommunicatorData>();
  const { activeChats, allUsers } = data;

  const [selectedChatAddr, setSelectedChatAddr] = useLocalState<string | null>(
    'SelectedChatAddr',
    null,
  );

  const ChatEntry = ({ chat }: { chat: TextChat }) => {
    // TODO: Handle `chatTargetUser` being null, like in the contacts list.
    const chatTargetUser = allUsers.find(
      (user) => user.address === chat.chatTarget,
    );
    const targetName = chatTargetUser?.username || chat.targetName;

    const latestMessage =
      !!chat.messages.length && chat.messages[chat.messages.length - 1];

    // The first character of the user's username if it's alphanumeric,
    // otherwise a question mark.
    const iconName =
      (targetName && /^\w/.exec(targetName)?.[0].toLowerCase()) ||
      'question';

    return (
      <Flex.Item key={chat.chatTarget} my={1}>
        <Button
          fluid
          color="transparent"
          py={1}
          onClick={() => setSelectedChatAddr(chat.chatTarget)}
        >
          <Flex>
            <Flex.Item pr={0.5}>
              <Icon name={iconName} size={4} m="auto" />
            </Flex.Item>
            <Flex.Item grow>
              <Flex
                direction="column"
                justify="space-between"
                py="2px"
                height="100%"
              >
                <Flex.Item>
                  <Box inline bold color="white" fontSize={1.6}>
                    {targetName || '[UNKNOWN]'}
                  </Box>
                  &nbsp;
                  <Box inline position="absolute" fontSize={1.15} mt="1px">
                    ({chat.chatTarget})
                  </Box>
                </Flex.Item>
                <Flex.Item fontSize={1.4}>
                  {latestMessage ? (
                    <Box color="white">{latestMessage.content}</Box>
                  ) : (
                    <Box>No messages</Box>
                  )}
                </Flex.Item>
              </Flex>
            </Flex.Item>
            <Flex.Item>{latestMessage && latestMessage.timeSent}</Flex.Item>
          </Flex>
        </Button>
      </Flex.Item>
    );
  };

  return activeChats.length ? (
    <Flex direction="column">
      {activeChats.map((chat) => (
        <ChatEntry key={chat.chatTarget} chat={chat} />
      ))}
    </Flex>
  ) : (
    <Flex
      height="100%"
      textAlign="center"
      justify="space-evenly"
      align="center"
      fontSize={2}
      color="label"
    >
      <Flex.Item>No messages</Flex.Item>
    </Flex>
  );
};

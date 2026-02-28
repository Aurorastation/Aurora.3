import { useBackend, useLocalState } from '../../backend';
import { Box, Button, Flex, Icon, Section } from '../../components';
import { CommunicatorData, CommunicatorTab, TextChat } from './types';

export const CommunicatorMessagesTab = (props, context) => {
  const { act, data } = useBackend<CommunicatorData>(context);
  const { activeChats } = data;

  const [selectedChatAddr, setSelectedChatAddr] = useLocalState<string | null>(
    context,
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

const ChatView = ({ selectedChat }: { selectedChat: TextChat }, context) => {
  return <Box>chat view placeholder</Box>;
};

const AllChatList = (props, context) => {
  const { act, data } = useBackend<CommunicatorData>(context);
  const { activeChats, allUsers } = data;

  const [selectedChatAddr, setSelectedChatAddr] = useLocalState<string | null>(
    context,
    'SelectedChatAddr',
    null,
  );

  const ChatEntry = ({ chat }: { chat: TextChat }) => {
    // TODO: Handle `chatTargetUser` being null, like in the contacts list.
    const chatTargetUser = allUsers.find(
      (user) => user.address === chat.chatTarget,
    );

    const latestMessage =
      !!chat.messages.length && chat.messages[chat.messages.length - 1];

    // The first character of the user's username if it's alphanumeric,
    // otherwise a question mark.
    const iconName =
      (chatTargetUser?.username &&
        /^\w/.exec(chatTargetUser.username)?.[0].toLowerCase()) ||
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
                    {chatTargetUser?.username}
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

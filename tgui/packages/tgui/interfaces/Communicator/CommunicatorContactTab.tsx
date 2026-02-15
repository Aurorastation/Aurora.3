import { useBackend, useLocalState } from '../../backend';
import {
  Box,
  Button,
  Divider,
  Flex,
  Section,
  Stack,
  Tooltip,
} from '../../components';
import { CommunicatorData, CommunicatorTab, User } from './types';

type ContactListProps = {
  contacts: User[];
  showFriendReqBtn?: boolean;
};

type ContactListingProps = {
  contact: User;
  showFriendReqBtn?: boolean;
};

export const CommunicatorContactTab = (props, context) => {
  const { act, data } = useBackend<CommunicatorData>(context);
  const { friendsList, allUsers } = data;

  const publicUsers = allUsers.filter((user) => user.visible);

  return (
    <Flex direction="column" justify="space-between" height="100%">
      <Flex.Item basis="50%">
        <FriendsList friends={friendsList} />
      </Flex.Item>
      <Divider />
      <Flex.Item basis="50%">
        <Section
          title="Public Devices"
          fill
          buttons={
            <Button
              icon="arrows-rotate"
              iconPosition="right"
              onClick={() => act('refresh_data')}
            >
              Refresh
            </Button>
          }
        >
          {(publicUsers.length && (
            <ContactsList contacts={publicUsers} showFriendReqBtn />
          )) || <Box>No devices detected on your local network.</Box>}
        </Section>
      </Flex.Item>
    </Flex>
  );
};

// Exported separately for use in the phone tab.
export const FriendsList = ({ friends }: { friends: User[] }) => {
  return (
    <Section title="Friends" fill>
      {(friends.length && <ContactsList contacts={friends} />) || (
        <Tooltip position="right" content=":(">
          <Box inline>Your friends list is empty.</Box>
        </Tooltip>
      )}
    </Section>
  );
};

const ContactsList = (props: ContactListProps) => {
  const { contacts, showFriendReqBtn } = props;
  return (
    <Stack vertical>
      {contacts.map((contact) => (
        // Todo: 'Add to contacts' button
        <Stack.Item key={contact.address} className="comm-contacts">
          <ContactListing
            contact={contact}
            showFriendReqBtn={showFriendReqBtn}
          />
        </Stack.Item>
      ))}
    </Stack>
  );
};

const ContactListing = (props: ContactListingProps, context) => {
  const { act, data } = useBackend<CommunicatorData>(context);
  const {
    contact,
    showFriendReqBtn,
  } = props;

  const [currentTab, setCurrentTab] = useLocalState(
    context,
    'tab',
    CommunicatorTab.Home,
  );
  const [targetAddress, setTargetAddress] = useLocalState(
    context,
    'tgtAddr',
    '',
  );

  const alreadyFriends = data.friendsList.find((friend) => friend.ref === contact.ref);
  const contactSentRequest = data.friendRequests.incoming.includes(contact.ref);
  const requestSentToContact = data.friendRequests.outgoing.includes(contact.ref);

  return (
    <Flex justify="space-between" m={0.25}>
      <Flex.Item
        align="center"
        textColor="label"
        style={{
          wordBreak: 'break-all',
        }}
      >
        <u>{contact.username}:</u>
      </Flex.Item>
      <Flex.Item>
        <Flex direction="column">
          <Flex.Item textAlign="right">{contact.address}</Flex.Item>
          <Flex.Item align="end">
            {showFriendReqBtn && (
              <Button
                icon="user-group"
                disabled={alreadyFriends || requestSentToContact}
                tooltip={
                  !alreadyFriends && contactSentRequest
                    ? 'Respond to Friend Request'
                    : 'Send Friend Request'
                }
                tooltipPosition="bottom"
                color={contactSentRequest && 'average'}
                onClick={() => {
                  act(
                    'friend_request',
                    { action: contactSentRequest ? 'respond' : 'send', selected_address: contact.address },
                  );
                }}
              />
            )}
            {/* Currently disabled because copying arbitrary strings to
                the user's clipboard seems like a bad idea.
            <Button
              icon="clipboard"
              tooltip="Copy address to clipboard"
              onClick={() => { navigator.clipboard.writeText(address); }}
              >
              Copy
            </Button>
            */}
            <Button
              icon="phone"
              tooltip="Send call invitation"
              tooltipPosition="bottom"
              onClick={() => {
                setTargetAddress(contact.address);
                setCurrentTab(CommunicatorTab.Phone);
              }}
            >
              Call
            </Button>
            <Button
              icon="comment-alt"
              tooltip="Send instant message"
              tooltipPosition="bottom"
            >
              Message
            </Button>
          </Flex.Item>
        </Flex>
      </Flex.Item>
    </Flex>
  );
};

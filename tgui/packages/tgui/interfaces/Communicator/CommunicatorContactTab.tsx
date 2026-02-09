import { useBackend } from '../../backend';
import { Box, Button, Divider, Flex, Section, Stack } from '../../components';
import { CommContact, ContactsTabData } from './types';

export const CommunicatorContactTab = (props, context) => {
  const { act, data } = useBackend<ContactsTabData>(context);
  const { friendsList, publicDevices } = data;

  return (
    <Flex direction="column" justify="space-between" height="100%" mx={1}>
      <Flex.Item basis="50%">
        <Section title="Contacts" fill>
          {(friendsList.length && <ContactsList commList={friendsList} />) || (
            <Box>no friends :(</Box> // placeholder
          )}
        </Section>
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
              onClick={() => {
                act('refresh_devices');
              }}
            >
              Refresh
            </Button>
          }
        >
          {(publicDevices.length && (
            <ContactsList commList={publicDevices} showFriendReq />
          )) || <Box>No devices detected on your local network.</Box>}
        </Section>
      </Flex.Item>
    </Flex>
  );
};

type ContactListProps = {
  commList: CommContact[];
  showFriendReq?: boolean;
};

const ContactsList = (props: ContactListProps) => {
  const { commList, showFriendReq } = props;
  return (
    <Stack vertical>
      {commList.map((contact) => (
        // Todo: 'Add to contacts' button
        <Stack.Item key={contact.address} className="comm-contacts">
          <ContactListing contact={contact} showFriendReq={showFriendReq} />
        </Stack.Item>
      ))}
    </Stack>
  );
};

type ContactListingProps = {
  contact: CommContact;
  showFriendReq?: boolean;
};

const ContactListing = (props: ContactListingProps, context) => {
  const { act, data } = useBackend<ContactsTabData>(context);
  const {
    contact: { address, name },
    showFriendReq,
  } = props;

  const alreadyFriends = data.friendsList.find(
    (friend) => friend.address === address,
  );
  const contactSentRequest = data.incomingFriendRequests.includes(address);
  const requestSentToContact = data.outgoingFriendRequests.includes(address);

  return (
    <Flex justify="space-between" m={0.25}>
      <Flex.Item
        align="center"
        textColor="label"
        style={{
          wordBreak: 'break-all',
        }}
      >
        <u>{name}:</u>
      </Flex.Item>
      <Flex.Item>
        <Flex direction="column">
          <Flex.Item textAlign="right">{address}</Flex.Item>
          <Flex.Item align="end">
            {showFriendReq && (
              <Button
                icon="user-group"
                disabled={alreadyFriends || requestSentToContact}
                tooltip={
                  !alreadyFriends && contactSentRequest
                    ? 'Respond to Friend Request'
                    : 'Send Friend Request'
                }
                tooltipPosition="bottom"
                className={contactSentRequest && 'friend-request'}
                onClick={() => {
                  act(
                    `friend_request_${contactSentRequest ? 'respond' : 'send'}`,
                    { selected_address: address },
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

import { useBackend } from '../../backend';
import {
  Box,
  Button,
  Divider,
  Flex,
  Section,
  Stack,
  Tooltip,
} from '../../components';
import { CommunicatorData, Contact } from './types';

export const CommunicatorContactTab = (props, context) => {
  const { act, data } = useBackend<CommunicatorData>(context);
  const { friendsList, allCommunicators } = data;

  const publicComms: Contact[] = allCommunicators
    .filter((comm) => comm.visible)
    .map((comm) => {
      return { address: comm.address, name: comm.ownerName };
    });

  return (
    <Flex direction="column" justify="space-between" height="100%" mx={1}>
      <Flex.Item basis="50%">
        <Section title="Friends" fill>
          {(friendsList.length && <ContactsList commList={friendsList} />) || (
            <Tooltip position="right" content=":(">
              <Box inline>Your friends list is empty.</Box>
            </Tooltip>
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
          {(publicComms.length && (
            <ContactsList commList={publicComms} showFriendReqBtn />
          )) || <Box>No devices detected on your local network.</Box>}
        </Section>
      </Flex.Item>
    </Flex>
  );
};

type ContactListProps = {
  commList: Contact[];
  showFriendReqBtn?: boolean;
};

const ContactsList = (props: ContactListProps) => {
  const { commList, showFriendReqBtn } = props;
  return (
    <Stack vertical>
      {commList.map((contact) => (
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

type ContactListingProps = {
  contact: Contact;
  showFriendReqBtn?: boolean;
};

const ContactListing = (props: ContactListingProps, context) => {
  const { act, data } = useBackend<CommunicatorData>(context);
  const {
    contact: { address, name },
    showFriendReqBtn,
  } = props;

  const alreadyFriends = data.friendsList.find(
    (friend) => friend.address === address,
  );
  const contactSentRequest = data.friendRequests.incoming.includes(address);
  const requestSentToContact = data.friendRequests.outgoing.includes(address);

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

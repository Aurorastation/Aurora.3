import { InfernoNode } from 'inferno';
import { useBackend, useLocalState } from '../../backend';
import {
  Box,
  Button,
  Divider,
  Flex,
  LabeledList,
  Section,
  Tooltip,
} from '../../components';
import { SortUsersByName, UserIsActive } from './helpers';
import { CommunicatorData, CommunicatorTab, UserDetails } from './types';

export const CommunicatorContactTab = (props, context) => {
  const { act, data } = useBackend<CommunicatorData>(context);
  const { allUsers } = data;

  const publicUsers = SortUsersByName(allUsers.filter((user) => user.visible));

  return (
    <Flex direction="column" justify="space-between" height="100%">
      <Flex.Item basis="50%">
        <FriendsList />
      </Flex.Item>
      <Divider />
      <Flex.Item basis="50%">
        <Section title="Public Devices" fill>
          {(publicUsers.length && (
            <LabeledList>
              {publicUsers.map((user) => (
                <ContactListing
                  key={user.address}
                  contact={user}
                  text={user.address}
                  ExtraButton={FriendReqButton}
                />
              ))}
            </LabeledList>
          )) || <Box>No devices detected on your local network.</Box>}
        </Section>
      </Flex.Item>
    </Flex>
  );
};

// Exported separately for use in the phone tab.
export const FriendsList = (props, context) => {
  const { act, data } = useBackend<CommunicatorData>(context);
  const { friendsList } = data;

  const allFriends = SortUsersByName(
    friendsList.missing.concat(friendsList.active),
  );

  return (
    <Section
      title="Friends"
      fill
      buttons={
        <Button
          icon="address-card"
          iconPosition="right"
          tooltip="Send a friend request manually to a known NTNet address"
          onClick={() => act('friend_request_manual')}
        >
          Add Address
        </Button>
      }
    >
      {(allFriends.length && (
        <LabeledList>
          {allFriends.map((friend) => (
            <ContactListing
              key={friend.address}
              contact={friend}
              text={
                UserIsActive(friend) ? (
                  friend.address
                ) : (
                  <Tooltip
                    content="Unable to locate user at address"
                    position="bottom-end"
                  >
                    <Box>
                      <Box inline bold color="bad">
                        ERROR:&nbsp;
                      </Box>
                      <Box inline style={{ 'text-decoration': 'line-through' }}>
                        {friend.address}
                      </Box>
                    </Box>
                  </Tooltip>
                )
              }
              ExtraButton={RemoveFriendButton}
            />
          ))}
        </LabeledList>
      )) || (
        <Tooltip position="right" content=":(">
          <Box inline>Your friends list is empty.</Box>
        </Tooltip>
      )}
    </Section>
  );
};

type ContactListingProps = {
  contact: UserDetails;
  text: InfernoNode;
  ExtraButton?: (props: { contact: UserDetails }, context) => JSX.Element;
};

const ContactListing = (
  { contact, text, ExtraButton }: ContactListingProps,
  context,
) => {
  const { act, data } = useBackend<CommunicatorData>(context);

  const [targetAddress, setTargetAddress] = useLocalState(
    context,
    'tgtAddr',
    '',
  );

  return (
    <LabeledList.Item
      key={contact.address}
      className="comm-contact"
      label={<u>{contact.username}:</u>}
      labelWrap
      verticalAlign="middle"
    >
      <Flex direction="column" minWidth="15em">
        <Flex.Item textAlign="right">{text}</Flex.Item>
        <Flex.Item align="end">
          {!!ExtraButton && <ExtraButton contact={contact} />}
          <Button
            icon="phone"
            tooltip="Send call request"
            tooltipPosition="bottom"
            disabled={
              !UserIsActive(contact) ||
              data.connectedCallers.includes(contact.address)
            }
            onClick={() => {
              setTargetAddress(contact.address);
              act('switch_tab', { new_tab: CommunicatorTab.Phone });
            }}
          >
            Call
          </Button>
          <Button
            icon="comment-alt"
            tooltip="Send instant message"
            tooltipPosition="bottom"
            disabled={!UserIsActive(contact)}
          >
            Message
          </Button>
        </Flex.Item>
      </Flex>
    </LabeledList.Item>
  );
};

const FriendReqButton = ({ contact }: { contact: UserDetails }, context) => {
  const { act, data } = useBackend<CommunicatorData>(context);

  const alreadyFriends = data.friendsList.active.find(
    (friend) => friend.username === contact.username,
  );
  const contactSentRequest = data.friendRequests.incoming.includes(
    contact.address,
  );
  const requestSentToContact = data.friendRequests.outgoing.includes(
    contact.address,
  );

  return (
    <Button
      icon="user-plus"
      disabled={alreadyFriends || requestSentToContact}
      tooltip={
        alreadyFriends
          ? 'Already friends!'
          : contactSentRequest
            ? 'Respond to friend request'
            : 'Send friend request'
      }
      tooltipPosition="bottom"
      color={contactSentRequest && 'average'}
      onClick={() => {
        act('friend_request', {
          action: contactSentRequest ? 'respond' : 'send',
          target_address: contact.address,
        });
      }}
    />
  );
};

const RemoveFriendButton = ({ contact }: { contact: UserDetails }, context) => {
  const { act, data } = useBackend<CommunicatorData>(context);

  return (
    <Button.Confirm
      icon="user-minus"
      color="bad"
      tooltip="Remove friend"
      onClick={() => {
        act('remove_friend', { friend_address: contact.address });
      }}
    />
  );
};

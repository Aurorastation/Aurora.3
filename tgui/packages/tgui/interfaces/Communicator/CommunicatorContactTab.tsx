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
import { CommunicatorData, CommunicatorTab, User } from './types';

export const CommunicatorContactTab = (props, context) => {
  const { act, data } = useBackend<CommunicatorData>(context);
  const { allUsers } = data;

  const publicUsers = allUsers.filter((user) => user.visible);

  return (
    <Flex direction="column" justify="space-between" height="100%">
      <Flex.Item basis="50%">
        <FriendsList />
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
            <LabeledList>
              {publicUsers.map((user) => (
                <ContactListing
                  key={user.address}
                  contact={user}
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
  const { friendsList, allUsers } = data;

  // `friendsList` is just a list of names. This goes through each of those
  // and returns either the person's corresponding `User` from `allUsers`,
  // or just their name again if they're not in that list.
  const friendsWithData = friendsList.map((friendName) => {
    return allUsers.find((user) => user.username === friendName) || friendName;
  });

  return (
    <Section title="Friends" fill>
      {(friendsWithData.length && (
        <LabeledList>
          {friendsWithData.map((friend) =>
            typeof friend === 'string' ? (
              <EmptyContactListing name={friend} />
            ) : (
              <ContactListing
                contact={friend}
                ExtraButton={RemoveFriendButton}
              />
            ),
          )}
        </LabeledList>
      )) || (
        <Tooltip position="right" content=":(">
          <Box inline>Your friends list is empty.</Box>
        </Tooltip>
      )}
    </Section>
  );
};

const EmptyContactListing = ({ name }: { name: string }) => {
  return (
    <LabeledList.Item
      className="comm-contact"
      label={<u>{name}</u>}
      verticalAlign="middle"
    />
  );
};

const ContactListing = (
  props: {
    contact: User;
    ExtraButton?: (props: { contact: User }, context) => JSX.Element;
  },
  context,
) => {
  const { contact, ExtraButton } = props;

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

  return (
    <LabeledList.Item
      className="comm-contact"
      label={<u>{contact.username}:</u>}
      verticalAlign="middle"
    >
      <Flex direction="column">
        <Flex.Item textAlign="right">{contact.address}</Flex.Item>
        <Flex.Item align="end">
          {!!ExtraButton && <ExtraButton contact={contact} />}
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
    </LabeledList.Item>
  );
};

const FriendReqButton = ({ contact }: { contact: User }, context) => {
  const { act, data } = useBackend<CommunicatorData>(context);

  const alreadyFriends = data.friendsList.find(
    (friendName) => friendName === contact.username,
  );
  const contactSentRequest = data.friendRequests.incoming.includes(contact.ref);
  const requestSentToContact = data.friendRequests.outgoing.includes(
    contact.ref,
  );

  return (
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
        act('friend_request', {
          action: contactSentRequest ? 'respond' : 'send',
          selected_address: contact.address,
        });
      }}
    />
  );
};

const RemoveFriendButton = ({ contact }: { contact: User }, context) => {
  const { act, data } = useBackend<CommunicatorData>(context);

  return (
    <Button.Confirm
      icon="xmark"
      color="bad"
      tooltip="Remove Friend"
      onClick={() => {
        act('remove_friend', { selected_name: contact.username });
      }}
    />
  );
};

import type { ReactNode } from 'react';
import {
  Box,
  Button,
  Divider,
  Flex,
  LabeledList,
  Section,
  Tooltip,
} from 'tgui-core/components';
import { useBackend, useLocalState } from '../../backend';
import { SortUsersByName, UserIsActive } from './helpers';
import { CommunicatorTab } from './types';
import type { CommunicatorData, UserDetails } from './types';

export const CommunicatorContactTab = () => {
  const { data } = useBackend<CommunicatorData>();
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
                  ExtraButton={AddContactButton}
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
export const FriendsList = () => {
  const { act, data } = useBackend<CommunicatorData>();
  const { friendsList } = data;

  const allFriends = SortUsersByName(
    friendsList.missing.concat(friendsList.active),
  );

  return (
    <Section
      title="Contacts"
      fill
      buttons={
        <Button
          icon="address-card"
          iconPosition="right"
          tooltip="Add a known communicator number, including an offline one"
          disabled={data.observer}
          onClick={() => act('add_contact_manual')}
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
                      <Box inline style={{ textDecoration: 'line-through' }}>
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
          <Box inline>Your contact list is empty.</Box>
        </Tooltip>
      )}
    </Section>
  );
};

type ContactListingProps = {
  contact: UserDetails;
  text: ReactNode;
  ExtraButton?: (props: { contact: UserDetails }) => ReactNode;
};

const ContactListing = ({ contact, text, ExtraButton }: ContactListingProps) => {
  const { act, data } = useBackend<CommunicatorData>();

  const [, setTargetAddress] = useLocalState<string>(
    'targetAddress',
    '',
  );
  const [selectedChatAddr, setSelectedChatAddr] = useLocalState<string | null>(
    'SelectedChatAddr',
    null,
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
              data.observer ||
              data.activeCall?.connectedComms.includes(contact.address)
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
            disabled={!UserIsActive(contact) || data.observer}
            onClick={() => {
              act('start_chat', { target_address: contact.address });
              setSelectedChatAddr(contact.address);
              act('switch_tab', { new_tab: CommunicatorTab.Messaging });
            }}
          >
            Message
          </Button>
        </Flex.Item>
      </Flex>
    </LabeledList.Item>
  );
};

const AddContactButton = ({ contact }: { contact: UserDetails }) => {
  const { act, data } = useBackend<CommunicatorData>();

  const alreadySaved = data.friendsList.active.find(
    (savedContact) => savedContact.address === contact.address,
  );

  return (
    <Button
      icon="user-plus"
      disabled={!!alreadySaved || data.observer}
      tooltip={alreadySaved ? 'Already in contacts' : 'Add to contacts'}
      tooltipPosition="bottom"
      onClick={() => {
        act('add_contact', { target_address: contact.address });
      }}
    />
  );
};

const RemoveFriendButton = ({ contact }: { contact: UserDetails }) => {
  const { act, data } = useBackend<CommunicatorData>();

  return (
    <Button.Confirm
      icon="user-minus"
      color="bad"
      tooltip="Remove contact"
      disabled={data.observer}
      onClick={() => {
        act('remove_friend', { friend_address: contact.address });
      }}
    />
  );
};

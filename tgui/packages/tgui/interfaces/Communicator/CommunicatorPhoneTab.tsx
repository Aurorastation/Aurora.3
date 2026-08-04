import { KEY } from 'tgui-core/keys';
import { classes } from 'tgui-core/react';
import {
  Box,
  Button,
  Divider,
  Flex,
  Input,
  Section,
  Stack,
} from 'tgui-core/components';
import { useBackend, useLocalState } from '../../backend';
import { FriendsList } from './CommunicatorContactTab';
import { FormatAddress, GetUserByAddress } from './helpers';
import { CommunicatorTab } from './types';
import type { CommunicatorData } from './types';

const MAX_ADDR_DIGITS = 16; // Four groups of four characters
const MAX_ADDR_COLONS = 3; // Three separators
const MAX_ADDRESS_LEN = MAX_ADDR_DIGITS + MAX_ADDR_COLONS;
const PHONE_KEYS = [
  '0',
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  'a',
  'b',
  'c',
  'd',
  'e',
  'f',
] as const;

export const CommunicatorPhoneTab = () => {
  const { act, data } = useBackend<CommunicatorData>();

  const [targetAddress, setTargetAddress] = useLocalState<string>(
    'targetAddress',
    '',
  );
  const [, setSelectedChatAddr] = useLocalState<string | null>(
    'SelectedChatAddr',
    null,
  );

  // Whether or not the `targetAddress` fully matches a user in `data.allUsers`.
  const targetAddrIsValid = !!GetUserByAddress(data, targetAddress);

  return (
    // TODO: Real styling to make this look better
    <Flex direction="column" justify="space-between" height="100%">
      <Flex.Item grow>
        <FriendsList />
      </Flex.Item>
      <Flex.Item>
        <Divider />
      </Flex.Item>
      <Flex.Item>
        <Section className="comm-address-input">
          <AutocompleteInput />
          <Flex height="100%" justify="space-evenly" wrap="wrap">
            {PHONE_KEYS.map((keyChar) => (
              <Flex.Item key={keyChar}>
                <Button
                  className="Button--rounded"
                  onClick={() => {
                    setTargetAddress(FormatAddress(targetAddress + keyChar));
                  }}
                >
                  {keyChar.toUpperCase()}
                </Button>
              </Flex.Item>
            ))}
          </Flex>
          <Stack className="action-buttons">
            <Stack.Item>
              <Button
                className="Button--wide"
                icon="phone"
                fluid
                disabled={!targetAddress || data.observer}
                color={targetAddrIsValid && 'green'}
                onClick={() => {
                  act('call_request', {
                    action: 'send',
                    target_address: targetAddress,
                  });
                  setTargetAddress('');
                }}
              >
                Call
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                className="Button--wide"
                icon="comment-alt"
                fluid
                disabled={!targetAddress || data.observer}
                color={targetAddrIsValid && 'green'}
                onClick={() => {
                  act('start_chat', { target_address: targetAddress });
                  setSelectedChatAddr(targetAddress);
                  act('switch_tab', {
                    new_tab: CommunicatorTab.Messaging,
                  });
                  setTargetAddress('');
                }}
              >
                Message
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                style={{ width: 'auto' }}
                icon="delete-left"
                disabled={!targetAddress}
                onClick={() =>
                  setTargetAddress(FormatAddress(targetAddress.slice(0, -1)))
                }
              />
            </Stack.Item>
          </Stack>
        </Section>
      </Flex.Item>
    </Flex>
  );
};

const AutocompleteInput = () => {
  const { data } = useBackend<CommunicatorData>();

  const [targetAddress, setTargetAddress] = useLocalState<string>(
    'targetAddress',
    '',
  );

  const [suggestedTargetIdx, setSuggestedTargetIdx] = useLocalState<number>(
    'suggestedTargetIdx',
    0,
  );

  const getMatchingUsers = (prefix: string) =>
    data.allUsers.filter(
      (user) => user.visible && user.address.startsWith(prefix),
    );

  // Users whose address starts with `targetAddress`. (if any)
  const possibleTargetUsers = getMatchingUsers(targetAddress);
  const suggestedTargetAddress =
    possibleTargetUsers[suggestedTargetIdx]?.address;

  return (
    <Box className="input-box">
      {targetAddress && suggestedTargetAddress && (
        <>
          <Box className="autocomplete address" preserveWhitespace>
            {// `suggestedTargetAddress` with `targetAddress` removed from
            //   the start of it. (fake autocomplete effect)
            suggestedTargetAddress
              ?.replace(targetAddress, '')
              .padStart(MAX_ADDRESS_LEN, ' ')}
          </Box>
          <Box
            className={classes([
              'autocomplete',
              'name',
              targetAddress === suggestedTargetAddress && 'completed',
            ])}
            // Set `targetAddress` to the suggested value when clicked.
            onClick={() => {
              // (Only clickable if the address hasn't already been completed)
              targetAddress !== suggestedTargetAddress &&
                setTargetAddress(suggestedTargetAddress);
            }}
          >
            {possibleTargetUsers[suggestedTargetIdx]?.username}
          </Box>
        </>
      )}
      <Input
        fluid
        monospace
        value={targetAddress}
        maxLength={MAX_ADDRESS_LEN}
        onKeyDown={(event) => {
          if (!suggestedTargetAddress) return;
          switch (event.key) {
            case KEY.Tab:
              // The `setTimeout` here is to bypass a bug where setting the
              // value state in `onKeyDown` doesn't update the input visually.
              // Apparently this is fixed in later React versions,
              // so test this in the future!
              setTimeout(() => {
                setTargetAddress(suggestedTargetAddress);
                setSuggestedTargetIdx(0);
              }, 0);
              break;
            // Up+Down arrow keys to switch between possible targets.
            // (Wrapping around to the other side at the limits)
            case KEY.Up:
              setSuggestedTargetIdx(
                (suggestedTargetIdx + possibleTargetUsers.length + 1) %
                  possibleTargetUsers.length,
              );
              event.preventDefault();
              break;
            case KEY.Down:
              setSuggestedTargetIdx(
                (suggestedTargetIdx + possibleTargetUsers.length - 1) %
                  possibleTargetUsers.length,
              );
              event.preventDefault();
              break;
          }
        }}
        // Every time this input has its value changed, format everything to
        // make sure that it stays address-ey.
        onChange={(value) => {
          const formattedValue = FormatAddress(value);
          setTargetAddress(formattedValue);

          // If the new value has less than 2 possible matches,
          // reset `suggestedTargetIdx` to avoid it going "out of bounds".
          getMatchingUsers(formattedValue).length < 2 &&
            setSuggestedTargetIdx(0);
        }}
        onEscape={() => {
          // This is just here to override the default Esc behaviour since
          // that breaks things.
        }}
      />
    </Box>
  );
};

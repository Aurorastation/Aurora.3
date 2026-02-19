import { classes } from 'common/react';
import { InfernoKeyboardEvent } from 'inferno';
import { KEY } from '../../../common/keys';
import { useBackend, useLocalState } from '../../backend';
import {
  Box,
  Button,
  Divider,
  Flex,
  Input,
  Section,
  Stack,
} from '../../components';
import { FriendsList } from './CommunicatorContactTab';
import { GetUserByAddress } from './helpers';
import { CommunicatorData } from './types';

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

function FormatAddress(newValue: string) {
  // Remove any characters not in `PHONE_KEYS`. (Including any colons)
  let formatted = newValue
    .toLowerCase()
    .replaceAll(RegExp(`[^${PHONE_KEYS.join('')}]`, 'g'), '');
  // Shorten to `MAX_ADDR_DIGITS`.
  formatted = formatted.slice(0, MAX_ADDR_DIGITS);

  // Split the string into groups of 1 to 4 alphanumeric characters.
  const groups = formatted.match(/\w{1,4}/g);
  if (!groups) {
    // This shouldn't happen, but if it does just return what we have so far.
    return formatted;
  }

  // Join each group with a colon.
  formatted = groups.join(':');
  return formatted;
}

export const CommunicatorPhoneTab = (props, context) => {
  const { act, data } = useBackend<CommunicatorData>(context);

  const [targetAddress, setTargetAddress] = useLocalState(
    context,
    'tgtAddr',
    '',
  );

  // A user whose address starts with `targetAddress`. (if one exists)
  const possibleTargetUser = data.allUsers.find(
    (user) => user.visible && user.address.startsWith(targetAddress),
  );
  const possibleTargetAddress = possibleTargetUser?.address;

  // Whether or not the `targetAddress` fully matches a user in `data.allUsers`.
  const targetAddrIsValid = !!GetUserByAddress(data, targetAddress);

  return (
    // TODO: Real styling to make this look better
    // TODO: Something somewhere showing outgoing call requests
    <Flex direction="column" justify="space-between" height="100%">
      <Flex.Item grow>
        <FriendsList />
      </Flex.Item>
      <Flex.Item>
        <Divider />
      </Flex.Item>
      <Flex.Item>
        <Section className="comm-address-input">
          <Box className="input-box">
            {targetAddress && possibleTargetAddress && (
              <>
                <Box className="autocomplete address" preserveWhitespace>
                  {/* `possibleTargetAddress` with `targetAddress` removed from
                      the start of it. (fake autocomplete effect) */}
                  {possibleTargetAddress
                    ?.replace(targetAddress, '')
                    .padStart(MAX_ADDRESS_LEN, ' ')}
                </Box>
                <Box
                  class={classes([
                    'autocomplete',
                    'name',
                    targetAddrIsValid && 'valid',
                  ])}
                  // Set `targetAddress` to the autocomplete value when clicked.
                  onClick={() => {
                    // (Only clickable if the address hasn't already been fully entered)
                    !targetAddrIsValid &&
                      setTargetAddress(possibleTargetAddress);
                  }}
                >
                  {possibleTargetUser.username}
                </Box>
              </>
            )}
            <Input
              fluid
              monospace
              value={targetAddress}
              maxLength={MAX_ADDRESS_LEN}
              // If there's an "autocomplete" address visible and the user pressed
              // tab, fill in the input box with the address.
              onKeyDown={(event: InfernoKeyboardEvent<HTMLInputElement>) => {
                if (possibleTargetAddress && event.key === KEY.Tab) {
                  // The `setTimeout` here is to bypass a bug where setting
                  // the value state in `onKeyDown` doesn't update the input visually.
                  // Apparently this is fixed in later React versions,
                  // so test this in the future!
                  setTimeout(() => setTargetAddress(possibleTargetAddress), 0);
                }
              }}
              // Every time this input has its value changed, format everything to
              // make sure that it stays address-ey.
              onInput={(
                event: InfernoKeyboardEvent<HTMLInputElement>,
                value: string,
              ) => {
                const formattedValue = FormatAddress(value);
                setTargetAddress(formattedValue);
                event.currentTarget.value = formattedValue;
              }}
              // This is just here to prevent the default Esc behaviour since
              // that breaks things.
              onEscape={() => {}}
            />
          </Box>
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
                disabled={!targetAddress}
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
                disabled={!targetAddress}
                color={targetAddrIsValid && 'green'}
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

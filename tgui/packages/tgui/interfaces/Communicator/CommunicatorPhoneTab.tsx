import { InfernoKeyboardEvent } from 'inferno';
import { useBackend, useLocalState } from '../../backend';
import { Button, Divider, Flex, Input, Section, Stack } from '../../components';
import { FriendsList } from './CommunicatorContactTab';
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
];

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
    // Can't do anything further, so just return it here.
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

  return (
    // TODO: Real styling to make this look better
    <Flex direction="column" justify="space-around" height="100%">
      <Flex.Item grow>
        <FriendsList friends={data.friendsList} />
      </Flex.Item>
      <Flex.Item>
        <Divider />
      </Flex.Item>
      <Flex.Item>
        <Section className="address-input">
          <Input
            fluid
            mb="0.5em"
            value={targetAddress}
            maxLength={MAX_ADDRESS_LEN}
            onInput={(
              event: InfernoKeyboardEvent<HTMLInputElement>,
              value: string,
            ) => {
              const formattedValue = FormatAddress(value);
              setTargetAddress(formattedValue);
              event.currentTarget.value = formattedValue;
            }}
          />
          <Flex className="keypad">
            {PHONE_KEYS.map((keyChar) => (
              <Flex.Item key={keyChar}>
                <Button
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
                icon="phone"
                fluid
                // color={} If address is valid, green. Else disabled
              >
                Call
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                icon="comment-alt"
                fluid
              >
                Message
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                style={{ "width": "auto" }}
                icon="delete-left"
                onClick={() => setTargetAddress(FormatAddress(targetAddress.slice(0, -1)))}
              />
            </Stack.Item>
          </Stack>
        </Section>
      </Flex.Item>
    </Flex>
  );
};

import { InfernoKeyboardEvent } from 'inferno';
import { useBackend, useLocalState } from '../../backend';
import { Button, Divider, Flex, Input, Section } from '../../components';
import { FriendsList } from './CommunicatorContactTab';
import { CommunicatorData } from './types';

const MAX_ADDR_ALPHANUM = 20;
const MAX_ADDR_COLONS = 4;
const MAX_ADDRESS_LEN = MAX_ADDR_ALPHANUM + MAX_ADDR_COLONS;
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
  // Remove any characters not in `PhoneKeys`. (Including any colons)
  let formatted = newValue
    .toLowerCase()
    .replaceAll(RegExp(`[^${PHONE_KEYS.join('')}]`, 'g'), '');
  // Shorten to `maxAddrAlphaNum`.
  formatted = formatted.slice(0, MAX_ADDR_ALPHANUM);

  // Split the string into groups of 1 to 4 non-whitespace characters.
  const groups = formatted.match(/\S{1,4}/g);
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
    <Flex direction="column" justify="space-between" height="100%">
      <Flex.Item grow>
        <FriendsList contacts={data.friendsList} />
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
              <Flex.Item key={keyChar} my={0.5}>
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
          <Flex className="call-buttons">
            <Flex.Item>
              <Button
                icon="phone"
                // color={} If address is valid, green. Else disabled
              >
                Call
              </Button>
            </Flex.Item>
            <Flex.Item>
              <Button icon="comment-alt">Message</Button>
            </Flex.Item>
          </Flex>
        </Section>
      </Flex.Item>
    </Flex>
  );
};

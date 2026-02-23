import { InfernoNode } from 'inferno';
import { useBackend } from '../../backend';
import { Box, Button, Flex, Icon, Stack } from '../../components';
import { GetUserByAddress } from './helpers';
import { CommunicatorData, CommunicatorTab } from './types';

export const CommunicatorCallTab = (props, context) => {
  const { act, data } = useBackend<CommunicatorData>(context);
  const { callDuration, connectedCallers, callRequests, userComm } = data;

  const activeCall = !!connectedCallers.length;
  const incomingCall = !!callRequests.incoming.length;
  const outgoingCall = !!callRequests.outgoing.length;

  // If either `userComm` is connecting to the call target,
  // or the call target is connecting to `userComm`.
  const connecting =
    userComm.connectingToAddr === callRequests.incoming[0] ||
    GetUserByAddress(data, callRequests.outgoing[0])?.connectingToAddr ===
      userComm.address;

  // Currently in an active call.
  if (activeCall) {
    return (
      <CallScreen
        name={connectedCallers
          .map((addr) => GetUserByAddress(data, addr)?.username)
          .join(' | ')}
        subtitle={callDuration}
        centerItem={<OptionButtons />}
        buttons={
          <Button
            icon="phone-slash"
            color="red"
            fontSize={2.5}
            onClick={() => act('end_call')}
          >
            End Call
          </Button>
        }
      />
    );
  }

  if (outgoingCall) {
    return (
      <CallScreen
        name={GetUserByAddress(data, callRequests.outgoing[0])?.username}
        subtitle="Calling..."
        centerItem={connecting && <ConnectingSpinner />}
        buttons={
          <Button
            icon="phone-slash"
            color="red"
            fontSize={2.5}
            onClick={() =>
              act('call_request', {
                action: 'cancel',
                target_address: callRequests.outgoing[0],
              })
            }
          >
            Cancel
          </Button>
        }
      />
    );
  }

  if (incomingCall) {
    return (
      <CallScreen
        name={GetUserByAddress(data, callRequests.incoming[0])?.username}
        subtitle="Incoming call"
        centerItem={connecting && <ConnectingSpinner />}
        buttons={
          <Stack justify="space-evenly">
            <Stack.Item grow>
              <Button
                fluid
                icon="phone-volume"
                color="green"
                fontSize={2}
                onClick={() =>
                  act('call_request', {
                    action: 'accept',
                    target_address: callRequests.incoming[0],
                  })
                }
              >
                Accept
              </Button>
            </Stack.Item>
            <Stack.Item grow>
              <Button
                fluid
                icon="phone-slash"
                color="red"
                fontSize={2}
                onClick={() =>
                  act('call_request', {
                    action: 'decline',
                    target_address: callRequests.incoming[0],
                  })
                }
              >
                Decline
              </Button>
            </Stack.Item>
          </Stack>
        }
      />
    );
  }

  return (
    <>
      <Box>Error: Something went very wrong :(</Box>
      <Box>please file a bug report</Box>
    </>
  );
};

const CallScreen = (
  props: {
    name?: string;
    subtitle: string;
    centerItem?: InfernoNode;
    buttons: InfernoNode;
  },
  context,
) => {
  const { name, subtitle, centerItem, buttons } = props;

  return (
    <Flex
      className="comm-call-screen"
      direction="column"
      justify="space-between"
      height="100%"
    >
      <Flex.Item>
        <Box className="caller-name">{name ?? '[UNKNOWN]'}</Box>
        <Box fontSize={1.5}>{subtitle}</Box>
      </Flex.Item>
      <Flex.Item>{centerItem}</Flex.Item>
      <Flex.Item>{buttons}</Flex.Item>
    </Flex>
  );
};

const OptionButtons = (props, context) => {
  const { act, data } = useBackend<CommunicatorData>(context);
  const { speakerphoneOn, microphoneOn } = data.callSettings;

  // TODO: Improve styling. These look pretty bad at the moment.
  return (
    <Flex className="option-buttons">
      <Flex.Item>
        <Button onClick={() => act('toggle_mute')}>
          <Icon
            name={microphoneOn ? 'microphone' : 'microphone-slash'}
            color={!microphoneOn && 'red'}
          />
        </Button>
        <Box>Mute</Box>
      </Flex.Item>
      <Flex.Item>
        <Button
          onClick={() => act('switch_tab', { new_tab: CommunicatorTab.Phone })}
        >
          <Icon name="hashtag" />
        </Button>
        <Box>Keypad</Box>
      </Flex.Item>
      <Flex.Item>
        <Button onClick={() => act('toggle_speakerphone')}>
          <Icon
            name={speakerphoneOn ? 'volume-high' : 'volume-xmark'}
            color={!speakerphoneOn && 'red'}
          />
        </Button>
        <Box>Speaker</Box>
      </Flex.Item>
      <Flex.Item>
        <Button
          onClick={() =>
            act('switch_tab', { new_tab: CommunicatorTab.Contacts })
          }
        >
          <Icon name="user-plus" />
        </Button>
        <Box>Add To Call</Box>
      </Flex.Item>
      <Flex.Item>
        <Button>
          <Icon name="video" />
        </Button>
        <Box>Video</Box>
      </Flex.Item>
      <Flex.Item>
        <Button>
          <Icon name="address-book" />
        </Button>
        <Box>Placeholder</Box>
      </Flex.Item>
    </Flex>
  );
};

const ConnectingSpinner = (props, context) => {
  const { act, data } = useBackend<CommunicatorData>(context);
  const { callRequests, userComm } = data;

  const connectingAddress =
    userComm.connectingToAddr || callRequests.outgoing[0];

  return (
    <Flex direction="column" justify="space-around">
      <Flex.Item mb={5} fontSize={1.5}>
        <Box>Connecting to</Box>
        <Box>{connectingAddress}</Box>
      </Flex.Item>
      <Flex.Item>
        <Icon name="spinner" spin size={8} />
      </Flex.Item>
    </Flex>
  );
};

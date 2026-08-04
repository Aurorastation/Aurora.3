import type { ReactNode } from 'react';
import { Box, Button, Flex, Icon, Stack } from 'tgui-core/components';
import { useBackend } from '../../backend';
import { GetUserByAddress } from './helpers';
import { CommunicatorTab } from './types';
import type { CommunicatorData } from './types';

export const CommunicatorCallTab = () => {
  const { act, data } = useBackend<CommunicatorData>();
  const { activeCall, callRequests, userComm } = data;

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
        name={activeCall.connectedComms
          .filter((addr) => addr !== userComm.address)
          .map((addr) => GetUserByAddress(data, addr)?.username)
          .join(', ')}
        subtitle={activeCall.duration}
        centerItem={<OptionButtons />}
        buttons={
          <Button
            icon="phone-slash"
            color="red"
            fontSize={2.5}
            disabled={data.observer}
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
            disabled={data.observer}
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
                disabled={data.observer}
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
                disabled={data.observer}
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
    centerItem?: ReactNode;
    buttons: ReactNode;
  },
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

const OptionButtons = () => {
  const { act, data } = useBackend<CommunicatorData>();
  const {
    speakerphoneOn,
    microphoneOn,
    videoOn,
    hologramOn,
    canVideo,
    canHologram,
  } = data.callSettings;

  // TODO: Improve styling. These look pretty bad at the moment.
  return (
    <Flex className="option-buttons">
      <Flex.Item>
        <Button
          disabled={data.observer}
          selected={!microphoneOn}
          onClick={() => act('toggle_mute')}
        >
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
        <Button
          disabled={data.observer}
          selected={speakerphoneOn}
          onClick={() => act('toggle_speakerphone')}
        >
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
        <Button
          disabled={!canVideo || data.observer}
          selected={videoOn}
          onClick={() => act('toggle_video')}
        >
          <Icon name={videoOn ? 'video' : 'video-slash'} />
        </Button>
        <Box>Video</Box>
      </Flex.Item>
      <Flex.Item>
        <Button
          disabled={!canHologram || data.observer}
          selected={hologramOn}
          onClick={() => act('toggle_hologram')}
        >
          <Icon name="person-rays" />
        </Button>
        <Box>Hologram</Box>
      </Flex.Item>
    </Flex>
  );
};

const ConnectingSpinner = () => {
  const { data } = useBackend<CommunicatorData>();
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

import { InfernoNode } from 'inferno';
import { useBackend } from '../../backend';
import { Box, Button, Flex, Icon, Stack } from '../../components';
import { CommunicatorData, CommunicatorTab } from './types';

export const CommunicatorCallTab = (props, context) => {
  const { act, data } = useBackend<CommunicatorData>(context);
  const { callDuration, connectedCallers, callRequests } = data;

  const activeCall = !!data.connectedCallers.length;
  const outgoingCall = !!data.callRequests.outgoing.length;
  const incomingCall = !!data.callRequests.incoming.length;

  if (activeCall) {
    return (
      <CallScreen
        name={connectedCallers.join(' | ')}
        subtitle={callDuration}
        showOptions
        buttons={
          <Button
            icon="phone-slash"
            color="red"
            fontSize={2.5}
            onClick={() => {
              act('end_call');
              act('switch_tab', { new_tab: CommunicatorTab.Home });
            }}
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
        name={
          data.allUsers.find(
            (user) => user.address === callRequests.outgoing[0],
          )?.username
        }
        subtitle="Calling..."
        buttons={
          <Button
            icon="phone-slash"
            color="red"
            fontSize={2.5}
            onClick={() => {
              act('call_request', {
                action: 'cancel',
                target_address: callRequests.outgoing[0],
              });
              act('switch_tab', { new_tab: CommunicatorTab.Home });
            }}
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
        name={
          data.allUsers.find(
            (user) => user.address === callRequests.incoming[0],
          )?.username
        }
        subtitle="<--Incoming call-->"
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
                onClick={() => {
                  act('call_request', {
                    action: 'decline',
                    target_address: callRequests.incoming[0],
                  });
                  act('switch_tab', { new_tab: CommunicatorTab.Home });
                }}
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
    showOptions?: boolean;
    buttons: InfernoNode;
  },
  context,
) => {
  const { name, subtitle, showOptions, buttons } = props;

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
      <Flex.Item>{showOptions && <OptionButtons />}</Flex.Item>
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
        <Button>
          <Icon name="phone" />
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
        <Button
          onClick={() =>
            act('switch_tab', { new_tab: CommunicatorTab.Contacts })
          }
        >
          <Icon name="address-book" />
        </Button>
        <Box>Contacts</Box>
      </Flex.Item>
    </Flex>
  );
};

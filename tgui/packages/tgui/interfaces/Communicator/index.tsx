import { useBackend } from '../../backend';
import { NtosWindow } from '../../layouts';
import { Box, Button, Flex, Icon, Section, Stack } from 'tgui-core/components';
import { CommunicatorCallTab } from './CommunicatorCallTab';
import { CommunicatorContactTab } from './CommunicatorContactTab';
import { CommunicatorHomeTab } from './CommunicatorHomeTab';
import { CommunicatorMessagesTab } from './CommunicatorMessagesTab';
import { CommunicatorPhoneTab } from './CommunicatorPhoneTab';
import { CommunicatorSettingsTab } from './CommunicatorSettingsTab';
import { GetUserByAddress } from './helpers';
import { CommunicatorTab } from './types';
import type { ReactNode } from 'react';
import type { CommunicatorData } from './types';

export const Communicator = () => {
  const { data } = useBackend<CommunicatorData>();

  return (
    <NtosWindow width={475} height={700}>
      <NtosWindow.Content fitted>
        {data.noID ? <NoIDScreen /> : <NormalScreen />}
      </NtosWindow.Content>
    </NtosWindow>
  );
};

const NormalScreen = () => {
  const { act, data } = useBackend<CommunicatorData>();

  const tabs: { [tab in CommunicatorTab]: ReactNode } = {
    [CommunicatorTab.Home]: <CommunicatorHomeTab />,
    [CommunicatorTab.Phone]: <CommunicatorPhoneTab />,
    [CommunicatorTab.Contacts]: <CommunicatorContactTab />,
    [CommunicatorTab.Messaging]: <CommunicatorMessagesTab />,
    [CommunicatorTab.Settings]: <CommunicatorSettingsTab />,
    [CommunicatorTab.ActiveCall]: <CommunicatorCallTab />,
  };

  return (
    <Flex height="100%" mt={2} direction="column" justify="space-between">
      {!!data.featureRequests.length && (
        <Section title={`${data.featureRequests[0].feature === 'video' ? 'Video' : 'Hologram'} request`}>
          <Stack align="center">
            <Stack.Item grow>
              {GetUserByAddress(data, data.featureRequests[0].address)?.username ?? '[UNKNOWN]'} wants to enable {data.featureRequests[0].feature}.
            </Stack.Item>
            <Stack.Item><Button color="green" icon="check" onClick={() => act('feature_request', { action: 'accept', target_address: data.featureRequests[0].address, feature: data.featureRequests[0].feature })}>Approve</Button></Stack.Item>
            <Stack.Item><Button color="red" icon="xmark" onClick={() => act('feature_request', { action: 'decline', target_address: data.featureRequests[0].address, feature: data.featureRequests[0].feature })}>Deny</Button></Stack.Item>
          </Stack>
        </Section>
      )}
      <Flex.Item grow>{tabs[data.currentTab]}</Flex.Item>
      <Flex.Item mb={2}>
        <Section>
          <FooterButtons />
        </Section>
      </Flex.Item>
    </Flex>
  );
};

const FooterButtons = () => {
  const { act, data } = useBackend<CommunicatorData>();

  const activeCall = !!data.activeCall;
  const incomingCall = !!data.callRequests.incoming.length;
  const outgoingCall = !!data.callRequests.outgoing.length;
  const showPhoneButton =
    data.currentTab !== CommunicatorTab.ActiveCall &&
    (activeCall || incomingCall || outgoingCall);

  return (
    <Stack className="comm-footer-buttons" fill px={4}>
      <Stack.Item grow>
        <Button
          fluid
          onClick={() => act('switch_tab', { new_tab: CommunicatorTab.Home })}
        >
          <Icon name="home" />
        </Button>
      </Stack.Item>
      {showPhoneButton && (
        <Stack.Item basis="20%">
          <Button
            fluid
            onClick={() =>
              act('switch_tab', { new_tab: CommunicatorTab.ActiveCall })
            }
          >
            <Icon
              name="phone"
              color={activeCall ? 'green' : 'gold'} // Todo: make this flash/glow if there's an incoming call
            />
          </Button>
        </Stack.Item>
      )}
    </Stack>
  );
};

const NoIDScreen = () => {
  return (
    <Flex height="100%" direction="column" justify="center" align="center">
      <Flex.Item position="absolute" top="10%">
        <Icon name="face-smile" size={10} /* logo goes here */ />
      </Flex.Item>
      <Flex.Item textAlign="center" fontSize={1.5}>
        <Box>Thank you for choosing your Communicator.</Box>
        <Box>Please swipe your identification card to continue.</Box>
      </Flex.Item>
    </Flex>
  );
};

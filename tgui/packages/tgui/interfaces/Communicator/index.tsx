import { useBackend } from '../../backend';
import { Box, Button, Flex, Icon, Section, Stack } from '../../components';
import { NtosWindow } from '../../layouts';
import { CommunicatorCallTab } from './CommunicatorCallTab';
import { CommunicatorContactTab } from './CommunicatorContactTab';
import { CommunicatorHomeTab } from './CommunicatorHomeTab';
import { CommunicatorPhoneTab } from './CommunicatorPhoneTab';
import { CommunicatorSettingsTab } from './CommunicatorSettingsTab';
import { CommunicatorData, CommunicatorTab } from './types';

export const Communicator = (props, context) => {
  const { act, data } = useBackend<CommunicatorData>(context);

  return (
    <NtosWindow width={475} height={700}>
      <NtosWindow.Content fitted>
        {data.noID ? <NoIDScreen /> : <NormalScreen />}
      </NtosWindow.Content>
    </NtosWindow>
  );
};

const NormalScreen = (props, context) => {
  const { act, data } = useBackend<CommunicatorData>(context);

  const tabs: { [tab in CommunicatorTab]: JSX.Element } = {
    [CommunicatorTab.Home]: <CommunicatorHomeTab />,
    [CommunicatorTab.Phone]: <CommunicatorPhoneTab />,
    [CommunicatorTab.Contacts]: <CommunicatorContactTab />,
    [CommunicatorTab.Messaging]: <CommunicatorHomeTab />, // todo
    [CommunicatorTab.Settings]: <CommunicatorSettingsTab />,
    [CommunicatorTab.ActiveCall]: <CommunicatorCallTab />,
  };

  return (
    <Flex height="100%" mt={2} direction="column" justify="space-between">
      <Flex.Item grow>{tabs[data.currentTab]}</Flex.Item>
      <Flex.Item mb={2}>
        <Section>
          <FooterButtons />
        </Section>
      </Flex.Item>
    </Flex>
  );
};

const FooterButtons = (props, context) => {
  const { act, data } = useBackend<CommunicatorData>(context);

  const activeCall = !!data.connectedCallers.length;
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
        <Box>Thank you for chosing the (corp name) Communicator®.</Box>
        <Box>Please register your identification card to continue.</Box>
      </Flex.Item>
    </Flex>
  );
};

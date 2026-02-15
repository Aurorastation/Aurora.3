import { useBackend, useLocalState } from '../../backend';
import { Box, Button, Flex, Icon, Section } from '../../components';
import { NtosWindow } from '../../layouts';
import { CommunicatorContactTab } from './CommunicatorContactTab';
import { CommunicatorHomeTab } from './CommunicatorHomeTab';
import { CommunicatorPhoneTab } from './CommunicatorPhoneTab';
import { CommunicatorData, CommunicatorTab } from './types';

export const Communicator = (props, context) => {
  const { act, data } = useBackend<CommunicatorData>(context);

  return (
    <NtosWindow width={475} height={700}>
      <NtosWindow.Content fitted>
        {data.user ? <NormalScreen /> : <NoIDScreen />}
      </NtosWindow.Content>
    </NtosWindow>
  );
};

const NormalScreen = (props, context) => {
  const [currentTab, setCurrentTab] = useLocalState(
    context,
    'tab',
    CommunicatorTab.Home,
  );

  const tabs: { [tab in CommunicatorTab]: JSX.Element } = {
    [CommunicatorTab.Home]: <CommunicatorHomeTab />,
    [CommunicatorTab.Phone]: <CommunicatorPhoneTab />,
    [CommunicatorTab.Contacts]: <CommunicatorContactTab />,
    [CommunicatorTab.Messaging]: <CommunicatorHomeTab />, // todo
    [CommunicatorTab.Settings]: <CommunicatorHomeTab />, // todo
  };

  return (
    <Flex height="100%" mt={2} direction="column" justify="space-between">
      <Flex.Item grow>{tabs[currentTab]}</Flex.Item>
      <Flex.Item mb={2}>
        <Section>
          <Button
            fluid
            p={1}
            mx={5}
            textAlign="center"
            style={{ 'border-radius': '10px' }}
            onClick={() => setCurrentTab(CommunicatorTab.Home)}
          >
            <Icon name="home" size={2} m="auto" />
          </Button>
        </Section>
      </Flex.Item>
    </Flex>
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

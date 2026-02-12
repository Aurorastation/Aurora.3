import { useLocalState } from '../../backend';
import { Button, Flex, Icon, Section } from '../../components';
import { NtosWindow } from '../../layouts';
import { CommunicatorContactTab } from './CommunicatorContactTab';
import { CommunicatorHomeTab } from './CommunicatorHomeTab';
import { CommunicatorPhoneTab } from './CommunicatorPhoneTab';
import { CommunicatorTab } from './types';

export const Communicator = (props, context) => {
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
    <NtosWindow width={475} height={700}>
      <NtosWindow.Content fitted>
        <Flex height="100%" mt={2} direction="column" justify="space-between">
          <Flex.Item>{tabs[currentTab]}</Flex.Item>
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
      </NtosWindow.Content>
    </NtosWindow>
  );
};

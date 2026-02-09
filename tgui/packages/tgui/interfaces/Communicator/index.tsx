import { useBackend, useLocalState } from '../../backend';
import { Flex } from '../../components';
import { Window } from '../../layouts';
import { CommunicatorContactTab } from './CommunicatorContactTab';
import { CommunicatorFooter, CommunicatorHeader } from './CommunicatorGeneral';
import { CommunicatorHomeTab } from './CommunicatorHomeTab';
import { CommunicatorData, CommunicatorTab } from './types';

export const Communicator = (props, context) => {
  const { data } = useBackend<CommunicatorData>(context);

  const [currentTab, setCurrentTab] = useLocalState(
    context,
    'tab',
    CommunicatorTab.Home,
  );

  const tabs: { [tab in CommunicatorTab]: JSX.Element } = {
    [CommunicatorTab.Home]: <CommunicatorHomeTab />,
    [CommunicatorTab.Phone]: <CommunicatorHomeTab />,
    [CommunicatorTab.Contacts]: <CommunicatorContactTab />,
    [CommunicatorTab.Messaging]: <CommunicatorHomeTab />,
    [CommunicatorTab.Settings]: <CommunicatorHomeTab />,
  };

  return (
    <Window width={475} height={700}>
      <Window.Content>
        <Flex height="100%" direction="column" justify="space-between">
          <Flex.Item mb={2}>
            <CommunicatorHeader />
          </Flex.Item>
          <Flex.Item grow>{tabs[currentTab]}</Flex.Item>
          <Flex.Item>
            <CommunicatorFooter />
          </Flex.Item>
        </Flex>
      </Window.Content>
    </Window>
  );
};

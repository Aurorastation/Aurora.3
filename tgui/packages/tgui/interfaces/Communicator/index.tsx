import { useBackend, useLocalState } from "../../backend";
import { Flex } from "../../components";
import { Window } from "../../layouts";
import { CommunicatorFooter, CommunicatorHeader } from "./CommunicatorGeneral";
import { CommunicatorHomeTab } from "./CommunicatorHomeTab";
import { CommunicatorData, CommunicatorTab } from "./types";

export const Communicator = (props, context) => {
  const { data } = useBackend<CommunicatorData>(context);

  const [currentTab, setCurrentTab] = useLocalState(context, 'tab', CommunicatorTab.Home);

  return (
    <Window width={475} height={700}>
      <Window.Content>
        <Flex height="100%" direction="column" justify="space-between">
          <Flex.Item>
            <CommunicatorHeader />
          </Flex.Item>
          <Flex.Item grow>
            {currentTab}
            <CommunicatorHomeTab />
          </Flex.Item>
          <Flex.Item>
            <CommunicatorFooter />
          </Flex.Item>
        </Flex>
      </Window.Content>
    </Window>
  );
};

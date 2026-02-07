import { useBackend, useLocalState } from "../../backend";
import { Button, Icon, Section, Stack } from "../../components";
import { CommunicatorData, CommunicatorTab } from "./types";


export const CommunicatorHeader = (props, context) => {
  const { data } = useBackend<CommunicatorData>(context);
  const { time, connectionStatus, ownerName, ownerOccupation } = data;

  return (
    <Section>
      <Stack align="center" justify="space-between">
        <Stack.Item color="average">{time}</Stack.Item>
        <Stack.Item>
          <Icon
            color={connectionStatus ? 'good' : 'bad'}
            name={connectionStatus ? 'signal' : 'exclamation-triangle'}
          />
        </Stack.Item>
        <Stack.Item color="average">{ownerName}</Stack.Item>
        <Stack.Item color="average">{ownerOccupation}</Stack.Item>
      </Stack>
    </Section>
  );
};

export const CommunicatorFooter = (props, context) => {
  const { act, data } = useBackend<CommunicatorData>(context);
  const { flashlightOn } = data;

  const [currentTab, setCurrentTab] = useLocalState(context, 'tab', CommunicatorTab.Home);

  return (
    <Stack>
      <Stack.Item basis='80%'>
        <Button
          fluid
          icon="home"
          p={1}
          textAlign="center"
          onClick={() => setCurrentTab(CommunicatorTab.Home)}
        />
      </Stack.Item>
      <Stack.Item basis="20%">
        <Button
          fluid
          icon="lightbulb"
          p={1}
          selected={flashlightOn}
          textAlign="center"
          tooltip="Flashlight"
          tooltipPosition="top"
          onClick={() => act('toggle_flashlight')}
        />
      </Stack.Item>
    </Stack>
  );
};

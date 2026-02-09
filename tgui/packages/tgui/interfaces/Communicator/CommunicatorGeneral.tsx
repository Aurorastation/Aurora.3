import { useBackend, useLocalState } from '../../backend';
import { Box, Button, Icon, Section, Stack } from '../../components';
import { CommunicatorData, CommunicatorTab } from './types';

export const CommunicatorHeader = (props, context) => {
  const { data } = useBackend<CommunicatorData>(context);
  const { time, connectionStatus, ownerName, ownerOccupation } = data;

  return (
    <Section>
      <Stack align="center" justify="space-between" color="average">
        <Stack.Item>{time}</Stack.Item>
        <Stack.Item>
          <Icon
            color={connectionStatus ? 'good' : 'bad'}
            name={connectionStatus ? 'signal' : 'exclamation-triangle'}
          />
        </Stack.Item>
        <Stack.Item>{ownerName}</Stack.Item>
        <Stack.Item>
          {ownerOccupation || <Box color="bad">Swipe ID to set.</Box>}
        </Stack.Item>
      </Stack>
    </Section>
  );
};

export const CommunicatorFooter = (props, context) => {
  const { act, data } = useBackend<CommunicatorData>(context);
  const { flashlightOn } = data;

  const [currentTab, setCurrentTab] = useLocalState(
    context,
    'tab',
    CommunicatorTab.Home,
  );

  return (
    <Stack>
      <Stack.Item basis="80%">
        <Button
          fluid
          p={1}
          // todo: icon size
          textAlign="center"
          onClick={() => setCurrentTab(CommunicatorTab.Home)}
        >
          <Icon name="home" size={2} m="auto" />
        </Button>
      </Stack.Item>
      <Stack.Item basis="20%">
        <Button
          fluid
          p={1}
          selected={flashlightOn}
          textAlign="center"
          tooltip="Flashlight"
          tooltipPosition="top"
          onClick={() => act('toggle_flashlight')}
        >
          <Icon name="lightbulb" size={2} m="auto" />
        </Button>
      </Stack.Item>
    </Stack>
  );
};

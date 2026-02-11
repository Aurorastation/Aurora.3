import { useBackend, useLocalState } from '../../backend';
import { Box, Button, Icon, Stack } from '../../components';
import { Apps, CommunicatorData, CommunicatorTab } from './types';

export const CommunicatorHomeTab = (props, context) => {
  const { act, data } = useBackend<CommunicatorData>(context);

  const [currentTab, setCurrentTab] = useLocalState(
    context,
    'tab',
    CommunicatorTab.Home,
  );

  return (
    <Stack mt={2} wrap="wrap" align="center" justify="center">
      {Apps.map((app) => (
        <Stack.Item basis="25%" textAlign="center" m={0} key={app.name}>
          <Button
            style={{
              borderRadius: '10%',
              border: '1px solid #000',
            }}
            width="64px"
            height="64px"
            lineHeight="64px"
            onClick={() => setCurrentTab(app.tab)}
          >
            <Icon
              // todo: spin + colour
              name={app.icon}
              size={3}
              mx="auto"
              mb="3px"
              style={{ 'vertical-align': 'middle' }}
            />
          </Button>
          <Box>{app.name}</Box>
        </Stack.Item>
      ))}
    </Stack>
  );
};

import { useBackend } from '../../backend';
import { Box, Button, Icon, Stack } from 'tgui-core/components';
import { Apps, type CommunicatorData } from './types';

export const CommunicatorHomeTab = () => {
  const { act } = useBackend<CommunicatorData>();

  return (
    <Stack
      mt={2}
      wrap="wrap"
      align="center"
      justify="center"
      textAlign="center"
    >
      {Apps.map((app) => (
        <Stack.Item basis="25%" m={0} key={app.name}>
          <Button
            style={{
              borderRadius: '10%',
              border: '1px solid black',
            }}
            width="64px"
            height="64px"
            lineHeight="64px"
            onClick={() => act('switch_tab', { new_tab: app.tab })}
          >
            <Icon
              // todo: spin + colour
              name={app.icon}
              size={2.5}
              mx="auto"
              mb="4px"
              style={{ verticalAlign: 'middle' }}
            />
          </Button>
          <Box>{app.name}</Box>
        </Stack.Item>
      ))}
    </Stack>
  );
};

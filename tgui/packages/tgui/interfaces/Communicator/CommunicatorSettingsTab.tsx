import { useBackend } from '../../backend';
import { Box, Button, LabeledList, Section, Stack } from '../../components';
import { CommunicatorData } from './types';

export const CommunicatorSettingsTab = (props, context) => {
  const { act, data } = useBackend<CommunicatorData>(context);
  const { userComm, silent } = data;

  return (
    <Section title="Settings">
      <LabeledList>
        <LabeledList.Item label="Display Name">
          <Button.Input
            fluid
            content={userComm.username}
            currentValue={userComm.username}
            defaultValue="__reset" // this is weird but it works
            onCommit={(_, value) => act('set_username', { new_name: value })}
          />
        </LabeledList.Item>
        <LabeledList.Item label="NTNet Address">
          {userComm.address}
        </LabeledList.Item>
        <LabeledList.Item label="NTNet Visibility">
          <Button.Checkbox
            fluid
            checked={userComm.visible}
            selected={userComm.visible}
            onClick={() => act('toggle_visibility')}
          >
            {userComm.visible
              ? 'Visible to other devices'
              : 'Invisible to other devices'}
          </Button.Checkbox>
        </LabeledList.Item>
        <LabeledList.Divider />
        <LabeledList.Item label="Notifications">
          <Button.Checkbox
            fluid
            checked={!silent}
            selected={!silent}
            onClick={() => act('toggle_silent')}
          >
            {silent ? 'Notifications off' : 'Notifications on'}
          </Button.Checkbox>
        </LabeledList.Item>
        <LabeledList.Divider />
        <LabeledList.Item
          label="Reset Device"
          labelColor="bad"
          verticalAlign="middle"
        >
          <Stack vertical>
            <Stack.Item>
              <Box color="label">
                Unregister your ID and remove any communications history on this
                device.
              </Box>
            </Stack.Item>
            <Stack.Item>
              <Button.Confirm
                fluid
                bold
                content="Confirm"
                confirmContent="Are you sure?"
                onClick={() => act('reset_device')}
              />
            </Stack.Item>
          </Stack>
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

import {
  Box,
  Button,
  Divider,
  Flex,
  LabeledList,
  Section,
  Stack,
  Tabs,
} from 'tgui-core/components';
import { useBackend, useLocalState } from '../../backend';
import type { CommunicatorData, RequestsList } from './types';

export const CommunicatorSettingsTab = () => {
  const { act, data } = useBackend<CommunicatorData>();
  const { userComm, silent, callRequests, friendRequests } = data;

  return (
    <Section title="Settings">
      <LabeledList>
        <LabeledList.Item label="Display Name">
          <Button.Input
            fluid
            value={userComm.username}
            disabled={data.observer}
            onCommit={(value) => act('set_username', { new_name: value })}
          />
        </LabeledList.Item>
        <LabeledList.Item label="NTNet Address">
          {userComm.address}
        </LabeledList.Item>
        <LabeledList.Item label="Device Tier">
          {data.deviceTierName}
        </LabeledList.Item>
        <LabeledList.Item label="NTNet Visibility">
          <Button.Checkbox
            fluid
            checked={userComm.visible}
            selected={userComm.visible}
            disabled={data.observer}
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
            disabled={data.observer}
            onClick={() => act('toggle_silent')}
          >
            {silent ? 'Notifications off' : 'Notifications on'}
          </Button.Checkbox>
        </LabeledList.Item>
        <LabeledList.Divider />
        <LabeledList.Item label="Requests">
          <RequestsTable />
        </LabeledList.Item>
        {!!data.canReset && (
          <>
            <LabeledList.Divider />
            <LabeledList.Item
              label="Reset Device"
              labelColor="bad"
              verticalAlign="middle"
            >
              <Stack vertical>
                <Stack.Item>
                  <Box color="label">
                    Unregister your ID and remove contacts and communications
                    history on this device.
                  </Box>
                </Stack.Item>
                <Stack.Item>
                  <Button.Confirm
                    fluid
                    bold
                    disabled={data.observer}
                    content="Confirm"
                    confirmContent="Are you sure?"
                    onClick={() => act('reset_device')}
                  />
                </Stack.Item>
              </Stack>
            </LabeledList.Item>
          </>
        )}
      </LabeledList>
    </Section>
  );
};

const RequestsTable = () => {
  const { data } = useBackend<CommunicatorData>();
  const { callRequests, friendRequests } = data;

  enum RequestsTab {
    Incoming,
    Outgoing,
  }

  const [requestsTab, setRequestsTab] = useLocalState<RequestsTab>(
    'requestsTab',
    RequestsTab.Incoming,
  );

  const Header = (props: { text: string }) => {
    return (
      <Flex.Item basis="50%">
        <Stack vertical>
          <Stack.Item>{props.text}</Stack.Item>
          <Stack.Divider align="center" width="75%" />
        </Stack>
      </Flex.Item>
    );
  };

  const AddressList = (props: { category: RequestsList }) => {
    const addresses =
      requestsTab === RequestsTab.Incoming
        ? props.category.incoming
        : props.category.outgoing;

    return (
      <Flex.Item grow>
        <Stack vertical fontSize="97%">
          {addresses.length ? (
            addresses.map((address) => (
              <Stack.Item key={address}>{address}</Stack.Item>
            ))
          ) : (
            <Stack.Item>No requests!</Stack.Item>
          )}
        </Stack>
      </Flex.Item>
    );
  };

  return (
    <Box backgroundColor="rgba(0, 0, 0, 0.5)">
      <Tabs fluid mx={0}>
        <Tabs.Tab
          selected={requestsTab === RequestsTab.Incoming}
          onClick={() => setRequestsTab(RequestsTab.Incoming)}
        >
          Incoming
        </Tabs.Tab>
        <Tabs.Tab
          selected={requestsTab === RequestsTab.Outgoing}
          onClick={() => setRequestsTab(RequestsTab.Outgoing)}
        >
          Outgoing
        </Tabs.Tab>
      </Tabs>
      <Flex direction="column" textAlign="center">
        <Flex.Item bold color="label" mr="16px">
          <Flex>
            <Header text="Friend Requests" />
            <Header text="Call Requests" />
          </Flex>
        </Flex.Item>
        <Flex.Item mt="4px" height="10em" overflowY="scroll">
          <Flex justify="space-between" height="100%">
            <AddressList category={friendRequests} />
            <Flex.Item>
              <Divider vertical />
            </Flex.Item>
            <AddressList category={callRequests} />
          </Flex>
        </Flex.Item>
      </Flex>
    </Box>
  );
};

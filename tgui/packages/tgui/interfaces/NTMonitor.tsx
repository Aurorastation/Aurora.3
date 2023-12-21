import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Box, Button, LabeledList, NoticeBox, Section, Table } from '../components';
import { NtosWindow } from '../layouts';

export type MonitorData = {
  ntnetstatus: BooleanLike;
  ntnetrelays: number;
  idsstatus: BooleanLike;
  idsalarm: BooleanLike;
  config_softwaredownload: BooleanLike;
  config_peertopeer: BooleanLike;
  config_communication: BooleanLike;
  config_systemcontrol: BooleanLike;

  ntnetlogs: string[];
  ntnetmessages: string[];
  ntnetmaxlogs: number;
};

export const NTMonitor = (props, context) => {
  const { act, data } = useBackend<MonitorData>(context);

  return (
    <NtosWindow resizable>
      <NtosWindow.Content scrollable>
        <Section title="Wireless Connectivity">
          <LabeledList>
            <LabeledList.Item label="Active NTNet Relays">
              {data.ntnetrelays}
            </LabeledList.Item>
            <LabeledList.Item label="System Status">
              {data.ntnetstatus ? 'Enabled' : 'Disabled'}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Firewall Configuration">
          <Table>
            <Table.Row header>
              <Table.Cell>Protocol</Table.Cell>
              <Table.Cell>Status</Table.Cell>
            </Table.Row>
            <Table.Row>
              <Table.Cell>Software Downloads</Table.Cell>
              <Table.Cell>
                <Button
                  content={
                    data.config_softwaredownload ? 'Enabled' : 'Disabled'
                  }
                  icon={data.config_softwaredownload ? 'power-off' : 'times'}
                  color={data.config_softwaredownload ? 'good' : 'red'}
                  onClick={() => act('toggle_function', { toggle_function: 1 })}
                />
              </Table.Cell>
            </Table.Row>
            <Table.Row>
              <Table.Cell>Peer-to-Peer Traffic</Table.Cell>
              <Table.Cell>
                <Button
                  content={data.config_peertopeer ? 'Enabled' : 'Disabled'}
                  icon={data.config_peertopeer ? 'power-off' : 'times'}
                  color={data.config_peertopeer ? 'good' : 'red'}
                  onClick={() => act('toggle_function', { toggle_function: 2 })}
                />
              </Table.Cell>
            </Table.Row>
            <Table.Row>
              <Table.Cell>Communication Systems</Table.Cell>
              <Table.Cell>
                <Button
                  content={data.config_communication ? 'Enabled' : 'Disabled'}
                  icon={data.config_communication ? 'power-off' : 'times'}
                  color={data.config_communication ? 'good' : 'red'}
                  onClick={() => act('toggle_function', { toggle_function: 3 })}
                />
              </Table.Cell>
            </Table.Row>
            <Table.Row>
              <Table.Cell>Remote System Control</Table.Cell>
              <Table.Cell>
                <Button
                  content={data.config_systemcontrol ? 'Enabled' : 'Disabled'}
                  icon={data.config_systemcontrol ? 'power-off' : 'times'}
                  color={data.config_systemcontrol ? 'good' : 'red'}
                  onClick={() => act('toggle_function', { toggle_function: 4 })}
                />
              </Table.Cell>
            </Table.Row>
          </Table>
        </Section>
        <Section
          title="Security Systems"
          buttons={
            <>
              <Button content="Reset IDs" onClick={() => act('resetIDS')} />
              <Button content="Toggle IDs" onClick={() => act('toggleIDS')} />
              <Button
                content="Set Log Limit"
                onClick={() => act('updatemaxlogs')}
              />
              <Button
                content="Purge Logs"
                color="red"
                onClick={() => act('purgelogs')}
              />
            </>
          }>
          <LabeledList>
            <LabeledList.Item label="Intrusion Detection">
              {data.idsstatus ? 'Enabled' : 'Disabled'}
            </LabeledList.Item>
            <LabeledList.Item label="Maximum Log Amount">
              {data.ntnetmaxlogs}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="System Logs">
          {data.ntnetlogs && data.ntnetlogs.length ? (
            data.ntnetlogs.map((log) => (
              <Box key={log} backgroundColor="#000000">
                {log}
              </Box>
            ))
          ) : (
            <NoticeBox>No system logs found.</NoticeBox>
          )}
        </Section>
        <Section title="Message Logs">
          {data.ntnetmessages && data.ntnetmessages.length ? (
            data.ntnetmessages.map((log) => (
              <Box key={log} backgroundColor="#000000">
                {log}
              </Box>
            ))
          ) : (
            <NoticeBox>No message logs found.</NoticeBox>
          )}
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};

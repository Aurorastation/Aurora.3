import { Button, NoticeBox, Section, Stack, Table } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { useBackend, useLocalState } from '../backend';
import { NtosWindow } from '../layouts';
import { SearchBar } from './common/SearchBar';

export type AlarmData = {
  alarms: Alarm[];
};

type Alarm = {
  deck: number;
  dept: string;
  name: string;
  searchname: string;
  ref: string;
  danger: BooleanLike;
};

export const AtmosAlarmControl = (props) => {
  const { act, data } = useBackend<AlarmData>();
  const [searchTerm, setSearchTerm] = useLocalState<string>(`searchTerm`, ``);

  return (
    <NtosWindow resizable>
      <NtosWindow.Content scrollable>
        <Section
          title="Alarms"
          buttons={
            <Stack align="center">
              <Stack.Item>
                <Button content={'Refresh'} onClick={() => act('refresh')} />
              </Stack.Item>
              <Stack.Item>
                <SearchBar
                  autoFocus
                  placeholder="Search by name"
                  query={searchTerm}
                  onSearch={(value) => {
                    setSearchTerm(value);
                  }}
                  style={{ width: '40vw' }}
                />
              </Stack.Item>
            </Stack>
          }
        >
          <Table>
            <Table.Row header>
              <Table.Cell>Deck</Table.Cell>
              <Table.Cell>Department</Table.Cell>
              <Table.Cell>Area</Table.Cell>
            </Table.Row>
            {data.alarms?.length ? (
              data.alarms
                // Search still doesn't work properly. While it correctly handles name searches now, it still won't search by dept or deck.
                .filter(
                  (alarm) =>
                    alarm.searchname
                      ?.toLowerCase()
                      .indexOf(searchTerm.toLowerCase()) > -1,
                )
                .sort(
                  (a, b) =>
                    Number(b.danger) - Number(a.danger) ||
                    a.dept?.localeCompare(b?.dept),
                )
                .map((alarm) => (
                  <Table.Row key={alarm.ref}>
                    <Table.Cell>{alarm.deck}</Table.Cell>
                    <Table.Cell>{alarm.dept}</Table.Cell>
                    <Table.Cell>
                      <Button
                        key={alarm.name}
                        content={alarm.name}
                        color={alarm.danger ? 'red' : 'green'}
                        onClick={() => act('alarm', { alarm: alarm.ref })}
                      />
                    </Table.Cell>
                  </Table.Row>
                ))
            ) : (
              <NoticeBox>No alarms detected.</NoticeBox>
            )}
          </Table>
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};

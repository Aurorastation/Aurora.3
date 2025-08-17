import { BooleanLike } from '../../common/react';
import { useBackend, useLocalState } from '../backend';
import { Button, Input, NoticeBox, Section, Table } from '../components';
import { NtosWindow } from '../layouts';

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

export const AtmosAlarmControl = (props, context) => {
  const { act, data } = useBackend<AlarmData>(context);
  const [searchTerm, setSearchTerm] = useLocalState<string>(
    context,
    `searchTerm`,
    ``
  );

  return (
    <NtosWindow resizable>
      <NtosWindow.Content scrollable>
        <Section
          title="Alarms"
          buttons={
            <>
              <Button content={'Refresh'} onClick={() => act('refresh')} />
              <Input
                autoFocus
                autoSelect
                placeholder="Search by name"
                width="40vw"
                maxLength={512}
                onInput={(e, value) => {
                  setSearchTerm(value);
                }}
                value={searchTerm}
              />
            </>
          }>
          <Table>
            <Table.Row header>
              <Table.Cell>Deck</Table.Cell>
              <Table.Cell>Department</Table.Cell>
              <Table.Cell>Area</Table.Cell>
            </Table.Row>
            {data.alarms && data.alarms.length ? (
              data.alarms
                // Search still doesn't work properly. While it correctly handles name searches now, it still won't search by dept or deck.
                .filter(
                  (alarm) =>
                    alarm.searchname
                      ?.toLowerCase()
                      .indexOf(searchTerm.toLowerCase()) > -1
                )
                .sort((a, b) => a.dept?.localeCompare(b?.dept))
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

import { BooleanLike } from '../../common/react';
import { useBackend, useLocalState } from '../backend';
import { Button, Input, NoticeBox, Section } from '../components';
import { NtosWindow } from '../layouts';

export type AlarmData = {
  alarms: Alarm[];
};

type Alarm = {
  name: string;
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
          }>
          {data.alarms && data.alarms.length ? (
            data.alarms
              .filter(
                (a) =>
                  a.name.toLowerCase().indexOf(searchTerm.toLowerCase()) > -1
              )
              .map((alarm) => (
                <Button
                  key={alarm.name}
                  content={alarm.name}
                  color={alarm.danger ? 'red' : ''}
                  onClick={() => act('alarm', { alarm: alarm.ref })}
                />
              ))
          ) : (
            <NoticeBox>No alarms detected.</NoticeBox>
          )}
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};

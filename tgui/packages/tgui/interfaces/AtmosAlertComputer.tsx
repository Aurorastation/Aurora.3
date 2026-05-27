import { Button, NoticeBox, Section } from 'tgui-core/components';
import { useBackend } from '../backend';
import { Window } from '../layouts';

type AtmosAlertComputerData = {
  priority_alarms: AlarmEntry[];
  minor_alarms: AlarmEntry[];
};

type AlarmEntry = {
  name: string;
  ref: string;
};

export const AtmosAlertComputer = (props) => {
  const { act, data } = useBackend<AtmosAlertComputerData>();

  return (
    <Window
      title="Atmospheric Alert Computer"
      width={400}
      height={400}
      theme="hephaestus"
    >
      <Window.Content scrollable>
        <Section title="Priority Alerts">
          {data.priority_alarms.length ? (
            data.priority_alarms.map((alarm) => (
              <Button.Confirm
                key={alarm.ref}
                fluid
                color="bad"
                content={alarm.name}
                confirmContent="Reset alarm?"
                onClick={() => act('clear_alarm', { ref: alarm.ref })}
              />
            ))
          ) : (
            <NoticeBox>No priority alerts detected.</NoticeBox>
          )}
        </Section>
        <Section title="Minor Alerts">
          {data.minor_alarms.length ? (
            data.minor_alarms.map((alarm) => (
              <Button.Confirm
                key={alarm.ref}
                fluid
                color="average"
                content={alarm.name}
                confirmContent="Reset alarm?"
                onClick={() => act('clear_alarm', { ref: alarm.ref })}
              />
            ))
          ) : (
            <NoticeBox>No minor alerts detected.</NoticeBox>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};

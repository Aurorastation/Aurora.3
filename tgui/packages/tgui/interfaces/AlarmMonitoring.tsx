import { useBackend } from '../backend';
import { Button, LabeledList, Section } from '../components';
import { NtosWindow, Window } from '../layouts';

export type AlarmData = {

}

export const AlarmMonitoring = (props, context) => {
  const { act, data } = useBackend<AlarmData>(context);

  return (
    <NtosWindow resizable>
      <NtosWindow.Content scrollable>
        <Section title="Alarm">

        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};

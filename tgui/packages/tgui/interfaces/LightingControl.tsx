import { useBackend } from '../backend';
import { Button, LabeledList, Section } from '../components';
import { NtosWindow } from '../layouts';

export type LightingData = {
  context: string;
  status: string;
};

export const LightingControl = (props, context) => {
  const { act, data } = useBackend<LightingData>(context);

  return (
    <NtosWindow resizable>
      <NtosWindow.Content scrollable>
        <Section
          title="Control"
          buttons={
            <Button
              content="Apply"
              color="green"
              icon="check"
              onClick={() => act('set')}
            />
          }>
          <LabeledList>
            <LabeledList.Item label="Target Areas">
              <Button
                content="Public Hallways"
                icon="chart-area"
                selected={data.context === 'pub'}
                onClick={() => act('context', { context: 'pub' })}
              />
              <Button
                content="All Areas"
                icon="chart-area"
                selected={data.context === 'all'}
                onClick={() => act('context', { context: 'all' })}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Lighting Mode">
              <Button
                content="Normal"
                icon="lightbulb"
                selected={data.status === 'full'}
                onClick={() => act('mode', { mode: 'full' })}
              />
              <Button
                content="Darkened"
                icon="lightbulb"
                selected={data.status === 'dark'}
                onClick={() => act('mode', { mode: 'dark' })}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};

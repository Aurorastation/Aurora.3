import { useEffect, useState } from 'react';
import { Button, LabeledList, Section } from 'tgui-core/components';
import { useBackend } from '../backend';
import { NtosWindow } from '../layouts';

export type LightingData = {
  context: string;
  status: string;
};

export const LightingControl = (props) => {
  const { act, data } = useBackend<LightingData>();
  const [context, setContext] = useState(data.context);
  const [status, setStatus] = useState(data.status);

  useEffect(() => {
    setContext(data.context);
    setStatus(data.status);
  }, [data.context, data.status]);

  return (
    <NtosWindow>
      <NtosWindow.Content scrollable>
        <Section
          title="Control"
          buttons={
            <Button
              content="Apply"
              color="green"
              icon="check"
              onClick={() => act('set', { context, mode: status })}
            />
          }
        >
          <LabeledList>
            <LabeledList.Item label="Target Areas">
              <Button
                content="Public Hallways"
                icon="chart-area"
                selected={context === 'pub'}
                onClick={() => setContext('pub')}
              />
              <Button
                content="All Areas"
                icon="chart-area"
                selected={context === 'all'}
                onClick={() => setContext('all')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Lighting Mode">
              <Button
                content="Normal"
                icon="lightbulb"
                selected={status === 'full'}
                onClick={() => setStatus('full')}
              />
              <Button
                content="Darkened"
                icon="lightbulb"
                selected={status === 'dark'}
                onClick={() => setStatus('dark')}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};

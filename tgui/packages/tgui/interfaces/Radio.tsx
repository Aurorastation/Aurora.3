import { useBackend } from '../backend';
import { Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

type SampleData = {
  frequency: number;
};

export const Radio = (props, context) => {
  const { act, data } = useBackend<SampleData>(context);
  const { frequency } = data;
  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section title="Radio Frequency">
          <LabeledList>
            <LabeledList.Item label="Frequency">{frequency}</LabeledList.Item>
            <LabeledList.Item label="Button">
              <Button
                content="Dispatch a 'test' action"
                onClick={() => act('test')}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};

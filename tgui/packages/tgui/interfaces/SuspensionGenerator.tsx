import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Button, LabeledList, ProgressBar, Section } from '../components';
import { Window } from '../layouts';

export type SuspensionData = {
  charge: number;
  fieldtype: string;
  fieldtypes: Field[];
  active: BooleanLike;
  anchored: BooleanLike;
};

type Field = {
  name: string;
  type: string;
};

export const SuspensionGenerator = (props, context) => {
  const { act, data } = useBackend<SuspensionData>(context);

  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section title="Overview">
          <LabeledList>
            <LabeledList.Item
              label="Cell Charge"
              buttons={
                <Button
                  content="Toggle Field"
                  disabled={!data.anchored}
                  icon={data.active ? 'times' : 'power-off'}
                  color={data.active ? 'good' : 'bad'}
                  tooltip="Cannot be enabled while anchored."
                  onClick={() => act('togglefield')}
                />
              }>
              <ProgressBar
                ranges={{
                  good: [75, 100],
                  average: [30, 75],
                  bad: [0, 30],
                }}
                value={data.charge}
                minValue={0}
                maxValue={100}>
                {data.charge}%
              </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Item label="Field Status">
              {data.active ? 'Enabled' : 'Disabled'}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Field Types">
          <LabeledList>
            {data.fieldtypes.map((field) => (
              <LabeledList.Item key={field.name} label={field.name}>
                <Button
                  content={
                    data.fieldtype === field.type ? 'Selected' : 'Select'
                  }
                  color={data.fieldtype === field.type ? 'good' : ''}
                  onClick={() => act('fieldtype', { fieldtype: field.type })}
                />
              </LabeledList.Item>
            ))}
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};

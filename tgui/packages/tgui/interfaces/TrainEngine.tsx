import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Button, LabeledList, ProgressBar, Section } from '../components';
import { Window } from '../layouts';

export type EngineData = {
  // Base cargo train data
  is_on: BooleanLike;
  has_key: BooleanLike;
  has_cell: BooleanLike;
  cell_charge: number;
  tow: string;
};

export const TrainEngine = (props, context) => {
  const { act, data } = useBackend<EngineData>(context);

  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section title="Status">
          <LabeledList>
            <LabeledList.Item label="Engine">
              <Button
                content={data.is_on ? 'Running' : 'Stopped'}
                icon={data.is_on ? 'power-off' : 'times'}
                color={data.is_on ? 'good' : 'bad'}
                onClick={() => act('toggle_engine')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Key">
              <Button
                content={data.has_key ? 'Remove' : 'Not Inserted'}
                disabled={!data.has_key}
                icon="key"
                onClick={() => act('key')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Cell">
              {data.has_cell ? (
                <ProgressBar
                  ranges={{
                    good: [75, 100],
                    average: [30, 75],
                    bad: [0, 30],
                  }}
                  value={data.cell_charge}
                  minValue={0}
                  maxValue={100}>
                  {data.cell_charge}%
                </ProgressBar>
              ) : (
                'Not Inserted'
              )}
            </LabeledList.Item>
            <LabeledList.Item label="Towing">
              {data.tow ? (
                <Button
                  content={data.tow}
                  icon="times"
                  onClick={() => act('unlatch')}
                />
              ) : (
                'Nothing'
              )}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};

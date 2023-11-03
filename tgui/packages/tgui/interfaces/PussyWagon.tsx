import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Button, LabeledList, ProgressBar, Section } from '../components';
import { Window } from '../layouts';

export type WagonData = {
  // Base cargo train data
  is_on: BooleanLike;
  has_key: BooleanLike;
  has_cell: BooleanLike;
  cell_charge: number;
  tow: string;

  // Janicart data
  has_proper_trolley: BooleanLike;
  is_hoovering: BooleanLike;
  vacuum_capacity: number;
  max_vacuum_capacity: number;
  is_mopping: BooleanLike;
  has_bucket: BooleanLike;
  bucket_capacity: number;
  max_bucket_capacity: number;
};

export const PussyWagon = (props, context) => {
  const { act, data } = useBackend<WagonData>(context);

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
                  {Math.round(data.cell_charge)}%
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
          <Section title="Controls">
            {data.has_proper_trolley ? (
              <ControlsWindow />
            ) : (
              'Unrecognised trolley.'
            )}
          </Section>
        </Section>
      </Window.Content>
    </Window>
  );
};

export const ControlsWindow = (props, context) => {
  const { act, data } = useBackend<WagonData>(context);

  return (
    <LabeledList>
      <LabeledList.Item label="Vacuum">
        <Button
          content={data.is_hoovering ? 'Active' : 'Inactive'}
          icon={data.is_hoovering ? 'power-off' : 'times'}
          onClick={() => act('toggle_hoover')}
        />
      </LabeledList.Item>
      <LabeledList.Item label="Vacuum Capacity">
        <ProgressBar
          ranges={{
            good: [data.max_vacuum_capacity * 0.8, data.max_vacuum_capacity],
            average: [
              data.max_vacuum_capacity * 0.4,
              data.max_vacuum_capacity * 0.8,
            ],
            bad: [0, data.max_vacuum_capacity * 0.4],
          }}
          value={data.vacuum_capacity}
          minValue={0}
          maxValue={data.max_vacuum_capacity}>
          {data.vacuum_capacity} L
        </ProgressBar>
      </LabeledList.Item>
      <LabeledList.Item label="Mopping">
        <Button
          content={data.is_mopping ? 'Active' : 'Inactive'}
          disabled={
            !data.is_on || !data.has_bucket || data.bucket_capacity <= 0
          }
          icon={data.is_mopping ? 'power-off' : 'times'}
          onClick={() => act('toggle_mop')}
        />
      </LabeledList.Item>
      <LabeledList.Item label="Container Reagents Remaining">
        {data.has_bucket ? (
          <ProgressBar
            ranges={{
              good: [data.max_bucket_capacity * 0.8, data.max_bucket_capacity],
              average: [
                data.max_bucket_capacity * 0.4,
                data.max_bucket_capacity * 0.8,
              ],
              bad: [0, data.max_bucket_capacity * 0.4],
            }}
            value={data.bucket_capacity}
            minValue={0}
            maxValue={data.max_bucket_capacity}>
            {data.bucket_capacity} cl
          </ProgressBar>
        ) : (
          'No Container'
        )}
      </LabeledList.Item>
    </LabeledList>
  );
};

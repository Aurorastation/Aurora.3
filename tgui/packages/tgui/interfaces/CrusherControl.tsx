import {
  Button,
  LabeledList,
  ProgressBar,
  Section,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { useBackend } from '../backend';
import { NtosWindow } from '../layouts';

export type CrusherData = {
  message: string;
  airlock_count: number;
  piston_count: number;
  status_pistons: Piston[];
  extending: BooleanLike;
};

type Piston = {
  progress: number;
  blocked: BooleanLike;
  action: string;
  piston: number;
};

export const CrusherControl = (props) => {
  const { act, data } = useBackend<CrusherData>();

  return (
    <NtosWindow>
      <NtosWindow.Content scrollable>
        <Section
          title="Crusher Management"
          buttons={
            data.piston_count === 0 && (
              <Button
                content="Initialize Pistons"
                icon="industry"
                onClick={() => act('initialize')}
              />
            )
          }
        >
          {data.piston_count === 0 ? (
            'No pistons detected.'
          ) : (
            <PistonManagement />
          )}
        </Section>
        {data.piston_count !== 0 && <PistonMonitoring />}
      </NtosWindow.Content>
    </NtosWindow>
  );
};

export const PistonManagement = (props) => {
  const { act, data } = useBackend<CrusherData>();

  return (
    <LabeledList>
      <LabeledList.Item label="Airlock Control">
        <Button
          content="Open"
          icon="door-closed"
          onClick={() => act('hatch_open')}
        />
        <Button
          content="Close"
          icon="door-open"
          onClick={() => act('hatch_close')}
        />
      </LabeledList.Item>
      <LabeledList.Item label="Activate">
        <Button
          content="Start"
          selected={data.extending}
          icon="cog"
          onClick={() => act('crush')}
        />
        <Button
          content="Abort"
          color="red"
          disabled={!data.extending}
          icon="stop"
          onClick={() => act('abort')}
        />
      </LabeledList.Item>
    </LabeledList>
  );
};

export const PistonMonitoring = (props) => {
  const { act, data } = useBackend<CrusherData>();

  return (
    <Section title="Piston Monitoring">
      <LabeledList>
        <LabeledList.Item label="Piston Count">
          {data.piston_count}
        </LabeledList.Item>
        {data.status_pistons.map((piston) => (
          <LabeledList.Item
            key={piston.piston}
            label={'Piston' + piston.piston}
          >
            <ProgressBar
              ranges={{
                good: [75, 100],
                average: [30, 75],
                bad: [0, 30],
              }}
              value={piston.progress}
              minValue={0}
              maxValue={100}
            />
          </LabeledList.Item>
        ))}
        <LabeledList.Item label="Airlock Count">
          {data.airlock_count}
        </LabeledList.Item>
        <LabeledList.Item label="Status">{data.message}</LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

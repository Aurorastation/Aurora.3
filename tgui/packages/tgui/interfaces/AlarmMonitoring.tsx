import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Button, LabeledList, Section } from '../components';
import { NtosWindow } from '../layouts';

export type AlarmData = {
  categories: Category[];
};

type Category = {
  category: string;
  alarms: Alarm[];
};

type Alarm = {
  name: string;
  origin_lost: BooleanLike;
  has_cameras: number;
  cameras: Camera[];
  lost_sources: string;
};

type Camera = {
  name: string;
  deact: BooleanLike; // deactivated
  camera: string; // ref
  x: number;
  y: number;
  z: number;
};

export const AlarmMonitoring = (props, context) => {
  const { act, data } = useBackend<AlarmData>(context);

  return (
    <NtosWindow resizable width={600} height={700}>
      <NtosWindow.Content scrollable>
        {data.categories.map((category) => (
          <Section title={category.category} key={category.category}>
            {category.alarms.length ? (
              <LabeledList>
                {category.alarms.map((alarm) => (
                  <LabeledList.Item
                    label={alarm.origin_lost ? 'Origin Lost' : alarm.name}
                    labelColor="red"
                    key={alarm.name}>
                    {alarm.has_cameras
                      ? alarm.cameras.map((camera) => (
                        <Button
                          content="Switch To"
                          disabled={camera.deact}
                          onClick={() =>
                            act('switchTo', { switchTo: camera.camera })
                          }
                          key={camera.camera}
                        />
                      ))
                      : ' (No cameras for this alarm.)'}
                  </LabeledList.Item>
                ))}
              </LabeledList>
            ) : (
              'No alarms found.'
            )}
          </Section>
        ))}
      </NtosWindow.Content>
    </NtosWindow>
  );
};

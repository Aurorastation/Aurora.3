import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Button, LabeledList, NoticeBox, NumberInput, Section } from '../components';
import { Window } from '../layouts';

export type FusionGyrotronData = {
  manufacturer: string;
  gyro_power_constant: number;
  gyrotrons: Gyrotron[];
};

type Gyrotron = {
  id: string;
  ref: string;
  active: BooleanLike;
  firedelay: number;
  energy: number;
};

export const FusionGyrotronControl = (props, context) => {
  const { act, data } = useBackend<FusionGyrotronData>(context);

  return (
    <Window resizable theme={data.manufacturer}>
      <Window.Content scrollable>
        {data.gyrotrons && data.gyrotrons.length ? (
          data.gyrotrons.map((gyrotron) => (
            <Section
              title={'Gyrotron ' + gyrotron.id}
              key={gyrotron.id}
              buttons={
                <Button
                  content={gyrotron.active ? 'Online' : 'Offline'}
                  icon={gyrotron.active ? 'power-off' : 'times'}
                  color={gyrotron.active ? 'good' : 'bad'}
                  onClick={() => act('toggle', { machine: gyrotron.ref })}
                />
              }>
              <NoticeBox>
                Power consumption per shot:{' '}
                {gyrotron.energy * data.gyro_power_constant} watts.
              </NoticeBox>
              <LabeledList>
                <LabeledList.Item label="Strength">
                  <NumberInput
                    value={gyrotron.energy}
                    minValue={1}
                    maxValue={50}
                    unit="x"
                    stepPixelSize={15}
                    onDrag={(e, value) =>
                      act('modifypower', {
                        modifypower: value,
                        machine: gyrotron.ref,
                      })
                    }
                  />
                </LabeledList.Item>
                <LabeledList.Item label="Fire Delay">
                  <NumberInput
                    value={gyrotron.firedelay}
                    minValue={2}
                    maxValue={10}
                    stepPixelSize={15}
                    unit="ds"
                    onDrag={(e, value) =>
                      act('modifyrate', {
                        modifyrate: value,
                        machine: gyrotron.ref,
                      })
                    }
                  />
                </LabeledList.Item>
              </LabeledList>
            </Section>
          ))
        ) : (
          <NoticeBox>No gyrotrons detected.</NoticeBox>
        )}
      </Window.Content>
    </Window>
  );
};

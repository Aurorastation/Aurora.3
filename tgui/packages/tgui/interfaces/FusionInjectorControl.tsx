import { BooleanLike } from '../../common/react';
import { capitalize } from '../../common/string';
import { useBackend } from '../backend';
import { Box, Button, LabeledList, NoticeBox, ProgressBar, Section, Slider } from '../components';
import { Window } from '../layouts';

export type FusionGyrotronControl = {
  manufacturer: string;
  global_rate: number;
  injectors: Injector[];
};

type Injector = {
  id: string;
  ref: string;
  injecting: BooleanLike;
  fueltype: string;
  depletion: number;
  injection_rate: number;
};

export const FusionInjectorControl = (props, context) => {
  const { act, data } = useBackend<FusionGyrotronControl>(context);

  return (
    <Window resizable theme={data.manufacturer}>
      <Window.Content scrollable>
        {data.injectors && data.injectors.length ? (
          <>
            <Section title="Global Controls">
              <LabeledList>
                <LabeledList.Item label="Global Injection">
                  <Button
                    content="Toggle"
                    icon="power-off"
                    onClick={() => act('global_toggle')}
                  />
                </LabeledList.Item>
                <LabeledList.Item label="Global Injection Rate">
                  <Slider
                    value={data.global_rate}
                    minValue={0}
                    maxValue={100}
                    step={1}
                    stepPixelSize={5}
                    onDrag={(e, value) =>
                      act('global_rate', {
                        global_rate: value,
                      })
                    }
                  />
                </LabeledList.Item>
              </LabeledList>
            </Section>

            {data.injectors.map((injector) => (
              <Section title={'Injector ' + injector.id} key={injector.id}>
                <LabeledList>
                  <LabeledList.Item label="Status">
                    <Box as="span" color={injector.injecting ? 'good' : 'bad'}>
                      {injector.injecting ? 'Online' : 'Offline'}
                    </Box>
                  </LabeledList.Item>
                  <LabeledList.Item label="Injection Rate">
                    <Slider
                      value={injector.injection_rate}
                      minValue={0}
                      maxValue={100}
                      step={1}
                      stepPixelSize={5}
                      onDrag={(e, value) =>
                        act('injection_rate', {
                          new_injection_rate: value,
                          machine: injector.ref,
                        })
                      }
                    />
                  </LabeledList.Item>
                  <LabeledList.Item label="Fuel Material">
                    {capitalize(injector.fueltype)}
                  </LabeledList.Item>
                  <LabeledList.Item label="Fuel">
                    {injector.depletion < 0 ? (
                      'No fuel inserted.'
                    ) : (
                      <ProgressBar
                        ranges={{
                          good: [75, 100],
                          average: [30, 75],
                          bad: [0, 30],
                        }}
                        value={injector.depletion}
                        minValue={0}
                        maxValue={100}
                      />
                    )}
                  </LabeledList.Item>
                </LabeledList>
              </Section>
            ))}
          </>
        ) : (
          <NoticeBox>No injectors detected.</NoticeBox>
        )}
      </Window.Content>
    </Window>
  );
};

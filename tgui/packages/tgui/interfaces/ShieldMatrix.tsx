import { BooleanLike } from 'common/react';
import { useBackend } from '../backend';
import { Button, Box, LabeledList, Slider, Section, NumberInput } from '../components';
import { Window } from '../layouts';

export type MatrixData = {
  owned_capacitor: BooleanLike;
  projector_power: Projector[];
  owned_projectors: string[];
  active: BooleanLike;
  strength_ratio: number;
  charge_ratio: number;
  modulator_ratio: number;
  modulators: string[];
  available_modulators: string[];
  max_field_radius: number;
  field_radius: number;
  multiz: BooleanLike;
};

type Projector = {
  dir: string;
  power: number;
};

const get_center_x = function (a, b, c, x) {
  let A = 87 * (1 - a);
  if (A) {
    let alpha = (((60 * c) / (b + c)) * Math.PI) / 180;
    x += A * Math.cos(alpha);
  }
  return x;
};

const get_center_y = function (a, b, c, y) {
  let A = 87 * (1 - a);
  if (A) {
    let alpha = (((60 * c) / (b + c)) * Math.PI) / 180;
    y += A * Math.sin(alpha);
  }
  return y;
};

export const ShieldMatrix = (props, context) => {
  const { act, data } = useBackend<MatrixData>(context);
  const cent_x = String(
    get_center_x(
      data.strength_ratio / 100,
      data.charge_ratio / 100,
      data.modulator_ratio / 100,
      25
    )
  );
  const cent_y = String(
    get_center_y(
      data.strength_ratio / 100,
      data.charge_ratio / 100,
      data.modulator_ratio / 100,
      31
    )
  );

  return (
    <Window resizable theme="hephaestus">
      <Window.Content scrollable>
        <Section
          title="Shield Matrix Controls"
          buttons={
            <Button
              color={data.active ? 'good' : 'bad'}
              content={data.active ? 'Online' : 'Offline'}
              icon={data.active ? 'power-off' : 'times'}
              onClick={(e) => act('toggle')}
            />
          }>
          <Box color={data.owned_capacitor ? 'good' : 'bad'}>
            Capacitor Status:{' '}
            {data.owned_capacitor
              ? 'Capacitor Connected'
              : 'No Capacitor Found'}
          </Box>
          <Slider
            animated
            step={1}
            stepPixelSize={1}
            value={data.field_radius}
            minValue={0}
            maxValue={data.max_field_radius}
            onChange={(e, value) =>
              act('setFieldRadius', { field_radius: value })
            }>
            Field Radius: {data.field_radius}
          </Slider>
          <br />
          <Box>
            Multi-Level Shielding:{' '}
            <Button
              color={data.multiz ? 'good' : 'bad'}
              content={data.multiz ? 'Online' : 'Offline'}
              icon="bars"
              onClick={(e) => act('multiz')}
            />
          </Box>
        </Section>
        <br />
        <Section title="Shield Power Control">
          <Box textAlign="center">
            <svg height={150} width={150} viewBox="0 0 150 150">
              <polygon
                points="25,31 125,31 75,118"
                stroke="orange"
                strokeWidth="3"
              />
              <circle cx={cent_x} cy={cent_y} r="3" fill="orange" />
              <line
                x1="25"
                y1="31"
                x2={cent_x}
                y2={cent_y}
                stroke="red"
                strokeWidth="3"
              />
              <line
                x1="125"
                y1="31"
                x2={cent_x}
                y2={cent_y}
                stroke="green"
                strokeWidth="3"
              />
              <line
                x1="75"
                y1="118"
                x2={cent_x}
                y2={cent_y}
                stroke="blue"
                strokeWidth="3"
              />
            </svg>
            <Box color="red">
              Shield Strength:{' '}
              <NumberInput
                value={data.strength_ratio}
                minValue={0}
                maxValue={100}
                unit="%"
                step={1}
                onChange={(e, value) =>
                  act('setNewRatios', { ratio: value, power: 'strength' })
                }
              />
            </Box>
            <Box color="green">
              Shield Charge Rate:{' '}
              <NumberInput
                value={data.charge_ratio}
                minValue={0}
                maxValue={100}
                unit="%"
                step={1}
                onChange={(e, value) =>
                  act('setNewRatios', { ratio: value, power: 'charge' })
                }
              />
            </Box>
            <Box color="blue">
              Shield Modulator Power:{' '}
              <NumberInput
                value={data.modulator_ratio}
                minValue={0}
                maxValue={100}
                unit="%"
                step={1}
                onChange={(e, value) =>
                  act('setNewRatios', {
                    ratio: value,
                    power: 'modulator',
                  })
                }
              />
            </Box>
          </Box>
        </Section>
        <br />
        <Section title="Shield Modulator Control">
          <Box>
            {data.available_modulators.length ? (
              <LabeledList>
                {data.available_modulators.map((mod) => (
                  <LabeledList.Item key={mod} label={mod}>
                    <Button
                      content={data.modulators.includes(mod) ? 'Remove' : 'Add'}
                      color={data.modulators.includes(mod) ? 'bad' : 'good'}
                      onClick={(e) =>
                        act('changeModulators', { modulator: mod })
                      }
                    />
                  </LabeledList.Item>
                ))}
              </LabeledList>
            ) : (
              'No Modulators Available.'
            )}
          </Box>
        </Section>
        <Section title="Projector Power Control">
          <Box>
            {data.owned_projectors.length ? (
              <LabeledList>
                {data.projector_power.map((projector) =>
                  data.owned_projectors.includes(projector.dir) ? (
                    <LabeledList.Item key={projector.dir} label={projector.dir}>
                      <NumberInput
                        value={projector.power}
                        minValue={0}
                        maxValue={100}
                        unit="%"
                        step={1}
                        onChange={(e, value) =>
                          act('setPower', {
                            dir: projector.dir,
                            power: value,
                          })
                        }
                      />
                    </LabeledList.Item>
                  ) : (
                    ''
                  )
                )}
              </LabeledList>
            ) : (
              'No Shield Projectors Found.'
            )}
          </Box>
        </Section>
      </Window.Content>
    </Window>
  );
};

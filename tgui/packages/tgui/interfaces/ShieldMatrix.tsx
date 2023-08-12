import { BooleanLike } from 'common/react';
import { useBackend, useLocalState } from '../backend';
import { Button, Box, LabeledList, Slider, Section, NumberInput } from '../components';
import { Window } from '../layouts';

export type MatrixData = {
  owned_capacitor: BooleanLike;
  owned_projectors: string[];
  active: BooleanLike;
  strength_ratio: number;
  charge_ratio: number;
  modulator_ratio: number;
  modulators: string[];
  available_modulators: string[];
  max_renwick_draw: number;
  renwick_draw: number;
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
      data.strength_ratio,
      data.charge_ratio,
      data.modulator_ratio,
      25
    )
  );
  const cent_y = String(
    get_center_y(
      data.strength_ratio,
      data.charge_ratio,
      data.modulator_ratio,
      31
    )
  );

  const [new_str, setNewStr] = useLocalState(
    context,
    'new_str',
    data.strength_ratio * 100
  );

  const [new_cha, setNewCha] = useLocalState(
    context,
    'new_cha',
    data.charge_ratio * 100
  );

  const [new_mod, setNewMod] = useLocalState(
    context,
    'new_mod',
    data.modulator_ratio * 100
  );

  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section
          title="Shield Matrix Control Console"
          buttons={
            <Button
              color={data.active ? 'good' : 'bad'}
              content={data.active ? 'Online' : 'Offline'}
              icon={data.active ? 'power-off' : 'times'}
              onClick={() => act('toggle')}
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
            value={data.renwick_draw}
            minValue={0}
            maxValue={data.max_renwick_draw}
            onChange={(value) =>
              act('setRenwickDraw', { renwick_draw: value })
            }>
            {data.renwick_draw} Renwicks
          </Slider>
        </Section>
        <Section>
          <Box>
            Shield Strength:{' '}
            <NumberInput
              value={new_str}
              minValue={0}
              maxValue={100}
              unit="%"
              step={1}
              onDrag={(e, value) => setNewStr(value)}
            />
            <br />
            Shield Charge Rate:{' '}
            <NumberInput
              value={new_cha}
              minValue={0}
              maxValue={100}
              unit="%"
              step={1}
              onDrag={(e, value) => setNewCha(value)}
            />
            <br />
            Shield Modulator Power:{' '}
            <NumberInput
              value={new_mod}
              minValue={0}
              maxValue={100}
              unit="%"
              step={1}
              onDrag={(e, value) => setNewMod(value)}
            />
            <br />
            <Button
              content="Set"
              onClick={() =>
                act('setNewRatios', {
                  str: new_str / 100,
                  cha: new_cha / 100,
                  mod: new_mod / 100,
                })
              }
            />
          </Box>
        </Section>
        <Section>
          <Box textAlign="center">
            <svg id="pwr" height={150} width={150} viewBox="0 0 150 150">
              <polygon
                points="25,31 125,31 75,118"
                fill="cyan"
                stroke="white"
              />
              <circle cx={cent_x} cy={cent_y} r="2" fill="white" />
              <line x1="25" y1="31" x2={cent_x} y2={cent_y} stroke="white" />
              <line x1="125" y1="31" x2={cent_x} y2={cent_y} stroke="white" />
              <line x1="75" y1="118" x2={cent_x} y2={cent_y} stroke="white" />
            </svg>
          </Box>
        </Section>
        <Section>
          <Box>
            <LabeledList>
              {data.available_modulators.map((mod) => (
                <LabeledList.Item key={mod} label={mod}>
                  <Button
                    content={data.modulators.includes(mod) ? 'Remove' : 'Add'}
                    color={data.modulators.includes(mod) ? 'bad' : 'good'}
                    onClick={() => act('changeModulators', { modulator: mod })}
                  />
                </LabeledList.Item>
              ))}
            </LabeledList>
          </Box>
        </Section>
      </Window.Content>
    </Window>
  );
};

import { BooleanLike } from 'common/react';
import { useBackend } from '../backend';
import { Button, Box, Slider, Section } from '../components';
import { Window } from '../layouts';

let svg = document.querySelector('svg');

export type MatrixData = {
  owned_capacitor: BooleanLike;
  owned_projectors: String[];
  active: BooleanLike;
  strength_ratio: number;
  charge_ratio: number;
  modulator_ratio: number;
  modulators: String[];
  available_modulators: String[];
  max_renwick_draw: number;
  renwick_draw: number;
};

const get_center_x = function (a, b, c, x) {
  let A = 87 * (1 - a);
  let alpha = (60 * c) / (b + c);
  x += A * Math.cos(alpha);
  return x;
};

const get_center_y = function (a, b, c, y) {
  let A = 87 * (1 - a);
  let alpha = (60 * c) / (b + c);
  y += A * Math.sin(alpha);
  return y;
};

const get_mouse_x = function (e) {
  let point = svg.createSVGPoint();
  point.x = e.clientX;
  point.y = e.clientY;
  point.matrixTransform(svg.getScreenCTM().inverse());
  return point.x;
};

const get_mouse_y = function (e) {
  let point = svg.createSVGPoint();
  point.x = e.clientX;
  point.y = e.clientY;
  point.matrixTransform(svg.getScreenCTM().inverse());
  return point.y;
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
            onChange={(e, value) =>
              act('setRenwickDraw', { renwick_draw: value })
            }>
            {data.renwick_draw} Renwicks
          </Slider>
        </Section>
        <Section>
          <Box textAlign="center">
            <svg
              height={150}
              width={150}
              viewBox="0 0 150 150"
              onClick={(e) =>
                act('setNewRatios', { x: get_mouse_x(e), y: get_mouse_y(e) })
              }>
              <polygon points="25,31 125,31 75,118" />
              <circle cx={cent_x} cy={cent_y} r="2" />
              <line x1="25" y1="31" x2={cent_x} y2={cent_y} stroke="black" />
              <line x1="125" y1="31" x2={cent_x} y2={cent_y} stroke="black" />
              <line x1="75" y1="118" x2={cent_x} y2={cent_y} stroke="black" />
            </svg>
          </Box>
        </Section>
      </Window.Content>
    </Window>
  );
};

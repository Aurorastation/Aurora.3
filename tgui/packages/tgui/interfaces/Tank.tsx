import { useBackend } from '../backend';
import { useLocalState } from '../backend';
import { Button, Section, LabeledList, ProgressBar, Slider } from '../components';
import { Window } from '../layouts';
import { BooleanLike } from '../../common/react';

export type TankData = {
  tankPressure: number;
  releasePressure: number;
  defaultReleasePressure: number;
  maxReleasePressure: number;
  valveOpen: BooleanLike;
  maskConnected: BooleanLike;
};

export const Tank = (props, context) => {
  const { act, data } = useBackend<TankData>(context);

  const [tank_color, setColor] = useLocalState(context, 'color', '');

  const tank_presure_color = tank_color
    ? { color: tank_color }
    : {
      ranges: {
        good: [200, Infinity],
        bad: [-Infinity, 100],
        average: [100, 200],
      },
    };

  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section title="Gas Tank">
          <LabeledList>
            <LabeledList.Item label="Tank Pressure">
              <ProgressBar
                {...tank_presure_color}
                minValue={0}
                maxValue={1024}
                value={data.tankPressure}>
                {data.tankPressure} kPa
              </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Item label="Mask Status">
              {data.maskConnected ? 'CONNECTED' : 'NOT CONNECTED'}
            </LabeledList.Item>
            <LabeledList.Item
              label="Mask Release Valve"
              buttons={
                <Button
                  icon="power-off"
                  disabled={!data.maskConnected}
                  onClick={() => act('toggleReleaseValve')}
                />
              }>
              {data.valveOpen ? 'OPEN' : 'CLOSED'}
            </LabeledList.Item>

            <LabeledList.Item label="Mask Release Pressure">
              <Slider
                animated
                step={1}
                stepPixelSize={1}
                value={data.releasePressure}
                minValue={0}
                maxValue={data.maxReleasePressure}
                onChange={(e, value) =>
                  act('setReleasePressure', { release_pressure: value })
                }>
                {data.releasePressure} kPa
              </Slider>
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};

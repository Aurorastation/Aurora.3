import {
  Button,
  LabeledList,
  ProgressBar,
  Section,
  Slider,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { useBackend, useLocalState } from '../backend';
import { Window } from '../layouts';

export type TankData = {
  tankPressure: number;
  releasePressure: number;
  defaultReleasePressure: number;
  maxReleasePressure: number;
  valveOpen: BooleanLike;
  maskConnected: BooleanLike;
};

export const Tank = (props) => {
  const { act, data } = useBackend<TankData>();

  const [tank_color] = useLocalState('color', '');

  const tank_presure_color = tank_color.toString()
    ? { color: tank_color }
    : {
        ranges: {
          good: [200, Infinity],
          bad: [-Infinity, 100],
          average: [100, 200],
        },
      };

  return (
    <Window>
      <Window.Content scrollable>
        <Section title="Gas Tank">
          <LabeledList>
            <LabeledList.Item label="Tank Pressure">
              <ProgressBar
                color={tank_presure_color.toString()}
                minValue={0}
                maxValue={1024}
                value={data.tankPressure}
              >
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
              }
            >
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
                onChange={(value) =>
                  act('setReleasePressure', { release_pressure: value })
                }
              >
                {data.releasePressure} kPa
              </Slider>
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};

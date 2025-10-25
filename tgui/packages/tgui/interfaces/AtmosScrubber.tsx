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

export type AtmoScrubberData = {
  portConnected: BooleanLike;
  tankPressure: number;
  rate: number;
  minrate: number;
  maxrate: number;
  powerDraw: number;
  cellCharge: number;
  cellMaxCharge: number;
  on: BooleanLike;
  hasHoldingTank: BooleanLike;
  holdingTankName: string[];
  holdingTankPressure: number;
};

export const AtmoScrubber = () => {
  const { act, data } = useBackend<AtmoScrubberData>();

  const [tank_color] = useLocalState('tank_color', '');
  const [cell_color] = useLocalState('tank_color', '');

  const tank_pressure_color = tank_color
    ? { color: tank_color.toString() }
    : {
        ranges: {
          good: [-Infinity, 500],
          bad: [750, Infinity],
          average: [500, 750],
        },
      };

  const cell_charge_color = cell_color
    ? { color: cell_color }
    : {
        ranges: {
          good: [data.cellMaxCharge / 2, Infinity],
          bad: [-Infinity, data.cellMaxCharge / 4],
          average: [data.cellMaxCharge / 4, data.cellMaxCharge / 2],
        },
      };

  return (
    <Window>
      <Window.Content>
        <Section
          title="Scrubber Status"
          buttons={
            <Button
              content={data.on ? 'On' : 'Off'}
              icon={data.on ? 'power-off' : 'times'}
              disabled={!data.cellCharge}
              color={!data.on && 'danger'}
              onClick={() => act('togglePower')}
            />
          }
        >
          <LabeledList>
            <LabeledList.Item label="Tank Pressure">
              <ProgressBar
                color={tank_pressure_color.toString()}
                minValue={0}
                maxValue={1024}
                value={data.tankPressure}
              >
                {data.tankPressure} kPa
              </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Item label="Port Status">
              {data.portConnected ? 'Connected' : 'Disconnected'}
            </LabeledList.Item>
            <LabeledList.Item label="Power Draw">
              {data.powerDraw} W
            </LabeledList.Item>
            <LabeledList.Item label="Cell Charge">
              <ProgressBar
                ranges={{
                  good: [data.cellMaxCharge * 0.8, data.cellMaxCharge],
                  average: [data.cellMaxCharge * 0.4, data.cellMaxCharge * 0.8],
                  bad: [0, data.cellMaxCharge * 0.4],
                }}
                value={data.cellCharge}
                minValue={0}
                maxValue={data.cellMaxCharge}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
        {data.hasHoldingTank ? (
          <Section title="Holding Tank">
            <LabeledList>
              <LabeledList.Item
                label="Tank Label"
                buttons={
                  <Button icon="eject" onClick={() => act('removeTank')} />
                }
              >
                {data.holdingTankName}
              </LabeledList.Item>
              <LabeledList.Item label="Tank Pressure">
                <ProgressBar
                  color={tank_pressure_color.toString()}
                  minValue={0}
                  maxValue={1024}
                  value={data.holdingTankPressure}
                >
                  {data.holdingTankPressure} kPa
                </ProgressBar>
              </LabeledList.Item>
            </LabeledList>
          </Section>
        ) : (
          ''
        )}
        <Section title="Regulator Status">
          <LabeledList>
            <LabeledList.Item label="Volume Rate">
              <Slider
                animated
                step={1}
                stepPixelSize={1}
                value={data.rate}
                minValue={data.minrate}
                maxValue={data.maxrate}
                onChange={(e, value) =>
                  act('setVolume', { targetVolume: value })
                }
              >
                {data.rate}
              </Slider>
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};

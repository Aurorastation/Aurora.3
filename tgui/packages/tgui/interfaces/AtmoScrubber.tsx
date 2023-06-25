import { useBackend } from '../backend';
import { useLocalState } from '../backend';
import { Button, Section, LabeledList, ProgressBar, Slider } from '../components';
import { Window } from '../layouts';
import { BooleanLike } from '../../common/react';

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
  holdingTankName: String[];
  holdingTankPressure: String[];
};

export const AtmoScrubber = (props, context) => {
  const { act, data } = useBackend<AtmoScrubberData>(context);

  const [tank_color] = useLocalState(context, 'tank_color', '');
  const [cell_color] = useLocalState(context, 'tank_color', '');

  const tank_presure_color = tank_color
    ? { color: tank_color }
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
        <Section title="Atmos Scrubber">
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
            <LabeledList.Item label="Port Status">
              {data.portConnected ? 'Connected' : 'Disconnected'}
            </LabeledList.Item>
            <LabeledList.Item label="Load">{data.powerDraw} W</LabeledList.Item>
            <LabeledList.Item label="Cell Charge">
              <ProgressBar
                {...cell_charge_color}
                minValue={0}
                maxValue={data.cellMaxCharge}
                value={data.cellCharge}>
                {data.cellCharge}
              </ProgressBar>
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
                }>
                {data.holdingTankName}
              </LabeledList.Item>
              <LabeledList.Item label="Tank Pressure">
                <ProgressBar
                  {...tank_presure_color}
                  minValue={0}
                  maxValue={1024}
                  value={data.holdingTankPressure}>
                  {data.holdingTankPressure} kPa
                </ProgressBar>
              </LabeledList.Item>
            </LabeledList>
          </Section>
        ) : (
          ''
        )}
        <Section title="Power Regulator Status">
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
                }>
                {data.rate}
              </Slider>
            </LabeledList.Item>
            <LabeledList.Item label="Power Switch">
              <Button
                icon="power-off"
                selected={data.on}
                onClick={() => act('togglePower')}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};

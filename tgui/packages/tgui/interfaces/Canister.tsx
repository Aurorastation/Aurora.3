import {
  Box,
  Button,
  Knob,
  LabeledList,
  ProgressBar,
  Section,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { useBackend } from '../backend';
import { Window } from '../layouts';

export type CanisterData = {
  name: string;
  canLabel: BooleanLike;
  portConnected: BooleanLike;
  tankPressure: number;
  releasePressure: number;
  minReleasePressure: number;
  maxReleasePressure: number;
  valveOpen: BooleanLike;
  hasHoldingTank: BooleanLike;
  holdingTank: Tank;
};

type Tank = {
  name: string;
  tankPressure: number;
};

export const Canister = (props) => {
  const { act, data } = useBackend<CanisterData>();
  const port_string = data.portConnected ? 'Connected' : 'Disconnected';

  return (
    <Window>
      <Window.Content scrollable>
        <Section
          title="Tank Status"
          buttons={
            !!data.canLabel && (
              <Button
                icon="pencil-alt"
                content="Relabel"
                onClick={() => act('relabel')}
              />
            )
          }
        >
          <LabeledList>
            <LabeledList.Item label="Tank Label">{data.name}</LabeledList.Item>
            <LabeledList.Item label="Tank Pressure">
              {data.tankPressure} kPa
            </LabeledList.Item>
            <LabeledList.Item label="Port Status">
              {port_string}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section
          title="Holding Tank Status"
          buttons={
            !!data.hasHoldingTank && (
              <Button
                icon="eject"
                color={data.valveOpen && 'danger'}
                content="Eject"
                onClick={() => act('remove_tank')}
              />
            )
          }
        >
          {data.hasHoldingTank ? (
            <HoldingTankWindow />
          ) : (
            <Box>No holding tank inserted.</Box>
          )}
        </Section>
        <Section title="Release Valve Status">
          <Box>
            Release Pressure:
            <ProgressBar
              ranges={{
                good: [data.maxReleasePressure * 0.8, data.maxReleasePressure],
                average: [
                  data.maxReleasePressure * 0.4,
                  data.maxReleasePressure * 0.8,
                ],
                bad: [0, data.maxReleasePressure * 0.4],
              }}
              value={data.releasePressure}
              minValue={data.minReleasePressure}
              maxValue={data.maxReleasePressure}
            />
            <Section textAlign="center">
              <Button
                content="Open"
                icon="lock-open"
                disabled={data.valveOpen}
                onClick={() => act('toggle')}
              />
              <Button
                content="Close"
                icon="lock"
                disabled={!data.valveOpen}
                onClick={() => act('toggle')}
              />
            </Section>
            <Knob
              size={1.25}
              color={!!data.valveOpen && 'yellow'}
              value={data.releasePressure}
              unit="kPa"
              minValue={data.minReleasePressure}
              maxValue={data.maxReleasePressure}
              step={5}
              stepPixelSize={1}
              onDrag={(e, value) =>
                act('pressure', {
                  pressure: value,
                })
              }
            />
          </Box>
        </Section>
      </Window.Content>
    </Window>
  );
};

export const HoldingTankWindow = (props) => {
  const { act, data } = useBackend<CanisterData>();
  return (
    <Section>
      <LabeledList>
        <LabeledList.Item label="Tank Label">
          {data.holdingTank.name}
        </LabeledList.Item>
        <LabeledList.Item label="Tank Pressure">
          {data.holdingTank.tankPressure} kPa
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

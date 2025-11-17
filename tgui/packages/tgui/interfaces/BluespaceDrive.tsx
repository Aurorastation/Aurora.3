import {
  Button,
  Knob,
  LabeledControls,
  LabeledList,
  Section,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { useBackend } from '../backend';
import { Window } from '../layouts';

export type BluespaceDriveData = {
  energized: BooleanLike;
  charge: BooleanLike;
  rotation: number;
  jumping: BooleanLike;
  jump_power: number;
  fuel_gas: number;
};

export const BluespaceDrive = (props) => {
  const { act, data } = useBackend<BluespaceDriveData>();
  return (
    <Window theme="hephaestus">
      <Window.Content>
        <Section title="Drive Configuration">
          <LabeledControls>
            <LabeledControls.Item label="Energize">
              <Button
                content={data.energized ? 'Energized' : 'Energize'}
                color={data.energized ? 'green' : 'red'}
                onClick={() => act('toggle_energized')}
              />
            </LabeledControls.Item>
            <LabeledControls.Item label="Purge Charge">
              <Button
                content="Purge Charge"
                color="red"
                disabled={!data.charge || data.jumping}
                onClick={() => act('purge_charge')}
              />
            </LabeledControls.Item>
            <LabeledControls.Item label="Rotation">
              <Knob
                animated
                value={data.rotation}
                unit="°"
                minValue={0}
                maxValue={359}
                onChange={(value) => act('set_rotation', { rotation: value })}
              />
            </LabeledControls.Item>
            <LabeledControls.Item label="Jump">
              <Button
                content="Jump"
                color="green"
                disabled={!data.charge || data.jumping}
                onClick={() => act('jump')}
              />
            </LabeledControls.Item>
          </LabeledControls>
        </Section>
        <Section title="Drive Status">
          <LabeledList>
            <LabeledList.Item label="Jump Distance">
              {data.jump_power}
            </LabeledList.Item>
            <LabeledList.Item label="Phoron Amount">
              {data.fuel_gas} mol / 1000
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};

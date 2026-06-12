import {
  Button,
  LabeledControls,
  LabeledList,
  Section,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { useBackend } from '../backend';
import { Window } from '../layouts';

export type BluespaceDriveControlData = {
  energized: BooleanLike;
  charge: BooleanLike;
  jumping: BooleanLike;
  jump_power: number;
  fuel_gas: number;
  primed: BooleanLike;
};

export const BluespaceDriveControl = (props) => {
  const { act, data } = useBackend<BluespaceDriveControlData>();
  return (
    <Window width={382} height={277} theme="nanotrasen">
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
          </LabeledControls>
        </Section>
        <Section title="Drive Status">
          <LabeledControls>
            <LabeledControls.Item label="Prime">
              <Button
                content={data.primed ? 'Primed' : 'Not Primed'}
                color={data.primed ? 'green' : 'red'}
                onClick={() => act('toggle_primed')}
              />
            </LabeledControls.Item>
          </LabeledControls>
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

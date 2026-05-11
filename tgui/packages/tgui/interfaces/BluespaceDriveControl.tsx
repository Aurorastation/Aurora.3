import { useBackend } from '../backend';
import { Button, LabeledControls, Section, LabeledList } from '../components';
import { Window } from '../layouts';
import { BooleanLike } from '../../common/react';

export type BluespaceDriveControlData = {
  energized: BooleanLike;
  charge: BooleanLike;
  jumping: BooleanLike;
  jump_power: number;
  fuel_gas: number;
  primed: BooleanLike;
};

export const BluespaceDriveControl = (props, context) => {
  const { act, data } = useBackend<BluespaceDriveControlData>(context);
  return (
    <Window width="382" height="277" theme="nanotrasen">
      <Window.Content>
        <Section title="Drive Configuration">
          <LabeledControls>
            <LabeledControls.Item>
              <Button
                name="Energize"
                content={data.energized ? 'Energized' : 'Energize'}
                color={data.energized ? 'green' : 'red'}
                onClick={() => act('toggle_energized')}
              />
            </LabeledControls.Item>
            <LabeledControls.Item>
              <Button
                name="Purge Charge"
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
            <LabeledControls.Item>
              <Button
                name="Prime"
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

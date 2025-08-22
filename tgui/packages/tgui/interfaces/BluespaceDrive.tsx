import { useBackend } from '../backend';
import { Button, Knob, LabeledControls } from '../components';
import { Window } from '../layouts';
import { BooleanLike } from '../../common/react';

export type BluespaceDriveData = {
  energized: BooleanLike;
  charge: BooleanLike;
  rotation: number;
  jumping: BooleanLike;
};

export const BluespaceDrive = (props, context) => {
  const { act, data } = useBackend<BluespaceDriveData>(context);
  return (
    <Window>
      <Window.Content>
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
          <LabeledControls.Item>
            <Knob
              name="Rotation"
              animated
              value={data.rotation}
              unit="°"
              minValue={0}
              maxValue={359}
              disabled={!data.charge}
              onChange={(e, value) => act('set_rotation', { rotation: value })}
            />
          </LabeledControls.Item>
          <LabeledControls.Item>
            <Button
              name="Jump"
              content="Jump"
              color="green"
              disabled={!data.charge || data.jumping}
              onClick={() => act('jump')}
            />
          </LabeledControls.Item>
        </LabeledControls>
      </Window.Content>
    </Window>
  );
};

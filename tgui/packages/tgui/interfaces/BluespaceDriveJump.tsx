import { useBackend } from '../backend';
import {
  Button,
  Knob,
  LabeledControls,
  Section,
  LabeledList,
  NoticeBox,
} from '../components';
import { Window } from '../layouts';
import { BooleanLike } from '../../common/react';

export type BluespaceDriveJumpData = {
  charge: BooleanLike;
  rotation: number;
  jumping: BooleanLike;
  jump_power: number;
  fuel_gas: number;
  primed: BooleanLike;
};

export const BluespaceDriveJump = (props, context) => {
  const { act, data } = useBackend<BluespaceDriveJumpData>(context);
  return (
    <Window width="382" height="277" theme="nanotrasen">
      <Window.Content>
        <Section title="Jump Computer">
          {!data.primed ? (
            <NoticeBox>
              Bluespace drive awaiting final priming{' '}
              <Button
                content="Override"
                color="red"
                icon="circle-exclamation"
                disabled={data.primed}
                onClick={() => act('toggle_primed')}
              />
            </NoticeBox>
          ) : (
            ''
          )}
          <LabeledControls>
            <LabeledControls.Item>
              <Knob
                name="Rotation"
                animated
                value={data.rotation}
                unit="°"
                minValue={0}
                maxValue={359}
                disabled={!data.charge}
                onChange={(e, value) =>
                  act('set_rotation', { rotation: value })
                }
              />
            </LabeledControls.Item>
            <LabeledControls.Item>
              <Button
                name="Jump"
                content="Jump"
                color="green"
                disabled={!data.charge || data.jumping || !data.primed}
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

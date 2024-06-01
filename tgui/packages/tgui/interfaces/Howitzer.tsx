import { useBackend } from '../backend';
import { Button, Knob, LabeledControls } from '../components';
import { Window } from '../layouts';
import { BooleanLike } from '../../common/react';
import { Box } from '../components';

export type HowitzerData = {
  loaded_shot: BooleanLike;
  horizontal_angle: number;
  vertical_angle: number;
};

export const Howitzer = (props, context) => {
  const { act, data } = useBackend<HowitzerData>(context);
  return (
    <Window>
      <Window.Content>
        <LabeledControls>
          <LabeledControls.Item label="Horizontal">
            <Box textAlign="center">
              {data.horizontal_angle ? data.horizontal_angle : 0}
            </Box>
            <Knob
              value={data.horizontal_angle}
              minValue={0}
              maxValue={360}
              unit="°"
              onChange={(e, value) =>
                act('set_horizontal_angle', { horizontal_angle: value })
              }
            />
          </LabeledControls.Item>
          <LabeledControls.Item label="Vertical">
            <Box textAlign="center">
              {data.vertical_angle ? data.vertical_angle : 0}
            </Box>
            <Knob
              value={data.vertical_angle}
              minValue={0}
              maxValue={90}
              unit="°"
              onChange={(e, value) =>
                act('set_vertical_angle', { vertical_angle: value })
              }
            />
          </LabeledControls.Item>
          <LabeledControls.Item label="Fire Control">
            <Button name="Fire" content="Fire" onClick={() => act('fire')} />
          </LabeledControls.Item>
        </LabeledControls>
      </Window.Content>
    </Window>
  );
};

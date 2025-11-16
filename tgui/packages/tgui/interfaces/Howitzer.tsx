import { Box, Button, Knob, LabeledControls } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { useBackend } from '../backend';
import { Window } from '../layouts';

export type HowitzerData = {
  loaded_shot: BooleanLike;
  horizontal_angle: number;
  vertical_angle: number;
};

export const Howitzer = (props) => {
  const { act, data } = useBackend<HowitzerData>();
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
              onChange={(value) =>
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
              onChange={(value) =>
                act('set_vertical_angle', { vertical_angle: value })
              }
            />
          </LabeledControls.Item>
          <LabeledControls.Item label="Fire Control">
            <Button content="Fire" onClick={() => act('fire')} />
          </LabeledControls.Item>
        </LabeledControls>
      </Window.Content>
    </Window>
  );
};

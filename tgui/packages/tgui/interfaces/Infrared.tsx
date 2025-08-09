import { BooleanLike } from 'tgui-core/react';
import { useBackend } from '../backend';
import { Button } from 'tgui-core/components';
import { Window } from '../layouts';

export type InfraredData = {
  active: BooleanLike;
  visible: BooleanLike;
};

export const Infrared = (props, context) => {
  const { act, data } = useBackend<InfraredData>(context);

  return (
    <Window resizable>
      <Window.Content scrollable>
        <Button
          content={data.active ? 'Active' : 'Inactive'}
          checked={data.active}
          onClick={() => act('state')}
        />
        <Button.Checkbox
          content={data.visible ? 'Visible' : 'Invisible'}
          checked={data.visible}
          onClick={() => act('visible')}
        />
      </Window.Content>
    </Window>
  );
};

import { Button, LabeledList, NoticeBox, Section } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { useBackend } from '../backend';
import { Window } from '../layouts';

export type TurretData = {
  settings: Setting[];
  locked: BooleanLike;
  enabled: BooleanLike;
  is_lethal: BooleanLike;
  lethal: BooleanLike;
  can_switch: BooleanLike;
};

type Setting = {
  category: string;
  variable_name: string;
  value: BooleanLike;
};

export const TurretControlPorta = (props) => {
  const { act, data } = useBackend<TurretData>();

  return (
    <Window>
      <Window.Content scrollable>
        <Section title="Control Panel">
          <NoticeBox>
            {data.locked
              ? 'Behaviour controls are locked.'
              : 'Behaviour controls are unlocked.'}
          </NoticeBox>
          <ControlSection />
        </Section>
      </Window.Content>
    </Window>
  );
};

export const ControlSection = (props) => {
  const { act, data } = useBackend<TurretData>();

  return (
    <LabeledList>
      <LabeledList.Item label="Turret Status">
        <Button
          content={data.enabled ? 'Enabled' : 'Disabled'}
          color={data.enabled ? 'bad' : ''}
          disabled={data.locked}
          onClick={() =>
            act('command', {
              value: !data.enabled,
              command: 'enable',
            })
          }
        />
      </LabeledList.Item>
      <LabeledList.Item label="Lethal Mode">
        <Button
          content={data.lethal ? 'On' : 'Off'}
          color={data.lethal ? 'bad' : 'average'}
          disabled={data.locked}
          onClick={() =>
            act('command', {
              value: !data.lethal,
              command: 'lethal',
            })
          }
        />
      </LabeledList.Item>
      {data.settings.map((setting) => (
        <LabeledList.Item label={setting.category} key={setting.category}>
          <Button
            content={setting.value ? 'On' : 'Off'}
            selected={setting.value}
            disabled={data.locked}
            onClick={() =>
              act('command', {
                value: !setting.value,
                command: setting.variable_name,
              })
            }
          />
        </LabeledList.Item>
      ))}
    </LabeledList>
  );
};

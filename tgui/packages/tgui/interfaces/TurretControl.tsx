import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Button, LabeledList, NoticeBox, Section } from '../components';
import { Window } from '../layouts';

export type TurretData = {
  turrets: Turret[];
  settings: Setting[];
  locked: BooleanLike;
  enabled: BooleanLike;
  is_lethal: BooleanLike;
  lethal: BooleanLike;
  can_switch: BooleanLike;
};

type Turret = {
  name: string;
  ref: string;
  enabled: BooleanLike;
  lethal: BooleanLike;
  settings: Setting[];
};

type Setting = {
  category: string;
  variable_name: string;
  value: BooleanLike;
};

export const TurretControl = (props, context) => {
  const { act, data } = useBackend<TurretData>(context);

  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section title="Group Controls">
          <NoticeBox>
            {data.locked
              ? 'Behaviour controls are locked.'
              : 'Behaviour controls are unlocked.'}
          </NoticeBox>
          <ControlWindow />
        </Section>
        <Section title="Individual Controls">
          <TurretsWindow />
        </Section>
      </Window.Content>
    </Window>
  );
};

export const ControlWindow = (props, context) => {
  const { act, data } = useBackend<TurretData>(context);

  return (
    <LabeledList>
      <LabeledList.Item label="Turret Status">
        <Button
          content={data.enabled ? 'Enabled' : 'Disabled'}
          color={data.enabled ? 'bad' : ''}
          disabled={data.locked}
          onClick={() =>
            act('command', {
              turret_ref: 'this',
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
              turret_ref: 'this',
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
                turret_ref: 'this',
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

export const TurretsWindow = (props, context) => {
  const { act, data } = useBackend<TurretData>(context);

  return (
    <Section>
      {data.turrets.map((turret) => (
        <Section title={turret.name} key={turret.name}>
          <LabeledList>
            <LabeledList.Item label="Turret Status">
              <Button
                content={turret.enabled ? 'Enabled' : 'Disabled'}
                color={turret.enabled ? 'bad' : 'good'}
                disabled={data.locked}
                onClick={() =>
                  act('command', {
                    turret_ref: turret.ref,
                    value: !turret.enabled,
                    command: 'enable',
                  })
                }
              />
            </LabeledList.Item>
            <LabeledList.Item label="Lethal Mode">
              <Button
                content={turret.lethal ? 'On' : 'Off'}
                color={turret.lethal ? 'bad' : 'average'}
                disabled={data.locked}
                onClick={() =>
                  act('command', {
                    turret_ref: turret.ref,
                    value: !turret.lethal,
                    command: 'lethal',
                  })
                }
              />
            </LabeledList.Item>
            {turret.settings.map((setting) => (
              <LabeledList.Item label={setting.category} key={setting.category}>
                <Button
                  content={setting.value ? 'On' : 'Off'}
                  selected={setting.value}
                  disabled={data.locked}
                  onClick={() =>
                    act('command', {
                      turret_ref: turret.ref,
                      value: !setting.value,
                      command: setting.variable_name,
                    })
                  }
                />
              </LabeledList.Item>
            ))}
          </LabeledList>
        </Section>
      ))}
    </Section>
  );
};

import { Button, Input, LabeledList, Section } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { useBackend } from '../backend';
import { Window } from '../layouts';

export type MaglockData = {
  locked: BooleanLike;
};

export const Maglock = (props) => {
  const { act, data } = useBackend<MaglockData>();

  return (
    <Window>
      <Window.Content scrollable>
        <Section title="Unlock">
          <LabeledList>
            <LabeledList.Item label="Passcode">
              <Input
                onChange={(e, value) => act('passcode', { passcode: value })}
              />
            </LabeledList.Item>
          </LabeledList>
          {!data.locked ? <ConfigureWindow /> : ''}
        </Section>
      </Window.Content>
    </Window>
  );
};

export const ConfigureWindow = (props) => {
  const { act, data } = useBackend<MaglockData>();

  return (
    <Section title="Configure">
      <LabeledList>
        <LabeledList.Item label="Passcode">
          <Input
            onChange={(e, value) =>
              act('set_passcode', { set_passcode: value })
            }
          />
        </LabeledList.Item>
        <LabeledList.Item label="Lock">
          <Button content="Lock" icon="lock" onClick={() => act('lock')} />
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

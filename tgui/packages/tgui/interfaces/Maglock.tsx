import { useBackend } from '../backend';
import { LabeledList, Input, Section } from '../components';
import { Window } from '../layouts';

export type MaglockData = {

}

export const Maglock = (props, context) => {
  const { act, data } = useBackend<MaglockData>(context);

  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section title="Unlock">
          <LabeledList>
            <LabeledList.Item label="Passcode:">
              <Input
                onChange={(e, value) => act('passcode', { passcode : value })}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};

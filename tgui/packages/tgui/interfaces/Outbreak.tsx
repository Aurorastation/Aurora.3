import { useBackend } from '../backend';
import { Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

export type OutbreakData = {};

export const Outbreak = (props, context) => {
  const { act, data } = useBackend<OutbreakData>(context);

  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section title="Outbreak Controller">
          <LabeledList>
            <LabeledList.Item label="Group Zombie Spawn">
              <Button
                content="Spawn"
                icon="radiation"
                onClick={() => act('group_spawn')}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};

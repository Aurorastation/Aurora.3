import { useBackend, useLocalState } from '../backend';
import { Button, LabeledList, NumberInput, Section } from '../components';
import { Window } from '../layouts';

export type OutbreakData = {};

export const Outbreak = (props, context) => {
  const { act, data } = useBackend<OutbreakData>(context);
  const [SpecZombieAmt, setSpecZombieAmt] = useLocalState<number>(
    context,
    'SpecZombieAmt',
    1
  );

  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section title="Outbreak Controller">
          <LabeledList>
            <LabeledList.Item label="AI Zombie Spawn">
              <Button
                content="Spawn"
                icon="radiation"
                onClick={() => act('group_spawn')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Special Zombie Spawn">
              <Button
                content="Spawn"
                icon="radiation"
                onClick={() =>
                  act('group_spawn_special', {
                    group_spawn_special: { SpecZombieAmt },
                  })
                }
              />
              &nbsp;
              <NumberInput
                value={SpecZombieAmt}
                minValue={1}
                maxValue={10}
                step={1}
                stepPixelSize={10}
                onChange={(e, value) => setSpecZombieAmt(value)}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};

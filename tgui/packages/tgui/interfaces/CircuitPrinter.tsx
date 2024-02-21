import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Button, LabeledList, ProgressBar, Section } from '../components';
import { Window } from '../layouts';

export type PrinterData = {
  metal: number;
  metal_max: number;
  upgraded: BooleanLike;
  can_clone: BooleanLike;
  assembly_to_clone: string;
  circuits: Circuit[];
  categories: string[];
};

type Circuit = {
  path: string;
  name: string;
  desc: string;
  basic: BooleanLike;
  category: string;
};

export const CircuitPrinter = (props, context) => {
  const { act, data } = useBackend<PrinterData>(context);

  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section title="Status">
          <LabeledList>
            <LabeledList.Item label="Metal">
              <ProgressBar
                ranges={{
                  good: [data.metal_max * 0.75, data.metal_max],
                  average: [data.metal_max * 0.3, data.metal_max * 0.75],
                  bad: [0, data.metal_max * 0.3],
                }}
                value={data.metal}
                minValue={0}
                maxValue={data.metal_max}>
                {data.metal} sheets
              </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Item label="Upgraded">
              {data.upgraded ? 'Yes' : 'No'}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        {data.categories.sort().map((category) => (
          <Section title={category} key={category}>
            {data.circuits.map((circuit) =>
              circuit.category === category ? (
                <Button
                  content={circuit.name}
                  onClick={() => act('build', { build: circuit.path })}
                />
              ) : (
                ''
              )
            )}
          </Section>
        ))}
      </Window.Content>
    </Window>
  );
};

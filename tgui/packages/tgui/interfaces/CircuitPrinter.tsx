import { BooleanLike } from '../../common/react';
import { useBackend, useLocalState } from '../backend';
import {
  Button,
  Input,
  LabeledList,
  ProgressBar,
  Section,
} from '../components';
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

  const [searchTerm, setSearchTerm] = useLocalState<string>(
    context,
    'searchTerm',
    '',
  );

  const normalizedSearchTerm = searchTerm.toLowerCase();

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
                maxValue={data.metal_max}
              >
                {data.metal} sheets
              </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Item label="Upgraded">
              {data.upgraded ? 'Yes' : 'No'}
            </LabeledList.Item>
          </LabeledList>
        </Section>

        <Section
          title="Circuits"
          buttons={
            <Input
              autoFocus
              autoSelect
              placeholder="Search categories or circuits"
              maxLength={512}
              onInput={(e, value) => {
                setSearchTerm(value);
              }}
              value={searchTerm}
            />
          }
        >
          {data.categories.sort().map((category) => {
            const categoryMatches =
              category.toLowerCase().indexOf(normalizedSearchTerm) > -1;

            const circuits = data.circuits.filter((circuit) => {
              if (circuit.category !== category) {
                return false;
              }

              if (!normalizedSearchTerm) {
                return true;
              }

              if (categoryMatches) {
                return true;
              }

              return (
                circuit.name?.toLowerCase().indexOf(normalizedSearchTerm) > -1
              );
            });

            if (!circuits.length) {
              return null;
            }

            return (
              <Section title={category} key={category}>
                {circuits.map((circuit) => (
                  <Button
                    key={circuit.path}
                    content={circuit.name}
                    tooltip={circuit.desc}
                    onClick={() => act('build', { build: circuit.path })}
                  />
                ))}
              </Section>
            );
          })}
        </Section>
      </Window.Content>
    </Window>
  );
};

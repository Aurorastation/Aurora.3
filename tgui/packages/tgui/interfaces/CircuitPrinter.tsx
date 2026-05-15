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
  phoron: number;
  phoron_max: number;
  upgraded: BooleanLike;
  can_clone: BooleanLike;
  assembly_to_clone: string;
  clone_cost: number;
  clone_print_time: number;
  currently_printing: BooleanLike;
  has_clone_blueprint: BooleanLike;
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
            <LabeledList.Item label="Phoron">
              <ProgressBar
                ranges={{
                  good: [data.phoron_max * 0.75, data.phoron_max],
                  average: [data.phoron_max * 0.3, data.phoron_max * 0.75],
                  bad: [0, data.phoron_max * 0.3],
                }}
                value={data.phoron}
                minValue={0}
                maxValue={data.phoron_max}
              >
                {data.phoron} sheets
              </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Item label="Upgraded">
              {data.upgraded ? 'Yes' : 'No'}
            </LabeledList.Item>
            <LabeledList.Item label="Cloner">
              {data.can_clone ? 'Installed' : 'Not Installed'}
            </LabeledList.Item>
            <LabeledList.Item label="Printing">
              {data.currently_printing ? 'Yes' : 'No'}
            </LabeledList.Item>
          </LabeledList>
        </Section>

        {!!data.can_clone && (
          <Section title="Circuit Cloning">
            <LabeledList>
              <LabeledList.Item label="Loaded Blueprint">
                {data.assembly_to_clone || 'None'}
              </LabeledList.Item>
              <LabeledList.Item label="Clone Cost">
                {data.assembly_to_clone && data.assembly_to_clone !== 'None'
                  ? `${data.clone_cost} sheets`
                  : 'N/A'}
              </LabeledList.Item>
              <LabeledList.Item label="Print Time">
                {data.assembly_to_clone && data.assembly_to_clone !== 'None'
                  ? `${data.clone_print_time} seconds`
                  : 'N/A'}
              </LabeledList.Item>
            </LabeledList>

            <Button
              content="Clone Assembly"
              icon="copy"
              disabled={
                !data.assembly_to_clone ||
                data.assembly_to_clone === 'None' ||
                data.currently_printing ||
                data.metal < data.clone_cost
              }
              onClick={() => act('clone')}
            />
            <Button
              content="Clear Scan"
              icon="times"
              disabled={
                !data.assembly_to_clone ||
                data.assembly_to_clone === 'None' ||
                data.currently_printing
              }
              onClick={() => act('clear_clone')}
            />
            <Button
              content="Export Blueprint"
              icon="file-export"
              disabled={
                !data.assembly_to_clone ||
                data.assembly_to_clone === 'None' ||
                data.currently_printing
              }
              onClick={() => act('export_clone')}
            />
            <Button
              content="Import Blueprint"
              icon="file-import"
              disabled={data.currently_printing}
              onClick={() => act('import_clone')}
            />
            <Button
              content="Clear Imported Blueprint"
              icon="trash"
              disabled={!data.has_clone_blueprint || data.currently_printing}
              onClick={() => act('clear_imported_clone')}
            />
          </Section>
        )}

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
                    disabled={data.currently_printing}
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

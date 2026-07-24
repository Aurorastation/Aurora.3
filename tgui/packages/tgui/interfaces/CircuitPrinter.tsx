import {
  Button,
  Input,
  LabeledList,
  ProgressBar,
  Section,
  TextArea,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { useBackend, useLocalState } from '../backend';
import { Window } from '../layouts';

const BLUEPRINT_IMPORT_CHUNK_DELAY = 250;

const sleep = (duration: number) =>
  new Promise((resolve) => setTimeout(resolve, duration));

export type PrinterData = {
  metal: number;
  metal_max: number;
  phoron: number;
  phoron_max: number;
  upgraded: BooleanLike;
  can_clone: BooleanLike;
  assembly_to_clone: string;
  clone_cost: number;
  clone_phoron_cost: number;
  clone_print_time: number;
  currently_printing: BooleanLike;
  has_clone_loaded: BooleanLike;
  has_live_clone_scan: BooleanLike;
  has_clone_blueprint: BooleanLike;
  has_clone_blueprint_export: BooleanLike;
  clone_blueprint_export_visible: BooleanLike;
  clone_blueprint_export: string;
  blueprint_chunk_limit: number;
  blueprint_buffer_limit: number;
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

type CircuitSubgroup = {
  key: string;
  group: string;
  subgroup: string;
  circuits: Circuit[];
};

type CircuitGroup = {
  group: string;
  subgroups: CircuitSubgroup[];
};

const splitCircuitCategory = (category: string) => {
  const separator = ' - ';
  const subgroupedGroups = ['LOGIC', 'MATH'];
  const separatorIndex = category.indexOf(separator);
  const group = category.slice(0, separatorIndex);

  if (separatorIndex < 0 || !subgroupedGroups.includes(group)) {
    return {
      group: category,
      subgroup: category,
    };
  }

  return {
    group,
    subgroup: category.slice(separatorIndex + separator.length),
  };
};

export const CircuitPrinter = (props) => {
  const { act, data } = useBackend<PrinterData>();

  const [searchTerm, setSearchTerm] = useLocalState<string>('searchTerm', '');
  const [blueprintText, setBlueprintText] = useLocalState<string>(
    'blueprintText',
    '',
  );
  const [showBlueprintImport, setShowBlueprintImport] = useLocalState<boolean>(
    'showBlueprintImport',
    false,
  );
  const [isImportingBlueprint, setIsImportingBlueprint] =
    useLocalState<boolean>('isImportingBlueprint', false);
  const [collapsedCategories, setCollapsedCategories] = useLocalState<
    Record<string, boolean>
  >('collapsedCategories', {});

  const normalizedSearchTerm = searchTerm.toLowerCase();
  const categories = [...data.categories].sort();
  const categoryGroups = categories.reduce<CircuitGroup[]>(
    (groups, category) => {
      const { group, subgroup } = splitCircuitCategory(category);
      const groupMatches = group.toLowerCase().includes(normalizedSearchTerm);
      const subgroupMatches = subgroup
        .toLowerCase()
        .includes(normalizedSearchTerm);
      const categoryMatches = category
        .toLowerCase()
        .includes(normalizedSearchTerm);

      const circuits = data.circuits.filter((circuit) => {
        if (circuit.category !== category) {
          return false;
        }

        if (
          !normalizedSearchTerm ||
          groupMatches ||
          subgroupMatches ||
          categoryMatches
        ) {
          return true;
        }

        return !!circuit.name?.toLowerCase().includes(normalizedSearchTerm);
      });

      if (!circuits.length) {
        return groups;
      }

      let circuitGroup = groups.find((entry) => entry.group === group);

      if (!circuitGroup) {
        circuitGroup = {
          group,
          subgroups: [],
        };
        groups.push(circuitGroup);
      }

      circuitGroup.subgroups.push({
        key: category,
        group,
        subgroup,
        circuits,
      });

      return groups;
    },
    [],
  );

  categoryGroups.sort((a, b) => a.group.localeCompare(b.group));
  categoryGroups.forEach((group) => {
    group.subgroups.sort((a, b) => a.subgroup.localeCompare(b.subgroup));
  });

  const importPastedBlueprint = async () => {
    const importText = blueprintText;

    if (!importText || isImportingBlueprint) {
      return;
    }

    setIsImportingBlueprint(true);

    let offset = 0;
    const chunkLimit = Math.max(1, data.blueprint_chunk_limit || 1000);
    const bufferLimit = data.blueprint_buffer_limit || 500000;

    if (importText.length > bufferLimit) {
      act('reject_oversized_import_tgui', {
        length: importText.length,
      });
      setIsImportingBlueprint(false);
      return;
    }

    try {
      await act('begin_import_buffer');

      while (offset < importText.length) {
        const chunk = importText.slice(offset, offset + chunkLimit);

        await act('append_import_chunk_tgui', {
          chunk: encodeURIComponent(chunk),
        });

        offset += chunk.length;
        await sleep(BLUEPRINT_IMPORT_CHUNK_DELAY);
      }

      await act('finish_import_buffer_tgui');
    } finally {
      setIsImportingBlueprint(false);
    }
  };

  return (
    <Window width={720} height={760}>
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
              <LabeledList.Item label="Steel Cost">
                {data.assembly_to_clone && data.assembly_to_clone !== 'None'
                  ? `${data.clone_cost} sheets`
                  : 'N/A'}
              </LabeledList.Item>
              <LabeledList.Item label="Phoron Cost">
                {data.assembly_to_clone && data.assembly_to_clone !== 'None'
                  ? `${data.clone_phoron_cost} sheets`
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
                !data.has_clone_loaded ||
                data.currently_printing ||
                data.metal < data.clone_cost ||
                data.phoron < data.clone_phoron_cost
              }
              onClick={() => act('clone')}
            />
            <Button
              content="Clear Scan"
              icon="times"
              disabled={!data.has_live_clone_scan || data.currently_printing}
              onClick={() => act('clear_clone')}
            />
            <Button
              content={
                showBlueprintImport ? 'Cancel Import' : 'Import Blueprint'
              }
              icon="file-import"
              disabled={data.currently_printing || isImportingBlueprint}
              onClick={() => {
                setShowBlueprintImport(!showBlueprintImport);
                act('hide_clone_blueprint_export');
              }}
            />
            <Button
              content={
                data.clone_blueprint_export_visible
                  ? 'Hide Export'
                  : 'Export Blueprint'
              }
              icon="file-export"
              disabled={
                !data.has_clone_blueprint_export ||
                data.currently_printing ||
                isImportingBlueprint
              }
              onClick={() => {
                setShowBlueprintImport(false);
                act(
                  data.clone_blueprint_export_visible
                    ? 'hide_clone_blueprint_export'
                    : 'show_clone_blueprint_export',
                );
              }}
            />
            <Button
              content="Clear Imported Blueprint"
              icon="trash"
              disabled={!data.has_clone_blueprint || data.currently_printing}
              onClick={() => act('clear_imported_clone')}
            />
            {showBlueprintImport && (
              <>
                <TextArea
                  fluid
                  height="240px"
                  mt={0.5}
                  placeholder="Paste blueprint JSON"
                  value={blueprintText}
                  onChange={setBlueprintText}
                  style={{
                    fontFamily: 'monospace',
                  }}
                />
                <Button
                  mt={0.5}
                  content={
                    isImportingBlueprint
                      ? 'Importing Blueprint'
                      : 'Import Pasted Blueprint'
                  }
                  icon="file-import"
                  disabled={
                    !blueprintText ||
                    data.currently_printing ||
                    isImportingBlueprint
                  }
                  onClick={importPastedBlueprint}
                />
              </>
            )}
            {!!data.clone_blueprint_export_visible && (
              <TextArea
                fluid
                height="240px"
                mt={0.5}
                value={data.clone_blueprint_export}
                style={{
                  fontFamily: 'monospace',
                }}
              />
            )}
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
              onChange={setSearchTerm}
              value={searchTerm}
            />
          }
        >
          {categoryGroups.map(({ group, subgroups }) => {
            const circuitCount = subgroups.reduce(
              (count, subgroup) => count + subgroup.circuits.length,
              0,
            );
            const hasSubgroups = ['LOGIC', 'MATH'].includes(group);
            const groupCollapsed = !!collapsedCategories[group];

            return (
              <Section
                title={`${group} (${circuitCount})`}
                key={group}
                buttons={
                  <Button
                    icon={groupCollapsed ? 'chevron-right' : 'chevron-down'}
                    tooltip={
                      groupCollapsed ? 'Expand category' : 'Collapse category'
                    }
                    onClick={() =>
                      setCollapsedCategories({
                        ...collapsedCategories,
                        [group]: !collapsedCategories[group],
                      })
                    }
                  />
                }
              >
                {!groupCollapsed &&
                  !hasSubgroups &&
                  subgroups.flatMap(({ circuits }) =>
                    circuits.map((circuit) => (
                      <Button
                        key={circuit.path}
                        content={circuit.name}
                        tooltip={circuit.desc}
                        disabled={data.currently_printing}
                        onClick={() => act('build', { build: circuit.path })}
                      />
                    )),
                  )}
                {!groupCollapsed &&
                  hasSubgroups &&
                  subgroups.map(({ key, subgroup, circuits }) => {
                    const subgroupCollapsed = !!collapsedCategories[key];

                    return (
                      <Section
                        title={`${subgroup} (${circuits.length})`}
                        key={key}
                        buttons={
                          <Button
                            icon={
                              subgroupCollapsed
                                ? 'chevron-right'
                                : 'chevron-down'
                            }
                            tooltip={
                              subgroupCollapsed
                                ? 'Expand category'
                                : 'Collapse category'
                            }
                            onClick={() =>
                              setCollapsedCategories({
                                ...collapsedCategories,
                                [key]: !collapsedCategories[key],
                              })
                            }
                          />
                        }
                      >
                        {!subgroupCollapsed &&
                          circuits.map((circuit) => (
                            <Button
                              key={circuit.path}
                              content={circuit.name}
                              tooltip={circuit.desc}
                              disabled={data.currently_printing}
                              onClick={() =>
                                act('build', { build: circuit.path })
                              }
                            />
                          ))}
                      </Section>
                    );
                  })}
              </Section>
            );
          })}
        </Section>
      </Window.Content>
    </Window>
  );
};

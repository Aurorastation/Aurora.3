import { round } from '../../common/math';
import { useBackend } from '../backend';
import { Button, Flex, LabeledList, ProgressBar, Section, Table, Tabs } from '../components';
import { Window } from '../layouts';

export type FabricatorData = {
  manufacturer: string;

  current: string;
  queue: string; // just an english_listed string
  buildable: BuildableItem[];
  category: string;
  available_categories: Category[];

  manufacturers: Manufacturer[];
  selected_manufacturer: string;

  materials: Material[];
  maximum_resource_amount: number;

  sync: string;

  timeleft: number;
};

type BuildableItem = {
  name: string;
  type: string;
  category: string;
  resources: string;
  time: string;
};

type Category = {
  name: string;
};

type Manufacturer = {
  name: string;
  type: string;
};

type Material = {
  name: string;
  amount: number;
};

export const SyntheticFabricator = (props, context) => {
  const { act, data } = useBackend<FabricatorData>(context);

  return (
    <Window resizable theme={data.manufacturer}>
      <Window.Content scrollable>
        <Flex fontSize="1.2rem" wrap="wrap">
          <Flex.Item>
            <Section title="Manufacturers">
              {data.manufacturers.map((manufacturer) => (
                <Button
                  key={manufacturer.type}
                  content={manufacturer.name}
                  selected={data.selected_manufacturer === manufacturer.name}
                  onClick={() =>
                    act('manufacturer', { manufacturer: manufacturer.name })
                  }
                />
              ))}
            </Section>
          </Flex.Item>
          <Flex.Item>
            <Section title="Materials">
              <LabeledList>
                {data.materials.map((material) => (
                  <LabeledList.Item label={material.name} key={material.name}>
                    <ProgressBar
                      ranges={{
                        good: [
                          data.maximum_resource_amount * 0.75,
                          data.maximum_resource_amount,
                        ],
                        average: [
                          data.maximum_resource_amount * 0.3,
                          data.maximum_resource_amount * 0.75,
                        ],
                        bad: [0, data.maximum_resource_amount * 0.3],
                      }}
                      value={round(material.amount, 1)}
                      maxValue={data.maximum_resource_amount}
                      minValue={0}>
                      {material.amount} / {data.maximum_resource_amount}{' '}
                      <Button
                        icon="eject"
                        color="bad"
                        tooltip="Eject"
                        onClick={() =>
                          act('eject', {
                            eject: material.name,
                            amount: -1,
                          })
                        }
                      />
                    </ProgressBar>
                  </LabeledList.Item>
                ))}
              </LabeledList>
            </Section>
          </Flex.Item>
          <Flex.Item>
            <Section title="Components">
              <Tabs>
                {data.available_categories.map((category) => (
                  <Tabs.Tab
                    textAlign="center"
                    selected={data.category === category.name}
                    key={category.name}
                    collapsing
                    onClick={() =>
                      act('category', { 'category': category.name })
                    }>
                    {category.name}
                  </Tabs.Tab>
                ))}
              </Tabs>
              <Table>
                <Table.Row header>
                  <Table.Cell>Component</Table.Cell>
                  <Table.Cell>Resources</Table.Cell>
                  <Table.Cell>Time</Table.Cell>
                </Table.Row>
                {data.buildable.map((buildable) => (
                  <Table.Row key={buildable.name}>
                    <Table.Cell>
                      <Button
                        content={buildable.name}
                        onClick={() => act('build', { build: buildable.type })}
                      />
                    </Table.Cell>
                    <Table.Cell>{buildable.resources}</Table.Cell>
                    <Table.Cell>{buildable.time}</Table.Cell>
                  </Table.Row>
                ))}
              </Table>
            </Section>
          </Flex.Item>
        </Flex>
      </Window.Content>
    </Window>
  );
};

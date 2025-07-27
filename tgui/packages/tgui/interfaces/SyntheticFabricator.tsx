import { round } from '../../common/math';
import { useBackend } from '../backend';
import { AnimatedNumber, Box, Button, Flex, LabeledControls, LabeledList, ProgressBar, Section, Table, Tabs } from '../components';
import { Window } from '../layouts';

export type FabricatorData = {
  manufacturer: string;

  current: string;
  queue: QueueItem[];
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

type QueueItem = {
  name: string;
  time: string;
  index: number;
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
        <Flex fontSize="1.2rem" wrap>
          <Flex.Item>
            <Section title="Materials" fill>
              <LabeledControls>
                {data.materials.map((material) => (
                  <LabeledControls.Item
                    key={material.name}
                    label={
                      <Button
                        icon="eject"
                        content={material.name}
                        tooltip="Eject"
                        color="grey"
                        onClick={() =>
                          act('eject', {
                            eject: material.name,
                            amount: material.amount,
                          })
                        }
                      />
                    }>
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
                    </ProgressBar>
                  </LabeledControls.Item>
                ))}
              </LabeledControls>
            </Section>
          </Flex.Item>
          <Flex.Item>
            <Section title="Manufacturers" fill>
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
              <Section title="Components" fill>
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
                          onClick={() =>
                            act('build', { build: buildable.type })
                          }
                        />
                      </Table.Cell>
                      <Table.Cell>{buildable.resources}</Table.Cell>
                      <Table.Cell>{buildable.time}</Table.Cell>
                    </Table.Row>
                  ))}
                </Table>
              </Section>
            </Section>
          </Flex.Item>
        </Flex>
        <Flex.Item>
          <Section title="Queue" fill>
            {data.queue.length ? (
              <>
                <Box>
                  Time remaining:{' '}
                  <AnimatedNumber value={data.timeleft} initial={0} />.
                </Box>
                <LabeledList>
                  {data.queue.map((queue) => (
                    <LabeledList.Item key={queue.name} label={queue.name}>
                      {queue.time}{' '}
                      <Button
                        icon="cancel"
                        color="red"
                        onClick={() => act('remove', { remove: queue.index })}
                      />
                    </LabeledList.Item>
                  ))}
                </LabeledList>
              </>
            ) : (
              'The manufacturing queue is currently empty.'
            )}
          </Section>
        </Flex.Item>
      </Window.Content>
    </Window>
  );
};

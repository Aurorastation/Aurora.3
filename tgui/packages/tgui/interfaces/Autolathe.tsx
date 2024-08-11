import { round } from '../../common/math';
import { BooleanLike } from '../../common/react';
import { capitalizeAll } from '../../common/string';
import { useBackend, useLocalState } from '../backend';
import { Box, Button, Input, LabeledList, NoticeBox, ProgressBar, Section, Stack, Table, Tabs } from '../components';
import { Window } from '../layouts';

export type AutolatheData = {
  disabled: BooleanLike;
  material_efficiency: number;
  build_time: number;
  materials: Material[];
  recipes: Recipe[];
  categories: string[];
  queue: QueueItem[];
  currently_printing: string;
};

type Material = {
  material: string;
  stored: number;
  max_capacity: number;
};

type Recipe = {
  name: string;
  category: string;
  resources: string;
  max_sheets: number;
  sheets: number;
  can_make: BooleanLike;
  recipe: string;
  hidden: BooleanLike;
};

type QueueItem = {
  ref: string;
  order: string;
  path: string;
  multiplier: number;
  build_time: number;
  progress: number;
};

export const Autolathe = (props, context) => {
  const { act, data } = useBackend<AutolatheData>(context);
  const [tab, setTab] = useLocalState(context, 'tab', 'All');

  return (
    <Window resizable theme="hephaestus" width="1000" height="700">
      <Window.Content scrollable>
        <Stack vertical fill>
          <Stack.Item>
            <Section fill title="Materials">
              <LabeledList>
                {data.materials.map((material) => (
                  <LabeledList.Item
                    key={material.material}
                    label={
                      <Box bold fontSize={1.4}>
                        {capitalizeAll(material.material)}
                      </Box>
                    }>
                    <ProgressBar
                      ranges={{
                        good: [
                          material.max_capacity * 0.75,
                          material.max_capacity,
                        ],
                        average: [
                          material.max_capacity * 0.3,
                          material.max_capacity * 0.75,
                        ],
                        bad: [0, material.max_capacity * 0.3],
                      }}
                      value={round(material.stored, 1)}
                      maxValue={material.max_capacity}
                      minValue={0}>
                      {material.stored} / {material.max_capacity}
                    </ProgressBar>
                  </LabeledList.Item>
                ))}
              </LabeledList>
            </Section>
          </Stack.Item>
          <Stack>
            <Stack.Item width={'175px'}>
              <Tabs vertical>
                {data.categories.map((category) => (
                  <Tabs.Tab
                    textAlign="center"
                    selected={category === tab}
                    key={category}
                    onClick={() => setTab(category)}>
                    {category}
                  </Tabs.Tab>
                ))}
              </Tabs>
            </Stack.Item>
            <Stack.Item grow>
              {tab ? <CategoryData /> : 'No category selected.'}
            </Stack.Item>
            <Stack.Item grow>
              <QueueData />
            </Stack.Item>
          </Stack>
        </Stack>
      </Window.Content>
    </Window>
  );
};

export const CategoryData = (props, context) => {
  const { act, data } = useBackend<AutolatheData>(context);
  const [tab, setTab] = useLocalState(context, 'tab', 'All');
  const [searchTerm, setSearchTerm] = useLocalState<string>(
    context,
    `searchTerm`,
    ``
  );
  const [amount, setAmount] = useLocalState(context, 'amount', 1);

  return (
    <Section
      fill
      title={tab}
      buttons={
        <Input
          autoFocus
          autoSelect
          placeholder="Search by name"
          maxLength={512}
          onInput={(e, value) => {
            setSearchTerm(value);
          }}
          value={searchTerm}
        />
      }>
      <Table collapsing>
        <Table.Row header>
          <Table.Cell>Recipe</Table.Cell>
          <Table.Cell>Resources</Table.Cell>
        </Table.Row>
        {data.recipes
          .filter(
            (c) => c.name?.toLowerCase().indexOf(searchTerm.toLowerCase()) > -1
          )
          .map((recipe) =>
            recipe.category === tab || tab === 'All' ? (
              <Table.Row>
                <Table.Cell py={0.25}>
                  <Button
                    content={
                      <Box bold color={recipe.hidden ? 'red' : ''}>
                        {capitalizeAll(recipe.name)}
                      </Box>
                    }
                    disabled={recipe.can_make}
                    color="transparent"
                    onClick={() =>
                      act('make', { multiplier: 1, recipe: recipe.recipe })
                    }
                  />
                  {recipe.max_sheets ? (
                    <>
                      {' '}
                      <Button
                        content={
                          <Box bold color={recipe.hidden ? 'red' : ''}>
                            [x5]
                          </Box>
                        }
                        disabled={recipe.can_make}
                        color="transparent"
                        onClick={() =>
                          act('make', { multiplier: 5, recipe: recipe.recipe })
                        }
                      />
                      <Button
                        content={
                          <Box bold color={recipe.hidden ? 'red' : ''}>
                            [x10]
                          </Box>
                        }
                        disabled={recipe.can_make}
                        color="transparent"
                        onClick={() =>
                          act('make', { multiplier: 10, recipe: recipe.recipe })
                        }
                      />
                      <Button
                        content={
                          <Box bold color={recipe.hidden ? 'red' : ''}>
                            [x{recipe.max_sheets}]
                          </Box>
                        }
                        disabled={recipe.can_make}
                        color="transparent"
                        onClick={() =>
                          act('make', {
                            multiplier: recipe.max_sheets,
                            recipe: recipe.recipe,
                          })
                        }
                      />
                    </>
                  ) : (
                    ''
                  )}
                </Table.Cell>
                <Table.Cell collapsing>
                  <Button
                    color="transparent"
                    tooltip={recipe.resources}
                    icon="question"
                  />
                </Table.Cell>
              </Table.Row>
            ) : (
              ''
            )
          )}
      </Table>
    </Section>
  );
};

export const QueueData = (props, context) => {
  const { act, data } = useBackend<AutolatheData>(context);

  return (
    <Section fill title="Queue">
      <LabeledList>
        {data.queue && data.queue.length ? (
          data.queue.map((queue_item) => (
            <LabeledList.Item
              key={queue_item.ref}
              label={capitalizeAll(queue_item.order)}>
              <ProgressBar
                minValue={0}
                maxValue={queue_item.build_time}
                value={queue_item.progress}
                ranges={{
                  good: [queue_item.build_time * 0.5, queue_item.build_time],
                  average: [
                    queue_item.build_time * 0.25,
                    queue_item.build_time * 0.5,
                  ],
                  bad: [0, queue_item.build_time * 0.25],
                }}>
                {round(queue_item.progress, 1)} / {queue_item.build_time}
                <Button
                  icon="cancel"
                  color="transparent"
                  disabled={queue_item.ref === data.currently_printing}
                  onClick={() => act('remove', { ref: queue_item.ref })}
                />
              </ProgressBar>
            </LabeledList.Item>
          ))
        ) : (
          <NoticeBox>The queue is empty.</NoticeBox>
        )}
      </LabeledList>
    </Section>
  );
};

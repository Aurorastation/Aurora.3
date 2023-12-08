import { round } from '../../common/math';
import { BooleanLike } from '../../common/react';
import { capitalizeAll } from '../../common/string';
import { useBackend, useLocalState } from '../backend';
import { Box, Button, Input, LabeledList, ProgressBar, Section, Stack, Table, Tabs } from '../components';
import { Window } from '../layouts';

export type AutolatheData = {
  disabled: BooleanLike;
  material_efficiency: number;
  materials: Material[];
  recipes: Recipe[];
  categories: string[];
};

type Material = {
  material: string;
  stored: number;
  max_capacity: number;
};

type Recipe = {
  name: string;
  category: string;
  resources: Resource;
  max_sheets: number;
  sheets: number;
  can_make: BooleanLike;
};

type Resource = {
  material: string;
  amount: number;
};

export const Autolathe = (props, context) => {
  const { act, data } = useBackend<AutolatheData>(context);
  const [tab, setTab] = useLocalState(context, 'tab', 'All');

  return (
    <Window resizable theme="hephaestus" width="700" height="700">
      <Window.Content scrollable>
        <Stack vertical fill>
          <Stack.Item>
            <Section fill title="Materials">
              <LabeledList>
                {data.materials.map((material) => (
                  <LabeledList.Item
                    key={material}
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
                      {material.stored}/{material.max_capacity}
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
  const [recipeSelected, selectRecipe] = useLocalState<string>(
    context,
    `recipeSelected`,
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
          width="40vw"
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
                    content={<Box bold>{capitalizeAll(recipe.name)}</Box>}
                    disabled={recipe.can_make}
                    color={recipeSelected === recipe.name ? 'good' : ''}
                    onClick={() => selectRecipe(recipe.name)}
                  />
                  &nbsp;
                  {recipeSelected === recipe.name ? (
                    !recipe.can_make ? (
                      <>
                        <Button content="[1x]" />
                        <Button content="[5x]" />
                        <Button content="[10x]" />
                        {recipe.max_sheets ? (
                          <Button
                            content={
                              <Box>
                                [
                                {recipe.sheets > recipe.max_sheets
                                  ? round(recipe.sheets, 1)
                                  : round(recipe.max_sheets, 1)}
                                x]
                              </Box>
                            }
                          />
                        ) : (
                          ''
                        )}
                      </>
                    ) : (
                      ''
                    )
                  ) : (
                    ''
                  )}
                </Table.Cell>
                <Table.Cell>
                  <Box>
                    {round(recipe.resources.amount, 0.1)}{' '}
                    {recipe.resources.material}
                  </Box>
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

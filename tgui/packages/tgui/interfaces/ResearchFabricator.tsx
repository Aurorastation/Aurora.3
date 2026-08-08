import {
  Box,
  Button,
  Flex,
  LabeledControls,
  LabeledList,
  NoticeBox,
  ProgressBar,
  Section,
  Stack,
  Table,
  Tabs,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { useBackend, useLocalState } from '../backend';
import { SearchBar } from './common/SearchBar';

export type ResearchFabricatorData = {
  linked: BooleanLike;
  materials: ResearchMaterial[];
  reagents: ResearchReagent[];
  recipes: ResearchRecipe[];
  categories: string[];
  queue: ResearchQueueItem[];
  sheet_material_amount: number;
  maximum_material_storage: number;
  maximum_reagent_volume: number;
  reagent_volume: number;
  supports_reagents: BooleanLike;

  supports_manufacturers: BooleanLike;
  manufacturers?: ResearchManufacturer[];
  selected_manufacturer?: string;
};

type ResearchMaterial = {
  id: string;
  name: string;
  amount: number;
  maximum: number;
};

type ResearchReagent = {
  id: string;
  name: string;
  amount: number;
};

type ResearchRequirement = {
  name: string;
  required: number;
  stored: number;
  missing: BooleanLike;
  type: 'material' | 'reagent';
};

type ResearchRecipe = {
  name: string;
  description: string;
  design: string;
  category: string;
  resources: string;
  requirements: ResearchRequirement[];
  can_build: BooleanLike;
  build_time: number;
};

type ResearchQueueItem = {
  index: number;
  name: string;
  build_time: number;
  active: BooleanLike;
  machine: string | null;
  remaining_time: number;
};

type ResearchManufacturer = {
  id: string;
  name: string;
};

type Props = {
  fabricator: ResearchFabricatorData;
  queueAmount: number;
  title: string;
};

export const ResearchFabricator = ({
  fabricator,
  queueAmount,
  title,
}: Props) => {
  const { act } = useBackend();
  const [category, setCategory] = useLocalState(`${title}-category`, 'All');
  const [searchTerm, setSearchTerm] = useLocalState(`${title}-search`, '');
  const search = searchTerm.trim().toLowerCase();
  const recipes = fabricator.recipes.filter((recipe) => {
    if (category !== 'All' && recipe.category !== category) {
      return false;
    }
    return !search || recipe.name.toLowerCase().includes(search);
  });

  return (
    <Stack vertical fill>
      <Stack.Item>
        <Section
          title={title}
          buttons={
            <Button
              icon="arrow-left"
              content="Back"
              onClick={() => act('back')}
            />
          }
        >
          <Flex fontSize="1.2rem" wrap>
            <Flex.Item grow>
              <FabricatorMaterials fabricator={fabricator} />
            </Flex.Item>

            {!!fabricator.supports_reagents && (
              <Flex.Item width="35%">
                <Chemicals fabricator={fabricator} />
              </Flex.Item>
            )}
          </Flex>
        </Section>
      </Stack.Item>

      {!!fabricator.supports_manufacturers && (
        <Stack.Item>
          <Manufacturers fabricator={fabricator} />
        </Stack.Item>
      )}

      <Stack.Item grow>
        <Stack fill>
          <Stack.Item width="180px">
            <Tabs vertical>
              {fabricator.categories.map((entry) => (
                <Tabs.Tab
                  key={entry}
                  selected={entry === category}
                  onClick={() => setCategory(entry)}
                >
                  {entry}
                </Tabs.Tab>
              ))}
            </Tabs>
          </Stack.Item>

          <Stack.Item grow>
            <Stack vertical fill>
              <Stack.Item>
                <Section>
                  <Stack align="center">
                    <Stack.Item grow>
                      <SearchBar
                        autoFocus
                        placeholder="Search designs"
                        query={searchTerm}
                        onSearch={setSearchTerm}
                      />
                    </Stack.Item>
                    <Stack.Item>
                      <Box inline mr={0.5}>
                        Queue amount:
                      </Box>
                      {[1, 5, 10].map((amount) => (
                        <Button
                          key={amount}
                          selected={queueAmount === amount}
                          content={amount}
                          onClick={() =>
                            act('set_queue_amount', { amount })
                          }
                        />
                      ))}
                      <Button
                        selected={![1, 5, 10].includes(queueAmount)}
                        content="×"
                        tooltip={`Choose a custom queue amount. Current: ${queueAmount}`}
                        onClick={() => act('set_custom_queue_amount')}
                      />
                    </Stack.Item>
                  </Stack>
                </Section>
              </Stack.Item>

              <Stack.Item grow>
                <Section fill scrollable title={category}>
              {category === 'All' ? (
                fabricator.categories
                  .filter((entry) => entry !== 'All')
                  .map((entry) => {
                    const categoryRecipes = recipes.filter(
                      (recipe) => recipe.category === entry,
                    );

                    if (!categoryRecipes.length) {
                      return null;
                    }

                    return (
                      <Section key={entry} title={entry}>
                        <RecipeTable
                          recipes={categoryRecipes}
                          queueAmount={queueAmount}
                        />
                      </Section>
                    );
                  })
              ) : (
                <RecipeTable recipes={recipes} queueAmount={queueAmount} />
              )}
                </Section>
              </Stack.Item>
            </Stack>
          </Stack.Item>

          <Stack.Item width="30%">
            <Queue fabricator={fabricator} />
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};


const RecipeTable = ({
  recipes,
  queueAmount,
}: {
  recipes: ResearchRecipe[];
  queueAmount: number;
}) => {
  const { act } = useBackend();

  return (
    <Table>
      <Table.Row header>
        <Table.Cell>Design</Table.Cell>
        <Table.Cell>Resources</Table.Cell>
        <Table.Cell collapsing>Time</Table.Cell>
      </Table.Row>
      {recipes.map((recipe, index) => (
        <Table.Row
          key={recipe.design}
          className={
            index % 2
              ? 'ResearchFabricator__recipeRow--odd'
              : 'ResearchFabricator__recipeRow--even'
          }
        >
          <Table.Cell>
            <Button
              fluid
              icon={recipe.can_build ? 'hammer' : 'triangle-exclamation'}
              disabled={!recipe.can_build}
              content={recipe.name}
              tooltip={
                recipe.can_build
                  ? `${recipe.description}\nQueues ${queueAmount} item${queueAmount === 1 ? '' : 's'}.`
                  : `${recipe.description}\nMissing required materials.`
              }
              onClick={() =>
                act('fabricator_build', {
                  design: recipe.design,
                })
              }
            />
          </Table.Cell>
          <Table.Cell>
            <RecipeRequirements recipe={recipe} />
          </Table.Cell>
          <Table.Cell collapsing>
            {formatDuration(recipe.build_time)}
          </Table.Cell>
        </Table.Row>
      ))}
    </Table>
  );
};

const FabricatorMaterials = ({
  fabricator,
}: {
  fabricator: ResearchFabricatorData;
}) => {
  const { act } = useBackend();
  const sheetSize = fabricator.sheet_material_amount;

  return (
    <Section title="Materials" fill>
      <LabeledControls>
        {fabricator.materials.map((material) => {
          const maximum =
            material.maximum ?? fabricator.maximum_material_storage;

          const sheets = Math.floor(material.amount / sheetSize);

          return (
            <LabeledControls.Item key={material.name} label={material.name}>
              <Button
                content="1"
                tooltip="Eject one sheet"
                color="grey"
                disabled={sheets < 1}
                onClick={() =>
                  act('fabricator_eject', {
                    material: material.id,
                    amount: 1,
                  })
                }
              />

              <Button
                content="5"
                tooltip="Eject five sheets"
                color="grey"
                disabled={sheets < 5}
                onClick={() =>
                  act('fabricator_eject', {
                    material: material.id,
                    amount: 5,
                  })
                }
              />

              <Button
                content="×"
                tooltip="Choose a custom number of sheets to eject"
                color="grey"
                disabled={sheets < 1}
                onClick={() =>
                  act('fabricator_eject_custom', {
                    material: material.id,
                  })
                }
              />

              <Button
                icon="eject"
                tooltip="Eject all complete sheets"
                color="grey"
                disabled={sheets < 1}
                onClick={() =>
                  act('fabricator_eject', {
                    material: material.id,
                    amount: sheets,
                  })
                }
              />

              <ProgressBar
                ranges={{
                  good: [maximum * 0.75, maximum],
                  average: [maximum * 0.3, maximum * 0.75],
                  bad: [0, maximum * 0.3],
                }}
                value={material.amount}
                maxValue={maximum}
                minValue={0}
              >
                {material.amount} / {maximum}
              </ProgressBar>
            </LabeledControls.Item>
          );
        })}
      </LabeledControls>
    </Section>
  );
};

const Chemicals = ({ fabricator }: { fabricator: ResearchFabricatorData }) => {
  const { act } = useBackend();

  return (
    <Section
      title="Chemicals"
      fill
      buttons={
        <Button.Confirm
          icon="trash"
          color="bad"
          content="Purge All"
          disabled={!fabricator.reagents.length}
          onClick={() => act('fabricator_purge_all')}
        />
      }
    >
      <ProgressBar
        value={fabricator.reagent_volume}
        maxValue={fabricator.maximum_reagent_volume}
      >
        {fabricator.reagent_volume} / {fabricator.maximum_reagent_volume}
      </ProgressBar>
      {fabricator.reagents.length ? (
        <Box mt={1}>
          <LabeledList>
            {fabricator.reagents.map((reagent) => (
              <LabeledList.Item
                key={reagent.id}
                label={reagent.name}
                buttons={
                  <Button.Confirm
                    icon="trash"
                    color="bad"
                    tooltip="Purge reagent"
                    onClick={() =>
                      act('fabricator_purge', { reagent: reagent.id })
                    }
                  />
                }
              >
                {reagent.amount} units
              </LabeledList.Item>
            ))}
          </LabeledList>
        </Box>
      ) : (
        <NoticeBox mt={1}>No chemicals stored.</NoticeBox>
      )}
    </Section>
  );
};

const RecipeRequirements = ({ recipe }: { recipe: ResearchRecipe }) => {
  if (!recipe.requirements?.length) {
    return <Box>{recipe.resources}</Box>;
  }

  return (
    <Flex wrap>
      {recipe.requirements.map((requirement) => (
        <Flex.Item
          key={`${requirement.type}-${requirement.name}`}
          mr={0.5}
          mb={0.25}
        >
          <Button
            color="transparent"
            tooltip={`Stored: ${requirement.stored}. Required: ${requirement.required}.`}
            className={
              requirement.missing
                ? 'ResearchFabricator__requirement--missing'
                : 'ResearchFabricator__requirement--available'
            }
          >
            <Box
              inline
              px={0.5}
              py={0.25}
              color={requirement.missing ? 'bad' : 'good'}
            >
              {requirement.name}: {requirement.required}
            </Box>
          </Button>
        </Flex.Item>
      ))}
    </Flex>
  );
};

const Manufacturers = ({
  fabricator,
}: {
  fabricator: ResearchFabricatorData;
}) => {
  const { act } = useBackend();

  return (
    <Section title="Limb Manufacturer">
      {fabricator.manufacturers?.map((manufacturer) => (
        <Button
          key={manufacturer.id}
          content={manufacturer.name}
          selected={fabricator.selected_manufacturer === manufacturer.name}
          onClick={() =>
            act('fabricator_manufacturer', {
              manufacturer: manufacturer.id,
            })
          }
        />
      ))}
    </Section>
  );
};

const Queue = ({ fabricator }: { fabricator: ResearchFabricatorData }) => {
  const { act } = useBackend();

  return (
    <Section fill scrollable title="Queue">
      {fabricator.queue.length ? (
        <LabeledList>
          {fabricator.queue.map((entry) => (
            <LabeledList.Item
              key={entry.index}
              label={entry.name}
              buttons={
                <Button
                  icon="cancel"
                  color="bad"
                  disabled={!!entry.active}
                  tooltip={
                    entry.active
                      ? 'An active build cannot be cancelled.'
                      : 'Remove from queue'
                  }
                  onClick={() =>
                    act('fabricator_remove', { index: entry.index })
                  }
                />
              }
            >
              {entry.active ? (
                <>
                  <Box>{entry.machine ?? 'Fabricator'}</Box>
                  <ProgressBar
                    minValue={0}
                    maxValue={entry.build_time}
                    value={entry.build_time - entry.remaining_time}
                  >
                    {formatDuration(entry.remaining_time)} remaining
                  </ProgressBar>
                </>
              ) : (
                <Box>{formatDuration(entry.build_time)}</Box>
              )}
            </LabeledList.Item>
          ))}
        </LabeledList>
      ) : (
        <NoticeBox>The queue is empty.</NoticeBox>
      )}
    </Section>
  );
};

const formatDuration = (deciseconds: number) => {
  const totalSeconds = Math.max(0, Math.ceil(deciseconds / 10));
  const minutes = Math.floor(totalSeconds / 60);
  const seconds = totalSeconds % 60;

  if (minutes > 0) {
    return `${minutes}:${seconds.toString().padStart(2, '0')}`;
  }

  return `${seconds}s`;
};

import { useBackend, useLocalState } from '../backend';
import { Box, Input, LabeledList, NoticeBox, Section, Table } from '../components';
import { NtosWindow } from '../layouts';

export type CodexData = {
  recipes: Recipe[];
};

type Recipe = {
  result: string;
  result_image: any; // base64 icon
  ingredients: string;
  appliances: string;
};

export const CookingCodex = (props, context) => {
  const { act, data } = useBackend<CodexData>(context);
  const [searchTerm, setSearchTerm] = useLocalState<string>(
    context,
    `searchTerm`,
    ``
  );

  return (
    <NtosWindow resizable theme="idris">
      <NtosWindow.Content scrollable>
        <Section
          title="Codex Search"
          fitted
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
          <Table collapsing pl="20px" pr="20px">
            <Table.Row header className="candystripe">
              <Table.Cell textAlign="right">Result</Table.Cell>
              <Table.Cell></Table.Cell>
              <Table.Cell>Ingredients</Table.Cell>
              <Table.Cell>Appliances</Table.Cell>
            </Table.Row>
            {data?.recipes
              .filter((recipe) => {
                return (
                  recipe.result
                    ?.toLowerCase()
                    .indexOf(searchTerm.toLowerCase()) > -1 ||
                  recipe.ingredients
                    ?.toLowerCase()
                    .indexOf(searchTerm.toLowerCase()) > -1 ||
                  recipe.appliances
                    ?.toLowerCase()
                    .indexOf(searchTerm.toLowerCase()) > -1
                );
              })
              .sort((a, b) => a.result.localeCompare(b.result))
              .map((recipe) => (
                <Table.Row header className="candystripe">
                  <Table.Cell textAlign="right" pl="5px">
                    {recipe.result.toLocaleLowerCase()}
                  </Table.Cell>
                  <Table.Cell>
                    <Box
                      as="img"
                      m={0}
                      src={`data:image/jpeg;base64,${recipe.result_image}`}
                      width="60px"
                      height="60px"
                      style={{
                        '-ms-interpolation-mode': 'nearest-neighbor',
                      }}
                    />
                  </Table.Cell>
                  <Table.Cell>
                    {recipe.ingredients.toLocaleLowerCase()}
                  </Table.Cell>
                  <Table.Cell pr="5px">
                    {recipe.appliances.toLocaleLowerCase()}
                  </Table.Cell>
                </Table.Row>
              ))}
          </Table>
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};

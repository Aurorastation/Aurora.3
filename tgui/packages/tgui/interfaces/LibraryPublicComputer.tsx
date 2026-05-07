import { BooleanLike } from '../../common/react';
import { useBackend, useLocalState } from '../backend';
import {
  Box,
  Button,
  Icon,
  Input,
  LabeledList,
  NoticeBox,
  Section,
  Stack,
  Table,
} from '../components';
import { Dropdown } from '../components/Dropdown';
import { Window } from '../layouts';

export type LibraryPublicComputerData = {
  search_title: string;
  search_author: string;
  search_category: string;
  db_loading: BooleanLike;
  db_error: BooleanLike;
  search_results: SearchResult[];
};

type SearchResult = {
  author: string;
  title: string;
  category: string;
  id: number;
};

const CATEGORIES = ['Any', 'Fiction', 'Non-Fiction', 'Reference', 'Religion'];

export const LibraryPublicComputer = (props, context) => {
  const { act, data } = useBackend<LibraryPublicComputerData>(context);
  const [title, setTitle] = useLocalState(context, 'title', '');
  const [author, setAuthor] = useLocalState(context, 'author', '');
  const [category, setCategory] = useLocalState(
    context,
    'category',
    data.search_category,
  );
  const [hasSearched, setHasSearched] = useLocalState(
    context,
    'hasSearched',
    false,
  );

  return (
    <Window title="Public Library Terminal" width={650} height={500} resizable>
      <Window.Content scrollable>
        <Section title="Search the Archive">
          <LabeledList>
            <LabeledList.Item label="Title">
              <Input
                fluid
                value={title}
                placeholder="Leave blank for any"
                onInput={(e, val) => setTitle(val)}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Author">
              <Input
                fluid
                value={author}
                placeholder="Leave blank for any"
                onInput={(e, val) => setAuthor(val)}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Category">
              <Dropdown
                options={CATEGORIES}
                selected={category}
                onSelected={(val) => setCategory(val)}
              />
            </LabeledList.Item>
          </LabeledList>
          <Box mt={1}>
            <Button
              icon="search"
              content="Search"
              disabled={!!data.db_loading}
              onClick={() => {
                setHasSearched(true);
                act('search', { title, author, category });
              }}
            />
          </Box>
        </Section>
        {!!data.db_error && (
          <NoticeBox danger>
            Unable to contact External Archive. Please contact your system
            administrator.
          </NoticeBox>
        )}
        {!!data.db_loading && (
          <Section>
            <Stack align="center" justify="center" fill>
              <Stack.Item>
                <Icon color="blue" name="spinner" spin size={3} />
              </Stack.Item>
              <Stack.Item>Searching archive...</Stack.Item>
            </Stack>
          </Section>
        )}
        {!data.db_loading && data.search_results.length > 0 && (
          <Section title={`Results (${data.search_results.length})`}>
            <Table>
              <Table.Row header>
                <Table.Cell>Author</Table.Cell>
                <Table.Cell>Title</Table.Cell>
                <Table.Cell>Category</Table.Cell>
                <Table.Cell>SS13BN</Table.Cell>
              </Table.Row>
              {data.search_results.map((r) => (
                <Table.Row key={r.id}>
                  <Table.Cell>{r.author}</Table.Cell>
                  <Table.Cell>{r.title}</Table.Cell>
                  <Table.Cell>{r.category}</Table.Cell>
                  <Table.Cell>{r.id}</Table.Cell>
                </Table.Row>
              ))}
            </Table>
          </Section>
        )}
        {!data.db_loading &&
          !data.db_error &&
          hasSearched &&
          data.search_results.length === 0 && (
            <NoticeBox>No results found. Try a different search.</NoticeBox>
          )}
      </Window.Content>
    </Window>
  );
};

import { sortBy } from 'es-toolkit';
import {
  Box,
  Button,
  Collapsible,
  NoticeBox,
  Section,
  Stack,
} from 'tgui-core/components';
import { useBackend, useLocalState } from '../backend';
import { Window } from '../layouts';
import { SearchBar } from './common/SearchBar';

type LogViewerData = {
  round_id: number;
  logging_start_timestamp: string | number;
  tree: LogViewerCategoryTree;
  last_data_update: number;
  categories: Record<string, LogViewerCategoryData>;
};

type LogViewerCategoryTree = {
  enabled: string[];
  disabled: string[];
};

type LogViewerCategoryData = {
  entry_count: number;
  entries: LogEntryData[];
};

type LogEntryData = {
  id: number;
  message: string;
  timestamp: string;
  semver?: unknown;
  data?: unknown;
};

const CATEGORY_ALL = 'all';

const emptyViewerData: LogViewerCategoryData = {
  entry_count: 0,
  entries: [],
};

export const LogViewer = (props) => {
  const { act, data } = useBackend<LogViewerData>();
  const categories = data.categories || {};
  const tree = data.tree || { enabled: [], disabled: [] };
  const [activeCategory, setActiveCategory] = useLocalState<string>(
    'activeCategory',
    '',
  );

  const viewerData = buildViewerData(activeCategory, categories);

  return (
    <Window theme="admin" width={720} height={720}>
      <Window.Content scrollable>
        <Section
          title="Round Logs"
          buttons={
            <Stack align="center">
              <Stack.Item>
                <Box color="label">Round {data.round_id || 'unknown'}</Box>
              </Stack.Item>
              <Stack.Item>
                <Button
                  content="Refresh"
                  icon="sync"
                  onClick={() => act('refresh')}
                />
              </Stack.Item>
            </Stack>
          }
        >
          <CategoryBar
            categories={categories}
            disabled={tree.disabled || []}
            enabled={tree.enabled || []}
            active={activeCategory}
            setActive={setActiveCategory}
          />
        </Section>
        <CategoryViewer activeCategory={activeCategory} data={viewerData} />
      </Window.Content>
    </Window>
  );
};

function buildViewerData(
  activeCategory: string,
  categories: Record<string, LogViewerCategoryData>,
): LogViewerCategoryData {
  if (!activeCategory) {
    return emptyViewerData;
  }

  if (activeCategory !== CATEGORY_ALL) {
    return categories[activeCategory] || emptyViewerData;
  }

  const entries: LogEntryData[] = [];
  let entryCount = 0;
  for (const categoryName of Object.keys(categories)) {
    const category = categories[categoryName];
    entries.push(...(category.entries || []));
    entryCount += category.entry_count || 0;
  }

  return {
    entry_count: entryCount,
    entries: sortBy(entries, [(entry) => entry.id]),
  };
}

type CategoryBarProps = {
  categories: Record<string, LogViewerCategoryData>;
  disabled: string[];
  enabled: string[];
  active: string;
  setActive: (active: string) => void;
};

const CategoryBar = (props: CategoryBarProps) => {
  const [categorySearch, setCategorySearch] = useLocalState<string>(
    'categorySearch',
    '',
  );
  const search = categorySearch.toLowerCase();
  const disabledSet = new Set(props.disabled || []);
  const enabledCategories = [...(props.enabled || [])]
    .filter((category) => category.toLowerCase().includes(search))
    .sort();
  const disabledOnlyCategories = [...disabledSet]
    .filter((category) => !props.categories[category])
    .filter((category) => category.toLowerCase().includes(search))
    .sort();

  return (
    <Stack vertical>
      <Stack.Item>
        <SearchBar
          placeholder="Search categories"
          query={categorySearch}
          onSearch={(value) => setCategorySearch(value)}
        />
      </Stack.Item>
      <Stack.Item>
        <Stack wrap>
          <Stack.Item>
            <Button
              content="None"
              selected={props.active === ''}
              onClick={() => props.setActive('')}
            />
          </Stack.Item>
          <Stack.Item>
            <Button
              content="All"
              icon="list"
              selected={props.active === CATEGORY_ALL}
              tooltip="Show all cached entries. This may be slow later in the round."
              onClick={() => props.setActive(CATEGORY_ALL)}
            />
          </Stack.Item>
          {enabledCategories.map((category) => {
            const isDisabled = disabledSet.has(category);
            const entryCount = props.categories[category]?.entry_count || 0;
            return (
              <Stack.Item key={category}>
                <Button
                  color={isDisabled ? 'grey' : undefined}
                  content={`${category} (${entryCount})`}
                  selected={category === props.active}
                  tooltip={isDisabled ? 'Disabled by config' : undefined}
                  onClick={() => props.setActive(category)}
                />
              </Stack.Item>
            );
          })}
          {disabledOnlyCategories.map((category) => (
            <Stack.Item key={category}>
              <Button
                color="grey"
                content={`${category} (disabled)`}
                disabled
                tooltip="Disabled by config"
              />
            </Stack.Item>
          ))}
        </Stack>
      </Stack.Item>
    </Stack>
  );
};

type CategoryViewerProps = {
  activeCategory: string;
  data: LogViewerCategoryData;
};

const validateRegExp = (text: string) => {
  try {
    new RegExp(text);
    return true;
  } catch (error) {
    return error as SyntaxError;
  }
};

const CategoryViewer = (props: CategoryViewerProps) => {
  const [search, setSearch] = useLocalState<string>('entrySearch', '');
  const [searchRegex, setSearchRegex] = useLocalState<boolean>(
    'entrySearchRegex',
    false,
  );
  const [caseSensitive, setCaseSensitive] = useLocalState<boolean>(
    'entryCaseSensitive',
    false,
  );

  const regexValidation = searchRegex && search ? validateRegExp(search) : true;
  const entries =
    regexValidation === true
      ? props.data.entries.filter((entry) =>
          matchesEntry(entry, search, searchRegex, caseSensitive),
        )
      : [];

  return (
    <Section
      title={
        props.activeCategory
          ? `${props.activeCategory} (${props.data.entry_count})`
          : 'Select a category'
      }
      buttons={
        <Stack align="center">
          <Stack.Item>
            <SearchBar
              expensive
              placeholder="Search entries"
              query={search}
              onSearch={(value) => setSearch(value)}
              style={{ width: '18rem' }}
            />
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="code"
              selected={searchRegex}
              tooltip="Regex search"
              onClick={() => setSearchRegex(!searchRegex)}
            />
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="font"
              selected={caseSensitive}
              tooltip="Case sensitive"
              onClick={() => setCaseSensitive(!caseSensitive)}
            />
          </Stack.Item>
          <Stack.Item>
            <Button
              color="bad"
              icon="trash"
              tooltip="Clear search"
              onClick={() => {
                setSearch('');
                setSearchRegex(false);
              }}
            />
          </Stack.Item>
        </Stack>
      }
    >
      {regexValidation !== true && (
        <NoticeBox danger>
          Invalid regex: {(regexValidation as SyntaxError).message}
        </NoticeBox>
      )}
      {!props.activeCategory && <NoticeBox>Select a log category.</NoticeBox>}
      {!!props.activeCategory && !entries.length && regexValidation === true && (
        <NoticeBox>No cached entries found.</NoticeBox>
      )}
      <Stack vertical>
        {entries.map((entry) => (
          <Stack.Item key={entry.id}>
            <Collapsible title={`[${entry.id}] ${entry.message}`}>
              <Box
                mb={1}
                style={{
                  fontFamily: 'monospace',
                  overflowWrap: 'anywhere',
                  whiteSpace: 'pre-wrap',
                }}
              >
                [{entry.timestamp}] {entry.message}
              </Box>
              {entry.data !== undefined && entry.data !== null && (
                <JsonViewer data={entry.data} title="Data" />
              )}
              {entry.semver !== undefined && entry.semver !== null && (
                <JsonViewer data={entry.semver} title="Semver" />
              )}
            </Collapsible>
          </Stack.Item>
        ))}
      </Stack>
    </Section>
  );
};

function matchesEntry(
  entry: LogEntryData,
  search: string,
  searchRegex: boolean,
  caseSensitive: boolean,
) {
  if (!search) {
    return true;
  }

  const haystack = `${entry.message} ${JSON.stringify(entry.data || '')}`;
  if (searchRegex) {
    const regex = new RegExp(search, caseSensitive ? 'g' : 'gi');
    return regex.test(haystack);
  }

  if (caseSensitive) {
    return haystack.includes(search);
  }

  return haystack.toLowerCase().includes(search.toLowerCase());
}

const JsonViewer = (props: { data: unknown; title: string }) => (
  <Collapsible title={props.title}>
    <Box
      as="pre"
      style={{
        margin: 0,
        overflowX: 'auto',
        whiteSpace: 'pre-wrap',
      }}
    >
      {JSON.stringify(props.data, null, 2)}
    </Box>
  </Collapsible>
);

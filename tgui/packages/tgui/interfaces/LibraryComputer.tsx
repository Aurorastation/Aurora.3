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
  Tabs,
} from '../components';
import { Dropdown } from '../components/Dropdown';
import { Window } from '../layouts';

export type LibraryComputerData = {
  is_public: BooleanLike;
  is_emagged: BooleanLike;
  bible_on_cooldown: BooleanLike;
  checkout_period_minutes: number;
  archive_loading: BooleanLike;
  archive_error: BooleanLike;
  archive_results: ArchiveEntry[];
  archive_page: number;
  archive_total: number;
  archive_search: string;
  archive_sort_field: string;
  archive_sort_dir: string;
  archive_page_size: number;
  upload_category: string;
  buffer_book: string | null;
  last_uploaded_title: string | null;
  inventory: InventoryBook[];
  checkouts: CheckoutEntry[];
  scanner: ScannerState;
  crew_names: string[];
};

type InventoryBook = {
  ref: string;
  name: string;
};

type CheckoutEntry = {
  ref: string;
  book_name: string;
  mob_name: string;
  taken_minutes: number;
  due_minutes: number;
  overdue: BooleanLike;
};

type ArchiveEntry = {
  id: number;
  author: string;
  title: string;
  category: string;
};

type ScannerState = {
  found: BooleanLike;
  title: string | null;
  author: string | null;
};

const UPLOAD_CATEGORIES = ['Fiction', 'Non-Fiction', 'Reference', 'Religion'];

export const LibraryComputer = (props, context) => {
  const { act, data } = useBackend<LibraryComputerData>(context);
  const [tab, setTab] = useLocalState(context, 'tab', 'inventory');

  const handleTabChange = (newTab: string) => {
    setTab(newTab);
    if (
      newTab === 'archive' &&
      !data.archive_loading &&
      data.archive_results.length === 0
    ) {
      act('fetch_archive');
    }
  };

  return (
    <Window resizable width={750} height={600}>
      <Window.Content>
        <Tabs>
          <Tabs.Tab
            selected={tab === 'inventory'}
            onClick={() => handleTabChange('inventory')}
          >
            Inventory
          </Tabs.Tab>
          <Tabs.Tab
            selected={tab === 'checkouts'}
            onClick={() => handleTabChange('checkouts')}
          >
            Checked Out
          </Tabs.Tab>
          <Tabs.Tab
            selected={tab === 'checkout'}
            onClick={() => handleTabChange('checkout')}
          >
            Check Out
          </Tabs.Tab>
          <Tabs.Tab
            selected={tab === 'archive'}
            onClick={() => handleTabChange('archive')}
          >
            Order From Archive
          </Tabs.Tab>
          {!data.is_public && (
            <Tabs.Tab
              selected={tab === 'upload'}
              onClick={() => handleTabChange('upload')}
            >
              Upload Title
            </Tabs.Tab>
          )}
          <Tabs.Tab
            selected={tab === 'bible'}
            onClick={() => handleTabChange('bible')}
          >
            Bible Printer
          </Tabs.Tab>
          {!!data.is_emagged && (
            <Tabs.Tab
              selected={tab === 'vault'}
              onClick={() => handleTabChange('vault')}
            >
              Forbidden Lore
            </Tabs.Tab>
          )}
        </Tabs>
        <Box>
          {tab === 'inventory' && <InventoryTab />}
          {tab === 'checkouts' && <CheckoutsTab />}
          {tab === 'checkout' && <CheckOutTab />}
          {tab === 'archive' && <ArchiveTab />}
          {tab === 'upload' && !data.is_public && <UploadTab />}
          {tab === 'bible' && <BibleTab />}
          {tab === 'vault' && !!data.is_emagged && <VaultTab />}
        </Box>
      </Window.Content>
    </Window>
  );
};

const InventoryTab = (props, context) => {
  const { act, data } = useBackend<LibraryComputerData>(context);

  return (
    <Section
      title="Physical Inventory"
      buttons={
        data.inventory.length > 0 && (
          <Button
            icon="print"
            content="Print List"
            onClick={() => act('print_inventory')}
          />
        )
      }
    >
      {data.inventory.length === 0 ? (
        <NoticeBox>No books in inventory.</NoticeBox>
      ) : (
        <Table>
          <Table.Row header>
            <Table.Cell>Title</Table.Cell>
            <Table.Cell collapsing />
          </Table.Row>
          {data.inventory.map((b) => (
            <Table.Row key={b.ref}>
              <Table.Cell>{b.name}</Table.Cell>
              <Table.Cell collapsing>
                <Button
                  color="bad"
                  icon="trash"
                  content="Delete"
                  onClick={() => act('delete_inventory_book', { ref: b.ref })}
                />
              </Table.Cell>
            </Table.Row>
          ))}
        </Table>
      )}
    </Section>
  );
};

const CheckoutsTab = (props, context) => {
  const { act, data } = useBackend<LibraryComputerData>(context);

  return (
    <Section
      title="Active Checkouts"
      buttons={
        data.checkouts.length > 0 && (
          <Button
            icon="print"
            content="Print List"
            onClick={() => act('print_checkouts')}
          />
        )
      }
    >
      {data.checkouts.length === 0 ? (
        <NoticeBox>No books currently checked out.</NoticeBox>
      ) : (
        <Table>
          <Table.Row header>
            <Table.Cell>Book</Table.Cell>
            <Table.Cell>Recipient</Table.Cell>
            <Table.Cell>Taken</Table.Cell>
            <Table.Cell>Due</Table.Cell>
            <Table.Cell collapsing />
          </Table.Row>
          {data.checkouts.map((c) => (
            <Table.Row key={c.ref}>
              <Table.Cell>{c.book_name}</Table.Cell>
              <Table.Cell>{c.mob_name}</Table.Cell>
              <Table.Cell>{c.taken_minutes} min ago</Table.Cell>
              <Table.Cell color={c.overdue ? 'bad' : 'default'}>
                {c.overdue
                  ? `OVERDUE by ${c.due_minutes} min`
                  : `in ${c.due_minutes} min`}
              </Table.Cell>
              <Table.Cell collapsing>
                <Button
                  icon="clock"
                  tooltip={`Extend by ${data.checkout_period_minutes} min`}
                  onClick={() => act('extend_checkout', { ref: c.ref })}
                />
                <Button
                  content="Check In"
                  onClick={() => act('checkin_book', { ref: c.ref })}
                />
              </Table.Cell>
            </Table.Row>
          ))}
        </Table>
      )}
    </Section>
  );
};

const CheckOutTab = (props, context) => {
  const { act, data } = useBackend<LibraryComputerData>(context);
  const [bookTitle, setBookTitle] = useLocalState(context, 'co_book', '');
  const [recipient, setRecipient] = useLocalState(context, 'co_recip', '');
  const [showBookPicker, setShowBookPicker] = useLocalState(
    context,
    'co_book_picker',
    false,
  );
  const [showRecipientPicker, setShowRecipientPicker] = useLocalState(
    context,
    'co_recip_picker',
    false,
  );

  return (
    <Section title="Check Out a Book">
      {!!data.buffer_book && bookTitle !== data.buffer_book && (
        <Box mb={1}>
          <Button
            icon="barcode"
            content={`Use scanned book: "${data.buffer_book}"`}
            onClick={() => setBookTitle(data.buffer_book!)}
          />
        </Box>
      )}
      <LabeledList>
        <LabeledList.Item label="Book Title">
          <Stack>
            <Stack.Item grow>
              <Input
                fluid
                value={bookTitle}
                placeholder="Enter book title"
                onInput={(e, v) => setBookTitle(v)}
              />
            </Stack.Item>
            {data.inventory.length > 0 && (
              <Stack.Item>
                <Button
                  icon="list"
                  selected={showBookPicker}
                  tooltip="Pick from inventory"
                  onClick={() => {
                    setShowBookPicker(!showBookPicker);
                    setShowRecipientPicker(false);
                  }}
                />
              </Stack.Item>
            )}
          </Stack>
          {showBookPicker && (
            <Box
              mt={0.5}
              style={{
                maxHeight: '150px',
                overflowY: 'auto',
                border: '1px solid rgba(255,255,255,0.2)',
              }}
            >
              {data.inventory.map((b) => (
                <Button
                  key={b.ref}
                  fluid
                  content={b.name}
                  onClick={() => {
                    setBookTitle(b.name);
                    setShowBookPicker(false);
                  }}
                />
              ))}
            </Box>
          )}
        </LabeledList.Item>
        <LabeledList.Item label="Recipient">
          <Stack>
            <Stack.Item grow>
              <Input
                fluid
                value={recipient}
                placeholder="Enter recipient name"
                onInput={(e, v) => setRecipient(v)}
              />
            </Stack.Item>
            {data.crew_names.length > 0 && (
              <Stack.Item>
                <Button
                  icon="users"
                  selected={showRecipientPicker}
                  tooltip="Pick from crew manifest"
                  onClick={() => {
                    setShowRecipientPicker(!showRecipientPicker);
                    setShowBookPicker(false);
                  }}
                />
              </Stack.Item>
            )}
          </Stack>
          {showRecipientPicker && (
            <Box
              mt={0.5}
              style={{
                maxHeight: '150px',
                overflowY: 'auto',
                border: '1px solid rgba(255,255,255,0.2)',
              }}
            >
              {data.crew_names.map((name) => (
                <Button
                  key={name}
                  fluid
                  content={name}
                  onClick={() => {
                    setRecipient(name);
                    setShowRecipientPicker(false);
                  }}
                />
              ))}
            </Box>
          )}
        </LabeledList.Item>
        <LabeledList.Item label="Checkout Period">
          <Button
            icon="minus"
            onClick={() => act('decrease_checkout_period')}
          />
          <Box inline mx={1}>
            {data.checkout_period_minutes} minute
            {data.checkout_period_minutes !== 1 && 's'}
          </Box>
          <Button icon="plus" onClick={() => act('increase_checkout_period')} />
        </LabeledList.Item>
      </LabeledList>
      <Box mt={1}>
        <Button
          icon="check"
          content="Commit Checkout"
          color="good"
          disabled={!bookTitle || !recipient}
          onClick={() => {
            act('checkout_book', {
              book_title: bookTitle,
              recipient: recipient,
            });
            setBookTitle('');
            setRecipient('');
          }}
        />
      </Box>
    </Section>
  );
};

type SortField = 'author' | 'title' | 'category';

const ArchiveTab = (props, context) => {
  const { act, data } = useBackend<LibraryComputerData>(context);
  // Local state only for the search input — committed to server on Enter or button click
  const [searchInput, setSearchInput] = useLocalState(
    context,
    'archive_search_input',
    data.archive_search,
  );
  const [isbnInput, setIsbnInput] = useLocalState(context, 'isbn_input', '');

  const totalPages = Math.max(
    1,
    Math.ceil(data.archive_total / data.archive_page_size),
  );

  const commitSearch = (value: string) => {
    if (!data.archive_loading) {
      act('archive_set_search', { query: value });
    }
  };

  const handleSort = (field: SortField) => {
    const newDir =
      data.archive_sort_field === field && data.archive_sort_dir === 'asc'
        ? 'desc'
        : 'asc';
    act('archive_set_sort', { field, dir: newDir });
  };

  const SortHeader = ({
    field,
    label,
  }: {
    field: SortField;
    label: string;
  }) => (
    <Table.Cell
      style={{ cursor: 'pointer', userSelect: 'none' }}
      onClick={() => handleSort(field)}
    >
      {label}
      {data.archive_sort_field === field && (
        <Icon
          name={data.archive_sort_dir === 'asc' ? 'sort-up' : 'sort-down'}
          ml={0.5}
        />
      )}
    </Table.Cell>
  );

  return (
    <Section
      title="External Archive"
      buttons={
        <Button
          icon="refresh"
          content="Refresh"
          disabled={!!data.archive_loading}
          onClick={() => act('fetch_archive')}
        />
      }
    >
      <Stack mb={1}>
        <Stack.Item grow>
          <Input
            fluid
            value={searchInput}
            placeholder="Search by title, author, or category..."
            onInput={(e, v) => setSearchInput(v)}
            onEnter={(e, v) => commitSearch(v)}
          />
        </Stack.Item>
        <Stack.Item>
          <Button
            icon="search"
            content="Search"
            disabled={!!data.archive_loading}
            onClick={() => commitSearch(searchInput)}
          />
        </Stack.Item>
        {!!data.archive_search && (
          <Stack.Item>
            <Button
              icon="times"
              content="Clear"
              onClick={() => {
                setSearchInput('');
                act('archive_set_search', { query: '' });
              }}
            />
          </Stack.Item>
        )}
        <Stack.Item>
          <Input
            value={isbnInput}
            placeholder="ISBN"
            width={8}
            onInput={(e, v) => setIsbnInput(v)}
          />
        </Stack.Item>
        <Stack.Item>
          <Button
            icon="download"
            content="Order by ISBN"
            disabled={!!data.bible_on_cooldown || !isbnInput}
            onClick={() => {
              const id = parseInt(isbnInput, 10);
              if (id > 0) {
                act('order_book', { id });
                setIsbnInput('');
              }
            }}
          />
        </Stack.Item>
      </Stack>
      {!!data.archive_error && (
        <NoticeBox danger>Unable to contact External Archive.</NoticeBox>
      )}
      {!!data.archive_loading && (
        <Stack align="center" justify="center" mt={2} mb={2}>
          <Stack.Item>
            <Icon color="blue" name="spinner" spin size={3} />
          </Stack.Item>
          <Stack.Item>Loading archive...</Stack.Item>
        </Stack>
      )}
      {!data.archive_loading &&
        !data.archive_error &&
        data.archive_total > 0 && (
          <>
            <Box
              style={{
                overflowY: 'auto',
                maxHeight: '460px',
                borderBottom: '1px solid rgba(255,255,255,0.1)',
              }}
            >
              <Table>
                <Table.Row header>
                  <SortHeader field="author" label="Author" />
                  <SortHeader field="title" label="Title" />
                  <SortHeader field="category" label="Category" />
                  <Table.Cell collapsing />
                </Table.Row>
                {data.archive_results.map((entry) => (
                  <Table.Row key={entry.id}>
                    <Table.Cell
                      style={{
                        maxWidth: '160px',
                        overflow: 'hidden',
                        textOverflow: 'ellipsis',
                        whiteSpace: 'nowrap',
                      }}
                      title={entry.author}
                    >
                      {entry.author}
                    </Table.Cell>
                    <Table.Cell
                      style={{
                        maxWidth: '220px',
                        overflow: 'hidden',
                        textOverflow: 'ellipsis',
                        whiteSpace: 'nowrap',
                      }}
                      title={entry.title}
                    >
                      {entry.title}
                    </Table.Cell>
                    <Table.Cell>{entry.category}</Table.Cell>
                    <Table.Cell collapsing>
                      <Button
                        content="Order"
                        disabled={!!data.bible_on_cooldown}
                        onClick={() => act('order_book', { id: entry.id })}
                      />
                    </Table.Cell>
                  </Table.Row>
                ))}
              </Table>
            </Box>
            <Stack mt={1} align="center">
              <Stack.Item>
                <Button
                  icon="chevron-left"
                  disabled={!!data.archive_loading || data.archive_page <= 1}
                  onClick={() =>
                    act('archive_go_to_page', { page: data.archive_page - 1 })
                  }
                />
              </Stack.Item>
              <Stack.Item grow textAlign="center">
                Page {data.archive_page} of {totalPages}
                {' — '}
                {data.archive_total} result{data.archive_total !== 1 && 's'}
                {!!data.archive_search && ` for "${data.archive_search}"`}
              </Stack.Item>
              <Stack.Item>
                <Button
                  icon="chevron-right"
                  disabled={
                    !!data.archive_loading || data.archive_page >= totalPages
                  }
                  onClick={() =>
                    act('archive_go_to_page', { page: data.archive_page + 1 })
                  }
                />
              </Stack.Item>
            </Stack>
          </>
        )}
      {!data.archive_loading &&
        !data.archive_error &&
        data.archive_total === 0 && (
          <NoticeBox mt={1}>
            {data.archive_search
              ? `No books match "${data.archive_search}".`
              : 'No archive data loaded. Click Refresh to load books.'}
          </NoticeBox>
        )}
    </Section>
  );
};

const UploadTab = (props, context) => {
  const { act, data } = useBackend<LibraryComputerData>(context);
  const { scanner } = data;

  return (
    <Section title="Upload New Title">
      {!!data.last_uploaded_title && (
        <NoticeBox>
          <Stack align="center">
            <Stack.Item grow>
              <Icon name="check-circle" mr={1} />
              Uploaded:{' '}
              <Box inline bold>
                {data.last_uploaded_title}
              </Box>
            </Stack.Item>
            <Stack.Item>
              <Button
                icon="times"
                content="Clear Scanner"
                onClick={() => act('clear_scanner_cache')}
              />
            </Stack.Item>
          </Stack>
        </NoticeBox>
      )}
      {!scanner.found ? (
        <NoticeBox danger>
          No scanner found within wireless network range.
        </NoticeBox>
      ) : !scanner.title ? (
        <NoticeBox>
          <Stack align="center">
            <Stack.Item grow>No data found in scanner memory.</Stack.Item>
            {!!data.last_uploaded_title && (
              <Stack.Item>
                <Button
                  icon="times"
                  content="Clear Scanner"
                  onClick={() => act('clear_scanner_cache')}
                />
              </Stack.Item>
            )}
          </Stack>
        </NoticeBox>
      ) : (
        <>
          <LabeledList>
            <LabeledList.Item label="Title">{scanner.title}</LabeledList.Item>
            <LabeledList.Item label="Author">
              <Input
                value={scanner.author || ''}
                onInput={(e, val) => act('set_upload_author', { value: val })}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Category">
              <Dropdown
                options={UPLOAD_CATEGORIES}
                selected={data.upload_category}
                onSelected={(val) => act('set_upload_category', { value: val })}
              />
            </LabeledList.Item>
          </LabeledList>
          <Box mt={1}>
            <Button
              icon="upload"
              content="Upload to Archive"
              color="good"
              onClick={() => act('upload_book')}
            />
            <Button
              icon="times"
              content="Clear Scanner"
              ml={1}
              onClick={() => act('clear_scanner_cache')}
            />
          </Box>
        </>
      )}
    </Section>
  );
};

const BibleTab = (props, context) => {
  const { act, data } = useBackend<LibraryComputerData>(context);

  return (
    <Section title="Bible Printer">
      <Button
        icon="bible"
        content="Print a Bible"
        disabled={!!data.bible_on_cooldown}
        onClick={() => act('print_bible')}
      />
      {!!data.bible_on_cooldown && (
        <Box mt={1} color="average">
          Printer cooling down. Please wait a moment.
        </Box>
      )}
    </Section>
  );
};

const VaultTab = (props, context) => {
  const { act, data } = useBackend<LibraryComputerData>(context);

  return (
    <Section title="Forbidden Lore Vault v1.3">
      <Box>
        Are you absolutely sure you want to proceed? EldritchTomes Inc. takes no
        responsibility for loss of sanity resulting from this action.
      </Box>
      <Box mt={1}>
        <Button
          color="bad"
          icon="skull"
          content="Yes."
          disabled={!!data.bible_on_cooldown}
          onClick={() => act('arcane_confirm')}
        />
      </Box>
      {!!data.bible_on_cooldown && (
        <Box mt={1} color="average">
          Printer cooling down. Please wait a moment.
        </Box>
      )}
    </Section>
  );
};

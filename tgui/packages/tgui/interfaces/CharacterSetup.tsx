import { Box, Button, Icon, Section, Stack, Tabs } from 'tgui-core/components';
import { useBackend } from '../backend';
import { Window } from '../layouts';
import { sanitizeText } from '../sanitize';
import { CharacterPreview } from './common/CharacterPreview';

type Category = {
  name: string;
  ref: string;
  selected: boolean;
};

type CharacterSetupData = {
  can_save: boolean;
  character_name: string;
  content: string;
  faction_name: string;
  faction_suffix: string;
  sql_saves: boolean;
  categories: Category[];
};

const allowedTags = [
  'a',
  'b',
  'body',
  'br',
  'center',
  'del',
  'div',
  'font',
  'h2',
  'hr',
  'i',
  'img',
  'input',
  'large',
  'li',
  'small',
  'span',
  'table',
  'tbody',
  'td',
  'th',
  'thead',
  'tr',
  'tt',
  'u',
  'ul',
];

const categoryIcons: Record<string, string> = {
  General: 'user',
  Origin: 'globe',
  Skills: 'brain',
  Occupation: 'briefcase',
  Roles: 'masks-theater',
  Loadout: 'shirt',
  Global: 'gear',
  Other: 'ellipsis',
};

export const CharacterSetup = () => {
  const { act, data } = useBackend<CharacterSetupData>();
  const selectedCategory = data.categories.find(
    (category) => category.selected,
  );
  const legacyContent = (data.content ?? '').replace(/byond:\/\/\?/gi, '?');
  const contentHtml = {
    __html: sanitizeText(legacyContent, false, allowedTags, []),
  };

  const runLoadoutSearch = (container: HTMLElement) => {
    const input = container.querySelector<HTMLInputElement>('#search_input');
    const refreshLink = container.querySelector<HTMLAnchorElement>(
      '#search_refresh_link',
    );
    const refreshHref = refreshLink?.getAttribute('href');
    if (!input || !refreshHref) {
      return;
    }
    window.location.href = `byond://${refreshHref}${encodeURIComponent(input.value)}`;
  };

  const handleContentClick = (event: React.MouseEvent<HTMLDivElement>) => {
    const link = (event.target as HTMLElement).closest('a');
    if (!link) {
      return;
    }

    const href = link.getAttribute('href');
    if (href === '#') {
      event.preventDefault();
      runLoadoutSearch(event.currentTarget);
    } else if (href?.startsWith('?')) {
      event.preventDefault();
      window.location.href = `byond://${href}`;
    }
  };

  const handleContentKeyDown = (event: React.KeyboardEvent<HTMLDivElement>) => {
    if (
      event.key === 'Enter' &&
      (event.target as HTMLElement).id === 'search_input'
    ) {
      event.preventDefault();
      runLoadoutSearch(event.currentTarget);
    }
  };

  return (
    <Window theme="character-setup" width={1280} height={900}>
      <Window.Content
        className={`CharacterSetup CharacterSetup--${data.faction_suffix}`}
        fitted
      >
        <Stack fill vertical>
          <Stack.Item>
            <Section className="CharacterSetup__toolbar">
              <Stack align="center">
                <Stack.Item>
                  <Box className="CharacterSetup__identityIcon">
                    <Icon name="user-astronaut" size={1.5} />
                  </Box>
                </Stack.Item>
                <Stack.Item grow>
                  <Box bold fontSize={1.3}>
                    {data.character_name || 'Unsaved Character'}
                  </Box>
                  <Box color="label">
                    Active character setup &middot; {data.faction_name}
                  </Box>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    className="CharacterSetup__action"
                    icon="folder-open"
                    disabled={!data.can_save}
                    onClick={() => act('load')}
                    verticalAlignContent="middle"
                  >
                    Load Slot
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    className="CharacterSetup__action"
                    icon="floppy-disk"
                    disabled={!data.can_save}
                    onClick={() => act('save')}
                    verticalAlignContent="middle"
                  >
                    Save Slot
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    className="CharacterSetup__action"
                    icon="rotate"
                    disabled={!data.can_save}
                    onClick={() => act('reload')}
                    verticalAlignContent="middle"
                  >
                    Reload Slot
                  </Button>
                </Stack.Item>
                {!!data.sql_saves && (
                  <Stack.Item>
                    <Button
                      className="CharacterSetup__action"
                      color="bad"
                      icon="trash"
                      disabled={!data.can_save}
                      onClick={() => act('delete')}
                      verticalAlignContent="middle"
                    >
                      Permanently Delete Slot
                    </Button>
                  </Stack.Item>
                )}
                {!data.can_save && (
                  <Stack.Item grow>
                    <Box color="label" textAlign="right">
                      Please create an account to save your preferences.
                    </Box>
                  </Stack.Item>
                )}
              </Stack>
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Box className="CharacterSetup__tabs">
              <Tabs fluid>
                {data.categories.map((category) => (
                  <Tabs.Tab
                    icon={categoryIcons[category.name]}
                    key={category.ref}
                    selected={category.selected}
                    onClick={() =>
                      act('select_category', { category: category.ref })
                    }
                  >
                    {category.name}
                  </Tabs.Tab>
                ))}
              </Tabs>
            </Box>
          </Stack.Item>
          <Stack.Item grow>
            <Stack className="CharacterSetup__workspace" fill>
              <Stack.Item grow>
                <Section
                  className="CharacterSetup__main"
                  fill
                  scrollable
                  title={`${selectedCategory?.name ?? 'Character'} Preferences`}
                >
                  <Box
                    className="CharacterSetup__content"
                    onClick={handleContentClick}
                    onKeyDown={handleContentKeyDown}
                    dangerouslySetInnerHTML={contentHtml}
                  />
                </Section>
              </Stack.Item>
              <Stack.Item>
                <Section
                  className="CharacterSetup__preview"
                  fill
                  title="Character Preview"
                >
                  <CharacterPreview
                    id="character_setup_preview"
                    height="100%"
                    width="300px"
                  />
                </Section>
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

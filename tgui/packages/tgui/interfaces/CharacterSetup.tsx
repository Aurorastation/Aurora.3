import { type ReactNode, useEffect } from 'react';
import {
  Box,
  Button,
  Icon,
  Input,
  Section,
  Stack,
  Tabs,
} from 'tgui-core/components';
import { useBackend } from '../backend';
import { Window } from '../layouts';
import { CharacterPreview } from './common/CharacterPreview';
import { LoadingScreen } from './common/LoadingScreen';

type Category = {
  name: string;
  ref: string;
  selected: boolean;
};

type BasePreferenceItem = {
  kind: string;
  name: string;
  ref: string;
};

type NoticePreferenceItem = BasePreferenceItem & {
  kind: 'notice';
  message: string;
};

type PreferenceAction = {
  action?: string;
  color?: string;
  icon?: string;
  label: string;
  preview_color?: string;
  topic?: Record<string, string | number>;
  value?: string | number;
};

type FormField = {
  action?: string;
  action_value?: string | number;
  actions?: PreferenceAction[];
  color?: string;
  font?: string;
  href?: string;
  inline_actions?: boolean;
  label: string;
  note?: string;
  pencode?: boolean;
  actions_below?: boolean;
  topic?: Record<string, string | number>;
  value?: string | number;
};

type FormSection = {
  description?: string;
  description_html?: boolean;
  fields: FormField[];
  title?: string;
  warning?: string;
  warning_html?: boolean;
};

type FormPreferenceItem = BasePreferenceItem & {
  kind: 'form';
  sections: FormSection[];
};

type BodyField = {
  action: string;
  label: string;
  value: string;
};

type BodyAppearance = {
  color?: string;
  color_action?: string;
  name: string;
  next_action?: string;
  previous_action?: string;
  style?: string;
  style_action?: string;
};

type BodyMarking = {
  can_reorder: boolean;
  color: string;
  has_preset: boolean;
  name: string;
};

type SpeciesOption = {
  available: boolean;
  current: boolean;
  description: string;
  language: string;
  name: string;
  selected: boolean;
  traits: string[];
};

type BodyPreferenceItem = BasePreferenceItem & {
  kind: 'body';
  appearance: BodyAppearance[];
  disabilities: string[];
  fields: BodyField[];
  has_internal_organs: boolean;
  has_skin_preset: boolean;
  internal_organs: { name: string; status: string }[];
  markings: BodyMarking[];
  preview_actions: PreferenceAction[];
  prostheses: string[];
  species_categories: {
    name: string;
    species: SpeciesOption[];
  }[];
  species_menu_open: boolean;
};

type BackgroundPreferenceItem = BasePreferenceItem & {
  kind: 'background';
  banned: boolean;
  records: {
    clear_value: string;
    edit_action: string;
    name: string;
    preview: string;
  }[];
};

type SkillLevel = {
  cost: number;
  label: string;
  selectable: boolean;
  state: 'current' | 'forced' | 'selectable' | 'unavailable';
  value: number;
};

type SkillEntry = {
  current_description?: string;
  description: string;
  levels: SkillLevel[];
  name: string;
  type: string;
  uneducated_cap?: string;
};

type SkillSubcategory = {
  name: string;
  skills: SkillEntry[];
};

type SkillCategory = {
  name: string;
  remaining: number;
  subcategories: SkillSubcategory[];
};

type SkillsPreferenceItem = BasePreferenceItem & {
  kind: 'skills';
  categories: SkillCategory[];
  education: string;
  education_description: string;
};

type LoadoutItem = {
  available: boolean;
  cost: number;
  description: string;
  name: string;
  restrictions: string[];
  selected: boolean;
  tweaks: PreferenceAction[];
};

type LoadoutPreferenceItem = BasePreferenceItem & {
  kind: 'loadout';
  categories: { has_selected: boolean; name: string; selected: boolean }[];
  cost: number;
  cost_limit: number;
  gear_reset: boolean | number;
  items: LoadoutItem[];
  search: string;
  slot: number;
};

type OccupationJob = {
  alt_title_ref?: string;
  bold: boolean;
  color: string;
  rank: string;
  selectable: boolean;
  status?: string;
  status_href?: string;
  status_tone: 'high' | 'medium' | 'low' | 'never' | 'unavailable';
  title: string;
  unavailable: boolean;
};

type OccupationDepartment = {
  name: string;
  jobs: OccupationJob[];
};

type OccupationPreferenceItem = BasePreferenceItem & {
  kind: 'occupation';
  alternative: string;
  departments: OccupationDepartment[];
  faction: string;
};

type PreferenceItem =
  | NoticePreferenceItem
  | FormPreferenceItem
  | BodyPreferenceItem
  | BackgroundPreferenceItem
  | SkillsPreferenceItem
  | LoadoutPreferenceItem
  | OccupationPreferenceItem;

type CharacterSetupData = {
  can_save: boolean;
  character_name: string;
  faction_name: string;
  faction_suffix: string;
  loading: boolean;
  sql_saves: boolean;
  slot_dialog?: {
    can_create: boolean;
    limit: number;
    slots: {
      id: number;
      name: string;
      selected: boolean;
    }[];
    used: number;
  };
  categories: Category[];
  items: PreferenceItem[];
};

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

const normalizedHeading = (heading: string) =>
  heading.toLowerCase().replace(/s$/, '');

const renderPencode = (text: string) => {
  type Frame = {
    children: ReactNode[];
    tag?: string;
  };

  let key = 0;
  const root: Frame = { children: [] };
  const stack: Frame[] = [root];
  const tokens = text.split(/(\[\/?(?:b|i|u|large|small)\])/gi);
  const wrap = (tag: string, children: ReactNode[]) => {
    const elementKey = key++;
    switch (tag) {
      case 'b':
        return <b key={elementKey}>{children}</b>;
      case 'i':
        return <i key={elementKey}>{children}</i>;
      case 'u':
        return <u key={elementKey}>{children}</u>;
      case 'large':
        return (
          <span key={elementKey} style={{ fontSize: '1.25em' }}>
            {children}
          </span>
        );
      case 'small':
        return (
          <span key={elementKey} style={{ fontSize: '0.8em' }}>
            {children}
          </span>
        );
    }
  };

  for (const token of tokens) {
    if (!token) {
      continue;
    }
    const tagMatch = token.match(/^\[(\/?)(b|i|u|large|small)\]$/i);
    if (!tagMatch) {
      stack[stack.length - 1].children.push(token);
      continue;
    }
    const [, closing, rawTag] = tagMatch;
    const tag = rawTag.toLowerCase();
    if (!closing) {
      stack.push({ children: [], tag });
      continue;
    }
    const frame = stack[stack.length - 1];
    if (stack.length === 1 || frame.tag !== tag) {
      frame.children.push(token);
      continue;
    }
    stack.pop();
    stack[stack.length - 1].children.push(wrap(tag, frame.children));
  }

  while (stack.length > 1) {
    const frame = stack.pop()!;
    stack[stack.length - 1].children.push(`[${frame.tag}]`, ...frame.children);
  }
  return root.children;
};

export const CharacterSetup = () => {
  const { act, data } = useBackend<CharacterSetupData>();

  useEffect(() => {
    if (!data.loading) {
      return;
    }
    // The server deliberately withholds the expensive preference payload until
    // React has mounted. Retrying makes recovery automatic if BYOND drops the
    // first message while its embedded browser is finishing initialization.
    act('character_setup_ready');
    const timer = setInterval(() => act('character_setup_ready'), 2000);
    return () => clearInterval(timer);
  }, [act, data.loading]);

  useEffect(() => {
    if (data.loading) {
      return;
    }
    const loader = document.getElementById('tgui-bootstrap-loader');
    let removalFrame: number | undefined;
    const waitForStyles = () => {
      const layout = document.querySelector('.Layout');
      const stylesReady =
        layout &&
        getComputedStyle(layout).getPropertyValue('--color-base').trim();
      if (!stylesReady) {
        removalFrame = requestAnimationFrame(waitForStyles);
        return;
      }
      removalFrame = requestAnimationFrame(() => loader?.remove());
    };
    removalFrame = requestAnimationFrame(waitForStyles);
    return () => {
      if (removalFrame !== undefined) {
        cancelAnimationFrame(removalFrame);
      }
    };
  }, [data.loading]);

  useEffect(() => {
    if (data.loading) {
      return;
    }
    // Native map controls mount after the TGUI window becomes visible. Wait for
    // the full React tree before asking BYOND to attach the preview objects.
    const timer = setTimeout(() => act('preview_ready'), 0);
    return () => clearTimeout(timer);
  }, [act, data.loading]);

  const selectedCategory = data.categories.find(
    (category) => category.selected,
  );
  const speciesDialogOpen = data.items.some(
    (item) => item.kind === 'body' && item.species_menu_open,
  );
  const modalOpen = !!data.slot_dialog || speciesDialogOpen;
  const sendPreferenceTopic = (
    item: BasePreferenceItem,
    topic: Record<string, string | number>,
  ) => act('preference_topic', { item: item.ref, topic });

  const sendPreferenceAction = (
    item: BasePreferenceItem,
    action: string,
    value: string | number = 1,
  ) => sendPreferenceTopic(item, { [action]: value });

  const renderSlotDialog = () => {
    const dialog = data.slot_dialog;
    if (!dialog) {
      return null;
    }

    return (
      <Box className="CharacterSetup__slotOverlay">
        <Section
          className="CharacterSetup__slotDialog"
          fill
          scrollable
          title="Character Slots"
          buttons={
            <Button
              color="transparent"
              icon="xmark"
              onClick={() => act('close_slots')}
            />
          }
        >
          <Box color="label" mb={1}>
            Select a character to load.
          </Box>
          <Stack vertical>
            {dialog.slots.map((slot) => (
              <Stack.Item key={slot.id}>
                <Button
                  fluid
                  icon={slot.selected ? 'user-check' : 'user'}
                  onClick={() => act('select_slot', { slot: slot.id })}
                  selected={slot.selected}
                >
                  {slot.name}
                </Button>
              </Stack.Item>
            ))}
          </Stack>
          <Stack align="center" mt={1}>
            <Stack.Item grow>
              <Box bold>
                {dialog.used}/{dialog.limit} slots used
              </Box>
            </Stack.Item>
            {!!data.sql_saves && (
              <Stack.Item>
                <Button
                  disabled={!dialog.can_create}
                  icon="plus"
                  onClick={() => act('new_character')}
                >
                  New Character
                </Button>
              </Stack.Item>
            )}
          </Stack>
        </Section>
      </Box>
    );
  };

  const renderSpeciesDialog = () => {
    const bodyItem = data.items.find(
      (item): item is BodyPreferenceItem => item.kind === 'body',
    );
    if (!bodyItem?.species_menu_open) {
      return null;
    }

    const speciesOptions = bodyItem.species_categories.reduce<SpeciesOption[]>(
      (options, category) => options.concat(category.species),
      [],
    );
    const selectedSpecies = speciesOptions.find((species) => species.selected);

    return (
      <Box className="CharacterSetup__slotOverlay">
        <Section
          className="CharacterSetup__speciesDialog"
          fill
          title="Species Selection"
          buttons={
            <Button
              color="transparent"
              icon="xmark"
              onClick={() => sendPreferenceAction(bodyItem, 'close_species')}
            />
          }
        >
          <Box className="species-dialog__layout">
            <Box className="species-dialog__list">
              {bodyItem.species_categories.map((category) => (
                <Box key={category.name} mb={1}>
                  <Box className="species-dialog__category">
                    {category.name}
                  </Box>
                  {category.species.map((species) => (
                    <Button
                      className="species-dialog__option"
                      color={species.available ? undefined : 'transparent'}
                      fluid
                      icon={species.available ? 'dna' : 'lock'}
                      key={species.name}
                      onClick={() =>
                        sendPreferenceAction(
                          bodyItem,
                          'preview_species',
                          species.name,
                        )
                      }
                      selected={species.selected}
                    >
                      {species.name}
                      {species.current ? ' (Current)' : ''}
                    </Button>
                  ))}
                </Box>
              ))}
            </Box>
            <Box className="species-dialog__details">
              {selectedSpecies ? (
                <>
                  <Box className="species-dialog__title">
                    {selectedSpecies.name}
                  </Box>
                  <Box color="label" className="species-dialog__description">
                    {selectedSpecies.description}
                  </Box>
                  <Box className="species-dialog__language">
                    <b>Language:</b> {selectedSpecies.language}
                  </Box>
                  {!!selectedSpecies.traits.length && (
                    <Box className="species-dialog__traits">
                      <Box bold mb={0.5}>
                        Traits
                      </Box>
                      {selectedSpecies.traits.map((trait) => (
                        <Box key={trait}>
                          <Icon name="check" mr={0.5} />
                          {trait}
                        </Box>
                      ))}
                    </Box>
                  )}
                  {!selectedSpecies.available && (
                    <Box color="bad" mt={1}>
                      This species is unavailable or requires a whitelist.
                    </Box>
                  )}
                  <Stack justify="flex-end" mt={2}>
                    <Stack.Item>
                      <Button
                        onClick={() =>
                          sendPreferenceAction(bodyItem, 'close_species')
                        }
                      >
                        Cancel
                      </Button>
                    </Stack.Item>
                    <Stack.Item>
                      <Button
                        color="good"
                        disabled={!selectedSpecies.available}
                        icon="check"
                        onClick={() =>
                          sendPreferenceAction(bodyItem, 'confirm_species')
                        }
                      >
                        Select Species
                      </Button>
                    </Stack.Item>
                  </Stack>
                </>
              ) : (
                <Box color="label">Select a species to see its details.</Box>
              )}
            </Box>
          </Box>
        </Section>
      </Box>
    );
  };

  const renderOccupation = (item: OccupationPreferenceItem) => (
    <Box className="occupation-layout">
      <Box className="occupation-faction" textAlign="center">
        <Box bold>Character Faction</Box>
        <Box color="label" fontSize={0.9}>
          This influences the jobs you can select and your starting equipment.
        </Box>
        <a
          onClick={() => sendPreferenceTopic(item, { faction_select: 1 })}
          role="button"
          tabIndex={0}
        >
          {item.faction}
        </a>
      </Box>
      <Box className="occupation-heading" textAlign="center">
        <Box bold>Choose occupation chances</Box>
        <Box color="label" fontSize={0.9}>
          Unavailable occupations are crossed out.
        </Box>
      </Box>
      <Box className="occupation-departments">
        {item.departments.map((department) => (
          <Box className="occupation-department" key={department.name}>
            <Box className="occupation-department__title">
              {department.name}
            </Box>
            <Box className="occupation-column">
              {department.jobs.map((job) => {
                const title = job.unavailable ? (
                  <del>{job.title}</del>
                ) : (
                  job.title
                );
                return (
                  <Box
                    className="occupation-job"
                    key={job.rank}
                    style={{ backgroundColor: job.color }}
                  >
                    <Box
                      className={`occupation-job__title${job.bold ? ' occupation-job__title--bold' : ''}`}
                    >
                      {job.alt_title_ref ? (
                        <a
                          onClick={() =>
                            sendPreferenceTopic(item, {
                              select_alt_title: job.alt_title_ref!,
                            })
                          }
                          role="button"
                          tabIndex={0}
                        >
                          {title}
                        </a>
                      ) : (
                        title
                      )}
                    </Box>
                    <Box
                      className={`occupation-job__status occupation-job__status--${job.status_tone}`}
                    >
                      {job.status &&
                        (job.status_href ? (
                          <a href={job.status_href}>[{job.status}]</a>
                        ) : job.selectable ? (
                          <a
                            onClick={() =>
                              sendPreferenceTopic(item, { set_job: job.rank })
                            }
                            role="button"
                            tabIndex={0}
                          >
                            [{job.status}]
                          </a>
                        ) : (
                          <>[{job.status}]</>
                        ))}
                    </Box>
                  </Box>
                );
              })}
            </Box>
          </Box>
        ))}
      </Box>
      <Stack className="occupation-footer" justify="center">
        <Stack.Item>
          <Button
            color="transparent"
            onClick={() => sendPreferenceTopic(item, { job_alternative: 1 })}
          >
            {item.alternative}
          </Button>
        </Stack.Item>
        <Stack.Item>
          <Button
            color="transparent"
            icon="rotate-left"
            onClick={() => sendPreferenceTopic(item, { reset_jobs: 1 })}
          >
            Reset
          </Button>
        </Stack.Item>
      </Stack>
    </Box>
  );

  const renderBody = (item: BodyPreferenceItem) => (
    <Box className="body-preferences">
      <Box className="body-preferences__summary">
        <Box>
          <Stack align="center">
            <Stack.Item grow>
              <Box bold>Body</Box>
            </Stack.Item>
            <Stack.Item>
              <Button
                compact
                icon="dice"
                tooltip="Randomize appearance"
                onClick={() => sendPreferenceAction(item, 'random')}
              />
            </Stack.Item>
          </Stack>
          {item.fields.map((field) => (
            <Box key={field.label}>
              <b>{field.label}:</b>{' '}
              <a
                onClick={() => sendPreferenceAction(item, field.action)}
                role="button"
                tabIndex={0}
              >
                {field.value}
              </a>
            </Box>
          ))}
          <Box>
            <b>Disabilities:</b>{' '}
            <a
              onClick={() => sendPreferenceAction(item, 'trait_add')}
              role="button"
              tabIndex={0}
            >
              Adjust
            </a>
          </Box>
          {!!item.disabilities.length && (
            <Box className="preference-detail-list">
              {item.disabilities.map((disability) => (
                <Box key={disability}>
                  {disability}{' '}
                  <Button
                    compact
                    color="transparent"
                    icon="minus"
                    onClick={() =>
                      sendPreferenceAction(item, 'trait_remove', disability)
                    }
                  />
                </Box>
              ))}
            </Box>
          )}
          <Box>
            <b>Limbs:</b>{' '}
            <a
              onClick={() => sendPreferenceAction(item, 'limbs')}
              role="button"
              tabIndex={0}
            >
              Adjust
            </a>
          </Box>
          {!!item.has_internal_organs && (
            <>
              <Box>
                <b>Internal Organs:</b>{' '}
                <a
                  onClick={() => sendPreferenceAction(item, 'organs')}
                  role="button"
                  tabIndex={0}
                >
                  Adjust
                </a>
              </Box>
              <Box className="preference-detail-list">
                {item.internal_organs.map((organ) => (
                  <Box key={organ.name}>
                    <b>{organ.name}</b>: {organ.status}
                  </Box>
                ))}
              </Box>
            </>
          )}
          <Box>
            <b>Prostheses/Amputations:</b>{' '}
            <a
              onClick={() => sendPreferenceAction(item, 'reset_organs')}
              role="button"
              tabIndex={0}
            >
              Reset
            </a>
          </Box>
          {!!item.prostheses.length && (
            <Box className="preference-detail-list">
              {item.prostheses.map((prosthesis) => (
                <Box key={prosthesis}>{prosthesis}</Box>
              ))}
            </Box>
          )}
        </Box>
        <Box>
          <Box bold mb={0.5}>
            Preview
          </Box>
          {item.preview_actions.map((action) => (
            <Box key={`${action.action}-${action.value}`}>
              <a
                onClick={() =>
                  sendPreferenceAction(item, action.action!, action.value)
                }
                role="button"
                tabIndex={0}
              >
                {action.label}
              </a>
            </Box>
          ))}
        </Box>
      </Box>
      <Box className="body-preferences__appearance">
        {item.appearance.map((appearance) => (
          <Box className="body-appearance" key={appearance.name}>
            <Box className="body-appearance__title">{appearance.name}</Box>
            <Stack align="center" wrap>
              {appearance.color_action && (
                <>
                  <Stack.Item>
                    <a
                      onClick={() =>
                        sendPreferenceAction(item, appearance.color_action!)
                      }
                      role="button"
                      tabIndex={0}
                    >
                      Change Color
                    </a>
                  </Stack.Item>
                  <Stack.Item>
                    <Box
                      className="body-appearance__color"
                      style={{ backgroundColor: appearance.color }}
                    />
                  </Stack.Item>
                </>
              )}
              {appearance.style && (
                <>
                  <Stack.Item>Style:</Stack.Item>
                  {appearance.previous_action && (
                    <Stack.Item>
                      <a
                        onClick={() =>
                          sendPreferenceAction(
                            item,
                            appearance.previous_action!,
                          )
                        }
                        role="button"
                        tabIndex={0}
                      >
                        &lt;
                      </a>
                    </Stack.Item>
                  )}
                  <Stack.Item>
                    <a
                      onClick={() =>
                        sendPreferenceAction(item, appearance.style_action!)
                      }
                      role="button"
                      tabIndex={0}
                    >
                      {appearance.style}
                    </a>
                  </Stack.Item>
                  {appearance.next_action && (
                    <Stack.Item>
                      <a
                        onClick={() =>
                          sendPreferenceAction(item, appearance.next_action!)
                        }
                        role="button"
                        tabIndex={0}
                      >
                        &gt;
                      </a>
                    </Stack.Item>
                  )}
                </>
              )}
            </Stack>
          </Box>
        ))}
        {!!item.has_skin_preset && (
          <Box className="body-appearance">
            <Box className="body-appearance__title">Body Color Presets</Box>
            <Button
              compact
              icon="palette"
              onClick={() => sendPreferenceAction(item, 'skin_preset')}
            >
              Choose Preset
            </Button>
          </Box>
        )}
      </Box>
      <Box className="body-markings">
        <Stack align="center">
          <Stack.Item grow>
            <Box bold>Body Markings</Box>
          </Stack.Item>
          <Stack.Item>
            <Button
              compact
              icon="plus"
              onClick={() => sendPreferenceAction(item, 'marking_style')}
            >
              Add
            </Button>
          </Stack.Item>
        </Stack>
        {item.markings.map((marking) => (
          <Stack align="center" key={marking.name} mt={0.25}>
            <Stack.Item>
              <Box
                className="body-appearance__color"
                style={{ backgroundColor: marking.color }}
              />
            </Stack.Item>
            <Stack.Item grow>{marking.name}</Stack.Item>
            {!!marking.can_reorder && (
              <>
                <Stack.Item>
                  <Button
                    compact
                    icon="chevron-up"
                    onClick={() =>
                      sendPreferenceAction(item, 'marking_up', marking.name)
                    }
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button
                    compact
                    icon="chevron-down"
                    onClick={() =>
                      sendPreferenceAction(item, 'marking_down', marking.name)
                    }
                  />
                </Stack.Item>
              </>
            )}
            <Stack.Item>
              <Button
                compact
                icon="eye-dropper"
                onClick={() =>
                  sendPreferenceAction(item, 'marking_color', marking.name)
                }
              >
                Color
              </Button>
            </Stack.Item>
            {!!marking.has_preset && (
              <Stack.Item>
                <Button
                  compact
                  onClick={() =>
                    sendPreferenceAction(item, 'marking_preset', marking.name)
                  }
                >
                  Preset
                </Button>
              </Stack.Item>
            )}
            <Stack.Item>
              <Button
                compact
                color="bad"
                icon="trash"
                onClick={() =>
                  sendPreferenceAction(item, 'marking_remove', marking.name)
                }
              />
            </Stack.Item>
          </Stack>
        ))}
      </Box>
    </Box>
  );

  const renderBackground = (item: BackgroundPreferenceItem) =>
    item.banned ? (
      <Box color="bad">You are banned from using character records.</Box>
    ) : (
      <Stack vertical>
        {item.records.map((record) => (
          <Stack.Item key={record.name}>
            <Box bold>{record.name} Records</Box>
            <Stack align="center">
              <Stack.Item grow>
                <Button
                  fluid
                  color="transparent"
                  onClick={() => sendPreferenceAction(item, record.edit_action)}
                >
                  {record.preview}
                </Button>
              </Stack.Item>
              <Stack.Item>
                <Button
                  compact
                  color="bad"
                  icon="trash"
                  onClick={() =>
                    sendPreferenceAction(item, 'clear', record.clear_value)
                  }
                >
                  Clear
                </Button>
              </Stack.Item>
            </Stack>
          </Stack.Item>
        ))}
      </Stack>
    );

  const renderFormActions = (
    item: FormPreferenceItem,
    actions: PreferenceAction[],
    inline = false,
  ) => (
    <Box
      className={`preference-form__actions${inline ? ' preference-form__actions--inline' : ''}`}
    >
      {actions.map((action) => (
        <Button
          compact
          color={action.color}
          icon={action.icon}
          key={`${action.action || action.label}-${action.value}`}
          onClick={() =>
            action.topic
              ? sendPreferenceTopic(item, action.topic)
              : sendPreferenceAction(item, action.action!, action.value)
          }
        >
          {action.preview_color && (
            <Box
              className="preference-action__color"
              style={{ backgroundColor: action.preview_color }}
            />
          )}
          {action.label}
        </Button>
      ))}
    </Box>
  );

  const renderForm = (item: FormPreferenceItem) => (
    <Stack className="preference-form" vertical>
      {item.sections.map((section, sectionIndex) => (
        <Stack.Item key={section.title || sectionIndex}>
          {section.title &&
            !(
              sectionIndex === 0 &&
              normalizedHeading(section.title) === normalizedHeading(item.name)
            ) && (
              <Box className="preference-form__heading">{section.title}</Box>
            )}
          {section.description &&
            (section.description_html ? (
              <Box
                color="label"
                dangerouslySetInnerHTML={{ __html: section.description }}
                mb={0.5}
              />
            ) : (
              <Box color="label" mb={0.5}>
                {section.description}
              </Box>
            ))}
          {section.warning &&
            (section.warning_html ? (
              <Box
                color="bad"
                dangerouslySetInnerHTML={{ __html: section.warning }}
                mb={0.5}
              />
            ) : (
              <Box color="bad" mb={0.5}>
                {section.warning}
              </Box>
            ))}
          <Box className="preference-form__fields">
            {section.fields.map((field, fieldIndex) => (
              <Box
                className={`preference-form__field${
                  section.fields.some(
                    (sectionField) =>
                      !!sectionField.actions?.length &&
                      !sectionField.inline_actions,
                  )
                    ? ' preference-form__field--with-actions'
                    : ''
                }${field.actions_below ? ' preference-form__field--actions-below' : ''}`}
                key={`${field.label}-${fieldIndex}`}
              >
                <Box className="preference-form__label">{field.label}</Box>
                <Box className="preference-form__value">
                  {field.color && (
                    <Box
                      className="body-appearance__color"
                      style={{ backgroundColor: field.color }}
                    />
                  )}
                  {field.pencode ? (
                    <span style={{ fontFamily: field.font }}>
                      {renderPencode(String(field.value ?? ''))}
                    </span>
                  ) : field.href ? (
                    <a href={field.href}>{field.value}</a>
                  ) : field.action || field.topic ? (
                    <a
                      onClick={() =>
                        field.topic
                          ? sendPreferenceTopic(item, field.topic)
                          : sendPreferenceAction(
                              item,
                              field.action!,
                              field.action_value,
                            )
                      }
                      role="button"
                      tabIndex={0}
                    >
                      {field.value}
                    </a>
                  ) : (
                    field.value
                  )}
                  {field.note && (
                    <Box color="label" fontSize={0.9}>
                      {field.note}
                    </Box>
                  )}
                  {!!field.actions?.length &&
                    !!field.inline_actions &&
                    renderFormActions(item, field.actions, true)}
                </Box>
                {!!field.actions?.length &&
                  !field.inline_actions &&
                  renderFormActions(item, field.actions)}
              </Box>
            ))}
          </Box>
        </Stack.Item>
      ))}
    </Stack>
  );

  const renderSkills = (item: SkillsPreferenceItem) => (
    <Box className="skills-preferences">
      <Box className="skills-preferences__education">
        <b>Education:</b>{' '}
        <a
          onClick={() => sendPreferenceAction(item, 'open_education_menu')}
          role="button"
          tabIndex={0}
        >
          {item.education}
        </a>
        <Box color="label" mt={0.5}>
          {item.education_description}
        </Box>
      </Box>
      {item.categories.map((category) => (
        <Box className="skill-category" key={category.name}>
          <Box className="skill-category__title">
            <span>{category.name}</span>
            <span>{category.remaining} points remaining</span>
          </Box>
          {category.subcategories.map((subcategory) => (
            <Box className="skill-subcategory" key={subcategory.name}>
              <Box className="skill-subcategory__title">{subcategory.name}</Box>
              {subcategory.skills.map((skill) => (
                <Box className="skill-row" key={skill.type}>
                  <Box className="skill-row__info">
                    <Stack align="center">
                      <Stack.Item grow>
                        <Box bold>{skill.name}</Box>
                      </Stack.Item>
                      <Stack.Item>
                        <Button
                          compact
                          color="transparent"
                          icon="circle-info"
                          tooltip={
                            <Box preserveWhitespace>
                              {[skill.description, skill.current_description]
                                .filter(Boolean)
                                .join('\n\n')}
                            </Box>
                          }
                        />
                      </Stack.Item>
                    </Stack>
                    {skill.uneducated_cap && (
                      <Box color="average" fontSize={0.85}>
                        Uneducated cap: {skill.uneducated_cap}
                      </Box>
                    )}
                  </Box>
                  <Box className="skill-row__levels">
                    {skill.levels.map((level) => (
                      <Button
                        className={`skill-level skill-level--${level.state}`}
                        disabled={!level.selectable}
                        key={level.value}
                        onClick={() =>
                          sendPreferenceTopic(item, {
                            setskill: skill.type,
                            newvalue: level.value,
                          })
                        }
                        selected={level.state === 'current'}
                        tooltip={`${level.cost} points`}
                      >
                        {level.label} ({level.cost})
                      </Button>
                    ))}
                  </Box>
                </Box>
              ))}
            </Box>
          ))}
        </Box>
      ))}
    </Box>
  );

  const renderLoadout = (item: LoadoutPreferenceItem) => (
    <Box className="loadout-preferences">
      {item.gear_reset ? (
        <Box color="bad" mb={1} textAlign="center">
          Your loadout failed to load and will be reset if you save this slot.
        </Box>
      ) : null}
      <Stack align="center" justify="center">
        <Stack.Item>
          <Button
            icon="chevron-left"
            onClick={() => sendPreferenceAction(item, 'prev_slot')}
          />
        </Stack.Item>
        <Stack.Item>
          <Box bold>
            Slot {item.slot} &middot; {item.cost}/{item.cost_limit} points
          </Box>
        </Stack.Item>
        <Stack.Item>
          <Button
            icon="chevron-right"
            onClick={() => sendPreferenceAction(item, 'next_slot')}
          />
        </Stack.Item>
        <Stack.Item>
          <Button
            icon="clone"
            onClick={() => sendPreferenceAction(item, 'duplicate_loadout')}
          >
            Duplicate Loadout
          </Button>
        </Stack.Item>
        <Stack.Item>
          <Button
            color="bad"
            icon="trash"
            onClick={() => sendPreferenceAction(item, 'clear_loadout')}
          >
            Clear Loadout
          </Button>
        </Stack.Item>
      </Stack>
      <Box className="loadout-categories">
        {item.categories.map((category) => (
          <Button
            color={category.has_selected ? 'average' : undefined}
            key={category.name}
            onClick={() =>
              sendPreferenceAction(item, 'select_category', category.name)
            }
            selected={category.selected}
          >
            {category.name}
          </Button>
        ))}
      </Box>
      <Input
        fluid
        onDragStart={(event) => event.stopPropagation()}
        onBlur={(value) =>
          sendPreferenceAction(item, 'search_input_refresh', value)
        }
        onMouseDown={(event) => event.stopPropagation()}
        placeholder="Search this category"
        value={item.search}
      />
      <Box className="loadout-items">
        {item.items.map((gear) => (
          <Box
            className={`loadout-item${gear.selected ? ' loadout-item--selected' : ''}${!gear.available ? ' loadout-item--unavailable' : ''}`}
            key={gear.name}
          >
            <Stack align="center">
              <Stack.Item grow>
                <Button
                  color={gear.selected ? 'average' : 'transparent'}
                  fluid
                  onClick={() =>
                    sendPreferenceAction(item, 'toggle_gear', gear.name)
                  }
                  selected={gear.selected}
                >
                  {gear.name}
                </Button>
              </Stack.Item>
              <Stack.Item>
                <Box bold>{gear.cost} pt</Box>
              </Stack.Item>
            </Stack>
            <Box color="label" mt={0.5}>
              {gear.description}
            </Box>
            {!!gear.restrictions.length && (
              <Box fontSize={0.85} mt={0.5}>
                {gear.restrictions.join(' · ')}
              </Box>
            )}
            {!!gear.tweaks.length && (
              <Box className="loadout-item__tweaks" mt={0.5}>
                {gear.tweaks.map((tweak) => (
                  <Button
                    compact
                    fluid
                    key={tweak.label}
                    onClick={() =>
                      tweak.topic && sendPreferenceTopic(item, tweak.topic)
                    }
                  >
                    {tweak.preview_color && (
                      <Box
                        className="preference-action__color"
                        style={{ backgroundColor: tweak.preview_color }}
                      />
                    )}
                    {tweak.label}
                  </Button>
                ))}
              </Box>
            )}
          </Box>
        ))}
      </Box>
    </Box>
  );

  const renderItem = (item: PreferenceItem) => (
    <Box className="preference-card" key={item.ref}>
      <Box className="preference-card__title">{item.name}</Box>
      <Box className="preference-card__content">
        {item.kind === 'body' ? (
          renderBody(item)
        ) : item.kind === 'background' ? (
          renderBackground(item)
        ) : item.kind === 'form' ? (
          renderForm(item)
        ) : item.kind === 'skills' ? (
          renderSkills(item)
        ) : item.kind === 'loadout' ? (
          renderLoadout(item)
        ) : item.kind === 'occupation' ? (
          renderOccupation(item)
        ) : (
          <Box textAlign="center">{item.message}</Box>
        )}
      </Box>
    </Box>
  );

  const itemSplit = Math.max(1, Math.floor(data.items.length / 2));
  const useWideLayout =
    data.items.length === 1 ||
    data.items.some(
      (item) =>
        item.kind === 'occupation' ||
        item.kind === 'skills' ||
        item.kind === 'loadout',
    );

  return (
    <Window height={900} theme="character-setup" width={1280}>
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
                  <Box className="CharacterSetup__identity">
                    <Box as="span" bold fontSize={1.3}>
                      {data.character_name || 'Unsaved Character'}
                    </Box>
                    <Box as="span" color="label">
                      &middot; {data.faction_name}
                    </Box>
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
                  {data.loading ? (
                    <LoadingScreen label="Loading character preferences... (Please press F5 if this gets stuck!)" />
                  ) : (
                    <Box className="CharacterSetup__content">
                      {useWideLayout ? (
                        data.items.map(renderItem)
                      ) : (
                        <Box className="preference-columns">
                          <Box className="preference-column">
                            {data.items.slice(0, itemSplit).map(renderItem)}
                          </Box>
                          <Box className="preference-column">
                            {data.items.slice(itemSplit).map(renderItem)}
                          </Box>
                        </Box>
                      )}
                    </Box>
                  )}
                </Section>
              </Stack.Item>
              <Stack.Item>
                <Section
                  className="CharacterSetup__preview"
                  fill
                  title="Character Preview"
                >
                  <Box className="character-preview-grid">
                    {[
                      ['south', 'Front'],
                      ['north', 'Back'],
                      ['west', 'Left'],
                      ['east', 'Right'],
                    ].map(([direction, label]) => (
                      <Box
                        className="character-preview-grid__tile"
                        key={direction}
                      >
                        <Box className="character-preview-grid__label">
                          {label}
                        </Box>
                        <CharacterPreview
                          id={`character_setup_preview_${direction}`}
                          height="160px"
                          hidden={modalOpen || data.loading}
                          width="100%"
                        />
                      </Box>
                    ))}
                  </Box>
                </Section>
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
        {renderSlotDialog()}
        {renderSpeciesDialog()}
      </Window.Content>
    </Window>
  );
};

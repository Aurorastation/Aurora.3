import { Box, Button, NoticeBox, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { useBackend } from '../backend';
import { Window } from '../layouts';

type SkillLevelOption = {
  cost: number;
  label: string;
  selectable: BooleanLike;
  state: 'forced' | 'current' | 'selectable' | 'unavailable';
  value: number;
};

type SkillItem = {
  current_description: string;
  description: string;
  levels: SkillLevelOption[];
  name: string;
  type: string;
};

type SkillSubcategory = {
  name: string;
  skills: SkillItem[];
};

type SkillCategory = {
  bonus: number;
  name: string;
  remaining: number;
  subcategories: SkillSubcategory[];
};

type SkillsMenuData = {
  categories?: SkillCategory[];
  initialized: BooleanLike;
};

export const SkillsMenu = () => {
  const { act, data } = useBackend<SkillsMenuData>();

  return (
    <Window width={850} height={700}>
      <Window.Content scrollable className="SkillsMenu">
        {!data.initialized ? (
          <NoticeBox>
            Skills are not initialized yet. Please wait a moment and reopen
            this menu.
          </NoticeBox>
        ) : (
          <Box className="skills-menu">
            <Box className="skills-menu__header">
              <Stack align="center" justify="space-between">
                <Stack.Item grow>
                  <Box bold>One-Time Skills Configuration</Box>
                  <Box color="label" mt={0.5}>
                    Education restrictions do not apply. Pre-existing skills
                    cannot be lowered. Click Confirm Skills when finished to
                    apply your choices.
                  </Box>
                </Stack.Item>
                <Stack.Item>
                  <Button.Confirm
                    color="good"
                    confirmColor="good"
                    confirmContent="Finalize Skills?"
                    icon="check"
                    onClick={() => act('confirm')}
                  >
                    Confirm Skills
                  </Button.Confirm>
                </Stack.Item>
              </Stack>
            </Box>

            {data.categories?.map((category) => (
              <Box className="skill-category" key={category.name}>
                <Box className="skill-category__title">
                  <span>{category.name}</span>
                  <span>
                    {category.remaining} points remaining
                    {category.bonus > 0 ? ` (+${category.bonus} bonus)` : ''}
                  </span>
                </Box>
                {category.subcategories.map((subcategory) => (
                  <Box className="skill-subcategory" key={subcategory.name}>
                    <Box className="skill-subcategory__title">
                      {subcategory.name}
                    </Box>
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
                                    {[
                                      skill.description,
                                      skill.current_description,
                                    ]
                                      .filter(Boolean)
                                      .join('\n\n')}
                                  </Box>
                                }
                              />
                            </Stack.Item>
                          </Stack>
                        </Box>
                        <Box className="skill-row__levels">
                          {skill.levels.map((level) => (
                            <Button
                              className={`skill-level skill-level--${level.state}`}
                              disabled={!level.selectable}
                              key={level.value}
                              onClick={() =>
                                act('setskill', {
                                  skill: skill.type,
                                  level: level.value,
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
        )}
      </Window.Content>
    </Window>
  );
};

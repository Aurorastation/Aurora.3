// code/modules/tgui/modules/faction_select.dm
import { classes } from 'common/react';
import { resolveAsset } from '../assets';
import { useBackend } from '../backend';
import {
  Box,
  Button,
  Divider,
  Flex,
  Icon,
  LabeledList,
  Section,
  Stack,
} from '../components';
import { Window } from '../layouts';

export type FactionSelectData = {
  chosen_faction: string;
  viewed_faction: string;
  viewed_selection_error: string;
  factions: Faction[];
  wiki_url: string;
};

export type Faction = {
  name: string;
  suffix: string;
  desc: string;
  logo: string;
  departments: string[];
  wiki_page: string;
};

export const FactionSelect = () => {
  return (
    <Window theme="faction_select" width={900} height={645}>
      <Window.Content>
        <Stack fill>
          <Stack.Item width="22em">
            <FactionList />
          </Stack.Item>
          <Stack.Item grow>
            <FactionInfo />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const FactionList = (props, context) => {
  const { act, data } = useBackend<FactionSelectData>(context);
  return (
    <Section fill fitted pl={1} py={1} scrollable>
      <Stack vertical>
        {data.factions.map((faction) => (
          <Stack.Item key={faction.name}>
            <Button
              className={`faction_entry--${faction.suffix}`}
              fluid
              selected={faction.name === data.chosen_faction}
              color={faction.name === data.viewed_faction ? 'label' : 'grey'}
              style={{ 'white-space': 'normal' }}
              onClick={() => act('view_faction', { faction: faction.name })}
            >
              <Flex align="center" justify="space-between">
                <Flex.Item bold fontSize={1.08}>
                  {faction.name}
                </Flex.Item>
                <Flex.Item pt={1} pr={0.5}>
                  <Box
                    as="img"
                    src={resolveAsset(faction.logo)}
                    width="48px"
                    height="48px"
                  />
                </Flex.Item>
              </Flex>
            </Button>
          </Stack.Item>
        ))}
      </Stack>
    </Section>
  );
};

const FactionInfo = (props, context) => {
  const { act, data } = useBackend<FactionSelectData>(context);

  const currentFaction = data.factions.find(
    (faction) => faction.name === data.viewed_faction
  )!; // Non-null assertion for `currentFaction` since if it is null, that shouldn't be handled here.

  return (
    <Flex height="100%" direction="column" justify="space-between">
      <Flex.Item>
        <Section>
          <Box
            my={1}
            textAlign="center"
            bold
            fontSize={2.1}
            fontFamily="Arial Black"
          >
            {currentFaction.name}
          </Box>
        </Section>
      </Flex.Item>
      <Flex.Item>
        <Divider />
      </Flex.Item>
      <Flex.Item grow>
        <Flex height="100%">
          <Flex.Item grow>
            <Section fill scrollable fontSize={1.1}>
              {currentFaction.desc}
            </Section>
          </Flex.Item>
          <Flex.Item align="center" height="100%" mt={12.5}>
            <div
              class={classes([
                'Divider--vertical',
                'Divider--vertical--dashed',
              ])}
              style={{ height: '85%' }}
            />
          </Flex.Item>
          <Flex.Item width="15.5em">
            <FactionPanel currentFaction={currentFaction} />
          </Flex.Item>
        </Flex>
      </Flex.Item>
      <Flex.Item>
        <Divider />
        <Box textAlign="center">
          ━━ You can learn more about this faction on the wiki:&nbsp;
          <Button
            icon="arrow-up-right-from-square"
            disabled={!currentFaction.wiki_page}
            title={
              currentFaction.wiki_page
                ? data.wiki_url + currentFaction.wiki_page
                : 'This faction currently has no wiki page'
            }
            onClick={() => act('open_wiki', { 'faction': currentFaction.name })}
          />
          &nbsp;━━
        </Box>
      </Flex.Item>
    </Flex>
  );
};

const FactionPanel = (props: { currentFaction: Faction }, context) => {
  const { currentFaction } = props;
  const { act, data } = useBackend<FactionSelectData>(context);

  const currentIsChosen = currentFaction.name === data.chosen_faction;
  const CanSelect = () =>
    currentFaction.name === data.chosen_faction ||
    !!data.viewed_selection_error;

  const Checkmark = (input: boolean) => {
    if (input) {
      return <Icon name="check" size={1.1} color="good" />;
    } else {
      return <Icon name="xmark" size={1.1} color="bad" />;
    }
  };

  return (
    <Flex
      height="100%"
      direction="column"
      align="center"
      justify="space-between"
    >
      <Flex.Item>
        <Stack vertical align="center" textColor="label">
          <Stack.Item>
            <Box
              as="img"
              src={resolveAsset(currentFaction.logo)}
              height="13em"
              width="13em"
            />
          </Stack.Item>
          <Stack.Item bold fontSize={1.25}>
            <u>Departments:</u>
          </Stack.Item>
          {currentFaction.departments.map((department) => (
            <Stack.Item key={department} bold>
              {department}
            </Stack.Item>
          ))}
        </Stack>
      </Flex.Item>
      <Flex.Item>
        <Stack vertical>
          <Stack.Item>
            <Divider />
          </Stack.Item>
          <Stack.Item>
            <Button
              width="15em"
              height="3.75em"
              textAlign="center"
              bold
              verticalAlignContent="middle"
              style={{ 'white-space': 'normal' }}
              disabled={CanSelect()}
              onClick={() =>
                act('choose_faction', { 'faction': currentFaction.name })
              }
            >
              {`[${currentIsChosen ? 'Faction Selected' : (data.viewed_selection_error ?? 'Select Faction')}]`}
            </Button>
          </Stack.Item>
          <Stack.Item fontFamily="Tahoma" fontSize={1.05}>
            <LabeledList>
              <LabeledList.Item label="Citizenship Check">
                {Checkmark(true)}
                {/* NYI (/datum/faction/var/blacklisted_citizenship_types) */}
              </LabeledList.Item>
              <LabeledList.Item label="Cultural Check">
                {Checkmark(!data.viewed_selection_error)}
              </LabeledList.Item>
            </LabeledList>
          </Stack.Item>
        </Stack>
      </Flex.Item>
    </Flex>
  );
};

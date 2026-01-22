// code/modules/client/preference_setup/occupation/occupation.dm
import { resolveAsset } from "../assets";
import { useBackend } from "../backend";
import { Box, Button, Divider, Flex, Section, Stack } from "../components";
import { Window } from "../layouts";

export type FactionSelectData = {
  chosen_faction: string;
  viewed_faction: string;
  viewed_selection_error: string;
  factions: Faction[];
  wiki_url: string;
};

export type Faction = {
  name: string;
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
          <Stack.Item width="40%" maxWidth="350px">
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
        {data.factions.map(faction => (
          <Stack.Item key={faction.name}>
            <Button
              fluid
              selected={faction.name === data.chosen_faction}
              color={faction.name === data.viewed_faction ? "label" : "grey"}
              onClick={() => act("view_faction", { faction: faction.name })}
            >
              <Flex align="center" justify="space-between" minWidth="300px">
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

  // Non-null assertion for `currentFaction` since it being null shouldn't be handled here.
  const currentFaction = data.factions.find(faction => faction.name === data.viewed_faction)!;

  const SelectButton = () => {
    const currentIsChosen = currentFaction.name === data.chosen_faction;
    const CanSelect = () => currentFaction.name === data.chosen_faction || !!data.viewed_selection_error;

    return (
      <Button
        width="12em"
        height="5em"
        textAlign="center"
        verticalAlignContent="middle"
        style={{ "white-space": "normal" }}
        disabled={CanSelect()}
        onClick={() => act("choose_faction", { "faction": currentFaction.name })}
      >
        {data.viewed_selection_error ?? (currentIsChosen ? "[Faction Selected]" : "[Select Faction]")}
      </Button>
    );
  };

  return (
    <Flex height="100%" direction="column" justify="space-between">
      <Flex.Item>
        <Section>
          <Box my={1} textAlign="center" bold fontSize={2.1} fontFamily="Arial Black">
            {currentFaction.name}
          </Box>
        </Section>
      </Flex.Item>
      <Flex.Item>
        <Divider />
      </Flex.Item>
      <Flex.Item grow>
        <Flex height="95%">
          <Flex.Item grow>
            <Section fill scrollable fontSize={1.1}>
              {currentFaction.desc}
            </Section>
          </Flex.Item>
          <Flex.Item align="center" height="100%" mt={15.5}>
            <div class="Divider--faction_select" />
          </Flex.Item>
          <Flex.Item width="35%">
            <Flex height="95%" direction="column" align="center" justify="space-between">
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
                  {currentFaction.departments.map(department => (
                    <Stack.Item key={department} bold>
                      {department}
                    </Stack.Item>
                  ))}
                </Stack>
              </Flex.Item>
              <Flex.Item>
                <SelectButton />
              </Flex.Item>
            </Flex>
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
            title={currentFaction.wiki_page ? data.wiki_url + currentFaction.wiki_page : "This faction currently has no wiki page"}
            onClick={() => act("open_wiki", { "faction": currentFaction.name })}
          />
          &nbsp;━━
        </Box>
      </Flex.Item>
    </Flex>
  );
};

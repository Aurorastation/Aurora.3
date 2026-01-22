// code/modules/client/preference_setup/occupation/occupation.dm
import { resolveAsset } from "../assets";
import { useBackend } from "../backend";
import { Box, Button, Divider, Flex, Section, Stack } from "../components";
import { Window } from "../layouts";

export type FactionSelectData = {
  chosen_faction: string;
  viewed_faction: string;
  factions: Faction[];
}

export type Faction = {
  name: string;
  desc: string;
  logo: string;
  departments: string;
}

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
              onClick={() => act("view_faction", { faction: faction.name })}>
                <Flex align="center" justify="space-between" minWidth="300px">
                  <Flex.Item>
                    <Box bold fontSize={1.08}>
                      {faction.name}
                    </Box>
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
  const currentFaction = data.factions.find(faction => faction.name === data.viewed_faction)!;
  // Non-null assertion for `currentFaction` since it being null would be a backend problem.
  const currentIsChosen = currentFaction.name === data.chosen_faction;

  return (
    <Flex height="100%" direction="column" justify="space-between">
      <Flex.Item>
        <Section textAlign="center" bold fontSize={2} fontFamily="Arial Black">
          {currentFaction.name}
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
          <Flex.Item>
            <Divider vertical />
          </Flex.Item>
          <Flex.Item width="35%">
            <Stack vertical align="center" textColor="label">
              <Stack.Item>
                <Box
                  as="img"
                  src={resolveAsset(currentFaction.logo)}
                  height="13em"
                  width="13em"
                />
              </Stack.Item>
              <Stack.Item bold>
                <u>Departments:</u>
              </Stack.Item>
              <Stack.Item>
                {currentFaction.departments}
              </Stack.Item>
              <Stack.Item>
                <Button
                  disabled={currentIsChosen}
                  onClick={() => act("choose_faction", { "faction": currentFaction.name })}>
                  {currentIsChosen ? "Faction Selected" : "Select Faction"}
                </Button>
              </Stack.Item>
            </Stack>
          </Flex.Item>
        </Flex>
      </Flex.Item>
      <Flex.Item>
        <Divider />
        <Box textAlign="center">
          ━━ You can learn more about this faction on <a href='byond://?src=[REF(user.client)];JSlink=wiki;wiki_page=[replacetext(faction.name, " ", "_")]'>the wiki</a>. ━━
        </Box>
      </Flex.Item>
    </Flex>
  );
};

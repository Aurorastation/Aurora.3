// code/modules/client/preference_setup/occupation/occupation.dm
import { resolveAsset } from "../assets";
import { useBackend } from "../backend";
import { Box, Button, Flex, Section, Stack } from "../components";
import { Window } from "../layouts";

export type FactionSelectData = {
  selected_faction: string;
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
    <Window width={900} height={600}>
      <Window.Content>
        <Stack fill>
          <Stack.Item grow>
            <FactionList />
          </Stack.Item>
          <Stack.Item width="60%">
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
              color={faction.name === data.selected_faction ? "label" : "grey"}
              style={faction.name === data.selected_faction ? { border: '2px solid silver' } : {}}>
                <Flex align="center" justify="space-between">
                  <Flex.Item>
                    <Box bold fontSize={1.08}>
                      {faction.name}
                    </Box>
                  </Flex.Item>
                  <Flex.Item pt={1}>
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
  return (
    <Flex>
      description and stuff goes here
    </Flex>
  );
};

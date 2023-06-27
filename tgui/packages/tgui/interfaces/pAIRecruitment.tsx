import { useBackend } from '../backend';
import { BlockQuote, Box, Button, Input, Section } from '../components';
import { Window } from '../layouts';

export type pAIData = {
  name: string;
  description: string;
  role: string;
  comments: string;
};

export const pAIRecruitment = (props, context) => {
  const { act, data } = useBackend<pAIData>(context);

  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section
          title="pAI Recruitment"
          buttons={
            <Button
              content="Submit"
              icon="check"
              color="good"
              onClick={() =>
                act('submit', {
                  name: data.name,
                  description: data.description,
                  role: data.role,
                  comments: data.comments,
                })
              }
            />
          }>
          <BlockQuote>
            Please configure your pAI personality&apos;s options. Remember, what
            you enter here could determine whether or not the user requesting a
            personality chooses you!
          </BlockQuote>
          <Section title="Name">
            What you plan to call yourself. Suggestions: Any character name you
            would choose for a station character OR an AI.
            <Box>
              <Input
                value={data.name}
                onChange={(e, value) => act('name', { name: value })}
              />
            </Box>
          </Section>
          <Section title="Description">
            What sort of pAI you typically play; your mannerisms, your quirks,
            etc. This can be as sparse or as detailed as you like.
            <Box>
              <Input
                value={data.description}
                fluid={1}
                onChange={(e, value) =>
                  act('description', { description: value })
                }
              />
            </Box>
          </Section>
          <Section title="Preferred Role">
            Do you like to partner with sneaky social ninjas? Like to help
            security hunt down thugs? Enjoy watching an engineer&apos;s back
            while he saves the station yet again? This doesn&apos;t have to be
            limited to just station jobs. Pretty much any general descriptor for
            what you&apos;d like to be doing works here.
            <Box>
              <Input
                value={data.role}
                fluid={1}
                onChange={(e, value) => act('role', { role: value })}
              />
            </Box>
          </Section>
          <Section title="OOC Comments">
            Anything you&apos;d like to address specifically to the player
            reading this in an OOC manner. &quot;I prefer more serious
            RP.&quot;, &quot;I&apos;m still learning the interface!&quot;, etc.
            Feel free to leave this blank if you want.
            <Box>
              <Input
                value={data.comments}
                fluid={1}
                onChange={(e, value) => act('comments', { comments: value })}
              />
            </Box>
          </Section>
        </Section>
      </Window.Content>
    </Window>
  );
};

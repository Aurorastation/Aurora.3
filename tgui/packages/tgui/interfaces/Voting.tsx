import { useBackend } from '../backend';
import { capitalizeAll } from '../../common/string';
import { Window } from '../layouts';
import { Section, Button, Box, Table } from '../components';

type VoteChoice = {
  choice: string;
  votes: number;
  extra: string;
};

export type VotingData = {
  choices: VoteChoice[];
  is_staff: boolean;
  mode: string;
  question: string;
  voted: string;
  allow_vote_restart: boolean;
  allow_vote_mode: boolean;
  allow_extra_antags: boolean;
};

export const Voting = (props, context) => {
  const { act, data } = useBackend<VotingData>(context);

  return (
    <Window resizable>
      <Window.Content scrollable>
        {data.mode ? <VoteWindow /> : <StartVoteWindow />}
      </Window.Content>
    </Window>
  );
};

export const VoteWindow = (props, context) => {
  const { act, data } = useBackend<VotingData>(context);
  return (
    <Section
      collapsing
      title={data.question}
      buttons={
        data.is_staff ? (
          <Button content="Cancel" onClick={() => act('cancel')} />
        ) : (
          ''
        )
      }>
      <Table>
        <Table.Row header>
          <Table.Cell>
            <Box bold>Choices</Box>
          </Table.Cell>
          <Table.Cell textAlign="right">
            <Box bold>Votes</Box>
          </Table.Cell>
          {data.mode === 'gamemode' && (
            <Table.Cell textAlign="center">Minimum Players</Table.Cell>
          )}
        </Table.Row>
        {data.choices.map((choice) => (
          <Table.Row key={choice.choice}>
            <Table.Cell>
              <Button
                content={capitalizeAll(choice.choice)}
                selected={choice.choice === data.voted}
                onClick={(value) => act('vote', { vote: choice })}
              />
            </Table.Cell>
            <Table.Cell textAlign="center">{choice.votes}</Table.Cell>
            {data.mode === 'gamemode' && (
              <Table.Cell textAlign="center">{choice.extra}</Table.Cell>
            )}
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
};

export const StartVoteWindow = (props, context) => {
  const { act, data } = useBackend<VotingData>(context);
  return (
    <Section collapsing title="Start a Vote">
      <Box>
        <Button
          content="Restart"
          disabled={!data.allow_vote_restart}
          onClick={(value) => act('restart')}
        />
      </Box>
      <Box>
        <Button
          content="Crew Transfer"
          disabled={!data.allow_vote_restart}
          tooltip="Disallowed on Code Red or above."
          onClick={(value) => act('crew_transfer')}
        />
      </Box>
      <Box>
        <Button
          content="Toggle Restart / Crew Transfer Voting"
          disabled={!data.is_staff}
          onClick={(value) => act('toggle_restart')}
        />
      </Box>
      <Box>
        <Button
          content="Toggle Gamemode Voting"
          disabled={!data.is_staff || !data.allow_vote_mode}
          onClick={(value) => act('toggle_gamemode')}
        />
      </Box>
      <Box>
        <Button
          content="Add Antagonist Type"
          disabled={!data.allow_extra_antags}
          onClick={(value) => act('add_antagonist')}
        />
      </Box>
      <Box>
        <Button
          content="Custom"
          disabled={!data.is_staff}
          onClick={(value) => act('custom')}
        />
      </Box>
    </Section>
  );
};

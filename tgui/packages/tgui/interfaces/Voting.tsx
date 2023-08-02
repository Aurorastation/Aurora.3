import { useBackend } from '../backend';
import { capitalizeAll } from '../../common/string';
import { Window } from '../layouts';
import { Section, Button, Box, Table } from '../components';

type VoteChoice = {
  choice: string;
  votes: number;
  extra: string;
  required_players: number;
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
  total_players: number;
  total_players_ready: number;
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

  const extra_column =
    data.choices.filter((choice) => {
      return choice.extra && choice.extra !== '';
    }).length > 0;

  const required_players_column =
    data.choices.filter((choice) => {
      return choice.required_players && choice.required_players > 0;
    }).length > 0;

  if (required_players_column) {
    data.choices.sort((a, b) => {
      if (a.required_players < b.required_players) return -1;
      else if (a.required_players > b.required_players) return +1;
      else return 0;
    });
  }

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
          {extra_column && <Table.Cell textAlign="center" />}
          {required_players_column && (
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
            {extra_column && (
              <Table.Cell textAlign="center">{choice.extra}</Table.Cell>
            )}
            {required_players_column && (
              <Table.Cell
                textAlign="center"
                color={(() => {
                  if (choice.required_players < data.total_players_ready)
                    return 'white';
                  else if (choice.required_players < data.total_players)
                    return 'lightgray';
                  else return 'gray';
                })()}>
                {choice.required_players ? choice.required_players : ''}
              </Table.Cell>
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

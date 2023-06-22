import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Box, Button, LabeledControls, LabeledList, Section } from '../components';
import { NtosWindow } from '../layouts';

export type ArcadeData = {
  player_health: number;
  player_mana: number;

  enemy_health: number;
  enemy_mana: number;
  enemy_name: string;

  gameover: BooleanLike;
  information: string;
};

export const NTOSArcade = (props, context) => {
  const { act, data } = useBackend<ArcadeData>(context);

  return (
    <NtosWindow resizable>
      <NtosWindow.Content scrollable>
        {data.gameover ? <GameOverWindow /> : <GameWindow />}
      </NtosWindow.Content>
    </NtosWindow>
  );
};

export const GameOverWindow = (props, context) => {
  const { act, data } = useBackend<ArcadeData>(context);

  return (
    <Section>
      <Box fontSize={3} textAlign="center">
        Game over!
      </Box>
      <Box>{data.information}</Box>
      <Box>You were brutally slain by {data.enemy_name}!</Box>
      <Button
        content="New Game"
        icon="newspaper"
        onClick={() => act('new_game')}
      />
    </Section>
  );
};

export const GameWindow = (props, context) => {
  const { act, data } = useBackend<ArcadeData>(context);

  return (
    <Section>
      <Box textAlign="center">{data.information}</Box>
      <Section title="Player">
        <LabeledList>
          <LabeledList.Item label="Health">
            {data.player_health}
          </LabeledList.Item>
          <LabeledList.Item label="Mana">{data.player_mana}</LabeledList.Item>
        </LabeledList>
      </Section>
      <Section title={data.enemy_name}>
        <LabeledList>
          <LabeledList.Item label="Health">
            {data.enemy_health}
          </LabeledList.Item>
          <LabeledList.Item label="Mana">{data.enemy_mana}</LabeledList.Item>
        </LabeledList>
      </Section>
      <Section title="Controls">
        <LabeledControls>
          <LabeledControls.Item label="Attack">
            <Button
              icon="chess-knight"
              color="red"
              onClick={() => act('attack')}
            />
          </LabeledControls.Item>
          <LabeledControls.Item label="Heal">
            <Button icon="plus" color="green" onClick={() => act('heal')} />
          </LabeledControls.Item>
          <LabeledControls.Item label="Regain Mana">
            <Button
              icon="magic"
              color="blue"
              onClick={() => act('regain_mana')}
            />
          </LabeledControls.Item>
          <LabeledControls.Item label="New Game">
            <Button icon="newspaper" onClick={() => act('new_game')} />
          </LabeledControls.Item>
        </LabeledControls>
      </Section>
    </Section>
  );
};

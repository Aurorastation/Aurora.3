import { BooleanLike } from 'common/react';
import { useBackend } from '../backend';
import { Box, Button, LabeledList, Section, Tooltip } from '../components';
import { Window } from '../layouts';

export type NeuralData = {
  neural_coherence: number;
  max_neural_coherence: number;
  owner_real_name: string;
  firewall: BooleanLike;
};

export const NeuralConfiguration = (props, context) => {
  const { act, data } = useBackend<NeuralData>(context);

  return (
    <Window
      resizable
      theme={
        data.neural_coherence < data.max_neural_coherence * 0.25
          ? 'spookyconsole'
          : 'ntos_lightmode'
      }>
      <Window.Content scrollable>
        <Section textAlign="center" title="Neural Configuration">
          <Box textAlign="center" fontSize={1.7}>
            This is your consciousness,{' '}
            <Box as="span" bold>
              {data.owner_real_name}.
            </Box>
          </Box>
          <Box textAlign="center" fontSize={1.5}>
            Your{' '}
            <Tooltip content="Neural coherence represents the stability of your positronic's inner workings and thoughts.">
              <Box as="span">neural coherence</Box>
            </Tooltip>
            is
            <Box
              as="span"
              bold
              textColor={neuralCoherenceLabel(
                data.neural_coherence,
                data.max_neural_coherence
              )}>
              {describeNeuralCoherence(
                data.neural_coherence,
                data.max_neural_coherence
              )}
            </Box>
          </Box>
          <LabeledList>
            <LabeledList.Item label="Firewall">
              <Button
                content={data.firewall ? 'Enabled' : 'Disabled'}
                color={data.firewall ? 'good' : 'bad'}
                tooltip="Disabling your firewall subroutines will allow external access to your software."
                icon={data.firewall ? 'shield-virus' : 'warning'}
                onClick={() => act('toggle_firewall')}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};

export const describeNeuralCoherence = (
  neuralCoherence,
  maxNeuralCoherence = 200
) => {
  if (neuralCoherence >= maxNeuralCoherence) {
    return 'synchronized';
  } else if (neuralCoherence > maxNeuralCoherence * 0.75) {
    return 'slightly fragmented';
  } else if (neuralCoherence > maxNeuralCoherence * 0.5) {
    return 'fragmented';
  } else if (neuralCoherence > maxNeuralCoherence * 0.25) {
    return 'heavily fragmented';
  } else if (neuralCoherence > 0) {
    return 'F̷͈͈̥͉̀͌̓̓̀̈́̆̓͒̓̊A̷͖͔̮̯͕̖̼̜͛̄̈́̐͘̕L̶̛͎̞̪̋̎̀̎͐̐̉͆͂́̇̅͘͠L̸̢̹̘̟̈́͘͝I̵̢̢̛̪͍̭͖̝͔͉̙̱͎̼̭̝͒̅͆̾̍͛̎̀̅̐N̶̨̘̭͒͑͛͛̈̚̚͜G̶͙͖̊̍̋̔͝͝͝͠ ̷̢̖̞̣̲̠͊̊ͅȂ̸̛̹̟̻̘̭͓̣̺̱͙͎͉͖͇̲͗͐̓P̴̧̲̬̗̥͖̤̫͓̲̝͉̓͋͜Ȁ̸̹̈́̊͗̌̾́̽͑̓̕R̸̢̡͇͋̔̔̓̒͂̉̎̍̎͜T̸̡͕̥̖̳͚͓̜͇̱͚̤̮̰̔̉̒͛͌͛̀̈́̓͝ͅ';
  } else if (neuralCoherence <= 0) {
    return '';
  } else {
    return 'ERROR';
  }
};

export const neuralCoherenceLabel = (
  neuralCoherence,
  maxNeuralCoherence = 200
) => {
  if (neuralCoherence >= maxNeuralCoherence) {
    return 'good';
  } else if (neuralCoherence > maxNeuralCoherence * 0.75) {
    return 'yellow';
  } else if (neuralCoherence > maxNeuralCoherence * 0.5) {
    return 'orange';
  } else if (neuralCoherence > maxNeuralCoherence * 0.25) {
    return 'average';
  } else if (neuralCoherence > 0) {
    return 'bad';
  } else if (neuralCoherence <= 0) {
    return 'bad';
  } else {
    return 'bad';
  }
};

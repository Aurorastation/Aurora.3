import { BooleanLike } from 'tgui-core/react';
import { useBackend } from '../backend';
import { Box, Button, LabeledControls, Section, Tooltip } from 'tgui-core/components';
import { Window } from '../layouts';

export type NeuralData = {
  neural_coherence: number;
  max_neural_coherence: number;
  owner_real_name: string;
  firewall: BooleanLike;
  p2p_communication: BooleanLike;

  port: BooleanLike;
  port_connected: BooleanLike;
  port_can_communicate: BooleanLike;
};

export const NeuralConfiguration = (props) => {
  const { act, data } = useBackend<NeuralData>();

  return (
    <Window
      theme={
        data.neural_coherence > data.max_neural_coherence * 0.75
          ? 'spookyconsole'
          : 'scc'
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
              <Box as="span">neural coherence </Box>
            </Tooltip>
            is{' '}
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
              .
            </Box>
          </Box>
          <LabeledControls>
            <LabeledControls.Item label="Firewall">
              <Button
                content={data.firewall ? 'Enabled' : 'Disabled'}
                color={data.firewall ? 'good' : 'bad'}
                tooltip="Disabling your firewall subroutines will allow external access to your software."
                icon={data.firewall ? 'shield-virus' : 'warning'}
                onClick={() => act('toggle_firewall')}
              />
            </LabeledControls.Item>
            <LabeledControls.Item label="Virtual Communication">
              <Button
                content={
                  data.port
                    ? data.p2p_communication
                      ? 'Allowed'
                      : 'Disallowed'
                    : 'ERROR'
                }
                color={data.p2p_communication ? 'good' : 'bad'}
                disabled={!data.port}
                icon="voicemail"
                onClick={() => act('toggle_p2p')}
              />
            </LabeledControls.Item>
          </LabeledControls>
          {data.port ? (
            data.port_connected ? (
              <Box>
                A Virtual Connection is set up.{' '}
                <Button
                  content={
                    data.port
                      ? data.port_can_communicate
                        ? 'Message'
                        : 'N/A'
                      : 'ERROR'
                  }
                  color={
                    data.port
                      ? data.port_can_communicate
                        ? 'green'
                        : 'grey'
                      : 'bad'
                  }
                  icon="mail-forward"
                  disabled={!data.port || !data.port_can_communicate}
                  onClick={() => act('talk_p2p')}
                />
              </Box>
            ) : (
              ''
            )
          ) : (
            ''
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};

export const describeNeuralCoherence = (
  neuralCoherence,
  maxNeuralCoherence = 200
) => {
  if (neuralCoherence > maxNeuralCoherence * 0.8) {
    return 'F̷͈͈̥͉̀͌̓̓̀̈́̆̓͒̓̊A̷͖͔̮̯͕̖̼̜͛̄̈́̐͘̕L̶̛͎̞̪̋̎̀̎͐̐̉͆͂́̇̅͘͠L̸̢̹̘̟̈́͘͝I̵̢̢̛̪͍̭͖̝͔͉̙̱͎̼̭̝͒̅͆̾̍͛̎̀̅̐N̶̨̘̭͒͑͛͛̈̚̚͜G̶͙͖̊̍̋̔͝͝͝͠ ̷̢̖̞̣̲̠͊̊ͅȂ̸̛̹̟̻̘̭͓̣̺̱͙͎͉͖͇̲͗͐̓P̴̧̲̬̗̥͖̤̫͓̲̝͉̓͋͜Ȁ̸̹̈́̊͗̌̾́̽͑̓̕R̸̢̡͇͋̔̔̓̒͂̉̎̍̎͜T̸̡͕̥̖̳͚͓̜͇̱͚̤̮̰̔̉̒͛͌͛̀̈́̓͝ͅ';
  } else if (neuralCoherence > maxNeuralCoherence * 0.75) {
    return 'heavily fragmented';
  } else if (neuralCoherence > maxNeuralCoherence * 0.5) {
    return 'fragmented';
  } else if (neuralCoherence > maxNeuralCoherence * 0.25) {
    return 'slightly fragmented';
  } else if (neuralCoherence > maxNeuralCoherence * 0.1) {
    return 'slightly desynchronized';
  } else {
    return 'synchronized';
  }
};

export const neuralCoherenceLabel = (
  neuralCoherence,
  maxNeuralCoherence = 200
) => {
  if (neuralCoherence > maxNeuralCoherence * 0.75) {
    return 'bad';
  } else if (neuralCoherence > maxNeuralCoherence * 0.5) {
    return 'orange';
  } else if (neuralCoherence > maxNeuralCoherence * 0.25) {
    return 'yellow';
  } else if (neuralCoherence > maxNeuralCoherence * 0.1) {
    return 'good';
  } else {
    return 'good';
  }
};

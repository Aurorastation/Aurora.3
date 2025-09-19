import { BooleanLike } from '../../common/react';
import { Button, LabeledList, ProgressBar, Section } from '../components';
import { useBackend } from '../backend';
import { Window } from '../layouts';

export type DisposalData = {
  is_on: BooleanLike;
  flush: BooleanLike;
  mode: Number;
  uses_air: BooleanLike;
  panel_open: BooleanLike;
  pressure: Number;
};

export const DisposalUnit = (props, context) => {
  const { act, data } = useBackend<DisposalData>(context);
  let stateColor;
  let modeText;
  if (!data.is_on) {
    stateColor = 'bad';
    modeText = 'Power Off';
  } else if (data.mode === 1) {
    stateColor = 'average';
    modeText = 'Pressurizing';
  } else if (data.mode === 2) {
    stateColor = 'good';
    modeText = 'Ready';
  } else {
    stateColor = 'good';
    modeText = 'Flushing';
  }
  return (
    <Window width={300} height={180}>
      <Window.Content>
        <Section>
          <LabeledList>
            <LabeledList.Item label="State" color={stateColor}>
              {modeText}
            </LabeledList.Item>
            <LabeledList.Item label="Pressure">
              <ProgressBar value={data.pressure} color="good" />
            </LabeledList.Item>
            <LabeledList.Item label="Handle">
              <Button
                icon={data.flush ? 'toggle-on' : 'toggle-off'}
                disabled={data.panel_open}
                selected={data.flush}
                content={data.flush ? 'Engaged' : 'Disengaged'}
                onClick={() => act(data.flush ? 'handle-0' : 'handle-1')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Ejection">
              <Button
                icon="sign-out-alt"
                content="Eject Contents"
                onClick={() => act('eject')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Power">
              <Button
                icon={data.is_on ? 'power-off' : 'times'}
                content={data.is_on ? 'On' : 'Off'}
                selected={data.is_on}
                onClick={() => act('power')}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};

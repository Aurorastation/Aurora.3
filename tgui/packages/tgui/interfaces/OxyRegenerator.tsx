import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

type OxyRegeneratorData = {
  on: BooleanLike;
  powerSetting: number;
  gasProcessed: number;
  air1Pressure: number;
  air2Pressure: number;
  tankPressure: number;
  targetPressure: number;
  phase: 'filling' | 'processing' | 'releasing';
  co2: number;
  o2: number;
};

export const OxyRegenerator = (props, context) => {
  const { act, data } = useBackend<OxyRegeneratorData>(context);

  return (
    <Window
      title="Oxygen Regeneration System"
      width={380}
      height={320}
      theme="hephaestus"
    >
      <Window.Content>
        <Section title="Controls">
          <LabeledList>
            <LabeledList.Item label="Status">
              <Button
                icon="power-off"
                content={data.on ? 'On' : 'Off'}
                selected={!!data.on}
                onClick={() => act('power')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Power Level">
              {[1, 2, 3, 4, 5].map((level) => (
                <Button
                  key={level}
                  content={String(level)}
                  selected={data.powerSetting === level}
                  onClick={() => act('set_power', { value: level })}
                />
              ))}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title={`Phase: ${data.phase}`}>
          <LabeledList>
            {data.phase === 'filling' && (
              <>
                <LabeledList.Item label="Input Pressure">
                  {data.air1Pressure} kPa
                </LabeledList.Item>
                <LabeledList.Item label="Tank Pressure">
                  {data.tankPressure} kPa
                </LabeledList.Item>
                <LabeledList.Item label="Target Tank Pressure">
                  {data.targetPressure} kPa
                </LabeledList.Item>
              </>
            )}
            {data.phase === 'processing' && (
              <>
                <LabeledList.Item label="Processing Rate">
                  {data.gasProcessed} mol
                </LabeledList.Item>
                <LabeledList.Item label="Tank Pressure">
                  {data.tankPressure} kPa
                </LabeledList.Item>
                <LabeledList.Item label="CO₂ Content">
                  {data.co2}%
                </LabeledList.Item>
                <LabeledList.Item label="O₂ Content">
                  {data.o2}%
                </LabeledList.Item>
              </>
            )}
            {data.phase === 'releasing' && (
              <>
                <LabeledList.Item label="Tank Pressure">
                  {data.tankPressure} kPa
                </LabeledList.Item>
                <LabeledList.Item label="Output Pressure">
                  {data.air2Pressure} kPa
                </LabeledList.Item>
                <LabeledList.Item label="Target Release Pressure">
                  {data.targetPressure} kPa
                </LabeledList.Item>
              </>
            )}
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};

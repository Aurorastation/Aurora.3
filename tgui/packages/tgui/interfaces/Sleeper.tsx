import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { BlockQuote, Button, Knob, LabeledList, ProgressBar, Section, Table } from '../components';
import { Window } from '../layouts';

export type SleeperData = {
  occupant: BooleanLike;
  stat: number;
  stasis: number;
  species: string;
  brain_activity: number;
  blood_pressure: number[];
  blood_pressure_level: number;
  blood_o2: number;
  bloodreagents: Reagent[];
  hasstomach: BooleanLike;
  stomachreagents: Reagent[];
  pulse: string;
  reagents: SleeperReagent[];
  stasissettings: number[];
  beaker: BooleanLike;
  beakerfreespace: number;
  filtering: BooleanLike;
  pump: BooleanLike;
};

type Reagent = {
  name: string;
  amount: number;
};

type SleeperReagent = {
  type: string;
  name: string;
};

export const Sleeper = (props, context) => {
  const { act, data } = useBackend<SleeperData>(context);

  return (
    <Window resizable theme="zenghu">
      <Window.Content scrollable>
        {data.occupant ? (
          <OccupantStatus />
        ) : (
          <Table>
            <BlockQuote>No occupant detected.</BlockQuote>
            <Button
              content={data.beaker ? 'Eject Beaker' : 'No Beaker'}
              icon="medkit"
              color="red"
              disabled={!data.beaker}
              onClick={() => act('beaker')}
            />
          </Table>
        )}
      </Window.Content>
    </Window>
  );
};

export const OccupantStatus = (props, context) => {
  const { act, data } = useBackend<SleeperData>(context);

  return (
    <Table>
      <Table.Row header>
        <Table.Cell>
          <Section
            fill:false
            title="Occupant Status"
            buttons={
              <Button
                content="Eject Occupant"
                color="bad"
                icon="person-booth"
                onClick={() => act('eject')}
              />
            }>
            <LabeledList>
              <LabeledList.Item
                label="Status"
                color={consciousnessLabel(data.stat)}>
                {consciousnessText(data.stat)}
              </LabeledList.Item>
              <LabeledList.Item label="Stasis Level">
                {data.stasis}x
              </LabeledList.Item>
              <LabeledList.Item label="Species">
                {data.species}
              </LabeledList.Item>
              <LabeledList.Item label="Brain Activity">
                <ProgressBar
                  ranges={{
                    good: [85, 100],
                    average: [40, 85],
                    bad: [0, 40],
                  }}
                  value={data.brain_activity}
                  minValue={0}
                  maxValue={100}>
                  {data.brain_activity}%
                </ProgressBar>
              </LabeledList.Item>
              <LabeledList.Item
                label="Pulse"
                color={progressClass(data.brain_activity)}>
                {data.pulse}
              </LabeledList.Item>
              <LabeledList.Item
                label="BP"
                color={getPressureClass(data.blood_pressure_level)}>
                {data.blood_pressure}
              </LabeledList.Item>
              <LabeledList.Item
                label="Blood Oxygenation"
                color={progressClass(data.blood_o2)}>
                {Math.round(data.blood_o2)}
              </LabeledList.Item>
            </LabeledList>
          </Section>
          <Section title="Bloodstream Reagents">
            {data.bloodreagents.length ? (
              <BloodReagents />
            ) : (
              'No detected reagents in the bloodstream.'
            )}
          </Section>
          <Section title="Stomach Reagents">
            {data.hasstomach ? (
              data.stomachreagents.length ? (
                <BloodReagents />
              ) : (
                'No detected reagents in the stomach.'
              )
            ) : (
              'No stomach detected.'
            )}
          </Section>
          <Section title="Injectable Reagents">
            <Table>
              {data.reagents.map((reagent) => (
                <Table.Row key={reagent.name}>
                  <Table.Cell>{reagent.name}</Table.Cell>
                  <Table.Cell>
                    <Button
                      content="Inject 5"
                      onClick={() =>
                        act('chemical', { chemical: reagent.type, amount: 5 })
                      }
                    />
                  </Table.Cell>
                  <Table.Cell>
                    <Button
                      content="Inject 10"
                      onClick={() =>
                        act('chemical', { chemical: reagent.type, amount: 10 })
                      }
                    />
                  </Table.Cell>
                </Table.Row>
              ))}
            </Table>
            <Section title="Stasis">
              <Knob
                size={1.25}
                value={data.stasis}
                unit="x"
                minValue={data.stasissettings[0]}
                maxValue={data.stasissettings[data.stasissettings.length - 1]}
                step={1}
                stepPixelSize={50}
                onDrag={(e, value) =>
                  act('stasis', {
                    stasis: value,
                  })
                }
              />
            </Section>
            <Section
              title="Dialysis"
              buttons={
                <Button
                  content={data.beaker ? 'Eject Beaker' : 'No Beaker'}
                  icon="medkit"
                  color="red"
                  disabled={!data.beaker}
                  onClick={() => act('beaker')}
                />
              }>
              <Button
                content="Blood Dialysis"
                color={data.filtering ? 'good' : ''}
                disabled={!data.beaker || data.beakerfreespace <= 0}
                icon="heart"
                onClick={() => act('filter')}
              />
              <Button
                content="Stomach Pump"
                color={data.pump ? 'good' : ''}
                disabled={!data.beaker || data.beakerfreespace <= 0}
                icon="splotch"
                onClick={() => act('pump')}
              />
              {data.beaker ? (
                <BlockQuote>
                  {Math.round(data.beakerfreespace)}u of free space remaining.
                </BlockQuote>
              ) : (
                <BlockQuote color="bad">No beaker inserted.</BlockQuote>
              )}
            </Section>
          </Section>
        </Table.Cell>
      </Table.Row>
    </Table>
  );
};

export const BloodReagents = (props, context) => {
  const { act, data } = useBackend<SleeperData>(context);

  return (
    <Table>
      {data.bloodreagents.map((reagent) => (
        <Table.Row key={reagent.name}>
          <Table.Cell>{reagent.name}</Table.Cell>
          <Table.Cell>{reagent.amount}u</Table.Cell>
        </Table.Row>
      ))}
    </Table>
  );
};

// is this shit copypaste? yeah i dont care, you try converting 75 UIs over 2 months
export const StomachReagents = (props, context) => {
  const { act, data } = useBackend<SleeperData>(context);

  return (
    <Table>
      {data.stomachreagents.map((reagent) => (
        <>
          <Table.Row key={reagent.name}>{reagent.name}</Table.Row>
          <Table.Row key={reagent.amount}>{reagent.amount}u</Table.Row>
        </>
      ))}
    </Table>
  );
};

const consciousnessLabel = (value) => {
  switch (value) {
    case 0:
      return 'green';
    case 1:
      return 'average';
    case 2:
      return 'bad';
  }
};
const consciousnessText = (value) => {
  switch (value) {
    case 0:
      return 'Conscious';
    case 1:
      return 'Unconscious';
    case 2:
      return 'DEAD';
  }
};

const progressClass = (value) => {
  if (value <= 50) {
    return 'bad';
  } else if (value <= 90) {
    return 'average';
  } else {
    return 'green';
  }
};

const getPressureClass = (tpressure) => {
  switch (tpressure) {
    case 1:
      return 'red';
    case 2:
      return 'green';
    case 3:
      return 'good';
    case 4:
      return 'red';
    default:
      return 'teal';
  }
};

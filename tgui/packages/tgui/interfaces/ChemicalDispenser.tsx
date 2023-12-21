import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { AnimatedNumber, Box, Button, Divider, LabeledControls, NumberInput, Section, Stack } from '../components';
import { Window } from '../layouts';

export type DispenserData = {
  manufacturer: string;
  amount: number;
  preset_dispense_amounts: number[];
  can_select_dispense_amount: BooleanLike;
  accept_drinking: BooleanLike;
  is_beaker_loaded: BooleanLike;
  beaker_max_volume: number;
  beaker_current_volume: number;
  beaker_contents: Reagent[];
  chemicals: Chemical[];
};

type Reagent = {
  name: string;
  volume: number;
};

type Chemical = {
  label: string;
  amount: number;
};

export const ChemicalDispenser = (props, context) => {
  const { act, data } = useBackend<DispenserData>(context);

  return (
    <Window resizable theme={data.manufacturer}>
      <Window.Content scrollable>
        <Section>
          <LabeledControls>
            {data.preset_dispense_amounts.map((number) => (
              <LabeledControls.Item key={number}>
                <Button
                  content={number}
                  icon="chevron-circle-down"
                  selected={data.amount === number}
                  onClick={() => act('amount', { amount: number })}
                />
              </LabeledControls.Item>
            ))}
          </LabeledControls>
          &nbsp;
          <Box textAlign="center">
            <NumberInput
              value={data.amount}
              minValue={0}
              maxValue={data.beaker_max_volume || 120}
              unit="u"
              step={5}
              stepPixelSize={15}
              onDrag={(e, value) => act('amount', { amount: value })}
            />
          </Box>
          <Divider />
          {data.chemicals ? <ChemTable /> : 'No chemicals detected.'}
        </Section>
        <Section
          title={
            'Container Display' +
            (data.is_beaker_loaded
              ? ' (' +
              data.beaker_current_volume +
              '/' +
              data.beaker_max_volume +
              'u)'
              : '')
          }
          buttons={
            data.is_beaker_loaded ? (
              <Button
                content="Eject"
                icon="times"
                onClick={() => act('ejectBeaker')}
              />
            ) : (
              ''
            )
          }>
          {!data.is_beaker_loaded ? 'No container loaded.' : <BeakerContents />}
        </Section>
      </Window.Content>
    </Window>
  );
};

export const ChemTable = (props, context) => {
  const { act, data } = useBackend<DispenserData>(context);

  return (
    <Box mr={-1}>
      {data.chemicals.map((chemical) => (
        <Button
          key={chemical.label}
          content={chemical.label + ' (' + chemical.amount + ')'}
          icon="tint"
          width="170px"
          lineHeight={1.75}
          onClick={() => act('dispense', { dispense: chemical.label })}
        />
      ))}
    </Box>
  );
};

export const BeakerContents = (props, context) => {
  const { act, data } = useBackend<DispenserData>(context);

  return (
    <Section>
      {data.beaker_contents.length ? (
        <Stack vertical>
          {data.beaker_contents.map((chemical) => (
            <Stack.Item key={chemical.name}>
              <Box>
                <Box as="span" color="label">
                  <AnimatedNumber value={chemical.volume} initial={0} />u
                </Box>{' '}
                of {chemical.name}
              </Box>
            </Stack.Item>
          ))}
        </Stack>
      ) : (
        'No liquid detected.'
      )}
    </Section>
  );
};

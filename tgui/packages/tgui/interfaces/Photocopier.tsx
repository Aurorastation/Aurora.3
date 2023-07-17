import { useBackend } from '../backend';
import { Section, ProgressBar, Box, NumberInput, Button, BlockQuote } from '../components';
import { Window } from '../layouts';

export type PhotocopierData = {
  toner: number;
  max_toner: number;
  max_copies: number;
  gotitem: boolean;
  is_silicon: boolean;
  num_copies: number;
};

export const Photocopier = (props, context) => {
  const { act, data } = useBackend<PhotocopierData>(context);
  // Extract `health` and `color` variables from the `data` object.
  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section title="Toner">
          {data.toner ? (
            <Toner />
          ) : (
            <BlockQuote>No toner cartridge inserted.</BlockQuote>
          )}
        </Section>
        <Section
          title="Printing"
          buttons={
            data.gotitem ? (
              <Button
                content="Remove"
                color="red"
                icon="times"
                onClick={() => act('remove')}
              />
            ) : (
              ''
            )
          }>
          {data.gotitem ? (
            <PrintOptions />
          ) : (
            <BlockQuote>No object to copy inserted.</BlockQuote>
          )}
        </Section>
        {data.is_silicon ? (
          <Section title="Artificial Intelligence Overrides">
            <Button content="Print Photo" onClick={(value) => act('aipic')} />
          </Section>
        ) : (
          ''
        )}
      </Window.Content>
    </Window>
  );
};

const PrintOptions = (props, context) => {
  const { act, data } = useBackend<PhotocopierData>(context);
  const { num_copies } = data;
  return (
    <Section>
      <Box>
        Copies to Print:
        <NumberInput
          animate
          width={2.6}
          height={1.65}
          step={1}
          stepPixelSize={8}
          minValue={1}
          maxValue={10}
          value={num_copies}
          onDrag={(e, value) =>
            act('set_copies', {
              num_copies: value,
            })
          }
        />
      </Box>
      <Button
        content="Print"
        icon="copy"
        disabled={!data.toner}
        onClick={(value) => act('copy')}
      />
    </Section>
  );
};

const Toner = (props, context) => {
  const { act, data } = useBackend<PhotocopierData>(context);
  const { toner, max_toner } = data;

  const average_toner = max_toner * 0.66;
  const bad_toner = max_toner * 0.33;

  return (
    <Section>
      <ProgressBar
        ranges={{
          good: [average_toner, max_toner],
          average: [bad_toner, average_toner],
          bad: [0, bad_toner],
        }}
        value={toner}
        minValue={0}
        maxValue={max_toner}
      />
    </Section>
  );
};

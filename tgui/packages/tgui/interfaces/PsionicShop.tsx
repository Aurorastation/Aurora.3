import { useBackend, useLocalState } from '../backend';
import { BlockQuote, Box, Button, Input, NoticeBox, Section } from '../components';
import { Window } from '../layouts';

export type PsiData = {
  psi_rank: string;
  psi_points: number;
  available_psionics: Psionic[];
  bought_powers: string[];
};

type Psionic = {
  name: string;
  desc: string;
  point_cost: number;
  minimum_rank: string;
  path: string;
};

export const PsionicShop = (props, context) => {
  const { act, data } = useBackend<PsiData>(context);

  const [searchTerm, setSearchTerm] = useLocalState<string>(
    context,
    `searchTerm`,
    ``
  );

  return (
    <Window resizable theme="wizard">
      <Window.Content scrollable>
        <Section
          title="Psionic Point Shop"
          buttons={
            <Input
              autoFocus
              autoSelect
              placeholder="Search by name"
              width="40vw"
              maxLength={512}
              onInput={(e, value) => {
                setSearchTerm(value);
              }}
              value={searchTerm}
            />
          }>
          <Box fontSize={1.4}>
            You are{' '}
            <Box as="span" bold>
              {data.psi_rank}
            </Box>
            .
          </Box>
          {data.available_psionics && data.available_psionics.length ? (
            <PsionicsList />
          ) : (
            <NoticeBox>There are no psionics available.</NoticeBox>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};

export const PsionicsList = (props, context) => {
  const { act, data } = useBackend<PsiData>(context);

  const [searchTerm, setSearchTerm] = useLocalState<string>(
    context,
    `searchTerm`,
    ``
  );

  return (
    <Section>
      {data.available_psionics
        .filter(
          (psi) => psi.name.toLowerCase().indexOf(searchTerm.toLowerCase()) > -1
        )
        .map((psi) => (
          <Section
            key={psi.name}
            title={psi.name + ' (' + psi.point_cost + ')'}
            buttons={
              <Button
                content="Buy"
                icon="shopping-cart"
                color="green"
                disabled={
                  psi.point_cost > data.psi_points ||
                  data.bought_powers.includes(psi.path)
                }
                onClick={() => act('buy', { buy: psi.path })}
              />
            }>
            <BlockQuote>{psi.desc}</BlockQuote>
          </Section>
        ))}
    </Section>
  );
};

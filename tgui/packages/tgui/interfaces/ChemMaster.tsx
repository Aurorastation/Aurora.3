import { useBackend } from '../backend';
import { Button, Section, Stack, Table, Flex } from '../components';
import { Window } from '../layouts';

export type DispenserData = {
  blood: Blood;
  reagents_in_beaker: Reagent[];
  reagents_in_internal_storage: Reagent[];
  mode: number;
  loaded_beaker: boolean;
  loaded_pill_bottle: boolean;
  // manufacturer: string;
  // amount: number;
  // preset_dispense_amounts: number[];
  // can_select_dispense_amount: BooleanLike;
  // accept_drinking: BooleanLike;
  // is_beaker_loaded: BooleanLike;
  // beaker_max_volume: number;
  // beaker_current_volume: number;
  // beaker_contents: Reagent[];
  // chemicals: Chemical[];
};

let modes = new Map<number, string>([
  [0, 'Disposals'],
  [1, 'Beaker'],
]);

type Reagent = {
  name: String;
  volume: number;
  typepath: String;
};

type Blood = {
  name: String;
  type: String;
  DNA: String;
};

type Chemical = {
  label: string;
  amount: number;
};

const ReagentFactory = (props, context) => {
  const { act, data } = useBackend<DispenserData>(context);
  const { reagents, quantities, clickOperation } = props;

  return (
    <Table>
      {reagents?.length
        ? reagents.map((reagent) => (
          <Table.Row key={reagent.name}>
            <Section title={reagent.name + ' (' + reagent.volume + ')'}>
              {quantities.map((quantity) => (
                <DispenseButton
                  key={quantity}
                  quantity={quantity}
                  reagent={reagent}
                  operation={clickOperation}
                />
              ))}
            </Section>
          </Table.Row>
        ))
        : 'Empty'}
    </Table>
  );
};

const DispenseButton = (props, context) => {
  const { act, data } = useBackend<DispenserData>(context);
  const { quantity, reagent, operation } = props;

  if (quantity === 'Custom') {
    return (
      <Button.Input
        key={quantity}
        content={quantity}
        onCommit={(e, value: string) => {
          act(operation, {
            [operation]: reagent.typepath,
            amount: parseFloat(value),
          });
        }}
        disabled={reagent.volume <= 0}
      />
    );
  } else {
    return (
      <Button
        key={quantity}
        content={quantity}
        disabled={reagent.volume < quantity}
        onClick={() => {
          act(operation, {
            [operation]: reagent.typepath,
            amount: quantity === 'All' ? 200 : quantity,
          });
        }}
      />
    );
  }
};

export const ChemMaster = (props, context) => {
  const { act, data } = useBackend<DispenserData>(context);
  let dispensable_quantities = [1, 2, 5, 10, 15, 20, 30, 60, 'Custom', 'All'];

  return (
    <Window title="ChemMaster 9000">
      <Window.Content scrollable>
        <Section
          title="ChemMaster 9000"
          buttons={
            <Stack fill>
              <Stack.Item>
                <Button
                  content="Eject beaker"
                  disabled={!data.loaded_beaker}
                  onClick={() => act('eject')}
                />
              </Stack.Item>
              <Stack.Item>
                <Button
                  content="Eject pill bottle"
                  disabled={!data.loaded_pill_bottle}
                  onClick={() => act('ejectp')}
                />
              </Stack.Item>
            </Stack>
          }>
          <Table nowrap>
            <Table.Row>
              <Section title="Beaker content">
                <Flex>
                  <Flex.Item>
                    <ReagentFactory
                      reagents={data.reagents_in_beaker}
                      quantities={dispensable_quantities}
                      clickOperation="add"
                    />
                  </Flex.Item>
                </Flex>
              </Section>
            </Table.Row>
          </Table>
        </Section>
        <Section title="ChemMaster Content">
          <Stack vertical>
            <Stack.Item>
              <Flex fill>
                <Flex.Item>
                  <ReagentFactory
                    reagents={data.reagents_in_internal_storage}
                    quantities={dispensable_quantities}
                    clickOperation="remove"
                  />
                </Flex.Item>
              </Flex>
            </Stack.Item>
            <Stack.Item pt="10px">
              <Flex>
                <Flex.Item direction="column">
                  <Section title="Controls">
                    <Button
                      content="Create Bottle"
                      onClick={() => act('createbottle', {})}
                      disabled={!data.reagents_in_internal_storage.length}
                    />
                    <Button
                      content="Create Pill"
                      onClick={() => act('createpill', {})}
                      disabled={!data.reagents_in_internal_storage.length}
                    />
                    <Button
                      content="Create Multiple Pill"
                      onClick={() => act('createpill_multiple', {})}
                      disabled={!data.reagents_in_internal_storage.length}
                    />
                  </Section>
                </Flex.Item>
              </Flex>
            </Stack.Item>
            <Stack.Item>
              {'Transfer to: '}
              <Button
                content={modes.get(data.mode)}
                onClick={() => {
                  act('toggle', {});
                }}
              />
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};

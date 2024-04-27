import { useBackend } from '../backend';
import { Button, Section, Stack, Table, Flex, Box, Collapsible, LabeledList, Divider } from '../components';
import { Window } from '../layouts';

export type DispenserData = {
  machine_name: string;
  reagents_in_beaker: Reagent[];
  reagents_in_internal_storage: Reagent[];
  mode: number;
  loaded_beaker: boolean;
  loaded_pill_bottle: boolean;
  bottle_icons: string[];
  pill_icons: string[];
  current_bottle_icon: string;
  current_pill_icon: string;
  analysis: Blood;
  is_condimaster: boolean;
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

const ReagentFactory = (props, context) => {
  const { act, data } = useBackend<DispenserData>(context);
  const { reagents, quantities, clickOperation } = props;

  return (
    <Table>
      {reagents?.length
        ? reagents.map((reagent) => (
          <Table.Row key={reagent.name}>
            <Section
              title={reagent.name + ' (' + reagent.volume + ')'}
              buttons={
                reagent.name === 'Blood' && clickOperation === 'add' ? (
                  <Button
                    content="Analyze"
                    onClick={() => act('analyze', { name: 'Blood' })}
                  />
                ) : null
              }
              mt="-3px">
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
    <Window
      title={data.machine_name}
      theme={data.is_condimaster ? 'idris' : 'zenghu'}>
      <Window.Content scrollable fitted fontSize={0.95}>
        <Section
          title={data.machine_name}
          buttons={
            <Stack fill>
              <Stack.Item>
                <Button
                  content="Eject beaker"
                  disabled={!data.loaded_beaker}
                  onClick={() => act('eject')}
                />
              </Stack.Item>
              {!data.is_condimaster ? (
                <Stack.Item>
                  <Button
                    content="Eject pill bottle"
                    disabled={!data.loaded_pill_bottle}
                    onClick={() => act('ejectp')}
                  />
                </Stack.Item>
              ) : null}
            </Stack>
          }>
          <Table nowrap>
            <Table.Row>
              <Section title="Beaker content">
                <Flex direction="column">
                  {data.analysis?.name ? (
                    <Flex.Item mb="30px">
                      <LabeledList>
                        <LabeledList.Item
                          label="Name"
                          buttons={
                            <Button
                              content="Close"
                              onClick={() => act('analyze', { name: 'Close' })}
                            />
                          }>
                          {data.analysis.name}
                        </LabeledList.Item>
                        <LabeledList.Item label="Type">
                          {data.analysis.type}
                        </LabeledList.Item>
                        <LabeledList.Item label="DNA">
                          {data.analysis.DNA}
                        </LabeledList.Item>
                      </LabeledList>
                    </Flex.Item>
                  ) : null}
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
        <Divider />
        <Section title={data.machine_name.split(' ')[0] + ' Content'}>
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
                    {!data.is_condimaster ? (
                      <Button
                        content="Create Pill"
                        onClick={() => act('createpill', {})}
                        disabled={!data.reagents_in_internal_storage.length}
                      />
                    ) : null}
                    {!data.is_condimaster ? (
                      <Button
                        content="Create Multiple Pills"
                        onClick={() => act('createpill_multiple', {})}
                        disabled={!data.reagents_in_internal_storage.length}
                      />
                    ) : null}
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
        <Divider />
        <Section title="Preferences">
          <Collapsible title="Bottle type">
            <Flex pt="10px" wrap="wrap" align="center">
              {data.bottle_icons.map((icon) => (
                <Flex.Item
                  key={icon}
                  m="4px"
                  mt="10px"
                  style={
                    icon.split(' ')[1] === data.current_bottle_icon
                      ? {
                        border: '6px solid red',
                        'border-top': '10px solid red',
                      }
                      : ''
                  }>
                  <Button
                    tooltip={icon.split(' ')[1]}
                    onClick={() =>
                      act('bottle_sprite', {
                        bottle_sprite: icon.split(' ')[1],
                      })
                    }>
                    <Box
                      as="img"
                      key={icon}
                      className={icon}
                      style={{
                        '-ms-interpolation-mode': 'bicubic',
                        transform: 'scale(1.5)',
                      }}
                    />
                  </Button>
                </Flex.Item>
              ))}
            </Flex>
          </Collapsible>
          {!data.is_condimaster ? (
            <Collapsible title="Pill type">
              <Flex pt="10px" wrap="wrap">
                {data.pill_icons.map((icon) => (
                  <Flex.Item
                    key={icon}
                    m="4px"
                    mt="10px"
                    style={
                      icon.split(' ')[1] === data.current_pill_icon
                        ? {
                          border: '6px solid red',
                          'border-top': '10px solid red',
                        }
                        : ''
                    }>
                    <Button
                      tooltip={icon.split(' ')[1]}
                      onClick={() =>
                        act('pill_sprite', {
                          pill_sprite: icon.split(' ')[1],
                        })
                      }>
                      <Box
                        as="img"
                        key={icon}
                        className={icon}
                        style={{
                          '-ms-interpolation-mode': 'bicubic',
                          transform: 'scale(1.5)',
                        }}
                      />
                    </Button>
                  </Flex.Item>
                ))}
              </Flex>
            </Collapsible>
          ) : null}
        </Section>
      </Window.Content>
    </Window>
  );
};

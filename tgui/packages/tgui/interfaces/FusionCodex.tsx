import { Box, Flex, Input, LabeledList, Section } from 'tgui-core/components';
import { useBackend, useLocalState } from '../backend';
import { NtosWindow } from '../layouts';

export type CodexData = {
  reactions: Reaction[];
};

type Reaction = {
  name: string;
  reactants: Reactant[];
  products: Product[];
  minimum_temp: number;
  energy_consumption: number;
  energy_production: number;
  radiation: number;
  instability: number;
};

type Reactant = {
  name: string;
  amount: number;
};

type Product = {
  name: string;
  amount: number;
};

export const FusionCodex = (props, context) => {
  const { act, data } = useBackend<CodexData>();
  const [searchTerm, setSearchTerm] = useLocalState<string>(`searchTerm`, ``);

  return (
    <NtosWindow resizable>
      <NtosWindow.Content scrollable>
        <Section
          title="Codex Search"
          fitted
          buttons={
            <Input
              autoFocus
              autoSelect
              placeholder="Search by name"
              width="40vw"
              maxLength={512}
              onChange={(value) => {
                setSearchTerm(value);
              }}
              value={searchTerm}
            />
          }
        >
          <Box m={2}>
            <Section>
              {data.reactions
                .filter(
                  (reaction) =>
                    reaction.name
                      .toLowerCase()
                      .indexOf(searchTerm.toLowerCase()) > -1,
                )
                .map((reaction) => (
                  <Section title={reaction.name} key={reaction.name}>
                    <Box m={1}>
                      <Flex>
                        <Flex.Item grow={1}>
                          <Section title="Reactants">
                            <LabeledList>
                              {reaction.reactants.map((Reactant) => (
                                <LabeledList.Item
                                  label={Reactant.name}
                                  key={Reactant.name}
                                >
                                  {Reactant.amount ? Reactant.amount : 'None'}
                                </LabeledList.Item>
                              ))}
                            </LabeledList>
                          </Section>
                        </Flex.Item>
                        <Flex.Item grow={1}>
                          <Section title="Products">
                            <LabeledList>
                              {reaction.products.map((Product) => (
                                <LabeledList.Item
                                  label={Product.name}
                                  key={Product.name}
                                >
                                  {Product.amount}
                                </LabeledList.Item>
                              ))}
                            </LabeledList>
                          </Section>
                        </Flex.Item>
                      </Flex>
                      <Section title="Properties">
                        <LabeledList>
                          <LabeledList.Item
                            label="Minimum Temperature"
                            color="orange"
                          >
                            {reaction.minimum_temp} K
                          </LabeledList.Item>
                          <LabeledList.Divider size={1} />
                          <LabeledList.Item
                            label="Relative Energy Production/Consumption"
                            color="yellow"
                          >
                            {reaction.energy_production} {' / '}
                            {reaction.energy_consumption}
                          </LabeledList.Item>
                          <LabeledList.Divider size={1} />
                          <LabeledList.Item
                            label="Radiation Coefficient"
                            color="green"
                          >
                            {reaction.radiation ? reaction.radiation : 'None'}
                          </LabeledList.Item>
                          <LabeledList.Divider size={1} />
                          <LabeledList.Item
                            label="Instability Coefficient"
                            color="red"
                          >
                            {reaction.instability
                              ? reaction.instability
                              : 'None'}
                          </LabeledList.Item>
                          <LabeledList.Divider size={1} />
                        </LabeledList>
                      </Section>
                    </Box>
                  </Section>
                ))}
            </Section>
          </Box>
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};

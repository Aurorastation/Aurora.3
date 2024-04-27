import { useBackend, useLocalState } from '../backend';
import { Input, LabeledList, NoticeBox, Section } from '../components';
import { NtosWindow } from '../layouts';

export type CodexData = {
  reactions: Reaction[];
};

type Reaction = {
  result: Result;
  reagents: Reagent[];
  catalysts: Reagent[];
  inhibitors: Reagent[];
  temp_min: number;
  temp_max: number;
};

type Result = {
  name: string;
  description: string;
  amount: number;
};

type Reagent = {
  name: string;
  amount: number;
};

export const ChemCodex = (props, context) => {
  const { act, data } = useBackend<CodexData>(context);
  const [searchTerm, setSearchTerm] = useLocalState<string>(
    context,
    `searchTerm`,
    ``
  );

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
              onInput={(e, value) => {
                setSearchTerm(value);
              }}
              value={searchTerm}
            />
          }
        />
        {data.reactions
          .filter(
            (reaction) =>
              reaction.result.name
                .toLowerCase()
                .indexOf(searchTerm.toLowerCase()) > -1
          )
          .map((reaction) => (
            <Section
              title={reaction.result.name + '(' + reaction.result.amount + 'u)'}
              key={reaction.result.name}>
              <NoticeBox>{reaction.result.description}</NoticeBox>
              <Section title="Required Reagents">
                <LabeledList>
                  {reaction.reagents.map((reagent) => (
                    <LabeledList.Item label={reagent.name} key={reagent.name}>
                      {reagent.amount}u
                    </LabeledList.Item>
                  ))}
                </LabeledList>
                <Section title="Catalysts">
                  <LabeledList>
                    {reaction.catalysts.length
                      ? reaction.catalysts.map((catalyst) => (
                        <LabeledList.Item
                          label={catalyst.name}
                          key={catalyst.name}>
                          {catalyst.amount}u
                        </LabeledList.Item>
                      ))
                      : 'No catalysts present for this recipe.'}
                  </LabeledList>
                </Section>
                <Section title="Inhibitors">
                  <LabeledList>
                    {reaction.inhibitors.length
                      ? reaction.inhibitors.map((inhibitor) => (
                        <LabeledList.Item
                          label={inhibitor.name}
                          key={inhibitor.name}>
                          {inhibitor.amount}u
                        </LabeledList.Item>
                      ))
                      : 'No inhibitors present for this recipe.'}
                  </LabeledList>
                </Section>
                <Section title="Other">
                  <LabeledList>
                    <LabeledList.Item label="Minimum Required Temperature">
                      {reaction.temp_min ? reaction.temp_min : 'None.'}
                    </LabeledList.Item>
                    <LabeledList.Item label="Maximum Required Temperature">
                      {reaction.temp_max ? reaction.temp_max : 'None.'}
                    </LabeledList.Item>
                  </LabeledList>
                </Section>
              </Section>
            </Section>
          ))}
      </NtosWindow.Content>
    </NtosWindow>
  );
};

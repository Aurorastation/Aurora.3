import { LabeledList, Section } from 'tgui-core/components';
import { useBackend, useLocalState } from '../backend';
import { NtosWindow } from '../layouts';
import { SearchBar } from './common/SearchBar';

export type CodexData = {
  reactions: Reaction[];
};

type Reaction = {
  id: string;
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

export const ChemCodex = (props) => {
  const { act, data } = useBackend<CodexData>();
  const [searchTerm, setSearchTerm] = useLocalState<string>(`searchTerm`, ``);

  return (
    <NtosWindow resizable>
      <NtosWindow.Content scrollable>
        <Section
          title="Codex Search"
          fitted
          buttons={
            <SearchBar
              autoFocus
              placeholder="Search"
              query={searchTerm}
              onSearch={(value) => {
                setSearchTerm(value);
              }}
              style={{ width: '40vw' }}
            />
          }
        />
        {data.reactions
          .filter(
            (reaction) =>
              reaction.result.name
                .toLowerCase()
                .indexOf(searchTerm.toLowerCase()) > -1,
          )
          .map((reaction) => (
            <Section
              title={`${reaction.result.name}(${reaction.result.amount}u)`}
              key={reaction.id}
            >
              <Section>{reaction.result.description}</Section>
              <Section title="Required Reagents">
                <LabeledList>
                  {reaction.reagents.map((reagent) => (
                    <LabeledList.Item label={reagent.name} key={reagent.name}>
                      {reagent.amount}u
                    </LabeledList.Item>
                  ))}
                </LabeledList>
                {reaction.catalysts.length ? (
                  <Section title="Catalysts">
                    <LabeledList>
                      {reaction.catalysts.map((catalyst) => (
                        <LabeledList.Item
                          label={catalyst.name}
                          key={catalyst.name}
                        >
                          {catalyst.amount}u
                        </LabeledList.Item>
                      ))}
                    </LabeledList>
                  </Section>
                ) : null}
                {reaction.inhibitors.length ? (
                  <Section title="Inhibitors">
                    <LabeledList>
                      {reaction.inhibitors.map((inhibitor) => (
                        <LabeledList.Item
                          label={inhibitor.name}
                          key={inhibitor.name}
                        >
                          {inhibitor.amount}u
                        </LabeledList.Item>
                      ))}
                    </LabeledList>
                  </Section>
                ) : null}
                {reaction.temp_min || reaction.temp_max ? (
                  <Section title="Temperature">
                    <LabeledList>
                      <LabeledList.Item label="Minimum">
                        {reaction.temp_min ? `${reaction.temp_min}K` : 'N/A'}
                      </LabeledList.Item>
                      <LabeledList.Item label="Maximum">
                        {reaction.temp_max ? `${reaction.temp_max}K` : 'N/A'}
                      </LabeledList.Item>
                    </LabeledList>
                  </Section>
                ) : null}
              </Section>
            </Section>
          ))}
      </NtosWindow.Content>
    </NtosWindow>
  );
};

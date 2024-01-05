import { useBackend, useLocalState } from '../backend';
import { Input, LabeledList, NoticeBox, Section } from '../components';
import { NtosWindow } from '../layouts';

export type CodexData = {
  // reactions: Reaction[];
};

// type Reaction = {
//   result: Result;
//   reagents: Reagent[];
//   catalysts: Reagent[];
//   inhibitors: Reagent[];
//   temp_min: number;
//   temp_max: number;
// };

// type Result = {
//   name: string;
//   description: string;
//   amount: number;
// };

// type Reagent = {
//   name: string;
//   amount: number;
// };

export const CookingCodex = (props, context) => {
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
      </NtosWindow.Content>
    </NtosWindow>
  );
};

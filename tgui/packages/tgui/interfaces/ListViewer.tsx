import { useBackend } from '../backend';
import { Box, LabeledList, Section } from '../components';
import { Window } from '../layouts';

export type ListData = {
  listvar: List[];
};

type List = {
  key: any;
  value: any;
};

export const ListViewer = (props, context) => {
  const { act, data } = useBackend<ListData>(context);

  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section title="List">
          <LabeledList>
            {data.listvar.map((list) => (
              <Box key={list.key}>
                <LabeledList.Item label={list.key}>
                  {list.value}
                </LabeledList.Item>
              </Box>
            ))}
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};

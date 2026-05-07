import { useBackend, useLocalState } from '../backend';
import { Box, Button, Section, Stack } from '../components';
import { Window } from '../layouts';

type LoreEntry = {
  title?: string;
  body: string;
};

type LoreConsoleData = {
  entries: LoreEntry[];
};

export const LoreConsole = (props, context) => {
  const { data } = useBackend<LoreConsoleData>(context);
  const { entries } = data;
  const [currentPage, setCurrentPage] = useLocalState(
    context,
    'currentPage',
    0,
  );
  const entry = entries[currentPage];

  return (
    <Window width={700} height={700} theme="amberpos">
      <Stack fill vertical>
        {entries.length > 1 && (
          <Stack.Item>
            <Section
              fill
              title={`Page ${currentPage + 1}/${entries.length}`}
              textAlign="center"
            >
              <Stack>
                <Stack.Item grow basis={0}>
                  <Button
                    fluid
                    content="Previous"
                    fontSize="150%"
                    icon="arrow-left"
                    lineHeight={2}
                    disabled={currentPage <= 0}
                    onClick={() => setCurrentPage(currentPage - 1)}
                  />
                </Stack.Item>
                <Stack.Item grow basis={0}>
                  <Button
                    fluid
                    content="Next"
                    fontSize="150%"
                    icon="arrow-right"
                    lineHeight={2}
                    disabled={currentPage >= entries.length - 1}
                    onClick={() => setCurrentPage(currentPage + 1)}
                  />
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
        )}
        <Stack.Item>
          <h1>{entry.title && entry.title}</h1>
          <Box
            className="LoreConsole__entryText"
            dangerouslySetInnerHTML={{ __html: entry.body }}
          />
        </Stack.Item>
      </Stack>
    </Window>
  );
};

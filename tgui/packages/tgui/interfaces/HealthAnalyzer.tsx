import { useBackend } from '../backend';
import { Box, Button, Section, Stack } from '../components';
import { Window } from '../layouts';

type HealthAnalyzerData = {
  scan_title?: string;
  scan_results: string[];
  reagent_results: string[];
  mode: boolean;
};

export const HealthAnalyzer = (props, context) => {
  const { act, data } = useBackend<HealthAnalyzerData>(context);
  const { scan_title, scan_results, reagent_results, mode } = data;

  return (
    <Window width={520} height={620} theme="zenghu">
      <Window.Content scrollable>
        <Section
          title={scan_title || 'Health Analyzer'}
          buttons={
            <Button icon={'fa-notes-medical'} onClick={() => act('clear_list')}>
              Clear scan
            </Button>
          }
        >
          {!scan_results?.length ? (
            <Box color="label">No scan data.</Box>
          ) : (
            <Stack vertical>
              {scan_results.map((line, i) => (
                <Stack.Item key={i}>
                  <Box
                    className="HealthAnalyzer__line"
                    dangerouslySetInnerHTML={{ __html: line }}
                  />
                </Stack.Item>
              ))}
            </Stack>
          )}
        </Section>

        <Section title="Reagent Scan">
          {!reagent_results?.length ? (
            <Box color="label">No results.</Box>
          ) : (
            <Stack vertical>
              {reagent_results.map((line, i) => (
                <Stack.Item key={i}>
                  <Box
                    className="HealthAnalyzer__line"
                    dangerouslySetInnerHTML={{ __html: line }}
                  />
                </Stack.Item>
              ))}
            </Stack>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};

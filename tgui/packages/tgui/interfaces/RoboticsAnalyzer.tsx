import { Box, Button, LabeledList, Section, Stack } from 'tgui-core/components';
import { useBackend } from '../backend';
import { Window } from '../layouts';

type AnalyzerResult = {
  label: string;
  value: string;
};

type RoboticsAnalyzerData = {
  scan_title?: string;
  status_results: string[];
  external_results: AnalyzerResult[];
  internal_results: AnalyzerResult[];
  tesla_results: AnalyzerResult[];
};

const ResultLines = (props: { results: string[] }) => {
  const { results } = props;

  if (!results?.length) {
    return <Box color="label">No scan data.</Box>;
  }

  return (
    <Stack vertical>
      {results.map((line, index) => (
        <Stack.Item key={index}>
          <Box
            /* biome-ignore lint/security/noDangerouslySetInnerHtml: Is sanitized by DOMPurify. */
            dangerouslySetInnerHTML={{ __html: line }}
          />
        </Stack.Item>
      ))}
    </Stack>
  );
};

const ResultList = (props: { results: AnalyzerResult[] }) => {
  const { results } = props;

  if (!results?.length) {
    return <Box color="label">No scan data.</Box>;
  }

  return (
    <LabeledList>
      {results.map((result, index) => (
        <LabeledList.Item
          key={index}
          label={
            <Box
              bold
              /* biome-ignore lint/security/noDangerouslySetInnerHtml: Is sanitized by DOMPurify. */
              dangerouslySetInnerHTML={{ __html: result.label }}
            />
          }
        >
          <Box
            /* biome-ignore lint/security/noDangerouslySetInnerHtml: Is sanitized by DOMPurify. */
            dangerouslySetInnerHTML={{ __html: result.value }}
          />
        </LabeledList.Item>
      ))}
    </LabeledList>
  );
};

export const RoboticsAnalyzer = (props) => {
  const { act, data } = useBackend<RoboticsAnalyzerData>();
  const {
    scan_title,
    status_results,
    external_results,
    internal_results,
    tesla_results,
  } = data;

  return (
    <Window theme="zenghu">
      <Window.Content scrollable>
        <Section
          title={scan_title || 'Robotics Analyzer'}
          buttons={
            <Button icon="eraser" onClick={() => act('clear_list')}>
              Clear scan
            </Button>
          }
        >
          <ResultLines results={status_results} />
        </Section>
        <Section title="External Components">
          <ResultList results={external_results} />
        </Section>
        {!!internal_results?.length && (
          <Section title="Internal Prosthetics">
            <ResultList results={internal_results} />
          </Section>
        )}
        {!!tesla_results?.length && (
          <Section title="Tesla Systems">
            <ResultList results={tesla_results} />
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};

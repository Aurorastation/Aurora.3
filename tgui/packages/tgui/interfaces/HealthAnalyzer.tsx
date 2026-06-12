import { Box, Button, LabeledList, Section, Stack } from 'tgui-core/components';
import { useBackend } from '../backend';
import { Window } from '../layouts';

type HealthAnalyzerData = {
  scan_title?: string;
  status_results: string[];
  trauma_results: string[];
  limb_results: Array<LimbResult | string>;
  internal_results: string[];
  reagent_results: string[];
};

type LimbResult = {
  label: string;
  value: string;
};

export const HealthAnalyzer = (props) => {
  const { act, data } = useBackend<HealthAnalyzerData>();
  const {
    scan_title,
    status_results,
    trauma_results,
    limb_results,
    internal_results,
    reagent_results,
  } = data;

  return (
    <Window theme="zenghu">
      <Window.Content scrollable>
        {/* Basic info, brain damage and such */}
        <Section
          title={scan_title || 'Health Analyzer'}
          buttons={
            <Button icon={'fa-notes-medical'} onClick={() => act('clear_list')}>
              Clear scan
            </Button>
          }
        >
          {!status_results?.length ? (
            <Box color="label">No scan data.</Box>
          ) : (
            <Stack vertical>
              {status_results.map((line, i) => (
                <Stack.Item key={i}>
                  <Box
                    className="HealthAnalyzer__line"
                    /* biome-ignore lint/security/noDangerouslySetInnerHtml: Is sanitized by DOMPurify. */
                    dangerouslySetInnerHTML={{ __html: line }}
                  />
                </Stack.Item>
              ))}
            </Stack>
          )}
        </Section>
        {/* Anatomy related injuries.  Limb injuries, major trauma, so on*/}
        <Section title="Anatomical Scan">
          {!trauma_results?.length &&
          !limb_results?.length &&
          !internal_results?.length ? (
            <Box color="label">No scan data.</Box>
          ) : (
            <Stack vertical>
              {!!trauma_results?.length && (
                <Stack.Item>
                  <Stack vertical>
                    {trauma_results.map((line, i) => (
                      <Stack.Item key={i}>
                        <Box
                          className="HealthAnalyzer__line"
                          /* biome-ignore lint/security/noDangerouslySetInnerHtml: Is sanitized by DOMPurify. */
                          dangerouslySetInnerHTML={{ __html: line }}
                        />
                      </Stack.Item>
                    ))}
                  </Stack>
                </Stack.Item>
              )}

              {!!limb_results?.length && (
                <Stack.Item>
                  <Box className="HealthAnalyzer__limb_List">
                    <LabeledList>
                      {limb_results.map((entry, i) =>
                        typeof entry === 'string' ? (
                          <LabeledList.Item key={i}>
                            <Box
                              className="HealthAnalyzer__line"
                              /* biome-ignore lint/security/noDangerouslySetInnerHtml: Is sanitized by DOMPurify. */
                              dangerouslySetInnerHTML={{ __html: entry }}
                            />
                          </LabeledList.Item>
                        ) : (
                          <LabeledList.Item
                            key={i}
                            className="HealthAnalyzer__limb_List_Item"
                            label={
                              <Box
                                bold
                                /* biome-ignore lint/security/noDangerouslySetInnerHtml: Is sanitized by DOMPurify. */
                                dangerouslySetInnerHTML={{
                                  __html: entry.label,
                                }}
                              />
                            }
                          >
                            <Box
                              className="HealthAnalyzer__line"
                              /* biome-ignore lint/security/noDangerouslySetInnerHtml: Is sanitized by DOMPurify. */
                              dangerouslySetInnerHTML={{
                                __html: entry.value,
                              }}
                            />
                          </LabeledList.Item>
                        ),
                      )}
                    </LabeledList>
                  </Box>
                </Stack.Item>
              )}

              {!!internal_results?.length && (
                <Stack.Item>
                  <Stack vertical>
                    {internal_results.map((line, i) => (
                      <Stack.Item key={i}>
                        <Box
                          className="HealthAnalyzer__line"
                          /* biome-ignore lint/security/noDangerouslySetInnerHtml: Is sanitized by DOMPurify. */
                          dangerouslySetInnerHTML={{ __html: line }}
                        />
                      </Stack.Item>
                    ))}
                  </Stack>
                </Stack.Item>
              )}
            </Stack>
          )}
        </Section>
        {/* Reagents. Things in stomach and blood */}
        <Section title="Reagent Scan">
          {!reagent_results?.length ? (
            <Box color="label">No scan data.</Box>
          ) : (
            <Stack vertical>
              {reagent_results.map((line, i) => (
                <Stack.Item key={i}>
                  <Box
                    className="HealthAnalyzer__line"
                    /* biome-ignore lint/security/noDangerouslySetInnerHtml: Is sanitized by DOMPurify. */
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

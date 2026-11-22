import {
  BlockQuote,
  Box,
  Button,
  Flex,
  LabeledList,
  Section,
  Tabs,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { useBackend, useLocalState } from '../backend';
import { Window } from '../layouts';
import {
  InvalidWindow as ScannerInvalidWindow,
  ScannerWindow,
  type ScannerData,
} from './BodyScanner';
import {
  getStandardSeverity,
  MedicalSummary,
  standardizeSeverityLabel,
} from './common/MedicalSummary';

type SurgeryZone = {
  id: string;
  label: string;
  known: BooleanLike;
  present: BooleanLike;
  robotic: BooleanLike;
  prosthetic_internal?: BooleanLike;
  scan_severity: number;
  scan_findings: string[];
};

type SurgeryTool = {
  name: string | null;
  path: string | null;
  suitability: number;
  success_chance: number;
};

type SurgeryProcedure = {
  id: string;
  name: string;
  category: string;
  estimated_time: number;
  skills: string[];
  tools: SurgeryTool[];
  tool_note: string;
};

export type SurgeryPlannerData = ScannerData & {
  has_table: BooleanLike;
  has_patient: BooleanLike;
  patient_is_ipc: BooleanLike;
  patient_name: string | null;
  patient_species: string | null;
  selected_zone: string;
  selected_zone_name: string;
  area_state: string;
  area_open_state: string;
  selected_zone_robotic: BooleanLike;
  scan_primer_loaded: BooleanLike;
  scan_primer_matches: BooleanLike;
  scan_primer_subject: string | null;
  scan_primer_time: string | null;
  zones: SurgeryZone[];
  procedures: SurgeryProcedure[];
  planner_locked_zone?: string | null;
  planner_robotic_only?: BooleanLike;
  planner_available_zones?: string[] | null;
  integrity?: number;
  temp?: number;
  charge_percent?: number;
  power_core_integrity?: number;
  armor_data?: Array<{ key: string; status: string }>;
  endoskeleton_damage?: number;
  endoskeleton_max_damage?: number;
  selected_prosthetic_organs?: string[];
};

type DollZone = {
  id: string;
  top: number;
  left: number;
  width: number;
  height: number;
  clipPath?: string;
  borderRadius?: string;
  zIndex?: number;
};

type SuitabilityPalette = {
  border: string;
  background: string;
  text: string;
};

const humanizeToolPath = (path: string | null) => {
  if (!path) {
    return 'Unknown tool';
  }

  const parts = path.split('/').filter(Boolean);
  const leaf = parts[parts.length - 1] || path;
  const parent = parts[parts.length - 2] || '';

  if (leaf === 'external' && parent === 'organ') {
    return 'compatible organic limb';
  }

  if (leaf === 'robot_parts') {
    return 'compatible prosthetic limb';
  }

  if (parent === 'scalpel') {
    return `${leaf.replace(/_/g, ' ')} scalpel`;
  }

  return leaf.replace(/_/g, ' ');
};

const getToolDisplayName = (tool: SurgeryTool) =>
  tool.name || humanizeToolPath(tool.path);

const getSuitabilityPalette = (chance: number): SuitabilityPalette => {
  if (chance >= 90) {
    return {
      border: '#53b66d',
      background: 'rgba(83, 182, 109, 0.14)',
      text: '#b9f2c7',
    };
  }

  if (chance >= 70) {
    return {
      border: '#d9c84d',
      background: 'rgba(217, 200, 77, 0.14)',
      text: '#f3e88f',
    };
  }

  if (chance >= 40) {
    return {
      border: '#d98a3d',
      background: 'rgba(217, 138, 61, 0.14)',
      text: '#f0bc82',
    };
  }

  return {
    border: '#c95757',
    background: 'rgba(201, 87, 87, 0.14)',
    text: '#f0a1a1',
  };
};

const getScanSeverityColor = (severity: number) => {
  if (severity >= 4) {
    return '#d34e4e';
  }

  if (severity === 3) {
    return '#dd7840';
  }

  if (severity === 2) {
    return '#d8b94b';
  }

  return '#e3d887';
};

const getScanSeverityLabel = (severity: number) => {
  if (severity >= 4) {
    return 'Critical';
  }
  if (severity === 3) {
    return 'Severe';
  }
  if (severity === 2) {
    return 'Moderate';
  }
  return 'Minor';
};

const getScanSeveritySymbol = (severity: number) => {
  if (severity >= 4) {
    return '×';
  }
  if (severity === 3) {
    return '!!';
  }
  if (severity === 2) {
    return '!';
  }
  return 'i';
};

const dollZones: DollZone[] = [
  {
    id: 'head',
    top: 1,
    left: 35,
    width: 30,
    height: 25,
    borderRadius: '44% 44% 38% 38%',
  },
  {
    id: 'eyes',
    top: 9,
    left: 42,
    width: 16,
    height: 5,
    borderRadius: '45%',
    zIndex: 4,
  },
  {
    id: 'mouth',
    top: 18,
    left: 44,
    width: 12,
    height: 5,
    borderRadius: '45%',
    zIndex: 4,
  },
  {
    id: 'chest',
    top: 28,
    left: 35,
    width: 30,
    height: 28,
    clipPath:
      'polygon(12% 0, 88% 0, 100% 88%, 78% 100%, 22% 100%, 0 88%)',
  },
  {
    id: 'groin',
    top: 57,
    left: 38,
    width: 24,
    height: 11,
    clipPath: 'polygon(0 0, 100% 0, 80% 100%, 20% 100%)',
  },
  {
    id: 'r_arm',
    top: 29,
    left: 22,
    width: 12,
    height: 27,
    clipPath: 'polygon(28% 0, 100% 5%, 80% 100%, 0 96%)',
  },
  {
    id: 'l_arm',
    top: 29,
    left: 66,
    width: 12,
    height: 27,
    clipPath: 'polygon(0 5%, 72% 0, 100% 96%, 20% 100%)',
  },
  {
    id: 'r_hand',
    top: 57,
    left: 18,
    width: 14,
    height: 11,
    borderRadius: '38% 38% 48% 48%',
  },
  {
    id: 'l_hand',
    top: 57,
    left: 68,
    width: 14,
    height: 11,
    borderRadius: '38% 38% 48% 48%',
  },
  {
    id: 'r_leg',
    top: 69,
    left: 35,
    width: 13,
    height: 22,
    clipPath: 'polygon(0 0, 100% 0, 82% 100%, 8% 100%)',
  },
  {
    id: 'l_leg',
    top: 69,
    left: 52,
    width: 13,
    height: 22,
    clipPath: 'polygon(0 0, 100% 0, 92% 100%, 18% 100%)',
  },
  {
    id: 'r_foot',
    top: 92,
    left: 31,
    width: 17,
    height: 7,
    clipPath: 'polygon(22% 0, 100% 0, 100% 74%, 0 100%)',
  },
  {
    id: 'l_foot',
    top: 92,
    left: 52,
    width: 17,
    height: 7,
    clipPath: 'polygon(0 0, 78% 0, 100% 100%, 0 74%)',
  },
];

type SurgeryBodyMapProps = {
  hasPatient: boolean;
  scanOnline: boolean;
  selectedZone: string;
  zones: SurgeryZone[];
  onSelectZone: (zone: string) => void;
  lockedZone?: string | null;
  roboticOnly?: boolean;
  availableZones?: string[] | null;
};

const SurgeryBodyMap = (props: SurgeryBodyMapProps) => {
  const {
    hasPatient,
    availableZones,
    lockedZone,
    onSelectZone,
    roboticOnly,
    scanOnline,
    selectedZone,
    zones,
  } = props;

  return (
    <Box className="SurgeryPlanner__body-map">
      {dollZones.map((dollZone) => {
        const zoneData = zones.find((zone) => zone.id === dollZone.id);
        const isSelected = selectedZone === dollZone.id;
        const isMissing = Boolean(zoneData?.known && !zoneData?.present);
        const zoneLabel = zoneData?.label || dollZone.id;
        const scanDescription = zoneData?.scan_severity
          ? `; ${getScanSeverityLabel(zoneData.scan_severity)} findings: ${zoneData.scan_findings.join(', ')}`
          : '';
        const zoneClassName = [
          'SurgeryPlanner__zone',
          isMissing
            ? 'SurgeryPlanner__zone--missing'
            : zoneData?.robotic
              ? 'SurgeryPlanner__zone--robotic'
              : zoneData?.prosthetic_internal
                ? 'SurgeryPlanner__zone--hybrid'
              : 'SurgeryPlanner__zone--organic',
          isSelected && 'SurgeryPlanner__zone--selected',
        ]
          .filter(Boolean)
          .join(' ');

        return (
          <Box key={dollZone.id}>
            <button
              type="button"
              className={zoneClassName}
              title={zoneLabel}
              aria-label={`${zoneLabel}${scanDescription}`}
              aria-pressed={isSelected}
              disabled={
                !hasPatient ||
                Boolean(lockedZone && lockedZone !== dollZone.id) ||
                Boolean(roboticOnly && !zoneData?.robotic) ||
                Boolean(availableZones && !availableZones.includes(dollZone.id))
              }
              onClick={() => onSelectZone(dollZone.id)}
              style={{
                top: `${dollZone.top}%`,
                left: `${dollZone.left}%`,
                width: `${dollZone.width}%`,
                height: `${dollZone.height}%`,
                zIndex: dollZone.zIndex || 1,
                borderRadius: dollZone.borderRadius || '4px',
                clipPath: dollZone.clipPath,
              }}
            />

            {!!zoneData?.scan_severity && scanOnline && (
              <div
                className="SurgeryPlanner__scan-marker"
                title={zoneData.scan_findings.join('\n')}
                style={{
                  top: `${dollZone.top + dollZone.height / 2}%`,
                  left: `${dollZone.left + dollZone.width / 2}%`,
                  background: getScanSeverityColor(zoneData.scan_severity),
                }}
              >
                {getScanSeveritySymbol(zoneData.scan_severity)}
              </div>
            )}
          </Box>
        );
      })}
    </Box>
  );
};

type SurgeryPlannerProps = {
  contentOnly?: boolean;
  plannerOnly?: boolean;
  syntheticMode?: boolean;
};

export const SurgeryPlanner = (props: SurgeryPlannerProps) => {
  const { act, data } = useBackend<SurgeryPlannerData>();
  const [tab, setTab] = useLocalState<'monitor' | 'planner'>(
    'surgeryPlannerTab',
    'monitor',
  );

  const selectedZone = data.zones.find(
    (zone) => zone.id === data.selected_zone,
  );

  const procedures = [...data.procedures].sort((a, b) => {
    const categoryOrder = a.category.localeCompare(b.category);
    return categoryOrder || a.name.localeCompare(b.name);
  });

  const content = (
    <>
      {!props.plannerOnly && (
        <Tabs fluid>
          <Tabs.Tab
            icon="heart-pulse"
            selected={tab === 'monitor'}
            onClick={() => setTab('monitor')}
          >
            Patient Monitoring
          </Tabs.Tab>
          <Tabs.Tab
            icon="book-medical"
            selected={tab === 'planner'}
            onClick={() => setTab('planner')}
          >
            Surgery Planning
          </Tabs.Tab>
        </Tabs>
      )}
      {data.patient_is_ipc && !props.plannerOnly ? (
        <BlockQuote>
          Synthetic patients require a cabled Robotics Interface for
          diagnostics and repair planning.
        </BlockQuote>
      ) : !props.plannerOnly && tab === 'monitor' ? (
        data.invalid ? (
          <ScannerInvalidWindow />
        ) : (
          <ScannerWindow />
        )
      ) : (
        <>
          <MedicalSummary
            name={data.patient_name}
            subtitle={`${data.patient_species || 'Patient'} · Selected: ${data.selected_zone_name}`}
            metrics={
              props.syntheticMode && data.patient_is_ipc
                ? [
                    {
                      label: 'Diagnostic Unit',
                      value:
                        data.integrity === undefined
                          ? 'Not installed'
                          : standardizeSeverityLabel(
                              getStandardSeverity(data.integrity, 100, false),
                            ),
                      severity:
                        data.integrity === undefined
                          ? 'critical'
                          : getStandardSeverity(data.integrity, 100, false),
                    },
                    {
                      label: 'Frame Temperature',
                      value:
                        data.temp === undefined ? 'Unknown' : `${data.temp}°C`,
                    },
                    {
                      label: 'Battery',
                      value:
                        data.charge_percent === undefined
                          ? 'Not installed'
                          : `${data.charge_percent}%`,
                      severity:
                        data.charge_percent === undefined ||
                        data.power_core_integrity === undefined
                          ? 'critical'
                          : getStandardSeverity(
                              data.power_core_integrity,
                              100,
                              false,
                            ),
                    },
                    {
                      label: 'Plating',
                      value: data.armor_data?.length
                        ? `${data.armor_data.length} fault${data.armor_data.length === 1 ? '' : 's'}`
                        : 'Nominal',
                      severity: data.armor_data?.length ? 'moderate' : 'nominal',
                    },
                    {
                      label: 'Endoskeleton',
                      value:
                        data.endoskeleton_damage === undefined ||
                        data.endoskeleton_max_damage === undefined
                          ? 'Not installed'
                          : standardizeSeverityLabel(
                              getStandardSeverity(
                                data.endoskeleton_damage,
                                data.endoskeleton_max_damage,
                              ),
                            ),
                      severity:
                        data.endoskeleton_damage === undefined ||
                        data.endoskeleton_max_damage === undefined
                          ? 'critical'
                          : getStandardSeverity(
                              data.endoskeleton_damage,
                              data.endoskeleton_max_damage,
                            ),
                    },
                  ]
                : props.syntheticMode
                  ? [
                      {
                        label: 'Connection',
                        value: data.has_patient ? 'Online' : 'Offline',
                        severity: data.has_patient ? 'nominal' : 'critical',
                      },
                      {
                        label: 'Mechatronic Components',
                        value: data.selected_prosthetic_organs?.length || 0,
                      },
                    ]
                  : [
                      {
                        label: 'Brain Activity',
                        value:
                          data.brain_activity < 0
                            ? 'Non-standard'
                            : `${data.brain_activity}%`,
                        severity:
                          data.brain_activity < 0
                            ? 'moderate'
                            : getStandardSeverity(100 - data.brain_activity),
                      },
                      { label: 'Pulse', value: `${data.pulse} BPM` },
                      {
                        label: 'Blood Oxygenation',
                        value: `${Math.round(data.blood_o2)}%`,
                        severity: getStandardSeverity(100 - data.blood_o2),
                      },
                      {
                        label: 'Blood Volume',
                        value: `${Math.round(data.blood_volume)}%`,
                        severity: getStandardSeverity(100 - data.blood_volume),
                      },
                    ]
            }
          />

          {!data.has_table ? (
            <BlockQuote color="red">
              No operating table is linked to this monitoring console.
            </BlockQuote>
          ) : !data.has_patient ? (
            <BlockQuote>No patient detected on the linked operating table.</BlockQuote>
          ) : null}

          {!props.syntheticMode && (
            <Box
              className={`MedicalBanner MedicalBanner--${
                !data.scan_primer_loaded ||
                (data.has_patient && !data.scan_primer_matches)
                  ? 'critical'
                  : data.has_patient
                    ? 'nominal'
                    : 'moderate'
              }`}
              mb={1}
              p={1}
            >
              <Box bold>
                {!data.scan_primer_loaded
                  ? 'No body-scan primer loaded'
                  : !data.has_patient
                    ? 'Primer loaded — awaiting patient'
                    : data.scan_primer_matches
                      ? 'Primer verified — diagnostics online'
                      : 'Primer does not match patient'}
              </Box>
              {!!data.scan_primer_loaded && (
                <Box color="label">
                  {data.scan_primer_subject || 'Unknown subject'} ·{' '}
                  {data.scan_primer_time || 'Unknown scan time'}
                </Box>
              )}
            </Box>
          )}

        <Flex align="stretch">
          <Flex.Item width="300px" mr={1}>
            <Section
              title="Target Area"
              fill
              buttons={
                !props.syntheticMode && (
                  <Button
                    icon="eject"
                    content="Eject Primer"
                    disabled={!data.scan_primer_loaded}
                    onClick={() => act('eject_primer')}
                  />
                )
              }
            >
              <SurgeryBodyMap
                hasPatient={Boolean(data.has_patient)}
                scanOnline={Boolean(data.scan_primer_matches)}
                selectedZone={data.selected_zone}
                zones={data.zones}
                onSelectZone={(zone) => act('select_zone', { zone })}
                lockedZone={data.planner_locked_zone}
                roboticOnly={Boolean(data.planner_robotic_only)}
                availableZones={data.planner_available_zones}
              />

              <Box mt={1} textAlign="center">
                {!props.syntheticMode && <>Organic · </>}
                <Box as="span" color="blue">Robotic</Box>
                {props.syntheticMode ? (
                  <>
                    {' · '}
                    <Box as="span" className="SurgeryPlanner__hybrid-label">
                      Augmented
                    </Box>
                  </>
                ) : null}
                {' · '}
                <Box as="span" style={{ color: '#777d82' }}>
                  {props.syntheticMode ? 'Non-prosthetic' : 'Missing'}
                </Box>
              </Box>
            </Section>
          </Flex.Item>

          <Flex.Item grow={1}>
            <Section
              title={`Selected Region — ${data.selected_zone_name}`}
              style={{
                borderLeft: `4px solid ${
                  selectedZone?.scan_severity
                    ? getScanSeverityColor(selectedZone.scan_severity)
                    : '#55b86b'
                }`,
              }}
            >
              {!data.has_patient ? (
                <BlockQuote>No patient data available.</BlockQuote>
              ) : (
                <Flex>
                  <Flex.Item width="250px" mr={2}>
                    <LabeledList>
                      <LabeledList.Item label="Tissue">
                        {data.area_state}
                      </LabeledList.Item>
                      <LabeledList.Item label="Surgical State">
                        {data.area_open_state}
                      </LabeledList.Item>
                      <LabeledList.Item label="Diagnostics">
                        {props.syntheticMode
                          ? data.scan_primer_matches
                            ? 'Cabled diagnostics online'
                            : 'Diagnostics unavailable'
                          : !data.scan_primer_loaded
                          ? 'No body scan inserted'
                          : data.scan_primer_matches
                            ? 'Online'
                            : 'Primer mismatch'}
                      </LabeledList.Item>
                    </LabeledList>
                  </Flex.Item>

                  <Flex.Item grow={1}>
                    {!!data.selected_prosthetic_organs?.length && (
                      <Box mb={1}>
                        <Box bold>Installed Mechatronic Components</Box>
                        <Box color="label">
                          {data.selected_prosthetic_organs.join(', ')}
                        </Box>
                      </Box>
                    )}
                    <Box bold mb={0.5}>
                      Diagnostic Findings
                    </Box>

                    {data.selected_zone_robotic && !props.syntheticMode ? (
                      <Box color="label">
                        Prosthetic diagnostics and repair planning require a
                        cabled Robotics Interface connection to this assembly.
                      </Box>
                    ) : !data.scan_primer_matches ? (
                      <Box color="label">
                        {props.syntheticMode
                          ? 'Connect a compatible synthetic interface to display findings.'
                          : 'Insert a matching body-scan primer to display injuries and internal findings.'}
                      </Box>
                    ) : !selectedZone?.scan_findings.length ? (
                      <Box style={{ color: '#8bd49c' }}>
                        No abnormalities detected in this region.
                      </Box>
                    ) : (
                      selectedZone.scan_findings.map((finding, index) => (
                        <Box key={`${finding}-${index}`} mb={0.25}>
                          • {finding}
                        </Box>
                      ))
                    )}
                  </Flex.Item>
                </Flex>
              )}
            </Section>

            <Section
              title={`Applicable Procedures — ${data.selected_zone_name}`}
              buttons={
                <Button
                  icon="circle-question"
                  tooltip="Estimated success chance: green 90–100, yellow 70–89, orange 40–69, red below 40. Estimates include your current skills and patient-specific modifiers, and assume a nominal-condition tool with the listed quality. Tool condition and resources are checked when surgery begins."
                />
              }
            >
              {!data.has_patient ? (
                <BlockQuote>
                  Place a patient on the linked operating table to populate the
                  surgical reference.
                </BlockQuote>
              ) : data.selected_zone_robotic && !props.syntheticMode ? (
                <BlockQuote>
                  Connect Robotics Interface directly to this prosthetic to
                  view its repair procedures.
                </BlockQuote>
              ) : !data.scan_primer_matches ? (
                <BlockQuote>
                  {props.syntheticMode
                    ? 'Connect a compatible synthetic interface to evaluate procedure applicability.'
                    : 'Insert a matching body-scan primer to evaluate procedure applicability.'}
                </BlockQuote>
              ) : procedures.length === 0 ? (
                <BlockQuote>
                  No procedures currently match the patient state in this area.
                </BlockQuote>
              ) : (
                <Box>
                  {procedures.map((procedure) => {
                    const bestSuccessChance = Math.max(
                      0,
                      ...procedure.tools.map((tool) => tool.success_chance),
                    );
                    const cardPalette =
                      getSuitabilityPalette(bestSuccessChance);

                    return (
                      <Box
                        key={procedure.id}
                        mb={1}
                        p={1.25}
                        style={{
                          border: `1px solid ${cardPalette.border}`,
                          borderLeft: `4px solid ${cardPalette.border}`,
                          borderRadius: '3px',
                          background: cardPalette.background,
                        }}
                      >
                        <Flex align="center">
                          <Flex.Item grow={1}>
                            <Box bold fontSize={1.15}>
                              {procedure.name}
                            </Box>
                            <Box color="label" mt={0.2}>
                              {procedure.category} · Skill:{' '}
                              {procedure.skills.join(' / ')} ·{' '}
                              {procedure.estimated_time}s estimated time
                            </Box>
                          </Flex.Item>
                        </Flex>

                        <Box mt={1}>
                          {procedure.tools.map((tool, index) => {
                            const palette = getSuitabilityPalette(
                              tool.success_chance,
                            );

                            return (
                              <Box
                                key={`${procedure.id}-${tool.path}-${tool.name}-${index}`}
                                mr={0.5}
                                mb={0.5}
                                px={0.75}
                                py={0.5}
                                style={{
                                  display: 'inline-block',
                                  border: `1px solid ${palette.border}`,
                                  borderRadius: '3px',
                                  background: palette.background,
                                  color: palette.text,
                                }}
                              >
                                <Box as="span" bold>
                                  {getToolDisplayName(tool)}
                                </Box>
                                {' · '}
                                {tool.success_chance}% success
                              </Box>
                            );
                          })}
                        </Box>
                        <Box mt={0.25} color="label">
                          {procedure.tool_note}
                        </Box>
                      </Box>
                    );
                  })}
                </Box>
              )}

            </Section>
          </Flex.Item>
        </Flex>
        </>
      )}
    </>
  );

  if (props.contentOnly) {
    return content;
  }

  return (
    <Window theme="zenghu">
      <Window.Content scrollable>{content}</Window.Content>
    </Window>
  );
};

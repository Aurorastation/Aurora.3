import {
  Box,
  Button,
  Collapsible,
  Divider,
  Section,
  Table,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { capitalize } from 'tgui-core/string';
import { useBackend, useLocalState } from '../backend';
import {
  getStandardSeverity,
  MedicalSummary,
  type MedicalSeverity,
} from './common/MedicalSummary';

export type DiagnosticsData = {
  broken: BooleanLike;
  integrity?: number;
  machine_ui_theme: string;
  patient_name: string;
  diagnostic_mode?: 'ipc' | 'prosthetic' | null;
  standalone_prosthetic?: BooleanLike;
  connected_zone_name?: string;
  temp?: number;
  robolimb_self_repair_cap?: number;
  charge_percent?: number;
  power_core_integrity?: number;
  has_power_core?: BooleanLike;
  has_endoskeleton?: BooleanLike;
  has_armor?: BooleanLike;
  organs: Organ[];
  limbs: Limb[];
  armor_data: ArmorDamage[];
  missing_organs?: string[];
  endoskeleton_damage?: number;
  endoskeleton_max_damage?: number;
};

type ArmorDamage = { key: string; status: string };

type Organ = {
  name: string;
  location?: string;
  desc: string;
  damage: number;
  max_damage: number;
  wiring_status?: number;
  plating_status?: number;
  electronics_status?: number;
  diagnostics_info?: string;
};

type Limb = {
  name: string;
  brute_damage: number;
  burn_damage: number;
  max_damage: number;
  foreign_bodies?: string[];
};

const isOrganFaulted = (organ: Organ) =>
  organ.damage > 0 ||
  (organ.wiring_status !== undefined && organ.wiring_status < 100) ||
  (organ.plating_status !== undefined && organ.plating_status < 100) ||
  (organ.electronics_status !== undefined && organ.electronics_status < 100);

const isLimbFaulted = (limb: Limb) =>
  limb.brute_damage > 0 ||
  limb.burn_damage > 0 ||
  Boolean(limb.foreign_bodies?.length);

const severityLabel = (severity: MedicalSeverity) => capitalize(severity);
const damageSeverity = (damage: number, maximum: number) =>
  getStandardSeverity(damage, maximum);
const integritySeverity = (integrity: number) =>
  getStandardSeverity(integrity, 100, false);

const armorSeverity = (status: string): MedicalSeverity => {
  switch (status.toLowerCase()) {
    case 'catastrophic':
      return 'critical';
    case 'serious':
      return 'severe';
    case 'moderate':
      return 'moderate';
    case 'minor':
      return 'minor';
    default:
      return 'nominal';
  }
};

const severityRank: Record<MedicalSeverity, number> = {
  nominal: 0,
  minor: 1,
  moderate: 2,
  severe: 3,
  critical: 4,
};

const scrollToSection = (id: string) =>
  document.getElementById(id)?.scrollIntoView({ behavior: 'smooth' });

export const IPCDiagnostics = (props) => {
  const { data } = useBackend<DiagnosticsData>();
  const [faultsOnly, setFaultsOnly] = useLocalState(
    'diagnosticsFaultsOnly',
    true,
  );
  const isProsthetic = data.diagnostic_mode === 'prosthetic';
  const organs = data.organs || [];
  const limbs = data.limbs || [];
  const armorData = data.armor_data || [];
  const missingOrgans = data.missing_organs || [];
  const armorCondition = armorData.reduce<MedicalSeverity>((worst, armor) => {
    const severity = armorSeverity(armor.status);
    return severityRank[severity] > severityRank[worst] ? severity : worst;
  }, 'nominal');
  const sortedLimbs = [...limbs].sort(
    (a, b) =>
      Number(isLimbFaulted(b)) - Number(isLimbFaulted(a)) ||
      a.name.localeCompare(b.name),
  );
  const sortedOrgans = [...organs].sort(
    (a, b) =>
      Number(isOrganFaulted(b)) - Number(isOrganFaulted(a)) ||
      (a.location || '').localeCompare(b.location || '') ||
      a.name.localeCompare(b.name),
  );
  const damagedAssemblies = sortedLimbs.filter(isLimbFaulted);
  const damagedComponents = sortedOrgans.filter(isOrganFaulted);
  const visibleLimbs = faultsOnly ? damagedAssemblies : sortedLimbs;
  const visibleOrgans = faultsOnly ? damagedComponents : sortedOrgans;
  const diagnosticFault =
    !isProsthetic && data.integrity !== undefined && data.integrity < 100;
  const endoskeletonFault =
    Boolean(data.has_endoskeleton) && (data.endoskeleton_damage ?? 0) > 0;
  const criticalSystemFaults =
    damagedAssemblies.filter(
      (limb) =>
        Math.max(limb.brute_damage, limb.burn_damage) >=
        limb.max_damage * 0.75,
    ).length +
    damagedComponents.filter(
      (organ) =>
        damageSeverity(organ.damage, organ.max_damage) === 'critical' ||
        [
          organ.wiring_status,
          organ.plating_status,
          organ.electronics_status,
        ].some((status) => status !== undefined && status <= 25),
    ).length +
    armorData.filter((armor) => armorSeverity(armor.status) === 'critical')
      .length +
    Number(diagnosticFault && (data.integrity ?? 100) <= 25) +
    missingOrgans.length +
    Number(
      endoskeletonFault &&
        (data.endoskeleton_damage ?? 0) >=
          (data.endoskeleton_max_damage ?? 1) * 0.75,
    );
  const totalFaults =
    damagedAssemblies.length +
    damagedComponents.length +
    armorData.length +
    Number(diagnosticFault) +
    missingOrgans.length +
    Number(endoskeletonFault);

  if (data.broken) {
    return (
      <Section title={`${data.patient_name}: Diagnostics Unavailable`}>
        <Box color="bad">
          The patient&apos;s diagnostics suite is missing or too damaged to
          provide a reliable reading.
        </Box>
      </Section>
    );
  }

  return (
    <>
      <MedicalSummary
        name={data.patient_name}
        subtitle={
          isProsthetic
            ? data.standalone_prosthetic
              ? `Detached assembly via ${data.connected_zone_name || 'service interface'}`
              : `Cybernetic network via ${data.connected_zone_name || 'unknown socket'}`
            : 'IPC chassis diagnostics'
        }
        metrics={[
          {
            label: 'Overall',
            value: totalFaults ? `${totalFaults} faults` : 'Nominal',
            severity: criticalSystemFaults
              ? 'critical'
              : totalFaults
                ? 'moderate'
                : 'nominal',
          },
          {
            label: 'External',
            value: `${damagedAssemblies.length} affected`,
            severity: damagedAssemblies.length ? 'moderate' : 'nominal',
            onClick: () => scrollToSection('diagnostics-assemblies'),
          },
          {
            label: 'Internal',
            value: missingOrgans.length
              ? `${damagedComponents.length} damaged · ${missingOrgans.length} missing`
              : `${damagedComponents.length} damaged`,
            severity: missingOrgans.length
              ? 'critical'
              : damagedComponents.length
                ? 'moderate'
                : 'nominal',
            onClick: () => scrollToSection('diagnostics-components'),
          },
          {
            label: 'Critical',
            value: criticalSystemFaults,
            severity: criticalSystemFaults ? 'critical' : 'nominal',
          },
          ...(!isProsthetic
            ? [
                {
                  label: 'Diagnostic Unit',
                  value:
                    data.integrity === undefined
                      ? 'Not installed'
                      : severityLabel(integritySeverity(data.integrity)),
                  severity:
                    data.integrity === undefined
                      ? ('critical' as const)
                      : integritySeverity(data.integrity),
                },
              ]
            : []),
        ]}
      />

      {!isProsthetic && (
        <Section title="Chassis Systems">
          <Table>
            <Table.Row header>
              <Table.Cell>System</Table.Cell>
              <Table.Cell>Status</Table.Cell>
              <Table.Cell>Reading</Table.Cell>
            </Table.Row>
            <Table.Row>
              <Table.Cell>Frame temperature</Table.Cell>
              <Table.Cell>
                <SeverityStatus
                  severity={data.temp === undefined ? 'moderate' : 'nominal'}
                  label={data.temp === undefined ? 'Unknown' : 'Nominal'}
                />
              </Table.Cell>
              <Table.Cell>
                {data.temp === undefined ? 'Unknown' : `${data.temp}°C`}
              </Table.Cell>
            </Table.Row>
            <Table.Row>
              <Table.Cell>Battery</Table.Cell>
              <Table.Cell>
                <SeverityStatus
                  severity={
                    data.has_power_core &&
                    data.power_core_integrity !== undefined
                      ? integritySeverity(data.power_core_integrity)
                      : 'critical'
                  }
                  label={
                    !data.has_power_core
                      ? 'Not installed'
                      : data.power_core_integrity === undefined
                        ? 'Unknown'
                        : undefined
                  }
                />
              </Table.Cell>
              <Table.Cell>
                {data.has_power_core ? `${data.charge_percent ?? 0}%` : '—'}
              </Table.Cell>
            </Table.Row>
            <Table.Row>
              <Table.Cell>Armor plating</Table.Cell>
              <Table.Cell>
                <SeverityStatus
                  severity={data.has_armor ? armorCondition : 'critical'}
                  label={data.has_armor ? undefined : 'Not installed'}
                />
              </Table.Cell>
              <Table.Cell>
                {armorData.length
                  ? armorData
                      .map(
                        (armor) =>
                          `${capitalize(armor.key)}: ${severityLabel(armorSeverity(armor.status))}`,
                      )
                      .join(', ')
                  : '—'}
              </Table.Cell>
            </Table.Row>
            <Table.Row>
              <Table.Cell>Endoskeleton</Table.Cell>
              <Table.Cell>
                <SeverityStatus
                  severity={
                    data.has_endoskeleton
                      ? damageSeverity(
                          data.endoskeleton_damage ?? 0,
                          data.endoskeleton_max_damage ?? 1,
                        )
                      : 'critical'
                  }
                  label={data.has_endoskeleton ? undefined : 'Not installed'}
                />
              </Table.Cell>
              <Table.Cell>
                {data.has_endoskeleton
                  ? endoskeletonFault
                    ? 'Damage detected'
                    : 'No damage detected'
                  : '—'}
              </Table.Cell>
            </Table.Row>
          </Table>
        </Section>
      )}

      <Box id="diagnostics-assemblies">
        <LimbDisplay
          limbs={visibleLimbs}
          faultsOnly={faultsOnly}
          setFaultsOnly={setFaultsOnly}
        />
      </Box>
      <Box id="diagnostics-components">
        {!!missingOrgans.length && (
          <Section title="Missing Components">
            {missingOrgans.map((organ) => (
              <Box key={organ} mb={0.5}>
                <SeverityStatus
                  severity="critical"
                  label={`${organ}: Missing`}
                />
              </Box>
            ))}
          </Section>
        )}
        <OrganDisplay organs={visibleOrgans} faultsOnly={faultsOnly} />
      </Box>
    </>
  );
};

export const LimbDisplay = (props: {
  limbs: Limb[];
  faultsOnly: boolean;
  setFaultsOnly: (faultsOnly: boolean) => void;
}) => (
  <Section
    title="External Assemblies"
    buttons={
      <>
        <Button
          icon="filter"
          selected={props.faultsOnly}
          content="Faults Only"
          onClick={() => props.setFaultsOnly(true)}
        />
        <Button
          icon="list"
          selected={!props.faultsOnly}
          content="All Components"
          onClick={() => props.setFaultsOnly(false)}
        />
      </>
    }
  >
    {!props.limbs.length ? (
      <Box color="good">
        {props.faultsOnly
          ? 'No external assembly faults detected.'
          : 'No external assemblies exposed by this connection.'}
      </Box>
    ) : (
      <Table>
        <Table.Row header>
          <Table.Cell>Assembly</Table.Cell>
          <Table.Cell>Impact Damage</Table.Cell>
          <Table.Cell>Thermal Damage</Table.Cell>
          <Table.Cell>Findings</Table.Cell>
        </Table.Row>
        {props.limbs.map((limb) => (
            <Table.Row key={limb.name}>
              <Table.Cell>{capitalize(limb.name)}</Table.Cell>
              <Table.Cell>
                <SeverityStatus
                  severity={damageSeverity(
                    limb.brute_damage,
                    limb.max_damage,
                  )}
                />
              </Table.Cell>
              <Table.Cell>
                <SeverityStatus
                  severity={damageSeverity(limb.burn_damage, limb.max_damage)}
                />
              </Table.Cell>
              <Table.Cell>
                {limb.foreign_bodies?.length
                  ? limb.foreign_bodies.join(', ')
                  : 'None'}
              </Table.Cell>
            </Table.Row>
          ))}
      </Table>
    )}
  </Section>
);

export const OrganDisplay = (props: {
  organs: Organ[];
  faultsOnly: boolean;
}) => (
  <Section title="Internal Components">
    {!props.organs.length ? (
      <Box color="good">
        {props.faultsOnly
          ? 'No damaged internal components.'
          : 'No internal components exposed by this connection.'}
      </Box>
    ) : (
      props.organs.map((organ, index) => (
        <Collapsible
          title={`${organ.location ? `${organ.name} — ${organ.location}` : organ.name} · ${severityLabel(damageSeverity(organ.damage, organ.max_damage))}`}
          key={`${organ.name}-${organ.location}-${index}`}
        >
          <Box italic>{organ.desc}</Box>
          <Divider />
          <SubsystemStatus
            label="Component damage"
            value={organ.damage}
            maximum={organ.max_damage}
            damage
          />
          {organ.wiring_status !== undefined && (
            <>
              <SubsystemStatus label="Wiring" value={organ.wiring_status} />
              <SubsystemStatus
                label="Plating"
                value={organ.plating_status ?? 0}
              />
              <SubsystemStatus
                label="Electronics"
                value={organ.electronics_status ?? 0}
              />
            </>
          )}
          {!!organ.diagnostics_info && (
            <Box mt={1} fontSize={0.8} italic>
              {organ.diagnostics_info}
            </Box>
          )}
        </Collapsible>
      ))
    )}
  </Section>
);

const SubsystemStatus = (props: {
  label: string;
  value: number;
  maximum?: number;
  damage?: boolean;
}) => {
  const maximum = props.maximum ?? 100;
  const severity = props.damage
    ? damageSeverity(props.value, maximum)
    : integritySeverity(props.value);
  return (
    <Box
      mb={0.5}
      className={`MedicalStatus MedicalSeverity--${severity}`}
    >
      {props.label}: {severityLabel(severity)}
    </Box>
  );
};

const SeverityStatus = (props: {
  severity: MedicalSeverity;
  label?: string;
}) => (
  <Box
    as="span"
    className={`MedicalStatus MedicalSeverity--${props.severity}`}
  >
    {props.label || severityLabel(props.severity)}
  </Box>
);

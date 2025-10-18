import { BooleanLike } from 'common/react';
import { capitalize } from 'common/string';
import { useBackend } from '../backend';
import { AnimatedNumber, Box, Collapsible, Divider, LabeledList, Section } from '../components';
import { Window } from '../layouts';

export type DiagnosticsData = {
  broken: BooleanLike;
  integrity: number;
  machine_ui_theme: string;
  patient_name: string;

  temp: number;
  robolimb_self_repair_cap: number;
  charge_percent: number;

  organs: Organ[];
  limbs: Limb[];

  armor_data: ArmorDamage[];

  endoskeleton_damage: number;
  endoskeleton_damage_maximum: number;
};

type ArmorDamage = {
  key: string;
  status: string;
};

type Organ = {
  name: string;
  desc: string;
  damage: number;
  max_damage: number;

  wiring_status: number;
  plating_status: number;
  electronics_status: number;
  diagnostics_info: string;
};

type Limb = {
  name: string;
  brute_damage: number;
  burn_damage: number;
  max_damage: number;
};

export const IPCDiagnostics = (props, context) => {
  const { act, data } = useBackend<DiagnosticsData>(context);

  return (
    <Window
      resizable
      theme={data.broken ? 'spookyconsole' : data.machine_ui_theme}>
      <Window.Content scrollable>
        {data.broken ? <Broken /> : <DiagnosticsWindow />}
      </Window.Content>
    </Window>
  );
};

export const Broken = (props, context) => {
  const { act, data } = useBackend<DiagnosticsData>(context);

  return (
    <Section title="CRITICAL ERROR 0x0127F29">
      <Box as="span" textColor="red" fontSize={3}>
        ERROR ER0RR $R0RRO$!R41.%%!!(%$^^__+ @#F0E4/ERROR ER0RR
        $R0RRO$!R41.%%!!(%$^^__+ @#F0E4/ERROR ER0RR $R0RRO$!R41.%%!!(%$^^__+
        @#F0E4/ERROR ER0RR $R0RRO$!R41.%%!!(%$^^__+ @#F0E4/
      </Box>
    </Section>
  );
};

export const DiagnosticsWindow = (props, context) => {
  const { act, data } = useBackend<DiagnosticsData>(context);

  return (
    <>
      <Section title={data.patient_name + ': Main Information'}>
        <Box>
          Diagnostics unit integrity{' '}
          <Box as="span" bold textColor={damageLabel(data.integrity)}>
            {describeIntegrity(data.integrity)}
          </Box>
          .
        </Box>
        <Box>
          Frame temperature at{' '}
          <Box as="span" bold>
            <AnimatedNumber value={data.temp} />
            °C
          </Box>
          .
        </Box>
        <Box>
          Battery charge at{' '}
          <Box as="span" bold textColor={damageLabel(data.charge_percent)}>
            {data.charge_percent}%
          </Box>
          .
        </Box>
        <Box>
          Endoskeleton status:{' '}
          <Box
            as="span"
            bold
            textColor={endoskeletonDamageLabel(
              data.endoskeleton_damage,
              data.endoskeleton_damage_maximum
            )}>
            {capitalize(
              describeEndoskeletonIntegrity(
                data.endoskeleton_damage,
                data.endoskeleton_damage_maximum
              )
            )}
          </Box>
          .
        </Box>
        {data.armor_data.length ? (
          <Box>
            <Divider />
            External armor plating condition:{' '}
            <LabeledList>
              {data.armor_data.map((armor) => (
                <LabeledList.Item label={capitalize(armor.key)} key={armor.key}>
                  <Box
                    as="span"
                    bold
                    textColor={armorDamageLabel(armor.status)}>
                    {capitalize(armor.status)}
                  </Box>
                </LabeledList.Item>
              ))}
            </LabeledList>
          </Box>
        ) : (
          'Internal armor plating nominal.'
        )}
      </Section>
      <OrganDisplay />
    </>
  );
};

export const OrganDisplay = (props, context) => {
  const { act, data } = useBackend<DiagnosticsData>(context);

  return (
    <Section title={data.patient_name + ': Internal Components'}>
      {data.organs.map((organ) => (
        <Collapsible content={organ.name} key={organ.name}>
          <Box italic>{organ.desc}</Box>
          <Divider />
          <Box>
            The {organ.name}&apos;s internal components are{' '}
            <Box
              as="span"
              bold
              textColor={organDamageLabel(organ.damage, organ.max_damage)}>
              {describeOrganDamage(organ.damage, organ.max_damage)}
            </Box>
            .
          </Box>
          {organ.wiring_status ? (
            <LabeledList>
              <LabeledList.Item label="Wiring">
                <Box
                  as="span"
                  bold
                  textColor={damageLabel(organ.wiring_status)}>
                  {capitalize(describeIntegrity(organ.wiring_status))}
                </Box>
              </LabeledList.Item>
              <LabeledList.Item label="Plating">
                <Box
                  as="span"
                  bold
                  textColor={damageLabel(organ.plating_status)}>
                  {capitalize(describeIntegrity(organ.plating_status))}
                </Box>
              </LabeledList.Item>
              <LabeledList.Item label="Electronics">
                <Box
                  as="span"
                  bold
                  textColor={damageLabel(organ.electronics_status)}>
                  {capitalize(describeIntegrity(organ.electronics_status))}
                </Box>
              </LabeledList.Item>
            </LabeledList>
          ) : (
            ''
          )}
          <>
            <Divider />
            {organ.diagnostics_info ? (
              <Box fontSize={0.8} italic>
                {organ.diagnostics_info}
              </Box>
            ) : (
              ''
            )}
          </>
        </Collapsible>
      ))}
    </Section>
  );
};

export const describeIntegrity = (integrity, max_integrity = 100) => {
  if (integrity >= max_integrity) {
    return 'undamaged';
  } else if (integrity > max_integrity * 0.75) {
    return 'fine';
  } else if (integrity > max_integrity * 0.5) {
    return 'problematic';
  } else if (integrity > max_integrity * 0.25) {
    return 'heavily compromised';
  } else if (integrity > 0) {
    return 'falling apart';
  } else if (integrity <= 0) {
    return 'destroyed';
  } else {
    return 'unknown';
  }
};

const damageLabel = (value, max_value = 100) => {
  if (value < max_value * 0.1) {
    return 'bad';
  }
  if (value < max_value * 0.2) {
    return 'bad';
  } else if (value < max_value * 0.4) {
    return 'average';
  } else if (value < max_value * 0.6) {
    return 'orange';
  } else if (value < max_value * 0.8) {
    return 'yellow';
  } else if (value < max_value) {
    return 'good';
  } else {
    return 'green';
  }
};

const armorDamageLabel = (value, max_value = 100) => {
  if (value === 'minor') {
    return 'good';
  } else if (value === 'moderate') {
    return 'average';
  } else if (value === 'serious') {
    return 'orange';
  } else if (value === 'catastrophic') {
    return 'bad';
  }
};

const describeOrganDamage = (damage, max_damage) => {
  if (damage >= max_damage) {
    return 'completely unresponsive';
  } else if (damage > max_damage * 0.75) {
    return 'severely mangled';
  } else if (damage > max_damage * 0.5) {
    return 'very damaged';
  } else if (damage > max_damage * 0.25) {
    return 'not responding properly';
  } else if (damage > 0) {
    return 'mostly responsive';
  } else if (damage <= 0) {
    return 'fully responsive';
  } else {
    return 'unknown';
  }
};

const organDamageLabel = (damage, max_damage) => {
  if (damage > max_damage * 0.9) {
    return 'bad';
  } else if (damage > max_damage * 0.75) {
    return 'average';
  } else if (damage > max_damage * 0.5) {
    return 'orange';
  } else if (damage > max_damage * 0.25) {
    return 'yellow';
  } else if (damage > 0) {
    return 'good';
  } else {
    return 'green';
  }
};

const describeEndoskeletonIntegrity = (damage, max_damage = 200) => {
  if (damage >= max_damage) {
    return 'completely destroyed';
  } else if (damage > max_damage * 0.75) {
    return 'extremely mangled';
  } else if (damage > max_damage * 0.5) {
    return 'severely damaged';
  } else if (damage > max_damage * 0.3) {
    return 'damaged';
  } else if (damage > 0) {
    return 'mostly fine';
  } else if (damage <= 0) {
    return 'fine';
  } else {
    return 'unknown';
  }
};

const endoskeletonDamageLabel = (damage, max_damage = 200) => {
  if (damage > max_damage * 0.75) {
    return 'bad';
  } else if (damage > max_damage * 0.5) {
    return 'orange';
  } else if (damage > max_damage * 0.3) {
    return 'yellow';
  } else if (damage > 0) {
    return 'good';
  } else {
    return 'green';
  }
};

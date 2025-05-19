import { BooleanLike } from 'common/react';
import { useBackend } from '../backend';
import { AnimatedNumber, Box, Collapsible, Divider, Section } from '../components';
import { Window } from '../layouts';

export type DiagnosticsData = {
  broken: BooleanLike;
  integrity: number;
  machine_ui_theme: string;

  temp: number;
  robolimb_self_repair_cap: number;
  charge_percent: number;

  organs: Organ[];
  limbs: Limb[];
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
      <Section title="Internal Information">
        <Box>
          My diagnostics unit's integrity is{' '}
          <Box as="span" bold textColor={damageLabel(data.integrity)}>
            {describeIntegrity(data.integrity)}
          </Box>
          .
        </Box>
        <Box>
          My temperature is{' '}
          <Box as="span" bold>
            <AnimatedNumber value={data.temp} />
            °C
          </Box>
          .
        </Box>
        <Box>
          My battery's charge is at{' '}
          <Box as="span" bold textColor={damageLabel(data.charge_percent)}>
            {data.charge_percent}%
          </Box>
          .
        </Box>
      </Section>
      <OrganDisplay />
    </>
  );
};

export const OrganDisplay = (props, context) => {
  const { act, data } = useBackend<DiagnosticsData>(context);

  return (
    <Section title="Internal Components">
      {data.organs.map((organ) => (
        <Collapsible open={1} content={organ.name} key={organ.name}>
          <Box italic>{organ.desc}</Box>
          <Divider />
          <Box>
            My {organ.name}'s internal components are{' '}
            <Box
              as="span"
              bold
              textColor={organDamageLabel(organ.damage, organ.max_damage)}>
              {describeOrganDamage(organ.damage, organ.max_damage)}
            </Box>
            .
          </Box>
          {organ.wiring_status ? (
            <>
              <Box>
                My {organ.name}'s wiring is{' '}
                <Box
                  as="span"
                  bold
                  textColor={damageLabel(organ.wiring_status)}>
                  {describeIntegrity(organ.wiring_status)}
                </Box>
                .
              </Box>
              <Box>
                My {organ.name}'s plating is{' '}
                <Box
                  as="span"
                  bold
                  textColor={damageLabel(organ.plating_status)}>
                  {describeIntegrity(organ.plating_status)}
                </Box>
                .
              </Box>
              <Box>
                My {organ.name}'s electronics are{' '}
                <Box
                  as="span"
                  bold
                  textColor={damageLabel(organ.electronics_status)}>
                  {describeIntegrity(organ.electronics_status)}
                </Box>
                .
              </Box>
            </>
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

const describeIntegrity = (integrity, max_integrity = 100) => {
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

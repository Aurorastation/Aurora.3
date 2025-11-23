import { BooleanLike } from 'common/react';
import { useBackend } from '../backend';
import { Box, Section } from '../components';
import { Window } from '../layouts';
import { IPCDiagnostics } from './IPCDiagnostics';

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
  endoskeleton_max_damage: number;
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

export const DiagnosticsUnit = (props, context) => {
  const { act, data } = useBackend<DiagnosticsData>(context);

  return (
    <Window
      resizable
      theme={data.broken ? 'spookyconsole' : data.machine_ui_theme}>
      <Window.Content scrollable>
        {data.broken ? <Broken /> : <IPCDiagnostics />}
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

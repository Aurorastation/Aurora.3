import { useBackend } from '../backend';
import { NoticeBox } from '../components';
import { NtosWindow } from '../layouts';
import { IPCDiagnostics } from './IPCDiagnostics';

export type DiagnosticsData = {
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

export const RoboticsComputer = (props, context) => {
  const { act, data } = useBackend<DiagnosticsData>(context);

  return (
    <NtosWindow resizable>
      <NtosWindow.Content scrollable theme={data.machine_ui_theme}>
        {!data.patient_name ? (
          <NoticeBox>You must run a diagnostic first.</NoticeBox>
        ) : (
          <IPCDiagnostics />
        )}
      </NtosWindow.Content>
    </NtosWindow>
  );
};

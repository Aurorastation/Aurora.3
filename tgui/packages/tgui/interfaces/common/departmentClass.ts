import type { CSSProperties } from 'react';

import { COLORS } from '../../constants';

type DepartmentStyle = CSSProperties & {
  '--department-color': string;
};

const departmentColorByName: Record<string, string> = {
  cargo: COLORS.department.cargo,
  operations: COLORS.department.cargo,
  command: COLORS.department.medbay,
  'command-support': COLORS.department.medbay,
  security: COLORS.department.security,
  engineering: COLORS.department.engineering,
  medical: COLORS.department.medbay,
  science: COLORS.department.science,
  service: COLORS.department.service,
  civilian: COLORS.department.other,
  centcom: COLORS.department.centcom,
  miscellaneous: COLORS.department.other,
  silicon: COLORS.department.other,
  equipment: COLORS.department.other,
  'off-ship': COLORS.department.other,
  other: COLORS.department.other,
};

const normalizeDepartment = (department: string) =>
  department
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-|-$/g, '');

export const departmentColor = (department: string) =>
  departmentColorByName[normalizeDepartment(department)] ||
  COLORS.department.other;

export const departmentClass = () => 'border-dept';

export const departmentStyle = (department: string): DepartmentStyle => ({
  '--department-color': departmentColor(department),
});

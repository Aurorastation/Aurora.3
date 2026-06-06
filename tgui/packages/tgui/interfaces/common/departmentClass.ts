export const departmentClass = (department: string) =>
  `border-dept-${department
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-|-$/g, '')}`;

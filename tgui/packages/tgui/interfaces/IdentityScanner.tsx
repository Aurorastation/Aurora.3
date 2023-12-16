import { useBackend } from '../backend';
import { Section, LabeledList, Table } from '../components';
import { Window } from '../layouts';

export type IdentityData = {
  scan_number: number;
  name: string;
  faction: string;
  species: string;
  economic_status: string;
  religion: string;
  sec_incident_count: string;
  ccia_incident_count: string;
  created_at: string;
  last_jobs: JobData[];
};

type JobData = {
  id: string;
  date: string;
  job_name: string;
  alt_title: string;
  special_role: string;
};

export const IdentityScanner = (props, context) => {
  const { act, data } = useBackend<IdentityData>(context);

  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section title="Person Data">
          <LabeledList>
            <LabeledList.Item label="Scan Number">
              {data.scan_number}
            </LabeledList.Item>
            <LabeledList.Item label="Name">{data.name}</LabeledList.Item>
            <LabeledList.Item label="Faction">{data.faction}</LabeledList.Item>
            <LabeledList.Item label="Species">{data.species}</LabeledList.Item>
            <LabeledList.Item label="Economic Status">
              {data.economic_status}
            </LabeledList.Item>
            <LabeledList.Item label="Religion">
              {data.religion}
            </LabeledList.Item>
            <LabeledList.Item label="Security Incidents">
              {data.sec_incident_count}
            </LabeledList.Item>
            <LabeledList.Item label="CCIA Incidents">
              {data.ccia_incident_count}
            </LabeledList.Item>
            <LabeledList.Item label="Crated At (Server Time)">
              {data.created_at}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Job Data">
          <Table>
            <Table.Row header>
              <Table.Cell>Date (Server Time)</Table.Cell>
              <Table.Cell>Job</Table.Cell>
              <Table.Cell>Alt. Title</Table.Cell>
              <Table.Cell>Special Role</Table.Cell>
            </Table.Row>
            {data.last_jobs.map((job) => (
              <Table.Row key={job.id}>
                <Table.Cell>{job.date}</Table.Cell>
                <Table.Cell>{job.job_name}</Table.Cell>
                <Table.Cell>{job.alt_title}</Table.Cell>
                <Table.Cell>{job.special_role}</Table.Cell>
              </Table.Row>
            ))}
          </Table>
        </Section>
      </Window.Content>
    </Window>
  );
};
